/**
 *Submitted for verification at Etherscan.io on 2020-07-16
*/

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

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

// File: contracts/core/interfaces/ICore.sol

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
 * @title ICore
 * @author Set Protocol
 *
 * The ICore Contract defines all the functions exposed in the Core through its
 * various extensions and is a light weight way to interact with the contract.
 */
interface ICore {
    /**
     * Return transferProxy address.
     *
     * @return address       transferProxy address
     */
    function transferProxy()
        external
        view
        returns (address);

    /**
     * Return vault address.
     *
     * @return address       vault address
     */
    function vault()
        external
        view
        returns (address);

    /**
     * Return address belonging to given exchangeId.
     *
     * @param  _exchangeId       ExchangeId number
     * @return address           Address belonging to given exchangeId
     */
    function exchangeIds(
        uint8 _exchangeId
    )
        external
        view
        returns (address);

    /*
     * Returns if valid set
     *
     * @return  bool      Returns true if Set created through Core and isn't disabled
     */
    function validSets(address)
        external
        view
        returns (bool);

    /*
     * Returns if valid module
     *
     * @return  bool      Returns true if valid module
     */
    function validModules(address)
        external
        view
        returns (bool);

    /**
     * Return boolean indicating if address is a valid Rebalancing Price Library.
     *
     * @param  _priceLibrary    Price library address
     * @return bool             Boolean indicating if valid Price Library
     */
    function validPriceLibraries(
        address _priceLibrary
    )
        external
        view
        returns (bool);

