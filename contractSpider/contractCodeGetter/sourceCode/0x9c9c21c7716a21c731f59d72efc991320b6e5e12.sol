/**
 *Submitted for verification at Etherscan.io on 2020-07-28
*/

pragma solidity 0.4.25;

// File: contracts/saga/interfaces/ITransactionLimiter.sol

/**
 * @title Transaction Limiter Interface.
 */
interface ITransactionLimiter {
    /**
     * @dev Reset the total buy-amount and the total sell-amount.
     */
    function resetTotal() external;

    /**
     * @dev Increment the total buy-amount.
     * @param _amount The amount to increment by.
     */
    function incTotalBuy(uint256 _amount) external;

    /**
     * @dev Increment the total sell-amount.
     * @param _amount The amount to increment by.
     */
    function incTotalSell(uint256 _amount) external;
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

// File: contracts/saga/TransactionLimiter.sol

/**
 * Details of usage of licenced software see here: https://www.saga.org/software/readme_v1
 */

/**
 * @title Transaction Limiter.
 */
contract TransactionLimiter is ITransactionLimiter, ContractAddressLocatorHolder, Claimable {
    string public constant VERSION = "2.0.0";

    using SafeMath for uint256;

    /**
     * @dev Total buy-amount.
     */
    uint256 public totalBuy;

    /**
     * @dev Total sell-amount.
     */
    uint256 public totalSell;

    /**
     * @dev Maximum buy difference permitted.
     */
    uint256 public maxBuyDiff = uint256(~0);

    /**
     * @dev Maximum sell difference permitted.
     */
    uint256 public maxSellDiff = uint256(~0);

    uint256 public sequenceNum = 0;

    event MaxDiffSaved(uint256 _maxBuyDiff, uint256 _maxSellDiff);
    event MaxDiffNotSaved(uint256 _maxBuyDiff, uint256 _maxSellDiff);

    /**
     * @dev Create the contract.
     * @param _contractAddressLocator The contract address locator.
     */
    constructor(IContractAddressLocator _contractAddressLocator) ContractAddressLocatorHolder(_contractAddressLocator) public {}

    /**
     * @dev Set the maximum difference permitted.
     * @param _sequenceNum The sequence-number of the operation.
     * @param _maxBuyDiff The maximum buy difference permitted.
     * @param _maxSellDiff The maximum sell difference permitted.
     */
    function setMaxDiff(uint256 _sequenceNum, uint256 _maxBuyDiff, uint256 _maxSellDiff) external onlyOwner {
        if (sequenceNum < _sequenceNum) {
            sequenceNum = _sequenceNum;
            maxBuyDiff = _maxBuyDiff;
            maxSellDiff = _maxSellDiff;

            emit MaxDiffSaved(_maxBuyDiff, _maxSellDiff);
        }
        else {
            emit MaxDiffNotSaved(_maxBuyDiff, _maxSellDiff);
        }
    }

    /**
     * @dev Reset the total buy-amount and the total sell-amount.
     */
    function resetTotal() external only(_IETHConverter_) {
        totalBuy = 0;
        totalSell = 0;
    }

    /**
     * @dev Increment the total buy-amount.
     * @param _amount The amount to increment by.
     */
    function incTotalBuy(uint256 _amount) external only(_ITransactionManager_) {
        totalBuy = totalBuy.add(_amount);
        if (totalBuy > totalSell)
            require(totalBuy - totalSell <= maxBuyDiff, "buy-limit has been reached");
    }

    /**
     * @dev Increment the total sell-amount.
     * @param _amount The amount to increment by.
     */
    function incTotalSell(uint256 _amount) external only(_ITransactionManager_) {
        totalSell = totalSell.add(_amount);
        if (totalSell > totalBuy)
            require(totalSell - totalBuy <= maxSellDiff, "sell-limit has been reached");
    }
}