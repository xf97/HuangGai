/**
 *Submitted for verification at Etherscan.io on 2020-05-09
*/

// File: @openzeppelin/contracts/GSN/Context.sol

pragma solidity ^0.6.0;

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

    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol

pragma solidity ^0.6.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: @openzeppelin/contracts/utils/EnumerableSet.sol

pragma solidity ^0.6.0;

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
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
 * (`UintSet`) are supported.
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint256(_at(set._inner, index)));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
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

// File: @openzeppelin/contracts/access/AccessControl.sol

pragma solidity ^0.6.0;




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
abstract contract AccessControl is Context {
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
        return _roles[role].members.at(index);
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
    function grantRole(bytes32 role, address account) public virtual {
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
    function revokeRole(bytes32 role, address account) public virtual {
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
    function renounceRole(bytes32 role, address account) public virtual {
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
    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
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

// File: @animoca/ethereum-contracts-core_library/contracts/access/MinterRole.sol

pragma solidity ^0.6.6;


contract MinterRole is AccessControl {

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    constructor () internal {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        emit MinterAdded(_msgSender());
    }

    modifier onlyMinter() {
        require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
        _;
    }

    function isMinter(address account) public view returns (bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, account);
    }

    function addMinter(address account) public onlyMinter {
        grantRole(DEFAULT_ADMIN_ROLE, account);
        emit MinterAdded(account);
    }

    function renounceMinter() public {
        renounceRole(DEFAULT_ADMIN_ROLE, _msgSender());
        emit MinterRemoved(_msgSender());
    }

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

// File: @openzeppelin/contracts/introspection/IERC165.sol

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC721/IERC721Receiver.sol

pragma solidity ^0.6.6;

/**
    @title ERC721 Non-Fungible Token Standard, token receiver
    @dev See https://eips.ethereum.org/EIPS/eip-721
    Interface for any contract that wants to support safeTransfers from ERC721 asset contracts.
    Note: The ERC-165 identifier for this interface is 0x150b7a02.
 */
abstract contract IERC721Receiver {

    //bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))
    bytes4 constant internal ERC721_RECEIVED = 0x150b7a02;

    /**
        @notice Handle the receipt of an NFT
        @dev The ERC721 smart contract calls this function on the recipient
        after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
        otherwise the caller will revert the transaction. The selector to be
        returned can be obtained as `this.onERC721Received.selector`. This
        function MAY throw to revert and reject the transfer.
        Note: the ERC721 contract address is always the message sender.
        @param operator The address which called `safeTransferFrom` function
        @param from The address which previously owned the token
        @param tokenId The NFT identifier which is being transferred
        @param data Additional data with no specified format
        @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
     */
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data
    ) external virtual returns (bytes4);
}

// File: @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC721/IERC721.sol

pragma solidity ^0.6.6;

 /**
    @title ERC721 Non-Fungible Token Standard, basic interface
    @dev See https://eips.ethereum.org/EIPS/eip-721
    Note: The ERC-165 identifier for this interface is 0x80ac58cd.
 */
interface IERC721 {
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );

    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );

    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    /**
     * @dev Gets the balance of the specified address
     * @param owner address to query the balance of
     * @return balance uint256 representing the amount owned by the passed address
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Gets the owner of the specified ID
     * @param tokenId uint256 ID to query the owner of
     * @return owner address currently marked as the owner of the given ID
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Approves another address to transfer the given token ID
     * The zero address indicates there is no approved address.
     * There can only be one approved address per token at a given time.
     * Can only be called by the token owner or an approved operator.
     * @param to address to be approved for the given token ID
     * @param tokenId uint256 ID of the token to be approved
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Gets the approved address for a token ID, or zero if no address set
     * Reverts if the token ID does not exist.
     * @param tokenId uint256 ID of the token to query the approval of
     * @return operator address currently approved for the given token ID
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Sets or unsets the approval of a given operator
     * An operator is allowed to transfer all tokens of the sender on their behalf
     * @param operator operator address to set the approval
     * @param approved representing the status of the approval to be set
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Tells whether an operator is approved by a given owner
     * @param owner owner address which you want to query the approval of
     * @param operator operator address which you want to query the approval of
     * @return bool whether the given operator is approved by the given owner
     */
    function isApprovedForAll(address owner,address operator) external view returns (bool);

    /**
     * @dev Transfers the ownership of a given token ID to another address
     * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
    */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     *
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
    */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     *
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     * @param data bytes data to send along with a safe transfer check
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

// File: @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC721/IERC721Metadata.sol

pragma solidity ^0.6.6;

 /**
    @title ERC721 Non-Fungible Token Standard, optional metadata extension
    @dev See https://eips.ethereum.org/EIPS/eip-721
    Note: The ERC-165 identifier for this interface is 0x5b5e139f.
 */
interface IERC721Metadata {

    /**
     * @dev Gets the token name
     * @return string representing the token name
     */
    function name() external view returns (string memory);

    /**
     * @dev Gets the token symbol
     * @return string representing the token symbol
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns an URI for a given token ID
     * Throws if the token ID does not exist. May return an empty string.
     * @param tokenId uint256 ID of the token to query
     * @return string URI of given token ID
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

// File: @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155.sol

pragma solidity ^0.6.6;

/**
    @title ERC-1155 Multi Token Standard, basic interface
    @dev See https://eips.ethereum.org/EIPS/eip-1155
    Note: The ERC-165 identifier for this interface is 0xd9b67a26.
 */
interface IERC1155 {

    event TransferSingle(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256 _id,
        uint256 _value
    );

    event TransferBatch(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256[] _ids,
        uint256[] _values
    );

    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    event URI(
        string _value,
        uint256 indexed _id
    );

    /**
        @notice Transfers `value` amount of an `id` from  `from` to `to`  (with safety call).
        @dev Caller must be approved to manage the tokens being transferred out of the `from` account (see "Approval" section of the standard).
        MUST revert if `to` is the zero address.
        MUST revert if balance of holder for token `id` is lower than the `value` sent.
        MUST revert on any other error.
        MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
        After the above conditions are met, this function MUST check if `to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `to` and act appropriately (see "Safe Transfer Rules" section of the standard).
        @param from    Source address
        @param to      Target address
        @param id      ID of the token type
        @param value   Transfer amount
        @param data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `to`
    */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external;

    /**
        @notice Transfers `values` amount(s) of `ids` from the `from` address to the `to` address specified (with safety call).
        @dev Caller must be approved to manage the tokens being transferred out of the `from` account (see "Approval" section of the standard).
        MUST revert if `to` is the zero address.
        MUST revert if length of `ids` is not the same as length of `values`.
        MUST revert if any of the balance(s) of the holder(s) for token(s) in `ids` is lower than the respective amount(s) in `values` sent to the recipient.
        MUST revert on any other error.
        MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
        Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
        After the above conditions for the transfer(s) in the batch are met, this function MUST check if `to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `to` and act appropriately (see "Safe Transfer Rules" section of the standard).
        @param from    Source address
        @param to      Target address
        @param ids     IDs of each token type (order and length must match _values array)
        @param values  Transfer amounts per token type (order and length must match _ids array)
        @param data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `to`
    */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external;

    /**
        @notice Get the balance of an account's tokens.
        @param owner  The address of the token holder
        @param id     ID of the token
        @return        The _owner's balance of the token type requested
     */
    function balanceOf(address owner, uint256 id) external view returns (uint256);

    /**
        @notice Get the balance of multiple account/token pairs
        @param owners The addresses of the token holders
        @param ids    ID of the tokens
        @return        The _owner's balance of the token types requested (i.e. balance for each (owner, id) pair)
     */
    function balanceOfBatch(
        address[] calldata owners,
        uint256[] calldata ids
    ) external view returns (uint256[] memory);

    /**
        @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
        @dev MUST emit the ApprovalForAll event on success.
        @param operator  Address to add to the set of authorized operators
        @param approved  True if the operator is approved, false to revoke approval
    */
    function setApprovalForAll(address operator, bool approved) external;

    /**
        @notice Queries the approval status of an operator for a given owner.
        @param owner     The owner of the tokens
        @param operator  Address of authorized operator
        @return           True if the operator is approved, false if not
    */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// File: @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155MetadataURI.sol

pragma solidity ^0.6.6;

/**
    @title ERC-1155 Multi Token Standard, optional metadata URI extension
    @dev See https://eips.ethereum.org/EIPS/eip-1155
    Note: The ERC-165 identifier for this interface is 0x0e89341c.
 */
interface IERC1155MetadataURI {
    /**
        @notice A distinct Uniform Resource Identifier (URI) for a given token.
        @dev URIs are defined in RFC 3986.
        The URI MUST point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
        The uri function SHOULD be used to retrieve values if no event was emitted.
        The uri function MUST return the same value as the latest event for an _id if it was emitted.
        The uri function MUST NOT be used to check for the existence of a token as it is possible for an implementation to return a valid string even if the token does not exist.
        @return URI string
    */
    function uri(uint256 id) external view returns (string memory);
}

// File: @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155AssetCollections.sol

pragma solidity ^0.6.6;

/**
    @title ERC-1155 Multi Token Standard, optional Asset Collections extension
    @dev See https://eips.ethereum.org/EIPS/eip-xxxx
    Interface for fungible/non-fungible collections management on a 1155-compliant contract.
    This proposal attempts to rationalize the co-existence of fungible and non-fungible tokens
    within the same contract. We consider that there can be up to several:
    (a) Fungible Collections, each representing a supply of fungible token,
    (b) Non-Fungible Collections, each representing a set of non-fungible tokens,
    (c) Non-Fungible Tokens.

    `balanceOf` and `balanceOfBatch`:
    - when applied to a Non-Fungible Collection, MAY return the balance of Non-Fungible Tokens for this collection,
    - when applied to a Non-Fungible Token, SHOULD return 1.

    Note: The ERC-165 identifier for this interface is 0x09ce5c46.
 */
interface IERC1155AssetCollections {

    /**
        @dev Returns the parent collection ID of a Non-Fungible Token ID.
        This function returns either a Fungible Collection ID or a Non-Fungible Collection ID.
        This function SHOULD NOT be used to check the existence of a Non-Fungible Token.
        This function MAY return a value for a non-existing Non-Fungible Token.
        @param id The ID to query. id must represent an existing/non-existing Non-Fungible Token, else it throws.
        @return uint256 the parent collection ID.
     */
    function collectionOf(uint256 id) external view returns (uint256);

    /**
        @dev Returns whether or not an ID represents a Fungible Collection.
        @param id The ID to query.
        @return bool true if id represents a Fungible Collection, false otherwise.
    */
    function isFungible(uint256 id) external view returns (bool);

    /**
       @dev Returns the owner of a Non-Fungible Token.
       @param tokenId The ID to query. MUST represent an existing Non-Fungible Token, else it throws.
       @return owner address currently marked as the owner of the Non-Fungible Token.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);
}

// File: @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155TokenReceiver.sol

pragma solidity ^0.6.6;

/**
    @title ERC-1155 Multi Token Standard, token receiver
    @dev See https://eips.ethereum.org/EIPS/eip-1155
    Interface for any contract that wants to support transfers from ERC1155 asset contracts.
    Note: The ERC-165 identifier for this interface is 0x4e2312e0.
 */
abstract contract IERC1155TokenReceiver {

    // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
    bytes4 constant internal ERC1155_RECEIVED = 0xf23a6e61;

    // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
    bytes4 constant internal ERC1155_BATCH_RECEIVED = 0xbc197c81;

    /**
        @notice Handle the receipt of a single ERC1155 token type.
        @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
        This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
        This function MUST revert if it rejects the transfer.
        Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
        @param operator  The address which initiated the transfer (i.e. msg.sender)
        @param from      The address which previously owned the token
        @param id        The ID of the token being transferred
        @param value     The amount of tokens being transferred
        @param data      Additional data with no specified format
        @return bytes4   `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
    */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external virtual returns (bytes4);

    /**
        @notice Handle the receipt of multiple ERC1155 token types.
        @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
        This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
        This function MUST revert if it rejects the transfer(s).
        Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
        @param operator  The address which initiated the batch transfer (i.e. msg.sender)
        @param from      The address which previously owned the token
        @param ids       An array containing ids of each token being transferred (order and length must match _values array)
        @param values    An array containing amounts of each token being transferred (order and length must match _ids array)
        @param data      Additional data with no specified format
        @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
    */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external virtual returns (bytes4);
}

// File: @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155721/AssetsInventory.sol

pragma solidity ^0.6.6;












/**
    @title AssetsInventory, a contract which manages up to multiple collections of fungible and non-fungible tokens
    @dev In this implementation, with N representing the non-fungible bitmask length, IDs are composed as follow:
    (a) Fungible Collection IDs:
        - most significant bit == 0
    (b) Non-Fungible Collection IDs:
        - most significant bit == 1
        - (256-N) least significant bits == 0
    (c) Non-Fungible Token IDs:
        - most significant bit == 1
        - (256-N) least significant bits != 0

    If non-fungible bitmask length == 1, there is one Non-Fungible Collection represented by the most significant bit set to 1 and other bits set to 0.
    If non-fungible bitmask length > 1, there are multiple Non-Fungible Collections.
 */
abstract contract AssetsInventory is IERC165, IERC721, IERC721Metadata, IERC1155, IERC1155MetadataURI, IERC1155AssetCollections, Context
{
    //bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))
    bytes4 constant internal ERC721_RECEIVED = 0x150b7a02;

    // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
    bytes4 constant internal ERC1155_RECEIVED = 0xf23a6e61;

    // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
    bytes4 constant internal ERC1155_BATCH_RECEIVED = 0xbc197c81;

    // bytes4(keccak256("supportsInterface(bytes4)"))
    bytes4 constant internal ERC165_InterfaceId = 0x01ffc9a7;

    bytes4 constant internal ERC1155TokenReceiver_InterfaceId = 0x4e2312e0;

    // id (collection) => owner => balance
    mapping(uint256 => mapping(address => uint256)) internal _balances;

    // owner => operator => approved
    mapping(address => mapping(address => bool)) internal _operatorApprovals;

    // id (nft) => operator
    mapping(uint256 => address) internal _tokenApprovals;

    // id (collection or nft) => owner
    mapping(uint256 => address) internal _owners;

    // owner => nb nfts owned
    mapping(address => uint256) internal _nftBalances;

    // Mask for the non-fungible flag in ids
    uint256 internal constant NF_BIT_MASK = 1 << 255;

    // Mask for non-fungible collection in ids (it includes the nf bit)
    uint256 internal NF_COLLECTION_MASK;

    /**
     * @dev Constructor function
     * @param nfMaskLength number of bits in the Non-Fungible Collection mask
     */
    constructor(uint256 nfMaskLength) internal {
        require(nfMaskLength > 0 && nfMaskLength < 256);
        uint256 mask = (1 << nfMaskLength) - 1;
        mask = mask << (256 - nfMaskLength);
        NF_COLLECTION_MASK = mask;
    }

    function _uri(uint256 id) internal virtual view returns(string memory);

/////////////////////////////////////////// ERC165 /////////////////////////////////////////////

    /**
     * @dev Check if support an interface id
     * @param interfaceId interface id to query
     * @return bool if support the given interface id
     */
    function supportsInterface(bytes4 interfaceId) external virtual override view returns (bool) {
        return (
            // ERC165 interface id
            interfaceId == 0x01ffc9a7 ||
            // ERC721 interface id
            interfaceId == 0x80ac58cd ||
            // ERC721Metadata interface id
            interfaceId == 0x5b5e139f ||
            // ERC721Exists interface id
            interfaceId == 0x4f558e79 ||
            // ERC1155 interface id
            interfaceId == 0xd9b67a26 ||
            // ERC1155MetadataURI interface id
            interfaceId == 0x0e89341c ||
            // ERC1155AssetCollections interface id
            interfaceId == 0x09ce5c46
        );
    }
/////////////////////////////////////////// ERC721 /////////////////////////////////////////////

    function balanceOf(address tokenOwner) public virtual override view returns (uint256) {
        require(tokenOwner != address(0x0));
        return _nftBalances[tokenOwner];
    }

    function ownerOf(uint256 tokenId) public virtual override(IERC1155AssetCollections, IERC721) view returns (address) {
        require(isNFT(tokenId));
        address tokenOwner = _owners[tokenId];
        require(tokenOwner != address(0x0));
        return tokenOwner;
    }

    function approve(address to, uint256 tokenId) public virtual override {
        address tokenOwner = ownerOf(tokenId);
        require(to != tokenOwner); // solium-disable-line error-reason

        address sender = _msgSender();
        require(sender == tokenOwner || _operatorApprovals[tokenOwner][sender]); // solium-disable-line error-reason

        _tokenApprovals[tokenId] = to;
        emit Approval(tokenOwner, to, tokenId);
    }

    function getApproved(uint256 tokenId) public virtual override view returns (address) {
        require(isNFT(tokenId) && exists(tokenId));
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address to, bool approved) public virtual override(IERC1155, IERC721) {
        address sender = _msgSender();
        require(to != sender);
        _setApprovalForAll(sender, to, approved);
    }

    function _setApprovalForAll(address sender, address operator, bool approved) internal virtual {
        _operatorApprovals[sender][operator] = approved;
        emit ApprovalForAll(sender, operator, approved);
    }

    function isApprovedForAll(address tokenOwner, address operator) public virtual override(IERC1155, IERC721) view returns (bool) {
        return _operatorApprovals[tokenOwner][operator];
    }

    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        _transferFrom(from, to, tokenId, "", false);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
        _transferFrom(from, to, tokenId, "", true);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
        _transferFrom(from, to, tokenId, data, true);
    }

    function tokenURI(uint256 tokenId) external virtual override view returns (string memory) {
        require(exists(tokenId));
        return _uri(tokenId);
    }

/////////////////////////////////////////// ERC1155 /////////////////////////////////////////////

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes memory data
    ) public virtual override
    {
        address sender = _msgSender();
        bool operatable = (from == sender || _operatorApprovals[from][sender] == true);

        if (isFungible(id) && value > 0) {
            require(operatable);
            _transferFungible(from, to, id, value);
        } else if (isNFT(id) && value == 1) {
            _transferNonFungible(from, to, id, operatable);
            emit Transfer(from, to, id);
        } else {
            revert();
        }

        emit TransferSingle(sender, from, to, id, value);
        require(_checkERC1155AndCallSafeTransfer(sender, from, to, id, value, data, false, false));
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) public virtual override
    {
        require(ids.length == values.length);

        // Only supporting a global operator approval allows to do a single check and not to touch storage to handle allowances.
        address sender = _msgSender();
        require(from == sender || _operatorApprovals[from][sender] == true);

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            uint256 value = values[i];

            if (isFungible(id) && value > 0) {
                _transferFungible(from, to, id, value);
            } else if (isNFT(id) && value == 1) {
                _transferNonFungible(from, to, id, true);
                emit Transfer(from, to, id);
            } else {
                revert();
            }
        }

        emit TransferBatch(sender, from, to, ids, values);
        require(_checkERC1155AndCallSafeBatchTransfer(sender, from, to, ids, values, data));
    }

    function balanceOf(address tokenOwner, uint256 id) public virtual override view returns (uint256) {
        require(tokenOwner != address(0x0));

        if (isNFT(id)) {
            return _owners[id] == tokenOwner ? 1 : 0;
        }

        return _balances[id][tokenOwner];
    }

    function balanceOfBatch(
        address[] memory tokenOwners,
        uint256[] memory ids
    ) public virtual override view returns (uint256[] memory)
    {
        require(tokenOwners.length == ids.length);

        uint256[] memory balances = new uint256[](tokenOwners.length);

        for (uint256 i = 0; i < tokenOwners.length; ++i) {
            require(tokenOwners[i] != address(0x0));

            uint256 id = ids[i];

            if (isNFT(id)) {
                balances[i] = _owners[id] == tokenOwners[i] ? 1 : 0;
            } else {
                balances[i] = _balances[id][tokenOwners[i]];
            }
        }

        return balances;
    }

    /**
     * @dev Returns an URI for a given ID
     * Throws if the ID does not exist. May return an empty string.
     * @param id uint256 ID of the tokenId / collectionId to query
     * @return string URI of given ID
     */
    function uri(uint256 id) external virtual override view returns (string memory) {
        return _uri(id);
    }

/////////////////////////////////////////// ERC1155AssetCollections /////////////////////////////////////////////

    function collectionOf(uint256 id) public virtual override view returns (uint256) {
        require(isNFT(id));
        return id & NF_COLLECTION_MASK;
    }

    /**
        @dev Tells whether an id represents a fungible collection
        @param id The ID to query
        @return bool whether the given id is fungible
     */
    function isFungible(uint256 id) public virtual override view returns (bool) {
        return id & (NF_BIT_MASK) == 0;
    }

    /**
        @dev Tells whether an id represents a non-fungible token
        @param id The ID to query
        @return bool whether the given id is non-fungible token
     */
    function isNFT(uint256 id) internal virtual view returns (bool) {
        // A base type has the NF bit and an index
        return (id & (NF_BIT_MASK) != 0) && (id & (~NF_COLLECTION_MASK) != 0);
    }

    /**
     * @dev Returns whether the NFT belongs to someone
     * @param id uint256 ID of the NFT
     * @return whether the NFT belongs to someone
     */
    function exists(uint256 id) public virtual view returns (bool) {
        address tokenOwner = _owners[id];
        return tokenOwner != address(0x0);
    }

/////////////////////////////////////////// Transfer Internal Functions ///////////////////////////////////////

    /**
     * @dev Internal function to transfer the ownership of a given NFT to another address
     * Emits Transfer and TransferSingle events
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     * @param safe bool to indicate whether the transfer is safe
    */
    function _transferFrom(address from, address to, uint256 tokenId, bytes memory data, bool safe) internal virtual {
        require(isNFT(tokenId));

        address sender = _msgSender();
        bool operatable = (from == sender || _operatorApprovals[from][sender] == true);

        _transferNonFungible(from, to, tokenId, operatable);

        emit Transfer(from, to, tokenId);
        emit TransferSingle(sender, from, to, tokenId, 1);

        require(_checkERC1155AndCallSafeTransfer(sender, from, to, tokenId, 1, data, true, safe));
    }

    /**
     * @dev Internal function to transfer the ownership of a given token ID to another address
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param id uint256 ID of the token to be transferred
     * @param operatable bool to indicate whether the msg sender is operator
    */
    function _transferNonFungible(address from, address to, uint256 id, bool operatable) internal virtual {
        require(from == _owners[id]);

        address sender = _msgSender();
        require(operatable || ownerOf(id) == sender || getApproved(id) == sender);

        // clear approval
        if (_tokenApprovals[id] != address(0x0)) {
            _tokenApprovals[id] = address(0x0);
        }

        uint256 nfCollection = id & NF_COLLECTION_MASK;
        _balances[nfCollection][from] = SafeMath.sub(_balances[nfCollection][from], 1);
        _nftBalances[from] = SafeMath.sub(_nftBalances[from], 1);

        _owners[id] = to;

        if (to != address(0x0)) {
            _balances[nfCollection][to] = SafeMath.add(_balances[nfCollection][to], 1);
            _nftBalances[to] = SafeMath.add(_nftBalances[to], 1);
        }
    }

    /**
     * @dev Internal function to move `collectionId` fungible tokens `value` from `from` to `to`.
     * @param from current owner of the `collectionId` fungible token
     * @param to address to receive the ownership of the given `collectionId` fungible token
     * @param collectionId uint256 ID of the fungible token to be transferred
     * @param value uint256 transfer amount
     */
    function _transferFungible(address from, address to, uint256 collectionId, uint256 value) internal virtual {
        _balances[collectionId][from] = SafeMath.sub(_balances[collectionId][from], value);

        if (to != address(0x0)) {
            _balances[collectionId][to] = SafeMath.add(_balances[collectionId][to], value);
        }
    }

/////////////////////////////////////////// Minting ///////////////////////////////////////

    /**
     * @dev Internal function to mint one non fungible token
     * Reverts if the given nft id already exists
     * @param to address recipient that will own the minted tokens
     * @param id uint256 ID of the token to be minted
     */
    function _mintNonFungible(address to, uint256 id, bool typeChecked) internal virtual {
        require(to != address(0x0));
        if (!typeChecked) {
            require(isNFT(id));
        }
        require(!exists(id));

        uint256 collection = id & NF_COLLECTION_MASK;

        _owners[id] = to;
        _nftBalances[to] = SafeMath.add(_nftBalances[to], 1);
        _balances[collection][to] = SafeMath.add(_balances[collection][to], 1);

        emit Transfer(address(0x0), to, id);
        emit TransferSingle(_msgSender(), address(0x0), to, id, 1);

        emit URI(_uri(id), id);

        require(
            _checkERC1155AndCallSafeTransfer(_msgSender(), address(0x0), to, id, 1, "", false, false), "failCheck"
        );
    }

    /**
     * @dev Internal function to mint fungible token
     * @param to address recipient that will own the minted tokens
     * @param collection uint256 fungible collection id
     * @param value uint256 amount to mint
     */
    function _mintFungible(address to, uint256 collection, uint256 value, bool typeChecked) internal virtual {
        require(to != address(0x0));
        if (!typeChecked) {
            require(isFungible(collection));
        }
        require(value > 0);

        _balances[collection][to] = SafeMath.add(_balances[collection][to], value);

        emit TransferSingle(_msgSender(), address(0x0), to, collection, value);

        require(
            _checkERC1155AndCallSafeTransfer(_msgSender(), address(0x0), to, collection, value, "", false, false), "failCheck"
        );
    }

/////////////////////////////////////////// Receiver Internal Functions ///////////////////////////////////////

    /**
     * @dev public function to invoke `onERC721Received` on a target address
     * The call is not executed if the target address is not a contract
     * @param operator transfer msg sender
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the token
     * @param tokenId uint256 ID of the token to be transferred
     * @param data bytes optional data to send along with the call
     * @return whether the call correctly returned the expected magic value
     */
    function _checkERC721AndCallSafeTransfer(
        address operator,
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal returns(bool)
    {
        if (!Address.isContract(to)) {
            return true;
        }
        return IERC721Receiver(to).onERC721Received(operator, from, tokenId, data) == ERC721_RECEIVED;
    }

    /**
     * @dev public function to invoke `onERC1155Received` on a target address
     * The call is not executed if the target address is not a contract
     * @param operator transfer msg sender
     * @param from address representing the previous owner of the given ID
     * @param to target address that will receive the token
     * @param id uint256 ID of the `non-fungible token / non-fungible collection / fungible collection` to be transferred
     * @param data bytes optional data to send along with the call
     * @param erc721 bool whether transfer to ERC721 contract
     * @param erc721Safe bool whether transfer to ERC721 contract safely
     * @return whether the call correctly returned the expected magic value
     */
    function _checkERC1155AndCallSafeTransfer(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes memory data,
        bool erc721,
        bool erc721Safe
    ) internal returns (bool)
    {
        if (!Address.isContract(to)) {
            return true;
        }
        if (erc721) {
            if (!_checkIsERC1155Receiver(to)) {
                if (erc721Safe) {
                    return _checkERC721AndCallSafeTransfer(operator, from, to, id, data);
                } else {
                    return true;
                }
            }
        }
        return IERC1155TokenReceiver(to).onERC1155Received(operator, from, id, value, data) == ERC1155_RECEIVED;
    }

    /**
     * @dev internal function to invoke `onERC1155BatchReceived` on a target address
     * The call is not executed if the target address is not a contract
     * @param operator transfer msg sender
     * @param from address representing the previous owner of the given IDs
     * @param to target address that will receive the tokens
     * @param ids uint256 ID of the `non-fungible token / non-fungible collection / fungible collection` to be transferred
     * @param values uint256 transfer amounts of the `non-fungible token / non-fungible collection / fungible collection`
     * @param data bytes optional data to send along with the call
     * @return whether the call correctly returned the expected magic value
     */
    function _checkERC1155AndCallSafeBatchTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) internal returns (bool)
    {
        if (!Address.isContract(to)) {
            return true;
        }
        return IERC1155TokenReceiver(to).onERC1155BatchReceived(operator, from, ids, values, data) == ERC1155_BATCH_RECEIVED;
    }

    /**
     * @dev internal function to tell whether a contract is an ERC1155 Receiver contract
     * @param _contract address query contract addrss
     * @return wheter the given contract is an ERC1155 Receiver contract
     */
    function _checkIsERC1155Receiver(address _contract) internal view returns(bool) {
        bool success;
        uint256 result;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            let x:= mload(0x40)               // Find empty storage location using "free memory pointer"
            mstore(x, ERC165_InterfaceId)                // Place signature at beginning of empty storage
            mstore(add(x, 0x04), ERC1155TokenReceiver_InterfaceId) // Place first argument directly next to signature

            success:= staticcall(
                10000,          // 10k gas
                _contract,     // To addr
                x,             // Inputs are stored at location x
                0x24,          // Inputs are 36 bytes long
                x,             // Store output over input (saves space)
                0x20)          // Outputs are 32 bytes long

            result:= mload(x)                 // Load the result
        }
        // (10000 / 63) "not enough for supportsInterface(...)" // consume all gas, so caller can potentially know that there was not enough gas
        assert(gasleft() > 158);
        return success && result == 1;
    }
}

// File: @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155721/NonBurnableInventory.sol

pragma solidity ^0.6.6;


/**
    @title NonBurnableInventory, a non-burnable inventory contract
 */
abstract contract NonBurnableInventory is AssetsInventory
{

    constructor(uint256 nfMaskLength) internal AssetsInventory(nfMaskLength)  {}

    modifier notZero(address addr) {
        require(addr != address(0x0));
        _;
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes memory data
    ) public virtual override notZero(to) {
        super.safeTransferFrom(from, to, id, value, data);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) public virtual override notZero(to) {
        super.safeBatchTransferFrom(from, to, ids, values, data);
    }

    function _transferFrom(address from, address to, uint256 tokenId, bytes memory data, bool safe
    ) internal virtual override notZero(to) {
        super._transferFrom(from, to, tokenId, data, safe);
    }
}

// File: @animoca/ethereum-contracts-core_library/contracts/utils/RichUInt256.sol

pragma solidity ^0.6.6;

library RichUInt256 {

    function toString(uint256 i) internal pure returns (string memory) {
        return toString(i, 10);
    }

    function toString(uint256 i, uint8 base) internal pure returns (string memory) {
        if (base == 10) {
            return toDecimalString(i);
        } else if (base == 16) {
            return toHexString(i);
        } else {
            revert("Base must be either 10 or 16");
        }
    }

    function toDecimalString(uint256 i) internal pure returns (string memory) {
        if (i == 0) {
            return "0";
        }

        uint256 j = i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }

        bytes memory bstr = new bytes(len);
        uint256 k = len - 1;
        while (i != 0) {
            bstr[k--] = bytes1(uint8(48 + (i % 10)));
            i /= 10;
        }

        return string(bstr);
    }

    function toHexString(uint256 i) internal pure returns (string memory) {
        uint length = 64;
        uint mask = 15;
        bytes memory bstr = new bytes(length);
        int k = int(length - 1);
        while (i != 0) {
            uint curr = (i & mask);
            bstr[uint(k--)] = curr > 9 ? byte(uint8(87 + curr)) : byte(uint8(48 + curr)); // 87 = 97 - 10
            i = i >> 4;
        }
        while (k >= 0) {
            bstr[uint(k--)] = byte(uint8(48));
        }
        return string(bstr);
    }
}

