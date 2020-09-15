/**
 *Submitted for verification at Etherscan.io on 2020-05-01
*/

pragma solidity ^0.4.24;


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * See https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}


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
}contract PermittedConvertsInterface {
  mapping (address => bool) public permittedAddresses;
}
contract PermittedStablesInterface {
  mapping (address => bool) public permittedAddresses;
}
contract PermittedPoolsInterface {
  mapping (address => bool) public permittedAddresses;
}
contract PermittedExchangesInterface {
  mapping (address => bool) public permittedAddresses;
}
contract SmartFundUSDFactoryInterface {
  function createSmartFund(
    address _owner,
    string  _name,
    uint256 _successFee,
    uint256 _platformFee,
    address _platfromAddress,
    address _exchangePortalAddress,
    address _permittedExchanges,
    address _permittedPools,
    address _permittedStabels,
    address _poolPortalAddress,
    address _stableCoinAddress,
    address _cEther,
    address _permittedConvertsAddress
    )
  public
  returns(address);
}
contract SmartFundETHFactoryInterface {
  function createSmartFund(
    address _owner,
    string  _name,
    uint256 _successFee,
    uint256 _platformFee,
    address _platfromAddress,
    address _exchangePortalAddress,
    address _permittedExchanges,
    address _permittedPools,
    address _poolPortalAddress,
    address _cEther,
    address _permittedConvertsAddress
    )
  public
  returns(address);
}














/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender)
    public view returns (uint256);

  function transferFrom(address from, address to, uint256 value)
    public returns (bool);

  function approve(address spender, uint256 value) public returns (bool);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

