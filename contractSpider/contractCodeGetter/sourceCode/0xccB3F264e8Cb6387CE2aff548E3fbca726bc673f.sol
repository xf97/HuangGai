/**
 *Submitted for verification at Etherscan.io on 2020-07-18
*/

// SPDX-License-Identifier: Copyright@I AM Satoshi Global
/**
 *
 *
 *       ██|█|█|█|        ██|       ██|█|█|█|█|     ██|█|█|      ██|█|█|█|    ██|      █|   ██|
 *      ██|       █     ██|  █|         ██|       ██|      █|   ██|       █   ██|      █|   ██|
 *      ██|            ██|    █|        ██|       ██|      █|   ██|           ██|      █|   ██|
 *       ██|█|█|█|    ██||█|█||█|       ██|       ██|      █|    ██|█|█|█|    ██|█|█|█|█|   ██|
 *              ██|   ██|      █|       ██|       ██|      █|           ██|   ██|      █|   ██|
 *      █       ██|   ██|      █|       ██|       ██|      █|   █       ██|   ██|      █|   ██|
 *       ██|█|█|█|    ██|      █|       ██|         ██|█|█|      ██|█|█|█|    ██|      █|   ██|
 *
 *                      ██████   ██          ████    ████████     ██     ██
 *                     ██        ██        ██    ██  ██     █   ██  ██   ██
 *                     ██  ████  ██        ██    ██  ████████  ██ ██ ██  ██
 *                     ██    ██  ██        ██    ██  ██     █  ██    ██  ██
 *                      ██████   ████████    ████    ████████  ██    ██  ████████

 *       ██|█|█|█|  ██|    █|  ██|█|█|█  ██|    █|     ██|     ██|    █|   ██|█|█|   ██|█|█|█|
 *       ██|         ██|  █|   ██|       ██|    █|   ██|  █|   ██|█   █|  ██|        ██|
 *       ██|█|█|█      ██|     ██|       ██|█|█|█|  ██| █| █|  ██| ██ █|  ██|  █|█|  ██|█|█|█
 *       ██|         ██|  █|   ██|       ██|    █|  ██|    █|  ██|   ██|  ██|    █|  ██|
 *       ██|█|█|█|  ██|    █|  ██|█|█|█  ██|    █|  ██|    █|  ██|    █|   ██|█|█|   ██|█|█|█|

 *                                       ███╗       ██████╗
 *                                        ██║      ██╔═══██╗
 *                                        ██║      ██║   ██║
 *                                        ██║      ██║   ██║
 *                                        ██║  ██╗ ╚██████╔╝
 *                                        ╚═╝  ╚═╝  ╚═════╝
 *
 * URL: https://iamsatoshi.global
 *      https://iamsatoshiglobal.io
 *
 *
 */

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

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

pragma solidity ^0.5.0;

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

pragma solidity ^0.5.5;

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

pragma solidity ^0.5.0;




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

// File: @openzeppelin/contracts/utils/EnumerableSet.sol

pragma solidity ^0.5.0;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * As of v2.5.0, only `address` sets are supported.
 *
 * Include with `using EnumerableSet for EnumerableSet.AddressSet;`.
 *
 * _Available since v2.5.0._
 *
 * @author Alberto Cuesta Cañada
 */
