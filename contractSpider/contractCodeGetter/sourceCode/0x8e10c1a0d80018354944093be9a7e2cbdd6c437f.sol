/**
 *Submitted for verification at Etherscan.io on 2020-08-10
*/

pragma solidity ^0.4.22;

// File: contracts/library/SafeMath.sol

/**
 * @title Safe Math
 *
 * @dev Library for safe mathematical operations.
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;

        return c;
    }

    function minus(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);

        return a - b;
    }

    function plus(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);

        return c;
    }
}

// File: contracts/token/ERC20Token.sol

/**
 * @dev The standard ERC20 Token contract base.
 */
contract ERC20Token {
    uint256 public totalSupply;  /* shorthand for public function and a property */
    
    function balanceOf(address _owner) public view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

// File: contracts/token/StandardToken.sol

/**
 * @title Standard Token
 *
 * @dev The standard abstract implementation of the ERC20 interface.
 */
contract StandardToken is ERC20Token {
    using SafeMath for uint256;

    string public name;
    string public symbol;
    uint256 public decimals;

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) internal allowed;

    /**
     * @dev The constructor assigns the token name, symbols and decimals.
     */
    constructor(string _name, string _symbol, uint256 _decimals) internal {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    /**
     * @dev Get the balance of an address.
     *
     * @param _address The address which's balance will be checked.
     *
     * @return The current balance of the address.
     */
    function balanceOf(address _address) public view returns (uint256 balance) {
        return balances[_address];
    }

    /**
     * @dev Checks the amount of tokens that an owner allowed to a spender.
     *
     * @param _owner The address which owns the funds allowed for spending by a third-party.
     * @param _spender The third-party address that is allowed to spend the tokens.
     *
     * @return The number of tokens available to `_spender` to be spent.
     */
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    /**
     * @dev Give permission to `_spender` to spend `_value` number of tokens on your behalf.
     * E.g. You place a buy or sell order on an exchange and in that example, the 
     * `_spender` address is the address of the contract the exchange created to add your token to their 
     * website and you are `msg.sender`.
     *
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     *
     * @return Whether the approval process was successful or not.
     */
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    /**
     * @dev Transfers `_value` number of tokens to the `_to` address.
     *
     * @param _to The address of the recipient.
     * @param _value The number of tokens to be transferred.
     */
    function transfer(address _to, uint256 _value) public returns (bool) {
        executeTransfer(msg.sender, _to, _value);

        return true;
    }

    /**
     * @dev Allows another contract to spend tokens on behalf of the `_from` address and send them to the `_to` address.
     *
     * @param _from The address which approved you to spend tokens on their behalf.
     * @param _to The address where you want to send tokens.
     * @param _value The number of tokens to be sent.
     *
     * @return Whether the transfer was successful or not.
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_value <= allowed[_from][msg.sender], "Insufficient allowance");

        allowed[_from][msg.sender] = allowed[_from][msg.sender].minus(_value);
        executeTransfer(_from, _to, _value);

        return true;
    }

    /**
     * @dev Internal function that this reused by the transfer functions
     */
    function executeTransfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0), "Invalid transfer to address zero");
        require(_value <= balances[_from], "Insufficient account balance");

        balances[_from] = balances[_from].minus(_value);
        balances[_to] = balances[_to].plus(_value);

        emit Transfer(_from, _to, _value);
    }
}



// File: contracts/token/BurnableToken.sol

/**
 * @title Burnable Token
 *
 * @dev Allows tokens to be destroyed.
 */
contract BurnableToken is StandardToken {
    /**
     * @dev Event fired when tokens are burned.
     *
     * @param _from The address from which tokens will be removed.
     * @param _value The number of tokens to be destroyed.
     */
    event Burn(address indexed _from, uint256 _value);

    /**
     * @dev Burnes `_value` number of tokens.
     *
     * @param _value The number of tokens that will be burned.
     */
    function burn(uint256 _value) public {
        require(_value != 0, "The amount of tokens is zero");

        address burner = msg.sender;
        require(_value <= balances[burner], "Insufficient account balance");

        balances[burner] = balances[burner].minus(_value);
        totalSupply = totalSupply.minus(_value);

        emit Burn(burner, _value);
        emit Transfer(burner, address(0), _value);
    }
}


// File: contracts/token/MintableToken.sol

/**
 * @title Mintable Token
 *
 * @dev Allows the creation of new tokens.
 */
contract MintableToken is StandardToken {
    /// @dev The only address allowed to mint coins
    address public minter;

    /**
     * @dev Allows a function to be called only by the minter
     */
    modifier onlyMinter() {
        require(msg.sender == minter, "Only the owner address can mint");
        _;
    }

    /**
     * @dev The constructor assigns the minter which is allowed to mint and disable minting
     */
    constructor(address _minter) internal {
        minter = _minter;
    }

    /**
    * @dev Creates new `_value` number of tokens and sends them to the `_to` address.
    *
    * @param _to The address which will receive the freshly minted tokens.
    * @param _value The number of tokens that will be created.
    */
    function mint(address _to, uint256 _value) public onlyMinter {
        totalSupply = totalSupply.plus(_value);
        balances[_to] = balances[_to].plus(_value);

        emit Transfer(0x0, _to, _value);
    }


}


// File: contracts/token/StandardMintableToken.sol

contract StandardMintableToken is MintableToken, BurnableToken {
    constructor(address _minter, string _name, string _symbol, uint256 _decimals)
        StandardToken(_name, _symbol, _decimals)
        MintableToken(_minter)
        
        public
    {
    mint(msg.sender, _decimals);
    }
}