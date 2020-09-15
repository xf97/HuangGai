/**
 *Submitted for verification at Etherscan.io on 2020-07-08
*/

// File: contracts/IOwnable.sol

// Adaped from "@0x/contracts-utils/contracts/src/interfaces/IOwnable.sol";

pragma solidity ^0.5.5;


contract IOwnable {

    function transferOwnership1(address newOwner)
        public;

    function transferOwnership2(address newOwner)
        public;
}

// File: contracts/Ownable.sol

// Adaped from "@0x/contracts-utils/contracts/src/Ownable.sol";

pragma solidity ^0.5.5;



contract Ownable is
    IOwnable
{
    address public owner1;
    address public owner2;

    constructor ()
        public
    {
        owner1 = msg.sender;
        owner2 = msg.sender;
    }

    modifier onlyOwner() {
        require(
            (msg.sender == owner1) || (msg.sender == owner2),
            "ONLY_CONTRACT_OWNER"
        );
        _;
    }

    function transferOwnership1(address newOwner)
        public
        onlyOwner
    {
        if (newOwner != address(0)) {
            owner1 = newOwner;
        }
    }

    function transferOwnership2(address newOwner)
        public
        onlyOwner
    {
        if (newOwner != address(0)) {
            owner2 = newOwner;
        }
    }

}

// File: contracts/Registry.sol