library EnumerableSet {

    struct AddressSet {
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (address => uint256) index;
        address[] values;
    }

    /**
     * @dev Add a value to a set. O(1).
     * Returns false if the value was already in the set.
     */
    function add(AddressSet storage set, address value)
        internal
        returns (bool)
    {
        if (!contains(set, value)){
            set.index[value] = set.values.push(value);
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     * Returns false if the value was not present in the set.
     */
    function remove(AddressSet storage set, address value)
        internal
        returns (bool)
    {
        if (contains(set, value)){
            uint256 toDeleteIndex = set.index[value] - 1;
            uint256 lastIndex = set.values.length - 1;

            // If the element we're deleting is the last one, we can just remove it without doing a swap
            if (lastIndex != toDeleteIndex) {
                address lastValue = set.values[lastIndex];

                // Move the last value to the index where the deleted value is
                set.values[toDeleteIndex] = lastValue;
                // Update the index for the moved value
                set.index[lastValue] = toDeleteIndex + 1; // All indexes are 1-based
            }

            // Delete the index entry for the deleted value
            delete set.index[value];

            // Delete the old entry for the moved value
            set.values.pop();

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value)
        internal
        view
        returns (bool)
    {
        return set.index[value] != 0;
    }

    /**
     * @dev Returns an array with all values in the set. O(N).
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.

     * WARNING: This function may run out of gas on large sets: use {length} and
     * {get} instead in these cases.
     */
    function enumerate(AddressSet storage set)
        internal
        view
        returns (address[] memory)
    {
        address[] memory output = new address[](set.values.length);
        for (uint256 i; i < set.values.length; i++){
            output[i] = set.values[i];
        }
        return output;
    }

    /**
     * @dev Returns the number of elements on the set. O(1).
     */
    function length(AddressSet storage set)
        internal
        view
        returns (uint256)
    {
        return set.values.length;
    }

   /** @dev Returns the element stored at position `index` in the set. O(1).
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function get(AddressSet storage set, uint256 index)
        internal
        view
        returns (address)
    {
        return set.values[index];
    }
}

// File: @openzeppelin/contracts/GSN/Context.sol

pragma solidity ^0.5.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: contracts/dependencies/AccessControl.sol

pragma solidity ^0.5.16;




/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it.
 */
contract AccessControl is Context {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Address for address;

    struct RoleData {
        EnumerableSet.AddressSet members;
        bytes32 adminRole;
    }

    mapping (bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role].members.contains(account);
    }

    /**
     * @dev Returns the number of accounts that have `role`. Can be used
     * together with {getRoleMember} to enumerate all bearers of a role.
     */
    function getRoleMemberCount(bytes32 role) public view returns (uint256) {
        return _roles[role].members.length();
    }

    /**
     * @dev Returns one of the accounts that have `role`. `index` must be a
     * value between 0 and {getRoleMemberCount}, non-inclusive.
     *
     * Role bearers are not sorted in any particular way, and their ordering may
     * change at any point.
     *
     * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
     * you perform all queries on the same block. See the following
     * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
     * for more information.
     */
    function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
        return _roles[role].members.get(index);
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) public {
        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");

        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) public {
        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");

        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) public {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event. Note that unlike {grantRole}, this function doesn't perform any
     * checks on the calling account.
     *
     * [WARNING]
     * ====
     * This function should only be called from the constructor when setting
     * up the initial roles for the system.
     *
     * Using this function in any other way is effectively circumventing the admin
     * system imposed by {AccessControl}.
     * ====
     */
    function _setupRole(bytes32 role, address account) internal {
        _grantRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal {
        _roles[role].adminRole = adminRole;
    }

    function _grantRole(bytes32 role, address account) private {
        if (_roles[role].members.add(account)) {
            emit RoleGranted(role, account, _msgSender());
        }
    }

    function _revokeRole(bytes32 role, address account) private {
        if (_roles[role].members.remove(account)) {
            emit RoleRevoked(role, account, _msgSender());
        }
    }
}

// File: @openzeppelin/contracts/GSN/IRelayRecipient.sol

pragma solidity ^0.5.0;

/**
 * @dev Base interface for a contract that will be called via the GSN from {IRelayHub}.
 *
 * TIP: You don't need to write an implementation yourself! Inherit from {GSNRecipient} instead.
 */
interface IRelayRecipient {
    /**
     * @dev Returns the address of the {IRelayHub} instance this recipient interacts with.
     */
    function getHubAddr() external view returns (address);

    /**
     * @dev Called by {IRelayHub} to validate if this recipient accepts being charged for a relayed call. Note that the
     * recipient will be charged regardless of the execution result of the relayed call (i.e. if it reverts or not).
     *
     * The relay request was originated by `from` and will be served by `relay`. `encodedFunction` is the relayed call
     * calldata, so its first four bytes are the function selector. The relayed call will be forwarded `gasLimit` gas,
     * and the transaction executed with a gas price of at least `gasPrice`. `relay`'s fee is `transactionFee`, and the
     * recipient will be charged at most `maxPossibleCharge` (in wei). `nonce` is the sender's (`from`) nonce for
     * replay attack protection in {IRelayHub}, and `approvalData` is a optional parameter that can be used to hold a signature
     * over all or some of the previous values.
     *
     * Returns a tuple, where the first value is used to indicate approval (0) or rejection (custom non-zero error code,
     * values 1 to 10 are reserved) and the second one is data to be passed to the other {IRelayRecipient} functions.
     *
     * {acceptRelayedCall} is called with 50k gas: if it runs out during execution, the request will be considered
     * rejected. A regular revert will also trigger a rejection.
     */
    function acceptRelayedCall(
        address relay,
        address from,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata approvalData,
        uint256 maxPossibleCharge
    )
        external
        view
        returns (uint256, bytes memory);

    /**
     * @dev Called by {IRelayHub} on approved relay call requests, before the relayed call is executed. This allows to e.g.
     * pre-charge the sender of the transaction.
     *
     * `context` is the second value returned in the tuple by {acceptRelayedCall}.
     *
     * Returns a value to be passed to {postRelayedCall}.
     *
     * {preRelayedCall} is called with 100k gas: if it runs out during exection or otherwise reverts, the relayed call
     * will not be executed, but the recipient will still be charged for the transaction's cost.
     */
    function preRelayedCall(bytes calldata context) external returns (bytes32);

    /**
     * @dev Called by {IRelayHub} on approved relay call requests, after the relayed call is executed. This allows to e.g.
     * charge the user for the relayed call costs, return any overcharges from {preRelayedCall}, or perform
     * contract-specific bookkeeping.
     *
     * `context` is the second value returned in the tuple by {acceptRelayedCall}. `success` is the execution status of
     * the relayed call. `actualCharge` is an estimate of how much the recipient will be charged for the transaction,
     * not including any gas used by {postRelayedCall} itself. `preRetVal` is {preRelayedCall}'s return value.
     *
     *
     * {postRelayedCall} is called with 100k gas: if it runs out during execution or otherwise reverts, the relayed call
     * and the call to {preRelayedCall} will be reverted retroactively, but the recipient will still be charged for the
     * transaction's cost.
     */
    function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
}

// File: @openzeppelin/contracts/GSN/IRelayHub.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface for `RelayHub`, the core contract of the GSN. Users should not need to interact with this contract
 * directly.
 *
 * See the https://github.com/OpenZeppelin/openzeppelin-gsn-helpers[OpenZeppelin GSN helpers] for more information on
 * how to deploy an instance of `RelayHub` on your local test network.
 */
interface IRelayHub {
    // Relay management

    /**
     * @dev Adds stake to a relay and sets its `unstakeDelay`. If the relay does not exist, it is created, and the caller
     * of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
     * cannot be its own owner.
     *
     * All Ether in this function call will be added to the relay's stake.
     * Its unstake delay will be assigned to `unstakeDelay`, but the new value must be greater or equal to the current one.
     *
     * Emits a {Staked} event.
     */
    function stake(address relayaddr, uint256 unstakeDelay) external payable;

    /**
     * @dev Emitted when a relay's stake or unstakeDelay are increased
     */
    event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);

    /**
     * @dev Registers the caller as a relay.
     * The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
     *
     * This function can be called multiple times, emitting new {RelayAdded} events. Note that the received
     * `transactionFee` is not enforced by {relayCall}.
     *
     * Emits a {RelayAdded} event.
     */
    function registerRelay(uint256 transactionFee, string calldata url) external;

    /**
     * @dev Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out
     * {RelayRemoved} events) lets a client discover the list of available relays.
     */
    event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);

    /**
     * @dev Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed.
     *
     * Can only be called by the owner of the relay. After the relay's `unstakeDelay` has elapsed, {unstake} will be
     * callable.
     *
     * Emits a {RelayRemoved} event.
     */
    function removeRelayByOwner(address relay) external;

    /**
     * @dev Emitted when a relay is removed (deregistered). `unstakeTime` is the time when unstake will be callable.
     */
    event RelayRemoved(address indexed relay, uint256 unstakeTime);

    /** Deletes the relay from the system, and gives back its stake to the owner.
     *
     * Can only be called by the relay owner, after `unstakeDelay` has elapsed since {removeRelayByOwner} was called.
     *
     * Emits an {Unstaked} event.
     */
    function unstake(address relay) external;

    /**
     * @dev Emitted when a relay is unstaked for, including the returned stake.
     */
    event Unstaked(address indexed relay, uint256 stake);

    // States a relay can be in
    enum RelayState {
        Unknown, // The relay is unknown to the system: it has never been staked for
        Staked, // The relay has been staked for, but it is not yet active
        Registered, // The relay has registered itself, and is active (can relay calls)
        Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
    }

    /**
     * @dev Returns a relay's status. Note that relays can be deleted when unstaked or penalized, causing this function
     * to return an empty entry.
     */
    function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);

    // Balance management

    /**
     * @dev Deposits Ether for a contract, so that it can receive (and pay for) relayed transactions.
     *
     * Unused balance can only be withdrawn by the contract itself, by calling {withdraw}.
     *
     * Emits a {Deposited} event.
     */
    function depositFor(address target) external payable;

    /**
     * @dev Emitted when {depositFor} is called, including the amount and account that was funded.
     */
    event Deposited(address indexed recipient, address indexed from, uint256 amount);

    /**
     * @dev Returns an account's deposits. These can be either a contracts's funds, or a relay owner's revenue.
     */
    function balanceOf(address target) external view returns (uint256);

    /**
     * Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
     * contracts can use it to reduce their funding.
     *
     * Emits a {Withdrawn} event.
     */
    function withdraw(uint256 amount, address payable dest) external;

    /**
     * @dev Emitted when an account withdraws funds from `RelayHub`.
     */
    event Withdrawn(address indexed account, address indexed dest, uint256 amount);

    // Relaying

    /**
     * @dev Checks if the `RelayHub` will accept a relayed operation.
     * Multiple things must be true for this to happen:
     *  - all arguments must be signed for by the sender (`from`)
     *  - the sender's nonce must be the current one
     *  - the recipient must accept this transaction (via {acceptRelayedCall})
     *
     * Returns a `PreconditionCheck` value (`OK` when the transaction can be relayed), or a recipient-specific error
     * code if it returns one in {acceptRelayedCall}.
     */
    function canRelay(
        address relay,
        address from,
        address to,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata signature,
        bytes calldata approvalData
    ) external view returns (uint256 status, bytes memory recipientContext);

    // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
    enum PreconditionCheck {
        OK,                         // All checks passed, the call can be relayed
        WrongSignature,             // The transaction to relay is not signed by requested sender
        WrongNonce,                 // The provided nonce has already been used by the sender
        AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
        InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
    }

    /**
     * @dev Relays a transaction.
     *
     * For this to succeed, multiple conditions must be met:
     *  - {canRelay} must `return PreconditionCheck.OK`
     *  - the sender must be a registered relay
     *  - the transaction's gas price must be larger or equal to the one that was requested by the sender
     *  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
     * recipient) use all gas available to them
     *  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
     * spent)
     *
     * If all conditions are met, the call will be relayed and the recipient charged. {preRelayedCall}, the encoded
     * function and {postRelayedCall} will be called in that order.
     *
     * Parameters:
     *  - `from`: the client originating the request
     *  - `to`: the target {IRelayRecipient} contract
     *  - `encodedFunction`: the function call to relay, including data
     *  - `transactionFee`: fee (%) the relay takes over actual gas cost
     *  - `gasPrice`: gas price the client is willing to pay
     *  - `gasLimit`: gas to forward when calling the encoded function
     *  - `nonce`: client's nonce
     *  - `signature`: client's signature over all previous params, plus the relay and RelayHub addresses
     *  - `approvalData`: dapp-specific data forwared to {acceptRelayedCall}. This value is *not* verified by the
     * `RelayHub`, but it still can be used for e.g. a signature.
     *
     * Emits a {TransactionRelayed} event.
     */
    function relayCall(
        address from,
        address to,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata signature,
        bytes calldata approvalData
    ) external;

    /**
     * @dev Emitted when an attempt to relay a call failed.
     *
     * This can happen due to incorrect {relayCall} arguments, or the recipient not accepting the relayed call. The
     * actual relayed call was not executed, and the recipient not charged.
     *
     * The `reason` parameter contains an error code: values 1-10 correspond to `PreconditionCheck` entries, and values
     * over 10 are custom recipient error codes returned from {acceptRelayedCall}.
     */
    event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);

    /**
     * @dev Emitted when a transaction is relayed. 
     * Useful when monitoring a relay's operation and relayed calls to a contract
     *
     * Note that the actual encoded function might be reverted: this is indicated in the `status` parameter.
     *
     * `charge` is the Ether value deducted from the recipient's balance, paid to the relay's owner.
     */
    event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);

    // Reason error codes for the TransactionRelayed event
    enum RelayCallStatus {
        OK,                      // The transaction was successfully relayed and execution successful - never included in the event
        RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
        PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
        PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
        RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
    }

    /**
     * @dev Returns how much gas should be forwarded to a call to {relayCall}, in order to relay a transaction that will
     * spend up to `relayedCallStipend` gas.
     */
    function requiredGas(uint256 relayedCallStipend) external view returns (uint256);

    /**
     * @dev Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
     */
    function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) external view returns (uint256);

     // Relay penalization. 
     // Any account can penalize relays, removing them from the system immediately, and rewarding the
    // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
    // still loses half of its stake.

    /**
     * @dev Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
     * different data (gas price, gas limit, etc. may be different).
     *
     * The (unsigned) transaction data and signature for both transactions must be provided.
     */
    function penalizeRepeatedNonce(bytes calldata unsignedTx1, bytes calldata signature1, bytes calldata unsignedTx2, bytes calldata signature2) external;

    /**
     * @dev Penalize a relay that sent a transaction that didn't target `RelayHub`'s {registerRelay} or {relayCall}.
     */
    function penalizeIllegalTransaction(bytes calldata unsignedTx, bytes calldata signature) external;

    /**
     * @dev Emitted when a relay is penalized.
     */
    event Penalized(address indexed relay, address sender, uint256 amount);

    /**
     * @dev Returns an account's nonce in `RelayHub`.
     */
    function getNonce(address from) external view returns (uint256);
}

