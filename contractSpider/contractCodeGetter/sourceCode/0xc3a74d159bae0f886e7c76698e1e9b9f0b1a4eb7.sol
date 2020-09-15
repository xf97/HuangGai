/**
 *Submitted for verification at Etherscan.io on 2020-05-12
*/

// File: @openzeppelin/contracts/math/Math.sol

pragma solidity ^0.5.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
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

// File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol

pragma solidity ^0.5.0;



/**
 * @dev Extension of {ERC20} that allows token holders to destroy both their own
 * tokens and those that they have an allowance for, in a way that can be
 * recognized off-chain (via event analysis).
 */
contract ERC20Burnable is Context, ERC20 {
    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    /**
     * @dev See {ERC20-_burnFrom}.
     */
    function burnFrom(address account, uint256 amount) public {
        _burnFrom(account, amount);
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

// File: contracts/GenesisSC.sol

pragma solidity ^0.5.15;






contract GenesisSC is Ownable {

    using SafeMath for uint256;
    using Math for uint256;
    using Address for address;

    enum States{Initializing, Staking, Validating, Finalized, Retired}

    // EVENTS
    event StakeDeposited(address indexed account, uint256 amount);
    event StakeWithdrawn(address indexed account, uint256 amount);
    event StateChanged(States fromState, States toState);

    // STRUCT DECLARATIONS
    struct StakingNode {
        bytes32 blsKeyHash;
        bytes32 elrondAddressHash;
        bool approved;
        bool exists;
    }

    struct WhitelistedAccount {
        uint256 numberOfNodes;
        uint256 amountStaked;
        StakingNode[] stakingNodes;
        bool exists;
        mapping(bytes32 => uint256) blsKeyHashToStakingNodeIndex;
    }

    struct DelegationDeposit {
        uint256 amount;
        bytes32 elrondAddressHash;
        bool exists;
    }

    // CONTRACT STATE VARIABLES
    uint256 public nodePrice;
    uint256 public delegationNodesLimit;
    uint256 public delegationAmountLimit;
    uint256 public currentTotalDelegated;
    address[] private _whitelistedAccountAddresses;

    ERC20Burnable public token;
    States public contractState = States.Initializing;

    mapping(address => WhitelistedAccount) private _whitelistedAccounts;
    mapping(address => DelegationDeposit) private _delegationDeposits;
    mapping (bytes32 => bool) private _approvedBlsKeyHashes;

    // MODIFIERS
    modifier onlyContract(address account)
    {
        require(account.isContract(), "[Validation] The address does not contain a contract");
        _;
    }

    modifier guardMaxDelegationLimit(uint256 amount)
    {
        require(amount <= (delegationAmountLimit - currentTotalDelegated), "[DepositDelegateStake] Your deposit would exceed the delegation limit");
        _;
    }

    modifier onlyWhitelistedAccounts(address who)
    {
        WhitelistedAccount memory account = _whitelistedAccounts[who];
        require(account.exists, "[Validation] The provided address is not whitelisted");
        _;
    }

    modifier onlyAccountsWithNodes()
    {
        require(_whitelistedAccounts[msg.sender].stakingNodes.length > 0, "[Validation] Your account has 0 nodes submitted");
        _;
    }

    modifier onlyNotWhitelistedAccounts(address who)
    {
        WhitelistedAccount memory account = _whitelistedAccounts[who];
        require(!account.exists, "[Validation] Address is already whitelisted");
        _;
    }

    // STATE GUARD MODIFIERS
    modifier whenStaking()
    {
        require(contractState == States.Staking, "[Validation] This function can be called only when contract is in staking phase");
        _;
    }

    modifier whenInitializedAndNotValidating()
    {
        require(contractState != States.Initializing, "[Validation] This function cannot be called in the initialization phase");
        require(contractState != States.Validating, "[Validation] This function cannot be called while your submitted nodes are in the validation process");
        _;
    }

    modifier whenFinalized()
    {
        require(contractState == States.Finalized, "[Validation] This function can be called only when the contract is finalized");
        _;
    }

    modifier whenNotFinalized()
    {
        require(contractState != States.Finalized, "[Validation] This function cannot be called when the contract is finalized");
        _;
    }

    modifier whenNotRetired()
    {
        require(contractState != States.Retired, "[Validation] This function cannot be called when the contract is retired");
        _;
    }

    modifier whenRetired()
    {
        require(contractState == States.Retired, "[Validation] This function can be called only when the contract is retired");
        _;
    }

    // PUBLIC FUNCTIONS
    constructor(ERC20Burnable _token, uint256 _nodePrice, uint256 _delegationNodesLimit)
    public
    {
        require(_nodePrice > 0, "[Validation] Node price must be greater than 0");

        token = _token;
        nodePrice = _nodePrice;
        delegationNodesLimit = _delegationNodesLimit;
        delegationAmountLimit = _delegationNodesLimit.mul(_nodePrice);
    }

    /**
    * submitStake can be called in the staking phase by any account that has been previously whitelisted by the Elrond
    *  team. An account can submit hashes of BLS keys to this contract (in a number that adds up to less or equal than
    *  what has been set up for that account) and an associated reward address hash for them. The total amount of ERD
    *  tokens that will be transferred from that account will be fixed to nrOfSubmittedNodes*nodePrice
    *
    * @param blsKeyHashes A list where each element represents the hash of an Elrond's native node public key
    * @param elrondAddressHash Represents the hash of an Elrond's native wallet address
    */
    function submitStake(bytes32[] calldata blsKeyHashes, bytes32 elrondAddressHash)
    external
    whenStaking
    onlyWhitelistedAccounts(msg.sender)
    {
        require(elrondAddressHash != 0, "[Validation] Elrond address hash should not be 0");

        WhitelistedAccount storage whitelistedAccount = _whitelistedAccounts[msg.sender];
        _validateStakeParameters(whitelistedAccount, blsKeyHashes);
        _addStakingNodes(whitelistedAccount, blsKeyHashes, elrondAddressHash);

        uint256 transferAmount = nodePrice.mul(blsKeyHashes.length);
        require(token.transferFrom(msg.sender, address(this), transferAmount));

        whitelistedAccount.amountStaked = whitelistedAccount.amountStaked.add(transferAmount);

        emit StakeDeposited(msg.sender, transferAmount);
    }

    /**
    * withdraw can be called by any account that has been whitelisted and has submitted BLS key hashes for their nodes
    *  and implicitly ERD tokens as staking value for them. This function will withdraw all associated tokens for
    *  nodes that have not been validated off-chain and approved by the Elrond team. If an account wants to give up
    *  and withdraw tokens for an already approved node (if the phase the contract is in still permits it), he/she
    *  can use withdrawPerNodes function
    */
    function withdraw()
    external
    whenInitializedAndNotValidating
    onlyWhitelistedAccounts(msg.sender)
    onlyAccountsWithNodes
    {
        uint256 totalSumToWithdraw;
        WhitelistedAccount storage account = _whitelistedAccounts[msg.sender];

        uint256 length = account.stakingNodes.length - 1;
        for (uint256 i = length; i <= length; i--) {
            StakingNode storage stakingNode = account.stakingNodes[i];
            if ((!stakingNode.exists) || (stakingNode.approved)) {
                continue;
            }

            totalSumToWithdraw = totalSumToWithdraw.add(nodePrice);

            _removeStakingNode(account, stakingNode.blsKeyHash);
        }

        if (totalSumToWithdraw == 0) {
            emit StakeWithdrawn(msg.sender, 0);
            return;
        }

        account.amountStaked = account.amountStaked.sub(totalSumToWithdraw);

        require(token.transfer(msg.sender, totalSumToWithdraw));

        emit StakeWithdrawn(msg.sender, totalSumToWithdraw);
    }

    /**
    * withdrawPerNodes gives the user the possibility to withdraw funds associated with the provided BLS key hashes.
    *  This function allows withdrawal also for nodes that were approved by the Elrond team, with the mention that
    *  it should happen before the contract gets in the finalized or retired state (meaning the genesis of the Elrond blockchain
    *  is established and those tokens will be minted on the main chain)
    *
    * @param blsKeyHashes A list where each element represents the hash of an Elrond's native node public key
    */
    function withdrawPerNodes(bytes32[] calldata blsKeyHashes)
    external
    whenInitializedAndNotValidating
    onlyWhitelistedAccounts(msg.sender)
    onlyAccountsWithNodes
    {
        require(blsKeyHashes.length > 0, "[Validation] You must provide at least one BLS key");

        WhitelistedAccount storage account = _whitelistedAccounts[msg.sender];
        for (uint256 i; i < blsKeyHashes.length; i++) {
            _validateBlsKeyHashForWithdrawal(account, blsKeyHashes[i]);
            _removeStakingNode(account, blsKeyHashes[i]);
        }

        uint256 totalSumToWithdraw = nodePrice.mul(blsKeyHashes.length);
        account.amountStaked = account.amountStaked.sub(totalSumToWithdraw);

        require(token.transfer(msg.sender, totalSumToWithdraw));

        emit StakeWithdrawn(msg.sender, totalSumToWithdraw);
    }

    /**
    * depositDelegateStake provides users that were not whitelisted to run nodes at the start of the
    *  Elrond blockchain with the possibility to take part anyway in the genesis of the network
    *  by delegating stake to nodes that will be ran by Elrond. The rewards will be received
    *  by the user according to the Elrond's delegation smart contract in the provided wallet address
    *
    * @param elrondAddressHash The Elrond native address hash where the user wants to receive the rewards
    * @param amount The ERD amount to be staked
    */
    function depositDelegateStake(uint256 amount, bytes32 elrondAddressHash)
    external
    whenStaking
    guardMaxDelegationLimit(amount)
    {
        require(amount > 0, "[Validation] The stake amount has to be larger than 0");
        require(!_delegationDeposits[msg.sender].exists, "[Validation] You already delegated a stake");

        _delegationDeposits[msg.sender] = DelegationDeposit(amount, elrondAddressHash, true);

        currentTotalDelegated = currentTotalDelegated.add(amount);

        require(token.transferFrom(msg.sender, address(this), amount));

        emit StakeDeposited(msg.sender, amount);
    }

    /**
    * increaseDelegatedAmount lets a user that has already delegated a number of tokens to increase that amount
    *
    * @param amount The ERD amount to be added to the existing stake
    */
    function increaseDelegatedAmount(uint256 amount)
    external
    whenStaking
    guardMaxDelegationLimit(amount)
    {
        require(amount > 0, "[Validation] The amount has to be larger than 0");

        DelegationDeposit storage deposit = _delegationDeposits[msg.sender];
        require(deposit.exists, "[Validation] You don't have a delegated stake");

        deposit.amount = deposit.amount.add(amount);
        currentTotalDelegated = currentTotalDelegated.add(amount);

        require(token.transferFrom(msg.sender, address(this), amount));

        emit StakeDeposited(msg.sender, amount);
    }

    /**
    * withdrawDelegatedStake lets a user that has already delegated a number of tokens to decrease that amount
    *
    * @param amount The ERD amount to be removed to the existing stake
    */
    function withdrawDelegatedStake(uint256 amount)
    external
    whenStaking
    {
        require(amount > 0, "[Validation] The withdraw amount has to be larger than 0");

        DelegationDeposit storage deposit = _delegationDeposits[msg.sender];
        require(deposit.exists, "[Validation] You don't have a delegated stake");
        require(amount <= deposit.amount, "[Validation] Not enough stake deposit to withdraw");

        deposit.amount = deposit.amount.sub(amount);
        currentTotalDelegated = currentTotalDelegated.sub(amount);
        require(token.transfer(msg.sender, amount));

        emit StakeWithdrawn(msg.sender, amount);
    }

    // OWNER ONLY FUNCTIONS

    /**
    * changeStateToStaking allows the owner to change the state of the contract into the staking phase
    */
    function changeStateToStaking()
    external
    onlyOwner
    whenNotRetired
    {
        emit StateChanged(contractState, States.Staking);
        contractState = States.Staking;
    }

    /**
    * changeStateToValidating allows the owner to change the state of the contract into the validating phase. With the
    *  mention that we can go into validating phase only from the staking phase.
    */
    function changeStateToValidating()
    external
    onlyOwner
    whenStaking
    {
        emit StateChanged(contractState, States.Validating);
        contractState = States.Validating;
    }

    /**
    * changeStateToFinalized allows the owner to change the state of the contract into the finalized phase
    */
    function changeStateToFinalized()
    external
    onlyOwner
    whenNotRetired
    {
        emit StateChanged(contractState, States.Finalized);
        contractState = States.Finalized;
    }

    /**
   * changeStateToRetired allows the owner to change the state of the contract into the retired phase.
   *  this can only happen if the contract is finalized - in order to prevent retiring it by mistake,
   *  since there is no turning back from this state
   */
    function changeStateToRetired()
    external
    onlyOwner
    whenFinalized
    {
        emit StateChanged(contractState, States.Retired);
        contractState = States.Retired;
    }

    /**
    * whitelistAccount allows the owner to whitelist an ethereum address to stake ERD and add nodes to run
    *  on the Elrond blockchain
    */
    function whitelistAccount(address who, uint256 numberOfNodes)
    external
    onlyOwner
    whenNotFinalized
    whenNotRetired
    onlyNotWhitelistedAccounts(who)
    {
        WhitelistedAccount storage whitelistedAccount = _whitelistedAccounts[who];
        whitelistedAccount.numberOfNodes = numberOfNodes;
        whitelistedAccount.exists = true;

        _whitelistedAccountAddresses.push(who);
    }

    /**
    * approveBlsKeyHashes gives the owner the possibility to mark some BLS key hashes submitted by an account
    *  as approved after an off-chain validation
    */
    function approveBlsKeyHashes(address who, bytes32[] calldata blsHashes)
    external
    onlyOwner
    whenNotFinalized
    whenNotRetired
    onlyWhitelistedAccounts(who)
    {
        WhitelistedAccount storage whitelistedAccount = _whitelistedAccounts[who];

        for (uint256 i = 0; i < blsHashes.length; i++) {
            require(_accountHasNode(whitelistedAccount, blsHashes[i]), "[Validation] BLS key does not exist for this account");
            require(!_approvedBlsKeyHashes[blsHashes[i]], "[Validation] Provided BLS key was already approved");

            uint256 accountIndex = whitelistedAccount.blsKeyHashToStakingNodeIndex[blsHashes[i]];
            StakingNode storage stakingNode = whitelistedAccount.stakingNodes[accountIndex];
            require(stakingNode.exists, '[Validation] Bls key does not exist for this account');
            stakingNode.approved = true;
            _approvedBlsKeyHashes[blsHashes[i]] = true;
        }
    }

    /**
    * unapproveBlsKeyHashes the same as approveBlsKeyHashes, but changing the approved flag to false for selected keys
    */
    function unapproveBlsKeyHashes(address who, bytes32[] calldata blsHashes)
    external
    onlyOwner
    whenNotFinalized
    whenNotRetired
    onlyWhitelistedAccounts(who)
    {
        WhitelistedAccount storage whitelistedAccount = _whitelistedAccounts[who];

        for (uint256 i = 0; i < blsHashes.length; i++) {
            require(_accountHasNode(whitelistedAccount, blsHashes[i]), "[Validation] BLS key does not exist for this account");
            require(_approvedBlsKeyHashes[blsHashes[i]], "[Validation] Provided BLS key was not previously approved");

            uint256 accountIndex = whitelistedAccount.blsKeyHashToStakingNodeIndex[blsHashes[i]];
            StakingNode storage stakingNode = whitelistedAccount.stakingNodes[accountIndex];
            require(stakingNode.exists, '[Validation] Bls key does not exist for this account');
            stakingNode.approved = false;
            _approvedBlsKeyHashes[blsHashes[i]] = false;
        }
    }

    /**
    * editWhitelistedAccountNumberOfNodes gives the owner the possibility to change the number of nodes a user can
    *  stake for. The number cannot be set lower than the number of nodes the user already submitted
    */
    function editWhitelistedAccountNumberOfNodes(address who, uint256 numberOfNodes)
    external
    onlyOwner
    whenNotFinalized
    whenNotRetired
    onlyWhitelistedAccounts(who)
    {
        WhitelistedAccount storage whitelistedAccount = _whitelistedAccounts[who];
        require(numberOfNodes >= whitelistedAccount.stakingNodes.length, "[Validation] Whitelisted account already submitted more nodes than you wish to allow");

        whitelistedAccount.numberOfNodes = numberOfNodes;
    }

    /**
    * burnCommittedFunds can be called by the owner after this contract is retired. This function burns the amount
    *  of tokens associated with approved nodes and delegated stake. The equivalent will be minted on the
    *  Elrond blockchain
    */
    function burnCommittedFunds()
    external
    onlyOwner
    whenRetired
    {
        uint256 totalToBurn = currentTotalDelegated;
        for(uint256 i; i < _whitelistedAccountAddresses.length; i++) {
            WhitelistedAccount memory account = _whitelistedAccounts[_whitelistedAccountAddresses[i]];
            if (!account.exists) {
                continue;
            }

            uint256 approvedNodes = _approvedNodesCount(account);
            totalToBurn = totalToBurn.add(nodePrice.mul(approvedNodes));
        }

        token.burn(totalToBurn);
    }

    /**
    * recoverLostFunds helps us recover funds for users that accidentally send tokens directly to this contract
    */
    function recoverLostFunds(address who, uint256 amount)
    external
    onlyOwner
    {
        uint256 currentBalance = token.balanceOf(address(this));
        require(amount <= currentBalance, "[Validation] Recover amount exceeds contract balance");

        uint256 correctDepositAmount = _correctDepositAmount();
        uint256 lostFundsAmount = currentBalance.sub(correctDepositAmount);
        require(amount <= lostFundsAmount, "[Validation] Recover amount exceeds lost funds amount");

        token.transfer(who, amount);
    }

    // VIEW FUNCTIONS
    function whitelistedAccountAddresses()
    external
    view
    returns (address[] memory, uint256[] memory)
    {
        address[] memory whitelistedAddresses = new address[](_whitelistedAccountAddresses.length);
        uint256[] memory whitelistedAddressesNodes = new uint256[](_whitelistedAccountAddresses.length);

        for (uint256 i = 0; i < _whitelistedAccountAddresses.length; i++) {
            whitelistedAddresses[i] = _whitelistedAccountAddresses[i];
            WhitelistedAccount storage whitelistedAccount = _whitelistedAccounts[_whitelistedAccountAddresses[i]];
            whitelistedAddressesNodes[i] = whitelistedAccount.numberOfNodes;

        }

        return (whitelistedAddresses, whitelistedAddressesNodes);
    }

    function whitelistedAccount(address who)
    external
    view
    returns (uint256 maxNumberOfNodes, uint256 amountStaked)
    {
        require(_whitelistedAccounts[who].exists, "[WhitelistedAddress] Address is not whitelisted");

        return (_whitelistedAccounts[who].numberOfNodes, _whitelistedAccounts[who].amountStaked);
    }

    function stakingNodesHashes(address who)
    external
    view
    returns (bytes32[] memory, bool[] memory, bytes32[] memory)
    {
        require(_whitelistedAccounts[who].exists, "[StakingNodesHashes] Address is not whitelisted");

        StakingNode[] memory stakingNodes = _whitelistedAccounts[who].stakingNodes;
        bytes32[] memory blsKeyHashes = new bytes32[](stakingNodes.length);
        bool[] memory blsKeyHashesStatus = new bool[](stakingNodes.length);
        bytes32[] memory rewardAddresses = new bytes32[](stakingNodes.length);

        for (uint256 i = 0; i < stakingNodes.length; i++) {
            blsKeyHashes[i] = stakingNodes[i].blsKeyHash;
            blsKeyHashesStatus[i] = stakingNodes[i].approved;
            rewardAddresses[i] = stakingNodes[i].elrondAddressHash;
        }

        return (blsKeyHashes, blsKeyHashesStatus, rewardAddresses);
    }

    function stakingNodeInfo(address who, bytes32 blsKeyHash)
    external
    view
    returns(bytes32, bool)
    {
        require(_whitelistedAccounts[who].exists, "[StakingNodeInfo] Address is not whitelisted");
        require(_accountHasNode(_whitelistedAccounts[who], blsKeyHash), "[StakingNodeInfo] Address does not have the provided node");

        WhitelistedAccount storage account = _whitelistedAccounts[who];
        uint256 nodeIndex = account.blsKeyHashToStakingNodeIndex[blsKeyHash];
        return (account.stakingNodes[nodeIndex].elrondAddressHash, account.stakingNodes[nodeIndex].approved);
    }

    function delegationDeposit(address who)
    external
    view
    returns (uint256, bytes32)
    {
        return (_delegationDeposits[who].amount, _delegationDeposits[who].elrondAddressHash);
    }

    function lostFundsAmount()
    external
    view
    returns (uint256)
    {
        uint256 currentBalance = token.balanceOf(address(this));
        uint256 correctDepositAmount = _correctDepositAmount();

        return currentBalance.sub(correctDepositAmount);
    }

    // PRIVATE FUNCTIONS
    function _addStakingNodes(WhitelistedAccount storage account, bytes32[] memory blsKeyHashes, bytes32 elrondAddressHash)
    internal
    {
        for (uint256 i = 0; i < blsKeyHashes.length; i++) {
            _insertStakingNode(account, blsKeyHashes[i], elrondAddressHash);
        }
    }

    function _validateStakeParameters(WhitelistedAccount memory account, bytes32[] memory blsKeyHashes)
    internal
    pure
    {
        require(
            account.numberOfNodes >= account.stakingNodes.length + blsKeyHashes.length,
            "[Validation] Adding this many nodes would exceed the maximum number of allowed nodes per this account"
        );
    }

    function _correctDepositAmount()
    internal
    view
    returns (uint256)
    {
        uint256 correctDepositAmount = currentTotalDelegated;
        for(uint256 i; i < _whitelistedAccountAddresses.length; i++) {
            WhitelistedAccount memory account = _whitelistedAccounts[_whitelistedAccountAddresses[i]];
            if (!account.exists) {
                continue;
            }

            correctDepositAmount = correctDepositAmount.add(nodePrice.mul(account.stakingNodes.length));
        }

        return correctDepositAmount;
    }

    // StakingNode list manipulation
    function _accountHasNode(WhitelistedAccount storage account, bytes32 blsKeyHash)
    internal
    view
    returns (bool)
    {
        if (account.stakingNodes.length == 0) {
            return false;
        }

        uint256 nodeIndex = account.blsKeyHashToStakingNodeIndex[blsKeyHash];

        return (account.stakingNodes[nodeIndex].blsKeyHash == blsKeyHash) && account.stakingNodes[nodeIndex].exists;
    }

    function _approvedNodesCount(WhitelistedAccount memory account)
    internal
    pure
    returns(uint256)
    {
        uint256 nodesCount = 0;

        for(uint256 i = 0; i < account.stakingNodes.length; i++) {
            if (account.stakingNodes[i].exists && account.stakingNodes[i].approved) {
                nodesCount++;
            }
        }

        return nodesCount;
    }

    // Node operations
    function _insertStakingNode(WhitelistedAccount storage account, bytes32 blsKeyHash, bytes32 elrondAddressHash)
    internal
    {
        require(blsKeyHash != 0, "[Validation] BLS key hash should not be 0");
        require(!_accountHasNode(account, blsKeyHash), "[Validation] BLS key was already added for this account");

        account.blsKeyHashToStakingNodeIndex[blsKeyHash] = account.stakingNodes.length;
        StakingNode memory newNode = StakingNode(blsKeyHash, elrondAddressHash, false, true);
        account.stakingNodes.push(newNode);
    }

    function _removeStakingNode(WhitelistedAccount storage account, bytes32 blsKeyHash)
    internal
    {
        uint256 nodeIndex = account.blsKeyHashToStakingNodeIndex[blsKeyHash];
        uint256 lastNodeIndex = account.stakingNodes.length - 1;

        bool stakingNodeIsApproved = account.stakingNodes[nodeIndex].approved;

        // It's not the last StakingNode so we replace this one with the last one
        if (nodeIndex != lastNodeIndex) {
            bytes32 lastHash = account.stakingNodes[lastNodeIndex].blsKeyHash;
            account.blsKeyHashToStakingNodeIndex[lastHash] = nodeIndex;
            account.stakingNodes[nodeIndex] = account.stakingNodes[lastNodeIndex];
        }

        if (stakingNodeIsApproved) {
            delete _approvedBlsKeyHashes[blsKeyHash];
        }

        account.stakingNodes.pop();
        delete account.blsKeyHashToStakingNodeIndex[blsKeyHash];
    }

    function _validateBlsKeyHashForWithdrawal(WhitelistedAccount storage account, bytes32 blsKeyHash)
    internal
    view
    {
        require(_accountHasNode(account, blsKeyHash), "[Validation] BLS key does not exist for this account");
        if (contractState == States.Finalized || contractState == States.Retired) {
            require(
                !account.stakingNodes[account.blsKeyHashToStakingNodeIndex[blsKeyHash]].approved,
                "[Validation] BLS key was already approved, you cannot withdraw the associated amount"
            );
        }
    }
}