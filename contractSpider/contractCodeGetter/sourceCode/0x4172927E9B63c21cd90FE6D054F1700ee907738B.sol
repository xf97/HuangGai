/**
 *Submitted for verification at Etherscan.io on 2020-05-08
*/

pragma solidity ^0.5.2;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
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
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     * @notice Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
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

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.2;

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

// File: contracts/external/SetProtocolContracts/lib/AddressArrayUtils.sol

// Pulled in from Cryptofin Solidity package in order to control Solidity compiler version
// https://github.com/cryptofinlabs/cryptofin-solidity/blob/master/contracts/array-utils/AddressArrayUtils.sol

pragma solidity 0.5.7;


library AddressArrayUtils {

    /**
     * Finds the index of the first occurrence of the given element.
     * @param A The input array to search
     * @param a The value to find
     * @return Returns (index and isIn) for the first occurrence starting from index 0
     */
    function indexOf(address[] memory A, address a) internal pure returns (uint256, bool) {
        uint256 length = A.length;
        for (uint256 i = 0; i < length; i++) {
            if (A[i] == a) {
                return (i, true);
            }
        }
        return (0, false);
    }

    /**
    * Returns true if the value is present in the list. Uses indexOf internally.
    * @param A The input array to search
    * @param a The value to find
    * @return Returns isIn for the first occurrence starting from index 0
    */
    function contains(address[] memory A, address a) internal pure returns (bool) {
        bool isIn;
        (, isIn) = indexOf(A, a);
        return isIn;
    }

    /**
     * Returns the combination of the two arrays
     * @param A The first array
     * @param B The second array
     * @return Returns A extended by B
     */
    function extend(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
        uint256 aLength = A.length;
        uint256 bLength = B.length;
        address[] memory newAddresses = new address[](aLength + bLength);
        for (uint256 i = 0; i < aLength; i++) {
            newAddresses[i] = A[i];
        }
        for (uint256 j = 0; j < bLength; j++) {
            newAddresses[aLength + j] = B[j];
        }
        return newAddresses;
    }

    /**
     * Returns the array with a appended to A.
     * @param A The first array
     * @param a The value to append
     * @return Returns A appended by a
     */
    function append(address[] memory A, address a) internal pure returns (address[] memory) {
        address[] memory newAddresses = new address[](A.length + 1);
        for (uint256 i = 0; i < A.length; i++) {
            newAddresses[i] = A[i];
        }
        newAddresses[A.length] = a;
        return newAddresses;
    }

    /**
     * Returns the intersection of two arrays. Arrays are treated as collections, so duplicates are kept.
     * @param A The first array
     * @param B The second array
     * @return The intersection of the two arrays
     */
    function intersect(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
        uint256 length = A.length;
        bool[] memory includeMap = new bool[](length);
        uint256 newLength = 0;
        for (uint256 i = 0; i < length; i++) {
            if (contains(B, A[i])) {
                includeMap[i] = true;
                newLength++;
            }
        }
        address[] memory newAddresses = new address[](newLength);
        uint256 j = 0;
        for (uint256 k = 0; k < length; k++) {
            if (includeMap[k]) {
                newAddresses[j] = A[k];
                j++;
            }
        }
        return newAddresses;
    }

    /**
     * Returns the union of the two arrays. Order is not guaranteed.
     * @param A The first array
     * @param B The second array
     * @return The union of the two arrays
     */
    function union(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
        address[] memory leftDifference = difference(A, B);
        address[] memory rightDifference = difference(B, A);
        address[] memory intersection = intersect(A, B);
        return extend(leftDifference, extend(intersection, rightDifference));
    }

    /**
     * Computes the difference of two arrays. Assumes there are no duplicates.
     * @param A The first array
     * @param B The second array
     * @return The difference of the two arrays
     */
    function difference(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
        uint256 length = A.length;
        bool[] memory includeMap = new bool[](length);
        uint256 count = 0;
        // First count the new length because can't push for in-memory arrays
        for (uint256 i = 0; i < length; i++) {
            address e = A[i];
            if (!contains(B, e)) {
                includeMap[i] = true;
                count++;
            }
        }
        address[] memory newAddresses = new address[](count);
        uint256 j = 0;
        for (uint256 k = 0; k < length; k++) {
            if (includeMap[k]) {
                newAddresses[j] = A[k];
                j++;
            }
        }
        return newAddresses;
    }

    /**
    * Removes specified index from array
    * Resulting ordering is not guaranteed
    * @return Returns the new array and the removed entry
    */
    function pop(address[] memory A, uint256 index)
        internal
        pure
        returns (address[] memory, address)
    {
        uint256 length = A.length;
        address[] memory newAddresses = new address[](length - 1);
        for (uint256 i = 0; i < index; i++) {
            newAddresses[i] = A[i];
        }
        for (uint256 j = index + 1; j < length; j++) {
            newAddresses[j - 1] = A[j];
        }
        return (newAddresses, A[index]);
    }

    /**
     * @return Returns the new array
     */
    function remove(address[] memory A, address a)
        internal
        pure
        returns (address[] memory)
    {
        (uint256 index, bool isIn) = indexOf(A, a);
        if (!isIn) {
            revert();
        } else {
            (address[] memory _A,) = pop(A, index);
            return _A;
        }
    }

    /**
     * Returns whether or not there's a duplicate. Runs in O(n^2).
     * @param A Array to search
     * @return Returns true if duplicate, false otherwise
     */
    function hasDuplicate(address[] memory A) internal pure returns (bool) {
        if (A.length == 0) {
            return false;
        }
        for (uint256 i = 0; i < A.length - 1; i++) {
            for (uint256 j = i + 1; j < A.length; j++) {
                if (A[i] == A[j]) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Returns whether the two arrays are equal.
     * @param A The first array
     * @param B The second array
     * @return True is the arrays are equal, false if not.
     */
    function isEqual(address[] memory A, address[] memory B) internal pure returns (bool) {
        if (A.length != B.length) {
            return false;
        }
        for (uint256 i = 0; i < A.length; i++) {
            if (A[i] != B[i]) {
                return false;
            }
        }
        return true;
    }
}

// File: contracts/external/SetProtocolContracts/lib/TimeLockUpgrade.sol

/*
    Copyright 2018 Set Labs Inc.

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

pragma solidity 0.5.7;




/**
 * @title TimeLockUpgrade
 * @author Set Protocol
 *
 * The TimeLockUpgrade contract contains a modifier for handling minimum time period updates
 */
contract TimeLockUpgrade is
    Ownable
{
    using SafeMath for uint256;

    /* ============ State Variables ============ */

    // Timelock Upgrade Period in seconds
    uint256 public timeLockPeriod;

    // Mapping of upgradable units and initialized timelock
    mapping(bytes32 => uint256) public timeLockedUpgrades;

    /* ============ Events ============ */

    event UpgradeRegistered(
        bytes32 _upgradeHash,
        uint256 _timestamp
    );

    /* ============ Modifiers ============ */

    modifier timeLockUpgrade() {
        // If the time lock period is 0, then allow non-timebound upgrades.
        // This is useful for initialization of the protocol and for testing.
        if (timeLockPeriod == 0) {
            _;

            return;
        }

        // The upgrade hash is defined by the hash of the transaction call data,
        // which uniquely identifies the function as well as the passed in arguments.
        bytes32 upgradeHash = keccak256(
            abi.encodePacked(
                msg.data
            )
        );

        uint256 registrationTime = timeLockedUpgrades[upgradeHash];

        // If the upgrade hasn't been registered, register with the current time.
        if (registrationTime == 0) {
            timeLockedUpgrades[upgradeHash] = block.timestamp;

            emit UpgradeRegistered(
                upgradeHash,
                block.timestamp
            );

            return;
        }

        require(
            block.timestamp >= registrationTime.add(timeLockPeriod),
            "TimeLockUpgrade: Time lock period must have elapsed."
        );

        // Reset the timestamp to 0
        timeLockedUpgrades[upgradeHash] = 0;

        // Run the rest of the upgrades
        _;
    }

    /* ============ Function ============ */

    /**
     * Change timeLockPeriod period. Generally called after initially settings have been set up.
     *
     * @param  _timeLockPeriod   Time in seconds that upgrades need to be evaluated before execution
     */
    function setTimeLockPeriod(
        uint256 _timeLockPeriod
    )
        external
        onlyOwner
    {
        // Only allow setting of the timeLockPeriod if the period is greater than the existing
        require(
            _timeLockPeriod > timeLockPeriod,
            "TimeLockUpgrade: New period must be greater than existing"
        );

        timeLockPeriod = _timeLockPeriod;
    }
}

// File: contracts/external/SetProtocolContracts/lib/Authorizable.sol

/*
    Copyright 2018 Set Labs Inc.

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

pragma solidity 0.5.7;






/**
 * @title Authorizable
 * @author Set Protocol
 *
 * The Authorizable contract is an inherited contract that sets permissions on certain function calls
 * through the onlyAuthorized modifier. Permissions can be managed only by the Owner of the contract.
 */
contract Authorizable is
    Ownable,
    TimeLockUpgrade
{
    using SafeMath for uint256;
    using AddressArrayUtils for address[];

    /* ============ State Variables ============ */

    // Mapping of addresses to bool indicator of authorization
    mapping (address => bool) public authorized;

    // Array of authorized addresses
    address[] public authorities;

    /* ============ Modifiers ============ */

    // Only authorized addresses can invoke functions with this modifier.
    modifier onlyAuthorized {
        require(
            authorized[msg.sender],
            "Authorizable.onlyAuthorized: Sender not included in authorities"
        );
        _;
    }

    /* ============ Events ============ */

    // Event emitted when new address is authorized.
    event AddressAuthorized (
        address indexed authAddress,
        address authorizedBy
    );

    // Event emitted when address is deauthorized.
    event AuthorizedAddressRemoved (
        address indexed addressRemoved,
        address authorizedBy
    );

    /* ============ Setters ============ */

    /**
     * Add authorized address to contract. Can only be set by owner.
     *
     * @param  _authTarget   The address of the new authorized contract
     */

    function addAuthorizedAddress(address _authTarget)
        external
        onlyOwner
        timeLockUpgrade
    {
        // Require that address is not already authorized
        require(
            !authorized[_authTarget],
            "Authorizable.addAuthorizedAddress: Address already registered"
        );

        // Set address authority to true
        authorized[_authTarget] = true;

        // Add address to authorities array
        authorities.push(_authTarget);

        // Emit authorized address event
        emit AddressAuthorized(
            _authTarget,
            msg.sender
        );
    }

    /**
     * Remove authorized address from contract. Can only be set by owner.
     *
     * @param  _authTarget   The address to be de-permissioned
     */

    function removeAuthorizedAddress(address _authTarget)
        external
        onlyOwner
    {
        // Require address is authorized
        require(
            authorized[_authTarget],
            "Authorizable.removeAuthorizedAddress: Address not authorized"
        );

        // Delete address from authorized mapping
        authorized[_authTarget] = false;

        authorities = authorities.remove(_authTarget);

        // Emit AuthorizedAddressRemoved event.
        emit AuthorizedAddressRemoved(
            _authTarget,
            msg.sender
        );
    }

    /* ============ Getters ============ */

    /**
     * Get array of authorized addresses.
     *
     * @return address[]   Array of authorized addresses
     */
    function getAuthorizedAddresses()
        external
        view
        returns (address[] memory)
    {
        // Return array of authorized addresses
        return authorities;
    }
}

// File: contracts/meta-oracles/interfaces/IOracle.sol

/*
    Copyright 2019 Set Labs Inc.

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

pragma solidity 0.5.7;


/**
 * @title IOracle
 * @author Set Protocol
 *
 * Interface for operating with any external Oracle that returns uint256 or
 * an adapting contract that converts oracle output to uint256
 */
interface IOracle {

    /**
     * Returns the queried data from an oracle returning uint256
     *
     * @return  Current price of asset represented in uint256
     */
    function read()
        external
        view
        returns (uint256);
}

// File: contracts/meta-oracles/proxies/MedianOracleAdapter.sol

/*
    Copyright 2020 Set Labs Inc.

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

pragma solidity 0.5.7;




/**
 * @title MedianOracleAdapter
 * @author Set Protocol
 *
 * Permissioned oracle proxy that is intended to replicate the interface of the MakerDAO Legacy IMedian
 * oracle that returns bytes32 values.
 */
contract MedianOracleAdapter is
    Authorizable
{

    /* ============ State Variables ============ */
    IOracle public oracleInstance;

    /* ============ Events ============ */

    event LogOracleUpdated(
        address indexed newOracleAddress
    );

    /* ============ Constructor ============ */
    /*
     * Set address of oracle being proxied
     *
     * @param  _oracleAddress    The address of oracle being proxied
     */
    constructor(
        IOracle _oracleAddress
    )
        public
    {
        oracleInstance = _oracleAddress;
    }

    /* ============ External ============ */

    /*
     * Reads value of IOracle and returns bytes32 result. Only authorized addresses are allowed
     * to call read().
     *
     * @returns         Oracle's bytes32 converted output
     */
    function read()
        external
        view
        onlyAuthorized
        returns (bytes32)
    {
        // Read value of oracle and coerces into bytes32
        return bytes32(oracleInstance.read());
    }

    /*
     * Sets address of new oracle to be proxied. Only owner has ability to update oracleAddress.
     *
     * @param _newOracleAddress         Address of new oracle being proxied
     */
    function changeOracleAddress(
        IOracle _newOracleAddress
    )
        external
        onlyOwner
        timeLockUpgrade // Must be placed after onlyOwner
    {
        // Check to make sure new oracle address is passed
        require(
            address(_newOracleAddress) != address(oracleInstance),
            "MedianOracleAdapter.changeOracleAddress: Must give new oracle address."
        );

        // Set new Oracle instance
        oracleInstance = _newOracleAddress;

        emit LogOracleUpdated(address(_newOracleAddress));
    }
}