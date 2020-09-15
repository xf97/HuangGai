/**
 *Submitted for verification at Etherscan.io on 2020-08-10
*/

// File: contracts/lib/Ownable.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

/**
 * @title Ownable
 * @author DODO Breeder
 *
 * @notice Ownership related functions
 */
contract Ownable {
    address public _OWNER_;
    address public _NEW_OWNER_;

    // ============ Events ============

    event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // ============ Modifiers ============

    modifier onlyOwner() {
        require(msg.sender == _OWNER_, "NOT_OWNER");
        _;
    }

    // ============ Functions ============

    constructor() internal {
        _OWNER_ = msg.sender;
        emit OwnershipTransferred(address(0), _OWNER_);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "INVALID_OWNER");
        emit OwnershipTransferPrepared(_OWNER_, newOwner);
        _NEW_OWNER_ = newOwner;
    }

    function claimOwnership() external {
        require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
        emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
        _OWNER_ = _NEW_OWNER_;
        _NEW_OWNER_ = address(0);
    }
}

// File: contracts/intf/IDODO.sol

/*

    Copyright 2020 DODO ZOO.

*/

interface IDODO {
    function init(
        address owner,
        address supervisor,
        address maintainer,
        address baseToken,
        address quoteToken,
        address oracle,
        uint256 lpFeeRate,
        uint256 mtFeeRate,
        uint256 k,
        uint256 gasPriceLimit
    ) external;

    function transferOwnership(address newOwner) external;

    function claimOwnership() external;

    function sellBaseToken(
        uint256 amount,
        uint256 minReceiveQuote,
        bytes calldata data
    ) external returns (uint256);

    function buyBaseToken(
        uint256 amount,
        uint256 maxPayQuote,
        bytes calldata data
    ) external returns (uint256);

    function querySellBaseToken(uint256 amount) external view returns (uint256 receiveQuote);

    function queryBuyBaseToken(uint256 amount) external view returns (uint256 payQuote);

    function depositBaseTo(address to, uint256 amount) external returns (uint256);

    function withdrawBase(uint256 amount) external returns (uint256);

    function withdrawAllBase() external returns (uint256);

    function depositQuoteTo(address to, uint256 amount) external returns (uint256);

    function withdrawQuote(uint256 amount) external returns (uint256);

    function withdrawAllQuote() external returns (uint256);

    function _BASE_CAPITAL_TOKEN_() external returns (address);

    function _QUOTE_CAPITAL_TOKEN_() external returns (address);

    function _BASE_TOKEN_() external returns (address);

    function _QUOTE_TOKEN_() external returns (address);
}

// File: contracts/intf/IERC20.sol

// This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function name() external view returns (string memory);

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
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

// File: contracts/lib/SafeMath.sol

/*

    Copyright 2020 DODO ZOO.

*/

/**
 * @title SafeMath
 * @author DODO Breeder
 *
 * @notice Math operations with safety checks that revert on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "MUL_ERROR");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "DIVIDING_ERROR");
        return a / b;
    }

    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 quotient = div(a, b);
        uint256 remainder = a - quotient * b;
        if (remainder > 0) {
            return quotient + 1;
        } else {
            return quotient;
        }
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SUB_ERROR");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "ADD_ERROR");
        return c;
    }

    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z = x / 2 + 1;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}

// File: contracts/lib/SafeERC20.sol

/*

    Copyright 2020 DODO ZOO.
    This is a simplified version of OpenZepplin's SafeERC20 library

*/

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

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: contracts/helper/UniswapArbitrageur.sol

/*

    Copyright 2020 DODO ZOO.

*/

interface IUniswapV2Pair {
    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;
}

