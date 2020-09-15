/**
 *Submitted for verification at Etherscan.io on 2020-07-11
*/

pragma solidity ^0.4.24;
contract SafeMath {
    uint256 constant public MAX_UINT256 =
    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

    function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
        if (x > MAX_UINT256 - y) revert();
        return x + y;
    }

    function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
        if (x < y) revert();
        return x - y;
    }

    function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
        if (y == 0) return 0;
        if (x > MAX_UINT256 / y) revert();
        return x * y;
    }
}
contract TQA is SafeMath{
    
    string public constant name='CanadianSpinachCoin';
    string public constant symbol='TQA';
    uint public constant decimals=8;
    uint256 public constant totalSupply=280000000*10**decimals;
    // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().

    constructor() public {
        balances[msg.sender] = totalSupply;
    }
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowance;

    //发生转账时必须要触发的事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    // event Approval(address _owner,address _spender,uint256 _value);

    /// 获取账户_owner拥有token的数量
    function balanceOf(address _owner) public constant returns (uint256 balance) {//constant==view
        return balances[_owner];
    }

    //从消息发送者账户中往_to账户转数量为_value的token
    function transfer(address _to, uint256 _value) public returns (bool success){
        //默认totalSupply 不会超过最大值 (2^256 - 1).
        require(balances[msg.sender] >= _value);
        balances[msg.sender] = safeSub(balances[msg.sender], _value);
        //从消息发送者账户中减去token数量_value
        balances[_to] = safeAdd(balances[_to], _value);
        //往接收账户增加token数量_value
        emit Transfer(msg.sender, _to, _value);
        //触发转币交易事件
        return true;
    }

    //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(balances[_from] >= _value && allowance[_from][msg.sender] >= _value);
        balances[_to] = safeAdd(balances[_to], _value);
        //接收账户增加token数量_value
        balances[_from] = safeSub(balances[_from], _value);
        //支出账户_from减去token数量_value
        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
        //消息发送者可以从账户_from中转出的数量减少_value
        emit Transfer(_from, _to, _value);
        //触发转币交易事件
        return true;

    }

    //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
    function approve(address _spender, uint256 _value) public returns (bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    //获取账户_spender可以从账户_owner中转出token的数量
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
        return allowance[_owner][_spender];
    }
}