// File: @animoca/ethereum-contracts-assets_inventory/contracts/mocks/token/ERC1155721/URI.sol

pragma solidity ^0.6.6;


contract URI {

    using RichUInt256 for uint256;

    /**
     * @dev Internal function to convert id to full uri string
     * @param id uint256 ID to convert
     * @return string URI convert from given ID
     */
    function _fullUriFromId(uint256 id) internal pure returns (string memory) {
        return string(abi.encodePacked("https://prefix/json/", id.toString()));
    }

}

// File: @animoca/ethereum-contracts-assets_inventory/contracts/mocks/token/ERC1155721/NonBurnableInventoryMock.sol

pragma solidity ^0.6.6;





contract NonBurnableInventoryMock is NonBurnableInventory, Ownable, MinterRole, URI {

    string public override constant name = "NonBurnableInventoryMock";
    string public override constant symbol = "NBIM";

    constructor(uint256 nfMaskLength) public NonBurnableInventory(nfMaskLength) {}

    /**
     * @dev This function creates the collection id.
     * @param collectionId collection identifier
     */
    function createCollection(uint256 collectionId) onlyOwner external {
        require(!isNFT(collectionId));
        emit URI(_uri(collectionId), collectionId);
    }

    /**
     * @dev Public function to mint a batch of new tokens
     * Reverts if some the given token IDs already exist
     * @param to address[] List of addresses that will own the minted tokens
     * @param ids uint256[] List of ids of the tokens to be minted
     * @param values uint256[] List of quantities of ft to be minted
     */
    function batchMint(address[] calldata to, uint256[] calldata ids, uint256[] calldata values) external onlyMinter {
        require(ids.length == to.length &&
            ids.length == values.length,
            "parameter length inconsistent");

        for (uint i = 0; i < ids.length; i++) {
            if (isNFT(ids[i]) && values[i] == 1) {
                _mintNonFungible(to[i], ids[i], true);
            } else if (isFungible(ids[i])) {
                _mintFungible(to[i], ids[i], values[i], true);
            } else {
                revert("Incorrect id");
            }
        }
    }

     /**
     * @dev Public function to mint one non fungible token id
     * Reverts if the given token ID is not non fungible token id
     * @param to address recipient that will own the minted tokens
     * @param tokenId uint256 ID of the token to be minted
     */
    function mintNonFungible(address to, uint256 tokenId) onlyMinter external {
        _mintNonFungible(to, tokenId, false);
    }

    /**
     * @dev Public function to mint fungible token
     * Reverts if the given ID is not fungible collection ID
     * @param to address recipient that will own the minted tokens
     * @param collection uint256 ID of the fungible collection to be minted
     * @param value uint256 amount to mint
     */
    function mintFungible(address to, uint256 collection, uint256 value) onlyMinter external {
        _mintFungible(to, collection, value, false);
    }

    function _uri(uint256 id) internal override view returns (string memory) {
        return _fullUriFromId(id);
    }
}

