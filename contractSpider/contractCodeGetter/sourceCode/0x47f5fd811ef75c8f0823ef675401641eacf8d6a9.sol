/**
 *Submitted for verification at Etherscan.io on 2020-06-22
*/

// File: @onchain-id/solidity/contracts/IERC734.sol

pragma solidity ^0.6.2;

/**
 * @dev Interface of the ERC734 (Key Holder) standard as defined in the EIP.
 */
interface IERC734 {
    /**
     * @dev Definition of the structure of a Key.
     *
     * Specification: Keys are cryptographic public keys, or contract addresses associated with this identity.
     * The structure should be as follows:
     *   - key: A public key owned by this identity
     *      - purposes: uint256[] Array of the key purposes, like 1 = MANAGEMENT, 2 = EXECUTION
     *      - keyType: The type of key used, which would be a uint256 for different key types. e.g. 1 = ECDSA, 2 = RSA, etc.
     *      - key: bytes32 The public key. // Its the Keccak256 hash of the key
     */
    struct Key {
        uint256[] purposes;
        uint256 keyType;
        bytes32 key;
    }

    /**
     * @dev Emitted when an execution request was approved.
     *
     * Specification: MUST be triggered when approve was successfully called.
     */
    event Approved(uint256 indexed executionId, bool approved);

    /**
     * @dev Emitted when an execute operation was approved and successfully performed.
     *
     * Specification: MUST be triggered when approve was called and the execution was successfully approved.
     */
    event Executed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);

    /**
     * @dev Emitted when an execution request was performed via `execute`.
     *
     * Specification: MUST be triggered when execute was successfully called.
     */
    event ExecutionRequested(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);

    /**
     * @dev Emitted when a key was added to the Identity.
     *
     * Specification: MUST be triggered when addKey was successfully called.
     */
    event KeyAdded(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);

    /**
     * @dev Emitted when a key was removed from the Identity.
     *
     * Specification: MUST be triggered when removeKey was successfully called.
     */
    event KeyRemoved(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);

    /**
     * @dev Emitted when the list of required keys to perform an action was updated.
     *
     * Specification: MUST be triggered when changeKeysRequired was successfully called.
     */
    event KeysRequiredChanged(uint256 purpose, uint256 number);


    /**
     * @dev Adds a _key to the identity. The _purpose specifies the purpose of the key.
     *
     * Triggers Event: `KeyAdded`
     *
     * Specification: MUST only be done by keys of purpose 1, or the identity itself. If it's the identity itself, the approval process will determine its approval.
     */
    function addKey(bytes32 _key, uint256 _purpose, uint256 _keyType) external returns (bool success);

    /**
    * @dev Approves an execution or claim addition.
    *
    * Triggers Event: `Approved`, `Executed`
    *
    * Specification:
    * This SHOULD require n of m approvals of keys purpose 1, if the _to of the execution is the identity contract itself, to successfully approve an execution.
    * And COULD require n of m approvals of keys purpose 2, if the _to of the execution is another contract, to successfully approve an execution.
    */
    function approve(uint256 _id, bool _approve) external returns (bool success);

    /**
     * @dev Passes an execution instruction to an ERC725 identity.
     *
     * Triggers Event: `ExecutionRequested`, `Executed`
     *
     * Specification:
     * SHOULD require approve to be called with one or more keys of purpose 1 or 2 to approve this execution.
     * Execute COULD be used as the only accessor for `addKey` and `removeKey`.
     */
    function execute(address _to, uint256 _value, bytes calldata _data) external payable returns (uint256 executionId);

    /**
     * @dev Returns the full key data, if present in the identity.
     */
    function getKey(bytes32 _key) external view returns (uint256[] memory purposes, uint256 keyType, bytes32 key);

    /**
     * @dev Returns the list of purposes associated with a key.
     */
    function getKeyPurposes(bytes32 _key) external view returns(uint256[] memory _purposes);

    /**
     * @dev Returns an array of public key bytes32 held by this identity.
     */
    function getKeysByPurpose(uint256 _purpose) external view returns (bytes32[] memory keys);

    /**
     * @dev Returns TRUE if a key is present and has the given purpose. If the key is not present it returns FALSE.
     */
    function keyHasPurpose(bytes32 _key, uint256 _purpose) external view returns (bool exists);

    /**
     * @dev Removes _purpose for _key from the identity.
     *
     * Triggers Event: `KeyRemoved`
     *
     * Specification: MUST only be done by keys of purpose 1, or the identity itself. If it's the identity itself, the approval process will determine its approval.
     */
    function removeKey(bytes32 _key, uint256 _purpose) external returns (bool success);
}

