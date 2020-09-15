/**
 *Submitted for verification at Etherscan.io on 2020-06-23
*/

pragma solidity ^0.5.0;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address private _owner;

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
    _owner = msg.sender;
  }

  /**
   * @return the address of the owner.
   */
  function owner() public view returns(address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  /**
   * @return true if `msg.sender` is the owner of the contract.
   */
  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(_owner);
    _owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

contract DOSAddressBridge is Ownable {
    // Deployed DOSProxy contract address.
    address private _proxyAddress;
    // Deployed CommitReveal contract address.
    address private _commitrevealAddress;
    // Deployed DOSPayment contract address.
    address private _paymentAddress;
    // Deployed StakingGateway contract address.
    address private _stakingAddress;
    // BootStrap node lists.
    string private _bootStrapUrl;

    event ProxyAddressUpdated(address previousProxy, address newProxy);
    event CommitRevealAddressUpdated(address previousAddr, address newAddr);
    event PaymentAddressUpdated(address previousPayment, address newPayment);
    event StakingAddressUpdated(address previousStaking, address newStaking);
    event BootStrapUrlUpdated(string previousURL, string newURL);

    function getProxyAddress() public view returns (address) {
        return _proxyAddress;
    }

    function setProxyAddress(address newAddr) public onlyOwner {
        emit ProxyAddressUpdated(_proxyAddress, newAddr);
        _proxyAddress = newAddr;
    }

    function getCommitRevealAddress() public view returns (address) {
        return _commitrevealAddress;
    }

    function setCommitRevealAddress(address newAddr) public onlyOwner {
        emit CommitRevealAddressUpdated(_commitrevealAddress, newAddr);
        _commitrevealAddress = newAddr;
    }

    function getPaymentAddress() public view returns (address) {
        return _paymentAddress;
    }

    function setPaymentAddress(address newAddr) public onlyOwner {
        emit PaymentAddressUpdated(_paymentAddress, newAddr);
        _paymentAddress = newAddr;
    }

    function getStakingAddress() public view returns (address) {
        return _stakingAddress;
    }

    function setStakingAddress(address newAddr) public onlyOwner {
        emit StakingAddressUpdated(_stakingAddress, newAddr);
        _stakingAddress = newAddr;
    }

    function getBootStrapUrl() public view returns (string memory) {
        return _bootStrapUrl;
    }

    function setBootStrapUrl(string memory url) public onlyOwner {
        emit BootStrapUrlUpdated(_bootStrapUrl, url);
        _bootStrapUrl = url;
    }
}