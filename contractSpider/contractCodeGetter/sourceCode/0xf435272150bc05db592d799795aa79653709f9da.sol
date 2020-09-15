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
 * @title Bonding Curve Interface
 * @dev A bonding curve is a method for continous token minting / burning.
 */
/* solhint-disable func-order */
interface ICurveModule {
    /**
     * @notice Calculates amount of pTokens to mint
     * @param liquidAssets Liquid assets in Pool
     * @param debtCommitments Debt commitments
     * @param lAmount Amount of liquidTokens to deposit
     * @return Amount of pTokens to mint/unlock
     */
    function calculateEnter(uint256 liquidAssets, uint256 debtCommitments, uint256 lAmount) external view returns (uint256);

    /**
     * @notice Calculates amount of pTokens which should be burned/locked when liquidity removed from pool
     * @param liquidAssets Liquid assets in Pool
     * @param lAmount Amount of liquid tokens to withdraw (full: sum of withdrawU and withdrawP)
     * @return Amount of pTokens to burn/lock
     */
    function calculateExit(uint256 liquidAssets, uint256 lAmount) external view returns (uint256);

    /**
     * @notice Calculates amount of pTokens which should be burned/locked when liquidity removed from pool
     * @param liquidAssets Liquid assets in Pool
     * @param lAmount Amount of liquid tokens beeing withdrawn. Does NOT include fee = withdrawU
     * @return Amount of pTokens to burn/lock
     */
    function calculateExitWithFee(uint256 liquidAssets, uint256 lAmount) external view returns(uint256);

    /**
     * @notice Calculates amount of liquid tokens one can withdraw from the pool when pTokens are burned/locked
     * @param liquidAssets Liquid assets in Pool
     * @param pAmount Amount of pTokens to withdraw
     * @return Amount of liquid tokens to withdraw: total, for user, for pool
     */
    function calculateExitInverseWithFee(uint256 liquidAssets, uint256 pAmount) external view returns (uint256 withdraw, uint256 withdrawU, uint256 withdrawP);

    /**
     * @notice Calculates lAmount to be taken as fee upon withdraw
     * @param lAmount Amount of liquid tokens beeing withdrawn. Does NOT include fee
     * @return Amount of liquid tokens which will be additionally taken as a pool fee
     */
    function calculateExitFee(uint256 lAmount) external view returns(uint256);
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
 * @title Funds Module Interface
 * @dev Funds module is responsible for deposits, withdrawals, debt proposals, debts and repay.
 */
interface ILoanProposalsModule {
    event DebtProposalCreated(address indexed sender, uint256 proposal, uint256 lAmount, uint256 interest, bytes32 descriptionHash);
    event PledgeAdded(address indexed sender, address indexed borrower, uint256 proposal, uint256 lAmount, uint256 pAmount);
    event PledgeWithdrawn(address indexed sender, address indexed borrower, uint256 proposal, uint256 lAmount, uint256 pAmount);
    event DebtProposalCanceled(address indexed sender, uint256 proposal);
    event DebtProposalExecuted(address indexed sender, uint256 proposal, uint256 debt, uint256 lAmount);

    /**
     * @notice Create DebtProposal
     * @param debtLAmount Amount of debt in liquid tokens
     * @param interest Annual interest rate multiplied by INTEREST_MULTIPLIER (to allow decimal numbers)
     * @param pAmountMax Max amount of pTokens to use as collateral
     * @param descriptionHash Hash of loan description
     * @return Index of created DebtProposal
     */
    function createDebtProposal(uint256 debtLAmount, uint256 interest, uint256 pAmountMax, bytes32 descriptionHash) external returns(uint256);

    /**
     * @notice Add pledge to DebtProposal
     * @param borrower Address of borrower
     * @param proposal Index of borroers's proposal
     * @param pAmount Amount of pTokens to use as collateral
     * @param lAmountMin Minimal amount of liquid tokens to cover by this pledge
     */
    function addPledge(address borrower, uint256 proposal, uint256 pAmount, uint256 lAmountMin) external;

    /**
     * @notice Withdraw pledge from DebtProposal
     * @param borrower Address of borrower
     * @param proposal Index of borrowers's proposal
     * @param pAmount Amount of pTokens to withdraw
     */
    function withdrawPledge(address borrower, uint256 proposal, uint256 pAmount) external;

