/**
 *Submitted for verification at Etherscan.io on 2020-08-13
*/

pragma solidity 0.7.0;
// SPDX-License-Identifier: MIT

/**
 * Copyright © 2017-2019 Ramp Network sp. z o.o. All rights reserved (MIT License).
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 * and associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute,
 * sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
 * is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 * or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
 * BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
 * AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


/**
 * Abstract class for an asset adapter -- a class handling a binary asset description,
 * encapsulating the asset-specific transfer logic, to maintain a single interface for the main
 * escrows contract, regardless of asset type.
 * The `assetData` bytes represent a tightly packed struct, consisting of a 2-byte (uint16) asset
 * type, followed by asset-specific data. For now there are 2 asset types, ETH and ERC-20 tokens.
 * The asset type bytes must be equal to the `ASSET_TYPE` constant in each subclass.
 *
 * @dev Subclasses of this class are used as mixins to their respective main escrows contract.
 *
 * @author Ramp Network sp. z o.o.
 */
abstract contract AssetAdapter {

    uint16 public immutable ASSET_TYPE;  // solhint-disable-line var-name-mixedcase

    constructor(
        uint16 assetType
    ) {
        ASSET_TYPE = assetType;
    }

    /**
     * Ensure the described asset is sent to the given address.
     * Should revert if the transfer failed, but callers must also handle `false` being returned,
     * much like ERC-20's `transfer`.
     */
    function rawSendAsset(
        bytes memory assetData,
        uint256 _amount,
        address payable _to
    ) internal virtual returns (bool success);

    /**
     * Ensure the described asset is sent to this contract.
     * Should revert if the transfer failed, but callers must also handle `false` being returned,
     * much like ERC-20's `transfer`.
     */
    function rawLockAsset(
        uint256 amount,
        address payable _from
    ) internal returns (bool success) {
        return RampInstantPoolInterface(_from).sendFundsToSwap(amount);
    }

    function getAmount(bytes memory assetData) internal virtual pure returns (uint256);

    /**
     * Verify that the passed asset data can be handled by this adapter and given pool.
     *
     * @dev it's sufficient to use this only when creating a new swap -- all the other swap
     * functions first check if the swap hash is valid, while a swap hash with invalid
     * asset type wouldn't be created at all.
     *
     * @dev asset type is 2 bytes long, and it's at offset 32 in `assetData`'s memory (the first 32
     * bytes are the data length). We load the word at offset 2 (it ends with the asset type bytes),
     * and retrieve its last 2 bytes into a `uint16` variable.
     */
    modifier checkAssetTypeAndData(bytes memory assetData, address _pool) {
        uint16 assetType;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            assetType := and(
                mload(add(assetData, 2)),
                0xffff
            )
        }
        require(assetType == ASSET_TYPE, "iat");  // "invalid asset type"
        checkAssetData(assetData, _pool);
        _;
    }

    function checkAssetData(bytes memory assetData, address _pool) internal virtual view;

}

/**
 * A simple interface used by the escrows contract (precisely AssetAdapters) to interact
 * with the liquidity pools.
 */
abstract contract RampInstantPoolInterface {

    uint16 public ASSET_TYPE;  // solhint-disable-line var-name-mixedcase

    function sendFundsToSwap(uint256 _amount)
        public virtual /*onlyActive onlySwapsContract isWithinLimits*/ returns(bool success);

}

/**
 * A standard, simple transferrable contract ownership.
 */
abstract contract Ownable {

    address public owner;

    event OwnerChanged(address oldOwner, address newOwner);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "ooc");  // "only the owner can call this"
        _;
    }

    function changeOwner(address _newOwner) external onlyOwner {
        owner = _newOwner;
        emit OwnerChanged(msg.sender, _newOwner);
    }

}

/**
 * An extended version of the standard `Pausable` contract, with more possible statuses:
 *  * STOPPED: all swap actions cannot be executed until the status is changed,
 *  * RETURN_ONLY: the existing swaps can only be returned, no new swaps can be created;
 *  * FINALIZE_ONLY: the existing swaps can be released or returned, no new swaps can be created;
 *  * ACTIVE: all swap actions can be executed.
 *
 * @dev the status enum is strictly monotonic (i.e. all actions allowed on status X are allowed on
 * status X+1) and the default 0 is mapped to STOPPED for safety.
 */
