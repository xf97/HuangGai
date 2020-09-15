/**
 *Submitted for verification at Etherscan.io on 2020-08-04
*/

/*

 Copyright 2018 RigoBlock, Rigo Investment Sagl.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

*/

pragma solidity 0.4.25;
pragma experimental "v0.5.0";

contract Owned {

    address public owner;

    event NewOwner(address indexed old, address indexed current);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function setOwner(address _new)
        public
        onlyOwner
    {
        require(_new != address(0));
        owner = _new;
        emit NewOwner(owner, _new);
    }
}

/// @title Exchange Authority Interface - A helper contract for the exchange adapters.
/// @author Gabriele Rigo - <gab@rigoblock.com>
// solhint-disable-next-line
interface ExchangesAuthorityFace {

    /*
     * EVENTS
     */
    event AuthoritySet(address indexed authority);
    event WhitelisterSet(address indexed whitelister);
    event WhitelistedAsset(address indexed asset, bool approved);
    event WhitelistedExchange(address indexed exchange, bool approved);
    event WhitelistedWrapper(address indexed wrapper, bool approved);
    event WhitelistedProxy(address indexed proxy, bool approved);
    event WhitelistedMethod(bytes4 indexed method, address indexed exchange, bool approved);
    event NewSigVerifier(address indexed sigVerifier);
    event NewExchangeEventful(address indexed exchangeEventful);
    event NewCasper(address indexed casper);

    /*
     * CORE FUNCTIONS
     */
    /// @dev Allows the owner to whitelist an authority
    /// @param _authority Address of the authority
    /// @param _isWhitelisted Bool whitelisted
    function setAuthority(address _authority, bool _isWhitelisted)
        external;

    /// @dev Allows the owner to whitelist a whitelister
    /// @param _whitelister Address of the whitelister
    /// @param _isWhitelisted Bool whitelisted
    function setWhitelister(address _whitelister, bool _isWhitelisted)
        external;

    /// @dev Allows a whitelister to whitelist an asset
    /// @param _asset Address of the token
    /// @param _isWhitelisted Bool whitelisted
    function whitelistAsset(address _asset, bool _isWhitelisted)
        external;

    /// @dev Allows a whitelister to whitelist an exchange
    /// @param _exchange Address of the target exchange
    /// @param _isWhitelisted Bool whitelisted
    function whitelistExchange(address _exchange, bool _isWhitelisted)
        external;

    /// @dev Allows a whitelister to whitelist an token wrapper
    /// @param _wrapper Address of the target token wrapper
    /// @param _isWhitelisted Bool whitelisted
    function whitelistWrapper(address _wrapper, bool _isWhitelisted)
        external;

    /// @dev Allows a whitelister to whitelist a tokenTransferProxy
    /// @param _tokenTransferProxy Address of the proxy
    /// @param _isWhitelisted Bool whitelisted
    function whitelistTokenTransferProxy(
        address _tokenTransferProxy, bool _isWhitelisted)
        external;

    /// @dev Allows a whitelister to enable trading on a particular exchange
    /// @param _asset Address of the token
    /// @param _exchange Address of the exchange
    /// @param _isWhitelisted Bool whitelisted
    function whitelistAssetOnExchange(
        address _asset,
        address _exchange,
        bool _isWhitelisted)
        external;

    /// @dev Allows a whitelister to enable assiciate wrappers to a token
    /// @param _token Address of the token
    /// @param _wrapper Address of the exchange
    /// @param _isWhitelisted Bool whitelisted
    function whitelistTokenOnWrapper(
        address _token,
        address _wrapper,
        bool _isWhitelisted)
        external;

    /// @dev Allows an admin to whitelist a factory
    /// @param _method Hex of the function ABI
    /// @param _isWhitelisted Bool whitelisted
    function whitelistMethod(
        bytes4 _method,
        address _adapter,
        bool _isWhitelisted)
        external;

    /// @dev Allows the owner to set the signature verifier
    /// @param _sigVerifier Address of the logs contract
    function setSignatureVerifier(address _sigVerifier)
        external;

