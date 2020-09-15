/**
 *Submitted for verification at Etherscan.io on 2020-07-25
*/

// SPDX-License-Identifier: MIT
/*
Buy HTK tokens by sending funds to this address, or visit www.HonestLabs.win
This is a Honest Token Sale Contract.
This contract holds HTK tokens and sell them at a given price (depending on if Pre-ICO, ICO or amount)
This contract holds HTK tokens because the HTK contract has mint them to this address.

 /$$   /$$                                          /$$           /$$                 /$$                
| $$  | $$                                         | $$          | $$                | $$                
| $$  | $$  /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$/$$$$$$        | $$        /$$$$$$ | $$$$$$$   /$$$$$$$
| $$$$$$$$ /$$__  $$| $$__  $$ /$$__  $$ /$$_____/_  $$_/        | $$       |____  $$| $$__  $$ /$$_____/
| $$__  $$| $$  \ $$| $$  \ $$| $$$$$$$$|  $$$$$$  | $$          | $$        /$$$$$$$| $$  \ $$|  $$$$$$ 
| $$  | $$| $$  | $$| $$  | $$| $$_____/ \____  $$ | $$ /$$      | $$       /$$__  $$| $$  | $$ \____  $$
| $$  | $$|  $$$$$$/| $$  | $$|  $$$$$$$ /$$$$$$$/ |  $$$$/      | $$$$$$$$|  $$$$$$$| $$$$$$$/ /$$$$$$$/
|__/  |__/ \______/ |__/  |__/ \_______/|_______/   \___/        |________/ \_______/|_______/ |_______/ 
                                                                                                         
                                                                                                         
                                                                                                       
                                                                                                                                                                              
Visit our website and buy HTK using the ICO user interface at www.HonestLabs.win
Visit our first game in www.HonestTree.win

Contact us in our Telegram Group: https://t.me/HonestLabs





HTK token sale (ICO) contract address: (this)= 0x474d52047c62545d596b22ee953f290d51fa1ac2

HTK token contract address: 0x24619b932ff015852a6f472f949a7c959650f21c


If you hold HTK, you will earn all dividends that will be paid to the token contract Address
The first project to do this is the Honest Tree Game
Visit www.honesttree.win

*/



// File: contracts/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol

// Licence: MIT

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

// Licence: MIT

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

// Licence: MIT

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


// File: contracts/HTK_Sale_Contract.sol
// Licence: MIT
pragma solidity 0.6.10;

// We first set an ERC20 contact interface with the functions that we'll use
interface HTK_Token {
    function balanceOf(address owner) external returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool); //token transfer function
    function decimals() external returns (uint256);
    function withdrawFunds() external;
}




contract HTK_TokenSale is ReentrancyGuard, Ownable {
    
    using SafeMath for uint256;
    
    HTK_Token public HTK_tokenContract;   // The HTK Token
    address payable public HTK_tokenContract_address; // Is the same address, but now as an payable address object 
    
    uint public pre_ICO_deadline;
    uint public ICO_deadline;
    
    
    uint256 public HTK_tokensSold;          // Number of tokens already sold

    event HTK_tokenSold(address buyer, uint256 amount);
    
    constructor(HTK_Token _HTK_tokenContract, address payable _HTK_tokenContract_address) public {
        HTK_tokenContract=_HTK_tokenContract;
        HTK_tokenContract_address=_HTK_tokenContract_address;
        HTK_tokensSold=0;
        
        
        //Epoch timestamp:  1601510399
        // Date and time (GMT): Wednesday, September 30, 2020 23:59:59 
        pre_ICO_deadline=1601510399;
        
        
        //Epoch timestamp: 1609459199
        //Date and time (GMT): Thursday, December 31, 2020 23:59:59 
        ICO_deadline=1609459199;
        
        // 
    }

    fallback() external payable {
        //The same Token Contract Address should not buy tokens itself :D
        if (msg.sender !=HTK_tokenContract_address){
            buyHTK_Tokens();
        }
        
    }
    
    receive() external payable {
        //The same Token Contract Address should not buy tokens itself :D
        if (msg.sender !=HTK_tokenContract_address){
            buyHTK_Tokens();
        }
    }

    
    function buyHTK_Tokens()
        public
        payable
        nonReentrant {
            uint _date = now;
            uint256 _tokensAmount = getTokenAmount(msg.value, _date);
            
            require(HTK_tokenContract.balanceOf(address(this)) >= _tokensAmount,
                'I dont have such amount, please check my balance and try to buy less tokens');
    
            emit HTK_tokenSold(msg.sender, _tokensAmount);
            HTK_tokensSold = HTK_tokensSold.add(_tokensAmount);
    
            require(HTK_tokenContract.transfer(msg.sender, _tokensAmount),'Error while transfering tokens');
    }
    
    
    function getTokenAmount(uint256 _weiAmount, uint _date) public view returns(uint256){
        if (_date<pre_ICO_deadline){
            return _weiAmount.mul(1250); // 1ETH = 1250 HTK    
        }
        
        else{ // During ICO, there are different bonuses:
        
            if (_weiAmount<=100000000000000000){ // from 0 to 0.1 ETH
                return  _weiAmount.mul(1000); 
            }
            else if ((_weiAmount>100000000000000000) && (_weiAmount<=1000000000000000000)){ // from 0.1 to 1 ETH
                return  _weiAmount.mul(1100);  // 10% Bonus
            }
            else if ((_weiAmount>1000000000000000000) && (_weiAmount<=10000000000000000000)){ // from 1 to 10 ETH
                return _weiAmount.mul(1200); // 20% Bonus
            }
            
            else if ((_weiAmount>10000000000000000000)){ // More than 10 ETH
                return _weiAmount.mul(1300); // 20% Bonus
            }
            
        }
        
    }
    
    
    
    function withdrawICOFunds() public onlyOwner nonReentrant {
        // funds will only be withdrawn after pre ICO
        require(now>pre_ICO_deadline, 'Too early my friend');
        (bool success, ) = owner().call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function endSale() public onlyOwner nonReentrant{
        // Only after ICO deadline
        require(now>ICO_deadline, 'Too early my friend');
        require(HTK_tokenContract.transfer(owner(), HTK_tokenContract.balanceOf(address(this))));
        (bool success, ) = owner().call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }
    
    function getDistributedFundsOfNotYesSoldTokens() public onlyOwner nonReentrant {
        HTK_tokenContract.withdrawFunds();
    }
}







// File: contracts/openzeppelin-contracts/contracts/math/SafeMath.sol

// Licence: MIT

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