/**
 *Submitted for verification at Etherscan.io on 2020-06-27
*/

/**************************************************************************
 *            ____        _                              
 *           / ___|      | |     __ _  _   _   ___  _ __ 
 *          | |    _____ | |    / _` || | | | / _ \| '__|
 *          | |___|_____|| |___| (_| || |_| ||  __/| |   
 *           \____|      |_____|\__,_| \__, | \___||_|   
 *                                     |___/             
 * 
 **************************************************************************
 *
 *  The MIT License (MIT)
 *
 * Copyright (c) 2016-2020 Cyril Lapinte / C-Layer
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 **************************************************************************
 *
 * Flatten Contract: CoreConfiguration
 *
 * Git Commit:
 * https://github.com/c-layer/contracts/commit/0adcf9f214ae3f7b709cc41ec5dcb68e79d68772
 *
 * SPDX-License-Identifier: MIT
 **************************************************************************/

// File: @c-layer/common/contracts/interface/IAccessDefinitions.sol

pragma solidity ^0.6.0;


/**
 * @title IAccessDefinitions
 * @dev IAccessDefinitions
 *
 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
 */
contract IAccessDefinitions {

  // Hardcoded role granting all - non sysop - privileges
  bytes32 internal constant ALL_PRIVILEGES = bytes32("AllPrivileges");
  address internal constant ALL_PROXIES = address(0x416c6C50726F78696573); // "AllProxies"

  // Roles
  bytes32 internal constant FACTORY_CORE_ROLE = bytes32("FactoryCoreRole");
  bytes32 internal constant FACTORY_PROXY_ROLE = bytes32("FactoryProxyRole");

  // Sys Privileges
  bytes4 internal constant DEFINE_ROLE_PRIV =
    bytes4(keccak256("defineRole(bytes32,bytes4[])"));
  bytes4 internal constant ASSIGN_OPERATORS_PRIV =
    bytes4(keccak256("assignOperators(bytes32,address[])"));
  bytes4 internal constant REVOKE_OPERATORS_PRIV =
    bytes4(keccak256("revokeOperators(address[])"));
  bytes4 internal constant ASSIGN_PROXY_OPERATORS_PRIV =
    bytes4(keccak256("assignProxyOperators(address,bytes32,address[])"));
}

// File: @c-layer/common/contracts/interface/IOperableStorage.sol

pragma solidity ^0.6.0;



/**
 * @title IOperableStorage
 * @dev The Operable storage
 *
 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
 *
 * Error messages
 */
abstract contract IOperableStorage is IAccessDefinitions {

  struct RoleData {
    mapping(bytes4 => bool) privileges;
  }

  struct OperatorData {
    bytes32 coreRole;
    mapping(address => bytes32) proxyRoles;
  }

  function coreRole(address _address) virtual public view returns (bytes32);
  function proxyRole(address _proxy, address _address) virtual public view returns (bytes32);
  function rolePrivilege(bytes32 _role, bytes4 _privilege) virtual public view returns (bool);
  function roleHasPrivilege(bytes32 _role, bytes4 _privilege) virtual public view returns (bool);
  function hasCorePrivilege(address _address, bytes4 _privilege) virtual public view returns (bool);
  function hasProxyPrivilege(address _address, address _proxy, bytes4 _privilege) virtual public view returns (bool);

  event RoleDefined(bytes32 role);
  event OperatorAssigned(bytes32 role, address operator);
  event ProxyOperatorAssigned(address proxy, bytes32 role, address operator);
  event OperatorRevoked(address operator);
}

// File: @c-layer/common/contracts/interface/IOperableCore.sol

pragma solidity ^0.6.0;



/**
 * @title IOperableCore
 * @dev The Operable contract enable the restrictions of operations to a set of operators
 *
 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
 *
 * Error messages
 */
