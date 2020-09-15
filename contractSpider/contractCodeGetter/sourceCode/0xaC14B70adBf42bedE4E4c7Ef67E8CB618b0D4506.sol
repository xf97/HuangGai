/**
 *Submitted for verification at Etherscan.io on 2020-08-19
*/

/*

    Copyright 2020 dYdX Trading Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

*/

pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

// File: @openzeppelin/contracts/math/SafeMath.sol

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
     *
     * _Available since v2.4.0._
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
     *
     * _Available since v2.4.0._
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
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/protocol/v1/traders/P1TraderConstants.sol

/**
 * @title P1TraderConstants
 * @author dYdX
 *
 * @notice Constants for traderFlags set by contracts implementing the I_P1Trader interface.
 */
contract P1TraderConstants {
    bytes32 constant internal TRADER_FLAG_ORDERS = bytes32(uint256(1));
    bytes32 constant internal TRADER_FLAG_LIQUIDATION = bytes32(uint256(2));
    bytes32 constant internal TRADER_FLAG_DELEVERAGING = bytes32(uint256(4));
}

// File: contracts/protocol/lib/BaseMath.sol

/**
 * @title BaseMath
 * @author dYdX
 *
 * @dev Arithmetic for fixed-point numbers with 18 decimals of precision.
 */
library BaseMath {
    using SafeMath for uint256;

    // The number One in the BaseMath system.
    uint256 constant internal BASE = 10 ** 18;

    /**
     * @dev Getter function since constants can't be read directly from libraries.
     */
    function base()
        internal
        pure
        returns (uint256)
    {
        return BASE;
    }

    /**
     * @dev Multiplies a value by a base value (result is rounded down).
     */
    function baseMul(
        uint256 value,
        uint256 baseValue
    )
        internal
        pure
        returns (uint256)
    {
        return value.mul(baseValue).div(BASE);
    }

    /**
     * @dev Multiplies a value by a base value (result is rounded down).
     *  Intended as an alternaltive to baseMul to prevent overflow, when `value` is known
     *  to be divisible by `BASE`.
     */
    function baseDivMul(
        uint256 value,
        uint256 baseValue
    )
        internal
        pure
        returns (uint256)
    {
        return value.div(BASE).mul(baseValue);
    }

    /**
     * @dev Multiplies a value by a base value (result is rounded up).
     */
    function baseMulRoundUp(
        uint256 value,
        uint256 baseValue
    )
        internal
        pure
        returns (uint256)
    {
        if (value == 0 || baseValue == 0) {
            return 0;
        }
        return value.mul(baseValue).sub(1).div(BASE).add(1);
    }

    /**
     * @dev Divide a value by a base value (result is rounded down).
     */
    function baseDiv(
        uint256 value,
        uint256 baseValue
    )
        internal
        pure
        returns (uint256)
    {
        return value.mul(BASE).div(baseValue);
    }

    /**
     * @dev Returns a base value representing the reciprocal of another base value (result is
     *  rounded down).
     */
    function baseReciprocal(
        uint256 baseValue
    )
        internal
        pure
        returns (uint256)
    {
        return baseDiv(BASE, baseValue);
    }
}

// File: contracts/protocol/lib/TypedSignature.sol

/**
 * @title TypedSignature
 * @author dYdX
 *
 * @dev Library to unparse typed signatures.
 */
library TypedSignature {

    // ============ Constants ============

    bytes32 constant private FILE = "TypedSignature";

    // Prepended message with the length of the signed hash in decimal.
    bytes constant private PREPEND_DEC = "\x19Ethereum Signed Message:\n32";

    // Prepended message with the length of the signed hash in hexadecimal.
    bytes constant private PREPEND_HEX = "\x19Ethereum Signed Message:\n\x20";

    // Number of bytes in a typed signature.
    uint256 constant private NUM_SIGNATURE_BYTES = 66;

    // ============ Enums ============

    // Different RPC providers may implement signing methods differently, so we allow different
    // signature types depending on the string prepended to a hash before it was signed.
    enum SignatureType {
        NoPrepend,   // No string was prepended.
        Decimal,     // PREPEND_DEC was prepended.
        Hexadecimal, // PREPEND_HEX was prepended.
        Invalid      // Not a valid type. Used for bound-checking.
    }

    // ============ Structs ============

    struct Signature {
        bytes32 r;
        bytes32 s;
        bytes2 vType;
    }

    // ============ Functions ============

    /**
     * @dev Gives the address of the signer of a hash. Also allows for the commonly prepended string
     *  of '\x19Ethereum Signed Message:\n' + message.length
     *
     * @param  hash       Hash that was signed (does not include prepended message).
     * @param  signature  Type and ECDSA signature with structure: {32:r}{32:s}{1:v}{1:type}
     * @return            Address of the signer of the hash.
     */
    function recover(
        bytes32 hash,
        Signature memory signature
    )
        internal
        pure
        returns (address)
    {
        SignatureType sigType = SignatureType(uint8(bytes1(signature.vType << 8)));

        bytes32 signedHash;
        if (sigType == SignatureType.NoPrepend) {
            signedHash = hash;
        } else if (sigType == SignatureType.Decimal) {
            signedHash = keccak256(abi.encodePacked(PREPEND_DEC, hash));
        } else {
            assert(sigType == SignatureType.Hexadecimal);
            signedHash = keccak256(abi.encodePacked(PREPEND_HEX, hash));
        }

        return ecrecover(
            signedHash,
            uint8(bytes1(signature.vType)),
            signature.r,
            signature.s
        );
    }
}

