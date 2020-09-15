/**
 *Submitted for verification at Etherscan.io on 2020-05-28
*/

/*
Copyright (c) 2020, BitVerk
*/

pragma solidity >=0.4.22 <0.7.0;

// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------
library MySafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        if (a == 0) {
            revert();
        }
        c = a * b;
        require(c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
contract MyERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

// ----------------------------------------------------------------------------
// Contract function to receive approval and execute function in one call
//
// Borrowed from MiniMeToken
// ----------------------------------------------------------------------------
contract MyApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
}

// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract MyOwned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }
    
    function transferOwnership(address _newOwner) external {
        require(msg.sender == owner);
        newOwner = _newOwner;
    }

    function acceptOwnership() external {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

/**
 * The /**
  * The Delegated contract allows a set of delegate accounts
  * to perform special tasks such as admin tasks to the contract
  */
 contract MyDelegated is MyOwned {
    mapping (address => bool) delegates;
    
    event DelegateChanged(address delegate, bool state);

    constructor() public {
    }

    function() external payable { 
        revert();
    }

    function checkDelegate(address _user) internal view {
        require(_user == owner || delegates[_user]);
    }
    
    function setDelegate(address _address, bool state) external {
        checkDelegate(msg.sender);

        if (state) {
            delegates[_address] = true;
        } else {
            delegates[_address] = false;
        }
        emit DelegateChanged(_address, state);
    }
 
    function isDelegate(address account) external view returns (bool delegate)  {
        return (account == owner || delegates[account]);
    }

    function kill() external {
        checkDelegate(msg.sender);
        selfdestruct(owner); 
    }
 }

// ----------------------------------------------------------------------------
// Test Token, with the addition of symbol, name and decimals and an
// initial fixed supply
// ----------------------------------------------------------------------------
contract BitVerkCredit is MyERC20Interface, MyDelegated {
    using MySafeMath for uint;

    string internal symbol_ = "VERK";
    string internal name_ = "BitVerkCredit"; 
    uint internal  decimals_ = 18;
    uint internal  totalSupply_;
    bool public halted_ = false;

    mapping(address => uint) internal balances_;
    mapping(address => mapping(address => uint)) internal allowed_;

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor() public {
        halted_ = false;
        totalSupply_ = 0;
    }

    function name() external view returns (string) {
        return name_;
    }

    function symbol() external view returns (string) {
        return symbol_;
    }

    function decimals() external view returns (uint) {
        return decimals_;
    }

    function setInfo(string _name, string _symbol, uint _decimals) external {
        checkDelegate(msg.sender);
        symbol_ = _name;
        name_ = _symbol;
        decimals_ = _decimals;
    }

    function mint(address _to, uint _amount) external {
        checkDelegate(msg.sender);
        require(_to != address(0));
        require(_amount > 0);

        balances_[_to] = balances_[_to].add(_amount);
        totalSupply_ = totalSupply_.add(_amount);
        emit Transfer(address(0), _to, _amount);
    }

    function burn(address _to, uint _amount) external {
        checkDelegate(msg.sender);
        require(_amount > 0);

        balances_[_to] = balances_[_to].sub(_amount);
        totalSupply_ = totalSupply_.sub(_amount);
        emit Transfer(_to, address(0), _amount);
    }

    // ------------------------------------------------------------------------
    // Set the halted tag when the emergent case happened
    // ------------------------------------------------------------------------
    function setEmergentHalt(bool _tag) external {
        checkDelegate(msg.sender);
        halted_ = _tag;
    }

    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() external view returns (uint) {
        return totalSupply_;
    }

    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function balanceOf(address _tokenOwner) external view returns (uint) {
        return balances_[_tokenOwner];
    }

    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address _to, uint _tokens) external returns (bool) {
        require(!halted_);

        balances_[msg.sender] = balances_[msg.sender].sub(_tokens);
        balances_[_to] = balances_[_to].add(_tokens);

        emit Transfer(msg.sender, _to, _tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account
    //
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
    // recommends that there are no checks for the approval double-spend attack
    // as this should be implemented in user interfaces 
    // ------------------------------------------------------------------------
    function approve(address _spender, uint _tokens) external returns (bool) {
        require(_spender != msg.sender);

        allowed_[msg.sender][_spender] = _tokens;

        emit Approval(msg.sender, _spender, _tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    // 
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(address _from, address _to, uint _tokens) external returns (bool) {
        require(!halted_);

        allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_tokens);
        balances_[_from] = balances_[_from].sub(_tokens);
        balances_[_to] = balances_[_to].add(_tokens);

        emit Transfer(_from, _to, _tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function allowance(address _tokenOwner, address _spender) external view returns (uint) {
        return allowed_[_tokenOwner][_spender];
    }

    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------
    function transferAnyERC20Token(address _tokenAddress, uint _tokens) external returns (bool) {
        checkDelegate(msg.sender);
        return MyERC20Interface(_tokenAddress).transfer(owner, _tokens);
    }
}