abstract contract IOperableCore is IOperableStorage {
  function defineRole(bytes32 _role, bytes4[] memory _privileges) virtual public returns (bool);
  function assignOperators(bytes32 _role, address[] memory _operators) virtual public returns (bool);
  function assignProxyOperators(
    address _proxy, bytes32 _role, address[] memory _operators) virtual public returns (bool);
  function revokeOperators(address[] memory _operators) virtual public returns (bool);
}

// File: @c-layer/common/contracts/interface/IProxy.sol

pragma solidity ^0.6.0;

/**
 * @title IProxy
 *
 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
 *
 * Error messages
 **/
interface IProxy {

  function core() external view returns (address);

}

// File: @c-layer/common/contracts/core/Proxy.sol

pragma solidity ^0.6.0;



/**
 * @title Proxy
 *
 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
 *
 * Error messages
 *   PR01: Only accessible by core
 *   PR02: Core request should be successful
 **/
contract Proxy is IProxy {

  address public override core;

  /**
   * @dev Throws if called by any account other than a core
   */
  modifier onlyCore {
    require(core == msg.sender, "PR01");
    _;
  }

  constructor(address _core) public {
    core = _core;
  }

  /**
   * @dev update the core
   */
  function updateCore(address _core)
    public onlyCore returns (bool)
  {
    core = _core;
    return true;
  }

  /**
   * @dev enforce static immutability (view)
   * @dev in order to read core value through internal core delegateCall
   */
  function staticCallUint256() internal view returns (uint256 result) {
    (bool status, bytes memory value) = core.staticcall(msg.data);
    require(status, "PR02");
    // solhint-disable-next-line no-inline-assembly
    assembly {
      result := mload(add(value, 0x20))
    }
  }
}

// File: @c-layer/common/contracts/operable/OperableAsCore.sol

pragma solidity ^0.6.0;




/**
 * @title OperableAsCore
 *
 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
 *
 * Error messages
 *   OA01: Missing the core privilege
 *   OA02: Missing the proxy privilege
 **/
contract OperableAsCore {

  modifier onlyCoreOperator(IOperableCore _core) {
    require(_core.hasCorePrivilege(
      msg.sender, msg.sig), "OA01");
    _;
  }

  modifier onlyProxyOperator(Proxy _proxy) {
    IOperableCore core = IOperableCore(_proxy.core());
    require(core.hasProxyPrivilege(
      msg.sender, address(_proxy), msg.sig), "OA02");
    _;
  }
}

// File: @c-layer/oracle/contracts/interface/IUserRegistry.sol

pragma solidity ^0.6.0;


/**
 * @title IUserRegistry
 * @dev IUserRegistry interface
 *
 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
 **/