// File: @onchain-id/solidity/contracts/IERC735.sol

pragma solidity ^0.6.2;

/**
 * @dev Interface of the ERC735 (Claim Holder) standard as defined in the EIP.
 */
interface IERC735 {

    /**
     * @dev Emitted when a claim request was performed.
     *
     * Specification: Is not clear
     */
    event ClaimRequested(uint256 indexed claimRequestId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);

    /**
     * @dev Emitted when a claim was added.
     *
     * Specification: MUST be triggered when a claim was successfully added.
     */
    event ClaimAdded(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);

    /**
     * @dev Emitted when a claim was removed.
     *
     * Specification: MUST be triggered when removeClaim was successfully called.
     */
    event ClaimRemoved(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);

    /**
     * @dev Emitted when a claim was changed.
     *
     * Specification: MUST be triggered when changeClaim was successfully called.
     */
    event ClaimChanged(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);

    /**
     * @dev Definition of the structure of a Claim.
     *
     * Specification: Claims are information an issuer has about the identity holder.
     * The structure should be as follows:
     *   - claim: A claim published for the Identity.
     *      - topic: A uint256 number which represents the topic of the claim. (e.g. 1 biometric, 2 residence (ToBeDefined: number schemes, sub topics based on number ranges??))
     *      - scheme : The scheme with which this claim SHOULD be verified or how it should be processed. Its a uint256 for different schemes. E.g. could 3 mean contract verification, where the data will be call data, and the issuer a contract address to call (ToBeDefined). Those can also mean different key types e.g. 1 = ECDSA, 2 = RSA, etc. (ToBeDefined)
     *      - issuer: The issuers identity contract address, or the address used to sign the above signature. If an identity contract, it should hold the key with which the above message was signed, if the key is not present anymore, the claim SHOULD be treated as invalid. The issuer can also be a contract address itself, at which the claim can be verified using the call data.
     *      - signature: Signature which is the proof that the claim issuer issued a claim of topic for this identity. it MUST be a signed message of the following structure: `keccak256(abi.encode(identityHolder_address, topic, data))`
     *      - data: The hash of the claim data, sitting in another location, a bit-mask, call data, or actual data based on the claim scheme.
     *      - uri: The location of the claim, this can be HTTP links, swarm hashes, IPFS hashes, and such.
     */
    struct Claim {
        uint256 topic;
        uint256 scheme;
        address issuer;
        bytes signature;
        bytes data;
        string uri;
    }

    /**
     * @dev Get a claim by its ID.
     *
     * Claim IDs are generated using `keccak256(abi.encode(address issuer_address, uint256 topic))`.
     */
    function getClaim(bytes32 _claimId) external view returns(uint256 topic, uint256 scheme, address issuer, bytes memory signature, bytes memory data, string memory uri);

    /**
     * @dev Returns an array of claim IDs by topic.
     */
    function getClaimIdsByTopic(uint256 _topic) external view returns(bytes32[] memory claimIds);

    /**
     * @dev Add or update a claim.
     *
     * Triggers Event: `ClaimRequested`, `ClaimAdded`, `ClaimChanged`
     *
     * Specification: Requests the ADDITION or the CHANGE of a claim from an issuer.
     * Claims can requested to be added by anybody, including the claim holder itself (self issued).
     *
     * _signature is a signed message of the following structure: `keccak256(abi.encode(address identityHolder_address, uint256 topic, bytes data))`.
     * Claim IDs are generated using `keccak256(abi.encode(address issuer_address + uint256 topic))`.
     *
     * This COULD implement an approval process for pending claims, or add them right away.
     * MUST return a claimRequestId (use claim ID) that COULD be sent to the approve function.
     */
    function addClaim(uint256 _topic, uint256 _scheme, address issuer, bytes calldata _signature, bytes calldata _data, string calldata _uri) external returns (bytes32 claimRequestId);

