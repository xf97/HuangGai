/**
 *Submitted for verification at Etherscan.io on 2020-07-22
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

// File: canonical-weth/contracts/WETH9.sol

contract WETH9 {
    string public name     = "Wrapped Ether";
    string public symbol   = "WETH";
    uint8  public decimals = 18;

    event  Approval(address indexed src, address indexed guy, uint wad);
    event  Transfer(address indexed src, address indexed dst, uint wad);
    event  Deposit(address indexed dst, uint wad);
    event  Withdrawal(address indexed src, uint wad);

    mapping (address => uint)                       public  balanceOf;
    mapping (address => mapping (address => uint))  public  allowance;

    function() external payable {
        deposit();
    }
    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    function withdraw(uint wad) public {
        require(balanceOf[msg.sender] >= wad);
        balanceOf[msg.sender] -= wad;
        msg.sender.transfer(wad);
        emit Withdrawal(msg.sender, wad);
    }

    function totalSupply() public view returns (uint) {
        return address(this).balance;
    }

    function approve(address guy, uint wad) public returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public
        returns (bool)
    {
        require(balanceOf[src] >= wad);

        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
            require(allowance[src][msg.sender] >= wad);
            allowance[src][msg.sender] -= wad;
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        emit Transfer(src, dst, wad);

        return true;
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
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

// File: @openzeppelin/contracts/utils/Address.sol

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
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
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
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol

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
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IERC20 token, bytes memory data) private {
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

// File: contracts/protocol/v1/intf/I_PerpetualV1.sol

/**
 * @title I_PerpetualV1
 * @author dYdX
 *
 * @notice Interface for PerpetualV1.
 */
interface I_PerpetualV1 {

    // ============ Structs ============

    struct TradeArg {
        uint256 takerIndex;
        uint256 makerIndex;
        address trader;
        bytes data;
    }

    // ============ State-Changing Functions ============

    /**
     * @notice Submits one or more trades between any number of accounts.
     *
     * @param  accounts  The sorted list of accounts that are involved in trades.
     * @param  trades    The list of trades to execute in-order.
     */
    function trade(
        address[] calldata accounts,
        TradeArg[] calldata trades
    )
        external;

    /**
     * @notice Withdraw the number of margin tokens equal to the value of the account at the time
     *  that final settlement occurred.
     */
    function withdrawFinalSettlement()
        external;

    /**
     * @notice Deposit some amount of margin tokens from the msg.sender into an account.
     *
     * @param  account  The account for which to credit the deposit.
     * @param  amount   the amount of tokens to deposit.
     */
    function deposit(
        address account,
        uint256 amount
    )
        external;

    /**
     * @notice Withdraw some amount of margin tokens from an account to a destination address.
     *
     * @param  account      The account for which to debit the withdrawal.
     * @param  destination  The address to which the tokens are transferred.
     * @param  amount       The amount of tokens to withdraw.
     */
    function withdraw(
        address account,
        address destination,
        uint256 amount
    )
        external;

    /**
     * @notice Grants or revokes permission for another account to perform certain actions on behalf
     *  of the sender.
     *
     * @param  operator  The account that is approved or disapproved.
     * @param  approved  True for approval, false for disapproval.
     */
    function setLocalOperator(
        address operator,
        bool approved
    )
        external;

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
        returns (P1Types.Balance memory);

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
        returns (P1Types.Index memory);

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
        returns (bool);

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
        returns (bool);

    /**
     * @notice Gets the address of the ERC20 margin contract used for margin deposits.
     *
     * @return The address of the ERC20 token.
     */
    function getTokenContract()
        external
        view
        returns (address);

    /**
     * @notice Gets the current address of the price oracle contract.
     *
     * @return The address of the price oracle contract.
     */
    function getOracleContract()
        external
        view
        returns (address);

    /**
     * @notice Gets the current address of the funder contract.
     *
     * @return The address of the funder contract.
     */
    function getFunderContract()
        external
        view
        returns (address);

    /**
     * @notice Gets the most recently cached global index.
     *
     * @return The most recently cached global index.
     */
    function getGlobalIndex()
        external
        view
        returns (P1Types.Index memory);

    /**
     * @notice Gets minimum collateralization ratio of the protocol.
     *
     * @return The minimum-acceptable collateralization ratio, returned as a fixed-point number with
     *  18 decimals of precision.
     */
    function getMinCollateral()
        external
        view
        returns (uint256);