abstract contract IUserRegistry {

  enum KeyCode {
    KYC_LIMIT_KEY,
    RECEPTION_LIMIT_KEY,
    EMISSION_LIMIT_KEY
  }

  event UserRegistered(uint256 indexed userId, address address_, uint256 validUntilTime);
  event AddressAttached(uint256 indexed userId, address address_);
  event AddressDetached(uint256 indexed userId, address address_);
  event UserSuspended(uint256 indexed userId);
  event UserRestored(uint256 indexed userId);
  event UserValidity(uint256 indexed userId, uint256 validUntilTime);
  event UserExtendedKey(uint256 indexed userId, uint256 key, uint256 value);
  event UserExtendedKeys(uint256 indexed userId, uint256[] values);
  event ExtendedKeysDefinition(uint256[] keys);

  function registerManyUsersExternal(address[] calldata _addresses, uint256 _validUntilTime)
    virtual external returns (bool);
  function registerManyUsersFullExternal(
    address[] calldata _addresses,
    uint256 _validUntilTime,
    uint256[] calldata _values) virtual external returns (bool);
  function attachManyAddressesExternal(uint256[] calldata _userIds, address[] calldata _addresses)
    virtual external returns (bool);
  function detachManyAddressesExternal(address[] calldata _addresses)
    virtual external returns (bool);
  function suspendManyUsersExternal(uint256[] calldata _userIds) virtual external returns (bool);
  function restoreManyUsersExternal(uint256[] calldata _userIds) virtual external returns (bool);
  function updateManyUsersExternal(
    uint256[] calldata _userIds,
    uint256 _validUntilTime,
    bool _suspended) virtual external returns (bool);
  function updateManyUsersExtendedExternal(
    uint256[] calldata _userIds,
    uint256 _key, uint256 _value) virtual external returns (bool);
  function updateManyUsersAllExtendedExternal(
    uint256[] calldata _userIds,
    uint256[] calldata _values) virtual external returns (bool);
  function updateManyUsersFullExternal(
    uint256[] calldata _userIds,
    uint256 _validUntilTime,
    bool _suspended,
    uint256[] calldata _values) virtual external returns (bool);

  function name() virtual public view returns (string memory);
  function currency() virtual public view returns (bytes32);

  function userCount() virtual public view returns (uint256);
  function userId(address _address) virtual public view returns (uint256);
  function validUserId(address _address) virtual public view returns (uint256);
  function validUser(address _address, uint256[] memory _keys)
    virtual public view returns (uint256, uint256[] memory);
  function validity(uint256 _userId) virtual public view returns (uint256, bool);

  function extendedKeys() virtual public view returns (uint256[] memory);
  function extended(uint256 _userId, uint256 _key)
    virtual public view returns (uint256);
  function manyExtended(uint256 _userId, uint256[] memory _key)
    virtual public view returns (uint256[] memory);

  function isAddressValid(address _address) virtual public view returns (bool);
  function isValid(uint256 _userId) virtual public view returns (bool);

  function defineExtendedKeys(uint256[] memory _extendedKeys) virtual public returns (bool);

  function registerUser(address _address, uint256 _validUntilTime)
    virtual public returns (bool);
  function registerUserFull(
    address _address,
    uint256 _validUntilTime,
    uint256[] memory _values) virtual public returns (bool);

  function attachAddress(uint256 _userId, address _address) virtual public returns (bool);
  function detachAddress(address _address) virtual public returns (bool);
  function detachSelf() virtual public returns (bool);
  function detachSelfAddress(address _address) virtual public returns (bool);
  function suspendUser(uint256 _userId) virtual public returns (bool);
  function restoreUser(uint256 _userId) virtual public returns (bool);
  function updateUser(uint256 _userId, uint256 _validUntilTime, bool _suspended)
    virtual public returns (bool);
  function updateUserExtended(uint256 _userId, uint256 _key, uint256 _value)
    virtual public returns (bool);
  function updateUserAllExtended(uint256 _userId, uint256[] memory _values)
    virtual public returns (bool);
  function updateUserFull(
    uint256 _userId,
    uint256 _validUntilTime,
    bool _suspended,
    uint256[] memory _values) virtual public returns (bool);
}

// File: @c-layer/oracle/contracts/interface/IRatesProvider.sol

pragma solidity ^0.6.0;


/**
 * @title IRatesProvider
 * @dev IRatesProvider interface
 *
 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
 */
abstract contract IRatesProvider {

  function defineRatesExternal(uint256[] calldata _rates) virtual external returns (bool);

  function name() virtual public view returns (string memory);

  function rate(bytes32 _currency) virtual public view returns (uint256);

  function currencies() virtual public view
    returns (bytes32[] memory, uint256[] memory, uint256);
  function rates() virtual public view returns (uint256, uint256[] memory);

  function convert(uint256 _amount, bytes32 _fromCurrency, bytes32 _toCurrency)
    virtual public view returns (uint256);

  function defineCurrencies(
    bytes32[] memory _currencies,
    uint256[] memory _decimals,
    uint256 _rateOffset) virtual public returns (bool);
  function defineRates(uint256[] memory _rates) virtual public returns (bool);

  event RateOffset(uint256 rateOffset);
  event Currencies(bytes32[] currencies, uint256[] decimals);
  event Rate(bytes32 indexed currency, uint256 rate);
}

