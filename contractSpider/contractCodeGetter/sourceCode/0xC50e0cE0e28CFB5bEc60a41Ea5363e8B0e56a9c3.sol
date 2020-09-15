/**
 *Submitted for verification at Etherscan.io on 2020-05-26
*/

/**
 *Submitted for verification at Etherscan.io on 2020-05-21
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

// File: set-protocol-contract-utils/contracts/lib/ScaleValidations.sol

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



library ScaleValidations {
    using SafeMath for uint256;

    uint256 private constant ONE_HUNDRED_PERCENT = 1e18;
    uint256 private constant ONE_BASIS_POINT = 1e14;

    function validateLessThanEqualOneHundredPercent(uint256 _value) internal view {
        require(_value <= ONE_HUNDRED_PERCENT, "Must be <= 100%");
    }

    function validateMultipleOfBasisPoint(uint256 _value) internal view {
        require(
            _value.mod(ONE_BASIS_POINT) == 0,
            "Must be multiple of 0.01%"
        );
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

// File: contracts/core/interfaces/IFeeCalculator.sol

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

// File: contracts/core/interfaces/IRebalancingSetTokenV2.sol

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

// File: contracts/core/fee-calculators/lib/PerformanceFeeLibrary.sol

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

// File: contracts/core/liquidators/impl/SetUSDValuation.sol

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
 * @title SetUSDValuation
 * @author Set Protocol
 *
 * Utility functions to derive the USD value of a Set and its components
 */
library SetUSDValuation {
    using SafeMath for uint256;
    using AddressArrayUtils for address[];

    uint256 constant public SET_FULL_UNIT = 10 ** 18;

    /* ============ SetToken Valuation Helpers ============ */


    /**
     * Calculates value of RebalancingSetToken.
     *
     * @return uint256        Streaming fee
     */
    function calculateRebalancingSetValue(
        address _rebalancingSetTokenAddress,
        IOracleWhiteList _oracleWhitelist
    )
        internal
        view
        returns (uint256)
    {
        IRebalancingSetTokenV2 rebalancingSetToken = IRebalancingSetTokenV2(_rebalancingSetTokenAddress);

        uint256 unitShares = rebalancingSetToken.unitShares();
        uint256 naturalUnit = rebalancingSetToken.naturalUnit();
        ISetToken currentSet = rebalancingSetToken.currentSet();

        // Calculate collateral value
        uint256 collateralValue = calculateSetTokenDollarValue(
            currentSet,
            _oracleWhitelist
        );

        // Value of rebalancing set is collateralValue times unitShares divided by naturalUnit
        return collateralValue.mul(unitShares).div(naturalUnit);
    }

    /*
     * Calculates the USD Value of a full unit Set Token
     *
     * @param  _set                 Instance of SetToken
     * @param  _oracleWhiteList     Instance of oracle whitelist
     * @return uint256              The USD value of the Set (in cents)
     */
    function calculateSetTokenDollarValue(
        ISetToken _set,
        IOracleWhiteList _oracleWhitelist
    )
        internal
        view
        returns (uint256)
    {
        uint256 setDollarAmount = 0;

        address[] memory components = _set.getComponents();
        uint256[] memory units = _set.getUnits();
        uint256 naturalUnit = _set.naturalUnit();

        // Loop through assets
        for (uint256 i = 0; i < components.length; i++) {
            address currentComponent = components[i];

            address oracle = _oracleWhitelist.getOracleAddressByToken(currentComponent);
            uint256 price = IOracle(oracle).read();
            uint256 decimals = ERC20Detailed(currentComponent).decimals();

            // Calculate dollar value of single component in Set
            uint256 tokenDollarValue = calculateTokenAllocationAmountUSD(
                price,
                naturalUnit,
                units[i],
                decimals
            );

            // Add value of single component to running component value tally
            setDollarAmount = setDollarAmount.add(tokenDollarValue);
        }

        return setDollarAmount;
    }

    /*
     * Get USD value of one component in a Set to 18 decimals
     *
     * @param  _tokenPrice          The 18 decimal value of one full token
     * @param  _naturalUnit         The naturalUnit of the set being component belongs to
     * @param  _unit                The unit of the component in the set
     * @param  _tokenDecimal        The component token's decimal value
     * @return uint256              The USD value of the component's allocation in the Set
     */
    function calculateTokenAllocationAmountUSD(
        uint256 _tokenPrice,
        uint256 _naturalUnit,
        uint256 _unit,
        uint256 _tokenDecimal
    )
        internal
        pure
        returns (uint256)
    {
        uint256 tokenFullUnit = 10 ** _tokenDecimal;

        // Calculate the amount of component base units are in one full set token
        uint256 componentUnitsInFullToken = SetMath.setToComponent(
            SET_FULL_UNIT,
            _unit,
            _naturalUnit
        );

        // Return value of component token in one full set token, to 18 decimals
        uint256 allocationUSDValue = _tokenPrice
            .mul(componentUnitsInFullToken)
            .div(tokenFullUnit);

        require(
            allocationUSDValue > 0,
            "SetUSDValuation.calculateTokenAllocationAmountUSD: Value must be > 0"
        );

        return allocationUSDValue;
    }
}

