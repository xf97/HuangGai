/**
 *Submitted for verification at Etherscan.io on 2020-08-12
*/

// File: @openzeppelin\upgrades\contracts\Initializable.sol

pragma solidity >=0.4.24 <0.7.0;


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

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

// File: @openzeppelin\contracts-ethereum-package\contracts\GSN\Context.sol

pragma solidity ^0.5.0;


/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context is Initializable {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin\contracts-ethereum-package\contracts\ownership\Ownable.sol

pragma solidity ^0.5.0;



/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Initializable, Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    function initialize(address sender) public initializer {
        _owner = sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    uint256[50] private ______gap;
}

// File: contracts\common\Base.sol

pragma solidity ^0.5.12;




/**
 * Base contract for all modules
 */
contract Base is Initializable, Context, Ownable {
    address constant  ZERO_ADDRESS = address(0);

    function initialize() public initializer {
        Ownable.initialize(_msgSender());
    }

}

// File: contracts\interfaces\core\CoreInterface.sol

pragma solidity ^0.5.12;

contract CoreInterface {

    /* Module manipulation events */

    event ModuleAdded(string name, address indexed module);

    event ModuleRemoved(string name, address indexed module);

    event ModuleReplaced(string name, address indexed from, address indexed to);


    /* Functions */

    function set(string memory  _name, address _module, bool _constant) public;

    function setMetadata(string memory _name, string  memory _description) public;

    function remove(string memory _name) public;
    
    function contains(address _module)  public view returns (bool);

    function size() public view returns (uint);

    function isConstant(string memory _name) public view returns (bool);

    function get(string memory _name)  public view returns (address);

    function getName(address _module)  public view returns (string memory);

    function first() public view returns (address);

    function next(address _current)  public view returns (address);
}

// File: contracts\utils\AddressList.sol

pragma solidity ^0.5.12;
/**
 * @dev Double linked list with address items
 */
library AddressList {

    address constant  ZERO_ADDRESS = address(0);

    struct Data {
        address head;
        address tail;
        uint    length;
        mapping(address => bool)    isContain;
        mapping(address => address) nextOf;
        mapping(address => address) prevOf;
    }

    /**
     * @dev Append element to end of list
     * @param _data is list storage ref
     * @param _item is a new list element
     */
    function append(Data storage _data, address _item) internal
    {
        append(_data, _item, _data.tail);
    }

    /**
     * @dev Append element to end of element
     * @param _data is list storage ref
     * @param _item is a new list element
     * @param _to is a item element before new
     * @notice gas usage < 100000
     */
    function append(Data storage _data, address _item, address _to) internal {
        // Unable to contain double element
        require(!_data.isContain[_item], "Unable to contain double element");

        // Empty list
        if (_data.head == ZERO_ADDRESS) {
            _data.head = _data.tail = _item;
        } else {
            require(_data.isContain[_to], "Append target not contained");

            address  nextTo = _data.nextOf[_to];
            if (nextTo != ZERO_ADDRESS) {
                _data.prevOf[nextTo] = _item;
            } else {
                _data.tail = _item;
            }

            _data.nextOf[_to] = _item;
            _data.prevOf[_item] = _to;
            _data.nextOf[_item] = nextTo;
        }
        _data.isContain[_item] = true;
        ++_data.length;
    }

    /**
     * @dev Prepend element to begin of list
     * @param _data is list storage ref
     * @param _item is a new list element
     */
    function prepend(Data storage _data, address _item) internal
    {
        prepend(_data, _item, _data.head);
    }

    /**
     * @dev Prepend element to element of list
     * @param _data is list storage ref
     * @param _item is a new list element
     * @param _to is a item element before new
     */
    function prepend(Data storage _data, address _item, address _to) internal {
        require(!_data.isContain[_item], "Unable to contain double element");

        // Empty list
        if (_data.head == ZERO_ADDRESS) {
            _data.head = _data.tail = _item;
        } else {
            require(_data.isContain[_to], "Preppend target is not contained");

            address  prevTo = _data.prevOf[_to];
            if (prevTo != ZERO_ADDRESS) {
                _data.nextOf[prevTo] = _item;
            } else {
                _data.head = _item;
            }

            _data.prevOf[_item] = prevTo;
            _data.nextOf[_item] = _to;
            _data.prevOf[_to] = _item;
        }
        _data.isContain[_item] = true;
        ++_data.length;
    }

    /**
     * @dev Remove element from list
     * @param _data is list storage ref
     * @param _item is a removed list element
     */
    function remove(Data storage _data, address _item) internal {
        require(_data.isContain[_item], "Item is not contained");

        address  elemPrev = _data.prevOf[_item];
        address  elemNext = _data.nextOf[_item];

        if (elemPrev != ZERO_ADDRESS) {
            _data.nextOf[elemPrev] = elemNext;
        } else {
            _data.head = elemNext;
        }

        if (elemNext != ZERO_ADDRESS) {
            _data.prevOf[elemNext] = elemPrev;
        } else {
            _data.tail = elemPrev;
        }

        _data.isContain[_item] = false;
        --_data.length;
    }

    /**
     * @dev Replace element on list
     * @param _data is list storage ref
     * @param _from is old element
     * @param _to is a new element
     */
    function replace(Data storage _data, address _from, address _to) internal {

        require(_data.isContain[_from], "Old element not contained");
        require(!_data.isContain[_to], "New element is already contained");

        address  elemPrev = _data.prevOf[_from];
        address  elemNext = _data.nextOf[_from];

        if (elemPrev != ZERO_ADDRESS) {
            _data.nextOf[elemPrev] = _to;
        } else {
            _data.head = _to;
        }

        if (elemNext != ZERO_ADDRESS) {
            _data.prevOf[elemNext] = _to;
        } else {
            _data.tail = _to;
        }

        _data.prevOf[_to] = elemPrev;
        _data.nextOf[_to] = elemNext;
        _data.isContain[_from] = false;
        _data.isContain[_to] = true;
    }

    /**
     * @dev Swap two elements of list
     * @param _data is list storage ref
     * @param _a is a first element
     * @param _b is a second element
     */
    function swap(Data storage _data, address _a, address _b) internal {
        require(_data.isContain[_a] && _data.isContain[_b], "Can not swap element which is not contained");

        address prevA = _data.prevOf[_a];

        remove(_data, _a);
        replace(_data, _b, _a);

        if (prevA == ZERO_ADDRESS) {
            prepend(_data, _b);
        } else if (prevA != _b) {
            append(_data, _b, prevA);
        } else {
            append(_data, _b, _a);
        }
    }

    function first(Data storage _data)  internal view returns (address)
    { 
        return _data.head; 
    }

    function last(Data storage _data)  internal view returns (address)
    { 
        return _data.tail; 
    }

    /**
     * @dev Chec list for element
     * @param _data is list storage ref
     * @param _item is an element
     * @return `true` when element in list
     */
    function contains(Data storage _data, address _item)  internal view returns (bool)
    { 
        return _data.isContain[_item]; 
    }

    /**
     * @dev Next element of list
     * @param _data is list storage ref
     * @param _item is current element of list
     * @return next elemen of list
     */
    function next(Data storage _data, address _item)  internal view returns (address)
    { 
        return _data.nextOf[_item]; 
    }

    /**
     * @dev Previous element of list
     * @param _data is list storage ref
     * @param _item is current element of list
     * @return previous element of list
     */
    function prev(Data storage _data, address _item) internal view returns (address)
    { 
        return _data.prevOf[_item]; 
    }
}

// File: contracts\utils\AddressMap.sol

pragma solidity ^0.5.12;


/**
 * @dev Iterable by index (string => address) mapping structure
 *      with reverse resolve and fast element remove
 */
library AddressMap {

    address constant  ZERO_ADDRESS = address(0);

    struct Data {
        mapping(bytes32 => address) valueOf;
        mapping(address => string)  keyOf;
        AddressList.Data            items;
    }

    using AddressList for AddressList.Data;

    /**
     * @dev Set element value for given key
     * @param _data is an map storage ref
     * @param _key is a item key
     * @param _value is a item value
     * @notice by design you can't set different keys with same value
     */
    function set(Data storage _data, string memory _key, address _value) internal {
        address replaced = get(_data, _key);
        if (replaced != ZERO_ADDRESS) {
            _data.items.replace(replaced, _value);
        } else {
            _data.items.append(_value);
        }
        _data.valueOf[keccak256(abi.encodePacked(_key))] = _value;
        _data.keyOf[_value] = _key;
    }

    /**
     * @dev Remove item from map by key
     * @param _data is an map storage ref
     * @param _key is and item key
     */
    function remove(Data storage _data, string memory _key) internal {
        address  value = get(_data, _key);
        _data.items.remove(value);
        _data.valueOf[keccak256(abi.encodePacked(_key))] = ZERO_ADDRESS;
        _data.keyOf[value] = "";
    }

    /**
     * @dev Get size of map
     * @return count of elements
     */
    function size(Data storage _data) internal view returns (uint)
    { return _data.items.length; }

    /**
     * @dev Get element by name
     * @param _data is an map storage ref
     * @param _key is a item key
     * @return item value
     */
    function get(Data storage _data, string memory _key) internal view returns (address)
    { return _data.valueOf[keccak256(abi.encodePacked(_key))]; }

    /** Get key of element
     * @param _data is an map storage ref
     * @param _item is a item
     * @return item key
     */
    function getKey(Data storage _data, address _item) internal view returns (string memory)
    { 
        return _data.keyOf[_item]; 
    }

}

// File: contracts\core\Pool.sol

pragma solidity ^0.5.12;




contract Pool is Base, CoreInterface {

    /* Short description */
    string  public name;
    string  public description;
    address public founder;

    /* Modules map */
    AddressMap.Data modules;

    using AddressList for AddressList.Data;
    using AddressMap for AddressMap.Data;

    /* Module constant mapping */
    mapping(bytes32 => bool) public is_constant;

    /**
     * @dev Contract ABI storage
     *      the contract interface contains source URI
     */
    mapping(address => string) public abiOf;
    
    function initialize() public initializer {
        Base.initialize();
        founder = _msgSender();
    }

    function setMetadata(string memory _name, string  memory _description) public onlyOwner {
        name = _name;
        description = _description;
    }
      
    /**
     * @dev Set new module for given name
     * @param _name infrastructure node name
     * @param _module infrastructure node address
     * @param _constant have a `true` value when you create permanent name of module
     */
    function set(string memory _name, address _module, bool _constant) public onlyOwner {
        
        require(!isConstant(_name), "Pool: module address can not be replaced");

        // Notify
        if (modules.get(_name) != ZERO_ADDRESS)
            emit ModuleReplaced(_name, modules.get(_name), _module);
        else
            emit ModuleAdded(_name, _module);
 
        // Set module in the map
        modules.set(_name, _module);

        // Register constant flag 
        is_constant[keccak256(abi.encodePacked(_name))] = _constant;
    }

     /**
     * @dev Remove module by name
     * @param _name module name
     */
    function remove(string memory _name)  public onlyOwner {
        require(!isConstant(_name), "Pool: module can not be removed");

        // Notify
        emit ModuleRemoved(_name, modules.get(_name));

        // Remove module
        modules.remove(_name);
    }

    /**
     * @dev Fast module exist check
     * @param _module is a module address
     * @return `true` wnen core contains module
     */
    function contains(address _module) public view returns (bool)
    {
        return modules.items.contains(_module);
    }

    /**
     * @dev Modules counter
     * @return count of modules in core
     */
    function size() public view returns (uint)
    {
        return modules.size();
    }

    /**
     * @dev Check for module have permanent name
     * @param _name is a module name
     * @return `true` when module have permanent name
     */
    function isConstant(string memory _name) public view returns (bool)
    {
        return is_constant[keccak256(abi.encodePacked(_name))];
    }

    /**
     * @dev Get module by name
     * @param _name is module name
     * @return module address
     */
    function get(string memory _name) public view returns (address)
    {
        return modules.get(_name);
    }

    /**
     * @dev Get module name by address
     * @param _module is a module address
     * @return module name
     */
    function getName(address _module) public view returns (string memory)
    {
        return modules.keyOf[_module];
    }

    /**
     * @dev Get first module
     * @return first address
     */
    function first() public view returns (address)
    {
        return modules.items.head;
    }

    /**
     * @dev Get next module
     * @param _current is an current address
     * @return next address
     */
    function next(address _current) public view returns (address)
    {
        return modules.items.next(_current);
    }

}