    /**
     * @notice Execute DebtProposal
     * @dev Creates Debt using data of DebtProposal
     * @param proposal Index of DebtProposal
     * @return Index of created Debt
     */
    function executeDebtProposal(uint256 proposal) external returns(uint256);


    /**
     * @notice Total amount of collateral locked in proposals
     * Although this is measured in liquid tokens, it's not actual tokens,
     * just a value wich is supposed to represent the collateral locked in proposals.
     * @return Summ of all collaterals in proposals
     */
    function totalLProposals() external view returns(uint256);

    /**
     * @notice Returns most used data from proposal and pledge
     * @param borrower Address of borrower
     * @param proposal Proposal id
     * @param supporter Address of supporter (can be same as borrower)
     */
    function getProposalAndPledgeInfo(address borrower, uint256 proposal, address supporter) external view
    returns(uint256 lAmount, uint256 lCovered, uint256 pCollected, uint256 interest, uint256 lPledge, uint256 pPledge);

    /**
    * @dev Returns interest rate of proposal. Usefull when only this value is required
    */
    function getProposalInterestRate(address borrower, uint256 proposal) external view returns(uint256);
}

/**
 * @title Funds Module Interface
 * @dev Funds module is responsible for deposits, withdrawals, debt proposals, debts and repay.
 */
interface ILoanLimitsModule {
    // List of limit types. See LoanLimits struct for descriptions
    enum LoanLimitType {
        L_DEBT_AMOUNT_MIN,
        DEBT_INTEREST_MIN,
        PLEDGE_PERCENT_MIN,
        L_MIN_PLEDGE_MAX,    
        DEBT_LOAD_MAX,       
        MAX_OPEN_PROPOSALS_PER_USER,
        MIN_CANCEL_PROPOSAL_TIMEOUT
    }

    function set(LoanLimitType limit, uint256 value) external;
    function get(LoanLimitType limit) external view returns(uint256);

