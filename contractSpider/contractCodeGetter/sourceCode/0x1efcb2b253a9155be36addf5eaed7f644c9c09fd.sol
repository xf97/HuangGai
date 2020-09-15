/**
 *Submitted for verification at Etherscan.io on 2020-07-01
*/

pragma solidity ^0.5.0;

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

contract LoanLimitsModule is Module, ILoanLimitsModule{
    // This constants are copied from LoanModule   
    uint256 public constant INTEREST_MULTIPLIER = 10**3;
    uint256 public constant PLEDGE_PERCENT_MULTIPLIER = 10**3;
    uint256 public constant DEBT_LOAD_MULTIPLIER = 10**3;



    // struct LoanLimits {
    //     uint256 lDebtAmountMin;     // Minimal amount of proposed credit (DebtProposal.lAmount)
    //     uint256 debtInterestMin;    // Minimal value of debt interest
    //     uint256 pledgePercentMin;   // Minimal pledge as percent of credit collateral amount. Value is divided to PLEDGE_PERCENT_MULTIPLIER for calculations
    //     uint256 lMinPledgeMax;      // Maximal value of minimal pledge (in liquid tokens), works together with pledgePercentMin
    //     uint256 debtLoadMax;        // Maximal ratio LoanModule.lDebts/(FundsModule.lBalance+LoanModule.lDebts)<=debtLoadMax; multiplied to DEBT_LOAD_MULTIPLIER
    //     uint256 maxOpenProposalsPerUser;  // How many open proposals are allowed for user
    //     uint256 minCancelProposalTimeout; // Minimal time (seconds) before a proposal can be cancelled
    // }
    //LoanLimits public limits;

    uint256[7] limits;

    function initialize(address _pool) public initializer {
        Module.initialize(_pool);
        // limits = LoanLimits({
        //     lDebtAmountMin: 100*10**18,                         // 100 DAI min credit
        //     debtInterestMin: INTEREST_MULTIPLIER*10/100,        // 10% min interest
        //     pledgePercentMin: PLEDGE_PERCENT_MULTIPLIER*10/100, // 10% min pledge 
        //     lMinPledgeMax: 500*10**18,                          // 500 DAI max minimal pledge
        //     debtLoadMax: DEBT_LOAD_MULTIPLIER*50/100,           // 50% max debt load
        //     maxOpenProposalsPerUser: 1,                         // 1 open proposal per user
        //     minCancelProposalTimeout: 7*24*60*60                // 7-day timeout before cancelling proposal
        // });
        limits[uint256(LoanLimitType.L_DEBT_AMOUNT_MIN)] = 100*10**18;                           // 100 DAI min credit
        limits[uint256(LoanLimitType.DEBT_INTEREST_MIN)] = INTEREST_MULTIPLIER*10/100;           // 10% min interest
        limits[uint256(LoanLimitType.PLEDGE_PERCENT_MIN)] = PLEDGE_PERCENT_MULTIPLIER*10/100;     // 10% min pledge 
        limits[uint256(LoanLimitType.L_MIN_PLEDGE_MAX)] = 500*10**18;                           // 500 DAI max minimal pledge
        limits[uint256(LoanLimitType.DEBT_LOAD_MAX)] = DEBT_LOAD_MULTIPLIER*50/100;          // 50% max debt load
        limits[uint256(LoanLimitType.MAX_OPEN_PROPOSALS_PER_USER)] = 1;                           // 1 open proposal per user
        limits[uint256(LoanLimitType.MIN_CANCEL_PROPOSAL_TIMEOUT)] = 7*24*60*60;                   // 7-day timeout before cancelling proposal
    }

    function set(LoanLimitType limit, uint256 value) public onlyOwner {
        limits[uint256(limit)] = value;
    }

    function get(LoanLimitType limit) public view returns(uint256) {
        return limits[uint256(limit)];
    }

    function lDebtAmountMin() public view returns(uint256){
        return limits[uint256(LoanLimitType.L_DEBT_AMOUNT_MIN)];
    }     

    function debtInterestMin() public view returns(uint256){
        return limits[uint256(LoanLimitType.DEBT_INTEREST_MIN)];
    }

    function pledgePercentMin() public view returns(uint256){
        return limits[uint256(LoanLimitType.PLEDGE_PERCENT_MIN)];
    }

    function lMinPledgeMax() public view returns(uint256){
        return limits[uint256(LoanLimitType.L_MIN_PLEDGE_MAX)];
    }

    function debtLoadMax() public view returns(uint256){
        return limits[uint256(LoanLimitType.DEBT_LOAD_MAX)];
    }

    function maxOpenProposalsPerUser() public view returns(uint256){
        return limits[uint256(LoanLimitType.MAX_OPEN_PROPOSALS_PER_USER)];
    }

    function minCancelProposalTimeout() public view returns(uint256){
        return limits[uint256(LoanLimitType.MIN_CANCEL_PROPOSAL_TIMEOUT)];
    }

}