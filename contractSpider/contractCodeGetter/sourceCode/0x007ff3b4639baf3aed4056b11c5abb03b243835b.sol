/**
 *Submitted for verification at Etherscan.io on 2020-06-28
*/

pragma solidity 0.4.25;

// File: contracts/saga/interfaces/IRateApprover.sol

/**
 * @title Rate Approver Interface.
 */
interface IRateApprover {
    /**
     * @dev Approve high rate.
     * @param _highRateN The numerator of the high rate.
     * @param _highRateD The denominator of the high rate.
     * @return Success flag.
     */
    function approveHighRate(uint256 _highRateN, uint256 _highRateD) external view  returns (bool);

    /**
    * @dev Approve low rate.
    * @param _lowRateN The numerator of the low rate.
    * @param _lowRateD The denominator of the low rate.
    * @return Success flag.
    */
    function approveLowRate(uint256 _lowRateN, uint256 _lowRateD) external view  returns (bool);
}

// File: contracts/contract_address_locator/interfaces/IContractAddressLocator.sol

/**
 * @title Contract Address Locator Interface.
 */
interface IContractAddressLocator {
    /**
     * @dev Get the contract address mapped to a given identifier.
     * @param _identifier The identifier.
     * @return The contract address.
     */
    function getContractAddress(bytes32 _identifier) external view returns (address);

    /**
     * @dev Determine whether or not a contract address relates to one of the identifiers.
     * @param _contractAddress The contract address to look for.
     * @param _identifiers The identifiers.
     * @return A boolean indicating if the contract address relates to one of the identifiers.
     */
    function isContractAddressRelates(address _contractAddress, bytes32[] _identifiers) external view returns (bool);
}

// File: contracts/contract_address_locator/ContractAddressLocatorHolder.sol

/**
 * @title Contract Address Locator Holder.
 * @dev Hold a contract address locator, which maps a unique identifier to every contract address in the system.
 * @dev Any contract which inherits from this contract can retrieve the address of any contract in the system.
 * @dev Thus, any contract can remain "oblivious" to the replacement of any other contract in the system.
 * @dev In addition to that, any function in any contract can be restricted to a specific caller.
 */
