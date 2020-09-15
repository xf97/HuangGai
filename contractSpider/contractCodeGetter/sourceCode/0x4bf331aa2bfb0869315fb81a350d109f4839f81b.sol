/**
 *Submitted for verification at Etherscan.io on 2020-07-27
*/

// File: node_modules\@openzeppelin\contracts\utils\Address.sol

pragma solidity ^0.5.5;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following 
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol

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

// File: node_modules\@openzeppelin\contracts\GSN\Context.sol

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

// File: node_modules\@openzeppelin\contracts\ownership\Ownable.sol

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

// File: node_modules\@openzeppelin\contracts\utils\ReentrancyGuard.sol

pragma solidity ^0.5.0;

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
 *
 * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
 * metering changes introduced in the Istanbul hardfork.
 */
contract ReentrancyGuard {
    bool private _notEntered;

    constructor () internal {
        // Storing an initial non-zero value makes deployment a bit more
        // expensive, but in exchange the refund on every call to nonReentrant
        // will be lower in amount. Since refunds are capped to a percetange of
        // the total transaction's gas, it is best to keep them low in cases
        // like this one, to increase the likelihood of the full refund coming
        // into effect.
        _notEntered = true;
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
        require(_notEntered, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _notEntered = false;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _notEntered = true;
    }
}

// File: node_modules\@openzeppelin\contracts\math\SafeMath.sol

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

// File: contracts\Curve\Curve_General_Zapout_V1_2.sol

// ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
// ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
// ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
// ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
// ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
// ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
// Copyright (C) 2020 zapper, nodarjanashia, suhailg, apoorvlathey, seb, sumit

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// Visit <https://www.gnu.org/licenses/>for a copy of the GNU Affero General Public License

///@author Zapper
///@notice this contract implements one click ZapOut from Curve Pools

pragma solidity 0.5.12;






/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(
            value
        );
        callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value,
            "SafeERC20: decreased allowance below zero"
        );
        callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

// interface
interface ICurveExchange {
    // function coins() external view returns (address[] memory);
    function coins(int128 arg0) external view returns (address);

    function underlying_coins(int128 arg0) external view returns (address);

    function balances(int128 arg0) external view returns (uint256);

    function remove_liquidity(uint256 _amount, uint256[4] calldata min_amounts)
        external;

    function remove_liquidity_one_coin(
        uint256 _token_amount,
        int128 i,
        uint256 min_amount,
        bool donate_dust
    ) external;

    function exchange(
        int128 from,
        int128 to,
        uint256 _from_amount,
        uint256 _min_to_amount
    ) external;

    function exchange_underlying(
        int128 from,
        int128 to,
        uint256 _from_amount,
        uint256 _min_to_amount
    ) external;

    function calc_withdraw_one_coin(uint256 _token_amount, int128 i)
        external
        returns (uint256);
}

interface ICurveExchangeBTC {
    function remove_liquidity_one_coin(
        uint256 _token_amount,
        int128 i,
        uint256 min_amount
    ) external;
}

interface ICurveExchangeSBTC {
    function remove_liquidity(uint256 _amount, uint256[3] calldata min_amounts)
        external;
}

interface ICurveExchangeRenBTC {
    function remove_liquidity(uint256 _amount, uint256[2] calldata min_amounts)
        external;
}

interface IuniswapFactory {
    function getExchange(address token)
        external
        view
        returns (address exchange);
}

interface IuniswapExchange {
    // converting ERC20 to ERC20 and transfer
    function tokenToTokenTransferInput(
        uint256 tokens_sold,
        uint256 min_tokens_bought,
        uint256 min_eth_bought,
        uint256 deadline,
        address recipient,
        address token_addr
    ) external returns (uint256 tokens_bought);

    function getEthToTokenInputPrice(uint256 eth_sold)
        external
        view
        returns (uint256 tokens_bought);

    function getEthToTokenOutputPrice(uint256 tokens_bought)
        external
        view
        returns (uint256 eth_sold);

