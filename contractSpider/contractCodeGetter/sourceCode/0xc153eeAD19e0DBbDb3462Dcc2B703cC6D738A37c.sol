/**
 *Submitted for verification at Etherscan.io on 2020-07-02
*/

// File: contracts/sol6/IERC20.sol

pragma solidity 0.6.6;


interface IERC20 {
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function approve(address _spender, uint256 _value) external returns (bool success);

    function transfer(address _to, uint256 _value) external returns (bool success);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);

    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    function balanceOf(address _owner) external view returns (uint256 balance);

    function decimals() external view returns (uint8 digits);

    function totalSupply() external view returns (uint256 supply);
}


// to support backward compatible contract name -- so function signature remains same
abstract contract ERC20 is IERC20 {

}

// File: contracts/sol6/utils/PermissionGroupsNoModifiers.sol

pragma solidity 0.6.6;


contract PermissionGroupsNoModifiers {
    address public admin;
    address public pendingAdmin;
    mapping(address => bool) internal operators;
    mapping(address => bool) internal alerters;
    address[] internal operatorsGroup;
    address[] internal alertersGroup;
    uint256 internal constant MAX_GROUP_SIZE = 50;

    event AdminClaimed(address newAdmin, address previousAdmin);
    event AlerterAdded(address newAlerter, bool isAdd);
    event OperatorAdded(address newOperator, bool isAdd);
    event TransferAdminPending(address pendingAdmin);

    constructor(address _admin) public {
        require(_admin != address(0), "admin 0");
        admin = _admin;
    }

    function getOperators() external view returns (address[] memory) {
        return operatorsGroup;
    }

    function getAlerters() external view returns (address[] memory) {
        return alertersGroup;
    }

    function addAlerter(address newAlerter) public {
        onlyAdmin();
        require(!alerters[newAlerter], "alerter exists"); // prevent duplicates.
        require(alertersGroup.length < MAX_GROUP_SIZE, "max alerters");

        emit AlerterAdded(newAlerter, true);
        alerters[newAlerter] = true;
        alertersGroup.push(newAlerter);
    }

    function addOperator(address newOperator) public {
        onlyAdmin();
        require(!operators[newOperator], "operator exists"); // prevent duplicates.
        require(operatorsGroup.length < MAX_GROUP_SIZE, "max operators");

        emit OperatorAdded(newOperator, true);
        operators[newOperator] = true;
        operatorsGroup.push(newOperator);
    }

    /// @dev Allows the pendingAdmin address to finalize the change admin process.
    function claimAdmin() public {
        require(pendingAdmin == msg.sender, "not pending");
        emit AdminClaimed(pendingAdmin, admin);
        admin = pendingAdmin;
        pendingAdmin = address(0);
    }

    function removeAlerter(address alerter) public {
        onlyAdmin();
        require(alerters[alerter], "not alerter");
        delete alerters[alerter];

        for (uint256 i = 0; i < alertersGroup.length; ++i) {
            if (alertersGroup[i] == alerter) {
                alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
                alertersGroup.pop();
                emit AlerterAdded(alerter, false);
                break;
            }
        }
    }

    function removeOperator(address operator) public {
        onlyAdmin();
        require(operators[operator], "not operator");
        delete operators[operator];

        for (uint256 i = 0; i < operatorsGroup.length; ++i) {
            if (operatorsGroup[i] == operator) {
                operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
                operatorsGroup.pop();
                emit OperatorAdded(operator, false);
                break;
            }
        }
    }

    /// @dev Allows the current admin to set the pendingAdmin address
    /// @param newAdmin The address to transfer ownership to
    function transferAdmin(address newAdmin) public {
        onlyAdmin();
        require(newAdmin != address(0), "new admin 0");
        emit TransferAdminPending(newAdmin);
        pendingAdmin = newAdmin;
    }

    /// @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
    /// @param newAdmin The address to transfer ownership to.
    function transferAdminQuickly(address newAdmin) public {
        onlyAdmin();
        require(newAdmin != address(0), "admin 0");
        emit TransferAdminPending(newAdmin);
        emit AdminClaimed(newAdmin, admin);
        admin = newAdmin;
    }

    function onlyAdmin() internal view {
        require(msg.sender == admin, "only admin");
    }

    function onlyAlerter() internal view {
        require(alerters[msg.sender], "only alerter");
    }

    function onlyOperator() internal view {
        require(operators[msg.sender], "only operator");
    }
}

