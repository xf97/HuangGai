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
 * A contract that can be stopped/restarted by its owner.
 */
abstract contract Stoppable is Ownable {

    bool public isActive = true;

    event IsActiveChanged(bool _isActive);

    modifier onlyActive() {
        require(isActive, "stp");  // "contract is stopped"
        _;
    }

    function setIsActive(bool _isActive) external onlyOwner {
        if (_isActive == isActive) return;
        isActive = _isActive;
        emit IsActiveChanged(_isActive);
    }

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

abstract contract RampInstantTokenPoolInterface is RampInstantPoolInterface {

    address public token;

}

/**
 * An interface of the RampInstantEscrows functions that are used by the liquidity pool contracts.
 * See RampInstantEscrows.sol for more comments.
 */
abstract contract RampInstantEscrowsPoolInterface {

    uint16 public ASSET_TYPE;  // solhint-disable-line var-name-mixedcase

    function release(
        address _pool,
        address payable _receiver,
        address _oracle,
        bytes calldata _assetData,
        bytes32 _paymentDetailsHash
    )
        external virtual; /*statusAtLeast(Status.FINALIZE_ONLY) onlyOracleOrPool(_pool, _oracle)*/

    function returnFunds(
        address payable _pool,
        address _receiver,
        address _oracle,
        bytes calldata _assetData,
        bytes32 _paymentDetailsHash
    )
        external virtual; /*statusAtLeast(Status.RETURN_ONLY) onlyOracleOrPool(_pool, _oracle)*/

}

/**
 * An abstract Ramp Instant Liquidity Pool. A liquidity provider deploys an instance of this
 * contract, and sends his funds to it. The escrows contract later withdraws portions of these
 * funds to be locked. The owner can withdraw any part of the funds at any time, or temporarily
 * block creating new escrows by stopping the contract.
 *
 * The pool owner can set and update min/max swap amounts, with an upper limit of 2^240 wei/units
 * (see `AssetAdapterWithFees` for more info).
 *
 * The paymentDetailsHash parameters works the same as in the `RampInstantEscrows` contract, only
 * with 0 value and empty transfer title. It describes the bank account where the pool owner expects
 * to be paid, and can be used to validate that a created swap indeed uses the same account.
 *
 * @author Ramp Network sp. z o.o.
 */
abstract contract RampInstantPool is Ownable, Stoppable, RampInstantPoolInterface {

    uint256 constant private MAX_SWAP_AMOUNT_LIMIT = 1 << 240;

    address payable public swapsContract;
    uint256 public minSwapAmount;
    uint256 public maxSwapAmount;
    bytes32 public paymentDetailsHash;

    event LimitsChanged(uint256 _minAmount, uint256 _maxAmount);
    event SwapsContractChanged(address _oldAddress, address _newAddress);

    constructor(
        address payable _swapsContract,
        uint256 _minSwapAmount,
        uint256 _maxSwapAmount,
        bytes32 _paymentDetailsHash,
        uint16 _assetType
    )
        validateLimits(_minSwapAmount, _maxSwapAmount)
        validateSwapsContract(_swapsContract, _assetType)
    {
        swapsContract = _swapsContract;
        paymentDetailsHash = _paymentDetailsHash;
        minSwapAmount = _minSwapAmount;
        maxSwapAmount = _maxSwapAmount;
        ASSET_TYPE = _assetType;
    }

    function availableFunds() public virtual view returns (uint256);

    function withdrawFunds(address payable _to, uint256 _amount)
        public virtual /*onlyOwner*/ returns (bool success);

    function withdrawAllFunds(address payable _to) public virtual onlyOwner returns (bool success) {
        return withdrawFunds(_to, availableFunds());
    }

    function setLimits(
        uint256 _minAmount,
        uint256 _maxAmount
    ) public onlyOwner validateLimits(_minAmount, _maxAmount) {
        minSwapAmount = _minAmount;
        maxSwapAmount = _maxAmount;
        emit LimitsChanged(_minAmount, _maxAmount);
    }

    function setSwapsContract(
        address payable _swapsContract
    ) public onlyOwner validateSwapsContract(_swapsContract, ASSET_TYPE) {
        address oldSwapsContract = swapsContract;
        swapsContract = _swapsContract;
        emit SwapsContractChanged(oldSwapsContract, _swapsContract);
    }

    function sendFundsToSwap(uint256 _amount)
        public virtual override /*onlyActive onlySwapsContract isWithinLimits*/
        returns(bool success);

    function releaseSwap(
        address payable _receiver,
        address _oracle,
        bytes calldata _assetData,
        bytes32 _paymentDetailsHash
    ) external onlyOwner {
        RampInstantEscrowsPoolInterface(swapsContract).release(
            payable(address(this)),
            _receiver,
            _oracle,
            _assetData,
            _paymentDetailsHash
        );
    }

    function returnSwap(
        address _receiver,
        address _oracle,
        bytes calldata _assetData,
        bytes32 _paymentDetailsHash
    ) external onlyOwner {
        RampInstantEscrowsPoolInterface(swapsContract).returnFunds(
            payable(address(this)),
            _receiver,
            _oracle,
            _assetData,
            _paymentDetailsHash
        );
    }

    modifier onlySwapsContract() {
        require(msg.sender == swapsContract, "scc");  // "only the swaps contract can call this"
        _;
    }

    modifier isWithinLimits(uint256 _amount) {
        // "amount outside limits"
        require(_amount >= minSwapAmount && _amount <= maxSwapAmount, "lim");
        _;
    }

    modifier validateLimits(uint256 _minAmount, uint256 _maxAmount) {
        require(_minAmount <= _maxAmount, "vl1");  // "min limit over max limit"
        require(_maxAmount <= MAX_SWAP_AMOUNT_LIMIT, "vl2");  // "maxAmount too high"
        _;
    }

    modifier validateSwapsContract(address payable _swapsContract, uint16 _assetType) {
        require(_swapsContract != address(0), "nsc");  // "null swaps contract address"
        require(
            RampInstantEscrowsPoolInterface(_swapsContract).ASSET_TYPE() == _assetType,
            "pat"  // "pool asset type doesn't match swap contract"
        );
        _;
    }

}

/**
 * @title partial ERC-20 Token interface according to official documentation:
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 */
interface Erc20Token {

    /**
     * Send `_value` of tokens from `msg.sender` to `_to`
     *
     * @param _to The recipient address
     * @param _value The amount of tokens to be transferred
     * @return success Indication if the transfer was successful
     */
    function transfer(address _to, uint256 _value) external returns (bool success);

    /**
     * Approve `_spender` to withdraw from sender's account multiple times, up to `_value`
     * amount. If this function is called again it overwrites the current allowance with _value.
     *
     * @param _spender The address allowed to operate on sender's tokens
     * @param _value The amount of tokens allowed to be transferred
     * @return success Indication if the approval was successful
     */
    function approve(address _spender, uint256 _value) external returns (bool success);

    /**
     * Transfer tokens on behalf of `_from`, provided it was previously approved.
     *
     * @param _from The transfer source address (tokens owner)
     * @param _to The transfer destination address
     * @param _value The amount of tokens to be transferred
     * @return success Indication if the approval was successful
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);

    /**
     * Returns the account balance of another account with address `_owner`.
     */
    function balanceOf(address _owner) external view returns (uint256);

    /// OPTIONAL in the standard
    function decimals() external pure returns (uint8);

    function allowance(address _owner, address _spender) external view returns (uint256);

}

/**
 * @dev a wrapper to call token.transfer, that allows us to be compatible with older tokens
 * that don't comply with the ERC-20 interface and don't return anything
 */
abstract contract TokenTransferrer {

    function doTokenTransfer(
        address _token,
        address _to,
        uint256 _amount
    ) internal returns (bool success) {
        // selector is bytes4(keccak256("transfer(address,uint256)"))
        bytes memory callData = abi.encodeWithSelector(bytes4(0xa9059cbb), _to, _amount);
        // overwrite callData with call results (either the revert reason or return value)
        // solhint-disable-next-line avoid-low-level-calls
        (success, callData) = _token.call(callData);
        // if call failed, revert with the same error (also works with plain revert())
        require(success, string(callData));
        // if the call succeeded, check its result data:
        // * when no data is returned, assume the token reverts on failure, so the
        //   transfer was successful
        // * otherwise check the call returned a single nonzero word
        //   (the value at callData is the offset to the first data byte, hence the add+mload)
        // solhint-disable-next-line no-inline-assembly
        assembly {
            success := or(
                iszero(returndatasize()),
                and(eq(returndatasize(), 32), gt(mload(add(callData, mload(callData))), 0))
            )
        }
        require(success, "ttf");  // "token transfer failed"
        return true;
    }

}

/**
 * A pool that implements handling of ERC-20-compatible token assets. See `RampInstantPool`.
 *
 * @author Ramp Network sp. z o.o.
 */
contract RampInstantTokenPool is RampInstantPool, TokenTransferrer {

    uint16 internal constant TOKEN_TYPE_ID = 2;
    Erc20Token public token;

    constructor(
        address payable _swapsContract,
        uint256 _minSwapAmount,
        uint256 _maxSwapAmount,
        bytes32 _paymentDetailsHash,
        address _tokenAddress
    )
        RampInstantPool(
            _swapsContract, _minSwapAmount, _maxSwapAmount, _paymentDetailsHash, TOKEN_TYPE_ID
        )
    {
        token = Erc20Token(_tokenAddress);
    }

    function availableFunds() public override view returns(uint256) {
        return token.balanceOf(address(this));
    }

    function withdrawFunds(
        address payable _to,
        uint256 _amount
    ) public override onlyOwner returns (bool success) {
        return doTokenTransfer(address(token), _to, _amount);
    }

    function sendFundsToSwap(
        uint256 _amount
    ) public override onlyActive onlySwapsContract isWithinLimits(_amount) returns(bool success) {
        return doTokenTransfer(address(token), swapsContract, _amount);
    }

}