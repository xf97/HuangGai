/**
 *Submitted for verification at Etherscan.io on 2020-06-13
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

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol

pragma solidity ^0.5.0;




/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20Mintable}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

     /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
    }
}

// File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol

pragma solidity ^0.5.0;


/**
 * @dev Optional functions from the ERC20 standard.
 */
contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

// File: @openzeppelin/contracts/utils/ReentrancyGuard.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 */
contract ReentrancyGuard {
    // counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}

// File: @openzeppelin/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
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
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
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
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: @openzeppelin/contracts/access/Roles.sol

pragma solidity ^0.5.0;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

// File: @openzeppelin/contracts/access/roles/PauserRole.sol

pragma solidity ^0.5.0;



contract PauserRole is Context {
    using Roles for Roles.Role;

    event PauserAdded(address indexed account);
    event PauserRemoved(address indexed account);

    Roles.Role private _pausers;

    constructor () internal {
        _addPauser(_msgSender());
    }

    modifier onlyPauser() {
        require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
        _;
    }

    function isPauser(address account) public view returns (bool) {
        return _pausers.has(account);
    }

    function addPauser(address account) public onlyPauser {
        _addPauser(account);
    }

    function renouncePauser() public {
        _removePauser(_msgSender());
    }

    function _addPauser(address account) internal {
        _pausers.add(account);
        emit PauserAdded(account);
    }

    function _removePauser(address account) internal {
        _pausers.remove(account);
        emit PauserRemoved(account);
    }
}

// File: @openzeppelin/contracts/lifecycle/Pausable.sol

pragma solidity ^0.5.0;



/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
contract Pausable is Context, PauserRole {
    /**
     * @dev Emitted when the pause is triggered by a pauser (`account`).
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by a pauser (`account`).
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state. Assigns the Pauser role
     * to the deployer.
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
     * @dev Called by a pauser to pause, triggers stopped state.
     */
    function pause() public onlyPauser whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Called by a pauser to unpause, returns to normal state.
     */
    function unpause() public onlyPauser whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
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
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * IMPORTANT: It is unsafe to assume that an address for which this
     * function returns false is an externally-owned account (EOA) and not a
     * contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
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

// File: contracts/interfaces/iERC20Fulcrum.sol

pragma solidity 0.5.16;

interface iERC20Fulcrum {
  function mint(
    address receiver,
    uint256 depositAmount)
    external
    returns (uint256 mintAmount);

  function burn(
    address receiver,
    uint256 burnAmount)
    external
    returns (uint256 loanAmountPaid);

  function tokenPrice()
    external
    view
    returns (uint256 price);

  function supplyInterestRate()
    external
    view
    returns (uint256);

  function rateMultiplier()
    external
    view
    returns (uint256);
  function baseRate()
    external
    view
    returns (uint256);

  function borrowInterestRate()
    external
    view
    returns (uint256);

  function avgBorrowInterestRate()
    external
    view
    returns (uint256);

  function protocolInterestRate()
    external
    view
    returns (uint256);

  function spreadMultiplier()
    external
    view
    returns (uint256);

  function totalAssetBorrow()
    external
    view
    returns (uint256);

  function totalAssetSupply()
    external
    view
    returns (uint256);

  function nextSupplyInterestRate(uint256)
    external
    view
    returns (uint256);

  function nextBorrowInterestRate(uint256)
    external
    view
    returns (uint256);
  function nextLoanInterestRate(uint256)
    external
    view
    returns (uint256);
  function totalSupplyInterestRate(uint256)
    external
    view
    returns (uint256);

  function claimLoanToken()
    external
    returns (uint256 claimedAmount);

  function dsr()
    external
    view
    returns (uint256);

  function chaiPrice()
    external
    view
    returns (uint256);
}

// File: contracts/interfaces/ILendingProtocol.sol

pragma solidity 0.5.16;

interface ILendingProtocol {
  function mint() external returns (uint256);
  function redeem(address account) external returns (uint256);
  function nextSupplyRate(uint256 amount) external view returns (uint256);
  function nextSupplyRateWithParams(uint256[] calldata params) external view returns (uint256);
  function getAPR() external view returns (uint256);
  function getPriceInToken() external view returns (uint256);
  function token() external view returns (address);
  function underlying() external view returns (address);
  function availableLiquidity() external view returns (uint256);
}

// File: contracts/interfaces/IIdleTokenV3.sol

/**
 * @title: Idle Token interface
 * @author: Idle Labs Inc., idle.finance
 */
pragma solidity 0.5.16;

interface IIdleTokenV3 {
  // view
  /**
   * IdleToken price calculation, in underlying
   *
   * @return : price in underlying token
   */
  function tokenPrice() external view returns (uint256 price);
  /**
   * @return : underlying token address
   */
  function token() external view returns (address);

  /**
   * underlying token decimals
   *
   * @return : decimals of underlying token
   */
  function tokenDecimals() external view returns (uint256 decimals);

  /**
   * Get APR of every ILendingProtocol
   *
   * @return addresses: array of token addresses
   * @return aprs: array of aprs (ordered in respect to the `addresses` array)
   */
  function getAPRs() external view returns (address[] memory addresses, uint256[] memory aprs);

  // external
  // We should save the amount one has deposited to calc interests

  /**
   * Used to mint IdleTokens, given an underlying amount (eg. DAI).
   * This method triggers a rebalance of the pools if needed
   * NOTE: User should 'approve' _amount of tokens before calling mintIdleToken
   * NOTE 2: this method can be paused
   *
   * @param _amount : amount of underlying token to be lended
   * @param : pass []
   * @return mintedTokens : amount of IdleTokens minted
   */
  function mintIdleToken(uint256 _amount, uint256[] calldata) external returns (uint256 mintedTokens);

  /**
   * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
   * This method triggers a rebalance of the pools if needed
   * NOTE: If the contract is paused or iToken price has decreased one can still redeem but no rebalance happens.
   * NOTE 2: If iToken price has decresed one should not redeem (but can do it) otherwise he would capitalize the loss.
   *         Ideally one should wait until the black swan event is terminated
   *
   * @param _amount : amount of IdleTokens to be burned
   * @param : pass []
   * @return redeemedTokens : amount of underlying tokens redeemed
   */
  function redeemIdleToken(uint256 _amount, bool _skipRebalance, uint256[] calldata)
    external returns (uint256 redeemedTokens);

  /**
   * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
   * and send interest-bearing tokens (eg. cDAI/iDAI) directly to the user.
   * Underlying (eg. DAI) is not redeemed here.
   *
   * @param _amount : amount of IdleTokens to be burned
   */
  function redeemInterestBearingTokens(uint256 _amount) external;

  /**
   * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
   * @param : pass []
   * @return : whether has rebalanced or not
   */
  function rebalance(uint256 _newAmount, uint256[] calldata) external returns (bool);

  /**
   * @return : whether has rebalanced or not
   */
  function rebalance() external returns (bool);
}

// File: contracts/interfaces/IIdleRebalancerV3.sol

/**
 * @title: Idle Rebalancer interface
 * @author: Idle Labs Inc., idle.finance
 */
pragma solidity 0.5.16;

interface IIdleRebalancerV3 {
  function getAllocations() external view returns (uint256[] memory _allocations);
}

// File: contracts/IdleRebalancerV3.sol

/**
 * @title: Idle Rebalancer contract
 * @summary: Used for calculating amounts to lend on each implemented protocol.
 *           This implementation works with Compound and Fulcrum only,
 *           when a new protocol will be added this should be replaced
 * @author: Idle Labs Inc., idle.finance
 */
pragma solidity 0.5.16;




contract IdleRebalancerV3 is IIdleRebalancerV3, Ownable {
  using SafeMath for uint256;
  uint256[] public lastAmounts;
  address[] public lastAmountsAddresses;
  address public rebalancerManager;
  address public idleToken;

  /**
   * @param _cToken : cToken address
   * @param _iToken : iToken address
   * @param _aToken : aToken address
   * @param _yxToken : yxToken address
   * @param _rebalancerManager : rebalancerManager address
   */
  constructor(address _cToken, address _iToken, address _aToken, address _yxToken, address _rebalancerManager) public {
    require(_cToken != address(0) && _iToken != address(0) && _aToken != address(0) && _yxToken != address(0) && _rebalancerManager != address(0), 'some addr is 0');
    rebalancerManager = _rebalancerManager;

    // Initially 100% on first lending protocol
    lastAmounts = [100000, 0, 0, 0];
    lastAmountsAddresses = [_cToken, _iToken, _aToken, _yxToken];
  }

  /**
   * Throws if called by any account other than rebalancerManager.
   */
  modifier onlyRebalancerAndIdle() {
    require(msg.sender == rebalancerManager || msg.sender == idleToken, "Only rebalacer and IdleToken");
    _;
  }

  /**
   * It allows owner to set the allowed rebalancer address
   *
   * @param _rebalancerManager : rebalance manager address
   */
  function setRebalancerManager(address _rebalancerManager)
    external onlyOwner {
      require(_rebalancerManager != address(0), "_rebalancerManager addr is 0");

      rebalancerManager = _rebalancerManager;
  }

  function setIdleToken(address _idleToken)
    external onlyOwner {
      require(idleToken == address(0), "idleToken addr already set");
      require(_idleToken != address(0), "_idleToken addr is 0");
      idleToken = _idleToken;
  }

  /**
   * It adds a new token address to lastAmountsAddresses list
   *
   * @param _newToken : new interest bearing token address
   */
  function setNewToken(address _newToken)
    external onlyOwner {
      require(_newToken != address(0), "New token should be != 0");
      for (uint256 i = 0; i < lastAmountsAddresses.length; i++) {
        if (lastAmountsAddresses[i] == _newToken) {
          return;
        }
      }

      lastAmountsAddresses.push(_newToken);
      lastAmounts.push(0);
  }
  // end onlyOwner

  /**
   * Used by Rebalance manager to set the new allocations
   *
   * @param _allocations : array with allocations in percentages (100% => 100000)
   * @param _addresses : array with addresses of tokens used, should be equal to lastAmountsAddresses
   */
  function setAllocations(uint256[] calldata _allocations, address[] calldata _addresses)
    external onlyRebalancerAndIdle
  {
    require(_allocations.length == lastAmounts.length, "Alloc lengths are different, allocations");
    require(_allocations.length == _addresses.length, "Alloc lengths are different, addresses");

    uint256 total;
    for (uint256 i = 0; i < _allocations.length; i++) {
      require(_addresses[i] == lastAmountsAddresses[i], "Addresses do not match");
      total = total.add(_allocations[i]);
      lastAmounts[i] = _allocations[i];
    }
    require(total == 100000, "Not allocating 100%");
  }

  function getAllocations()
    external view returns (uint256[] memory _allocations) {
    return lastAmounts;
  }

  function getAllocationsLength()
    external view returns (uint256) {
    return lastAmounts.length;
  }
}

// File: contracts/interfaces/IIdleToken.sol

/**
 * @title: Idle Token interface
 * @author: Idle Labs Inc., idle.finance
 */
pragma solidity 0.5.16;

interface IIdleToken {
  // view
  /**
   * IdleToken price calculation, in underlying
   *
   * @return : price in underlying token
   */
  function tokenPrice() external view returns (uint256 price);

  /**
   * underlying token decimals
   *
   * @return : decimals of underlying token
   */
  function tokenDecimals() external view returns (uint256 decimals);

  /**
   * Get APR of every ILendingProtocol
   *
   * @return addresses: array of token addresses
   * @return aprs: array of aprs (ordered in respect to the `addresses` array)
   */
  function getAPRs() external view returns (address[] memory addresses, uint256[] memory aprs);

  // external
  // We should save the amount one has deposited to calc interests

  /**
   * Used to mint IdleTokens, given an underlying amount (eg. DAI).
   * This method triggers a rebalance of the pools if needed
   * NOTE: User should 'approve' _amount of tokens before calling mintIdleToken
   * NOTE 2: this method can be paused
   *
   * @param _amount : amount of underlying token to be lended
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return mintedTokens : amount of IdleTokens minted
   */
  function mintIdleToken(uint256 _amount, uint256[] calldata _clientProtocolAmounts) external returns (uint256 mintedTokens);

  /**
   * @param _amount : amount of underlying token to be lended
   * @return : address[] array with all token addresses used,
   *                          eg [cTokenAddress, iTokenAddress]
   * @return : uint256[] array with all amounts for each protocol in order,
   *                   eg [amountCompound, amountFulcrum]
   */
  function getParamsForMintIdleToken(uint256 _amount) external returns (address[] memory, uint256[] memory);

  /**
   * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
   * This method triggers a rebalance of the pools if needed
   * NOTE: If the contract is paused or iToken price has decreased one can still redeem but no rebalance happens.
   * NOTE 2: If iToken price has decresed one should not redeem (but can do it) otherwise he would capitalize the loss.
   *         Ideally one should wait until the black swan event is terminated
   *
   * @param _amount : amount of IdleTokens to be burned
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return redeemedTokens : amount of underlying tokens redeemed
   */
  function redeemIdleToken(uint256 _amount, bool _skipRebalance, uint256[] calldata _clientProtocolAmounts)
    external returns (uint256 redeemedTokens);

  /**
   * @param _amount : amount of IdleTokens to be burned
   * @param _skipRebalance : whether to skip the rebalance process or not
   * @return : address[] array with all token addresses used,
   *                          eg [cTokenAddress, iTokenAddress]
   * @return : uint256[] array with all amounts for each protocol in order,
   *                   eg [amountCompound, amountFulcrum]
   */
  function getParamsForRedeemIdleToken(uint256 _amount, bool _skipRebalance)
    external returns (address[] memory, uint256[] memory);

  /**
   * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
   * and send interest-bearing tokens (eg. cDAI/iDAI) directly to the user.
   * Underlying (eg. DAI) is not redeemed here.
   *
   * @param _amount : amount of IdleTokens to be burned
   */
  function redeemInterestBearingTokens(uint256 _amount) external;

  /**
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return claimedTokens : amount of underlying tokens claimed
   */
  function claimITokens(uint256[] calldata _clientProtocolAmounts) external returns (uint256 claimedTokens);

  /**
   * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return : whether has rebalanced or not
   */
  function rebalance(uint256 _newAmount, uint256[] calldata _clientProtocolAmounts) external returns (bool);

  /**
   * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
   * @return : address[] array with all token addresses used,
   *                          eg [cTokenAddress, iTokenAddress]
   * @return : uint256[] array with all amounts for each protocol in order,
   *                   eg [amountCompound, amountFulcrum]
   */
  function getParamsForRebalance(uint256 _newAmount) external returns (address[] memory, uint256[] memory);
}

// File: contracts/IdlePriceCalculator.sol

/**
 * @title: Idle Price Calculator contract
 * @summary: Used for calculating the current IdleToken price in underlying (eg. DAI)
 *          price is: Net Asset Value / totalSupply
 * @author: Idle Labs Inc., idle.finance
 */
pragma solidity 0.5.16;






contract IdlePriceCalculator {
  using SafeMath for uint256;
  /**
   * IdleToken price calculation, in underlying (eg. DAI)
   *
   * @return : price in underlying token
   */
  function tokenPrice(
    uint256 totalSupply,
    address idleToken,
    address[] calldata currentTokensUsed,
    address[] calldata protocolWrappersAddresses
  )
    external view
    returns (uint256 price) {
      require(currentTokensUsed.length == protocolWrappersAddresses.length, "Different Length");

      if (totalSupply == 0) {
        return 10**(IIdleToken(idleToken).tokenDecimals());
      }

      uint256 currPrice;
      uint256 currNav;
      uint256 totNav;

      for (uint256 i = 0; i < currentTokensUsed.length; i++) {
        currPrice = ILendingProtocol(protocolWrappersAddresses[i]).getPriceInToken();
        // NAV = price * poolSupply
        currNav = currPrice.mul(IERC20(currentTokensUsed[i]).balanceOf(idleToken));
        totNav = totNav.add(currNav);
      }

      price = totNav.div(totalSupply); // idleToken price in token wei
  }
}

// File: contracts/interfaces/GasToken.sol

pragma solidity 0.5.16;

interface GasToken {
  function freeUpTo(uint256 value) external returns (uint256 freed);
  function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
  function balanceOf(address from) external returns (uint256 balance);
}

// File: contracts/GST2Consumer.sol

pragma solidity 0.5.16;


contract GST2Consumer {
  GasToken public constant gst2 = GasToken(0x0000000000b3F879cb30FE243b4Dfee438691c04);
  uint256[] internal gasAmounts = [14154, 41130, 27710, 7020];

  modifier gasDiscountFrom(address from) {
    uint256 initialGasLeft = gasleft();
    _;
    _makeGasDiscount(initialGasLeft - gasleft(), from);
  }

  function _makeGasDiscount(uint256 gasSpent, address from) internal {
    // For more info https://gastoken.io/
    // 14154 -> FREE_BASE -> base cost of freeing
    // 41130 -> 2 * REIMBURSE - FREE_TOKEN -> 2 * 24000 - 6870
    uint256 tokens = (gasSpent + gasAmounts[0]) / gasAmounts[1];
    uint256 safeNumTokens;
    uint256 gas = gasleft();

    // For more info https://github.com/projectchicago/gastoken/blob/master/contract/gst2_free_example.sol
    if (gas >= gasAmounts[2]) {
      safeNumTokens = (gas - gasAmounts[2]) / gasAmounts[3];
    }

    if (tokens > safeNumTokens) {
      tokens = safeNumTokens;
    }

    if (tokens > 0) {
      if (from == address(this)) {
        gst2.freeUpTo(tokens);
      } else {
        gst2.freeFromUpTo(from, tokens);
      }
    }
  }
}

// File: contracts/IdleTokenV3SUSD.sol

/**
 * @title: Idle Token (V3) main contract
 * @summary: ERC20 that holds pooled user funds together
 *           Each token rapresent a share of the underlying pools
 *           and with each token user have the right to redeem a portion of these pools
 * @author: Idle Labs Inc., idle.finance
 */
pragma solidity 0.5.16;















contract IdleTokenV3SUSD is ERC20, ERC20Detailed, ReentrancyGuard, Ownable, Pausable, IIdleTokenV3, GST2Consumer {
  using SafeERC20 for IERC20;
  using SafeMath for uint256;

  // eg. cTokenAddress => IdleCompoundAddress
  mapping(address => address) public protocolWrappers;
  // eg. DAI address
  address public token;
  // eg. iDAI address
  address public iToken; // used for claimITokens and userClaimITokens
  // Idle rebalancer current implementation address
  address public rebalancer;
  // Idle price calculator current implementation address
  address public priceCalculator;
  // Address collecting underlying fees
  address public feeAddress;
  // Last iToken price, used to pause contract in case of a black swan event
  uint256 public lastITokenPrice;
  // eg. 18 for DAI
  uint256 public tokenDecimals;
  // Max possible fee on interest gained
  uint256 constant MAX_FEE = 10000; // 100000 == 100% -> 10000 == 10%
  // Min delay for adding a new protocol
  uint256 constant NEW_PROTOCOL_DELAY = 60 * 60 * 24 * 3; // 3 days in seconds
  // Current fee on interest gained
  uint256 public fee;
  // Manual trigger for unpausing contract in case of a black swan event that caused the iToken price to not
  // return to the normal level
  bool public manualPlay;
  // Flag for disabling openRebalance for the risk adjusted variant
  bool public isRiskAdjusted;
  // Flag for disabling instant new protocols additions
  bool public isNewProtocolDelayed;
  // eg. [cTokenAddress, iTokenAddress, ...]
  address[] public allAvailableTokens;
  // last fully applied allocations (ie when all liquidity has been correctly placed)
  // eg. [5000, 0, 5000, 0] for 50% in compound, 0% fulcrum, 50% aave, 0 dydx. same order of allAvailableTokens
  uint256[] public lastAllocations;
  // Map that saves avg idleToken price paid for each user
  mapping(address => uint256) public userAvgPrices;
  // Map that saves amount with no fee for each user
  mapping(address => uint256) private userNoFeeQty;
  // timestamp when new protocol wrapper has been queued for change
  // protocol_wrapper_address -> timestamp
  mapping(address => uint256) public releaseTimes;

  /**
   * @dev constructor, initialize some variables, mainly addresses of other contracts
   *
   * @param _name : IdleToken name
   * @param _symbol : IdleToken symbol
   * @param _decimals : IdleToken decimals
   * @param _token : underlying token address
   * @param _aToken : aToken address
   * @param _rebalancer : Idle Rebalancer address
   * @param _idleAave : Idle Aave address
   */
  constructor(
    string memory _name, // eg. IdleDAI
    string memory _symbol, // eg. IDLEDAI
    uint8 _decimals, // eg. 18
    address _token,
    address _aToken,
    address _rebalancer,
    address _priceCalculator,
    address _idleAave)
    public
    ERC20Detailed(_name, _symbol, _decimals) {
      token = _token;
      tokenDecimals = ERC20Detailed(_token).decimals();
      rebalancer = _rebalancer;
      priceCalculator = _priceCalculator;
      protocolWrappers[_aToken] = _idleAave;
      allAvailableTokens = [_aToken];
  }

  // During a black swan event is possible that iToken price decreases instead of increasing,
  // with the consequence of lowering the IdleToken price. To mitigate this we implemented a
  // check on the iToken price that prevents users from minting cheap IdleTokens or rebalancing
  // the pool in this specific case. The redeemIdleToken won't be paused but the rebalance process
  // won't be triggered in this case.
  modifier whenITokenPriceHasNotDecreased() {
    if (iToken != address(0)) {
      uint256 iTokenPrice = iERC20Fulcrum(iToken).tokenPrice();
      require(
        iTokenPrice >= lastITokenPrice || manualPlay,
        "Paused: iToken price decreased"
      );

      _;

      if (iTokenPrice > lastITokenPrice) {
        lastITokenPrice = iTokenPrice;
      }
    } else {
      _;
    }
  }

  // onlyOwner
  /**
   * It allows owner to set the IdleRebalancerV3 address
   *
   * @param _rebalancer : new IdleRebalancerV3 address
   */
  function setRebalancer(address _rebalancer)
    external onlyOwner {
      require(_rebalancer != address(0), 'Addr is 0');
      rebalancer = _rebalancer;
  }
  /**
   * It allows owner to set the IdlePriceCalculator address
   *
   * @param _priceCalculator : new IdlePriceCalculator address
   */
  function setPriceCalculator(address _priceCalculator)
    external onlyOwner {
      require(_priceCalculator != address(0), 'Addr is 0');
      if (!isNewProtocolDelayed || (releaseTimes[_priceCalculator] != 0 && now - releaseTimes[_priceCalculator] > NEW_PROTOCOL_DELAY)) {
        priceCalculator = _priceCalculator;
        releaseTimes[_priceCalculator] = 0;
        return;
      }
      releaseTimes[_priceCalculator] = now;
  }

  /**
   * It allows owner to set a protocol wrapper address
   *
   * @param _token : underlying token address (eg. DAI)
   * @param _wrapper : Idle protocol wrapper address
   */
  function setProtocolWrapper(address _token, address _wrapper)
    external onlyOwner {
      require(_token != address(0) && _wrapper != address(0), 'some addr is 0');

      if (!isNewProtocolDelayed || (releaseTimes[_wrapper] != 0 && now - releaseTimes[_wrapper] > NEW_PROTOCOL_DELAY)) {
        // update allAvailableTokens if needed
        if (protocolWrappers[_token] == address(0)) {
          allAvailableTokens.push(_token);
        }
        protocolWrappers[_token] = _wrapper;
        releaseTimes[_wrapper] = 0;
        return;
      }

      releaseTimes[_wrapper] = now;
  }

  /**
   * It allows owner to unpause the contract when iToken price decreased and didn't return to the expected level
   *
   * @param _manualPlay : flag
   */
  function setManualPlay(bool _manualPlay)
    external onlyOwner {
      manualPlay = _manualPlay;
  }

  /**
   * It allows owner to disable openRebalance
   *
   * @param _isRiskAdjusted : flag
   */
  function setIsRiskAdjusted(bool _isRiskAdjusted)
    external onlyOwner {
      isRiskAdjusted = _isRiskAdjusted;
  }

  /**
   * It permanently disable instant new protocols additions
   */
  function delayNewProtocols()
    external onlyOwner {
      isNewProtocolDelayed = true;
  }

  /**
   * It allows owner to set the fee (1000 == 10% of gained interest)
   *
   * @param _fee : fee amount where 100000 is 100%, max settable is MAX_FEE constant
   */
  function setFee(uint256 _fee)
    external onlyOwner {
      require(_fee <= MAX_FEE, "Fee too high");
      fee = _fee;
  }

  /**
   * It allows owner to set the fee address
   *
   * @param _feeAddress : fee address
   */
  function setFeeAddress(address _feeAddress)
    external onlyOwner {
      require(_feeAddress != address(0), 'Addr is 0');
      feeAddress = _feeAddress;
  }

  /**
   * It allows owner to set gas parameters
   *
   * @param _amounts : fee amount where 100000 is 100%, max settable is MAX_FEE constant
   */
  function setGasParams(uint256[] calldata _amounts)
    external onlyOwner {
      gasAmounts = _amounts;
  }
  // view
  /**
   * IdleToken price calculation, in underlying
   *
   * @return : price in underlying token
   */
  function tokenPrice()
    public view
    returns (uint256 price) {
      address[] memory protocolWrappersAddresses = new address[](allAvailableTokens.length);
      for (uint256 i = 0; i < allAvailableTokens.length; i++) {
        protocolWrappersAddresses[i] = protocolWrappers[allAvailableTokens[i]];
      }
      price = IdlePriceCalculator(priceCalculator).tokenPrice(
        totalSupply(), address(this), allAvailableTokens, protocolWrappersAddresses
      );
  }

  /**
   * Get APR of every ILendingProtocol
   *
   * @return addresses: array of token addresses
   * @return aprs: array of aprs (ordered in respect to the `addresses` array)
   */
  function getAPRs()
    external view
    returns (address[] memory addresses, uint256[] memory aprs) {
      address currToken;
      addresses = new address[](allAvailableTokens.length);
      aprs = new uint256[](allAvailableTokens.length);
      for (uint256 i = 0; i < allAvailableTokens.length; i++) {
        currToken = allAvailableTokens[i];
        addresses[i] = currToken;
        aprs[i] = ILendingProtocol(protocolWrappers[currToken]).getAPR();
      }
  }

  /**
   * Get current avg APR of this IdleToken
   *
   * @return avgApr: current weighted avg apr
   */
  function getAvgAPR()
    public view
    returns (uint256 avgApr) {
      (, uint256[] memory amounts, uint256 total) = _getCurrentAllocations();
      uint256 currApr;
      uint256 weight;
      for (uint256 i = 0; i < allAvailableTokens.length; i++) {
        if (amounts[i] == 0) {
          continue;
        }
        currApr = ILendingProtocol(protocolWrappers[allAvailableTokens[i]]).getAPR();
        weight = amounts[i].mul(10**18).div(total);
        avgApr = avgApr.add(currApr.mul(weight).div(10**18));
      }
  }

  // ##### ERC20 modified transfer and transferFrom that also update the avgPrice paid for the recipient
  function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, msg.sender, allowance(sender, msg.sender).sub(amount, "ERC20: transfer amount exceeds allowance"));
    _updateAvgPrice(recipient, amount, userAvgPrices[sender]);
    return true;
  }
  function transfer(address recipient, uint256 amount) public returns (bool) {
    _transfer(msg.sender, recipient, amount);
    _updateAvgPrice(recipient, amount, userAvgPrices[msg.sender]);
    return true;
  }
  // #####

  // external
  /**
   * Used to mint IdleTokens, given an underlying amount (eg. DAI).
   * This method triggers a rebalance of the pools if needed and if _skipWholeRebalance is false
   * NOTE: User should 'approve' _amount of tokens before calling mintIdleToken
   * NOTE 2: this method can be paused
   * This method use GasTokens of this contract (if present) to get a gas discount
   *
   * @param _amount : amount of underlying token to be lended
   * @param _skipWholeRebalance : flag to choose whter to do a full rebalance or not
   * @return mintedTokens : amount of IdleTokens minted
   */
  function mintIdleToken(uint256 _amount, bool _skipWholeRebalance)
    external nonReentrant gasDiscountFrom(address(this))
    returns (uint256 mintedTokens) {
    return _mintIdleToken(_amount, new uint256[](0), _skipWholeRebalance);
  }

  /**
   * DEPRECATED: Used to mint IdleTokens, given an underlying amount (eg. DAI).
   * Keep for backward compatibility with IdleV2
   *
   * @param _amount : amount of underlying token to be lended
   * @param : not used, pass empty array
   * @return mintedTokens : amount of IdleTokens minted
   */
  function mintIdleToken(uint256 _amount, uint256[] calldata)
    external nonReentrant gasDiscountFrom(address(this))
    returns (uint256 mintedTokens) {
    return _mintIdleToken(_amount, new uint256[](0), false);
  }

  /**
   * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
   * This method triggers a rebalance of the pools if needed
   * NOTE: If the contract is paused or iToken price has decreased one can still redeem but no rebalance happens.
   * NOTE 2: If iToken price has decresed one should not redeem (but can do it) otherwise he would capitalize the loss.
   *         Ideally one should wait until the black swan event is terminated
   *
   * @param _amount : amount of IdleTokens to be burned
   * @param _skipRebalance : whether to skip the rebalance process or not
   * @param : not used
   * @return redeemedTokens : amount of underlying tokens redeemed
   */
  function redeemIdleToken(uint256 _amount, bool _skipRebalance, uint256[] calldata)
    external nonReentrant
    returns (uint256 redeemedTokens) {
      uint256 balance;
      for (uint256 i = 0; i < allAvailableTokens.length; i++) {
        balance = IERC20(allAvailableTokens[i]).balanceOf(address(this));
        if (balance == 0) {
          continue;
        }
        redeemedTokens = redeemedTokens.add(
          _redeemProtocolTokens(
            protocolWrappers[allAvailableTokens[i]],
            allAvailableTokens[i],
            // _amount * protocolPoolBalance / idleSupply
            _amount.mul(balance).div(totalSupply()), // amount to redeem
            address(this)
          )
        );
      }

      _burn(msg.sender, _amount);
      if (fee > 0 && feeAddress != address(0)) {
        redeemedTokens = _getFee(_amount, redeemedTokens);
      }
      // send underlying minus fee to msg.sender
      IERC20(token).safeTransfer(msg.sender, redeemedTokens);

      if (this.paused() || iERC20Fulcrum(iToken).tokenPrice() < lastITokenPrice || _skipRebalance) {
        return redeemedTokens;
      }

      _rebalance(0, false);
  }

  /**
   * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
   * and send interest-bearing tokens (eg. cDAI/iDAI) directly to the user.
   * Underlying (eg. DAI) is not redeemed here.
   *
   * @param _amount : amount of IdleTokens to be burned
   */
  function redeemInterestBearingTokens(uint256 _amount)
    external nonReentrant {
      uint256 idleSupply = totalSupply();
      address currentToken;
      uint256 balance;

      for (uint256 i = 0; i < allAvailableTokens.length; i++) {
        currentToken = allAvailableTokens[i];
        balance = IERC20(currentToken).balanceOf(address(this));
        if (balance == 0) {
          continue;
        }
        IERC20(currentToken).safeTransfer(
          msg.sender,
          _amount.mul(balance).div(idleSupply) // amount to redeem
        );
      }

      _burn(msg.sender, _amount);
  }

  /**
   * Allow any users to set new allocations as long as the new allocations
   * give a better avg APR than before
   * Allocations should be in the format [100000, 0, 0, 0, ...] where length is the same
   * as lastAllocations variable and the sum of all value should be == 100000
   *
   * This method is not callble if this instance of IdleToken is a risk adjusted instance
   * NOTE: this method can be paused
   *
   * @param _newAllocations : array with new allocations in percentage
   * @return : whether has rebalanced or not
   * @return avgApr : the new avg apr after rebalance
   */
  function openRebalance(uint256[] calldata _newAllocations)
    external whenNotPaused whenITokenPriceHasNotDecreased
    returns (bool, uint256 avgApr) {
      require(!isRiskAdjusted, "Setting allocations not allowed");
      uint256 initialAPR = getAvgAPR();
      // Validate and update rebalancer allocations
      IdleRebalancerV3(rebalancer).setAllocations(_newAllocations, allAvailableTokens);
      bool hasRebalanced = _rebalance(0, false);
      uint256 newAprAfterRebalance = getAvgAPR();
      require(newAprAfterRebalance > initialAPR, "APR not improved");
      return (hasRebalanced, newAprAfterRebalance);
  }

  /**
   * Dynamic allocate all the pool across different lending protocols if needed, use gas refund from gasToken
   *
   * NOTE: this method can be paused.
   * msg.sender should approve this contract to spend GST2 tokens before calling
   * this method
   *
   * @return : whether has rebalanced or not
   */
  function rebalanceWithGST()
    external gasDiscountFrom(msg.sender)
    returns (bool) {
      return _rebalance(0, false);
  }

  /**
   * DEPRECATED: Dynamic allocate all the pool across different lending protocols if needed,
   * Keep for backward compatibility with IdleV2
   *
   * NOTE: this method can be paused
   *
   * @param : not used
   * @param : not used
   * @return : whether has rebalanced or not
   */
  function rebalance(uint256, uint256[] calldata)
    external returns (bool) {
    return _rebalance(0, false);
  }

  /**
   * Dynamic allocate all the pool across different lending protocols if needed,
   * rebalance without params
   *
   * NOTE: this method can be paused
   *
   * @return : whether has rebalanced or not
   */
  function rebalance() external returns (bool) {
    return _rebalance(0, false);
  }

  /**
   * Get the contract balance of every protocol currently used
   *
   * @return tokenAddresses : array with all token addresses used,
   *                          eg [cTokenAddress, iTokenAddress]
   * @return amounts : array with all amounts for each protocol in order,
   *                   eg [amountCompoundInUnderlying, amountFulcrumInUnderlying]
   * @return total : total AUM in underlying
   */
  function getCurrentAllocations() external view
    returns (address[] memory tokenAddresses, uint256[] memory amounts, uint256 total) {
    return _getCurrentAllocations();
  }

  // internal
  /**
   * Used to mint IdleTokens, given an underlying amount (eg. DAI).
   * This method triggers a rebalance of the pools if needed
   * NOTE: User should 'approve' _amount of tokens before calling mintIdleToken
   * NOTE 2: this method can be paused
   * This method use GasTokens of this contract (if present) to get a gas discount
   *
   * @param _amount : amount of underlying token to be lended
   * @param : not used
   * @param _skipWholeRebalance : flag to decide if doing a simple mint or mint + rebalance
   * @return mintedTokens : amount of IdleTokens minted
   */
  function _mintIdleToken(uint256 _amount, uint256[] memory, bool _skipWholeRebalance)
    internal whenNotPaused whenITokenPriceHasNotDecreased
    returns (uint256 mintedTokens) {
      // Get current IdleToken price
      uint256 idlePrice = tokenPrice();
      // transfer tokens to this contract
      IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);

      // Rebalance the current pool if needed and mint new supplied amount
      _rebalance(0, _skipWholeRebalance);

      mintedTokens = _amount.mul(10**18).div(idlePrice);
      _mint(msg.sender, mintedTokens);

      _updateAvgPrice(msg.sender, mintedTokens, idlePrice);
  }

  /**
   * Dynamic allocate all the pool across different lending protocols if needed
   *
   * NOTE: this method can be paused
   *
   * @param : not used
   * @return : whether has rebalanced or not
   */
  function _rebalance(uint256, bool _skipWholeRebalance)
    internal whenNotPaused whenITokenPriceHasNotDecreased
    returns (bool) {
      // check if we need to rebalance by looking at the allocations in rebalancer contract
      uint256[] memory rebalancerLastAllocations = IdleRebalancerV3(rebalancer).getAllocations();
      bool areAllocationsEqual = rebalancerLastAllocations.length == lastAllocations.length;
      if (areAllocationsEqual) {
        for (uint256 i = 0; i < lastAllocations.length || !areAllocationsEqual; i++) {
          if (lastAllocations[i] != rebalancerLastAllocations[i]) {
            areAllocationsEqual = false;
            break;
          }
        }
      }
      uint256 balance = IERC20(token).balanceOf(address(this));
      if (areAllocationsEqual && balance == 0) {
        return false;
      }

      if (balance > 0) {
        if (lastAllocations.length == 0 && _skipWholeRebalance) {
          // set in storage
          lastAllocations = rebalancerLastAllocations;
        }
        _mintWithAmounts(allAvailableTokens, _amountsFromAllocations(rebalancerLastAllocations, balance));
      }

      if (_skipWholeRebalance || areAllocationsEqual) {
        return false;
      }

      // Instead of redeeming everything during rebalance we redeem and mint only what needs
      // to be reallocated
      // get current allocations in underlying
      (address[] memory tokenAddresses, uint256[] memory amounts, uint256 totalInUnderlying) = _getCurrentAllocations();
      // calculate new allocations given the total
      uint256[] memory newAmounts = _amountsFromAllocations(rebalancerLastAllocations, totalInUnderlying);
      (uint256[] memory toMintAllocations, uint256 totalToMint, bool lowLiquidity) = _redeemAllNeeded(tokenAddresses, amounts, newAmounts);

      // if some protocol has liquidity that we should redeem, we do not update
      // lastAllocations to force another rebalance next time
      if (!lowLiquidity) {
        // Update lastAllocations with rebalancerLastAllocations
        delete lastAllocations;
        lastAllocations = rebalancerLastAllocations;
      }
      uint256 totalRedeemd = IERC20(token).balanceOf(address(this));
      if (totalRedeemd > 1 && totalToMint > 1) {
        // Do not mint directly using toMintAllocations check with totalRedeemd
        uint256[] memory tempAllocations = new uint256[](toMintAllocations.length);
        for (uint256 i = 0; i < toMintAllocations.length; i++) {
          // Calc what would have been the correct allocations percentage if all was available
          tempAllocations[i] = toMintAllocations[i].mul(100000).div(totalToMint);
        }

        uint256[] memory partialAmounts = _amountsFromAllocations(tempAllocations, totalRedeemd);
        _mintWithAmounts(allAvailableTokens, partialAmounts);
      }

      return true; // hasRebalanced
  }

  /**
   * Update avg price paid for each idle token of a user
   *
   * @param usr : user that should have balance update
   * @param qty : new amount deposited / transferred, in idleToken
   * @param price : curr idleToken price in underlying
   */
  function _updateAvgPrice(address usr, uint256 qty, uint256 price) internal {
    if (fee == 0) {
      userNoFeeQty[usr] = userNoFeeQty[usr].add(qty);
      return;
    }

    uint256 totBalance = balanceOf(usr).sub(userNoFeeQty[usr]);
    uint256 oldAvgPrice = userAvgPrices[usr];
    uint256 oldBalance = totBalance.sub(qty);
    userAvgPrices[usr] = oldAvgPrice.mul(oldBalance).div(totBalance).add(price.mul(qty).div(totBalance));
  }

  /**
   * Calculate fee and send them to feeAddress
   *
   * @param amount : in idleTokens
   * @param redeemed : in underlying
   * @return : net value in underlying
   */
  function _getFee(uint256 amount, uint256 redeemed) internal returns (uint256) {
    uint256 noFeeQty = userNoFeeQty[msg.sender];
    uint256 currPrice = tokenPrice();
    if (noFeeQty > 0 && noFeeQty > amount) {
      noFeeQty = amount;
    }

    uint256 totalValPaid = noFeeQty.mul(currPrice).add(amount.sub(noFeeQty).mul(userAvgPrices[msg.sender])).div(10**18);
    uint256 currVal = amount.mul(currPrice).div(10**18);
    if (currVal < totalValPaid) {
      return redeemed;
    }
    uint256 gain = currVal.sub(totalValPaid);
    uint256 feeDue = gain.mul(fee).div(100000);
    IERC20(token).safeTransfer(feeAddress, feeDue);
    userNoFeeQty[msg.sender] = userNoFeeQty[msg.sender].sub(noFeeQty);
    return currVal.sub(feeDue);
  }

  /**
   * Mint specific amounts of protocols tokens
   *
   * @param tokenAddresses : array of protocol tokens
   * @param protocolAmounts : array of amounts to be minted
   * @return : net value in underlying
   */
  function _mintWithAmounts(address[] memory tokenAddresses, uint256[] memory protocolAmounts) internal {
    // mint for each protocol and update currentTokensUsed
    require(tokenAddresses.length == protocolAmounts.length, "All tokens length != allocations length");

    uint256 currAmount;

    for (uint256 i = 0; i < protocolAmounts.length; i++) {
      currAmount = protocolAmounts[i];
      if (currAmount == 0) {
        continue;
      }
      _mintProtocolTokens(protocolWrappers[tokenAddresses[i]], currAmount);
    }
  }

  /**
   * Calculate amounts from percentage allocations (100000 => 100%)
   *
   * @param allocations : array of protocol allocations in percentage
   * @param total : total amount
   * @return : array with amounts
   */
  function _amountsFromAllocations(uint256[] memory allocations, uint256 total)
    internal pure returns (uint256[] memory) {
    uint256[] memory newAmounts = new uint256[](allocations.length);
    uint256 currBalance = 0;
    uint256 allocatedBalance = 0;

    for (uint256 i = 0; i < allocations.length; i++) {
      if (i == allocations.length - 1) {
        newAmounts[i] = total.sub(allocatedBalance);
      } else {
        currBalance = total.mul(allocations[i]).div(100000);
        allocatedBalance = allocatedBalance.add(currBalance);
        newAmounts[i] = currBalance;
      }
    }
    return newAmounts;
  }

  /**
   * Redeem all underlying needed from each protocol
   *
   * @param tokenAddresses : array of protocol tokens addresses
   * @param amounts : array with current allocations in underlying
   * @param newAmounts : array with new allocations in underlying
   * @return toMintAllocations : array with amounts to be minted
   * @return totalToMint : total amount that needs to be minted
   */
  function _redeemAllNeeded(
    address[] memory tokenAddresses,
    uint256[] memory amounts,
    uint256[] memory newAmounts
    ) internal returns (
      uint256[] memory toMintAllocations,
      uint256 totalToMint,
      bool lowLiquidity
    ) {
    require(amounts.length == newAmounts.length, 'Lengths not equal');
    toMintAllocations = new uint256[](amounts.length);
    ILendingProtocol protocol;
    uint256 currAmount;
    uint256 newAmount;
    address currToken;
    // check the difference between amounts and newAmounts
    for (uint256 i = 0; i < amounts.length; i++) {
      currToken = tokenAddresses[i];
      newAmount = newAmounts[i];
      currAmount = amounts[i];
      protocol = ILendingProtocol(protocolWrappers[currToken]);
      if (currAmount > newAmount) {
        toMintAllocations[i] = 0;
        uint256 toRedeem = currAmount.sub(newAmount);
        uint256 availableLiquidity = protocol.availableLiquidity();
        if (availableLiquidity < toRedeem) {
          lowLiquidity = true;
          toRedeem = availableLiquidity;
        }
        // redeem the difference
        _redeemProtocolTokens(
          protocolWrappers[currToken],
          currToken,
          // convert amount from underlying to protocol token
          toRedeem.mul(10**18).div(protocol.getPriceInToken()),
          address(this) // tokens are now in this contract
        );
      } else {
        toMintAllocations[i] = newAmount.sub(currAmount);
        totalToMint = totalToMint.add(toMintAllocations[i]);
      }
    }
  }

  /**
   * Get the contract balance of every protocol currently used
   *
   * @return tokenAddresses : array with all token addresses used,
   *                          eg [cTokenAddress, iTokenAddress]
   * @return amounts : array with all amounts for each protocol in order,
   *                   eg [amountCompoundInUnderlying, amountFulcrumInUnderlying]
   * @return total : total AUM in underlying
   */
  function _getCurrentAllocations() internal view
    returns (address[] memory tokenAddresses, uint256[] memory amounts, uint256 total) {
      // Get balance of every protocol implemented
      tokenAddresses = new address[](allAvailableTokens.length);
      amounts = new uint256[](allAvailableTokens.length);

      address currentToken;
      uint256 currTokenPrice;

      for (uint256 i = 0; i < allAvailableTokens.length; i++) {
        currentToken = allAvailableTokens[i];
        tokenAddresses[i] = currentToken;
        currTokenPrice = ILendingProtocol(protocolWrappers[currentToken]).getPriceInToken();
        amounts[i] = currTokenPrice.mul(
          IERC20(currentToken).balanceOf(address(this))
        ).div(10**18);
        total = total.add(amounts[i]);
      }

      // return addresses and respective amounts in underlying
      return (tokenAddresses, amounts, total);
  }

  // ILendingProtocols calls
  /**
   * Mint protocol tokens through protocol wrapper
   *
   * @param _wrapperAddr : address of protocol wrapper
   * @param _amount : amount of underlying to be lended
   * @return tokens : new tokens minted
   */
  function _mintProtocolTokens(address _wrapperAddr, uint256 _amount)
    internal
    returns (uint256 tokens) {
      if (_amount == 0) {
        return tokens;
      }
      // Transfer _amount underlying token (eg. DAI) to _wrapperAddr
      IERC20(token).safeTransfer(_wrapperAddr, _amount);
      tokens = ILendingProtocol(_wrapperAddr).mint();
  }

  /**
   * Redeem underlying tokens through protocol wrapper
   *
   * @param _wrapperAddr : address of protocol wrapper
   * @param _amount : amount of `_token` to redeem
   * @param _token : protocol token address
   * @param _account : should be msg.sender when rebalancing and final user when redeeming
   * @return tokens : new tokens minted
   */
  function _redeemProtocolTokens(address _wrapperAddr, address _token, uint256 _amount, address _account)
    internal
    returns (uint256 tokens) {
      if (_amount == 0) {
        return tokens;
      }
      // Transfer _amount of _protocolToken (eg. cDAI) to _wrapperAddr
      IERC20(_token).safeTransfer(_wrapperAddr, _amount);
      tokens = ILendingProtocol(_wrapperAddr).redeem(_account);
  }
}