/**
 *Submitted for verification at Etherscan.io on 2020-06-05
*/

/**
 *Submitted for verification at Etherscan.io on 2020-05-27
*/

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

pragma solidity ^0.5.2;
pragma experimental "ABIEncoderV2";

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

// File: set-protocol-contract-utils/contracts/lib/BoundsLibrary.sol

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


library BoundsLibrary {
    /* ============ Structs ============ */
    struct Bounds {
        uint256 lower;
        uint256 upper;
    }

    /* ============ Functions ============ */
    function isValid(Bounds memory _bounds) internal pure returns(bool) {
        return _bounds.upper >= _bounds.lower;
    }

    function isWithin(Bounds memory _bounds, uint256 _value) internal pure returns(bool) {
        return _value >= _bounds.lower && _value <= _bounds.upper;
    }

    function isOutside(Bounds memory _bounds, uint256 _value) internal pure returns(bool) {
        return _value < _bounds.lower || _value > _bounds.upper;
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

// File: contracts/core/liquidators/utils/LiquidatorUtils.sol

/*
    Copyright 2020 Set Labs Inc.

    Licensed under the Apache License,
        Version 2.0 (the "License");
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
 * @title LiquidatorUtils
 * @author Set Protocol
 *
 * Contract of generic utils functions that can be used by liquidators and supporting contracts.
 */
library LiquidatorUtils {
    using SafeMath for uint256;
    using CommonMath for uint256;

    /* ============ Internal Functions ============ */

    /**
     * Calculate the rebalance volume as the difference in allocation percentages between two, tw0-asset
     * allocations times market cap. This function only works for Sets containing the two same assets,
     * either explicitly or implicitly (one of the Sets has 0 allocation for one of the assets).
     *
     * rebalanceVolume = currentSetValue * currentSetQty * abs(currentSetAllocation-nextSetAllocation)
     *
     * @param _currentSet               The Set to rebalance from
     * @param _nextSet                  The Set to rebalance to
     * @param _oracleWhiteList          OracleWhiteList used for valuation
     * @param _currentSetQuantity       Quantity of currentSet to rebalance
     * @return                          Rebalance volume
     */
    function calculateRebalanceVolume(
        ISetToken _currentSet,
        ISetToken _nextSet,
        IOracleWhiteList _oracleWhiteList,
        uint256 _currentSetQuantity
    )
        internal
        view
        returns (uint256)
    {
        // Calculate currency value of current set
        uint256 currentSetValue = SetUSDValuation.calculateSetTokenDollarValue(
            _currentSet,
            _oracleWhiteList
        );

        // Calculate allocationAsset's current set allocation in 18 decimal scaled percentage
        address allocationAsset = _currentSet.getComponents()[0];
        uint256 currentSetAllocation = calculateAssetAllocation(
            _currentSet,
            _oracleWhiteList,
            allocationAsset
        );

        // Calculate allocationAsset's next set allocation in 18 decimal scaled percentage. If asset is not
        // in nextSet, returns 0.
        uint256 nextSetAllocation = calculateAssetAllocation(
            _nextSet,
            _oracleWhiteList,
            allocationAsset
        );

        // Get allocation change
        uint256 allocationChange = currentSetAllocation > nextSetAllocation ?
            currentSetAllocation.sub(nextSetAllocation) :
            nextSetAllocation.sub(currentSetAllocation);

        // Return rebalance volume by multiplying allocationChange by Set market cap, deScaling to avoid
        // overflow potential, still have 18 decimals of precision
        return currentSetValue.mul(_currentSetQuantity).deScale().mul(allocationChange).deScale();
    }

    /**
     * Calculate the allocation percentage of passed asset in Set
     *
     * @param  _setToken            Set being evaluated
     * @param  _oracleWhiteList     OracleWhiteList used for valuation
     * @param  _asset               Asset that's allocation being calculated
     * @return                      18 decimal scaled allocation percentage
     */
    function calculateAssetAllocation(
        ISetToken _setToken,
        IOracleWhiteList _oracleWhiteList,
        address _asset
    )
        internal
        view
        returns (uint256)
    {
        address[] memory components = _setToken.getComponents();

        // Get index of asset and return if asset in Set
        (
            uint256 assetIndex,
            bool isInSet
        ) = AddressArrayUtils.indexOf(components, _asset);

        // Calculate allocation of asset if multiple assets and asset is in Set
        if (isInSet && components.length > 1) {
            uint256 setNaturalUnit = _setToken.naturalUnit();
            uint256[] memory setUnits = _setToken.getUnits();

            uint256 assetValue;
            uint256 setValue = 0;
            for (uint256 i = 0; i < components.length; i++) {
                address currentComponent = components[i];

                address oracle = _oracleWhiteList.getOracleAddressByToken(currentComponent);
                uint256 price = IOracle(oracle).read();
                uint256 decimals = ERC20Detailed(currentComponent).decimals();

                // Calculate currency value of single component in Set
                uint256 componentValue = SetUSDValuation.calculateTokenAllocationAmountUSD(
                    price,
                    setNaturalUnit,
                    setUnits[i],
                    decimals
                );

                // Add currency value of single component to running currency value tally
                setValue = setValue.add(componentValue);
                if (i == assetIndex) {assetValue = componentValue;}
            }

            return assetValue.scale().div(setValue);
        } else {
            // Since Set only has one asset, if its included then must be 100% else 0%
            return isInSet ? CommonMath.scaleFactor() : 0;
        }
    }
}

// File: contracts/core/interfaces/IRebalancingSetTokenV3.sol

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

// File: contracts/core/liquidators/twap-impl/TWAPAuction.sol

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
 * @title TWAPAuction
 * @author Set Protocol
 *
 * Contract for executing TWAP Auctions from initializing to moving to the next chunk auction. Inherits from
 * TwoAssetPriceBoundedLinearAuction
 */
contract TWAPAuction is TwoAssetPriceBoundedLinearAuction {
    using SafeMath for uint256;
    using CommonMath for uint256;
    using AddressArrayUtils for address[];
    using BoundsLibrary for BoundsLibrary.Bounds;

    /* ============ Structs ============ */

    struct TWAPState {
        LinearAuction.State chunkAuction;   // Current chunk auction state
        uint256 orderSize;                  // Beginning amount of currentSets
        uint256 orderRemaining;             // Amount of current Sets not auctioned or being auctioned
        uint256 lastChunkAuctionEnd;        // Time of last chunk auction end
        uint256 chunkAuctionPeriod;         // Time between chunk auctions
        uint256 chunkSize;                  // Amount of current Sets in a full chunk auction
    }

    struct TWAPLiquidatorData {
        uint256 chunkSizeValue;             // Currency value of rebalance volume in each chunk (18 decimal)
        uint256 chunkAuctionPeriod;         // Time between chunk auctions
    }

    struct AssetPairVolumeBounds {
        address assetOne;                   // Address of first asset in pair
        address assetTwo;                   // Address of second asset in pair
        BoundsLibrary.Bounds bounds;        // Chunk size volume bounds for asset pair
    }

    /* ============ Constants ============ */

    // Auction completion buffer assumes completion potentially 2% after fair value when auction started
    uint256 constant public AUCTION_COMPLETION_BUFFER = 2e16;

    /* ============ State Variables ============ */

    // Mapping between an address pair's addresses and the min/max USD-chunk size, each asset pair will
    // have two entries, one for each ordering of the addresses
    mapping(address => mapping(address => BoundsLibrary.Bounds)) public chunkSizeWhiteList;
    //Estimated length in seconds of a chunk auction
    uint256 public expectedChunkAuctionLength;

    /* ============ Constructor ============ */

    /**
     * TWAPAuction constructor
     *
     * @param _oracleWhiteList          OracleWhiteList used by liquidator
     * @param _auctionPeriod            Length of auction in seconds
     * @param _rangeStart               Percentage below FairValue to begin auction at in 18 decimal value
     * @param _rangeEnd                 Percentage above FairValue to end auction at in 18 decimal value
     * @param _assetPairVolumeBounds    List of chunk size bounds for each asset pair
     */
    constructor(
        IOracleWhiteList _oracleWhiteList,
        uint256 _auctionPeriod,
        uint256 _rangeStart,
        uint256 _rangeEnd,
        AssetPairVolumeBounds[] memory _assetPairVolumeBounds
    )
        public
        TwoAssetPriceBoundedLinearAuction(
            _oracleWhiteList,
            _auctionPeriod,
            _rangeStart,
            _rangeEnd
        )
    {
        require(
            _rangeEnd >= AUCTION_COMPLETION_BUFFER,
            "TWAPAuction.constructor: Passed range end must exceed completion buffer."
        );

        // Not using CommonMath.scaleFactoor() due to compilation issues related to constructor size
        require(
            _rangeEnd <= 1e18 && _rangeStart <= 1e18,
            "TWAPAuction.constructor: Range bounds must be less than 100%."
        );

        for (uint256 i = 0; i < _assetPairVolumeBounds.length; i++) {
            BoundsLibrary.Bounds memory bounds = _assetPairVolumeBounds[i].bounds;

            // Not using native library due to compilation issues related to constructor size
            require(
                bounds.lower <= bounds.upper,
                "TWAPAuction.constructor: Passed asset pair bounds are invalid."
            );

            address assetOne = _assetPairVolumeBounds[i].assetOne;
            address assetTwo = _assetPairVolumeBounds[i].assetTwo;

            require(
                chunkSizeWhiteList[assetOne][assetTwo].upper == 0,
                "TWAPAuction.constructor: Asset pair volume bounds must be unique."
            );

            chunkSizeWhiteList[assetOne][assetTwo] = bounds;
            chunkSizeWhiteList[assetTwo][assetOne] = bounds;
        }

        // Expected length of a chunk auction, assuming the auction goes 2% beyond initial fair
        // value. Used to validate TWAP Auction length won't exceed Set's rebalanceFailPeriod.
        // Not using SafeMath due to compilation issues related to constructor size
        require(
            _auctionPeriod < -uint256(1) / (_rangeStart + AUCTION_COMPLETION_BUFFER),
            "TWAPAuction.constructor: Auction period too long."
        );

        expectedChunkAuctionLength = _auctionPeriod * (_rangeStart + AUCTION_COMPLETION_BUFFER) /
            (_rangeStart + _rangeEnd);

        require(
            expectedChunkAuctionLength > 0,
            "TWAPAuction.constructor: Expected auction length must exceed 0."
        );
    }

    /* ============ Internal Functions ============ */

    /**
     * Populates the TWAPState struct and initiates first chunk auction.
     *
     * @param _twapAuction                  TWAPAuction State object
     * @param _currentSet                   The Set to rebalance from
     * @param _nextSet                      The Set to rebalance to
     * @param _startingCurrentSetQuantity   Quantity of currentSet to rebalance
     * @param _chunkSizeValue               Value of chunk size in terms of currency represented by
     *                                          the oracleWhiteList
     * @param _chunkAuctionPeriod           Time between chunk auctions
     */
    function initializeTWAPAuction(
        TWAPState storage _twapAuction,
        ISetToken _currentSet,
        ISetToken _nextSet,
        uint256 _startingCurrentSetQuantity,
        uint256 _chunkSizeValue,
        uint256 _chunkAuctionPeriod
    )
        internal
    {
        // Initialize first chunk auction with the currentSetQuantity to populate LinearAuction struct
        // This will be overwritten by the initial chunk auction quantity
        LinearAuction.initializeLinearAuction(
            _twapAuction.chunkAuction,
            _currentSet,
            _nextSet,
            _startingCurrentSetQuantity
        );

        // Calculate currency value of rebalance volume
        uint256 rebalanceVolume = LiquidatorUtils.calculateRebalanceVolume(
            _currentSet,
            _nextSet,
            oracleWhiteList,
            _startingCurrentSetQuantity
        );

        // Calculate the size of each chunk auction in currentSet terms
        uint256 chunkSize = calculateChunkSize(
            _startingCurrentSetQuantity,
            rebalanceVolume,
            _chunkSizeValue
        );

        // Normalize the chunkSize and orderSize to ensure all values are a multiple of
        // the minimum bid
        uint256 minBid = _twapAuction.chunkAuction.auction.minimumBid;
        uint256 normalizedChunkSize = chunkSize.div(minBid).mul(minBid);
        uint256 totalOrderSize = _startingCurrentSetQuantity.div(minBid).mul(minBid);

        // Initialize the first chunkAuction to the normalized chunk size
        _twapAuction.chunkAuction.auction.startingCurrentSets = normalizedChunkSize;
        _twapAuction.chunkAuction.auction.remainingCurrentSets = normalizedChunkSize;

        // Set TWAPState
        _twapAuction.orderSize = totalOrderSize;
        _twapAuction.orderRemaining = totalOrderSize.sub(normalizedChunkSize);
        _twapAuction.chunkSize = normalizedChunkSize;
        _twapAuction.lastChunkAuctionEnd = 0;
        _twapAuction.chunkAuctionPeriod = _chunkAuctionPeriod;
    }

    /**
     * Calculates size of next chunk auction and then starts then parameterizes the auction and overwrites
     * the previous auction state. The orderRemaining is updated to take into account the currentSets included
     * in the new chunk auction. Function can only be called provided the following conditions have been met:
     *  - Last chunk auction is finished (remainingCurrentSets < minimumBid)
     *  - There is still more collateral to auction off
     *  - The chunkAuctionPeriod has elapsed
     *
     * @param _twapAuction                  TWAPAuction State object
     */
    function auctionNextChunk(
        TWAPState storage _twapAuction
    )
        internal
    {
        // Add leftover current Sets from previous chunk auction to orderRemaining
        uint256 totalRemainingSets = _twapAuction.orderRemaining.add(
            _twapAuction.chunkAuction.auction.remainingCurrentSets
        );

        // Calculate next chunk auction size as min of chunkSize or orderRemaining
        uint256 nextChunkAuctionSize = Math.min(_twapAuction.chunkSize, totalRemainingSets);

        // Start new chunk auction by over writing previous auction state and decrementing orderRemaining
        overwriteChunkAuctionState(_twapAuction, nextChunkAuctionSize);
        _twapAuction.orderRemaining = totalRemainingSets.sub(nextChunkAuctionSize);
    }

    /* ============ Internal Helper Functions ============ */

    /**
     * Resets state for next chunk auction (except minimumBid and token flow arrays)
     *
     * @param _twapAuction                  TWAPAuction State object
     * @param _chunkAuctionSize             Size of next chunk auction
     */
    function overwriteChunkAuctionState(
        TWAPState storage _twapAuction,
        uint256 _chunkAuctionSize
    )
        internal
    {
        _twapAuction.chunkAuction.auction.startingCurrentSets = _chunkAuctionSize;
        _twapAuction.chunkAuction.auction.remainingCurrentSets = _chunkAuctionSize;
        _twapAuction.chunkAuction.auction.startTime = block.timestamp;
        _twapAuction.chunkAuction.endTime = block.timestamp.add(auctionPeriod);

        // Since currentSet and nextSet param is not used in calculating start and end price on
        // TwoAssetPriceBoundedLinearAuction we can pass in zero addresses
        _twapAuction.chunkAuction.startPrice = calculateStartPrice(
            _twapAuction.chunkAuction.auction,
            ISetToken(address(0)),
            ISetToken(address(0))
        );
        _twapAuction.chunkAuction.endPrice = calculateEndPrice(
            _twapAuction.chunkAuction.auction,
            ISetToken(address(0)),
            ISetToken(address(0))
        );
    }

    /**
     * Validates that chunk size is within asset bounds and passed chunkAuctionLength
     * is unlikely to push TWAPAuction beyond rebalanceFailPeriod.
     *
     * @param _currentSet                   The Set to rebalance from
     * @param _nextSet                      The Set to rebalance to
     * @param _startingCurrentSetQuantity   Quantity of currentSet to rebalance
     * @param _chunkSizeValue               Value of chunk size in terms of currency represented by
     *                                          the oracleWhiteList
     * @param _chunkAuctionPeriod           Time between chunk auctions
     */
    function validateLiquidatorData(
        ISetToken _currentSet,
        ISetToken _nextSet,
        uint256 _startingCurrentSetQuantity,
        uint256 _chunkSizeValue,
        uint256 _chunkAuctionPeriod
    )
        internal
        view
    {
        // Calculate currency value of rebalance volume
        uint256 rebalanceVolume = LiquidatorUtils.calculateRebalanceVolume(
            _currentSet,
            _nextSet,
            oracleWhiteList,
            _startingCurrentSetQuantity
        );

        BoundsLibrary.Bounds memory volumeBounds = getVolumeBoundsFromCollateral(_currentSet, _nextSet);

        validateTWAPParameters(
            _chunkSizeValue,
            _chunkAuctionPeriod,
            rebalanceVolume,
            volumeBounds
        );
    }

    /**
     * Validates passed in parameters for TWAP auction
     *
     * @param _chunkSizeValue           Value of chunk size in terms of currency represented by
     *                                      the oracleWhiteList
     * @param _chunkAuctionPeriod       Time between chunk auctions
     * @param _rebalanceVolume          Value of collateral being rebalanced
     * @param _assetPairVolumeBounds    Volume bounds of asset pair
     */
    function validateTWAPParameters(
        uint256 _chunkSizeValue,
        uint256 _chunkAuctionPeriod,
        uint256 _rebalanceVolume,
        BoundsLibrary.Bounds memory _assetPairVolumeBounds
    )
        internal
        view
    {
        // Bounds and chunkSizeValue denominated in currency value
        require(
            _assetPairVolumeBounds.isWithin(_chunkSizeValue),
            "TWAPAuction.validateTWAPParameters: Passed chunk size must be between bounds."
        );

        // Want to make sure that the expected length of the auction is less than the rebalanceFailPeriod
        // or else a legitimate auction could be failed. Calculated as such:
        // expectedTWAPTime = numChunkAuctions * expectedChunkAuctionLength + (numChunkAuctions - 1) *
        // chunkAuctionPeriod
        uint256 numChunkAuctions = _rebalanceVolume.divCeil(_chunkSizeValue);
        uint256 expectedTWAPAuctionTime = numChunkAuctions.mul(expectedChunkAuctionLength)
            .add(numChunkAuctions.sub(1).mul(_chunkAuctionPeriod));

        uint256 rebalanceFailPeriod = IRebalancingSetTokenV3(msg.sender).rebalanceFailPeriod();

        require(
            expectedTWAPAuctionTime < rebalanceFailPeriod,
            "TWAPAuction.validateTWAPParameters: Expected auction duration exceeds allowed length."
        );
    }

    /**
     * The next chunk auction can begin when the previous auction has completed, there are still currentSets to
     * rebalance, and the auction period has elapsed.
     *
     * @param _twapAuction                  TWAPAuction State object
     */
    function validateNextChunkAuction(
        TWAPState storage _twapAuction
    )
        internal
        view
    {
        Auction.validateAuctionCompletion(_twapAuction.chunkAuction.auction);

        require(
            isRebalanceActive(_twapAuction),
            "TWAPState.validateNextChunkAuction: TWAPAuction is finished."
        );

        require(
            _twapAuction.lastChunkAuctionEnd.add(_twapAuction.chunkAuctionPeriod) <= block.timestamp,
            "TWAPState.validateNextChunkAuction: Not enough time elapsed from last chunk auction end."
        );
    }

    /**
     * Checks if the amount of Sets still to be auctioned (in aggregate) is greater than the minimumBid
     *
     * @param _twapAuction                  TWAPAuction State object
     */
    function isRebalanceActive(
        TWAPState storage _twapAuction
    )
        internal
        view
        returns (bool)
    {
        // Sum of remaining Sets in current chunk auction and order remaining
        uint256 totalRemainingSets = calculateTotalSetsRemaining(_twapAuction);

        // Check that total remaining sets is greater than minimumBid
        return totalRemainingSets >= _twapAuction.chunkAuction.auction.minimumBid;
    }

    /**
     * Calculates chunkSize of auction in current Set terms
     *
     * @param _totalSetAmount       Total amount of Sets being auctioned
     * @param _rebalanceVolume      The total currency value being auctioned
     * @param _chunkSizeValue       Value of chunk size in currency terms
     */
    function calculateChunkSize(
        uint256 _totalSetAmount,
        uint256 _rebalanceVolume,
        uint256 _chunkSizeValue
    )
        internal
        view
        returns (uint256)
    {
        // Since solidity rounds down anything equal to 1 will require at least one auction
        // equal to the chunkSizeValue
        if (_rebalanceVolume.div(_chunkSizeValue) >= 1) {
            return _totalSetAmount.mul(_chunkSizeValue).div(_rebalanceVolume);
        } else {
            return _totalSetAmount;
        }
    }

    /**
     * Calculates the total remaining sets in the auction between the currently underway chunk auction and
     * the Sets that have yet to be included in a chunk auction.
     *
     * @param _twapAuction                  TWAPAuction State object
     */
    function calculateTotalSetsRemaining(TWAPAuction.TWAPState storage _twapAuction)
        internal
        view
        returns (uint256)
    {
        return _twapAuction.orderRemaining.add(_twapAuction.chunkAuction.auction.remainingCurrentSets);
    }

    /**
     * Returns asset pair volume bounds based on passed in collateral Sets.
     *
     * @param _currentSet                   The Set to rebalance from
     * @param _nextSet                      The Set to rebalance to
     */
    function getVolumeBoundsFromCollateral(
        ISetToken _currentSet,
        ISetToken _nextSet
    )
        internal
        view
        returns (BoundsLibrary.Bounds memory)
    {
        // Get set components
        address[] memory currentSetComponents = _currentSet.getComponents();
        address[] memory nextSetComponents = _nextSet.getComponents();

        address firstComponent = currentSetComponents [0];
        address secondComponent = currentSetComponents.length > 1 ? currentSetComponents [1] :
            nextSetComponents [0] != firstComponent ? nextSetComponents [0] : nextSetComponents [1];

        return chunkSizeWhiteList[firstComponent][secondComponent];
    }

    function parseLiquidatorData(
        bytes memory _liquidatorData
    )
        internal
        pure
        returns (uint256, uint256)
    {
        return abi.decode(_liquidatorData, (uint256, uint256));
    }
}

// File: contracts/core/liquidators/impl/AuctionGetters.sol

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
 * @title AuctionGetters
 * @author Set Protocol
 *
 * Contract containing getters for receiving data from Auction.Setup struct. The auction() getter is implemented in the
 * inheriting contract.
 */
contract AuctionGetters {

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

    function auction(address _set) internal view returns(Auction.Setup storage);
}

// File: contracts/core/liquidators/twap-impl/TWAPAuctionGetters.sol

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
 * @title TWAPAuctionGetters
 * @author Set Protocol
 *
 * Contract containing getters for receiving data from TWAPAuction.TWAPState struct. The twapAuction()
 * getter is implemented in the inheriting contract.
 */
contract TWAPAuctionGetters is AuctionGetters {
    using SafeMath for uint256;

    function getOrderSize(address _set) external view returns (uint256) {
        return twapAuction(_set).orderSize;
    }

    function getOrderRemaining(address _set) external view returns (uint256) {
        return twapAuction(_set).orderRemaining;
    }

    function getChunkSize(address _set) external view returns (uint256) {
        return twapAuction(_set).chunkSize;
    }

    function getChunkAuctionPeriod(address _set) external view returns (uint256) {
        return twapAuction(_set).chunkAuctionPeriod;
    }

    function getLastChunkAuctionEnd(address _set) external view returns (uint256) {
        return twapAuction(_set).lastChunkAuctionEnd;
    }

    function twapAuction(address _set) internal view returns(TWAPAuction.TWAPState storage);
}

// File: contracts/core/liquidators/TWAPLiquidator.sol

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
 * @title TWAPLiquidator
 * @author Set Protocol
 *
 * Contract that holds all the state and functionality required for setting up, returning prices, and tearing
 * down TWAP rebalances for RebalancingSetTokens.
 */
contract TWAPLiquidator is
    ILiquidator,
    TWAPAuction,
    TWAPAuctionGetters,
    Ownable
{
    using SafeMath for uint256;

    /* ============ Events ============ */
    event ChunkAuctionIterated(
        address indexed rebalancingSetToken,
        uint256 orderRemaining,
        uint256 startingCurrentSets
    );

    event ChunkSizeBoundUpdated(
        address assetOne,
        address assetTwo,
        uint256 lowerBound,
        uint256 upperBound
    );

    ICore public core;
    string public name;
    // Maps RebalancingSetToken to it's auction state
    mapping(address => TWAPAuction.TWAPState) public auctions;

    /* ============ Modifier ============ */
    modifier onlyValidSet() {
        require(
            core.validSets(msg.sender),
            "TWAPLiquidator: Invalid or disabled proposed SetToken address"
        );
        _;
    }

    /**
     * TWAPLiquidator constructor
     *
     * @param _core                     Core instance
     * @param _oracleWhiteList          Oracle WhiteList instance
     * @param _auctionPeriod            Length of auction in seconds
     * @param _rangeStart               Percentage above FairValue to begin auction at in 18 decimal value
     * @param _rangeEnd                 Percentage below FairValue to end auction at in 18 decimal value
     * @param _assetPairVolumeBounds    List of asset pair USD-denominated chunk auction size bounds
     * @param _name                     Descriptive name of Liquidator
     */
    constructor(
        ICore _core,
        IOracleWhiteList _oracleWhiteList,
        uint256 _auctionPeriod,
        uint256 _rangeStart,
        uint256 _rangeEnd,
        TWAPAuction.AssetPairVolumeBounds[] memory _assetPairVolumeBounds,
        string memory _name
    )
        public
        TWAPAuction(
            _oracleWhiteList,
            _auctionPeriod,
            _rangeStart,
            _rangeEnd,
            _assetPairVolumeBounds
        )
    {
        core = _core;
        name = _name;
    }

    /* ============ External Functions ============ */

    /**
     * Initiates a TWAP auction. Can only be called by a SetToken.
     *
     * @param _currentSet                   The Set to rebalance from
     * @param _nextSet                      The Set to rebalance to
     * @param _startingCurrentSetQuantity   The currentSet quantity to rebalance
     * @param _liquidatorData               Bytecode formatted data with TWAPLiquidator-specific arguments
     */
    function startRebalance(
        ISetToken _currentSet,
        ISetToken _nextSet,
        uint256 _startingCurrentSetQuantity,
        bytes calldata _liquidatorData
    )
        external
        onlyValidSet
    {
        // Validates only 2 components are involved and are supported by oracles
        TwoAssetPriceBoundedLinearAuction.validateTwoAssetPriceBoundedAuction(
            _currentSet,
            _nextSet
        );

        // Retrieve the chunk auction size and auction period from liquidator data.
        (
            uint256 chunkAuctionValue,
            uint256 chunkAuctionPeriod
        ) = TWAPAuction.parseLiquidatorData(_liquidatorData);

        // Chunk size must be within bounds and total rebalance length must be below fail auction time
        TWAPAuction.validateLiquidatorData(
            _currentSet,
            _nextSet,
            _startingCurrentSetQuantity,
            chunkAuctionValue,
            chunkAuctionPeriod
        );

        // Initializes TWAP Auction and commits to TWAP state
        TWAPAuction.initializeTWAPAuction(
            auctions[msg.sender],
            _currentSet,
            _nextSet,
            _startingCurrentSetQuantity,
            chunkAuctionValue,
            chunkAuctionPeriod
        );
    }

    /**
     * Reduces the remainingCurrentSet quantity and retrieves the current
     * bid price for the chunk auction. If this auction completes the chunkAuction,
     * the lastChunkAuction parameter is updated.
     * Can only be called by a SetToken during an active auction
     *
     * @param _quantity               The currentSetQuantity to rebalance
     * @return TokenFlow              Struct with array, inflow, and outflow data
     */
    function placeBid(
        uint256 _quantity
    )
        external
        onlyValidSet
        returns (Rebalance.TokenFlow memory)
    {
        Auction.validateBidQuantity(auction(msg.sender), _quantity);

        Auction.reduceRemainingCurrentSets(auction(msg.sender), _quantity);

        // If the auction is complete, update the chunk auction end time to the present timestamp
        if (!hasBiddableQuantity(auction(msg.sender))) {
            twapAuction(msg.sender).lastChunkAuctionEnd = block.timestamp;
        }

        return getBidPrice(msg.sender, _quantity);
    }

    /**
     * Initiates the next chunk auction. Callable by anybody.
     *
     * @param _set                    Address of the RebalancingSetToken
     */
    function iterateChunkAuction(address _set) external {
        TWAPAuction.TWAPState storage twapAuction = twapAuction(_set);
        validateNextChunkAuction(twapAuction);

        auctionNextChunk(twapAuction);

        emit ChunkAuctionIterated(
            _set,
            twapAuction.orderRemaining,
            twapAuction.chunkAuction.auction.startingCurrentSets
        );
    }

    /**
     * Validates auction completion and clears auction state. Callable only by a SetToken.
     */
    function settleRebalance() external onlyValidSet {
        require(
            !(TWAPAuction.isRebalanceActive(twapAuction(msg.sender))),
            "TWAPLiquidator: Rebalance must be complete"
        );

        clearAuctionState(msg.sender);
    }

    /**
     * Clears auction state.
     */
    function endFailedRebalance() external onlyValidSet {
        clearAuctionState(msg.sender);
    }

    /**
     * Retrieves the current chunk auction price for the particular Set
     *
     * @param _set                    Address of the SetToken
     * @param _quantity               The chunk auction's currentSetQuantity to rebalance
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
        return LinearAuction.getTokenFlow(chunkAuction(_set), _quantity);
    }

    /**
     * Admin function to modify chunk sizes for an asset pair.
     *
     * @param _assetOne                   Address of the first asset
     * @param _assetTwo                   Address of the second asset
     * @param _assetPairVolumeBounds      Asset pair USD-denominated chunk auction size bounds
     */
    function setChunkSizeBounds(
        address _assetOne,
        address _assetTwo,
        BoundsLibrary.Bounds memory _assetPairVolumeBounds
    )
        public
        onlyOwner
    {
        require(
            BoundsLibrary.isValid(_assetPairVolumeBounds),
            "TWAPLiquidator: Bounds invalid"
        );

        chunkSizeWhiteList[_assetOne][_assetTwo] = _assetPairVolumeBounds;
        chunkSizeWhiteList[_assetTwo][_assetOne] = _assetPairVolumeBounds;

        emit ChunkSizeBoundUpdated(
            _assetOne,
            _assetTwo,
            _assetPairVolumeBounds.lower,
            _assetPairVolumeBounds.upper
        );
    }

    /* ============ Getters Functions ============ */

    function hasRebalanceFailed(address _set) external view returns (bool) {
        return LinearAuction.hasAuctionFailed(chunkAuction(_set));
    }

    function auctionPriceParameters(address _set)
        external
        view
        returns (RebalancingLibrary.AuctionPriceParameters memory)
    {
        return RebalancingLibrary.AuctionPriceParameters({
            auctionStartTime: auction(_set).startTime,
            auctionTimeToPivot: auctionPeriod,
            auctionStartPrice: chunkAuction(_set).startPrice,
            auctionPivotPrice: chunkAuction(_set).endPrice
        });
    }

    function getTotalSetsRemaining(address _set) external view returns (uint256) {
        return TWAPAuction.calculateTotalSetsRemaining(twapAuction(_set));
    }

    /**
     * Converts the chunkSize and chunkAuctionPeriod into liquidator data.
     *
     * _chunkSizeValue            Currency value of rebalance volume in each chunk (18 decimal)
     * _chunkAuctionPeriod        Time between chunk auctions
     * @return bytes              Bytes encoded liquidator data
     */
    function getLiquidatorData(
        uint256 _chunkSize,
        uint256 _chunkAuctionPeriod
    )
        external
        view
        returns(bytes memory)
    {
        return abi.encode(_chunkSize, _chunkAuctionPeriod);
    }

    /* ============ Private Functions ============ */

    function clearAuctionState(address _set) internal {
        delete auctions[_set];
    }

    function twapAuction(address _set) internal view returns(TWAPAuction.TWAPState storage) {
        return auctions[_set];
    }

    function chunkAuction(address _set) internal view returns(LinearAuction.State storage) {
        return twapAuction(_set).chunkAuction;
    }

    function auction(address _set) internal view returns(Auction.Setup storage) {
        return chunkAuction(_set).auction;
    }
}