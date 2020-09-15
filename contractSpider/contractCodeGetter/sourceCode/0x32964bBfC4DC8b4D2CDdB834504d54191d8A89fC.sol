/**
 *Submitted for verification at Etherscan.io on 2020-06-05
*/

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
 * @title IERC20
 * @author Set Protocol
 *
 * Interface for using ERC20 Tokens. This interface is needed to interact with tokens that are not
 * fully ERC20 compliant and return something other than true on successful transfers.
 */
interface IERC20 {
    function balanceOf(
        address _owner
    )
        external
        view
        returns (uint256);

    function allowance(
        address _owner,
        address _spender
    )
        external
        view
        returns (uint256);

    function transfer(
        address _to,
        uint256 _quantity
    )
        external;

    function transferFrom(
        address _from,
        address _to,
        uint256 _quantity
    )
        external;

    function approve(
        address _spender,
        uint256 _quantity
    )
        external
        returns (bool);

    function totalSupply()
        external
        returns (uint256);
}

// File: contracts/viewer/lib/ERC20Viewer.sol

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
 * @title ERC20Viewer
 * @author Set Protocol
 *
 * Interfaces for fetching multiple ERC20 state in a single read
 */
contract ERC20Viewer {

    /*
     * Fetches multiple balances for passed in array of ERC20 contract addresses for an owner
     *
     * @param  _tokenAddresses    Addresses of ERC20 contracts to check balance for
     * @param  _owner             Address to check balance of _tokenAddresses for
     * @return  uint256[]         Array of balances for each ERC20 contract passed in
     */
    function batchFetchBalancesOf(
        address[] calldata _tokenAddresses,
        address _owner
    )
        external
        returns (uint256[] memory)
    {
        // Cache length of addresses to fetch balances for
        uint256 _addressesCount = _tokenAddresses.length;

        // Instantiate output array in memory
        uint256[] memory balances = new uint256[](_addressesCount);

        // Cycle through contract addresses array and fetching the balance of each for the owner
        for (uint256 i = 0; i < _addressesCount; i++) {
            balances[i] = IERC20(_tokenAddresses[i]).balanceOf(_owner);
        }

        return balances;
    }

    /*
     * Fetches token balances for each tokenAddress, tokenOwner pair
     *
     * @param  _tokenAddresses    Addresses of ERC20 contracts to check balance for
     * @param  _tokenOwners       Addresses of users sequential to tokenAddress to fetch balance for
     * @return  uint256[]         Array of balances for each ERC20 contract passed in
     */
    function batchFetchUsersBalances(
        address[] calldata _tokenAddresses,
        address[] calldata _tokenOwners
    )
        external
        returns (uint256[] memory)
    {
        // Cache length of addresses to fetch balances for
        uint256 _addressesCount = _tokenAddresses.length;

        // Instantiate output array in memory
        uint256[] memory balances = new uint256[](_addressesCount);

        // Cycle through contract addresses array and fetching the balance of each for the owner
        for (uint256 i = 0; i < _addressesCount; i++) {
            balances[i] = IERC20(_tokenAddresses[i]).balanceOf(_tokenOwners[i]);
        }

        return balances;
    }

    /*
     * Fetches multiple supplies for passed in array of ERC20 contract addresses
     *
     * @param  _tokenAddresses    Addresses of ERC20 contracts to check supply for
     * @return  uint256[]         Array of supplies for each ERC20 contract passed in
     */
    function batchFetchSupplies(
        address[] calldata _tokenAddresses
    )
        external
        returns (uint256[] memory)
    {
        // Cache length of addresses to fetch supplies for
        uint256 _addressesCount = _tokenAddresses.length;

        // Instantiate output array in memory
        uint256[] memory supplies = new uint256[](_addressesCount);

        // Cycle through contract addresses array and fetching the supply of each
        for (uint256 i = 0; i < _addressesCount; i++) {
            supplies[i] = IERC20(_tokenAddresses[i]).totalSupply();
        }

        return supplies;
    }
}

// File: set-protocol-strategies/contracts/managers/interfaces/IAssetPairManager.sol

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
 * @title IAssetPairManager
 * @author Set Protocol
 *
 * Interface for interacting with AssetPairManager contracts
 */
interface IAssetPairManager {
    function signalConfirmationMinTime() external view returns (uint256);
    function signalConfirmationMaxTime() external view returns (uint256);
    function recentInitialProposeTimestamp() external view returns (uint256);
}

// File: set-protocol-strategies/contracts/managers/interfaces/IMACOStrategyManagerV2.sol

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
 * @title IMACOStrategyManagerV2
 * @author Set Protocol
 *
 * Interface for interacting with MACOStrategyManagerV2 contracts
 */
interface IMACOStrategyManagerV2 {
    function crossoverConfirmationMinTime() external view returns (uint256);
    function crossoverConfirmationMaxTime() external view returns (uint256);
    function lastCrossoverConfirmationTimestamp() external view returns (uint256);
}

// File: contracts/viewer/lib/ManagerViewer.sol

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
 * @title ManagerViewer
 * @author Set Protocol
 *
 * Interfaces for fetching multiple managers state in a single read
 */
contract ManagerViewer {

    function batchFetchMACOV2CrossoverTimestamp(
        IMACOStrategyManagerV2[] calldata _managers
    )
        external
        view
        returns (uint256[] memory)
    {
        // Cache length of addresses to fetch owner for
        uint256 _managerCount = _managers.length;

        // Instantiate output array in memory
        uint256[] memory timestamps = new uint256[](_managerCount);

        for (uint256 i = 0; i < _managerCount; i++) {
            IMACOStrategyManagerV2 manager = _managers[i];

            timestamps[i] = manager.lastCrossoverConfirmationTimestamp();
        }

        return timestamps;
    }

    function batchFetchAssetPairCrossoverTimestamp(
        IAssetPairManager[] calldata _managers
    )
        external
        view
        returns (uint256[] memory)
    {
        // Cache length of addresses to fetch owner for
        uint256 _managerCount = _managers.length;

        // Instantiate output array in memory
        uint256[] memory timestamps = new uint256[](_managerCount);

        for (uint256 i = 0; i < _managerCount; i++) {
            IAssetPairManager manager = _managers[i];

            timestamps[i] = manager.recentInitialProposeTimestamp();
        }

        return timestamps;
    }

}

// File: set-protocol-oracles/contracts/meta-oracles/interfaces/IOracle.sol

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

// File: contracts/viewer/lib/OracleViewer.sol

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
 * @title OracleViewer
 * @author Set Protocol
 *
 * Contract for fetching oracle state
 */
