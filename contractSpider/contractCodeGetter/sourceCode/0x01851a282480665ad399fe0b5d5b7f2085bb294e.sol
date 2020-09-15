/**
 *Submitted for verification at Etherscan.io on 2020-07-01
*/

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

interface IAccessModule {
    enum Operation {
        // LiquidityModule
        Deposit,
        Withdraw,
        // LoanModule
        CreateDebtProposal,
        AddPledge,
        WithdrawPledge,
        CancelDebtProposal,
        ExecuteDebtProposal,
        Repay,
        ExecuteDebtDefault,
        WithdrawUnlockedPledge
    }
    
    /**
     * @notice Check if operation is allowed
     * @param operation Requested operation
     * @param sender Sender of transaction
     */
    function isOperationAllowed(Operation operation, address sender) external view returns(bool);
}

/**
 * @title Funds Module Interface
 * @dev Funds module is responsible for token transfers, provides info about current liquidity/debts and pool token price.
 */
interface IFundsModule {
    event Status(uint256 lBalance, uint256 lDebts, uint256 lProposals, uint256 pEnterPrice, uint256 pExitPrice);

    /**
     * @notice Deposit liquid tokens to the pool
     * @param from Address of the user, who sends tokens. Should have enough allowance.
     * @param amount Amount of tokens to deposit
     */
    function depositLTokens(address from, uint256 amount) external;
    /**
     * @notice Withdraw liquid tokens from the pool
     * @param to Address of the user, who sends tokens. Should have enough allowance.
     * @param amount Amount of tokens to deposit
     */
    function withdrawLTokens(address to, uint256 amount) external;

    /**
     * @notice Withdraw liquid tokens from the pool
     * @param to Address of the user, who sends tokens. Should have enough allowance.
     * @param amount Amount of tokens to deposit
     * @param poolFee Pool fee will be sent to pool owner
     */
    function withdrawLTokens(address to, uint256 amount, uint256 poolFee) external;

    /**
     * @notice Deposit pool tokens to the pool
     * @param from Address of the user, who sends tokens. Should have enough allowance.
     * @param amount Amount of tokens to deposit
     */
    function depositPTokens(address from, uint256 amount) external;

    /**
     * @notice Withdraw pool tokens from the pool
     * @param to Address of the user, who sends tokens. Should have enough allowance.
     * @param amount Amount of tokens to deposit
     */
    function withdrawPTokens(address to, uint256 amount) external;

    /**
     * @notice Mint new PTokens
     * @param to Address of the user, who sends tokens.
     * @param amount Amount of tokens to mint
     */
    function mintPTokens(address to, uint256 amount) external;

    /**
     * @notice Mint new PTokens and distribute the to other PToken holders
     * @param amount Amount of tokens to mint
     */
    function distributePTokens(uint256 amount) external;

    /**
     * @notice Burn pool tokens
     * @param from Address of the user, whos tokens we burning. Should have enough allowance.
     * @param amount Amount of tokens to burn
     */
    function burnPTokens(address from, uint256 amount) external;

    function lockPTokens(address[] calldata from, uint256[] calldata amount) external;

    function mintAndLockPTokens(uint256 amount) external;

    function unlockAndWithdrawPTokens(address to, uint256 amount) external;

    function burnLockedPTokens(uint256 amount) external;

    /**
     * @notice Calculates how many pTokens should be given to user for increasing liquidity
     * @param lAmount Amount of liquid tokens which will be put into the pool
     * @return Amount of pToken which should be sent to sender
     */
    function calculatePoolEnter(uint256 lAmount) external view returns(uint256);

    /**
     * @notice Calculates how many pTokens should be given to user for increasing liquidity
     * @param lAmount Amount of liquid tokens which will be put into the pool
     * @param liquidityCorrection Amount of liquid tokens to remove from liquidity because it was "virtually" withdrawn
     * @return Amount of pToken which should be sent to sender
     */
    function calculatePoolEnter(uint256 lAmount, uint256 liquidityCorrection) external view returns(uint256);
    
