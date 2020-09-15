/**
 *Submitted for verification at Etherscan.io on 2020-06-18
*/

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @openzeppelin/contracts/math/SafeMath.sol

pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/contracts/utils/Address.sol

pragma solidity ^0.6.2;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol

pragma solidity ^0.6.0;




/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: @openzeppelin/contracts/cryptography/ECDSA.sol

pragma solidity ^0.6.0;

/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 *
 * These functions can be used to verify that a message was signed by the holder
 * of the private keys of a given address.
 */
library ECDSA {
    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature`. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        // Check the signature length
        if (signature.length != 65) {
            revert("ECDSA: invalid signature length");
        }

        // Divide the signature in r, s and v variables
        bytes32 r;
        bytes32 s;
        uint8 v;

        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solhint-disable-next-line no-inline-assembly
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            revert("ECDSA: invalid signature 's' value");
        }

        if (v != 27 && v != 28) {
            revert("ECDSA: invalid signature 'v' value");
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        require(signer != address(0), "ECDSA: invalid signature");

        return signer;
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from a `hash`. This
     * replicates the behavior of the
     * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
     * JSON-RPC method.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}

// File: contracts/RenEscrow.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;




interface IGateway {
    function mint(bytes32 _pHash, uint256 _amount, bytes32 _nHash, bytes calldata _sig) external returns (uint256);
    function burn(bytes calldata _to, uint256 _amount) external returns (uint256);
}

interface IGatewayRegistry {
    function getGatewayBySymbol(string calldata _tokenSymbol) external view returns (IGateway);
    function getTokenBySymbol(string calldata _tokenSymbol) external view returns (IERC20);
}

/**
 * @dev Escrow contract for ERC20 token based escrows
 */
contract RenEscrow {

    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using ECDSA for bytes32;

    event FundsDeposited(address indexed buyer, uint256 amount);
    event FundsRefunded();
    event FundsReleased(address indexed seller, uint256 amount);
    event DisputeResolved();
    event OwnershipTransferred(address indexed oldOwner, address newOwner);
    event MediatorChanged(address indexed oldMediator, address newMediator);

    enum Status { AWAITING_PAYMENT, PAID, REFUNDED, MEDIATED, COMPLETE }

    struct RenEscrowConfig {
        bytes id;
        IERC20 token;
        address mediator;
        address buyer;
        address seller;
        uint256 amount;
        uint256 fee;
        string symbol; // e.g. BTC, BCH, etc
        IGatewayRegistry registry;
    }

    Status public status;
    bytes32 escrowID;
    address public owner;
    RenEscrowConfig public config;
    bool public initialized = false;
    bool public funded = false;
    bool public completed = false;
    bytes32 public releaseMsgHash;
    bytes32 public refundMsgHash;
    bytes32 public resolveMsgHash;
    bytes  buyerOffChainAddr;
    bytes  sellerOffChainAddr;

    modifier onlyBuyer() {
        require(msg.sender == config.buyer, "Only the buyer can call this function.");
        _;
    }

    modifier onlyWithBuyerSignature(bytes32 hash, bytes memory signature) {
        require(
            hash.toEthSignedMessageHash()
                .recover(signature) == config.buyer,
            "Must be signed by buyer."
        );
        _;
    }

    modifier onlyWithSellerSignature(bytes32 hash, bytes memory signature) {
        require(
            hash.toEthSignedMessageHash()
                .recover(signature) == config.buyer,
            "Must be signed by buyer."
        );
        _;
    }

    modifier onlyWithParticipantSignature(bytes32 hash, bytes memory signature) {
        address signer = hash.toEthSignedMessageHash()
            .recover(signature);
        require(
            signer == config.buyer || signer == config.seller,
            "Must be signed by either buyer or seller."
        );
        _;
    }

    modifier onlySeller() {
        require(msg.sender == config.seller, "Only the seller can call this function.");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    modifier onlyMediator() {
        require(msg.sender == config.mediator, "Only the mediator can call this function.");
        _;
    }

    modifier onlyUninitialized() {
        require(initialized == false, "Escrow already initialized.");
        initialized = true;
        _;
    }

    modifier onlyUnfunded() {
        require(funded == false, "Escrow already funded.");
        funded = true;
        _;
    }

    modifier onlyFunded() {
        require(funded == true, "Escrow not funded.");
        _;
    }

    modifier onlyIncompleted() {
        require(completed == false, "Escrow already completed.");
        completed = true;
        _;
    }

    function init(
        bytes32 _escrowID,
        address _owner,
        bytes memory _buyerOffChainAddr,
        bytes memory _sellerOffChainAddr,
        RenEscrowConfig memory _cfg
    )
        public
        onlyUninitialized
    {
        status = Status.AWAITING_PAYMENT;
        escrowID = _escrowID;
        owner = _owner;
        buyerOffChainAddr = _buyerOffChainAddr;
        sellerOffChainAddr = _sellerOffChainAddr;
        config = _cfg;
        releaseMsgHash = keccak256(
            abi.encodePacked("releaseFunds()", escrowID, address(this))
        );
        refundMsgHash = keccak256(
            abi.encodePacked("refund()", escrowID, address(this))
        );
        resolveMsgHash = keccak256(
            abi.encodePacked("resolveDispute()", escrowID, address(this))
        );
        emit OwnershipTransferred(address(0), _owner);
        emit MediatorChanged(address(0), _owner);
    }

    function depositAmount() public view returns (uint256) {
        return config.amount.add(config.fee);
    }

    function deposit(
        // Parameters from users
        bytes calldata _msg,
        // Parameters from Darknodes
        uint256        _amount,
        bytes32        _nHash,
        bytes calldata _sig
    )
        external
        onlyUnfunded
    {
        bytes32 pHash = keccak256(abi.encode(_msg));
        uint256 mintedAmount = config.registry.getGatewayBySymbol(config.symbol).mint(pHash, _amount, _nHash, _sig);
        require(mintedAmount == depositAmount(), "Amount needs to be exact.");
        status = Status.PAID;
        emit FundsDeposited(msg.sender, mintedAmount);
    }

    function _releaseFees() private {
        config.token.safeTransfer(config.mediator, config.fee.mul(2));
    }

    function refund(
        bytes calldata _signature
    )
        external
        onlyFunded
        onlyIncompleted
        onlyWithSellerSignature(refundMsgHash, _signature)
    {
        uint256 releaseAmount = depositAmount().sub(config.fee.mul(2));
        config.registry.getGatewayBySymbol(config.symbol).burn(buyerOffChainAddr, releaseAmount);
        _releaseFees();
        status = Status.REFUNDED;
        emit FundsRefunded();
    }

    function releaseFunds(
        bytes calldata _signature
    )
        external
        onlyFunded
        onlyIncompleted
        onlyWithBuyerSignature(releaseMsgHash, _signature)
    {
        uint256 releaseAmount = depositAmount().sub(config.fee.mul(2));
        config.registry.getGatewayBySymbol(config.symbol).burn(sellerOffChainAddr, releaseAmount);

        _releaseFees();

        status = Status.COMPLETE;
        emit FundsReleased(config.seller, releaseAmount);
    }

    function resolveDispute(
        bytes calldata _signature,
        uint8 _buyerPercent
    )
        external
        onlyFunded
        onlyMediator
        onlyIncompleted
        onlyWithParticipantSignature(resolveMsgHash, _signature)
    {
        require(_buyerPercent <= 100, "_buyerPercent must be 100 or lower");
        uint256 releaseAmount = depositAmount().sub(config.fee.mul(2));

        status = Status.MEDIATED;
        emit DisputeResolved();

        if (_buyerPercent > 0)
            config.registry.getGatewayBySymbol(config.symbol).burn(buyerOffChainAddr, releaseAmount.mul(uint256(_buyerPercent)).div(100));
        if (_buyerPercent < 100)
            config.registry.getGatewayBySymbol(config.symbol).burn(sellerOffChainAddr, releaseAmount.mul(uint256(100).sub(_buyerPercent)).div(100));

        _releaseFees();
    }

    function setOwner(address _newOwner) external onlyOwner {
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

    function setMediator(address _newMediator) external onlyOwner {
        emit MediatorChanged(config.mediator, _newMediator);
        config.mediator = _newMediator;
    }
}