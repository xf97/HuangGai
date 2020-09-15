/**
 *Submitted for verification at Etherscan.io on 2020-04-28
*/

// File: @openzeppelin/contracts/GSN/Context.sol

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
contract Context {
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

// File: @openzeppelin/contracts/access/Roles.sol

pragma solidity ^0.5.0;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

// File: @openzeppelin/contracts/access/roles/WhitelistAdminRole.sol

pragma solidity ^0.5.0;



/**
 * @title WhitelistAdminRole
 * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
 */
contract WhitelistAdminRole is Context {
    using Roles for Roles.Role;

    event WhitelistAdminAdded(address indexed account);
    event WhitelistAdminRemoved(address indexed account);

    Roles.Role private _whitelistAdmins;

    constructor () internal {
        _addWhitelistAdmin(_msgSender());
    }

    modifier onlyWhitelistAdmin() {
        require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
        _;
    }

    function isWhitelistAdmin(address account) public view returns (bool) {
        return _whitelistAdmins.has(account);
    }

    function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
        _addWhitelistAdmin(account);
    }

    function renounceWhitelistAdmin() public {
        _removeWhitelistAdmin(_msgSender());
    }

    function _addWhitelistAdmin(address account) internal {
        _whitelistAdmins.add(account);
        emit WhitelistAdminAdded(account);
    }

    function _removeWhitelistAdmin(address account) internal {
        _whitelistAdmins.remove(account);
        emit WhitelistAdminRemoved(account);
    }
}

// File: @openzeppelin/contracts/access/roles/WhitelistedRole.sol

pragma solidity ^0.5.0;




/**
 * @title WhitelistedRole
 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
 * it), and not Whitelisteds themselves.
 */
contract WhitelistedRole is Context, WhitelistAdminRole {
    using Roles for Roles.Role;

    event WhitelistedAdded(address indexed account);
    event WhitelistedRemoved(address indexed account);

    Roles.Role private _whitelisteds;

    modifier onlyWhitelisted() {
        require(isWhitelisted(_msgSender()), "WhitelistedRole: caller does not have the Whitelisted role");
        _;
    }

    function isWhitelisted(address account) public view returns (bool) {
        return _whitelisteds.has(account);
    }

    function addWhitelisted(address account) public onlyWhitelistAdmin {
        _addWhitelisted(account);
    }

    function removeWhitelisted(address account) public onlyWhitelistAdmin {
        _removeWhitelisted(account);
    }

    function renounceWhitelisted() public {
        _removeWhitelisted(_msgSender());
    }

    function _addWhitelisted(address account) internal {
        _whitelisteds.add(account);
        emit WhitelistedAdded(account);
    }

    function _removeWhitelisted(address account) internal {
        _whitelisteds.remove(account);
        emit WhitelistedRemoved(account);
    }
}

// File: contracts/access/MetaFactoryWhitelist.sol

pragma solidity ^0.5.14;


contract MetaFactoryWhitelist is WhitelistedRole {
    constructor() public {
        super.addWhitelisted(msg.sender);
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/registry/SealedBidsRegistry.sol

pragma solidity ^0.5.14;



contract SealedBidsRegistry {

    event OfferMade(address indexed bidder, string sealedBid);
    event OfferUpdated(address indexed bidder, string sealedBid);
    event OfferCleared(address indexed bidder);

    event StartTimeUpdated(uint256 indexed startTime);
    event EndTimeUpdated(uint256 indexed endTime);

    struct Offer {
        string ipfsHash;
        uint256 timestamp;
    }

    MetaFactoryWhitelist public whitelist;

    uint256 public totalBids;

    mapping(address => Offer) public offers;

    uint256 public startTime;
    uint256 public endTime;

    modifier onlyWhenOpen() {
        require(now >= startTime && now <= endTime, "Registry not open");
        _;
    }

    modifier onlyWhenWhitelisted() {
        require(whitelist.isWhitelisted(msg.sender), "Caller is not whitelisted");
        _;
    }

    constructor(MetaFactoryWhitelist _whitelist, uint256 _startTime, uint256 _endTime) public {
        whitelist = _whitelist;
        startTime = _startTime;
        endTime = _endTime;
    }

    function recordOffer(string memory sealedBidIpfsHash) onlyWhenOpen public {
        require(bytes(sealedBidIpfsHash).length == 46, "Invalid IPFS hash supplied for the sealed bid");

        if (bytes(offers[msg.sender].ipfsHash).length == 0) {
            totalBids++;
            emit OfferMade(msg.sender, sealedBidIpfsHash);
        }

        offers[msg.sender] = Offer({
            ipfsHash: sealedBidIpfsHash,
            timestamp: now
        });

        emit OfferUpdated(msg.sender, sealedBidIpfsHash);
    }

    function clearOffer() onlyWhenOpen public {
        require(bytes(offers[msg.sender].ipfsHash).length != 0, "No offer or offer already cleared");
        totalBids--;
        delete offers[msg.sender];
        emit OfferCleared(msg.sender);
    }

    function updateStartTime(uint256 _startTime) onlyWhenWhitelisted public {
        startTime = _startTime;
        emit StartTimeUpdated(_startTime);
    }

    function updateEndTime(uint256 _endTime) onlyWhenWhitelisted public {
        endTime = _endTime;
        emit EndTimeUpdated(_endTime);
    }

    function pullFunds(IERC20 token, address[] calldata bidders, uint256[] calldata amounts) onlyWhenWhitelisted external {
        require(bidders.length == amounts.length, "Array lengths are out of sync");
        require(bidders.length > 0, "No bidders have been supplied");

        address self = address(this);
        for (uint256 i = 0; i < bidders.length; i++) {
            address bidder = bidders[i];
            uint256 amount = amounts[i];

            token.transferFrom(bidder, self, amount);
        }
    }

    function withdrawFunds(IERC20 token, address recipient) onlyWhenWhitelisted external {
        uint256 contractBalance = token.balanceOf(address(this));
        token.transfer(recipient, contractBalance);
    }

    function getOffer(address bidder) public view returns (
        string memory _ipfsHash,
        uint256 _timestamp
    ) {
        require(bytes(offers[bidder].ipfsHash).length > 0, "No offer for specified bidder");
        Offer memory offer = offers[bidder];
        return (offer.ipfsHash, offer.timestamp);
    }

}