// File: contracts/protocol/lib/Storage.sol

/**
 * @title Storage
 * @author dYdX
 *
 * @dev Storage library for reading/writing storage at a low level.
 */
library Storage {

    /**
     * @dev Performs an SLOAD and returns the data in the slot.
     */
    function load(
        bytes32 slot
    )
        internal
        view
        returns (bytes32)
    {
        bytes32 result;
        /* solium-disable-next-line security/no-inline-assembly */
        assembly {
            result := sload(slot)
        }
        return result;
    }

    /**
     * @dev Performs an SSTORE to save the value to the slot.
     */
    function store(
        bytes32 slot,
        bytes32 value
    )
        internal
    {
        /* solium-disable-next-line security/no-inline-assembly */
        assembly {
            sstore(slot, value)
        }
    }
}

// File: contracts/protocol/lib/Adminable.sol

/**
 * @title Adminable
 * @author dYdX
 *
 * @dev EIP-1967 Proxy Admin contract.
 */
contract Adminable {
    /**
     * @dev Storage slot with the admin of the contract.
     *  This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1.
     */
    bytes32 internal constant ADMIN_SLOT =
    0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    /**
    * @dev Modifier to check whether the `msg.sender` is the admin.
    *  If it is, it will run the function. Otherwise, it will revert.
    */
    modifier onlyAdmin() {
        require(
            msg.sender == getAdmin(),
            "Adminable: caller is not admin"
        );
        _;
    }

    /**
     * @return The EIP-1967 proxy admin
     */
    function getAdmin()
        public
        view
        returns (address)
    {
        return address(uint160(uint256(Storage.load(ADMIN_SLOT))));
    }
}

// File: contracts/protocol/lib/ReentrancyGuard.sol

/**
 * @title ReentrancyGuard
 * @author dYdX
 *
 * @dev Updated ReentrancyGuard library designed to be used with Proxy Contracts.
 */
contract ReentrancyGuard {
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = uint256(int256(-1));

    uint256 private _STATUS_;

    constructor () internal {
        _STATUS_ = NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_STATUS_ != ENTERED, "ReentrancyGuard: reentrant call");
        _STATUS_ = ENTERED;
        _;
        _STATUS_ = NOT_ENTERED;
    }
}

// File: contracts/protocol/v1/lib/P1Types.sol

/**
 * @title P1Types
 * @author dYdX
 *
 * @dev Library for common types used in PerpetualV1 contracts.
 */
library P1Types {
    // ============ Structs ============

    /**
     * @dev Used to represent the global index and each account's cached index.
     *  Used to settle funding paymennts on a per-account basis.
     */
    struct Index {
        uint32 timestamp;
        bool isPositive;
        uint128 value;
    }

    /**
     * @dev Used to track the signed margin balance and position balance values for each account.
     */
    struct Balance {
        bool marginIsPositive;
        bool positionIsPositive;
        uint120 margin;
        uint120 position;
    }

    /**
     * @dev Used to cache commonly-used variables that are relatively gas-intensive to obtain.
     */
    struct Context {
        uint256 price;
        uint256 minCollateral;
        Index index;
    }

    /**
     * @dev Used by contracts implementing the I_P1Trader interface to return the result of a trade.
     */
    struct TradeResult {
        uint256 marginAmount;
        uint256 positionAmount;
        bool isBuy; // From taker's perspective.
        bytes32 traderFlags;
    }
}

