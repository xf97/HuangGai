/**
 *Submitted for verification at Etherscan.io on 2020-04-29
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
contract ITokensTypeStorage {
  mapping(address => bool) public isRegistred;

  mapping(address => bytes32) public getType;

  mapping(address => bool) public isPermittedAddress;

  address public owner;

  function addNewTokenType(address _token, string _type) public;

  function setTokenTypeAsOwner(address _token, string _type) public;
}


contract UniswapFactoryInterface {
    // Public Variables
    address public exchangeTemplate;
    uint256 public tokenCount;
    // Create Exchange
    function createExchange(address token) external returns (address exchange);
    // Get Exchange and Token Info
    function getExchange(address token) external view returns (address exchange);
    function getToken(address exchange) external view returns (address token);
    function getTokenWithId(uint256 tokenId) external view returns (address token);
    // Never use
    function initializeFactory(address template) external;
}


contract UniswapExchangeInterface {
    // Address of ERC20 token sold on this exchange
    function tokenAddress() external view returns (address token);
    // Address of Uniswap Factory
    function factoryAddress() external view returns (address factory);
    // Provide Liquidity
    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
    // Get Prices
    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
    function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
    function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
    // Trade ETH to ERC20
    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
    function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
    function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
    // Trade ERC20 to ETH
    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
    function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
    function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
    // Trade ERC20 to ERC20
    function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
    function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
    // Trade ERC20 to Custom Pool
    function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
    function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
    // ERC20 comaptibility for liquidity tokens
    bytes32 public name;
    bytes32 public symbol;
    uint256 public decimals;
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);
    function allowance(address _owner, address _spender) external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    // Never use
    function setup(address token_addr) external;
}


contract IBancorFormula {
    function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _depositAmount) public view returns (uint256);
    function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _sellAmount) public view returns (uint256);
    function calculateCrossReserveReturn(uint256 _fromReserveBalance, uint32 _fromReserveRatio, uint256 _toReserveBalance, uint32 _toReserveRatio, uint256 _amount) public view returns (uint256);
    function calculateFundCost(uint256 _supply, uint256 _reserveBalance, uint32 _totalRatio, uint256 _amount) public view returns (uint256);
    function calculateLiquidateReturn(uint256 _supply, uint256 _reserveBalance, uint32 _totalRatio, uint256 _amount) public view returns (uint256);
}


contract IGetBancorAddressFromRegistry{
  function getBancorContractAddresByName(string _name) public view returns (address result);
}


contract IGetRatioForBancorAssets {
  function getRatio(address _from, address _to, uint256 _amount) public view returns(uint256 result);
}



contract BancorConverterInterface {
  ERC20[] public connectorTokens;
  function fund(uint256 _amount) public;
  function liquidate(uint256 _amount) public;
  function getConnectorBalance(ERC20 _connectorToken) public view returns (uint256);
}


/*
* This contract allow buy/sell pool for Bancor and Uniswap assets
* and provide ratio and addition info for pool assets
*/





/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}







contract SmartTokenInterface is ERC20 {
  function disableTransfers(bool _disable) public;
  function issue(address _to, uint256 _amount) public;
  function destroy(address _from, uint256 _amount) public;
  function owner() public view returns (address);
}