// File: contracts/sol6/utils/WithdrawableNoModifiers.sol

pragma solidity 0.6.6;




contract WithdrawableNoModifiers is PermissionGroupsNoModifiers {
    constructor(address _admin) public PermissionGroupsNoModifiers(_admin) {}

    event EtherWithdraw(uint256 amount, address sendTo);
    event TokenWithdraw(IERC20 token, uint256 amount, address sendTo);

    /// @dev Withdraw Ethers
    function withdrawEther(uint256 amount, address payable sendTo) external {
        onlyAdmin();
        (bool success, ) = sendTo.call{value: amount}("");
        require(success);
        emit EtherWithdraw(amount, sendTo);
    }

    /// @dev Withdraw all IERC20 compatible tokens
    /// @param token IERC20 The address of the token contract
    function withdrawToken(
        IERC20 token,
        uint256 amount,
        address sendTo
    ) external {
        onlyAdmin();
        token.transfer(sendTo, amount);
        emit TokenWithdraw(token, amount, sendTo);
    }
}

// File: contracts/sol6/utils/Utils5.sol

pragma solidity 0.6.6;



/**
 * @title Kyber utility file
 * mostly shared constants and rate calculation helpers
 * inherited by most of kyber contracts.
 * previous utils implementations are for previous solidity versions.
 */
contract Utils5 {
    IERC20 internal constant ETH_TOKEN_ADDRESS = IERC20(
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
    );
    uint256 internal constant PRECISION = (10**18);
    uint256 internal constant MAX_QTY = (10**28); // 10B tokens
    uint256 internal constant MAX_RATE = (PRECISION * 10**7); // up to 10M tokens per eth
    uint256 internal constant MAX_DECIMALS = 18;
    uint256 internal constant ETH_DECIMALS = 18;
    uint256 constant BPS = 10000; // Basic Price Steps. 1 step = 0.01%
    uint256 internal constant MAX_ALLOWANCE = uint256(-1); // token.approve inifinite

    mapping(IERC20 => uint256) internal decimals;

    function getUpdateDecimals(IERC20 token) internal returns (uint256) {
        if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
        uint256 tokenDecimals = decimals[token];
        // moreover, very possible that old tokens have decimals 0
        // these tokens will just have higher gas fees.
        if (tokenDecimals == 0) {
            tokenDecimals = token.decimals();
            decimals[token] = tokenDecimals;
        }

        return tokenDecimals;
    }

    function setDecimals(IERC20 token) internal {
        if (decimals[token] != 0) return; //already set

        if (token == ETH_TOKEN_ADDRESS) {
            decimals[token] = ETH_DECIMALS;
        } else {
            decimals[token] = token.decimals();
        }
    }

    /// @dev get the balance of a user.
    /// @param token The token type
    /// @return The balance
    function getBalance(IERC20 token, address user) internal view returns (uint256) {
        if (token == ETH_TOKEN_ADDRESS) {
            return user.balance;
        } else {
            return token.balanceOf(user);
        }
    }

    function getDecimals(IERC20 token) internal view returns (uint256) {
        if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
        uint256 tokenDecimals = decimals[token];
        // moreover, very possible that old tokens have decimals 0
        // these tokens will just have higher gas fees.
        if (tokenDecimals == 0) return token.decimals();

        return tokenDecimals;
    }

    function calcDestAmount(
        IERC20 src,
        IERC20 dest,
        uint256 srcAmount,
        uint256 rate
    ) internal view returns (uint256) {
        return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
    }

    function calcSrcAmount(
        IERC20 src,
        IERC20 dest,
        uint256 destAmount,
        uint256 rate
    ) internal view returns (uint256) {
        return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
    }

    function calcDstQty(
        uint256 srcQty,
        uint256 srcDecimals,
        uint256 dstDecimals,
        uint256 rate
    ) internal pure returns (uint256) {
        require(srcQty <= MAX_QTY, "srcQty > MAX_QTY");
        require(rate <= MAX_RATE, "rate > MAX_RATE");

        if (dstDecimals >= srcDecimals) {
            require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
            return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
        } else {
            require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
            return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
        }
    }

    function calcSrcQty(
        uint256 dstQty,
        uint256 srcDecimals,
        uint256 dstDecimals,
        uint256 rate
    ) internal pure returns (uint256) {
        require(dstQty <= MAX_QTY, "dstQty > MAX_QTY");
        require(rate <= MAX_RATE, "rate > MAX_RATE");

        //source quantity is rounded up. to avoid dest quantity being too low.
        uint256 numerator;
        uint256 denominator;
        if (srcDecimals >= dstDecimals) {
            require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
            numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
            denominator = rate;
        } else {
            require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
            numerator = (PRECISION * dstQty);
            denominator = (rate * (10**(dstDecimals - srcDecimals)));
        }
        return (numerator + denominator - 1) / denominator; //avoid rounding down errors
    }

    function calcRateFromQty(
        uint256 srcAmount,
        uint256 destAmount,
        uint256 srcDecimals,
        uint256 dstDecimals
    ) internal pure returns (uint256) {
        require(srcAmount <= MAX_QTY, "srcAmount > MAX_QTY");
        require(destAmount <= MAX_QTY, "destAmount > MAX_QTY");

        if (dstDecimals >= srcDecimals) {
            require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
            return ((destAmount * PRECISION) / ((10**(dstDecimals - srcDecimals)) * srcAmount));
        } else {
            require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
            return ((destAmount * PRECISION * (10**(srcDecimals - dstDecimals))) / srcAmount);
        }
    }

    function minOf(uint256 x, uint256 y) internal pure returns (uint256) {
        return x > y ? y : x;
    }
}

