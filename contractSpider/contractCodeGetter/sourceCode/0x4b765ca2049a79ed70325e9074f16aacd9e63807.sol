/**
 *Submitted for verification at Etherscan.io on 2020-04-28
*/

pragma solidity 0.5.4;
// File: openzeppelin-solidity/contracts/ownership/Ownable.sol
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
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
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
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

// File: contracts/interfaces/IGovernanceRegistry.sol
/**
 * @title Governance Registry Interface
 */
interface IGovernanceRegistry {
    
    /**
     * @return true if @param account is a signee.
     */
    function isSignee(address account) external view returns (bool);

    /**
     * @return true if @param account is a vault.
     */
    function isVault(address account) external view returns (bool) ;

}

// File: contracts/governance/GovernanceRegistry.sol
/**
 * @title Governance Registry
 * @dev Holds signees and vaults addresses.
 */
contract GovernanceRegistry is Ownable {

    struct Actor {
        bytes32 name;
        bool enrolled;
    }

    /**
     * @dev Holds signees
     */
    mapping (address => Actor) public signees;

    /**
     * @dev Holds vaults
     */
    mapping (address => Actor) public vaults;

    /**
     * @dev Adds the signee role to an address.
     * @param name Use web3.utils.fromAscii(string).
     */
    function addSignee(address signee, bytes32 name) external onlyOwner{
        signees[signee] = Actor(name,true);
    }

    /**
     * @dev Removes the signee role from an address.
     */
    function removeSignee(address signee) external onlyOwner {
        signees[signee] = Actor(bytes32(0),false);
    }

    /**
     * @dev Adds the vault role to an address.
     * @param name Use web3.utils.fromAscii(string).
     */
    function addVault(address vault, bytes32 name) external onlyOwner {
        vaults[vault] = Actor(name,true);
    }

    /**
     * @dev Removes the vault role from an address.
     */
    function removeVault(address vault) external onlyOwner {
        vaults[vault] = Actor(bytes32(0),false);
    }

    /**
     * @return true if @param account is a signee.
     */
    function isSignee(address account) external view returns (bool) {
        return signees[account].enrolled;
    }

    /**
     * @return true if @param account is a vault.
     */
    function isVault(address account) external view returns (bool) {
        return vaults[account].enrolled;
    }
}