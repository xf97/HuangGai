/**
 *Submitted for verification at Etherscan.io on 2020-06-26
*/

pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

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


contract ContextUpgradeable is Initializable {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    function initialize() virtual public initializer { }

    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


contract OwnableUpgradeable is ContextUpgradeable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    function initialize() override virtual public initializer {
        ContextUpgradeable.initialize();

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


library Account {
    struct Info {
        address owner; // The address that owns the account
        uint256 number; // A nonce that allows a single address to control many accounts
    }
}

library Actions {
    enum ActionType {
        Deposit, // supply tokens
        Withdraw, // borrow tokens
        Transfer, // transfer balance between accounts
        Buy, // buy an amount of some token (publicly)
        Sell, // sell an amount of some token (publicly)
        Trade, // trade tokens against another account
        Liquidate, // liquidate an undercollateralized or expiring account
        Vaporize, // use excess tokens to zero-out a completely negative account
        Call // send arbitrary data to an address
    }
    struct ActionArgs {
        ActionType actionType;
        uint256 accountId;
        Types.AssetAmount amount;
        uint256 primaryMarketId;
        uint256 secondaryMarketId;
        address otherAddress;
        uint256 otherAccountId;
        bytes data;
    }
}

library Types {
    enum AssetDenomination {
        Wei, // the amount is denominated in wei
        Par // the amount is denominated in par
    }

    enum AssetReference {
        Delta, // the amount is given as a delta from the current value
        Target // the amount is given as an exact number to end up at
    }

    struct AssetAmount {
        bool sign; // true if positive
        AssetDenomination denomination;
        AssetReference ref;
        uint256 value;
    }
 
    struct Par {
        bool sign; // true if positive
        uint128 value;
    }

    struct Wei {
        bool sign; // true if positive
        uint256 value;
    }
}

interface ISoloMargin {
    function operate(
        Account.Info[] memory accounts,
        Actions.ActionArgs[] memory actions
    ) external;

    function getAccountBalances(Account.Info memory account)
        external view
        returns (
            address[] memory,
            Types.Par[] memory,
            Types.Wei[] memory
        );
}

contract dYdXWrapper is OwnableUpgradeable {
    IERC20 public constant DAI = IERC20(
        0x6B175474E89094C44Da98b954EedeAC495271d0F
    );
    ISoloMargin public constant soloMargin = ISoloMargin(
        0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e
    );

    function initialize() public override initializer {
        OwnableUpgradeable.initialize();
        DAI.approve(address(soloMargin), 100000e18);
    }

    function deposit(uint256 value) external onlyOwner {
        Account.Info[] memory accounts = new Account.Info[](1);
        accounts[0] = Account.Info(address(this), 0);

        Actions.ActionArgs[] memory actions = new Actions.ActionArgs[](1);
        actions[0] = Actions.ActionArgs(
            Actions.ActionType.Deposit,
            0,
            Types.AssetAmount(
                true,
                Types.AssetDenomination.Wei,
                Types.AssetReference.Delta,
                value
            ),
            3,
            0,
            address(this),
            0,
            bytes("")
        );
        soloMargin.operate(accounts, actions);
    }

    function withdraw(uint256 value) external onlyOwner {
        Account.Info[] memory accounts = new Account.Info[](1);
        accounts[0] = Account.Info(address(this), 0);

        Actions.ActionArgs[] memory actions = new Actions.ActionArgs[](1);

        actions[0] = Actions.ActionArgs({
            actionType: Actions.ActionType.Withdraw,
            accountId: 0,
            amount: Types.AssetAmount({
                sign: false,
                denomination: Types.AssetDenomination.Wei,
                ref: Types.AssetReference.Delta,
                value: value
            }),
            primaryMarketId: 3,
            secondaryMarketId: 0,
            otherAddress: address(this),
            otherAccountId: 0,
            data: ""
        });
        soloMargin.operate(accounts, actions);
    }

    function me() public view returns (address) {
        return address(this);
    }

    function balance()
        external
        view
        returns (
            address[] memory,
            Types.Par[] memory,
            Types.Wei[] memory
        )
    {
        Account.Info memory account = Account.Info(address(this), 0);
        return soloMargin.getAccountBalances(account);
    }
}