    /**
     * @notice Gets the status of whether final-settlement was initiated by the Admin.
     *
     * @return True if final-settlement was enabled, false otherwise.
     */
    function getFinalSettlementEnabled()
        external
        view
        returns (bool);

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
        external
        view
        returns (bool);

    // ============ Authorized Getters ============

    /**
     * @notice Gets the price returned by the oracle.
     * @dev Only able to be called by global operators.
     *
     * @return The price returned by the current price oracle.
     */
    function getOraclePrice()
        external
        view
        returns (uint256);
}

// File: contracts/protocol/v1/proxies/P1Proxy.sol

/**
 * @title P1Proxy
 * @author dYdX
 *
 * @notice Base contract for proxy contracts, which can be used to provide additional functionality
 *  or restrictions when making calls to a Perpetual contract on behalf of a user.
 */
contract P1Proxy {
    using SafeERC20 for IERC20;

    /**
     * @notice Sets the maximum allowance on the Perpetual contract. Must be called at least once
     *  on a given Perpetual before deposits can be made.
     * @dev Cannot be run in the constructor due to technical restrictions in Solidity.
     */
    function approveMaximumOnPerpetual(
        address perpetual
    )
        external
    {
        IERC20 tokenContract = IERC20(I_PerpetualV1(perpetual).getTokenContract());

        // safeApprove requires unsetting the allowance first.
        tokenContract.safeApprove(perpetual, 0);

        // Set the allowance to the highest possible value.
        tokenContract.safeApprove(perpetual, uint256(-1));
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

// File: contracts/protocol/v1/proxies/P1WethProxy.sol

/**
 * @title P1WethProxy
 * @author dYdX
 *
 * @notice A proxy for depositing and withdrawing ETH to/from a Perpetual contract that uses WETH as
 *  its margin token. The ETH will be wrapper and unwrapped by the proxy.
 */
contract P1WethProxy is
    P1Proxy,
    ReentrancyGuard
{
    // ============ Storage ============

    WETH9 public _WETH_;

    // ============ Constructor ============

    constructor (
        address payable weth
    )
        public
    {
        _WETH_ = WETH9(weth);
    }

    // ============ External Functions ============

    /**
     * Fallback function. Disallows ether to be sent to this contract without data except when
     * unwrapping WETH.
     */
    function ()
        external
        payable
    {
        require(
            msg.sender == address(_WETH_),
            "Cannot receive ETH"
        );
    }

    /**
     * @notice Deposit ETH into a Perpetual, by first wrapping it as WETH. Any ETH paid to this
     *  function will be converted and deposited.
     *
     * @param  perpetual  Address of the Perpetual contract to deposit to.
     * @param  account    The account on the Perpetual for which to credit the deposit.
     */
    function depositEth(
        address perpetual,
        address account
    )
        external
        payable
        nonReentrant
    {
        WETH9 weth = _WETH_;
        address marginToken = I_PerpetualV1(perpetual).getTokenContract();
        require(
            marginToken == address(weth),
            "The perpetual does not use WETH for margin deposits"
        );

        // Wrap ETH.
        weth.deposit.value(msg.value)();

        // Deposit all WETH into the perpetual.
        uint256 amount = weth.balanceOf(address(this));
        I_PerpetualV1(perpetual).deposit(account, amount);
    }

    /**
     * @notice Withdraw ETH from a Perpetual, by first withdrawing and unwrapping WETH.
     *
     * @param  perpetual    Address of the Perpetual contract to withdraw from.
     * @param  account      The account on the Perpetual to withdraw from.
     * @param  destination  The address to send the withdrawn ETH to.
     * @param  amount       The amount of ETH/WETH to withdraw.
     */
    function withdrawEth(
        address perpetual,
        address account,
        address payable destination,
        uint256 amount
    )
        external
        nonReentrant
    {
        WETH9 weth = _WETH_;
        address marginToken = I_PerpetualV1(perpetual).getTokenContract();
        require(
            marginToken == address(weth),
            "The perpetual does not use WETH for margin deposits"
        );

        require(
            // Short-circuit if sender is the account owner.
            msg.sender == account ||
                I_PerpetualV1(perpetual).hasAccountPermissions(account, msg.sender),
            "Sender does not have withdraw permissions for the account"
        );

        // Withdraw WETH from the perpetual.
        I_PerpetualV1(perpetual).withdraw(account, address(this), amount);

        // Unwrap all WETH and send it as ETH to the provided destination.
        uint256 balance = weth.balanceOf(address(this));
        weth.withdraw(balance);
        destination.transfer(balance);
    }
}