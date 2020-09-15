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


contract CToken {
    address public underlying;
    function transfer(address dst, uint256 amount) external returns (bool);
    function transferFrom(address src, address dst, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function mint(uint mintAmount) external returns (uint);
    function borrow(uint borrowAmount) external returns (uint);
    function repayBorrow(uint repayAmount) external returns (uint);
    function liquidateBorrow(address borrower, uint repayAmount, CToken cTokenCollateral) external returns (uint);
    function redeem(uint redeemTokens) external returns (uint);
    function redeemUnderlying(uint redeemAmount) external returns (uint);
    function exchangeRateCurrent() external view returns (uint);
    function totalSupply() external view returns(uint);
    function balanceOfUnderlying(address account) external view returns (uint);
    function balanceOf(address account) external view returns (uint);
}
contract ITokensTypeStorage {
  mapping(address => bool) public isRegistred;

  mapping(address => bytes32) public getType;

  mapping(address => bool) public isPermittedAddress;

  address public owner;

  function addNewTokenType(address _token, string _type) public;

  function setTokenTypeAsOwner(address _token, string _type) public;
}


contract PoolPortalInterface {
  function buyPool
  (
    uint256 _amount,
    uint _type,
    ERC20 _poolToken
  )
  external
  payable;

  function sellPool
  (
    uint256 _amount,
    uint _type,
    ERC20 _poolToken
  )
  external
  payable;

  function getBacorConverterAddressByRelay(address relay)
  public
  view
  returns(address converter);

  function getBancorConnectorsAmountByRelayAmount
  (
    uint256 _amount,
    ERC20 _relay
  )
  public view returns(uint256 bancorAmount, uint256 connectorAmount);

  function getBancorConnectorsByRelay(address relay)
  public
  view
  returns(
    ERC20 BNTConnector,
    ERC20 ERCConnector
  );

  function getBancorRatio(address _from, address _to, uint256 _amount)
  public
  view
  returns(uint256);

  function getUniswapConnectorsAmountByPoolAmount(
    uint256 _amount,
    address _exchange
  )
  public
  view
  returns(uint256 ethAmount, uint256 ercAmount);

  function getUniswapTokenAmountByETH(address _token, uint256 _amount)
  public
  view
  returns(uint256);

  function getTokenByUniswapExchange(address _exchange)
  public
  view
  returns(address);
}


contract ExchangePortalInterface {

  event Trade(address src, uint256 srcAmount, address dest, uint256 destReceived);

  function trade(
    ERC20 _source,
    uint256 _sourceAmount,
    ERC20 _destination,
    uint256 _type,
    bytes32[] _additionalArgs,
    bytes _additionalData
  )
    external
    payable
    returns (uint256);

  function compoundRedeemByPercent(uint _percent, address _cToken) external returns(uint256);

  function compoundMint(uint256 _amount, address _cToken) external payable returns(uint256);

  function getPercentFromCTokenBalance(uint _percent, address _cToken, address _holder)
   public
   view
   returns(uint256);

  function getValue(address _from, address _to, uint256 _amount) public view returns (uint256);

  function getTotalValue(address[] _fromAddresses, uint256[] _amounts, address _to)
   public
   view
   returns (uint256);

   function getCTokenUnderlying(address _cToken) public view returns(address);
}

/**
* This contract convert source ERC20 token to destanation token
* support sources 1INCH, COMPOUND, BANCOR/UNISWAP pools
*/










/**
 * @title DetailedERC20 token
 * @dev The decimals are only for visualization purposes.
 * All the operations are done using the smallest and indivisible token unit,
 * just as on Ethereum all the operations are done in wei.
 */
contract DetailedERC20 is ERC20 {
  string public name;
  string public symbol;
  uint8 public decimals;

  constructor(string _name, string _symbol, uint8 _decimals) public {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
  }
}

contract ConvertPortal {
  address constant private ETH_TOKEN_ADDRESS = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
  bytes32[] private BYTES32_EMPTY_ARRAY = new bytes32[](0);
  address public CEther;
  address public sUSD;
  ExchangePortalInterface public exchangePortal;
  PoolPortalInterface public poolPortal;
  ITokensTypeStorage  public tokensTypes;

  /**
  * @dev contructor
  *
  * @param _exchangePortal         address of exchange portal
  * @param _poolPortal             address of pool portal
  * @param _tokensTypes            address of the tokens type storage
  * @param _CEther                 address of Compound ETH wrapper
  */
  constructor(
    address _exchangePortal,
    address _poolPortal,
    address _tokensTypes,
    address _CEther
    )
    public
  {
    exchangePortal = ExchangePortalInterface(_exchangePortal);
    poolPortal = PoolPortalInterface(_poolPortal);
    tokensTypes = ITokensTypeStorage(_tokensTypes);
    CEther = _CEther;
  }

  // convert CRYPTOCURRENCY, COMPOUND, BANCOR/UNISWAP pools to _destination asset
  function convert(
    address _source,
    uint256 _sourceAmount,
    address _destination,
    address _receiver
  )
    external
    payable
  {
    // no need continue convert for not correct input data
    if(_sourceAmount <= 0 || _source == _destination)
      return;

    uint256 receivedAmount = 0;
    // convert assets
    if(tokensTypes.getType(_source) == bytes32("CRYPTOCURRENCY")){
      receivedAmount = convertCryptocurency(_source, _sourceAmount, _destination);
    }
    else if (tokensTypes.getType(_source) == bytes32("BANCOR POOL")){
      receivedAmount = convertBancorPool(_source, _sourceAmount, _destination);
    }
    else if (tokensTypes.getType(_source) == bytes32("UNISWAP POOL")){
      receivedAmount = convertUniswapPool(_source, _sourceAmount, _destination);
    }
    else if (tokensTypes.getType(_source) == bytes32("COMPOUND")){
      receivedAmount = convertCompound(_source, _sourceAmount, _destination);
    }
    else {
      // Unknown type
      revert("Unknown token type");
    }

    // send assets to _receiver
    if (_destination == ETH_TOKEN_ADDRESS) {
      (_receiver).transfer(receivedAmount);
    } else {
      // transfer tokens received to sender
      ERC20(_destination).transfer(_receiver, receivedAmount);
    }

    // After the trade, any _source that exchangePortal holds will be sent back to msg.sender
    uint256 endAmount = (_source == ETH_TOKEN_ADDRESS)
    ? address(this).balance
    : ERC20(_source).balanceOf(address(this));

    // Check if we hold a positive amount of _source
    if (endAmount > 0) {
      if (_source == ETH_TOKEN_ADDRESS) {
        (_receiver).transfer(endAmount);
      } else {
        ERC20(_source).transfer(_receiver, endAmount);
      }
    }
  }

  // helper for convert Compound asset
  // _source - should be Compound token
  function convertCompound(address _source, uint256 _sourceAmount, address _destination)
    private
    returns(uint256)
  {
    // step 0 transfer compound asset from sender
    ERC20(_source).transferFrom(msg.sender, address(this), _sourceAmount);

    // step 1 convert cToken to underlying
    CToken(_source).redeem(_sourceAmount);

    // step 2 get underlying address and received underlying amount
    address underlyingAddress = (_source == CEther)
    ? ETH_TOKEN_ADDRESS
    : CToken(_source).underlying();

    uint256 underlyingAmount = (_source == CEther)
    ? address(this).balance
    : ERC20(underlyingAddress).balanceOf(address(this));

    // step 3 convert underlying to destination if _destination != underlyingAddress
    if(_destination != underlyingAddress){
      uint256 destAmount = 0;
      // convert via 1inch
      // Convert ETH
      if(underlyingAddress == ETH_TOKEN_ADDRESS){
        destAmount = exchangePortal.trade.value(underlyingAmount)(
          ERC20(underlyingAddress),
          underlyingAmount,
          ERC20(_destination),
          2,
          BYTES32_EMPTY_ARRAY,
          "0x"
        );
      }
      // Convert ERC20
      else{
        ERC20(underlyingAddress).approve(address(exchangePortal), underlyingAmount);
        destAmount = exchangePortal.trade(
          ERC20(underlyingAddress),
          underlyingAmount,
          ERC20(_destination),
          2,
          BYTES32_EMPTY_ARRAY,
          "0x"
        );
      }
      return destAmount;
    }
    else{
      return underlyingAmount;
    }

  }

  // helper for convert Unswap asset
  // _source - should be Uni pool
  function convertUniswapPool(address _source, uint256 _sourceAmount, address _destination)
    private
    returns(uint256)
  {
    // sell pool
    _transferFromSenderAndApproveTo(ERC20(_source), _sourceAmount, address(poolPortal));

    poolPortal.sellPool(
      _sourceAmount,
      1, // type Uniswap
      ERC20(_source)
    );

    // convert pool connectors to destanation
    // get erc20 connector address
    address ERCConnector = poolPortal.getTokenByUniswapExchange(_source);
    uint256 ERCAmount = ERC20(ERCConnector).balanceOf(address(this));

    // convert ERC20 connector via 1inch if destination != ERC20 connector
    if(ERCConnector != _destination){
      ERC20(ERCConnector).approve(address(exchangePortal), ERCAmount);
      exchangePortal.trade(
        ERC20(ERCConnector),
        ERCAmount,
        ERC20(_destination),
        2, // type 1inch
        BYTES32_EMPTY_ARRAY,
        "0x"
      );
    }

    // if destanation != ETH, convert ETH also
    if(_destination != ETH_TOKEN_ADDRESS){
      uint256 ETHAmount = address(this).balance;
      exchangePortal.trade.value(ETHAmount)(
        ERC20(ETH_TOKEN_ADDRESS),
        ETHAmount,
        ERC20(_destination),
        2, // type 1inch
        BYTES32_EMPTY_ARRAY,
        "0x"
      );
    }

    // return received amount
    if(_destination == ETH_TOKEN_ADDRESS){
      return address(this).balance;
    }else{
      return ERC20(_destination).balanceOf(address(this));
    }
  }

  // helper for convert standrad crypto assets
  function convertCryptocurency(address _source, uint256 _sourceAmount, address _destination)
    private
    returns(uint256)
  {
    // Convert crypto via 1inch aggregator
    uint256 destAmount = 0;
    if(_source == ETH_TOKEN_ADDRESS){
      destAmount = exchangePortal.trade.value(_sourceAmount)(
        ERC20(_source),
        _sourceAmount,
        ERC20(_destination),
        2,
        BYTES32_EMPTY_ARRAY,
        "0x"
      );
    }else{
      _transferFromSenderAndApproveTo(ERC20(_source), _sourceAmount, address(exchangePortal));
      destAmount = exchangePortal.trade(
        ERC20(_source),
        _sourceAmount,
        ERC20(_destination),
        2,
        BYTES32_EMPTY_ARRAY,
        "0x"
      );
    }
    return destAmount;
  }

  // helper for convert Bancor pools asset
  // _source - should be Bancor pool
  function convertBancorPool(address _source, uint256 _sourceAmount, address _destination)
    private
    returns(uint256)
  {
    _transferFromSenderAndApproveTo(ERC20(_source), _sourceAmount, address(exchangePortal));
    // Convert BNT pools just via Bancor DEX
    uint256 destAmount = exchangePortal.trade(
      ERC20(_source),
      _sourceAmount,
      ERC20(_destination),
      1,
      BYTES32_EMPTY_ARRAY,
      "0x"
    );

    return destAmount;
  }

  /**
  * @dev Transfers tokens to this contract and approves them to another address
  *
  * @param _source          Token to transfer and approve
  * @param _sourceAmount    The amount to transfer and approve (in _source token)
  * @param _to              Address to approve to
  */
  function _transferFromSenderAndApproveTo(ERC20 _source, uint256 _sourceAmount, address _to) private {
    require(_source.transferFrom(msg.sender, address(this), _sourceAmount), "Can not transfer from");

    _source.approve(_to, _sourceAmount);
  }

  // fallback payable function to receive ether from other contract addresses
  function() public payable {}
}