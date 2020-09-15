pragma solidity ^0.4.8;
import "./Token.sol";

contract StandardToken is Token {
    function transfer(address _to, uint256 _value) returns (bool success) {
      
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }


    function transferFrom(address _from, address _to, uint256 _value) returns 
    (bool success) {
       
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
        balances[_to] += _value;
        balances[_from] -= _value; 
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }


    function approve(address _spender, uint256 _value) returns (bool success)   
    {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }


    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
}

contract HumanStandardToken is StandardToken { 
    address public owner;
    /* Public variables of the token */
    string public name;                  
    uint8 public decimals;              
    string public symbol;               
    string public version = 'H0.1';    

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function HumanStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol,address _owner) {
        balances[msg.sender] = _initialAmount; 
        totalSupply = _initialAmount;        
        name = _tokenName;                 
        decimals = _decimalUnits;       
        symbol = _tokenSymbol;             
        owner = _owner;
    }

    /* Approves and then calls the receiving contract */
    
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
        require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
        return true;
    }


    function mintToken(address target, uint256 mintedAmount) public onlyOwner returns (bool success){
        balances[target] += mintedAmount;
        totalSupply += mintedAmount;
        Transfer(0, owner, mintedAmount);
        Transfer(owner, target, mintedAmount);
        return true;
    }


}