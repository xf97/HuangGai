/**
 *Submitted for verification at Etherscan.io on 2020-05-20
*/

// File: openzeppelin-solidity/contracts/GSN/Context.sol

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

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;

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
        _owner = _msgSender();
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
     * NOTE: Renouncing ownership will leave the contract without an owner,
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
}

// File: contracts/HintoTips.sol

pragma solidity ^0.5.10;


contract HintoTips is Ownable {
    mapping(address => bool) public publishers;
    uint256 tipsCount;
    mapping(uint256 => Tip) public tips;

    struct Tip {
        address publisher;
        bytes32 tipCode;
        bytes32 tipMetaSha256Hash;
        bytes32[] recipients;
        bool isValid;
    }

    event ApprovePublisher(address publisher);
    event PublisherDisapproved(address publisher);
    event TipPublished(
        address publisher,
        bytes32 tipCode,
        uint256 tipId,
        bytes32[] indexed recipients
    );
    event TipVoided(uint256 tipId);

    modifier isPublisher() {
        require(
            publishers[msg.sender],
            "Only approved publishers can call this method"
        );
        _;
    }

    modifier tipExists(uint256 _tipId) {
        require(tipsCount > _tipId, "Tip with the given id does not exist");
        _;
    }
    
    constructor() public Ownable() {}

    function approvePublisher(address _publisher) external onlyOwner() {
        publishers[_publisher] = true;
        emit ApprovePublisher(_publisher);
    }

    function disapprovePublisher(address _publisher) external onlyOwner() {
        publishers[_publisher] = false;
        emit PublisherDisapproved(_publisher);
    }

    function publishTip(
        bytes32 _tipCode,
        bytes32 _tipMetaSha256Hash,
        bytes32[] calldata _recipients
    ) external isPublisher() {
        Tip memory tip = Tip(
            msg.sender,
            _tipCode,
            _tipMetaSha256Hash,
            _recipients,
            true
        );
        tips[tipsCount] = tip;
        emit TipPublished(msg.sender, _tipCode, tipsCount, _recipients);
        tipsCount++;
    }

    function invalidateTip(uint256 _tipId) external tipExists(_tipId) {
        require(
            msg.sender == owner() || tips[_tipId].publisher == msg.sender,
            "Only the contract owner or the tip publisher can unvalid it"
        );
        tips[_tipId].isValid = false;
        emit TipVoided(_tipId);
    }

    function getTipsCount() external view returns (uint256) {
        return tipsCount;
    }

    function getTip(uint256 _tipId)
        external
        view
        tipExists(_tipId)
        returns (address, bytes32, bytes32, bytes32[] memory, bool)
    {
        return (
            tips[_tipId].publisher,
            tips[_tipId].tipCode,
            tips[_tipId].tipMetaSha256Hash,
            tips[_tipId].recipients,
            tips[_tipId].isValid
        );
    }
}