// File: @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/IERC20.sol

/*
https://github.com/OpenZeppelin/openzeppelin-contracts

The MIT License (MIT)

Copyright (c) 2016-2019 zOS Global Limited

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

pragma solidity ^0.6.6;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

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
}

// File: @animoca/ethereum-contracts-core_library/contracts/payment/PayoutWallet.sol

pragma solidity ^0.6.6;


/**
    @title PayoutWallet
    @dev adds support for a payout wallet
    Note: .
 */
contract PayoutWallet is Ownable
{
    event PayoutWalletSet(address payoutWallet);

    address payable public _payoutWallet;

    constructor(address payoutWallet) internal {
        setPayoutWallet(payoutWallet);
    }

    function setPayoutWallet(address payoutWallet) public onlyOwner {
        require(payoutWallet != address(0), "The payout wallet must not be the zero address");
        require(payoutWallet != address(this), "The payout wallet must not be the contract itself");
        require(payoutWallet != _payoutWallet, "The payout wallet must be different");
        _payoutWallet = payable(payoutWallet);
        emit PayoutWalletSet(_payoutWallet);
    }
}

// File: @openzeppelin/contracts/utils/Pausable.sol

pragma solidity ^0.6.0;


/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor () internal {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    /**
     * @dev Triggers stopped state.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// File: @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/IERC20Detailed.sol

/*
https://github.com/OpenZeppelin/openzeppelin-contracts

The MIT License (MIT)

Copyright (c) 2016-2019 zOS Global Limited

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

pragma solidity ^0.6.6;

/**
 * @dev Interface for commonly used additional ERC20 interfaces
 */
interface IERC20Detailed {

    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() external view returns (uint8);
}

// File: @animoca/ethereum-contracts-sale_base/contracts/payment/IKyber.sol

pragma solidity ^0.6.6;


// contract

// https://github.com/KyberNetwork/smart-contracts/blob/master/contracts/KyberNetworkProxy.sol
interface IKyber {
    function getExpectedRate(IERC20 src, IERC20 dest, uint srcQty) external view
        returns (uint expectedRate, uint slippageRate);

    function trade(
        IERC20 src,
        uint srcAmount,
        IERC20 dest,
        address destAddress,
        uint maxDestAmount,
        uint minConversionRate,
        address walletId
    )
    external
    payable
        returns(uint);
}

// File: @animoca/ethereum-contracts-sale_base/contracts/payment/KyberAdapter.sol

pragma solidity ^0.6.6;





contract KyberAdapter {
    using SafeMath for uint256;

    IKyber public kyber;

    IERC20 public ETH_ADDRESS = IERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);

    constructor(address _kyberProxy) public {
        kyber = IKyber(_kyberProxy);
    }

    fallback () external payable {}

    receive () external payable {}

    function _getTokenDecimals(IERC20 _token) internal view returns (uint8 _decimals) {
        return _token != ETH_ADDRESS ? IERC20Detailed(address(_token)).decimals() : 18;
    }

    function _getTokenBalance(IERC20 _token, address _account) internal view returns (uint256 _balance) {
        return _token != ETH_ADDRESS ? _token.balanceOf(_account) : _account.balance;
    }

    function ceilingDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
        return a.div(b).add(a.mod(b) > 0 ? 1 : 0);
    }

    function _fixTokenDecimals(
        IERC20 _src,
        IERC20 _dest,
        uint256 _unfixedDestAmount,
        bool _ceiling
    )
    internal
    view
    returns (uint256 _destTokenAmount)
    {
        uint256 _unfixedDecimals = _getTokenDecimals(_src) + 18; // Kyber by default returns rates with 18 decimals.
        uint256 _decimals = _getTokenDecimals(_dest);

        if (_unfixedDecimals > _decimals) {
            // Divide token amount by 10^(_unfixedDecimals - _decimals) to reduce decimals.
            if (_ceiling) {
                return ceilingDiv(_unfixedDestAmount, (10 ** (_unfixedDecimals - _decimals)));
            } else {
                return _unfixedDestAmount.div(10 ** (_unfixedDecimals - _decimals));
            }
        } else {
            // Multiply token amount with 10^(_decimals - _unfixedDecimals) to increase decimals.
            return _unfixedDestAmount.mul(10 ** (_decimals - _unfixedDecimals));
        }
    }

    function _convertToken(
        IERC20 _src,
        uint256 _srcAmount,
        IERC20 _dest
    )
    internal
    view
    returns (
        uint256 _expectedAmount,
        uint256 _slippageAmount
    )
    {
        (uint256 _expectedRate, uint256 _slippageRate) = kyber.getExpectedRate(_src, _dest, _srcAmount);

        return (
            _fixTokenDecimals(_src, _dest, _srcAmount.mul(_expectedRate), false),
            _fixTokenDecimals(_src, _dest, _srcAmount.mul(_slippageRate), false)
        );
    }

    function _swapTokenAndHandleChange(
        IERC20 _src,
        uint256 _maxSrcAmount,
        IERC20 _dest,
        uint256 _maxDestAmount,
        uint256 _minConversionRate,
        address payable _initiator,
        address payable _receiver
    )
    internal
    returns (
        uint256 _srcAmount,
        uint256 _destAmount
    )
    {
        if (_src == _dest) {
            // payment is made with DAI
            require(_maxSrcAmount >= _maxDestAmount);
            _destAmount = _srcAmount = _maxDestAmount;
            require(_src.transferFrom(_initiator, address(this), _destAmount));
        } else {
            require(_src == ETH_ADDRESS ? msg.value >= _maxSrcAmount : msg.value == 0);

            // Prepare for handling back the change if there is any.
            uint256 _balanceBefore = _getTokenBalance(_src, address(this));

            if (_src != ETH_ADDRESS) {
                require(_src.transferFrom(_initiator, address(this), _maxSrcAmount));
                require(_src.approve(address(kyber), _maxSrcAmount));
            } else {
                // Since we are going to transfer the source amount to Kyber.
                _balanceBefore = _balanceBefore.sub(_maxSrcAmount);
            }

            _destAmount = kyber.trade{ value: _src == ETH_ADDRESS ? _maxSrcAmount : 0 } (
                _src,
                _maxSrcAmount,
                _dest,
                _receiver,
                _maxDestAmount,
                _minConversionRate,
                address(0)
            );

            uint256 _balanceAfter = _getTokenBalance(_src, address(this));
            _srcAmount = _maxSrcAmount;

            // Handle back the change, if there is any, to the message sender.
            if (_balanceAfter > _balanceBefore) {
                uint256 _change = _balanceAfter - _balanceBefore;
                _srcAmount = _srcAmount.sub(_change);

                if (_src != ETH_ADDRESS) {
                    require(_src.transfer(_initiator, _change));
                } else {
                    _initiator.transfer(_change);
                }
            }
        }
    }
}