    /**
     * @notice Calculates how many pTokens should be taken from user for decreasing liquidity
     * @param lAmount Amount of liquid tokens which will be removed from the pool
     * @return Amount of pToken which should be taken from sender
     */
    function calculatePoolExit(uint256 lAmount) external view returns(uint256);

    /**
     * @notice Calculates how many liquid tokens should be removed from pool when decreasing liquidity
     * @param pAmount Amount of pToken which should be taken from sender
     * @return Amount of liquid tokens which will be removed from the pool: total, part for sender, part for pool
     */
    function calculatePoolExitInverse(uint256 pAmount) external view returns(uint256, uint256, uint256);

    /**
     * @notice Calculates how many pTokens should be taken from user for decreasing liquidity
     * @param lAmount Amount of liquid tokens which will be removed from the pool
     * @return Amount of pToken which should be taken from sender
     */
    function calculatePoolExitWithFee(uint256 lAmount) external view returns(uint256);

    /**
     * @notice Calculates amount of pTokens which should be burned/locked when liquidity removed from pool
     * @param lAmount Amount of liquid tokens beeing withdrawn. Does NOT include part for pool
     * @param liquidityCorrection Amount of liquid tokens to remove from liquidity because it was "virtually" withdrawn
     * @return Amount of pTokens to burn/lock
     */
    function calculatePoolExitWithFee(uint256 lAmount, uint256 liquidityCorrection) external view returns(uint256);

    /**
     * @notice Current pool liquidity
     * @return available liquidity
     */
    function lBalance() external view returns(uint256);

    /**
     * @return Amount of pTokens locked in FundsModule by account
     */
    function pBalanceOf(address account) external view returns(uint256);

}

/**
 * @title Funds Module Interface
 * @dev Funds module is responsible for deposits, withdrawals, debt proposals, debts and repay.
 */
interface ILoanModule {
    event Repay(address indexed sender, uint256 debt, uint256 lDebtLeft, uint256 lFullPaymentAmount, uint256 lInterestPaid, uint256 pInterestPaid, uint256 newlastPayment);
    event UnlockedPledgeWithdraw(address indexed sender, address indexed borrower, uint256 proposal, uint256 debt, uint256 pAmount);
    event DebtDefaultExecuted(address indexed borrower, uint256 debt, uint256 pBurned);

    /**
     * @notice Creates Debt from proposal
     * @dev Used by LoanProposalModule to create debt
     * @param borrower Address of borrower
     * @param proposal Index of DebtProposal
     * @param lAmount Amount of the loan
     * @return Index of created Debt
     */
    function createDebt(address borrower, uint256 proposal, uint256 lAmount) external returns(uint256);

    /**
     * @notice Repay amount of liquidToken and unlock pTokens
     * @param debt Index of Debt
     * @param lAmount Amount of liquid tokens to repay
     */
    function repay(uint256 debt, uint256 lAmount) external;

    function repayPTK(uint256 debt, uint256 pAmount, uint256 lAmountMin) external;

    function repayAllInterest(address borrower) external;

    /**
     * @notice Allows anyone to default a debt which is behind it's repay deadline
     * @param borrower Address of borrower
     * @param debt Index of borrowers's debt
     */
    function executeDebtDefault(address borrower, uint256 debt) external;

    /**
     * @notice Withdraw part of the pledge which is already unlocked (borrower repaid part of the debt) + interest
     * @param borrower Address of borrower
     * @param debt Index of borrowers's debt
     */
    function withdrawUnlockedPledge(address borrower, uint256 debt) external;

    /**
     * @notice Calculates if default time for the debt is reached
     * @param borrower Address of borrower
     * @param debt Index of borrowers's debt
     * @return true if debt is defaulted
     */
    function isDebtDefaultTimeReached(address borrower, uint256 debt) external view returns(bool);

    /**
     * @notice Check if user has active debts
     * @param borrower Address to check
     * @return True if borrower has unpaid debts
     */
    function hasActiveDebts(address borrower) external view returns(bool);

