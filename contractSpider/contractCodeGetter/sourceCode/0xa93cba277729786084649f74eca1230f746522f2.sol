/**
 *Submitted for verification at Etherscan.io on 2020-07-14
*/

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

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

// File: contracts/interfaces/IBridgeValidators.sol

pragma solidity 0.4.24;

interface IBridgeValidators {
    function initialize(uint256 _requiredSignatures, address[] _initialValidators, address _owner) external returns(bool);
    function isValidator(address _validator) external view returns(bool);
    function requiredSignatures() external view returns(uint256);
    function owner() external view returns(address);
}

// File: contracts/interfaces/IOwnedUpgradeabilityProxy.sol

pragma solidity 0.4.24;

interface IOwnedUpgradeabilityProxy {
    function proxyOwner() external view returns (address);
}

// File: contracts/upgradeable_contracts/OwnedUpgradeability.sol

pragma solidity 0.4.24;


contract OwnedUpgradeability {

    function upgradeabilityAdmin() public view returns (address) {
        return IOwnedUpgradeabilityProxy(this).proxyOwner();
    }

    // Avoid using onlyProxyOwner name to prevent issues with implementation from proxy contract
    modifier onlyIfOwnerOfProxy() {
        require(msg.sender == upgradeabilityAdmin());
        _;
    }
}

// File: contracts/upgradeability/EternalStorage.sol

pragma solidity 0.4.24;

/**
 * @title EternalStorage
 * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
 */
contract EternalStorage {

    mapping(bytes32 => uint256) internal uintStorage;
    mapping(bytes32 => string) internal stringStorage;
    mapping(bytes32 => address) internal addressStorage;
    mapping(bytes32 => bytes) internal bytesStorage;
    mapping(bytes32 => bool) internal boolStorage;
    mapping(bytes32 => int256) internal intStorage;


    mapping(bytes32 => uint256[]) internal uintArrayStorage;
    mapping(bytes32 => string[]) internal stringArrayStorage;
    mapping(bytes32 => address[]) internal addressArrayStorage;
    //mapping(bytes32 => bytes[]) internal bytesArrayStorage;
    mapping(bytes32 => bool[]) internal boolArrayStorage;
    mapping(bytes32 => int256[]) internal intArrayStorage;
    mapping(bytes32 => bytes32[]) internal bytes32ArrayStorage;
}

// File: contracts/upgradeable_contracts/EternalOwnable.sol

pragma solidity 0.4.24;


/**
 * @title EternalOwnable
 * @dev This contract has an owner address providing basic authorization control
 */