// File: @openzeppelin/contracts/GSN/GSNRecipient.sol

pragma solidity ^0.5.0;




/**
 * @dev Base GSN recipient contract: includes the {IRelayRecipient} interface
 * and enables GSN support on all contracts in the inheritance tree.
 *
 * TIP: This contract is abstract. The functions {IRelayRecipient-acceptRelayedCall},
 *  {_preRelayedCall}, and {_postRelayedCall} are not implemented and must be
 * provided by derived contracts. See the
 * xref:ROOT:gsn-strategies.adoc#gsn-strategies[GSN strategies] for more
 * information on how to use the pre-built {GSNRecipientSignature} and
 * {GSNRecipientERC20Fee}, or how to write your own.
 */
contract GSNRecipient is IRelayRecipient, Context {
    // Default RelayHub address, deployed on mainnet and all testnets at the same address
    address private _relayHub = 0xD216153c06E857cD7f72665E0aF1d7D82172F494;

    uint256 constant private RELAYED_CALL_ACCEPTED = 0;
    uint256 constant private RELAYED_CALL_REJECTED = 11;

    // How much gas is forwarded to postRelayedCall
    uint256 constant internal POST_RELAYED_CALL_MAX_GAS = 100000;

    /**
     * @dev Emitted when a contract changes its {IRelayHub} contract to a new one.
     */
    event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);

    /**
     * @dev Returns the address of the {IRelayHub} contract for this recipient.
     */
    function getHubAddr() public view returns (address) {
        return _relayHub;
    }

    /**
     * @dev Switches to a new {IRelayHub} instance. This method is added for future-proofing: there's no reason to not
     * use the default instance.
     *
     * IMPORTANT: After upgrading, the {GSNRecipient} will no longer be able to receive relayed calls from the old
     * {IRelayHub} instance. Additionally, all funds should be previously withdrawn via {_withdrawDeposits}.
     */
    function _upgradeRelayHub(address newRelayHub) internal {
        address currentRelayHub = _relayHub;
        require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
        require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");

        emit RelayHubChanged(currentRelayHub, newRelayHub);

        _relayHub = newRelayHub;
    }

    /**
     * @dev Returns the version string of the {IRelayHub} for which this recipient implementation was built. If
     * {_upgradeRelayHub} is used, the new {IRelayHub} instance should be compatible with this version.
     */
    // This function is view for future-proofing, it may require reading from
    // storage in the future.
    function relayHubVersion() public view returns (string memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return "1.0.0";
    }

    /**
     * @dev Withdraws the recipient's deposits in `RelayHub`.
     *
     * Derived contracts should expose this in an external interface with proper access control.
     */
    function _withdrawDeposits(uint256 amount, address payable payee) internal {
        IRelayHub(_relayHub).withdraw(amount, payee);
    }

    // Overrides for Context's functions: when called from RelayHub, sender and
    // data require some pre-processing: the actual sender is stored at the end
    // of the call data, which in turns means it needs to be removed from it
    // when handling said data.

    /**
     * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
     * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).
     *
     * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.
     */
    function _msgSender() internal view returns (address payable) {
        if (msg.sender != _relayHub) {
            return msg.sender;
        } else {
            return _getRelayedCallSender();
        }
    }

    /**
     * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,
     * and a reduced version for GSN relayed calls (where msg.data contains additional information).
     *
     * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.
     */
    function _msgData() internal view returns (bytes memory) {
        if (msg.sender != _relayHub) {
            return msg.data;
        } else {
            return _getRelayedCallData();
        }
    }

    // Base implementations for pre and post relayedCall: only RelayHub can invoke them, and data is forwarded to the
    // internal hook.

    /**
     * @dev See `IRelayRecipient.preRelayedCall`.
     *
     * This function should not be overriden directly, use `_preRelayedCall` instead.
     *
     * * Requirements:
     *
     * - the caller must be the `RelayHub` contract.
     */
    function preRelayedCall(bytes calldata context) external returns (bytes32) {
        require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
        return _preRelayedCall(context);
    }

    /**
     * @dev See `IRelayRecipient.preRelayedCall`.
     *
     * Called by `GSNRecipient.preRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
     * must implement this function with any relayed-call preprocessing they may wish to do.
     *
     */
    function _preRelayedCall(bytes memory context) internal returns (bytes32);

    /**
     * @dev See `IRelayRecipient.postRelayedCall`.
     *
     * This function should not be overriden directly, use `_postRelayedCall` instead.
     *
     * * Requirements:
     *
     * - the caller must be the `RelayHub` contract.
     */
    function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external {
        require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
        _postRelayedCall(context, success, actualCharge, preRetVal);
    }

    /**
     * @dev See `IRelayRecipient.postRelayedCall`.
     *
     * Called by `GSNRecipient.postRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
     * must implement this function with any relayed-call postprocessing they may wish to do.
     *
     */
    function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal;

    /**
     * @dev Return this in acceptRelayedCall to proceed with the execution of a relayed call. Note that this contract
     * will be charged a fee by RelayHub
     */
    function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
        return _approveRelayedCall("");
    }

    /**
     * @dev See `GSNRecipient._approveRelayedCall`.
     *
     * This overload forwards `context` to _preRelayedCall and _postRelayedCall.
     */
    function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
        return (RELAYED_CALL_ACCEPTED, context);
    }

    /**
     * @dev Return this in acceptRelayedCall to impede execution of a relayed call. No fees will be charged.
     */
    function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
        return (RELAYED_CALL_REJECTED + errorCode, "");
    }

    /*
     * @dev Calculates how much RelayHub will charge a recipient for using `gas` at a `gasPrice`, given a relayer's
     * `serviceFee`.
     */
    function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
        // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be
        // charged for 1.4 times the spent amount.
        return (gas * gasPrice * (100 + serviceFee)) / 100;
    }

    function _getRelayedCallSender() private pure returns (address payable result) {
        // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
        // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
        // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
        // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
        // bytes. This can always be done due to the 32-byte prefix.

        // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
        // easiest/most-efficient way to perform this operation.

        // These fields are not accessible from assembly
        bytes memory array = msg.data;
        uint256 index = msg.data.length;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
            result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
        }
        return result;
    }

    function _getRelayedCallData() private pure returns (bytes memory) {
        // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,
        // we must strip the last 20 bytes (length of an address type) from it.

        uint256 actualDataLength = msg.data.length - 20;
        bytes memory actualData = new bytes(actualDataLength);

        for (uint256 i = 0; i < actualDataLength; ++i) {
            actualData[i] = msg.data[i];
        }

        return actualData;
    }
}