    /**
     * @dev Removes a claim.
     *
     * Triggers Event: `ClaimRemoved`
     *
     * Claim IDs are generated using `keccak256(abi.encode(address issuer_address, uint256 topic))`.
     */
    function removeClaim(bytes32 _claimId) external returns (bool success);
}

// File: @onchain-id/solidity/contracts/IIdentity.sol

pragma solidity ^0.6.2;



interface IIdentity is IERC734, IERC735 {}

// File: @tokenysolutions/t-rex/contracts/registry/IIdentityRegistryStorage.sol

/**
 *     NOTICE
 *
 *     The T-REX software is licensed under a proprietary license or the GPL v.3.
 *     If you choose to receive it under the GPL v.3 license, the following applies:
 *     T-REX is a suite of smart contracts developed by Tokeny to manage and transfer financial assets on the ethereum blockchain
 *
 *     Copyright (C) 2019, Tokeny sàrl.
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma solidity 0.6.2;


interface IIdentityRegistryStorage {

   /**
    *  this event is emitted when an Identity is registered into the storage contract.
    *  the event is emitted by the 'registerIdentity' function
    *  `investorAddress` is the address of the investor's wallet
    *  `identity` is the address of the Identity smart contract (onchainID)
    */
    event IdentityStored(address indexed investorAddress, IIdentity indexed identity);

   /**
    *  this event is emitted when an Identity is removed from the storage contract.
    *  the event is emitted by the 'deleteIdentity' function
    *  `investorAddress` is the address of the investor's wallet
    *  `identity` is the address of the Identity smart contract (onchainID)
    */
    event IdentityUnstored(address indexed investorAddress, IIdentity indexed identity);

   /**
    *  this event is emitted when an Identity has been updated
    *  the event is emitted by the 'updateIdentity' function
    *  `oldIdentity` is the old Identity contract's address to update
    *  `newIdentity` is the new Identity contract's
    */
    event IdentityModified(IIdentity indexed oldIdentity, IIdentity indexed newIdentity);

   /**
    *  this event is emitted when an Identity's country has been updated
    *  the event is emitted by the 'updateCountry' function
    *  `investorAddress` is the address on which the country has been updated
    *  `country` is the numeric code (ISO 3166-1) of the new country
    */
    event CountryModified(address indexed investorAddress, uint16 indexed country);

   /**
    *  this event is emitted when an Identity Registry is bound to the storage contract
    *  the event is emitted by the 'addIdentityRegistry' function
    *  `identityRegistry` is the address of the identity registry added
    */
    event IdentityRegistryBound(address indexed identityRegistry);

   /**
    *  this event is emitted when an Identity Registry is unbound from the storage contract
    *  the event is emitted by the 'removeIdentityRegistry' function
    *  `identityRegistry` is the address of the identity registry removed
    */
    event IdentityRegistryUnbound(address indexed identityRegistry);

   /**
    *  @dev Returns the identity registries linked to the storage contract
    */
    function linkedIdentityRegistries() external view returns (address[] memory);

   /**
    *  @dev Returns the onchainID of an investor.
    *  @param _userAddress The wallet of the investor
    */
    function storedIdentity(address _userAddress) external view returns (IIdentity);

   /**
    *  @dev Returns the country code of an investor.
    *  @param _userAddress The wallet of the investor
    */
    function storedInvestorCountry(address _userAddress) external view returns (uint16);

   /**
    *  @dev adds an identity contract corresponding to a user address in the storage.
    *  Requires that the user doesn't have an identity contract already registered.
    *  This function can only be called by an address set as agent of the smart contract
    *  @param _userAddress The address of the user
    *  @param _identity The address of the user's identity contract
    *  @param _country The country of the investor
    *  emits `IdentityStored` event
    */
    function addIdentityToStorage(address _userAddress, IIdentity _identity, uint16 _country) external;

   /**
    *  @dev Removes an user from the storage.
    *  Requires that the user have an identity contract already deployed that will be deleted.
    *  This function can only be called by an address set as agent of the smart contract
    *  @param _userAddress The address of the user to be removed
    *  emits `IdentityUnstored` event
    */
    function removeIdentityFromStorage(address _userAddress) external;

   /**
    *  @dev Updates the country corresponding to a user address.
    *  Requires that the user should have an identity contract already deployed that will be replaced.
    *  This function can only be called by an address set as agent of the smart contract
    *  @param _userAddress The address of the user
    *  @param _country The new country of the user
    *  emits `CountryModified` event
    */
    function modifyStoredInvestorCountry(address _userAddress, uint16 _country) external;

   /**
    *  @dev Updates an identity contract corresponding to a user address.
    *  Requires that the user address should be the owner of the identity contract.
    *  Requires that the user should have an identity contract already deployed that will be replaced.
    *  This function can only be called by an address set as agent of the smart contract
    *  @param _userAddress The address of the user
    *  @param _identity The address of the user's new identity contract
    *  emits `IdentityModified` event
    */
    function modifyStoredIdentity(address _userAddress, IIdentity _identity) external;

   /**
    *  @notice Transfers the Ownership of the Identity Registry Storage to a new Owner.
    *  This function can only be called by the wallet set as owner of the smart contract
    *  @param _newOwner The new owner of this contract.
    */
    function transferOwnershipOnIdentityRegistryStorage(address _newOwner) external;

   /**
    *  @notice Adds an identity registry as agent of the Identity Registry Storage Contract.
    *  This function can only be called by the wallet set as owner of the smart contract
    *  This function adds the identity registry to the list of identityRegistries linked to the storage contract
    *  @param _identityRegistry The identity registry address to add.
    */
    function bindIdentityRegistry(address _identityRegistry) external;

   /**
    *  @notice Removes an identity registry from being agent of the Identity Registry Storage Contract.
    *  This function can only be called by the wallet set as owner of the smart contract
    *  This function removes the identity registry from the list of identityRegistries linked to the storage contract
    *  @param _identityRegistry The identity registry address to remove.
    */
    function unbindIdentityRegistry(address _identityRegistry) external;
}