// File: contracts/interface/ITokenAccessDefinitions.sol

pragma solidity ^0.6.0;



/**
 * @title ITokenAccessDefinitions
 * @dev ITokenAccessDefinitions
 *
 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
 */
abstract contract ITokenAccessDefinitions is IAccessDefinitions {

  // Roles
  bytes32 internal constant COMPLIANCE_CORE_ROLE = bytes32("ComplianceCoreRole");
  bytes32 internal constant COMPLIANCE_PROXY_ROLE = bytes32("ComplianceProxyRole");
  bytes32 internal constant ISSUER_PROXY_ROLE = bytes32("IssuerProxyRole");

  // Core Privileges
  bytes4 internal constant DEFINE_CORE_CONFIGURATION_PRIV =
    bytes4(keccak256("defineCoreConfigurations(address,address,address[],address,address,address,address,address)"));
  bytes4 internal constant DEFINE_AUDIT_CONFIGURATION_PRIV =
    bytes4(keccak256("defineAuditConfiguration(uint256,uint256,uint8,uint256[],uint256[],address,address)"));
  bytes4 internal constant DEFINE_TOKEN_DELEGATE_PRIV =
    bytes4(keccak256("defineTokenDelegate(uint256,address,uint256[])"));
  bytes4 internal constant DEFINE_ORACLE_PRIV =
    bytes4(keccak256("defineOracle(address,address,address)"));
  bytes4 internal constant DEFINE_TOKEN_PRIV =
    bytes4(keccak256("defineToken(address,uint256,string,string,uint256)"));

  // Proxy Privileges
  bytes4 internal constant MINT_PRIV =
    bytes4(keccak256("mint(address,address[],uint256[])"));
  bytes4 internal constant BURN_PRIV =
    bytes4(keccak256("burn(address,uint256)"));
  bytes4 internal constant FINISH_MINTING_PRIV =
    bytes4(keccak256("finishMinting(address)"));
  bytes4 internal constant SEIZE_PRIV =
    bytes4(keccak256("seize(address,address,uint256)"));
  bytes4 internal constant DEFINE_LOCK_PRIV =
    bytes4(keccak256("defineLock(address,uint256,uint256,address[])"));
  bytes4 internal constant FREEZE_MANY_ADDRESSES_PRIV =
    bytes4(keccak256("freezeManyAddresses(address,address[],uint256)"));
  bytes4 internal constant DEFINE_RULES_PRIV =
    bytes4(keccak256("defineRules(address,address[])"));

  // Factory prilieges
  bytes4 internal constant CONFIGURE_TOKENSALES_PRIV =
    bytes4(keccak256("configureTokensales(address,address[],uint256[])"));
  bytes4 internal constant UPDATE_ALLOWANCE_PRIV =
    bytes4(keccak256("updateAllowances(address,address[],uint256[])"));
}

// File: contracts/interface/IRule.sol

pragma solidity ^0.6.0;


/**
 * @title IRule
 * @dev IRule interface
 *
 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
 **/
interface IRule {
  function isAddressValid(address _address) external view returns (bool);
  function isTransferValid(address _from, address _to, uint256 _amount)
    external view returns (bool);
}

// File: contracts/interface/ITokenStorage.sol

pragma solidity ^0.6.0;





/**
 * @title ITokenStorage
 * @dev Token storage interface
 *
 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
 */
