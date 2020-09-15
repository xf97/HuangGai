/**
 *Submitted for verification at Etherscan.io on 2020-08-04
*/

/**
 *Submitted for verification at Etherscan.io on 2017-09-17
*/

pragma solidity ^0.4.16;

contract SafeMath {
     function safeMul(uint a, uint b) internal returns (uint) {
          uint c = a * b;
          assert(a == 0 || c / a == b);
          return c;
     }

     function safeSub(uint a, uint b) internal returns (uint) {
          assert(b <= a);
          return a - b;
     }

     function safeAdd(uint a, uint b) internal returns (uint) {
          uint c = a + b;
          assert(c>=a && c>=b);
          return c;
     }
}

// Standard token interface (ERC 20)
// https://github.com/ethereum/EIPs/issues/20
contract Token is SafeMath {
     // Functions:
     /// @return total amount of tokens
     function totalSupply() constant returns (uint256 supply);

     /// @param _owner The address from which the balance will be retrieved
     /// @return The balance
     function balanceOf(address _owner) constant returns (uint256 balance);

     /// @notice send `_value` token to `_to` from `msg.sender`
     /// @param _to The address of the recipient
     /// @param _value The amount of token to be transferred
     function transfer(address _to, uint256 _value) returns(bool);

     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
     /// @param _from The address of the sender
     /// @param _to The address of the recipient
     /// @param _value The amount of token to be transferred
     /// @return Whether the transfer was successful or not
     function transferFrom(address _from, address _to, uint256 _value) returns(bool);

     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
     /// @param _spender The address of the account able to transfer the tokens
     /// @param _value The amount of wei to be approved for transfer
     /// @return Whether the approval was successful or not
     function approve(address _spender, uint256 _value) returns (bool success);

     /// @param _owner The address of the account owning tokens
     /// @param _spender The address of the account able to transfer the tokens
     /// @return Amount of remaining tokens allowed to spent
     function allowance(address _owner, address _spender) constant returns (uint256 remaining);

     // Events:
     event Transfer(address indexed _from, address indexed _to, uint256 _value);
     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract StdToken is Token {
     // Fields:
     mapping(address => uint256) balances;
     mapping (address => mapping (address => uint256)) allowed;
     uint public supply = 0;

     // Functions:
     function transfer(address _to, uint256 _value) returns(bool) {
          require(balances[msg.sender] >= _value);
          require(balances[_to] + _value > balances[_to]);

          balances[msg.sender] = safeSub(balances[msg.sender],_value);
          balances[_to] = safeAdd(balances[_to],_value);

          Transfer(msg.sender, _to, _value);
          return true;
     }

     function transferFrom(address _from, address _to, uint256 _value) returns(bool){
          require(balances[_from] >= _value);
          require(allowed[_from][msg.sender] >= _value);
          require(balances[_to] + _value > balances[_to]);

          balances[_to] = safeAdd(balances[_to],_value);
          balances[_from] = safeSub(balances[_from],_value);
          allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);

          Transfer(_from, _to, _value);
          return true;
     }

     function totalSupply() constant returns (uint256) {
          return supply;
     }

     function balanceOf(address _owner) constant returns (uint256) {
          return balances[_owner];
     }

     function approve(address _spender, uint256 _value) returns (bool) {
          // To change the approve amount you first have to reduce the addresses`
          //  allowance to zero by calling `approve(_spender, 0)` if it is not
          //  already 0 to mitigate the race condition described here:
          //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
          require((_value == 0) || (allowed[msg.sender][_spender] == 0));

          allowed[msg.sender][_spender] = _value;
          Approval(msg.sender, _spender, _value);

          return true;
     }

     function allowance(address _owner, address _spender) constant returns (uint256) {
          return allowed[_owner][_spender];
     }
}

contract EthDBNToken is StdToken
{
/// Fields:
    string public constant name = "Deep Belief Network";
    string public constant symbol = "DBN";
    uint public constant decimals = 18;

    // this includes DEVELOPERS_BONUS
    uint public constant TOTAL_SUPPLY = 2000000000 * (1 ether / 1 wei);

    uint public constant PRESALE_PRICE_1 = 240000;
    uint public constant PRESALE_PRICE_2 = 200000;
    uint public constant PRESALE_PRICE_3 = 150000;
    uint public constant PRESALE_MAX_ETH_PER_ROUND = 1000;

    // 1bln - this includes presale tokens
    // uint public constant TOTAL_SOLD_TOKEN_SUPPLY_LIMIT = 1000000000* (1 ether / 1 wei);

    enum DBNState {
        Selling,
        Pending,
        Working
    }

    DBNState public currentState = DBNState.Pending;
    address public tokenManager = 0;

/// Modifiers:
    modifier onlyTokenManager()
    {
        require(msg.sender == tokenManager); 
        _; 
    }
    
/// Events:
    event LogBuy(address indexed owner, uint value);
    event LogBurn(address indexed owner, uint value);

/// Functions:
    /// @dev Constructor
    /// @param _tokenManager Token manager address.
    
    constructor (address _tokenManager) public
    {
        tokenManager = _tokenManager;
        balances[_tokenManager] += TOTAL_SUPPLY;
    }

    function setState(DBNState _nextState) public onlyTokenManager
    {
        currentState = _nextState;
    }

/// Overrides:
    function transfer(address _to, uint256 _value) public returns(bool){
        require(currentState == DBNState.Working || msg.sender == tokenManager);
        return super.transfer(_to,_value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
        require(currentState == DBNState.Working || msg.sender == tokenManager);
        return super.transferFrom(_from,_to,_value);
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        require(currentState == DBNState.Working || msg.sender == tokenManager);
        return super.approve(_spender,_value);
    }


/// Setters/getters
    function setTokenManager(address _mgr) public onlyTokenManager
    {
        tokenManager = _mgr;
    }

    // Default fallback function
    function() payable 
    {
        
    }
}