// File: @animoca/ethereum-contracts-sale_base/contracts/sale/FixedSupplyLotSale.sol

pragma solidity ^0.6.6;




// import "@openzeppelin/contracts/math/Math.sol";


abstract contract FixedSupplyLotSale is Pausable, KyberAdapter, PayoutWallet {
    using SafeMath for uint256;

    // a Lot is a class of purchasable sale items. in the case of CDH, each chest
    // of a given 'star' rarity tier is a different Lot. the Lot items are token
    // bundles comprising of a single 'card' NFT (of the appropriate 'star' rarity
    // tier) and a number of fungible 'gem' tokens.
    struct Lot {
        bool exists; // state flag to indicate that the Lot item exists.
        uint256[] nonFungibleSupply; // supply of non-fungible tokens for sale.
        uint256 fungibleAmount; // fungible token amount bundled with each NFT.
        uint256 price; // Lot item price, in payout currency tokens.
        uint256 numAvailable; // number of Lot items available for purchase.
    }

    // a struct container for allocating intermediate values, used by the purchaseFor()
    // function, onto the stack (as opposed to memory) to help reduce gas cost for
    // calling the function.
    struct PurchaseForVars {
        address payable recipient;
        uint256 lotId;
        uint256 quantity;
        IERC20 tokenAddress;
        uint256 maxTokenAmount;
        uint256 minConversionRate;
        string extData;
        address payable operator;
        Lot lot;
        uint256[] nonFungibleTokens;
        uint256 totalFungibleAmount;
        uint256 totalPrice;
        uint256 totalDiscounts;
        uint256 tokensSent;
        uint256 tokensReceived;
    }

    event Purchased (
        address indexed recipient, // destination account receiving the purchased Lot items.
        address operator, // account that executed the purchase operation.
        uint256 indexed lotId, // Lot id of the purchased items.
        uint256 indexed quantity, // quantity of Lot items purchased.
        uint256[] nonFungibleTokens, // list of Lot item non-fungible tokens in the purchase.
        uint256 totalFungibleAmount, // total amount of Lot item fungible tokens in the purchase.
        uint256 totalPrice, // total price (excluding any discounts) of the purchase, in payout currency tokens.
        uint256 totalDiscounts, // total discounts applied to the total price, in payout currency tokens.
        address tokenAddress, // purchase currency token contract address.
        uint256 tokensSent, // amount of actual purchase tokens spent (to convert to payout tokens) for the purchase.
        uint256 tokensReceived, // amount of actual payout tokens received (converted from purchase tokens) for the purchase.
        string extData // string encoded context-specific data blob.
    );

    event LotCreated (
        uint256 lotId, // id of the created Lot.
        uint256[] nonFungibleTokens, // initial Lot supply of non-fungible tokens.
        uint256 fungibleAmount, // initial fungible token amount bundled with each NFT.
        uint256 price // initial Lot item price.
    );

    event LotNonFungibleSupplyUpdated (
        uint256 lotId, // id of the Lot whose supply of non-fungible tokens was updated.
        uint256[] nonFungibleTokens // the non-fungible tokens that updated the supply.
    );

    event LotFungibleAmountUpdated (
        uint256 lotId, // id of the Lot whose fungible token amount was updated.
        uint256 fungibleAmount // updated fungible token amount.
    );

    event LotPriceUpdated (
        uint256 lotId, // id of the Lot whose item price was updated.
        uint256 price // updated item price.
    );

    IERC20 public _payoutTokenAddress; // payout currency token contract address.

    uint256 public _fungibleTokenId; // inventory token id of the fungible tokens bundled in a Lot item.

    address public _inventoryContract; // inventory contract address.

    mapping (uint256 => Lot) public _lots; // mapping of lotId => Lot.

    uint256 public _startedAt; // starting timestamp of the Lot sale.

    modifier whenStarted() {
        require(_startedAt != 0);
        _;
    }

    modifier whenNotStarted() {
        require(_startedAt == 0);
        _;
    }

    /**
     * @dev Constructor.
     * @param kyberProxy Kyber network proxy contract.
     * @param payoutWallet Account to receive payout currency tokens from the Lot sales.
     * @param payoutTokenAddress Payout currency token contract address.
     * @param fungibleTokenId Inventory token id of the fungible tokens bundled in a Lot item.
     * @param inventoryContract Address of the inventory contract to use in the delivery of purchased Lot items.
     */
    constructor(
        address kyberProxy,
        address payable payoutWallet,
        IERC20 payoutTokenAddress,
        uint256 fungibleTokenId,
        address inventoryContract
    )
        KyberAdapter(kyberProxy)
        PayoutWallet(payoutWallet)
        public
    {
        pause();

        setPayoutTokenAddress(payoutTokenAddress);
        setFungibleTokenId(fungibleTokenId);
        setInventoryContract(inventoryContract);
    }

    /**
     * @dev Sets which token to use as the payout currency from the Lot sales.
     * @param payoutTokenAddress Payout currency token contract address to use.
     */
    function setPayoutTokenAddress(
        IERC20 payoutTokenAddress
    )
        public
        onlyOwner
        whenPaused
    {
        require(payoutTokenAddress != IERC20(0));
        require(payoutTokenAddress != _payoutTokenAddress);

        _payoutTokenAddress = payoutTokenAddress;
    }

    /**
     * @dev Sets the inventory token id of the fungible tokens bundled in a Lot item.
     * @param fungibleTokenId Inventory token id of the fungible tokens to bundle in a Lot item.
     */
    function setFungibleTokenId(
        uint256 fungibleTokenId
    )
        public
        onlyOwner
        whenNotStarted
    {
        require(fungibleTokenId != 0);
        require(fungibleTokenId != _fungibleTokenId);

        _fungibleTokenId = fungibleTokenId;
    }

    /**
     * @dev Sets the inventory contract to use in the delivery of purchased Lot items.
     * @param inventoryContract Address of the inventory contract to use.
     */
    function setInventoryContract(
        address inventoryContract
    )
        public
        onlyOwner
        whenNotStarted
    {
        require(inventoryContract != address(0));
        require(inventoryContract != _inventoryContract);

        _inventoryContract = inventoryContract;
    }

    /**
     * @dev Starts the sale
     */
    function start()
        public
        onlyOwner
        whenNotStarted
    {
        // solium-disable-next-line security/no-block-members
        _startedAt = now;

        unpause();
    }

    function pause()
        public
        onlyOwner
    {
        _pause();
    }

    function unpause()
        public onlyOwner
    {
        _unpause();
    }

    /**
     * @dev Creates a new Lot to add to the sale.
     * There are NO guarantees about the uniqueness of the non-fungible token supply.
     * Lot item price must be at least 0.00001 of the base denomination.
     * @param lotId Id of the Lot to create.
     * @param nonFungibleSupply Initial non-fungible token supply of the Lot.
     * @param fungibleAmount Initial fungible token amount to bundle with each NFT.
     * @param price Initial Lot item sale price, in payout currency tokens
     */
    function createLot(
        uint256 lotId,
        uint256[] memory nonFungibleSupply,
        uint256 fungibleAmount,
        uint256 price
    )
        public
        onlyOwner
        whenNotStarted
    {
        require(!_lots[lotId].exists);

        Lot memory lot;
        lot.exists = true;
        lot.nonFungibleSupply = nonFungibleSupply;
        lot.fungibleAmount = fungibleAmount;
        lot.price = price;
        lot.numAvailable = nonFungibleSupply.length;

        _lots[lotId] = lot;

        emit LotCreated(lotId, nonFungibleSupply, fungibleAmount, price);
    }

    /**
     * @dev Updates the given Lot's non-fungible token supply with additional NFTs.
     * There are NO guarantees about the uniqueness of the non-fungible token supply.
     * @param lotId Id of the Lot to update.
     * @param nonFungibleTokens Non-fungible tokens to update with.
     */
    function updateLotNonFungibleSupply(
        uint256 lotId,
        uint256[] calldata nonFungibleTokens
    )
        external
        onlyOwner
        whenNotStarted
    {
        require(nonFungibleTokens.length != 0);

        Lot memory lot = _lots[lotId];

        require(lot.exists);

        uint256 newSupplySize = lot.nonFungibleSupply.length.add(nonFungibleTokens.length);
        uint256[] memory newNonFungibleSupply = new uint256[](newSupplySize);

        for (uint256 index = 0; index < lot.nonFungibleSupply.length; index++) {
            newNonFungibleSupply[index] = lot.nonFungibleSupply[index];
        }

        for (uint256 index = 0; index < nonFungibleTokens.length; index++) {
            uint256 offset = index.add(lot.nonFungibleSupply.length);
            newNonFungibleSupply[offset] = nonFungibleTokens[index];
        }

        lot.nonFungibleSupply = newNonFungibleSupply;
        lot.numAvailable = lot.numAvailable.add(nonFungibleTokens.length);

        _lots[lotId] = lot;

        emit LotNonFungibleSupplyUpdated(lotId, nonFungibleTokens);
    }

    /**
     * @dev Updates the given Lot's fungible token amount bundled with each NFT.
     * @param lotId Id of the Lot to update.
     * @param fungibleAmount Fungible token amount to update with.
     */
    function updateLotFungibleAmount(
        uint256 lotId,
        uint256 fungibleAmount
    )
        external
        onlyOwner
        whenPaused
    {
        require(_lots[lotId].exists);
        require(_lots[lotId].fungibleAmount != fungibleAmount);

        _lots[lotId].fungibleAmount = fungibleAmount;

        emit LotFungibleAmountUpdated(lotId, fungibleAmount);
    }

    /**
     * @dev Updates the given Lot's item sale price.
     * @param lotId Id of the Lot to update.
     * @param price The new sale price, in payout currency tokens, to update with.
     */
    function updateLotPrice(
        uint256 lotId,
        uint256 price
    )
        external
        onlyOwner
        whenPaused
    {
        require(_lots[lotId].exists);
        require(_lots[lotId].price != price);

        _lots[lotId].price = price;

        emit LotPriceUpdated(lotId, price);
    }

    /**
     * @dev Returns the given number of next available non-fungible tokens for the specified Lot.
     * @dev If the given number is more than the next available non-fungible tokens, then the remaining available is returned.
     * @param lotId Id of the Lot whose non-fungible supply to peek into.
     * @param count Number of next available non-fungible tokens to peek.
     * @return The given number of next available non-fungible tokens for the specified Lot, otherwise the remaining available non-fungible tokens.
     */
    function peekLotAvailableNonFungibleSupply(
        uint256 lotId,
        uint256 count
    )
        external
        view
        returns
    (
        uint256[] memory
    )
    {
        Lot memory lot = _lots[lotId];

        require(lot.exists);

        if (count > lot.numAvailable) {
            count = lot.numAvailable;
        }

        uint256[] memory nonFungibleTokens = new uint256[](count);

        uint256 nonFungibleSupplyOffset = lot.nonFungibleSupply.length.sub(lot.numAvailable);

        for (uint256 index = 0; index < count; index++) {
            uint256 position = nonFungibleSupplyOffset.add(index);
            nonFungibleTokens[index] = lot.nonFungibleSupply[position];
        }

        return nonFungibleTokens;
    }

    /**
     * @dev Purchases a quantity of Lot items for the given Lot id.
     * @param recipient Destination account to receive the purchased Lot items.
     * @param lotId Lot id of the items to purchase.
     * @param quantity Quantity of Lot items to purchase.
     * @param tokenAddress Purchase currency token contract address.
     * @param maxTokenAmount Maximum amount of purchase tokens to spend for the purchase.
     * @param minConversionRate Minimum conversion rate, from purchase tokens to payout tokens, to allow for the purchase to succeed.
     * @param extData Additional string encoded custom data to pass through to the event.
     */
    function purchaseFor(
        address payable recipient,
        uint256 lotId,
        uint256 quantity,
        IERC20 tokenAddress,
        uint256 maxTokenAmount,
        uint256 minConversionRate,
        string calldata extData
    )
        external
        payable
        whenNotPaused
        whenStarted
    {
        require(recipient != address(0));
        require(recipient != address(uint160(address(this))));
        require (quantity > 0);
        require(tokenAddress != IERC20(0));

        PurchaseForVars memory purchaseForVars;
        purchaseForVars.recipient = recipient;
        purchaseForVars.lotId = lotId;
        purchaseForVars.quantity = quantity;
        purchaseForVars.tokenAddress = tokenAddress;
        purchaseForVars.maxTokenAmount = maxTokenAmount;
        purchaseForVars.minConversionRate = minConversionRate;
        purchaseForVars.extData = extData;
        purchaseForVars.operator = msg.sender;
        purchaseForVars.lot = _lots[lotId];

        require(purchaseForVars.lot.exists);
        require(quantity <= purchaseForVars.lot.numAvailable);

        purchaseForVars.nonFungibleTokens = new uint256[](quantity);

        uint256 nonFungibleSupplyOffset = purchaseForVars.lot.nonFungibleSupply.length.sub(purchaseForVars.lot.numAvailable);

        for (uint256 index = 0; index < quantity; index++) {
            uint256 position = nonFungibleSupplyOffset.add(index);
            purchaseForVars.nonFungibleTokens[index] = purchaseForVars.lot.nonFungibleSupply[position];
        }

        purchaseForVars.totalFungibleAmount = purchaseForVars.lot.fungibleAmount.mul(quantity);

        _purchaseFor(purchaseForVars);

        _lots[lotId].numAvailable = purchaseForVars.lot.numAvailable.sub(quantity);
    }

    /**
     * @dev Retrieves user purchase price information for the given quantity of Lot items.
     * @param recipient The user for whom the price information is being retrieved for.
     * @param lotId Lot id of the items from which the purchase price information will be retrieved.
     * @param quantity Quantity of Lot items from which the purchase price information will be retrieved.
     * @param tokenAddress Purchase currency token contract address.
     * @return minConversionRate Minimum conversion rate from purchase tokens to payout tokens.
     * @return totalPrice Total price (excluding any discounts), in purchase currency tokens.
     * @return totalDiscounts Total discounts to apply to the total price, in purchase currency tokens.
     */
    function getPrice(
        address payable recipient,
        uint256 lotId,
        uint256 quantity,
        IERC20 tokenAddress
    )
        external
        view
        returns
    (
        uint256 minConversionRate,
        uint256 totalPrice,
        uint256 totalDiscounts
    )
    {
        Lot memory lot = _lots[lotId];

        require(lot.exists);
        require(tokenAddress != IERC20(0));

        (totalPrice, totalDiscounts) = _getPrice(recipient, lot, quantity);

        if (tokenAddress == _payoutTokenAddress) {
            minConversionRate = 1000000000000000000;
        } else {
            (, uint tokenAmount) = _convertToken(_payoutTokenAddress, totalPrice, tokenAddress);
            (, minConversionRate) = kyber.getExpectedRate(tokenAddress, _payoutTokenAddress, tokenAmount);

            if (totalPrice > 0) {
                totalPrice = ceilingDiv(totalPrice.mul(10**36), minConversionRate);
                totalPrice = _fixTokenDecimals(_payoutTokenAddress, tokenAddress, totalPrice, true);
            }

            if (totalDiscounts > 0) {
                totalDiscounts = ceilingDiv(totalDiscounts.mul(10**36), minConversionRate);
                totalDiscounts = _fixTokenDecimals(_payoutTokenAddress, tokenAddress, totalDiscounts, true);
            }
        }
    }

    /**
     * @dev Purchases a quantity of Lot items for the given Lot id.
     * @dev Overridable.
     * @param purchaseForVars PurchaseForVars structure of in-memory intermediate variables used in the purchaseFor() call
     */
    function _purchaseFor(
        PurchaseForVars memory purchaseForVars
    )
        internal
        virtual
    {
        (purchaseForVars.totalPrice, purchaseForVars.totalDiscounts) =
            _purchaseForPricing(purchaseForVars);

        (purchaseForVars.tokensSent, purchaseForVars.tokensReceived) =
            _purchaseForPayment(purchaseForVars);

        _purchaseForDelivery(purchaseForVars);
        _purchaseForNotify(purchaseForVars);
    }

    /**
     * @dev Purchase lifecycle hook that handles the calculation of the total price and total discounts, in payout currency tokens.
     * @dev Overridable.
     * @param purchaseForVars PurchaseForVars structure of in-memory intermediate variables used in the purchaseFor() call
     * @return totalPrice Total price (excluding any discounts), in payout currency tokens.
     * @return totalDiscounts Total discounts to apply to the total price, in payout currency tokens.
     */
    function _purchaseForPricing(
        PurchaseForVars memory purchaseForVars
    )
        internal
        virtual
        returns
    (
        uint256 totalPrice,
        uint256 totalDiscounts
    )
    {
        (totalPrice, totalDiscounts) =
            _getPrice(
                purchaseForVars.recipient,
                purchaseForVars.lot,
                purchaseForVars.quantity);

        require(totalDiscounts <= totalPrice);
    }

    /**
     * @dev Purchase lifecycle hook that handles the conversion and transfer of payment tokens.
     * @dev Any overpayments result in the change difference being returned to the recipient, in purchase currency tokens.
     * @dev Overridable.
     * @param purchaseForVars PurchaseForVars structure of in-memory intermediate variables used in the purchaseFor() call
     * @return purchaseTokensSent The amount of actual purchase tokens paid by the recipient.
     * @return payoutTokensReceived The amount of actual payout tokens received by the payout wallet.
     */
    function _purchaseForPayment(
        PurchaseForVars memory purchaseForVars
    )
        internal
        virtual
        returns
    (
        uint256 purchaseTokensSent,
        uint256 payoutTokensReceived
    )
    {
        uint256 totalDiscountedPrice = purchaseForVars.totalPrice.sub(purchaseForVars.totalDiscounts);

        (purchaseTokensSent, payoutTokensReceived) =
            _swapTokenAndHandleChange(
                purchaseForVars.tokenAddress,
                purchaseForVars.maxTokenAmount,
                _payoutTokenAddress,
                totalDiscountedPrice,
                purchaseForVars.minConversionRate,
                purchaseForVars.operator,
                address(uint160(address(this))));

        require(payoutTokensReceived >= totalDiscountedPrice);
        require(_payoutTokenAddress.transfer(_payoutWallet, payoutTokensReceived));
    }

    /**
     * @dev Purchase lifecycle hook that handles the delivery of purchased fungible and non-fungible tokens to the recipient.
     * @dev Overridable.
     * @param purchaseForVars PurchaseForVars structure of in-memory intermediate variables used in the purchaseFor() call
     */
    function _purchaseForDelivery(PurchaseForVars memory purchaseForVars) internal virtual;

    /**
     * @dev Purchase lifecycle hook that handles the notification of a purchase event.
     * @dev Overridable.
     * @param purchaseForVars PurchaseForVars structure of in-memory intermediate variables used in the purchaseFor() call
     */
    function _purchaseForNotify(
        PurchaseForVars memory purchaseForVars
    )
        internal
        virtual
    {
        emit Purchased(
            purchaseForVars.recipient,
            purchaseForVars.operator,
            purchaseForVars.lotId,
            purchaseForVars.quantity,
            purchaseForVars.nonFungibleTokens,
            purchaseForVars.totalFungibleAmount,
            purchaseForVars.totalPrice,
            purchaseForVars.totalDiscounts,
            address(purchaseForVars.tokenAddress),
            purchaseForVars.tokensSent,
            purchaseForVars.tokensReceived,
            purchaseForVars.extData);
    }

    /**
     * @dev Retrieves user payout price information for the given quantity of Lot items.
     * @dev @param recipient The user for whom the price information is being retrieved for.
     * @param lot Lot of the items from which the purchase price information will be retrieved.
     * @param quantity Quantity of Lot items from which the purchase price information will be retrieved.
     * @return totalPrice Total price (excluding any discounts), in payout currency tokens.
     * @return totalDiscounts Total discounts to apply to the total price, in payout currency tokens.
     */
    function _getPrice(
        address payable /* recipient */,
        Lot memory lot,
        uint256 quantity
    )
        internal
        virtual
        pure
        returns
    (
        uint256 totalPrice,
        uint256 totalDiscounts
    )
    {
        totalPrice = lot.price.mul(quantity);
        totalDiscounts = 0;
    }
}

