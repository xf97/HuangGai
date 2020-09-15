/**
 *Submitted for verification at Etherscan.io on 2020-08-18
*/

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

pragma solidity ^0.4.23;


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
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
   * @dev Allows the current owner to relinquish control of the contract.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.4.23;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol

pragma solidity ^0.4.23;


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

pragma solidity ^0.4.23;



/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender)
    public view returns (uint256);

  function transferFrom(address from, address to, uint256 value)
    public returns (bool);

  function approve(address spender, uint256 value) public returns (bool);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

// File: contracts/Pausable.sol

pragma solidity ^0.4.23;


/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable  {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused, "Is paused");
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused, "Is not paused");
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() public onlyOwner whenNotPaused {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() public onlyOwner whenPaused {
    paused = false;
    emit Unpause();
  }
}

// File: contracts/AtlantisSimpleSwapBridgeV2.sol

pragma solidity ^0.4.23;





// another one is ByzantineSimpleSwapBridge.
contract AtlantisSimpleSwapBridge is Ownable, Pausable {
    using SafeMath for uint256;

    mapping (address => bool) public supportedTokens;

    uint256 public swapCount;

    address public feeWallet;

    uint256 public feeRatio;    // default to 100, denominator is 10000

    /// Event created on initilizing token dex in source network.
    event TokenSwapped(
    uint256 indexed swapId, address from, bytes32 to, uint256 amount, address token, uint256 fee, uint256 srcNetwork, uint256 dstNetwork);

    event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);


    /// Constructor.
    constructor (
        address _feeWallet,
        uint256 _feeRatio
    ) public
    {
        feeWallet = _feeWallet;
        feeRatio = _feeRatio;
    }

    //users initial the exchange token with token method of "approveAndCall" in the source chain network
    //then invoke the following function in this contract
    //_amount include the fee token
    function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public whenNotPaused {

        require(supportedTokens[_token], "Not suppoted token.");
        require(msg.sender == _token, "Invalid msg sender for this tx.");

        uint256 swapAmount;
        uint256 dstNetwork;
        bytes32 receiver;

        // swapAmount - token amount
        // dstNetwork -  1:Atlantis 2: Byzantine
        // receiver - receiver address of target network
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize)
            swapAmount := mload(add(ptr, 164))
            dstNetwork := mload(add(ptr, 196))
            receiver :=  mload(add(ptr, 228))
        }

        require(swapAmount > 0, "Swap amount must be larger than zero.");

        uint256 requiredFee = querySwapFee(swapAmount);
        require(_amount >= swapAmount.add(requiredFee), "No enough of token amount are approved.");

        if(requiredFee > 0) {
            require(ERC20(_token).transferFrom(from, feeWallet, requiredFee), "Fee transfer failed.");
        }

        require(ERC20(_token).transferFrom(from, this, swapAmount), "Swap amount transfer failed.");

        emit TokenSwapped(swapCount, from, receiver, swapAmount, _token, requiredFee, 1, dstNetwork);
        
        swapCount = swapCount + 1;
    }

    function addSupportedToken(address _token) public onlyOwner {
        supportedTokens[_token] = true;
    }

    function removeSupportedToken(address _token) public onlyOwner {
        supportedTokens[_token] = false;
    }

    function changeFeeWallet(address _newFeeWallet) public onlyOwner {
        feeWallet = _newFeeWallet;
    }

    function changeFeeRatio(uint256 _feeRatio) public onlyOwner {
        feeRatio = _feeRatio;
    }

    function querySwapFee(uint256 _amount) public view returns (uint256) {
        uint256 requiredFee = feeRatio.mul(_amount).div(10000);

        return requiredFee;
    }

    function claimTokens(address _token) public onlyOwner {
        if (_token == 0x0) {
            address(msg.sender).transfer(address(this).balance);
            return;
        }

        ERC20 token = ERC20(_token);
        uint balance = token.balanceOf(this);
        token.transfer(address(msg.sender), balance);

        emit ClaimedTokens(_token, address(msg.sender), balance);
    }
}