// File: contracts/sol6/utils/zeppelin/SafeMath.sol

pragma solidity 0.6.6;

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

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}

// File: contracts/sol6/utils/zeppelin/Address.sol

pragma solidity 0.6.6;

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

// File: contracts/sol6/utils/zeppelin/SafeERC20.sol

pragma solidity 0.6.6;




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

// File: contracts/sol6/IKyberNetwork.sol

pragma solidity 0.6.6;



interface IKyberNetwork {
    event KyberTrade(
        IERC20 indexed src,
        IERC20 indexed dest,
        uint256 ethWeiValue,
        uint256 networkFeeWei,
        uint256 customPlatformFeeWei,
        bytes32[] t2eIds,
        bytes32[] e2tIds,
        uint256[] t2eSrcAmounts,
        uint256[] e2tSrcAmounts,
        uint256[] t2eRates,
        uint256[] e2tRates
    );

    function tradeWithHintAndFee(
        address payable trader,
        IERC20 src,
        uint256 srcAmount,
        IERC20 dest,
        address payable destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address payable platformWallet,
        uint256 platformFeeBps,
        bytes calldata hint
    ) external payable returns (uint256 destAmount);

    function listTokenForReserve(
        address reserve,
        IERC20 token,
        bool add
    ) external;

    function enabled() external view returns (bool);

    function getExpectedRateWithHintAndFee(
        IERC20 src,
        IERC20 dest,
        uint256 srcQty,
        uint256 platformFeeBps,
        bytes calldata hint
    )
        external
        view
        returns (
            uint256 expectedRateAfterNetworkFee,
            uint256 expectedRateAfterAllFees
        );

    function getNetworkData()
        external
        view
        returns (
            uint256 negligibleDiffBps,
            uint256 networkFeeBps,
            uint256 expiryTimestamp
        );

    function maxGasPrice() external view returns (uint256);
}

// File: contracts/sol6/IKyberNetworkProxy.sol

pragma solidity 0.6.6;



interface IKyberNetworkProxy {

    event ExecuteTrade(
        address indexed trader,
        IERC20 src,
        IERC20 dest,
        address destAddress,
        uint256 actualSrcAmount,
        uint256 actualDestAmount,
        address platformWallet,
        uint256 platformFeeBps
    );

    /// @notice backward compatible
    function tradeWithHint(
        ERC20 src,
        uint256 srcAmount,
        ERC20 dest,
        address payable destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address payable walletId,
        bytes calldata hint
    ) external payable returns (uint256);

    function tradeWithHintAndFee(
        IERC20 src,
        uint256 srcAmount,
        IERC20 dest,
        address payable destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address payable platformWallet,
        uint256 platformFeeBps,
        bytes calldata hint
    ) external payable returns (uint256 destAmount);

    function trade(
        IERC20 src,
        uint256 srcAmount,
        IERC20 dest,
        address payable destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address payable platformWallet
    ) external payable returns (uint256);