contract EternalOwnable is EternalStorage {
    /**
    * @dev Event to show ownership has been transferred
    * @param previousOwner representing the address of the previous owner
    * @param newOwner representing the address of the new owner
    */
    event EternalOwnershipTransferred(address previousOwner, address newOwner);

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        require(msg.sender == owner());
        _;
    }

    /**
    * @dev Tells the address of the owner
    * @return the address of the owner
    */
    function owner() public view returns (address) {
        return addressStorage[keccak256(abi.encodePacked("owner"))];
    }

    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param newOwner the address to transfer ownership to.
    */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        setOwner(newOwner);
    }

    /**
    * @dev Sets a new owner address
    */
    function setOwner(address newOwner) internal {
        emit EternalOwnershipTransferred(owner(), newOwner);
        addressStorage[keccak256(abi.encodePacked("owner"))] = newOwner;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

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

// File: contracts/upgradeable_contracts/BasicBridge.sol

pragma solidity 0.4.24;







contract BasicBridge is EternalStorage, EternalOwnable, OwnedUpgradeability {
    using SafeMath for uint256;

    event GasPriceChanged(uint256 gasPrice);
    event RequiredBlockConfirmationChanged(uint256 requiredBlockConfirmations);
    event DailyLimitChanged(uint256 newLimit);
    event ExecutionDailyLimitChanged(uint256 newLimit);

    function getBridgeInterfacesVersion() public pure returns(uint64 major, uint64 minor, uint64 patch) {
        return (2, 2, 0);
    }

    function setGasPrice(uint256 _gasPrice) public onlyOwner {
        require(_gasPrice > 0);
        uintStorage[keccak256(abi.encodePacked("gasPrice"))] = _gasPrice;
        emit GasPriceChanged(_gasPrice);
    }

    function gasPrice() public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked("gasPrice"))];
    }

    function setRequiredBlockConfirmations(uint256 _blockConfirmations) public onlyOwner {
        require(_blockConfirmations > 0);
        uintStorage[keccak256(abi.encodePacked("requiredBlockConfirmations"))] = _blockConfirmations;
        emit RequiredBlockConfirmationChanged(_blockConfirmations);
    }

    function requiredBlockConfirmations() public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked("requiredBlockConfirmations"))];
    }

    function deployedAtBlock() public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked("deployedAtBlock"))];
    }

    function setTotalSpentPerDay(uint256 _day, uint256 _value) internal {
        uintStorage[keccak256(abi.encodePacked("totalSpentPerDay", _day))] = _value;
    }

    function totalSpentPerDay(uint256 _day) public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked("totalSpentPerDay", _day))];
    }

    function setTotalExecutedPerDay(uint256 _day, uint256 _value) internal {
        uintStorage[keccak256(abi.encodePacked("totalExecutedPerDay", _day))] = _value;
    }

    function totalExecutedPerDay(uint256 _day) public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked("totalExecutedPerDay", _day))];
    }

    function minPerTx() public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked("minPerTx"))];
    }

    function maxPerTx() public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked("maxPerTx"))];
    }

    function executionMaxPerTx() public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked("executionMaxPerTx"))];
    }

    function setInitialize(bool _status) internal {
        boolStorage[keccak256(abi.encodePacked("isInitialized"))] = _status;
    }

    function isInitialized() public view returns(bool) {
        return boolStorage[keccak256(abi.encodePacked("isInitialized"))];
    }

    function getCurrentDay() public view returns(uint256) {
        return now / 1 days;
    }

    function setDailyLimit(uint256 _dailyLimit) public onlyOwner {
        uintStorage[keccak256(abi.encodePacked("dailyLimit"))] = _dailyLimit;
        emit DailyLimitChanged(_dailyLimit);
    }

    function dailyLimit() public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked("dailyLimit"))];
    }

    function setExecutionDailyLimit(uint256 _dailyLimit) public onlyOwner {
        uintStorage[keccak256(abi.encodePacked("executionDailyLimit"))] = _dailyLimit;
        emit ExecutionDailyLimitChanged(_dailyLimit);
    }

    function executionDailyLimit() public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked("executionDailyLimit"))];
    }

    function setExecutionMaxPerTx(uint256 _maxPerTx) external onlyOwner {
        require(_maxPerTx < executionDailyLimit());
        uintStorage[keccak256(abi.encodePacked("executionMaxPerTx"))] = _maxPerTx;
    }

    function setMaxPerTx(uint256 _maxPerTx) external onlyOwner {
        require(_maxPerTx < dailyLimit());
        uintStorage[keccak256(abi.encodePacked("maxPerTx"))] = _maxPerTx;
    }

    function setMinPerTx(uint256 _minPerTx) external onlyOwner {
        require(_minPerTx < dailyLimit() && _minPerTx < maxPerTx());
        uintStorage[keccak256(abi.encodePacked("minPerTx"))] = _minPerTx;
    }

    function withinLimit(uint256 _amount) public view returns(bool) {
        uint256 nextLimit = totalSpentPerDay(getCurrentDay()).add(_amount);
        return dailyLimit() >= nextLimit && _amount <= maxPerTx() && _amount >= minPerTx();
    }

    function withinExecutionLimit(uint256 _amount) public view returns(bool) {
        uint256 nextLimit = totalExecutedPerDay(getCurrentDay()).add(_amount);
        return executionDailyLimit() >= nextLimit && _amount <= executionMaxPerTx();
    }

    function claimTokens(address _token, address _to) public onlyIfOwnerOfProxy {
        require(_to != address(0));
        if (_token == address(0)) {
            _to.transfer(address(this).balance);
            return;
        }

        IERC20 token = IERC20(_token);
        uint256 balance = token.balanceOf(this);
        require(token.transfer(_to, balance));
    }


    function isContract(address _addr) internal view returns (bool)
    {
        uint length;
        assembly { length := extcodesize(_addr) }
        return length > 0;
    }
}

