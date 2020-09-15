/**
 *Submitted for verification at Etherscan.io on 2020-08-04
*/

/**
 *Submitted for verification at Etherscan.io on 2020-08-04
*/

/*

 Copyright 2017-2018 RigoBlock, Rigo Investment Sagl.

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

/// @title Authority Interface - Allows interaction with the Authority contract.
/// @author Gabriele Rigo - <gab@rigoblock.com>
// solhint-disable-next-line
interface AuthorityFace {

    /*
     * EVENTS
     */
    event AuthoritySet(address indexed authority);
    event WhitelisterSet(address indexed whitelister);
    event WhitelistedUser(address indexed target, bool approved);
    event WhitelistedRegistry(address indexed registry, bool approved);
    event WhitelistedFactory(address indexed factory, bool approved);
    event WhitelistedVault(address indexed vault, bool approved);
    event WhitelistedDrago(address indexed drago, bool isWhitelisted);
    event NewDragoEventful(address indexed dragoEventful);
    event NewVaultEventful(address indexed vaultEventful);
    event NewNavVerifier(address indexed navVerifier);
    event NewExchangesAuthority(address indexed exchangesAuthority);

    /*
     * CORE FUNCTIONS
     */
    function setAuthority(address _authority, bool _isWhitelisted) external;
    function setWhitelister(address _whitelister, bool _isWhitelisted) external;
    function whitelistUser(address _target, bool _isWhitelisted) external;
    function whitelistDrago(address _drago, bool _isWhitelisted) external;
    function whitelistVault(address _vault, bool _isWhitelisted) external;
    function whitelistRegistry(address _registry, bool _isWhitelisted) external;
    function whitelistFactory(address _factory, bool _isWhitelisted) external;
    function setDragoEventful(address _dragoEventful) external;
    function setVaultEventful(address _vaultEventful) external;
    function setNavVerifier(address _navVerifier) external;
    function setExchangesAuthority(address _exchangesAuthority) external;

    /*
     * CONSTANT PUBLIC FUNCTIONS
     */
    function isWhitelistedUser(address _target) external view returns (bool);
    function isAuthority(address _authority) external view returns (bool);
    function isWhitelistedRegistry(address _registry) external view returns (bool);
    function isWhitelistedDrago(address _drago) external view returns (bool);
    function isWhitelistedVault(address _vault) external view returns (bool);
    function isWhitelistedFactory(address _factory) external view returns (bool);
    function getDragoEventful() external view returns (address);
    function getVaultEventful() external view returns (address);
    function getNavVerifier() external view returns (address);
    function getExchangesAuthority() external view returns (address);
}


