/**
 *Submitted for verification at Etherscan.io on 2020-08-03
*/

pragma solidity ^0.5.0;

// --1--------------------------------------------------------------------------
// Chad has an ERC20 Token Now
// --1--------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
// Beboop Maths Compute
// --1--------------------------------------------------------------------------
// Saf3 Math L1brary 
// --1--------------------------------------------------------------------------
contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
        c = a / b;
    }
}

// Less def1ne some stuff for Chad

contract ChadCoin is ERC20Interface, SafeMath {
    string public name;
    string public symbol;
    uint8 public decimals; // 18 decimals is the strongly sugg3sted default, avoid changing it
    
    uint256 public _totalSupply;
    
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    
    /**
     * Constructor Gadget function goes
     * Woo Hoo
     * Initializ3s contract with initial supply tok3ns to the creator of the contract
     */
    constructor() public {
        name = "Chad Coin";
        symbol = "CHAD";
        decimals = 18;
        _totalSupply = 10000000000000000000000000000;
        
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
    
    function totalSupply() public view returns (uint) {
        return _totalSupply  - balances[address(0)];
    }
    
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }
    
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
    
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
    
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
    
// Ooo, spicey food. Burp
event Burn(address indexed burner, uint256 value);  function burn(uint256 _value) public {
    _burn(msg.sender, _value);
  }function _burn(address _who, uint256 _value) internal {
    emit Burn(_who, _value);
    emit Transfer(_who, address(0), _value);
  }
// Well that came up twice - bleh
}