    function getTokenToEthInputPrice(uint256 tokens_sold)
        external
        view
        returns (uint256 eth_bought);

    function getTokenToEthOutputPrice(uint256 eth_bought)
        external
        view
        returns (uint256 tokens_sold);

    function tokenToEthTransferInput(
        uint256 tokens_sold,
        uint256 min_eth,
        uint256 deadline,
        address recipient
    ) external returns (uint256 eth_bought);

    function balanceOf(address _owner) external view returns (uint256);

    function transfer(address _to, uint256 _value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 tokens
    ) external returns (bool success);
}

interface IWETH {
    function deposit() external payable;

    function withdraw(uint256) external;
}

interface cERC20 {
    function redeem(uint256) external returns (uint256);
}

interface yERC20 {
    function withdraw(uint256 _amount) external;
}

interface IUniswapRouter02 {
    //get estimated amountOut
    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    //token 2 token
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    //eth 2 token
    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    //token 2 eth
    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}

interface IBalancer {
    function swapExactAmountIn(
        address tokenIn,
        uint tokenAmountIn,
        address tokenOut,
        uint minAmountOut,
        uint maxPrice
    ) external returns (uint tokenAmountOut, uint spotPriceAfter);
}

contract Curve_General_ZapOut_V2 is ReentrancyGuard, Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using Address for address;
    bool private stopped = false;
    uint16 public goodwill;
    address public dzgoodwillAddress;
    
    IBalancer private constant BalWBTCPool = IBalancer(0x294de1cdE8b04bf6d25F98f1d547052F8080A177);

    IuniswapFactory private constant UniSwapFactoryAddress = IuniswapFactory(
        0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95
    );
    IUniswapRouter02 private constant uniswapRouter = IUniswapRouter02(
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
    );

    address private constant wethTokenAddress = address(
        0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
    );
    address private constant WBTCTokenAddress = address(
        0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599
    );
    address private constant DaiTokenAddress = address(
        0x6B175474E89094C44Da98b954EedeAC495271d0F
    );
    address private constant UsdcTokenAddress = address(
        0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
    );
    address private constant UsdtTokenAddress = address(
        0xdAC17F958D2ee523a2206206994597C13D831ec7
    );
    address public sUsdTokenAddress = address(
        0x57Ab1ec28D129707052df4dF418D58a2D46d5f51
    );

    address private constant bUsdTokenAddress = address(
        0x4Fabb145d64652a948d72533023f6E7A623C7C53
    );

    address private constant sUSDCurveExchangeAddress = address(
        0xFCBa3E75865d2d561BE8D220616520c171F12851
    );
    address private constant sUSDCurvePoolTokenAddress = address(
        0xC25a3A3b969415c80451098fa907EC722572917F
    );
    address private constant yCurveExchangeAddress = address(
        0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3
    );
    address private constant yCurvePoolTokenAddress = address(
        0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8
    );
    address private constant bUSDCurveExchangeAddress = address(
        0xb6c057591E073249F2D9D88Ba59a46CFC9B59EdB
    );
    address private constant bUSDCurvePoolTokenAddress = address(
        0x3B3Ac5386837Dc563660FB6a0937DFAa5924333B
    );
    address private constant paxCurveExchangeAddress = address(
        0xA50cCc70b6a011CffDdf45057E39679379187287
    );
    address private constant paxCurvePoolTokenAddress = address(
        0xD905e2eaeBe188fc92179b6350807D8bd91Db0D8
    );
    address private constant renCurvePoolTokenAddress = address(
        0x49849C98ae39Fff122806C06791Fa73784FB3675
    );
    address private constant sbtcCurvePoolTokenAddress = address(
        0x075b1bb99792c9E1041bA13afEf80C91a1e70fB3
    );

    address private constant renCurveExchangeAddress = address(
        0x93054188d876f558f4a66B2EF1d97d16eDf0895B
    );

    address private constant sbtcCurveExchangeAddress = address(
        0x7fC77b5c7614E1533320Ea6DDc2Eb61fa00A9714
    );

    address private constant yDAI = address(0xC2cB1040220768554cf699b0d863A3cd4324ce32);
    address private constant yUSDC = address(0xd6aD7a6750A7593E092a9B218d66C0A814a3436e);
    address private constant yUSDT = address(0x83f798e925BcD4017Eb265844FDDAbb448f1707D);
    address private constant yBUSD = address(0x04bC0Ab673d88aE9dbC9DA2380cB6B79C4BCa9aE);
    address private constant yTUSD = address(0x73a052500105205d34Daf004eAb301916DA8190f);

    address private constant ycDAI = address(0x99d1Fa417f94dcD62BfE781a1213c092a47041Bc);
    address private constant ycUSDC = address(0x9777d7E2b60bB01759D0E2f8be2095df444cb07E);
    address private constant ycUSDT = address(0x1bE5d71F2dA660BFdee8012dDc58D024448A0A59);

    mapping(address => address) public exchange2Token;
    mapping(address => address) public cToken;
    mapping(address => address) public yToken;

    constructor(
        uint16 _goodwill,
        address _dzgoodwillAddress
    ) public {
        goodwill = _goodwill;
        dzgoodwillAddress = _dzgoodwillAddress;
        approveToken();
        setCRVTokenAddresses();
        setcTokens();
        setyTokens();
    }

    function approveToken() public {
        IERC20(sUSDCurvePoolTokenAddress).approve(
            sUSDCurveExchangeAddress,
            uint256(-1)
        );
        IERC20(yCurvePoolTokenAddress).approve(
            yCurveExchangeAddress,
            uint256(-1)
        );
        IERC20(bUSDCurvePoolTokenAddress).approve(
            bUSDCurveExchangeAddress,
            uint256(-1)
        );
        IERC20(paxCurvePoolTokenAddress).approve(
            paxCurveExchangeAddress,
            uint256(-1)
        );
        IERC20(renCurvePoolTokenAddress).approve(
            renCurveExchangeAddress,
            uint256(-1)
        );
        IERC20(sbtcCurvePoolTokenAddress).approve(
            sbtcCurveExchangeAddress,
            uint256(-1)
        );
    }

    function setcTokens() public onlyOwner {
        cToken[address(
            0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643
        )] = DaiTokenAddress;
        cToken[address(
            0x39AA39c021dfbaE8faC545936693aC917d5E7563
        )] = UsdcTokenAddress;
        cToken[address(
            0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9
        )] = UsdtTokenAddress;
        cToken[address(
            0xC11b1268C1A384e55C48c2391d8d480264A3A7F4
        )] = WBTCTokenAddress;
    }

    function setyTokens() public onlyOwner {
        //y tokens
        yToken[yDAI] = DaiTokenAddress;
        yToken[yUSDC] = UsdcTokenAddress;
        yToken[yUSDT] = UsdtTokenAddress;
        yToken[yBUSD] = bUsdTokenAddress;

        //yc tokens
        yToken[ycDAI] = DaiTokenAddress;
        yToken[ycUSDC] = UsdcTokenAddress;
        yToken[ycUSDT] = UsdtTokenAddress;
    }

    function setCRVTokenAddresses() public onlyOwner {
        exchange2Token[sUSDCurveExchangeAddress] = sUSDCurvePoolTokenAddress;
        exchange2Token[yCurveExchangeAddress] = yCurvePoolTokenAddress;
        exchange2Token[bUSDCurveExchangeAddress] = bUSDCurvePoolTokenAddress;
        exchange2Token[paxCurveExchangeAddress] = paxCurvePoolTokenAddress;
        exchange2Token[renCurveExchangeAddress] = renCurvePoolTokenAddress;
        exchange2Token[sbtcCurveExchangeAddress] = sbtcCurvePoolTokenAddress;
    }

    function addCRVToken(address _exchangeAddress, address _crvTokenAddress)
        public
        onlyOwner
    {
        exchange2Token[_exchangeAddress] = _crvTokenAddress;
    }

    function addCToken(address _cToken, address _underlyingToken)
        public
        onlyOwner
    {
        cToken[_cToken] = _underlyingToken;
    }

    function addYToken(address _yToken, address _underlyingToken)
        public
        onlyOwner
    {
        yToken[_yToken] = _underlyingToken;
    }

    function set_new_sUSDTokenAddress(address _new_sUSDTokenAddress)
        public
        onlyOwner
    {
        sUsdTokenAddress = _new_sUSDTokenAddress;
    }

    // circuit breaker modifiers
    modifier stopInEmergency {
        if (stopped) {
            revert("Temporarily Paused");
        } else {
            _;
        }
    }

    function ZapoutToUnderlying(
        address _toWhomToIssue,
        address _curveExchangeAddress,
        uint256 _IncomingCRV,
        uint256 _tokenCount
    ) public stopInEmergency {
        require(
            _curveExchangeAddress == sUSDCurveExchangeAddress ||
                _curveExchangeAddress == yCurveExchangeAddress ||
                _curveExchangeAddress == bUSDCurveExchangeAddress ||
                _curveExchangeAddress == paxCurveExchangeAddress ||
                _curveExchangeAddress == renCurveExchangeAddress ||
                _curveExchangeAddress == sbtcCurveExchangeAddress,
            "Invalid Curve Pool Address"
        );

        uint256 goodwillPortion = SafeMath.div(
            SafeMath.mul(_IncomingCRV, goodwill),
            10000
        );

        require(
            IERC20(exchange2Token[_curveExchangeAddress]).transferFrom(
                msg.sender,
                dzgoodwillAddress,
                goodwillPortion
            ),
            "Error transferring goodwill"
        );

        require(
            IERC20(exchange2Token[_curveExchangeAddress]).transferFrom(
                msg.sender,
                address(this),
                SafeMath.sub(_IncomingCRV, goodwillPortion)
            ),
            "Error transferring CRV"
        );
        require(SafeMath.sub(_IncomingCRV, goodwillPortion) > 0, "Here");
        address[] memory coins;
        if (
            (_curveExchangeAddress == renCurveExchangeAddress ||
                _curveExchangeAddress == sbtcCurveExchangeAddress)
        ) {
            coins = getCoins(_curveExchangeAddress, _tokenCount);
        } else {
            coins = getUnderlyingCoins(_curveExchangeAddress, _tokenCount);
        }

        if (_tokenCount == 4) {
            ICurveExchange(_curveExchangeAddress).remove_liquidity(
                SafeMath.sub(_IncomingCRV, goodwillPortion),
                [uint256(0), 0, 0, 0]
            );
        } else if (_tokenCount == 3) {
            ICurveExchangeSBTC(_curveExchangeAddress).remove_liquidity(
                SafeMath.sub(_IncomingCRV, goodwillPortion),
                [uint256(0), 0, 0]
            );
        } else if (_tokenCount == 2) {
            ICurveExchangeRenBTC(_curveExchangeAddress).remove_liquidity(
                SafeMath.sub(_IncomingCRV, goodwillPortion),
                [uint256(0), 0]
            );
        }

        for (uint256 index = 0; index < _tokenCount; index++) {
            uint256 tokenReceived = IERC20(coins[index]).balanceOf(
                address(this)
            );
            if (tokenReceived > 0)
                SafeERC20.safeTransfer(
                    IERC20(coins[index]),
                    _toWhomToIssue,
                    tokenReceived
                );
        }
    }

    function ZapOut(
        address payable _toWhomToIssue,
        address _curveExchangeAddress,
        uint256 _tokenCount,
        uint256 _IncomingCRV,
        address _ToTokenAddress,
        uint256 _minToTokens
    ) public stopInEmergency returns (uint256 ToTokensBought) {
        require(
            _curveExchangeAddress == sUSDCurveExchangeAddress ||
                _curveExchangeAddress == yCurveExchangeAddress ||
                _curveExchangeAddress == bUSDCurveExchangeAddress ||
                _curveExchangeAddress == paxCurveExchangeAddress ||
                _curveExchangeAddress == renCurveExchangeAddress ||
                _curveExchangeAddress == sbtcCurveExchangeAddress,
            "Invalid Curve Pool Address"
        );

        uint256 goodwillPortion = SafeMath.div(
            SafeMath.mul(_IncomingCRV, goodwill),
            10000
        );

        require(
            IERC20(exchange2Token[_curveExchangeAddress]).transferFrom(
                msg.sender,
                dzgoodwillAddress,
                goodwillPortion
            ),
            "Error transferring goodwill"
        );

        require(
            IERC20(exchange2Token[_curveExchangeAddress]).transferFrom(
                msg.sender,
                address(this),
                SafeMath.sub(_IncomingCRV, goodwillPortion)
            ),
            "Error transferring CRV"
        );

        (bool flag, uint256 i) = _getIntermediateToken(
            _ToTokenAddress,
            _curveExchangeAddress,
            _tokenCount
        );

        if (
            flag &&
            (_curveExchangeAddress == renCurveExchangeAddress ||
                _curveExchangeAddress == sbtcCurveExchangeAddress)
        ) {
            uint256 tokenBought = _exitCurve(
                _curveExchangeAddress,
                i,
                SafeMath.sub(_IncomingCRV, goodwillPortion)
            );
            require(tokenBought > 0, "No liquidity removed");
            ToTokensBought = _swap(
                _ToTokenAddress,
                WBTCTokenAddress,
                _toWhomToIssue,
                tokenBought
            );
        } else if (flag) {
            uint256 tokenBought = _exitCurve(
                _curveExchangeAddress,
                i,
                SafeMath.sub(_IncomingCRV, goodwillPortion)
            );
            require(tokenBought > 0, "No liquidity removed");
            // if wbtc, coin else underlying coin
            ToTokensBought = _swap(
                _ToTokenAddress,
                ICurveExchange(_curveExchangeAddress).underlying_coins(
                    int128(i)
                ),
                _toWhomToIssue,
                tokenBought
            );
        } else {
            //split CRV tokens received
            uint256 _crv = (_IncomingCRV.sub(goodwillPortion)).div(2);
            uint256 tokenBought = _exitCurve(
                _curveExchangeAddress,
                0,
                _crv
            );
            require(tokenBought > 0, "No liquidity removed");
            //swap dai
            ToTokensBought = _swap(
                _ToTokenAddress,
                ICurveExchange(_curveExchangeAddress).underlying_coins(
                    int128(0)
                ),
                _toWhomToIssue,
                tokenBought
            );
            tokenBought = _exitCurve(
                _curveExchangeAddress,
                1,
                (_IncomingCRV.sub(goodwillPortion)).sub(_crv)
            );
            require(tokenBought > 0, "No liquidity removed");
            //swap usdc
            ToTokensBought += _swap(
                _ToTokenAddress,
                ICurveExchange(_curveExchangeAddress).underlying_coins(
                    int128(1)
                ),
                _toWhomToIssue,
                tokenBought
            );
        }

        require(ToTokensBought >= _minToTokens, "ERR: High Slippage");
    }

    function _exitCurve(
        address _curveExchangeAddress,
        uint256 i,
        uint256 _IncomingCRV
    ) internal returns (uint256 tokenReceived) {
        // Withdraw to intermediate token from Curve
        if (
            _curveExchangeAddress == renCurveExchangeAddress ||
            _curveExchangeAddress == sbtcCurveExchangeAddress
        ) {
            ICurveExchangeBTC(_curveExchangeAddress).remove_liquidity_one_coin(
                _IncomingCRV,
                int128(i),
                0
            );
            tokenReceived = IERC20(
                ICurveExchange(_curveExchangeAddress).coins(int128(i))
            )
                .balanceOf(address(this));
        } else {
            ICurveExchange(_curveExchangeAddress).remove_liquidity_one_coin(
                _IncomingCRV,
                int128(i),
                0,
                false
            );
            tokenReceived = IERC20(
                ICurveExchange(_curveExchangeAddress).underlying_coins(
                    int128(i)
                )
            )
                .balanceOf(address(this));
        }
        require(tokenReceived > 0, "No token received");
    }

    function _swap(
        address _toToken,
        address _fromToken,
        address payable _toWhomToIssue,
        uint256 _amount
    ) internal returns (uint256) {
        if (_toToken == _fromToken) {
            SafeERC20.safeTransfer(IERC20(_fromToken), _toWhomToIssue, _amount);
            return _amount;
        } else if (_toToken == address(0)) {
            return
                _token2Eth(_fromToken, _amount, _toWhomToIssue);
        } else {
            return
                _token2Token(
                    _fromToken,
                    _toWhomToIssue,
                    _toToken,
                    _amount
                );
        }
    }

    function _getIntermediateToken(
        address _ToTokenAddress,
        address _curveExchangeAddress,
        uint256 _tokenCount
    ) public view returns (bool, uint256) {
        address[] memory coins = getCoins(_curveExchangeAddress, _tokenCount);
        address[] memory underlyingCoins = getUnderlyingCoins(
            _curveExchangeAddress,
            _tokenCount
        );

        //check if toToken is coin
        (bool isCurveToken, uint256 index) = isBound(_ToTokenAddress, coins);
        if (isCurveToken) return (true, index);

        ////check if toToken is underlying coin
        (isCurveToken, index) = isBound(_ToTokenAddress, underlyingCoins);
        if (isCurveToken) return (true, index);

        if (
            _curveExchangeAddress == renCurveExchangeAddress ||
            _curveExchangeAddress == sbtcCurveExchangeAddress
        ) {
            //return wbtc for renBTC & sBTC pools
            return (true, 1);
        } else return (false, 0);
    }

    function isBound(address _token, address[] memory coins)
        internal
        pure
        returns (bool, uint256)
    {
        if (_token == address(0)) return (false, 0);
        for (uint256 i = 0; i < coins.length; i++) {
            if (_token == coins[i]) {
                return (true, i);
            }
        }
        return (false, 0);
    }

    function getUnderlyingCoins(
        address _curveExchangeAddress,
        uint256 _tokenCount
    ) public view returns (address[] memory) {
        if (
            _curveExchangeAddress == renCurveExchangeAddress ||
            _curveExchangeAddress == sbtcCurveExchangeAddress
        ) {
            return new address[](_tokenCount);
        }
        address[] memory coins = new address[](_tokenCount);
        for (uint256 i = 0; i < _tokenCount; i++) {
            address coin = ICurveExchange(_curveExchangeAddress)
                .underlying_coins(int128(i));
            coins[i] = coin;
        }
        return coins;
    }

    function getCoins(address _curveExchangeAddress, uint256 _tokenCount)
        public
        view
        returns (address[] memory)
    {
        address[] memory coins = new address[](_tokenCount);
        for (uint256 i = 0; i < _tokenCount; i++) {
            address coin = ICurveExchange(_curveExchangeAddress).coins(
                int128(i)
            );
            coins[i] = coin;
        }
        return coins;
    }

    function _token2Eth(
        address _FromTokenContractAddress,
        uint256 tokens2Trade,
        address payable _toWhomToIssue
    ) public returns (uint256) {
        if (_FromTokenContractAddress == wethTokenAddress) {
            IWETH(wethTokenAddress).withdraw(tokens2Trade);
            _toWhomToIssue.transfer(tokens2Trade);
            return tokens2Trade;
        }
        if(_FromTokenContractAddress == WBTCTokenAddress) {
            IERC20(WBTCTokenAddress).approve(
                address(BalWBTCPool),
                tokens2Trade
            );
            (uint256 wethBought, ) = BalWBTCPool.swapExactAmountIn(
                                        WBTCTokenAddress,
                                        tokens2Trade,
                                        wethTokenAddress,
                                        0,
                                        uint(-1)
                                    );
            IWETH(wethTokenAddress).withdraw(wethBought);
            (bool success, ) = _toWhomToIssue.call.value(wethBought)("");
            require(success, "ETH Transfer failed.");
            
            return wethBought;
        }

        //unwrap
        (uint256 tokensUnwrapped, address fromToken) = _unwrap(
            _FromTokenContractAddress,
            tokens2Trade
        );

        IERC20(fromToken).approve(
            address(uniswapRouter),
            tokensUnwrapped
        );

        address[] memory path = new address[](2);
        path[0] = _FromTokenContractAddress;
        path[1] = wethTokenAddress;
        uint256 ethBought = uniswapRouter.swapExactTokensForETH(
                            tokensUnwrapped,
                            1,
                            path,
                            _toWhomToIssue,
                            now + 60
                        )[path.length - 1];
        
        require(ethBought > 0, "Error in swapping Eth: 1");
        return ethBought;
    }

    /**
    @notice This function is used to swap tokens
    @param _FromTokenContractAddress The token address to swap from
    @param _ToWhomToIssue The address to transfer after swap
    @param _ToTokenContractAddress The token address to swap to
    @param tokens2Trade The quantity of tokens to swap
    @return The amount of tokens returned after swap
     */
    function _token2Token(
        address _FromTokenContractAddress,
        address _ToWhomToIssue,
        address _ToTokenContractAddress,
        uint256 tokens2Trade
    ) public returns (uint256 tokenBought) {
        //unwrap
        (uint256 tokensUnwrapped, address fromToken) = _unwrap(
            _FromTokenContractAddress,
            tokens2Trade
        );

        IERC20(fromToken).approve(
            address(uniswapRouter),
            tokensUnwrapped
        );

        address[] memory path = new address[](3);
        path[0] = _FromTokenContractAddress;
        path[1] = wethTokenAddress;
        path[2] = _ToTokenContractAddress;
        tokenBought = uniswapRouter.swapExactTokensForTokens(
                            tokensUnwrapped,
                            1,
                            path,
                            _ToWhomToIssue,
                            now + 60
                        )[path.length - 1];
        
        require(tokenBought > 0, "Error in swapping ERC: 1");
    }

    function _unwrap(address _FromTokenContractAddress, uint256 tokens2Trade)
        internal
        returns (uint256 tokensUnwrapped, address toToken)
    {
        if (cToken[_FromTokenContractAddress] != address(0)) {
            require(
                cERC20(_FromTokenContractAddress).redeem(tokens2Trade) == 0,
                "Error in unwrapping"
            );
            toToken = cToken[_FromTokenContractAddress];
        } else if (yToken[_FromTokenContractAddress] != address(0)) {
            yERC20(_FromTokenContractAddress).withdraw(tokens2Trade);
            toToken = yToken[_FromTokenContractAddress];
        } else {
            toToken = _FromTokenContractAddress;
        }
        tokensUnwrapped = IERC20(toToken).balanceOf(address(this));
    }

    function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
        require(
            _new_goodwill >= 0 && _new_goodwill < 10000,
            "GoodWill Value not allowed"
        );
        goodwill = _new_goodwill;
    }

    function set_new_dzgoodwillAddress(address _new_dzgoodwillAddress)
        public
        onlyOwner
    {
        dzgoodwillAddress = _new_dzgoodwillAddress;
    }

    function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
        uint256 qty = _TokenAddress.balanceOf(address(this));
        _TokenAddress.transfer(owner(), qty);
    }

    // - to Pause the contract
    function toggleContractActive() public onlyOwner {
        stopped = !stopped;
    }

    // - to withdraw any ETH balance sitting in the contract
    function withdraw() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        address payable _to = owner().toPayable();
        _to.transfer(contractBalance);
    }

    function() external payable {}
}