contract UniswapArbitrageur {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    address public _UNISWAP_;
    address public _DODO_;
    address public _BASE_;
    address public _QUOTE_;

    bool public _REVERSE_; // true if dodo.baseToken=uniswap.token0

    constructor(address _uniswap, address _dodo) public {
        _UNISWAP_ = _uniswap;
        _DODO_ = _dodo;

        _BASE_ = IDODO(_DODO_)._BASE_TOKEN_();
        _QUOTE_ = IDODO(_DODO_)._QUOTE_TOKEN_();

        address token0 = IUniswapV2Pair(_UNISWAP_).token0();
        address token1 = IUniswapV2Pair(_UNISWAP_).token1();

        if (token0 == _BASE_ && token1 == _QUOTE_) {
            _REVERSE_ = false;
        } else if (token0 == _QUOTE_ && token1 == _BASE_) {
            _REVERSE_ = true;
        } else {
            require(true, "DODO_UNISWAP_NOT_MATCH");
        }

        IERC20(_BASE_).approve(_DODO_, uint256(-1));
        IERC20(_QUOTE_).approve(_DODO_, uint256(-1));
    }

    function executeBuyArbitrage(uint256 baseAmount) external returns (uint256 quoteProfit) {
        IDODO(_DODO_).buyBaseToken(baseAmount, uint256(-1), "0xd");
        quoteProfit = IERC20(_QUOTE_).balanceOf(address(this));
        IERC20(_QUOTE_).transfer(msg.sender, quoteProfit);
        return quoteProfit;
    }

    function executeSellArbitrage(uint256 baseAmount) external returns (uint256 baseProfit) {
        IDODO(_DODO_).sellBaseToken(baseAmount, 0, "0xd");
        baseProfit = IERC20(_BASE_).balanceOf(address(this));
        IERC20(_BASE_).transfer(msg.sender, baseProfit);
        return baseProfit;
    }

    function dodoCall(
        bool isDODOBuy,
        uint256 baseAmount,
        uint256 quoteAmount,
        bytes calldata
    ) external {
        require(msg.sender == _DODO_, "WRONG_DODO");
        if (_REVERSE_) {
            _inverseArbitrage(isDODOBuy, baseAmount, quoteAmount);
        } else {
            _arbitrage(isDODOBuy, baseAmount, quoteAmount);
        }
    }

    function _inverseArbitrage(
        bool isDODOBuy,
        uint256 baseAmount,
        uint256 quoteAmount
    ) internal {
        (uint112 _reserve0, uint112 _reserve1, ) = IUniswapV2Pair(_UNISWAP_).getReserves();
        uint256 token0Balance = uint256(_reserve0);
        uint256 token1Balance = uint256(_reserve1);
        uint256 token0Amount;
        uint256 token1Amount;
        if (isDODOBuy) {
            IERC20(_BASE_).transfer(_UNISWAP_, baseAmount);
            // transfer token1 into uniswap
            uint256 newToken0Balance = token0Balance.mul(token1Balance).div(
                token1Balance.add(baseAmount)
            );
            token0Amount = token0Balance.sub(newToken0Balance).mul(9969).div(10000); // mul 0.9969
            require(token0Amount > quoteAmount, "NOT_PROFITABLE");
            IUniswapV2Pair(_UNISWAP_).swap(token0Amount, token1Amount, address(this), "");
        } else {
            IERC20(_QUOTE_).transfer(_UNISWAP_, quoteAmount);
            // transfer token0 into uniswap
            uint256 newToken1Balance = token0Balance.mul(token1Balance).div(
                token0Balance.add(quoteAmount)
            );
            token1Amount = token1Balance.sub(newToken1Balance).mul(9969).div(10000); // mul 0.9969
            require(token1Amount > baseAmount, "NOT_PROFITABLE");
            IUniswapV2Pair(_UNISWAP_).swap(token0Amount, token1Amount, address(this), "");
        }
    }

    function _arbitrage(
        bool isDODOBuy,
        uint256 baseAmount,
        uint256 quoteAmount
    ) internal {
        (uint112 _reserve0, uint112 _reserve1, ) = IUniswapV2Pair(_UNISWAP_).getReserves();
        uint256 token0Balance = uint256(_reserve0);
        uint256 token1Balance = uint256(_reserve1);
        uint256 token0Amount;
        uint256 token1Amount;
        if (isDODOBuy) {
            IERC20(_BASE_).transfer(_UNISWAP_, baseAmount);
            // transfer token0 into uniswap
            uint256 newToken1Balance = token1Balance.mul(token0Balance).div(
                token0Balance.add(baseAmount)
            );
            token1Amount = token1Balance.sub(newToken1Balance).mul(9969).div(10000); // mul 0.9969
            require(token1Amount > quoteAmount, "NOT_PROFITABLE");
            IUniswapV2Pair(_UNISWAP_).swap(token0Amount, token1Amount, address(this), "");
        } else {
            IERC20(_QUOTE_).transfer(_UNISWAP_, quoteAmount);
            // transfer token1 into uniswap
            uint256 newToken0Balance = token1Balance.mul(token0Balance).div(
                token1Balance.add(quoteAmount)
            );
            token0Amount = token0Balance.sub(newToken0Balance).mul(9969).div(10000); // mul 0.9969
            require(token0Amount > baseAmount, "NOT_PROFITABLE");
            IUniswapV2Pair(_UNISWAP_).swap(token0Amount, token1Amount, address(this), "");
        }
    }

    function retrieve(address token, uint256 amount) external {
        IERC20(token).safeTransfer(msg.sender, amount);
    }
}