/**
 *Submitted for verification at Etherscan.io on 2020-07-19
*/

/*


 ██████ ██   ██ ██    ██ ██████  ███    ██ 
██      ██   ██ ██    ██ ██   ██ ████   ██ 
██      ███████ ██    ██ ██████  ██ ██  ██ 
██      ██   ██ ██    ██ ██   ██ ██  ██ ██ 
 ██████ ██   ██  ██████  ██   ██ ██   ████ 

                                      


(CHURN) 

The Delflationary Token with Staking Rewards for Holders.

Website:   https://churn.fund   

Twitter:   https://twitter.com/ChurnFund

Discord:   https://discord.gg/K9NcvJE

1% of every CHURN transfer is burned making all CHURN tokens more valuable.

CHURN holders can choose to stake their tokens for different amounts of bonus tokens:

    30   Days.....  1.5%  Bonus
    90  Days.....   5.0%  Bonus
    180  Days..... 17.5%  Bonus
    360 Days....   45.0%  Bonus

CHURN presale from July 20 to August 1

CHURN presale price is 0.0005 ETH.

2,000,000 CHURN max in presale

Uniswap Launch Aug 2

50% of presale funds raised will be used for the initial Uniswap liquidity.

CHURN will launch Balancer pool on September 1

Maximum Supply of CHURN is 5,000,000 tokens

*/

pragma solidity ^0.5.17;

interface IERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address who) external view returns (uint256);
  function allowance(address owner, address spender) external view returns (uint256);
  function transfer(address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  function transferFrom(address from, address to, uint256 value) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
    uint256 c = add(a,m);
    uint256 d = sub(c,1);
    return mul(div(d,m),m);
  }
}

contract ERC20Detailed is IERC20 {

  string private _name;
  string private _symbol;
  uint8 private _decimals;

  constructor(string memory name, string memory symbol, uint8 decimals) public {
    _name = name;
    _symbol = symbol;
    _decimals = decimals;
  }

  function name() public view returns(string memory) {
    return _name;
  }

  function symbol() public view returns(string memory) {
    return _symbol;
  }

  function decimals() public view returns(uint8) {
    return _decimals;
  }
}