abstract contract WithStatus is Ownable {

    enum Status {
        STOPPED,
        RETURN_ONLY,
        FINALIZE_ONLY,
        ACTIVE
    }

    event StatusChanged(Status oldStatus, Status newStatus);

    Status public status = Status.ACTIVE;

    function setStatus(Status _status) external onlyOwner {
        emit StatusChanged(status, _status);
        status = _status;
    }

    modifier statusAtLeast(Status _status) {
        require(status >= _status, "ics");  // "invalid contract status"
        _;
    }

}


/**
 * An owner-managed list of oracles, that are allowed to release or return swaps.
 * The deployer is the default only oracle.
 */
abstract contract WithOracles is Ownable {

    mapping (address => bool) internal oracles;

    constructor() {
        oracles[msg.sender] = true;
    }

    function approveOracle(address _oracle) external onlyOwner {
        oracles[_oracle] = true;
    }

    function revokeOracle(address _oracle) external onlyOwner {
        oracles[_oracle] = false;
    }

    modifier isOracle(address _oracle) {
        require(oracles[_oracle], "ioa");  // invalid oracle address"
        _;
    }

    modifier onlyOracleOrPool(address _pool, address _oracle) {
        require(
            msg.sender == _pool || (msg.sender == _oracle && oracles[msg.sender]),
            "oop"  // "only the oracle or the pool can call this"
        );
        _;
    }

}


/**
 * An owner-managed address that is allowed to create new swaps.
 */
abstract contract WithSwapsCreators is Ownable {

    mapping (address => bool) internal creators;

    constructor() {
        creators[msg.sender] = true;
    }

    function approveSwapCreator(address _creator) external onlyOwner {
        creators[_creator] = true;
    }

    function revokeSwapCreator(address _creator) external onlyOwner {
        creators[_creator] = false;
    }

    modifier onlySwapCreator() {
        require(creators[msg.sender], "osc");  // "only the swap creator can call this"
        _;
    }

}

/**
 * An extension of `AssetAdapter` that encapsulates collecting Ramp fees while locking and resolving
 * an escrow. The collected fees can be withdrawn by the contract owner.
 *
 * Fees are configured dynamically by the backend and encoded in `assetData`. The fee amount is
 * also hashed into the swapHash, so a swap is guaranteed to be released/returned with the same fee
 * it was created with.
 *
 * @author Ramp Network sp. z o.o.
 */
abstract contract AssetAdapterWithFees is Ownable, AssetAdapter {

    function accumulateFee(bytes memory assetData) internal virtual;

    function withdrawFees(
        bytes calldata assetData,
        address payable _to
    ) external virtual /*onlyOwner*/ returns (bool success);

    function getFee(bytes memory assetData) internal virtual pure returns (uint256);

    function getAmountWithFee(bytes memory assetData) internal pure returns (uint256) {
        return getAmount(assetData) + getFee(assetData);
    }

    function lockAssetWithFee(
        bytes memory assetData,
        address payable _from
    ) internal returns (bool success) {
        return rawLockAsset(getAmountWithFee(assetData), _from);
    }

    function sendAssetWithFee(
        bytes memory assetData,
        address payable _to
    ) internal returns (bool success) {
        return rawSendAsset(assetData, getAmountWithFee(assetData), _to);
    }

    function sendAssetKeepingFee(
        bytes memory assetData,
        address payable _to
    ) internal returns (bool success) {
        bool result = rawSendAsset(assetData, getAmount(assetData), _to);
        if (result) accumulateFee(assetData);
        return result;
    }

    function getAccumulatedFees(address _assetAddress) public virtual view returns (uint256);

}

/**
 * The main contract managing Ramp Swaps escrows lifecycle: create, release or return.
 * Uses an abstract AssetAdapter to carry out the transfers and handle the particular asset data.
 * With a corresponding off-chain oracle protocol allows for atomic-swap-like transfer between
 * fiat currencies and crypto assets.
 *
 * @dev an active swap is represented by a hash of its details, mapped to its escrow expiration
 * timestamp. When the swap is created, its end time is set a given amount of time in the future
 * (but within {MIN,MAX}_SWAP_LOCK_TIME_S).
 * The hashed swap details are:
 *  * address pool: the `RampInstantPool` contract that sells the crypto asset;
 *  * address receiver: the user that buys the crypto asset;
 *  * address oracle: address of the oracle that handles this particular swap;
 *  * bytes assetData: description of the crypto asset, handled by an AssetAdapter;
 *  * bytes32 paymentDetailsHash: hash of the fiat payment details: account numbers, fiat value
 *    and currency, and the transfer reference (title), that can be verified off-chain.
 *
 * @author Ramp Network sp. z o.o.
 */