    /// @notice backward compatible
    /// @notice Rate units (10 ** 18) => destQty (twei) / srcQty (twei) * 10 ** 18
    function getExpectedRate(
        ERC20 src,
        ERC20 dest,
        uint256 srcQty
    ) external view returns (uint256 expectedRate, uint256 worstRate);

    function getExpectedRateAfterFee(
        IERC20 src,
        IERC20 dest,
        uint256 srcQty,
        uint256 platformFeeBps,
        bytes calldata hint
    ) external view returns (uint256 expectedRate);
}

// File: contracts/sol6/ISimpleKyberProxy.sol

pragma solidity 0.6.6;



/*
 * @title simple Kyber Network proxy interface
 * add convenient functions to help with kyber proxy API
 */
interface ISimpleKyberProxy {
    function swapTokenToEther(
        IERC20 token,
        uint256 srcAmount,
        uint256 minConversionRate
    ) external returns (uint256 destAmount);

    function swapEtherToToken(IERC20 token, uint256 minConversionRate)
        external
        payable
        returns (uint256 destAmount);

    function swapTokenToToken(
        IERC20 src,
        uint256 srcAmount,
        IERC20 dest,
        uint256 minConversionRate
    ) external returns (uint256 destAmount);
}

// File: contracts/sol6/IKyberReserve.sol

pragma solidity 0.6.6;



interface IKyberReserve {
    function trade(
        IERC20 srcToken,
        uint256 srcAmount,
        IERC20 destToken,
        address payable destAddress,
        uint256 conversionRate,
        bool validate
    ) external payable returns (bool);

    function getConversionRate(
        IERC20 src,
        IERC20 dest,
        uint256 srcQty,
        uint256 blockNumber
    ) external view returns (uint256);
}

// File: contracts/sol6/IKyberHint.sol

pragma solidity 0.6.6;



interface IKyberHint {
    enum TradeType {BestOfAll, MaskIn, MaskOut, Split}
    enum HintErrors {
        NoError, // Hint is valid
        NonEmptyDataError, // reserveIDs and splits must be empty for BestOfAll hint
        ReserveIdDupError, // duplicate reserveID found
        ReserveIdEmptyError, // reserveIDs array is empty for MaskIn and Split trade type
        ReserveIdSplitsError, // reserveIDs and splitBpsValues arrays do not have the same length
        ReserveIdSequenceError, // reserveID sequence in array is not in increasing order
        ReserveIdNotFound, // reserveID isn't registered or doesn't exist
        SplitsNotEmptyError, // splitBpsValues is not empty for MaskIn or MaskOut trade type
        TokenListedError, // reserveID not listed for the token
        TotalBPSError // total BPS for Split trade type is not 10000 (100%)
    }

    function buildTokenToEthHint(
        IERC20 tokenSrc,
        TradeType tokenToEthType,
        bytes32[] calldata tokenToEthReserveIds,
        uint256[] calldata tokenToEthSplits
    ) external view returns (bytes memory hint);

    function buildEthToTokenHint(
        IERC20 tokenDest,
        TradeType ethToTokenType,
        bytes32[] calldata ethToTokenReserveIds,
        uint256[] calldata ethToTokenSplits
    ) external view returns (bytes memory hint);

    function buildTokenToTokenHint(
        IERC20 tokenSrc,
        TradeType tokenToEthType,
        bytes32[] calldata tokenToEthReserveIds,
        uint256[] calldata tokenToEthSplits,
        IERC20 tokenDest,
        TradeType ethToTokenType,
        bytes32[] calldata ethToTokenReserveIds,
        uint256[] calldata ethToTokenSplits
    ) external view returns (bytes memory hint);

    function parseTokenToEthHint(IERC20 tokenSrc, bytes calldata hint)
        external
        view
        returns (
            TradeType tokenToEthType,
            bytes32[] memory tokenToEthReserveIds,
            IKyberReserve[] memory tokenToEthAddresses,
            uint256[] memory tokenToEthSplits
        );

    function parseEthToTokenHint(IERC20 tokenDest, bytes calldata hint)
        external
        view
        returns (
            TradeType ethToTokenType,
            bytes32[] memory ethToTokenReserveIds,
            IKyberReserve[] memory ethToTokenAddresses,
            uint256[] memory ethToTokenSplits
        );