contract ContractAddressLocatorHolder {
    bytes32 internal constant _IAuthorizationDataSource_ = "IAuthorizationDataSource";
    bytes32 internal constant _ISGNConversionManager_    = "ISGNConversionManager"      ;
    bytes32 internal constant _IModelDataSource_         = "IModelDataSource"        ;
    bytes32 internal constant _IPaymentHandler_          = "IPaymentHandler"            ;
    bytes32 internal constant _IPaymentManager_          = "IPaymentManager"            ;
    bytes32 internal constant _IPaymentQueue_            = "IPaymentQueue"              ;
    bytes32 internal constant _IReconciliationAdjuster_  = "IReconciliationAdjuster"      ;
    bytes32 internal constant _IIntervalIterator_        = "IIntervalIterator"       ;
    bytes32 internal constant _IMintHandler_             = "IMintHandler"            ;
    bytes32 internal constant _IMintListener_            = "IMintListener"           ;
    bytes32 internal constant _IMintManager_             = "IMintManager"            ;
    bytes32 internal constant _IPriceBandCalculator_     = "IPriceBandCalculator"       ;
    bytes32 internal constant _IModelCalculator_         = "IModelCalculator"        ;
    bytes32 internal constant _IRedButton_               = "IRedButton"              ;
    bytes32 internal constant _IReserveManager_          = "IReserveManager"         ;
    bytes32 internal constant _ISagaExchanger_           = "ISagaExchanger"          ;
    bytes32 internal constant _IMonetaryModel_               = "IMonetaryModel"              ;
    bytes32 internal constant _IMonetaryModelState_          = "IMonetaryModelState"         ;
    bytes32 internal constant _ISGAAuthorizationManager_ = "ISGAAuthorizationManager";
    bytes32 internal constant _ISGAToken_                = "ISGAToken"               ;
    bytes32 internal constant _ISGATokenManager_         = "ISGATokenManager"        ;
    bytes32 internal constant _ISGNAuthorizationManager_ = "ISGNAuthorizationManager";
    bytes32 internal constant _ISGNToken_                = "ISGNToken"               ;
    bytes32 internal constant _ISGNTokenManager_         = "ISGNTokenManager"        ;
    bytes32 internal constant _IMintingPointTimersManager_             = "IMintingPointTimersManager"            ;
    bytes32 internal constant _ITradingClasses_          = "ITradingClasses"         ;
    bytes32 internal constant _IWalletsTradingLimiterValueConverter_        = "IWalletsTLValueConverter"       ;
    bytes32 internal constant _BuyWalletsTradingDataSource_       = "BuyWalletsTradingDataSource"      ;
    bytes32 internal constant _SellWalletsTradingDataSource_       = "SellWalletsTradingDataSource"      ;
    bytes32 internal constant _WalletsTradingLimiter_SGNTokenManager_          = "WalletsTLSGNTokenManager"         ;
    bytes32 internal constant _BuyWalletsTradingLimiter_SGATokenManager_          = "BuyWalletsTLSGATokenManager"         ;
    bytes32 internal constant _SellWalletsTradingLimiter_SGATokenManager_          = "SellWalletsTLSGATokenManager"         ;
    bytes32 internal constant _IETHConverter_             = "IETHConverter"   ;
    bytes32 internal constant _ITransactionLimiter_      = "ITransactionLimiter"     ;
    bytes32 internal constant _ITransactionManager_      = "ITransactionManager"     ;
    bytes32 internal constant _IRateApprover_      = "IRateApprover"     ;

    IContractAddressLocator private contractAddressLocator;

    /**
     * @dev Create the contract.
     * @param _contractAddressLocator The contract address locator.
     */
    constructor(IContractAddressLocator _contractAddressLocator) internal {
        require(_contractAddressLocator != address(0), "locator is illegal");
        contractAddressLocator = _contractAddressLocator;
    }

    /**
     * @dev Get the contract address locator.
     * @return The contract address locator.
     */
    function getContractAddressLocator() external view returns (IContractAddressLocator) {
        return contractAddressLocator;
    }

    /**
     * @dev Get the contract address mapped to a given identifier.
     * @param _identifier The identifier.
     * @return The contract address.
     */
    function getContractAddress(bytes32 _identifier) internal view returns (address) {
        return contractAddressLocator.getContractAddress(_identifier);
    }



    /**
     * @dev Determine whether or not the sender relates to one of the identifiers.
     * @param _identifiers The identifiers.
     * @return A boolean indicating if the sender relates to one of the identifiers.
     */
    function isSenderAddressRelates(bytes32[] _identifiers) internal view returns (bool) {
        return contractAddressLocator.isContractAddressRelates(msg.sender, _identifiers);
    }

    /**
     * @dev Verify that the caller is mapped to a given identifier.
     * @param _identifier The identifier.
     */
    modifier only(bytes32 _identifier) {
        require(msg.sender == getContractAddress(_identifier), "caller is illegal");
        _;
    }

}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

// File: openzeppelin-solidity-v1.12.0/contracts/ownership/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

// File: openzeppelin-solidity-v1.12.0/contracts/ownership/Claimable.sol

/**
 * @title Claimable
 * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
 * This allows the new owner to accept the transfer.
 */
contract Claimable is Ownable {
  address public pendingOwner;

  /**
   * @dev Modifier throws if called by any account other than the pendingOwner.
   */
  modifier onlyPendingOwner() {
    require(msg.sender == pendingOwner);
    _;
  }

  /**
   * @dev Allows the current owner to set the pendingOwner address.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    pendingOwner = newOwner;
  }

  /**
   * @dev Allows the pendingOwner address to finalize the transfer.
   */
  function claimOwnership() public onlyPendingOwner {
    emit OwnershipTransferred(owner, pendingOwner);
    owner = pendingOwner;
    pendingOwner = address(0);
  }
}

