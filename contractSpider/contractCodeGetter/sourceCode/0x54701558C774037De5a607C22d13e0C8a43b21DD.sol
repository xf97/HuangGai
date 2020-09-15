/**
 *Submitted for verification at Etherscan.io on 2020-06-22
*/

pragma solidity ^0.5.2;
pragma experimental "ABIEncoderV2";

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

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

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

// File: contracts/external/SetProtocolContracts/lib/TimeLockUpgradeV2.sol

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
 * @title TimeLockUpgradeV2
 * @author Set Protocol
 *
 * The TimeLockUpgradeV2 contract contains a modifier for handling minimum time period updates
 *
 * CHANGELOG:
 * - Requires that the caller is the owner
 * - New function to allow deletion of existing timelocks
 * - Added upgradeData to UpgradeRegistered event
 */
contract TimeLockUpgradeV2 is
    Ownable
{
    using SafeMath for uint256;

    /* ============ State Variables ============ */

    // Timelock Upgrade Period in seconds
    uint256 public timeLockPeriod;

    // Mapping of maps hash of registered upgrade to its registration timestam
    mapping(bytes32 => uint256) public timeLockedUpgrades;

    /* ============ Events ============ */

    event UpgradeRegistered(
        bytes32 indexed _upgradeHash,
        uint256 _timestamp,
        bytes _upgradeData
    );

    event RemoveRegisteredUpgrade(
        bytes32 indexed _upgradeHash
    );

    /* ============ Modifiers ============ */

    modifier timeLockUpgrade() {
        require(
            isOwner(),
            "TimeLockUpgradeV2: The caller must be the owner"
        );

        // If the time lock period is 0, then allow non-timebound upgrades.
        // This is useful for initialization of the protocol and for testing.
        if (timeLockPeriod > 0) {
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
                    block.timestamp,
                    msg.data
                );

                return;
            }

            require(
                block.timestamp >= registrationTime.add(timeLockPeriod),
                "TimeLockUpgradeV2: Time lock period must have elapsed."
            );

            // Reset the timestamp to 0
            timeLockedUpgrades[upgradeHash] = 0;

        }

        // Run the rest of the upgrades
        _;
    }

    /* ============ Function ============ */

    /**
     * Removes an existing upgrade.
     *
     * @param  _upgradeHash    Keccack256 hash that uniquely identifies function called and arguments
     */
    function removeRegisteredUpgrade(
        bytes32 _upgradeHash
    )
        external
        onlyOwner
    {
        require(
            timeLockedUpgrades[_upgradeHash] != 0,
            "TimeLockUpgradeV2.removeRegisteredUpgrade: Upgrade hash must be registered"
        );

        // Reset the timestamp to 0
        timeLockedUpgrades[_upgradeHash] = 0;

        emit RemoveRegisteredUpgrade(
            _upgradeHash
        );
    }

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
            "TimeLockUpgradeV2: New period must be greater than existing"
        );

        timeLockPeriod = _timeLockPeriod;
    }
}

// File: contracts/meta-oracles/lib/DataSourceLinearInterpolationLibrary.sol

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
 * @title LinearInterpolationLibrary
 * @author Set Protocol
 *
 * Library used to determine linearly interpolated value for DataSource contracts when TimeSeriesFeed
 * is updated after interpolationThreshold has passed.
 */