abstract contract ITokenStorage {
  enum TransferCode {
    UNKNOWN,
    OK,
    INVALID_SENDER,
    NO_RECIPIENT,
    INSUFFICIENT_TOKENS,
    LOCKED,
    FROZEN,
    RULE,
    INVALID_RATE,
    NON_REGISTRED_SENDER,
    NON_REGISTRED_RECEIVER,
    LIMITED_EMISSION,
    LIMITED_RECEPTION
  }

  enum Scope {
    DEFAULT
  }

  enum AuditStorageMode {
    ADDRESS,
    USER_ID,
    SHARED
  }

  enum AuditMode {
    NEVER,
    ALWAYS,
    ALWAYS_TRIGGERS_EXCLUDED,
    WHEN_TRIGGERS_MATCHED
  }

  event OracleDefined(
    IUserRegistry userRegistry,
    IRatesProvider ratesProvider,
    address currency);
  event TokenDelegateDefined(uint256 indexed delegateId, address delegate, uint256[] configurations);
  event TokenDelegateRemoved(uint256 indexed delegateId);
  event AuditConfigurationDefined(
    uint256 indexed configurationId,
    uint256 scopeId,
    AuditMode mode,
    uint256[] senderKeys,
    uint256[] receiverKeys,
    IRatesProvider ratesProvider,
    address currency);
  event AuditTriggersDefined(uint256 indexed configurationId, address[] triggers, bool[] tokens, bool[] senders, bool[] receivers);
  event AuditsRemoved(address scope, uint256 scopeId);
  event SelfManaged(address indexed holder, bool active);

  event Minted(address indexed token, uint256 amount);
  event MintFinished(address indexed token);
  event Burned(address indexed token, uint256 amount);
  event RulesDefined(address indexed token, IRule[] rules);
  event LockDefined(
    address indexed token,
    uint256 startAt,
    uint256 endAt,
    address[] exceptions
  );
  event Seize(address indexed token, address account, uint256 amount);
  event Freeze(address address_, uint256 until);
  event ClaimDefined(
    address indexed token,
    address indexed claim,
    uint256 claimAt);
  event TokenDefined(
    address indexed token,
    uint256 delegateId,
    string name,
    string symbol,
    uint256 decimals);
  event TokenMigrated(address indexed token, address newCore);
  event TokenRemoved(address indexed token);
  event LogTransferData(
    address token, address caller, address sender, address receiver,
    uint256 senderId, uint256[] senderKeys, bool senderFetched,
    uint256 receiverId, uint256[] receiverKeys, bool receiverFetched,
    uint256 value, uint256 convertedValue);
  event LogTransferAuditData(
    uint256 auditConfigurationId, uint256 scopeId,
    address currency, IRatesProvider ratesProvider,
    bool senderAuditRequired, bool receiverAuditRequired);
  event LogAuditData(
    uint64 createdAt, uint64 lastTransactionAt,
    uint256 cumulatedEmission, uint256 cumulatedReception
  );
}

// File: contracts/interface/ITokenCore.sol

pragma solidity ^0.6.0;




/**
 * @title ITokenCore
 *
 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
 *
 * Error messages
 **/
