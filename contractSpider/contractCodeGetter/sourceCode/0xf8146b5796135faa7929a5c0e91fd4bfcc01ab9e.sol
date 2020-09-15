/**
 *Submitted for verification at Etherscan.io on 2020-08-10
*/

// File: zos-lib/contracts/Initializable.sol

pragma solidity >=0.4.24 <0.6.0;


/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool wasInitializing = initializing;
    initializing = true;
    initialized = true;

    _;

    initializing = wasInitializing;
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    uint256 cs;
    assembly { cs := extcodesize(address) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

// File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.4.24;


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender)
    external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value)
    external returns (bool);

  function transferFrom(address from, address to, uint256 value)
    external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

// File: openzeppelin-eth/contracts/token/ERC20/ERC20Detailed.sol

pragma solidity ^0.4.24;




/**
 * @title ERC20Detailed token
 * @dev The decimals are only for visualization purposes.
 * All the operations are done using the smallest and indivisible token unit,
 * just as on Ethereum all the operations are done in wei.
 */
contract ERC20Detailed is Initializable, IERC20 {
  string private _name;
  string private _symbol;
  uint8 private _decimals;

  function initialize(string name, string symbol, uint8 decimals) public initializer {
    _name = name;
    _symbol = symbol;
    _decimals = decimals;
  }

  /**
   * @return the name of the token.
   */
  function name() public view returns(string) {
    return _name;
  }

  /**
   * @return the symbol of the token.
   */
  function symbol() public view returns(string) {
    return _symbol;
  }

  /**
   * @return the number of decimals of the token.
   */
  function decimals() public view returns(uint8) {
    return _decimals;
  }

  uint256[50] private ______gap;
}

// File: openzeppelin-eth/contracts/math/SafeMath.sol

pragma solidity ^0.4.24;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

// File: openzeppelin-eth/contracts/token/ERC20/ERC20.sol

pragma solidity ^0.4.24;