// File: contracts/ERC677Receiver.sol

pragma solidity 0.4.24;

contract ERC677Receiver {
  function onTokenTransfer(address _from, uint _value, bytes _data) external returns(bool);
}

// File: contracts/interfaces/IForeignBridgeValidators.sol

pragma solidity 0.4.24;

interface IForeignBridgeValidators {
    function isValidator(address _validator) external view returns(bool);
    function requiredSignatures() external view returns(uint256);
    function setValidators(address[] _validators) external returns(bool);
}

// File: contracts/libraries/Message.sol

pragma solidity 0.4.24;



library Message {
    function addressArrayContains(address[] array, address value) internal pure returns (bool) {
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == value) {
                return true;
            }
        }
        return false;
    }
    // layout of message :: bytes:
    // offset  0: 32 bytes :: uint256 - message length
    // offset 32: 20 bytes :: address - recipient address
    // offset 52: 32 bytes :: uint256 - value
    // offset 84: 32 bytes :: bytes32 - transaction hash
    // offset 104: 20 bytes :: address - contract address to prevent double spending

    // bytes 1 to 32 are 0 because message length is stored as little endian.
    // mload always reads 32 bytes.
    // so we can and have to start reading recipient at offset 20 instead of 32.
    // if we were to read at 32 the address would contain part of value and be corrupted.
    // when reading from offset 20 mload will read 12 zero bytes followed
    // by the 20 recipient address bytes and correctly convert it into an address.
    // this saves some storage/gas over the alternative solution
    // which is padding address to 32 bytes and reading recipient at offset 32.
    // for more details see discussion in:
    // https://github.com/paritytech/parity-bridge/interfaces/Issues/61
    function parseMessage(bytes message)
        internal
        pure
        returns(address recipient, uint256 amount, bytes32 txHash, address contractAddress)
    {
        require(isMessageValid(message));
        assembly {
            recipient := and(mload(add(message, 20)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            amount := mload(add(message, 52))
            txHash := mload(add(message, 84))
            contractAddress := mload(add(message, 104))
        }
    }

    function parseNewSetMessage(bytes message)
        internal
        returns(address[] memory newSet, bytes32 txHash, uint256 blockNumber, address contractAddress)
    {
        uint256 msgLength;
        uint256 position;
        address newSetMember;
        assembly {
            msgLength := mload(message)
            txHash := mload(add(message, 32))
            blockNumber:= mload(add(message, 64))
            contractAddress := mload(add(message, 84))
            position := 104
        }
        uint256 newSetLength = (msgLength - position) / 20 + 1;
        newSet = new address[](newSetLength);
        uint256 i = 0;
        while (position <= msgLength) {
            assembly {
                newSetMember := mload(add(message, position))
            }
            newSet[i] = newSetMember;
            position += 20;
            i++;
        }
        return (newSet, txHash, blockNumber, contractAddress);
    }

    function isMessageValid(bytes _msg) internal pure returns(bool) {
        return _msg.length == requiredMessageLength();
    }

    function requiredMessageLength() internal pure returns(uint256) {
        return 104;
    }

    function recoverAddressFromSignedMessage(bytes signature, bytes message, bool knownLength) internal pure returns (address) {
        require(signature.length == 65);
        bytes32 r;
        bytes32 s;
        bytes1 v;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := mload(add(signature, 0x60))
        }
        if (knownLength) {
            return ecrecover(hashMessage(message), uint8(v), r, s);
        } else {
            return ecrecover(hashMessageOfUnknownLength(message), uint8(v), r, s);
        }
    }

    function hashMessage(bytes message) internal pure returns (bytes32) {
        bytes memory prefix = "\x19Ethereum Signed Message:\n";
        // message is always 84 length
        string memory msgLength = "104";
        return keccak256(abi.encodePacked(prefix, msgLength, message));
    }

    function hashMessageOfUnknownLength(bytes message) internal pure returns (bytes32) {
        bytes memory prefix = "\x19Ethereum Signed Message:\n";
        uint256 lengthOffset;
        uint256 length;
        assembly {
          // The first word of a string is its length
          length := mload(message)
          // The beginning of the base-10 message length in the prefix
          lengthOffset := add(prefix, 57)
        }
        uint256 lengthLength = 0;
        // The divisor to get the next left-most message length digit
        uint256 divisor = 100000;
        // Move one digit of the message length to the right at a time
        while (divisor != 0) {
          // The place value at the divisor
          uint256 digit = length / divisor;
          if (digit == 0) {
            // Skip leading zeros
            if (lengthLength == 0) {
              divisor /= 10;
              continue;
            }
          }
          // Found a non-zero digit or non-leading zero digit
          lengthLength++;
          // Remove this digit from the message length's current value
          length -= digit * divisor;
          // Shift our base-10 divisor over
          divisor /= 10;
          // Convert the digit to its ASCII representation (man ascii)
          digit += 0x30;
          // Move to the next character and write the digit
          lengthOffset++;
          assembly {
            mstore8(lengthOffset, digit)
          }
        }
        // The null string requires exactly 1 zero (unskip 1 leading 0)
        if (lengthLength == 0) {
          lengthLength = 1 + 0x19 + 1;
        } else {
          lengthLength += 1 + 0x19;
        }
        // Truncate the tailing zeros from the prefix
        assembly {
          mstore(prefix, lengthLength)
        }
        return keccak256(prefix, message);
    }

    function hasEnoughValidSignaturesForeignBridgeValidator(
        bytes _message,
        uint8[] _vs,
        bytes32[] _rs,
        bytes32[] _ss,
        IForeignBridgeValidators _validatorContract) internal view
    {
        uint256 requiredSignatures = _validatorContract.requiredSignatures();
        require(_vs.length == _rs.length);
        require(_vs.length == _ss.length);
        require(_vs.length >= requiredSignatures);
        bytes32 hash = hashMessage(_message);
        address[] memory encounteredAddresses = new address[](requiredSignatures);
        uint256 signaturesCount;

        for (uint256 i = 0; i < _vs.length; i++) {
            address recoveredAddress = ecrecover(hash, _vs[i], _rs[i], _ss[i]);
            if(_validatorContract.isValidator(recoveredAddress)) {
                if (!addressArrayContains(encounteredAddresses, recoveredAddress)) {
                    encounteredAddresses[i] = recoveredAddress;
                    signaturesCount++;

                    if (signaturesCount == requiredSignatures) {
                        return;
                    }
                }
            }
        }
        require(signaturesCount >=requiredSignatures);
    }

    function hasEnoughValidNewSetSignaturesForeignBridgeValidator(
        bytes _message,
        uint8[] _vs,
        bytes32[] _rs,
        bytes32[] _ss,
        IForeignBridgeValidators _validatorContract) internal view
    {
        uint256 requiredSignatures = _validatorContract.requiredSignatures();
        require(_vs.length == _rs.length);
        require(_vs.length == _ss.length);
        require(_vs.length >= requiredSignatures);
        bytes32 hash = hashMessageOfUnknownLength(_message);
        address[] memory encounteredAddresses = new address[](requiredSignatures);
        uint256 signaturesCount;

        for (uint256 i = 0; i < _vs.length; i++) {
            address recoveredAddress = ecrecover(hash, _vs[i], _rs[i], _ss[i]);
            if(_validatorContract.isValidator(recoveredAddress)) {
                if (!addressArrayContains(encounteredAddresses, recoveredAddress)) {
                    encounteredAddresses[i] = recoveredAddress;
                    signaturesCount++;

                    if (signaturesCount == requiredSignatures) {
                        return;
                    }
                }
            }
        }
        require(signaturesCount >=requiredSignatures);
    }

    function recover(bytes32 hash, bytes sig) internal pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        // Check the signature length
        if (sig.length != 65) {
          return (address(0));
        }

        // Divide the signature in r, s and v variables
        assembly {
          r := mload(add(sig, 32))
          s := mload(add(sig, 64))
          v := byte(0, mload(add(sig, 96)))
        }

        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
          v += 27;
        }

        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
          return (address(0));
        } else {
          return ecrecover(hash, v, r, s);
        }
    }
}