// File: @openzeppelin/contracts/cryptography/ECDSA.sol

pragma solidity ^0.5.0;

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
     * NOTE: This call _does not revert_ if the signature is invalid, or
     * if the signer is otherwise unable to be retrieved. In those scenarios,
     * the zero address is returned.
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
            return (address(0));
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
            return address(0);
        }

        if (v != 27 && v != 28) {
            return address(0);
        }

        // If the signature is valid (and not malleable), return the signer address
        return ecrecover(hash, v, r, s);
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

// File: contracts/dependencies/GSNRecipientSignature.sol

pragma solidity ^0.5.16;



/**
 * @dev A xref:ROOT:gsn-strategies.adoc#gsn-strategies[GSN strategy] that allows relayed transactions through when they are
 * accompanied by the signature of a trusted signer. The intent is for this signature to be generated by a server that
 * performs validations off-chain. Note that nothing is charged to the user in this scheme. Thus, the server should make
 * sure to account for this in their economic and threat model.
 */
contract GSNRecipientSignature is GSNRecipient {
    using ECDSA for bytes32;

    address private _trustedSigner;

    enum GSNRecipientSignatureErrorCodes {
        INVALID_SIGNER
    }

    /**
     * @dev Sets the trusted signer that is going to be producing signatures to approve relayed calls.
     */
    constructor(address trustedSigner) public {
        require(trustedSigner != address(0), "GSNRecipientSignature: trusted signer is the zero address");
        _trustedSigner = trustedSigner;
    }

    /**
     * @dev Sets the trusted signer that is going to be producing signatures to approve relayed calls.
     */
    function setTrustedSigner(address trustedSigner) public {
        require(trustedSigner != address(0), "GSNRecipientSignature: trusted signer is the zero address");
        _trustedSigner = trustedSigner;
    }

    /**
     * @dev Ensures that only transactions with a trusted signature can be relayed through the GSN.
     */
    function acceptRelayedCall(
        address relay,
        address from,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata approvalData,
        uint256
    )
        external
        view
        returns (uint256, bytes memory)
    {
        bytes memory blob = abi.encodePacked(
            relay,
            from,
            encodedFunction,
            transactionFee,
            gasPrice,
            gasLimit,
            nonce, // Prevents replays on RelayHub
            getHubAddr(), // Prevents replays in multiple RelayHubs
            address(this) // Prevents replays in multiple recipients
        );
        if (keccak256(blob).toEthSignedMessageHash().recover(approvalData) == _trustedSigner) {
            return _approveRelayedCall();
        } else {
            return _rejectRelayedCall(uint256(GSNRecipientSignatureErrorCodes.INVALID_SIGNER));
        }
    }

    function _preRelayedCall(bytes memory) internal returns (bytes32) {
        // solhint-disable-previous-line no-empty-blocks
    }

    function _postRelayedCall(bytes memory, bool, uint256, bytes32) internal {
        // solhint-disable-previous-line no-empty-blocks
    }
}

