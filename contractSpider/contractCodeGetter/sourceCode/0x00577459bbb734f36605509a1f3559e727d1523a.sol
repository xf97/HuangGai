/**
 *Submitted for verification at Etherscan.io on 2020-07-02
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

// File: contracts/Utility.sol

pragma solidity ^0.5.16;


library utilities {

    using SafeMath for uint;

    // Utilities

    // basic array sort
    function sort_array(uint[] memory arr) internal pure returns (uint[] memory) {
        uint l = arr.length;
        for (uint i = 0; i < l; i++) {
            for (uint j = i + 1; j < l; j++) {
                if (arr[i] > arr[j]) {
                    uint temp = arr[i];
                    arr[i] = arr[j];
                    arr[j] = temp;
                }
            }
        }
        return arr;
    }

    // converts a string to a uint
    function stringToUint(string memory s) internal pure returns (uint) {
        bytes memory b = bytes(s);
        uint i;
        uint result = 0;
        for (i = 0; i < b.length; i++) {
            uint c = uint(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
        return result;
    }

    // Converts a uint to a string
    function uintToString(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

    // returns a substring but reverses the order of the characters
    function substrReversed(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        uint j = 0;
        for (uint i = endIndex - 1; i >= startIndex; i--) {
            result[j] = strBytes[i];
            j += 1;
        }
        return string(result);
    }

}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
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

// File: contracts/Whackers.sol

pragma solidity ^0.5.16;
// pragma experimental ABIEncoderV2;





//  ██╗    ██╗ ██╗  ██╗  █████╗   ██████╗ ██╗  ██╗ ███████╗ ██████╗  ███████╗
//  ██║    ██║ ██║  ██║ ██╔══██╗ ██╔════╝ ██║ ██╔╝ ██╔════╝ ██╔══██╗ ██╔════╝
//  ██║ █╗ ██║ ███████║ ███████║ ██║      █████╔╝  █████╗   ██████╔╝ ███████╗
//  ██║███╗██║ ██╔══██║ ██╔══██║ ██║      ██╔═██╗  ██╔══╝   ██╔══██╗ ╚════██║
// ╚███╔███╔╝ ██║  ██║ ██║  ██║ ╚██████╗ ██║  ██╗ ███████╗ ██║  ██║ ███████║
// ╚══╝╚══╝  ╚═╝  ╚═╝ ╚═╝  ╚═╝  ╚═════╝ ╚═╝  ╚═╝ ╚══════╝ ╚═╝  ╚═╝ ╚══════╝

// This contract is intended to give the WHACKD token a use case.
// Normally, WHACKD token burns 10% of a given transaction when the
// token is moved. The intent of this contract is to give users an
// opportunity to increase the value of their holding by buying into
// a lottery of WHACKD tokens. It also has the intrinsic use of burning
// tokens and, in the spirit of WHACKD, some participants lose their
// deposits. Here's how it works:

// PLAYING A ROUND
// There is a fixed deposit requirement, which matches the first of
// ten deposits: User 1 deposits 100 WHACKD, next 9 users must deposit
// 100 WHACKD. Once ten deposits are collected, distribution will be as follows:

// WINNERS (AND LOSERS)
// The kitty is the sum of all deposits
//  ** 5 random users will be WHACKD and get nothing. Remaining participants and
//    the house will split what remains on the WHACKERS contract.
//  ** 4 random users will win second place. The payout will be 1/7th of the
//    kitty
//  ** The House will collect a quarter of second prize
//  ** One random user will win first place. The payout will be what remains
//    of the kitty

// FINAL DISTRIBUTION FROM INITIAL DEPOSIT OF 111 WHACKD:
//  Upon completion of the whackers game, the original WHACKERS smart contract will
//  then distribute the winnings - but since WHACKD token burns ten percent of
//  every transaction. WHACKD token takes 10% on deposits and payouts.

// OLD GAMES: AN OLDER INCOMPLETE CHALLENGE
// If a round gets to be a week old a user can call forceRound
//  with the same ante as the others but we populate all the vacant
//  slots with his address thereby increasing his chances of winning,
//  although the payouts will be less, 2nd place winners may incur a net loss

// NOTICE: ONE IN A THOUSAND WHACKD TRANSACTIONS ARE 100% BURNED. Be warned!

/// @author snowkidind (https://github.com/snowkidind/whackers)
/// @title Whackers
contract Whackers is Ownable {

    using SafeMath for uint;

    IERC20 internal whackd;

    uint public ante;          // the amount of deposit required for active round, zero if new round.
    uint public start;         // annotate the date of the first ante
    uint public index;         // Countdown to having ten entrants
    uint public minimumAnte;   // setting for minimum deposit amount
    bool public uniqueWallet;  // setting for whether a single address may register multiple times in a round
    bool internal settling;    // used during settling process
    bool public suspend;       // owner can suspend the contract from accepting deposits

    constructor(IERC20 _whackd) public {
        index = 10;
        ante = 0;
        minimumAnte = 0;
        settling = false;
        uniqueWallet = true;
        whackd = _whackd;
        suspend = false;
    }

    event ReceivedTokens(address from, uint value, address token, bytes extraData);

    Player[10] players;
    address[5] winners;

    struct Player {
        address payable addr;
        string identifier;
    }

    modifier validDeposit(address from, uint amount) {
        if (ante > 0) {
            require(amount == ante, "Ante is set: Must send exact amount");
        } else {
            require(amount > 0, "Must send a deposit, Ante is open.");
        }
        if (uniqueWallet){
            for (uint i = 0; i < players.length; i++) {
                require(from != players[i].addr, "Deposit must be from a unique wallet.");
            }
        }
        require(settling == false, "Cannot accept a deposit during settling process, try again in a moment.");
        _;
    }

    function receiveApproval(address payable from, uint256 amount, address token, bytes memory extraData) public validDeposit(from, amount){

        if (!suspend) {
            require(IERC20(token) == whackd, "This contract only accepts WHACKD.");
            require(amount > minimumAnte, "Deposit must be above minimum ante.");
            require(IERC20(token).transferFrom(from, address(this), amount), "Must Approve transaction first.");

            emit ReceivedTokens(from, amount, token, extraData);

            string memory s = utilities.uintToString(block.timestamp.mul(index));
            string memory id = utilities.substrReversed(s, 8, 10);

            Player memory newPlayer = Player({addr : from, identifier : id});
            index -= 1;
            players[index] = newPlayer;

            if (ante == 0) {
                ante = amount;
                start = now; // overwrite last round start time
            }
            if (index == 0) {
                settle();
            }
        } else {
            revert();
        }
    }

    /// @notice when the amount of entrants reaches ten, or round is forced, payouts are distributed
    function settle() internal {

        settling = true;
        uint kitty = 0;
        uint[] memory list = sortById();

        kitty = whackd.balanceOf(address(this));
        payouts(list, kitty);

        cleanUp();
    }

    /// @notice Calculates second place winners
    /// @param list a sorted list of ID's
    /// @param kitty the latest balance of the smart contract
    function payouts(uint[] memory list, uint kitty) public payable {

        if (settling) {
            Player memory player2;
            Player memory player3;
            Player memory player4;
            Player memory player5;

            for (uint i = 0; i < players.length; i++) {
                if (utilities.stringToUint(players[i].identifier) == list[1]) {
                    player2 = players[i];
                    list[1] = 1000; // clear channel 1 from further winners
                }
                else if (utilities.stringToUint(players[i].identifier) == list[2]) {
                    player3 = players[i];
                    list[2] = 1000;
                }
                else if (utilities.stringToUint(players[i].identifier) == list[3]) {
                    player4 = players[i];
                    list[3] = 1000;
                }
                else if (utilities.stringToUint(players[i].identifier) == list[4]) {
                    player5 = players[i];
                    list[4] = 1000;
                }
            }

            uint payout = kitty.div(7);
            uint house = payout.div(4);

            require(whackd.transfer(player2.addr, payout));
            require(whackd.transfer(player3.addr, payout));
            require(whackd.transfer(player4.addr, payout));
            require(whackd.transfer(player5.addr, payout));
            require(whackd.transfer(owner(), house));

            kitty = kitty.sub(payout.mul(4));
            kitty = kitty.sub(house);

            winners[1] = player2.addr;
            winners[2] = player3.addr;
            winners[3] = player4.addr;
            winners[4] = player5.addr;

            // first place
            uint kitty2 = whackd.balanceOf(address(this)); // refresh balance

            Player memory player;
            for (uint i = 0; i < players.length; i++) {
                if (utilities.stringToUint(players[i].identifier) == list[0]) {
                    for (uint j = 0; j < 4; j++) {
                        if (winners[j] == players[i].addr){
                            // don't assign prize to 2nd place winners
                        } else {
                            player = players[i];
                            break;
                        }
                    }
                }
            }

            winners[0] = player.addr;
            require(whackd.transfer(player.addr, kitty2));

        } else {
            revert('Cannot call function externally');
        }
    }


    /// @notice Generates a list of identifiers from ids struct (global)
    /// @return list of ids to be used in assigning prizes
    function sortById() internal view returns (uint[] memory){
        // generate a list of id's, sort them and compare with mapping, return keys
        uint[] memory identifiers = new uint[](players.length);
        for (uint i = 0; i < players.length; i++) {
            identifiers[i] = utilities.stringToUint(players[i].identifier);
        }
        return utilities.sort_array(identifiers);
    }

    /// @notice Revert to new round
    function cleanUp() internal {
        for (uint i = 0; i < 10; i++) {
            delete players[i];
        }
        index = 10;
        ante = 0;
        settling = false;
    }

    /// @notice Forces a round to complete after time interval is exceeded
    /// @param token In this case, the address of whackd token is required.
    /// @param amount The amount of tokens being sent in wei
    function forceRound(IERC20 token, uint256 amount) external payable validDeposit(msg.sender, amount){
        if (!suspend) {
            require(token == whackd, "This contract only accepts WHACKD.");
            require(amount > minimumAnte, "Deposit must be above minimum ante.");
            require(token.transferFrom(msg.sender, address(this), amount));

            if (now > start + 7 days) {

                string memory s = utilities.uintToString(block.timestamp.mul(index));
                string memory id = utilities.substrReversed(s, 8, 10);
                Player memory newPlayer = Player({addr : msg.sender, identifier : id});
                index -= 1;
                players[index] = newPlayer;

                /// @dev here the empty values in the players array is filled with sender
                uint count = index;
                for (uint i = count; i > 0; i--) {
                    index -= 1;
                    players[index] = newPlayer;
                }

                settle();
            }
        } else {
            revert();
        }
    }

    /// An old round can be forced
    function oldRound() external view returns (bool){
        if (now > start + 7 days) {
          return true;
        }
        return false;
    }

    /// @notice players can be identified from this by index
    /// @param id the id in the array to retrieve
    function currentPlayers(uint id) external view returns (address){
        return players[id].addr;
    }

    // @notice last round of winners can also be retrieved
    /// @param id the id in the array to retrieve
    function lastRound(uint id) external view returns (address){
        return winners[id];
    }

    /// @notice Owner may cancel any given round, issuing refunds. (sans burn amount)
    function refundAll() external payable onlyOwner {

        settling = true;
        uint divisor = 10 - index;
        uint kitty = whackd.balanceOf(address(this));
        uint payout = kitty.div(divisor);
        uint count = 0;
        for (uint i = 10; i > (10 - divisor); i--) {
            require(whackd.transfer(players[i - 1].addr, payout));
            count += 1;
        }
        cleanUp();
    }

    /// @notice Owner may set a minimum ante
    /// @param minAnte the amount to set, in wei, defaults to zero
    function setMinimumAnte(uint minAnte) external onlyOwner {
        require(index == 10, "Currently in a round.");
        minimumAnte = minAnte;
    }

    /// @notice Owner may set wallet requirement to be unique or allows multiple deposits.
    function toggleUniqueWallet() external onlyOwner {
       uniqueWallet = !uniqueWallet;
    }

    /// @notice Fallback function rejects any ether deposits
    function() external payable {
        revert();
    }

    /// @notice owner may suspend use of this smart contract for new version
    function toggleSuspend() external onlyOwner {
        if (index == 10){
            suspend = !suspend;
        }
    }

    /// @notice Owner can remove erroneously sent erc20's
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return IERC20(tokenAddress).transfer(owner(), tokens);
    }
}