contract OracleViewer {
    /*
     * Fetches RebalancingSetToken liquidator for an array of RebalancingSetToken instances
     *
     * @param  _rebalancingSetTokens[]       RebalancingSetToken contract instances
     * @return address[]                     Current liquidator being used by RebalancingSetToken
     */
    function batchFetchOraclePrices(
        IOracle[] calldata _oracles
    )
        external
        returns (uint256[] memory)
    {
        // Cache length of addresses to fetch states for
        uint256 _addressesCount = _oracles.length;

        // Instantiate output array in memory
        uint256[] memory prices = new uint256[](_addressesCount);

        // Cycles through contract addresses array and fetches the current price of each oracle
        for (uint256 i = 0; i < _addressesCount; i++) {
            prices[i] = _oracles[i].read();
        }

        return prices;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol

pragma solidity ^0.5.2;


/**
 * @title ERC20Detailed token
 * @dev The decimals are only for visualization purposes.
 * All the operations are done using the smallest and indivisible token unit,
 * just as on Ethereum all the operations are done in wei.
 */
contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     * @return the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @return the symbol of the token.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @return the number of decimals of the token.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

// File: set-protocol-contracts/contracts/core/interfaces/ISetToken.sol

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
 * @title ISetToken
 * @author Set Protocol
 *
 * The ISetToken interface provides a light-weight, structured way to interact with the
 * SetToken contract from another contract.
 */
interface ISetToken {

    /* ============ External Functions ============ */

    /*
     * Get natural unit of Set
     *
     * @return  uint256       Natural unit of Set
     */
    function naturalUnit()
        external
        view
        returns (uint256);

    /*
     * Get addresses of all components in the Set
     *
     * @return  componentAddresses       Array of component tokens
     */
    function getComponents()
        external
        view
        returns (address[] memory);

    /*
     * Get units of all tokens in Set
     *
     * @return  units       Array of component units
     */
    function getUnits()
        external
        view
        returns (uint256[] memory);

    /*
     * Checks to make sure token is component of Set
     *
     * @param  _tokenAddress     Address of token being checked
     * @return  bool             True if token is component of Set
     */
    function tokenIsComponent(
        address _tokenAddress
    )
        external
        view
        returns (bool);

    /*
     * Mint set token for given address.
     * Can only be called by authorized contracts.
     *
     * @param  _issuer      The address of the issuing account
     * @param  _quantity    The number of sets to attribute to issuer
     */
    function mint(
        address _issuer,
        uint256 _quantity
    )
        external;

    /*
     * Burn set token for given address
     * Can only be called by authorized contracts
     *
     * @param  _from        The address of the redeeming account
     * @param  _quantity    The number of sets to burn from redeemer
     */
    function burn(
        address _from,
        uint256 _quantity
    )
        external;

    /**
    * Transfer token for a specified address
    *
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(
        address to,
        uint256 value
    )
        external;
}

// File: set-protocol-contracts/contracts/core/lib/RebalancingLibrary.sol

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
 * @title RebalancingLibrary
 * @author Set Protocol
 *
 * The RebalancingLibrary contains functions for facilitating the rebalancing process for
 * Rebalancing Set Tokens. Removes the old calculation functions
 *
 */
library RebalancingLibrary {

    /* ============ Enums ============ */

    enum State { Default, Proposal, Rebalance, Drawdown }

    /* ============ Structs ============ */

    struct AuctionPriceParameters {
        uint256 auctionStartTime;
        uint256 auctionTimeToPivot;
        uint256 auctionStartPrice;
        uint256 auctionPivotPrice;
    }

    struct BiddingParameters {
        uint256 minimumBid;
        uint256 remainingCurrentSets;
        uint256[] combinedCurrentUnits;
        uint256[] combinedNextSetUnits;
        address[] combinedTokenArray;
    }
}

// File: set-protocol-contracts/contracts/core/interfaces/IRebalancingSetToken.sol

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
 * @title IRebalancingSetToken
 * @author Set Protocol
 *
 * The IRebalancingSetToken interface provides a light-weight, structured way to interact with the
 * RebalancingSetToken contract from another contract.
 */

interface IRebalancingSetToken {

    /*
     * Get the auction library contract used for the current rebalance
     *
     * @return address    Address of auction library used in the upcoming auction
     */
    function auctionLibrary()
        external
        view
        returns (address);

    /*
     * Get totalSupply of Rebalancing Set
     *
     * @return  totalSupply
     */
    function totalSupply()
        external
        view
        returns (uint256);

    /*
     * Get proposalTimeStamp of Rebalancing Set
     *
     * @return  proposalTimeStamp
     */
    function proposalStartTime()
        external
        view
        returns (uint256);

    /*
     * Get lastRebalanceTimestamp of Rebalancing Set
     *
     * @return  lastRebalanceTimestamp
     */
    function lastRebalanceTimestamp()
        external
        view
        returns (uint256);

    /*
     * Get rebalanceInterval of Rebalancing Set
     *
     * @return  rebalanceInterval
     */
    function rebalanceInterval()
        external
        view
        returns (uint256);

    /*
     * Get rebalanceState of Rebalancing Set
     *
     * @return RebalancingLibrary.State    Current rebalance state of the RebalancingSetToken
     */
    function rebalanceState()
        external
        view
        returns (RebalancingLibrary.State);

    /*
     * Get the starting amount of current SetToken for the current auction
     *
     * @return  rebalanceState
     */
    function startingCurrentSetAmount()
        external
        view
        returns (uint256);

    /**
     * Gets the balance of the specified address.
     *
     * @param owner      The address to query the balance of.
     * @return           A uint256 representing the amount owned by the passed address.
     */
    function balanceOf(
        address owner
    )
        external
        view
        returns (uint256);

    /**
     * Function used to set the terms of the next rebalance and start the proposal period
     *
     * @param _nextSet                      The Set to rebalance into
     * @param _auctionLibrary               The library used to calculate the Dutch Auction price
     * @param _auctionTimeToPivot           The amount of time for the auction to go ffrom start to pivot price
     * @param _auctionStartPrice            The price to start the auction at
     * @param _auctionPivotPrice            The price at which the price curve switches from linear to exponential
     */
    function propose(
        address _nextSet,
        address _auctionLibrary,
        uint256 _auctionTimeToPivot,
        uint256 _auctionStartPrice,
        uint256 _auctionPivotPrice
    )
        external;

    /*
     * Get natural unit of Set
     *
     * @return  uint256       Natural unit of Set
     */
    function naturalUnit()
        external
        view
        returns (uint256);

    /**
     * Returns the address of the current base SetToken with the current allocation
     *
     * @return           A address representing the base SetToken
     */
    function currentSet()
        external
        view
        returns (address);

    /**
     * Returns the address of the next base SetToken with the post auction allocation
     *
     * @return  address    Address representing the base SetToken
     */
    function nextSet()
        external
        view
        returns (address);

    /*
     * Get the unit shares of the rebalancing Set
     *
     * @return  unitShares       Unit Shares of the base Set
     */
    function unitShares()
        external
        view
        returns (uint256);

    /*
     * Burn set token for given address.
     * Can only be called by authorized contracts.
     *
     * @param  _from        The address of the redeeming account
     * @param  _quantity    The number of sets to burn from redeemer
     */
    function burn(
        address _from,
        uint256 _quantity
    )
        external;

    /*
     * Place bid during rebalance auction. Can only be called by Core.
     *
     * @param _quantity                 The amount of currentSet to be rebalanced
     * @return combinedTokenArray       Array of token addresses invovled in rebalancing
     * @return inflowUnitArray          Array of amount of tokens inserted into system in bid
     * @return outflowUnitArray         Array of amount of tokens taken out of system in bid
     */
    function placeBid(
        uint256 _quantity
    )
        external
        returns (address[] memory, uint256[] memory, uint256[] memory);

    /*
     * Get combinedTokenArray of Rebalancing Set
     *
     * @return  combinedTokenArray
     */
    function getCombinedTokenArrayLength()
        external
        view
        returns (uint256);

    /*
     * Get combinedTokenArray of Rebalancing Set
     *
     * @return  combinedTokenArray
     */
    function getCombinedTokenArray()
        external
        view
        returns (address[] memory);

    /*
     * Get failedAuctionWithdrawComponents of Rebalancing Set
     *
     * @return  failedAuctionWithdrawComponents
     */
    function getFailedAuctionWithdrawComponents()
        external
        view
        returns (address[] memory);

    /*
     * Get auctionPriceParameters for current auction
     *
     * @return uint256[4]    AuctionPriceParameters for current rebalance auction
     */
    function getAuctionPriceParameters()
        external
        view
        returns (uint256[] memory);

    /*
     * Get biddingParameters for current auction
     *
     * @return uint256[2]    BiddingParameters for current rebalance auction
     */
    function getBiddingParameters()
        external
        view
        returns (uint256[] memory);

    /*
     * Get token inflows and outflows required for bid. Also the amount of Rebalancing
     * Sets that would be generated.
     *
     * @param _quantity               The amount of currentSet to be rebalanced
     * @return inflowUnitArray        Array of amount of tokens inserted into system in bid
     * @return outflowUnitArray       Array of amount of tokens taken out of system in bid
     */
    function getBidPrice(
        uint256 _quantity
    )
        external
        view
        returns (uint256[] memory, uint256[] memory);

}

// File: set-protocol-contracts/contracts/core/lib/Rebalance.sol

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
 * @title Rebalance
 * @author Set Protocol
 *
 * Types and functions for Rebalance-related data.
 */
library Rebalance {

    struct TokenFlow {
        address[] addresses;
        uint256[] inflow;
        uint256[] outflow;
    }

    function composeTokenFlow(
        address[] memory _addresses,
        uint256[] memory _inflow,
        uint256[] memory _outflow
    )
        internal
        pure
        returns(TokenFlow memory)
    {
        return TokenFlow({addresses: _addresses, inflow: _inflow, outflow: _outflow });
    }

    function decomposeTokenFlow(TokenFlow memory _tokenFlow)
        internal
        pure
        returns (address[] memory, uint256[] memory, uint256[] memory)
    {
        return (_tokenFlow.addresses, _tokenFlow.inflow, _tokenFlow.outflow);
    }

    function decomposeTokenFlowToBidPrice(TokenFlow memory _tokenFlow)
        internal
        pure
        returns (uint256[] memory, uint256[] memory)
    {
        return (_tokenFlow.inflow, _tokenFlow.outflow);
    }

    /**
     * Get token flows array of addresses, inflows and outflows
     *
     * @param    _rebalancingSetToken   The rebalancing Set Token instance
     * @param    _quantity              The amount of currentSet to be rebalanced
     * @return   combinedTokenArray     Array of token addresses
     * @return   inflowArray            Array of amount of tokens inserted into system in bid
     * @return   outflowArray           Array of amount of tokens returned from system in bid
     */
    function getTokenFlows(
        IRebalancingSetToken _rebalancingSetToken,
        uint256 _quantity
    )
        internal
        view
        returns (address[] memory, uint256[] memory, uint256[] memory)
    {
        // Get token addresses
        address[] memory combinedTokenArray = _rebalancingSetToken.getCombinedTokenArray();

        // Get inflow and outflow arrays for the given bid quantity
        (
            uint256[] memory inflowArray,
            uint256[] memory outflowArray
        ) = _rebalancingSetToken.getBidPrice(_quantity);

        return (combinedTokenArray, inflowArray, outflowArray);
    }
}

// File: set-protocol-contracts/contracts/core/interfaces/ILiquidator.sol

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
 * @title ILiquidator
 * @author Set Protocol
 *
 */
interface ILiquidator {

    /* ============ External Functions ============ */

    function startRebalance(
        ISetToken _currentSet,
        ISetToken _nextSet,
        uint256 _startingCurrentSetQuantity,
        bytes calldata _liquidatorData
    )
        external;

    function getBidPrice(
        address _set,
        uint256 _quantity
    )
        external
        view
        returns (Rebalance.TokenFlow memory);

    function placeBid(
        uint256 _quantity
    )
        external
        returns (Rebalance.TokenFlow memory);


    function settleRebalance()
        external;

    function endFailedRebalance() external;

    // ----------------------------------------------------------------------
    // Auction Price
    // ----------------------------------------------------------------------

    function auctionPriceParameters(address _set)
        external
        view
        returns (RebalancingLibrary.AuctionPriceParameters memory);

    // ----------------------------------------------------------------------
    // Auction
    // ----------------------------------------------------------------------

    function hasRebalanceFailed(address _set) external view returns (bool);
    function minimumBid(address _set) external view returns (uint256);
    function startingCurrentSets(address _set) external view returns (uint256);
    function remainingCurrentSets(address _set) external view returns (uint256);
    function getCombinedCurrentSetUnits(address _set) external view returns (uint256[] memory);
    function getCombinedNextSetUnits(address _set) external view returns (uint256[] memory);
    function getCombinedTokenArray(address _set) external view returns (address[] memory);
}

// File: set-protocol-contracts/contracts/core/fee-calculators/lib/PerformanceFeeLibrary.sol

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
 * @title PerformanceFeeLibrary
 * @author Set Protocol
 *
 * The PerformanceFeeLibrary contains struct definition for feeState so it can
 * be used elsewhere.
 */
library PerformanceFeeLibrary {

    /* ============ Structs ============ */

    struct FeeState {
        uint256 profitFeePeriod;                // Time required between accruing profit fees
        uint256 highWatermarkResetPeriod;       // Time required after last profit fee to reset high watermark
        uint256 profitFeePercentage;            // Percent of profits that accrue to manager
        uint256 streamingFeePercentage;         // Percent of Set that accrues to manager each year
        uint256 highWatermark;                  // Value of Set at last profit fee accrual
        uint256 lastProfitFeeTimestamp;         // Timestamp last profit fee was accrued
        uint256 lastStreamingFeeTimestamp;      // Timestamp last streaming fee was accrued
    }
}

// File: set-protocol-contracts/contracts/core/interfaces/IPerformanceFeeCalculator.sol

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
pragma experimental ABIEncoderV2;


/**
 * @title IPerformanceFeeCalculator
 * @author Set Protocol
 *
 * Interface for accessing state on PerformanceFeeCalculator (function calls defined in IFeeCalculator)
 */
interface IPerformanceFeeCalculator {

    /* ============ External Functions ============ */

    function feeState(
        address _rebalancingSetToken
    )
        external
        view
        returns (PerformanceFeeLibrary.FeeState memory);

    function getCalculatedFees(
        address _setAddress
    )
        external
        view
        returns (uint256, uint256);
}

// File: set-protocol-contracts/contracts/core/interfaces/IFeeCalculator.sol

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
 * @title IFeeCalculator
 * @author Set Protocol
 *
 */
interface IFeeCalculator {

    /* ============ External Functions ============ */

    function initialize(
        bytes calldata _feeCalculatorData
    )
        external;

    function getFee()
        external
        view
        returns(uint256);

    function updateAndGetFee()
        external
        returns(uint256);

    function adjustFee(
        bytes calldata _newFeeData
    )
        external;
}

// File: set-protocol-contracts/contracts/core/interfaces/IRebalancingSetTokenV2.sol

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
 * @title IRebalancingSetTokenV2
 * @author Set Protocol
 *
 * The IRebalancingSetTokenV2 interface provides a light-weight, structured way to interact with the
 * RebalancingSetTokenV2 contract from another contract.
 */

interface IRebalancingSetTokenV2 {

    /*
     * Get totalSupply of Rebalancing Set
     *
     * @return  totalSupply
     */
    function totalSupply()
        external
        view
        returns (uint256);

    /**
     * Returns liquidator instance
     *
     * @return  ILiquidator    Liquidator instance
     */
    function liquidator()
        external
        view
        returns (ILiquidator);

    /*
     * Get lastRebalanceTimestamp of Rebalancing Set
     *
     * @return  lastRebalanceTimestamp
     */
    function lastRebalanceTimestamp()
        external
        view
        returns (uint256);

    /*
     * Get rebalanceStartTime of Rebalancing Set
     *
     * @return  rebalanceStartTime
     */
    function rebalanceStartTime()
        external
        view
        returns (uint256);

    /*
     * Get startingCurrentSets of RebalancingSetToken
     *
     * @return  startingCurrentSets
     */
    function startingCurrentSetAmount()
        external
        view
        returns (uint256);

    /*
     * Get rebalanceInterval of Rebalancing Set
     *
     * @return  rebalanceInterval
     */
    function rebalanceInterval()
        external
        view
        returns (uint256);

    /*
     * Get array returning [startTime, timeToPivot, startPrice, endPrice]
     *
     * @return  AuctionPriceParameters
     */
    function getAuctionPriceParameters() external view returns (uint256[] memory);

    /*
     * Get array returning [minimumBid, remainingCurrentSets]
     *
     * @return  BiddingParameters
     */
    function getBiddingParameters() external view returns (uint256[] memory);

    /*
     * Get rebalanceState of Rebalancing Set
     *
     * @return RebalancingLibrary.State    Current rebalance state of the RebalancingSetTokenV2
     */
    function rebalanceState()
        external
        view
        returns (RebalancingLibrary.State);

    /**
     * Gets the balance of the specified address.
     *
     * @param owner      The address to query the balance of.
     * @return           A uint256 representing the amount owned by the passed address.
     */
    function balanceOf(
        address owner
    )
        external
        view
        returns (uint256);

    /*
     * Get manager of Rebalancing Set
     *
     * @return  manager
     */
    function manager()
        external
        view
        returns (address);

    /*
     * Get feeRecipient of Rebalancing Set
     *
     * @return  feeRecipient
     */
    function feeRecipient()
        external
        view
        returns (address);

    /*
     * Get entryFee of Rebalancing Set
     *
     * @return  entryFee
     */
    function entryFee()
        external
        view
        returns (uint256);

    /*
     * Retrieves the current expected fee from the fee calculator
     * Value is returned as a scale decimal figure.
     */
    function rebalanceFee()
        external
        view
        returns (uint256);

    /*
     * Get calculator contract used to compute rebalance fees
     *
     * @return  rebalanceFeeCalculator
     */
    function rebalanceFeeCalculator()
        external
        view
        returns (IFeeCalculator);

    /*
     * Initializes the RebalancingSetToken. Typically called by the Factory during creation
     */
    function initialize(
        bytes calldata _rebalanceFeeCalldata
    )
        external;

    /*
     * Set new liquidator address. Only whitelisted addresses are valid.
     */
    function setLiquidator(
        ILiquidator _newLiquidator
    )
        external;

    /*
     * Set new fee recipient address.
     */
    function setFeeRecipient(
        address _newFeeRecipient
    )
        external;

    /*
     * Set new fee entry fee.
     */
    function setEntryFee(
        uint256 _newEntryFee
    )
        external;

    /*
     * Initiates the rebalance in coordination with the Liquidator contract.
     * In this step, we redeem the currentSet and pass relevant information
     * to the liquidator.
     *
     * @param _nextSet                      The Set to rebalance into
     * @param _liquidatorData               Bytecode formatted data with liquidator-specific arguments
     *
     * Can only be called if the rebalance interval has elapsed.
     * Can only be called by manager.
     */
    function startRebalance(
        address _nextSet,
        bytes calldata _liquidatorData

    )
        external;

    /*
     * After a successful rebalance, the new Set is issued. If there is a rebalance fee,
     * the fee is paid via inflation of the Rebalancing Set to the feeRecipient.
     * Full issuance functionality is now returned to set owners.
     *
     * Anyone can call this function.
     */
    function settleRebalance()
        external;

    /*
     * Get natural unit of Set
     *
     * @return  uint256       Natural unit of Set
     */
    function naturalUnit()
        external
        view
        returns (uint256);

    /**
     * Returns the address of the current base SetToken with the current allocation
     *
     * @return           A address representing the base SetToken
     */
    function currentSet()
        external
        view
        returns (ISetToken);

    /**
     * Returns the address of the next base SetToken with the post auction allocation
     *
     * @return  address    Address representing the base SetToken
     */
    function nextSet()
        external
        view
        returns (ISetToken);

    /*
     * Get the unit shares of the rebalancing Set
     *
     * @return  unitShares       Unit Shares of the base Set
     */
    function unitShares()
        external
        view
        returns (uint256);

    /*
     * Place bid during rebalance auction. Can only be called by Core.
     *
     * @param _quantity                 The amount of currentSet to be rebalanced
     * @return combinedTokenArray       Array of token addresses invovled in rebalancing
     * @return inflowUnitArray          Array of amount of tokens inserted into system in bid
     * @return outflowUnitArray         Array of amount of tokens taken out of system in bid
     */
    function placeBid(
        uint256 _quantity
    )
        external
        returns (address[] memory, uint256[] memory, uint256[] memory);

    /*
     * Get token inflows and outflows required for bid. Also the amount of Rebalancing
     * Sets that would be generated.
     *
     * @param _quantity               The amount of currentSet to be rebalanced
     * @return inflowUnitArray        Array of amount of tokens inserted into system in bid
     * @return outflowUnitArray       Array of amount of tokens taken out of system in bid
     */
    function getBidPrice(
        uint256 _quantity
    )
        external
        view
        returns (uint256[] memory, uint256[] memory);

    /*
     * Get name of Rebalancing Set
     *
     * @return  name
     */
    function name()
        external
        view
        returns (string memory);

    /*
     * Get symbol of Rebalancing Set
     *
     * @return  symbol
     */
    function symbol()
        external
        view
        returns (string memory);
}

// File: set-protocol-contracts/contracts/core/interfaces/IRebalancingSetTokenV3.sol

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
 * @title IRebalancingSetTokenV2
 * @author Set Protocol
 *
 * The IRebalancingSetTokenV3 interface provides a light-weight, structured way to interact with the
 * RebalancingSetTokenV3 contract from another contract.
 */

interface IRebalancingSetTokenV3 {

    /*
     * Get totalSupply of Rebalancing Set
     *
     * @return  totalSupply
     */
    function totalSupply()
        external
        view
        returns (uint256);

    /**
     * Returns liquidator instance
     *
     * @return  ILiquidator    Liquidator instance
     */
    function liquidator()
        external
        view
        returns (ILiquidator);

    /*
     * Get lastRebalanceTimestamp of Rebalancing Set
     *
     * @return  lastRebalanceTimestamp
     */
    function lastRebalanceTimestamp()
        external
        view
        returns (uint256);

    /*
     * Get rebalanceStartTime of Rebalancing Set
     *
     * @return  rebalanceStartTime
     */
    function rebalanceStartTime()
        external
        view
        returns (uint256);

    /*
     * Get startingCurrentSets of RebalancingSetToken
     *
     * @return  startingCurrentSets
     */
    function startingCurrentSetAmount()
        external
        view
        returns (uint256);

    /*
     * Get rebalanceInterval of Rebalancing Set
     *
     * @return  rebalanceInterval
     */
    function rebalanceInterval()
        external
        view
        returns (uint256);

    /*
     * Get failAuctionPeriod of Rebalancing Set
     *
     * @return  failAuctionPeriod
     */
    function rebalanceFailPeriod()
        external
        view
        returns (uint256);

    /*
     * Get array returning [startTime, timeToPivot, startPrice, endPrice]
     *
     * @return  AuctionPriceParameters
     */
    function getAuctionPriceParameters() external view returns (uint256[] memory);

    /*
     * Get array returning [minimumBid, remainingCurrentSets]
     *
     * @return  BiddingParameters
     */
    function getBiddingParameters() external view returns (uint256[] memory);

    /*
     * Get rebalanceState of Rebalancing Set
     *
     * @return RebalancingLibrary.State    Current rebalance state of the RebalancingSetTokenV3
     */
    function rebalanceState()
        external
        view
        returns (RebalancingLibrary.State);

    /**
     * Gets the balance of the specified address.
     *
     * @param owner      The address to query the balance of.
     * @return           A uint256 representing the amount owned by the passed address.
     */
    function balanceOf(
        address owner
    )
        external
        view
        returns (uint256);

    /*
     * Get manager of Rebalancing Set
     *
     * @return  manager
     */
    function manager()
        external
        view
        returns (address);

    /*
     * Get feeRecipient of Rebalancing Set
     *
     * @return  feeRecipient
     */
    function feeRecipient()
        external
        view
        returns (address);

    /*
     * Get entryFee of Rebalancing Set
     *
     * @return  entryFee
     */
    function entryFee()
        external
        view
        returns (uint256);

    /*
     * Retrieves the current expected fee from the fee calculator
     * Value is returned as a scale decimal figure.
     */
    function rebalanceFee()
        external
        view
        returns (uint256);

    /*
     * Get calculator contract used to compute rebalance fees
     *
     * @return  rebalanceFeeCalculator
     */
    function rebalanceFeeCalculator()
        external
        view
        returns (IFeeCalculator);

    /*
     * Initializes the RebalancingSetToken. Typically called by the Factory during creation
     */
    function initialize(
        bytes calldata _rebalanceFeeCalldata
    )
        external;

    /*
     * Set new liquidator address. Only whitelisted addresses are valid.
     */
    function setLiquidator(
        ILiquidator _newLiquidator
    )
        external;

    /*
     * Set new fee recipient address.
     */
    function setFeeRecipient(
        address _newFeeRecipient
    )
        external;

    /*
     * Set new fee entry fee.
     */
    function setEntryFee(
        uint256 _newEntryFee
    )
        external;

    /*
     * Initiates the rebalance in coordination with the Liquidator contract.
     * In this step, we redeem the currentSet and pass relevant information
     * to the liquidator.
     *
     * @param _nextSet                      The Set to rebalance into
     * @param _liquidatorData               Bytecode formatted data with liquidator-specific arguments
     *
     * Can only be called if the rebalance interval has elapsed.
     * Can only be called by manager.
     */
    function startRebalance(
        address _nextSet,
        bytes calldata _liquidatorData

    )
        external;

    /*
     * After a successful rebalance, the new Set is issued. If there is a rebalance fee,
     * the fee is paid via inflation of the Rebalancing Set to the feeRecipient.
     * Full issuance functionality is now returned to set owners.
     *
     * Anyone can call this function.
     */
    function settleRebalance()
        external;

    /*
     * During the Default stage, the incentive / rebalance Fee can be triggered. This will
     * retrieve the current inflation fee from the fee calulator and mint the according
     * inflation to the feeRecipient. The unit shares is then adjusted based on the new
     * supply.
     *
     * Anyone can call this function.
     */
    function actualizeFee()
        external;

    /*
     * Validate then set new streaming fee.
     *
     * @param  _newFeeData       Fee type and new streaming fee encoded in bytes
     */
    function adjustFee(
        bytes calldata _newFeeData
    )
        external;

    /*
     * Get natural unit of Set
     *
     * @return  uint256       Natural unit of Set
     */
    function naturalUnit()
        external
        view
        returns (uint256);

    /**
     * Returns the address of the current base SetToken with the current allocation
     *
     * @return           A address representing the base SetToken
     */
    function currentSet()
        external
        view
        returns (ISetToken);

    /**
     * Returns the address of the next base SetToken with the post auction allocation
     *
     * @return  address    Address representing the base SetToken
     */
    function nextSet()
        external
        view
        returns (ISetToken);

    /*
     * Get the unit shares of the rebalancing Set
     *
     * @return  unitShares       Unit Shares of the base Set
     */
    function unitShares()
        external
        view
        returns (uint256);

    /*
     * Place bid during rebalance auction. Can only be called by Core.
     *
     * @param _quantity                 The amount of currentSet to be rebalanced
     * @return combinedTokenArray       Array of token addresses invovled in rebalancing
     * @return inflowUnitArray          Array of amount of tokens inserted into system in bid
     * @return outflowUnitArray         Array of amount of tokens taken out of system in bid
     */
    function placeBid(
        uint256 _quantity
    )
        external
        returns (address[] memory, uint256[] memory, uint256[] memory);

    /*
     * Get token inflows and outflows required for bid. Also the amount of Rebalancing
     * Sets that would be generated.
     *
     * @param _quantity               The amount of currentSet to be rebalanced
     * @return inflowUnitArray        Array of amount of tokens inserted into system in bid
     * @return outflowUnitArray       Array of amount of tokens taken out of system in bid
     */
    function getBidPrice(
        uint256 _quantity
    )
        external
        view
        returns (uint256[] memory, uint256[] memory);

    /*
     * Get name of Rebalancing Set
     *
     * @return  name
     */
    function name()
        external
        view
        returns (string memory);

    /*
     * Get symbol of Rebalancing Set
     *
     * @return  symbol
     */
    function symbol()
        external
        view
        returns (string memory);
}

// File: set-protocol-contracts/contracts/core/interfaces/ITWAPAuctionGetters.sol

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
 * @title ITWAPAuctionGetters
 * @author Set Protocol
 *
 * Interface for retrieving TWAPState struct
 */
interface ITWAPAuctionGetters {

    function getOrderSize(address _set) external view returns (uint256);

    function getOrderRemaining(address _set) external view returns (uint256);

    function getTotalSetsRemaining(address _set) external view returns (uint256);

    function getChunkSize(address _set) external view returns (uint256);

    function getChunkAuctionPeriod(address _set) external view returns (uint256);

    function getLastChunkAuctionEnd(address _set) external view returns (uint256);
}

// File: contracts/viewer/lib/RebalancingSetTokenViewer.sol

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
 * @title RebalancingSetTokenViewer
 * @author Set Protocol
 *
 * Interfaces for fetching multiple RebalancingSetToken state in a single read
 */
contract RebalancingSetTokenViewer {

    struct CollateralAndState {
        address collateralSet;
        RebalancingLibrary.State state;
    }

    struct CollateralSetInfo {
        address[] components;
        uint256[] units;
        uint256 naturalUnit;
        string name;
        string symbol;
    }

    struct RebalancingSetRebalanceInfo {
        uint256 rebalanceStartTime;
        uint256 timeToPivot;
        uint256 startPrice;
        uint256 endPrice;
        uint256 startingCurrentSets;
        uint256 remainingCurrentSets;
        uint256 minimumBid;
        RebalancingLibrary.State rebalanceState;
        ISetToken nextSet;
        ILiquidator liquidator;
    }

    struct RebalancingSetCreateInfo {
        address manager;
        address feeRecipient;
        ISetToken currentSet;
        ILiquidator liquidator;
        uint256 unitShares;
        uint256 naturalUnit;
        uint256 rebalanceInterval;
        uint256 entryFee;
        uint256 rebalanceFee;
        uint256 lastRebalanceTimestamp;
        RebalancingLibrary.State rebalanceState;
        string name;
        string symbol;
    }

    struct TWAPRebalanceInfo {
        uint256 rebalanceStartTime;
        uint256 timeToPivot;
        uint256 startPrice;
        uint256 endPrice;
        uint256 startingCurrentSets;
        uint256 remainingCurrentSets;
        uint256 minimumBid;
        RebalancingLibrary.State rebalanceState;
        ISetToken nextSet;
        ILiquidator liquidator;
        uint256 orderSize;
        uint256 orderRemaining;
        uint256 totalSetsRemaining;
        uint256 chunkSize;
        uint256 chunkAuctionPeriod;
        uint256 lastChunkAuctionEnd;
    }

    /* ============ RebalancingSetV1 Functions ============ */

    /*
     * Fetches all RebalancingSetToken state associated with a rebalance proposal
     *
     * @param  _rebalancingSetToken           RebalancingSetToken contract instance
     * @return RebalancingLibrary.State       Current rebalance state on the RebalancingSetToken
     * @return address[]                      Auction proposal library and next allocation SetToken addresses
     * @return uint256[]                      Auction time to pivot, start price, and pivot price
     */
    function fetchRebalanceProposalStateAsync(
        IRebalancingSetToken _rebalancingSetToken
    )
        external
        returns (RebalancingLibrary.State, address[] memory, uint256[] memory)
    {
        // Fetch the RebalancingSetToken's current rebalance state
        RebalancingLibrary.State rebalanceState = _rebalancingSetToken.rebalanceState();

        // Create return address arrays
        address[] memory auctionAddressParams = new address[](2);
        // Fetch the addresses associated with the current rebalance
        auctionAddressParams[0] = _rebalancingSetToken.nextSet();
        auctionAddressParams[1] = _rebalancingSetToken.auctionLibrary();

        // Create return integer array
        uint256[] memory auctionIntegerParams = new uint256[](4);
        auctionIntegerParams[0] = _rebalancingSetToken.proposalStartTime();

        // Fetch the current rebalance's proposal parameters
        uint256[] memory auctionParameters = _rebalancingSetToken.getAuctionPriceParameters();
        auctionIntegerParams[1] = auctionParameters[1]; // auctionTimeToPivot
        auctionIntegerParams[2] = auctionParameters[2]; // auctionStartPrice
        auctionIntegerParams[3] = auctionParameters[3]; // auctionPivotPrice

        return (rebalanceState, auctionAddressParams, auctionIntegerParams);
    }

    /*
     * Fetches all RebalancingSetToken state associated with a new rebalance auction
     *
     * @param  _rebalancingSetToken           RebalancingSetToken contract instance
     * @return RebalancingLibrary.State       Current rebalance state on the RebalancingSetToken
     * @return uint256[]                      Starting current set, start time, minimum bid, and remaining current sets
     */
    function fetchRebalanceAuctionStateAsync(
        IRebalancingSetToken _rebalancingSetToken
    )
        external
        returns (RebalancingLibrary.State, uint256[] memory)
    {
        // Fetch the RebalancingSetToken's current rebalance state
        RebalancingLibrary.State rebalanceState = _rebalancingSetToken.rebalanceState();

        // Fetch the current rebalance's startingCurrentSetAmount
        uint256[] memory auctionIntegerParams = new uint256[](4);
        auctionIntegerParams[0] = _rebalancingSetToken.startingCurrentSetAmount();

        // Fetch the current rebalance's auction parameters which are made up of various auction times and prices
        uint256[] memory auctionParameters = _rebalancingSetToken.getAuctionPriceParameters();
        auctionIntegerParams[1] = auctionParameters[0]; // auctionStartTime

        // Fetch the current rebalance's bidding parameters which includes the minimum bid and the remaining shares
        uint256[] memory biddingParameters = _rebalancingSetToken.getBiddingParameters();
        auctionIntegerParams[2] = biddingParameters[0]; // minimumBid
        auctionIntegerParams[3] = biddingParameters[1]; // remainingCurrentSets

        return (rebalanceState, auctionIntegerParams);
    }

    /* ============ Event Based Fetching Functions ============ */

    /*
     * Fetches RebalancingSetToken details. Compatible with:
     * - RebalancingSetTokenV2/V3
     * - PerformanceFeeCalculator
     * - Any Liquidator
     *
     * @param  _rebalancingSetToken           RebalancingSetToken contract instance
     * @return RebalancingLibrary.State       Current rebalance state on the RebalancingSetToken
     * @return uint256[]                      Starting current set, start time, minimum bid, and remaining current sets
     */
    function fetchNewRebalancingSetDetails(
        IRebalancingSetTokenV3 _rebalancingSetToken
    )
        public
        view
        returns (
            RebalancingSetCreateInfo memory,
            PerformanceFeeLibrary.FeeState memory,
            CollateralSetInfo memory,
            address
        )
    {
        RebalancingSetCreateInfo memory rbSetInfo = getRebalancingSetInfo(
            address(_rebalancingSetToken)
        );

        PerformanceFeeLibrary.FeeState memory performanceFeeInfo = getPerformanceFeeState(
            address(_rebalancingSetToken)
        );

        CollateralSetInfo memory collateralSetInfo = getCollateralSetInfo(
            rbSetInfo.currentSet
        );

        address performanceFeeCalculatorAddress = address(_rebalancingSetToken.rebalanceFeeCalculator());

        return (rbSetInfo, performanceFeeInfo, collateralSetInfo, performanceFeeCalculatorAddress);
    }

    /*
     * Fetches all RebalancingSetToken state associated with a new rebalance auction. Compatible with:
     * - RebalancingSetTokenV2/V3
     * - Any Fee Calculator
     * - Any liquidator (will omit additional TWAPLiquidator state)
     *
     * @param  _rebalancingSetToken           RebalancingSetToken contract instance
     * @return RebalancingLibrary.State       Current rebalance state on the RebalancingSetToken
     * @return uint256[]                      Starting current set, start time, minimum bid, and remaining current sets
     */
    function fetchRBSetRebalanceDetails(
        IRebalancingSetTokenV2 _rebalancingSetToken
    )
        public
        view
        returns (RebalancingSetRebalanceInfo memory, CollateralSetInfo memory)
    {
        uint256[] memory auctionParams = _rebalancingSetToken.getAuctionPriceParameters();
        uint256[] memory biddingParams = _rebalancingSetToken.getBiddingParameters();

        RebalancingSetRebalanceInfo memory rbSetInfo = RebalancingSetRebalanceInfo({
            rebalanceStartTime: auctionParams[0],
            timeToPivot: auctionParams[1],
            startPrice: auctionParams[2],
            endPrice: auctionParams[3],
            startingCurrentSets: _rebalancingSetToken.startingCurrentSetAmount(),
            remainingCurrentSets: biddingParams[1],
            minimumBid: biddingParams[0],
            rebalanceState: _rebalancingSetToken.rebalanceState(),
            nextSet: _rebalancingSetToken.nextSet(),
            liquidator: _rebalancingSetToken.liquidator()
        });

        CollateralSetInfo memory collateralSetInfo = getCollateralSetInfo(_rebalancingSetToken.nextSet());

        return (rbSetInfo, collateralSetInfo);
    }

    /*
     * Fetches all RebalancingSetToken state associated with a new TWAP rebalance auction. Compatible with:
     * - RebalancingSetTokenV2/V3
     * - Any Fee Calculator
     * - TWAPLiquidator
     *
     * @param  _rebalancingSetToken           RebalancingSetToken contract instance
     * @return RebalancingLibrary.State       Current rebalance state on the RebalancingSetToken
     * @return uint256[]                      Starting current set, start time, minimum bid, and remaining current sets
     */
    function fetchRBSetTWAPRebalanceDetails(
        IRebalancingSetTokenV2 _rebalancingSetToken
    )
        public
        view
        returns (TWAPRebalanceInfo memory, CollateralSetInfo memory)
    {
        uint256[] memory auctionParams = _rebalancingSetToken.getAuctionPriceParameters();
        uint256[] memory biddingParams = _rebalancingSetToken.getBiddingParameters();
        ILiquidator liquidator = _rebalancingSetToken.liquidator();

        ITWAPAuctionGetters twapStateGetters = ITWAPAuctionGetters(address(liquidator));

        TWAPRebalanceInfo memory rbSetInfo = TWAPRebalanceInfo({
            rebalanceStartTime: auctionParams[0],
            timeToPivot: auctionParams[1],
            startPrice: auctionParams[2],
            endPrice: auctionParams[3],
            startingCurrentSets: _rebalancingSetToken.startingCurrentSetAmount(),
            remainingCurrentSets: biddingParams[1],
            minimumBid: biddingParams[0],
            rebalanceState: _rebalancingSetToken.rebalanceState(),
            nextSet: _rebalancingSetToken.nextSet(),
            liquidator: liquidator,
            orderSize: twapStateGetters.getOrderSize(address(_rebalancingSetToken)),
            orderRemaining: twapStateGetters.getOrderRemaining(address(_rebalancingSetToken)),
            totalSetsRemaining: twapStateGetters.getTotalSetsRemaining(address(_rebalancingSetToken)),
            chunkSize: twapStateGetters.getChunkSize(address(_rebalancingSetToken)),
            chunkAuctionPeriod: twapStateGetters.getChunkAuctionPeriod(address(_rebalancingSetToken)),
            lastChunkAuctionEnd: twapStateGetters.getLastChunkAuctionEnd(address(_rebalancingSetToken))
        });

        CollateralSetInfo memory collateralSetInfo = getCollateralSetInfo(_rebalancingSetToken.nextSet());

        return (rbSetInfo, collateralSetInfo);
    }

    /* ============ Batch Fetch Functions ============ */

    /*
     * Fetches RebalancingSetToken states for an array of RebalancingSetToken instances
     *
     * @param  _rebalancingSetTokens[]       RebalancingSetToken contract instances
     * @return RebalancingLibrary.State[]    Current rebalance states on the RebalancingSetToken
     */
    function batchFetchRebalanceStateAsync(
        IRebalancingSetToken[] calldata _rebalancingSetTokens
    )
        external
        returns (RebalancingLibrary.State[] memory)
    {
        // Cache length of addresses to fetch states for
        uint256 _addressesCount = _rebalancingSetTokens.length;

        // Instantiate output array in memory
        RebalancingLibrary.State[] memory states = new RebalancingLibrary.State[](_addressesCount);

        // Cycle through contract addresses array and fetching the rebalance state of each RebalancingSet
        for (uint256 i = 0; i < _addressesCount; i++) {
            states[i] = _rebalancingSetTokens[i].rebalanceState();
        }

        return states;
    }

    /*
     * Fetches RebalancingSetToken unitShares for an array of RebalancingSetToken instances
     *
     * @param  _rebalancingSetTokens[]       RebalancingSetToken contract instances
     * @return uint256[]                     Current unitShares on the RebalancingSetToken
     */
    function batchFetchUnitSharesAsync(
        IRebalancingSetToken[] calldata _rebalancingSetTokens
    )
        external
        returns (uint256[] memory)
    {
        // Cache length of addresses to fetch states for
        uint256 _addressesCount = _rebalancingSetTokens.length;

        // Instantiate output array in memory
        uint256[] memory unitShares = new uint256[](_addressesCount);

        // Cycles through contract addresses array and fetches the unitShares of each RebalancingSet
        for (uint256 i = 0; i < _addressesCount; i++) {
            unitShares[i] = _rebalancingSetTokens[i].unitShares();
        }

        return unitShares;
    }

    /*
     * Fetches RebalancingSetToken liquidator for an array of RebalancingSetToken instances
     *
     * @param  _rebalancingSetTokens[]       RebalancingSetToken contract instances
     * @return address[]                     Current liquidator being used by RebalancingSetToken
     */
    function batchFetchLiquidator(
        IRebalancingSetTokenV2[] calldata _rebalancingSetTokens
    )
        external
        returns (address[] memory)
    {
        // Cache length of addresses to fetch states for
        uint256 _addressesCount = _rebalancingSetTokens.length;

        // Instantiate output array in memory
        address[] memory liquidators = new address[](_addressesCount);

        // Cycles through contract addresses array and fetches the liquidator addresss of each RebalancingSet
        for (uint256 i = 0; i < _addressesCount; i++) {
            liquidators[i] = address(_rebalancingSetTokens[i].liquidator());
        }

        return liquidators;
    }

    /*
     * Fetches RebalancingSetToken state and current collateral for an array of RebalancingSetToken instances
     *
     * @param  _rebalancingSetTokens[]       RebalancingSetToken contract instances
     * @return CollateralAndState[]          Current collateral and state of RebalancingSetTokens
     */
    function batchFetchStateAndCollateral(
        IRebalancingSetToken[] calldata _rebalancingSetTokens
    )
        external
        returns (CollateralAndState[] memory)
    {
        // Cache length of addresses to fetch states for
        uint256 _addressesCount = _rebalancingSetTokens.length;

        // Instantiate output array in memory
        CollateralAndState[] memory statuses = new CollateralAndState[](_addressesCount);

        // Cycles through contract addresses array and fetches the liquidator addresss of each RebalancingSet
        for (uint256 i = 0; i < _addressesCount; i++) {
            statuses[i].collateralSet = address(_rebalancingSetTokens[i].currentSet());
            statuses[i].state = _rebalancingSetTokens[i].rebalanceState();
        }

        return statuses;
    }

    /* ============ Internal Functions ============ */

    function getCollateralSetInfo(
        ISetToken _collateralSet
    )
        internal
        view
        returns (CollateralSetInfo memory)
    {
        return CollateralSetInfo({
            components: _collateralSet.getComponents(),
            units: _collateralSet.getUnits(),
            naturalUnit: _collateralSet.naturalUnit(),
            name: ERC20Detailed(address(_collateralSet)).name(),
            symbol: ERC20Detailed(address(_collateralSet)).symbol()
        });
    }

    function getRebalancingSetInfo(
        address _rebalancingSetToken
    )
        internal
        view
        returns (RebalancingSetCreateInfo memory)
    {
        IRebalancingSetTokenV2 rebalancingSetTokenV2Instance = IRebalancingSetTokenV2(_rebalancingSetToken);

        return RebalancingSetCreateInfo({
            manager: rebalancingSetTokenV2Instance.manager(),
            feeRecipient: rebalancingSetTokenV2Instance.feeRecipient(),
            currentSet: rebalancingSetTokenV2Instance.currentSet(),
            liquidator: rebalancingSetTokenV2Instance.liquidator(),
            unitShares: rebalancingSetTokenV2Instance.unitShares(),
            naturalUnit: rebalancingSetTokenV2Instance.naturalUnit(),
            rebalanceInterval: rebalancingSetTokenV2Instance.rebalanceInterval(),
            entryFee: rebalancingSetTokenV2Instance.entryFee(),
            rebalanceFee: rebalancingSetTokenV2Instance.rebalanceFee(),
            lastRebalanceTimestamp: rebalancingSetTokenV2Instance.lastRebalanceTimestamp(),
            rebalanceState: rebalancingSetTokenV2Instance.rebalanceState(),
            name: rebalancingSetTokenV2Instance.name(),
            symbol: rebalancingSetTokenV2Instance.symbol()
        });
    }

    function getPerformanceFeeState(
        address _rebalancingSetToken
    )
        internal
        view
        returns (PerformanceFeeLibrary.FeeState memory)
    {
        IRebalancingSetTokenV2 rebalancingSetTokenV3Instance = IRebalancingSetTokenV2(_rebalancingSetToken);

        address rebalanceFeeCalculatorAddress = address(rebalancingSetTokenV3Instance.rebalanceFeeCalculator());
        return IPerformanceFeeCalculator(rebalanceFeeCalculatorAddress).feeState(_rebalancingSetToken);
    }
}

// File: set-protocol-strategies/contracts/managers/allocators/ISocialAllocator.sol

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
 * @title ISocialAllocator
 * @author Set Protocol
 *
 * Interface for interacting with SocialAllocator contracts
 */
interface ISocialAllocator {

    /*
     * Determine the next allocation to rebalance into.
     *
     * @param  _targetBaseAssetAllocation       Target allocation of the base asset
     * @return ISetToken                        The address of the proposed nextSet
     */
    function determineNewAllocation(
        uint256 _targetBaseAssetAllocation
    )
        external
        returns (ISetToken);

    /*
     * Calculate value of passed collateral set.
     *
     * @param  _collateralSet        Instance of current set collateralizing RebalancingSetToken
     * @return uint256               USD value of passed Set
     */
    function calculateCollateralSetValue(
        ISetToken _collateralSet
    )
        external
        view
        returns(uint256);
}

// File: set-protocol-strategies/contracts/managers/lib/SocialTradingLibrary.sol

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
 * @title SocialTradingLibrary
 * @author Set Protocol
 *
 * Library for use in SocialTrading system.
 */
library SocialTradingLibrary {

    /* ============ Structs ============ */
    struct PoolInfo {
        address trader;                 // Address allowed to make admin and allocation decisions
        ISocialAllocator allocator;     // Allocator used to make collateral Sets, defines asset pair being used
        uint256 currentAllocation;      // Current base asset allocation of tradingPool
        uint256 newEntryFee;            // New fee percentage to change to after time lock passes, defaults to 0
        uint256 feeUpdateTimestamp;     // Timestamp when fee update process can be finalized, defaults to maxUint256
    }
}

// File: set-protocol-strategies/contracts/managers/interfaces/ISocialTradingManager.sol

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
 * @title ISocialTradingManager
 * @author Set Protocol
 *
 * Interface for interacting with SocialTradingManager contracts
 */
interface ISocialTradingManager {

    /*
     * Get trading pool info.
     *
     * @param _tradingPool        The address of the trading pool being queried
     *
     * @return                    PoolInfo struct of trading pool
     */
    function pools(address _tradingPool) external view returns (SocialTradingLibrary.PoolInfo memory);

    /*
     * Create a trading pool. Create or select new collateral and create RebalancingSetToken contract to
     * administer pool. Save relevant data to pool's entry in pools state variable under the Rebalancing
     * Set Token address.
     *
     * @param _tradingPairAllocator             The address of the allocator the trader wishes to use
     * @param _startingBaseAssetAllocation      Starting base asset allocation in a scaled decimal value
     *                                          (e.g. 100% = 1e18, 1% = 1e16)
     * @param _startingUSDValue                 Starting value of one share of the trading pool to 18 decimals of precision
     * @param _name                             The name of the new RebalancingSetTokenV2
     * @param _symbol                           The symbol of the new RebalancingSetTokenV2
     * @param _rebalancingSetCallData           Byte string containing additional call parameters to pass to factory
     */
    function createTradingPool(
        ISocialAllocator _tradingPairAllocator,
        uint256 _startingBaseAssetAllocation,
        uint256 _startingUSDValue,
        bytes32 _name,
        bytes32 _symbol,
        bytes calldata _rebalancingSetCallData
    )
        external;

    /*
     * Update trading pool allocation. Issue new collateral Set and initiate rebalance on RebalancingSetTokenV2.
     *
     * @param _tradingPool        The address of the trading pool being updated
     * @param _newAllocation      New base asset allocation in a scaled decimal value
     *                                          (e.g. 100% = 1e18, 1% = 1e16)
     * @param _liquidatorData     Extra parameters passed to the liquidator
     */
    function updateAllocation(
        IRebalancingSetTokenV2 _tradingPool,
        uint256 _newAllocation,
        bytes calldata _liquidatorData
    )
        external;

    /*
     * Update trader allowed to manage trading pool.
     *
     * @param _tradingPool        The address of the trading pool being updated
     * @param _newTrader          Address of new traders
     */
    function setTrader(
        IRebalancingSetTokenV2 _tradingPool,
        address _newTrader
    )
        external;

    /*
     * Update liquidator used by tradingPool.
     *
     * @param _tradingPool        The address of the trading pool being updated
     * @param _newLiquidator      Address of new Liquidator
     */
    function setLiquidator(
        IRebalancingSetTokenV2 _tradingPool,
        ILiquidator _newLiquidator
    )
        external;

    /*
     * Update fee recipient of tradingPool.
     *
     * @param _tradingPool          The address of the trading pool being updated
     * @param _newFeeRecipient      Address of new fee recipient
     */
    function setFeeRecipient(
        IRebalancingSetTokenV2 _tradingPool,
        address _newFeeRecipient
    )
        external;
}

// File: contracts/viewer/lib/TradingPoolViewer.sol

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
 * @title TradingPoolViewer
 * @author Set Protocol
 *
 * Interfaces for fetching multiple TradingPool state in a single read. Includes state
 * specific to managing pool as well as underlying RebalancingSetTokenV2 state.
 */
contract TradingPoolViewer is RebalancingSetTokenViewer {

    /*
     * Fetches TradingPool details. Compatible with:
     * - RebalancingSetTokenV2/V3
     * - Any Fee Calculator
     * - Any Liquidator
     *
     * @param  _rebalancingSetToken           RebalancingSetToken contract instance
     * @return RebalancingLibrary.State       Current rebalance state on the RebalancingSetToken
     * @return uint256[]                      Starting current set, start time, minimum bid, and remaining current sets
     */
    function fetchNewTradingPoolDetails(
        IRebalancingSetTokenV2 _tradingPool
    )
        external
        view
        returns (SocialTradingLibrary.PoolInfo memory, RebalancingSetCreateInfo memory, CollateralSetInfo memory)
    {
        RebalancingSetCreateInfo memory tradingPoolInfo = getRebalancingSetInfo(
            address(_tradingPool)
        );

        SocialTradingLibrary.PoolInfo memory poolInfo = ISocialTradingManager(tradingPoolInfo.manager).pools(
            address(_tradingPool)
        );

        CollateralSetInfo memory collateralSetInfo = getCollateralSetInfo(
            tradingPoolInfo.currentSet
        );

        return (poolInfo, tradingPoolInfo, collateralSetInfo);
    }

    /*
     * Fetches TradingPoolV2 details. Compatible with:
     * - RebalancingSetTokenV2/V3
     * - PerformanceFeeCalculator
     * - Any Liquidator
     *
     * @param  _rebalancingSetToken           RebalancingSetToken contract instance
     * @return RebalancingLibrary.State       Current rebalance state on the RebalancingSetToken
     * @return uint256[]                      Starting current set, start time, minimum bid, and remaining current sets
     */
    function fetchNewTradingPoolV2Details(
        IRebalancingSetTokenV3 _tradingPool
    )
        external
        view
        returns (
            SocialTradingLibrary.PoolInfo memory,
            RebalancingSetCreateInfo memory,
            PerformanceFeeLibrary.FeeState memory,
            CollateralSetInfo memory,
            address
        )
    {
        (
            RebalancingSetCreateInfo memory tradingPoolInfo,
            PerformanceFeeLibrary.FeeState memory performanceFeeInfo,
            CollateralSetInfo memory collateralSetInfo,
            address performanceFeeCalculatorAddress
        ) = fetchNewRebalancingSetDetails(_tradingPool);

        SocialTradingLibrary.PoolInfo memory poolInfo = ISocialTradingManager(tradingPoolInfo.manager).pools(
            address(_tradingPool)
        );

        return (poolInfo, tradingPoolInfo, performanceFeeInfo, collateralSetInfo, performanceFeeCalculatorAddress);
    }

    /*
     * Fetches all TradingPool state associated with a new rebalance auction. Compatible with:
     * - RebalancingSetTokenV2/V3
     * - Any Fee Calculator
     * - Any liquidator (will omit additional TWAPLiquidator state)
     *
     * @param  _rebalancingSetToken           RebalancingSetToken contract instance
     * @return RebalancingLibrary.State       Current rebalance state on the RebalancingSetToken
     * @return uint256[]                      Starting current set, start time, minimum bid, and remaining current sets
     */
    function fetchTradingPoolRebalanceDetails(
        IRebalancingSetTokenV2 _tradingPool
    )
        external
        view
        returns (SocialTradingLibrary.PoolInfo memory, RebalancingSetRebalanceInfo memory, CollateralSetInfo memory)
    {
        (
            RebalancingSetRebalanceInfo memory tradingPoolInfo,
            CollateralSetInfo memory collateralSetInfo
        ) = fetchRBSetRebalanceDetails(_tradingPool);

        address manager = _tradingPool.manager();

        SocialTradingLibrary.PoolInfo memory poolInfo = ISocialTradingManager(manager).pools(
            address(_tradingPool)
        );

        return (poolInfo, tradingPoolInfo, collateralSetInfo);
    }

    /*
     * Fetches all TradingPool state associated with a new TWAP rebalance auction. Compatible with:
     * - RebalancingSetTokenV2/V3
     * - Any Fee Calculator
     * - TWAP Liquidator
     *
     * @param  _rebalancingSetToken           RebalancingSetToken contract instance
     * @return RebalancingLibrary.State       Current rebalance state on the RebalancingSetToken
     * @return uint256[]                      Starting current set, start time, minimum bid, and remaining current sets
     */
    function fetchTradingPoolTWAPRebalanceDetails(
        IRebalancingSetTokenV2 _tradingPool
    )
        external
        view
        returns (SocialTradingLibrary.PoolInfo memory, TWAPRebalanceInfo memory, CollateralSetInfo memory)
    {
        (
            TWAPRebalanceInfo memory tradingPoolInfo,
            CollateralSetInfo memory collateralSetInfo
        ) = fetchRBSetTWAPRebalanceDetails(_tradingPool);

        address manager = _tradingPool.manager();

        SocialTradingLibrary.PoolInfo memory poolInfo = ISocialTradingManager(manager).pools(
            address(_tradingPool)
        );

        return (poolInfo, tradingPoolInfo, collateralSetInfo);
    }

    function batchFetchTradingPoolOperator(
        IRebalancingSetTokenV2[] calldata _tradingPools
    )
        external
        view
        returns (address[] memory)
    {
        // Cache length of addresses to fetch owner for
        uint256 _poolCount = _tradingPools.length;

        // Instantiate output array in memory
        address[] memory operators = new address[](_poolCount);

        for (uint256 i = 0; i < _poolCount; i++) {
            IRebalancingSetTokenV2 tradingPool = _tradingPools[i];

            operators[i] = ISocialTradingManager(tradingPool.manager()).pools(
                address(tradingPool)
            ).trader;
        }

        return operators;
    }

    function batchFetchTradingPoolEntryFees(
        IRebalancingSetTokenV2[] calldata _tradingPools
    )
        external
        view
        returns (uint256[] memory)
    {
        // Cache length of addresses to fetch entryFees for
        uint256 _poolCount = _tradingPools.length;

        // Instantiate output array in memory
        uint256[] memory entryFees = new uint256[](_poolCount);

        for (uint256 i = 0; i < _poolCount; i++) {
            entryFees[i] = _tradingPools[i].entryFee();
        }

        return entryFees;
    }

    function batchFetchTradingPoolRebalanceFees(
        IRebalancingSetTokenV2[] calldata _tradingPools
    )
        external
        view
        returns (uint256[] memory)
    {
        // Cache length of addresses to fetch rebalanceFees for
        uint256 _poolCount = _tradingPools.length;

        // Instantiate output array in memory
        uint256[] memory rebalanceFees = new uint256[](_poolCount);

        for (uint256 i = 0; i < _poolCount; i++) {
            rebalanceFees[i] = _tradingPools[i].rebalanceFee();
        }

        return rebalanceFees;
    }

    function batchFetchTradingPoolAccumulation(
        IRebalancingSetTokenV3[] calldata _tradingPools
    )
        external
        view
        returns (uint256[] memory, uint256[] memory)
    {
        // Cache length of addresses to fetch rebalanceFees for
        uint256 _poolCount = _tradingPools.length;

        // Instantiate streaming fees output array in memory
        uint256[] memory streamingFees = new uint256[](_poolCount);

        // Instantiate profit fees output array in memory
        uint256[] memory profitFees = new uint256[](_poolCount);

        for (uint256 i = 0; i < _poolCount; i++) {
            address rebalanceFeeCalculatorAddress = address(_tradingPools[i].rebalanceFeeCalculator());

            (
                streamingFees[i],
                profitFees[i]
            ) = IPerformanceFeeCalculator(rebalanceFeeCalculatorAddress).getCalculatedFees(
                address(_tradingPools[i])
            );
        }

        return (streamingFees, profitFees);
    }


    function batchFetchTradingPoolFeeState(
        IRebalancingSetTokenV3[] calldata _tradingPools
    )
        external
        view
        returns (PerformanceFeeLibrary.FeeState[] memory)
    {
        // Cache length of addresses to fetch rebalanceFees for
        uint256 _poolCount = _tradingPools.length;

        // Instantiate output array in memory
        PerformanceFeeLibrary.FeeState[] memory feeStates = new PerformanceFeeLibrary.FeeState[](_poolCount);

        for (uint256 i = 0; i < _poolCount; i++) {
            feeStates[i] = getPerformanceFeeState(
                address(_tradingPools[i])
            );
        }

        return feeStates;
    }
}

// File: set-protocol-contracts/contracts/core/interfaces/ICToken.sol

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
 * @title ICToken
 * @author Set Protocol
 *
 * Interface for interacting with Compound cTokens
 */
interface ICToken {

    /**
     * Calculates the exchange rate from the underlying to the CToken
     *
     * @notice Accrue interest then return the up-to-date exchange rate
     * @return Calculated exchange rate scaled by 1e18
     */
    function exchangeRateCurrent()
        external
        returns (uint256);

    function exchangeRateStored() external view returns (uint256);

    function decimals() external view returns(uint8);

    /**
     * Sender supplies assets into the market and receives cTokens in exchange
     *
     * @notice Accrues interest whether or not the operation succeeds, unless reverted
     * @param mintAmount The amount of the underlying asset to supply
     * @return uint 0=success, otherwise a failure
     */
    function mint(uint mintAmount) external returns (uint);

    /**
     * @notice Sender redeems cTokens in exchange for the underlying asset
     * @dev Accrues interest whether or not the operation succeeds, unless reverted
     * @param redeemTokens The number of cTokens to redeem into underlying
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function redeem(uint redeemTokens) external returns (uint);
}

// File: contracts/viewer/lib/CTokenViewer.sol

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
 * @title CTokenViewer
 * @author Set Protocol
 *
 * Interface for batch fetching the on-chain Compound exchange rate
 */
contract CTokenViewer {

    function batchFetchExchangeRateStored(
        address[] calldata _cTokenAddresses
    )
        external
        view
        returns (uint256[] memory)
    {
        // Cache length of addresses to fetch exchange rates for
        uint256 _addressesCount = _cTokenAddresses.length;

        // Instantiate output array in memory
        uint256[] memory cTokenExchangeRates = new uint256[](_addressesCount);

        // Cycle through contract addresses array and fetching the exchange rate of each for the owner
        for (uint256 i = 0; i < _addressesCount; i++) {
            cTokenExchangeRates[i] = ICToken(_cTokenAddresses[i]).exchangeRateStored();
        }

        return cTokenExchangeRates;
    }
}

// File: contracts/viewer/ProtocolViewer.sol

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
 * @title ProtocolViewer
 * @author Set Protocol
 *
 * Collection of view methods across various contracts in the SetProtocol system that make reads
 * to commonly fetch batches of state possible in a single eth_call. This reduces latency and
 * prevents inconsistent state from being read across multiple Ethereum nodes.
 */
 /* solium-disable-next-line no-empty-blocks */
contract ProtocolViewer is
    ERC20Viewer,
    TradingPoolViewer,
    CTokenViewer,
    ManagerViewer,
    OracleViewer
{}