/**
 *Submitted for verification at Etherscan.io on 2020-07-24
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

// File: contracts/Event.sol

pragma solidity 0.5.16;


contract Event {

    using SafeMath for uint256;

    bytes5 constant public version = "2.2.0";
    uint8 constant private CLAPS_PER_ATTENDEE = 100;
    uint8 constant private MAX_ATTENDEES = 50;

    uint8 constant private ATTENDEE_UNREGISTERED = 0;
    uint8 constant private ATTENDEE_REGISTERED = 1;
    uint8 constant private ATTENDEE_CLAPPED = 2;
    bool distributionMade;

    uint64 public fee;
    uint32 public end;
    address payable[] private attendees;
    mapping(address => uint8) public states;
    mapping(address => uint256) public claps;
    uint256 public totalClaps;

    event Distribution (uint256 totalReward);
    event Transfer (address indexed attendee, uint256 reward);

    constructor (uint64 _fee, uint32 _end) public {
        require(block.timestamp < _end);
        fee = _fee;
        end = _end;
    }

    function getAttendees () external view returns (address payable[] memory) {
        return attendees;
    }

    function register (address payable _attendee, uint256 _fee) internal {
        require(_fee == fee);
        require(states[_attendee] == ATTENDEE_UNREGISTERED);
        require(attendees.length < MAX_ATTENDEES);
        require(block.timestamp < end);
        states[_attendee] = ATTENDEE_REGISTERED;
        attendees.push(_attendee);
        claps[_attendee] = 1;
        totalClaps += 1;
    }

    function register () external payable {
        register(msg.sender, msg.value);
    }

    function clap (
        address _clapper,
        address[] memory _attendees,
        uint256[] memory _claps
    ) internal {
        require(states[_clapper] == ATTENDEE_REGISTERED);
        require(_attendees.length == _claps.length);
        states[_clapper] = ATTENDEE_CLAPPED;
        uint256 givenClaps;
        for (uint256 i; i < _attendees.length; i = i.add(1)) {
            givenClaps = givenClaps.add(_claps[i]);
            if (_attendees[i] == _clapper) continue;
            if (states[_attendees[i]] == ATTENDEE_UNREGISTERED) continue;
            claps[_attendees[i]] = claps[_attendees[i]].add(_claps[i]);
        }
        require(givenClaps <= CLAPS_PER_ATTENDEE);
        totalClaps = totalClaps.add(givenClaps);
    }

    function clap (address[] calldata _attendees, uint256[] calldata _claps)
        external {
        clap(msg.sender, _attendees, _claps);
    }

    function distribute () external {
        require(distributionMade == false);
        require(block.timestamp >= end);
        require(totalClaps > 0);
        distributionMade = true;
        uint256 totalReward = address(this).balance;
        emit Distribution(totalReward);
        for (uint256 i; i < attendees.length; i = i.add(1)) {
            uint256 reward = claps[attendees[i]]
                .mul(totalReward)
                .div(totalClaps);
            (bool success, ) = attendees[i].call.value(reward)("");
            if (success) {
                emit Transfer(attendees[i], reward);
            }
        }
    }
}

// File: contracts/ProxyEvent.sol

pragma solidity 0.5.16;


contract ProxyEvent is Event {

    bytes5 constant public version = "2.0.0";
    mapping(address => address) public proxy;

    constructor(uint64 _fee, uint32 _end) Event(_fee, _end) public {}

    function registerFor (address payable _attendee) external payable {
        register(_attendee, msg.value);
        proxy[_attendee] = msg.sender;
    }

    function clapFor (
        address _clapper,
        address[] calldata _attendees,
        uint256[] calldata _claps
    ) external {
        require(proxy[_clapper] == msg.sender);
        clap(_clapper, _attendees, _claps);
    }
}