/// @title Authority - Allows to set up the base rules of the protocol.
/// @author Gabriele Rigo - <gab@rigoblock.com>
// solhint-disable-next-line
contract Authority is
    Owned,
    AuthorityFace
{
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
        bool drago;
        bool vault;
        bool user;
        bool registry;
        bool factory;
        bool authority;
    }

    struct Account {
        address account;
        bool authorized;
        mapping (bool => Group) groups; //mapping account to bool authorized to bool group
    }

    struct BuildingBlocks {
        address dragoEventful;
        address vaultEventful;
        address navVerifier;
        address exchangesAuthority;
        address casper;
        mapping (address => bool) initialized;
    }

    /*
     * EVENTS
     */
    event AuthoritySet(address indexed authority);
    event WhitelisterSet(address indexed whitelister);
    event WhitelistedUser(address indexed target, bool approved);
    event WhitelistedRegistry(address indexed registry, bool approved);
    event WhitelistedFactory(address indexed factory, bool approved);
    event WhitelistedVault(address indexed vault, bool approved);
    event WhitelistedDrago(address indexed drago, bool isWhitelisted);
    event NewDragoEventful(address indexed dragoEventful);
    event NewVaultEventful(address indexed vaultEventful);
    event NewNavVerifier(address indexed navVerifier);
    event NewExchangesAuthority(address indexed exchangesAuthority);

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

    /// @dev Allows a whitelister to whitelist a user
    /// @param _target Address of the target user
    /// @param _isWhitelisted Bool whitelisted
    function whitelistUser(address _target, bool _isWhitelisted)
        external
        onlyWhitelister
    {
        accounts[_target].account = _target;
        accounts[_target].authorized = _isWhitelisted;
        accounts[_target].groups[_isWhitelisted].user = _isWhitelisted;
        types.list.push(List(_target));
        emit WhitelistedUser(_target, _isWhitelisted);
    }

    /// @dev Allows an admin to whitelist a drago
    /// @param _drago Address of the target drago
    /// @param _isWhitelisted Bool whitelisted
    function whitelistDrago(address _drago, bool _isWhitelisted)
        external
        onlyAdmin
    {
        accounts[_drago].account = _drago;
        accounts[_drago].authorized = _isWhitelisted;
        accounts[_drago].groups[_isWhitelisted].drago = _isWhitelisted;
        types.list.push(List(_drago));
        emit WhitelistedDrago(_drago, _isWhitelisted);
    }

    /// @dev Allows an admin to whitelist a vault
    /// @param _vault Address of the target vault
    /// @param _isWhitelisted Bool whitelisted
    function whitelistVault(address _vault, bool _isWhitelisted)
        external
        onlyAdmin
    {
        accounts[_vault].account = _vault;
        accounts[_vault].authorized = _isWhitelisted;
        accounts[_vault].groups[_isWhitelisted].vault = _isWhitelisted;
        types.list.push(List(_vault));
        emit WhitelistedVault(_vault, _isWhitelisted);
    }

    /// @dev Allows an admin to whitelist a registry
    /// @param _registry Address of the target registry
    /// @param _isWhitelisted Bool whitelisted
    function whitelistRegistry(address _registry, bool _isWhitelisted)
        external
        onlyAdmin
    {
        accounts[_registry].account = _registry;
        accounts[_registry].authorized = _isWhitelisted;
        accounts[_registry].groups[_isWhitelisted].registry = _isWhitelisted;
        types.list.push(List(_registry));
        emit WhitelistedRegistry(_registry, _isWhitelisted);
    }

    /// @dev Allows an admin to whitelist a factory
    /// @param _factory Address of the target factory
    /// @param _isWhitelisted Bool whitelisted
    function whitelistFactory(address _factory, bool _isWhitelisted)
        external
        onlyAdmin
    {
        accounts[_factory].account = _factory;
        accounts[_factory].authorized = _isWhitelisted;
        accounts[_factory].groups[_isWhitelisted].registry = _isWhitelisted;
        types.list.push(List(_factory));
        setAuthorityInternal(_factory, _isWhitelisted);
        emit WhitelistedFactory(_factory, _isWhitelisted);
    }

    /// @dev Allows the owner to set the drago eventful
    /// @param _dragoEventful Address of the logs contract
    function setDragoEventful(address _dragoEventful)
        external
        onlyOwner
    {
        blocks.dragoEventful = _dragoEventful;
        emit NewDragoEventful(blocks.dragoEventful);
    }

    /// @dev Allows the owner to set the vault eventful
    /// @param _vaultEventful Address of the vault logs contract
    function setVaultEventful(address _vaultEventful)
        external
        onlyOwner
    {
        blocks.vaultEventful = _vaultEventful;
        emit NewVaultEventful(blocks.vaultEventful);
    }

    /// @dev Allows the owner to set the nav verifier
    /// @param _navVerifier Address of the verifier
    function setNavVerifier(address _navVerifier)
        external
        onlyOwner
    {
        blocks.navVerifier = _navVerifier;
        emit NewNavVerifier(blocks.navVerifier);
    }

    /// @dev Allows the owner to set the exchanges authority
    /// @param _exchangesAuthority Address of the exchanges authority
    function setExchangesAuthority(address _exchangesAuthority)
        external
        onlyOwner
    {
        blocks.exchangesAuthority = _exchangesAuthority;
        emit NewExchangesAuthority(blocks.exchangesAuthority);
    }

    /*
     * CONSTANT PUBLIC FUNCTIONS
     */
    /// @dev Provides whether a user is whitelisted
    /// @param _target Address of the target user
    /// @return Bool is whitelisted
    function isWhitelistedUser(address _target)
        external view
        returns (bool)
    {
        return accounts[_target].groups[true].user;
    }

    /// @dev Provides whether an address is an authority
    /// @param _authority Address of the target authority
    /// @return Bool is whitelisted
    function isAuthority(address _authority)
        external view
        returns (bool)
    {
        return accounts[_authority].groups[true].authority;
    }

    /// @dev Provides whether a drago is whitelisted
    /// @param _drago Address of the target drago
    /// @return Bool is whitelisted
    function isWhitelistedDrago(address _drago)
        external view
        returns (bool)
    {
        return accounts[_drago].groups[true].drago;
    }

    /// @dev Provides whether a vault is whitelisted
    /// @param _vault Address of the target vault
    /// @return Bool is whitelisted
    function isWhitelistedVault(address _vault)
        external view
        returns (bool)
    {
        return accounts[_vault].groups[true].vault;
    }

    /// @dev Provides whether a registry is whitelisted
    /// @param _registry Address of the target registry
    /// @return Bool is whitelisted
    function isWhitelistedRegistry(address _registry)
        external view
        returns (bool)
    {
        return accounts[_registry].groups[true].registry;
    }

    /// @dev Provides whether a factory is whitelisted
    /// @param _factory Address of the target factory
    /// @return Bool is whitelisted
    function isWhitelistedFactory(address _factory)
        external view
        returns (bool)
    {
        return accounts[_factory].groups[true].registry;
    }

    /// @dev Provides the address of the drago logs contract
    /// @return Address of the drago logs contract
    function getDragoEventful()
        external view
        returns (address)
    {
        return blocks.dragoEventful;
    }

    /// @dev Provides the address of the vault logs contract
    /// @return Address of the vault logs contract
    function getVaultEventful()
        external view
        returns (address)
    {
        return blocks.vaultEventful;
    }

    /// @dev Provides the address of the nav verifier
    /// @return Address of the verifier
    function getNavVerifier()
        external view
        returns (address)
    {
        return blocks.navVerifier;
    }

    /// @dev Provides the address of the exchangee authority
    /// @return Address of the adapter
    function getExchangesAuthority()
        external view
        returns (address)
    {
        return blocks.exchangesAuthority;
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