    function lDebtAmountMin() external view returns(uint256);
    function debtInterestMin() external view returns(uint256);
    function pledgePercentMin() external view returns(uint256);
    function lMinPledgeMax() external view returns(uint256);
    function debtLoadMax() external view returns(uint256);
    function maxOpenProposalsPerUser() external view returns(uint256);
    function minCancelProposalTimeout() external view returns(uint256);
}

/**
 * @title PToken Interface
 */
interface IPToken {
    /* solhint-disable func-order */
    //Standart ERC20
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    //Mintable & Burnable
    function mint(address account, uint256 amount) external returns (bool);
    function burn(uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;

    //Distributions
    function distribute(uint256 amount) external;
    function claimDistributions(address account) external returns(uint256);
    function claimDistributions(address account, uint256 lastDistribution) external returns(uint256);
    function claimDistributions(address[] calldata accounts) external;
    function claimDistributions(address[] calldata accounts, uint256 toDistribution) external;
    function fullBalanceOf(address account) external view returns(uint256);
    function calculateDistributedAmount(uint256 startDistribution, uint256 nextDistribution, uint256 initialBalance) external view returns(uint256);
    function nextDistribution() external view returns(uint256);

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

contract LoanModule is Module, ILoanModule {
    using SafeMath for uint256;

    uint256 public constant INTEREST_MULTIPLIER = 10**3;    // Multiplier to store interest rate (decimal) in int
    uint256 public constant ANNUAL_SECONDS = 365*24*60*60+(24*60*60/4);  // Seconds in a year + 1/4 day to compensate leap years

    uint256 public constant DEBT_REPAY_DEADLINE_PERIOD = 90*24*60*60;   //Period before debt without payments may be defaulted

    uint256 public constant DEBT_LOAD_MULTIPLIER = 10**3;

    struct Debt {
        uint256 proposal;           // Index of DebtProposal in adress's proposal list
        uint256 lAmount;            // Current amount of debt (in liquid token). If 0 - debt is fully paid
        uint256 lastPayment;        // Timestamp of last interest payment (can be timestamp of last payment or a virtual date untill which interest is paid)
        uint256 pInterest;          // Amount of pTokens minted as interest for this debt
        mapping(address => uint256) claimedPledges;  //Amount of pTokens already claimed by supporter
        bool defaultExecuted;       // If debt default is already executed by executeDebtDefault()
    }

    mapping(address=>Debt[]) public debts;                 

    uint256 private lDebts;

    mapping(address=>uint256) public activeDebts;           // Counts how many active debts the address has 

    modifier operationAllowed(IAccessModule.Operation operation) {
        IAccessModule am = IAccessModule(getModuleAddress(MODULE_ACCESS));
        require(am.isOperationAllowed(operation, _msgSender()), "LoanModule: operation not allowed");
        _;
    }

    function initialize(address _pool) public initializer {
        Module.initialize(_pool);
    }

    /**
     * @notice Execute DebtProposal
     * @dev Creates Debt using data of DebtProposal
     * @param proposal Index of DebtProposal
     * @return Index of created Debt
     */
    function createDebt(address borrower, uint256 proposal, uint256 lAmount) public returns(uint256) {
        require(_msgSender() == getModuleAddress(MODULE_LOAN_PROPOSALS), "LoanModule: requests only accepted from LoanProposalsModule");
        //TODO: check there is no debt for this proposal
        debts[borrower].push(Debt({
            proposal: proposal,
            lAmount: lAmount,
            lastPayment: now,
            pInterest: 0,
            defaultExecuted: false
        }));
        uint256 debtIdx = debts[borrower].length-1; //It's important to save index before calling external contract

        uint256 maxDebts = limits().debtLoadMax().mul(fundsModule().lBalance().add(lDebts)).div(DEBT_LOAD_MULTIPLIER);

        lDebts = lDebts.add(lAmount);
        require(lDebts <= maxDebts, "LoanModule: Debt can not be created now because of debt loan limit");

        //Move locked pTokens to Funds - done in LoanProposals

        increaseActiveDebts(borrower);
        fundsModule().withdrawLTokens(borrower, lAmount);
        return debtIdx;
    }

    /**
     * @notice Repay amount of lToken and unlock pTokens
     * @param debt Index of Debt
     * @param lAmount Amount of liquid tokens to repay (it will not take more than needed for full debt repayment)
     */
    function repay(uint256 debt, uint256 lAmount) public operationAllowed(IAccessModule.Operation.Repay) {
        address borrower = _msgSender();
        Debt storage d = debts[borrower][debt];
        require(d.lAmount > 0, "LoanModule: Debt is already fully repaid"); //Or wrong debt index
        require(!_isDebtDefaultTimeReached(d), "LoanModule: debt is already defaulted");

        (, uint256 lCovered, , uint256 interest, uint256 pledgeLAmount, )
        = loanProposals().getProposalAndPledgeInfo(borrower, d.proposal, borrower);

        uint256 lInterest = calculateInterestPayment(d.lAmount, interest, d.lastPayment, now);

        uint256 actualInterest;
        if (lAmount < lInterest) {
            uint256 paidTime = now.sub(d.lastPayment).mul(lAmount).div(lInterest);
            assert(d.lastPayment + paidTime <= now);
            d.lastPayment = d.lastPayment.add(paidTime);
            actualInterest = lAmount;
        } else {
            uint256 fullRepayLAmount = d.lAmount.add(lInterest);
            if (lAmount > fullRepayLAmount) lAmount = fullRepayLAmount;

            d.lastPayment = now;
            uint256 debtReturned = lAmount.sub(lInterest);
            d.lAmount = d.lAmount.sub(debtReturned);
            lDebts = lDebts.sub(debtReturned);
            actualInterest = lInterest;
        }

        uint256 pInterest = calculatePoolEnter(actualInterest);
        d.pInterest = d.pInterest.add(pInterest);
        uint256 poolInterest = pInterest.mul(pledgeLAmount).div(lCovered);

        fundsModule().depositLTokens(borrower, lAmount); 
        fundsModule().distributePTokens(poolInterest);
        fundsModule().mintAndLockPTokens(pInterest.sub(poolInterest));

        emit Repay(_msgSender(), debt, d.lAmount, lAmount, actualInterest, pInterest, d.lastPayment);

        if (d.lAmount == 0) {
            //Debt is fully repaid
            decreaseActiveDebts(borrower);
            withdrawUnlockedPledge(borrower, debt);
        }
    }

    function repayPTK(uint256 debt, uint256 pAmount, uint256 lAmountMin) public operationAllowed(IAccessModule.Operation.Repay) {
        address borrower = _msgSender();
        Debt storage d = debts[borrower][debt];
        require(d.lAmount > 0, "LoanModule: Debt is already fully repaid"); //Or wrong debt index
        require(!_isDebtDefaultTimeReached(d), "LoanModule: debt is already defaulted");

        (, uint256 lAmount,) = fundsModule().calculatePoolExitInverse(pAmount);
        require(lAmount >= lAmountMin, "LoanModule: Minimal amount is too high");

        (uint256 actualPAmount, uint256 actualInterest, uint256 pInterest, uint256 poolInterest) 
            = repayPTK_calculateInterestAndUpdateDebt(borrower, d, lAmount);
        if (actualPAmount == 0) actualPAmount = pAmount; // Fix of stack too deep if send original pAmount to repayPTK_calculateInterestAndUpdateDebt

        liquidityModule().withdrawForRepay(borrower, actualPAmount);
        fundsModule().distributePTokens(poolInterest);
        fundsModule().mintAndLockPTokens(pInterest.sub(poolInterest));

        emit Repay(_msgSender(), debt, d.lAmount, lAmount, actualInterest, pInterest, d.lastPayment);

        if (d.lAmount == 0) {
            //Debt is fully repaid
            decreaseActiveDebts(borrower);
            withdrawUnlockedPledge(borrower, debt);
        }
    }

    function repayPTK_calculateInterestAndUpdateDebt(address borrower, Debt storage d, uint256 lAmount) private 
    returns(uint256 pAmount, uint256 actualInterest, uint256 pInterest, uint256 poolInterest){
        (, uint256 lCovered, , uint256 interest, uint256 lPledge, )
        = loanProposals().getProposalAndPledgeInfo(borrower, d.proposal, borrower);

        uint256 lInterest = calculateInterestPayment(d.lAmount, interest, d.lastPayment, now);
        if (lAmount < lInterest) {
            uint256 paidTime = now.sub(d.lastPayment).mul(lAmount).div(lInterest);
            assert(d.lastPayment + paidTime <= now);
            d.lastPayment = d.lastPayment.add(paidTime);
            actualInterest = lAmount;
        } else {
            uint256 fullRepayLAmount = d.lAmount.add(lInterest);
            if (lAmount > fullRepayLAmount) {
                lAmount = fullRepayLAmount;
                pAmount = calculatePoolExitWithFee(lAmount);
            }

            d.lastPayment = now;
            uint256 debtReturned = lAmount.sub(lInterest);
            d.lAmount = d.lAmount.sub(debtReturned);
            lDebts = lDebts.sub(debtReturned);
            actualInterest = lInterest;
        }

        //current liquidity already includes lAmount, which was never actually withdrawn, so we need to remove it here
        pInterest = calculatePoolEnter(actualInterest, lAmount); 
        d.pInterest = d.pInterest.add(pInterest);
        poolInterest = pInterest.mul(lPledge).div(lCovered);
    }

    function repayAllInterest(address borrower) public {
        require(_msgSender() == getModuleAddress(MODULE_LIQUIDITY), "LoanModule: call only allowed from LiquidityModule");
        Debt[] storage userDebts = debts[borrower];
        if (userDebts.length == 0) return;
        uint256 totalLFee;
        uint256 totalPWithdraw;
        uint256 totalPInterestToDistribute;
        uint256 totalPInterestToMint;
        uint256 activeDebtCount = 0;
        for (int256 i=int256(userDebts.length)-1; i >= 0; i--){
            Debt storage d = userDebts[uint256(i)];
            // bool isUnpaid = (d.lAmount != 0);
            // bool isDefaulted = _isDebtDefaultTimeReached(d);
            // if (isUnpaid && !isDefaulted){                      
            if ((d.lAmount != 0) && !_isDebtDefaultTimeReached(d)){ //removed isUnpaid and isDefaulted variables to preent "Stack too deep" error
                (uint256 pWithdrawn, uint256 lFee, uint256 poolInterest, uint256 pInterestToMint) 
                    = repayInterestForDebt(borrower, uint256(i), d, totalLFee);
                totalPWithdraw = totalPWithdraw.add(pWithdrawn);
                totalLFee = totalLFee.add(lFee);
                totalPInterestToDistribute = totalPInterestToDistribute.add(poolInterest);
                totalPInterestToMint = totalPInterestToMint.add(pInterestToMint);

                activeDebtCount++;
                if (activeDebtCount >= activeDebts[borrower]) break;
            }
        }
        if (totalPWithdraw > 0) {
            liquidityModule().withdrawForRepay(borrower, totalPWithdraw);
            fundsModule().distributePTokens(totalPInterestToDistribute);
            fundsModule().mintAndLockPTokens(totalPInterestToMint);
        } else {
            assert(totalPInterestToDistribute == 0);
            assert(totalPInterestToMint == 0);
        }
    }

    function repayInterestForDebt(address borrower, uint256 debt, Debt storage d, uint256 totalLFee) private 
    returns(uint256 pWithdrawn, uint256 lFee, uint256 poolInterest, uint256 pInterestToMint) {
        (, uint256 lCovered, , uint256 interest, uint256 lPledge, )
        = loanProposals().getProposalAndPledgeInfo(borrower, d.proposal, borrower);
        uint256 lInterest = calculateInterestPayment(d.lAmount, interest, d.lastPayment, now);
        pWithdrawn = calculatePoolExitWithFee(lInterest, totalLFee);
        lFee = calculateExitFee(lInterest);

        //Update debt
        d.lastPayment = now;
        //current liquidity already includes totalLFee, which was never actually withdrawn, so we need to remove it here
        uint256 pInterest = calculatePoolEnter(lInterest, lInterest.add(totalLFee)); 
        d.pInterest = d.pInterest.add(pInterest);
        poolInterest = pInterest.mul(lPledge).div(lCovered);
        pInterestToMint = pInterest.sub(poolInterest); //We substract interest that will be minted during distribution
        emitRepay(borrower, debt, d, lInterest, lInterest, pInterest);
    }

    function emitRepay(address borrower, uint256 debt, Debt storage d, uint256 lFullPaymentAmount, uint256 lInterestPaid, uint256 pInterestPaid) private {
        emit Repay(borrower, debt, d.lAmount, lFullPaymentAmount, lInterestPaid, pInterestPaid, d.lastPayment);
    }

    /**
     * @notice Allows anyone to default a debt which is behind it's repay deadline
     * @param borrower Address of borrower
     * @param debt Index of borrowers's debt
     */
    function executeDebtDefault(address borrower, uint256 debt) public operationAllowed(IAccessModule.Operation.ExecuteDebtDefault) {
        Debt storage dbt = debts[borrower][debt];
        require(dbt.lAmount > 0, "LoanModule: debt is fully repaid");
        require(!dbt.defaultExecuted, "LoanModule: default is already executed");
        require(_isDebtDefaultTimeReached(dbt), "LoanModule: not enough time passed");

        (uint256 proposalLAmount, , uint256 pCollected, , , uint256 pPledge)
        = loanProposals().getProposalAndPledgeInfo(borrower, dbt.proposal, borrower);

        withdrawDebtDefaultPayment(borrower, debt);

        uint256 pLockedBorrower = pPledge.mul(dbt.lAmount).div(proposalLAmount);
        uint256 pUnlockedBorrower = pPledge.sub(pLockedBorrower);
        uint256 pSupportersPledge = pCollected.sub(pPledge);
        uint256 pLockedSupportersPledge = pSupportersPledge.mul(dbt.lAmount).div(proposalLAmount);
        uint256 pLocked = pLockedBorrower.add(pLockedSupportersPledge);
        dbt.defaultExecuted = true;
        lDebts = lDebts.sub(dbt.lAmount);
        uint256 pExtra;
        if (pUnlockedBorrower > pLockedSupportersPledge){
            pExtra = pUnlockedBorrower - pLockedSupportersPledge;
            fundsModule().distributePTokens(pExtra);
        }
        fundsModule().burnLockedPTokens(pLocked.add(pExtra));
        decreaseActiveDebts(borrower);
        emit DebtDefaultExecuted(borrower, debt, pLocked);
    }

    /**
     * @notice Withdraw part of the pledge which is already unlocked (borrower repaid part of the debt) + interest
     * @param borrower Address of borrower
     * @param debt Index of borrowers's debt
     */
    function withdrawUnlockedPledge(address borrower, uint256 debt) public operationAllowed(IAccessModule.Operation.WithdrawUnlockedPledge) {
        (, uint256 pUnlocked, uint256 pInterest, uint256 pWithdrawn) = calculatePledgeInfo(borrower, debt, _msgSender());

        uint256 pUnlockedPlusInterest = pUnlocked.add(pInterest);
        require(pUnlockedPlusInterest > pWithdrawn, "LoanModule: nothing to withdraw");
        uint256 pAmount = pUnlockedPlusInterest.sub(pWithdrawn);

        Debt storage dbt = debts[borrower][debt];
        dbt.claimedPledges[_msgSender()] = dbt.claimedPledges[_msgSender()].add(pAmount);
        
        fundsModule().unlockAndWithdrawPTokens(_msgSender(), pAmount);
        emit UnlockedPledgeWithdraw(_msgSender(), borrower, dbt.proposal, debt, pAmount);
    }

    /**
     * @notice Calculates if default time for the debt is reached
     * @param borrower Address of borrower
     * @param debt Index of borrowers's debt
     * @return true if debt is defaulted
     */
    function isDebtDefaultTimeReached(address borrower, uint256 debt) public view returns(bool) {
        Debt storage dbt = debts[borrower][debt];
        return _isDebtDefaultTimeReached(dbt);
    }

    /**
     * @notice Calculates current pledge state
     * @param borrower Address of borrower
     * @param debt Index of borrowers's debt
     * @param supporter Address of supporter to check. If supporter == borrower, special rules applied.
     * @return current pledge state:
     *      pLocked - locked pTokens
     *      pUnlocked - unlocked pTokens (including already withdrawn)
     *      pInterest - received interest
     *      pWithdrawn - amount of already withdrawn pTokens
     */
    function calculatePledgeInfo(address borrower, uint256 debt, address supporter) public view
    returns(uint256 pLocked, uint256 pUnlocked, uint256 pInterest, uint256 pWithdrawn){
        Debt storage dbt = debts[borrower][debt];

        (uint256 proposalLAmount, uint256 lCovered, , , uint256 lPledge, uint256 pPledge)
        = loanProposals().getProposalAndPledgeInfo(borrower, dbt.proposal, supporter);

        pWithdrawn = dbt.claimedPledges[supporter];

        // DebtPledge storage dp = proposal.pledges[supporter];

        if (supporter == borrower) {
            if (dbt.lAmount == 0) {
                pLocked = 0;
                pUnlocked = pPledge;
            } else {
                pLocked = pPledge;
                pUnlocked = 0;
                if (dbt.defaultExecuted || _isDebtDefaultTimeReached(dbt)) {
                    pLocked = 0; 
                }
            }
            pInterest = 0;
        }else{
            pLocked = pPledge.mul(dbt.lAmount).div(proposalLAmount);
            assert(pLocked <= pPledge);
            pUnlocked = pPledge.sub(pLocked);
            pInterest = dbt.pInterest.mul(lPledge).div(lCovered);
            assert(pInterest <= dbt.pInterest);
            if (dbt.defaultExecuted || _isDebtDefaultTimeReached(dbt)) {
                (pLocked, pUnlocked) = calculatePledgeInfoForDefault(borrower, dbt, proposalLAmount, lCovered, lPledge, pLocked, pUnlocked);
            }
        }
    }

    function calculatePledgeInfoForDefault(
        address borrower, Debt storage dbt, uint256 proposalLAmount, uint256 lCovered, uint256 lPledge, 
        uint256 pLocked, uint256 pUnlocked) private view
    returns(uint256, uint256){
        (, , , , uint256 bpledgeLAmount, uint256 bpledgePAmount) = loanProposals().getProposalAndPledgeInfo(borrower, dbt.proposal, borrower);
        uint256 pLockedBorrower = bpledgePAmount.mul(dbt.lAmount).div(proposalLAmount);
        uint256 pUnlockedBorrower = bpledgePAmount.sub(pLockedBorrower);
        uint256 pCompensation = pUnlockedBorrower.mul(lPledge).div(lCovered.sub(bpledgeLAmount));
        if (pCompensation > pLocked) {
            pCompensation = pLocked;
        }
        if (dbt.defaultExecuted) {
            pLocked = 0;
            pUnlocked = pUnlocked.add(pCompensation);
        }else {
            pLocked = pCompensation;
        }
        return (pLocked, pUnlocked);
    }

    /**
     * @notice Calculates current pledge state
     * @param borrower Address of borrower
     * @param debt Index of borrowers's debt
     * @return Amount of unpaid debt, amount of interest payment
     */
    function getDebtRequiredPayments(address borrower, uint256 debt) public view returns(uint256, uint256) {
        Debt storage d = debts[borrower][debt];
        if (d.lAmount == 0) {
            return (0, 0);
        }
        uint256 interestRate = loanProposals().getProposalInterestRate(borrower, d.proposal);

        uint256 interest = calculateInterestPayment(d.lAmount, interestRate, d.lastPayment, now);
        return (d.lAmount, interest);
    }

    /**
     * @notice Check if user has active debts
     * @param borrower Address to check
     * @return True if borrower has unpaid debts
     */
    function hasActiveDebts(address borrower) public view returns(bool) {
        return activeDebts[borrower] > 0;
    }

    /**
     * @notice Calculates unpaid interest on all actve debts of the borrower
     * @dev This function may use a lot of gas, so it is not recommended to call it in the context of transaction. Use payAllInterest() instead.
     * @param borrower Address of borrower
     * @return summ of interest payments on all unpaid debts, summ of all interest payments per second
     */
    function getUnpaidInterest(address borrower) public view returns(uint256 totalLInterest, uint256 totalLInterestPerSecond){
        Debt[] storage userDebts = debts[borrower];
        if (userDebts.length == 0) return (0, 0);
        uint256 activeDebtCount;
        for (int256 i=int256(userDebts.length)-1; i >= 0; i--){
            Debt storage d = userDebts[uint256(i)];
            bool isUnpaid = (d.lAmount != 0);
            bool isDefaulted = _isDebtDefaultTimeReached(d);
            if (isUnpaid && !isDefaulted){
                uint256 interestRate = loanProposals().getProposalInterestRate(borrower, d.proposal);
                uint256 lInterest = calculateInterestPayment(d.lAmount, interestRate, d.lastPayment, now);
                uint256 lInterestPerSecond = lInterest.div(now.sub(d.lastPayment));
                totalLInterest = totalLInterest.add(lInterest);
                totalLInterestPerSecond = totalLInterestPerSecond.add(lInterestPerSecond);

                activeDebtCount++;
                if (activeDebtCount >= activeDebts[borrower]) break;
            }
        }
    }

    /**
     * @notice Total amount of debts
     * @return Sum of all liquid token in debts
     */
    function totalLDebts() public view returns(uint256){
        return lDebts;
    }

    /**
     * @notice Calculates interest amount for a debt
     * @param debtLAmount Current amount of debt
     * @param interest Annual interest rate multiplied by INTEREST_MULTIPLIER
     * @param prevPayment Timestamp of previous payment
     * @param currentPayment Timestamp of current payment
     */
    function calculateInterestPayment(uint256 debtLAmount, uint256 interest, uint256 prevPayment, uint currentPayment) public pure returns(uint256){
        require(prevPayment <= currentPayment, "LoanModule: prevPayment should be before currentPayment");
        uint256 annualInterest = debtLAmount.mul(interest).div(INTEREST_MULTIPLIER);
        uint256 time = currentPayment.sub(prevPayment);
        return time.mul(annualInterest).div(ANNUAL_SECONDS);
    }

    /**
     * @notice Calculates how many pTokens should be given to user for increasing liquidity
     * @param lAmount Amount of liquid tokens which will be put into the pool
     * @return Amount of pToken which should be sent to sender
     */
    function calculatePoolEnter(uint256 lAmount) internal view returns(uint256) {
        return fundsModule().calculatePoolEnter(lAmount);
    }

    /**
     * @notice Calculates how many pTokens should be given to user for increasing liquidity
     * @param lAmount Amount of liquid tokens which will be put into the pool
     * @param liquidityCorrection Amount of liquid tokens to remove from liquidity because it was "virtually" withdrawn
     * @return Amount of pToken which should be sent to sender
     */
    function calculatePoolEnter(uint256 lAmount, uint256 liquidityCorrection) internal view returns(uint256) {
        return fundsModule().calculatePoolEnter(lAmount, liquidityCorrection);
    }

    /**
     * @notice Calculates how many pTokens should be taken from user for decreasing liquidity
     * @param lAmount Amount of liquid tokens which will be removed from the pool
     * @return Amount of pToken which should be taken from sender
     */
    function calculatePoolExit(uint256 lAmount) internal view returns(uint256) {
        return fundsModule().calculatePoolExit(lAmount);
    }
    
    function calculatePoolExitWithFee(uint256 lAmount) internal view returns(uint256) {
        return fundsModule().calculatePoolExitWithFee(lAmount);
    }

    function calculatePoolExitWithFee(uint256 lAmount, uint256 liquidityCorrection) internal view returns(uint256) {
        return fundsModule().calculatePoolExitWithFee(lAmount, liquidityCorrection);
    }

    /**
     * @notice Calculates how many liquid tokens should be removed from pool when decreasing liquidity
     * @param pAmount Amount of pToken which should be taken from sender
     * @return Amount of liquid tokens which will be removed from the pool: total, part for sender, part for pool
     */
    function calculatePoolExitInverse(uint256 pAmount) internal view returns(uint256, uint256, uint256) {
        return fundsModule().calculatePoolExitInverse(pAmount);
    }

    function calculateExitFee(uint256 lAmount) internal view returns(uint256){
        return ICurveModule(getModuleAddress(MODULE_CURVE)).calculateExitFee(lAmount);
    }

    function fundsModule() internal view returns(IFundsModule) {
        return IFundsModule(getModuleAddress(MODULE_FUNDS));
    }

    function liquidityModule() internal view returns(ILiquidityModule) {
        return ILiquidityModule(getModuleAddress(MODULE_LIQUIDITY));
    }

    function pToken() internal view returns(IPToken){
        return IPToken(getModuleAddress(MODULE_PTOKEN));
    }

    function limits() internal view returns(ILoanLimitsModule) {
        return ILoanLimitsModule(getModuleAddress(MODULE_LOAN_LIMTS));
    }

    function loanProposals() internal view returns(ILoanProposalsModule) {
        return ILoanProposalsModule(getModuleAddress(MODULE_LOAN_PROPOSALS));
    }

    function increaseActiveDebts(address borrower) private {
        activeDebts[borrower] = activeDebts[borrower].add(1);
    }

    function decreaseActiveDebts(address borrower) private {
        activeDebts[borrower] = activeDebts[borrower].sub(1);
    }

    function withdrawDebtDefaultPayment(address borrower, uint256 debt) private {
        Debt storage d = debts[borrower][debt];

        uint256 lInterest = calculateInterestPayment(d.lAmount, loanProposals().getProposalInterestRate(borrower, d.proposal), d.lastPayment, now);

        uint256 lAmount = d.lAmount.add(lInterest);
        uint256 pAmount = calculatePoolExitWithFee(lAmount);
        uint256 pBalance = pToken().balanceOf(borrower);
        if (pBalance == 0) return;

        if (pAmount > pBalance) {
            pAmount = pBalance;
            (, lAmount,) = fundsModule().calculatePoolExitInverse(pAmount);
        }

        (uint256 pInterest, uint256 poolInterest) 
            = withdrawDebtDefaultPayment_calculatePInterest(borrower, d, lAmount, lInterest); 
        d.pInterest = d.pInterest.add(pInterest);
        
        if (lAmount < lInterest) {
            uint256 paidTime = now.sub(d.lastPayment).mul(lAmount).div(lInterest);
            assert(d.lastPayment + paidTime <= now);
            d.lastPayment = d.lastPayment.add(paidTime);
            lInterest = lAmount;
        } else {
            d.lastPayment = now;
            uint256 debtReturned = lAmount.sub(lInterest);
            d.lAmount = d.lAmount.sub(debtReturned);
            lDebts = lDebts.sub(debtReturned);
        }


        liquidityModule().withdrawForRepay(borrower, pAmount);
        fundsModule().distributePTokens(poolInterest);
        fundsModule().mintAndLockPTokens(pInterest.sub(poolInterest));

        emit Repay(borrower, debt, d.lAmount, lAmount, lInterest, pInterest, d.lastPayment);
    }

    function withdrawDebtDefaultPayment_calculatePInterest(address borrower, Debt storage d, uint256 lAmount, uint256 lInterest) private view 
    returns(uint256 pInterest, uint256 poolInterest) {
        //current liquidity already includes lAmount, which was never actually withdrawn, so we need to remove it here
        pInterest = calculatePoolEnter(lInterest, lAmount); 

        (, uint256 lCovered, , , uint256 lPledge, )
        = loanProposals().getProposalAndPledgeInfo(borrower, d.proposal, borrower);
        poolInterest = pInterest.mul(lPledge).div(lCovered);
    }

    function _isDebtDefaultTimeReached(Debt storage dbt) private view returns(bool) {
        uint256 timeSinceLastPayment = now.sub(dbt.lastPayment);
        return timeSinceLastPayment > DEBT_REPAY_DEADLINE_PERIOD;
    }
}