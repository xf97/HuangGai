/**
 *Submitted for verification at Etherscan.io on 2020-06-26
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.8;

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
abstract contract Context {
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
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


interface ENS {
    function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
    function owner(bytes32 node) external view returns (address);
}

contract Certification is Ownable {
    ENS ens;
    // namehash of chainshot.eth
    bytes32 node = 0x94dbba951baaab08bb17e607f270ebe323bf4f90dc7ee482add342d350de44e8;
    mapping(address => bool) certified;
    mapping(address => bytes32) public registration;

    constructor(address _ens) public {
        ens = ENS(_ens);
    }

    function certify(address _addr) public onlyOwner {
        certified[_addr] = true;
    }

    function isCertified(address _addr) public view returns(bool) {
        return certified[_addr];
    }

    function revoke(address _addr) public onlyOwner {
        certified[_addr] = false;
        _unregisterSubnode();
    }

    function register(string memory name) public {
        require(isCertified(msg.sender), "msg.sender must be certified!");
        bytes32 label = keccak256(abi.encodePacked(name));
        bytes32 subnode = keccak256(abi.encodePacked(node, label));
        // this subdomain is already registered
        require(ens.owner(subnode) == address(0x0), "this subnode is already registered to another address!");
        _unregisterSubnode();
        // register new subdomain
        registration[msg.sender] = label;
        ens.setSubnodeOwner(node, label, msg.sender);
    }

    function _unregisterSubnode() private {
        if(registration[msg.sender] != 0) {
            ens.setSubnodeOwner(node, registration[msg.sender], address(0x0));
        }
    }
}