    function parseTokenToTokenHint(IERC20 tokenSrc, IERC20 tokenDest, bytes calldata hint)
        external
        view
        returns (
            TradeType tokenToEthType,
            bytes32[] memory tokenToEthReserveIds,
            IKyberReserve[] memory tokenToEthAddresses,
            uint256[] memory tokenToEthSplits,
            TradeType ethToTokenType,
            bytes32[] memory ethToTokenReserveIds,
            IKyberReserve[] memory ethToTokenAddresses,
            uint256[] memory ethToTokenSplits
        );
}

// File: contracts/sol6/KyberNetworkProxy.sol

pragma solidity 0.6.6;









/**
 *   @title kyberProxy for kyberNetwork contract
 *   The contract provides the following functions:
 *   - Get rates
 *   - Trade execution
 *   - Simple T2E, E2T and T2T trade APIs
 *   - Has some checks in place to safeguard takers
 */
contract KyberNetworkProxy is
    IKyberNetworkProxy,
    ISimpleKyberProxy,
    WithdrawableNoModifiers,
    Utils5
{
    using SafeERC20 for IERC20;

    IKyberNetwork public kyberNetwork;
    IKyberHint public kyberHintHandler; // kyberHintHhandler pointer for users.

    event KyberNetworkSet(IKyberNetwork newKyberNetwork, IKyberNetwork previousKyberNetwork);
    event KyberHintHandlerSet(IKyberHint kyberHintHandler);

    constructor(address _admin) public WithdrawableNoModifiers(_admin) {
        /*empty body*/
    }

    /// @notice Backward compatible function
    /// @notice Use token address ETH_TOKEN_ADDRESS for ether
    /// @dev Trade from src to dest token and sends dest token to destAddress
    /// @param src Source token
    /// @param srcAmount Amount of src tokens in twei
    /// @param dest Destination token
    /// @param destAddress Address to send tokens to
    /// @param maxDestAmount A limit on the amount of dest tokens in twei
    /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade reverts
    /// @param platformWallet Platform wallet address for receiving fees
    /// @return Amount of actual dest tokens in twei
    function trade(
        IERC20 src,
        uint256 srcAmount,
        IERC20 dest,
        address payable destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address payable platformWallet
    ) external payable override returns (uint256) {
        bytes memory hint;

        return
            doTrade(
                src,
                srcAmount,
                dest,
                destAddress,
                maxDestAmount,
                minConversionRate,
                platformWallet,
                0,
                hint
            );
    }

    /// @notice Backward compatible function
    /// @notice Use token address ETH_TOKEN_ADDRESS for ether
    /// @dev Trade from src to dest token and sends dest token to destAddress
    /// @param src Source token
    /// @param srcAmount Amount of src tokens in twei
    /// @param dest Destination token
    /// @param destAddress Address to send tokens to
    /// @param maxDestAmount A limit on the amount of dest tokens in twei
    /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade reverts
    /// @param walletId Platform wallet address for receiving fees
    /// @param hint Advanced instructions for running the trade 
    /// @return Amount of actual dest tokens in twei
    function tradeWithHint(
        ERC20 src,
        uint256 srcAmount,
        ERC20 dest,
        address payable destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address payable walletId,
        bytes calldata hint
    ) external payable override returns (uint256) {
        return
            doTrade(
                src,
                srcAmount,
                dest,
                destAddress,
                maxDestAmount,
                minConversionRate,
                walletId,
                0,
                hint
            );
    }

    /// @notice Use token address ETH_TOKEN_ADDRESS for ether
    /// @dev Trade from src to dest token and sends dest token to destAddress
    /// @param src Source token
    /// @param srcAmount Amount of src tokens in twei
    /// @param dest Destination token
    /// @param destAddress Address to send tokens to
    /// @param maxDestAmount A limit on the amount of dest tokens in twei
    /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade reverts
    /// @param platformWallet Platform wallet address for receiving fees
    /// @param platformFeeBps Part of the trade that is allocated as fee to platform wallet. Ex: 10000 = 100%, 100 = 1%
    /// @param hint Advanced instructions for running the trade 
    /// @return destAmount Amount of actual dest tokens in twei
    function tradeWithHintAndFee(
        IERC20 src,
        uint256 srcAmount,
        IERC20 dest,
        address payable destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address payable platformWallet,
        uint256 platformFeeBps,
        bytes calldata hint
    ) external payable override returns (uint256 destAmount) {
        return
            doTrade(
                src,
                srcAmount,
                dest,
                destAddress,
                maxDestAmount,
                minConversionRate,
                platformWallet,
                platformFeeBps,
                hint
            );
    }

    /// @dev Trade from src to dest token. Sends dest tokens to msg sender
    /// @param src Source token
    /// @param srcAmount Amount of src tokens in twei
    /// @param dest Destination token
    /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade reverts
    /// @return Amount of actual dest tokens in twei
    function swapTokenToToken(
        IERC20 src,
        uint256 srcAmount,
        IERC20 dest,
        uint256 minConversionRate
    ) external override returns (uint256) {
        bytes memory hint;

        return
            doTrade(
                src,
                srcAmount,
                dest,
                msg.sender,
                MAX_QTY,
                minConversionRate,
                address(0),
                0,
                hint
            );
    }

    /// @dev Trade from eth -> token. Sends token to msg sender
    /// @param token Destination token
    /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade reverts
    /// @return Amount of actual dest tokens in twei
    function swapEtherToToken(IERC20 token, uint256 minConversionRate)
        external
        payable
        override
        returns (uint256)
    {
        bytes memory hint;

        return
            doTrade(
                ETH_TOKEN_ADDRESS,
                msg.value,
                token,
                msg.sender,
                MAX_QTY,
                minConversionRate,
                address(0),
                0,
                hint
            );
    }

    /// @dev Trade from token -> eth. Sends eth to msg sender
    /// @param token Source token
    /// @param srcAmount Amount of src tokens in twei
    /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade reverts
    /// @return Amount of actual dest tokens in twei
    function swapTokenToEther(
        IERC20 token,
        uint256 srcAmount,
        uint256 minConversionRate
    ) external override returns (uint256) {
        bytes memory hint;

        return
            doTrade(
                token,
                srcAmount,
                ETH_TOKEN_ADDRESS,
                msg.sender,
                MAX_QTY,
                minConversionRate,
                address(0),
                0,
                hint
            );
    }

    function setKyberNetwork(IKyberNetwork _kyberNetwork) external {
        onlyAdmin();
        require(_kyberNetwork != IKyberNetwork(0), "kyberNetwork 0");
        emit KyberNetworkSet(_kyberNetwork, kyberNetwork);

        kyberNetwork = _kyberNetwork;
    }

    function setHintHandler(IKyberHint _kyberHintHandler) external {
        onlyAdmin();
        require(_kyberHintHandler != IKyberHint(0), "kyberHintHandler 0");
        emit KyberHintHandlerSet(_kyberHintHandler);

        kyberHintHandler = _kyberHintHandler;
    }

    /// @notice Backward compatible function
    /// @notice Use token address ETH_TOKEN_ADDRESS for ether
    /// @dev Get expected rate for a trade from src to dest tokens, with amount srcQty (no platform fee)
    /// @param src Source token
    /// @param dest Destination token
    /// @param srcQty Amount of src tokens in twei
    /// @return expectedRate for a trade after deducting network fee. Rate = destQty (twei) / srcQty (twei) * 10 ** 18
    /// @return worstRate for a trade. Usually expectedRate * 97 / 100
    ///             Use worstRate value as trade min conversion rate at your own risk
    function getExpectedRate(
        ERC20 src,
        ERC20 dest,
        uint256 srcQty
    ) external view override returns (uint256 expectedRate, uint256 worstRate) {
        bytes memory hint;
        (expectedRate, ) = kyberNetwork.getExpectedRateWithHintAndFee(
            src,
            dest,
            srcQty,
            0,
            hint
        );
        // use simple backward compatible optoin.
        worstRate = (expectedRate * 97) / 100;
    }

    /// @notice Use token address ETH_TOKEN_ADDRESS for ether
    /// @dev Get expected rate for a trade from src to dest tokens, amount srcQty and fees
    /// @param src Source token
    /// @param dest Destination token
    /// @param srcQty Amount of src tokens in twei
    /// @param platformFeeBps Part of the trade that is allocated as fee to platform wallet. Ex: 10000 = 100%, 100 = 1%
    /// @param hint Advanced instructions for running the trade 
    /// @return expectedRate for a trade after deducting network + platform fee
    ///             Rate = destQty (twei) / srcQty (twei) * 10 ** 18
    function getExpectedRateAfterFee(
        IERC20 src,
        IERC20 dest,
        uint256 srcQty,
        uint256 platformFeeBps,
        bytes calldata hint
    ) external view override returns (uint256 expectedRate) {
        (, expectedRate) = kyberNetwork.getExpectedRateWithHintAndFee(
            src,
            dest,
            srcQty,
            platformFeeBps,
            hint
        );
    }

    function maxGasPrice() external view returns (uint256) {
        return kyberNetwork.maxGasPrice();
    }

    function enabled() external view returns (bool) {
        return kyberNetwork.enabled();
    }

    /// helper structure for function doTrade
    struct UserBalance {
        uint256 srcTok;
        uint256 destTok;
    }

    function doTrade(
        IERC20 src,
        uint256 srcAmount,
        IERC20 dest,
        address payable destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address payable platformWallet,
        uint256 platformFeeBps,
        bytes memory hint
    ) internal returns (uint256) {
        UserBalance memory balanceBefore = prepareTrade(src, dest, srcAmount, destAddress);

        uint256 reportedDestAmount = kyberNetwork.tradeWithHintAndFee{value: msg.value}(
            msg.sender,
            src,
            srcAmount,
            dest,
            destAddress,
            maxDestAmount,
            minConversionRate,
            platformWallet,
            platformFeeBps,
            hint
        );
        TradeOutcome memory tradeOutcome = calculateTradeOutcome(
            src,
            dest,
            destAddress,
            platformFeeBps,
            balanceBefore
        );

        require(
            tradeOutcome.userDeltaDestToken == reportedDestAmount,
            "kyberNetwork returned wrong amount"
        );
        require(
            tradeOutcome.userDeltaDestToken <= maxDestAmount,
            "actual dest amount exceeds maxDestAmount"
        );
        require(tradeOutcome.actualRate >= minConversionRate, "rate below minConversionRate");

        emit ExecuteTrade(
            msg.sender,
            src,
            dest,
            destAddress,
            tradeOutcome.userDeltaSrcToken,
            tradeOutcome.userDeltaDestToken,
            platformWallet,
            platformFeeBps
        );

        return tradeOutcome.userDeltaDestToken;
    }

    /// helper structure for function prepareTrade
    struct TradeOutcome {
        uint256 userDeltaSrcToken;
        uint256 userDeltaDestToken;
        uint256 actualRate;
    }

    function prepareTrade(
        IERC20 src,
        IERC20 dest,
        uint256 srcAmount,
        address destAddress
    ) internal returns (UserBalance memory balanceBefore) {
        if (src == ETH_TOKEN_ADDRESS) {
            require(msg.value == srcAmount, "sent eth not equal to srcAmount");
        } else {
            require(msg.value == 0, "sent eth not 0");
        }

        balanceBefore.srcTok = getBalance(src, msg.sender);
        balanceBefore.destTok = getBalance(dest, destAddress);

        if (src == ETH_TOKEN_ADDRESS) {
            balanceBefore.srcTok += msg.value;
        } else {
            src.safeTransferFrom(msg.sender, address(kyberNetwork), srcAmount);
        }
    }

    function calculateTradeOutcome(
        IERC20 src,
        IERC20 dest,
        address destAddress,
        uint256 platformFeeBps,
        UserBalance memory balanceBefore
    ) internal returns (TradeOutcome memory outcome) {
        uint256 srcTokenBalanceAfter;
        uint256 destTokenBalanceAfter;

        srcTokenBalanceAfter = getBalance(src, msg.sender);
        destTokenBalanceAfter = getBalance(dest, destAddress);

        //protect from underflow
        require(
            destTokenBalanceAfter > balanceBefore.destTok,
            "wrong amount in destination address"
        );
        require(balanceBefore.srcTok > srcTokenBalanceAfter, "wrong amount in source address");

        outcome.userDeltaSrcToken = balanceBefore.srcTok - srcTokenBalanceAfter;
        outcome.userDeltaDestToken = destTokenBalanceAfter - balanceBefore.destTok;

        // what would be the src amount after deducting platformFee
        // not protecting from platform fee
        uint256 srcTokenAmountAfterDeductingFee = (outcome.userDeltaSrcToken *
            (BPS - platformFeeBps)) / BPS;

        outcome.actualRate = calcRateFromQty(
            srcTokenAmountAfterDeductingFee,
            outcome.userDeltaDestToken,
            getUpdateDecimals(src),
            getUpdateDecimals(dest)
        );
    }
}