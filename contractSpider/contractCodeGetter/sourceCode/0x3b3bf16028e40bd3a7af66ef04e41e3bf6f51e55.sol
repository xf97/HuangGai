/**
 *Submitted for verification at Etherscan.io on 2020-06-15
*/

// File: contracts/token/interfaces/IERC20Token.sol

pragma solidity 0.4.26;

/*
    ERC20 Standard Token interface
*/
contract IERC20Token {
    // these functions aren't abstract since the compiler emits automatically generated getter functions as external
    function name() public view returns (string) {this;}
    function symbol() public view returns (string) {this;}
    function decimals() public view returns (uint8) {this;}
    function totalSupply() public view returns (uint256) {this;}
    function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
    function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}

    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
}

// File: contracts/utility/TokenHandler.sol

pragma solidity 0.4.26;


contract TokenHandler {
    bytes4 private constant APPROVE_FUNC_SELECTOR = bytes4(keccak256("approve(address,uint256)"));
    bytes4 private constant TRANSFER_FUNC_SELECTOR = bytes4(keccak256("transfer(address,uint256)"));
    bytes4 private constant TRANSFER_FROM_FUNC_SELECTOR = bytes4(keccak256("transferFrom(address,address,uint256)"));

    /**
      * @dev executes the ERC20 token's `approve` function and reverts upon failure
      * the main purpose of this function is to prevent a non standard ERC20 token
      * from failing silently
      *
      * @param _token   ERC20 token address
      * @param _spender approved address
      * @param _value   allowance amount
    */
    function safeApprove(IERC20Token _token, address _spender, uint256 _value) public {
       execute(_token, abi.encodeWithSelector(APPROVE_FUNC_SELECTOR, _spender, _value));
    }

    /**
      * @dev executes the ERC20 token's `transfer` function and reverts upon failure
      * the main purpose of this function is to prevent a non standard ERC20 token
      * from failing silently
      *
      * @param _token   ERC20 token address
      * @param _to      target address
      * @param _value   transfer amount
    */
    function safeTransfer(IERC20Token _token, address _to, uint256 _value) public {
       execute(_token, abi.encodeWithSelector(TRANSFER_FUNC_SELECTOR, _to, _value));
    }

    /**
      * @dev executes the ERC20 token's `transferFrom` function and reverts upon failure
      * the main purpose of this function is to prevent a non standard ERC20 token
      * from failing silently
      *
      * @param _token   ERC20 token address
      * @param _from    source address
      * @param _to      target address
      * @param _value   transfer amount
    */
    function safeTransferFrom(IERC20Token _token, address _from, address _to, uint256 _value) public {
       execute(_token, abi.encodeWithSelector(TRANSFER_FROM_FUNC_SELECTOR, _from, _to, _value));
    }

    /**
      * @dev executes a function on the ERC20 token and reverts upon failure
      * the main purpose of this function is to prevent a non standard ERC20 token
      * from failing silently
      *
      * @param _token   ERC20 token address
      * @param _data    data to pass in to the token's contract for execution
    */
    function execute(IERC20Token _token, bytes memory _data) private {
        uint256[1] memory ret = [uint256(1)];

        assembly {
            let success := call(
                gas,            // gas remaining
                _token,         // destination address
                0,              // no ether
                add(_data, 32), // input buffer (starts after the first 32 bytes in the `data` array)
                mload(_data),   // input length (loaded from the first 32 bytes in the `data` array)
                ret,            // output buffer
                32              // output length
            )
            if iszero(success) {
                revert(0, 0)
            }
        }

        require(ret[0] != 0, "ERR_TRANSFER_FAILED");
    }
}

// File: contracts/utility/interfaces/IOwned.sol

pragma solidity 0.4.26;

/*
    Owned contract interface
*/
contract IOwned {
    // this function isn't abstract since the compiler emits automatically generated getter functions as external
    function owner() public view returns (address) {this;}

    function transferOwnership(address _newOwner) public;
    function acceptOwnership() public;
}

// File: contracts/utility/Owned.sol

pragma solidity 0.4.26;