// File: openzeppelin-solidity/contracts/GSN/Context.sol

// SPDX-License-Identifier: MIT

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

// File: @tokenysolutions/t-rex/contracts/roles/Ownable.sol

pragma solidity 0.6.2;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
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
    function owner() external view returns (address) {
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
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() external virtual onlyOwner {
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

// File: @tokenysolutions/t-rex/contracts/compliance/ICompliance.sol

/**
 *     NOTICE
 *
 *     The T-REX software is licensed under a proprietary license or the GPL v.3.
 *     If you choose to receive it under the GPL v.3 license, the following applies:
 *     T-REX is a suite of smart contracts developed by Tokeny to manage and transfer financial assets on the ethereum blockchain
 *
 *     Copyright (C) 2019, Tokeny sàrl.
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma solidity 0.6.2;

interface ICompliance {

    /**
    *  this event is emitted when the Agent has been added on the allowedList of this Compliance.
    *  the event is emitted by the Compliance constructor and by the addTokenAgent function
    *  `_agentAddress` is the address of the Agent to add
    */
    event TokenAgentAdded(address _agentAddress);

    /**
    *  this event is emitted when the Agent has been removed from the agent list of this Compliance.
    *  the event is emitted by the Compliance constructor and by the removeTokenAgent function
    *  `_agentAddress` is the address of the Agent to remove
    */
    event TokenAgentRemoved(address _agentAddress);

    /**
    *  this event is emitted when a token has been bound to the compliance contract
    *  the event is emitted by the bindToken function
    *  `_token` is the address of the token to bind
    */
    event TokenBound(address _token);

    /**
    *  this event is emitted when a token has been unbound from the compliance contract
    *  the event is emitted by the unbindToken function
    *  `_token` is the address of the token to unbind
    */
    event TokenUnbound(address _token);

    /**
    *  @dev Returns true if the Address is in the list of token agents
    *  @param _agentAddress address of this agent
    */
    function isTokenAgent(address _agentAddress) external view returns (bool);

    /**
    *  @dev Returns true if the address given corresponds to a token that is bound with the Compliance contract
    *  @param _token address of the token
    */
    function isTokenBound(address _token) external view returns (bool);

    /**
     *  @dev adds an agent to the list of token agents
     *  @param _agentAddress address of the agent to be added
     *  Emits a TokenAgentAdded event
     */
    function addTokenAgent(address _agentAddress) external;

    /**
    *  @dev remove Agent from the list of token agents
    *  @param _agentAddress address of the agent to be removed (must be added first)
    *  Emits a TokenAgentRemoved event
    */
    function removeTokenAgent(address _agentAddress) external;

    /**
     *  @dev binds a token to the compliance contract
     *  @param _token address of the token to bind
     *  Emits a TokenBound event
     */
    function bindToken(address _token) external;

    /**
    *  @dev unbinds a token from the compliance contract
    *  @param _token address of the token to unbind
    *  Emits a TokenUnbound event
    */
    function unbindToken(address _token) external;


   /**
    *  @dev checks that the transfer is compliant.
    *  default compliance always returns true
    *  READ ONLY FUNCTION, this function cannot be used to increment
    *  counters, emit events, ...
    *  @param _from The address of the sender
    *  @param _to The address of the receiver
    *  @param _amount The amount of tokens involved in the transfer
    */
    function canTransfer(address _from, address _to, uint256 _amount) external view returns (bool);

   /**
    *  @dev function called whenever tokens are transferred
    *  from one wallet to another
    *  this function can update state variables in the compliance contract
    *  these state variables being used by `canTransfer` to decide if a transfer
    *  is compliant or not depending on the values stored in these state variables and on
    *  the parameters of the compliance smart contract
    *  @param _from The address of the sender
    *  @param _to The address of the receiver
    *  @param _amount The amount of tokens involved in the transfer
    */
    function transferred(address _from, address _to, uint256 _amount) external;

   /**
    *  @dev function called whenever tokens are created
    *  on a wallet
    *  this function can update state variables in the compliance contract
    *  these state variables being used by `canTransfer` to decide if a transfer
    *  is compliant or not depending on the values stored in these state variables and on
    *  the parameters of the compliance smart contract
    *  @param _to The address of the receiver
    *  @param _amount The amount of tokens involved in the transfer
    */
    function created(address _to, uint256 _amount) external;

   /**
    *  @dev function called whenever tokens are destroyed
    *  this function can update state variables in the compliance contract
    *  these state variables being used by `canTransfer` to decide if a transfer
    *  is compliant or not depending on the values stored in these state variables and on
    *  the parameters of the compliance smart contract
    *  @param _from The address of the receiver
    *  @param _amount The amount of tokens involved in the transfer
    */
    function destroyed(address _from, uint256 _amount) external;

   /**
    *  @dev function used to transfer the ownership of the compliance contract
    *  to a new owner, giving him access to the `OnlyOwner` functions implemented on the contract
    *  @param newOwner The address of the new owner of the compliance contract
    *  This function can only be called by the owner of the compliance contract
    *  emits an `OwnershipTransferred` event
    */
    function transferOwnershipOnComplianceContract(address newOwner) external;
}

// File: contracts/compliance/LimitsDMAndCountryRestrictions.sol

/**
 *     NOTICE
 *
 *     The T-REX software is licensed under a proprietary license or the GPL v.3.
 *     If you choose to receive it under the GPL v.3 license, the following applies:
 *     T-REX is a suite of smart contracts developed by Tokeny to manage
 *     and transfer financial assets on the ethereum blockchain.
 *
 *     Copyright (C) 2019, Tokeny sàrl.
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma solidity 0.6.2;




contract LimitsDMAndCountryRestrictions is ICompliance, Ownable {

    /**
     *  this event is emitted when the IdentityStorage has been set or updated.
     *  the event is emitted by the Compliance constructor and by the setCompliance function
     *  `_identityStorage` is the address of the IdentityRegistryStorage contract of the Compliance
     */
    event IdentityStorageAdded(address indexed _identityStorage);

    /**
     *  this event is emitted whenever a Country has been restricted.
     *  the event is emitted by 'addCountryRestriction' and 'batchRestrictCountries' functions.
     *  `_country` is the numeric ISO 3166-1 of the restricted country.
     */
    event AddedRestrictedCountry(uint16 _country);

    /**
     *  this event is emitted whenever a Country has been unrestricted.
     *  the event is emitted by 'removeCountryRestriction' and 'batchUnrestrictCountries' functions.
     *  `_country` is the numeric ISO 3166-1 of the unrestricted country.
     */
    event RemovedRestrictedCountry(uint16 _country);

    /**
     *  this event is emitted whenever a DailyLimit has been updated.
     *  the event is emitted by 'setDailyLimit' and by Compliance's constructor.
     *  `_newDailyLimit` is the amount Limit of tokens to be transferred daily.
     */
    event DailyLimitUpdated(uint _newDailyLimit);

    /**
     *  this event is emitted whenever a MonthlyLimit has been updated.
     *  the event is emitted by 'setMonthlyLimit' and by Compliance's constructor.
     *  `_newMonthlyLimit` is the amount Limit of tokens to be transferred monthly.
     */
    event MonthlyLimitUpdated(uint _newMonthlyLimit);

    /// IdentityRegistryStorage linked to this Compliance Contract
    IIdentityRegistryStorage public identityStorage;

    /// Mapping between country and their restriction status
    mapping(uint16 => bool) private _restrictedCountries;

    /// Mapping between agents and their statuses
    mapping(address => bool) private _tokenAgentsList;

    /// Mapping of tokens linked to the compliance contract
    mapping(address => bool) private _tokensBound;

    /// Getter for Tokens dailyLimit
    uint256 public dailyLimit;

    /// Getter for Tokens monthlyLimit
    uint256 public monthlyLimit;

    /// Struct of transfer Counters
    struct TransferCounter {
        uint256 dailyCount;
        uint256 monthlyCount;
        uint256 dailyTimer;
        uint256 monthlyTimer;
    }

    /// Mapping for users Counters
    mapping(address => TransferCounter) usersCounters;

    /**
     * @dev Throws if called by any address that is not a token bound to the compliance.
     */
    modifier onlyToken() {
        require(isToken(), "error : this address is not a token bound to the compliance contract");
        _;
    }

    /**
     *  @dev the constructor initiates the Compliance contract
     *  msg.sender is set automatically as the owner of the smart contract
     *  @param _identityStorage the address of the Identity Registry Storage linked to this Compliance
     *  @param _dailyLimit the limit of tokens allowed to be transferred daily
     *  @param _monthlyLimit the limit of tokens allowed to be transferred monthly
     *  emits an `IdentityRegistryAdded` event
     *  emits a `DailyLimitUpdated` event
     *  emits a `MonthlyLimitUpdated` event
     */
    constructor (address _identityStorage, uint256 _dailyLimit, uint256 _monthlyLimit) public {
        identityStorage = IIdentityRegistryStorage(_identityStorage);
        emit IdentityStorageAdded(_identityStorage);
        dailyLimit = _dailyLimit;
        emit DailyLimitUpdated(_dailyLimit);
        monthlyLimit = _monthlyLimit;
        emit MonthlyLimitUpdated(_monthlyLimit);
    }

    /**
    *  @dev checks if the day has finished since the cooldown has been triggered for this identity
    *  @param _identity ONCHAINID to be checked
    */
    function _isDayFinished(address _identity) internal view returns (bool) {
        return (usersCounters[_identity].dailyTimer <= block.timestamp);
    }

    /**
    *  @dev checks if the month has finished since the cooldown has been triggered for this identity
    *  @param _identity ONCHAINID to be checked
    */
    function _isMonthFinished(address _identity) internal view returns (bool) {
        return (usersCounters[_identity].monthlyTimer <= block.timestamp);
    }

    /**
    *  @dev resets cooldown for the day if cooldown has reached time limit of 1 day
    *  @param _identity ONCHAINID to be checked
    */
    function _resetDailyCooldown(address _identity) internal {
        if (_isDayFinished(_identity)) {
            usersCounters[_identity].dailyTimer = block.timestamp + 1 days;
            usersCounters[_identity].dailyCount = 0;
        }
    }

    /**
    *  @dev resets cooldown for the month if cooldown has reached the time limit of 30days
    *  @param _identity ONCHAINID to be checked
    */
    function _resetMonthlyCooldown(address _identity) internal {
        if (_isMonthFinished(_identity)) {
            usersCounters[_identity].monthlyTimer = block.timestamp + 30 days;
            usersCounters[_identity].monthlyCount = 0;
        }
    }

    /**
    *  @dev Checks if daily and/or monthly cooldown must be reset, then check if _value sent has been exceeded,
    *  if not increases user's OnchainID counters.
    *  @param _userAddress, address on which counters will be increased
    *  @param _value, value of transaction)to be increased
    */
    function _increaseCounters(address _userAddress, uint256 _value) internal {
        address identity = _getIdentity(_userAddress);
        _resetDailyCooldown(identity);
        _resetMonthlyCooldown(identity);
        if ((usersCounters[identity].dailyCount + _value) <= dailyLimit) {
            usersCounters[identity].dailyCount += _value;
        }
        if ((usersCounters[identity].monthlyCount + _value) <= monthlyLimit) {
            usersCounters[identity].monthlyCount += _value;
        }
    }

    /**
    *  @dev Returns the ONCHAINID (Identity) of the _userAddress
    *  @param _userAddress Address of the wallet
    */
    function _getIdentity(address _userAddress) internal view returns (address) {
        return address(identityStorage.storedIdentity(_userAddress));
    }

    /**
    *  @dev See {ICompliance-isTokenAgent}.
    */
    function isTokenAgent(address _agentAddress) public override view returns (bool) {
        return (_tokenAgentsList[_agentAddress]);
    }

    /**
    *  @dev See {ICompliance-isTokenBound}.
    */
    function isTokenBound(address _token) public override view returns (bool) {
        return (_tokensBound[_token]);
    }

    /**
    *  @dev Returns true if country is Restricted
    *  @param _country, numeric ISO 3166-1 standard of the country to be checked
    */
    function isCountryRestricted(uint16 _country) public view returns (bool) {
        return (_restrictedCountries[_country]);
    }

    /**
     *  @dev See {ICompliance-addTokenAgent}.
     */
    function addTokenAgent(address _agentAddress) external override onlyOwner {
        require(!_tokenAgentsList[_agentAddress], "This Agent is already registered");
        _tokenAgentsList[_agentAddress] = true;
        emit TokenAgentAdded(_agentAddress);
    }

    /**
    *  @dev See {ICompliance-isTokenAgent}.
    */
    function removeTokenAgent(address _agentAddress) external override onlyOwner {
        require(_tokenAgentsList[_agentAddress], "This Agent is not registered yet");
        _tokenAgentsList[_agentAddress] = false;
        emit TokenAgentRemoved(_agentAddress);
    }

    /**
     *  @dev See {ICompliance-isTokenAgent}.
     */
    function bindToken(address _token) external override onlyOwner {
        require(!_tokensBound[_token], "This token is already bound");
        _tokensBound[_token] = true;
        emit TokenBound(_token);
    }

    /**
    *  @dev See {ICompliance-isTokenAgent}.
    */
    function unbindToken(address _token) external override onlyOwner {
        require(_tokensBound[_token], "This token is not bound yet");
        _tokensBound[_token] = false;
        emit TokenUnbound(_token);
    }

    /**
    *  @dev Returns true if the sender corresponds to a token that is bound with the Compliance contract
    */
    function isToken() internal view returns (bool) {
        return isTokenBound(msg.sender);
    }

   /**
    *  @dev Set the limit of tokens allowed to be transferred daily.
    *  @param _newDailyLimit The new daily limit of tokens
    */
    function setDailyLimit(uint256 _newDailyLimit) external onlyOwner {
        dailyLimit = _newDailyLimit;
        emit DailyLimitUpdated(_newDailyLimit);
    }

   /**
    *  @dev Set the limit of tokens allowed to be transferred monthly.
    *  param _newMonthlyLimit The new monthly limit of tokens
    */
    function setMonthlyLimit(uint256 _newMonthlyLimit) external onlyOwner {
        monthlyLimit = _newMonthlyLimit;
        emit MonthlyLimitUpdated(_newMonthlyLimit);
    }

   /**
    *  @dev sets the Identity Storage for the Compliance
    *  @param _identityStorage the address of the Identity Storage to set
    *  Only the owner of the Compliance smart contract can call this function
    *  emits an `IdentityStorageAdded` event
    */
    function setIdentityStorage(address _identityStorage) external onlyOwner {
        identityStorage = IIdentityRegistryStorage(_identityStorage);
        emit IdentityStorageAdded(_identityStorage);
    }

   /**
    *  @dev Adds country restriction.
    *  Identities from those countries will be forbidden to manipulate Tokens linked to this Compliance.
    *  @param _country Country to be restricted, should be expressed by following numeric ISO 3166-1 standard
    *  Only the owner of the Compliance smart contract can call this function
    *  emits an `AddedRestrictedCountry` event
    */
    function addCountryRestriction(uint16 _country) external onlyOwner {
        _restrictedCountries[_country] = true;
        emit AddedRestrictedCountry(_country);
    }

   /**
    *  @dev Removes country restriction.
    *  Identities from those countries will again be authorised to manipulate Tokens linked to this Compliance.
    *  @param _country Country to be unrestricted, should be expressed by following numeric ISO 3166-1 standard
    *  Only the owner of the Compliance smart contract can call this function
    *  emits an `RemovedRestrictedCountry` event
    */
    function removeCountryRestriction(uint16 _country) external onlyOwner {
        _restrictedCountries[_country] = false;
        emit RemovedRestrictedCountry(_country);
    }

   /**
    *  @dev Adds countries restriction in batch.
    *  Identities from those countries will be forbidden to manipulate Tokens linked to this Compliance.
    *  @param _countries Countries to be restricted, should be expressed by following numeric ISO 3166-1 standard
    *  Only the owner of the Compliance smart contract can call this function
    *  emits an `AddedRestrictedCountry` event
    */
    function batchRestrictCountries(uint16[] calldata _countries) external onlyOwner {
        for (uint i = 0; i < _countries.length; i++) {
            _restrictedCountries[_countries[i]] = true;
            emit AddedRestrictedCountry(_countries[i]);
        }
    }

   /**
    *  @dev Removes countries restriction in batch.
    *  Identities from those countries will again be authorised to manipulate Tokens linked to this Compliance.
    *  @param _countries Countries to be unrestricted, should be expressed by following numeric ISO 3166-1 standard
    *  Only the owner of the Compliance smart contract can call this function
    *  emits an `RemovedRestrictedCountry` event
    */
    function batchUnrestrictCountries(uint16[] calldata _countries) external onlyOwner {
        for (uint i = 0; i < _countries.length; i++) {
            _restrictedCountries[_countries[i]] = false;
            emit RemovedRestrictedCountry(_countries[i]);
        }
    }

   /**
    *  @dev See {ICompliance-transferred}.
    */
    function transferred(address _from, address _to, uint256 _value) external onlyToken override {
        _increaseCounters(_from, _value);
    }

   /**
    *  @dev See {ICompliance-created}.
    */
    function created(address _to, uint256 _value) external override {}

   /**
    *  @dev See {ICompliance-destroyed}.
    */
    function destroyed(address _from, uint256 _value) external override {}

   /**
    *  @dev See {ICompliance-canTransfer}.
    */
    function canTransfer(address _from, address _to, uint256 _value) external view override returns (bool) {
        uint16 receiverCountry = identityStorage.storedInvestorCountry(_to);
        address senderIdentity = _getIdentity(_from);
        if (isCountryRestricted(receiverCountry)) {
            return false;
        }
        if (!isTokenAgent(_from)) {
            if (_value > dailyLimit) {
                return false;
            }
            if (!_isDayFinished(senderIdentity) &&
                ((usersCounters[senderIdentity].dailyCount + _value > dailyLimit)
                    || (usersCounters[senderIdentity].monthlyCount + _value > monthlyLimit))) {
                return false;
            }
            if (_isDayFinished(senderIdentity) && _value + usersCounters[senderIdentity].monthlyCount > monthlyLimit) {
                return(_isMonthFinished(senderIdentity));
            }
        }
        return true;
    }

   /**
    *  @dev See {ICompliance-transferOwnershipOnComplianceContract}.
    */
    function transferOwnershipOnComplianceContract(address newOwner) external override onlyOwner {
        transferOwnership(newOwner);
    }
}