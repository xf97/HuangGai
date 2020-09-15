/**
 *Submitted for verification at Etherscan.io on 2020-08-05
*/

/*
DEAR MSG.SENDER(S):

/ LexART is a project in beta.
// Please audit and use at your own risk.
/// There is also a DAO to join if you're curious.
//// This is code, don't construed this as legal advice or replacement for professional counsel.
///// STEAL THIS C0D3SL4W

~presented by Open, ESQ || LexDAO LLC || LexART DAO
*/

pragma solidity 0.5.17;

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
    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

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

contract LexDAORole is Context {
    using Roles for Roles.Role;

    event LexDAOadded(address indexed account);
    event LexDAOremoved(address indexed account);

    Roles.Role private _lexDAOs;

    modifier onlyLexDAO() {
        require(isLexDAO(_msgSender()), "LexDAORole: caller does not have the LexDAO role");
        _;
    }

    function isLexDAO(address account) public view returns (bool) {
        return _lexDAOs.has(account);
    }

    function addLexDAO(address account) public onlyLexDAO {
        _addLexDAO(account);
    }

    function renounceLexDAO() public {
        _removeLexDAO(_msgSender());
    }

    function _addLexDAO(address account) internal {
        _lexDAOs.add(account);
        emit LexDAOadded(account);
    }

    function _removeLexDAO(address account) internal {
        _lexDAOs.remove(account);
        emit LexDAOremoved(account);
    }
}

contract MinterRole is Context {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    Roles.Role private _minters;

    modifier onlyMinter() {
        require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
        _;
    }

    function isMinter(address account) public view returns (bool) {
        return _minters.has(account);
    }

    function addMinter(address account) public onlyMinter {
        _addMinter(account);
    }

    function renounceMinter() public {
        _removeMinter(_msgSender());
    }

    function _addMinter(address account) internal {
        _minters.add(account);
        emit MinterAdded(account);
    }

    function _removeMinter(address account) internal {
        _minters.remove(account);
        emit MinterRemoved(account);
    }
}

contract PauserRole is Context {
    using Roles for Roles.Role;

    event PauserAdded(address indexed account);
    event PauserRemoved(address indexed account);

    Roles.Role private _pausers;

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

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
contract Pausable is PauserRole {
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
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

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

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20MinterPauser}.
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
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
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
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

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
     * - the caller must have allowance for ``sender``'s tokens of at least
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

        _beforeTokenTransfer(sender, recipient, amount);

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

        _beforeTokenTransfer(address(0), account, amount);

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

        _beforeTokenTransfer(account, address(0), amount);

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
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal { }
}

/**
 * @dev Extension of {ERC20} that allows token holders to destroy both their own
 * tokens and those that they have an allowance for, in a way that can be
 * recognized off-chain (via event analysis).
 */
contract ERC20Burnable is ERC20 {
    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) public {
        uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");

        _approve(account, _msgSender(), decreasedAllowance);
        _burn(account, amount);
    }
}

/**
 * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
 */