// File: contracts/sale/CDHSale.sol

pragma solidity ^0.6.6;



contract CDHSale is FixedSupplyLotSale {

    // a struct container for allocating intermediate values, used by the _deliverPurchase()
    // function, onto the stack (as opposed to memory) to help reduce gas cost for
    // calling the function.
    struct DeliverPurchaseVars {
        uint256 numNonFungibleTokens;
        uint256 numTokens;
        address[] to;
        uint256[] ids;
        uint256[] values;
    }

    constructor(
        address kyberProxy,
        address payable payoutWallet,
        IERC20 payoutTokenAddress,
        uint256 fungibleTokenId,
        address inventoryContract
    )
        FixedSupplyLotSale(
            kyberProxy,
            payoutWallet,
            payoutTokenAddress,
            fungibleTokenId,
            inventoryContract
        )
        public
    {}

    function _purchaseForDelivery(
        PurchaseForVars memory purchaseForVars
    )
        internal
        override
    {
        require(purchaseForVars.recipient != address(0));
        require(purchaseForVars.recipient != address(uint160(address(this))));

        DeliverPurchaseVars memory vars;
        vars.numNonFungibleTokens = purchaseForVars.nonFungibleTokens.length;
        vars.numTokens = vars.numNonFungibleTokens + 1;
        vars.to = new address[](vars.numTokens);
        vars.ids = new uint256[](vars.numTokens);
        vars.values = new uint256[](vars.numTokens);

        // populate batch with non-fungible mint information
        for (uint256 index = 0; index < vars.numNonFungibleTokens; index++) {
            vars.to[index] = purchaseForVars.recipient;
            vars.ids[index] = purchaseForVars.nonFungibleTokens[index];
            vars.values[index] = 1;
        }

        // populate batch with fungible mint information
        vars.to[vars.numNonFungibleTokens] = purchaseForVars.recipient;
        vars.ids[vars.numNonFungibleTokens] = _fungibleTokenId;
        vars.values[vars.numNonFungibleTokens] = purchaseForVars.totalFungibleAmount;

        NonBurnableInventoryMock(_inventoryContract).batchMint(vars.to, vars.ids, vars.values);
    }

}