    /// @dev Allows the owner to set the exchange eventful
    /// @param _exchangeEventful Address of the exchange logs contract
    function setExchangeEventful(address _exchangeEventful)
        external;

    /// @dev Allows the owner to associate an exchange to its adapter
    /// @param _exchange Address of the exchange
    /// @param _adapter Address of the adapter
    function setExchangeAdapter(address _exchange, address _adapter)
        external;

    /// @dev Allows the owner to set the casper contract
    /// @param _casper Address of the casper contract
    function setCasper(address _casper)
        external;

    /*
     * CONSTANT PUBLIC FUNCTIONS
     */
    /// @dev Provides whether an address is an authority
    /// @param _authority Address of the target authority
    /// @return Bool is whitelisted
    function isAuthority(address _authority)
        external view
        returns (bool);

    /// @dev Provides whether an asset is whitelisted
    /// @param _asset Address of the target asset
    /// @return Bool is whitelisted
    function isWhitelistedAsset(address _asset)
        external view
        returns (bool);

    /// @dev Provides whether an exchange is whitelisted
    /// @param _exchange Address of the target exchange
    /// @return Bool is whitelisted
    function isWhitelistedExchange(address _exchange)
        external view
        returns (bool);

    /// @dev Provides whether a token wrapper is whitelisted
    /// @param _wrapper Address of the target exchange
    /// @return Bool is whitelisted
    function isWhitelistedWrapper(address _wrapper)
        external view
        returns (bool);

    /// @dev Provides whether a proxy is whitelisted
    /// @param _tokenTransferProxy Address of the proxy
    /// @return Bool is whitelisted
    function isWhitelistedProxy(address _tokenTransferProxy)
        external view
        returns (bool);

    /// @dev Provides the address of the exchange adapter
    /// @param _exchange Address of the exchange
    /// @return Address of the adapter
    function getExchangeAdapter(address _exchange)
        external view
        returns (address);

    /// @dev Provides the address of the signature verifier
    /// @return Address of the verifier
    function getSigVerifier()
        external view
        returns (address);

    /// @dev Checkes whether a token is allowed on an exchange
    /// @param _token Address of the token
    /// @param _exchange Address of the exchange
    /// @return Bool the token is whitelisted on the exchange
    function canTradeTokenOnExchange(address _token, address _exchange)
        external view
        returns (bool);

    /// @dev Checkes whether a token is allowed on a wrapper
    /// @param _token Address of the token
    /// @return Bool the token is whitelisted on the exchange
    function canWrapTokenOnWrapper(address _token, address _wrapper)
        external view
        returns (bool);

    /// @dev Checkes whether a method is allowed on an exchange
    function isMethodAllowed(bytes4 _method, address _exchange)
        external view
        returns (bool);

    /// @dev Checkes whether casper has been inizialized
    /// @return Bool the casper contract has been initialized
    function isCasperInitialized()
        external view
        returns (bool);

    /// @dev Provides the address of the casper contract
    /// @return Address of the casper contract
    function getCasper()
        external view
        returns (address);
}