    /**
     * Exchanges components for Set Tokens
     *
     * @param  _set          Address of set to issue
     * @param  _quantity     Quantity of set to issue
     */
    function issue(
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Issues a specified Set for a specified quantity to the recipient
     * using the caller's components from the wallet and vault.
     *
     * @param  _recipient    Address to issue to
     * @param  _set          Address of the Set to issue
     * @param  _quantity     Number of tokens to issue
     */
    function issueTo(
        address _recipient,
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Converts user's components into Set Tokens held directly in Vault instead of user's account
     *
     * @param _set          Address of the Set
     * @param _quantity     Number of tokens to redeem
     */
    function issueInVault(
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Function to convert Set Tokens into underlying components
     *
     * @param _set          The address of the Set token
     * @param _quantity     The number of tokens to redeem. Should be multiple of natural unit.
     */
    function redeem(
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Redeem Set token and return components to specified recipient. The components
     * are left in the vault
     *
     * @param _recipient    Recipient of Set being issued
     * @param _set          Address of the Set
     * @param _quantity     Number of tokens to redeem
     */
    function redeemTo(
        address _recipient,
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Function to convert Set Tokens held in vault into underlying components
     *
     * @param _set          The address of the Set token
     * @param _quantity     The number of tokens to redeem. Should be multiple of natural unit.
     */
    function redeemInVault(
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Composite method to redeem and withdraw with a single transaction
     *
     * Normally, you should expect to be able to withdraw all of the tokens.
     * However, some have central abilities to freeze transfers (e.g. EOS). _toExclude
     * allows you to optionally specify which component tokens to exclude when
     * redeeming. They will remain in the vault under the users' addresses.
     *
     * @param _set          Address of the Set
     * @param _to           Address to withdraw or attribute tokens to
     * @param _quantity     Number of tokens to redeem
     * @param _toExclude    Mask of indexes of tokens to exclude from withdrawing
     */
    function redeemAndWithdrawTo(
        address _set,
        address _to,
        uint256 _quantity,
        uint256 _toExclude
    )
        external;

    /**
     * Deposit multiple tokens to the vault. Quantities should be in the
     * order of the addresses of the tokens being deposited.
     *
     * @param  _tokens           Array of the addresses of the ERC20 tokens
     * @param  _quantities       Array of the number of tokens to deposit
     */
    function batchDeposit(
        address[] calldata _tokens,
        uint256[] calldata _quantities
    )
        external;

    /**
     * Withdraw multiple tokens from the vault. Quantities should be in the
     * order of the addresses of the tokens being withdrawn.
     *
     * @param  _tokens            Array of the addresses of the ERC20 tokens
     * @param  _quantities        Array of the number of tokens to withdraw
     */
    function batchWithdraw(
        address[] calldata _tokens,
        uint256[] calldata _quantities
    )
        external;

    /**
     * Deposit any quantity of tokens into the vault.
     *
     * @param  _token           The address of the ERC20 token
     * @param  _quantity        The number of tokens to deposit
     */
    function deposit(
        address _token,
        uint256 _quantity
    )
        external;

    /**
     * Withdraw a quantity of tokens from the vault.
     *
     * @param  _token           The address of the ERC20 token
     * @param  _quantity        The number of tokens to withdraw
     */
    function withdraw(
        address _token,
        uint256 _quantity
    )
        external;

    /**
     * Transfer tokens associated with the sender's account in vault to another user's
     * account in vault.
     *
     * @param  _token           Address of token being transferred
     * @param  _to              Address of user receiving tokens
     * @param  _quantity        Amount of tokens being transferred
     */
    function internalTransfer(
        address _token,
        address _to,
        uint256 _quantity
    )
        external;

    /**
     * Deploys a new Set Token and adds it to the valid list of SetTokens
     *
     * @param  _factory              The address of the Factory to create from
     * @param  _components           The address of component tokens
     * @param  _units                The units of each component token
     * @param  _naturalUnit          The minimum unit to be issued or redeemed
     * @param  _name                 The bytes32 encoded name of the new Set
     * @param  _symbol               The bytes32 encoded symbol of the new Set
     * @param  _callData             Byte string containing additional call parameters
     * @return setTokenAddress       The address of the new Set
     */
    function createSet(
        address _factory,
        address[] calldata _components,
        uint256[] calldata _units,
        uint256 _naturalUnit,
        bytes32 _name,
        bytes32 _symbol,
        bytes calldata _callData
    )
        external
        returns (address);

    /**
     * Exposes internal function that deposits a quantity of tokens to the vault and attributes
     * the tokens respectively, to system modules.
     *
     * @param  _from            Address to transfer tokens from
     * @param  _to              Address to credit for deposit
     * @param  _token           Address of token being deposited
     * @param  _quantity        Amount of tokens to deposit
     */
    function depositModule(
        address _from,
        address _to,
        address _token,
        uint256 _quantity
    )
        external;

    /**
     * Exposes internal function that withdraws a quantity of tokens from the vault and
     * deattributes the tokens respectively, to system modules.
     *
     * @param  _from            Address to decredit for withdraw
     * @param  _to              Address to transfer tokens to
     * @param  _token           Address of token being withdrawn
     * @param  _quantity        Amount of tokens to withdraw
     */
    function withdrawModule(
        address _from,
        address _to,
        address _token,
        uint256 _quantity
    )
        external;

    /**
     * Exposes internal function that deposits multiple tokens to the vault, to system
     * modules. Quantities should be in the order of the addresses of the tokens being
     * deposited.
     *
     * @param  _from              Address to transfer tokens from
     * @param  _to                Address to credit for deposits
     * @param  _tokens            Array of the addresses of the tokens being deposited
     * @param  _quantities        Array of the amounts of tokens to deposit
     */
    function batchDepositModule(
        address _from,
        address _to,
        address[] calldata _tokens,
        uint256[] calldata _quantities
    )
        external;

    /**
     * Exposes internal function that withdraws multiple tokens from the vault, to system
     * modules. Quantities should be in the order of the addresses of the tokens being withdrawn.
     *
     * @param  _from              Address to decredit for withdrawals
     * @param  _to                Address to transfer tokens to
     * @param  _tokens            Array of the addresses of the tokens being withdrawn
     * @param  _quantities        Array of the amounts of tokens to withdraw
     */
    function batchWithdrawModule(
        address _from,
        address _to,
        address[] calldata _tokens,
        uint256[] calldata _quantities
    )
        external;

    /**
     * Expose internal function that exchanges components for Set tokens,
     * accepting any owner, to system modules
     *
     * @param  _owner        Address to use tokens from
     * @param  _recipient    Address to issue Set to
     * @param  _set          Address of the Set to issue
     * @param  _quantity     Number of tokens to issue
     */
    function issueModule(
        address _owner,
        address _recipient,
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Expose internal function that exchanges Set tokens for components,
     * accepting any owner, to system modules
     *
     * @param  _burnAddress         Address to burn token from
     * @param  _incrementAddress    Address to increment component tokens to
     * @param  _set                 Address of the Set to redeem
     * @param  _quantity            Number of tokens to redeem
     */
    function redeemModule(
        address _burnAddress,
        address _incrementAddress,
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Expose vault function that increments user's balance in the vault.
     * Available to system modules
     *
     * @param  _tokens          The addresses of the ERC20 tokens
     * @param  _owner           The address of the token owner
     * @param  _quantities      The numbers of tokens to attribute to owner
     */
    function batchIncrementTokenOwnerModule(
        address[] calldata _tokens,
        address _owner,
        uint256[] calldata _quantities
    )
        external;

    /**
     * Expose vault function that decrement user's balance in the vault
     * Only available to system modules.
     *
     * @param  _tokens          The addresses of the ERC20 tokens
     * @param  _owner           The address of the token owner
     * @param  _quantities      The numbers of tokens to attribute to owner
     */
    function batchDecrementTokenOwnerModule(
        address[] calldata _tokens,
        address _owner,
        uint256[] calldata _quantities
    )
        external;

    /**
     * Expose vault function that transfer vault balances between users
     * Only available to system modules.
     *
     * @param  _tokens           Addresses of tokens being transferred
     * @param  _from             Address tokens being transferred from
     * @param  _to               Address tokens being transferred to
     * @param  _quantities       Amounts of tokens being transferred
     */
    function batchTransferBalanceModule(
        address[] calldata _tokens,
        address _from,
        address _to,
        uint256[] calldata _quantities
    )
        external;

    /**
     * Transfers token from one address to another using the transfer proxy.
     * Only available to system modules.
     *
     * @param  _token          The address of the ERC20 token
     * @param  _quantity       The number of tokens to transfer
     * @param  _from           The address to transfer from
     * @param  _to             The address to transfer to
     */
    function transferModule(
        address _token,
        uint256 _quantity,
        address _from,
        address _to
    )
        external;

    /**
     * Expose transfer proxy function to transfer tokens from one address to another
     * Only available to system modules.
     *
     * @param  _tokens         The addresses of the ERC20 token
     * @param  _quantities     The numbers of tokens to transfer
     * @param  _from           The address to transfer from
     * @param  _to             The address to transfer to
     */
    function batchTransferModule(
        address[] calldata _tokens,
        uint256[] calldata _quantities,
        address _from,
        address _to
    )
        external;
}

// File: contracts/core/interfaces/ISetToken.sol

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

// File: contracts/core/lib/RebalancingLibrary.sol

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

// File: contracts/core/interfaces/IRebalancingSetToken.sol

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

// File: contracts/core/lib/Rebalance.sol

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

// File: contracts/core/interfaces/ILiquidator.sol

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

// File: contracts/core/interfaces/IOracleWhiteList.sol

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
 * @title IOracleWhiteList
 * @author Set Protocol
 *
 * The IWhiteList interface exposes the whitelist mapping to check components
 */
interface IOracleWhiteList {

    /* ============ External Functions ============ */

    /**
     * Returns oracle of passed token address (not in array form)
     *
     * @param  _tokenAddress       Address to check
     * @return bool                Whether passed in address is whitelisted
     */
    function oracleWhiteList(
        address _tokenAddress
    )
        external
        view
        returns (address);

    /**
     * Verifies an array of token addresses against the whitelist
     *
     * @param  _addresses    Array of addresses to verify
     * @return bool          Whether all addresses in the list are whitelsited
     */
    function areValidAddresses(
        address[] calldata _addresses
    )
        external
        view
        returns (bool);

    /**
     * Return array of oracle addresses based on passed in token addresses
     *
     * @param  _tokenAddresses    Array of token addresses to get oracle addresses for
     * @return address[]          Array of oracle addresses
     */
    function getOracleAddressesByToken(
        address[] calldata _tokenAddresses
    )
        external
        view
        returns (address[] memory);

    function getOracleAddressByToken(
        address _token
    )
        external
        view
        returns (address);
}

// File: openzeppelin-solidity/contracts/math/Math.sol

pragma solidity ^0.5.2;

/**
 * @title Math
 * @dev Assorted math operations
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Calculates the average of two numbers. Since these are integers,
     * averages of an even and odd number cannot be represented, and will be
     * rounded down.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// File: set-protocol-contract-utils/contracts/lib/AddressArrayUtils.sol

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

// File: contracts/core/lib/SetMath.sol

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
 * @title SetMath
 * @author Set Protocol
 */
library SetMath {
    using SafeMath for uint256;


    /**
     * Converts SetToken quantity to component quantity
     */
    function setToComponent(
        uint256 _setQuantity,
        uint256 _componentUnit,
        uint256 _naturalUnit
    )
        internal
        pure
        returns(uint256)
    {
        return _setQuantity.mul(_componentUnit).div(_naturalUnit);
    }

    /**
     * Converts component quantity to Set quantity
     */
    function componentToSet(
        uint256 _componentQuantity,
        uint256 _componentUnit,
        uint256 _naturalUnit
    )
        internal
        pure
        returns(uint256)
    {
        return _componentQuantity.mul(_naturalUnit).div(_componentUnit);
    }
}

// File: contracts/core/liquidators/impl/Auction.sol

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
 * @title Auction
 * @author Set Protocol
 *
 * Contract containing utility functions for liquidators that use auctions processes. Contains
 * helper functions to value collateral SetTokens and determine parameters used in bidding
 * processes. Meant to be inherited.
 */
contract Auction {
    using SafeMath for uint256;
    using AddressArrayUtils for address[];

    /* ============ Structs ============ */
    struct Setup {
        uint256 maxNaturalUnit;
        uint256 minimumBid;
        uint256 startTime;
        uint256 startingCurrentSets;
        uint256 remainingCurrentSets;
        address[] combinedTokenArray;
        uint256[] combinedCurrentSetUnits;
        uint256[] combinedNextSetUnits;
    }

    /* ============ Structs ============ */
    uint256 constant private CURVE_DENOMINATOR = 10 ** 18;

    /* ============ Auction Struct Methods ============ */

    /*
     * Sets the Auction Setup struct variables.
     *
     * @param _auction                      Auction Setup object
     * @param _currentSet                   The Set to rebalance from
     * @param _nextSet                      The Set to rebalance to
     * @param _startingCurrentSetQuantity   Quantity of currentSet to rebalance
     */
    function initializeAuction(
        Setup storage _auction,
        ISetToken _currentSet,
        ISetToken _nextSet,
        uint256 _startingCurrentSetQuantity
    )
        internal
    {
        _auction.maxNaturalUnit = Math.max(
            _currentSet.naturalUnit(),
            _nextSet.naturalUnit()
        );

        _auction.startingCurrentSets = _startingCurrentSetQuantity;
        _auction.remainingCurrentSets = _startingCurrentSetQuantity;
        _auction.startTime = block.timestamp;
        _auction.combinedTokenArray = getCombinedTokenArray(_currentSet, _nextSet);
        _auction.combinedCurrentSetUnits = calculateCombinedUnitArray(_auction, _currentSet);
        _auction.combinedNextSetUnits = calculateCombinedUnitArray(_auction, _nextSet);
    }

    function reduceRemainingCurrentSets(Setup storage _auction, uint256 _quantity) internal {
        _auction.remainingCurrentSets = _auction.remainingCurrentSets.sub(_quantity);
    }

    /*
     * Validate bid is a multiple of minimum bid and that amount is less than remaining.
     */
    function validateBidQuantity(Setup storage _auction, uint256 _quantity) internal view {
        require(
            _quantity.mod(_auction.minimumBid) == 0,
            "Auction.validateBidQuantity: Must bid multiple of minimum bid"
        );

        require(
            _quantity <= _auction.remainingCurrentSets,
            "Auction.validateBidQuantity: Bid exceeds remaining current sets"
        );
    }

    /*
     * Asserts whether the auction has been completed, which is when all currentSets have been
     * rebalanced.
     */
    function validateAuctionCompletion(Setup storage _auction) internal view {
        require(
            !hasBiddableQuantity(_auction),
            "Auction.settleRebalance: Rebalance not completed"
        );
    }

    /**
     * Returns whether the remainingSets is still a quantity equal or greater than the minimum bid
     */
    function hasBiddableQuantity(Setup storage _auction) internal view returns(bool) {
        return _auction.remainingCurrentSets >= _auction.minimumBid;
    }

    /**
     * Returns whether the auction is active
     */
    function isAuctionActive(Setup storage _auction) internal view returns(bool) {
        return _auction.startTime > 0;
    }

    /*
     * Calculates TokenFlows
     *
     * @param _auction              Auction Setup object
     * @param _quantity             Amount of currentSets bidder is seeking to rebalance
     * @param _price                Value representing the auction numeartor
     */
    function calculateTokenFlow(
        Setup storage _auction,
        uint256 _quantity,
        uint256 _price
    )
        internal
        view
        returns (Rebalance.TokenFlow memory)
    {
        // Normalized quantity amount
        uint256 unitsMultiplier = _quantity.div(_auction.maxNaturalUnit);

        address[] memory memCombinedTokenArray = _auction.combinedTokenArray;

        uint256 combinedTokenCount = memCombinedTokenArray.length;
        uint256[] memory inflowUnitArray = new uint256[](combinedTokenCount);
        uint256[] memory outflowUnitArray = new uint256[](combinedTokenCount);

        // Cycle through each token in combinedTokenArray, calculate inflow/outflow and store
        // result in array
        for (uint256 i = 0; i < combinedTokenCount; i++) {
            (
                inflowUnitArray[i],
                outflowUnitArray[i]
            ) = calculateInflowOutflow(
                _auction.combinedCurrentSetUnits[i],
                _auction.combinedNextSetUnits[i],
                unitsMultiplier,
                _price
            );
        }

        return Rebalance.composeTokenFlow(memCombinedTokenArray, inflowUnitArray, outflowUnitArray);
    }

    /**
     * Computes the union of the currentSet and nextSet components
     *
     * @param _currentSet               The Set to rebalance from
     * @param _nextSet                  The Set to rebalance to
     * @return                          Aggregated components array
     */
    function getCombinedTokenArray(
        ISetToken _currentSet,
        ISetToken _nextSet
    )
        internal
        view
        returns(address[] memory)
    {
        address[] memory currentSetComponents = _currentSet.getComponents();
        address[] memory nextSetComponents = _nextSet.getComponents();
        return currentSetComponents.union(nextSetComponents);
    }

    /*
     * Calculates token inflow/outflow for single component in combinedTokenArray
     *
     * @param _currentUnit          Amount of token i in currentSet per minimum bid amount
     * @param _nextSetUnit          Amount of token i in nextSet per minimum bid amount
     * @param _unitsMultiplier      Bid amount normalized to number of minimum bid amounts
     * @param _price                Auction price numerator with 10 ** 18 as denominator
     * @return inflowUnit           Amount of token i transferred into the system
     * @return outflowUnit          Amount of token i transferred to the bidder
     */
    function calculateInflowOutflow(
        uint256 _currentUnit,
        uint256 _nextSetUnit,
        uint256 _unitsMultiplier,
        uint256 _price
    )
        internal
        pure
        returns (uint256, uint256)
    {
        /*
         * Below is a mathematically simplified formula for calculating token inflows and
         * outflows, the following is it's derivation:
         * token_flow = (bidQuantity/price)*(nextUnit - price*currentUnit)
         *
         * Where,
         * 1) price = (priceNumerator/priceDivisor),
         * 2) nextUnit and currentUnit are the amount of component i needed for a
         * standardAmount of sets to be rebalanced where one standardAmount =
         * max(natural unit nextSet, natural unit currentSet), and
         * 3) bidQuantity is a normalized amount in terms of the standardAmount used
         * to calculate nextUnit and currentUnit. This is represented by the unitsMultiplier
         * variable.
         *
         * Given these definitions we can derive the below formula as follows:
         * token_flow = (unitsMultiplier/(priceNumerator/priceDivisor))*
         * (nextUnit - (priceNumerator/priceDivisor)*currentUnit)
         *
         * We can then multiply this equation by (priceDivisor/priceDivisor)
         * which simplifies the above equation to:
         *
         * (unitsMultiplier/priceNumerator)* (nextUnit*priceDivisor - currentUnit*priceNumerator)
         *
         * This is the equation seen below, but since unsigned integers are used we must check to see if
         * nextUnit*priceDivisor > currentUnit*priceNumerator, otherwise those two terms must be
         * flipped in the equation.
         */
        uint256 inflowUnit;
        uint256 outflowUnit;

        // Use if statement to check if token inflow or outflow
        if (_nextSetUnit.mul(CURVE_DENOMINATOR) > _currentUnit.mul(_price)) {
            // Calculate inflow amount
            inflowUnit = _unitsMultiplier.mul(
                _nextSetUnit.mul(CURVE_DENOMINATOR).sub(_currentUnit.mul(_price))
            ).div(_price);

            // Set outflow amount to 0 for component i, since tokens need to be injected in rebalance
            outflowUnit = 0;
        } else {
            // Calculate outflow amount
            outflowUnit = _unitsMultiplier.mul(
                _currentUnit.mul(_price).sub(_nextSetUnit.mul(CURVE_DENOMINATOR))
            ).div(_price);

            // Set inflow amount to 0 for component i, since tokens need to be returned in rebalance
            inflowUnit = 0;
        }

        return (inflowUnit, outflowUnit);
    }

    /* ============ Token Array Creation Helpers ============ */

    /**
     * Create uint256 arrays that represents all components in currentSet and nextSet.
     * Calcualate unit difference between both sets relative to the largest natural
     * unit of the two sets.
     *
     * @param _auction           Auction Setup object
     * @param _set               The Set to generate units for
     * @return combinedUnits
     */
    function calculateCombinedUnitArray(
        Setup storage _auction,
        ISetToken _set
    )
        internal
        view
        returns (uint256[] memory)
    {
        address[] memory combinedTokenArray = _auction.combinedTokenArray;
        uint256[] memory combinedUnits = new uint256[](combinedTokenArray.length);
        for (uint256 i = 0; i < combinedTokenArray.length; i++) {
            combinedUnits[i] = calculateCombinedUnit(
                _set,
                _auction.maxNaturalUnit,
                combinedTokenArray[i]
            );
        }

        return combinedUnits;
    }

    /**
     * Calculations the unit amount of Token to include in the the combined Set units.
     *
     * @param _setToken                 Information on the SetToken
     * @param _maxNaturalUnit           Max natural unit of two sets in rebalance
     * @param _component                Current component in iteration
     * @return                          Unit inflow/outflow
     */
    function calculateCombinedUnit(
        ISetToken _setToken,
        uint256 _maxNaturalUnit,
        address _component
    )
        private
        view
        returns (uint256)
    {
        // Check if component in arrays and get index if it is
        (
            uint256 indexCurrent,
            bool isComponent
        ) = _setToken.getComponents().indexOf(_component);

        // Compute unit amounts of token in Set
        if (isComponent) {
            return calculateTransferValue(
                _setToken.getUnits()[indexCurrent],
                _setToken.naturalUnit(),
                _maxNaturalUnit
            );
        }

        return 0;
    }

   /**
     * Function to calculate the transfer value of a component given a standardized bid amount
     * (minimumBid/priceDivisor)
     *
     * @param   _unit               Units of the component token
     * @param   _naturalUnit        Natural unit of the Set token
     * @param   _maxNaturalUnit     Max natural unit of two sets in rebalance
     * @return  uint256             Amount of tokens per standard bid amount (minimumBid/priceDivisor)
     */
    function calculateTransferValue(
        uint256 _unit,
        uint256 _naturalUnit,
        uint256 _maxNaturalUnit
    )
        private
        pure
        returns (uint256)
    {
        return SetMath.setToComponent(_maxNaturalUnit, _unit, _naturalUnit);
    }
}

// File: contracts/core/liquidators/impl/LinearAuction.sol

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
 * @title LinearAuction
 * @author Set Protocol
 *
 * Library containing utility functions for computing auction Price for a linear price auction.
 */
contract LinearAuction is Auction {
    using SafeMath for uint256;

    /* ============ Structs ============ */
    struct State {
        Auction.Setup auction;
        uint256 endTime;
        uint256 startPrice;
        uint256 endPrice;
    }

    /* ============ State Variables ============ */
    uint256 public auctionPeriod; // Length in seconds of auction

    /**
     * LinearAuction constructor
     *
     * @param _auctionPeriod          Length of auction
     */
    constructor(
        uint256 _auctionPeriod
    )
        public
    {
        auctionPeriod = _auctionPeriod;
    }

    /* ============ Internal Functions ============ */

    /**
     * Populates the linear auction struct following an auction initiation.
     *
     * @param _linearAuction                LinearAuction State object
     * @param _currentSet                   The Set to rebalance from
     * @param _nextSet                      The Set to rebalance to
     * @param _startingCurrentSetQuantity   Quantity of currentSet to rebalance
     */
    function initializeLinearAuction(
        State storage _linearAuction,
        ISetToken _currentSet,
        ISetToken _nextSet,
        uint256 _startingCurrentSetQuantity
    )
        internal
    {
        initializeAuction(
            _linearAuction.auction,
            _currentSet,
            _nextSet,
            _startingCurrentSetQuantity
        );

        uint256 minimumBid = calculateMinimumBid(_linearAuction.auction, _currentSet, _nextSet);

        // remainingCurrentSets must be greater than minimumBid or no bidding would be allowed
        require(
            _startingCurrentSetQuantity.div(minimumBid) >= 100,
            "LinearAuction.initializeAuction: Minimum bid must be less than or equal to 1% of collateral."
        );

        _linearAuction.auction.minimumBid = minimumBid;

        _linearAuction.startPrice = calculateStartPrice(_linearAuction.auction, _currentSet, _nextSet);
        _linearAuction.endPrice = calculateEndPrice(_linearAuction.auction, _currentSet, _nextSet);

        _linearAuction.endTime = block.timestamp.add(auctionPeriod);
    }

    /* ============ Internal View Functions ============ */

    /**
     * Returns the TokenFlow based on the current price
     */
    function getTokenFlow(
        State storage _linearAuction,
        uint256 _quantity
    )
        internal
        view
        returns (Rebalance.TokenFlow memory)
    {
        return Auction.calculateTokenFlow(
            _linearAuction.auction,
            _quantity,
            getPrice(_linearAuction)
        );
    }

    /**
     * Auction failed is defined the timestamp breacnhing the auction end time and
     * the auction not being complete
     */
    function hasAuctionFailed(State storage _linearAuction) internal view returns(bool) {
        bool endTimeExceeded = block.timestamp >= _linearAuction.endTime;
        bool setsNotAuctioned = hasBiddableQuantity(_linearAuction.auction);

        return (endTimeExceeded && setsNotAuctioned);
    }

    /**
     * Returns the price based on the current timestamp. Returns the endPrice
     * if time has exceeded the auction period
     *
     * @param _linearAuction            Linear Auction State object
     * @return price                    uint representing the current price
     */
    function getPrice(State storage _linearAuction) internal view returns (uint256) {
        uint256 elapsed = block.timestamp.sub(_linearAuction.auction.startTime);

        // If current time has elapsed
        if (elapsed >= auctionPeriod) {
            return _linearAuction.endPrice;
        } else {
            uint256 range = _linearAuction.endPrice.sub(_linearAuction.startPrice);
            uint256 elapsedPrice = elapsed.mul(range).div(auctionPeriod);

            return _linearAuction.startPrice.add(elapsedPrice);
        }
    }

    /**
     * Abstract function that must be implemented.
     * Calculate the minimumBid allowed for the rebalance.
     *
     * @param _auction            Auction object
     * @param _currentSet         The Set to rebalance from
     * @param _nextSet            The Set to rebalance to
     * @return                    Minimum bid amount
     */
    function calculateMinimumBid(
        Setup storage _auction,
        ISetToken _currentSet,
        ISetToken _nextSet
    )
        internal
        view
        returns (uint256);

    /**
     * Abstract function that must be implemented.
     * Calculates the linear auction start price
     */
    function calculateStartPrice(
        Auction.Setup storage _auction,
        ISetToken _currentSet,
        ISetToken _nextSet
    )
        internal
        view
        returns(uint256);

    /**
     * Abstract function that must be implemented.
     * Calculates the linear auction end price
     */
    function calculateEndPrice(
        Auction.Setup storage _auction,
        ISetToken _currentSet,
        ISetToken _nextSet
    )
        internal
        view
        returns(uint256);
}

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.2;

/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
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

// File: set-protocol-contract-utils/contracts/lib/CommonMath.sol

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



library CommonMath {
    using SafeMath for uint256;

    uint256 public constant SCALE_FACTOR = 10 ** 18;
    uint256 public constant MAX_UINT_256 = 2 ** 256 - 1;

    /**
     * Returns scale factor equal to 10 ** 18
     *
     * @return  10 ** 18
     */
    function scaleFactor()
        internal
        pure
        returns (uint256)
    {
        return SCALE_FACTOR;
    }

    /**
     * Calculates and returns the maximum value for a uint256
     *
     * @return  The maximum value for uint256
     */
    function maxUInt256()
        internal
        pure
        returns (uint256)
    {
        return MAX_UINT_256;
    }

    /**
     * Increases a value by the scale factor to allow for additional precision
     * during mathematical operations
     */
    function scale(
        uint256 a
    )
        internal
        pure
        returns (uint256)
    {
        return a.mul(SCALE_FACTOR);
    }

    /**
     * Divides a value by the scale factor to allow for additional precision
     * during mathematical operations
    */
    function deScale(
        uint256 a
    )
        internal
        pure
        returns (uint256)
    {
        return a.div(SCALE_FACTOR);
    }

    /**
    * @dev Performs the power on a specified value, reverts on overflow.
    */
    function safePower(
        uint256 a,
        uint256 pow
    )
        internal
        pure
        returns (uint256)
    {
        require(a > 0);

        uint256 result = 1;
        for (uint256 i = 0; i < pow; i++){
            uint256 previousResult = result;

            // Using safemath multiplication prevents overflows
            result = previousResult.mul(a);
        }

        return result;
    }

    /**
    * @dev Performs division where if there is a modulo, the value is rounded up
    */
    function divCeil(uint256 a, uint256 b)
        internal
        pure
        returns(uint256)
    {
        return a.mod(b) > 0 ? a.div(b).add(1) : a.div(b);
    }

    /**
     * Checks for rounding errors and returns value of potential partial amounts of a principal
     *
     * @param  _principal       Number fractional amount is derived from
     * @param  _numerator       Numerator of fraction
     * @param  _denominator     Denominator of fraction
     * @return uint256          Fractional amount of principal calculated
     */
    function getPartialAmount(
        uint256 _principal,
        uint256 _numerator,
        uint256 _denominator
    )
        internal
        pure
        returns (uint256)
    {
        // Get remainder of partial amount (if 0 not a partial amount)
        uint256 remainder = mulmod(_principal, _numerator, _denominator);

        // Return if not a partial amount
        if (remainder == 0) {
            return _principal.mul(_numerator).div(_denominator);
        }

        // Calculate error percentage
        uint256 errPercentageTimes1000000 = remainder.mul(1000000).div(_numerator.mul(_principal));

        // Require error percentage is less than 0.1%.
        require(
            errPercentageTimes1000000 < 1000,
            "CommonMath.getPartialAmount: Rounding error exceeds bounds"
        );

        return _principal.mul(_numerator).div(_denominator);
    }

    /*
     * Gets the rounded up log10 of passed value
     *
     * @param  _value         Value to calculate ceil(log()) on
     * @return uint256        Output value
     */
    function ceilLog10(
        uint256 _value
    )
        internal
        pure
        returns (uint256)
    {
        // Make sure passed value is greater than 0
        require (
            _value > 0,
            "CommonMath.ceilLog10: Value must be greater than zero."
        );

        // Since log10(1) = 0, if _value = 1 return 0
        if (_value == 1) return 0;

        // Calcualte ceil(log10())
        uint256 x = _value - 1;

        uint256 result = 0;

        if (x >= 10 ** 64) {
            x /= 10 ** 64;
            result += 64;
        }
        if (x >= 10 ** 32) {
            x /= 10 ** 32;
            result += 32;
        }
        if (x >= 10 ** 16) {
            x /= 10 ** 16;
            result += 16;
        }
        if (x >= 10 ** 8) {
            x /= 10 ** 8;
            result += 8;
        }
        if (x >= 10 ** 4) {
            x /= 10 ** 4;
            result += 4;
        }
        if (x >= 100) {
            x /= 100;
            result += 2;
        }
        if (x >= 10) {
            result += 1;
        }

        return result + 1;
    }
}

// File: contracts/core/liquidators/impl/TwoAssetPriceBoundedLinearAuction.sol

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
 * @title TwoAssetPriceBoundedLinearAuction
 * @author Set Protocol
 *
 * Contract to calculate minimumBid and auction start bounds for auctions containing only
 * an asset pair.
 */
contract TwoAssetPriceBoundedLinearAuction is LinearAuction {
    using SafeMath for uint256;
    using CommonMath for uint256;

    /* ============ Struct ============ */
    struct AssetInfo {
        uint256 price;
        uint256 fullUnit;
    }

    /* ============ Constants ============ */
    uint256 constant private CURVE_DENOMINATOR = 10 ** 18;
    uint256 constant private ONE = 1;
    // Minimum token flow allowed at spot price in auction
    uint256 constant private MIN_SPOT_TOKEN_FLOW_SCALED = 10 ** 21;

    /* ============ State Variables ============ */
    IOracleWhiteList public oracleWhiteList;
    uint256 public rangeStart; // Percentage below FairValue to begin auction at
    uint256 public rangeEnd;  // Percentage above FairValue to end auction at

    /**
     * TwoAssetPriceBoundedLinearAuction constructor
     *
     * @param _auctionPeriod          Length of auction
     * @param _rangeStart             Percentage below FairValue to begin auction at in 18 decimal value
     * @param _rangeEnd               Percentage above FairValue to end auction at in 18 decimal value
     */
    constructor(
        IOracleWhiteList _oracleWhiteList,
        uint256 _auctionPeriod,
        uint256 _rangeStart,
        uint256 _rangeEnd
    )
        public
        LinearAuction(_auctionPeriod)
    {
        oracleWhiteList = _oracleWhiteList;
        rangeStart = _rangeStart;
        rangeEnd = _rangeEnd;
    }

    /* ============ Internal Functions ============ */

    /**
     * Validates that the auction only includes two components and the components are valid.
     */
    function validateTwoAssetPriceBoundedAuction(
        ISetToken _currentSet,
        ISetToken _nextSet
    )
        internal
        view
    {
        address[] memory combinedTokenArray = Auction.getCombinedTokenArray(_currentSet, _nextSet);
        require(
            combinedTokenArray.length == 2,
            "TwoAssetPriceBoundedLinearAuction: Only two components are allowed."
        );

        require(
            oracleWhiteList.areValidAddresses(combinedTokenArray),
            "TwoAssetPriceBoundedLinearAuction: Passed token does not have matching oracle."
        );
    }

    /**
     * Calculates the minimumBid. First calculates the minimum token flow for the pair at fair value using
     * maximum natural unit of two Sets. If that token flow is below 1000 units then calculate minimumBid
     * as such:
     *
     * minimumBid = maxNaturalUnit*1000/min(tokenFlow)
     *
     * Else, set minimumBid equal to maxNaturalUnit. This is to ensure that around fair value there is ample
     * granualarity in asset pair price changes and not large discontinuities.
     *
     * @param _auction            Auction object
     * @param _currentSet         CurrentSet, unused in this implementation
     * @param _nextSet            NextSet, unused in this implementation
     */
    function calculateMinimumBid(
        Auction.Setup storage _auction,
        ISetToken _currentSet,
        ISetToken _nextSet
    )
        internal
        view
        returns (uint256)
    {
        // Get full Unit amount and price for each asset
        AssetInfo memory assetOne = getAssetInfo(_auction.combinedTokenArray[0]);
        AssetInfo memory assetTwo = getAssetInfo(_auction.combinedTokenArray[1]);

        // Calculate current spot price as assetOne/assetTwo
        uint256 spotPrice = calculateSpotPrice(assetOne.price, assetTwo.price);

        // Calculate auction price at current asset pair spot price
        uint256 auctionFairValue = convertAssetPairPriceToAuctionPrice(
            _auction,
            spotPrice,
            assetOne.fullUnit,
            assetTwo.fullUnit
        );

        uint256 minimumBidMultiplier = 0;
        for (uint8 i = 0; i < _auction.combinedTokenArray.length; i++) {
            // Get token flow at fair value for asset i, using an amount equal to ONE maxNaturalUnit
            // Hence the ONE.scale()
            (
                uint256 tokenInflowScaled,
                uint256 tokenOutflowScaled
            ) = Auction.calculateInflowOutflow(
                _auction.combinedCurrentSetUnits[i],
                _auction.combinedNextSetUnits[i],
                ONE.scale(),
                auctionFairValue
            );

            // One returned number from previous function will be zero so use max to get tokenFlow
            uint256 tokenFlowScaled = Math.max(tokenInflowScaled, tokenOutflowScaled);

            // Divide minimum spot token flow (1000 units) by token flow if more than minimumBidMultiplier
            // update minimumBidMultiplier
            uint256 currentMinBidMultiplier = MIN_SPOT_TOKEN_FLOW_SCALED.divCeil(tokenFlowScaled);
            minimumBidMultiplier = currentMinBidMultiplier > minimumBidMultiplier ?
                currentMinBidMultiplier :
                minimumBidMultiplier;
        }

        // Multiply the minimumBidMultiplier by maxNaturalUnit to get minimumBid
        return _auction.maxNaturalUnit.mul(minimumBidMultiplier);
    }

    /**
     * Calculates the linear auction start price. A target asset pair (i.e. ETH/DAI) price is calculated
     * to start the auction at, that asset pair price is then translated into the equivalent auction price.
     *
     * @param _auction            Auction object
     * @param _currentSet         CurrentSet, unused in this implementation
     * @param _nextSet            NextSet, unused in this implementation
     */
    function calculateStartPrice(
        Auction.Setup storage _auction,
        ISetToken _currentSet,
        ISetToken _nextSet
    )
        internal
        view
        returns(uint256)
    {
        // Get full Unit amount and price for each asset
        AssetInfo memory assetOne = getAssetInfo(_auction.combinedTokenArray[0]);
        AssetInfo memory assetTwo = getAssetInfo(_auction.combinedTokenArray[1]);

        // Calculate current asset pair spot price as assetOne/assetTwo
        uint256 spotPrice = calculateSpotPrice(assetOne.price, assetTwo.price);

        // Check to see if asset pair price is increasing or decreasing as time passes
        bool isTokenFlowIncreasing = isTokenFlowIncreasing(
            _auction,
            spotPrice,
            assetOne.fullUnit,
            assetTwo.fullUnit
        );

        // If price implied by token flows is increasing then target price we are using for lower bound
        // is below current spot price, if flows decreasing set target price above spotPrice
        uint256 startPairPrice;
        if (isTokenFlowIncreasing) {
            startPairPrice = spotPrice.mul(CommonMath.scaleFactor().sub(rangeStart)).deScale();
        } else {
            startPairPrice = spotPrice.mul(CommonMath.scaleFactor().add(rangeStart)).deScale();
        }

        // Convert start asset pair price to equivalent auction price
        return convertAssetPairPriceToAuctionPrice(
            _auction,
            startPairPrice,
            assetOne.fullUnit,
            assetTwo.fullUnit
        );
    }

    /**
     * Calculates the linear auction end price. A target asset pair (i.e. ETH/DAI) price is calculated
     * to end the auction at, that asset pair price is then translated into the equivalent auction price.
     *
     * @param _auction            Auction object
     * @param _currentSet         CurrentSet, unused in this implementation
     * @param _nextSet            NextSet, unused in this implementation
     */
    function calculateEndPrice(
        Auction.Setup storage _auction,
        ISetToken _currentSet,
        ISetToken _nextSet
    )
        internal
        view
        returns(uint256)
    {
        // Get full Unit amount and price for each asset
        AssetInfo memory assetOne = getAssetInfo(_auction.combinedTokenArray[0]);
        AssetInfo memory assetTwo = getAssetInfo(_auction.combinedTokenArray[1]);

        // Calculate current spot price as assetOne/assetTwo
        uint256 spotPrice = calculateSpotPrice(assetOne.price, assetTwo.price);

        // Check to see if asset pair price is increasing or decreasing as time passes
        bool isTokenFlowIncreasing = isTokenFlowIncreasing(
            _auction,
            spotPrice,
            assetOne.fullUnit,
            assetTwo.fullUnit
        );

        // If price implied by token flows is increasing then target price we are using for upper bound
        // is above current spot price, if flows decreasing set target price below spotPrice
        uint256 endPairPrice;
        if (isTokenFlowIncreasing) {
            endPairPrice = spotPrice.mul(CommonMath.scaleFactor().add(rangeEnd)).deScale();
        } else {
            endPairPrice = spotPrice.mul(CommonMath.scaleFactor().sub(rangeEnd)).deScale();
        }

        // Convert end asset pair price to equivalent auction price
        return convertAssetPairPriceToAuctionPrice(
            _auction,
            endPairPrice,
            assetOne.fullUnit,
            assetTwo.fullUnit
        );
    }

    /* ============ Private Functions ============ */

    /**
     * Determines if asset pair price is increasing or decreasing as time passed in auction. Used to set the
     * auction price bounds. Below a refers to any asset and subscripts c, n, d mean currentSetUnit, nextSetUnit
     * and fullUnit amount, respectively. pP and pD refer to auction price and auction denominator. Asset pair
     * price is defined as such:
     *
     * assetPrice = abs(assetTwoOutflow/assetOneOutflow)
     *
     * The equation for an outflow is given by (a_c/a_d)*pP - (a_n/a_d)*pD). It can be proven that the derivative
     * of this equation is always increasing. Thus by determining the sign of the assetOneOutflow (where a negative
     * amount signifies an inflow) it can be determined whether the asset pair price is increasing or decreasing.
     *
     * For example, if assetOneOutflow is negative it means that the denominator is getting smaller as time passes
     * and thus the assetPrice is increasing during the auction.
     *
     * @param _auction              Auction object
     * @param _spotPrice            Current spot price provided by asset oracles
     * @param _assetOneFullUnit     Units in one full unit of assetOne
     * @param _assetTwoFullUnit     Units in one full unit of assetTwo
     */
    function isTokenFlowIncreasing(
        Auction.Setup storage _auction,
        uint256 _spotPrice,
        uint256 _assetOneFullUnit,
        uint256 _assetTwoFullUnit
    )
        private
        view
        returns (bool)
    {
        // Calculate auction price at current asset pair spot price
        uint256 auctionFairValue = convertAssetPairPriceToAuctionPrice(
            _auction,
            _spotPrice,
            _assetOneFullUnit,
            _assetTwoFullUnit
        );

        // Determine whether outflow for assetOne is positive or negative, if positive then asset pair price is
        // increasing, else decreasing.
        return _auction.combinedNextSetUnits[0].mul(CURVE_DENOMINATOR) >
            _auction.combinedCurrentSetUnits[0].mul(auctionFairValue);
    }

    /**
     * Convert an asset pair price to the equivalent auction price where a1 refers to assetOne and a2 refers to assetTwo
     * and subscripts c, n, d mean currentSetUnit, nextSetUnit and fullUnit amount, respectively. pP and pD refer to auction
     * price and auction denominator:
     *
     * assetPrice = abs(assetTwoOutflow/assetOneOutflow)
     *
     * assetPrice = ((a2_c/a2_d)*pP - (a2_n/a2_d)*pD) / ((a1_c/a1_d)*pP - (a1_n/a1_d)*pD)
     *
     * We know assetPrice so we isolate for pP:
     *
     * pP = pD((a2_n/a2_d)+assetPrice*(a1_n/a1_d)) / (a2_c/a2_d)+assetPrice*(a1_c/a1_d)
     *
     * This gives us the auction price that matches with the passed asset pair price.
     *
     * @param _auction              Auction object
     * @param _targetPrice          Target asset pair price
     * @param _assetOneFullUnit     Units in one full unit of assetOne
     * @param _assetTwoFullUnit     Units in one full unit of assetTwo
     */
    function convertAssetPairPriceToAuctionPrice(
        Auction.Setup storage _auction,
        uint256 _targetPrice,
        uint256 _assetOneFullUnit,
        uint256 _assetTwoFullUnit
    )
        private
        view
        returns (uint256)
    {
        // Calculate the numerator for the above equation. In order to ensure no rounding down errors we distribute the auction
        // denominator. Additionally, since the price is passed as an 18 decimal number in order to maintain consistency we
        // have to scale the first term up accordingly
        uint256 calcNumerator = _auction.combinedNextSetUnits[1].mul(CURVE_DENOMINATOR).scale().div(_assetTwoFullUnit).add(
            _targetPrice.mul(_auction.combinedNextSetUnits[0]).mul(CURVE_DENOMINATOR).div(_assetOneFullUnit)
        );

        // Calculate the denominator for the above equation. As above we we have to scale the first term match the 18 decimal
        // price. Furthermore since we are not guaranteed that targetPrice * a1_c > a1_d we have to scale the second term and
        // thus also the first term in order to match (hence the two scale() in the first term)
        uint256 calcDenominator = _auction.combinedCurrentSetUnits[1].scale().scale().div(_assetTwoFullUnit).add(
           _targetPrice.mul(_auction.combinedCurrentSetUnits[0]).scale().div(_assetOneFullUnit)
        );

        // Here the scale required to account for the 18 decimal price cancels out since it was applied to both the numerator
        // and denominator. However, there was an extra scale applied to the denominator that we need to remove, in order to
        // do so we'll just apply another scale to the numerator before dividing since 1/(1/10 ** 18) = 10 ** 18!
        return calcNumerator.scale().div(calcDenominator);
    }

    /**
     * Get fullUnit amount and price of given asset.
     *
     * @param _asset            Address of auction to get information from
     */
    function getAssetInfo(address _asset) private view returns(AssetInfo memory) {
        address assetOracle = oracleWhiteList.getOracleAddressByToken(_asset);
        uint256 assetPrice = IOracle(assetOracle).read();

        uint256 decimals = ERC20Detailed(_asset).decimals();

        return AssetInfo({
            price: assetPrice,
            fullUnit: CommonMath.safePower(10, decimals)
        });
    }

    /**
     * Calculate asset pair price given two prices.
     */
    function calculateSpotPrice(uint256 _assetOnePrice, uint256 _assetTwoPrice) private view returns(uint256) {
        return _assetOnePrice.scale().div(_assetTwoPrice);
    }
}

// File: contracts/core/liquidators/LinearAuctionLiquidator.sol

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
 * @title LinearAuctionLiquidator
 * @author Set Protocol
 *
 * Contract that holds all the state and functionality required for setting up, returning prices, and tearing
 * down linear auction rebalances for RebalancingSetTokens.
 */
contract LinearAuctionLiquidator is TwoAssetPriceBoundedLinearAuction, ILiquidator {
    using SafeMath for uint256;

    ICore public core;
    string public name;
    mapping(address => LinearAuction.State) public auctions;

    /* ============ Modifier ============ */
    modifier isValidSet() {
        requireValidSet(msg.sender);
        _;
    }

    /**
     * LinearAuctionLiquidator constructor
     *
     * @param _core                   Core instance
     * @param _oracleWhiteList        Oracle WhiteList instance
     * @param _auctionPeriod          Length of auction
     * @param _rangeStart             Percentage above FairValue to begin auction at
     * @param _rangeEnd               Percentage below FairValue to end auction at
     * @param _name                   Descriptive name of Liquidator
     */
    constructor(
        ICore _core,
        IOracleWhiteList _oracleWhiteList,
        uint256 _auctionPeriod,
        uint256 _rangeStart,
        uint256 _rangeEnd,
        string memory _name
    )
        public
        TwoAssetPriceBoundedLinearAuction(
            _oracleWhiteList,
            _auctionPeriod,
            _rangeStart,
            _rangeEnd
        )
    {
        core = _core;
        name = _name;
    }

    /* ============ External Functions ============ */

    /**
     * Initiates a linear auction. Can only be called by a SetToken.
     *
     * @param _currentSet                   The Set to rebalance from
     * @param _nextSet                      The Set to rebalance to
     * @param _startingCurrentSetQuantity   The currentSet quantity to rebalance
     * @param _liquidatorData                  Bytecode formatted data with liquidator-specific arguments
     */
    function startRebalance(
        ISetToken _currentSet,
        ISetToken _nextSet,
        uint256 _startingCurrentSetQuantity,
        bytes calldata _liquidatorData
    )
        external
        isValidSet
    {
        _liquidatorData; // Pass linting

        TwoAssetPriceBoundedLinearAuction.validateTwoAssetPriceBoundedAuction(
            _currentSet,
            _nextSet
        );

        LinearAuction.initializeLinearAuction(
            linearAuction(msg.sender),
            _currentSet,
            _nextSet,
            _startingCurrentSetQuantity
        );
    }

    /**
     * Reduces the remainingCurrentSet quantity and retrieves the current
     * bid price.
     * Can only be called by a SetToken during an active auction
     *
     * @param _quantity               The currentSetQuantity to rebalance
     * @return TokenFlow              Struct with array, inflow, and outflow data
     */
    function placeBid(
        uint256 _quantity
    )
        external
        isValidSet
        returns (Rebalance.TokenFlow memory)
    {
        Auction.validateBidQuantity(auction(msg.sender), _quantity);

        Auction.reduceRemainingCurrentSets(auction(msg.sender), _quantity);

        return getBidPrice(msg.sender, _quantity);
    }

    /**
     * Retrieves the current auction price for the particular Set
     *
     * @param _set                    Address of the SetToken
     * @param _quantity               The currentSetQuantity to rebalance
     * @return TokenFlow              Struct with array, inflow, and outflow data
     */
    function getBidPrice(
        address _set,
        uint256 _quantity
    )
        public
        view
        returns (Rebalance.TokenFlow memory)
    {
        return LinearAuction.getTokenFlow(linearAuction(_set), _quantity);
    }

    /**
     * Validates auction completion and clears auction state.
     */
    function settleRebalance() external isValidSet {

        Auction.validateAuctionCompletion(auction(msg.sender));

        clearAuctionState(msg.sender);
    }

    /**
     * Clears auction state.
     */
    function endFailedRebalance() external isValidSet {

        clearAuctionState(msg.sender);
    }

    /* ============ Getters Functions ============ */

    function hasRebalanceFailed(address _set) external view returns (bool) {
        return LinearAuction.hasAuctionFailed(linearAuction(_set));
    }

    function minimumBid(address _set) external view returns (uint256) {
        return auction(_set).minimumBid;
    }

    function remainingCurrentSets(address _set) external view returns (uint256) {
        return auction(_set).remainingCurrentSets;
    }

    function startingCurrentSets(address _set) external view returns (uint256) {
        return auction(_set).startingCurrentSets;
    }

    function getCombinedTokenArray(address _set) external view returns (address[] memory) {
        return auction(_set).combinedTokenArray;
    }

    function getCombinedCurrentSetUnits(address _set) external view returns (uint256[] memory) {
        return auction(_set).combinedCurrentSetUnits;
    }

    function getCombinedNextSetUnits(address _set) external view returns (uint256[] memory) {
        return auction(_set).combinedNextSetUnits;
    }

    function auctionPriceParameters(address _set)
        external
        view
        returns (RebalancingLibrary.AuctionPriceParameters memory)
    {
        return RebalancingLibrary.AuctionPriceParameters({
            auctionStartTime: auction(_set).startTime,
            auctionTimeToPivot: auctionPeriod,
            auctionStartPrice: linearAuction(_set).startPrice,
            auctionPivotPrice: linearAuction(_set).endPrice
        });
    }

    /* ============ Private Functions ============ */

    function clearAuctionState(address _set) private {
        delete auctions[_set];
    }

    function auction(address _set) private view returns(Auction.Setup storage) {
        return linearAuction(_set).auction;
    }

    function linearAuction(address _set) private view returns(LinearAuction.State storage) {
        return auctions[_set];
    }

    function requireValidSet(address _set) private view {
        require(
            core.validSets(_set),
            "LinearAuctionLiquidator: Invalid or disabled proposed SetToken address"
        );
    }
}