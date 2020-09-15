/**
 *Submitted for verification at Etherscan.io on 2020-05-11
*/

pragma solidity ^0.6.4;

// import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

// import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// import "@uniswap/lib/contracts/libraries/Babylonian.sol";
library Babylonian {
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
        // else z = 0
    }
}

// import "@uniswap/lib/contracts/libraries/TransferHelper.sol";
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}

// import "../interfaces/IUniswapV2Router01.sol";
interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// import "../interfaces/IWETH.sol";
interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
}

// import "../libraries/SafeMath.sol";
library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}

// import "../libraries/UniswapV2Library.sol";
library UniswapV2Library {
    using SafeMath for uint;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
            ))));
    }

    // fetches and sorts the reserves for a pair
    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(1000);
        uint denominator = reserveOut.sub(amountOut).mul(997);
        amountIn = (numerator / denominator).add(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
        }
    }
}

// enables adding and removing liquidity with a single token to/from a pair
// adds liquidity via a single token of the pair, by first swapping against the pair and then adding liquidity
// removes liquidity in a single token, by removing liquidity and then immediately swapping
contract UniZap {
    using SafeMath for uint;

    IUniswapV2Factory public factory;
    IUniswapV2Router01 public router;
    IWETH public weth;

    constructor(IUniswapV2Factory factory_, IUniswapV2Router01 router_, IWETH weth_) public {
        factory = factory_;
        router = router_;
        weth = weth_;
    }

    // returns the amount of token that should be swapped in such that ratio of reserves in the pair is equivalent
    // to the swapper's ratio of tokens
    // note this depends only on the number of tokens the caller wishes to swap and the current reserves of that token,
    // and not the current reserves of the other token
    function calculateSwapInAmount(uint reserveIn, uint userIn) public pure returns (uint) {
        return Babylonian.sqrt(reserveIn.mul(userIn.mul(3988000) + reserveIn.mul(3988009))).sub(reserveIn.mul(1997)) / 1994;
    }

    // internal function shared by the ETH/non-ETH versions
    function _swapExactTokensAndAddLiquidity(
        address from,
        address tokenIn,
        address otherToken,
        uint amountIn,
        uint minOtherTokenIn,
        address to,
        uint deadline
    ) internal returns (uint amountTokenIn, uint amountTokenOther, uint liquidity) {
        // compute how much we should swap in to match the reserve ratio of tokenIn / otherToken of the pair
        uint swapInAmount;
        {
            (uint reserveIn,) = UniswapV2Library.getReserves(address(factory), tokenIn, otherToken);
            swapInAmount = calculateSwapInAmount(reserveIn, amountIn);
        }

        // first take possession of the full amount from the caller, unless caller is this contract
        if (from != address(this)) {
            TransferHelper.safeTransferFrom(tokenIn, from, address(this), amountIn);
        }
        // approve for the swap, and then later the add liquidity. total is amountIn
        TransferHelper.safeApprove(tokenIn, address(router), amountIn);

        {
            address[] memory path = new address[](2);
            path[0] = tokenIn;
            path[1] = otherToken;

            amountTokenOther = router.swapExactTokensForTokens(
                swapInAmount,
                minOtherTokenIn,
                path,
                address(this),
                deadline
            )[1];
        }

        // approve the other token for the add liquidity call
        TransferHelper.safeApprove(otherToken, address(router), amountTokenOther);
        amountTokenIn = amountIn.sub(swapInAmount);

        // no need to check that we transferred everything because minimums == total balance of this contract
        (,,liquidity) = router.addLiquidity(
            tokenIn,
            otherToken,
        // desired amountA, amountB
            amountTokenIn,
            amountTokenOther,
        // amountTokenIn and amountTokenOther should match the ratio of reserves of tokenIn to otherToken
        // thus we do not need to constrain the minimums here
            0,
            0,
            to,
            deadline
        );
    }

    // computes the exact amount of tokens that should be swapped before adding liquidity for a given token
    // does the swap and then adds liquidity
    // minOtherToken should be set to the minimum intermediate amount of token1 that should be received to prevent
    // excessive slippage or front running
    // liquidity provider shares are minted to the 'to' address
    function swapExactTokensAndAddLiquidity(
        address tokenIn,
        address otherToken,
        uint amountIn,
        uint minOtherTokenIn,
        address to,
        uint deadline
    ) external returns (uint amountTokenIn, uint amountTokenOther, uint liquidity) {
        return _swapExactTokensAndAddLiquidity(
            msg.sender, tokenIn, otherToken, amountIn, minOtherTokenIn, to, deadline
        );
    }

    // similar to the above method but handles converting ETH to WETH
    function swapExactETHAndAddLiquidity(
        address token,
        uint minTokenIn,
        address to,
        uint deadline
    ) external payable returns (uint amountETHIn, uint amountTokenIn, uint liquidity) {
        weth.deposit{value: msg.value}();
        return _swapExactTokensAndAddLiquidity(
            address(this), address(weth), token, msg.value, minTokenIn, to, deadline
        );
    }

    // internal function shared by the ETH/non-ETH versions
    function _removeLiquidityAndSwap(
        address from,
        address undesiredToken,
        address desiredToken,
        uint liquidity,
        uint minDesiredTokenOut,
        address to,
        uint deadline
    ) internal returns (uint amountDesiredTokenOut) {
        address pair = UniswapV2Library.pairFor(address(factory), undesiredToken, desiredToken);
        // take possession of liquidity and give access to the router
        TransferHelper.safeTransferFrom(pair, from, address(this), liquidity);
        TransferHelper.safeApprove(pair, address(router), liquidity);

        (uint amountInToSwap, uint amountOutToTransfer) = router.removeLiquidity(
            undesiredToken,
            desiredToken,
            liquidity,
        // amount minimums are applied in the swap
            0,
            0,
        // contract must receive both tokens because we want to swap the undesired token
            address(this),
            deadline
        );

        // send the amount in that we received in the burn
        TransferHelper.safeApprove(undesiredToken, address(router), amountInToSwap);

        address[] memory path = new address[](2);
        path[0] = undesiredToken;
        path[1] = desiredToken;

        uint amountOutSwap = router.swapExactTokensForTokens(
            amountInToSwap,
        // we must get at least this much from the swap to meet the minDesiredTokenOut parameter
            minDesiredTokenOut > amountOutToTransfer ? minDesiredTokenOut - amountOutToTransfer : 0,
            path,
            to,
            deadline
        )[1];

        // we do this after the swap to save gas in the case where we do not meet the minimum output
        if (to != address(this)) {
            TransferHelper.safeTransfer(desiredToken, to, amountOutToTransfer);
        }
        amountDesiredTokenOut = amountOutToTransfer + amountOutSwap;
    }

    // burn the liquidity and then swap one of the two tokens to the other
    // enforces that at least minDesiredTokenOut tokens are received from the combination of burn and swap
    function removeLiquidityAndSwapToToken(
        address undesiredToken,
        address desiredToken,
        uint liquidity,
        uint minDesiredTokenOut,
        address to,
        uint deadline
    ) external returns (uint amountDesiredTokenOut) {
        return _removeLiquidityAndSwap(
            msg.sender, undesiredToken, desiredToken, liquidity, minDesiredTokenOut, to, deadline
        );
    }

    // only WETH can send to this contract without a function call.
    receive() payable external {
        require(msg.sender == address(weth), 'CombinedSwapAddRemoveLiquidity: RECEIVE_NOT_FROM_WETH');
    }

    // similar to the above method but for when the desired token is WETH, handles unwrapping
    function removeLiquidityAndSwapToETH(
        address token,
        uint liquidity,
        uint minDesiredETH,
        address to,
        uint deadline
    ) external returns (uint amountETHOut) {
        // do the swap remove and swap to this address
        amountETHOut = _removeLiquidityAndSwap(
            msg.sender, token, address(weth), liquidity, minDesiredETH, address(this), deadline
        );

        // now withdraw to ETH and forward to the recipient
        weth.withdraw(amountETHOut);
        TransferHelper.safeTransferETH(to, amountETHOut);
    }
}