abstract contract ITokenCore is ITokenStorage, IOperableCore {

  function name() virtual public view returns (string memory);
  function oracle() virtual public view returns (
    IUserRegistry userRegistry,
    IRatesProvider ratesProvider,
    address currency);

  function auditConfiguration(uint256 _configurationId)
    virtual public view returns (
      uint256 scopeId,
      AuditMode mode,
      uint256[] memory senderKeys,
      uint256[] memory receiverKeys,
      IRatesProvider ratesProvider,
      address currency);
  function auditTriggers(
    uint256 _configurationId,
    address[] memory _triggers) virtual public view returns (
    bool[] memory senders,
    bool[] memory receivers,
    bool[] memory tokens);
  function delegatesConfigurations(uint256 _delegateId)
    virtual public view returns (uint256[] memory);

  function auditCurrency(
    address _scope,
    uint256 _scopeId
  ) virtual external view returns (address currency);
  function audit(
    address _scope,
    uint256 _scopeId,
    AuditStorageMode _storageMode,
    bytes32 _storageId) virtual external view returns (
    uint64 createdAt,
    uint64 lastTransactionAt,
    uint256 cumulatedEmission,
    uint256 cumulatedReception);

  /**************  ERC20  **************/
  function tokenName() virtual external view returns (string memory);
  function tokenSymbol() virtual external view returns (string memory);

  function decimals() virtual external returns (uint256);
  function totalSupply() virtual external returns (uint256);
  function balanceOf(address) virtual external returns (uint256);
  function allowance(address, address) virtual external returns (uint256);
  function transfer(address, address, uint256)
    virtual external returns (bool status);
  function transferFrom(address, address, address, uint256)
    virtual external returns (bool status);
  function approve(address, address, uint256)
    virtual external returns (bool status);
  function increaseApproval(address, address, uint256)
    virtual external returns (bool status);
  function decreaseApproval(address, address, uint256)
    virtual external returns (bool status);

  /***********  TOKEN DATA   ***********/
  function token(address _token) external view virtual returns (
    bool mintingFinished,
    uint256 allTimeMinted,
    uint256 allTimeBurned,
    uint256 allTimeSeized,
    uint256[2] memory lock,
    address[] memory lockExceptions,
    uint256 freezedUntil,
    IRule[] memory);
  function canTransfer(address, address, uint256)
    virtual external returns (uint256);

  /***********  TOKEN ADMIN  ***********/
  function mint(address, address[] calldata, uint256[] calldata)
    virtual external returns (bool);
  function finishMinting(address)
    virtual external returns (bool);
  function burn(address, uint256)
    virtual external returns (bool);
  function seize(address _token, address, uint256)
    virtual external returns (bool);
  function freezeManyAddresses(
    address _token,
    address[] calldata _addresses,
    uint256 _until) virtual external returns (bool);
  function defineLock(address, uint256, uint256, address[] calldata)
    virtual external returns (bool);
  function defineRules(address, IRule[] calldata) virtual external returns (bool);

  /************  CORE ADMIN  ************/
  function defineToken(
    address _token,
    uint256 _delegateId,
    string memory _name,
    string memory _symbol,
    uint256 _decimals) virtual external returns (bool);
  function migrateToken(address _token, address _newCore)
    virtual external returns (bool);
  function removeToken(address _token) virtual external returns (bool);

  function defineOracle(
    IUserRegistry _userRegistry,
    IRatesProvider _ratesProvider,
    address _currency) virtual external returns (bool);
  function defineTokenDelegate(
    uint256 _delegateId,
    address _delegate,
    uint256[] calldata _configurations) virtual external returns (bool);
  function defineAuditConfiguration(
    uint256 _configurationId,
    uint256 _scopeId,
    AuditMode _mode,
    uint256[] calldata _senderKeys,
    uint256[] calldata _receiverKeys,
    IRatesProvider _ratesProvider,
    address _currency) virtual external returns (bool);
  function removeAudits(address _scope, uint256 _scopeId)
    virtual external returns (bool);
  function defineAuditTriggers(
    uint256 _configurationId,
    address[] calldata _triggerAddresses,
    bool[] calldata _triggerSenders,
    bool[] calldata _triggerReceivers,
    bool[] calldata _triggerTokens) virtual external returns (bool);

  function isSelfManaged(address _owner)
    virtual external view returns (bool);
  function manageSelf(bool _active)
    virtual external returns (bool);
}

// File: contracts/interface/ICoreConfiguration.sol

pragma solidity ^0.6.0;







/**
 * @title ICoreConfiguration
 * @dev ICoreConfiguration
 *
 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
 */