library DataSourceLinearInterpolationLibrary {
    using SafeMath for uint256;

    /* ============ External ============ */

    /*
     * When the update time has surpassed the currentTime + interpolationThreshold, linearly interpolate the
     * price between the current time and price and the last updated time and price to reduce potential error. This
     * is done with the following series of equations, modified in this instance to deal unsigned integers:
     *
     * price = (currentPrice * updateInterval + previousLoggedPrice * timeFromExpectedUpdate) / timeFromLastUpdate
     *
     * Where updateTimeFraction represents the fraction of time passed between the last update and now spent in
     * the previous update window. It's worth noting that because we consider updates to occur on their update
     * timestamp we can make the assumption that the amount of time spent in the previous update window is equal
     * to the update frequency.
     *
     * By way of example, assume updateInterval of 24 hours and a interpolationThreshold of 1 hour. At time 1 the
     * update is missed by one day and when the oracle is finally called the price is 150, the price feed
     * then interpolates this price to imply a price at t1 equal to 125. Time 2 the update is 10 minutes late but
     * since it's within the interpolationThreshold the value isn't interpolated. At time 3 everything
     * falls back in line.
     *
     * +----------------------+------+-------+-------+-------+
     * |                      | 0    | 1     | 2     | 3     |
     * +----------------------+------+-------+-------+-------+
     * | Expected Update Time | 0:00 | 24:00 | 48:00 | 72:00 |
     * +----------------------+------+-------+-------+-------+
     * | Actual Update Time   | 0:00 | 48:00 | 48:10 | 72:00 |
     * +----------------------+------+-------+-------+-------+
     * | Logged Px            | 100  | 125   | 151   | 130   |
     * +----------------------+------+-------+-------+-------+
     * | Received Oracle Px   | 100  | 150   | 151   | 130   |
     * +----------------------+------+-------+-------+-------+
     * | Actual Price         | 100  | 110   | 151   | 130   |
     * +------------------------------------------------------
     *
     * @param  _currentPrice                Current price returned by oracle
     * @param  _updateInterval              Update interval of TimeSeriesFeed
     * @param  _timeFromExpectedUpdate      Time passed from expected update
     * @param  _previousLoggedDataPoint     Previously logged price from TimeSeriesFeed
     * @returns                             Interpolated price value
     */
    function interpolateDelayedPriceUpdate(
        uint256 _currentPrice,
        uint256 _updateInterval,
        uint256 _timeFromExpectedUpdate,
        uint256 _previousLoggedDataPoint
    )
        internal
        pure
        returns (uint256)
    {
        // Calculate how much time has passed from timestamp corresponding to last update
        uint256 timeFromLastUpdate = _timeFromExpectedUpdate.add(_updateInterval);

        // Linearly interpolate between last updated price (with corresponding timestamp) and current price (with
        // current timestamp) to imply price at the timestamp we are updating
        return _currentPrice.mul(_updateInterval)
            .add(_previousLoggedDataPoint.mul(_timeFromExpectedUpdate))
            .div(timeFromLastUpdate);
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

// File: contracts/meta-oracles/lib/LinkedListLibraryV3.sol

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
 * @title LinkedListLibraryV3
 * @author Set Protocol
 *
 * Library for creating and altering uni-directional circularly linked lists, optimized for sequential updating
 * Version two of this contract is a library vs. a contract.
 *
 *
 * CHANGELOG
 * - LinkedListLibraryV3's readList function does not load LinkedList into memory
 * - readListMemory is removed
 */
library LinkedListLibraryV3 {

    using SafeMath for uint256;

    /* ============ Structs ============ */

    struct LinkedList{
        uint256 dataSizeLimit;
        uint256 lastUpdatedIndex;
        uint256[] dataArray;
    }

    /*
     * Initialize LinkedList by setting limit on amount of nodes and initial value of node 0
     *
     * @param  _self                        LinkedList to operate on
     * @param  _dataSizeLimit               Max amount of nodes allowed in LinkedList
     * @param  _initialValue                Initial value of node 0 in LinkedList
     */
    function initialize(
        LinkedList storage _self,
        uint256 _dataSizeLimit,
        uint256 _initialValue
    )
        internal
    {
        // Check dataArray is empty
        require(
            _self.dataArray.length == 0,
            "LinkedListLibrary.initialize: Initialized LinkedList must be empty"
        );

        // Check that LinkedList is intialized to be greater than 0 size
        require(
            _dataSizeLimit > 0,
            "LinkedListLibrary.initialize: dataSizeLimit must be greater than 0."
        );

        // Initialize Linked list by defining upper limit of data points in the list and setting
        // initial value
        _self.dataSizeLimit = _dataSizeLimit;
        _self.dataArray.push(_initialValue);
        _self.lastUpdatedIndex = 0;
    }

    /*
     * Add new value to list by either creating new node if node limit not reached or updating
     * existing node value
     *
     * @param  _self                        LinkedList to operate on
     * @param  _addedValue                  Value to add to list
     */
    function editList(
        LinkedList storage _self,
        uint256 _addedValue
    )
        internal
    {
        // Add node if data hasn't reached size limit, otherwise update next node
        _self.dataArray.length < _self.dataSizeLimit ? addNode(_self, _addedValue)
            : updateNode(_self, _addedValue);
    }

    /*
     * Add new value to list by either creating new node. Node limit must not be reached.
     *
     * @param  _self                        LinkedList to operate on
     * @param  _addedValue                  Value to add to list
     */
    function addNode(
        LinkedList storage _self,
        uint256 _addedValue
    )
        internal
    {
        uint256 newNodeIndex = _self.lastUpdatedIndex.add(1);

        require(
            newNodeIndex == _self.dataArray.length,
            "LinkedListLibrary: Node must be added at next expected index in list"
        );

        require(
            newNodeIndex < _self.dataSizeLimit,
            "LinkedListLibrary: Attempting to add node that exceeds data size limit"
        );

        // Add node value
        _self.dataArray.push(_addedValue);

        // Update lastUpdatedIndex value
        _self.lastUpdatedIndex = newNodeIndex;
    }

    /*
     * Add new value to list by updating existing node. Updates only happen if node limit has been
     * reached.
     *
     * @param  _self                        LinkedList to operate on
     * @param  _addedValue                  Value to add to list
     */
    function updateNode(
        LinkedList storage _self,
        uint256 _addedValue
    )
        internal
    {
        // Determine the next node in list to be updated
        uint256 updateNodeIndex = _self.lastUpdatedIndex.add(1) % _self.dataSizeLimit;

        // Require that updated node has been previously added
        require(
            updateNodeIndex < _self.dataArray.length,
            "LinkedListLibrary: Attempting to update non-existent node"
        );

        // Update node value and last updated index
        _self.dataArray[updateNodeIndex] = _addedValue;
        _self.lastUpdatedIndex = updateNodeIndex;
    }

    /*
     * Read list from the lastUpdatedIndex back the passed amount of data points.
     *
     * @param  _self                        LinkedList to operate on
     * @param  _dataPoints                  Number of data points to return
     * @return                              Array of length dataPoints containing most recent values
     */
    function readList(
        LinkedList storage _self,
        uint256 _dataPoints
    )
        internal
        view
        returns (uint256[] memory)
    {
        // Make sure query isn't for more data than collected
        require(
            _dataPoints <= _self.dataArray.length,
            "LinkedListLibrary: Querying more data than available"
        );

        // Instantiate output array in memory
        uint256[] memory outputArray = new uint256[](_dataPoints);

        // Find head of list
        uint256 linkedListIndex = _self.lastUpdatedIndex;
        for (uint256 i = 0; i < _dataPoints; i++) {
            // Get value at index in linkedList
            outputArray[i] = _self.dataArray[linkedListIndex];

            // Find next linked index
            linkedListIndex = linkedListIndex == 0 ? _self.dataSizeLimit.sub(1) : linkedListIndex.sub(1);
        }

        return outputArray;
    }

    /*
     * Get latest value from LinkedList.
     *
     * @param  _self                        LinkedList to operate on
     * @return                              Latest logged value in LinkedList
     */
    function getLatestValue(
        LinkedList storage _self
    )
        internal
        view
        returns (uint256)
    {
        return _self.dataArray[_self.lastUpdatedIndex];
    }
}

// File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol

pragma solidity ^0.5.2;

/**
 * @title Helps contracts guard against reentrancy attacks.
 * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
 * @dev If you mark a function `nonReentrant`, you should also
 * mark it `external`.
 */
contract ReentrancyGuard {
    /// @dev counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter);
    }
}

// File: contracts/meta-oracles/lib/TimeSeriesFeedV2.sol

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
 * @title TimeSeriesFeedV2
 * @author Set Protocol
 *
 * Contract used to track time-series data. This is meant to be inherited, as the calculateNextValue
 * function is unimplemented. New data is appended by calling the poke function, which retrieves the
 * latest value using the calculateNextValue function.
 *
 * CHANGELOG
 * - Built to be inherited by contract that implements new calculateNextValue function
 * - Uses LinkedListLibraryV3
 * - nextEarliestUpdate is passed into constructor
 */
contract TimeSeriesFeedV2 is
    ReentrancyGuard
{
    using SafeMath for uint256;
    using LinkedListLibraryV3 for LinkedListLibraryV3.LinkedList;

    /* ============ State Variables ============ */
    uint256 public updateInterval;
    uint256 public maxDataPoints;
    // Unix Timestamp in seconds of next earliest update time
    uint256 public nextEarliestUpdate;

    LinkedListLibraryV3.LinkedList internal timeSeriesData;

    /* ============ Constructor ============ */

    /*
     * Stores time-series values in a LinkedList and updated using data from a specific data source.
     * Updates must be triggered off chain to be stored in this smart contract.
     *
     * @param  _updateInterval            Cadence at which data is optimally logged. Optimal schedule is based
                                          off deployment timestamp. A certain data point can't be logged before
                                          it's expected timestamp but can be logged after
     * @param  _nextEarliestUpdate        Time the first on-chain price update becomes available
     * @param  _maxDataPoints             The maximum amount of data points the linkedList will hold
     * @param  _seededValues              Array of previous timeseries values to seed initial values in list.
     *                                    The last value should contain the most current piece of data
     */
    constructor(
        uint256 _updateInterval,
        uint256 _nextEarliestUpdate,
        uint256 _maxDataPoints,
        uint256[] memory _seededValues
    )
        public
    {

        // Check that nextEarliestUpdate is greater than current block timestamp
        require(
            _nextEarliestUpdate > block.timestamp,
            "TimeSeriesFeed.constructor: nextEarliestUpdate must be greater than current timestamp."
        );

        // Check that at least one seeded value is passed in
        require(
            _seededValues.length > 0,
            "TimeSeriesFeed.constructor: Must include at least one seeded value."
        );

        // Check that maxDataPoints greater than 0
        require(
            _maxDataPoints > 0,
            "TimeSeriesFeed.constructor: Max data points must be greater than 0."
        );

        // Check that updateInterval greater than 0
        require(
            _updateInterval > 0,
            "TimeSeriesFeed.constructor: Update interval must be greater than 0."
        );

        // Set updateInterval and maxDataPoints
        updateInterval = _updateInterval;
        maxDataPoints = _maxDataPoints;

        // Define upper data size limit for linked list and input initial value
        timeSeriesData.initialize(_maxDataPoints, _seededValues[0]);

        // Cycle through input values array (skipping first value used to initialize LinkedList)
        // and add to timeSeriesData
        for (uint256 i = 1; i < _seededValues.length; i++) {
            timeSeriesData.editList(_seededValues[i]);
        }

        // Set nextEarliestUpdate
        nextEarliestUpdate = _nextEarliestUpdate;
    }

    /* ============ External ============ */

    /*
     * Updates linked list with newest data point by calling the implemented calculateNextValue function
     */
    function poke()
        external
        nonReentrant
    {
        // Make sure block timestamp exceeds nextEarliestUpdate
        require(
            block.timestamp >= nextEarliestUpdate,
            "TimeSeriesFeed.poke: Not enough time elapsed since last update"
        );

        // Get the most current data point
        uint256 newValue = calculateNextValue();

        // Update the nextEarliestUpdate to previous nextEarliestUpdate plus updateInterval
        nextEarliestUpdate = nextEarliestUpdate.add(updateInterval);

        // Update linkedList with new price
        timeSeriesData.editList(newValue);
    }

    /*
     * Query linked list for specified days of data. Will revert if number of days
     * passed exceeds amount of days collected. Will revert if not enough days of
     * data logged.
     *
     * @param  _numDataPoints  Number of datapoints to query
     * @returns                Array of datapoints of length _numDataPoints from most recent to oldest
     */
    function read(
        uint256 _numDataPoints
    )
        external
        view
        returns (uint256[] memory)
    {
        return timeSeriesData.readList(_numDataPoints);
    }


    /* ============ Internal ============ */

    function calculateNextValue()
        internal
        returns (uint256);

}

// File: contracts/meta-oracles/feeds/TwoAssetLinearizedTimeSeriesFeed.sol

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
 * @title TwoAssetLinearizedTimeSeriesFeed
 * @author Set Protocol
 *
 * This TimeSeriesFeed calculates the ratio of base to quote asset and stores it using the
 * inherited TimeSeriesFeedV2 contract. On calculation, if the interpolationThreshold
 * is reached, then it returns a linearly interpolated value.
 */
contract TwoAssetLinearizedTimeSeriesFeed is
    TimeSeriesFeedV2,
    TimeLockUpgradeV2
{
    using SafeMath for uint256;
    using LinkedListLibraryV3 for LinkedListLibraryV3.LinkedList;

    /* ============ State Variables ============ */

    // Amount of time after which read interpolates price result, in seconds
    uint256 public interpolationThreshold;
    string public dataDescription;
    IOracle public baseOracleInstance;
    IOracle public quoteOracleInstance;


    /* ============ Events ============ */

    event LogOracleUpdated(
        address indexed newOracleAddress
    );

    /* ============ Constructor ============ */

    /*
     * Set interpolationThreshold, data description, quote oracle and base oracle and instantiate oracle
     *
     * @param  _updateInterval            Cadence at which data is optimally logged. Optimal schedule is based
                                          off deployment timestamp. A certain data point can't be logged before
                                          it's expected timestamp but can be logged after (for TimeSeriesFeed)
     * @param  _nextEarliestUpdate        Time the first on-chain price update becomes available (for TimeSeriesFeed)
     * @param  _maxDataPoints             The maximum amount of data points the linkedList will hold (for TimeSeriesFeed)
     * @param  _seededValues              Array of previous timeseries values to seed initial values in list.
     *                                    The last value should contain the most current piece of data (for TimeSeriesFeed)
     * @param  _interpolationThreshold    The minimum time in seconds where interpolation is enabled
     * @param  _baseOracleAddress         The address of the base oracle to read current data from
     * @param  _quoteOracleAddress        The address of the quote oracle to read current data from
     * @param  _dataDescription           Description of contract for Etherscan / other applications
     */
    constructor(
        uint256 _updateInterval,
        uint256 _nextEarliestUpdate,
        uint256 _maxDataPoints,
        uint256[] memory _seededValues,
        uint256 _interpolationThreshold,
        IOracle _baseOracleAddress,
        IOracle _quoteOracleAddress,
        string memory _dataDescription
    )
        public
        TimeSeriesFeedV2(
            _updateInterval,
            _nextEarliestUpdate,
            _maxDataPoints,
            _seededValues
        )
    {
        interpolationThreshold = _interpolationThreshold;
        baseOracleInstance = _baseOracleAddress;
        quoteOracleInstance = _quoteOracleAddress;
        dataDescription = _dataDescription;
    }

    /* ============ External ============ */

    /*
     * Change base asset oracle in case current one fails or is deprecated. Only contract
     * owner is allowed to change.
     *
     * @param  _newBaseOracleAddress       Address of new oracle to pull data from
     */
    function changeBaseOracle(
        IOracle _newBaseOracleAddress
    )
        external
        timeLockUpgrade
    {
        // Check to make sure new base oracle address is passed
        require(
            address(_newBaseOracleAddress) != address(baseOracleInstance),
            "TwoAssetLinearizedTimeSeriesFeed.changeBaseOracle: Must give new base oracle address."
        );

        baseOracleInstance = _newBaseOracleAddress;

        emit LogOracleUpdated(address(_newBaseOracleAddress));
    }

    /*
     * Change quote asset oracle in case current one fails or is deprecated. Only contract
     * owner is allowed to change.
     *
     * @param  _newQuoteOracleAddress       Address of new oracle to pull data from
     */
    function changeQuoteOracle(
        IOracle _newQuoteOracleAddress
    )
        external
        timeLockUpgrade
    {
        // Check to make sure new quote oracle address is passed
        require(
            address(_newQuoteOracleAddress) != address(quoteOracleInstance),
            "TwoAssetLinearizedTimeSeriesFeed.changeQuoteOracle: Must give new quote oracle address."
        );

        quoteOracleInstance = _newQuoteOracleAddress;

        emit LogOracleUpdated(address(_newQuoteOracleAddress));
    }

    /* ============ Internal ============ */

    /*
     * Returns the data from the oracle contract. If the current timestamp has surpassed
     * the interpolationThreshold, then the current price is retrieved and interpolated based on
     * the previous value and the time that has elapsed since the intended update value.
     *
     * Returns with newest data point by querying oracle. Is eligible to be
     * called after nextAvailableUpdate timestamp has passed. Because the nextAvailableUpdate occurs
     * on a predetermined cadence based on the time of deployment, delays in calling poke do not propogate
     * throughout the whole dataset and the drift caused by previous poke transactions not being mined
     * exactly on nextAvailableUpdate do not compound as they would if it was required that poke is called
     * an updateInterval amount of time after the last poke.
     *
     * @returns                         Returns the datapoint from the oracle contract
     */
    function calculateNextValue()
        internal
        returns (uint256)
    {
        // Get current base oracle value
        uint256 baseOracleValue = baseOracleInstance.read();

        // Get current quote oracle value
        uint256 quoteOracleValue = quoteOracleInstance.read();

        // Calculate the current base / quote asset ratio with 10 ** 18 precision
        uint256 currentRatioValue = baseOracleValue.mul(10 ** 18).div(quoteOracleValue);

        // Calculate how much time has passed from last expected update
        uint256 timeFromExpectedUpdate = block.timestamp.sub(nextEarliestUpdate);

        // If block timeFromExpectedUpdate is greater than interpolationThreshold we linearize
        // the current price to try to reduce error
        if (timeFromExpectedUpdate < interpolationThreshold) {
            return currentRatioValue;
        } else {
            // Get the previous value
            uint256 previousRatioValue = timeSeriesData.getLatestValue();

            return DataSourceLinearInterpolationLibrary.interpolateDelayedPriceUpdate(
                currentRatioValue,
                updateInterval,
                timeFromExpectedUpdate,
                previousRatioValue
            );
        }
    }
}