    /**
     * @notice Total amount of debts
     * @return Summ of all liquid token in debts
     */
    function totalLDebts() external view returns(uint256);

}

/**
 * @title Liquidity Module Interface
 * @dev Liquidity module is responsible for deposits, withdrawals and works with Funds module.
 */
interface ILiquidityModule {

    event Deposit(address indexed sender, uint256 lAmount, uint256 pAmount);
    event Withdraw(address indexed sender, uint256 lAmountTotal, uint256 lAmountUser, uint256 pAmount);

    /*
     * @notice Deposit amount of lToken and mint pTokens
     * @param lAmount Amount of liquid tokens to invest
     * @param pAmountMin Minimal amout of pTokens suitable for sender
     */ 
    function deposit(uint256 lAmount, uint256 pAmountMin) external;

    /**
     * @notice Withdraw amount of lToken and burn pTokens
     * @param pAmount Amount of pTokens to send
     * @param lAmountMin Minimal amount of liquid tokens to withdraw
     */
    function withdraw(uint256 pAmount, uint256 lAmountMin) external;

    /**
     * @notice Simulate withdrawal for loan repay with PTK
     * @param pAmount Amount of pTokens to use
     */
    function withdrawForRepay(address borrower, uint256 pAmount) external;
}

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

/**
 * Base contract for all modules
 */
contract Base is Initializable, Context, Ownable {
    address constant  ZERO_ADDRESS = address(0);

    function initialize() public initializer {
        Ownable.initialize(_msgSender());
    }

}

/**
 * @dev List of module names
 */
contract ModuleNames {
    // Pool Modules
    string public constant MODULE_ACCESS            = "access";
    string public constant MODULE_PTOKEN            = "ptoken";
    string public constant MODULE_CURVE             = "curve";
    string public constant MODULE_FUNDS             = "funds";
    string public constant MODULE_LIQUIDITY         = "liquidity";
    string public constant MODULE_LOAN              = "loan";
    string public constant MODULE_LOAN_LIMTS        = "loan_limits";
    string public constant MODULE_LOAN_PROPOSALS    = "loan_proposals";

    // External Modules (used to store addresses of external contracts)
    string public constant MODULE_LTOKEN            = "ltoken";
}

/**
 * Base contract for all modules
 */
contract Module is Base, ModuleNames {
    event PoolAddressChanged(address newPool);
    address public pool;

    function initialize(address _pool) public initializer {
        Base.initialize();
        setPool(_pool);
    }

    function setPool(address _pool) public onlyOwner {
        require(_pool != ZERO_ADDRESS, "Module: pool address can't be zero");
        pool = _pool;
        emit PoolAddressChanged(_pool);        
    }

    function getModuleAddress(string memory module) public view returns(address){
        require(pool != ZERO_ADDRESS, "Module: no pool");
        (bool success, bytes memory result) = pool.staticcall(abi.encodeWithSignature("get(string)", module));
        
        //Forward error from Pool contract
        if (!success) assembly {
            revert(add(result, 32), result)
        }

        address moduleAddress = abi.decode(result, (address));
        require(moduleAddress != ZERO_ADDRESS, "Module: requested module not found");
        return moduleAddress;
    }

}

