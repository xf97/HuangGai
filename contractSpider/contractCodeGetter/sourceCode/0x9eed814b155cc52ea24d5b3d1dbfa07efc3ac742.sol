/**
 *Submitted for verification at Etherscan.io on 2020-06-15
*/

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

// File: contracts/converter/interfaces/IConverterUpgrader.sol

pragma solidity 0.4.26;

/*
    Converter Upgrader interface
*/
contract IConverterUpgrader {
    function upgrade(bytes32 _version) public;
    function upgrade(uint16 _version) public;
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

// File: contracts/converter/interfaces/IConverterFactory.sol

pragma solidity 0.4.26;




/*
    Converter Factory interface
*/
contract IConverterFactory {
    function createAnchor(uint16 _type, string _name, string _symbol, uint8 _decimals) public returns (IConverterAnchor);
    function createConverter(uint16 _type, IConverterAnchor _anchor, IContractRegistry _registry, uint32 _maxConversionFee) public returns (IConverter);
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

// File: contracts/token/interfaces/IEtherToken.sol

pragma solidity 0.4.26;


/*
    Ether Token interface
*/
contract IEtherToken is IERC20Token {
    function deposit() public payable;
    function withdraw(uint256 _amount) public;
    function depositTo(address _to) public payable;
    function withdrawTo(address _to, uint256 _amount) public;
}

// File: contracts/converter/ConverterUpgrader.sol

pragma solidity 0.4.26;







/**
  * @dev Converter Upgrader
  *
  * The converter upgrader contract allows upgrading an older converter contract (0.4 and up)
  * to the latest version.
  * To begin the upgrade process, simply execute the 'upgrade' function.
  * At the end of the process, the ownership of the newly upgraded converter will be transferred
  * back to the original owner and the original owner will need to execute the 'acceptOwnership' function.
  *
  * The address of the new converter is available in the ConverterUpgrade event.
  *
  * Note that for older converters that don't yet have the 'upgrade' function, ownership should first
  * be transferred manually to the ConverterUpgrader contract using the 'transferOwnership' function
  * and then the upgrader 'upgrade' function should be executed directly.
*/
contract ConverterUpgrader is IConverterUpgrader, ContractRegistryClient {
    address private constant ETH_RESERVE_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    IEtherToken public etherToken;

    /**
      * @dev triggered when the contract accept a converter ownership
      *
      * @param _converter   converter address
      * @param _owner       new owner - local upgrader address
    */
    event ConverterOwned(address indexed _converter, address indexed _owner);

    /**
      * @dev triggered when the upgrading process is done
      *
      * @param _oldConverter    old converter address
      * @param _newConverter    new converter address
    */
    event ConverterUpgrade(address indexed _oldConverter, address indexed _newConverter);

    /**
      * @dev initializes a new ConverterUpgrader instance
      *
      * @param _registry    address of a contract registry contract
    */
    constructor(IContractRegistry _registry, IEtherToken _etherToken) ContractRegistryClient(_registry) public {
        etherToken = _etherToken;
    }

    /**
      * @dev upgrades an old converter to the latest version
      * will throw if ownership wasn't transferred to the upgrader before calling this function.
      * ownership of the new converter will be transferred back to the original owner.
      * fires the ConverterUpgrade event upon success.
      * can only be called by a converter
      *
      * @param _version old converter version
    */
    function upgrade(bytes32 _version) public {
        upgradeOld(IConverter(msg.sender), _version);
    }

    /**
      * @dev upgrades an old converter to the latest version
      * will throw if ownership wasn't transferred to the upgrader before calling this function.
      * ownership of the new converter will be transferred back to the original owner.
      * fires the ConverterUpgrade event upon success.
      * can only be called by a converter
      *
      * @param _version old converter version
    */
    function upgrade(uint16 _version) public {
        upgradeOld(IConverter(msg.sender), bytes32(_version));
    }

    /**
      * @dev upgrades an old converter to the latest version
      * will throw if ownership wasn't transferred to the upgrader before calling this function.
      * ownership of the new converter will be transferred back to the original owner.
      * fires the ConverterUpgrade event upon success.
      *
      * @param _converter   old converter contract address
      * @param _version     old converter version
    */
    function upgradeOld(IConverter _converter, bytes32 _version) public {
        _version;
        IConverter converter = IConverter(_converter);
        address prevOwner = converter.owner();
        acceptConverterOwnership(converter);
        IConverter newConverter = createConverter(converter);
        copyReserves(converter, newConverter);
        copyConversionFee(converter, newConverter);
        transferReserveBalances(converter, newConverter);
        IConverterAnchor anchor = converter.token();

        if (anchor.owner() == address(converter)) {
            converter.transferTokenOwnership(newConverter);
            newConverter.acceptAnchorOwnership();
        }

        converter.transferOwnership(prevOwner);
        newConverter.transferOwnership(prevOwner);

        emit ConverterUpgrade(address(converter), address(newConverter));
    }

    /**
      * @dev the first step when upgrading a converter is to transfer the ownership to the local contract.
      * the upgrader contract then needs to accept the ownership transfer before initiating
      * the upgrade process.
      * fires the ConverterOwned event upon success
      *
      * @param _oldConverter       converter to accept ownership of
    */
    function acceptConverterOwnership(IConverter _oldConverter) private {
        _oldConverter.acceptOwnership();
        emit ConverterOwned(_oldConverter, this);
    }

    /**
      * @dev creates a new converter with same basic data as the original old converter
      * the newly created converter will have no reserves at this step.
      *
      * @param _oldConverter    old converter contract address
      *
      * @return the new converter  new converter contract address
    */
    function createConverter(IConverter _oldConverter) private returns (IConverter) {
        IConverterAnchor anchor = _oldConverter.token();
        uint32 maxConversionFee = _oldConverter.maxConversionFee();
        uint16 reserveTokenCount = _oldConverter.connectorTokenCount();

        // determine new converter type
        uint16 newType = 0;
        // new converter - get the type from the converter itself
        if (isV28OrHigherConverter(_oldConverter))
            newType = _oldConverter.converterType();
        // old converter - if it has 1 reserve token, the type is a liquid token, otherwise the type liquidity pool
        else if (reserveTokenCount > 1)
            newType = 1;

        IConverterFactory converterFactory = IConverterFactory(addressOf(CONVERTER_FACTORY));
        IConverter converter = converterFactory.createConverter(newType, anchor, registry, maxConversionFee);

        converter.acceptOwnership();
        return converter;
    }

    /**
      * @dev copies the reserves from the old converter to the new one.
      * note that this will not work for an unlimited number of reserves due to block gas limit constraints.
      *
      * @param _oldConverter    old converter contract address
      * @param _newConverter    new converter contract address
    */
    function copyReserves(IConverter _oldConverter, IConverter _newConverter)
        private
    {
        uint16 reserveTokenCount = _oldConverter.connectorTokenCount();

        for (uint16 i = 0; i < reserveTokenCount; i++) {
            address reserveAddress = _oldConverter.connectorTokens(i);
            (, uint32 weight, , , ) = _oldConverter.connectors(reserveAddress);

            // Ether reserve
            if (reserveAddress == ETH_RESERVE_ADDRESS) {
                _newConverter.addReserve(IERC20Token(ETH_RESERVE_ADDRESS), weight);
            }
            // Ether reserve token
            else if (reserveAddress == address(etherToken)) {
                _newConverter.addReserve(IERC20Token(ETH_RESERVE_ADDRESS), weight);
            }
            // ERC20 reserve token
            else {
                _newConverter.addReserve(IERC20Token(reserveAddress), weight);
            }
        }
    }

    /**
      * @dev copies the conversion fee from the old converter to the new one
      *
      * @param _oldConverter    old converter contract address
      * @param _newConverter    new converter contract address
    */
    function copyConversionFee(IConverter _oldConverter, IConverter _newConverter) private {
        uint32 conversionFee = _oldConverter.conversionFee();
        _newConverter.setConversionFee(conversionFee);
    }

    /**
      * @dev transfers the balance of each reserve in the old converter to the new one.
      * note that the function assumes that the new converter already has the exact same number of
      * also, this will not work for an unlimited number of reserves due to block gas limit constraints.
      *
      * @param _oldConverter    old converter contract address
      * @param _newConverter    new converter contract address
    */
    function transferReserveBalances(IConverter _oldConverter, IConverter _newConverter)
        private
    {
        uint256 reserveBalance;
        uint16 reserveTokenCount = _oldConverter.connectorTokenCount();

        for (uint16 i = 0; i < reserveTokenCount; i++) {
            address reserveAddress = _oldConverter.connectorTokens(i);
            // Ether reserve
            if (reserveAddress == ETH_RESERVE_ADDRESS) {
                _oldConverter.withdrawETH(address(_newConverter));
            }
            // Ether reserve token
            else if (reserveAddress == address(etherToken)) {
                reserveBalance = etherToken.balanceOf(_oldConverter);
                _oldConverter.withdrawTokens(etherToken, address(this), reserveBalance);
                etherToken.withdrawTo(address(_newConverter), reserveBalance);
            }
            // ERC20 reserve token
            else {
                IERC20Token connector = IERC20Token(reserveAddress);
                reserveBalance = connector.balanceOf(_oldConverter);
                _oldConverter.withdrawTokens(connector, address(_newConverter), reserveBalance);
            }
        }
    }

    bytes4 private constant IS_V28_OR_HIGHER_FUNC_SELECTOR = bytes4(keccak256("isV28OrHigher()"));

    // using assembly code to identify converter version
    // can't rely on the version number since the function had a different signature in older converters
    function isV28OrHigherConverter(IConverter _converter) internal view returns (bool) {
        bool success;
        uint256[1] memory ret;
        bytes memory data = abi.encodeWithSelector(IS_V28_OR_HIGHER_FUNC_SELECTOR);

        assembly {
            success := staticcall(
                gas,           // gas remaining
                _converter,    // destination address
                add(data, 32), // input buffer (starts after the first 32 bytes in the `data` array)
                mload(data),   // input length (loaded from the first 32 bytes in the `data` array)
                ret,           // output buffer
                32             // output length
            )
        }

        return success;
    }
}