/**
 *Submitted for verification at Etherscan.io on 2020-08-05
*/

// File: @openzeppelin/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/protocol/interfaces/IUsdAggregatorV2.sol

pragma solidity ^0.5.0;

/**
 * @dev Gets the USD value of a currency with 8 decimals.
 */
interface IUsdAggregatorV2 {

    /**
     * @return The USD value of a currency, with 8 decimals.
     */
    function latestAnswer() external view returns (uint);

}

// File: @openzeppelin/contracts/GSN/Context.sol

pragma solidity ^0.5.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = _msgSender();
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
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
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

// File: contracts/protocol/interfaces/IUnderlyingTokenValuator.sol

pragma solidity ^0.5.0;

interface IUnderlyingTokenValuator {

    /**
      * @dev Gets the tokens value in terms of USD.
      *
      * @return The value of the `amount` of `token`, as a number with 18 decimals
      */
    function getTokenValue(address token, uint amount) external view returns (uint);

}

// File: contracts/utils/StringHelpers.sol

pragma solidity ^0.5.0;

library StringHelpers {

    function toString(address _address) public pure returns (string memory) {
        bytes memory b = new bytes(20);
        for (uint i = 0; i < 20; i++) {
            b[i] = byte(uint8(uint(_address) / (2 ** (8 * (19 - i)))));
        }
        return string(b);
    }

}

// File: contracts/protocol/impl/UnderlyingTokenValuatorImplV3.sol

/*
 * Copyright 2020 DMM Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


pragma solidity ^0.5.0;






contract UnderlyingTokenValuatorImplV3 is IUnderlyingTokenValuator, Ownable {

    using StringHelpers for address;
    using SafeMath for uint;

    event DaiUsdAggregatorChanged(address indexed oldAggregator, address indexed newAggregator);
    event EthUsdAggregatorChanged(address indexed oldAggregator, address indexed newAggregator);
    event UsdcEthAggregatorChanged(address indexed oldAggregator, address indexed newAggregator);

    address public dai;
    address public usdc;
    address public weth;

    IUsdAggregatorV2 public daiUsdAggregator;
    IUsdAggregatorV2 public ethUsdAggregator;

    IUsdAggregatorV2 public usdcEthAggregator;

    uint public constant USD_AGGREGATOR_BASE = 100000000; // 1e8
    uint public constant ETH_AGGREGATOR_BASE = 1e18;

    constructor(
        address _dai,
        address _usdc,
        address _weth,
        address _daiUsdAggregator,
        address _ethUsdAggregator,
        address _usdcEthAggregator
    ) public {
        dai = _dai;
        usdc = _usdc;
        weth = _weth;

        ethUsdAggregator = IUsdAggregatorV2(_ethUsdAggregator);

        daiUsdAggregator = IUsdAggregatorV2(_daiUsdAggregator);
        usdcEthAggregator = IUsdAggregatorV2(_usdcEthAggregator);
    }

    function setEthUsdAggregator(address _ethUsdAggregator) public onlyOwner {
        address oldAggregator = address(ethUsdAggregator);
        ethUsdAggregator = IUsdAggregatorV2(_ethUsdAggregator);

        emit EthUsdAggregatorChanged(oldAggregator, _ethUsdAggregator);
    }

    function setDaiUsdAggregator(address _daiUsdAggregator) public onlyOwner {
        address oldAggregator = address(daiUsdAggregator);
        daiUsdAggregator = IUsdAggregatorV2(_daiUsdAggregator);

        emit DaiUsdAggregatorChanged(oldAggregator, _daiUsdAggregator);
    }

    function setUsdcEthAggregator(address _usdcEthAggregator) public onlyOwner {
        address oldAggregator = address(usdcEthAggregator);
        usdcEthAggregator = IUsdAggregatorV2(_usdcEthAggregator);

        emit UsdcEthAggregatorChanged(oldAggregator, _usdcEthAggregator);
    }

    function getTokenValue(address token, uint amount) public view returns (uint) {
        if (token == weth) {
            return amount.mul(ethUsdAggregator.latestAnswer()).div(USD_AGGREGATOR_BASE);
        } else if (token == usdc) {
            uint wethValueAmount = amount.mul(usdcEthAggregator.latestAnswer()).div(ETH_AGGREGATOR_BASE);
            return getTokenValue(weth, wethValueAmount);
        } else if (token == dai) {
            return amount.mul(daiUsdAggregator.latestAnswer()).div(USD_AGGREGATOR_BASE);
        } else {
            revert(string(abi.encodePacked("Invalid token, found: ", token.toString())));
        }
    }

}

// File: contracts/protocol/impl/UnderlyingTokenValuatorImplV4.sol

/*
 * Copyright 2020 DMM Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


pragma solidity ^0.5.0;




contract UnderlyingTokenValuatorImplV4 is UnderlyingTokenValuatorImplV3 {

    using SafeMath for uint;

    event UsdtEthAggregatorChanged(address indexed oldAggregator, address indexed newAggregator);

    address public usdt;

    IUsdAggregatorV2 public usdtEthAggregator;

    constructor(
        address _dai,
        address _usdc,
        address _usdt,
        address _weth,
        address _daiUsdAggregator,
        address _ethUsdAggregator,
        address _usdcEthAggregator,
        address _usdtEthAggregator
    ) public UnderlyingTokenValuatorImplV3(
        _dai, _usdc, _weth, _daiUsdAggregator, _ethUsdAggregator, _usdcEthAggregator
    ) {
        usdt = _usdt;
        usdtEthAggregator = IUsdAggregatorV2(_usdtEthAggregator);
    }

    function setUsdtEthAggregator(address _usdtEthAggregator) public onlyOwner {
        address oldAggregator = address(usdtEthAggregator);
        usdtEthAggregator = IUsdAggregatorV2(_usdtEthAggregator);

        emit UsdtEthAggregatorChanged(oldAggregator, _usdtEthAggregator);
    }

    function getTokenValue(address token, uint amount) public view returns (uint) {
        if (token == usdt) {
            uint wethValueAmount = amount.mul(usdtEthAggregator.latestAnswer()).div(ETH_AGGREGATOR_BASE);
            return getTokenValue(weth, wethValueAmount);
        } else {
            return super.getTokenValue(token, amount);
        }
    }

}