contract CHURN is ERC20Detailed {

  using SafeMath for uint256;
  mapping (address => uint256) private _balances;
  mapping (address => uint256) private _lockEnd;
  mapping (address => bool) private _presaleAuth;
  mapping (address => mapping (address => uint256)) private _allowed;
  bool public _presaleMode = true;
  address _manager = msg.sender;
  uint256 presalePrice = 0.0005 ether;
  uint256 totalPresale = 0;
  uint256 maxPresale = 2000000 * 1e18;
  uint256 maxSupply = 5000000 * 1e18;


  event Stake(address owner, uint256 period);

  string constant tokenName = "Churn.fund";   
  string constant tokenSymbol = "CHURN";   
  uint8  constant tokenDecimals = 18;
  uint256 _totalSupply = 0;
  uint256 public basePercent = 100; 
  uint256 day = 86400; 
  uint256[] public stakeLevelRates;
  uint256[] public stakePeriods;
  


  constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
    //_issue(msg.sender, _totalSupply);
    _presaleAuth[msg.sender] = true;
    stakeLevelRates.push(15);  //30 Days     1.5%
    stakeLevelRates.push(50);  //90 Days     5.0%
    stakeLevelRates.push(175);  //180 Days   17.5%
    stakeLevelRates.push(450);  //360 Days   45.0%

    stakePeriods.push(30);  //30 Days     1.5%
    stakePeriods.push(90);  //90 Days     5.0%
    stakePeriods.push(180);  //180 Days   17.5%
    stakePeriods.push(360);  //360 Days   45.0%

    _presaleAuth[msg.sender] = true;
  }

  function() external payable {
    //Handle presale deposits here
    _presale();
  }

  function presale() external payable {
    _presale();
  }

  function _presale() internal {
      require(_presaleMode);
      require(msg.value >= 0.05 ether);
      uint256 newTokens = SafeMath.mul(SafeMath.div(msg.value, presalePrice),1e18);
      totalPresale += newTokens;
      require(totalPresale <= maxPresale);
      //_totalSupply = _totalSupply.add(newTokens);
      _issue(msg.sender, newTokens);
      //emit Transfer(address(0), msg.sender, newTokens);
  }

   function withdraw() external {
      require(msg.sender == _manager);
      msg.sender.transfer(address(this).balance);
  }

  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

   function getTime() public view returns (uint256) {
    return block.timestamp;
  }

  function balanceOf(address owner) public view returns (uint256) {
    return _balances[owner];
  }

  function lockOf(address owner) public view returns (uint256) {
    return _lockEnd[owner];
  }

   function myLockedTime() public view returns (uint256) {
    return _lockEnd[msg.sender];
  }

  function myLockedStatus() public view returns (bool) {
     if(_lockEnd[msg.sender] > block.timestamp){
           return true;
       } else {
           return false;
       }
  }

   function isLocked(address owner) public view returns (bool) {
       if(_lockEnd[owner] > block.timestamp){
           return true;
       } else {
           return false;
       }
    
  }

  function allowance(address owner, address spender) public view returns (uint256) {
    return _allowed[owner][spender];
  }

  function cut(uint256 value) public view returns (uint256)  {
    uint256 roundValue = value.ceil(basePercent);
    uint256 cutValue = roundValue.mul(basePercent).div(10000);
    return cutValue;
  }

  function endPresale() external {
    require(msg.sender == _manager);
    _presaleMode = false;
  }

  function addPresaleAuth(address _addAuth) external {
    require(msg.sender == _manager);
    _presaleAuth[_addAuth] = true;
  }

  function issue(address _to, uint256 _tokenAmount) external {
    require(msg.sender == _manager);
    //require(_tokenAmount + _totalSupply <= maxSupply);
    //_totalSupply = _totalSupply.add(newTokens);
    uint256 testTotalSupply = _totalSupply + _tokenAmount;
    require(testTotalSupply <= maxSupply);
    _issue(_to, _tokenAmount);
  }


  // function burnPresale() external {
  //   require(msg.sender == _manager);
  //   _presaleMode = false;
  //   uint256 burnTokens = SafeMath.sub(totalPresale, MaxPresale)
  // }

  function transfer(address to, uint256 value) public returns (bool) {
    require(_lockEnd[msg.sender] <= block.timestamp);
    require(value <= _balances[msg.sender]);
    require(to != address(0));
    require(!_presaleMode || _presaleAuth[msg.sender]);
   

    uint256 tokensToBurn = cut(value);
    uint256 tokensToTransfer = value.sub(tokensToBurn);

    _balances[msg.sender] = _balances[msg.sender].sub(value);
    _balances[to] = _balances[to].add(tokensToTransfer);

    _totalSupply = _totalSupply.sub(tokensToBurn);

    emit Transfer(msg.sender, to, tokensToTransfer);
    emit Transfer(msg.sender, address(0), tokensToBurn);
    return true;
  }


  function approve(address spender, uint256 value) public returns (bool) {
    require(spender != address(0));
    require(!_presaleMode || _presaleAuth[msg.sender]);
    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  function transferFrom(address from, address to, uint256 value) public returns (bool) {
    require(_lockEnd[from] <= block.timestamp || _presaleAuth[msg.sender]);
    require(value <= _balances[from]);
    require(value <= _allowed[from][msg.sender]);
    require(to != address(0));

    _balances[from] = _balances[from].sub(value);

    uint256 tokensToBurn = cut(value);
    uint256 tokensToTransfer = value.sub(tokensToBurn);

    _balances[to] = _balances[to].add(tokensToTransfer);
    _totalSupply = _totalSupply.sub(tokensToBurn);

    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);

    emit Transfer(from, to, tokensToTransfer);
    emit Transfer(from, address(0), tokensToBurn);

    return true;
  }

  function upAllowance(address spender, uint256 addedValue) public returns (bool) {
    require(spender != address(0));
    require(!_presaleMode || _presaleAuth[msg.sender]);
    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  function downAllowance(address spender, uint256 subtractedValue) public returns (bool) {
    require(spender != address(0));
    require(!_presaleMode || _presaleAuth[msg.sender]);
    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  function _issue(address account, uint256 amount) internal {
    require(amount != 0);
    _balances[account] = _balances[account].add(amount);
    _totalSupply += amount;
    emit Transfer(address(0), account, amount);
  }

  function destroy(uint256 amount) external {
    _destroy(msg.sender, amount);
  }

  function _destroy(address account, uint256 amount) internal {
    require(amount != 0);
    require(amount <= _balances[account]);
    _totalSupply = _totalSupply.sub(amount);
    _balances[account] = _balances[account].sub(amount);
    emit Transfer(account, address(0), amount);
  }

  function destroyFrom(address account, uint256 amount) external {
    require(amount <= _allowed[account][msg.sender]);
    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
    _destroy(account, amount);
  }

  function stake(uint256 period) external {
    _stake(period);
  }

  function setRate(uint256 _periodIndex, uint256 _newRate) external {
     require(msg.sender == _manager);
    stakeLevelRates[_periodIndex] = _newRate;
  }

  function setPeriods(uint256 _periodIndex, uint256 _newPeriod) external {
     require(msg.sender == _manager);
    stakePeriods[_periodIndex] = _newPeriod;
  }

  function _stake(uint256 _period) internal {
      require(_balances[msg.sender] > 10000, "Not enough tokens");
      require(_lockEnd[msg.sender] <= block.timestamp, "Lock Up Period");
      require(_period <= stakePeriods.length);

      uint256 newTokens;


      _lockEnd[msg.sender] = block.timestamp + SafeMath.mul(day,stakePeriods[_period]);
      newTokens = SafeMath.div(SafeMath.mul(_balances[msg.sender],stakeLevelRates[_period]),1000);
      _balances[msg.sender] += newTokens;

  
      _totalSupply = _totalSupply.add(newTokens);

      emit Stake(msg.sender, _period);
      emit Transfer(address(0), msg.sender, newTokens);

  }

}