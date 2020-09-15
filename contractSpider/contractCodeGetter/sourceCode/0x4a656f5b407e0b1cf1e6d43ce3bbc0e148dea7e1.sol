/**
 *Submitted for verification at Etherscan.io on 2020-04-28
*/

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

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

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

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

// File: contracts/interfaces/IUniswapSwapper.sol

pragma solidity 0.5.12;


interface IUniswapSwapper {
    event Swap(
        address caller,
        address guy,
        address inputToken,
        address outputToken,
        uint256 inputTokenAmount,
        uint256 outputTokenAmount,
        uint256 inputTokenSpent
    );

    function init(address _factoryAddress) external returns (bool);

    function isDestroyed() external view returns (bool);

    function swap(
        address payable guy,
        address inputTokenAddress,
        address outputTokenAddress,
        uint256 inputTokenAmount,
        uint256 outputTokenAmount
    ) external;

    function swapEth(address payable guy, address outputTokenAddress, uint256 outputTokenAmount)
        external
        payable;
}

// File: contracts/interfaces/IUniswapFactory.sol

pragma solidity 0.5.12;

interface IUniswapFactory {
    // Create Exchange
    function createExchange(address token) external returns (address exchange);
    // Get Exchange and Token Info
    function getExchange(address token) external view returns (address exchange);
    function getToken(address exchange) external view returns (address token);
    function getTokenWithId(uint256 tokenId) external view returns (address token);
    // Init factory
    function initializeFactory(address template) external;
}

// File: contracts/interfaces/IUniswapExchange.sol

pragma solidity 0.5.12;

interface IUniswapExchange {
    // Address of ERC20 token sold on this exchange
    function tokenAddress() external view returns (address token);
    // Address of Uniswap Factory
    function factoryAddress() external view returns (address factory);
    // Provide Liquidity
    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline)
        external
        payable
        returns (uint256);
    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline)
        external
        returns (uint256, uint256);
    // Get Prices
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
    // Trade ETH to ERC20
    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline)
        external
        payable
        returns (uint256 tokens_bought);
    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient)
        external
        payable
        returns (uint256 tokens_bought);
    function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline)
        external
        payable
        returns (uint256 eth_sold);
    function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient)
        external
        payable
        returns (uint256 eth_sold);
    // Trade ERC20 to ETH
    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline)
        external
        returns (uint256 eth_bought);
    function tokenToEthTransferInput(
        uint256 tokens_sold,
        uint256 min_eth,
        uint256 deadline,
        address recipient
    ) external returns (uint256 eth_bought);
    function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline)
        external
        returns (uint256 tokens_sold);
    function tokenToEthTransferOutput(
        uint256 eth_bought,
        uint256 max_tokens,
        uint256 deadline,
        address recipient
    ) external returns (uint256 tokens_sold);
    // Trade ERC20 to ERC20
    function tokenToTokenSwapInput(
        uint256 tokens_sold,
        uint256 min_tokens_bought,
        uint256 min_eth_bought,
        uint256 deadline,
        address token_addr
    ) external returns (uint256 tokens_bought);
    function tokenToTokenTransferInput(
        uint256 tokens_sold,
        uint256 min_tokens_bought,
        uint256 min_eth_bought,
        uint256 deadline,
        address recipient,
        address token_addr
    ) external returns (uint256 tokens_bought);
    function tokenToTokenSwapOutput(
        uint256 tokens_bought,
        uint256 max_tokens_sold,
        uint256 max_eth_sold,
        uint256 deadline,
        address token_addr
    ) external returns (uint256 tokens_sold);
    function tokenToTokenTransferOutput(
        uint256 tokens_bought,
        uint256 max_tokens_sold,
        uint256 max_eth_sold,
        uint256 deadline,
        address recipient,
        address token_addr
    ) external returns (uint256 tokens_sold);
    // Trade ERC20 to Custom Pool
    function tokenToExchangeSwapInput(
        uint256 tokens_sold,
        uint256 min_tokens_bought,
        uint256 min_eth_bought,
        uint256 deadline,
        address exchange_addr
    ) external returns (uint256 tokens_bought);
    function tokenToExchangeTransferInput(
        uint256 tokens_sold,
        uint256 min_tokens_bought,
        uint256 min_eth_bought,
        uint256 deadline,
        address recipient,
        address exchange_addr
    ) external returns (uint256 tokens_bought);
    function tokenToExchangeSwapOutput(
        uint256 tokens_bought,
        uint256 max_tokens_sold,
        uint256 max_eth_sold,
        uint256 deadline,
        address exchange_addr
    ) external returns (uint256 tokens_sold);
    function tokenToExchangeTransferOutput(
        uint256 tokens_bought,
        uint256 max_tokens_sold,
        uint256 max_eth_sold,
        uint256 deadline,
        address recipient,
        address exchange_addr
    ) external returns (uint256 tokens_sold);
}

// File: contracts/UniswapSwapper.sol

pragma solidity 0.5.12;







