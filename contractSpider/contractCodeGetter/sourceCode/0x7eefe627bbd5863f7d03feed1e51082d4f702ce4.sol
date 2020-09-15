/**
 *Submitted for verification at Etherscan.io on 2020-06-03
*/

pragma solidity ^0.6.0;


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
contract Context {
	// Empty internal constructor, to prevent people from mistakenly deploying
	// an instance of this contract, which should be used via inheritance.
	constructor () internal { }

	function _msgSender() internal view virtual returns (address payable) {
		return msg.sender;
	}

	function _msgData() internal view virtual returns (bytes memory) {
		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
		return msg.data;
	}
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
	address private _owner;

	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

	/**
	 * @dev Initializes the contract setting the deployer as the initial owner.
	 */
	constructor () internal {
		address msgSender = _msgSender();
		_owner = msgSender;
		emit OwnershipTransferred(address(0), msgSender);
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
		require(_owner == _msgSender(), "Ownable: caller is not the owner");
		_;
	}

	/**
	 * @dev Leaves the contract without owner. It will not be possible to call
	 * `onlyOwner` functions anymore. Can only be called by the current owner.
	 *
	 * NOTE: Renouncing ownership will leave the contract without an owner,
	 * thereby removing any functionality that is only available to the owner.
	 */
	function renounceOwnership() public virtual onlyOwner {
		emit OwnershipTransferred(_owner, address(0));
		_owner = address(0);
	}

	/**
	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
	 * Can only be called by the current owner.
	 */
	function transferOwnership(address newOwner) public virtual onlyOwner {
		_transferOwnership(newOwner);
	}

	/**
	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
	 */
	function _transferOwnership(address newOwner) internal virtual {
		require(newOwner != address(0), "Ownable: new owner is the zero address");
		emit OwnershipTransferred(_owner, newOwner);
		_owner = newOwner;
	}
}


library LibSet_bytes4 {
	struct set
	{
		bytes4[] values;
		mapping(bytes4 => uint256) indexes;
	}

	function length(set storage _set)
	internal view returns (uint256)
	{
		return _set.values.length;
	}

	function at(set storage _set, uint256 _index)
	internal view returns (bytes4 )
	{
		return _set.values[_index - 1];
	}

	function indexOf(set storage _set, bytes4  _value)
	internal view returns (uint256)
	{
		return _set.indexes[_value];
	}

	function contains(set storage _set, bytes4  _value)
	internal view returns (bool)
	{
		return indexOf(_set, _value) != 0;
	}

	function content(set storage _set)
	internal view returns (bytes4[] memory)
	{
		return _set.values;
	}

	function add(set storage _set, bytes4  _value)
	internal returns (bool)
	{
		if (contains(_set, _value))
		{
			return false;
		}
		_set.values.push(_value);
		_set.indexes[_value] = _set.values.length;
		return true;
	}

	function remove(set storage _set, bytes4  _value)
	internal returns (bool)
	{
		if (!contains(_set, _value))
		{
			return false;
		}

		uint256 i    = indexOf(_set, _value);
		uint256 last = length(_set);

		if (i != last)
		{
			bytes4  swapValue = _set.values[last - 1];
			_set.values[i - 1] = swapValue;
			_set.indexes[swapValue] = i;
		}

		delete _set.indexes[_value];
		_set.values.pop();

		return true;
	}

	function clear(set storage _set)
	internal returns (bool)
	{
		for (uint256 i = _set.values.length; i > 0; --i)
		{
			delete _set.indexes[_set.values[i-1]];
		}
		_set.values = new bytes4[](0);
		return true;
	}
}

