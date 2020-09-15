/**
 *Submitted for verification at Etherscan.io on 2020-05-06
*/

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;

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

// File: contracts/interfaces/ILendingPoolAddressesProviderRegistry.sol

pragma solidity ^0.5.0;

/**
* @title ILendingPoolAddressesProvider interface
* @notice provides the interface to fetch the LendingPoolCore address
**/

contract ILendingPoolAddressesProviderRegistry {

    function getAddressesProvidersList() external view returns (address[] memory);
    function isAddressesProviderRegistered(address _provider) external view returns (uint256);

    function registerAddressesProvider(address _provider, uint256 _id) external;
    function unregisterAddressesProvider(address _provider) external;
}

// File: contracts/configuration/LendingPoolAddressesProviderRegistry.sol

pragma solidity ^0.5.0;





/**
* @title LendingPoolAddressesProviderRegistry contract
* @notice contains the list of active addresses providers
* @author Aave
**/

contract LendingPoolAddressesProviderRegistry is Ownable, ILendingPoolAddressesProviderRegistry {
    //events
    event AddressesProviderRegistered(address indexed newAddress);
    event AddressesProviderUnregistered(address indexed newAddress);

    mapping(address => uint256) addressesProviders;
    address[] addressesProvidersList;

    /**
    * @dev returns if an addressesProvider is registered or not
    * @param _provider the addresses provider
    * @return true if the addressesProvider is registered, false otherwise
    **/
    function isAddressesProviderRegistered(address _provider) external view returns(uint256) {
        return addressesProviders[_provider];
    }

    /**
    * @dev returns the list of active addressesProviders
    * @return the list of addressesProviders
    **/
    function getAddressesProvidersList() external view returns(address[] memory) {

        uint256 maxLength = addressesProvidersList.length;

        address[] memory activeProviders = new address[](maxLength);

        for(uint256 i = 0; i<addressesProvidersList.length; i++){
            if(addressesProviders[addressesProvidersList[i]] > 0){
                activeProviders[i] = addressesProvidersList[i];
            }
        }

        return activeProviders;
    }

    /**
    * @dev adds a lending pool to the list of registered lending pools
    * @param _provider the pool address to be registered
    **/
    function registerAddressesProvider(address _provider, uint256 _id) public onlyOwner {
        addressesProviders[_provider] = _id;
        addToAddressesProvidersListInternal(_provider);
        emit AddressesProviderRegistered(_provider);
    }

    /**
    * @dev removes a lending pool from the list of registered lending pools
    * @param _provider the pool address to be unregistered
    **/
    function unregisterAddressesProvider(address _provider) public onlyOwner {
        require(addressesProviders[_provider] > 0, "Provider is not registered");
        addressesProviders[_provider] = 0;
        emit AddressesProviderUnregistered(_provider);
    }

    /**
    * @dev adds to the list of the addresses providers, if it wasn't already added before
    * @param _provider the pool address to be added
    **/
    function addToAddressesProvidersListInternal(address _provider) internal {

        for(uint256 i = 0; i < addressesProvidersList.length; i++) {

            if(addressesProvidersList[i] == _provider){
                return;
            }
        }

        addressesProvidersList.push(_provider);
    }
}