/**
 *Submitted for verification at Etherscan.io on 2020-07-25
*/

// SPDX-License-Identifier: MIT

/*

 /$$   /$$                                           /$$           /$$$$$$$$                           
| $$  | $$                                          | $$          |__  $$__/                           
| $$  | $$  /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$ /$$$$$$           | $$  /$$$$$$   /$$$$$$   /$$$$$$ 
| $$$$$$$$ /$$__  $$| $$__  $$ /$$__  $$ /$$_____/|_  $$_/           | $$ /$$__  $$ /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$| $$  \ $$| $$$$$$$$|  $$$$$$   | $$             | $$| $$  \__/| $$$$$$$$| $$$$$$$$
| $$  | $$| $$  | $$| $$  | $$| $$_____/ \____  $$  | $$ /$$         | $$| $$      | $$_____/| $$_____/
| $$  | $$|  $$$$$$/| $$  | $$|  $$$$$$$ /$$$$$$$/  |  $$$$/         | $$| $$      |  $$$$$$$|  $$$$$$$
|__/  |__/ \______/ |__/  |__/ \_______/|_______/    \___/           |__/|__/       \_______/ \_______/
                                                                                                       
                                                                                                       

Visit The Honest Tree Game in http://htree.win or in http://www.HonestTree.win

Visit The Honest LABS in http://www.HonestLabs.win

Join our Telegram groups: https://t.me/HonestTree and https://t.me/HonestLabs

Buy HTK tokens (Hononest Tree Root node's rewards go to HTK token holders) in http://www.HonestLabs.win

*   The only tree/pyramid/multiply-your-eth type of game which is 100% honest on how does it works!

*   The only one with a 48 Hours  Money Back Guarantee!

*   The only one where YOU CAN BE IN THE VERY TOP by holding Honest Tokens (HTK)

*   The only one where you can make YOUR OWN COSTUMIZED REFERAL CODES. As much  as you want!

See www.honesttree.win for more information.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

How does it works:

- Players get refered
- Players pay a one-time fee: 0.04 ETH in early bird time (before August 1st 2020), 0.07 ETH afterwords:
- Players become a node of a basic general Tree (see https://en.wikipedia.org/wiki/Tree_%28data_structure%29
    where the root_node's ethereum address is the Honest Token (HTK) smart contract, that divided dividends among
    token holders. (See below for more information)
- Players can invite new players and build more branches. You get money up to the 3rd level (see below)
- By default your referal code will be your last 8 characters of your ethereum address.
- You can make your own costumized referal codes!!!!!

- Fees are distributed in 4 different rewards:
    -   40% to 1st level up parent node
    -   25% to 2nd level up parent node 
    -   15% to 3rd level up parent node (or to root node if 3rd level player is not Premium)
    -   20% to root node
    
- Basic players receive rewards from players who are in the 1st and 2nd level under their node.

- Premium players receive from their 1st, 2nd AND 3rd level.

- To become Premium it does cost 0.6 ETH. This means that in average, every one of your 
childs needs to have 4.06 childs for the Premium fee to give you positive revenues

- If you are not satisfied, you can GET YOUR MONEY BACK during the first 48 hours after your registration

- After 2 days, your participation is confirmed and you cannot recover out your participation fee.

- This means that you must wait the same amount of time (2 days) in order to withdraw your rewards from your child players


Root node's earnings:
- Root node rewards are accumulated and can only be transfered to Honest Token smart contract every 15 days.
- The Honest Token (HTK) smart contract distribute dividends among token holders.
- The maximum frecuency of 15 days is chosen in order to give certainty to token holders on the real value of the token,
    so they can profit by speculation

When does my investment is payed and I start earning money????

    - If you are Basic player; when you have 3 players under you.
    
    - If you payed to be Premium, when you have between 67 and 100 players in your 3rd level
        (depending on if they payed early bird fee or not). This means that in average, every
        child player should have invited 4.06-4.64 players each. It's not a lot. Very possible!
        
See http://www.HonestTree.win for more information
Write to contact@honestlabs.win
Or just join hour Telegram groups in: https://t.me/HonestTree and https://t.me/HonestLabs

                                               |
                                              -x-
                                               |
              v .   ._, |_  .,
           `-._\/  .  \ /    |/_
               \\  _\, y | \//
         _\_.___\\, \\/ -.\||
           `7-,--.`._||  / / ,
           /'     `-. `./ / |/_.'
                     |    |//
                     |_    /
                     |-   |
                     |   =|
                     |    |
--------------------/ ,  . \--------._


  

ascii tree taken from: https://ascii.co.uk/art/tree

*/





// File: contracts/openzeppelin-contracts/contracts/math/SafeMath.sol
// License: MIT

pragma solidity ^0.6.0;

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
     *
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
     *
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
     *
     * - Subtraction cannot overflow.
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
     *
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol

// License: MIT