library LibMap2_bytes4_address_bytes {
	using LibSet_bytes4 for LibSet_bytes4.set;

	struct map
	{
		LibSet_bytes4.set keyset;
		mapping(bytes4 => address) values1;
		mapping(bytes4 => bytes) values2;
	}

	function length(map storage _map)
	internal view returns (uint256)
	{
		return _map.keyset.length();
	}

	function value1(map storage _map, bytes4  _key)
	internal view returns (address )
	{
		return _map.values1[_key];
	}

	function value2(map storage _map, bytes4  _key)
	internal view returns (bytes memory)
	{
		return _map.values2[_key];
	}

	function keyAt(map storage _map, uint256 _index)
	internal view returns (bytes4 )
	{
		return _map.keyset.at(_index);
	}

	function at(map storage _map, uint256 _index)
	internal view returns (bytes4 , address , bytes memory)
	{
		bytes4  key = keyAt(_map, _index);
		return (key, value1(_map, key), value2(_map, key));
	}

	function indexOf(map storage _map, bytes4  _key)
	internal view returns (uint256)
	{
		return _map.keyset.indexOf(_key);
	}

	function contains(map storage _map, bytes4  _key)
	internal view returns (bool)
	{
		return _map.keyset.contains(_key);
	}

	function keys(map storage _map)
	internal view returns (bytes4[] memory)
	{
		return _map.keyset.content();
	}

	function set(
		map storage _map,
		bytes4  _key,
		address  _value1,
		bytes memory _value2)
	internal returns (bool)
	{
		_map.keyset.add(_key);
		_map.values1[_key] = _value1;
		_map.values2[_key] = _value2;
		return true;
	}

	function del(map storage _map, bytes4  _key)
	internal returns (bool)
	{
		_map.keyset.remove(_key);
		delete _map.values1[_key];
		delete _map.values2[_key];
		return true;
	}

	function clear(map storage _map)
	internal returns (bool)
	{
		for (uint256 i = _map.keyset.length(); i > 0; --i)
		{
			bytes4  key = keyAt(_map, i);
			delete _map.values1[key];
			delete _map.values2[key];
		}
		_map.keyset.clear();
		return true;
	}
}

interface IERC1538 {
	event CommitMessage(string message);
	event FunctionUpdate(bytes4 indexed functionId, address indexed oldDelegate, address indexed newDelegate, string functionSignature);
}

contract ERC1538Store is Ownable
{
	using LibMap2_bytes4_address_bytes for LibMap2_bytes4_address_bytes.map;

	LibMap2_bytes4_address_bytes.map internal m_funcs;
}

contract ERC1538Core is IERC1538, ERC1538Store
{
	bytes4 constant internal RECEIVE  = 0xd217fcc6; // bytes4(keccak256("receive"));
	bytes4 constant internal FALLBACK = 0xb32cdf4d; // bytes4(keccak256("fallback"));

	event CommitMessage(string message);
	event FunctionUpdate(bytes4 indexed functionId, address indexed oldDelegate, address indexed newDelegate, string functionSignature);

	function _setFunc(string memory funcSignature, address funcDelegate)
	internal
	{
		bytes4 funcId = bytes4(keccak256(bytes(funcSignature)));
		if (funcId == RECEIVE ) { funcId = bytes4(0x00000000); }
		if (funcId == FALLBACK) { funcId = bytes4(0xFFFFFFFF); }

		address oldDelegate = m_funcs.value1(funcId);

		if (funcDelegate == oldDelegate) // No change → skip
		{
			return;
		}
		else if (funcDelegate == address(0)) // Delete
		{
			m_funcs.del(funcId);
		}
		else // Set / Update
		{
			m_funcs.set(funcId, funcDelegate, bytes(funcSignature));
		}

		emit FunctionUpdate(funcId, oldDelegate, funcDelegate, funcSignature);
	}
}

contract ERC1538Module is ERC1538Store
{
	constructor()
	public
	{
		renounceOwnership();
	}
}

interface ERC1538Query
{
	function totalFunctions            (                           ) external view returns(uint256);
	function functionByIndex           (uint256          _index    ) external view returns(string memory, bytes4, address);
	function functionById              (bytes4           _id       ) external view returns(string memory, bytes4, address);
	function functionExists            (string  calldata _signature) external view returns(bool);
	function functionSignatures        (                           ) external view returns(string memory);
	function delegateFunctionSignatures(address          _delegate ) external view returns(string memory);
	function delegateAddress           (string  calldata _signature) external view returns(address);
	function delegateAddresses         (                           ) external view returns(address[] memory);
}