contract PoolPortal {
  using SafeMath for uint256;

  IGetRatioForBancorAssets public bancorRatio;
  IGetBancorAddressFromRegistry public bancorRegistry;
  UniswapFactoryInterface public uniswapFactory;

  address public BancorEtherToken;

  // CoTrader platform recognize ETH by this address
  ERC20 constant private ETH_TOKEN_ADDRESS = ERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

  // Enum
  // NOTE: You can add a new type at the end, but do not change this order
  enum PortalType { Bancor, Uniswap }

  // events
  event BuyPool(address poolToken, uint256 amount, address trader);
  event SellPool(address poolToken, uint256 amount, address trader);

  // Contract for handle tokens types
  ITokensTypeStorage public tokensTypes;

  /**
  * @dev contructor
  *
  * @param _bancorRegistryWrapper  address of GetBancorAddressFromRegistry
  * @param _bancorRatio            address of GetRatioForBancorAssets
  * @param _bancorEtherToken       address of Bancor ETH wrapper
  * @param _uniswapFactory         address of Uniswap factory contract
  * @param _tokensTypes            address of the ITokensTypeStorage
  */
  constructor(
    address _bancorRegistryWrapper,
    address _bancorRatio,
    address _bancorEtherToken,
    address _uniswapFactory,
    address _tokensTypes

  )
  public
  {
    bancorRegistry = IGetBancorAddressFromRegistry(_bancorRegistryWrapper);
    bancorRatio = IGetRatioForBancorAssets(_bancorRatio);
    BancorEtherToken = _bancorEtherToken;
    uniswapFactory = UniswapFactoryInterface(_uniswapFactory);
    tokensTypes = ITokensTypeStorage(_tokensTypes);
  }


  /**
  * @dev buy Bancor or Uniswap pool
  *
  * @param _amount     amount of pool token
  * @param _type       pool type
  * @param _poolToken  pool token address
  */
  function buyPool
  (
    uint256 _amount,
    uint _type,
    ERC20 _poolToken
  )
  external
  payable
  {
    if(_type == uint(PortalType.Bancor)){
      buyBancorPool(_poolToken, _amount);
    }
    else if (_type == uint(PortalType.Uniswap)){
      require(_amount == msg.value, "Not enough ETH");
      buyUniswapPool(_poolToken, _amount);
    }
    else{
      // unknown portal type
      revert();
    }

    emit BuyPool(address(_poolToken), _amount, msg.sender);
  }


  /**
  * @dev helper for buy pool in Bancor network
  *
  * @param _poolToken        address of bancor converter
  * @param _amount           amount of bancor relay
  */
  function buyBancorPool(ERC20 _poolToken, uint256 _amount) private {
    // get Bancor converter
    address converterAddress = getBacorConverterAddressByRelay(address(_poolToken));
    // calculate connectors amount for buy certain pool amount
    (uint256 bancorAmount,
     uint256 connectorAmount) = getBancorConnectorsAmountByRelayAmount(_amount, _poolToken);
    // get converter as contract
    BancorConverterInterface converter = BancorConverterInterface(converterAddress);
    // approve bancor and coonector amount to converter
    // get connectors
    (ERC20 bancorConnector,
    ERC20 ercConnector) = getBancorConnectorsByRelay(address(_poolToken));
    // reset approve (some ERC20 not allow do new approve if already approved)
    bancorConnector.approve(converterAddress, 0);
    ercConnector.approve(converterAddress, 0);
    // transfer from fund and approve to converter
    _transferFromSenderAndApproveTo(bancorConnector, bancorAmount, converterAddress);
    _transferFromSenderAndApproveTo(ercConnector, connectorAmount, converterAddress);
    // buy relay from converter
    converter.fund(_amount);

    require(_amount > 0, "BNT pool recieved amount can not be zerro");

    // transfer relay back to smart fund
    _poolToken.transfer(msg.sender, _amount);

    // transfer connectors back if a small amount remains
    uint256 bancorRemains = bancorConnector.balanceOf(address(this));
    if(bancorRemains > 0)
       bancorConnector.transfer(msg.sender, bancorRemains);

    uint256 ercRemains = ercConnector.balanceOf(address(this));
    if(ercRemains > 0)
        ercConnector.transfer(msg.sender, ercRemains);

    setTokenType(_poolToken, "BANCOR POOL");
  }


  /**
  * @dev helper for buy pool in Uniswap network
  *
  * @param _poolToken        address of Uniswap exchange
  * @param _ethAmount        ETH amount (in wei)
  */
  function buyUniswapPool(address _poolToken, uint256 _ethAmount)
  private
  returns(uint256 poolAmount)
  {
    // get token address
    address tokenAddress = uniswapFactory.getToken(_poolToken);
    // check if such a pool exist
    if(tokenAddress != address(0x0000000000000000000000000000000000000000)){
      // get tokens amd approve to exchange
      uint256 erc20Amount = getUniswapTokenAmountByETH(tokenAddress, _ethAmount);
      _transferFromSenderAndApproveTo(ERC20(tokenAddress), erc20Amount, _poolToken);
      // get exchange contract
      UniswapExchangeInterface exchange = UniswapExchangeInterface(_poolToken);
      // set deadline
      uint256 deadline = now + 15 minutes;
      // buy pool
      poolAmount = exchange.addLiquidity.value(_ethAmount)(
        1,
        erc20Amount,
        deadline);
      // reset approve (some ERC20 not allow do new approve if already approved)
      ERC20(tokenAddress).approve(_poolToken, 0);

      require(poolAmount > 0, "UNI pool recieved amount can not be zerro");

      // transfer pool token back to smart fund
      ERC20(_poolToken).transfer(msg.sender, poolAmount);
      // transfer ERC20 remains
      uint256 remainsERC = ERC20(tokenAddress).balanceOf(address(this));
      if(remainsERC > 0)
          ERC20(tokenAddress).transfer(msg.sender, remainsERC);

      setTokenType(_poolToken, "UNISWAP POOL");
    }else{
      // throw if such pool not Exist in Uniswap network
      revert();
    }
  }

  /**
  * @dev return token amount by ETH input ratio
  *
  * @param _token     address of ERC20 token
  * @param _amount    ETH amount (in wei)
  */
  function getUniswapTokenAmountByETH(address _token, uint256 _amount)
  public
  view
  returns(uint256)
  {
    UniswapExchangeInterface exchange = UniswapExchangeInterface(
      uniswapFactory.getExchange(_token));
    return exchange.getTokenToEthOutputPrice(_amount);
  }


  /**
  * @dev sell Bancor or Uniswap pool
  *
  * @param _amount     amount of pool token
  * @param _type       pool type
  * @param _poolToken  pool token address
  */
  function sellPool
  (
    uint256 _amount,
    uint _type,
    ERC20 _poolToken
  )
  external
  payable
  {
    if(_type == uint(PortalType.Bancor)){
      sellPoolViaBancor(_poolToken, _amount);
    }
    else if (_type == uint(PortalType.Uniswap)){
      sellPoolViaUniswap(_poolToken, _amount);
    }
    else{
      // unknown portal type
      revert();
    }

    emit SellPool(address(_poolToken), _amount, msg.sender);
  }

  /**
  * @dev helper for sell pool in Bancor network
  *
  * @param _poolToken        address of bancor relay
  * @param _amount           amount of bancor relay
  */
  function sellPoolViaBancor(ERC20 _poolToken, uint256 _amount) private {
    // transfer pool from fund
    _poolToken.transferFrom(msg.sender, address(this), _amount);
    // get Bancor Converter address
    address converterAddress = getBacorConverterAddressByRelay(address(_poolToken));
    // liquidate relay
    BancorConverterInterface(converterAddress).liquidate(_amount);
    // get connectors
    (ERC20 bancorConnector,
    ERC20 ercConnector) = getBancorConnectorsByRelay(address(_poolToken));
    // transfer connectors back to fund
    bancorConnector.transfer(msg.sender, bancorConnector.balanceOf(this));
    ercConnector.transfer(msg.sender, ercConnector.balanceOf(this));
  }


  /**
  * @dev helper for sell pool in Uniswap network
  *
  * @param _poolToken        address of uniswap exchane
  * @param _amount           amount of uniswap pool
  */
  function sellPoolViaUniswap(ERC20 _poolToken, uint256 _amount) private {
    address tokenAddress = uniswapFactory.getToken(_poolToken);
    // check if such a pool exist
    if(tokenAddress != address(0x0000000000000000000000000000000000000000)){
      UniswapExchangeInterface exchange = UniswapExchangeInterface(_poolToken);
      // approve pool token
      _transferFromSenderAndApproveTo(ERC20(_poolToken), _amount, _poolToken);
      // get min returns
      (uint256 minEthAmount,
        uint256 minErcAmount) = getUniswapConnectorsAmountByPoolAmount(
          _amount,
          address(_poolToken));
      // set deadline
      uint256 deadline = now + 15 minutes;
      // liquidate
      (uint256 eth_amount,
       uint256 token_amount) = exchange.removeLiquidity(
         _amount,
         minEthAmount,
         minErcAmount,
         deadline);
      // transfer assets back to smart fund
      msg.sender.transfer(eth_amount);
      ERC20(tokenAddress).transfer(msg.sender, token_amount);
    }else{
      revert();
    }
  }

  /**
  * @dev helper for get bancor converter by bancor relay addrses
  *
  * @param _relay       address of bancor relay
  */
  function getBacorConverterAddressByRelay(address _relay)
  public
  view
  returns(address converter)
  {
    converter = SmartTokenInterface(_relay).owner();
  }

  /**
  * @dev helper for get Bancor ERC20 connectors addresses
  *
  * @param _relay       address of bancor relay
  */
  function getBancorConnectorsByRelay(address _relay)
  public
  view
  returns(
    ERC20 BNTConnector,
    ERC20 ERCConnector
  )
  {
    address converterAddress = getBacorConverterAddressByRelay(_relay);
    BancorConverterInterface converter = BancorConverterInterface(converterAddress);
    BNTConnector = converter.connectorTokens(0);
    ERCConnector = converter.connectorTokens(1);
  }


  /**
  * @dev return ERC20 address from Uniswap exchange address
  *
  * @param _exchange       address of uniswap exchane
  */
  function getTokenByUniswapExchange(address _exchange)
  public
  view
  returns(address)
  {
    return uniswapFactory.getToken(_exchange);
  }


  /**
  * @dev helper for get amounts for both Uniswap connectors for input amount of pool
  *
  * @param _amount         relay amount
  * @param _exchange       address of uniswap exchane
  */
  function getUniswapConnectorsAmountByPoolAmount(
    uint256 _amount,
    address _exchange
  )
  public
  view
  returns(uint256 ethAmount, uint256 ercAmount)
  {
    ERC20 token = ERC20(uniswapFactory.getToken(_exchange));
    // total_liquidity exchange.totalSupply
    uint256 totalLiquidity = UniswapExchangeInterface(_exchange).totalSupply();
    // ethAmount = amount * exchane.eth.balance / total_liquidity
    ethAmount = _amount.mul(_exchange.balance).div(totalLiquidity);
    // ercAmount = amount * token.balanceOf(exchane) / total_liquidity
    ercAmount = _amount.mul(token.balanceOf(_exchange)).div(totalLiquidity);
  }


  /**
  * @dev helper for get amount for both Bancor connectors for input amount of pool
  *
  * @param _amount      relay amount
  * @param _relay       address of bancor relay
  */
  function getBancorConnectorsAmountByRelayAmount
  (
    uint256 _amount,
    ERC20 _relay
  )
  public view returns(uint256 bancorAmount, uint256 connectorAmount) {
    // get converter contract
    BancorConverterInterface converter = BancorConverterInterface(
      SmartTokenInterface(_relay).owner());
    // calculate BNT and second connector amount
    // get connectors
    ERC20 bancorConnector = converter.connectorTokens(0);
    ERC20 ercConnector = converter.connectorTokens(1);
    // get connectors balance
    uint256 bntBalance = converter.getConnectorBalance(bancorConnector);
    uint256 ercBalance = converter.getConnectorBalance(ercConnector);
    // get bancor formula contract
    IBancorFormula bancorFormula = IBancorFormula(
      bancorRegistry.getBancorContractAddresByName("BancorFormula"));
    // calculate input
    bancorAmount = bancorFormula.calculateFundCost(
      _relay.totalSupply(),
      bntBalance,
      1000000,
       _amount);
    connectorAmount = bancorFormula.calculateFundCost(
      _relay.totalSupply(),
      ercBalance,
      1000000,
       _amount);
  }

  /**
  * @dev helper for get ratio between assets in bancor newtork
  *
  * @param _from      token or relay address
  * @param _to        token or relay address
  * @param _amount    amount from
  */
  function getBancorRatio(address _from, address _to, uint256 _amount)
  public
  view
  returns(uint256)
  {
    // Change ETH to Bancor ETH wrapper
    address fromAddress = ERC20(_from) == ETH_TOKEN_ADDRESS ? BancorEtherToken : _from;
    address toAddress = ERC20(_to) == ETH_TOKEN_ADDRESS ? BancorEtherToken : _to;
    // return Bancor ratio
    return bancorRatio.getRatio(fromAddress, toAddress, _amount);
  }


  /**
  * @dev Transfers tokens to this contract and approves them to another address
  *
  * @param _source          Token to transfer and approve
  * @param _sourceAmount    The amount to transfer and approve (in _source token)
  * @param _to              Address to approve to
  */
  function _transferFromSenderAndApproveTo(ERC20 _source, uint256 _sourceAmount, address _to) private {
    require(_source.transferFrom(msg.sender, address(this), _sourceAmount));

    _source.approve(_to, _sourceAmount);
  }

  // Pool portal can mark each pool token as UNISWAP or BANCOR
  function setTokenType(address _token, string _type) private {
    // no need add type, if token alredy registred
    if(tokensTypes.isRegistred(_token))
      return;

    tokensTypes.addNewTokenType(_token,  _type);
  }

  // fallback payable function to receive ether from other contract addresses
  function() public payable {}
}