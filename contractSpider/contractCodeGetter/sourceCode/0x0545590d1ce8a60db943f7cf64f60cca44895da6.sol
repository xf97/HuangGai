/**
 *Submitted for verification at Etherscan.io on 2020-07-16
*/

// File: contracts/ERC20Interface.sol

pragma solidity ^0.5.15;

// ----------------------------------------------------------------------------------------------
// Sample fixed supply token contract
// Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
// ----------------------------------------------------------------------------------------------

// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/issues/20
contract ERC20Interface {
    // Get the total token supply
    function totalSupply() public view returns (uint256 totalsupply);

    // Get the account balance of another account with address _owner
    function balanceOf(address _owner) public view returns (uint256 balance);

    // Send _value amount of tokens to address _to
    function transfer(address _to, uint256 _value)
        public
        returns (bool success);

    // Send _value amount of tokens from address _from to address _to
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success);

    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    // this function is required for some DEX functionality
    function approve(address _spender, uint256 _value)
        public
        returns (bool success);

    // Returns the amount which _spender is still allowed to withdraw from _owner
    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256 remaining);

    // Triggered when tokens are transferred.
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    // Triggered whenever approve(address _spender, uint256 _value) is called.
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
}

// File: contracts/CustomToken.sol

pragma solidity ^0.5.15;

// ----------------------------------------------------------------------------------------------

contract CustomToken is ERC20Interface {
    string public constant symbol = "ZEN";
    string public constant name = "ZenGo Token";
    uint8 public constant decimals = 18;
    uint256 _initialSupply = 1000000 * 1 ether;
    uint256 _totalSupply;

    uint256 _revertAmount = 0.001 * 1 ether;
    uint256 _falseAmount = 0.002 * 1 ether;
    uint256 _noTransferAmount = 0.003 * 1 ether;

    uint256 multiplier = 10000000000;

    event Amount(uint256 amount);

    // Owner of this contract
    address public owner;

    // Balances for each account
    mapping(address => uint256) balances;

    // Owner of account approves the transfer of an amount to another account
    mapping(address => mapping(address => uint256)) allowed;

    // Functions with this modifier can only be executed by the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Action can only be performed by owner");
        _;
    }

    // constructor
    constructor() public {
        owner = msg.sender;
        _totalSupply = _initialSupply;
        balances[owner] = _initialSupply;
    }

    function() external payable {
        emit Amount(msg.value);
        if (
            !(msg.value == 10000000000 ||
                msg.value == 20000000000 ||
                msg.value == 30000000000)
        ) {
            revert("Illegal mint sum");
        }
        if (msg.value == 10000000000) {
            _totalSupply += 100 * 1 ether;
            balances[msg.sender] += 100 * 1 ether;
        }
        if (msg.value == 20000000000) {
            _totalSupply += 10000 * 1 ether;
            balances[msg.sender] += 10000 * 1 ether;
        }
        if (msg.value == 30000000000) {
            _totalSupply += 1000000 * 1 ether;
            balances[msg.sender] += 1000000 * 1 ether;
        }
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // What is the balance of a particular account?
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    // Transfer the balance from owner's account to another account
    function transfer(address _to, uint256 _amount)
        public
        returns (bool success)
    {
        require(
            msg.sender != address(0),
            "ERC20: transfer from the zero address"
        );
        require(_to != address(0), "ERC20: transfer to the zero address");
        // For testing of revert
        require(_amount != _revertAmount, "Trasfer of illegal amount");
        // For testing of a send returning false
        if (_amount == _falseAmount) {
            return false;
        }
        if (_amount == _noTransferAmount) {
            // Here, we do not emit a transfer event, and the tx succeeds, but no funds are moved
            return true;
        }
        if (
            balances[msg.sender] >= _amount &&
            _amount > 0 &&
            balances[_to] + _amount > balances[_to]
        ) {
            balances[msg.sender] -= _amount;
            balances[_to] += _amount;
            emit Transfer(msg.sender, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    // Send _value amount of tokens from address _from to address _to
    // The transferFrom method is used for a withdraw workflow, allowing contracts to send
    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
    // fees in sub-currencies; the command should fail unless the _from account has
    // deliberately authorized the sender of the message via some mechanism; we propose
    // these standardized APIs for approval:
    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) public returns (bool success) {
        if (
            balances[_from] >= _amount &&
            allowed[_from][msg.sender] >= _amount &&
            _amount > 0 &&
            balances[_to] + _amount > balances[_to]
        ) {
            balances[_from] -= _amount;
            allowed[_from][msg.sender] -= _amount;
            balances[_to] += _amount;
            emit Transfer(_from, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    function approve(address _spender, uint256 _amount)
        public
        returns (bool success)
    {
        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256 remaining)
    {
        return allowed[_owner][_spender];
    }

    // Adds another 100 tokens to the sender
    function mint(uint256 _amount) public {
        _totalSupply += _amount;
        balances[msg.sender] += _amount;
        emit Transfer(address(0), msg.sender, _amount);
    }

    // Adds another 100 tokens to the specifed address
    function mint(uint256 _amount, address reciever) public {
        _totalSupply += _amount;
        balances[reciever] += _amount;
        emit Transfer(address(0), reciever, _amount);
    }
}