contract ERC1538QueryDelegate is ERC1538Query, ERC1538Module
{
	function totalFunctions()
	external override view returns(uint256)
	{
		return m_funcs.length();
	}

	function functionByIndex(uint256 _index)
	external override view returns(string memory signature, bytes4 id, address delegate)
	{
		(bytes4 funcId, address funcDelegate, bytes memory funcSignature) = m_funcs.at(_index + 1);
		return (string(funcSignature), funcId, funcDelegate);
	}

	function functionById(bytes4 _funcId)
	external override view returns(string memory signature, bytes4 id, address delegate)
	{
		return (string(m_funcs.value2(_funcId)), _funcId, m_funcs.value1(_funcId));
	}

	function functionExists(string calldata _funcSignature)
	external override view returns(bool)
	{
		return m_funcs.contains(bytes4(keccak256(bytes(_funcSignature))));
	}

	function delegateAddress(string calldata _funcSignature)
	external override view returns(address)
	{
		return m_funcs.value1(bytes4(keccak256(bytes(_funcSignature))));
	}

	function functionSignatures()
	external override view returns(string memory)
	{
		uint256 signaturesLength = 0;
		for (uint256 i = 1; i <= m_funcs.length(); ++i)
		{
			signaturesLength += m_funcs.value2(m_funcs.keyAt(i)).length + 1; // EDIT
		}

		bytes memory signatures = new bytes(signaturesLength);
		uint256 charPos = 0;
		for (uint256 i = 1; i <= m_funcs.length(); ++i)
		{
			bytes memory signature = m_funcs.value2(m_funcs.keyAt(i));
			for (uint256 c = 0; c < signature.length; ++c)
			{
				signatures[charPos] = signature[c];
				++charPos;
			}
			signatures[charPos] = 0x3B;
			++charPos;
		}

		return string(signatures);
	}

	function delegateFunctionSignatures(address _delegate)
	external override view returns(string memory)
	{
		bytes[] memory delegateSignatures = new bytes[](m_funcs.length());
		uint256 delegateSignaturesLength = 0;

		uint256 signaturesLength = 0;
		for (uint256 i = 1; i <= m_funcs.length(); ++i)
		{
			(bytes4 funcId, address funcDelegate, bytes memory funcSignature) = m_funcs.at(i);
			if (_delegate == funcDelegate)
			{
				signaturesLength += funcSignature.length + 1;
				delegateSignatures[delegateSignaturesLength] = funcSignature;
				++delegateSignaturesLength;
			}
		}

		bytes memory signatures = new bytes(signaturesLength);
		uint256 charPos = 0;
		for (uint256 i = 0; i < delegateSignaturesLength; ++i)
		{
			bytes memory signature = delegateSignatures[i];
			for (uint256 c = 0; c < signature.length; ++c)
			{
				signatures[charPos] = signature[c];
				++charPos;
			}
			signatures[charPos] = 0x3B;
			++charPos;
		}

		return string(signatures);
	}

	function delegateAddresses()
	external override view returns(address[] memory)
	{
		address[] memory delegatesBucket = new address[](m_funcs.length());

		uint256 numDelegates = 0;
		for (uint256 i = 1; i <= m_funcs.length(); ++i)
		{
			address delegate = m_funcs.value1(m_funcs.keyAt(i));
			bool seen = false;
			for (uint256 j = 0; j < numDelegates; ++j)
			{
				if (delegate == delegatesBucket[j])
				{
					seen = true;
					break;
				}
			}
			if (seen == false)
			{
				delegatesBucket[numDelegates] = delegate;
				++numDelegates;
			}
		}

		address[] memory delegates = new address[](numDelegates);
		for (uint256 i = 0; i < numDelegates; ++i)
		{
			delegates[i] = delegatesBucket[i];
		}
		return delegates;
	}
}