// File: contracts/interfaces/ISatoshiToken.sol

pragma solidity >=0.5.7 <0.7.0;

interface ISatoshiToken{
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

    function mint(address to, uint256 amount) external;
    function burn(uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

// File: contracts/interfaces/ISatoshiPriceFeeder.sol

pragma solidity >=0.5.7 <0.7.0;


interface ISatoshiPriceFeeder {

    function getPriceInWei() external view returns (uint256);
}

// File: contracts/interfaces/IERC20Detailed.sol

pragma solidity >=0.5.7 <0.7.0;

interface IERC20Detailed{
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
    
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

// File: contracts/interfaces/ISatoshiAllotment.sol

pragma solidity >=0.5.7 <0.7.0;


interface ISatoshiAllotment {

    function grantAllotment(address account,
        uint256 amountAllotedInWei,
        uint64 startEpoch,
        uint256 planId) external returns (uint64);

    function isAllotmentPlanValid(uint64 id) external view returns (bool);
}

// File: contracts/SatoshiExchange.sol
pragma solidity ^0.5.16;








/**
* @dev This contract handles exchange of Satoshi Tokens to supported stablecoins
* and vice-versa
*/
contract SatoshiExchange is AccessControl, GSNRecipientSignature {
    using SafeERC20 for ISatoshiToken;
    using SafeERC20 for IERC20Detailed;
    using SafeERC20 for IERC20Detailed;
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    // Satoshi token Contract
    ISatoshiToken private _satoshiToken;

    // Satoshi Price Feeder Contract
    ISatoshiPriceFeeder private _satoshiPriceFeed;

    // Satoshi Allotment Contract
    ISatoshiAllotment private _satoshiAllotment;

    // Default plan id for alloment, set to max uint value
    uint256 public _defaultPlanId = ~uint256(0);

    // Direct Buy fee, no fee for allotments
    uint256 public _buyFeePercentInWei;

    // Sell fee
    uint256 public _sellFeePercentInWei;

    // Flag for enabling/disabling direct buy of satoshi tokens
    bool public _enableDirectBuying = false;

    // List of supported USD stable coins
    mapping(address => bool) private _supportedTokens;

    // Withdrawal Wallet address
    address payable private _wallet;

    // Event details
    event TokenAdded(address indexed token);
    event TokenRemoved(address indexed token);
    event TokenContractChanged(address indexed newAddress);
    event PriceFeederContractChanged(address indexed newAddress);
    event AllotmentContractChanged(address indexed newAddress);
    event SatoshiAllotmentBought(address indexed account,
        uint64 indexed id,
        uint256 amountInWei,
        address indexed token,
        uint256 tokenAmount,
        uint256 timestamp);
    event SatoshiSold(address indexed account,
        uint256 amountInWei,
        address indexed token,
        uint256 tokenAmount,
        uint256 feeInWei,
        uint256 timestamp);
    event SatoshiBought(address indexed account,
        uint256 amountInWei,
        address indexed token,
        uint256 tokenAmount,
        uint256 timestamp);
    event BuyFeeUpdated(uint256 newFeePercentInWei, uint256 timestamp);
    event SellFeeUpdated(uint256 newFeePercentInWei, uint256 timestamp);
    event ChangedAllotmentPlan(uint64 planId, uint256 timestamp);
    event ChangedDirectBuying(bool flag, uint256 timestamp);
    event WalletChanged(address wallet);
    event TokensWithdrawn(address indexed token, uint256 amount, uint256 timestamp);
    event EthWithdrawn(uint256 balance, uint256 timestamp);
    event TokenDeposited(address indexed account, string depositKey, uint256 depositAmount, address token, uint256 timestamp);
    event EthDeposited(address indexed account, string depositKey, uint256 depositAmount, uint256 timestamp);

    // Supported token validity modifier
    modifier onlySupportedToken(address token) {
        require(isTokenSupported(token), "SatoshiExchange: token not supported");
        _;
    }

    /**
     * @dev Initialize the contract with Satoshi token address,
     * support stable coin tokens for exchange and the base price of Satoshi token.
     *
     * @param satoshiToken - Satoshi Token address
     * @param satoshiPriceFeeder - Satoshi Price Feeder Contract address
     * @param satoshiAllotment - Satoshi Allotment Contract address
     * @param defaultPlanId - Default allotment plan id, could be set
     * to ~uint256(0) to set the plan later
     * @param buyFeePercentInWei - Direct buy fee percent in wei
     * @param sellFeePercentInWei - Sell fee percent in wei
     * @param enableDirectBuying - Flag to enable/disable direct buying
     * @param supportedTokens - Array of supported token address for exchange
     * @param trustedSigner - Trusted signer for GSN
     */
    constructor(address satoshiToken,
            address satoshiPriceFeeder,
            address satoshiAllotment,
            uint256 defaultPlanId,
            uint256 buyFeePercentInWei,
            uint256 sellFeePercentInWei,
            bool enableDirectBuying,
            address[] memory supportedTokens,
            address trustedSigner
        ) public GSNRecipientSignature(trustedSigner) {

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        require(satoshiToken != address(0), "SatoshiExchange: token is zero address");
        require(satoshiPriceFeeder != address(0), "SatoshiExchange: price Feeder is zero address");
        require(satoshiAllotment != address(0), "SatoshiExchange: allotment is zero address");

        // Set Satoshi ERC20 token Contract
        _satoshiToken = ISatoshiToken(satoshiToken);

        // Set Satoshi Price Feeder contract
        _satoshiPriceFeed = ISatoshiPriceFeeder(satoshiPriceFeeder);

        // Set Satoshi Allotment contract
        _satoshiAllotment = ISatoshiAllotment(satoshiAllotment);

        // Set direct buy fee percentage
        _buyFeePercentInWei = buyFeePercentInWei;

        // Set sell fee percentage
        _sellFeePercentInWei = sellFeePercentInWei;

        // Set direct buying flag
        _enableDirectBuying = enableDirectBuying;

        // Set the stable coin tokens supported for exchange
        for (uint256 i = 0; i < supportedTokens.length; i++){
            _supportedTokens[supportedTokens[i]] = true;
            emit TokenAdded(supportedTokens[i]);
        }

        // Set default plan id
        _defaultPlanId = defaultPlanId;
    }

    /**
     * @dev Sets the trusted signer that is going to be producing signatures to approve relayed calls.
     *
     * @param trustedSigner - Address of the trusted signer for GSN
     *
     * Requirements:
     *
     * - the caller must have the `DEFAULT_ADMIN_ROLE`
     */
    function setTrustedSigner(address trustedSigner) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "SatoshiToken: must have admin role to change trustedSigner");
        super.setTrustedSigner(trustedSigner);
    }

    /**
    * @dev Change the Satoshi Token contract
    *
    * @param newAddress New Address of the token
    * Requirements:
    *
    * - the caller must have the admin role.
    */
    function changeSatoshiTokenContract(address newAddress) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "SatoshiExchange: must have admin role to change satoshi token contract"
        );
        require(newAddress != address(0), "SatoshiExchange: token is zero address");