/// @title Exchanges Authority - A helper contract for the exchange adapters.
/// @author Gabriele Rigo - <gab@rigoblock.com>
// solhint-disable-next-line
contract ExchangesAuthority is Owned, ExchangesAuthorityFace {

    BuildingBlocks public blocks;
    Type public types;

    mapping (address => Account) public accounts;

    struct List {
        address target;
    }

    struct Type {
        string types;
        List[] list;
    }

    struct Group {
        bool whitelister;
        bool exchange;
        bool asset;
        bool authority;
        bool wrapper;
        bool proxy;
    }

    struct Account {
        address account;
        bool authorized;
        mapping (bool => Group) groups; //mapping account to bool authorized to bool group
    }

    struct BuildingBlocks {
        address exchangeEventful;
        address sigVerifier;
        address casper;
        mapping (address => bool) initialized;
        mapping (address => address) adapter;
        // Mapping of exchange => method => approved
        mapping (address => mapping (bytes4 => bool)) allowedMethods;
        mapping (address => mapping (address => bool)) allowedTokens;
        mapping (address => mapping (address => bool)) allowedWrappers;
    }

    /*
     * EVENTS
     */
    event AuthoritySet(address indexed authority);
    event WhitelisterSet(address indexed whitelister);
    event WhitelistedAsset(address indexed asset, bool approved);
    event WhitelistedExchange(address indexed exchange, bool approved);
    event WhitelistedWrapper(address indexed wrapper, bool approved);
    event WhitelistedProxy(address indexed proxy, bool approved);
    event WhitelistedMethod(bytes4 indexed method, address indexed adapter, bool approved);
    event NewSigVerifier(address indexed sigVerifier);
    event NewExchangeEventful(address indexed exchangeEventful);
    event NewCasper(address indexed casper);

    /*
     * MODIFIERS
     */
    modifier onlyAdmin {
        require(msg.sender == owner || isWhitelister(msg.sender));
        _;
    }

    modifier onlyWhitelister {
        require(isWhitelister(msg.sender));
        _;
    }

    /*
     * CORE FUNCTIONS
     */
    /// @dev Allows the owner to whitelist an authority
    /// @param _authority Address of the authority
    /// @param _isWhitelisted Bool whitelisted
    function setAuthority(address _authority, bool _isWhitelisted)
        external
        onlyOwner
    {
        setAuthorityInternal(_authority, _isWhitelisted);
    }

    /// @dev Allows the owner to whitelist a whitelister
    /// @param _whitelister Address of the whitelister
    /// @param _isWhitelisted Bool whitelisted
    function setWhitelister(address _whitelister, bool _isWhitelisted)
        external
        onlyOwner
    {
        setWhitelisterInternal(_whitelister, _isWhitelisted);
    }

    /// @dev Allows a whitelister to whitelist an asset
    /// @param _asset Address of the token
    /// @param _isWhitelisted Bool whitelisted
    function whitelistAsset(address _asset, bool _isWhitelisted)
        external
        onlyWhitelister
    {
        accounts[_asset].account = _asset;
        accounts[_asset].authorized = _isWhitelisted;
        accounts[_asset].groups[_isWhitelisted].asset = _isWhitelisted;
        types.list.push(List(_asset));
        emit WhitelistedAsset(_asset, _isWhitelisted);
    }

    /// @dev Allows a whitelister to whitelist an exchange
    /// @param _exchange Address of the target exchange
    /// @param _isWhitelisted Bool whitelisted
    function whitelistExchange(address _exchange, bool _isWhitelisted)
        external
        onlyWhitelister
    {
        accounts[_exchange].account = _exchange;
        accounts[_exchange].authorized = _isWhitelisted;
        accounts[_exchange].groups[_isWhitelisted].exchange = _isWhitelisted;
        types.list.push(List(_exchange));
        emit WhitelistedExchange(_exchange, _isWhitelisted);
    }

    /// @dev Allows a whitelister to whitelist an token wrapper
    /// @param _wrapper Address of the target token wrapper
    /// @param _isWhitelisted Bool whitelisted
    function whitelistWrapper(address _wrapper, bool _isWhitelisted)
        external
        onlyWhitelister
    {
        accounts[_wrapper].account = _wrapper;
        accounts[_wrapper].authorized = _isWhitelisted;
        accounts[_wrapper].groups[_isWhitelisted].wrapper = _isWhitelisted;
        types.list.push(List(_wrapper));
        emit WhitelistedWrapper(_wrapper, _isWhitelisted);
    }

    /// @dev Allows a whitelister to whitelist a tokenTransferProxy
    /// @param _tokenTransferProxy Address of the proxy
    /// @param _isWhitelisted Bool whitelisted
    function whitelistTokenTransferProxy(
        address _tokenTransferProxy,
        bool _isWhitelisted)
        external
        onlyWhitelister
    {
        accounts[_tokenTransferProxy].account = _tokenTransferProxy;
        accounts[_tokenTransferProxy].authorized = _isWhitelisted;
        accounts[_tokenTransferProxy].groups[_isWhitelisted].proxy = _isWhitelisted;
        types.list.push(List(_tokenTransferProxy));
        emit WhitelistedProxy(_tokenTransferProxy, _isWhitelisted);
    }

    /// @dev Allows a whitelister to enable trading on a particular exchange
    /// @param _asset Address of the token
    /// @param _exchange Address of the exchange
    /// @param _isWhitelisted Bool whitelisted
    function whitelistAssetOnExchange(
        address _asset,
        address _exchange,
        bool _isWhitelisted)
        external
        onlyAdmin
    {
        blocks.allowedTokens[_exchange][_asset] = _isWhitelisted;
        emit WhitelistedAsset(_asset, _isWhitelisted);
    }

    /// @dev Allows a whitelister to enable assiciate wrappers to a token
    /// @param _token Address of the token
    /// @param _wrapper Address of the exchange
    /// @param _isWhitelisted Bool whitelisted
    function whitelistTokenOnWrapper(address _token, address _wrapper, bool _isWhitelisted)
        external
        onlyAdmin
    {
        blocks.allowedWrappers[_wrapper][_token] = _isWhitelisted;
        emit WhitelistedAsset(_token, _isWhitelisted);
    }

    /// @dev Allows an admin to whitelist a factory
    /// @param _method Hex of the function ABI
    /// @param _isWhitelisted Bool whitelisted
    function whitelistMethod(
        bytes4 _method,
        address _adapter,
        bool _isWhitelisted)
        external
        onlyAdmin
    {
        blocks.allowedMethods[_adapter][_method] = _isWhitelisted;
        emit WhitelistedMethod(_method, _adapter, _isWhitelisted);
    }

    /// @dev Allows the owner to set the signature verifier
    /// @param _sigVerifier Address of the verifier contract
    function setSignatureVerifier(address _sigVerifier)
        external
        onlyOwner
    {
        blocks.sigVerifier = _sigVerifier;
        emit NewSigVerifier(blocks.sigVerifier);
    }

    /// @dev Allows the owner to set the exchange eventful
    /// @param _exchangeEventful Address of the exchange logs contract
    function setExchangeEventful(address _exchangeEventful)
        external
        onlyOwner
    {
        blocks.exchangeEventful = _exchangeEventful;
        emit NewExchangeEventful(blocks.exchangeEventful);
    }

    /// @dev Allows the owner to associate an exchange to its adapter
    /// @param _exchange Address of the exchange
    /// @param _adapter Address of the adapter
    function setExchangeAdapter(address _exchange, address _adapter)
        external
        onlyOwner
    {
        require(_exchange != _adapter);
        blocks.adapter[_exchange] = _adapter;
    }

    /// @dev Allows the owner to set the casper contract
    /// @param _casper Address of the casper contract
    function setCasper(address _casper)
        external
        onlyOwner
    {
        blocks.casper = _casper;
        blocks.initialized[_casper] = true;
        emit NewCasper(blocks.casper);
    }

    /*
     * CONSTANT PUBLIC FUNCTIONS
     */
    /// @dev Provides whether an address is an authority
    /// @param _authority Address of the target authority
    /// @return Bool is whitelisted
    function isAuthority(address _authority)
        external view
        returns (bool)
    {
        return accounts[_authority].groups[true].authority;
    }

    /// @dev Provides whether an asset is whitelisted
    /// @param _asset Address of the target asset
    /// @return Bool is whitelisted
    function isWhitelistedAsset(address _asset)
        external view
        returns (bool)
    {
        return accounts[_asset].groups[true].asset;
    }

    /// @dev Provides whether an exchange is whitelisted
    /// @param _exchange Address of the target exchange
    /// @return Bool is whitelisted
    function isWhitelistedExchange(address _exchange)
        external view
        returns (bool)
    {
        return accounts[_exchange].groups[true].exchange;
    }

    /// @dev Provides whether a token wrapper is whitelisted
    /// @param _wrapper Address of the target exchange
    /// @return Bool is whitelisted
    function isWhitelistedWrapper(address _wrapper)
        external view
        returns (bool)
    {
        return accounts[_wrapper].groups[true].wrapper;
    }

    /// @dev Provides whether a proxy is whitelisted
    /// @param _tokenTransferProxy Address of the proxy
    /// @return Bool is whitelisted
    function isWhitelistedProxy(address _tokenTransferProxy)
        external view
        returns (bool)
    {
        return accounts[_tokenTransferProxy].groups[true].proxy;
    }

    /// @dev Provides the address of the exchange adapter
    /// @param _exchange Address of the exchange
    /// @return Address of the adapter
    function getExchangeAdapter(address _exchange)
        external view
        returns (address)
    {
        return blocks.adapter[_exchange];
    }

    /// @dev Provides the address of the signature verifier
    /// @return Address of the verifier
    function getSigVerifier()
        external view
        returns (address)
    {
        return blocks.sigVerifier;
    }

    /// @dev Checkes whether a token is allowed on an exchange
    /// @param _token Address of the token
    /// @param _exchange Address of the exchange
    /// @return Bool the token is whitelisted on the exchange
    function canTradeTokenOnExchange(address _token, address _exchange)
        external view
        returns (bool)
    {
        return blocks.allowedTokens[_exchange][_token];
    }

    /// @dev Checkes whether a token is allowed on a wrapper
    /// @param _token Address of the token
    /// @param _wrapper Address of the token wrapper
    /// @return Bool the token is whitelisted on the exchange
    function canWrapTokenOnWrapper(address _token, address _wrapper)
        external view
        returns (bool)
    {
        return blocks.allowedWrappers[_wrapper][_token];
    }

    /// @dev Checkes whether a method is allowed on an exchange
    /// @param _method Bytes of the function signature
    /// @param _adapter Address of the exchange
    /// @return Bool the method is allowed
    function isMethodAllowed(bytes4 _method, address _adapter)
        external view
        returns (bool)
    {
        return blocks.allowedMethods[_adapter][_method];
    }

    /// @dev Checkes whether casper has been inizialized
    /// @return Bool the casper contract has been initialized
    function isCasperInitialized()
        external view
        returns (bool)
    {
        address casper = blocks.casper;
        return blocks.initialized[casper];
    }

    /// @dev Provides the address of the casper contract
    /// @return Address of the casper contract
    function getCasper()
        external view
        returns (address)
    {
        return blocks.casper;
    }

    /*
     * INTERNAL FUNCTIONS
     */
    /// @dev Allows to whitelist an authority
    /// @param _authority Address of the authority
    /// @param _isWhitelisted Bool whitelisted
    function setAuthorityInternal(
        address _authority,
        bool _isWhitelisted)
        internal
    {
        accounts[_authority].account = _authority;
        accounts[_authority].authorized = _isWhitelisted;
        accounts[_authority].groups[_isWhitelisted].authority = _isWhitelisted;
        setWhitelisterInternal(_authority, _isWhitelisted);
        types.list.push(List(_authority));
        emit AuthoritySet(_authority);
    }

    /// @dev Allows the owner to whitelist a whitelister
    /// @param _whitelister Address of the whitelister
    /// @param _isWhitelisted Bool whitelisted
    function setWhitelisterInternal(
        address _whitelister,
        bool _isWhitelisted)
        internal
    {
        accounts[_whitelister].account = _whitelister;
        accounts[_whitelister].authorized = _isWhitelisted;
        accounts[_whitelister].groups[_isWhitelisted].whitelister = _isWhitelisted;
        types.list.push(List(_whitelister));
        emit WhitelisterSet(_whitelister);
    }

    /// @dev Provides whether an address is whitelister
    /// @param _whitelister Address of the target whitelister
    /// @return Bool is whitelisted
    function isWhitelister(address _whitelister)
        internal view
        returns (bool)
    {
        return accounts[_whitelister].groups[true].whitelister;
    }
}