// File: contracts/core/fee-calculators/PerformanceFeeCalculator.sol

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
 * @title PerformanceFeeCalculator
 * @author Set Protocol
 *
 * Smart contract that stores and returns fees (represented as scaled decimal values). Fees are
 * determined based on performance of the Set and a streaming fee. Set values can be denominated
 * in any any asset based on oracle white list used in deploy.
 *
 * CHANGELOG:
 * - 5/17/2020: Update adjustFee function to update high watermark to prevent unexpected fee actualizations
 *              when the profitFee was initially 0. We also disallow changing the profit fee if the the fee period
 *              has not elapsed.
 */
contract PerformanceFeeCalculator is IFeeCalculator {

    using SafeMath for uint256;
    using CommonMath for uint256;

    /* ============ Enums ============ */

    enum FeeType { StreamingFee, ProfitFee }

    /* ============ Events ============ */

    event FeeActualization(
        address indexed rebalancingSetToken,
        uint256 newHighWatermark,
        uint256 profitFee,
        uint256 streamingFee
    );

    event FeeInitialization(
        address indexed rebalancingSetToken,
        uint256 profitFeePeriod,
        uint256 highWatermarkResetPeriod,
        uint256 profitFeePercentage,
        uint256 streamingFeePercentage,
        uint256 highWatermark,
        uint256 lastProfitFeeTimestamp,
        uint256 lastStreamingFeeTimestamp
    );

    event FeeAdjustment(
        address indexed rebalancingSetToken,
        FeeType feeType,
        uint256 newFeePercentage
    );

    /* ============ Structs ============ */

    struct InitFeeParameters {
        uint256 profitFeePeriod;
        uint256 highWatermarkResetPeriod;
        uint256 profitFeePercentage;
        uint256 streamingFeePercentage;
    }

    /* ============ Constants ============ */
    // 365.25 days used to represent the year
    uint256 private constant ONE_YEAR_IN_SECONDS = 365.25 days;
    uint256 private constant ONE_HUNDRED_PERCENT = 1e18;
    uint256 private constant ZERO = 0;

    /* ============ State Variables ============ */
    ICore public core;
    IOracleWhiteList public oracleWhiteList;
    uint256 public maximumProfitFeePercentage;
    uint256 public maximumStreamingFeePercentage;
    mapping(address => PerformanceFeeLibrary.FeeState) public feeState;

    /* ============ Constructor ============ */

    /**
     * Constructor function for PerformanceFeeCalculator
     *
     * @param _core                                 Core instance
     * @param _oracleWhiteList                      Oracle white list instance
     * @param _maximumProfitFeePercentage           Maximum percent of profit fee scaled by 1e18
     *                                              (e.g. 100% = 1e18 and 1% = 1e16)
     * @param _maximumStreamingFeePercentage        Maximum percent of streaming fee scaled by 1e18
     *                                              (e.g. 100% = 1e18 and 1% = 1e16)
     */
    constructor(
        ICore _core,
        IOracleWhiteList _oracleWhiteList,
        uint256 _maximumProfitFeePercentage,
        uint256 _maximumStreamingFeePercentage
    )
        public
    {
        core = _core;
        oracleWhiteList = _oracleWhiteList;
        maximumProfitFeePercentage = _maximumProfitFeePercentage;
        maximumStreamingFeePercentage = _maximumStreamingFeePercentage;
    }

    /* ============ External Functions ============ */

    /*
     * Called by RebalancingSetToken, parses bytedata then assigns to correct FeeState struct.
     *
     * @param  _feeCalculatorData       Bytestring encoding fee parameters for RebalancingSetToken
     */
    function initialize(
        bytes calldata _feeCalculatorData
    )
        external
    {
        // Parse fee data into struct
        InitFeeParameters memory parameters = parsePerformanceFeeCallData(_feeCalculatorData);

        // Validate fee data
        validateFeeParameters(parameters);
        uint256 highWatermark = SetUSDValuation.calculateRebalancingSetValue(msg.sender, oracleWhiteList);

        // Set fee state for new caller
        PerformanceFeeLibrary.FeeState storage feeInfo = feeState[msg.sender];

        feeInfo.profitFeePeriod = parameters.profitFeePeriod;
        feeInfo.highWatermarkResetPeriod = parameters.highWatermarkResetPeriod;
        feeInfo.profitFeePercentage = parameters.profitFeePercentage;
        feeInfo.streamingFeePercentage = parameters.streamingFeePercentage;
        feeInfo.lastProfitFeeTimestamp = block.timestamp;
        feeInfo.lastStreamingFeeTimestamp = block.timestamp;
        feeInfo.highWatermark = highWatermark;

        emit FeeInitialization(
            msg.sender,
            parameters.profitFeePeriod,
            parameters.highWatermarkResetPeriod,
            parameters.profitFeePercentage,
            parameters.streamingFeePercentage,
            highWatermark,
            block.timestamp,
            block.timestamp
        );
    }

    /*
     * Calculates total inflation percentage in order to accrue fees to manager. Profit fee calculations
     * are net of streaming fees, so streaming fees are applied first then profit fees are calculated.
     *
     * @return  uint256       Percent inflation of supply
     */
    function getFee()
        external
        view
        returns (uint256)
    {
        (
            uint256 streamingFee,
            uint256 profitFee
        ) = calculateFees(msg.sender);

        return streamingFee.add(profitFee);
    }

    /**
     * Returns calculated streaming and profit fee.
     *
     * @param  _setAddress          Address of Set to get fees
     * @return  uint256             Streaming Fee
     * @return  uint256             Profit Fee
     */
    function getCalculatedFees(
        address _setAddress
    )
        external
        view
        returns (uint256, uint256)
    {
        (
            uint256 streamingFee,
            uint256 profitFee
        ) = calculateFees(_setAddress);

        return (streamingFee, profitFee);
    }

    /*
     * Calculates total inflation percentage in order to accrue fees to manager. Profit fee calculations
     * are net of streaming fees, so streaming fees are applied first then profit fees are calculated.
     * Additionally, fee state is set timestamps are updated for each fee type and the high watermark is
     * reset if time since last profit fee exceeds the highWatermarkResetPeriod.
     *
     * @return  uint256       Percent inflation of supply
     */
    function updateAndGetFee()
        external
        returns (uint256)
    {
        (
            uint256 streamingFee,
            uint256 profitFee
        ) = calculateFees(msg.sender);

        // Update fee state based off fees collected
        updateFeeState(msg.sender, streamingFee, profitFee);

        emit FeeActualization(
            msg.sender,
            highWatermark(msg.sender),
            profitFee,
            streamingFee
        );

        return streamingFee.add(profitFee);
    }

    /*
     * Validate then set new streaming fee.
     *
     * @param  _newFeeData       Fee type and new streaming fee encoded in bytes
     */
    function adjustFee(
        bytes calldata _newFeeData
    )
        external
    {
        (
            FeeType feeIdentifier,
            uint256 feePercentage
        ) = parseNewFeeCallData(_newFeeData);

        // Since only two fee options and anything feeType integer passed that is not 0 or 1 will revert in
        // parsing can make this a simple if...else... statement
        if (feeIdentifier == FeeType.StreamingFee) {
            validateStreamingFeePercentage(feePercentage);

            feeState[msg.sender].streamingFeePercentage = feePercentage;
        } else {
            validateProfitFeePercentage(feePercentage);

            // IMPORTANT: In the case that a profit fee is initially 0 and is set to a non-zero number,
            // the actualizeFee / updateFeeState function does not update the high watermark
            // Thus, we need to reset the high water mark here so that users do not pay for profit fees
            // since inception.
            uint256 rebalancingSetValue = SetUSDValuation.calculateRebalancingSetValue(msg.sender, oracleWhiteList);
            uint256 existingHighwatermark = feeState[msg.sender].highWatermark;
            if (rebalancingSetValue > existingHighwatermark) {
                // In the case the profit fee period hasn't elapsed, disallow changing fees
                require(
                    exceedsProfitFeePeriod(msg.sender),
                    "PerformanceFeeCalculator.adjustFee: ProfitFeePeriod must have elapsed to update fee"
                );

                feeState[msg.sender].lastProfitFeeTimestamp = block.timestamp;
                feeState[msg.sender].highWatermark = rebalancingSetValue;
            }

            feeState[msg.sender].profitFeePercentage = feePercentage;
        }

        emit FeeAdjustment(msg.sender, feeIdentifier, feePercentage);
    }

    /* ============ Internal Functions ============ */

    /**
     * Updates fee state after a fee has been accrued. Streaming timestamp is always updated. Profit timestamp
     * is only updated if profit fee is collected. High watermark timestamp is updated if profit fee collected
     * or if a highWatermarkResetPeriod amount of time has passed since last profit fee collection.
     *
     * @param  _setAddress          Address of Set to have feeState updated
     * @param  _streamingFee        Calculated streaming fee percentage
     * @param  _profitFee           Calculated profit fee percentage
     */
    function updateFeeState(
        address _setAddress,
        uint256 _streamingFee,
        uint256 _profitFee
    )
        internal
    {
        // Set streaming fee timestamp
        feeState[_setAddress].lastStreamingFeeTimestamp = block.timestamp;

        uint256 rebalancingSetValue = SetUSDValuation.calculateRebalancingSetValue(_setAddress, oracleWhiteList);
        uint256 postStreamingValue = calculatePostStreamingValue(rebalancingSetValue, _streamingFee);

        // If profit fee then set new high watermark and profit fee timestamp
        if (_profitFee > 0) {
            feeState[_setAddress].lastProfitFeeTimestamp = block.timestamp;
            feeState[_setAddress].highWatermark = postStreamingValue;
        } else if (timeSinceLastProfitFee(_setAddress) >= highWatermarkResetPeriod(_setAddress)) {
            // If no profit fee and last profit fee was more than highWatermarkResetPeriod seconds ago then reset
            // high watermark
            feeState[_setAddress].highWatermark = postStreamingValue;
            feeState[_setAddress].lastProfitFeeTimestamp = block.timestamp;
        }
    }

    /*
     * Validates fee parameters. Ensures that both fees are below the max fee percentages and that they are
     * multiples of a basis point. Also makes sure highWatermarkResetPeriod is greater than profitFeePeriod.
     */
    function validateFeeParameters(
        InitFeeParameters memory parameters
    )
        internal
        view
    {
        // Validate fee amounts
        validateStreamingFeePercentage(parameters.streamingFeePercentage);
        validateProfitFeePercentage(parameters.profitFeePercentage);

        // WARNING: This require has downstream effects on security assumptions for updating and accruing fees.
        // Removing it allows highWatermarks to be reset, potentially cancelling fee collections or allowing traders
        // to apply higher profitFee to Set gains.
        require(
            parameters.highWatermarkResetPeriod >= parameters.profitFeePeriod,
            "PerformanceFeeCalculator.validateFeeParameters: Fee collection frequency must exceed highWatermark reset."
        );
    }

    /*
     * Validates streaming fee is less than maximum allowed and multiple of basis point.
     */
    function validateStreamingFeePercentage(
        uint256 _streamingFee
    )
        internal
        view
    {
        require(
            _streamingFee <= maximumStreamingFeePercentage,
            "PerformanceFeeCalculator.validateStreamingFeePercentage: Streaming fee exceeds maximum."
        );

        ScaleValidations.validateMultipleOfBasisPoint(_streamingFee);
    }

    /*
     * Validates profit fee is less than maximum allowed and multiple of basis point.
     */
    function validateProfitFeePercentage(
        uint256 _profitFee
    )
        internal
        view
    {
        require(
            _profitFee <= maximumProfitFeePercentage,
            "PerformanceFeeCalculator.validateProfitFeePercentage: Profit fee exceeds maximum."
        );

        ScaleValidations.validateMultipleOfBasisPoint(_profitFee);
    }

    /**
     * Verifies caller is valid Set. Calculates and returns streaming and profit fee.
     *
     * @param  _setAddress          Address of Set to have feeState updated
     * @return  uint256             Streaming Fee
     * @return  uint256             Profit Fee
     */
    function calculateFees(
        address _setAddress
    )
        internal
        view
        returns (uint256, uint256)
    {
        require(
            core.validSets(_setAddress),
            "PerformanceFeeCalculator.calculateFees: Caller must be valid RebalancingSetToken."
        );

        uint256 streamingFee = calculateStreamingFee(_setAddress);

        uint256 profitFee = calculateProfitFee(_setAddress, streamingFee);

        return (streamingFee, profitFee);
    }

    /**
     * Calculates streaming fee by multiplying streamingFeePercentage by the elapsed amount of time since the last fee
     * was collected divided by one year in seconds, since the fee is a yearly fee.
     *
     * @param  _setAddress          Address of Set to have feeState updated
     * @return uint256              Streaming fee
     */
    function calculateStreamingFee(
        address _setAddress
    )
        internal
        view
        returns(uint256)
    {
        uint256 timeSinceLastFee = block.timestamp.sub(lastStreamingFeeTimestamp(_setAddress));

        // Streaming fee is streaming fee times years since last fee
        return timeSinceLastFee.mul(streamingFeePercentage(_setAddress)).div(ONE_YEAR_IN_SECONDS);
    }

    /**
     * Calculates profit fee net of streaming fee. Value of rebalancing Set is determined then streaming fee subtracted,
     * to get postStreamingValue. This value is compared to the highWatermark, if greater than highWatermark multiply by
     * profitFeePercentage and divide by rebalancingSetValue to get inflation from profit fees. If postStreamingValue does
     * not exceed highWatermark then return 0.
     *
     * @param  _setAddress          Address of Set to have feeState updated
     * @param  _streamingFee        Calculated streaming fee percentage
     * @return uint256              Streaming fee
     */
    function calculateProfitFee(
        address _setAddress,
        uint256 _streamingFee
    )
        internal
        view
        returns(uint256)
    {
        // If time since last profit fee exceeds profitFeePeriod then calculate profit fee else 0.
        if (exceedsProfitFeePeriod(_setAddress)) {
            // Calculate post streaming value and get high watermark
            uint256 rebalancingSetValue = SetUSDValuation.calculateRebalancingSetValue(_setAddress, oracleWhiteList);
            uint256 postStreamingValue = calculatePostStreamingValue(rebalancingSetValue, _streamingFee);
            uint256 highWatermark = highWatermark(_setAddress);

            // Subtract high watermark from post streaming fee value, unless less than 0 set to 0
            uint256 gainedValue = postStreamingValue > highWatermark ? postStreamingValue.sub(highWatermark) : 0;

            // Determine percent fee in terms of current rebalancing Set value
            return gainedValue.mul(profitFeePercentage(_setAddress)).div(rebalancingSetValue);
        } else {
            return 0;
        }
    }

   /**
     * Calculates Rebalancing Set Token value after streaming fees accounted for.
     *
     * @param  _rebalancingSetValue         Pre-fee value of Set
     * @param  _streamingFee                Calculated streaming fee percentage
     * @return  uint256                     Post streaming fee value
     */
    function calculatePostStreamingValue(
        uint256 _rebalancingSetValue,
        uint256 _streamingFee
    )
        internal
        view
        returns (uint256)
    {
        return _rebalancingSetValue.sub(_rebalancingSetValue.mul(_streamingFee).deScale());
    }

    /**
     * Checks if time since last profit fee exceeds profitFeePeriod
     *
     * @return  bool
     */
    function exceedsProfitFeePeriod(address _set) internal view returns (bool) {
        return timeSinceLastProfitFee(_set) > profitFeePeriod(_set);
    }

    /**
     * Checks if time since last profit fee exceeds profitFeePeriod
     *
     * @return  uint256     Time since last profit fee accrued
     */
    function timeSinceLastProfitFee(address _set) internal view returns (uint256) {
        return block.timestamp.sub(lastProfitFeeTimestamp(_set));
    }

    function lastStreamingFeeTimestamp(address _set) internal view returns (uint256) {
        return feeState[_set].lastStreamingFeeTimestamp;
    }

    function lastProfitFeeTimestamp(address _set) internal view returns (uint256) {
        return feeState[_set].lastProfitFeeTimestamp;
    }

    function streamingFeePercentage(address _set) internal view returns (uint256) {
        return feeState[_set].streamingFeePercentage;
    }

    function profitFeePercentage(address _set) internal view returns (uint256) {
        return feeState[_set].profitFeePercentage;
    }

    function profitFeePeriod(address _set) internal view returns (uint256) {
        return feeState[_set].profitFeePeriod;
    }

    function highWatermark(address _set) internal view returns(uint256) {
        return feeState[_set].highWatermark;
    }

    function highWatermarkResetPeriod(address _set) internal view returns(uint256) {
        return feeState[_set].highWatermarkResetPeriod;
    }

    /* ============ Private Functions ============ */

    /**
     * Parses passed in fee parameters from bytestring.
     *
     * | CallData                     | Location                      |
     * |------------------------------|-------------------------------|
     * | profitFeePeriod              | 32                            |
     * | highWatermarkResetPeriod     | 64                            |
     * | profitFeePercentage          | 96                            |
     * | streamingFeePercentage       | 128                           |
     *
     * @param  _callData            Byte string containing fee parameter data
     * @return feeParameters        Fee parameters
     */
    function parsePerformanceFeeCallData(
        bytes memory _callData
    )
        private
        pure
        returns (InitFeeParameters memory)
    {
        return abi.decode (_callData, (InitFeeParameters));
    }

    /**
     * Parses passed in fee parameters from bytestring. If passed feeType number exceeds number of
     *  enum items function will revert.
     *
     * | CallData                     | Location                      |
     * |------------------------------|-------------------------------|
     * | feeType                      | 32                            |
     * | feePercentage                | 64                            |
     *
     * @param  _callData            Byte string containing fee parameter data
     * @return feeParameters        Fee parameters
     */
    function parseNewFeeCallData(
        bytes memory _callData
    )
        private
        pure
        returns (FeeType, uint256)
    {
        (
            uint8 feeType,
            uint256 feePercentage
        ) = abi.decode (_callData, (uint8, uint256));

        require(
            feeType < 2,
            "PerformanceFeeCalculator.parseNewFeeCallData: Fee type invalid"
        );

        return (FeeType(feeType), feePercentage);
    }
}