/**
 *Submitted for verification at Etherscan.io on 2020-04-29
*/

pragma solidity ^0.4.24;


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}



/*
  The PermittedConverts contract determines which addresses are permitted
*/
contract PermittedConverts is Ownable {
  event NewConvertsEnabled(address newConvert, bool enabled);
  // Mapping to permitted PoolPortal addresses
  mapping (address => bool) public permittedAddresses;

  /**
  * @dev contructor
  *
  * @param _address    The initial Pool Portal address to be permitted
  */
  constructor(address _address) public {
    _enableAddress(_address, true);
  }


  /**
  * @dev Completes the process of adding a new pool portal to permittedAddresses
  *
  * @param _newAddress    The new address to permit
  */
  function addNewConvertAddress(address _newAddress) public onlyOwner {
    // Set the pool portal as permitted
    _enableAddress(_newAddress, true);
  }

  /**
  * @dev Disables an address, meaning SmartFunds will no longer be able to connect to them
  * if they're not already connected
  *
  * @param _newAddress    The address to disable
  */
  function disableAddress(address _newAddress) public onlyOwner {
    _enableAddress(_newAddress, false);
  }

  /**
  * @dev Enables/disables an address
  *
  * @param _newAddress    The new address to set
  * @param _enabled       Bool representing whether or not the address will be enabled
  */
  function _enableAddress(address _newAddress, bool _enabled) private {
    permittedAddresses[_newAddress] = _enabled;

    emit NewConvertsEnabled(_newAddress, _enabled);
  }
}