abstract contract ICoreConfiguration is ITokenAccessDefinitions {

  enum Configuration {
    DEFAULT,
    AML_PRIMARY,
    AML_FULL
  }

  enum Delegate {
    UNDEFINED,
    UTILITY,
    PAYMENT,
    SECURITY,
    EQUITY,
    BOND,
    FUND,
    DERIVATIVE
  }

  // The definition below should be considered as a constant
  // Solidity 0.6.x do not provide ways to have arrays as constants
  bytes4[] public requiredCorePrivileges = [
    DEFINE_CORE_CONFIGURATION_PRIV,
    DEFINE_AUDIT_CONFIGURATION_PRIV,
    DEFINE_TOKEN_DELEGATE_PRIV,
    DEFINE_ROLE_PRIV,
    ASSIGN_OPERATORS_PRIV,
    REVOKE_OPERATORS_PRIV,
    ASSIGN_PROXY_OPERATORS_PRIV,
    DEFINE_ORACLE_PRIV
  ];

  function hasCoreAccess(IOperableCore _core) virtual public view returns (bool);
  function defineCoreConfigurations(
    ITokenCore _core,
    address[] calldata _factories,
    address _mintableDelegate,
    address _compliantDelegate,
    IUserRegistry _userRegistry,
    IRatesProvider _ratesProvider,
    address _currency
  ) virtual external returns (bool);
}

// File: contracts/CoreConfiguration.sol

pragma solidity ^0.6.0;




/**
 * @title CoreConfiguration
 * @dev CoreConfiguration
 *
 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>
 *
 * Error messages
 *   CC01: Some required privileges from the core are missing
 *   CC02: Primary market audit configuration setup failed
 *   CC03: Secondary market audit configuration setup failed
 *   CC04: Utility token delegate setup failed
 *   CC05: Payment token delegate setup failed
 *   CC06: Security token delegate setup failed
 *   CC07: Equity token delegate setup failed
 *   CC08: Bond token delegate setup failed
 *   CC09: Fund token delegate setup failed
 *   CC10: Derivative token delegate setup failed
 *   CC11: Factory core role definition failed
 *   CC12: Factory core role assignment failed
 *   CC13: Factory proxy role definition failed
 *   CC14: Factory proxy role assignment failed
 *   CC15: Compliance core role definition failed
 *   CC16: Compliance proxy role definition failed
 *   CC17: Issuer proxy role definition failed
 *   CC18: Oracle definition failed
 *   CC19: Revoking core configuration access failed
 *   CC20: Revoking access from the core configuration was successful
 */