/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract ERC20 is Initializable, IERC20 {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowed;

  uint256 private _totalSupply;

  /**
  * @dev Total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address owner) public view returns (uint256) {
    return _balances[owner];
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param owner address The address which owns the funds.
   * @param spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(
    address owner,
    address spender
   )
    public
    view
    returns (uint256)
  {
    return _allowed[owner][spender];
  }

  /**
  * @dev Transfer token for a specified address
  * @param to The address to transfer to.
  * @param value The amount to be transferred.
  */
  function transfer(address to, uint256 value) public returns (bool) {
    _transfer(msg.sender, to, value);
    return true;
  }

/**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

  /**
   * @dev Transfer tokens from one address to another
   * @param from address The address which you want to send tokens from
   * @param to address The address which you want to transfer to
   * @param value uint256 the amount of tokens to be transferred
   */
  function transferFrom(
    address from,
    address to,
    uint256 value
  )
    public
    returns (bool)
  {    
    _transfer(from, to, value);
    _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
    return true;
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed_[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param spender The address which will spend the funds.
   * @param addedValue The amount of tokens to increase the allowance by.
   */
  function increaseAllowance(
    address spender,
    uint256 addedValue
  )
    public
    returns (bool)
  {
    _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed_[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param spender The address which will spend the funds.
   * @param subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseAllowance(
    address spender,
    uint256 subtractedValue
  )
    public
    returns (bool)
  {
    _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
    return true;
  }

  /**
  * @dev Transfer token for a specified addresses
  * @param from The address to transfer from.
  * @param to The address to transfer to.
  * @param value The amount to be transferred.
  */
  function _transfer(address from, address to, uint256 value) internal {
    require(value <= _balances[from]);
    require(to != address(0));

    _balances[from] = _balances[from].sub(value);
    _balances[to] = _balances[to].add(value);
    emit Transfer(from, to, value);
  }

  /**
   * @dev Internal function that mints an amount of the token and assigns it to
   * an account. This encapsulates the modification of balances such that the
   * proper events are emitted.
   * @param account The account that will receive the created tokens.
   * @param amount The amount that will be created.
   */
  function _mint(address account, uint256 amount) internal {
    require(account != 0);
    _totalSupply = _totalSupply.add(amount);
    _balances[account] = _balances[account].add(amount);
    emit Transfer(address(0), account, amount);
  }

  /**
   * @dev Internal function that burns an amount of the token of a given
   * account.
   * @param account The account whose tokens will be burnt.
   * @param amount The amount that will be burnt.
   */
  function _burn(address account, uint256 amount) internal {
    require(account != 0);
    require(amount <= _balances[account]);

    _totalSupply = _totalSupply.sub(amount);
    _balances[account] = _balances[account].sub(amount);
    emit Transfer(account, address(0), amount);
  }

  /**
     * @dev Approve an address to spend another addresses' tokens.
     * @param owner The address that owns the tokens.
     * @param spender The address that will spend the tokens.
     * @param value The number of tokens that can be spent.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(spender != address(0));
        require(owner != address(0));

        _allowed[owner][spender] = value;
        emit Approval(owner, spender, value);
    }
  /**
   * @dev Internal function that burns an amount of the token of a given
   * account, deducting from the sender's allowance for said account. Uses the
   * internal burn function.
   * @param account The account whose tokens will be burnt.
   * @param value The amount that will be burnt.
   */
  function _burnFrom(address account, uint256 value) internal {    
    _burn(account, value);
    _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
  }

  uint256[50] private ______gap;
}

// File: contracts/token/PropsTimeBasedTransfers.sol

pragma solidity ^0.4.24;



/**
 * @title Props Time Based Transfers
 * @dev Contract allows to set a transfer start time (unix timestamp) from which transfers are allowed excluding one address defined in initialize
 **/
contract PropsTimeBasedTransfers is Initializable, ERC20 {
    uint256 public transfersStartTime;
    address public canTransferBeforeStartTime;
    /**
    Contract logic is no longer relevant.
    Leaving in the variables used for upgrade compatibility but the checks are no longer required
    */

    // modifier canTransfer(address _account)
    // {
    //     require(
    //         now > transfersStartTime ||
    //         _account==canTransferBeforeStartTime,
    //         "Cannot transfer before transfers start time from this account"
    //     );
    //     _;
    // }

    // /**
    // * @dev The initializer function, with transfers start time `transfersStartTime` (unix timestamp)
    // * and `canTransferBeforeStartTime` address which is exempt from start time restrictions
    // * @param start uint Unix timestamp of when transfers can start
    // * @param account uint256 address exempt from the start date check
    // */
    // function initialize(
    //     uint256 start,
    //     address account
    // )
    //     public
    //     initializer
    // {
    //     transfersStartTime = start;
    //     canTransferBeforeStartTime = account;
    // }
    // /**
    // * @dev Transfer token for a specified address if allowed
    // * @param to The address to transfer to.
    // * @param value The amount to be transferred.
    // */
    // function transfer(
    //     address to,
    //     uint256 value
    // )
    // public canTransfer(msg.sender)
    // returns (bool)
    // {
    //     return super.transfer(to, value);
    // }

    // /**
    //  * @dev Transfer tokens from one address to another if allowed
    //  * Note that while this function emits an Approval event, this is not required as per the specification,
    //  * and other compliant implementations may not emit the event.
    //  * @param from address The address which you want to send tokens from
    //  * @param to address The address which you want to transfer to
    //  * @param value uint256 the amount of tokens to be transferred
    //  */
    // function transferFrom(
    //     address from,
    //     address to,
    //     uint256 value
    // )
    // public canTransfer(from)
    // returns (bool)
    // {
    //     return super.transferFrom(from, to, value);
    // }
}

// File: openzeppelin-eth/contracts/cryptography/ECDSA.sol

pragma solidity ^0.4.24;


/**
 * @title Elliptic curve signature operations
 * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
 * TODO Remove this library once solidity supports passing a signature to ecrecover.
 * See https://github.com/ethereum/solidity/issues/864
 */

library ECDSA {

  /**
   * @dev Recover signer address from a message by using their signature
   * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
   * @param signature bytes signature, the signature is generated using web3.eth.sign()
   */
  function recover(bytes32 hash, bytes signature)
    internal
    pure
    returns (address)
  {
    bytes32 r;
    bytes32 s;
    uint8 v;

    // Check the signature length
    if (signature.length != 65) {
      return (address(0));
    }

    // Divide the signature in r, s and v variables
    // ecrecover takes the signature parameters, and the only way to get them
    // currently is to use assembly.
    // solium-disable-next-line security/no-inline-assembly
    assembly {
      r := mload(add(signature, 32))
      s := mload(add(signature, 64))
      v := byte(0, mload(add(signature, 96)))
    }

    // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
    if (v < 27) {
      v += 27;
    }

    // If the version is correct return the signer address
    if (v != 27 && v != 28) {
      return (address(0));
    } else {
      // solium-disable-next-line arg-overflow
      return ecrecover(hash, v, r, s);
    }
  }

  /**
   * toEthSignedMessageHash
   * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
   * and hash the result
   */
  function toEthSignedMessageHash(bytes32 hash)
    internal
    pure
    returns (bytes32)
  {
    // 32 is the length in bytes of hash,
    // enforced by the type signature above
    return keccak256(
      abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
    );
  }
}

// File: contracts/token/IERC865.sol

pragma solidity ^0.4.24;

/**
 * @title ERC865 Interface
 * @dev see https://github.com/ethereum/EIPs/issues/865
 *
 */

contract IERC865 {

    event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
    event ApprovalPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);

    function transferPreSigned(
        bytes _signature,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
    )
        public
        returns (bool);

    function approvePreSigned(
        bytes _signature,
        address _spender,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
    )
        public
        returns (bool);

    function increaseAllowancePreSigned(
        bytes _signature,
        address _spender,
        uint256 _addedValue,
        uint256 _fee,
        uint256 _nonce
    )
        public
        returns (bool);

    function decreaseAllowancePreSigned(
        bytes _signature,
        address _spender,
        uint256 _subtractedValue,
        uint256 _fee,
        uint256 _nonce
    )
        public
        returns (bool);

    function transferFromPreSigned(
        bytes _signature,
        address _from,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
    )
        public
        returns (bool);
}

// File: contracts/token/ERC865Token.sol

pragma solidity ^0.4.24;





/**
 * @title ERC865Token Token
 *
 * ERC865Token allows users paying transfers in tokens instead of gas
 * https://github.com/ethereum/EIPs/issues/865
 *
 */

contract ERC865Token is Initializable, ERC20, IERC865 {

    /* hashed tx of transfers performed */
    mapping(bytes32 => bool) hashedTxs;
    /**
     * @dev Submit a presigned transfer
     * @notice fee will be given to sender if it's a smart contract make sure it can accept funds
     * @param _signature bytes The signature, issued by the owner.
     * @param _to address The address which you want to transfer to.
     * @param _value uint256 The amount of tokens to be transferred.
     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
     * @param _nonce uint256 Presigned transaction number.
     */
    function transferPreSigned(
        bytes _signature,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
    )
        public
        returns (bool)
    {
        require(_to != address(0), "Invalid _to address");

        bytes32 hashedParams = getTransferPreSignedHash(address(this), _to, _value, _fee, _nonce);
        address from = ECDSA.recover(hashedParams, _signature);
        require(from != address(0), "Invalid from address recovered");
        bytes32 hashedTx = keccak256(abi.encodePacked(from, hashedParams));
        require(hashedTxs[hashedTx] == false,"Transaction hash was already used");
        hashedTxs[hashedTx] = true;
        _transfer(from, _to, _value);
        _transfer(from, msg.sender, _fee);

        emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
        return true;
    }

    /**
     * @dev Submit a presigned approval
     * @notice fee will be given to sender if it's a smart contract make sure it can accept funds
     * @param _signature bytes The signature, issued by the owner.
     * @param _spender address The address which will spend the funds.
     * @param _value uint256 The amount of tokens to allow.
     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
     * @param _nonce uint256 Presigned transaction number.
     */
    function approvePreSigned(
        bytes _signature,
        address _spender,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
    )
        public
        returns (bool)
    {
        require(_spender != address(0),"Invalid _spender address");

        bytes32 hashedParams = getApprovePreSignedHash(address(this), _spender, _value, _fee, _nonce);
        address from = ECDSA.recover(hashedParams, _signature);
        require(from != address(0),"Invalid from address recovered");
        bytes32 hashedTx = keccak256(abi.encodePacked(from, hashedParams));
        require(hashedTxs[hashedTx] == false,"Transaction hash was already used");
        hashedTxs[hashedTx] = true;
        _approve(from, _spender, _value);
        _transfer(from, msg.sender, _fee);

        emit ApprovalPreSigned(from, _spender, msg.sender, _value, _fee);
        return true;
    }

    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     * @notice fee will be given to sender if it's a smart contract make sure it can accept funds
     * @param _signature bytes The signature, issued by the owner.
     * @param _spender address The address which will spend the funds.
     * @param _addedValue uint256 The amount of tokens to increase the allowance by.
     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
     * @param _nonce uint256 Presigned transaction number.
     */
    function increaseAllowancePreSigned(
        bytes _signature,
        address _spender,
        uint256 _addedValue,
        uint256 _fee,
        uint256 _nonce
    )
        public
        returns (bool)
    {
        require(_spender != address(0),"Invalid _spender address");

        bytes32 hashedParams = getIncreaseAllowancePreSignedHash(address(this), _spender, _addedValue, _fee, _nonce);
        address from = ECDSA.recover(hashedParams, _signature);
        require(from != address(0),"Invalid from address recovered");
        bytes32 hashedTx = keccak256(abi.encodePacked(from, hashedParams));
        require(hashedTxs[hashedTx] == false,"Transaction hash was already used");
        hashedTxs[hashedTx] = true;
        _approve(from, _spender, allowance(from, _spender).add(_addedValue));
        _transfer(from, msg.sender, _fee);

        emit ApprovalPreSigned(from, _spender, msg.sender, allowance(from, _spender), _fee);
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     * @notice fee will be given to sender if it's a smart contract make sure it can accept funds
     * @param _signature bytes The signature, issued by the owner
     * @param _spender address The address which will spend the funds.
     * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
     * @param _nonce uint256 Presigned transaction number.
     */
    function decreaseAllowancePreSigned(
        bytes _signature,
        address _spender,
        uint256 _subtractedValue,
        uint256 _fee,
        uint256 _nonce
    )
        public
        returns (bool)
    {
        require(_spender != address(0),"Invalid _spender address");

        bytes32 hashedParams = getDecreaseAllowancePreSignedHash(address(this), _spender, _subtractedValue, _fee, _nonce);
        address from = ECDSA.recover(hashedParams, _signature);
        require(from != address(0),"Invalid from address recovered");
        bytes32 hashedTx = keccak256(abi.encodePacked(from, hashedParams));
        require(hashedTxs[hashedTx] == false,"Transaction hash was already used");
        // if substractedValue is greater than allowance will fail as allowance is uint256
        hashedTxs[hashedTx] = true;
        _approve(from, _spender, allowance(from,_spender).sub(_subtractedValue));
        _transfer(from, msg.sender, _fee);

        emit ApprovalPreSigned(from, _spender, msg.sender, allowance(from, _spender), _fee);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another
     * @notice fee will be given to sender if it's a smart contract make sure it can accept funds
     * @param _signature bytes The signature, issued by the spender.
     * @param _from address The address which you want to send tokens from.
     * @param _to address The address which you want to transfer to.
     * @param _value uint256 The amount of tokens to be transferred.
     * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
     * @param _nonce uint256 Presigned transaction number.
     */
    function transferFromPreSigned(
        bytes _signature,
        address _from,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
    )
        public
        returns (bool)
    {
        require(_to != address(0),"Invalid _to address");

        bytes32 hashedParams = getTransferFromPreSignedHash(address(this), _from, _to, _value, _fee, _nonce);

        address spender = ECDSA.recover(hashedParams, _signature);
        require(spender != address(0),"Invalid spender address recovered");
        bytes32 hashedTx = keccak256(abi.encodePacked(spender, hashedParams));
        require(hashedTxs[hashedTx] == false,"Transaction hash was already used");
        hashedTxs[hashedTx] = true;
        _transfer(_from, _to, _value);
        _approve(_from, spender, allowance(_from, spender).sub(_value));
        _transfer(spender, msg.sender, _fee);

        emit TransferPreSigned(_from, _to, msg.sender, _value, _fee);
        return true;
    }


    /**
     * @dev Hash (keccak256) of the payload used by transferPreSigned
     * @notice fee will be given to sender if it's a smart contract make sure it can accept funds
     * @param _token address The address of the token.
     * @param _to address The address which you want to transfer to.
     * @param _value uint256 The amount of tokens to be transferred.
     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
     * @param _nonce uint256 Presigned transaction number.
     */
    function getTransferPreSignedHash(
        address _token,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
    )
        public
        pure
        returns (bytes32)
    {
        /* "0d98dcb1": getTransferPreSignedHash(address,address,uint256,uint256,uint256) */
        return keccak256(abi.encodePacked(bytes4(0x0d98dcb1), _token, _to, _value, _fee, _nonce));
    }

    /**
     * @dev Hash (keccak256) of the payload used by approvePreSigned
     * @notice fee will be given to sender if it's a smart contract make sure it can accept funds
     * @param _token address The address of the token
     * @param _spender address The address which will spend the funds.
     * @param _value uint256 The amount of tokens to allow.
     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
     * @param _nonce uint256 Presigned transaction number.
     */
    function getApprovePreSignedHash(
        address _token,
        address _spender,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
    )
        public
        pure
        returns (bytes32)
    {
        /* "79250dcf": getApprovePreSignedHash(address,address,uint256,uint256,uint256) */
        return keccak256(abi.encodePacked(bytes4(0x79250dcf), _token, _spender, _value, _fee, _nonce));
    }

    /**
     * @dev Hash (keccak256) of the payload used by increaseAllowancePreSigned
     * @notice fee will be given to sender if it's a smart contract make sure it can accept funds
     * @param _token address The address of the token
     * @param _spender address The address which will spend the funds.
     * @param _addedValue uint256 The amount of tokens to increase the allowance by.
     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
     * @param _nonce uint256 Presigned transaction number.
     */
    function getIncreaseAllowancePreSignedHash(
        address _token,
        address _spender,
        uint256 _addedValue,
        uint256 _fee,
        uint256 _nonce
    )
        public
        pure
        returns (bytes32)
    {
        /* "138e8da1": getIncreaseAllowancePreSignedHash(address,address,uint256,uint256,uint256) */
        return keccak256(abi.encodePacked(bytes4(0x138e8da1), _token, _spender, _addedValue, _fee, _nonce));
    }

     /**
      * @dev Hash (keccak256) of the payload used by decreaseAllowancePreSigned
      * @notice fee will be given to sender if it's a smart contract make sure it can accept funds
      * @param _token address The address of the token
      * @param _spender address The address which will spend the funds.
      * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
      * @param _nonce uint256 Presigned transaction number.
      */
    function getDecreaseAllowancePreSignedHash(
        address _token,
        address _spender,
        uint256 _subtractedValue,
        uint256 _fee,
        uint256 _nonce
    )
        public
        pure
        returns (bytes32)
    {
        /* "5229c56f": getDecreaseAllowancePreSignedHash(address,address,uint256,uint256,uint256) */
        return keccak256(abi.encodePacked(bytes4(0x5229c56f), _token, _spender, _subtractedValue, _fee, _nonce));
    }

    /**
     * @dev Hash (keccak256) of the payload used by transferFromPreSigned
     * @notice fee will be given to sender if it's a smart contract make sure it can accept funds
     * @param _token address The address of the token
     * @param _from address The address which you want to send tokens from.
     * @param _to address The address which you want to transfer to.
     * @param _value uint256 The amount of tokens to be transferred.
     * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
     * @param _nonce uint256 Presigned transaction number.
     */
    function getTransferFromPreSignedHash(
        address _token,
        address _from,
        address _to,
        uint256 _value,
        uint256 _fee,
        uint256 _nonce
    )
        public
        pure
        returns (bytes32)
    {
        /* "a70c41b4": getTransferFromPreSignedHash(address,address,address,uint256,uint256,uint256) */
        return keccak256(abi.encodePacked(bytes4(0xa70c41b4), _token, _from, _to, _value, _fee, _nonce));
    }
}

// File: contracts/token/PropsRewardsLib.sol

pragma solidity ^0.4.24;


/**
 * @title Props Rewards Library
 * @dev Library to manage application and validators and parameters
 **/
library PropsRewardsLib {
    using SafeMath for uint256;
    /*
    *  Events
    */

    /*
    *  Storage
    */

    // The various parameters used by the contract
    enum ParameterName { ApplicationRewardsPercent, ApplicationRewardsMaxVariationPercent, ValidatorMajorityPercent, ValidatorRewardsPercent}
    enum RewardedEntityType { Application, Validator }

    // Represents a parameter current, previous and time of change
    struct Parameter {
        uint256 currentValue;                   // current value in Pphm valid after timestamp
        uint256 previousValue;                  // previous value in Pphm for use before timestamp
        uint256 rewardsDay;                     // timestamp of when the value was updated
    }
    // Represents application details
    struct RewardedEntity {
        bytes32 name;                           // Application name
        address rewardsAddress;                 // address where rewards will be minted to
        address sidechainAddress;               // address used on the sidechain
        bool isInitializedState;                // A way to check if there's something in the map and whether it is already added to the list
        RewardedEntityType entityType;          // Type of rewarded entity
    }

    // Represents validators current and previous lists
    struct RewardedEntityList {
        mapping (address => bool) current;
        mapping (address => bool) previous;
        address[] currentList;
        address[] previousList;
        uint256 rewardsDay;
    }

    // Represents daily rewards submissions and confirmations
    struct DailyRewards {
        mapping (bytes32 => Submission) submissions;
        bytes32[] submittedRewardsHashes;
        uint256 totalSupply;
        bytes32 lastConfirmedRewardsHash;
        uint256 lastApplicationsRewardsDay;
    }

    struct Submission {
        mapping (address => bool) validators;
        address[] validatorsList;
        uint256 confirmations;
        uint256 finalizedStatus;               // 0 - initialized, 1 - finalized
        bool isInitializedState;               // A way to check if there's something in the map and whether it is already added to the list
    }


    // represent the storage structures
    struct Data {
        // applications data
        mapping (address => RewardedEntity) applications;
        address[] applicationsList;
        // validators data
        mapping (address => RewardedEntity) validators;
        address[] validatorsList;
        // adjustable parameters data
        mapping (uint256 => Parameter) parameters; // uint256 is the parameter enum index
        // the participating validators
        RewardedEntityList selectedValidators;
        // the participating applications
        RewardedEntityList selectedApplications;
        // daily rewards submission data
        DailyRewards dailyRewards;
        uint256 minSecondsBetweenDays;
        uint256 rewardsStartTimestamp;
        uint256 maxTotalSupply;
        uint256 lastValidatorsRewardsDay;
    }
    /*
    *  Modifiers
    */
    modifier onlyOneConfirmationPerValidatorPerRewardsHash(Data storage _self, bytes32 _rewardsHash) {
        require(
            !_self.dailyRewards.submissions[_rewardsHash].validators[msg.sender],
            "Must be one submission per validator"
        );
         _;
    }

    modifier onlyExistingApplications(Data storage _self, address[] _entities) {
        for (uint256 i = 0; i < _entities.length; i++) {
            require(
                _self.applications[_entities[i]].isInitializedState,
                "Application must exist"
            );
        }
        _;
    }

    modifier onlyExistingValidators(Data storage _self, address[] _entities) {
        for (uint256 i = 0; i < _entities.length; i++) {
            require(
                _self.validators[_entities[i]].isInitializedState,
                "Validator must exist"
            );
        }
        _;
    }

    modifier onlySelectedValidators(Data storage _self, uint256 _rewardsDay) {
        if (!_usePreviousSelectedRewardsEntityList(_self.selectedValidators, _rewardsDay)) {
            require (
                _self.selectedValidators.current[msg.sender],
                "Must be a current selected validator"
            );
        } else {
            require (
                _self.selectedValidators.previous[msg.sender],
                "Must be a previous selected validator"
            );
        }
        _;
    }

    modifier onlyValidRewardsDay(Data storage _self, uint256 _rewardsDay) {
        require(
            _currentRewardsDay(_self) > _rewardsDay && _rewardsDay > _self.lastValidatorsRewardsDay,
            "Must be for a previous day but after the last rewards day"
        );
         _;
    }

    modifier onlyValidFutureRewardsDay(Data storage _self, uint256 _rewardsDay) {
        require(
            _rewardsDay >= _currentRewardsDay(_self),
            "Must be future rewardsDay"
        );
         _;
    }

    modifier onlyValidAddresses(address _rewardsAddress, address _sidechainAddress) {
        require(
            _rewardsAddress != address(0) &&
            _sidechainAddress != address(0),
            "Must have valid rewards and sidechain addresses"
        );
        _;
    }

    /**
    * @dev The function is called by validators with the calculation of the daily rewards
    * @param _self Data pointer to storage
    * @param _rewardsDay uint256 the rewards day
    * @param _rewardsHash bytes32 hash of the rewards data
    * @param _allValidators bool should the calculation be based on all the validators or just those which submitted
    */
    function calculateValidatorRewards(
        Data storage _self,
        uint256 _rewardsDay,
        bytes32 _rewardsHash,
        bool _allValidators
    )
        public
        view
        returns (uint256)
    {
        uint256 numOfValidators;
        if (_self.dailyRewards.submissions[_rewardsHash].finalizedStatus == 1)
        {
            if (_allValidators) {
                numOfValidators = _requiredValidatorsForValidatorsRewards(_self, _rewardsDay);
                if (numOfValidators > _self.dailyRewards.submissions[_rewardsHash].confirmations) return 0;
            } else {
                numOfValidators = _self.dailyRewards.submissions[_rewardsHash].confirmations;
            }
            uint256 rewardsPerValidator = _getValidatorRewardsDailyAmountPerValidator(_self, _rewardsDay, numOfValidators);
            return rewardsPerValidator;
        }
        return 0;
    }

    /**
    * @dev The function is called by validators with the calculation of the daily rewards
    * @param _self Data pointer to storage
    * @param _rewardsDay uint256 the rewards day
    * @param _rewardsHash bytes32 hash of the rewards data
    * @param _applications address[] array of application addresses getting the daily reward
    * @param _amounts uint256[] array of amounts each app should get
    * @param _currentTotalSupply uint256 current total supply
    */
    function calculateAndFinalizeApplicationRewards(
        Data storage _self,
        uint256 _rewardsDay,
        bytes32 _rewardsHash,
        address[] _applications,
        uint256[] _amounts,
        uint256 _currentTotalSupply
    )
        public
        onlyValidRewardsDay(_self, _rewardsDay)
        onlyOneConfirmationPerValidatorPerRewardsHash(_self, _rewardsHash)
        onlySelectedValidators(_self, _rewardsDay)
        returns (uint256)
    {
        require(
                _rewardsHashIsValid(_self, _rewardsDay, _rewardsHash, _applications, _amounts),
                "Rewards Hash is invalid"
        );
        if (!_self.dailyRewards.submissions[_rewardsHash].isInitializedState) {
            _self.dailyRewards.submissions[_rewardsHash].isInitializedState = true;
            _self.dailyRewards.submittedRewardsHashes.push(_rewardsHash);
        }
        _self.dailyRewards.submissions[_rewardsHash].validators[msg.sender] = true;
        _self.dailyRewards.submissions[_rewardsHash].validatorsList.push(msg.sender);
        _self.dailyRewards.submissions[_rewardsHash].confirmations++;

        if (_self.dailyRewards.submissions[_rewardsHash].confirmations == _requiredValidatorsForAppRewards(_self, _rewardsDay)) {
            uint256 sum = _validateSubmittedData(_self, _applications, _amounts);
            require(
                sum <= _getMaxAppRewardsDailyAmount(_self, _rewardsDay, _currentTotalSupply),
                "Rewards data is invalid - exceed daily variation"
            );
            _finalizeDailyApplicationRewards(_self, _rewardsDay, _rewardsHash, _currentTotalSupply);
            return sum;
        }
        return 0;
    }

    /**
    * @dev Finalizes the state, rewards Hash, total supply and block timestamp for the day
    * @param _self Data pointer to storage
    * @param _rewardsDay uint256 the rewards day
    * @param _rewardsHash bytes32 the daily rewards hash
    * @param _currentTotalSupply uint256 the current total supply
    */
    function _finalizeDailyApplicationRewards(Data storage _self, uint256 _rewardsDay, bytes32 _rewardsHash, uint256 _currentTotalSupply)
        public
    {
        _self.dailyRewards.totalSupply = _currentTotalSupply;
        _self.dailyRewards.lastConfirmedRewardsHash = _rewardsHash;
        _self.dailyRewards.lastApplicationsRewardsDay = _rewardsDay;
        _self.dailyRewards.submissions[_rewardsHash].finalizedStatus = 1;
    }

    /**
    * @dev Get parameter's value
    * @param _self Data pointer to storage
    * @param _name ParameterName name of the parameter
    * @param _rewardsDay uint256 the rewards day
    */
    function getParameterValue(
        Data storage _self,
        ParameterName _name,
        uint256 _rewardsDay
    )
        public
        view
        returns (uint256)
    {
        if (_rewardsDay >= _self.parameters[uint256(_name)].rewardsDay) {
            return _self.parameters[uint256(_name)].currentValue;
        } else {
            return _self.parameters[uint256(_name)].previousValue;
        }
    }

    /**
    * @dev Allows the controller/owner to update rewards parameters
    * @param _self Data pointer to storage
    * @param _name ParameterName name of the parameter
    * @param _value uint256 new value for the parameter
    * @param _rewardsDay uint256 the rewards day
    */
    function updateParameter(
        Data storage _self,
        ParameterName _name,
        uint256 _value,
        uint256 _rewardsDay
    )
        public
        onlyValidFutureRewardsDay(_self, _rewardsDay)
    {
        if (_rewardsDay <= _self.parameters[uint256(_name)].rewardsDay) {
           _self.parameters[uint256(_name)].currentValue = _value;
           _self.parameters[uint256(_name)].rewardsDay = _rewardsDay;
        } else {
            _self.parameters[uint256(_name)].previousValue = _self.parameters[uint256(_name)].currentValue;
            _self.parameters[uint256(_name)].currentValue = _value;
           _self.parameters[uint256(_name)].rewardsDay = _rewardsDay;
        }
    }

    /**
    * @dev Allows an application to add/update its details
    * @param _self Data pointer to storage
    * @param _entityType RewardedEntityType either application (0) or validator (1)
    * @param _name bytes32 name of the app
    * @param _rewardsAddress address an address for the app to receive the rewards
    * @param _sidechainAddress address the address used for using the sidechain
    */
    function updateEntity(
        Data storage _self,
        RewardedEntityType _entityType,
        bytes32 _name,
        address _rewardsAddress,
        address _sidechainAddress
    )
        public
        onlyValidAddresses(_rewardsAddress, _sidechainAddress)
    {
        if (_entityType == RewardedEntityType.Application) {
            updateApplication(_self, _name, _rewardsAddress, _sidechainAddress);
        } else {
            updateValidator(_self, _name, _rewardsAddress, _sidechainAddress);
        }
    }

    /**
    * @dev Allows an application to add/update its details
    * @param _self Data pointer to storage
    * @param _name bytes32 name of the app
    * @param _rewardsAddress address an address for the app to receive the rewards
    * @param _sidechainAddress address the address used for using the sidechain
    */
    function updateApplication(
        Data storage _self,
        bytes32 _name,
        address _rewardsAddress,
        address _sidechainAddress
    )
        public
        returns (uint256)
    {
        _self.applications[msg.sender].name = _name;
        _self.applications[msg.sender].rewardsAddress = _rewardsAddress;
        _self.applications[msg.sender].sidechainAddress = _sidechainAddress;
        if (!_self.applications[msg.sender].isInitializedState) {
            _self.applicationsList.push(msg.sender);
            _self.applications[msg.sender].isInitializedState = true;
            _self.applications[msg.sender].entityType = RewardedEntityType.Application;
        }
        return uint256(RewardedEntityType.Application);
    }

    /**
    * @dev Allows a validator to add/update its details
    * @param _self Data pointer to storage
    * @param _name bytes32 name of the validator
    * @param _rewardsAddress address an address for the validator to receive the rewards
    * @param _sidechainAddress address the address used for using the sidechain
    */
    function updateValidator(
        Data storage _self,
        bytes32 _name,
        address _rewardsAddress,
        address _sidechainAddress
    )
        public
        returns (uint256)
    {
        _self.validators[msg.sender].name = _name;
        _self.validators[msg.sender].rewardsAddress = _rewardsAddress;
        _self.validators[msg.sender].sidechainAddress = _sidechainAddress;
        if (!_self.validators[msg.sender].isInitializedState) {
            _self.validatorsList.push(msg.sender);
            _self.validators[msg.sender].isInitializedState = true;
            _self.validators[msg.sender].entityType = RewardedEntityType.Validator;
        }
        return uint256(RewardedEntityType.Validator);
    }

    /**
    * @dev Set new validators list
    * @param _self Data pointer to storage
    * @param _rewardsDay uint256 the rewards day from which the list should be active
    * @param _validators address[] array of validators
    */
    function setValidators(
        Data storage _self,
        uint256 _rewardsDay,
        address[] _validators
    )
        public
        onlyValidFutureRewardsDay(_self, _rewardsDay)
        onlyExistingValidators(_self, _validators)
    {
        // no need to update the previous if its' the first time or second update in the same day
        if (_rewardsDay > _self.selectedValidators.rewardsDay && _self.selectedValidators.currentList.length > 0)
            _updatePreviousEntityList(_self.selectedValidators);

        _updateCurrentEntityList(_self.selectedValidators, _validators);
        _self.selectedValidators.rewardsDay = _rewardsDay;
    }

   /**
    * @dev Set new applications list
    * @param _self Data pointer to storage
    * @param _rewardsDay uint256 the rewards day from which the list should be active
    * @param _applications address[] array of applications
    */
    function setApplications(
        Data storage _self,
        uint256 _rewardsDay,
        address[] _applications
    )
        public
        onlyValidFutureRewardsDay(_self, _rewardsDay)
        onlyExistingApplications(_self, _applications)
    {

        if (_rewardsDay > _self.selectedApplications.rewardsDay && _self.selectedApplications.currentList.length > 0)
                _updatePreviousEntityList(_self.selectedApplications);
        _updateCurrentEntityList(_self.selectedApplications, _applications);
        _self.selectedApplications.rewardsDay = _rewardsDay;
    }

    /**
    * @dev Get applications or validators list
    * @param _self Data pointer to storage
    * @param _entityType RewardedEntityType either application (0) or validator (1)
    * @param _rewardsDay uint256 the rewards day to determine which list to get
    */
    function getEntities(
        Data storage _self,
        RewardedEntityType _entityType,
        uint256 _rewardsDay
    )
        public
        view
        returns (address[])
    {
        if (_entityType == RewardedEntityType.Application) {
            if (!_usePreviousSelectedRewardsEntityList(_self.selectedApplications, _rewardsDay)) {
                return _self.selectedApplications.currentList;
            } else {
                return _self.selectedApplications.previousList;
            }
        } else {
            if (!_usePreviousSelectedRewardsEntityList(_self.selectedValidators, _rewardsDay)) {
                return _self.selectedValidators.currentList;
            } else {
                return _self.selectedValidators.previousList;
            }
        }
    }

    /**
    * @dev Get which entity list to use. If true use previous if false use current
    * @param _rewardedEntitylist RewardedEntityList pointer to storage
    * @param _rewardsDay uint256 the rewards day to determine which list to get
    */
    function _usePreviousSelectedRewardsEntityList(RewardedEntityList _rewardedEntitylist, uint256 _rewardsDay)
        internal
        pure
        returns (bool)
    {
        if (_rewardsDay >= _rewardedEntitylist.rewardsDay) {
            return false;
        } else {
            return true;
        }
    }

    /**
    * @dev Checks how many validators are needed for app rewards
    * @param _self Data pointer to storage
    * @param _rewardsDay uint256 the rewards day
    * @param _currentTotalSupply uint256 current total supply
    */
    function _getMaxAppRewardsDailyAmount(
        Data storage _self,
        uint256 _rewardsDay,
        uint256 _currentTotalSupply
    )
        public
        view
        returns (uint256)
    {
        return ((_self.maxTotalSupply.sub(_currentTotalSupply)).mul(
        getParameterValue(_self, ParameterName.ApplicationRewardsPercent, _rewardsDay)).mul(
        getParameterValue(_self, ParameterName.ApplicationRewardsMaxVariationPercent, _rewardsDay))).div(1e16);
    }


    /**
    * @dev Checks how many validators are needed for app rewards
    * @param _self Data pointer to storage
    * @param _rewardsDay uint256 the rewards day
    * @param _numOfValidators uint256 number of validators
    */
    function _getValidatorRewardsDailyAmountPerValidator(
        Data storage _self,
        uint256 _rewardsDay,
        uint256 _numOfValidators
    )
        public
        view
        returns (uint256)
    {
        return (((_self.maxTotalSupply.sub(_self.dailyRewards.totalSupply)).mul(
        getParameterValue(_self, ParameterName.ValidatorRewardsPercent, _rewardsDay))).div(1e8)).div(_numOfValidators);
    }

    /**
    * @dev Checks if app daily rewards amount is valid
    * @param _self Data pointer to storage
    * @param _applications address[] array of application addresses getting the daily rewards
    * @param _amounts uint256[] array of amounts each app should get
    */
    function _validateSubmittedData(
        Data storage _self,
        address[] _applications,
        uint256[] _amounts
    )
        public
        view
        returns (uint256)
    {
        uint256 sum;
        bool valid = true;
        for (uint256 i = 0; i < _amounts.length; i++) {
            sum = sum.add(_amounts[i]);
            if (!_self.applications[_applications[i]].isInitializedState) valid = false;
        }
        require(
                sum > 0 && valid,
                "Sum zero or none existing app submitted"
        );
        return sum;
    }

    /**
    * @dev Checks if submitted data matches rewards hash
    * @param _rewardsDay uint256 the rewards day
    * @param _rewardsHash bytes32 hash of the rewards data
    * @param _applications address[] array of application addresses getting the daily rewards
    * @param _amounts uint256[] array of amounts each app should get
    */
    function _rewardsHashIsValid(
        Data storage _self,
        uint256 _rewardsDay,
        bytes32 _rewardsHash,
        address[] _applications,
        uint256[] _amounts
    )
        public
        view
        returns (bool)
    {
        bool nonActiveApplication = false;
        if (!_usePreviousSelectedRewardsEntityList(_self.selectedApplications, _rewardsDay)) {
            for (uint256 i = 0; i < _applications.length; i++) {
                if (!_self.selectedApplications.current[_applications[i]]) {
                    nonActiveApplication = true;
                }
            }
        } else {
            for (uint256 j = 0; j < _applications.length; j++) {
                if (!_self.selectedApplications.previous[_applications[j]]) {
                    nonActiveApplication = true;
                }
            }
        }
        return
            _applications.length > 0 &&
            _applications.length == _amounts.length &&
            !nonActiveApplication &&
            keccak256(abi.encodePacked(_rewardsDay, _applications.length, _amounts.length, _applications, _amounts)) == _rewardsHash;
    }

    /**
    * @dev Checks how many validators are needed for app rewards
    * @param _self Data pointer to storage
    * @param _rewardsDay uint256 the rewards day
    */
    function _requiredValidatorsForValidatorsRewards(Data storage _self, uint256 _rewardsDay)
        public
        view
        returns (uint256)
    {
        if (!_usePreviousSelectedRewardsEntityList(_self.selectedValidators, _rewardsDay)) {
            return _self.selectedValidators.currentList.length;
        } else {
            return _self.selectedValidators.previousList.length;
        }
    }

    /**
    * @dev Checks how many validators are needed for app rewards
    * @param _self Data pointer to storage
    * @param _rewardsDay uint256 the rewards day
    */
    function _requiredValidatorsForAppRewards(Data storage _self, uint256 _rewardsDay)
        public
        view
        returns (uint256)
    {
        if (!_usePreviousSelectedRewardsEntityList(_self.selectedValidators, _rewardsDay)) {
            return ((_self.selectedValidators.currentList.length.mul(getParameterValue(_self, ParameterName.ValidatorMajorityPercent, _rewardsDay))).div(1e8)).add(1);
        } else {
            return ((_self.selectedValidators.previousList.length.mul(getParameterValue(_self, ParameterName.ValidatorMajorityPercent, _rewardsDay))).div(1e8)).add(1);
        }
    }

    /**
    * @dev Get rewards day from block.timestamp
    * @param _self Data pointer to storage
    */
    function _currentRewardsDay(Data storage _self)
        public
        view
        returns (uint256)
    {
        //the the start time - floor timestamp to previous midnight divided by seconds in a day will give the rewards day number
       if (_self.minSecondsBetweenDays > 0) {
            return (block.timestamp.sub(_self.rewardsStartTimestamp)).div(_self.minSecondsBetweenDays).add(1);
        } else {
            return 0;
        }
    }

    /**
    * @dev Update current daily applications list.
    * If new, push.
    * If same size, replace
    * If different size, delete, and then push.
    * @param _rewardedEntitylist RewardedEntityList pointer to storage
    * @param _entities address[] array of entities
    */
    //_updateCurrentEntityList(_rewardedEntitylist, _entities,_rewardedEntityType),
    function _updateCurrentEntityList(
        RewardedEntityList storage _rewardedEntitylist,
        address[] _entities
    )
        internal
    {
        bool emptyCurrentList = _rewardedEntitylist.currentList.length == 0;
        if (!emptyCurrentList && _rewardedEntitylist.currentList.length != _entities.length) {
            _deleteCurrentEntityList(_rewardedEntitylist);
            emptyCurrentList = true;
        }

        for (uint256 i = 0; i < _entities.length; i++) {
            if (emptyCurrentList) {
                _rewardedEntitylist.currentList.push(_entities[i]);
            } else {
                _rewardedEntitylist.currentList[i] = _entities[i];
            }
            _rewardedEntitylist.current[_entities[i]] = true;
        }
    }

    /**
    * @dev Update previous daily list
    * @param _rewardedEntitylist RewardedEntityList pointer to storage
    */
    function _updatePreviousEntityList(RewardedEntityList storage _rewardedEntitylist)
        internal
    {
        bool emptyPreviousList = _rewardedEntitylist.previousList.length == 0;
        if (
            !emptyPreviousList &&
            _rewardedEntitylist.previousList.length != _rewardedEntitylist.currentList.length
        ) {
            _deletePreviousEntityList(_rewardedEntitylist);
            emptyPreviousList = true;
        }
        for (uint256 i = 0; i < _rewardedEntitylist.currentList.length; i++) {
            if (emptyPreviousList) {
                _rewardedEntitylist.previousList.push(_rewardedEntitylist.currentList[i]);
            } else {
                _rewardedEntitylist.previousList[i] = _rewardedEntitylist.currentList[i];
            }
            _rewardedEntitylist.previous[_rewardedEntitylist.currentList[i]] = true;
        }
    }

    /**
    * @dev Delete existing values from the current list
    * @param _rewardedEntitylist RewardedEntityList pointer to storage
    */
    function _deleteCurrentEntityList(RewardedEntityList storage _rewardedEntitylist)
        internal
    {
        for (uint256 i = 0; i < _rewardedEntitylist.currentList.length ; i++) {
             delete _rewardedEntitylist.current[_rewardedEntitylist.currentList[i]];
        }
        delete  _rewardedEntitylist.currentList;
    }

    /**
    * @dev Delete existing values from the previous applications list
    * @param _rewardedEntitylist RewardedEntityList pointer to storage
    */
    function _deletePreviousEntityList(RewardedEntityList storage _rewardedEntitylist)
        internal
    {
        for (uint256 i = 0; i < _rewardedEntitylist.previousList.length ; i++) {
            delete _rewardedEntitylist.previous[_rewardedEntitylist.previousList[i]];
        }
        delete _rewardedEntitylist.previousList;
    }

    /**
    * @dev Deletes rewards day submission data
    * @param _self Data pointer to storage
    * @param _rewardsHash bytes32 rewardsHash
    */
    function _resetDailyRewards(
        Data storage _self,
        bytes32 _rewardsHash
    )
        public
    {
         _self.lastValidatorsRewardsDay = _self.dailyRewards.lastApplicationsRewardsDay;
        for (uint256 j = 0; j < _self.dailyRewards.submissions[_rewardsHash].validatorsList.length; j++) {
            delete(
                _self.dailyRewards.submissions[_rewardsHash].validators[_self.dailyRewards.submissions[_rewardsHash].validatorsList[j]]
            );
        }
            delete _self.dailyRewards.submissions[_rewardsHash].validatorsList;
            _self.dailyRewards.submissions[_rewardsHash].confirmations = 0;
            _self.dailyRewards.submissions[_rewardsHash].finalizedStatus = 0;
            _self.dailyRewards.submissions[_rewardsHash].isInitializedState = false;
    }
}

// File: contracts/token/PropsRewards.sol

pragma solidity ^0.4.24;





/**
 * @title Props Rewards
 * @dev Contract allows to set approved apps and validators. Submit and mint rewards...
 **/
contract PropsRewards is Initializable, ERC20 {
    using SafeMath for uint256;
    /*
    *  Events
    */
    event DailyRewardsSubmitted(
        uint256 indexed rewardsDay,
        bytes32 indexed rewardsHash,
        address indexed validator
    );

    event DailyRewardsApplicationsMinted(
        uint256 indexed rewardsDay,
        bytes32 indexed rewardsHash,
        uint256 numOfApplications,
        uint256 amount
    );

    event DailyRewardsValidatorsMinted(
        uint256 indexed rewardsDay,
        bytes32 indexed rewardsHash,
        uint256 numOfValidators,
        uint256 amount
    );

    event EntityUpdated(
        address indexed id,
        PropsRewardsLib.RewardedEntityType indexed entityType,
        bytes32 name,
        address rewardsAddress,
        address indexed sidechainAddress
    );

    event ParameterUpdated(
        PropsRewardsLib.ParameterName param,
        uint256 newValue,
        uint256 oldValue,
        uint256 rewardsDay
    );

    event ValidatorsListUpdated(
        address[] validatorsList,
        uint256 indexed rewardsDay
    );

    event ApplicationsListUpdated(
        address[] applicationsList,
        uint256 indexed rewardsDay
    );

    event ControllerUpdated(address indexed newController);

    event Settlement(
        address indexed applicationId,
        bytes32 indexed userId,
        address indexed to,
        uint256 amount,
        address rewardsAddress
    );
    /*
    *  Storage
    */

    PropsRewardsLib.Data internal rewardsLibData;
    uint256 public maxTotalSupply;
    uint256 public rewardsStartTimestamp;
    address public controller; // controller entity

    /*
    *  Modifiers
    */
    modifier onlyController() {
        require(
            msg.sender == controller,
            "Must be the controller"
        );
        _;
    }

    /**
    * @dev The initializer function for upgrade as initialize was already called, get the decimals used in the token to initialize the params
    * @param _controller address that will have controller functionality on rewards protocol
    * @param _minSecondsBetweenDays uint256 seconds required to pass between consecutive rewards day
    * @param _rewardsStartTimestamp uint256 day 0 timestamp
    */
    function initializePostRewardsUpgrade1(
        address _controller,
        uint256 _minSecondsBetweenDays,
        uint256 _rewardsStartTimestamp
    )
        public
    {
        uint256 decimals = 18;
        _initializePostRewardsUpgrade1(_controller, decimals, _minSecondsBetweenDays, _rewardsStartTimestamp);
    }

    /**
    * @dev Set new validators list
    * @param _rewardsDay uint256 the rewards day from which this change should take effect
    * @param _validators address[] array of validators
    */
    function setValidators(uint256 _rewardsDay, address[] _validators)
        public
        onlyController
    {
        PropsRewardsLib.setValidators(rewardsLibData, _rewardsDay, _validators);
        emit ValidatorsListUpdated(_validators, _rewardsDay);
    }

    /**
    * @dev Set new applications list
    * @param _rewardsDay uint256 the rewards day from which this change should take effect
    * @param _applications address[] array of applications
    */
    function setApplications(uint256 _rewardsDay, address[] _applications)
        public
        onlyController
    {
        PropsRewardsLib.setApplications(rewardsLibData, _rewardsDay, _applications);
        emit ApplicationsListUpdated(_applications, _rewardsDay);
    }

    /**
    * @dev Get the applications or validators list
    * @param _entityType RewardedEntityType either application (0) or validator (1)
    * @param _rewardsDay uint256 the rewards day to use for this value
    */
    function getEntities(PropsRewardsLib.RewardedEntityType _entityType, uint256 _rewardsDay)
        public
        view
        returns (address[])
    {
        return PropsRewardsLib.getEntities(rewardsLibData, _entityType, _rewardsDay);
    }

    /**
    * @dev The function is called by validators with the calculation of the daily rewards
    * @param _rewardsDay uint256 the rewards day
    * @param _rewardsHash bytes32 hash of the rewards data
    * @param _applications address[] array of application addresses getting the daily reward
    * @param _amounts uint256[] array of amounts each app should get
    */
    function submitDailyRewards(
        uint256 _rewardsDay,
        bytes32 _rewardsHash,
        address[] _applications,
        uint256[] _amounts
    )
        public
    {
        // if submission is for a new day check if previous day validator rewards were given if not give to participating ones
        if (_rewardsDay > rewardsLibData.dailyRewards.lastApplicationsRewardsDay) {
            uint256 previousDayValidatorRewardsAmount = PropsRewardsLib.calculateValidatorRewards(
                rewardsLibData,
                rewardsLibData.dailyRewards.lastApplicationsRewardsDay,
                rewardsLibData.dailyRewards.lastConfirmedRewardsHash,
                false
            );
            if (previousDayValidatorRewardsAmount > 0) {
                _mintDailyRewardsForValidators(rewardsLibData.dailyRewards.lastApplicationsRewardsDay, rewardsLibData.dailyRewards.lastConfirmedRewardsHash, previousDayValidatorRewardsAmount);
            }
        }
        // check and give application rewards if majority of validators agree
        uint256 appRewardsSum = PropsRewardsLib.calculateAndFinalizeApplicationRewards(
            rewardsLibData,
            _rewardsDay,
            _rewardsHash,
            _applications,
            _amounts,
            totalSupply()
        );
        if (appRewardsSum > 0) {
            _mintDailyRewardsForApps(_rewardsDay, _rewardsHash, _applications, _amounts, appRewardsSum);
        }

        // check and give validator rewards if all validators submitted
        uint256 validatorRewardsAmount = PropsRewardsLib.calculateValidatorRewards(
            rewardsLibData,
            _rewardsDay,
            _rewardsHash,
            true
        );
        if (validatorRewardsAmount > 0) {
            _mintDailyRewardsForValidators(_rewardsDay, _rewardsHash, validatorRewardsAmount);
        }

        emit DailyRewardsSubmitted(_rewardsDay, _rewardsHash, msg.sender);
    }

    /**
    * @dev Allows the controller/owner to update to a new controller
    * @param _controller address address of the new controller
    */
    function updateController(
        address _controller
    )
        public
        onlyController
    {
        require(_controller != address(0), "Controller cannot be the zero address");
        controller = _controller;
        emit ControllerUpdated
        (
            _controller
        );
    }

    /**
    * @dev Allows getting a parameter value based on timestamp
    * @param _name ParameterName name of the parameter
    * @param _rewardsDay uint256 starting when should this parameter use the current value
    */
    function getParameter(
        PropsRewardsLib.ParameterName _name,
        uint256 _rewardsDay
    )
        public
        view
        returns (uint256)
    {
        return PropsRewardsLib.getParameterValue(rewardsLibData, _name, _rewardsDay);
    }

    /**
    * @dev Allows the controller/owner to update rewards parameters
    * @param _name ParameterName name of the parameter
    * @param _value uint256 new value for the parameter
    * @param _rewardsDay uint256 starting when should this parameter use the current value
    */
    function updateParameter(
        PropsRewardsLib.ParameterName _name,
        uint256 _value,
        uint256 _rewardsDay
    )
        public
        onlyController
    {
        PropsRewardsLib.updateParameter(rewardsLibData, _name, _value, _rewardsDay);
        emit ParameterUpdated(
            _name,
            rewardsLibData.parameters[uint256(_name)].currentValue,
            rewardsLibData.parameters[uint256(_name)].previousValue,
            rewardsLibData.parameters[uint256(_name)].rewardsDay
        );
    }

    /**
    * @dev Allows an application or validator to add/update its details
    * @param _entityType RewardedEntityType either application (0) or validator (1)
    * @param _name bytes32 name of the app
    * @param _rewardsAddress address an address for the app to receive the rewards
    * @param _sidechainAddress address the address used for using the sidechain
    */
    function updateEntity(
        PropsRewardsLib.RewardedEntityType _entityType,
        bytes32 _name,
        address _rewardsAddress,
        address _sidechainAddress
    )
        public
    {
        PropsRewardsLib.updateEntity(rewardsLibData, _entityType, _name, _rewardsAddress, _sidechainAddress);
        emit EntityUpdated(msg.sender, _entityType, _name, _rewardsAddress, _sidechainAddress);
    }

    /**
    * @dev Allows an application to settle sidechain props. Should be called from an application rewards address
    * @param _applicationAddress address the application main address (used to setup the application)
    * @param _userId bytes32 identification of the user on the sidechain that was settled
    * @param _to address where to send the props to
    * @param _amount uint256 the address used for using the sidechain
    */
    function settle(
        address _applicationAddress,
        bytes32 _userId,
        address _to,
        uint256 _amount
    )
        public
    {
        require(
            rewardsLibData.applications[_applicationAddress].rewardsAddress == msg.sender,
            "settle may only be called by an application"
        );
        _transfer(msg.sender, _to, _amount);
        emit Settlement(_applicationAddress, _userId, _to, _amount, msg.sender);
    }
    /**
    * @dev internal intialize rewards upgrade1
    * @param _controller address that will have controller functionality on rewards protocol
    * @param _decimals uint256 number of decimals used in total supply
    * @param _minSecondsBetweenDays uint256 seconds required to pass between consecutive rewards day
    * @param _rewardsStartTimestamp uint256 day 0 timestamp
    */
    function _initializePostRewardsUpgrade1(
        address _controller,
        uint256 _decimals,
        uint256 _minSecondsBetweenDays,
        uint256 _rewardsStartTimestamp
    )
        internal
    {
        require(maxTotalSupply==0, "Initialize rewards upgrade1 can happen only once");
        controller = _controller;
        // ApplicationRewardsPercent pphm ==> 0.03475%
        PropsRewardsLib.updateParameter(rewardsLibData, PropsRewardsLib.ParameterName.ApplicationRewardsPercent, 34750, 0);
        // // ApplicationRewardsMaxVariationPercent pphm ==> 150%
        PropsRewardsLib.updateParameter(rewardsLibData, PropsRewardsLib.ParameterName.ApplicationRewardsMaxVariationPercent, 150 * 1e6, 0);
        // // ValidatorMajorityPercent pphm ==> 50%
        PropsRewardsLib.updateParameter(rewardsLibData, PropsRewardsLib.ParameterName.ValidatorMajorityPercent, 50 * 1e6, 0);
        //  // ValidatorRewardsPercent pphm ==> 0.001829%
        PropsRewardsLib.updateParameter(rewardsLibData, PropsRewardsLib.ParameterName.ValidatorRewardsPercent, 1829, 0);

        // max total supply is 1,000,000,000 PROPS specified in AttoPROPS
        rewardsLibData.maxTotalSupply = maxTotalSupply = 1 * 1e9 * (10 ** _decimals);
        rewardsLibData.rewardsStartTimestamp = rewardsStartTimestamp = _rewardsStartTimestamp;
        rewardsLibData.minSecondsBetweenDays = _minSecondsBetweenDays;

    }

    /**
    * @dev Mint rewards for validators
    * @param _rewardsDay uint256 the rewards day
    * @param _rewardsHash bytes32 hash of the rewards data
    * @param _amount uint256 amount each validator should get
    */
    function _mintDailyRewardsForValidators(uint256 _rewardsDay, bytes32 _rewardsHash, uint256 _amount)
        internal
    {
        uint256 validatorsCount = rewardsLibData.dailyRewards.submissions[_rewardsHash].validatorsList.length;
        for (uint256 i = 0; i < validatorsCount; i++) {
            _mint(rewardsLibData.validators[rewardsLibData.dailyRewards.submissions[_rewardsHash].validatorsList[i]].rewardsAddress,_amount);
        }
        PropsRewardsLib._resetDailyRewards(rewardsLibData, _rewardsHash);
        emit DailyRewardsValidatorsMinted(
            _rewardsDay,
            _rewardsHash,
            validatorsCount,
            (_amount * validatorsCount)
        );
    }

    /**
    * @dev Mint rewards for apps
    * @param _rewardsDay uint256 the rewards day
    * @param _rewardsHash bytes32 hash of the rewards data
    * @param _applications address[] array of application addresses getting the daily reward
    * @param _amounts uint256[] array of amounts each app should get
    * @param _sum uint256 the sum of all application rewards given
    */
    function _mintDailyRewardsForApps(
        uint256 _rewardsDay,
        bytes32 _rewardsHash,
        address[] _applications,
        uint256[] _amounts,
        uint256 _sum
    )
        internal
    {
        for (uint256 i = 0; i < _applications.length; i++) {
            _mint(rewardsLibData.applications[_applications[i]].rewardsAddress, _amounts[i]);
        }
        emit DailyRewardsApplicationsMinted(_rewardsDay, _rewardsHash, _applications.length, _sum);
    }
}

// File: contracts/token/PropsToken.sol

pragma solidity ^0.4.24;






/**
 * @title PROPSToken
 * @dev PROPS token contract (based of ZEPToken by openzeppelin), a detailed ERC20 token
 * https://github.com/zeppelinos/zos-vouching/blob/master/contracts/ZEPToken.sol
 * PROPS are divisible by 1e18 base
 * units referred to as 'AttoPROPS'.
 *
 * PROPS are displayed using 18 decimal places of precision.
 *
 * 1 PROPS is equivalent to:
 *   1 * 1e18 == 1e18 == One Quintillion AttoPROPS
 *
 * 600 Million PROPS (total supply) is equivalent to:
 *   600000000 * 1e18 == 6e26 AttoPROPS
 *

 */


contract PropsToken is Initializable, ERC20Detailed, ERC865Token, PropsTimeBasedTransfers, PropsRewards {

  /**
   * @dev Initializer function. Called only once when a proxy for the contract is created.
   * @param _holder address that will receive its initial supply and be able to transfer before transfers start time
   * @param _controller address that will have controller functionality on rewards protocol
   * @param _minSecondsBetweenDays uint256 seconds required to pass between consecutive rewards day
   * @param _rewardsStartTimestamp uint256 day 0 timestamp
   */
  function initialize(
    address _holder,
    address _controller,
    uint256 _minSecondsBetweenDays,
    uint256 _rewardsStartTimestamp
  )
    public
    initializer
  {
    uint8 decimals = 18;
    // total supply is 600,000,000 PROPS specified in AttoPROPS
    uint256 totalSupply = 0.6 * 1e9 * (10 ** uint256(decimals));

    ERC20Detailed.initialize("Props Token", "PROPS", decimals);
    PropsRewards.initializePostRewardsUpgrade1(_controller, _minSecondsBetweenDays, _rewardsStartTimestamp);
    _mint(_holder, totalSupply);
  }
}