// File: contracts/upgradeable_contracts/BasicForeignBridge.sol

pragma solidity 0.4.24;




contract BasicForeignBridge is EternalStorage {
    using SafeMath for uint256;

    /// triggered when relay of deposit from HomeBridge is complete
    event RelayedMessage(address recipient, uint value, bytes32 transactionHash);

    function onExecuteMessage(address, uint256) internal returns(bool);

    function setRelayedMessages(bytes32 _txHash, bool _status) internal {
        boolStorage[keccak256(abi.encodePacked("relayedMessages", _txHash))] = _status;
    }

    function relayedMessages(bytes32 _txHash) public view returns(bool) {
        return boolStorage[keccak256(abi.encodePacked("relayedMessages", _txHash))];
    }

    function setLastRelayedBlockNumber(uint256 _blockNumber) internal {
        uintStorage[keccak256(abi.encodePacked("relayedMessagesLastBlockNumber"))] = _blockNumber;
    }

    function lastRelayedBlockNumber() public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked("relayedMessagesLastBlockNumber"))];
    }

    function messageWithinLimits(uint256) internal view returns(bool);

    function onFailedMessage(address, uint256, bytes32) internal;
}

// File: contracts/upgradeable_contracts/native_to_erc20/ForeignValidatable.sol

pragma solidity 0.4.24;