contract LiquidityModule is Module, ILiquidityModule {
    struct LiquidityLimits {
        uint256 lDepositMin;     // Minimal amount of liquid tokens for deposit
        uint256 pWithdrawMin;    // Minimal amount of pTokens for withdraw
    }

    LiquidityLimits public limits;

    modifier operationAllowed(IAccessModule.Operation operation) {
        IAccessModule am = IAccessModule(getModuleAddress(MODULE_ACCESS));
        require(am.isOperationAllowed(operation, _msgSender()), "LiquidityModule: operation not allowed");
        _;
    }

    function initialize(address _pool) public initializer {
        Module.initialize(_pool);
        setLimits(10*10**18, 0);    //10 DAI minimal enter
    }

    /**
     * @notice Deposit amount of lToken and mint pTokens
     * @param lAmount Amount of liquid tokens to invest
     * @param pAmountMin Minimal amout of pTokens suitable for sender
     */ 
    function deposit(uint256 lAmount, uint256 pAmountMin) public operationAllowed(IAccessModule.Operation.Deposit) {
        require(lAmount > 0, "LiquidityModule: lAmount should not be 0");
        require(lAmount >= limits.lDepositMin, "LiquidityModule: amount should be >= lDepositMin");
        uint pAmount = fundsModule().calculatePoolEnter(lAmount);
        require(pAmount >= pAmountMin, "LiquidityModule: Minimal amount is too high");
        fundsModule().depositLTokens(_msgSender(), lAmount);
        fundsModule().mintPTokens(_msgSender(), pAmount);
        emit Deposit(_msgSender(), lAmount, pAmount);
    }

    /**
     * @notice Withdraw amount of lToken and burn pTokens
     * @dev This operation also repays all interest on all debts
     * @param pAmount Amount of pTokens to send (this amount does not include pTokens used to pay interest)
     * @param lAmountMin Minimal amount of liquid tokens to withdraw
     */
    function withdraw(uint256 pAmount, uint256 lAmountMin) public operationAllowed(IAccessModule.Operation.Withdraw) {
        require(pAmount > 0, "LiquidityModule: pAmount should not be 0");
        require(pAmount >= limits.pWithdrawMin, "LiquidityModule: amount should be >= pWithdrawMin");
        loanModule().repayAllInterest(_msgSender());
        (uint256 lAmountT, uint256 lAmountU, uint256 lAmountP) = fundsModule().calculatePoolExitInverse(pAmount);
        require(lAmountU >= lAmountMin, "LiquidityModule: Minimal amount is too high");
        uint256 availableLiquidity = fundsModule().lBalance();
        require(lAmountT <= availableLiquidity, "LiquidityModule: not enough liquidity");
        fundsModule().burnPTokens(_msgSender(), pAmount);
        fundsModule().withdrawLTokens(_msgSender(), lAmountU, lAmountP);
        emit Withdraw(_msgSender(), lAmountT, lAmountU, pAmount);
    }

    /**
     * @notice Withdraw amount of lToken and burn pTokens
     * @param borrower Address of the borrower
     * @param pAmount Amount of pTokens to send
     */
    function withdrawForRepay(address borrower, uint256 pAmount) public {
        require(_msgSender() == getModuleAddress(MODULE_LOAN), "LiquidityModule: call only allowed from LoanModule");
        require(pAmount > 0, "LiquidityModule: pAmount should not be 0");
        //require(pAmount >= limits.pWithdrawMin, "LiquidityModule: amount should be >= pWithdrawMin"); //Limit disabled, because this is actually repay
        (uint256 lAmountT, uint256 lAmountU, uint256 lAmountP) = fundsModule().calculatePoolExitInverse(pAmount);
        uint256 availableLiquidity = fundsModule().lBalance();
        require(lAmountP <= availableLiquidity, "LiquidityModule: not enough liquidity");
        fundsModule().burnPTokens(borrower, pAmount);           //We just burn pTokens, withous sending lTokens to _msgSender()
        fundsModule().withdrawLTokens(borrower, 0, lAmountP);   //This call is required to send pool fee
        emit Withdraw(borrower, lAmountT, lAmountU, pAmount);
    }

    function setLimits(uint256 lDepositMin, uint256 pWithdrawMin) public onlyOwner {
        limits.lDepositMin = lDepositMin;
        limits.pWithdrawMin = pWithdrawMin;
    }

    function fundsModule() internal view returns(IFundsModule) {
        return IFundsModule(getModuleAddress(MODULE_FUNDS));
    }

    function loanModule() internal view returns(ILoanModule) {
        return ILoanModule(getModuleAddress(MODULE_LOAN));
    }
}