/*

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

pragma solidity ^0.5.5;
pragma experimental ABIEncoderV2;



contract Registry is
    Ownable
{


    // Pause. When true, Registry updates (writes) are paused.
    bool public paused = false;


    /***  Microsponsors Registry Data:  ***/


    // Array of registrant addresses,
    // regardless of isWhitelisted status
    address[] private registrants;

    // Map registrant's address => isWhitelisted status.
    // Addresses authorized to transact.
    mapping (address => bool) public isWhitelisted;

    // Map each registrant's address to the `block.timestamp`
    // when the address was first registered
    mapping (address => uint) public registrantTimestamp;

    // Map each registrant's address to the address that referred them.
    mapping (address => address) private registrantToReferrer;

    // Map each referrer's address to array of addresses they referred.
    mapping (address => address[]) private referrerToRegistrants;

    // Map address => array of ContentId structs.
    // Using struct because there is not mapping to an array of strings in Solidity at this time.
    struct ContentIdStruct {
        string contentId;
    }
    mapping (address => ContentIdStruct[]) private addressToContentIds;

    // Map contentId => address (for reverse-lookups)
    mapping (string => address) private contentIdToAddress;


    /***  Constructor  ***/

    constructor ()
        public
    {

    }


    /*** Admin Pause: Adapted from OpenZeppelin (via Cryptokitties) ***/


    /// @dev Modifier to allow actions only when the contract IS NOT paused
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    /// @dev Modifier to allow actions only when the contract IS paused
    modifier whenPaused {
        require(paused);
        _;
    }

    /// @dev Called by contract owner to pause actions on this contract
    function pause() external onlyOwner whenNotPaused {
        paused = true;
    }

    /// @dev Called by contract owner to unpause the smart contract.
    /// @notice This is public rather than external so it can be called by
    ///  derived contracts.
    function unpause() public onlyOwner whenPaused {
        paused = false;
    }


    /***  Admin: Registry Management  ***/


    /// @dev Admin registers an address with a contentId.
    /// @param target Address to add or remove from whitelist.
    /// @param contentId To map the target's address to. UTF8-encoded SRN (a string).
    /// @param isApproved Whitelist status to assign to the address.
    function adminUpdate(
        address target,
        string memory contentId,
        bool isApproved
    )
        public
        onlyOwner
        whenNotPaused
    {

        address previousOwner = contentIdToAddress[contentId];

        if (previousOwner != target) {

            // If contentId already belongs to another owner address
            // it must be explicitly removed by admin remove fn
            // which will also remove that address from whitelist
            // if this was its only contentId
            if (previousOwner != 0x0000000000000000000000000000000000000000) {
                adminRemoveContentIdFromAddress(previousOwner, contentId);
            }

            // Assign content id to new registrant address
            addressToContentIds[target].push( ContentIdStruct(contentId) );
            contentIdToAddress[contentId] = target;

        }

        if (!hasRegistered(target)) {
            registrants.push(target);
            registrantTimestamp[target] = block.timestamp;
        }

        isWhitelisted[target] = isApproved;

    }


    function adminUpdateWithReferrer(
        address target,
        string memory contentId,
        bool isApproved,
        address referrer
    )
        public
        onlyOwner
        whenNotPaused
    {

        // Revert transaction (refund gas) if
        // the referrer is not whitelisted
        require(
            isWhitelisted[referrer],
            'INVALID_REFERRER'
        );

        adminUpdate(target, contentId, isApproved);

        adminUpdateReferrer(target, referrer);

    }


    function adminUpdateReferrer(
        address registrant,
        address referrer
    )
        public
        onlyOwner
        whenNotPaused
    {

        // Revert transaction (refund gas) if
        // the registrant has never registered
        require(
            hasRegistered(registrant),
            'INVALID_REGISTRANT'
        );

        // Revert transaction (refund gas) if
        // the referrer is not whitelisted
        require(
            isWhitelisted[referrer],
            'INVALID_REFERRER'
        );

        // Revert transaction (refund gas) if
        // the registrant and referrer are the same
        require(
            registrant != referrer,
            'INVALID_REFERRER'
        );

        require(
            registrantToReferrer[registrant] != referrer,
            'REFERRER_UPDATE_IS_REDUNDANT'
        );

        address previousReferrer = registrantToReferrer[registrant];

        // If the registrant had a previous referrer, remove the registrant
        // from referrerToRegistrants[previousReferrer] array
        if (previousReferrer != 0x0000000000000000000000000000000000000000) {
            address[] memory a = referrerToRegistrants[previousReferrer];
            for (uint i = 0; i < a.length; i++) {
                if (a[i] == registrant) {
                    referrerToRegistrants[previousReferrer][i] = 0x0000000000000000000000000000000000000000;
                }
            }
        }

        registrantToReferrer[registrant] = referrer;
        referrerToRegistrants[referrer].push(registrant);

    }

    /// @dev Admin updates whitelist status for a given address.
    /// @param target Address to update.
    /// @param isApproved Whitelist status to assign to address.
    function adminUpdateWhitelistStatus(
        address target,
        bool isApproved
    )
        external
        onlyOwner
        whenNotPaused
    {

        // Revert transaction (refund gas) if
        // the requested whitelist status update is redundant
        require(
            isApproved != isWhitelisted[target],
            'NO_STATUS_UPDATE_REQUIRED'
        );

        // Disallow users with no associated content ids
        // (ex: admin or user themselves may have removed content ids)
        if (isApproved == true) {
            require(
                getNumContentIds(target) > 0,
                'ADDRESS_HAS_NO_ASSOCIATED_CONTENT_IDS'
            );
        }

        isWhitelisted[target] = isApproved;

    }

    /// @dev Admin removes a contentId from a given address.
    function adminRemoveContentIdFromAddress(
        address target,
        string memory contentId
    )
        public
        onlyOwner
        whenNotPaused
    {

        require(
            contentIdToAddress[contentId] == target,
            'CONTENT_ID_DOES_NOT_BELONG_TO_ADDRESS'
        );

        contentIdToAddress[contentId] = address(0x0000000000000000000000000000000000000000);

        // Remove content id from addressToContentIds mapping
        // by replacing it with empty string
        ContentIdStruct[] memory m = addressToContentIds[target];
        for (uint i = 0; i < m.length; i++) {
            if (stringsMatch(contentId, m[i].contentId)) {
                addressToContentIds[target][i] = ContentIdStruct('');
            }
        }

        // If address has no valid content ids left, remove from Whitelist
        if (getNumContentIds(target) == 0) {
            isWhitelisted[target] = false;
        }

    }

    /// @dev Admin removes *all* contentIds from a given address.
    function adminRemoveAllContentIdsFromAddress(
        address target
    )
        public
        onlyOwner
        whenNotPaused
    {

        // Loop thru content ids from addressToContentIds mapping
        // by replacing each with empty string
        ContentIdStruct[] memory m = addressToContentIds[target];
        for (uint i = 0; i < m.length; i++) {
            addressToContentIds[target][i] = ContentIdStruct('');
        }

        // Remove from whitelist
        isWhitelisted[target] = false;

    }


    /*** Admin read-only functions ***/


    /// @dev Admin gets address mapped to a contentId,
    ///      regardless of isWhitelist status.
    function adminGetAddressByContentId(
        string calldata contentId
    )
        external
        view
        onlyOwner
        returns (address target)
    {

        return contentIdToAddress[contentId];

    }

    /// @dev Admin gets contentIds mapped to any address,
    ///      regardless of whitelist status. There is a
    ///      public-facing version of this below that only returns
    ///      content ids for whitelisted accounts.
    /// @param target Ethereum address to return contentIds for.
    function adminGetContentIdsByAddress(
        address target
    )
        external
        view
        onlyOwner
        returns (string[] memory)
    {

        ContentIdStruct[] memory m = addressToContentIds[target];
        string[] memory r = new string[](m.length);

        for (uint i = 0; i < m.length; i++) {
            r[i] =  m[i].contentId;
        }

        return r;

    }


    /// @dev Returns valid whitelisted account address by registrant index number,
    ///      regardless of whitelist status.
    function adminGetRegistrantByIndex (
        uint index
    )
        external
        view
        returns (address)
    {

        // Will throw error if specified index does not exist
        return registrants[index];

    }


    /*** User-facing functions for reading registry state ***/


    /// @dev Any address can check if an address has *ever* registered,
    /// regardless of isWhitelisted status
    function hasRegistered (
        address target
    )
        public
        view
        returns(bool)
    {

        bool _hasRegistered = false;
        for (uint i=0; i<registrants.length; i++) {
            if (registrants[i] == target) {
                return _hasRegistered = true;
            }
        }

    }

    /// @dev Returns count of all addresses that have *ever* registered,
    /// regardless of their isWhitelisted status
    function getRegistrantCount ()
        external
        view
        returns (uint)
    {

        return registrants.length;

    }

    /// @dev Returns valid whitelisted account address by registrant index number.
    function getRegistrantByIndex (
        uint index
    )
        external
        view
        returns (address)
    {

        // Will throw error if specified index does not exist
        address target = registrants[index];

        require(
            isWhitelisted[target],
            'INVALID_ADDRESS'
        );

        return target;
    }

    function getRegistrantToReferrer(address registrant)
        external
        view
        returns (address)
    {

        return registrantToReferrer[registrant];

    }

    function getReferrerToRegistrants(address referrer)
        external
        view
        returns (address[] memory)
    {

        return referrerToRegistrants[referrer];

    }

    /// @dev *Any* address can get a valid whitelisted account's contentIds.
    ///      In practice, this is called from dapp(s).
    function getContentIdsByAddress(
        address target
    )
        external
        view
        returns (string[] memory)
    {

        require(
            isWhitelisted[target],
            'INVALID_ADDRESS'
        );

        ContentIdStruct[] memory m = addressToContentIds[target];
        string[] memory r = new string[](m.length);

        for (uint i = 0; i < m.length; i++) {
            r[i] =  m[i].contentId;
        }

        return r;

    }

    /// @dev *Any* address can get a valid whitelisted account's
    ///      address if they pass in (one of) its contentId(s).
    function getAddressByContentId(
        string calldata contentId
    )
        external
        view
        returns (address)
    {

        address target = contentIdToAddress[contentId];

        require(
            isWhitelisted[target],
            'INVALID_ADDRESS'
        );

        return target;
    }


    /*** User-facing functions to update an account's own registry state ***/


    /// @dev Valid whitelisted address can remove its own content id.
    function removeContentIdFromAddress(
        string calldata contentId
    )
        external
        whenNotPaused
    {

        require(
            isWhitelisted[msg.sender],
            'INVALID_SENDER'
        );

        require(
            contentIdToAddress[contentId] == msg.sender,
            'CONTENT_ID_DOES_NOT_BELONG_TO_SENDER'
        );

        contentIdToAddress[contentId] = address(0x0000000000000000000000000000000000000000);

        // Remove content id from addressToContentIds mapping
        // by replacing it with empty string
        ContentIdStruct[] memory m = addressToContentIds[msg.sender];
        for (uint i = 0; i < m.length; i++) {
            if (stringsMatch(contentId, m[i].contentId)) {
                addressToContentIds[msg.sender][i] = ContentIdStruct('');
            }
        }

        // If address has no valid content ids left, remove from Whitelist
        if (getNumContentIds(msg.sender) == 0) {
            isWhitelisted[msg.sender] = false;
        }

    }

    /// @dev Valid whitelisted address can remove *all* contentIds from itself.
    function removeAllContentIdsFromAddress(
        address target
    )
        external
        whenNotPaused
    {

        require(
            isWhitelisted[msg.sender],
            'INVALID_SENDER'
        );

        require(
            target == msg.sender,
            'INVALID_SENDER'
        );

        // Loop thru content ids from addressToContentIds mapping
        // by replacing each with empty string
        ContentIdStruct[] memory m = addressToContentIds[target];
        for (uint i = 0; i < m.length; i++) {
            addressToContentIds[target][i] = ContentIdStruct('');
        }

        // Remove from whitelist
        isWhitelisted[target] = false;

    }


    /*** User roles and authorizations: Contract-to-contract read functions  ***/


    /**
     * The following functions check user Roles and Authorizations.
     * For now, most of them simply check `isWhitelisted()` in this contract.
     * But the long-term idea here is to create a path for Microsponsors
     * to federate: allowing other organizations to create their own
     * exchange front-ends with their own set of granular rules about minting,
     * selling and re-selling tokens, cross-exchange arbitrage, etc etc.
     */


    /// @dev Valid whitelisted address validates registration of its own
    ///      Content ID. In practice, this will be used by Microsponsors'
    ///      ERC-721 for validating that an address is authorized to mint()
    ///      a time slot for a given content id.
    function isContentIdRegisteredToCaller(
        uint32 federationId,
        string memory contentId
    )
        public
        view
        returns (bool)
    {

        // Minimal checks around federationId here in case
        // other Federation registries wish to read from this one
        require(federationId > 0, 'INVALID_FEDERATION_ID');

        // Check tx.origin (vs msg.sender) since this *is likely* invoked by
        // another contract
        require(
            isWhitelisted[tx.origin],
            'INVALID_SENDER'
        );

        address registrantAddress = contentIdToAddress[contentId];

        require(
            registrantAddress == tx.origin,
            'INVALID_SENDER'
        );

        return true;

    }

    function isMinter(
        uint32 federationId,
        address account
    )
        public
        view
        returns (bool)
    {

        // Minimal checks around federationId here in case
        // other Federation registries wish to read from this one
        require(federationId > 0, 'INVALID_FEDERATION_ID');

        require(
            isWhitelisted[account],
            'INVALID_MINTER'
        );

        return true;

    }

    function isAuthorizedTransferFrom(
        uint32 federationId,
        address from,
        address to,
        uint256 tokenId,
        address minter,
        address owner
    )
        public
        view
        returns (bool)
    {

        // Minimal checks around federationId here in case
        // other Federation registries wish to read from this one
        require(federationId > 0, 'INVALID_FEDERATION_ID');

        // The Minter must be whitelisted
        require(
            isWhitelisted[minter],
            'INVALID_TRANSFER_MINTER'
        );

        require(
            tokenId > 0,
            'INVALID_TOKEN_ID'
        );

        require(
            from != to,
            'INVALID_TRANSFER'
        );

        require(
            owner != address(0),
            'INVALID_TRANSFER'
        );

        return true;

    }


    /***  Helpers  ***/


    function stringsMatch (
        string memory a,
        string memory b
    )
        private
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
    }


    function getNumContentIds (
        address target
    )
        private
        view
        returns (uint16)
    {

        ContentIdStruct[] memory m = addressToContentIds[target];
        uint16 counter = 0;
        for (uint i = 0; i < m.length; i++) {
            // Omit entries that are empty strings
            // (from contentIds that were removed by admin or user)
            if (!stringsMatch('', m[i].contentId)) {
                counter++;
            }
        }

        return counter;

    }


    /*** Prevent Accidents! ***/


    /// @notice No tipping!
    /// @dev Reject all Ether from being sent here.
    /// (Hopefully, we can prevent user accidents.)
    ///  Hat-tip to Cryptokitties.
    function() external payable {
        require(
            msg.sender == address(0)
        );
    }


}