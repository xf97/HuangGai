/**
 *Submitted for verification at Etherscan.io on 2020-05-07
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

// File: contracts/Coinosis.sol

pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;


contract Coinosis {

    using SafeMath for uint;

    string constant NOT_OWNER = "The sender account is not the owner \
(not-owner)";
    string constant INVALID_ETH_PRICE = "The provided ETH price is invalid \
(invalid-eth-price)";
    string constant NAMES_DIFFER_ADDRESSES =
        "The amount of names differs from the amount of addresses \
(names-differ-addresses)";
    string constant ADDRESSES_DIFFER_CLAPS =
        "The amount of addresses differs from the amount of claps \
(addresses-differ-claps)";
    string constant INSUFFICIENT_VALUE =
        "The ether value in this contract is less than the total reward value \
to send (insufficient-value)";
    string constant NO_CLAPS = "All the claps are zero (no-claps)";

    string public version = "1.3.1";
    address payable private owner;

    event Assessment(
        uint timestamp,
        string indexed eventURL,
        uint registrationFeeUSDWei,
        uint ETHPriceUSDWei,
        string[] names,
        address payable[] addresses,
        uint[] claps,
        uint registrationFeeWei,
        uint totalFeesWei,
        uint totalClaps,
        uint[] rewards
    );
    event Transfer(
        string name,
        address indexed addr,
        uint registrationFeeUSDWei,
        uint registrationFeeWei,
        uint claps,
        uint reward
    );
    event RewardedAmount(uint rewardedAmount);

    constructor () public {
        owner = msg.sender;
    }

    function () external payable {}

    function decommission() public {
        require(msg.sender == owner, NOT_OWNER);
        selfdestruct(owner);
    }

    function assess(
        string memory eventURL,
        uint registrationFeeUSDWei,
        uint ETHPriceUSDWei,
        string[] memory names,
        address payable[] memory addresses,
        uint[] memory claps
    ) public {
        require(msg.sender == owner, NOT_OWNER);
        require(ETHPriceUSDWei > 0, INVALID_ETH_PRICE);
        require(names.length == addresses.length, NAMES_DIFFER_ADDRESSES);
        require(addresses.length == claps.length, ADDRESSES_DIFFER_CLAPS);
        uint registrationFeeWei =
            registrationFeeUSDWei.mul(1 ether).div(ETHPriceUSDWei);
        uint totalFeesWei = registrationFeeWei.mul(addresses.length);
        require(address(this).balance >= totalFeesWei, INSUFFICIENT_VALUE);
        uint totalClaps = 0;
        for (uint i = 0; i < claps.length; i = i.add(1)) {
            totalClaps = totalClaps.add(claps[i]);
        }
        require(totalClaps > 0, NO_CLAPS);
        uint[] memory rewards = new uint[](claps.length);
        for (uint i = 0; i < claps.length; i = i.add(1)) {
            rewards[i] = claps[i].mul(totalFeesWei).div(totalClaps);
        }
        emit Assessment(
            now,
            eventURL,
            registrationFeeUSDWei,
            ETHPriceUSDWei,
            names,
            addresses,
            claps,
            registrationFeeWei,
            totalFeesWei,
            totalClaps,
            rewards
        );
        uint rewardedAmount = 0;
        for (uint i = 0; i < addresses.length; i = i.add(1)) {
            if (rewards[i] > 0 && addresses[i].send(rewards[i])) {
                emit Transfer(
                    names[i],
                    addresses[i],
                    registrationFeeUSDWei,
                    registrationFeeWei,
                    claps[i],
                    rewards[i]
                );
                rewardedAmount += rewards[i];
            }
        }
        emit RewardedAmount(rewardedAmount);
    }
}