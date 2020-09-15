/**
 *Submitted for verification at Etherscan.io on 2020-05-26
*/

/**
 *Submitted for verification at Etherscan.io on 2020-02-25
*/

/**
 *Submitted for verification at Etherscan.io on 2020-25-08
*/

pragma solidity ^0.4.18;

// File: contracts/zeppelin-solidity-1.4/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

// File: contracts/zeppelin-solidity-1.4/ERC20Basic.sol

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

// File: contracts/zeppelin-solidity-1.4/SafeMath.sol

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Pausable is Ownable {
    bool public isPaused;
    
    event Pause(address _owner, uint _timestamp);
    event Unpause(address _owner, uint _timestamp);
    
    modifier whenPaused {
        require(isPaused);
        _;
    }
    
    modifier whenNotPaused {
        require(!isPaused);
        _;
    }
    
    function pause() public onlyOwner whenNotPaused {
        isPaused = true;
        Pause(msg.sender, now);
    }
    
    function unpause() public onlyOwner whenPaused {
        isPaused = false;
        Unpause(msg.sender, now);
    }
}

contract Whitelist is Ownable {
    
    bool public whitelistToggle = false;
    
    mapping(address => bool) whitelistedAccounts;
    
    modifier onlyWhitelisted(address from, address to) {
        if(whitelistToggle){
            require(whitelistedAccounts[from]);
            require(whitelistedAccounts[to]);
        }
        _;
    }
    
    event Whitelisted(address account);
    event UnWhitelisted(address account);
    
    event ToggleWhitelist(address sender, uint timestamp);
    event UntoggleWhitelist(address sender, uint timestamp);
    
    function addWhitelist(address account) public onlyOwner returns(bool) {
        whitelistedAccounts[account] = true;
        Whitelisted(account);
    }
        
    function removeWhitelist(address account) public onlyOwner returns(bool) {
        whitelistedAccounts[account] = false;
        UnWhitelisted(account);
    }
    
    function toggle() external onlyOwner {
        whitelistToggle = true;
        ToggleWhitelist(msg.sender, now);
    }
    
    function untoggle() external onlyOwner {
        whitelistToggle = false;
        UntoggleWhitelist(msg.sender, now);
    }
    
    function isWhiteListed(address account) public view returns(bool){
        return whitelistedAccounts[account];
    }
    
}

// File: contracts/zeppelin-solidity-1.4/BasicToken.sol

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic, Pausable, Whitelist {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public whenNotPaused onlyWhitelisted(msg.sender, _to) returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

}

// File: contracts/zeppelin-solidity-1.4/ERC20.sol

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/zeppelin-solidity-1.4/StandardToken.sol

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused onlyWhitelisted(msg.sender, _to) returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  /**
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   */
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

contract BTCE is StandardToken {
  using SafeMath for uint256;

  string public name;
  string public symbol;
  uint256 public decimals;
  
  mapping (address => bool) burners;
  uint256 public totalBurned;
  
  function BTCE() public {
     name = "BTCERC-20";
     symbol = "BTCE";
     decimals = 8;
     totalSupply = 2100000000000000;
     totalBurned = 0;
     
     balances[msg.sender] = 2100000000000000;
  }
  
  event Burned(address indexed owner, uint256 indexed value, uint256 indexed timestamp);
  event AssignedBurner(address indexed burner, uint256 indexed timestamp);
  
  function addBurner(address _burner) public onlyOwner returns (bool) {
      require(burners[_burner] == false);
      burners[_burner] = true;
      
      AssignedBurner(_burner, now);
  }
  
  function burn(uint256 _amount) public returns (bool) {
      require(burners[msg.sender] == true);
      require(balances[msg.sender] >= _amount);
      
      balances[msg.sender] = balances[msg.sender].sub(_amount);
      totalSupply = totalSupply.sub(_amount);
      totalBurned = totalBurned.add(_amount);
      
      Burned(msg.sender, _amount, now);
  }

}