contract CoreConfiguration is ICoreConfiguration, OperableAsCore {

  uint256[] private noAMLConfig = new uint256[](0);
  uint256[] private primaryMarketAMLConfig = [ uint256(Configuration.AML_PRIMARY) ];
  uint256[] private secondaryMarketAMLConfig = [ uint256(Configuration.AML_FULL) ];

  uint256[] private emptyArray = new uint256[](0);
  uint256[] private senderKeys = [ uint256(IUserRegistry.KeyCode.EMISSION_LIMIT_KEY) ];
  uint256[] private receiverKeys = [ uint256(IUserRegistry.KeyCode.RECEPTION_LIMIT_KEY) ];

  /**
   * @dev has core access
   */
  function hasCoreAccess(IOperableCore _core) override public view returns (bool access) {
    access = true;
    for (uint256 i=0; i<requiredCorePrivileges.length; i++) {
      access = access && _core.hasCorePrivilege(
        address(this), requiredCorePrivileges[i]);
    }
  }

   /**
   * @dev defineCoreConfigurations
   */
  function defineCoreConfigurations(
    ITokenCore _core,
    address[] calldata _factories,
    address _mintableDelegate,
    address _compliantDelegate,
    IUserRegistry _userRegistry,
    IRatesProvider _ratesProvider,
    address _currency
  ) override external onlyCoreOperator(_core) returns (bool)
  {
    require(hasCoreAccess(_core), "CC01");

    // Primary Market AML Configuration
    require(_core.defineAuditConfiguration(
      uint256(Configuration.AML_PRIMARY),
      uint256(ITokenStorage.Scope.DEFAULT),
      ITokenStorage.AuditMode.WHEN_TRIGGERS_MATCHED,
      emptyArray, receiverKeys, _ratesProvider, _currency
    ), "CC02");

    // Secondary Market AML Configuration
    require(_core.defineAuditConfiguration(
      uint256(Configuration.AML_FULL),
      uint256(ITokenStorage.Scope.DEFAULT),
      ITokenStorage.AuditMode.ALWAYS_TRIGGERS_EXCLUDED,
      senderKeys, receiverKeys, _ratesProvider, _currency
    ), "CC03");

    require(_core.defineTokenDelegate(
      uint256(Delegate.UTILITY), _mintableDelegate, noAMLConfig), "CC04");
    require(_core.defineTokenDelegate(
      uint256(Delegate.PAYMENT), _mintableDelegate, noAMLConfig), "CC05");
    require(_core.defineTokenDelegate(
      uint256(Delegate.SECURITY), _compliantDelegate, primaryMarketAMLConfig), "CC06");
    require(_core.defineTokenDelegate(
      uint256(Delegate.EQUITY), _compliantDelegate, secondaryMarketAMLConfig), "CC07");
    require(_core.defineTokenDelegate(
      uint256(Delegate.BOND), _compliantDelegate, secondaryMarketAMLConfig), "CC08");
    require(_core.defineTokenDelegate(
      uint256(Delegate.FUND), _compliantDelegate, secondaryMarketAMLConfig), "CC09");
    require(_core.defineTokenDelegate(
      uint256(Delegate.DERIVATIVE), _compliantDelegate, secondaryMarketAMLConfig), "CC10");

    // Setup basic roles
    bytes4[] memory privileges = new bytes4[](2);
    privileges[0] = ASSIGN_PROXY_OPERATORS_PRIV;
    privileges[1] = DEFINE_TOKEN_PRIV;
    require(_core.defineRole(FACTORY_CORE_ROLE, privileges), "CC11");
    require(_core.assignOperators(FACTORY_CORE_ROLE, _factories), "CC12");

    privileges = new bytes4[](4);
    privileges[0] = MINT_PRIV;
    privileges[1] = FINISH_MINTING_PRIV;
    privileges[2] = DEFINE_RULES_PRIV;
    privileges[3] = DEFINE_LOCK_PRIV;
    require(_core.defineRole(FACTORY_PROXY_ROLE, privileges), "CC13");
    require(_core.assignProxyOperators(ALL_PROXIES, FACTORY_PROXY_ROLE, _factories), "CC14");

    privileges = new bytes4[](1);
    privileges[0] = DEFINE_TOKEN_PRIV;
    require(_core.defineRole(COMPLIANCE_CORE_ROLE, privileges), "CC15");

    privileges = new bytes4[](4);
    privileges[0] = DEFINE_RULES_PRIV;
    privileges[1] = SEIZE_PRIV;
    privileges[2] = FREEZE_MANY_ADDRESSES_PRIV;
    privileges[3] = DEFINE_LOCK_PRIV;
    require(_core.defineRole(COMPLIANCE_PROXY_ROLE, privileges), "CC16");

    privileges = new bytes4[](6);
    privileges[0] = MINT_PRIV;
    privileges[1] = BURN_PRIV;
    privileges[2] = FINISH_MINTING_PRIV;
    privileges[3] = DEFINE_LOCK_PRIV;
    privileges[4] = CONFIGURE_TOKENSALES_PRIV;
    privileges[5] = UPDATE_ALLOWANCE_PRIV;
    require(_core.defineRole(ISSUER_PROXY_ROLE, privileges), "CC17");

    // Assign Oracle
    require(_core.defineOracle(_userRegistry, _ratesProvider, _currency), "CC18");

    address[] memory configOperators = new address[](1);
    configOperators[0] = address(this);
    require(_core.revokeOperators(configOperators), "CC19");
    require(!hasCoreAccess(_core), "CC20");
  }
}