contract ERC20Capped is ERC20 {
    uint256 private _cap;

    /**
     * @dev Sets the value of the `cap`. This value is immutable, it can only be
     * set once during construction.
     */
    constructor (uint256 cap) public {
        require(cap > 0, "ERC20Capped: cap is 0");
        _cap = cap;
    }

    /**
     * @dev Returns the cap on the token's total supply.
     */
    function cap() public view returns (uint256) {
        return _cap;
    }

    /**
     * @dev See {ERC20-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - minted tokens must not cause the total supply to go over the cap.
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal {
        super._beforeTokenTransfer(from, to, amount);

        if (from == address(0)) { // When minting tokens
            require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
        }
    }
}

/**
 * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
 * which have permission to mint (create) new tokens as they see fit.
 *
 */
contract ERC20Mintable is MinterRole, ERC20 {
    /**
     * @dev See {ERC20-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the {MinterRole}.
     */
    function mint(address account, uint256 amount) public onlyMinter returns (bool) {
        _mint(account, amount);
        return true;
    }
}

/**
 * @dev ERC20 token with pausable token transfers, minting and burning.
 *
 * Useful for scenarios such as preventing trades until the end of an evaluation
 * period, or having an emergency switch for freezing all token transfers in the
 * event of a large bug.
 */
contract ERC20Pausable is Pausable, ERC20 {
    /**
     * @dev See {ERC20-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - the contract must not be paused.
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal {
        super._beforeTokenTransfer(from, to, amount);

        require(!paused(), "ERC20Pausable: token transfer while paused");
    }
}

/**
 * @dev Implementation of ERC20 standard designed for detailed tokenization with optional lexDAO governance.
 */
contract LexArt is LexDAORole, ERC20Burnable, ERC20Capped, ERC20Mintable, ERC20Pausable {

    uint256 public periodDuration = 86400; // default = 1 day (or 86400 seconds)

    //***** Art *****//
    // address payable public owner; // owner of LexArt
    address public buyer; // buyer of LexArt
    string public artworkHash; // hash of artwork
    string public certificateHash; // hash of certificate of authenticity
    uint8 public ownerOffered; // 1 = offer active, 0 = offer inactive
    uint256 public transactionValue; // pricing for LexArt
    uint256 public totalRoyaltyPayout; // total royalties payout for this LexArt


    //***** Royalties *****//
    struct Owner {
        address payable ownerAddress;
        uint8 royalties;
        uint256 royaltiesReceived;
        uint8 gifted; // 1 = gifted (gifted owner retains royalties), 0 = not gifted
    }

    uint8 public startingRoyalties = 10; // percentage of royalty retained by minter-owner
    uint8 public ownerCount = 0; // total owners of Art
    mapping(uint256 => Owner) public owners; // a dictionary of owners


    //***** License *****//
    struct License {
        // license details set by original owner
        address licensee;
        uint256 licenseFee;
        string licenseDocument;
        uint8 licensePeriodLength; // Number of periodDuration a license will last

        // time related license data
        uint256 licenseStartTime;
        uint256 licenseEndTime;
        uint8 licensePeriodLengthReached; // 1 = reached, 0 = not reached

        // license results
        uint8 licenseOffered; // 1 = offer active, 0 = offer inactive
        uint8 licenseCompleted; // 1 = license completed, 0 = license incomplete
        uint8 licenseTerminated; // 1 = license terminated, 0 = license not terminated
        string licenseReport; // Licensee submits license report to complete active license
        string terminationDetail; // Mintor-owner submits termination detail to terminate an active license
    }

    uint8 public licenseCount = 0; // total license created
    mapping(uint256 => License) public licenses; // a dictionary of licenses


    //***** Events *****//
    event LexDAOtransferred(string indexed details);
    event ArtworkUpdated(string indexed _artworkHash);
    event CertificateUpdated(string indexed _certificatekHash);
    event LicenseCreated(address _licensee, string indexed _licenseDocument, uint8 _licenseDuration, uint256 _licenseStartTime);

    constructor (
        string memory name,
        string memory symbol,
        string memory _artworkHash,
        string memory _certificateHash,
        address payable _owner,
        address _lexDAO) public
        ERC20(name, symbol)
        ERC20Capped(1) {
        artworkHash = _artworkHash;
        certificateHash = _certificateHash;

        owners[ownerCount].ownerAddress = _owner;
        owners[ownerCount].royalties = startingRoyalties;

	    _addLexDAO(_lexDAO);
        _addMinter(owners[ownerCount].ownerAddress);
        _addPauser(_lexDAO);
        _mint(owners[ownerCount].ownerAddress, 1);
        _setupDecimals(0);
    }

    function giftLexART(address payable newOwner) public payable {
        require(msg.sender == owners[ownerCount].ownerAddress, "You do not currently own this Art!");
        require(newOwner != owners[ownerCount].ownerAddress, "Owner cannot gift to herself!");

        _transfer(owners[ownerCount].ownerAddress, newOwner, 1);

        ownerCount += 1;
        owners[ownerCount].ownerAddress = newOwner;
        owners[ownerCount].royalties = decayRoyalties(owners[ownerCount - 1].royalties);
        owners[ownerCount].gifted = 1;
    }

    function decayRoyalties(uint8 royalties) private view returns (uint8) {
        if (royalties <= startingRoyalties) {
            if (royalties > 0) {
                royalties = royalties - 1;
                return royalties;
            }
        }
    }

    // owner makes offer by assigning buyer
    function makeOffer(address _buyer, uint256 _transactionValue) public {
        require(msg.sender == owners[ownerCount].ownerAddress, "You are not the owner!");
        require(_buyer != owners[ownerCount].ownerAddress, "Owner cannot be a buyer!");
        require(_transactionValue != 0, "Transaction value cannot be 0!");

        transactionValue = _transactionValue;
        buyer = _buyer;
        ownerOffered = 1;
    }

    // distribute royalties
    function distributeRoyalties(uint256 _transactionValue) private returns (uint256) {
        uint256 totalPayout = _transactionValue.div(100);
        uint256 royaltyPayout;

        // royalties distribution
        for (uint256 i = 0; i <= ownerCount; i++) {
            uint256 eachPayout;

            eachPayout = totalPayout.mul(owners[i].royalties);
            royaltyPayout += eachPayout;

            owners[i].ownerAddress.transfer(eachPayout);
            owners[i].royaltiesReceived += eachPayout;
        }
        return royaltyPayout;
    }

    // buyer accepts offer
    function acceptOffer() public payable {
        require(msg.sender == buyer, "You are not the buyer to accept owner's offer!");
        require(msg.value == transactionValue, "Incorrect payment amount!");
        require(ownerOffered == 1, "Owner has not made any offer!");

        // Calculate royalty payout
        uint256 royaltyPayout = distributeRoyalties(transactionValue);

        // Calculate all time royalty payout
        totalRoyaltyPayout += royaltyPayout;

        // Owner receives transactionValue less royaltyPayout
        owners[ownerCount].ownerAddress.transfer(transactionValue - royaltyPayout);
        _transfer(owners[ownerCount].ownerAddress, buyer, 1);

        // Add new owner to owners mapping
        ownerCount += 1;
        owners[ownerCount].ownerAddress = msg.sender;
        owners[ownerCount].royalties = decayRoyalties(owners[ownerCount - 1].royalties);
        owners[ownerCount].gifted = 0;

        // Complete owner's offer
        ownerOffered = 0;
    }

    // creator can create license accepted only by designated licensee
    function createLicense(
        address _licensee,
        uint256 _licenseFee,
        string memory _licenseDocument,
        uint8 _licensePeriodLength) public {
        require(msg.sender == owners[0].ownerAddress, "You are not the minter-owner!");
        require(_licensee != owners[0].ownerAddress, "Mintor-owner doesn't need a license!");
        require(_licensee != address(0), "Licensee zeroed!");
        require(_licensePeriodLength != 0, "License is set to 0 days!");

        License memory license = License({
            licensee : _licensee,
            licenseFee : _licenseFee,
            licenseDocument : _licenseDocument,
            licensePeriodLength : _licensePeriodLength,
            licenseStartTime : 0,
            licenseEndTime : 0,
            licensePeriodLengthReached : 0,
            licenseOffered : 1,
            licenseCompleted : 0,
            licenseTerminated : 0,
            licenseReport : "",
            terminationDetail : ""
        });

        licenses[licenseCount] = license;
        emit LicenseCreated(licenses[licenseCount].licensee, licenses[licenseCount].licenseDocument, licenses[licenseCount].licensePeriodLength, licenses[licenseCount].licenseStartTime);

        licenseCount += 1;
    }

    // designated licensee can accept license
    function acceptLicense(uint256 _licenseCount) public payable {
        require(msg.sender == licenses[_licenseCount].licensee, "Not licensee!");
        require(msg.value == licenses[_licenseCount].licenseFee, "Licensee fee incorrect!");
        require(licenses[_licenseCount].licenseOffered == 1, "Cannot accept offer never created or already claimed!");

        // record time of acceptance... maybe connect LexGrow for escrow?
        licenses[_licenseCount].licenseStartTime = now;

        // license contract formed and so license offer is no longer active
        licenses[_licenseCount].licenseOffered = 0;

        // licensee pays licensee fee
        owners[0].ownerAddress.transfer(msg.value);
    }

    // licensee can complete active licenses
    function completeLicense(uint256 _licenseCount, string memory _licenseReport) public payable {
        require(msg.sender == licenses[_licenseCount].licensee, "Not licensee!");
        require(msg.value > 0, "Cannot complete a license without paying!"); // is this needed??????????
        require(licenses[_licenseCount].licenseOffered == 0, "Cannot complete a license that is pending acceptance!");
        require(licenses[_licenseCount].licenseTerminated == 0, "Cannot complete a license that has been terminated!");

        licenses[_licenseCount].licenseReport = _licenseReport;
        owners[0].ownerAddress.transfer(msg.value);
        licenses[_licenseCount].licenseCompleted = 1;
        licenses[_licenseCount].licenseEndTime = now;

        // Record whether the license has lapsed
        getCurrentPeriod(_licenseCount) > licenses[_licenseCount].licensePeriodLength ? licenses[_licenseCount].licensePeriodLengthReached = 1 : licenses[_licenseCount].licensePeriodLengthReached = 0;
    }

    // creator can terminate active licenses
    function terminateLicense(uint256 _licenseCount, string memory _terminationDetail) public {
        require(msg.sender == owners[0].ownerAddress, "You are not the creator!");
        require(licenses[_licenseCount].licensee != address(0), "License does not have a licensee!");
        require(licenses[_licenseCount].licenseOffered == 0, "Cannot terminate a license not accepted by licensee!");
        require(licenses[_licenseCount].licenseCompleted == 0, "Cannot terminate a license that has been completed!");

        licenses[_licenseCount].terminationDetail = _terminationDetail;
        licenses[_licenseCount].licenseTerminated = 1;
        licenses[_licenseCount].licenseEndTime = now;

        // Record whether the license has lapsed
        getCurrentPeriod(_licenseCount) > licenses[_licenseCount].licensePeriodLength ? licenses[_licenseCount].licensePeriodLengthReached = 1 : licenses[_licenseCount].licensePeriodLengthReached = 0;
    }

    function getCurrentPeriod(uint256 _licenseCount) public view returns (uint256) {
        return now.sub(licenses[_licenseCount].licenseStartTime).div(periodDuration);
    }

     /***************
    LEXDAO FUNCTIONS
    ***************/

    // DAO can vote to effectuate transfer of this token
    function lexDAOtransfer(string memory details, address currentOwner, address newOwner) public onlyLexDAO {
        _transfer(currentOwner, newOwner, 1);
        emit LexDAOtransferred(details);
    }

    // DAO can vote to burn this token
    function lexDAOburn(string memory details, address currentOwner) public onlyLexDAO {
        _burn(currentOwner, 1);
        emit LexDAOtransferred(details);
    }

    // DAO can vote to update artwork hash
    function updateArtworkHash(string memory _artworkHash) public onlyLexDAO {
        artworkHash = _artworkHash; // pauser admin(s) adjust token stamp
        emit ArtworkUpdated(_artworkHash);
    }

    // DAO can vote to update certificate hash
    function updateCertificateHash(string memory _certificateHash) public onlyLexDAO {
        certificateHash = _certificateHash;
        emit CertificateUpdated(_certificateHash);
    }
}

/**
 * @dev Factory pattern to create new token contracts with LexARTDAO governance.
 */
contract LexArtFactory is Context {

    string public factoryName;
    uint256 public factoryFee = 5000000000000000; // default - 0.005 Ξ
    address payable public lexDAO = 0x9455b183F9a6f716F8F46E5C6856A9775e40240d; // WARNING: This is a LexART DAO temp account.
    address payable public factoryOwner; // owner of LexArtFactory

    address[] public arts;

    event FactoryFeeUpdated(uint256 indexed _factoryFee);
    event FactoryNameUpdated(string indexed _factoryName);
    event FactoryOwnerUpdated(address indexed _factoryOwner);
    event LexDAOpaid(string indexed details, uint256 indexed payment, address indexed sender);
    event LexDAOupdated(address indexed lexDAO);
    event LexTokenDeployed(address indexed LT, address indexed owner, bool indexed _lexDAOgoverned);

    constructor (string memory _factoryName) public {
        factoryName = _factoryName;
        factoryOwner = lexDAO;
    }

    function newLexArt(
        string memory name,
        string memory symbol,
        string memory artworkHash,
        string memory certificateHash
        ) payable public {

        require(msg.sender == factoryOwner, "Only factory owners can mint Art!");
	    require(msg.value == factoryFee, "Factory Fee not attached!");

        LexArt LA = new LexArt (
            name,
            symbol,
            artworkHash,
            certificateHash,
            factoryOwner,
            lexDAO);

        arts.push(address(LA));
        address(lexDAO).transfer(msg.value);
    }

    function getLexArtCount() public view returns (uint256 LexArtCount) {
        return arts.length;
    }

    /***************
    LEXDAO FUNCTIONS
    ***************/
    modifier onlyLexDAO () {
        require(_msgSender() == lexDAO, "caller not lexDAO");
        _;
    }

    function updateFactoryFee(uint256 _factoryFee) public onlyLexDAO {
       factoryFee = _factoryFee;
       emit FactoryFeeUpdated(_factoryFee);
    }

    function updateFactoryName(string memory _factoryName) public {
        require(msg.sender == factoryOwner, "Not factory owner!");
        factoryName = _factoryName;
        emit FactoryNameUpdated(_factoryName);
    }

    function assignFactoryOwner(address payable _factoryOwner) public onlyLexDAO {
        require(msg.sender == lexDAO, "Not factory owner!");
        factoryOwner = _factoryOwner;
        emit FactoryOwnerUpdated(_factoryOwner);
    }

    function updateLexDAO(address payable __lexDAO) public onlyLexDAO {
        lexDAO = __lexDAO;
        emit LexDAOupdated(lexDAO);
    }
}