/**
  * @dev Provides support and utilities for contract ownership
*/
contract Owned is IOwned {
    address public owner;
    address public newOwner;

    /**
      * @dev triggered when the owner is updated
      *
      * @param _prevOwner previous owner
      * @param _newOwner  new owner
    */
    event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);

    /**
      * @dev initializes a new Owned instance
    */
    constructor() public {
        owner = msg.sender;
    }

    // allows execution by the owner only
    modifier ownerOnly {
        _ownerOnly();
        _;
    }

    // error message binary size optimization
    function _ownerOnly() internal view {
        require(msg.sender == owner, "ERR_ACCESS_DENIED");
    }

    /**
      * @dev allows transferring the contract ownership
      * the new owner still needs to accept the transfer
      * can only be called by the contract owner
      *
      * @param _newOwner    new contract owner
    */
    function transferOwnership(address _newOwner) public ownerOnly {
        require(_newOwner != owner, "ERR_SAME_OWNER");
        newOwner = _newOwner;
    }

    /**
      * @dev used by a new owner to accept an ownership transfer
    */
    function acceptOwnership() public {
        require(msg.sender == newOwner, "ERR_ACCESS_DENIED");
        emit OwnerUpdate(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

// File: contracts/utility/Utils.sol

pragma solidity 0.4.26;

/**
  * @dev Utilities & Common Modifiers
*/
contract Utils {
    // verifies that a value is greater than zero
    modifier greaterThanZero(uint256 _value) {
        _greaterThanZero(_value);
        _;
    }

    // error message binary size optimization
    function _greaterThanZero(uint256 _value) internal pure {
        require(_value > 0, "ERR_ZERO_VALUE");
    }

    // validates an address - currently only checks that it isn't null
    modifier validAddress(address _address) {
        _validAddress(_address);
        _;
    }

    // error message binary size optimization
    function _validAddress(address _address) internal pure {
        require(_address != address(0), "ERR_INVALID_ADDRESS");
    }

    // verifies that the address is different than this contract address
    modifier notThis(address _address) {
        _notThis(_address);
        _;
    }

    // error message binary size optimization
    function _notThis(address _address) internal view {
        require(_address != address(this), "ERR_ADDRESS_IS_SELF");
    }
}

// File: contracts/utility/interfaces/IContractRegistry.sol

pragma solidity 0.4.26;

/*
    Contract Registry interface
*/
contract IContractRegistry {
    function addressOf(bytes32 _contractName) public view returns (address);

    // deprecated, backward compatibility
    function getAddress(bytes32 _contractName) public view returns (address);
}

// File: contracts/utility/ContractRegistryClient.sol

pragma solidity 0.4.26;




/**
  * @dev Base contract for ContractRegistry clients
*/
contract ContractRegistryClient is Owned, Utils {
    bytes32 internal constant CONTRACT_REGISTRY = "ContractRegistry";
    bytes32 internal constant BANCOR_NETWORK = "BancorNetwork";
    bytes32 internal constant BANCOR_FORMULA = "BancorFormula";
    bytes32 internal constant CONVERTER_FACTORY = "ConverterFactory";
    bytes32 internal constant CONVERSION_PATH_FINDER = "ConversionPathFinder";
    bytes32 internal constant CONVERTER_UPGRADER = "BancorConverterUpgrader";
    bytes32 internal constant CONVERTER_REGISTRY = "BancorConverterRegistry";
    bytes32 internal constant CONVERTER_REGISTRY_DATA = "BancorConverterRegistryData";
    bytes32 internal constant BNT_TOKEN = "BNTToken";
    bytes32 internal constant BANCOR_X = "BancorX";
    bytes32 internal constant BANCOR_X_UPGRADER = "BancorXUpgrader";

    IContractRegistry public registry;      // address of the current contract-registry
    IContractRegistry public prevRegistry;  // address of the previous contract-registry
    bool public onlyOwnerCanUpdateRegistry; // only an owner can update the contract-registry

    /**
      * @dev verifies that the caller is mapped to the given contract name
      *
      * @param _contractName    contract name
    */
    modifier only(bytes32 _contractName) {
        _only(_contractName);
        _;
    }

    // error message binary size optimization
    function _only(bytes32 _contractName) internal view {
        require(msg.sender == addressOf(_contractName), "ERR_ACCESS_DENIED");
    }

    /**
      * @dev initializes a new ContractRegistryClient instance
      *
      * @param  _registry   address of a contract-registry contract
    */
    constructor(IContractRegistry _registry) internal validAddress(_registry) {
        registry = IContractRegistry(_registry);
        prevRegistry = IContractRegistry(_registry);
    }

    /**
      * @dev updates to the new contract-registry
     */
    function updateRegistry() public {
        // verify that this function is permitted
        require(msg.sender == owner || !onlyOwnerCanUpdateRegistry, "ERR_ACCESS_DENIED");

        // get the new contract-registry
        IContractRegistry newRegistry = IContractRegistry(addressOf(CONTRACT_REGISTRY));

        // verify that the new contract-registry is different and not zero
        require(newRegistry != address(registry) && newRegistry != address(0), "ERR_INVALID_REGISTRY");

        // verify that the new contract-registry is pointing to a non-zero contract-registry
        require(newRegistry.addressOf(CONTRACT_REGISTRY) != address(0), "ERR_INVALID_REGISTRY");

        // save a backup of the current contract-registry before replacing it
        prevRegistry = registry;

        // replace the current contract-registry with the new contract-registry
        registry = newRegistry;
    }

    /**
      * @dev restores the previous contract-registry
    */
    function restoreRegistry() public ownerOnly {
        // restore the previous contract-registry
        registry = prevRegistry;
    }

    /**
      * @dev restricts the permission to update the contract-registry
      *
      * @param _onlyOwnerCanUpdateRegistry  indicates whether or not permission is restricted to owner only
    */
    function restrictRegistryUpdate(bool _onlyOwnerCanUpdateRegistry) public ownerOnly {
        // change the permission to update the contract-registry
        onlyOwnerCanUpdateRegistry = _onlyOwnerCanUpdateRegistry;
    }

    /**
      * @dev returns the address associated with the given contract name
      *
      * @param _contractName    contract name
      *
      * @return contract address
    */
    function addressOf(bytes32 _contractName) internal view returns (address) {
        return registry.addressOf(_contractName);
    }
}

// File: contracts/utility/interfaces/ITokenHolder.sol

pragma solidity 0.4.26;



/*
    Token Holder interface
*/
contract ITokenHolder is IOwned {
    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
}

// File: contracts/converter/interfaces/IConverterAnchor.sol

pragma solidity 0.4.26;



/*
    Converter Anchor interface
*/
contract IConverterAnchor is IOwned, ITokenHolder {
}

// File: contracts/utility/interfaces/IWhitelist.sol

pragma solidity 0.4.26;

/*
    Whitelist interface
*/
contract IWhitelist {
    function isWhitelisted(address _address) public view returns (bool);
}

// File: contracts/converter/interfaces/IConverter.sol

pragma solidity 0.4.26;





/*
    Converter interface
*/
contract IConverter is IOwned {
    function converterType() public pure returns (uint16);
    function anchor() public view returns (IConverterAnchor) {this;}
    function isActive() public view returns (bool);

    function rateAndFee(IERC20Token _sourceToken, IERC20Token _targetToken, uint256 _amount) public view returns (uint256, uint256);
    function convert(IERC20Token _sourceToken,
                     IERC20Token _targetToken,
                     uint256 _amount,
                     address _trader,
                     address _beneficiary) public payable returns (uint256);

    function conversionWhitelist() public view returns (IWhitelist) {this;}
    function conversionFee() public view returns (uint32) {this;}
    function maxConversionFee() public view returns (uint32) {this;}
    function reserveBalance(IERC20Token _reserveToken) public view returns (uint256);
    function() external payable;

    function transferAnchorOwnership(address _newOwner) public;
    function acceptAnchorOwnership() public;
    function setConversionFee(uint32 _conversionFee) public;
    function setConversionWhitelist(IWhitelist _whitelist) public;
    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
    function withdrawETH(address _to) public;
    function addReserve(IERC20Token _token, uint32 _ratio) public;

    // deprecated, backward compatibility
    function token() public view returns (IConverterAnchor);
    function transferTokenOwnership(address _newOwner) public;
    function acceptTokenOwnership() public;
    function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool);
    function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
    function connectorTokens(uint256 _index) public view returns (IERC20Token);
    function connectorTokenCount() public view returns (uint16);
}

// File: contracts/converter/interfaces/IConverterFactory.sol

pragma solidity 0.4.26;




/*
    Converter Factory interface
*/
contract IConverterFactory {
    function createAnchor(uint16 _type, string _name, string _symbol, uint8 _decimals) public returns (IConverterAnchor);
    function createConverter(uint16 _type, IConverterAnchor _anchor, IContractRegistry _registry, uint32 _maxConversionFee) public returns (IConverter);
}

// File: contracts/converter/interfaces/IConverterRegistry.sol

pragma solidity 0.4.26;

contract IConverterRegistry {
    function getAnchorCount() public view returns (uint256);
    function getAnchors() public view returns (address[]);
    function getAnchor(uint256 _index) public view returns (address);
    function isAnchor(address _value) public view returns (bool);
    function getLiquidityPoolCount() public view returns (uint256);
    function getLiquidityPools() public view returns (address[]);
    function getLiquidityPool(uint256 _index) public view returns (address);
    function isLiquidityPool(address _value) public view returns (bool);
    function getConvertibleTokenCount() public view returns (uint256);
    function getConvertibleTokens() public view returns (address[]);
    function getConvertibleToken(uint256 _index) public view returns (address);
    function isConvertibleToken(address _value) public view returns (bool);
    function getConvertibleTokenAnchorCount(address _convertibleToken) public view returns (uint256);
    function getConvertibleTokenAnchors(address _convertibleToken) public view returns (address[]);
    function getConvertibleTokenAnchor(address _convertibleToken, uint256 _index) public view returns (address);
    function isConvertibleTokenAnchor(address _convertibleToken, address _value) public view returns (bool);
}

// File: contracts/converter/interfaces/IConverterRegistryData.sol

pragma solidity 0.4.26;

interface IConverterRegistryData {
    function addSmartToken(address _smartToken) external;
    function removeSmartToken(address _smartToken) external;
    function addLiquidityPool(address _liquidityPool) external;
    function removeLiquidityPool(address _liquidityPool) external;
    function addConvertibleToken(address _convertibleToken, address _smartToken) external;
    function removeConvertibleToken(address _convertibleToken, address _smartToken) external;
    function getSmartTokenCount() external view returns (uint256);
    function getSmartTokens() external view returns (address[]);
    function getSmartToken(uint256 _index) external view returns (address);
    function isSmartToken(address _value) external view returns (bool);
    function getLiquidityPoolCount() external view returns (uint256);
    function getLiquidityPools() external view returns (address[]);
    function getLiquidityPool(uint256 _index) external view returns (address);
    function isLiquidityPool(address _value) external view returns (bool);
    function getConvertibleTokenCount() external view returns (uint256);
    function getConvertibleTokens() external view returns (address[]);
    function getConvertibleToken(uint256 _index) external view returns (address);
    function isConvertibleToken(address _value) external view returns (bool);
    function getConvertibleTokenSmartTokenCount(address _convertibleToken) external view returns (uint256);
    function getConvertibleTokenSmartTokens(address _convertibleToken) external view returns (address[]);
    function getConvertibleTokenSmartToken(address _convertibleToken, uint256 _index) external view returns (address);
    function isConvertibleTokenSmartToken(address _convertibleToken, address _value) external view returns (bool);
}

// File: contracts/converter/ConverterRegistry.sol

pragma solidity 0.4.26;







/**
  * @dev The ConverterRegistry maintains a list of all active converters in the Bancor Network.
  *
  * Since converters can be upgraded and thus their address can change, the registry actually keeps
  * converter anchors internally and not the converters themselves.
  * The active converter for each anchor can be easily accessed by querying the anchor's owner.
  *
  * The registry exposes 3 differnet lists that can be accessed and iterated, based on the use-case of the caller:
  * - anchors - can be used to get all the latest / historical data in the network
  * - Liquidity pools - can be used to get all liquidity pools for funding, liquidation etc.
  * - Convertible tokens - can be used to get all tokens that can be converted in the network (excluding pool
  *   tokens), and for each one - all anchors that hold it in their reserves
  *
  *
  * The contract fires events whenever one of the primitives is added to or removed from the registry
  *
  * The contract is upgradable.
*/
contract ConverterRegistry is IConverterRegistry, ContractRegistryClient, TokenHandler {
    address private constant ETH_RESERVE_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    /**
      * @dev triggered when a converter anchor is added to the registry
      *
      * @param _anchor smart token
    */
    event ConverterAnchorAdded(address indexed _anchor);

    /**
      * @dev triggered when a converter anchor is removed from the registry
      *
      * @param _anchor smart token
    */
    event ConverterAnchorRemoved(address indexed _anchor);

    /**
      * @dev triggered when a liquidity pool is added to the registry
      *
      * @param _liquidityPool liquidity pool
    */
    event LiquidityPoolAdded(address indexed _liquidityPool);

    /**
      * @dev triggered when a liquidity pool is removed from the registry
      *
      * @param _liquidityPool liquidity pool
    */
    event LiquidityPoolRemoved(address indexed _liquidityPool);

    /**
      * @dev triggered when a convertible token is added to the registry
      *
      * @param _convertibleToken convertible token
      * @param _smartToken associated smart token
    */
    event ConvertibleTokenAdded(address indexed _convertibleToken, address indexed _smartToken);

    /**
      * @dev triggered when a convertible token is removed from the registry
      *
      * @param _convertibleToken convertible token
      * @param _smartToken associated smart token
    */
    event ConvertibleTokenRemoved(address indexed _convertibleToken, address indexed _smartToken);

    /**
      * @dev deprecated, backward compatibility, use `ConverterAnchorAdded`
    */
    event SmartTokenAdded(address indexed _smartToken);

    /**
      * @dev deprecated, backward compatibility, use `ConverterAnchorRemoved`
    */
    event SmartTokenRemoved(address indexed _smartToken);

    /**
      * @dev initializes a new ConverterRegistry instance
      *
      * @param _registry address of a contract registry contract
    */
    constructor(IContractRegistry _registry) ContractRegistryClient(_registry) public {
    }

    /**
      * @dev creates a zero supply liquid token / empty liquidity pool and adds its converter to the registry
      *
      * @param _type                converter type, see ConverterBase contract main doc
      * @param _name                token / pool name
      * @param _symbol              token / pool symbol
      * @param _decimals            token / pool decimals
      * @param _maxConversionFee    maximum conversion-fee
      * @param _reserveTokens       reserve tokens
      * @param _reserveWeights      reserve weights
      *
      * @return new converter
    */
    function newConverter(
        uint16 _type,
        string _name,
        string _symbol,
        uint8 _decimals,
        uint32 _maxConversionFee,
        IERC20Token[] memory _reserveTokens,
        uint32[] memory _reserveWeights
    )
    public returns (IConverter)
    {
        uint256 length = _reserveTokens.length;
        require(length == _reserveWeights.length, "ERR_INVALID_RESERVES");
        require(getLiquidityPoolByConfig(_type, _reserveTokens, _reserveWeights) == IConverterAnchor(0), "ERR_ALREADY_EXISTS");

        IConverterFactory factory = IConverterFactory(addressOf(CONVERTER_FACTORY));
        IConverterAnchor anchor = IConverterAnchor(factory.createAnchor(_type, _name, _symbol, _decimals));
        IConverter converter = IConverter(factory.createConverter(_type, anchor, registry, _maxConversionFee));

        anchor.acceptOwnership();
        converter.acceptOwnership();

        for (uint256 i = 0; i < length; i++)
            converter.addReserve(_reserveTokens[i], _reserveWeights[i]);

        anchor.transferOwnership(converter);
        converter.acceptAnchorOwnership();
        converter.transferOwnership(msg.sender);

        addConverterInternal(converter);
        return converter;
    }

    /**
      * @dev adds an existing converter to the registry
      * can only be called by the owner
      *
      * @param _converter converter
    */
    function addConverter(IConverter _converter) public ownerOnly {
        require(isConverterValid(_converter), "ERR_INVALID_CONVERTER");
        addConverterInternal(_converter);
    }

    /**
      * @dev removes a converter from the registry
      * anyone can remove an existing converter from the registry, as long as the converter is invalid
      * note that the owner can also remove valid converters
      *
      * @param _converter converter
    */
    function removeConverter(IConverter _converter) public {
        require(msg.sender == owner || !isConverterValid(_converter), "ERR_ACCESS_DENIED");
        removeConverterInternal(_converter);
    }

    /**
      * @dev returns the number of converter anchors in the registry
      *
      * @return number of anchors
    */
    function getAnchorCount() public view returns (uint256) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).getSmartTokenCount();
    }

    /**
      * @dev returns the list of converter anchors in the registry
      *
      * @return list of anchors
    */
    function getAnchors() public view returns (address[]) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).getSmartTokens();
    }

    /**
      * @dev returns the converter anchor at a given index
      *
      * @param _index index
      * @return anchor at the given index
    */
    function getAnchor(uint256 _index) public view returns (address) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).getSmartToken(_index);
    }

    /**
      * @dev checks whether or not a given value is a converter anchor
      *
      * @param _value value
      * @return true if the given value is an anchor, false if not
    */
    function isAnchor(address _value) public view returns (bool) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).isSmartToken(_value);
    }

    /**
      * @dev returns the number of liquidity pools in the registry
      *
      * @return number of liquidity pools
    */
    function getLiquidityPoolCount() public view returns (uint256) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).getLiquidityPoolCount();
    }

    /**
      * @dev returns the list of liquidity pools in the registry
      *
      * @return list of liquidity pools
    */
    function getLiquidityPools() public view returns (address[]) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).getLiquidityPools();
    }

    /**
      * @dev returns the liquidity pool at a given index
      *
      * @param _index index
      * @return liquidity pool at the given index
    */
    function getLiquidityPool(uint256 _index) public view returns (address) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).getLiquidityPool(_index);
    }

    /**
      * @dev checks whether or not a given value is a liquidity pool
      *
      * @param _value value
      * @return true if the given value is a liquidity pool, false if not
    */
    function isLiquidityPool(address _value) public view returns (bool) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).isLiquidityPool(_value);
    }

    /**
      * @dev returns the number of convertible tokens in the registry
      *
      * @return number of convertible tokens
    */
    function getConvertibleTokenCount() public view returns (uint256) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).getConvertibleTokenCount();
    }

    /**
      * @dev returns the list of convertible tokens in the registry
      *
      * @return list of convertible tokens
    */
    function getConvertibleTokens() public view returns (address[]) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).getConvertibleTokens();
    }

    /**
      * @dev returns the convertible token at a given index
      *
      * @param _index index
      * @return convertible token at the given index
    */
    function getConvertibleToken(uint256 _index) public view returns (address) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).getConvertibleToken(_index);
    }

    /**
      * @dev checks whether or not a given value is a convertible token
      *
      * @param _value value
      * @return true if the given value is a convertible token, false if not
    */
    function isConvertibleToken(address _value) public view returns (bool) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).isConvertibleToken(_value);
    }

    /**
      * @dev returns the number of converter anchors associated with a given convertible token
      *
      * @param _convertibleToken convertible token
      * @return number of anchors associated with the given convertible token
    */
    function getConvertibleTokenAnchorCount(address _convertibleToken) public view returns (uint256) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).getConvertibleTokenSmartTokenCount(_convertibleToken);
    }

    /**
      * @dev returns the list of aoncerter anchors associated with a given convertible token
      *
      * @param _convertibleToken convertible token
      * @return list of anchors associated with the given convertible token
    */
    function getConvertibleTokenAnchors(address _convertibleToken) public view returns (address[]) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).getConvertibleTokenSmartTokens(_convertibleToken);
    }

    /**
      * @dev returns the converter anchor associated with a given convertible token at a given index
      *
      * @param _index index
      * @return anchor associated with the given convertible token at the given index
    */
    function getConvertibleTokenAnchor(address _convertibleToken, uint256 _index) public view returns (address) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).getConvertibleTokenSmartToken(_convertibleToken, _index);
    }

    /**
      * @dev checks whether or not a given value is a converter anchor of a given convertible token
      *
      * @param _convertibleToken convertible token
      * @param _value value
      * @return true if the given value is an anchor of the given convertible token, false if not
    */
    function isConvertibleTokenAnchor(address _convertibleToken, address _value) public view returns (bool) {
        return IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA)).isConvertibleTokenSmartToken(_convertibleToken, _value);
    }

    /**
      * @dev returns a list of converters for a given list of anchors
      * this is a utility function that can be used to reduce the number of calls to the contract
      *
      * @param _anchors list of converter anchors
      * @return list of converters
    */
    function getConvertersByAnchors(address[] _anchors) public view returns (address[]) {
        address[] memory converters = new address[](_anchors.length);

        for (uint256 i = 0; i < _anchors.length; i++)
            converters[i] = IConverterAnchor(_anchors[i]).owner();

        return converters;
    }

    /**
      * @dev checks whether or not a given converter is valid
      *
      * @param _converter converter
      * @return true if the given converter is valid, false if not
    */
    function isConverterValid(IConverter _converter) public view returns (bool) {
        // verify that the converter is active
        return _converter.token().owner() == address(_converter);
    }

    /**
      * @dev checks if a liquidity pool with given configuration is already registered
      *
      * @param _converter converter with specific configuration
      * @return if a liquidity pool with the same configuration is already registered
    */
    function isSimilarLiquidityPoolRegistered(IConverter _converter) public view returns (bool) {
        uint256 reserveTokenCount = _converter.connectorTokenCount();
        IERC20Token[] memory reserveTokens = new IERC20Token[](reserveTokenCount);
        uint32[] memory reserveWeights = new uint32[](reserveTokenCount);

        // get the reserve-configuration of the converter
        for (uint256 i = 0; i < reserveTokenCount; i++) {
            IERC20Token reserveToken = _converter.connectorTokens(i);
            reserveTokens[i] = reserveToken;
            reserveWeights[i] = getReserveWeight(_converter, reserveToken);
        }

        // return if a liquidity pool with the same configuration is already registered
        return getLiquidityPoolByConfig(_converter.converterType(), reserveTokens, reserveWeights) != IConverterAnchor(0);
    }

    /**
      * @dev searches for a liquidity pool with specific configuration
      *
      * @param _type            converter type, see ConverterBase contract main doc
      * @param _reserveTokens   reserve tokens
      * @param _reserveWeights  reserve weights
      * @return the liquidity pool, or zero if no such liquidity pool exists
    */
    function getLiquidityPoolByConfig(uint16 _type, IERC20Token[] memory _reserveTokens, uint32[] memory _reserveWeights) public view returns (IConverterAnchor) {
        // verify that the input parameters represent a valid liquidity pool
        if (_reserveTokens.length == _reserveWeights.length && _reserveTokens.length > 1) {
            // get the anchors of the least frequent token (optimization)
            address[] memory convertibleTokenAnchors = getLeastFrequentTokenAnchors(_reserveTokens);
            // search for a converter with the same configuration
            for (uint256 i = 0; i < convertibleTokenAnchors.length; i++) {
                IConverterAnchor anchor = IConverterAnchor(convertibleTokenAnchors[i]);
                IConverter converter = IConverter(anchor.owner());
                if (isConverterReserveConfigEqual(converter, _type, _reserveTokens, _reserveWeights))
                    return anchor;
            }
        }

        return IConverterAnchor(0);
    }

    /**
      * @dev adds a converter anchor to the registry
      *
      * @param _anchor converter anchor
    */
    function addAnchor(IConverterRegistryData _converterRegistryData, address _anchor) internal {
        _converterRegistryData.addSmartToken(_anchor);
        emit ConverterAnchorAdded(_anchor);
        emit SmartTokenAdded(_anchor);
    }

    /**
      * @dev removes a converter anchor from the registry
      *
      * @param _anchor converter anchor
    */
    function removeAnchor(IConverterRegistryData _converterRegistryData, address _anchor) internal {
        _converterRegistryData.removeSmartToken(_anchor);
        emit ConverterAnchorRemoved(_anchor);
        emit SmartTokenRemoved(_anchor);
    }

    /**
      * @dev adds a liquidity pool to the registry
      *
      * @param _liquidityPool liquidity pool
    */
    function addLiquidityPool(IConverterRegistryData _converterRegistryData, address _liquidityPool) internal {
        _converterRegistryData.addLiquidityPool(_liquidityPool);
        emit LiquidityPoolAdded(_liquidityPool);
    }

    /**
      * @dev removes a liquidity pool from the registry
      *
      * @param _liquidityPool liquidity pool
    */
    function removeLiquidityPool(IConverterRegistryData _converterRegistryData, address _liquidityPool) internal {
        _converterRegistryData.removeLiquidityPool(_liquidityPool);
        emit LiquidityPoolRemoved(_liquidityPool);
    }

    /**
      * @dev adds a convertible token to the registry
      *
      * @param _convertibleToken    convertible token
      * @param _anchor              associated converter anchor
    */
    function addConvertibleToken(IConverterRegistryData _converterRegistryData, address _convertibleToken, address _anchor) internal {
        _converterRegistryData.addConvertibleToken(_convertibleToken, _anchor);
        emit ConvertibleTokenAdded(_convertibleToken, _anchor);
    }

    /**
      * @dev removes a convertible token from the registry
      *
      * @param _convertibleToken    convertible token
      * @param _anchor              associated converter anchor
    */
    function removeConvertibleToken(IConverterRegistryData _converterRegistryData, address _convertibleToken, address _anchor) internal {
        _converterRegistryData.removeConvertibleToken(_convertibleToken, _anchor);
        emit ConvertibleTokenRemoved(_convertibleToken, _anchor);
    }

    function addConverterInternal(IConverter _converter) private {
        IConverterRegistryData converterRegistryData = IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA));
        IConverterAnchor anchor = IConverter(_converter).token();
        uint256 reserveTokenCount = _converter.connectorTokenCount();

        // add the converter anchor
        addAnchor(converterRegistryData, anchor);
        if (reserveTokenCount > 1)
            addLiquidityPool(converterRegistryData, anchor);
        else
            addConvertibleToken(converterRegistryData, anchor, anchor);

        // add all reserve tokens
        for (uint256 i = 0; i < reserveTokenCount; i++)
            addConvertibleToken(converterRegistryData, _converter.connectorTokens(i), anchor);
    }

    function removeConverterInternal(IConverter _converter) private {
        IConverterRegistryData converterRegistryData = IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA));
        IConverterAnchor anchor = IConverter(_converter).anchor();
        uint256 reserveTokenCount = _converter.connectorTokenCount();

        // remove the converter anchor
        removeAnchor(converterRegistryData, anchor);
        if (reserveTokenCount > 1)
            removeLiquidityPool(converterRegistryData, anchor);
        else
            removeConvertibleToken(converterRegistryData, anchor, anchor);

        // remove all reserve tokens
        for (uint256 i = 0; i < reserveTokenCount; i++)
            removeConvertibleToken(converterRegistryData, _converter.connectorTokens(i), anchor);
    }

    function getLeastFrequentTokenAnchors(IERC20Token[] memory _reserveTokens) private view returns (address[] memory) {
        IConverterRegistryData converterRegistryData = IConverterRegistryData(addressOf(CONVERTER_REGISTRY_DATA));
        uint256 minAnchorCount = converterRegistryData.getConvertibleTokenSmartTokenCount(_reserveTokens[0]);
        uint256 index = 0;

        // find the reserve token which has the smallest number of converter anchors
        for (uint256 i = 1; i < _reserveTokens.length; i++) {
            uint256 convertibleTokenAnchorCount = converterRegistryData.getConvertibleTokenSmartTokenCount(_reserveTokens[i]);
            if (minAnchorCount > convertibleTokenAnchorCount) {
                minAnchorCount = convertibleTokenAnchorCount;
                index = i;
            }
        }

        return converterRegistryData.getConvertibleTokenSmartTokens(_reserveTokens[index]);
    }

    function isConverterReserveConfigEqual(IConverter _converter, uint16 _type, IERC20Token[] memory _reserveTokens, uint32[] memory _reserveWeights) private view returns (bool) {
        if (_type != _converter.converterType())
            return false;

        if (_reserveTokens.length != _converter.connectorTokenCount())
            return false;

        for (uint256 i = 0; i < _reserveTokens.length; i++) {
            if (_reserveWeights[i] != getReserveWeight(_converter, _reserveTokens[i]))
                return false;
        }

        return true;
    }

    bytes4 private constant CONNECTORS_FUNC_SELECTOR = bytes4(keccak256("connectors(address)"));

    // assembly is used since older converters didn't have the `getReserveWeight` function, so getting the weight
    // requires calling the `connectors` property function, however that results in the `stack too deep` compiler
    // error so using assembly to circumvent that issue
    function getReserveWeight(address _converter, address _reserveToken) private view returns (uint32) {
        uint256[2] memory ret;
        bytes memory data = abi.encodeWithSelector(CONNECTORS_FUNC_SELECTOR, _reserveToken);

        assembly {
            let success := staticcall(
                gas,           // gas remaining
                _converter,    // destination address
                add(data, 32), // input buffer (starts after the first 32 bytes in the `data` array)
                mload(data),   // input length (loaded from the first 32 bytes in the `data` array)
                ret,           // output buffer
                64             // output length
            )
            if iszero(success) {
                revert(0, 0)
            }
        }

        return uint32(ret[1]);
    }

    /**
      * @dev deprecated, backward compatibility, use `getAnchorCount`
    */
    function getSmartTokenCount() public view returns (uint256) {
        return getAnchorCount();
    }

    /**
      * @dev deprecated, backward compatibility, use `getAnchors`
    */
    function getSmartTokens() public view returns (address[]) {
        return getAnchors();
    }

    /**
      * @dev deprecated, backward compatibility, use `getAnchor`
    */
    function getSmartToken(uint256 _index) public view returns (address) {
        return getAnchor(_index);
    }

    /**
      * @dev deprecated, backward compatibility, use `isAnchor`
    */
    function isSmartToken(address _value) public view returns (bool) {
        return isAnchor(_value);
    }

    /**
      * @dev deprecated, backward compatibility, use `getConvertibleTokenAnchorCount`
    */
    function getConvertibleTokenSmartTokenCount(address _convertibleToken) public view returns (uint256) {
        return getConvertibleTokenAnchorCount(_convertibleToken);
    }

    /**
      * @dev deprecated, backward compatibility, use `getConvertibleTokenAnchors`
    */
    function getConvertibleTokenSmartTokens(address _convertibleToken) public view returns (address[]) {
        return getConvertibleTokenAnchors(_convertibleToken);
    }

    /**
      * @dev deprecated, backward compatibility, use `getConvertibleTokenAnchor`
    */
    function getConvertibleTokenSmartToken(address _convertibleToken, uint256 _index) public view returns (address) {
        return getConvertibleTokenAnchor(_convertibleToken, _index);
    }

    /**
      * @dev deprecated, backward compatibility, use `isConvertibleTokenAnchor`
    */
    function isConvertibleTokenSmartToken(address _convertibleToken, address _value) public view returns (bool) {
        return isConvertibleTokenAnchor(_convertibleToken, _value);
    }

    /**
      * @dev deprecated, backward compatibility, use `getConvertersByAnchors`
    */
    function getConvertersBySmartTokens(address[] _smartTokens) public view returns (address[]) {
        return getConvertersByAnchors(_smartTokens);
    }

    /**
      * @dev deprecated, backward compatibility, use `getLiquidityPoolByConfig`
    */
    function getLiquidityPoolByReserveConfig(IERC20Token[] memory _reserveTokens, uint32[] memory _reserveWeights) public view returns (IConverterAnchor) {
        return getLiquidityPoolByConfig(1, _reserveTokens, _reserveWeights);
    }
}