pragma solidity ^0.6.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () internal {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: contracts/openzeppelin-contracts/contracts/GSN/Context.sol

// License: MIT

pragma solidity ^0.6.0;

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
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: contracts/openzeppelin-contracts/contracts/access/Ownable.sol

// License: MIT

pragma solidity ^0.6.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
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
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
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
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: contracts/HonestTreeGame.sol

pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

// License: MIT

/*

 /$$   /$$                                           /$$           /$$$$$$$$                           
| $$  | $$                                          | $$          |__  $$__/                           
| $$  | $$  /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$ /$$$$$$           | $$  /$$$$$$   /$$$$$$   /$$$$$$ 
| $$$$$$$$ /$$__  $$| $$__  $$ /$$__  $$ /$$_____/|_  $$_/           | $$ /$$__  $$ /$$__  $$ /$$__  $$
| $$__  $$| $$  \ $$| $$  \ $$| $$$$$$$$|  $$$$$$   | $$             | $$| $$  \__/| $$$$$$$$| $$$$$$$$
| $$  | $$| $$  | $$| $$  | $$| $$_____/ \____  $$  | $$ /$$         | $$| $$      | $$_____/| $$_____/
| $$  | $$|  $$$$$$/| $$  | $$|  $$$$$$$ /$$$$$$$/  |  $$$$/         | $$| $$      |  $$$$$$$|  $$$$$$$
|__/  |__/ \______/ |__/  |__/ \_______/|_______/    \___/           |__/|__/       \_______/ \_______/
                                                                                                       
                                                                                                       

Visit The Honest Tree Game in http://htree.win or in http://www.HonestTree.win

Visit The Honest LABS in http://www.HonestLabs.win

Join our Telegram groups: https://t.me/HonestTree and https://t.me/HonestLabs

Buy HTK tokens (Hononest Tree Root node's rewards go to HTK token holders) in http://www.HonestLabs.win

*   The only tree/pyramid/multiply-your-eth type of game which is 100% honest on how does it works!

*   The only one with a 48 Hours  Money Back Guarantee!

*   The only one where YOU CAN BE IN THE VERY TOP by holding Honest Tokens (HTK)

*   The only one where you can make YOUR OWN COSTUMIZED REFERAL CODES. As much  as you want!

See www.honesttree.win for more information.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

How does it works:

- Players get refered
- Players pay a one-time fee: 0.04 ETH in early bird time (before August 1st 2020), 0.07 ETH afterwords:
- Players become a node of a basic general Tree (see https://en.wikipedia.org/wiki/Tree_%28data_structure%29
    where the root_node's ethereum address is the Honest Token (HTK) smart contract, that divided dividends among
    token holders. (See below for more information)
- Players can invite new players and build more branches. You get money up to the 3rd level (see below)
- By default your referal code will be your last 8 characters of your ethereum address.
- You can make your own costumized referal codes!!!!!

- Fees are distributed in 4 different rewards:
    -   40% to 1st level up parent node
    -   25% to 2nd level up parent node 
    -   15% to 3rd level up parent node (or to root node if 3rd level player is not Premium)
    -   20% to root node
    
- Basic players receive rewards from players who are in the 1st and 2nd level under their node.

- Premium players receive from their 1st, 2nd AND 3rd level.

- To become Premium it does cost 0.6 ETH. This means that in average, every one of your 
childs needs to have 4.06 childs for the Premium fee to give you positive revenues

- If you are not satisfied, you can GET YOUR MONEY BACK during the first 48 hours after your registration

- After 2 days, your participation is confirmed and you cannot recover out your participation fee.

- This means that you must wait the same amount of time (2 days) in order to withdraw your rewards from your child players


Root node's earnings:
- Root node rewards are accumulated and can only be transfered to Honest Token smart contract every 15 days.
- The Honest Token (HTK) smart contract distribute dividends among token holders.
- The maximum frecuency of 15 days is chosen in order to give certainty to token holders on the real value of the token,
    so they can profit by speculation

When does my investment is payed and I start earning money????

    - If you are Basic player; when you have 3 players under you.
    
    - If you payed to be Premium, when you have between 67 and 100 players in your 3rd level
        (depending on if they payed early bird fee or not). This means that in average, every
        child player should have invited 4.06-4.64 players each. It's not a lot. Very possible!
        
See http://www.HonestTree.win for more information
Write to contact@honestlabs.win
Or just join hour Telegram groups in: https://t.me/HonestTree and https://t.me/HonestLabs

                                               |
                                              -x-
                                               |
              v .   ._, |_  .,
           `-._\/  .  \ /    |/_
               \\  _\, y | \//
         _\_.___\\, \\/ -.\||
           `7-,--.`._||  / / ,
           /'     `-. `./ / |/_.'
                     |    |//
                     |_    /
                     |-   |
                     |   =|
                     |    |
--------------------/ ,  . \--------._


  

ascii tree taken from: https://ascii.co.uk/art/tree

*/





// The Honest Token (HTK) has a bounty program for the first 3 projects of the Honest LABS
// One of these projects is the Honest Tree Game.
// In order to reward the first 100 players, we need an interface of the token contract in order to send them tokens.

interface HTK_Token {
    function balanceOf(address owner) external returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool); //token transfer function 
    function decimals() external returns (uint256);
    function withdrawFunds() external;
    function distributeFunds() external payable returns (bool);
}


