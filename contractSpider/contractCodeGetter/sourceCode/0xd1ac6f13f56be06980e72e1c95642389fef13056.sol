/**
 *Submitted for verification at Etherscan.io on 2020-06-05
*/

pragma solidity ^0.5.0;

/***************************************************************************************
*Who's streets our streets! It's 2020. It's time to stomp out the virus of Fascism, and 
*White Surpremecy that has forced its way into our lives, and asserted its rule through
*a broken society ruled by the inherent sociopathy of the Patriarchy! 
*
*The Fascists have shown themselves, and have attempted to invalidate our human 
*rights. They are threatening us with guns, taking the lives of POCs, gassing immigrants 
*at detention centers, they are attempting the murder of the Media.... All while an orange
* cheeto smirks from behind bulletproof glass, and his false, stolen, presidency. 
*It's time to push back against the lies, and take back our streets and our lives! 
*
*This token is a grassroots project for Antifa to continue to send and recieve support
*in the fight against Fascism, without being tracked, or monitored by Fascist government
*officials. 
*
*Humanity is global, our future is global. This is the first step, you can help us take the rest. 
*
*BLM!
* Bash the fash!
 */

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

// ----------------------------------------------------------------------------
// Safe Math Library 
// ----------------------------------------------------------------------------
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


contract Antifascisttoken is ERC20Interface, SafeMath {
    string public name;
    string public symbol;
    uint8 public decimals; 
    
    uint256 public _totalSupply;
    
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    


    constructor() public {
        name = "AntifascistToken";
        symbol = "ANTIFA";
        decimals = 18;
        _totalSupply = 1000000000;
        
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
}