contract UniswapSwapper is IUniswapSwapper {
    using SafeMath for uint256;

    bool internal destroyed;
    bool isTemplate;

    address internal factoryAddress;

    uint16 constant DEADLINE_TIME_LENGTH = 300;

    event Swap(
        address caller,
        address guy,
        address inputToken,
        address outputToken,
        uint256 inputTokenAmount,
        uint256 outputTokenAmount,
        uint256 inputTokenSpent,
        address factoryAddress
    );

    constructor() public {
        isTemplate = true;
    }

    function init(address _factoryAddress) external notTemplate returns (bool) {
        require(factoryAddress == address(0), "factory already init");
        factoryAddress = _factoryAddress;
        return true;
    }

    modifier notTemplate() {
        require(isTemplate == false, "is template contract");
        require(destroyed == false, "this contract will selfdestruct");
        _;
    }

    function swapTokenToTokenOutput(
        address caller,
        address guy,
        address inputTokenAddress,
        address outputTokenAddress,
        uint256 inputTokenAmount,
        uint256 outputTokenAmount
    ) internal returns (uint256) {
        // Prevent DDOS erc20 attack by calculating balance offset, so if one maliciuous user sends 1 WEI
        // of ERC20 to a precomputed address, it still works.
        uint256 inputBalancePriorOps = IERC20(inputTokenAddress).balanceOf(address(this));
        uint256 outputBalancePriorOps = IERC20(outputTokenAddress).balanceOf(address(this));
        require(
            IERC20(inputTokenAddress).transferFrom(msg.sender, address(this), inputTokenAmount),
            "error transfer input token to swap"
        );
        IUniswapExchange exchange = IUniswapExchange(
            IUniswapFactory(factoryAddress).getExchange(inputTokenAddress)
        );
        require(address(exchange) != address(0), "exchange can not be 0 address");
        IERC20(inputTokenAddress).approve(address(exchange), inputTokenAmount);
        uint256 inputTokenSpent = exchange.tokenToTokenSwapOutput(
            outputTokenAmount,
            inputTokenAmount, // at least prevent to consume more input tokens than the transfer
            uint256(-1), // do not check how much eth is sold prior the swap: input token --> eth --> output token
            block.timestamp.add(DEADLINE_TIME_LENGTH), // prevent swap to go throught if is not mined after deadline
            outputTokenAddress
        );
        require(inputTokenSpent > 0, "Swap not spent input token");
        require(
            IERC20(inputTokenAddress).transfer(guy, inputTokenAmount.sub(inputTokenSpent)),
            "error transfer remaining input"
        );
        require(
            IERC20(outputTokenAddress).transfer(caller, outputTokenAmount),
            "error transfer remaining output"
        );
        require(
            IERC20(inputTokenAddress).balanceOf(address(this)) == inputBalancePriorOps,
            "input token still here"
        );
        require(
            IERC20(outputTokenAddress).balanceOf(address(this)) == outputBalancePriorOps,
            "output token still here"
        );
        return inputTokenSpent;
    }

    function isDestroyed() external view returns (bool) {
        return destroyed;
    }

    function swapEth(address payable guy, address outputTokenAddress, uint256 outputTokenAmount)
        external
        payable
        notTemplate
    {
        require(factoryAddress != address(0), "factory address not init");
        require(guy != address(0), "guy address can not be 0");
        require(outputTokenAddress != address(0), "output token can not be 0");
        require(msg.value > 0, "ETH value amount can not be 0");
        require(outputTokenAmount > 0, "output token amount can not be 0");

        // Prevent DDOS erc20 attack by calculating balance offset, so if one maliciuous user sends 1 WEI
        // of ERC20 to a precomputed address, it still works.
        uint256 outputBalancePriorOps = IERC20(outputTokenAddress).balanceOf(address(this));
        IUniswapExchange exchange = IUniswapExchange(
            IUniswapFactory(factoryAddress).getExchange(outputTokenAddress)
        );
        require(address(exchange) != address(0), "exchange can not be 0 address");
        uint256 ethCost = exchange.getEthToTokenOutputPrice(outputTokenAmount);
        require(ethCost <= msg.value, "Eth costs greater than input");
        uint256 ethSpent = exchange.ethToTokenSwapOutput.value(ethCost)(
            outputTokenAmount,
            block.timestamp.add(DEADLINE_TIME_LENGTH) // prevent swap to go throught if is not mined after deadline
        );
        require(ethSpent > 0, "ETH not spent");
        require(
            IERC20(outputTokenAddress).balanceOf(address(this)) ==
                outputBalancePriorOps.add(outputTokenAmount),
            "no output token from uniswap"
        );
        require(
            IERC20(outputTokenAddress).transfer(msg.sender, outputTokenAmount),
            "error transfer remaining output"
        );
        require(
            IERC20(outputTokenAddress).balanceOf(address(this)) == outputBalancePriorOps,
            "output token still here"
        );
        emit Swap(
            msg.sender,
            guy,
            address(0),
            outputTokenAddress,
            msg.value,
            outputTokenAmount,
            ethSpent,
            factoryAddress
        );
        // mark this contract as destroyed, so external contract can know this contract is being selfdestruct
        // during this tx, also prevents to call this function again during the transaction
        destroyed = true;
        // Self destruct this contract and send the remaining eth to the user
        selfdestruct(guy);
    }

    function swap(
        address payable guy,
        address inputTokenAddress,
        address outputTokenAddress,
        uint256 inputTokenAmount,
        uint256 outputTokenAmount
    ) external notTemplate {
        require(factoryAddress != address(0), "factory address not init");
        require(guy != address(0), "depositor address can not be 0");
        require(inputTokenAddress != address(0), "input address can not be 0");
        require(outputTokenAddress != address(0), "output token can not be 0");
        require(inputTokenAmount > 0, "input token amount can not be 0");
        require(outputTokenAmount > 0, "output token amount can not be 0");
        uint256 inputTokenSpent = swapTokenToTokenOutput(
            msg.sender,
            guy,
            inputTokenAddress,
            outputTokenAddress,
            inputTokenAmount,
            outputTokenAmount
        );
        emit Swap(
            msg.sender,
            guy,
            inputTokenAddress,
            outputTokenAddress,
            inputTokenAmount,
            outputTokenAmount,
            inputTokenSpent,
            factoryAddress
        );
        // mark this contract as destroyed, so external contract can know this contract is being selfdestruct
        // during this tx, also prevents to call this function again during the transaction
        destroyed = true;
        // Self destruct this contract
        selfdestruct(guy);
    }
}