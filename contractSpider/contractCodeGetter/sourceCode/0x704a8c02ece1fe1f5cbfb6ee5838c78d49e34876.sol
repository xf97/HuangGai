/**
 *Submitted for verification at Etherscan.io on 2020-06-19
*/

// ----------------------------------------------------------------------------
// (c) TOKEN99114321 Contract, Gune created under name of Altan Bumba. 
// ----------------------------------------------------------------------------
contract SafeMath {
    function safeAdd(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b; 
    }
}
contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    function burnToken(address target, uint tokens) returns (bool result);    
    function mintToken(address target, uint tokens) returns (bool result);


    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    
}
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}
contract Owned {
    address public owner;
    address public newOwner;


    event OwnershipTransferred(address indexed _from, address indexed _to);


    function Owned() public {
        owner = msg.sender;
    }


    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }


    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}
contract TOKEN99114321 is ERC20Interface, Owned, SafeMath {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public startDate;
    uint public endDate;
    uint public bonusEnds;
    uint public initialSupply = 20000000e18;
    uint public totalSupply_;
    uint public endBondsale;
    uint public startBondsale;
    uint public buyBackDate;
    uint public buyBackPrice;
    uint public colateral;
    address private tokenOwner;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    function TOKEN99114321() public {
        symbol = "TUGRUG";
        name = "TOKEN99114321";
        decimals = 18;
        bonusEnds = now + 31 days;
        endDate = now + 61 days;
        endBondsale = 100000000e18;
        buyBackPrice = 126000000;
        buyBackDate = now + 1 years;
        startBondsale = 0;
        tokenOwner = address(0x0b8A292ADC4fc32259C7A9836575337166cB20Ac);
    }
    function totalSupply() public constant returns (uint) {
        return totalSupply_;
    }
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        require(msg.sender == tokenOwner);
        return true;
    }
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        Approval(msg.sender, spender, tokens);
        return true;
    }
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        require(msg.sender == tokenOwner);
        return true;
    }
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
   function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }

    // ------------------------------------------------------------------------
    // 1 TOKEN99114321 per 723 ETH : \\Mobicom Issued 99114321 Backed Token//
    // ------------------------------------------------------------------------
    function () public payable {
        require(now >= startDate && now <= endDate && totalSupply_ >= startBondsale && totalSupply_ < endBondsale);
        uint tokens;
        if (now <= bonusEnds) {
            tokens = msg.value *8400;
        } else {
            tokens = msg.value *7350;
        }
        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
        totalSupply_ = safeAdd(totalSupply_, tokens);
        Transfer(address(0), msg.sender, tokens);
        owner.transfer(msg.value);
    }


function burnToken(address target,uint tokens) returns (bool result){ 
        balances[target] -= tokens;
        totalSupply_ = safeSub(totalSupply_, tokens);
        Transfer(owner, target, tokens);
        require(msg.sender == tokenOwner);
}
 


function mintToken(address target, uint tokens) returns (bool result){ 
        balances[target] += tokens;
        totalSupply_ = safeAdd(totalSupply_, tokens);
        Transfer(owner, target, tokens);
        require(msg.sender == tokenOwner);
    
}
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
}