abstract contract RampInstantEscrows
is Ownable, WithStatus, WithOracles, WithSwapsCreators, AssetAdapterWithFees {

    /// @dev contract version, defined in semver
    string public constant VERSION = "0.6.4";

    uint32 internal constant MIN_ACTUAL_TIMESTAMP = 1000000000;

    /// @dev lock time limits for pool's assets, after which unreleased escrows can be returned
    uint32 internal constant MIN_SWAP_LOCK_TIME_S = 24 hours;
    uint32 internal constant MAX_SWAP_LOCK_TIME_S = 30 days;

    event Created(bytes32 indexed swapHash);
    event Released(bytes32 indexed swapHash);
    event PoolReleased(bytes32 indexed swapHash);
    event Returned(bytes32 indexed swapHash);
    event PoolReturned(bytes32 indexed swapHash);

    /**
     * @dev Mapping from swap details hash to its end time (as a unix timestamp).
     * After the end time the swap can be cancelled, and the funds will be returned to the pool.
     */
    mapping (bytes32 => uint32) internal swaps;

    /**
     * Swap creation, called by the Ramp Network. Checks swap parameters and ensures the crypto
     * asset is locked on this contract.
     *
     * Emits a `Created` event with the swap hash.
     */
    function create(
        address payable _pool,
        address _receiver,
        address _oracle,
        bytes calldata _assetData,
        bytes32 _paymentDetailsHash,
        uint32 lockTimeS
    )
        external
        statusAtLeast(Status.ACTIVE)
        onlySwapCreator()
        isOracle(_oracle)
        checkAssetTypeAndData(_assetData, _pool)
        returns
        (bool success)
    {
        require(
            lockTimeS >= MIN_SWAP_LOCK_TIME_S && lockTimeS <= MAX_SWAP_LOCK_TIME_S,
            "ltl"  // "lock time outside limits"
        );
        bytes32 swapHash = getSwapHash(
            _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
        );
        requireSwapNotExists(swapHash);
        // Set up swap status before transfer, to avoid reentrancy attacks.
        // Even if a malicious token is somehow passed to this function (despite the oracle
        // signature of its details), the state of this contract is already fully updated,
        // so it will behave correctly (as it would be a separate call).
        // solhint-disable-next-line not-rely-on-time
        swaps[swapHash] = uint32(block.timestamp) + lockTimeS;
        require(
            lockAssetWithFee(_assetData, _pool),
            "elf"  // "escrow lock failed"
        );
        emit Created(swapHash);
        return true;
    }

    /**
     * Swap release, which transfers the crypto asset to the receiver and removes the swap from
     * the active swap mapping. Normally called by the swap's oracle after it confirms a matching
     * wire transfer on pool's bank account. Can be also called by the pool, for example in case
     * of a dispute, when the parties reach an agreement off-chain.
     *
     * Emits a `Released` or `PoolReleased` event with the swap's hash.
     */
    function release(
        address _pool,
        address payable _receiver,
        address _oracle,
        bytes calldata _assetData,
        bytes32 _paymentDetailsHash
    ) external statusAtLeast(Status.FINALIZE_ONLY) onlyOracleOrPool(_pool, _oracle) {
        bytes32 swapHash = getSwapHash(
            _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
        );
        requireSwapCreated(swapHash);
        // Delete the swap status before transfer, to avoid reentrancy attacks.
        swaps[swapHash] = 0;
        require(
            sendAssetKeepingFee(_assetData, _receiver),
            "arf"  // "asset release failed"
        );
        if (msg.sender == _pool) {
            emit PoolReleased(swapHash);
        } else {
            emit Released(swapHash);
        }
    }

    /**
     * Swap return, which transfers the crypto asset back to the pool and removes the swap from
     * the active swap mapping. Can be called by the pool or the swap's oracle, but only if the
     * escrow lock time expired.
     *
     * Emits a `Returned` or `PoolReturned` event with the swap's hash.
     */
    function returnFunds(
        address payable _pool,
        address _receiver,
        address _oracle,
        bytes calldata _assetData,
        bytes32 _paymentDetailsHash
    ) external statusAtLeast(Status.RETURN_ONLY) onlyOracleOrPool(_pool, _oracle) {
        bytes32 swapHash = getSwapHash(
            _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
        );
        requireSwapExpired(swapHash);
        // Delete the swap status before transfer, to avoid reentrancy attacks.
        swaps[swapHash] = 0;
        require(
            sendAssetWithFee(_assetData, _pool),
            "acf"  // "asset return failed"
        );
        if (msg.sender == _pool) {
            emit PoolReturned(swapHash);
        } else {
            emit Returned(swapHash);
        }
    }

    /**
     * Given all valid swap details, returns its status. The return can be:
     * 0: the swap details are invalid, swap doesn't exist, or was already released/returned.
     * >1: the swap was created, and the value is a timestamp indicating end of its lock time.
     */
    function getSwapStatus(
        address _pool,
        address _receiver,
        address _oracle,
        bytes calldata _assetData,
        bytes32 _paymentDetailsHash
    ) external view returns (uint32 status) {
        bytes32 swapHash = getSwapHash(
            _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
        );
        return swaps[swapHash];
    }

    /**
     * Calculates the swap hash used to reference the swap in this contract's storage.
     */
    function getSwapHash(
        address _pool,
        address _receiver,
        address _oracle,
        bytes32 assetHash,
        bytes32 _paymentDetailsHash
    ) internal pure returns (bytes32) {
        return keccak256(
            abi.encodePacked(
                _pool, _receiver, _oracle, assetHash, _paymentDetailsHash
            )
        );
    }

    function requireSwapNotExists(bytes32 swapHash) internal view {
        require(
            swaps[swapHash] == 0,
            "sae"  // "swap already exists"
        );
    }

    function requireSwapCreated(bytes32 swapHash) internal view {
        require(
            swaps[swapHash] > MIN_ACTUAL_TIMESTAMP,
            "siv"  // "swap invalid"
        );
    }

    function requireSwapExpired(bytes32 swapHash) internal view {
        require(
            // solhint-disable-next-line not-rely-on-time
            swaps[swapHash] > MIN_ACTUAL_TIMESTAMP && block.timestamp > swaps[swapHash],
            "sei"  // "swap not expired or invalid"
        );
    }

}

