/**
 *Submitted for verification at Etherscan.io on 2020-08-13
*/

// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol

pragma solidity >=0.5.0;

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

// File: @uniswap/lib/contracts/libraries/FixedPoint.sol

pragma solidity >=0.4.0;

// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
library FixedPoint {
    // range: [0, 2**112 - 1]
    // resolution: 1 / 2**112
    struct uq112x112 {
        uint224 _x;
    }

    // range: [0, 2**144 - 1]
    // resolution: 1 / 2**112
    struct uq144x112 {
        uint _x;
    }

    uint8 private constant RESOLUTION = 112;

    // encode a uint112 as a UQ112x112
    function encode(uint112 x) internal pure returns (uq112x112 memory) {
        return uq112x112(uint224(x) << RESOLUTION);
    }

    // encodes a uint144 as a UQ144x112
    function encode144(uint144 x) internal pure returns (uq144x112 memory) {
        return uq144x112(uint256(x) << RESOLUTION);
    }

    // divide a UQ112x112 by a uint112, returning a UQ112x112
    function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
        require(x != 0, 'FixedPoint: DIV_BY_ZERO');
        return uq112x112(self._x / uint224(x));
    }

    // multiply a UQ112x112 by a uint, returning a UQ144x112
    // reverts on overflow
    function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
        uint z;
        require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
        return uq144x112(z);
    }

    // returns a UQ112x112 which represents the ratio of the numerator to the denominator
    // equivalent to encode(numerator).div(denominator)
    function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
        require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
        return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
    }

    // decode a UQ112x112 into a uint112 by truncating after the radix point
    function decode(uq112x112 memory self) internal pure returns (uint112) {
        return uint112(self._x >> RESOLUTION);
    }

    // decode a UQ144x112 into a uint144 by truncating after the radix point
    function decode144(uq144x112 memory self) internal pure returns (uint144) {
        return uint144(self._x >> RESOLUTION);
    }
}

// File: contracts/libraries/UniswapV2OracleLibrary.sol

pragma solidity >=0.5.0;



// library with helper methods for oracles that are concerned with computing average prices
library UniswapV2OracleLibrary {
    using FixedPoint for *;

    // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
    function currentBlockTimestamp() internal view returns (uint32) {
        return uint32(block.timestamp % 2 ** 32);
    }

    // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
    function currentCumulativePrices(
        address pair
    ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
        blockTimestamp = currentBlockTimestamp();
        price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
        price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();

        // if time has elapsed since the last update on the pair, mock the accumulated price values
        (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
        if (blockTimestampLast != blockTimestamp) {
            // subtraction overflow is desired
            uint32 timeElapsed = blockTimestamp - blockTimestampLast;
            // addition overflow is desired
            // counterfactual
            price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
            // counterfactual
            price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
        }
    }
}

// File: contracts/libraries/SafeMath.sol

pragma solidity =0.6.6;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

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

    function abs(int a) internal pure returns (int) {
        require(a != int256(1) << 255, 'ds-math-mul-overflow');
        return a < 0 ? -a : a;
    }
}

// File: contracts/interfaces/IMostERC20.sol

pragma solidity >=0.6.2;

interface IMostERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
    event LogRebase(uint indexed epoch, uint totalSupply);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function epoch() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function PERIOD() external pure returns (uint);

    function pair() external view returns (address);
    function rebaseSetter() external view returns (address);
    function creator() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function blockTimestampLast() external view returns (uint32);
    function initialize(address, address) external;
    function rebase() external returns (uint);
    function setRebaseSetter(address) external;
    function setCreator(address) external;
    function consult(address token, uint amountIn) external view returns (uint amountOut);
}

// File: contracts/interfaces/IERC20.sol

pragma solidity >=0.5.0;

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

// File: contracts/MostHelper.sol

pragma solidity =0.6.6;







contract MostHelper {
    using FixedPoint for *;
    using SafeMath for uint;
    using SafeMath for int;

    uint8 private constant RATE_BASE = 100;
    uint8 private constant UPPER_BOUND = 106;
    uint8 private constant LOWER_BOUND = 96;
    uint private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1

    address pair;
    address mostToken;

    constructor(address _pair, address _mostToken) public {
        pair = _pair;
        mostToken = _mostToken;
    }

    function consultNow(uint amountIn) external view returns (uint amountOut, int256 supplyDelta, uint totalSupply) {
        IMostERC20 mostERC20Token = IMostERC20(mostToken);
        address token0 = mostERC20Token.token0();
        address token1 = mostERC20Token.token1();

        (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) =
            UniswapV2OracleLibrary.currentCumulativePrices(mostERC20Token.pair());
        uint32 timeElapsed = blockTimestamp - mostERC20Token.blockTimestampLast(); // overflow is desired

        uint priceAverage;
        uint tokenBRemaining;

        // overflow is desired, casting never truncates
        // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
        if (mostToken == token0) {
            FixedPoint.uq112x112 memory price0Average = FixedPoint.uq112x112(uint224((price0Cumulative - mostERC20Token.price0CumulativeLast()) / timeElapsed));
            amountOut = price0Average.mul(amountIn).decode144();
            priceAverage = price0Average.mul(10 ** uint(mostERC20Token.decimals())).decode144();
            tokenBRemaining = 10 ** uint(IERC20(token1).decimals() - 2);
        } else {
            require(mostToken == token1, 'MOST: INVALID_TOKEN');
            FixedPoint.uq112x112 memory price1Average = FixedPoint.uq112x112(uint224((price1Cumulative - mostERC20Token.price1CumulativeLast()) / timeElapsed));
            amountOut = price1Average.mul(amountIn).decode144();
            priceAverage = price1Average.mul(10 ** uint(mostERC20Token.decimals())).decode144();
            tokenBRemaining = 10 ** uint(IERC20(token0).decimals() - 2);
        }

        uint unitBase = RATE_BASE * tokenBRemaining;
        if (priceAverage > UPPER_BOUND * tokenBRemaining) {
            supplyDelta = 0 - int(mostERC20Token.totalSupply().mul(priceAverage.sub(unitBase)) / priceAverage);
        } else if (priceAverage < LOWER_BOUND * tokenBRemaining) {
            supplyDelta = int(mostERC20Token.totalSupply().mul(unitBase.sub(priceAverage)) / unitBase);
        } else {
            supplyDelta = 0;
        }

        supplyDelta = supplyDelta / 10;

        if (supplyDelta == 0) {
            totalSupply = mostERC20Token.totalSupply();
        }

        if (supplyDelta < 0) {
            totalSupply = mostERC20Token.totalSupply().sub(uint256(supplyDelta.abs()));
        } else {
            totalSupply = mostERC20Token.totalSupply().add(uint256(supplyDelta));
        }

        if (totalSupply > MAX_SUPPLY) {
            totalSupply = MAX_SUPPLY;
        }
    }

    function rebase() external returns (uint totalSupply) {
        totalSupply = IMostERC20(mostToken).rebase();
        IUniswapV2Pair(pair).sync();
    }
}