// File: @chainlink/contracts/src/v0.4/interfaces/AggregatorInterface.sol

interface AggregatorInterface {
  function latestAnswer() external view returns (int256);
  function latestTimestamp() external view returns (uint256);
  function latestRound() external view returns (uint256);
  function getAnswer(uint256 roundId) external view returns (int256);
  function getTimestamp(uint256 roundId) external view returns (uint256);

  event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
  event NewRound(uint256 indexed roundId, address indexed startedBy);
}

// File: contracts/saga/OracleRateApprover.sol

/**
 * Details of usage of licenced software see here: https://www.saga.org/software/readme_v1
 */

/**
 * @title Oracle Rate Approver.
 */
contract OracleRateApprover is IRateApprover, ContractAddressLocatorHolder, Claimable {
    string public constant VERSION = "1.0.0";

    using SafeMath for uint256;

    uint256 public constant MILLION = 1000000;
    uint256 public constant ORACLE_RATE_PRECISION = 100000000;

    uint256 public rateDeviationThreshold = 0;
    bool public isApproveAllRates = false;
    AggregatorInterface public oracleRateAggregator;

    uint256 public oracleRateAggregatorSequenceNum = 0;
    uint256 public rateDeviationThresholdSequenceNum = 0;
    uint256 public isApproveAllRatesSequenceNum = 0;


    event OracleRateAggregatorSaved(address _oracleRateAggregatorAddress);
    event OracleRateAggregatorNotSaved(address _oracleRateAggregatorAddress);
    event RateDeviationThresholdSaved(uint256 _rateDeviationThreshold);
    event RateDeviationThresholdNotSaved(uint256 _rateDeviationThreshold);
    event ApproveAllRatesSaved(bool _isApproveAllRates);
    event ApproveAllRatesNotSaved(bool _isApproveAllRates);

    /**
     * @dev Create the contract.
     * @param _contractAddressLocator The contract address locator.
     * @param _oracleRateAggregatorAddress The address of the ETH SDR aggregator.
     * @param _rateDeviationThreshold The deviation threshold.
     */
    constructor(IContractAddressLocator _contractAddressLocator, address _oracleRateAggregatorAddress, uint256 _rateDeviationThreshold) ContractAddressLocatorHolder(_contractAddressLocator) public {
        setOracleRateAggregator(1, _oracleRateAggregatorAddress);
        setRateDeviationThreshold(1, _rateDeviationThreshold);
    }

    /**
     * @dev Set oracle rate aggregator.
     * @param _oracleRateAggregatorSequenceNum The sequence-number of the operation.
     * @param _oracleRateAggregatorAddress The address of the oracle rate aggregator.
     */
    function setOracleRateAggregator(uint256 _oracleRateAggregatorSequenceNum, address _oracleRateAggregatorAddress) public onlyOwner() {
        require(_oracleRateAggregatorAddress != address(0), "invalid _oracleRateAggregatorAddress");
        if (oracleRateAggregatorSequenceNum < _oracleRateAggregatorSequenceNum) {
            oracleRateAggregatorSequenceNum = _oracleRateAggregatorSequenceNum;
            oracleRateAggregator = AggregatorInterface(_oracleRateAggregatorAddress);
            emit OracleRateAggregatorSaved(_oracleRateAggregatorAddress);
        }
        else {
            emit OracleRateAggregatorNotSaved(_oracleRateAggregatorAddress);
        }
    }


    /**
     * @dev Set rate deviation threshold.
     * @param _rateDeviationThresholdSequenceNum The sequence-number of the operation.
     * @param _rateDeviationThreshold The deviation threshold, given in parts per million.
     */
    function setRateDeviationThreshold(uint256 _rateDeviationThresholdSequenceNum, uint256 _rateDeviationThreshold) public onlyOwner {
        require(_rateDeviationThreshold < MILLION, "_rateDeviationThreshold  is out of range");
        if (rateDeviationThresholdSequenceNum < _rateDeviationThresholdSequenceNum) {
            rateDeviationThresholdSequenceNum = _rateDeviationThresholdSequenceNum;
            rateDeviationThreshold = _rateDeviationThreshold;
            emit RateDeviationThresholdSaved(_rateDeviationThreshold);
        }
        else {
            emit RateDeviationThresholdNotSaved(_rateDeviationThreshold);
        }
    }


    /**
    * @dev Set is approve all rates.
    * @param _isApproveAllRatesSequenceNum The sequence-number of the operation.
    * @param _isApproveAllRates Approve all rates.
    */
    function setIsApproveAllRates(uint256 _isApproveAllRatesSequenceNum, bool _isApproveAllRates) public onlyOwner {
        if (isApproveAllRatesSequenceNum < _isApproveAllRatesSequenceNum) {
            isApproveAllRatesSequenceNum = _isApproveAllRatesSequenceNum;
            isApproveAllRates = _isApproveAllRates;
            emit ApproveAllRatesSaved(_isApproveAllRates);
        }
        else {
            emit ApproveAllRatesNotSaved(_isApproveAllRates);
        }
    }


    /**
     * @dev Approve high rate.
     * @param _highRateN The numerator of the high rate.
     * @param _highRateD The denominator of the high rate.
     * @return Success flag.
     */
    function approveHighRate(uint256 _highRateN, uint256 _highRateD) external view only(_IETHConverter_) returns (bool){
        return approveRate(_highRateN, _highRateD);
    }

    /**
     * @dev Approve low rate.
     * @param _lowRateN The numerator of the low rate.
     * @param _lowRateD The denominator of the low rate.
     * @return Success flag.
     */
    function approveLowRate(uint256 _lowRateN, uint256 _lowRateD) external view only(_IETHConverter_) returns (bool){
        return approveRate(_lowRateN, _lowRateD);
    }

    /**
     * @notice Checks if given rate is close to OracleLatestRate up to rateDeviationThreshold/MILLION, using the inequality:
     * OracleLatestRate/ORACLE_RATE_PRECISION*(1-rateDeviationThreshold/MILLION) < rate_N/rate_D < OracleLatestRate/ORACLE_RATE_PRECISION*(1 + rateDeviationThreshold/MILLION)
     * to avoid underflow this can be written as: B-C  > rate >  B+C, with:
     * rate = rate_N*ORACLE_RATE_PRECISION*MILLION
     * A = OracleLatestRate*rateD
     * B = A*MILLION
     * C = A*rateDeviationThreshold
     * will never overflow for the allowed range of values for each variable
     * @dev Approve rate.
     * @param _rateN The numerator of the rate.
     * @param _rateD The denominator of the rate.
     * @return Success flag.
     */
    function approveRate(uint256 _rateN, uint256 _rateD) internal view returns (bool) {
        assert(_rateN > 0);
        assert(_rateD > 0);
        bool success = true;

        if (!isApproveAllRates) {
            uint256 A = (getOracleLatestRate()).mul(_rateD);
            uint256 B = A.mul(MILLION);
            uint256 C = A.mul(rateDeviationThreshold);
            uint256 rate = (_rateN.mul(ORACLE_RATE_PRECISION)).mul(MILLION);

            if (rate > B.add(C)) {
                success = false;
            }
            else if (rate < B.sub(C)) {
                success = false;
            }
        }

        return success;
    }

    /**
    * @dev Get the oracle latest rate.
    * @return The oracle latest rate.
    */
    function getOracleLatestRate() internal view returns (uint256) {
        int256 latestAnswer = oracleRateAggregator.latestAnswer();
        assert(latestAnswer > 0);
        return uint256(latestAnswer);
    }
}