/**
 * An adapter for handling ether assets.
 *
 * @author Ramp Network sp. z o.o.
 */
abstract contract EthAdapter is AssetAdapterWithFees {

    uint16 internal constant ETH_TYPE_ID = 1;
    uint16 internal constant ETH_ASSET_DATA_LENGTH = 66;
    uint256 internal accumulatedFees = 0;

    constructor() AssetAdapter(ETH_TYPE_ID) {}

    /**
    * @dev extract the amount from the asset data bytes. ETH assetData bytes contents:
    * offset length type     contents
    * +00    32     uint256  data length (== 0x22 == 34 bytes)
    * +32     2     uint16   asset type  (== ETH_TYPE_ID == 1)
    * +34    32     uint256  ether amount in wei
    * +66    32     uint256  ether fee in wei
    */
    function getAmount(bytes memory assetData) internal override pure returns (uint256 amount) {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            amount := mload(add(assetData, 34))
        }
    }

    /**
     * @dev extract the fee from the asset data bytes. See getAmount for bytes contents.
     */
    function getFee(bytes memory assetData) internal override pure returns (uint256 fee) {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            fee := mload(add(assetData, 66))
        }
    }

    function rawSendAsset(
        bytes memory /*assetData*/,
        uint256 _amount,
        address payable _to
    ) internal override returns (bool success) {
        // To enable more complex purchase receiver contracts, we're using `call.value(...)` instead
        // of plain `transfer(...)`, which allows only 2300 gas to be used by the fallback function.
        // This works for transfers to plain accounts too, no need to check if it's a contract.
        // solhint-disable-next-line avoid-low-level-calls
        (bool transferSuccessful,) = _to.call{ value:_amount }("");
        require(transferSuccessful, "etf");  // "eth transfer failed"
        return true;
    }

    function accumulateFee(bytes memory assetData) internal override {
        accumulatedFees += getFee(assetData);
    }

    function withdrawFees(
        bytes calldata /*assetData*/,
        address payable _to
    ) external override onlyOwner returns (bool success) {
        uint256 fees = accumulatedFees;
        accumulatedFees = 0;
        _to.transfer(fees);
        return true;
    }

    /**
     * This adapter can receive eth payments, but no other use of the fallback function is allowed.
     * @dev this is the "receive ether" fallback function, split off from the regular fallback
     * function in Solidity 0.6
     */
    receive () external payable {}

    function checkAssetData(bytes memory assetData, address /*_pool*/) internal override pure {
        require(assetData.length == ETH_ASSET_DATA_LENGTH, "adl");  // "invalid asset data length"
    }

    function getAccumulatedFees(address /*_assetAddress*/) public override view returns (uint256) {
        return accumulatedFees;
    }

}


/**
 * Ramp Swaps contract with the ether asset adapter.
 *
 * @author Ramp Network sp. z o.o.
 */
contract RampInstantEthEscrows is RampInstantEscrows, EthAdapter {}