contract ForeignValidatable is EternalStorage {
    function validatorContract() public view returns(IForeignBridgeValidators) {
        return IForeignBridgeValidators(addressStorage[keccak256(abi.encodePacked("validatorContract"))]);
    }

    modifier onlyValidator() {
        require(validatorContract().isValidator(msg.sender));
        _;
    }

    function requiredSignatures() public view returns(uint256) {
        return validatorContract().requiredSignatures();
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

pragma solidity ^0.4.24;



/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract ERC20 is IERC20 {
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
  * @param owner The address to query the balance of.
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
    require(spender != address(0));

    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
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
    require(value <= _allowed[from][msg.sender]);

    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
    _transfer(from, to, value);
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
    require(spender != address(0));

    _allowed[msg.sender][spender] = (
      _allowed[msg.sender][spender].add(addedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
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
    require(spender != address(0));

    _allowed[msg.sender][spender] = (
      _allowed[msg.sender][spender].sub(subtractedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
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
   * @param value The amount that will be created.
   */
  function _mint(address account, uint256 value) internal {
    require(account != 0);
    _totalSupply = _totalSupply.add(value);
    _balances[account] = _balances[account].add(value);
    emit Transfer(address(0), account, value);
  }

  /**
   * @dev Internal function that burns an amount of the token of a given
   * account.
   * @param account The account whose tokens will be burnt.
   * @param value The amount that will be burnt.
   */
  function _burn(address account, uint256 value) internal {
    require(account != 0);
    require(value <= _balances[account]);

    _totalSupply = _totalSupply.sub(value);
    _balances[account] = _balances[account].sub(value);
    emit Transfer(account, address(0), value);
  }

  /**
   * @dev Internal function that burns an amount of the token of a given
   * account, deducting from the sender's allowance for said account. Uses the
   * internal burn function.
   * @param account The account whose tokens will be burnt.
   * @param value The amount that will be burnt.
   */
  function _burnFrom(address account, uint256 value) internal {
    require(value <= _allowed[account][msg.sender]);

    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
    // this function needs to emit an event with the updated approval.
    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
      value);
    _burn(account, value);
  }
}

// File: contracts/ERC677.sol

pragma solidity 0.4.24;


contract ERC677 is ERC20 {
    event Transfer(address indexed from, address indexed to, uint value, bytes data);

    function transferAndCall(address, uint, bytes) external returns (bool);
}

// File: contracts/interfaces/IBurnableMintableERC677Token.sol

pragma solidity 0.4.24;


contract IBurnableMintableERC677Token is ERC677 {
    function mint(address, uint256) public returns (bool);
    function burn(uint256 _value) public;
    function claimTokens(address _token, address _to) public;
}

// File: contracts/upgradeable_contracts/ERC677Bridge.sol

pragma solidity 0.4.24;



contract ERC677Bridge is BasicBridge {
    function erc677token() public view returns(IBurnableMintableERC677Token) {
        return IBurnableMintableERC677Token(addressStorage[keccak256(abi.encodePacked("erc677token"))]);
    }

    function setErc677token(address _token) internal {
        require(_token != address(0) && isContract(_token));
        addressStorage[keccak256(abi.encodePacked("erc677token"))] = _token;
    }

    function onTokenTransfer(address _from, uint256 _value, bytes _data) external returns(bool) {
        require(msg.sender == address(erc677token()));
        require(withinLimit(_value));
        setTotalSpentPerDay(getCurrentDay(), totalSpentPerDay(getCurrentDay()).add(_value));
        if (!boolStorage[keccak256(abi.encodePacked("erc677tokenPreMinted"))]) {
            erc677token().burn(_value);
        }
        fireEventOnTokenTransfer(_from, _value, _data);
        return true;
    }

    function fireEventOnTokenTransfer(address /*_from */, uint256 /* _value */, bytes /* _data */) internal {
        // has to be defined
    }
}

// File: contracts/upgradeable_contracts/native_to_erc20/ForeignBridgeNativeToErc.sol

pragma solidity 0.4.24;







contract ForeignBridgeNativeToErc is ERC677Receiver, BasicBridge, BasicForeignBridge, ERC677Bridge, ForeignValidatable {

    /// Event created on money withdraw.
    event UserRequestForAffirmation(address recipient, uint256 value);

    event RelayedNewSetMessage(address[] newSet, bytes32 transactionHash);

    function initialize(
        address _validatorContract,
        address _erc677token,
        uint256 _dailyLimit,
        uint256 _maxPerTx,
        uint256 _minPerTx,
        uint256 _foreignGasPrice,
        uint256 _requiredBlockConfirmations,
        uint256 _homeDailyLimit,
        uint256 _homeMaxPerTx,
        address _owner,
        bool _erc677tokenPreMinted
    ) public returns(bool) {
        require(!isInitialized());
        require(_validatorContract != address(0) && isContract(_validatorContract));
        require(_minPerTx > 0 && _maxPerTx > _minPerTx && _dailyLimit > _maxPerTx);
        require(_foreignGasPrice > 0);
        require(_homeMaxPerTx < _homeDailyLimit);
        require(_owner != address(0));
        addressStorage[keccak256(abi.encodePacked("validatorContract"))] = _validatorContract;
        setErc677token(_erc677token);
        uintStorage[keccak256(abi.encodePacked("dailyLimit"))] = _dailyLimit;
        uintStorage[keccak256(abi.encodePacked("deployedAtBlock"))] = block.number;
        uintStorage[keccak256(abi.encodePacked("maxPerTx"))] = _maxPerTx;
        uintStorage[keccak256(abi.encodePacked("minPerTx"))] = _minPerTx;
        uintStorage[keccak256(abi.encodePacked("gasPrice"))] = _foreignGasPrice;
        uintStorage[keccak256(abi.encodePacked("requiredBlockConfirmations"))] = _requiredBlockConfirmations;
        uintStorage[keccak256(abi.encodePacked("executionDailyLimit"))] = _homeDailyLimit;
        uintStorage[keccak256(abi.encodePacked("executionMaxPerTx"))] = _homeMaxPerTx;
        boolStorage[keccak256(abi.encodePacked("erc677tokenPreMinted"))] = _erc677tokenPreMinted;
        setOwner(_owner);
        setInitialize(true);
        return isInitialized();
    }

    function getBridgeMode() public pure returns(bytes4 _data) {
        return bytes4(keccak256(abi.encodePacked("native-to-erc-core")));
    }

    function claimTokensFromErc677(address _token, address _to) external onlyIfOwnerOfProxy {
        erc677token().claimTokens(_token, _to);
    }

    function executeSignatures(uint8[] vs, bytes32[] rs, bytes32[] ss, bytes message) external {
        require(Message.isMessageValid(message));
        Message.hasEnoughValidSignaturesForeignBridgeValidator(message, vs, rs, ss, validatorContract());
        address recipient;
        uint256 amount;
        bytes32 txHash;
        address contractAddress;
        (recipient, amount, txHash, contractAddress) = Message.parseMessage(message);
        if (messageWithinLimits(amount)) {
            require(contractAddress == address(this));
            require(!relayedMessages(txHash));
            setRelayedMessages(txHash, true);
            require(onExecuteMessage(recipient, amount));
            emit RelayedMessage(recipient, amount, txHash);
        } else {
            onFailedMessage(recipient, amount, txHash);
        }
    }

    function executeNewSetSignatures(uint8[] vs, bytes32[] rs, bytes32[] ss, bytes message) external {
        Message.hasEnoughValidNewSetSignaturesForeignBridgeValidator(message, vs, rs, ss, validatorContract());
        address[] memory newSet;
        bytes32 txHash;
        uint256 blockNumber;
        address contractAddress;
        (newSet, txHash, blockNumber, contractAddress) = Message.parseNewSetMessage(message);
        require(contractAddress == address(this));
        require(!relayedMessages(txHash));
        require(blockNumber > lastRelayedBlockNumber());
        setRelayedMessages(txHash, true);
        setLastRelayedBlockNumber(blockNumber);
        require(validatorContract().setValidators(newSet));
        emit RelayedNewSetMessage(newSet, txHash);
    }

    function onExecuteMessage(address _recipient, uint256 _amount) internal returns(bool){
        if (_recipient == address(this)) {
            return erc677token().mint(_recipient, _amount);
        }
        setTotalExecutedPerDay(getCurrentDay(), totalExecutedPerDay(getCurrentDay()).add(_amount));
        if (boolStorage[keccak256(abi.encodePacked("erc677tokenPreMinted"))]) {
            return erc677token().transfer(_recipient, _amount);
        }
        return erc677token().mint(_recipient, _amount);
    }

    function fireEventOnTokenTransfer(address _from, uint256 _value, bytes /*_data*/) internal {
        emit UserRequestForAffirmation(_from, _value);
    }

    function messageWithinLimits(uint256 _amount) internal view returns(bool) {
        return withinExecutionLimit(_amount);
    }

    function onFailedMessage(address, uint256, bytes32) internal {
        revert();
    }
}