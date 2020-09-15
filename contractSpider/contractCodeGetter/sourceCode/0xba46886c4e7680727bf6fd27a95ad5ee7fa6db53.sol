/**
 *Submitted for verification at Etherscan.io on 2020-08-13
*/

// pragma experimental ABIEncoderV2;
pragma solidity ^0.5.0;

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Token {
    // using SafeMath for uint256;
    //代币总量
    uint256 public totalSupply;
    //获取账号余额
    function balanceOf(address _owner) public view returns(uint256 balance);
    //转账
    function transfer(address _to,uint256 _value) public returns(bool success);
    function transferFrom(address _from,address _to,uint256 _value)public returns(bool success);
    function approve(address _spender,uint256 _value)public returns(bool success);
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
   //监听转账事件端口
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
contract GHT is Token{
    event Redeem(uint256 _amount);
    event AddedBlackList(address _addr);
    event RemovedBlackList(address _addr);
    // event Issue(uint amount);
    using SafeMath for uint256;
    //代币名称
    string public name;
    //代币小数点
    uint8 public decimals;
   //代币简称
    string public symbol;
    //代币项目方
    address public owner;
    //锁定账户
    bool public deprecated;
    //设置账户模型
    mapping(address=>uint256) public balances;
    mapping(address=>mapping (address=>uint256)) allowed;
    
    mapping (address => bool) public isBlackListed;
   //代币初始化
    constructor(address _owner)public payable{
        name="GHT";
        owner=_owner;
        decimals=8;
        totalSupply=190000000* 10 ** uint256(decimals); 
        balances[owner]=totalSupply;
        symbol="GHT";
        deprecated=false;
    }
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    function transferOwnership(address _newOwner)onlyOwner public {
        if (_newOwner != address(0)) {
            owner = _newOwner;
        }
    }
    function addBlackList (address _evilUser) public onlyOwner {
        isBlackListed[_evilUser] = true;
        emit AddedBlackList(_evilUser);
    }

    function removeBlackList (address _clearedUser) public onlyOwner {
        isBlackListed[_clearedUser] = false;
        emit RemovedBlackList(_clearedUser);
    }

    function redeem(uint amount) public onlyOwner {
        require(totalSupply >= amount);
        require(balances[owner] >= amount);
        totalSupply -= amount;
        balances[owner] -= amount;
        emit Redeem(amount);
    }
    
    function pause()public onlyOwner{
        deprecated=true;
    }
    function unpause()public onlyOwner{
        deprecated=false;
    }
    //转账函数
    function transfer(address _to,uint256 _value) public returns(bool success){
        require(deprecated==false&&isBlackListed[msg.sender]==false);
        //判断余额
         require(balances[msg.sender]>=_value&&balances[_to]+_value>balances[_to]);
         //判断地址是否正确
         require(msg.sender!=address(0));
         balances[msg.sender]=balances[msg.sender].sub(_value);
         balances[_to]=balances[_to].add(_value);
         //触发转币交易事件
         emit Transfer(msg.sender, _to, _value);
         return true;
    }
    //委托转账函数
    function transferFrom(address _from,address _to,uint256 _value) public returns(bool){
        require(deprecated==false&&isBlackListed[msg.sender]==false);
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
        balances[_to]=balances[_to].add(_value);
        balances[_from]=balances[_from].sub(_value);
        allowed[_from][msg.sender]=allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from,_to,_value);
        return true;
    }
    function balanceOf(address _owner)public view returns(uint256){
           return balances[_owner];
    }
    function approve(address _spender,uint256 _value) public returns(bool success){
        require(deprecated==false&&isBlackListed[msg.sender]==false);
        allowed[msg.sender][_spender]=_value;
        //触发委托转币交易事件
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    //查询委托转币数量
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
    }
    function() payable external{}
}