/*
* The SmartFundRegistry is used to manage the creation and permissions of SmartFund contracts
*/
contract SmartFundRegistry is Ownable {
  address[] public smartFunds;

  // The Smart Contract which stores the addresses of all the authorized Exchange Portals
  PermittedExchangesInterface public permittedExchanges;
  // The Smart Contract which stores the addresses of all the authorized Pool Portals
  PermittedPoolsInterface public permittedPools;
  // The Smart Contract which stores the addresses of all the authorized stable coins
  PermittedStablesInterface public permittedStables;
  // The Smart Contract which stores the addresses of all the authorized Converts portal
  PermittedConvertsInterface public permittedConverts;

  // Addresses of portals
  address public poolPortalAddress;
  address public exchangePortalAddress;
  address public convertPortalAddress;

  // platForm fee is out of 10,000, e.g 2500 is 25%
  uint256 public platformFee;

  // Default maximum success fee is 3000/30%
  uint256 public maximumSuccessFee = 3000;

  // Address of stable coin can be set in constructor and changed via function
  address public stableCoinAddress;

  // Addresses for Compound platform
  address public cEther;

  // Factories
  SmartFundETHFactoryInterface public smartFundETHFactory;
  SmartFundUSDFactoryInterface public smartFundUSDFactory;

  event SmartFundAdded(address indexed smartFundAddress, address indexed owner);

  /**
  * @dev contructor
  *
  * @param _convertPortalAddress         address of convert portal contract
  * @param _platformFee                  Initial platform fee
  * @param _permittedExchangesAddress    Address of the permittedExchanges contract
  * @param _exchangePortalAddress        Address of the initial ExchangePortal contract
  * @param _permittedPoolAddress         Address of the permittedPool contract
  * @param _poolPortalAddress            Address of the initial PoolPortal contract
  * @param _permittedStables             Address of the permittesStabels contract
  * @param _stableCoinAddress            Address of the stable coin
  * @param _smartFundETHFactory          Address of smartFund ETH factory
  * @param _smartFundUSDFactory          Address of smartFund USD factory
  * @param _cEther                       Address of Compound ETH wrapper
  * @param _permittedConvertsAddress     Address of the permittedConverts contract
  */
  constructor(
    address _convertPortalAddress,
    uint256 _platformFee,
    address _permittedExchangesAddress,
    address _exchangePortalAddress,
    address _permittedPoolAddress,
    address _poolPortalAddress,
    address _permittedStables,
    address _stableCoinAddress,
    address _smartFundETHFactory,
    address _smartFundUSDFactory,
    address _cEther,
    address _permittedConvertsAddress
  ) public {
    convertPortalAddress = _convertPortalAddress;
    platformFee = _platformFee;
    exchangePortalAddress = _exchangePortalAddress;
    permittedExchanges = PermittedExchangesInterface(_permittedExchangesAddress);
    permittedPools = PermittedPoolsInterface(_permittedPoolAddress);
    permittedStables = PermittedStablesInterface(_permittedStables);
    poolPortalAddress = _poolPortalAddress;
    stableCoinAddress = _stableCoinAddress;
    smartFundETHFactory = SmartFundETHFactoryInterface(_smartFundETHFactory);
    smartFundUSDFactory = SmartFundUSDFactoryInterface(_smartFundUSDFactory);
    cEther = _cEther;
    permittedConverts = PermittedConvertsInterface(_permittedConvertsAddress);
  }

  /**
  * @dev Creates a new SmartFund
  *
  * @param _name               The name of the new fund
  * @param _successFee         The fund managers success fee
  * @param _isStableBasedFund  true for USD base fund, false for ETH base
  */
  function createSmartFund(
    string _name,
    uint256 _successFee,
    bool _isStableBasedFund
  ) public {
    // Require that the funds success fee be less than the maximum allowed amount
    require(_successFee <= maximumSuccessFee);

    address owner = msg.sender;
    address smartFund;

    if(_isStableBasedFund){
      // Create USD Fund
      smartFund = smartFundUSDFactory.createSmartFund(
        owner,
        _name,
        _successFee,
        platformFee,
        exchangePortalAddress,
        address(permittedExchanges),
        address(permittedPools),
        address(permittedStables),
        poolPortalAddress,
        stableCoinAddress,
        convertPortalAddress,
        cEther,
        convertPortalAddress
      );
    }else{
      // Create ETH Fund
      smartFund = smartFundETHFactory.createSmartFund(
        owner,
        _name,
        _successFee,
        platformFee,
        exchangePortalAddress,
        address(permittedExchanges),
        address(permittedPools),
        poolPortalAddress,
        convertPortalAddress,
        cEther,
        convertPortalAddress
      );
    }

    smartFunds.push(smartFund);
    emit SmartFundAdded(smartFund, owner);
  }

  function totalSmartFunds() public view returns (uint256) {
    return smartFunds.length;
  }

  function getAllSmartFundAddresses() public view returns(address[]) {
    address[] memory addresses = new address[](smartFunds.length);

    for (uint i; i < smartFunds.length; i++) {
      addresses[i] = address(smartFunds[i]);
    }

    return addresses;
  }

  /**
  * @dev Sets a new default ExchangePortal address
  *
  * @param _newExchangePortalAddress    Address of the new exchange portal to be set
  */
  function setExchangePortalAddress(address _newExchangePortalAddress) public onlyOwner {
    // Require that the new exchange portal is permitted by permittedExchanges
    require(permittedExchanges.permittedAddresses(_newExchangePortalAddress));

    exchangePortalAddress = _newExchangePortalAddress;
  }

  /**
  * @dev Sets a new default Portal Portal address
  *
  * @param _poolPortalAddress    Address of the new pool portal to be set
  */
  function setPoolPortalAddress (address _poolPortalAddress) external onlyOwner {
    // Require that the new pool portal is permitted by permittedPools
    require(permittedPools.permittedAddresses(_poolPortalAddress));

    poolPortalAddress = _poolPortalAddress;
  }


  /**
  * @dev Sets a new default Convert Portal address
  *
  * @param _convertPortalAddress    Address of the new convert portal to be set
  */
  function setConvertPortalAddress(address _convertPortalAddress) external onlyOwner {
    // Require that the new convert portal is permitted by permittedConverts
    require(permittedConverts.permittedAddresses(_convertPortalAddress));

    convertPortalAddress = _convertPortalAddress;
  }

  /**
  * @dev Sets maximum success fee for all newly created SmartFunds
  *
  * @param _maximumSuccessFee    New maximum success fee
  */
  function setMaximumSuccessFee(uint256 _maximumSuccessFee) external onlyOwner {
    maximumSuccessFee = _maximumSuccessFee;
  }

  /**
  * @dev Sets platform fee for all newly created SmartFunds
  *
  * @param _platformFee    New platform fee
  */
  function setPlatformFee(uint256 _platformFee) external onlyOwner {
    platformFee = _platformFee;
  }


  /**
  * @dev Sets new stableCoinAddress
  *
  * @param _stableCoinAddress    New stable address
  */
  function setStableCoinAddress(address _stableCoinAddress) external onlyOwner {
    require(permittedStables.permittedAddresses(_stableCoinAddress));
    stableCoinAddress = _stableCoinAddress;
  }

  /**
  * @dev Allows platform to withdraw tokens received as part of the platform fee
  *
  * @param _tokenAddress    Address of the token to be withdrawn
  */
  function withdrawTokens(address _tokenAddress) external onlyOwner {
    ERC20 token = ERC20(_tokenAddress);

    token.transfer(owner, token.balanceOf(this));
  }

  /**
  * @dev Allows platform to withdraw ether received as part of the platform fee
  */
  function withdrawEther() external onlyOwner {
    owner.transfer(address(this).balance);
  }

  // Fallback payable function in order to receive ether when fund manager withdraws their cut
  function() public payable {}

}