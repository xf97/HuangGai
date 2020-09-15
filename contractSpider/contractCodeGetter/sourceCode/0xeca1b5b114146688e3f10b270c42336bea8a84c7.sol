/**
 *Submitted for verification at Etherscan.io on 2020-06-30
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

contract FundsOperatorRole is Initializable, Context {
    using Roles for Roles.Role;

    event FundsOperatorAdded(address indexed account);
    event FundsOperatorRemoved(address indexed account);

    Roles.Role private _operators;

    function initialize(address sender) public initializer {
        if (!isFundsOperator(sender)) {
            _addFundsOperator(sender);
        }
    }

    modifier onlyFundsOperator() {
        require(isFundsOperator(_msgSender()), "FundsOperatorRole: caller does not have the FundsOperator role");
        _;
    }

    function addFundsOperator(address account) public onlyFundsOperator {
        _addFundsOperator(account);
    }

    function renounceFundsOperator() public {
        _removeFundsOperator(_msgSender());
    }

    function isFundsOperator(address account) public view returns (bool) {
        return _operators.has(account);
    }

    function _addFundsOperator(address account) internal {
        _operators.add(account);
        emit FundsOperatorAdded(account);
    }

    function _removeFundsOperator(address account) internal {
        _operators.remove(account);
        emit FundsOperatorRemoved(account);
    }

}

contract FundsModule is Module, IFundsModule, FundsOperatorRole {
    using SafeMath for uint256;
    uint256 private constant STATUS_PRICE_AMOUNT = 10**18;  // Used to calculate price for Status event, should represent 1 DAI

    uint256 public lBalance;    //Tracked balance of liquid token, may be less or equal to lToken.balanceOf(address(this))
    mapping(address=>uint256) pBalances;    //Stores how many pTokens is locked in FundsModule by user

    function initialize(address _pool) public initializer {
        Module.initialize(_pool);
        FundsOperatorRole.initialize(_msgSender());
        //lBalance = lToken.balanceOf(address(this)); //We do not initialize lBalance to preserve it's previous value when updgrade
    }

    /**
     * @notice Deposit liquid tokens to the pool
     * @param from Address of the user, who sends tokens. Should have enough allowance.
     * @param amount Amount of tokens to deposit
     */
    function depositLTokens(address from, uint256 amount) public onlyFundsOperator {
        lBalance = lBalance.add(amount);
        require(lToken().transferFrom(from, address(this), amount), "FundsModule: deposit failed");
        emitStatus();
    }

    /**
     * @notice Withdraw liquid tokens from the pool
     * @param to Address of the user, who sends tokens. Should have enough allowance.
     * @param amount Amount of tokens to deposit
     */
    function withdrawLTokens(address to, uint256 amount) public onlyFundsOperator {
        withdrawLTokens(to, amount, 0);
    }

    /**
     * @notice Withdraw liquid tokens from the pool
     * @param to Address of the user, who sends tokens. Should have enough allowance.
     * @param amount Amount of tokens to deposit
     * @param poolFee Pool fee will be sent to pool owner
     */
    function withdrawLTokens(address to, uint256 amount, uint256 poolFee) public onlyFundsOperator {
        lBalance = lBalance.sub(amount);
        if (amount > 0) { //This will be false for "fee only" withdrawal in LiquidityModule.withdrawForRepay()
            require(lToken().transfer(to, amount), "FundsModule: withdraw failed");
        }
        if (poolFee > 0) {
            lBalance = lBalance.sub(poolFee);
            require(lToken().transfer(owner(), poolFee), "FundsModule: fee transfer failed");
        }
        emitStatus();
    }

    /**
     * @notice Deposit pool tokens to the pool
     * @param from Address of the user, who sends tokens. Should have enough allowance.
     * @param amount Amount of tokens to deposit
     */
    function depositPTokens(address from, uint256 amount) public onlyFundsOperator {
        require(pToken().transferFrom(from, address(this), amount), "FundsModule: deposit failed"); //this also runs claimDistributions(from)
        pBalances[from] = pBalances[from].add(amount);
    }

    /**
     * @notice Withdraw pool tokens from the pool
     * @param to Address of the user, who receivs tokens.
     * @param amount Amount of tokens to deposit
     */
    function withdrawPTokens(address to, uint256 amount) public onlyFundsOperator {
        require(pToken().transfer(to, amount), "FundsModule: withdraw failed");  //this also runs claimDistributions(to)
        pBalances[to] = pBalances[to].sub(amount);
    }

    /**
     * @notice Mint new PTokens
     * @param to Address of the user, who sends tokens.
     * @param amount Amount of tokens to mint
     */
    function mintPTokens(address to, uint256 amount) public onlyFundsOperator {
        assert(to != address(this)); //Use mintAndLockPTokens
        require(pToken().mint(to, amount), "FundsModule: mint failed");
    }

    function distributePTokens(uint256 amount) public onlyFundsOperator {
        pToken().distribute(amount);    // This call will eventually mint new pTokens (with next distribution, which should be once a day)
    }
    
    /**
     * @notice Burn pool tokens
     * @param from Address of the user, whos tokens we burning. Should have enough allowance.
     * @param amount Amount of tokens to burn
     */
    function burnPTokens(address from, uint256 amount) public onlyFundsOperator {
        assert(from != address(this)); //Use burnLockedPTokens
        pToken().burnFrom(from, amount); // This call will revert if sender has not enough pTokens. Allowance is always unlimited for FundsModule
    }

    /**
     * @notice Lock pTokens for a loan
     * @param from list of addresses to lock tokens from
     * @param amount list of amounts addresses to lock tokens from
     */
    function lockPTokens(address[] calldata from, uint256[] calldata amount) external onlyFundsOperator {
        require(from.length == amount.length, "FundsModule: from and amount length should match");
        //pToken().claimDistributions(address(this));
        pToken().claimDistributions(from);
        uint256 lockAmount;
        for (uint256 i=0; i < from.length; i++) {
            address account = from[i];
            pBalances[account] = pBalances[account].sub(amount[i]);                
            lockAmount = lockAmount.add(amount[i]);
        }
        pBalances[address(this)] = pBalances[address(this)].add(lockAmount);
    }

    function mintAndLockPTokens(uint256 amount) public onlyFundsOperator {
        require(pToken().mint(address(this), amount), "FundsModule: mint failed"); 
        pBalances[address(this)] = pBalances[address(this)].add(amount);
    }

    function unlockAndWithdrawPTokens(address to, uint256 amount) public onlyFundsOperator {
        require(pToken().transfer(to, amount), "FundsModule: withdraw failed"); //this also runs claimDistributions(to)
        pBalances[address(this)] = pBalances[address(this)].sub(amount);
    }

    function burnLockedPTokens(uint256 amount) public onlyFundsOperator {
        pToken().burn(amount); //This call will revert if something goes wrong
        pBalances[address(this)] = pBalances[address(this)].sub(amount);
    }

    /**
     * @notice Refund liquid tokens accidentially sent directly to this contract
     * @param to Address of the user, who receives refund
     * @param amount Amount of tokens to send
     */
    function refundLTokens(address to, uint256 amount) public onlyFundsOperator {
        uint256 realLBalance = lToken().balanceOf(address(this));
        require(realLBalance.sub(amount) >= lBalance, "FundsModule: not enough tokens to refund");
        require(lToken().transfer(to, amount), "FundsModule: refund failed");
    }

    /**
     * @return Amount of pTokens locked in FundsModule by account
     */
    function pBalanceOf(address account) public view returns(uint256){
        return pBalances[account];
    }

    /**
     * @notice Calculates how many pTokens should be given to user for increasing liquidity
     * @param lAmount Amount of liquid tokens which will be put into the pool
     * @return Amount of pToken which should be sent to sender
     */
    function calculatePoolEnter(uint256 lAmount) public view returns(uint256) {
        uint256 lDebts = loanModule().totalLDebts();
        return curveModule().calculateEnter(lBalance, lDebts, lAmount);
    }

    /**
     * @notice Calculates how many pTokens should be given to user for increasing liquidity
     * @param lAmount Amount of liquid tokens which will be put into the pool
     * @param liquidityCorrection Amount of liquid tokens to remove from liquidity because it was "virtually" withdrawn
     * @return Amount of pToken which should be sent to sender
     */
    function calculatePoolEnter(uint256 lAmount, uint256 liquidityCorrection) public view returns(uint256) {
        uint256 lDebts = loanModule().totalLDebts();
        return curveModule().calculateEnter(lBalance.sub(liquidityCorrection), lDebts, lAmount);
    }

    /**
     * @notice Calculates how many pTokens should be taken from user for decreasing liquidity
     * @param lAmount Amount of liquid tokens which will be removed from the pool
     * @return Amount of pToken which should be taken from sender
     */
    function calculatePoolExit(uint256 lAmount) public view returns(uint256) {
        uint256 lProposals = loanProposalsModule().totalLProposals();
        return curveModule().calculateExit(lBalance.sub(lProposals), lAmount);
    }

    /**
     * @notice Calculates amount of pTokens which should be burned/locked when liquidity removed from pool
     * @param lAmount Amount of liquid tokens beeing withdrawn. Does NOT include part for pool
     * @return Amount of pTokens to burn/lock
     */
    function calculatePoolExitWithFee(uint256 lAmount) public view returns(uint256) {
        uint256 lProposals = loanProposalsModule().totalLProposals();
        return curveModule().calculateExitWithFee(lBalance.sub(lProposals), lAmount);
    }

    /**
     * @notice Calculates amount of pTokens which should be burned/locked when liquidity removed from pool
     * @param lAmount Amount of liquid tokens beeing withdrawn. Does NOT include part for pool
     * @param liquidityCorrection Amount of liquid tokens to remove from liquidity because it was "virtually" withdrawn
     * @return Amount of pTokens to burn/lock
     */
    function calculatePoolExitWithFee(uint256 lAmount, uint256 liquidityCorrection) public view returns(uint256) {
        uint256 lProposals = loanProposalsModule().totalLProposals();
        return curveModule().calculateExitWithFee(lBalance.sub(liquidityCorrection).sub(lProposals), lAmount);
    }

    /**
     * @notice Calculates how many liquid tokens should be removed from pool when decreasing liquidity
     * @param pAmount Amount of pToken which should be taken from sender
     * @return Amount of liquid tokens which will be removed from the pool: total, part for sender, part for pool
     */
    function calculatePoolExitInverse(uint256 pAmount) public view returns(uint256, uint256, uint256) {
        uint256 lProposals = loanProposalsModule().totalLProposals();
        return curveModule().calculateExitInverseWithFee(lBalance.sub(lProposals), pAmount);
    }

    function emitStatus() private {
        uint256 lDebts = loanModule().totalLDebts();
        uint256 lProposals = loanProposalsModule().totalLProposals();
        uint256 pEnterPrice = curveModule().calculateEnter(lBalance, lDebts, STATUS_PRICE_AMOUNT);
        uint256 pExitPrice; // = 0; //0 is default value
        if (lBalance >= STATUS_PRICE_AMOUNT) {
            pExitPrice = curveModule().calculateExit(lBalance.sub(lProposals), STATUS_PRICE_AMOUNT);
        } else {
            pExitPrice = 0;
        }
        emit Status(lBalance, lDebts, lProposals, pEnterPrice, pExitPrice);
    }

    function curveModule() private view returns(ICurveModule) {
        return ICurveModule(getModuleAddress(MODULE_CURVE));
    }
    
    function loanModule() private view returns(ILoanModule) {
        return ILoanModule(getModuleAddress(MODULE_LOAN));
    }

    function loanProposalsModule() private view returns(ILoanProposalsModule) {
        return ILoanProposalsModule(getModuleAddress(MODULE_LOAN_PROPOSALS));
    }

    function pToken() private view returns(IPToken){
        return IPToken(getModuleAddress(MODULE_PTOKEN));
    }
    
    function lToken() private view returns(IERC20){
        return IERC20(getModuleAddress(MODULE_LTOKEN));
    }

}