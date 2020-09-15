/**
 *Submitted for verification at Etherscan.io on 2020-04-28
*/

pragma solidity ^0.5.2;
pragma experimental "ABIEncoderV2";
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

// File: set-protocol-contracts/contracts/lib/CommonMath.sol

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

// File: set-protocol-contracts/contracts/core/interfaces/ICore.sol

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

// File: set-protocol-contracts/contracts/core/lib/SetTokenLibrary.sol

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






library SetTokenLibrary {
    using SafeMath for uint256;

    struct SetDetails {
        uint256 naturalUnit;
        address[] components;
        uint256[] units;
    }

    /**
     * Validates that passed in tokens are all components of the Set
     *
     * @param _set                      Address of the Set
     * @param _tokens                   List of tokens to check
     */
    function validateTokensAreComponents(
        address _set,
        address[] calldata _tokens
    )
        external
        view
    {
        for (uint256 i = 0; i < _tokens.length; i++) {
            // Make sure all tokens are members of the Set
            require(
                ISetToken(_set).tokenIsComponent(_tokens[i]),
                "SetTokenLibrary.validateTokensAreComponents: Component must be a member of Set"
            );

        }
    }

    /**
     * Validates that passed in quantity is a multiple of the natural unit of the Set.
     *
     * @param _set                      Address of the Set
     * @param _quantity                 Quantity to validate
     */
    function isMultipleOfSetNaturalUnit(
        address _set,
        uint256 _quantity
    )
        external
        view
    {
        require(
            _quantity.mod(ISetToken(_set).naturalUnit()) == 0,
            "SetTokenLibrary.isMultipleOfSetNaturalUnit: Quantity is not a multiple of nat unit"
        );
    }

    /**
     * Validates that passed in quantity is a multiple of the natural unit of the Set.
     *
     * @param _core                     Address of Core
     * @param _set                      Address of the Set
     */
    function requireValidSet(
        ICore _core,
        address _set
    )
        internal
        view
    {
        require(
            _core.validSets(_set),
            "SetTokenLibrary: Must be an approved SetToken address"
        );
    }

    /**
     * Retrieves the Set's natural unit, components, and units.
     *
     * @param _set                      Address of the Set
     * @return SetDetails               Struct containing the natural unit, components, and units
     */
    function getSetDetails(
        address _set
    )
        internal
        view
        returns (SetDetails memory)
    {
        // Declare interface variables
        ISetToken setToken = ISetToken(_set);

        // Fetch set token properties
        uint256 naturalUnit = setToken.naturalUnit();
        address[] memory components = setToken.getComponents();
        uint256[] memory units = setToken.getUnits();

        return SetDetails({
            naturalUnit: naturalUnit,
            components: components,
            units: units
        });
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

// File: contracts/managers/lib/AllocatorMathLibrary.sol

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
 * @title AllocatorMathLibrary
 * @author Set Protocol
 *
 * Library containing math helper function for Allocator.
 */
library AllocatorMathLibrary {
    using SafeMath for uint256;

    /*
     * Rounds passed value to the nearest power of 2.
     *
     * @param  _value         Value to be rounded to nearest power of 2
     * @return uint256        Rounded value
     */
    function roundToNearestPowerOfTwo(
        uint256 _value
    )
        internal
        pure
        returns (uint256)
    {
        // Multiply by 1.5 to roughly approximate sqrt(2). Needed to round to nearest power of two.
        uint256 scaledValue = _value.mul(3) >> 1;
        uint256 nearestValue = 1;

        // Calculate nearest power of two
        if (scaledValue >= 0x100000000000000000000000000000000) { scaledValue >>= 128; nearestValue <<= 128; }
        if (scaledValue >= 0x10000000000000000) { scaledValue >>= 64; nearestValue <<= 64; }
        if (scaledValue >= 0x100000000) { scaledValue >>= 32; nearestValue <<= 32; }
        if (scaledValue >= 0x10000) { scaledValue >>= 16; nearestValue <<= 16; }
        if (scaledValue >= 0x100) { scaledValue >>= 8; nearestValue <<= 8; }
        if (scaledValue >= 0x10) { scaledValue >>= 4; nearestValue <<= 4; }
        if (scaledValue >= 0x4) { scaledValue >>= 2; nearestValue <<= 2; }
        if (scaledValue >= 0x2) nearestValue <<= 1; // No need to shift x anymore

        return nearestValue;
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
            "AllocatorMathLibrary.ceilLog10: Value must be greater than zero."
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

    /*
     * Round up division by subtracting one from numerator, dividing, then adding one.
     *
     * @param  _numerator         Numerator of expression
     * @param  _denominator       Denominator of expression
     * @return uint256            Output value
     */
    function roundUpDivision(
        uint256 _numerator,
        uint256 _denominator
    )
        internal
        pure
        returns (uint256)
    {
        return _numerator.sub(1).div(_denominator).add(1);
    }
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

// File: set-protocol-oracles/contracts/external/DappHub/interfaces/IMedian.sol

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
 * @title IMedian
 * @author Set Protocol
 *
 * Interface for operating with a price feed Medianizer contract
 */
interface IMedian {

    /**
     * Returns the current price set on the medianizer. Throws if the price is set to 0 (initialization)
     *
     * @return  Current price of asset represented in hex as bytes32
     */
    function read()
        external
        view
        returns (bytes32);

    /**
     * Returns the current price set on the medianizer and whether the value has been initialized
     *
     * @return  Current price of asset represented in hex as bytes32, and whether value is non-zero
     */
    function peek()
        external
        view
        returns (bytes32, bool);
}

// File: contracts/managers/lib/FlexibleTimingManagerLibrary.sol

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
 * @title FlexibleTimingManagerLibrary
 * @author Set Protocol
 *
 * The FlexibleTimingManagerLibrary contains functions for helping Managers create proposals
 *
 */
library FlexibleTimingManagerLibrary {
    using SafeMath for uint256;

    /*
     * Validates whether the Rebalancing Set is in the correct state and sufficient time has elapsed.
     *
     * @param  _rebalancingSetInterface      Instance of the Rebalancing Set Token
     */
    function validateManagerPropose(
        IRebalancingSetToken _rebalancingSetInterface
    )
        internal
    {
        // Require that enough time has passed from last rebalance
        uint256 lastRebalanceTimestamp = _rebalancingSetInterface.lastRebalanceTimestamp();
        uint256 rebalanceInterval = _rebalancingSetInterface.rebalanceInterval();
        require(
            block.timestamp >= lastRebalanceTimestamp.add(rebalanceInterval),
            "FlexibleTimingManagerLibrary.proposeNewRebalance: Rebalance interval not elapsed"
        );

        // Require that Rebalancing Set Token is in Default state, won't allow for re-proposals
        // because malicious actor could prevent token from ever rebalancing
        require(
            _rebalancingSetInterface.rebalanceState() == RebalancingLibrary.State.Default,
            "FlexibleTimingManagerLibrary.proposeNewRebalance: State must be in Default"
        );
    }

    /*
    /*
     * Calculates the auction price parameters, targetting 1% slippage every 10 minutes. Fair value
     * placed in middle of price range.
     *
     * @param  _currentSetDollarAmount      The 18 decimal value of one currenSet
     * @param  _nextSetDollarAmount         The 18 decimal value of one nextSet
     * @param  _timeIncrement               Amount of time to explore 1% of fair value price change
     * @param  _auctionLibraryPriceDivisor  The auction library price divisor
     * @param  _auctionTimeToPivot          The auction time to pivot
     * @return uint256                      The auctionStartPrice for rebalance auction
     * @return uint256                      The auctionPivotPrice for rebalance auction
     */
    function calculateAuctionPriceParameters(
        uint256 _currentSetDollarAmount,
        uint256 _nextSetDollarAmount,
        uint256 _timeIncrement,
        uint256 _auctionLibraryPriceDivisor,
        uint256 _auctionTimeToPivot
    )
        internal
        view
        returns (uint256, uint256)
    {
        // Determine fair value of nextSet/currentSet and put in terms of auction library price divisor
        uint256 fairValue = _nextSetDollarAmount.mul(_auctionLibraryPriceDivisor).div(_currentSetDollarAmount);
        // Calculate how much one percent slippage from fair value is
        uint256 onePercentSlippage = fairValue.div(100);

        // Calculate how many time increments are in auctionTimeToPivot
        uint256 timeIncrements = _auctionTimeToPivot.div(_timeIncrement);
        // Since we are targeting a 1% slippage every time increment the price range is defined as
        // the price of a 1% move multiplied by the amount of time increments in the auctionTimeToPivot
        // This value is then divided by two to get half the price range
        uint256 halfPriceRange = timeIncrements.mul(onePercentSlippage).div(2);

        // Auction start price is fair value minus half price range to center the auction at fair value
        uint256 auctionStartPrice = fairValue.sub(halfPriceRange);
        // Auction pivot price is fair value plus half price range to center the auction at fair value
        uint256 auctionPivotPrice = fairValue.add(halfPriceRange);

        return (auctionStartPrice, auctionPivotPrice);
    }

    /*
     * Query the Medianizer price feeds for a value that is returned as a Uint. Prices
     * have 18 decimals.
     *
     * @param  _priceFeedAddress            Address of the medianizer price feed
     * @return uint256                      The price from the price feed with 18 decimals
     */
    function queryPriceData(
        address _priceFeedAddress
    )
        internal
        view
        returns (uint256)
    {
        // Get prices from oracles
        bytes32 priceInBytes = IMedian(_priceFeedAddress).read();

        return uint256(priceInBytes);
    }

    /*
     * Calculates the USD Value of a Set Token - by taking the individual token prices, units
     * and decimals.
     *
     * @param  _tokenPrices         The 18 decimal values of components
     * @param  _naturalUnit         The naturalUnit of the set being component belongs to
     * @param  _units               The units of the components in the Set
     * @param  _tokenDecimals       The components decimal values
     * @return uint256              The USD value of the Set (in cents)
     */
    function calculateSetTokenDollarValue(
        uint256[] memory _tokenPrices,
        uint256 _naturalUnit,
        uint256[] memory _units,
        uint256[] memory _tokenDecimals
    )
        internal
        view
        returns (uint256)
    {
        uint256 setDollarAmount = 0;

        // Loop through assets
        for (uint256 i = 0; i < _tokenPrices.length; i++) {
            uint256 tokenDollarValue = calculateTokenAllocationAmountUSD(
                _tokenPrices[i],
                _naturalUnit,
                _units[i],
                _tokenDecimals[i]
            );

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
     * @param  _tokenDecimals       The component token's decimal value
     * @return uint256              The USD value of the component's allocation in the Set
     */
    function calculateTokenAllocationAmountUSD(
        uint256 _tokenPrice,
        uint256 _naturalUnit,
        uint256 _unit,
        uint256 _tokenDecimals
    )
        internal
        view
        returns (uint256)
    {
        uint256 SET_TOKEN_DECIMALS = 18;

        // Calculate the amount of component base units are in one full set token
        uint256 componentUnitsInFullToken = _unit
            .mul(10 ** SET_TOKEN_DECIMALS)
            .div(_naturalUnit);

        // Return value of component token in one full set token, to 18 decimals
        uint256 allocationUSDValue = _tokenPrice
            .mul(componentUnitsInFullToken)
            .div(10 ** _tokenDecimals);

        require(
            allocationUSDValue > 0,
            "FlexibleTimingManagerLibrary.calculateTokenAllocationAmountUSD: Value must be > 0"
        );

        return allocationUSDValue;
    }
}

// File: contracts/managers/allocators/IAllocator.sol

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
 * @title IAllocator
 * @author Set Protocol
 *
 * Interface for interacting with Allocator contracts
 */
interface IAllocator {

    /*
     * Determine the next allocation to rebalance into.
     *
     * @param  _targetBaseAssetAllocation       Target allocation of the base asset
     * @param  _allocationPrecision             Precision of allocation percentage
     * @param  _currentCollateralSet            Instance of current set collateralizing RebalancingSetToken
     * @return address                          The address of the proposed nextSet
     */
    function determineNewAllocation(
        uint256 _targetBaseAssetAllocation,
        uint256 _allocationPrecision,
        ISetToken _currentCollateralSet
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

// File: contracts/managers/allocators/BinaryAllocator.sol

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
 * @title BinaryAllocator
 * @author Set Protocol
 *
 * Implementing IAllocator the BinaryAllocator flips between two all or nothing
 * allocations of the base asset depending what allocation the calling manager is seeking. In
 * addition, if either collateral Set becomes 4x more valuable than the other the contract will
 * create a new collateral Set and use that Set going forward.
 */
contract BinaryAllocator is
    IAllocator
{
    using SafeMath for uint256;

    /* ============ Events ============ */

    event NewCollateralTracked(
        bytes32 indexed _hash,
        address indexed _collateralAddress
    );

    /* ============ Constants ============ */
    uint256 constant public MINIMUM_COLLATERAL_NATURAL_UNIT_DECIMALS = 6;

    /* ============ State Variables ============ */
    ICore public core;
    address public setTokenFactory;

    ERC20Detailed public baseAsset;
    ERC20Detailed public quoteAsset;
    IOracle public baseAssetOracle;
    IOracle public quoteAssetOracle;
    uint8 public baseAssetDecimals;
    uint8 public quoteAssetDecimals;

    // Hash of collateral units, naturalUnit, and component maps to collateral address
    mapping(bytes32 => ISetToken) public storedCollateral;

    /*
     * BinaryAllocator constructor.
     *
     * @param  _baseAsset                   The baseAsset address
     * @param  _quoteAsset                  The quoteAsset address
     * @param  _baseAssetOracle             The baseAsset oracle
     * @param  _quoteAssetOracle            The quoteAsset oracle
     * @param  _baseAssetCollateral         The baseAsset collateral Set
     * @param  _quoteAssetCollateral        The quoteAsset collateral Set
     * @param  _core                        The address of the Core contract
     * @param  _setTokenFactory             The address of SetTokenFactory used to create new collateral
     */
    constructor(
        ERC20Detailed _baseAsset,
        ERC20Detailed _quoteAsset,
        IOracle _baseAssetOracle,
        IOracle _quoteAssetOracle,
        ISetToken _baseAssetCollateral,
        ISetToken _quoteAssetCollateral,
        ICore _core,
        address _setTokenFactory
    )
        public
    {
        // Get components of collateral instances
        address[] memory baseAssetCollateralComponents = _baseAssetCollateral.getComponents();
        address[] memory quoteAssetCollateralComponents = _quoteAssetCollateral.getComponents();

        // Check that component arrays only have one component
        validateSingleItemArray(baseAssetCollateralComponents);
        validateSingleItemArray(quoteAssetCollateralComponents);

        // Make sure collateral instances are using the correct base and quote asset
        require(
            baseAssetCollateralComponents[0] == address(_baseAsset),
            "BinaryAllocator.constructor: Base collateral component must match base asset."
        );

        require(
            quoteAssetCollateralComponents[0] == address(_quoteAsset),
            "BinaryAllocator.constructor: Quote collateral component must match quote asset."
        );

        baseAsset = _baseAsset;
        quoteAsset = _quoteAsset;

        baseAssetOracle = _baseAssetOracle;
        quoteAssetOracle = _quoteAssetOracle;

        // Query decimals of base and quote assets
        baseAssetDecimals = _baseAsset.decimals();
        quoteAssetDecimals = _quoteAsset.decimals();

        // Set Core and setTokenFactory
        core = _core;
        setTokenFactory = _setTokenFactory;

        // Store passed in collateral in mapping
        bytes32 baseCollateralHash = calculateCollateralIDHashFromSet(
            _baseAssetCollateral
        );
        bytes32 quoteCollateralHash = calculateCollateralIDHashFromSet(
            _quoteAssetCollateral
        );
        storedCollateral[baseCollateralHash] = _baseAssetCollateral;
        storedCollateral[quoteCollateralHash] = _quoteAssetCollateral;

        emit NewCollateralTracked(baseCollateralHash, address(_baseAssetCollateral));
        emit NewCollateralTracked(quoteCollateralHash, address(_quoteAssetCollateral));
    }

    /* ============ External ============ */

    /*
     * Determine the next allocation to rebalance into. If the dollar value of the two collateral sets is more
     * than 4x different from each other then create a new collateral set. If currently 100% in baseAsset then
     * a new quote collateral set is created if 0% in baseAsset then a new base collateral set is created.
     *
     * @param  _targetBaseAssetAllocation       Target allocation of the base asset
     * @param  _allocationPrecision             Precision of allocation percentage
     * @param  _currentCollateralSet            Instance of current set collateralizing RebalancingSetToken
     * @return address                          The address of the proposed nextSet
     */
    function determineNewAllocation(
        uint256 _targetBaseAssetAllocation,
        uint256 _allocationPrecision,
        ISetToken _currentCollateralSet
    )
        external
        returns (ISetToken)
    {
        require(
            _targetBaseAssetAllocation == _allocationPrecision || _targetBaseAssetAllocation == 0,
            "BinaryAllocator.determineNewAllocation: Passed allocation must be equal to allocationPrecision or 0."
        );

        // Determine if rebalance is to the baseAsset
        bool toBaseAsset = (_targetBaseAssetAllocation == _allocationPrecision);

        validateCurrentCollateralSet(
            _currentCollateralSet,
            toBaseAsset
        );

        // Calculate currentSetValue, toBaseAsset inverted here because calculating currentSet value which would be
        // using opposite collateral asset of toBaseAsset
        uint256 currentSetValue = calculateCollateralSetValueInternal(
            address(_currentCollateralSet),
            !toBaseAsset
        );

        // Check to see if new collateral must be created in order to keep collateral price ratio in line.
        // If not just return the dollar value of current collateral sets
        (
            ERC20Detailed nextSetComponent,
            uint256 nextSetUnit,
            uint256 nextSetNaturalUnit
        ) = calculateNextCollateralParameters(
            currentSetValue,
            toBaseAsset
        );

        ISetToken nextSet = createOrSelectNextSet(
            nextSetComponent,
            nextSetUnit,
            nextSetNaturalUnit
        );

        return nextSet;
    }

    /*
     * Calculate value of passed collateral set.
     *
     * @param  _collateralSet         of current set collateralizing RebalancingSetToken
     * @return uint256               USD value of passed Set
     */
    function calculateCollateralSetValue(
        ISetToken _collateralSet
    )
        external
        view
        returns (uint256)
    {
        address[] memory setComponents = _collateralSet.getComponents();

        // Check that setComponents only has one component
        validateSingleItemArray(setComponents);

        return calculateCollateralSetValueInternal(
            address(_collateralSet),
            setComponents[0] == address(baseAsset)
        );
    }

    /* ============ Internal ============ */

    /*
     * Create CollateralIDHash based on nextSet parameters. If hash already exists then use collateral
     * set associated with that hash. If hash does not already exist then create new collateral set and
     * store in storedCollateral mapping.
     *
     * @param  _nextSetComponent        Component of nextSet
     * @param  _nextSetUnit             Unit of nextSet
     * @param  _nextSetNaturalUnit      NaturalUnit of nextSet
     * @return address                  Address of nextSet
     */
    function createOrSelectNextSet(
        ERC20Detailed _nextSetComponent,
        uint256 _nextSetUnit,
        uint256 _nextSetNaturalUnit
    )
        internal
        returns (ISetToken)
    {
        // Create collateralIDHash
        bytes32 collateralIDHash = calculateCollateralIDHash(
            _nextSetUnit,
            _nextSetNaturalUnit,
            address(_nextSetComponent)
        );

        // If collateralIDHash exists then use existing collateral set otherwise create new collateral and
        // store in mapping
        if (address(storedCollateral[collateralIDHash]) != address(0)) {
            return storedCollateral[collateralIDHash];
        } else {
            // Determine new collateral name and symbol
            (
                bytes32 nextCollateralName,
                bytes32 nextCollateralSymbol
            ) = _nextSetComponent == baseAsset ? (bytes32("BaseAssetCollateral"), bytes32("BACOL")) :
                (bytes32("QuoteAssetCollateral"), bytes32("QACOL"));

            // Create unit and component arrays for SetToken creation
            uint256[] memory nextSetUnits = new uint256[](1);
            address[] memory nextSetComponents = new address[](1);
            nextSetUnits[0] = _nextSetUnit;
            nextSetComponents[0] = address(_nextSetComponent);

            // Create new collateral set with passed components, units, and naturalUnit
            address nextSetAddress = core.createSet(
                setTokenFactory,
                nextSetComponents,
                nextSetUnits,
                _nextSetNaturalUnit,
                nextCollateralName,
                nextCollateralSymbol,
                ""
            );

            // Store new collateral in mapping
            storedCollateral[collateralIDHash] = ISetToken(nextSetAddress);

            emit NewCollateralTracked(collateralIDHash, nextSetAddress);

            return ISetToken(nextSetAddress);
        }
    }

    /*
     * Validate passed parameters to make sure target allocation is either 0 or 100 and that the currentSet
     * was created by core and is made up of the correct component. Finally, return a boolean indicating
     * whether new allocation should be in baseAsset.
     *
     * @param  _currentCollateralSet            Instance of current set collateralizing RebalancingSetToken
     * @param  _toBaseAsset                     Boolean indicating whether new collateral is made of baseAsset
     */
    function validateCurrentCollateralSet(
        ISetToken _currentCollateralSet,
        bool _toBaseAsset
    )
        internal
        view
    {
        // Make sure passed currentSet was created by Core
        require(
            core.validSets(address(_currentCollateralSet)),
            "BinaryAllocator.validateCurrentCollateralSet: Passed collateralSet must be tracked by Core."
        );

        // Get current set components
        address[] memory currentSetComponents = _currentCollateralSet.getComponents();

        // Make sure current set component array is one item long
        require(
            currentSetComponents.length == 1,
            "BinaryAllocator.validateCurrentCollateralSet: Passed collateral set must have one component."
        );

        // Make sure that currentSet component is opposite of expected component to be rebalanced into
        address requiredComponent = _toBaseAsset ? address(quoteAsset) : address(baseAsset);
        require(
            currentSetComponents[0] == requiredComponent,
            "BinaryAllocator.validateCurrentCollateralSet: New allocation doesn't match currentSet component."
        );
    }

    /*
     * Calculate value of passed collateral set.
     *
     * @param  _currentCollateralSet        Instance of current set collateralizing RebalancingSetToken
     * @param  _usingBaseAsset              Boolean indicating whether collateral set uses base asset
     * @return uint256                      USD value of passed Set
     */
    function calculateCollateralSetValueInternal(
        address _collateralSet,
        bool _usingBaseAsset
    )
        internal
        view
        returns (uint256)
    {
        // Gather price and decimal information for current collateral component
        (
            uint256 currentComponentPrice,
            uint256 currentComponentDecimals
        ) = getComponentPriceAndDecimalData(_usingBaseAsset);

        // Get currentSet Details and use to value passed currentSet
        SetTokenLibrary.SetDetails memory currentSetDetails = SetTokenLibrary.getSetDetails(
            address(_collateralSet)
        );

        // Calculate collateral set value
        return FlexibleTimingManagerLibrary.calculateTokenAllocationAmountUSD(
            currentComponentPrice,
            currentSetDetails.naturalUnit,
            currentSetDetails.units[0],
            currentComponentDecimals
        );
    }

    /*
     * Calculate new collateral units and natural unit. Return new component address The system of
     * equations to determine unit and naturalUnit is as follows:
     *
     * naturalUnit = 10 ** k
     * unit = log2(round(10^(d + k - 18) * V / P))
     * k = max(6, log10(10^(18 - d) * P / V), 18-d)
     *
     * Where d is the decimals of the new component, P is the price of the new component, and V is the
     * target value of the new Set.
     *
     * Implementation for k will be split as such,
     * kOne = max(6, 18-d)
     * kTwo = log10(10^(18 - d) * P / V)
     * k = max(kOne, kTwo)
     *
     * @param  _targetCollateralUSDValue      USD Value of current collateral set
     * @param  _newComponentPrice             Price of underlying token to be rebalanced into
     * @param  _newComponentDecimals          Amount of decimals in replacement token
     * @return ERCDetailed                    Instance of new collateral component
     * @return uint256                        Units for new collateral set
     * @return uint256                        NaturalUnit for new collateral set
     */
    function calculateNextCollateralParameters(
        uint256 _currentSetValue,
        bool _toBaseAsset
    )
        internal
        view
        returns (ERC20Detailed, uint256, uint256)
    {
        // Gather price and decimal information for next collateral components
        (
            uint256 nextSetComponentPrice,
            uint8 nextSetComponentDecimals
        ) = getComponentPriceAndDecimalData(_toBaseAsset);

        // Determine minimum natural unit based on max of pre-defined minimum or (18 - decimals) of the
        // component in the new Set.
        uint256 kOne = Math.max(
            MINIMUM_COLLATERAL_NATURAL_UNIT_DECIMALS,
            uint256(18).sub(nextSetComponentDecimals)
        );

        // Intermediate step to calculate kTwo
        uint256 intermediate = AllocatorMathLibrary.roundUpDivision(
            CommonMath.safePower(uint256(10), uint256(18).sub(nextSetComponentDecimals)).mul(nextSetComponentPrice),
            _currentSetValue
        );

        // Complete kTwo calculation by taking ceil(log10()) of intermediate
        uint256 kTwo = AllocatorMathLibrary.ceilLog10(intermediate);

        // k is max of kOne and kTwo
        uint256 k = Math.max(kOne, kTwo);

        // Get raw unit amount for nextSet
        uint256 unroundedNextUnit = (uint256(10) ** uint256(nextSetComponentDecimals + k - 18))
            .mul(_currentSetValue)
            .div(nextSetComponentPrice);

        // Round raw nextSet unit to nearest power of 2
        uint256 nextSetUnit = AllocatorMathLibrary.roundToNearestPowerOfTwo(
            unroundedNextUnit
        );

        // Get nextSetComponent
        ERC20Detailed nextSetComponent = _toBaseAsset ? baseAsset : quoteAsset;

        return (nextSetComponent, nextSetUnit, CommonMath.safePower(10, k));
    }

    /*
     * Gets price and decimal information for component based on if looking for base or quote asset data
     *
     * @param  _usingBaseAsset         Boolean indicating whether to get information for base asset
     * @return uint256                 USD Price of component
     * @return uint8                   Decimal of component
     */
    function getComponentPriceAndDecimalData(
        bool _usingBaseAsset
    )
        internal
        view
        returns (uint256, uint8)
    {
        // If using base asset return baseAsset price and decimals and vice versa
        if (_usingBaseAsset) {
            return (baseAssetOracle.read(), baseAssetDecimals);
        } else {
            return (quoteAssetOracle.read(), quoteAssetDecimals);
        }
    }

    /*
     * Creates a CollateralIDHash from a passed SetToken instance.
     *
     * @param  _setToken         SetToken to make CollateralIDHash of
     * @return bytes32           CollateralIDHash of SetToken
     */
    function calculateCollateralIDHashFromSet(
        ISetToken _setToken
    )
        internal
        view
        returns (bytes32)
    {
        // Get SetToken details for use in calculating collateralIDHash
        SetTokenLibrary.SetDetails memory setDetails = SetTokenLibrary.getSetDetails(
            address(_setToken)
        );

        // Calculate CollateralIDHash
        return calculateCollateralIDHash(
            setDetails.units[0],
            setDetails.naturalUnit,
            setDetails.components[0]
        );
    }

    /*
     * Creates a CollateralIDHash from passed SetToken parameters.
     *
     * @param  _units           Units of SetToken
     * @param  _naturalUnit     NaturalUnit of SetToken
     * @param  _component       Component of SetToken
     * @return bytes32          CollateralIDHash of SetToken
     */
    function calculateCollateralIDHash(
        uint256 _units,
        uint256 _naturalUnit,
        address _component
    )
        internal
        pure
        returns (bytes32)
    {
        return keccak256(
            abi.encodePacked(
                _units,
                _naturalUnit,
                _component
            )
        );
    }

    /*
     * Check that passed component array contains one component, else revert.
     *
     * @param  _array     Array to be evaluated
     */
    function validateSingleItemArray(
        address[] memory _array
    )
        internal
        pure
    {
        require(
            _array.length == 1,
            "BinaryAllocator.validateSingleItemArray: Array contains more than one component."
        );
    }
}