        // Change Satoshi ERC20 token Contract
        _satoshiToken = ISatoshiToken(newAddress);

        emit TokenContractChanged(newAddress);
    }

    /**
    * @dev Change the Satoshi Price Feeder contract
    *
    * @param newAddress New Address of the price feeder contract
    * Requirements:
    *
    * - the caller must have the admin role.
    */
    function changeSatoshiPriceFeederContract(address newAddress) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "SatoshiExchange: must have admin role to change price feeder contract"
        );
        require(newAddress != address(0), "SatoshiExchange: price feeder is zero address");

        // Change Satoshi Price Feeder contract
        _satoshiPriceFeed = ISatoshiPriceFeeder(newAddress);

        emit PriceFeederContractChanged(newAddress);
    }

    /**
    * @dev Change the Satoshi Allotment contract
    *
    * @param newAddress New Address of the allotment contract
    * Requirements:
    *
    * - the caller must have the admin role.
    */
    function changeSatoshiAllotmentContract(address newAddress) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "SatoshiExchange: must have admin role to change allotment contract"
        );
        require(newAddress != address(0), "SatoshiExchange: allotment is zero address");

        // Change Satoshi Price Feeder contract
        _satoshiAllotment = ISatoshiAllotment(newAddress);

        emit AllotmentContractChanged(newAddress);
    }

    /**
    * @dev Change direct buying fee
    *
    * @param newFeePercentInWei Updated fee for buying satoshi
    * Requirements:
    *
    * - the caller must have the admin role.
    */
    function changeBuyFee(uint256 newFeePercentInWei) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "SatoshiExchange: must have admin role to change change buy fee"
        );
        // Change Satoshi direct buy fee
        _buyFeePercentInWei = newFeePercentInWei;

        emit BuyFeeUpdated(newFeePercentInWei, block.timestamp);
    }

    /**
    * @dev Change selling fee
    *
    * @param newFeePercentInWei Updated fee for sell
    * Requirements:
    *
    * - the caller must have the admin role.
    */
    function changeSellFee(uint256 newFeePercentInWei) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "SatoshiExchange: must have admin role to change change sell fee"
        );
        // Change Satoshi sellingfee
        _sellFeePercentInWei = newFeePercentInWei;

        emit SellFeeUpdated(newFeePercentInWei, block.timestamp);
    }

    /**
    * @dev Returns whether given token is supported for subscriptions or not
    *
    * @param token Address of the token to be checked
    *
    * @return bool - Whether token is supported or not
    */
    function isTokenSupported(address token) public view returns(bool) {
        return _supportedTokens[token];
    }

    /**
    * @dev Allows admin to add supported token
    *
    * @param token Token address to be added
    * Requirements:
    *
    * - the caller must have the admin role.
    */
    function addToken(address token) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "SatoshiExchange: must have admin role to add token"
        );
        require(token != address(0), "SatoshiExchange: token is zero address");
        require(!_supportedTokens[token],
            "SatoshiExchange: token already supported"
        );
        _supportedTokens[token] = true;
        emit TokenAdded(token);
    }

    /**
    * @dev Allows admin to remove any supported token from the list
    *
    * @param token Token to be removed
    * Requirements:
    *
    * - only supported tokens
    * - the caller must have the admin role.
    */
    function removeToken(address token) external onlySupportedToken(token) {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "SatoshiExchange: must have admin role to remove token"
        );

        _supportedTokens[token] = false;
        emit TokenRemoved(token);
    }

    /**
    * @dev Adjust decimal precision from given value to another precision
    *
    * @param value - Value which needs precision adjustment
    * @param fromDecimals - Present decimal precision
    * @param toDecimals - Resulting decimal precision
    *
    * @return uint256 - Adjusted value to toDecimals precision
    */
    function adjustPrecision(uint256 value, uint8 fromDecimals, uint8 toDecimals) public pure returns (uint256) {
        if (fromDecimals == toDecimals) {
            return value;
        } else if (fromDecimals < toDecimals) {
            return value.mul(uint256(10)**(toDecimals - fromDecimals));
        } else {
            return value.div(uint256(10)**(fromDecimals - toDecimals));
        }
    }

    /**
    * @dev Convert given amount of Satoshi tokens to the value of stablecoin token,
    * and by also considering the current price of satoshi token.
    *
    * @param amountInWei - Amount of Satoshi Token to be bought
    * @param token - Supported stablecoin address
    *
    * @return uint256 - Converted value of stablecoin tokens
    */
    function convertSatoshiToTokenAmount(uint256 amountInWei, address token) public view returns (uint256) {
        // Decimal count of Stablecoin token to be received, for supporting
        // stable coins of different decimal places
        uint8 tokenDecimals = IERC20Detailed(token).decimals();
        uint8 satoshiDecimals = _satoshiToken.decimals();

        // Protection for not losing too much of decimals in conversion
        require(tokenDecimals >= 6, "SatoshiExchange: token should have greater that 6 decimals");

        // When there is difference in decimal precision, we might
        // lose precision but its an expected result. Only downside is,
        // a slightly less amount of stablecoin token shall be received/transferred.
        uint256 satoshiPriceInTokenDecimals = adjustPrecision(_satoshiPriceFeed.getPriceInWei(), satoshiDecimals, tokenDecimals);
        uint256 amountInWeiInTokenDecimals = adjustPrecision(amountInWei, satoshiDecimals, tokenDecimals);

        return amountInWeiInTokenDecimals.mul(satoshiPriceInTokenDecimals).div(uint256(10)**tokenDecimals);
    }

    /**
    * @dev Set default allotment plan ID
    *
    * @param planId - Allotment plan ID
    * Requirements:
    *
    * - the caller must have the admin role.
    * - Verify whether the allotment plan id is valid
    */
    function setDefaultAllotmentPlan(uint64 planId) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "SatoshiExchange: must have admin role to change allotment contract"
        );
        // Note: When plan ID is not present, then this will cause a revert
        require(_satoshiAllotment.isAllotmentPlanValid(planId) == true, "SatoshiExchange: Deleted allotment plan ID");

        _defaultPlanId = planId;
        emit ChangedAllotmentPlan(planId, block.timestamp);
    }

    /**
    * @dev Set direct buying
    *
    * @param flag - Flag to enable/disable direct buying
    * Requirements:
    *
    * - the caller must have the admin role.
    */
    function setDirectBuying(bool flag) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "SatoshiExchange: must have admin role to change direct buy flag"
        );

        _enableDirectBuying = flag;
        emit ChangedDirectBuying(flag, block.timestamp);
    }

    /**
    * @dev Buy Satoshi allottment by paying equivalant supported stablecoins
    * An allotment with default plan is granted. Tokens are released based
    * on the allotment plan release cycle. Users should call release() in
    * allotment contract to withdraw the tokens available for release.
    *
    * @param amountInWei - Amount of Satoshi Token to be bought
    * @param token - Supported stablecoin address for making payment
    * Requirements:
    *
    * - amountInWei should be greated than 0
    * - token address should be non-zero
    */
    function buySatoshiAllotment(uint256 amountInWei, address token) external onlySupportedToken(token) {
        // Verify whether default plan is configured
        require(_defaultPlanId != ~uint256(0), "SatoshiExchange: default plan not configured");

        require(amountInWei > 0, "SatoshiExchange: amount is zero");
        require(token != address(_satoshiToken), "SatoshiExchange: cannot buy using satoshi");

        uint256 tokenAmount = convertSatoshiToTokenAmount(amountInWei, token);

        // Receive respective amount of supported stablecoin tokens from the msg.sender
        IERC20(token).safeTransferFrom(_msgSender(), address(this), tokenAmount);

        // Grant allotment to the msg.sender
        uint64 id = _satoshiAllotment.grantAllotment(
                        _msgSender(),
                        amountInWei,
                        (uint32)(block.timestamp),
                        _defaultPlanId
                    );

        emit SatoshiAllotmentBought(_msgSender(), id, amountInWei, token, tokenAmount, block.timestamp);
    }

    /**
    * @dev Sell Satoshi token to receive equivalant supported stablecoins
    *
    * @param amountInWei - Amount of Satoshi Token to be sold
    * @param token - Supported stablecoin address for receiving payment
    * Requirements:
    *
    * - amountInWei should be greated than 0
    * - token address should be non-zero
    */
    function sellSatoshi(uint256 amountInWei, address token) external onlySupportedToken(token) {
        require(amountInWei > 0, "SatoshiExchange: amount is zero");
        require(token != address(_satoshiToken), "SatoshiExchange: cannot sell using satoshi");

        uint256 fee = amountInWei.mul(_sellFeePercentInWei).div(100).div(10**18);
        // Apply fees
        uint256 amountAfterFees = amountInWei - fee;

        uint256 tokenAmount = convertSatoshiToTokenAmount(amountAfterFees, token);

        require(tokenAmount > 0, "SatoshiExchange: converted amount is zero");

        // Burn Satoshi Token from msg.sender account
        _satoshiToken.burnFrom(_msgSender(), amountInWei);

        // Transfer respective amount of supported stablecoin tokens to the msg.sender
        IERC20(token).safeTransfer(_msgSender(), tokenAmount);

        emit SatoshiSold(_msgSender(), amountInWei, token, tokenAmount, fee, block.timestamp);
    }

    /**
    * @dev Buy Satoshi directly
    *
    * @param amountInWei - Amount of Satoshi Token to be bought
    * @param token - Supported stablecoin address for making payment
    *
    * Requirements:
    *
    * - amountInWei should be greated than 0
    * - direct buy should have been enabled
    */
    function buySatoshiDirect(uint256 amountInWei, address token) external onlySupportedToken(token) {
        require(amountInWei > 0, "SatoshiExchange: amount is zero");
        require(token != address(_satoshiToken), "SatoshiExchange: cannot buy using satoshi");

        require(_enableDirectBuying == true, "SatoshiExchange: direct buying is disabled");

        uint256 fee = amountInWei.mul(_buyFeePercentInWei).div(100).div(10**18);
        // Apply fees
        uint256 amountAfterFees = amountInWei + fee;

        uint256 tokenAmount = convertSatoshiToTokenAmount(amountAfterFees, token);

        // Receive respective amount of supported stablecoin tokens from the msg.sender
        IERC20(token).safeTransferFrom(_msgSender(), address(this), tokenAmount);

        // Mint Satoshi Token to msg.sender account
        _satoshiToken.mint(_msgSender(), amountInWei);

        emit SatoshiBought(_msgSender(), amountInWei, token, tokenAmount, block.timestamp);
    }

    /**
    * @dev Allows owner to change the withdrawal wallet address
    *
    * @param newWallet New wallet address
    * Requirements:
    *
    * - the caller must have the admin role.
    */
    function changeWallet(address payable newWallet) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "SatoshiExchange: must have admin role to change wallet"
        );
        require(newWallet != address(0), "SatoshiExchange: wallet is zero address");

        _wallet = newWallet;
        emit WalletChanged(newWallet);
    }

    /**
    * @dev Deposit Satoshi tokens of the user and log an event
    *
    * @param depositKey - An unique key to identify the desposit
    * @param depositAmount - Amount of tokens to transfer from user account
    * @param token - Address of the supported token
    *
    * Requirements:
    * - only supported tokens are allowed for deposit
    * - deposit amount should be greater than zero
    *
    */
    function depositTokens(
        string calldata depositKey,
        uint256 depositAmount,
        address token) external onlySupportedToken(token) {

        require(depositAmount != 0, "SatoshiDeposit: deposit amount is zero");

        // Receive respective amount of supported tokens from the msg.sender
        IERC20(token).safeTransferFrom(_msgSender(), address(this), depositAmount);

        emit TokenDeposited(_msgSender(), depositKey, depositAmount, token, block.timestamp);
    }

    /**
    * @dev Deposit ether of the user and log an event
    *
    * @param depositKey - An unique key to identify the desposit
    *
    * Requirements:
    * - only supported tokens are allowed for deposit
    * - deposit amount should be greater than zero
    *
    */
    function depositEth(string calldata depositKey) external payable {

        require(msg.value != 0, "SatoshiDeposit: ether deposit amount is zero");

        emit EthDeposited(_msgSender(), depositKey, msg.value, block.timestamp);
    }

    /**
    * @dev Allows owner to withdraw tokens from contract
    *
    * @param token Token for which funds will be withdrawn
    * @param amount Amount of tokens to be withdrawn
    * Requirements:
    *
    * - the caller must have the admin role.
    */
    function withdrawTokens(uint256 amount, address token) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "SatoshiExchange: must have admin role to withdraw tokens"
        );
        require(token != address(0), "SatoshiExchange: token is zero address");
        require(_wallet != address(0), "SatoshiExchange: wallet is zero address");

        require(amount > 0, "SatoshiExchange: amount is zero");

        IERC20(token).transfer(
            _wallet,
            amount
        );
        emit TokensWithdrawn(token, amount, block.timestamp);
    }

    /**
    * @dev Allows owner to withdraw ether from contract
    *
    *
    * Requirements:
    *
    * - the caller must have the admin role.
    */
    function withdrawEth() external {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "SatoshiExchange: must have admin role to withdraw eth"
        );

        require(_wallet != address(0), "SatoshiExchange: wallet is zero address");

        uint256 balance = address(this).balance;

        _wallet.transfer(address(this).balance);

        emit EthWithdrawn(balance, block.timestamp);
    }
}