// File: contracts/protocol/v1/impl/P1Storage.sol

/**
 * @title P1Storage
 * @author dYdX
 *
 * @notice Storage contract. Contains or inherits from all contracts that have ordered storage.
 */
contract P1Storage is
    Adminable,
    ReentrancyGuard
{
    mapping(address => P1Types.Balance) internal _BALANCES_;
    mapping(address => P1Types.Index) internal _LOCAL_INDEXES_;

    mapping(address => bool) internal _GLOBAL_OPERATORS_;
    mapping(address => mapping(address => bool)) internal _LOCAL_OPERATORS_;

    address internal _TOKEN_;
    address internal _ORACLE_;
    address internal _FUNDER_;

    P1Types.Index internal _GLOBAL_INDEX_;
    uint256 internal _MIN_COLLATERAL_;

    bool internal _FINAL_SETTLEMENT_ENABLED_;
    uint256 internal _FINAL_SETTLEMENT_PRICE_;
}

// File: contracts/protocol/v1/intf/I_P1Oracle.sol

/**
 * @title I_P1Oracle
 * @author dYdX
 *
 * @notice Interface that PerpetualV1 Price Oracles must implement.
 */
interface I_P1Oracle {

    /**
     * @notice Returns the price of the underlying asset relative to the margin token.
     *
     * @return The price as a fixed-point number with 18 decimals.
     */
    function getPrice()
        external
        view
        returns (uint256);
}

// File: contracts/protocol/v1/impl/P1Getters.sol

/**
 * @title P1Getters
 * @author dYdX
 *
 * @notice Contract for read-only getters.
 */
contract P1Getters is
    P1Storage
{
    // ============ Account Getters ============

    /**
     * @notice Get the balance of an account, without accounting for changes in the index.
     *
     * @param  account  The address of the account to query the balances of.
     * @return          The balances of the account.
     */
    function getAccountBalance(
        address account
    )
        external
        view
        returns (P1Types.Balance memory)
    {
        return _BALANCES_[account];
    }

    /**
     * @notice Gets the most recently cached index of an account.
     *
     * @param  account  The address of the account to query the index of.
     * @return          The index of the account.
     */
    function getAccountIndex(
        address account
    )
        external
        view
        returns (P1Types.Index memory)
    {
        return _LOCAL_INDEXES_[account];
    }

    /**
     * @notice Gets the local operator status of an operator for a particular account.
     *
     * @param  account   The account to query the operator for.
     * @param  operator  The address of the operator to query the status of.
     * @return           True if the operator is a local operator of the account, false otherwise.
     */
    function getIsLocalOperator(
        address account,
        address operator
    )
        external
        view
        returns (bool)
    {
        return _LOCAL_OPERATORS_[account][operator];
    }

    // ============ Global Getters ============

    /**
     * @notice Gets the global operator status of an address.
     *
     * @param  operator  The address of the operator to query the status of.
     * @return           True if the address is a global operator, false otherwise.
     */
    function getIsGlobalOperator(
        address operator
    )
        external
        view
        returns (bool)
    {
        return _GLOBAL_OPERATORS_[operator];
    }

    /**
     * @notice Gets the address of the ERC20 margin contract used for margin deposits.
     *
     * @return The address of the ERC20 token.
     */
    function getTokenContract()
        external
        view
        returns (address)
    {
        return _TOKEN_;
    }

    /**
     * @notice Gets the current address of the price oracle contract.
     *
     * @return The address of the price oracle contract.
     */
    function getOracleContract()
        external
        view
        returns (address)
    {
        return _ORACLE_;
    }

    /**
     * @notice Gets the current address of the funder contract.
     *
     * @return The address of the funder contract.
     */
    function getFunderContract()
        external
        view
        returns (address)
    {
        return _FUNDER_;
    }

    /**
     * @notice Gets the most recently cached global index.
     *
     * @return The most recently cached global index.
     */
    function getGlobalIndex()
        external
        view
        returns (P1Types.Index memory)
    {
        return _GLOBAL_INDEX_;
    }

    /**
     * @notice Gets minimum collateralization ratio of the protocol.
     *
     * @return The minimum-acceptable collateralization ratio, returned as a fixed-point number with
     *  18 decimals of precision.
     */
    function getMinCollateral()
        external
        view
        returns (uint256)
    {
        return _MIN_COLLATERAL_;
    }

    /**
     * @notice Gets the status of whether final-settlement was initiated by the Admin.
     *
     * @return True if final-settlement was enabled, false otherwise.
     */
    function getFinalSettlementEnabled()
        external
        view
        returns (bool)
    {
        return _FINAL_SETTLEMENT_ENABLED_;
    }

    // ============ Authorized External Getters ============

    /**
     * @notice Gets the price returned by the oracle.
     * @dev Only able to be called by global operators.
     *
     * @return The price returned by the current price oracle.
     */
    function getOraclePrice()
        external
        view
        returns (uint256)
    {
        require(
            _GLOBAL_OPERATORS_[msg.sender],
            "Oracle price requester not global operator"
        );
        return I_P1Oracle(_ORACLE_).getPrice();
    }

    // ============ Public Getters ============

    /**
     * @notice Gets whether an address has permissions to operate an account.
     *
     * @param  account   The account to query.
     * @param  operator  The address to query.
     * @return           True if the operator has permission to operate the account,
     *                   and false otherwise.
     */
    function hasAccountPermissions(
        address account,
        address operator
    )
        public
        view
        returns (bool)
    {
        return account == operator
            || _GLOBAL_OPERATORS_[operator]
            || _LOCAL_OPERATORS_[account][operator];
    }
}

