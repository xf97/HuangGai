/**
 *Submitted for verification at Etherscan.io on 2020-04-30
*/

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
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 *
 * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
 * metering changes introduced in the Istanbul hardfork.
 */
contract ReentrancyGuard {
    bool private _notEntered;

    constructor () internal {
        // Storing an initial non-zero value makes deployment a bit more
        // expensive, but in exchange the refund on every call to nonReentrant
        // will be lower in amount. Since refunds are capped to a percetange of
        // the total transaction's gas, it is best to keep them low in cases
        // like this one, to increase the likelihood of the full refund coming
        // into effect.
        _notEntered = true;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_notEntered, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _notEntered = false;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _notEntered = true;
    }
}

// File: contracts/Recoverable.sol

/**
 * Based on https://github.com/TokenMarketNet/smart-contracts/blob/master/contracts/Recoverable.sol
 */

pragma solidity ^0.5.0;



/**
 * Allows to recover any tokens accidentally send on the smart contract.
 *
 * Sending ethers on token contracts is not possible in the first place.
 * as they are not payable.
 *
 * https://twitter.com/moo9000/status/1238514802189795331
 */
contract Recoverable is Ownable {

  function initialize(address sender) public initializer {
    super.initialize(sender);
  }

  /// @dev This will be invoked by the owner, when owner wants to rescue tokens
  /// @param token Token which will we rescue to the owner from the contract
  function recoverTokens(IERC20 token) public onlyOwner {
    require(token.transfer(owner(), tokensToBeReturned(token)), "Transfer failed");
  }

  /// @dev Interface function, can be overwritten by the superclass
  /// @param token Token which balance we will check and return
  /// @return The amount of tokens (in smallest denominator) the contract owns
  function tokensToBeReturned(IERC20 token) public view returns (uint) {
    return token.balanceOf(address(this));
  }

  // Upgradeability - add some space
  uint256[50] private ______gap;
}

// File: contracts/TokenSwap.sol

pragma solidity ^0.5.0;

// https://github.com/OpenZeppelin/openzeppelin-contracts-ethereum-package/blob/master/contracts/
// https://github.com/OpenZeppelin/openzeppelin-sdk/tree/master/packages/lib/contracts






/**
 * Swap old 1ST token to new DAWN token.
 *
 * Recoverable allows us to recover any wrong ERC-20 tokens user send here by an accident.
 *
 * This contract *is not* behind a proxy.
 * We use Initializable pattern here to be in line with the other contracts.
 * Normal constructor would work as well, but then we would be mixing
 * base contracts from openzeppelin-contracts and openzeppelin-sdk both,
 * which is a huge mess.
 *
 * We are not using SafeMath here, as we are not doing accounting math.
 * user gets out the same amount of tokens they send in.
 *
 */
contract TokenSwap is Initializable, ReentrancyGuard, Pausable, Ownable, Recoverable {

  /* Token coming for a burn */
  IERC20 public oldToken;

  /* Token sent to the swapper */
  IERC20 public newToken;

  /* Where old tokens are send permantly to die */
  address public burnDestination;

  /* Public key of our server-side signing mechanism to ensure everyone who calls swap is whitelisted */
  address public signerAddress;

  /* How many tokens we have successfully swapped */
  uint public totalSwapped;

  /* For following in the dashboard */
  event Swapped(address indexed owner, uint amount);

  /** When the contract owner sends old token to burn address */
  event LegacyBurn(uint amount);

  /** The server-side signer key has been updated */
  event SignerUpdated(address addr);

  /**
   *
   * 1. Owner is a multisig wallet
   * 2. Owner holds newToken supply
   * 3. Owner does approve() on this contract for the full supply
   * 4. Owner can pause swapping
   * 5. Owner can send tokens to be burned
   *
   */
  function initialize(address owner, address signer, address _oldToken, address _newToken, address _burnDestination)
    public initializer {

    // Note: ReentrancyGuard.initialze() was added in OpenZeppelin SDK 2.6.0, we are using 2.5.0
    // ReentrancyGuard.initialize();

    // Deployer account holds temporary ownership until the setup is done
    Ownable.initialize(_msgSender());
    setSignerAddress(signer);

    Pausable.initialize(owner);
    _transferOwnership(owner);

    _setBurnDestination(_burnDestination);

    oldToken = IERC20(_oldToken);
    newToken = IERC20(_newToken);
    require(oldToken.totalSupply() == newToken.totalSupply(), "Cannot create swap, old and new token supply differ");

  }

  function _swap(address whom, uint amount) internal nonReentrant {
    // Move old tokens to this contract
    address swapper = address(this);
    // We have added some user friendly error messages here if they
    // somehow manage to screw interaction
    totalSwapped += amount;
    require(oldToken.transferFrom(whom, swapper, amount), "Could not retrieve old tokens");
    require(newToken.transferFrom(owner(), whom, amount), "Could not send new tokens");
  }

  /**
   * Check that the server-side signature matches.
   *
   * Note that this check does NOT use Ethereum message signing preamble:
   * https://ethereum.stackexchange.com/a/43984/620
   *
   * Thus, you cannot get v, r, s with user facing wallets, you need
   * to work for those using lower level tools.
   *
   */
  function _checkSenderSignature(address sender, uint8 v, bytes32 r, bytes32 s) internal view {
      // https://ethereum.stackexchange.com/a/41356/620
      bytes memory packed = abi.encodePacked(sender);
      bytes32 hashResult = keccak256(packed);
      require(ecrecover(hashResult, v, r, s) == signerAddress, "Address was not properly signed by whitelisting server");
  }

  /**
   * A server-side whitelisted address can swap their tokens.
   *
   * Please note that after whitelisted once, the address can call this multiple times. This is intentional behavior.
   * As whitelisting per transaction is extra complexite that does not server any business goal.
   *
   */
  function swapTokensForSender(uint amount, uint8 v, bytes32 r, bytes32 s) public whenNotPaused {
    _checkSenderSignature(msg.sender, v, r, s);
    address swapper = address(this);
    require(oldToken.allowance(msg.sender, swapper) >= amount, "You need to first approve() enough tokens to swap for this contract");
    require(oldToken.balanceOf(msg.sender) >= amount, "You do not have enough tokens to swap");
    _swap(msg.sender, amount);

    emit Swapped(msg.sender, amount);
  }

  /**
   * How much new tokens we have loaded on the contract to swap.
   */
  function getTokensLeftToSwap() public view returns(uint) {
    return newToken.allowance(owner(), address(this));
  }

  /**
   * Allows admin to burn old tokens
   *
   * Note that the owner could recoverToken() here,
   * before tokens are burned. However, the same
   * owner can upload the code payload of the new token,
   * so the trust risk for this to happen is low compared
   * to other trust risks.
   */
  function burn(uint amount) public onlyOwner {
    require(oldToken.transfer(burnDestination, amount), "Could not send tokens to burn");
    emit LegacyBurn(amount);
  }

  /**
   * Set the address (0x0000) where we are going to send burned tokens.
   */
  function _setBurnDestination(address _destination) internal {
    burnDestination = _destination;
  }

  /**
   * Allow to cycle the server-side signing key.
   */
  function setSignerAddress(address _signerAddress) public onlyOwner {
    signerAddress = _signerAddress;
    emit SignerUpdated(signerAddress);
  }

}