contract HonestTreeGame is ReentrancyGuard, Ownable{
    
    using SafeMath for uint256;
    
    // The only thing that the Owner can do is to call the closeGame() function
    // Which can only be called after 180 days without any new player or without any new premium subscription.
    // The closeGame() function will close the game and send all balance Honest Token (HTK) holders.
    
    // WE ARE HONEST! ALL FEES are transfered to parents nodes (referals)
    // and 20% is transferred to Honest Token (HTK) holders in root_node address;
    
    
    address payable public root_node; //Honest Token (HTK) contract address
    HTK_Token public HTK_tokenContract; // The same! But now as an HTK_Token Contract Interface Object. 
    // This interface is to give away the free HTK for the first 100 players
    
    
    
    uint256 public participation_fee;
    uint256 public early_bird_participation_fee;
    uint256 public premium_fee;
    mapping(string => address) private aliases;
    uint private DAY_IN_SECONDS;
    uint public contract_creation_date;
    uint public last_participation_date;
    uint public early_bird_deadline;
    bool public early_bird;
    uint public guarantee_period;
    uint public root_node_withdraw_frecuency;
    
    
    uint256 public first_level_up_reward;
    uint256 public second_level_up_reward;
    uint256 public third_level_up_reward;
    uint256 public fourth_level_up_reward;
    
    uint256 public first_level_up_reward_percentage;
    uint256 public second_level_up_reward_percentage;
    uint256 public third_level_up_reward_percentage;
    uint256 public fourth_level_up_reward_percentage;
    
    
    
    // Numbers about the currente sate of the game
    uint256 public sum_all_time_players;
    uint256 public confirmed_count; // Helps to give free HTK to the first 100 confirmed players
    uint256 public abort_count;
    uint256 public sum_total_investment;
    
    //To track all-time payed premium fees
    uint256 public sum_premium_fees;
    uint256 public root_node_premium_fees_already_withdrawn;
    uint public last_root_node_withdraw_date;

    enum PlayerStatus {NOT_YET, PARTICIPATING, CONFIRMED, ABORTED}
    struct Player {
        // Referals
         address first_level_parent_node;
         address second_level_parent_node;
         address third_level_parent_node;
         
         // Date (in days since contract creation)
         uint256 sign_up_date; 
         uint256 sign_up_epoch_time; 
         
         //Each down-level player will push its address in one of these arrays
         address[] first_level_down_players;
         address[] second_level_down_players;
         address[] third_level_down_players;
         address[] fourth_level_down_players;
         
         
         // To keep track of the rewards you have lost for not being Premium yet!
         uint256 third_level_down_rewards_if_premium; 
         
         // Mapping to track registered rewards per date (days since contract creation)
         mapping(uint256 => uint256) confirmed_rewards_per_date; 
         
        // Array to track child registration dates (days since contract creation)
         uint256[] interaction_dates;
         
         //{NOT_YET, PARTICIPATING, CONFIRMED, ABORTED}
         // NOT_YET is the default value for non-existent players
         PlayerStatus status;
         
         //Tracking total ETH already withdrawn by the user.
         uint256 total_withdrawn;
         
         // Tracking all custom aliases.
         string[] my_aliases;
         
         // Premium Player
         bool is_premium;
         
         //Did this player payed an Early Bird fee?. Helps if this player wants to quit the game and ask for refund.
         bool is_early_bird;
        
    }
    
    mapping(address => Player) public players;
    
    
    
    event newPlayer(address player_address, string referal);
    event repentant( address player_address);

    constructor(HTK_Token _HTK_tokenContract, address payable _HTK_tokenContract_address) public{
        
        root_node=_HTK_tokenContract_address;
        HTK_tokenContract=_HTK_tokenContract;
        
        early_bird_participation_fee=40 finney; // 0.04 during Early Bird
        participation_fee=70 finney;       //  0.07 after Early Bird
        
        
        // Epoch timestamp: 1596239999
        // Date and time (GMT): Friday, July 31, 2020 11:59:59 PM
        early_bird_deadline=1596239999;
        
        guarantee_period=2; // 48 hours guarantee period (2-day)
        // guarantee will be from 2; guarantee_period until guarantee_period+1
        
        
        // Root node's revenues can be withdraw every 15 days.
        // This gives time to speculate on the HTK token value.
        root_node_withdraw_frecuency=15; 
        
        
        early_bird=true;
        
        first_level_up_reward_percentage=40;
        second_level_up_reward_percentage=25;
        third_level_up_reward_percentage=15;
        fourth_level_up_reward_percentage=20; // To Honest Token's Holders
        
        first_level_up_reward=early_bird_participation_fee*first_level_up_reward_percentage/100;   //  0.016  ETH = 40% to first level IN EARLY BIRD
        second_level_up_reward=early_bird_participation_fee*second_level_up_reward_percentage/100;  //  0.01 ETH = 25% to second level IN EARLY BIRD
        third_level_up_reward=early_bird_participation_fee*third_level_up_reward_percentage/100;   //  0.006 ETH = 15% to third level IN EARLY BIRD
        fourth_level_up_reward=early_bird_participation_fee*fourth_level_up_reward_percentage/100;  //  0.008 ETH = 20% to HTK token holders IN EARLY BIRD
        
        sum_premium_fees=0;
        premium_fee=600 finney; //0.6 ETH to be premium
        
        sum_all_time_players=0;
        confirmed_count=0;
        abort_count=0;
        last_participation_date=now;
        last_root_node_withdraw_date=now;
        
        DAY_IN_SECONDS=86400;
        contract_creation_date=now;
        
        //Root node registration
        players[root_node].first_level_parent_node=root_node;
        players[root_node].second_level_parent_node=root_node;
        players[root_node].third_level_parent_node=root_node;
        players[root_node].sign_up_date=0; // date in days since creation
        players[root_node].sign_up_epoch_time=now;
        string memory _my_alias=addressToAlias(root_node);
        aliases[_my_alias]=root_node;
        players[root_node].my_aliases.push(_my_alias);
        
        players[root_node].status=PlayerStatus.CONFIRMED;
        players[root_node].is_premium=true;
        players[msg.sender].is_premium=true;
        players[root_node].total_withdrawn=0;
        players[root_node].is_early_bird=true;
        
    }
    
    function addressToAlias(address _addr) private view returns(string memory) {
        bytes32 value = bytes32(uint256(_addr));
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(8); // we thinkg that 8 lenght aliases are long enough
        
        // For the first condition not to be checked inmediatelly, we choose a known existant alias:
        // Read the code carefully!
        bool _alias_exists=true;
        string memory _my_alias;
        uint j=0;
        
        //The following loop should iterate almost never. Just in case that your last 8 characters of your address are
        // exactely the last 8 charaters of another player. Very unlikely, but possible.
        //In that case will run once.
        
        while (_alias_exists){ //While this alias already existsl, tries to find anotherone
            for (uint i = 0; i < 4; i++) {
                str[i*2] = alphabet[uint(uint8(value[i + 28 - j] >> 4))];
                str[1+i*2] = alphabet[uint(uint8(value[i + 28 - j] & 0x0f))];
            }
            _my_alias=string(str);
            j+=1;
            _alias_exists=!isTeamNameAvailable(_my_alias);
            require(j<4,'You should use another address!, we dont want to consume all your gas');
        }
        return _my_alias;
    }
    
    function isTeamNameAvailable(string memory _new_team_name) public view returns (bool){
        // If the alias don't exist, then aliases[_new_team_name]=address(0x0)
        return (aliases[_new_team_name]==address(0x0));
    }
    
    
    modifier correctParticipationFee() { 
        if(early_bird){
        require(msg.value >= early_bird_participation_fee,'Please send at least 0.04 ETH'); _; }
        else {
        require(msg.value >= participation_fee,'Please send at least 0.06 ETH'); _; }        

    }
    
    modifier notParticipant(){require(players[msg.sender].status!=PlayerStatus.PARTICIPATING,'You are already participating'); _;}
    modifier notConfirmed(){require(players[msg.sender].status!=PlayerStatus.CONFIRMED,'You are already a confirmed player'); _;}
    
    // If someone just send money to the game (would not happen if they play on the website)
    fallback() external payable {
        participateWithReferal('root_node');
    }
    
    // If someone just send money to the game (would not happen if they play on the website)
    receive() external payable {
        participateWithReferal('root_node');
    }

    function participateWithReferal(string memory _my_referal_alias)
        nonReentrant
        correctParticipationFee
        notParticipant // We don't allow double registration.
        notConfirmed 
        public
        payable
        {
            last_participation_date=now;
            
            if(now>=early_bird_deadline){
                players[msg.sender].is_early_bird=false;
                sum_total_investment=sum_total_investment+participation_fee;
                
                
                if(early_bird==true) {
                    // This will run just once
                    //If early bird is over, we update values for next players.
                    early_bird=false;
                    first_level_up_reward=participation_fee*first_level_up_reward_percentage/100;   //  0.028  ETH = 40% to first level
                    second_level_up_reward=participation_fee*second_level_up_reward_percentage/100;  //  0.0175 ETH = 25% to second level
                    third_level_up_reward=participation_fee*third_level_up_reward_percentage/100;   //  0.0105 ETH = 15% to third level
                    fourth_level_up_reward=participation_fee*fourth_level_up_reward_percentage/100;  //  0.014 ETH = 20% to HTK token holders
                    
                }
                
            }
            else{
                players[msg.sender].is_early_bird=true;
                sum_total_investment=sum_total_investment+early_bird_participation_fee;
            }
            
            //We allow previouslly aborted players.
            address _my_referal_address;
            bool new_player;
            
            if (players[msg.sender].status==PlayerStatus.ABORTED){
                
                // If you aborted before, we are happy that you came back!!!
                new_player=false;
                
                //You will recover all the aliases (team names) you made!. 
                // This is because they where sent to root_node when you keft the game
                
                for (uint i=0; i<players[msg.sender].my_aliases.length;i++){
                    aliases[players[msg.sender].my_aliases[i]]=msg.sender;
                }
                
                
                
                //If the player previouslly aborted his participation and asked for a refund, he will be accepted again :)
                //However, now, he will be registered as CONFIRMED, so he cannot ask for a refund again.
                //No second chances, my friend. By subscribing again, you'll be directly be CONFIRMED.
                players[msg.sender].status=PlayerStatus.CONFIRMED;
                
                //Referals don't change, even if the player tries to reister again with a new referal
            }
            else {
                new_player=true;
                players[msg.sender].status=PlayerStatus.PARTICIPATING;  
                 // If the referal alias does not exist, it links it to the root_node
                if (aliases[_my_referal_alias]==address(0x0)) { 
                    _my_referal_address=aliases['root_node'];
                }
                else{
                    // But if the alias is correct, you are now linked with your referral :D :D !!!!
                    _my_referal_address=aliases[_my_referal_alias];
                }
                
                
                //We then create a new Player object, indexed by the msg.sender address.
                string memory _my_alias=addressToAlias(msg.sender);
                players[msg.sender].my_aliases.push(_my_alias); 
                aliases[_my_alias]=msg.sender;
                
                players[msg.sender].first_level_parent_node=_my_referal_address;
                players[msg.sender].second_level_parent_node=
                    players[players[msg.sender].first_level_parent_node].first_level_parent_node;
                
                
                players[msg.sender].total_withdrawn=0;
            }
            
            //For previouslly aborted players, third_level_parent_node must be calculated again.
            //In the case the third_level_parent_node became Premium during this time :)
            
            address _third_level_parent_node=players[players[msg.sender].second_level_parent_node].first_level_parent_node;
            
            if (!players[_third_level_parent_node].is_premium) {
                //If the third level parent node is not yet Premium, we add the reward to the "if you where premium".
                // Not only for new players.
                if(new_player) {
                    //players[_third_level_parent_node].third_level_down_players_if_premium.push(msg.sender);
                    players[_third_level_parent_node].third_level_down_rewards_if_premium+=third_level_up_reward;
                    
                }
                
                // If third level is not Premium, it is then given to root_node;
                _third_level_parent_node=root_node;
            }
            
            players[msg.sender].third_level_parent_node=_third_level_parent_node;
                    
                
            
            
            uint256 _today = getParticipationDayToday();
            // For sake of simplicity, and in order to avoid loops, even previouslly aborted players, will sign up with a date of today.
            // (previouslly aborted players will update their sign_up_date)
            players[msg.sender].sign_up_date=_today;
            players[msg.sender].sign_up_epoch_time=now;
            
            //Subscribe 1 level up
            if(new_player) {players[players[msg.sender].first_level_parent_node].first_level_down_players.push(msg.sender);}
            pushPlayerReward(players[msg.sender].first_level_parent_node,first_level_up_reward,_today);
            
            
            //Subscribe 2 level up
            if(new_player) {players[players[msg.sender].second_level_parent_node].second_level_down_players.push(msg.sender);}
            pushPlayerReward(players[msg.sender].second_level_parent_node, second_level_up_reward,_today);
            

            if(new_player) {players[_third_level_parent_node].third_level_down_players.push(msg.sender);}
            pushPlayerReward(_third_level_parent_node, third_level_up_reward,_today);
            
            //Lastly, 4th level up is always root_node:
            if(new_player) {players[root_node].fourth_level_down_players.push(msg.sender);}
            pushPlayerReward(root_node, fourth_level_up_reward,_today);
            
            //emits participation with referal's alias.
            if(new_player) {
                emit newPlayer(msg.sender, _my_referal_alias);
                sum_all_time_players=sum_all_time_players.add(1); }
            else { 
                emit repentant(msg.sender); 
                
            }
            
        }
    
    function getParticipationDayToday() public view returns (uint256) {
        return ((now.sub(contract_creation_date))/DAY_IN_SECONDS);
    }
    
    function pushPlayerReward(
        address _parent_node,
        uint256 _reward,
        uint256 _today) private {
            // In this function, a new player will be regitered in it's parents-node's Player struct
            // This registration is made in a way that allows any player to abort it's participation at any time before its
            // first 14 days after registration.
            // This means that there must be a way to track confirmed rewards in order to be able to withdraw them.
            // This is made by using the 
            //  * players[_parent_node].interaction_dates array, and the
            //  * players[_parent_address].confirmed_earnings_per_date[_today] mapping
            // Here the new player will add his reward to players[_parent_address].confirmed_earnings_per_date[_today], a
            // mapping tracking all rewards collected by the parent node through all history.
            // To do this, first he needs to check if players[_parent_address].confirmed_earnings_per_date[_today] exist, and if not
            // create it and sum the collected rewards registered in previous dates.
            
            // See withdraw() and askRefund() functions for more information
            
            uint _interaction_dates_lenght=players[_parent_node].interaction_dates.length; //Help variable
            
            if(_interaction_dates_lenght==0) {
                // This means that no one has been registered yet ==>  The new player is the first child
                
                // Pushes the current date
                players[_parent_node].interaction_dates.push(_today);
                // And inicialize the reward registration.
                players[_parent_node].confirmed_rewards_per_date[_today]=_reward;
            }
            else {
                //If some date has already been registered, reward registration should not be inicialize, but it should be added.
                // However, it is the first new child player one of the day?
                
                if (players[_parent_node].interaction_dates[_interaction_dates_lenght.sub(1)]<_today) {
                    // Last interaction registration was in a previous day ==> Child player is the first one of the day
                    
                    // Pushes the current date
                    players[_parent_node].interaction_dates.push(_today);
                    
                    // Sums its reward with the previous accumulated rewards
                    players[_parent_node].confirmed_rewards_per_date[_today]=
                        players[_parent_node].confirmed_rewards_per_date[
                            players[_parent_node].interaction_dates[_interaction_dates_lenght.sub(1)] // previous registered day
                        ].add(_reward); // Sums the previous registered day acumulated reward, with the new player's reward
                        
                }
                else{
                    // If the last registered day is today ==> No need for pushing current date. 
                    // And the new player just needs to sums his reward with the acumulated reward registered for today
                    players[_parent_node].confirmed_rewards_per_date[_today]=
                        players[_parent_node].confirmed_rewards_per_date[_today].add(_reward);
                }
                
            }
            
        
    }
    
    modifier correctPremiumFee() { require(msg.value >= premium_fee,'Please send at least 1 ETH'); _; }
    
    function confirmMyParticipation()
        public
        activePlayer
        notAborted {
            require(players[msg.sender].status==PlayerStatus.PARTICIPATING);
            players[msg.sender].status=PlayerStatus.CONFIRMED;
            
            confirmed_count=confirmed_count.add(1); 
            // We reward the first 100 confirmed players with 100 HTK tokens.
            if (confirmed_count<=100){
                if (HTK_tokenContract.balanceOf(address(this))>=(500*10**HTK_tokenContract.decimals()))
                {
                    HTK_tokenContract.transfer(msg.sender, (500*10**HTK_tokenContract.decimals())); 
                }
            }
        
        }
        
    
    function becomePremium()
        nonReentrant
        public
        activePlayer
        notAborted
        correctPremiumFee
        payable {
            last_participation_date=now;
            
            players[msg.sender].status=PlayerStatus.CONFIRMED;
            sum_premium_fees=sum_premium_fees.add(msg.value);
            sum_total_investment=sum_total_investment.add(msg.value);
            players[msg.sender].is_premium=true;
        }
        
    function sumbitNewTeamName(string memory _new_team_name)
        nonReentrant
        public
        activePlayer
        notAborted {
            require(isTeamNameAvailable(_new_team_name), "That team name is not available!" );
            require(players[msg.sender].my_aliases.length<5,"You have alreade created your 5 custom team name!");
            players[msg.sender].my_aliases.push(_new_team_name);
            aliases[_new_team_name]=msg.sender;
        }
    
    modifier notAborted() { 
        require(players[msg.sender].status!=PlayerStatus.ABORTED,
        'You already aborted your participation. Please join the game again :).'); _;}
        
    modifier activePlayer(){ require(
        (players[msg.sender].status==PlayerStatus.CONFIRMED || players[msg.sender].status==PlayerStatus.PARTICIPATING),
        'You are not an active player. Please join the game :).'); _;}
        
    function withdrawPlayer()
        nonReentrant
        public
        notAborted
        activePlayer{
            uint256 _amount=withdrawCalculation(msg.sender);
            //Finally, we send.
            (bool success, ) = msg.sender.call{value: _amount}("");
            require(success, "Transfer failed.");
            
            emit withdraw_event(msg.sender,_amount);
            
        }
        
    function withdrawRootNodeRevenues()
        nonReentrant
        public
    {
        // Anyone can call this function!!!!
        
        
        // Once every (at least) 30 days,The Honest Tree's Root Node Revenues are sent to the Honest Token (HTK)
        // smart contract in order to be distribute them among token holders!!
        
        
        require(now>last_root_node_withdraw_date,'Last root node withdraw was just now!');
        
        // Maximum frecuency once every 90 days
        require((now-last_root_node_withdraw_date)>(root_node_withdraw_frecuency*DAY_IN_SECONDS),
            'Root node withdraws should be done with a minimum of 15 days difference');
        
        last_root_node_withdraw_date=now;
        
        // calculate current participation rewards to be withdrawn (as any other player!)
        uint256 _amount_participation_fees=withdrawCalculation(root_node);
        
        // calculate current premium fees to be withdrawn
        uint256 _amount_premium_fees=sum_premium_fees.sub(root_node_premium_fees_already_withdrawn);
        
        root_node_premium_fees_already_withdrawn=root_node_premium_fees_already_withdrawn.add(_amount_premium_fees);
        
        (bool success) = HTK_tokenContract.distributeFunds{value: _amount_participation_fees.add(_amount_premium_fees)}();
        require(success, "Transfer failed.");
            
        emit root_node_withdraw_event(_amount_participation_fees.add(_amount_premium_fees));    
        
        
    
    }
    
    event root_node_withdraw_event(uint256 _amount_windrawn);
    
    
    
    modifier isPlayerParticipating(address _player){
        require((players[_player].status==PlayerStatus.PARTICIPATING) || (players[_player].status==PlayerStatus.CONFIRMED),
                'Player is not participant');_;}
    
    function getPlayerConfirmedRewards(address _player) 
        public
        view
        returns (uint256) {
            uint256 _today = getParticipationDayToday();
            uint _interaction_dates_length=players[_player].interaction_dates.length;
            
            if((_today<=guarantee_period) || (_interaction_dates_length==0)) {
                return 0; // too early or no childs yet
            } 
            
            if(players[_player].interaction_dates[0].add(guarantee_period) >= _today){
                return 0; // no child is yet confirmed
            }
            
            //1. Calculate te available confirmed rewards. This is the only loop. And will lopp up to a maximum of 4 (2+2) times.
            // But if the last child registration was more than 2 days ago, this loop will work only once.
            
            for(uint t = 1; t < guarantee_period+3; t++)
            {
                if (t>_interaction_dates_length){
                    return 0; // This yould not happen at this time.
                }
                
                uint _my_interaction_day=players[_player].interaction_dates[_interaction_dates_length.sub(t)];
                if (_my_interaction_day<_today.sub(guarantee_period))
                {
                    return players[_player].confirmed_rewards_per_date[_my_interaction_day];
                    
                }
                
            }
        // If no child has completed the guarantee period yet:
        return 0;
    }
        
    
  
        
    function withdrawCalculation(address _player) private returns (uint256 _amount)
        {
            
            uint256 _confirmed_rewards=getPlayerConfirmedRewards(_player);
            
            require(_confirmed_rewards>0,'You have nothing to withdraw yet... Keep spamming!');
            require(_confirmed_rewards>players[_player].total_withdrawn,'You have already withdawn everything for the moment!');
            
            //1. Confirm the player's participation:
            if (players[_player].status==PlayerStatus.PARTICIPATING){
                //This won't happen in root_node withdraw, as root node is already "confirmed player"
                confirmMyParticipation();
            }
            
            //Calculate the amount to withdraw.
            _amount=_confirmed_rewards-players[_player].total_withdrawn;
            
            //We update now in order to avoid reentrancy attacks.
            players[_player].total_withdrawn=
                players[_player].total_withdrawn.add(_amount);
            
            require(_confirmed_rewards==players[_player].total_withdrawn, "Reentrancy guard.");
            
            return(_amount);
            
    }
    
    event withdraw_event(address _player,uint256 _amount);
 
 /*
        BIG DISCLAIMER:
        All the contract has been developed in order to AVOID ITERATIONS and LOOPS as much as possible
        However if you want to abort your participation, and if you had childs registered, we need to make shure
        that those child will be able to abort themselves if they want... and that those funds don't get lost in the contract.
        
        In theory, this sould not happen, because there is no reason to abort if you have several childs under you... But who knows...
        
        This is why some of the following functions involve iterations. But non of them will loop more than 2 times
        (we need to re-write history until at a maximum of 2 days in the past, because that's the guarantee period)
        
 */

 
    function abort() 
        nonReentrant
        public
        notAborted
        activePlayer
        notConfirmed
        {
            // Even if we have a nonReentrant Guard, we change inmediatelly the player status.
            players[msg.sender].status=PlayerStatus.ABORTED;
            abort_count=abort_count.add(1);
            
            // To recover rewards, we need to go and look for all register made in your parents level between these dates.
            uint256 _sign_up_date=players[msg.sender].sign_up_date;
            uint256 _today=getParticipationDayToday();
            
            // Avoid underflow.
            require(_today>=_sign_up_date);
            require(_today.sub(_sign_up_date)<=guarantee_period,'Too many days have already passed. Too late! We are sorry!');
            
            uint256 _my_first_level_up_reward;
            uint256 _my_second_level_up_reward;
            uint256 _my_third_level_up_reward;
            uint256 _my_fourth_level_up_reward;
            uint256 _my_participation_fee;
            
            if(players[msg.sender].is_early_bird){
                _my_first_level_up_reward=early_bird_participation_fee*first_level_up_reward_percentage/100;
                _my_second_level_up_reward=early_bird_participation_fee*second_level_up_reward_percentage/100; 
                _my_third_level_up_reward=early_bird_participation_fee*third_level_up_reward_percentage/100;   
                _my_fourth_level_up_reward=early_bird_participation_fee*fourth_level_up_reward_percentage/100; 
                _my_participation_fee=early_bird_participation_fee;
            }
            else {
                _my_first_level_up_reward=participation_fee*first_level_up_reward_percentage/100;
                _my_second_level_up_reward=participation_fee*second_level_up_reward_percentage/100;  
                _my_third_level_up_reward=participation_fee*third_level_up_reward_percentage/100;   
                _my_fourth_level_up_reward=participation_fee*fourth_level_up_reward_percentage/100; 
                _my_participation_fee=participation_fee;
                
            }
            
            //pull-out participation from 1st level up
            pullPlayerReward(players[msg.sender].first_level_parent_node, _my_first_level_up_reward, _sign_up_date);
            
            //pull-out participation from 2st level
            pullPlayerReward(players[msg.sender].second_level_parent_node, _my_second_level_up_reward, _sign_up_date);
            
            //pull-out participation from 3rd level
            pullPlayerReward(players[msg.sender].third_level_parent_node, _my_third_level_up_reward, _sign_up_date);
            
            //pull-out participation from root node (4th level)
            pullPlayerReward(root_node, _my_fourth_level_up_reward, _sign_up_date);
            
            
            // In order for your aliases to continue working, We will redirect all your alisases to your PARENT node
            // The Tree moves ONE LEVEL UP in case that someone leaves the game!
            
            //Yess, If you created too much aliases, to abort does cost gas!
            for (uint i=0; i<players[msg.sender].my_aliases.length;i++){
                aliases[players[msg.sender].my_aliases[i]]=players[msg.sender].first_level_parent_node;
            }
            
            //In case that during these <2 days you managed to collect some rewards:
            // One easy way to see if you have at least one child, is to see your interaction_dates:
            if(players[msg.sender].interaction_dates.length>0){
                transferMyRewardsAndChildsToRootNode(_today);
            }
            
            
            //Finally, the happy part: we send you the money.
            
            (bool success, ) = msg.sender.call{value:_my_participation_fee}("");
            require(success, "Refund transfer failed :( ");
            
            emit abort_event(msg.sender);
            
        }
    
    event abort_event(address _player);
    
    function pullPlayerReward(address _parent_node, uint256 _reward, uint _sign_up_date) private {
        
        uint _interaction_dates_lenght=players[_parent_node].interaction_dates.length;
        //This loop has a maximum of 4 iterations. It does cost gas to abort!
        for (uint t=1; t<guarantee_period+3;t++){
            if(t>_interaction_dates_lenght){
                break;
            }
            
            uint _interaction_day=players[_parent_node].interaction_dates[_interaction_dates_lenght.sub(t)];
            
            if(_interaction_day>=_sign_up_date){
                //Remember that confirmed_rewards_per_date collects all rewards from history:
                // rewards today = rewards yesterday + new rewards today
                players[_parent_node].confirmed_rewards_per_date[_interaction_day]=
                        players[_parent_node].confirmed_rewards_per_date[_interaction_day].sub(_reward);
            }
            else {
                //Everything is clean :)
                break;
            }
            
        }
        return;
    }
    
    
    function transferMyRewardsAndChildsToRootNode(uint256 _today) private {
        // Again: It will be very strange that this function will be called.... because no one should abort having childs....
        // But in order to make the contract strong, we think in every possible case.
        
        // First parent_node addresses:
        if (players[msg.sender].first_level_down_players.length>0){
            //The following loops should not be long: First we think that if you aborted, you should't have more than 2 childs to transfer.
            for(uint i=0;i<players[msg.sender].first_level_down_players.length;i++){
                //Transfering child to root_node
                players[players[msg.sender].first_level_down_players[i]].first_level_parent_node=root_node;
                players[msg.sender].first_level_down_players[i]=address(0x0);
            }
        }
        
        if (players[msg.sender].second_level_down_players.length>0){
            //The following loops should not be long: First we think that if you aborted, you should't have more than 2 childs to transfer.
            for(uint i=0;i<players[msg.sender].second_level_down_players.length;i++){
                players[players[msg.sender].second_level_down_players[i]].second_level_parent_node=root_node;
                players[msg.sender].second_level_down_players[i]=address(0x0);
            }
        }
        
        
        // And all the following loops have a maximum of 4 iterations in TOTAL.
        uint _my_interaction_dates_length=players[msg.sender].interaction_dates.length;
        
        
        //rewards registered in the last day must be written until today
        uint _my_last_day=players[msg.sender].interaction_dates[_my_interaction_dates_length.sub(1)];
        uint _reward_to_transfer=players[msg.sender].confirmed_rewards_per_date[_my_last_day];
        
        players[msg.sender].confirmed_rewards_per_date[_my_last_day]=0;
        
        for (uint j=_my_last_day;j<=_today;j++){
            //If there has been interaction, we add
            if(players[root_node].confirmed_rewards_per_date[j]>0){    
                players[root_node].confirmed_rewards_per_date[j]=
                    players[root_node].confirmed_rewards_per_date[j].add(_reward_to_transfer);
            }
        }
        
        //For other dates than the last one; (only if you had more than one child at time of abortion)
        // Again! You should not have aborted if you had more than one child!
        if(_my_interaction_dates_length>1){
            for (uint i=0;i<_my_interaction_dates_length.sub(2);i++){
                _my_last_day=players[msg.sender].interaction_dates[i];
                _reward_to_transfer=players[msg.sender].confirmed_rewards_per_date[_my_last_day];
                players[msg.sender].confirmed_rewards_per_date[_my_last_day]=0;
                
                //Days in between, not uncluding the next interaction day.
                for (uint j=_my_last_day;j<players[msg.sender].interaction_dates[i+1];j++){
                    //If there has been interaction, we add
                    if(players[root_node].confirmed_rewards_per_date[j]>0){    
                        players[root_node].confirmed_rewards_per_date[j]=
                            players[root_node].confirmed_rewards_per_date[j].add(_reward_to_transfer);
                    }
                }
            }
        }
    }
    
    
    // ---------------------------------------------------------------------------------------
    // ---------------------------------------------------------------------------------------
    // ---------------------------------------------------------------------------------------
    // ---------------------------------------------------------------------------------------
    // ---------------------------------------------------------------------------------------
    // ---------------------------------------------------------------------------------------
    ///////////////////// Useful functions for WEBSITE FRONT END
    // ---------------------------------------------------------------------------------------
    // ---------------------------------------------------------------------------------------
    // ---------------------------------------------------------------------------------------
    // ---------------------------------------------------------------------------------------
    // ---------------------------------------------------------------------------------------
    
    function getPlayerPotentialRewards(address _player) public view returns (uint) {
        
            uint _interaction_dates_lenght=players[_player].interaction_dates.length;
            
            if (_interaction_dates_lenght==0){
                return 0;
            }
            else {
                uint _last_interaction_day=players[_player].interaction_dates[_interaction_dates_lenght.sub(1)];
                return players[_player].confirmed_rewards_per_date[_last_interaction_day];
            }
    }
    
    
    function getPlayerAliases(address _player) public view returns(string[] memory){
        return  players[_player].my_aliases;
    }
    
    function getPlayerInteractionDatesArray(address _player) public view returns(uint256[] memory){
        return  players[_player].interaction_dates;
    }
    function getPlayerInteractionDates(address _player, uint _index) public view returns(uint){
        return  players[_player].interaction_dates[_index];
    }
    
    function getPlayerInteractionDatesLenght(address _player) public view returns(uint){
        return  players[_player].interaction_dates.length;
    }
    
    
    function getPlayerConfirmedRewardsPerDate(address _player, uint _date) public view returns(uint){
        return  players[_player].confirmed_rewards_per_date[_date];
    }
    
    function getPlayerFirstLevelDownChilds(address _player) public view returns(address[] memory ){
        return  players[_player].first_level_down_players;
    }
    
    function getPlayerSecondLevelDownChilds(address _player) public view returns(address[] memory){
        return  players[_player].second_level_down_players;
    }
    
    function getPlayerThirdLevelDownChilds(address _player) public view returns(address[] memory){
        return  players[_player].third_level_down_players;
    }
    
    function getPlayerThirdLevelDownChildsNumber(address _player) public view returns(uint){
        return  players[_player].third_level_down_players.length;
    }
    
    function getPlayerFourthLevelDownChilds(address _player) public view returns(address[] memory){
        return  players[_player].fourth_level_down_players;
    }
    
    
    
    function getPlayerTotalChildsNumber(address _player) public view returns(uint){
        return players[_player].first_level_down_players.length +
                    players[_player].second_level_down_players.length + 
                    players[_player].third_level_down_players.length;
    }
    
//    function getPlayerConfirmedChildsNumber(address _player) public view returns(uint){
//    This function can have a lot of loops, so this will be ran in the front end client. from the previous arrays
//    }
    
    function closeGame () public onlyOwner{
        require(now>last_participation_date);
        require((now-last_participation_date)>180*DAY_IN_SECONDS);
        
        (bool success, ) = root_node.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
        
        emit GameIsClosed();
    }
    
    event GameIsClosed();

}