// File: contracts/protocol/v1/traders/P1Orders.sol

/**
 * @title P1Orders
 * @author dYdX
 *
 * @notice Contract allowing trading between accounts using cryptographically signed messages.
 */
contract P1Orders is
    P1TraderConstants
{
    using BaseMath for uint256;
    using SafeMath for uint256;

    // ============ Constants ============

    // EIP191 header for EIP712 prefix
    bytes2 constant private EIP191_HEADER = 0x1901;

    // EIP712 Domain Name value
    string constant private EIP712_DOMAIN_NAME = "P1Orders";

    // EIP712 Domain Version value
    string constant private EIP712_DOMAIN_VERSION = "1.0";

    // Hash of the EIP712 Domain Separator Schema
    /* solium-disable-next-line indentation */
    bytes32 constant private EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
        "EIP712Domain(",
        "string name,",
        "string version,",
        "uint256 chainId,",
        "address verifyingContract",
        ")"
    ));

    // Hash of the EIP712 LimitOrder struct
    /* solium-disable-next-line indentation */
    bytes32 constant private EIP712_ORDER_STRUCT_SCHEMA_HASH = keccak256(abi.encodePacked(
        "Order(",
        "bytes32 flags,",
        "uint256 amount,",
        "uint256 limitPrice,",
        "uint256 triggerPrice,",
        "uint256 limitFee,",
        "address maker,",
        "address taker,",
        "uint256 expiration",
        ")"
    ));

    // Bitmasks for the flags field
    bytes32 constant FLAG_MASK_NULL = bytes32(uint256(0));
    bytes32 constant FLAG_MASK_IS_BUY = bytes32(uint256(1));
    bytes32 constant FLAG_MASK_IS_DECREASE_ONLY = bytes32(uint256(1 << 1));
    bytes32 constant FLAG_MASK_IS_NEGATIVE_LIMIT_FEE = bytes32(uint256(1 << 2));

    // ============ Enums ============

    enum OrderStatus {
        Open,
        Approved,
        Canceled
    }

    // ============ Structs ============

    struct Order {
        bytes32 flags;
        uint256 amount;
        uint256 limitPrice;
        uint256 triggerPrice;
        uint256 limitFee;
        address maker;
        address taker;
        uint256 expiration;
    }

    struct Fill {
        uint256 amount;
        uint256 price;
        uint256 fee;
        bool isNegativeFee;
    }

    struct TradeData {
        Order order;
        Fill fill;
        TypedSignature.Signature signature;
    }

    struct OrderQueryOutput {
        OrderStatus status;
        uint256 filledAmount;
    }

    // ============ Events ============

    event LogOrderCanceled(
        address indexed maker,
        bytes32 orderHash
    );

    event LogOrderApproved(
        address indexed maker,
        bytes32 orderHash
    );

    event LogOrderFilled(
        bytes32 orderHash,
        bytes32 flags,
        uint256 triggerPrice,
        Fill fill
    );

    // ============ Immutable Storage ============

    // address of the perpetual contract
    address public _PERPETUAL_V1_;

    // Hash of the EIP712 Domain Separator data
    bytes32 public _EIP712_DOMAIN_HASH_;

    // ============ Mutable Storage ============

    // order hash => filled amount (in position amount)
    mapping (bytes32 => uint256) public _FILLED_AMOUNT_;

    // order hash => status
    mapping (bytes32 => OrderStatus) public _STATUS_;

    // ============ Constructor ============

    constructor (
        address perpetualV1,
        uint256 chainId
    )
        public
    {
        _PERPETUAL_V1_ = perpetualV1;

        /* solium-disable-next-line indentation */
        _EIP712_DOMAIN_HASH_ = keccak256(abi.encode(
            EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
            keccak256(bytes(EIP712_DOMAIN_NAME)),
            keccak256(bytes(EIP712_DOMAIN_VERSION)),
            chainId,
            address(this)
        ));
    }

    // ============ External Functions ============

    /**
     * @notice Allows an account to take an order cryptographically signed by a different account.
     * @dev Emits the LogOrderFilled event.
     *
     * @param  sender  The address that called the trade() function on PerpetualV1.
     * @param  maker   The maker of the order.
     * @param  taker   The taker of the order.
     * @param  price   The current oracle price of the underlying asset.
     * @param  data    A struct of type TradeData.
     * @return         The assets to be traded and traderFlags that indicate that a trade occurred.
     */
    function trade(
        address sender,
        address maker,
        address taker,
        uint256 price,
        bytes calldata data,
        bytes32 /* traderFlags */
    )
        external
        returns (P1Types.TradeResult memory)
    {
        address perpetual = _PERPETUAL_V1_;

        require(
            msg.sender == perpetual,
            "msg.sender must be PerpetualV1"
        );

        if (taker != sender) {
            require(
                P1Getters(perpetual).hasAccountPermissions(taker, sender),
                "Sender does not have permissions for the taker"
            );
        }

        TradeData memory tradeData = abi.decode(data, (TradeData));
        bytes32 orderHash = _getOrderHash(tradeData.order);

        // validations
        _verifyOrderStateAndSignature(
            tradeData,
            orderHash
        );
        _verifyOrderRequest(
            tradeData,
            maker,
            taker,
            perpetual,
            price
        );

        // set _FILLED_AMOUNT_
        uint256 oldFilledAmount = _FILLED_AMOUNT_[orderHash];
        uint256 newFilledAmount = oldFilledAmount.add(tradeData.fill.amount);
        require(
            newFilledAmount <= tradeData.order.amount,
            "Cannot overfill order"
        );
        _FILLED_AMOUNT_[orderHash] = newFilledAmount;

        emit LogOrderFilled(
            orderHash,
            tradeData.order.flags,
            tradeData.order.triggerPrice,
            tradeData.fill
        );

        // Order fee is denoted as a percentage of execution price.
        // Convert into an amount per unit position.
        uint256 fee = tradeData.fill.fee.baseMul(tradeData.fill.price);

        // `isBuyOrder` is from the maker's perspective.
        bool isBuyOrder = _isBuy(tradeData.order);
        uint256 marginPerPosition = (isBuyOrder == tradeData.fill.isNegativeFee)
            ? tradeData.fill.price.sub(fee)
            : tradeData.fill.price.add(fee);

        return P1Types.TradeResult({
            marginAmount: tradeData.fill.amount.baseMul(marginPerPosition),
            positionAmount: tradeData.fill.amount,
            isBuy: !isBuyOrder,
            traderFlags: TRADER_FLAG_ORDERS
        });
    }

    /**
     * @notice On-chain approves an order.
     * @dev Emits the LogOrderApproved event.
     *
     * @param  order  The order that will be approved.
     */
    function approveOrder(
        Order calldata order
    )
        external
    {
        require(
            msg.sender == order.maker,
            "Order cannot be approved by non-maker"
        );
        bytes32 orderHash = _getOrderHash(order);
        require(
            _STATUS_[orderHash] != OrderStatus.Canceled,
            "Canceled order cannot be approved"
        );
        _STATUS_[orderHash] = OrderStatus.Approved;
        emit LogOrderApproved(msg.sender, orderHash);
    }

    /**
     * @notice On-chain cancels an order.
     * @dev Emits the LogOrderCanceled event.
     *
     * @param  order  The order that will be permanently canceled.
     */
    function cancelOrder(
        Order calldata order
    )
        external
    {
        require(
            msg.sender == order.maker,
            "Order cannot be canceled by non-maker"
        );
        bytes32 orderHash = _getOrderHash(order);
        _STATUS_[orderHash] = OrderStatus.Canceled;
        emit LogOrderCanceled(msg.sender, orderHash);
    }

    // ============ Getter Functions ============

    /**
     * @notice Gets the status (open/approved/canceled) and filled amount of each order in a list.
     *
     * @param  orderHashes  A list of the hashes of the orders to check.
     * @return              A list of OrderQueryOutput structs containing the status and filled
     *                      amount of each order.
     */
    function getOrdersStatus(
        bytes32[] calldata orderHashes
    )
        external
        view
        returns (OrderQueryOutput[] memory)
    {
        OrderQueryOutput[] memory result = new OrderQueryOutput[](orderHashes.length);
        for (uint256 i = 0; i < orderHashes.length; i++) {
            bytes32 orderHash = orderHashes[i];
            result[i] = OrderQueryOutput({
                status: _STATUS_[orderHash],
                filledAmount: _FILLED_AMOUNT_[orderHash]
            });
        }
        return result;
    }

    // ============ Helper Functions ============

    function _verifyOrderStateAndSignature(
        TradeData memory tradeData,
        bytes32 orderHash
    )
        private
        view
    {
        OrderStatus orderStatus = _STATUS_[orderHash];

        if (orderStatus == OrderStatus.Open) {
            require(
                tradeData.order.maker == TypedSignature.recover(orderHash, tradeData.signature),
                "Order has an invalid signature"
            );
        } else {
            require(
                orderStatus != OrderStatus.Canceled,
                "Order was already canceled"
            );
            assert(orderStatus == OrderStatus.Approved);
        }
    }

    function _verifyOrderRequest(
        TradeData memory tradeData,
        address maker,
        address taker,
        address perpetual,
        uint256 price
    )
        private
        view
    {
        require(
            tradeData.order.maker == maker,
            "Order maker does not match maker"
        );
        require(
            tradeData.order.taker == taker || tradeData.order.taker == address(0),
            "Order taker does not match taker"
        );
        require(
            tradeData.order.expiration >= block.timestamp || tradeData.order.expiration == 0,
            "Order has expired"
        );

        // `isBuyOrder` is from the maker's perspective.
        bool isBuyOrder = _isBuy(tradeData.order);
        bool validPrice = isBuyOrder
            ? tradeData.fill.price <= tradeData.order.limitPrice
            : tradeData.fill.price >= tradeData.order.limitPrice;
        require(
            validPrice,
            "Fill price is invalid"
        );

        bool validFee = _isNegativeLimitFee(tradeData.order)
            ? tradeData.fill.isNegativeFee && tradeData.fill.fee >= tradeData.order.limitFee
            : tradeData.fill.isNegativeFee || tradeData.fill.fee <= tradeData.order.limitFee;
        require(
            validFee,
            "Fill fee is invalid"
        );

        if (tradeData.order.triggerPrice != 0) {
            bool validTriggerPrice = isBuyOrder
                ? tradeData.order.triggerPrice <= price
                : tradeData.order.triggerPrice >= price;
            require(
                validTriggerPrice,
                "Trigger price has not been reached"
            );
        }

        if (_isDecreaseOnly(tradeData.order)) {
            P1Types.Balance memory balance = P1Getters(perpetual).getAccountBalance(maker);
            require(
                isBuyOrder != balance.positionIsPositive
                && tradeData.fill.amount <= balance.position,
                "Fill does not decrease position"
            );
        }
    }

    /**
     * @dev Returns the EIP712 hash of an order.
     */
    function _getOrderHash(
        Order memory order
    )
        private
        view
        returns (bytes32)
    {
        // compute the overall signed struct hash
        /* solium-disable-next-line indentation */
        bytes32 structHash = keccak256(abi.encode(
            EIP712_ORDER_STRUCT_SCHEMA_HASH,
            order
        ));

        // compute eip712 compliant hash
        /* solium-disable-next-line indentation */
        return keccak256(abi.encodePacked(
            EIP191_HEADER,
            _EIP712_DOMAIN_HASH_,
            structHash
        ));
    }

    function _isBuy(
        Order memory order
    )
        private
        pure
        returns (bool)
    {
        return (order.flags & FLAG_MASK_IS_BUY) != FLAG_MASK_NULL;
    }

    function _isDecreaseOnly(
        Order memory order
    )
        private
        pure
        returns (bool)
    {
        return (order.flags & FLAG_MASK_IS_DECREASE_ONLY) != FLAG_MASK_NULL;
    }

    function _isNegativeLimitFee(
        Order memory order
    )
        private
        pure
        returns (bool)
    {
        return (order.flags & FLAG_MASK_IS_NEGATIVE_LIMIT_FEE) != FLAG_MASK_NULL;
    }
}