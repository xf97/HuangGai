/**
 *Submitted for verification at Etherscan.io on 2020-08-12
*/

// File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol

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

// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol

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

// File: @openzeppelin/contracts-ethereum-package/contracts/utils/Address.sol

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

// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/SafeERC20.sol

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

// File: @openzeppelin/upgrades/contracts/Initializable.sol

pragma solidity >=0.4.24 <0.7.0;


/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol

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
contract Context is Initializable {
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

// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20.sol

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
contract ERC20 is Initializable, Context, IERC20 {
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

    uint256[50] private ______gap;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Detailed.sol

pragma solidity ^0.5.0;



/**
 * @dev Optional functions from the ERC20 standard.
 */
contract ERC20Detailed is Initializable, IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    function initialize(string memory name, string memory symbol, uint8 decimals) public initializer {
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

    uint256[50] private ______gap;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/utils/ReentrancyGuard.sol

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
contract ReentrancyGuard is Initializable {
    // counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    function initialize() public initializer {
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

    uint256[50] private ______gap;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;



/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Initializable, Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    function initialize(address sender) public initializer {
        _owner = sender;
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
     * > Note: Renouncing ownership will leave the contract without an owner,
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

    uint256[50] private ______gap;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/access/Roles.sol

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

// File: @openzeppelin/contracts-ethereum-package/contracts/access/roles/PauserRole.sol

pragma solidity ^0.5.0;




contract PauserRole is Initializable, Context {
    using Roles for Roles.Role;

    event PauserAdded(address indexed account);
    event PauserRemoved(address indexed account);

    Roles.Role private _pausers;

    function initialize(address sender) public initializer {
        if (!isPauser(sender)) {
            _addPauser(sender);
        }
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

    uint256[50] private ______gap;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/lifecycle/Pausable.sol

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
contract Pausable is Initializable, Context, PauserRole {
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
    function initialize(address sender) public initializer {
        PauserRole.initialize(sender);

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

    uint256[50] private ______gap;
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

// File: contracts/interfaces/IGovToken.sol

pragma solidity 0.5.16;

interface IGovToken {
  function redeemGovTokens() external;
}

// File: contracts/interfaces/IIdleTokenV3_1.sol

/**
 * @title: Idle Token interface
 * @author: Idle Labs Inc., idle.finance
 */
pragma solidity 0.5.16;

interface IIdleTokenV3_1 {
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
   * @param _skipRebalance : flag for skipping rebalance for lower gas price
   * @param _referral : referral address
   * @return mintedTokens : amount of IdleTokens minted
   */
  function mintIdleToken(uint256 _amount, bool _skipRebalance, address _referral) external returns (uint256 mintedTokens);

  /**
   * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
   * This method triggers a rebalance of the pools if needed
   * NOTE: If the contract is paused or iToken price has decreased one can still redeem but no rebalance happens.
   * NOTE 2: If iToken price has decresed one should not redeem (but can do it) otherwise he would capitalize the loss.
   *         Ideally one should wait until the black swan event is terminated
   *
   * @param _amount : amount of IdleTokens to be burned
   * @return redeemedTokens : amount of underlying tokens redeemed
   */
  function redeemIdleToken(uint256 _amount) external returns (uint256 redeemedTokens);
  /**
   * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
   * and send interest-bearing tokens (eg. cDAI/iDAI) directly to the user.
   * Underlying (eg. DAI) is not redeemed here.
   *
   * @param _amount : amount of IdleTokens to be burned
   */
  function redeemInterestBearingTokens(uint256 _amount) external;

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
  function setAllocations(uint256[] calldata _allocations, address[] calldata _addresses) external;
}

// File: contracts/interfaces/Comptroller.sol

pragma solidity 0.5.16;

interface Comptroller {
  function claimComp(address) external;
  function compSpeeds(address _cToken) external view returns (uint256);
  function claimComp(address[] calldata holders, address[] calldata cTokens, bool borrowers, bool suppliers) external;
}

// File: contracts/interfaces/CERC20.sol

pragma solidity 0.5.16;

interface CERC20 {
  function mint(uint256 mintAmount) external returns (uint256);
  function comptroller() external view returns (address);
  function redeem(uint256 redeemTokens) external returns (uint256);
  function exchangeRateStored() external view returns (uint256);
  function supplyRatePerBlock() external view returns (uint256);

  function borrowRatePerBlock() external view returns (uint256);
  function totalReserves() external view returns (uint256);
  function getCash() external view returns (uint256);
  function totalBorrows() external view returns (uint256);
  function reserveFactorMantissa() external view returns (uint256);
  function interestRateModel() external view returns (address);
}

// File: contracts/interfaces/GasToken.sol

pragma solidity 0.5.16;

interface GasToken {
  function freeUpTo(uint256 value) external returns (uint256 freed);
  function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
  function balanceOf(address from) external returns (uint256 balance);
}

// File: contracts/GST2ConsumerV2.sol

pragma solidity 0.5.16;



contract GST2ConsumerV2 is Initializable {
  GasToken public gst2;

  function initialize() initializer public {
    gst2 = GasToken(0x0000000000b3F879cb30FE243b4Dfee438691c04);
  }

  modifier gasDiscountFrom(address from) {
    uint256 initialGasLeft = gasleft();
    _;
    _makeGasDiscount(initialGasLeft - gasleft(), from);
  }

  function _makeGasDiscount(uint256 gasSpent, address from) internal {
    // For more info https://gastoken.io/
    // 14154 -> FREE_BASE -> base cost of freeing
    // 41130 -> 2 * REIMBURSE - FREE_TOKEN -> 2 * 24000 - 6870
    uint256 tokens = (gasSpent + 14154) / 41130;
    uint256 safeNumTokens;
    uint256 gas = gasleft();

    // For more info https://github.com/projectchicago/gastoken/blob/master/contract/gst2_free_example.sol
    if (gas >= 27710) {
      safeNumTokens = (gas - 27710) / 7020;
    }

    if (tokens > safeNumTokens) {
      tokens = safeNumTokens;
    }

    if (tokens > 0) {
      gst2.freeFromUpTo(from, tokens);
    }
  }
}

// File: contracts/IdleTokenV3_1.sol

/**
 * @title: Idle Token (V3) main contract
 * @summary: ERC20 that holds pooled user funds together
 *           Each token rapresent a share of the underlying pools
 *           and with each token user have the right to redeem a portion of these pools
 * @author: Idle Labs Inc., idle.finance
 */
pragma solidity 0.5.16;

















contract IdleTokenV3_1 is Initializable, ERC20, ERC20Detailed, ReentrancyGuard, Ownable, Pausable, IIdleTokenV3_1, GST2ConsumerV2 {
  using SafeERC20 for IERC20;
  using SafeMath for uint256;

  uint256 private constant ONE_18 = 10**18;
  // State variables
  // eg. DAI address
  address public token;
  // eg. iDAI address
  address private iToken;
  // eg. cDAI address
  address private cToken;
  // Idle rebalancer current implementation address
  address public rebalancer;
  // Address collecting underlying fees
  address public feeAddress;
  // Last iToken price, used to pause contract in case of a black swan event
  uint256 public lastITokenPrice;
  // eg. 18 for DAI
  uint256 private tokenDecimals;
  // Max unlent assets percentage for gas friendly swaps
  uint256 public maxUnlentPerc; // 100000 == 100% -> 1000 == 1%
  // Current fee on interest gained
  uint256 public fee;
  // eg. [cTokenAddress, iTokenAddress, ...]
  address[] public allAvailableTokens;
  // eg. [COMPAddress, CRVAddress, ...]
  address[] public govTokens;
  // last fully applied allocations (ie when all liquidity has been correctly placed)
  // eg. [5000, 0, 5000, 0] for 50% in compound, 0% fulcrum, 50% aave, 0 dydx. same order of allAvailableTokens
  uint256[] public lastAllocations;
  // Map that saves avg idleToken price paid for each user, used to calculate earnings
  mapping(address => uint256) public userAvgPrices;
  // eg. cTokenAddress => IdleCompoundAddress
  mapping(address => address) public protocolWrappers;
  // array with last balance recorded for each gov tokens
  mapping (address => uint256) public govTokensLastBalances;
  // govToken -> user_address -> user_index eg. usersGovTokensIndexes[govTokens[0]][msg.sender] = 1111123;
  mapping (address => mapping (address => uint256)) public usersGovTokensIndexes;
  // global indices for each gov tokens used as a reference to calculate a fair share for each user
  mapping (address => uint256) public govTokensIndexes;
  // Map that saves amount with no fee for each user
  mapping(address => uint256) private userNoFeeQty;
  // variable used for avoid the call of mint and redeem in the same tx
  bytes32 private _minterBlock;

  // Events
  event Rebalance(address _rebalancer, uint256 _amount);
  event Referral(uint256 _amount, address _ref);

  /**
   * @dev constructor, initialize some variables, mainly addresses of other contracts
   *
   * @param _name : IdleToken name
   * @param _symbol : IdleToken symbol
   * @param _token : underlying token address
   * @param _iToken : iToken address
   * @param _rebalancer : Idle Rebalancer address
   */
  function initialize(
    string memory _name, // eg. IdleDAI
    string memory _symbol, // eg. IDLEDAI
    address _token,
    address _iToken,
    address _cToken,
    address _rebalancer
  )
    public initializer
     {
      require(_rebalancer != address(0), "IDLE:IS_0");
      // Initialize inherited contracts
      ERC20Detailed.initialize(_name, _symbol, 18);
      Ownable.initialize(msg.sender);
      Pausable.initialize(msg.sender);
      ReentrancyGuard.initialize();
      GST2ConsumerV2.initialize();
      // Initialize storage variables
      maxUnlentPerc = 1000;

      token = _token;
      tokenDecimals = ERC20Detailed(_token).decimals();
      iToken = _iToken;
      cToken = _cToken;
      rebalancer = _rebalancer;
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
        iTokenPrice >= lastITokenPrice,
        "IDLE:ITOKEN_PRICE"
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
   * It allows owner to modify allAvailableTokens array in case of emergency
   * ie if a bug on a interest bearing token is discovered and reset protocolWrappers
   * associated with those tokens.
   *
   * @param protocolTokens : array of protocolTokens addresses (eg [cDAI, iDAI, ...])
   * @param wrappers : array of wrapper addresses (eg [IdleCompound, IdleFulcrum, ...])
   */
  function setAllAvailableTokensAndWrappers(
    address[] calldata protocolTokens,
    address[] calldata wrappers
  ) external onlyOwner {
    require(protocolTokens.length == wrappers.length, "IDLE:LEN_DIFF");

    for (uint256 i = 0; i < protocolTokens.length; i++) {
      require(protocolTokens[i] != address(0) && wrappers[i] != address(0), "IDLE:IS_0");
      protocolWrappers[protocolTokens[i]] = wrappers[i];
    }
    allAvailableTokens = protocolTokens;
  }

  /**
   * It allows owner to set the _iToken address
   *
   * @param _iToken : new _iToken address (can be address(0) which means disabled)
   */
  function setIToken(address _iToken)
    external onlyOwner {
      iToken = _iToken;
  }

  /**
   * It allows owner to set gov tokens array
   * In case of any errors gov distribution can be paused by passing an empty array
   *
   * @param _newGovTokens : array of governance token addresses
   */
  function setGovTokens(
    address[] calldata _newGovTokens
  ) external onlyOwner {
    govTokens = _newGovTokens;
  }

  /**
   * It allows owner to set the IdleRebalancerV3_1 address
   *
   * @param _rebalancer : new IdleRebalancerV3_1 address
   */
  function setRebalancer(address _rebalancer)
    external onlyOwner {
      require(_rebalancer != address(0), "IDLE:IS_0");
      rebalancer = _rebalancer;
  }

  /**
   * It allows owner to set the fee (1000 == 10% of gained interest)
   *
   * @param _fee : fee amount where 100000 is 100%, max settable is 10%
   */
  function setFee(uint256 _fee)
    external onlyOwner {
      // 100000 == 100% -> 10000 == 10%
      require(_fee <= 10000, "IDLE:TOO_HIGH");
      fee = _fee;
  }
  /**
   * It allows owner to set the max unlent asset percentage (1000 == 1% of unlent asset max)
   *
   * @param _perc : max unlent perc where 100000 is 100%
   */
  function setMaxUnlentPerc(uint256 _perc)
    external onlyOwner {
      require(_perc <= 100000, "IDLE:TOO_HIGH");
      maxUnlentPerc = _perc;
  }

  /**
   * It allows owner to set the fee address
   *
   * @param _feeAddress : fee address
   */
  function setFeeAddress(address _feeAddress)
    external onlyOwner {
      require(_feeAddress != address(0), "IDLE:IS_0");
      feeAddress = _feeAddress;
  }

  // view
  /**
   * IdleToken price calculation, in underlying
   *
   * @return : price in underlying token
   */
  function tokenPrice()
    external view
    returns (uint256) {
    return _tokenPrice();
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
   * Get current avg APR of this IdleToken (not counting gov tokens APR and unlent perc)
   *
   * @return avgApr: current weighted avg apr
   */
  function getAvgAPR()
    external view
    returns (uint256 avgApr) {
      (, uint256[] memory amounts, uint256 total) = _getCurrentAllocations();
      for (uint256 i = 0; i < allAvailableTokens.length; i++) {
        if (amounts[i] == 0) {
          continue;
        }
        // avgApr = avgApr.add(currApr.mul(weight).div(ONE_18))
        avgApr = avgApr.add(
          ILendingProtocol(protocolWrappers[allAvailableTokens[i]]).getAPR().mul(
            amounts[i]
          )
        );
      }

      avgApr = avgApr.div(total);
  }

  /**
   * ERC20 modified transferFrom that also update the avgPrice paid for the recipient and
   * updates user gov idx
   *
   * @param sender : sender account
   * @param recipient : recipient account
   * @param amount : value to transfer
   * @return : flag whether transfer was successful or not
   */
  function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
    _updateUserGovIdxTransfer(sender, recipient, amount);
    _transfer(sender, recipient, amount);
    _approve(sender, msg.sender, allowance(sender, msg.sender).sub(amount, "ERC20: transfer amount exceeds allowance"));
    _updateUserFeeInfo(recipient, amount, userAvgPrices[sender]);
    return true;
  }

  /**
   * ERC20 modified transfer that also update the avgPrice paid for the recipient and
   * updates user gov idx
   *
   * @param recipient : recipient account
   * @param amount : value to transfer
   * @return : flag whether transfer was successful or not
   */
  function transfer(address recipient, uint256 amount) public returns (bool) {
    _updateUserGovIdxTransfer(msg.sender, recipient, amount);
    _transfer(msg.sender, recipient, amount);
    _updateUserFeeInfo(recipient, amount, userAvgPrices[msg.sender]);
    return true;
  }

  /**
   * Helper method for transfer and transferFrom, updates recipient gov indexes
   *
   * @param _from : sender account
   * @param _to : recipient account
   * @param amount : value to transfer
   */
  function _updateUserGovIdxTransfer(address _from, address _to, uint256 amount) internal {
    address govToken;
    uint256 govTokenIdx;
    uint256 sharePerTokenFrom;
    uint256 shareTo;
    uint256 balanceTo = balanceOf(_to);
    for (uint256 i = 0; i < govTokens.length; i++) {
      govToken = govTokens[i];
      if (balanceTo == 0) {
        usersGovTokensIndexes[govToken][_to] = usersGovTokensIndexes[govToken][_from];
        continue;
      }

      govTokenIdx = govTokensIndexes[govToken];
      // calc 1 idleToken value in gov shares for user `_from`
      sharePerTokenFrom = govTokenIdx.sub(usersGovTokensIndexes[govToken][_from]);
      // calc current gov shares (before transfer) for user `_to`
      shareTo = balanceTo.mul(govTokenIdx.sub(usersGovTokensIndexes[govToken][_to])).div(ONE_18);
      // user `_to` should have -> shareTo + (sharePerTokenFrom * amount / 1e18) = (balanceTo + amount) * (govTokenIdx - userIdx) / 1e18
      // so userIdx = govTokenIdx - ((shareTo * 1e18 + (sharePerTokenFrom * amount)) / (balanceTo + amount))
      usersGovTokensIndexes[govToken][_to] = govTokenIdx.sub(
        shareTo.mul(ONE_18).add(sharePerTokenFrom.mul(amount)).div(
          balanceTo.add(amount)
        )
      );
    }
  }

  /**
   * Get how many gov tokens a user is entitled to (this may not include eventual undistributed tokens)
   *
   * @param _usr : user address
   * @return : array of amounts for each gov token
   */
  function getGovTokensAmounts(address _usr) external view returns (uint256[] memory _amounts) {
    address govToken;
    uint256 usrBal = balanceOf(_usr);
    _amounts = new uint256[](govTokens.length);
    for (uint256 i = 0; i < _amounts.length; i++) {
      govToken = govTokens[i];
      _amounts[i] = usrBal.mul(govTokensIndexes[govToken].sub(usersGovTokensIndexes[govToken][_usr])).div(ONE_18);
    }
  }

  // external
  /**
   * Used to mint IdleTokens, given an underlying amount (eg. DAI).
   * This method triggers a rebalance of the pools if _skipRebalance is set to false
   * NOTE: User should 'approve' _amount of tokens before calling mintIdleToken
   * NOTE 2: this method can be paused
   * This method use GasTokens of this contract (if present) to get a gas discount
   *
   * @param _amount : amount of underlying token to be lended
   * @param _referral : referral address
   * @return mintedTokens : amount of IdleTokens minted
   */
  function mintIdleToken(uint256 _amount, bool _skipRebalance, address _referral)
    external nonReentrant whenNotPaused whenITokenPriceHasNotDecreased
    returns (uint256 mintedTokens) {
    _minterBlock = keccak256(abi.encodePacked(tx.origin, block.number));
    _redeemGovTokens(msg.sender, true);
    // Get current IdleToken price
    uint256 idlePrice = _tokenPrice();
    // transfer tokens to this contract
    IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);

    if (!_skipRebalance) {
      // lend assets and rebalance the pool if needed
      _rebalance();
    }

    mintedTokens = _amount.mul(ONE_18).div(idlePrice);
    _mint(msg.sender, mintedTokens);

    // Update avg price and/or userNoFeeQty
    _updateUserFeeInfo(msg.sender, mintedTokens, idlePrice);
    // Update user idx for each gov tokens
    _updateUserGovIdx(msg.sender, mintedTokens);

    if (_referral != address(0)) {
      emit Referral(_amount, _referral);
    }
  }

  /**
   * Helper method for mintIdleToken, updates minter gov indexes
   *
   * @param _to : minter account
   * @param _mintedTokens : number of newly minted tokens
   */
  function _updateUserGovIdx(address _to, uint256 _mintedTokens) internal {
    address govToken;
    uint256 usrBal = balanceOf(_to);
    uint256 _govIdx;
    uint256 _usrIdx;

    for (uint256 i = 0; i < govTokens.length; i++) {
      govToken = govTokens[i];
      _govIdx = govTokensIndexes[govToken];
      _usrIdx = usersGovTokensIndexes[govToken][_to];

      // calculate user idx
      usersGovTokensIndexes[govToken][_to] = usrBal.mul(_usrIdx).add(
        _mintedTokens.mul(_govIdx.sub(_usrIdx))
      ).div(usrBal);
    }
  }

  /**
   * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
   * NOTE: If the contract is paused or iToken price has decreased one can still redeem but no rebalance happens.
   * NOTE 2: If iToken price has decresed one should not redeem (but can do it) otherwise he would capitalize the loss.
   *         Ideally one should wait until the black swan event is terminated
   *
   * @param _amount : amount of IdleTokens to be burned
   * @return redeemedTokens : amount of underlying tokens redeemed
   */
  function redeemIdleToken(uint256 _amount)
    external nonReentrant
    returns (uint256 redeemedTokens) {
      // Check that no mint has been made in the same block from the same EOA
      require(keccak256(abi.encodePacked(tx.origin, block.number)) != _minterBlock, "IDLE:REENTR");
      _redeemGovTokens(msg.sender, false);

      uint256 valueToRedeem = _amount.mul(_tokenPrice()).div(ONE_18);
      uint256 balanceUnderlying = IERC20(token).balanceOf(address(this));
      uint256 idleSupply = totalSupply();

      if (valueToRedeem <= balanceUnderlying) {
        redeemedTokens = valueToRedeem;
      } else {
        address currToken;
        for (uint256 i = 0; i < allAvailableTokens.length; i++) {
          currToken = allAvailableTokens[i];
          redeemedTokens = redeemedTokens.add(
            _redeemProtocolTokens(
              protocolWrappers[currToken],
              currToken,
              // _amount * protocolPoolBalance / idleSupply
              _amount.mul(IERC20(currToken).balanceOf(address(this))).div(idleSupply), // amount to redeem
              address(this)
            )
          );
        }
        // Get a portion of the eventual unlent balance
        redeemedTokens = redeemedTokens.add(_amount.mul(balanceUnderlying).div(idleSupply));
      }

      if (fee > 0 && feeAddress != address(0)) {
        redeemedTokens = _getFee(_amount, redeemedTokens);
      } else {
        userNoFeeQty[msg.sender] = balanceOf(msg.sender).sub(_amount);
      }

      _burn(msg.sender, _amount);
      // send underlying minus fee to msg.sender
      IERC20(token).safeTransfer(msg.sender, redeemedTokens);
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
      _redeemGovTokens(msg.sender, false);

      uint256 idleSupply = totalSupply();
      address currentToken;

      for (uint256 i = 0; i < allAvailableTokens.length; i++) {
        currentToken = allAvailableTokens[i];
        IERC20(currentToken).safeTransfer(
          msg.sender,
          _amount.mul(IERC20(currentToken).balanceOf(address(this))).div(idleSupply) // amount to redeem
        );
      }
      // Get a portion of the eventual unlent balance
      IERC20(token).safeTransfer(
        msg.sender,
        _amount.mul(IERC20(token).balanceOf(address(this))).div(idleSupply) // amount to redeem
      );

      _burn(msg.sender, _amount);
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
      return _rebalance();
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
    return _rebalance();
  }

  // internal
  /**
   * Get current idleToken price based on net asset value and totalSupply
   *
   * @return price: value of 1 idleToken in underlying
   */
  function _tokenPrice() internal view returns (uint256 price) {
    uint256 totSupply = totalSupply();
    if (totSupply == 0) {
      return 10**(tokenDecimals);
    }

    address currToken;
    uint256 totNav = IERC20(token).balanceOf(address(this)).mul(ONE_18); // eventual underlying unlent balance

    for (uint256 i = 0; i < allAvailableTokens.length; i++) {
      currToken = allAvailableTokens[i];
      totNav = totNav.add(
        // NAV = price * poolSupply
        ILendingProtocol(protocolWrappers[currToken]).getPriceInToken().mul(
          IERC20(currToken).balanceOf(address(this))
        )
      );
    }

    price = totNav.div(totSupply); // idleToken price in token wei
  }

  /**
   * Dynamic allocate all the pool across different lending protocols if needed
   *
   * NOTE: this method can be paused
   *
   * @return : whether has rebalanced or not
   */
  function _rebalance()
    internal whenNotPaused whenITokenPriceHasNotDecreased
    returns (bool) {
      // check if we need to rebalance by looking at the allocations in rebalancer contract
      uint256[] memory rebalancerLastAllocations = IIdleRebalancerV3(rebalancer).getAllocations();
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
      uint256 maxUnlentBalance;

      if (areAllocationsEqual && balance == 0) {
        return false;
      }

      if (balance > 0) {
        maxUnlentBalance = _getCurrentPoolValue().mul(maxUnlentPerc).div(100000);
        if (lastAllocations.length == 0) {
          // set in storage
          lastAllocations = rebalancerLastAllocations;
        }

        if (balance > maxUnlentBalance) {
          // mint the difference
          _mintWithAmounts(allAvailableTokens, _amountsFromAllocations(rebalancerLastAllocations, balance.sub(maxUnlentBalance)));
        }
      }

      if (areAllocationsEqual) {
        return false;
      }

      // Instead of redeeming everything during rebalance we redeem and mint only what needs
      // to be reallocated
      // get current allocations in underlying (it does not count unlent underlying)
      (address[] memory tokenAddresses, uint256[] memory amounts, uint256 totalInUnderlying) = _getCurrentAllocations();

      if (balance == 0 && maxUnlentPerc > 0) {
        totalInUnderlying = totalInUnderlying.sub(_getCurrentPoolValue().mul(maxUnlentPerc).div(100000));
      }
      // calculate new allocations given the total (not counting unlent balance)
      uint256[] memory newAmounts = _amountsFromAllocations(rebalancerLastAllocations, totalInUnderlying);
      (uint256[] memory toMintAllocations, uint256 totalToMint, bool lowLiquidity) = _redeemAllNeeded(tokenAddresses, amounts, newAmounts);
      // if some protocol has liquidity that we should redeem, we do not update
      // lastAllocations to force another rebalance next time
      if (!lowLiquidity) {
        // Update lastAllocations with rebalancerLastAllocations
        delete lastAllocations;
        lastAllocations = rebalancerLastAllocations;
      }

      // Do not count `maxUnlentPerc` from balance
      if (maxUnlentBalance == 0 && maxUnlentPerc > 0) {
        maxUnlentBalance = _getCurrentPoolValue().mul(maxUnlentPerc).div(100000);
      }

      uint256 totalRedeemd = IERC20(token).balanceOf(address(this));

      if (totalRedeemd <= maxUnlentBalance) {
        return false;
      }

      // Do not mint directly using toMintAllocations check with totalRedeemd
      uint256[] memory tempAllocations = new uint256[](toMintAllocations.length);
      for (uint256 i = 0; i < toMintAllocations.length; i++) {
        // Calc what would have been the correct allocations percentage if all was available
        tempAllocations[i] = toMintAllocations[i].mul(100000).div(totalToMint);
      }

      uint256[] memory partialAmounts = _amountsFromAllocations(tempAllocations, totalRedeemd.sub(maxUnlentBalance));
      _mintWithAmounts(allAvailableTokens, partialAmounts);

      emit Rebalance(msg.sender, totalInUnderlying.add(maxUnlentBalance));

      return true; // hasRebalanced
  }

  /**
   * Redeem unclaimed governance tokens and update governance global index and user index if needed
   * if called during redeem it will send all gov tokens accrued by a user to the user
   *
   * @param _to : user address
   * @param _skipRedeem : flag to choose whether to send gov tokens to user or not
   */
  function _redeemGovTokens(address _to, bool _skipRedeem) internal {
    if (govTokens.length == 0) {
      return;
    }
    uint256 supply = totalSupply();
    uint256 usrBal = balanceOf(_to);
    address govToken;

    for (uint256 i = 0; i < govTokens.length; i++) {
      govToken = govTokens[i];

      if (supply > 0) {
        if (!_skipRedeem) {
          // redeem gov tokens for this contract with the corresponding lending protocol wrapper
          if (i == 0) {
            address[] memory holders = new address[](1);
            address[] memory cTokens = new address[](1);
            holders[0] = address(this);
            cTokens[0] = cToken;
            Comptroller(CERC20(allAvailableTokens[0]).comptroller()).claimComp(holders, cTokens, false, true);
          }
        }
        // In case new Gov tokens will be supported this should be updated

        // get current gov token balance
        uint256 govBal = IERC20(govToken).balanceOf(address(this));
        if (govBal > 0) {
          // update global index with ratio of govTokens per idleToken
          govTokensIndexes[govToken] = govTokensIndexes[govToken].add(
            // check how much gov tokens for each idleToken we gained since last update
            govBal.sub(govTokensLastBalances[govToken]).mul(ONE_18).div(supply)
          );
          // update global var with current govToken balance
          govTokensLastBalances[govToken] = govBal;
        }
      }

      if (usrBal > 0) {
        if (!_skipRedeem) {
          uint256 usrIndex = usersGovTokensIndexes[govToken][_to];
          // update current user index for this gov token
          usersGovTokensIndexes[govToken][_to] = govTokensIndexes[govToken];
          // check if user has accrued something
          uint256 delta = govTokensIndexes[govToken].sub(usrIndex);
          if (delta == 0) { continue; }
          uint256 share = usrBal.mul(delta).div(ONE_18);
          uint256 bal = IERC20(govToken).balanceOf(address(this));
          // To avoid rounding issue
          if (share > bal) {
            share = bal;
          }

          uint256 feeDue;
          if (feeAddress != address(0) && fee > 0) {
            feeDue = share.mul(fee).div(100000);
            // Transfer gov token fee to feeAddress
            IERC20(govToken).safeTransfer(feeAddress, feeDue);
          }
          // Transfer gov token to user
          IERC20(govToken).safeTransfer(_to, share.sub(feeDue));
          // Update last balance
          govTokensLastBalances[govToken] = IERC20(govToken).balanceOf(address(this));
        }
      } else {
        // save current index for this gov token
        usersGovTokensIndexes[govToken][_to] = govTokensIndexes[govToken];
      }
    }
  }

  /**
   * Update avg price paid for each idle token of a user
   *
   * @param usr : user that should have balance update
   * @param qty : new amount deposited / transferred, in idleToken
   * @param price : curr idleToken price in underlying
   */
  function _updateUserFeeInfo(address usr, uint256 qty, uint256 price) internal {
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
    uint256 currPrice = _tokenPrice();
    if (noFeeQty > 0 && noFeeQty > amount) {
      noFeeQty = amount;
    }

    uint256 totalValPaid = noFeeQty.mul(currPrice).add(amount.sub(noFeeQty).mul(userAvgPrices[msg.sender])).div(ONE_18);
    uint256 currVal = amount.mul(currPrice).div(ONE_18);
    if (currVal < totalValPaid) {
      return redeemed;
    }
    uint256 feeDue = currVal.sub(totalValPaid).mul(fee).div(100000);
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
    uint256 currAmount;
    address protWrapper;

    for (uint256 i = 0; i < protocolAmounts.length; i++) {
      currAmount = protocolAmounts[i];
      if (currAmount == 0) {
        continue;
      }
      protWrapper = protocolWrappers[tokenAddresses[i]];
      // Transfer _amount underlying token (eg. DAI) to protWrapper
      IERC20(token).safeTransfer(protWrapper, currAmount);
      ILendingProtocol(protWrapper).mint();
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
    internal pure returns (uint256[] memory newAmounts) {
    newAmounts = new uint256[](allocations.length);
    uint256 currBalance;
    uint256 allocatedBalance;

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
          toRedeem.mul(ONE_18).div(protocol.getPriceInToken()),
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
        ).div(ONE_18);
        total = total.add(amounts[i]);
      }

      // return addresses and respective amounts in underlying
      return (tokenAddresses, amounts, total);
  }

  /**
   * Get the current pool value in underlying
   *
   * @return total : total AUM in underlying
   */
  function _getCurrentPoolValue() internal view
    returns (uint256 total) {
      // Get balance of every protocol implemented
      address currentToken;

      for (uint256 i = 0; i < allAvailableTokens.length; i++) {
        currentToken = allAvailableTokens[i];
        total = total.add(ILendingProtocol(protocolWrappers[currentToken]).getPriceInToken().mul(
          IERC20(currentToken).balanceOf(address(this))
        ).div(ONE_18));
      }

      // add unlent balance
      total = total.add(IERC20(token).balanceOf(address(this)));
  }

  // ILendingProtocols calls
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