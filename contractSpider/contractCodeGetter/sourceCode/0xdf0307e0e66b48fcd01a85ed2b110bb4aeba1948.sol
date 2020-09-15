/**
 *Submitted for verification at Etherscan.io on 2020-06-23
*/

pragma solidity ^0.5.0;
//pragma experimental ABIEncoderV2;


/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}


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


library BalancerLib {
    uint public constant BONE              = 10**18;

    uint public constant MIN_BOUND_TOKENS  = 2;
    uint public constant MAX_BOUND_TOKENS  = 8;

    uint public constant MIN_FEE           = BONE / 10**6;
    uint public constant MAX_FEE           = BONE / 10;
    uint public constant EXIT_FEE          = 0;

    uint public constant MIN_WEIGHT        = BONE;
    uint public constant MAX_WEIGHT        = BONE * 50;
    uint public constant MAX_TOTAL_WEIGHT  = BONE * 50;
    uint public constant MIN_BALANCE       = BONE / 10**12;

    uint public constant INIT_POOL_SUPPLY  = BONE * 100;

    uint public constant MIN_BPOW_BASE     = 1 wei;
    uint public constant MAX_BPOW_BASE     = (2 * BONE) - 1 wei;
    uint public constant BPOW_PRECISION    = BONE / 10**10;

    uint public constant MAX_IN_RATIO      = BONE / 2;
    uint public constant MAX_OUT_RATIO     = (BONE / 3) + 1 wei;

    function btoi(uint a)
        internal pure 
        returns (uint)
    {
        return a / BONE;
    }

    function bfloor(uint a)
        internal pure
        returns (uint)
    {
        return btoi(a) * BONE;
    }

    function badd(uint a, uint b)
        internal pure
        returns (uint)
    {
        uint c = a + b;
        require(c >= a, "ERR_ADD_OVERFLOW");
        return c;
    }

    function bsub(uint a, uint b)
        internal pure
        returns (uint)
    {
        (uint c, bool flag) = bsubSign(a, b);
        require(!flag, "ERR_SUB_UNDERFLOW");
        return c;
    }

    function bsubSign(uint a, uint b)
        internal pure
        returns (uint, bool)
    {
        if (a >= b) {
            return (a - b, false);
        } else {
            return (b - a, true);
        }
    }

    function bmul(uint a, uint b)
        internal pure
        returns (uint)
    {
        uint c0 = a * b;
        require(a == 0 || c0 / a == b, "ERR_MUL_OVERFLOW");
        uint c1 = c0 + (BONE / 2);
        require(c1 >= c0, "ERR_MUL_OVERFLOW");
        uint c2 = c1 / BONE;
        return c2;
    }

    function bdiv(uint a, uint b)
        internal pure
        returns (uint)
    {
        require(b != 0, "ERR_DIV_ZERO");
        uint c0 = a * BONE;
        require(a == 0 || c0 / a == BONE, "ERR_DIV_INTERNAL"); // bmul overflow
        uint c1 = c0 + (b / 2);
        require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require
        uint c2 = c1 / b;
        return c2;
    }

    // DSMath.wpow
    function bpowi(uint a, uint n)
        internal pure
        returns (uint)
    {
        uint z = n % 2 != 0 ? a : BONE;

        for (n /= 2; n != 0; n /= 2) {
            a = bmul(a, a);

            if (n % 2 != 0) {
                z = bmul(z, a);
            }
        }
        return z;
    }

    // Compute b^(e.w) by splitting it into (b^e)*(b^0.w).
    // Use `bpowi` for `b^e` and `bpowK` for k iterations
    // of approximation of b^0.w
    function bpow(uint base, uint exp)
        internal pure
        returns (uint)
    {
        require(base >= MIN_BPOW_BASE, "ERR_BPOW_BASE_TOO_LOW");
        require(base <= MAX_BPOW_BASE, "ERR_BPOW_BASE_TOO_HIGH");

        uint whole  = bfloor(exp);   
        uint remain = bsub(exp, whole);

        uint wholePow = bpowi(base, btoi(whole));

        if (remain == 0) {
            return wholePow;
        }

        uint partialResult = bpowApprox(base, remain, BPOW_PRECISION);
        return bmul(wholePow, partialResult);
    }

    function bpowApprox(uint base, uint exp, uint precision)
        internal pure
        returns (uint)
    {
        // term 0:
        uint a     = exp;
        (uint x, bool xneg)  = bsubSign(base, BONE);
        uint term = BONE;
        uint sum   = term;
        bool negative = false;


        // term(k) = numer / denom 
        //         = (product(a - i - 1, i=1-->k) * x^k) / (k!)
        // each iteration, multiply previous term by (a-(k-1)) * x / k
        // continue until term is less than precision
        for (uint i = 1; term >= precision; i++) {
            uint bigK = i * BONE;
            (uint c, bool cneg) = bsubSign(a, bsub(bigK, BONE));
            term = bmul(term, bmul(c, x));
            term = bdiv(term, bigK);
            if (term == 0) break;

            if (xneg) negative = !negative;
            if (cneg) negative = !negative;
            if (negative) {
                sum = bsub(sum, term);
            } else {
                sum = badd(sum, term);
            }
        }

        return sum;
    }

    /**********************************************************************************************
    // calcSpotPrice                                                                             //
    // sP = spotPrice                                                                            //
    // bI = tokenBalanceIn                ( bI / wI )         1                                  //
    // bO = tokenBalanceOut         sP =  -----------  *  ----------                             //
    // wI = tokenWeightIn                 ( bO / wO )     ( 1 - sF )                             //
    // wO = tokenWeightOut                                                                       //
    // sF = swapFee                                                                              //
    **********************************************************************************************/
    function calcSpotPrice(
        uint tokenBalanceIn,
        uint tokenWeightIn,
        uint tokenBalanceOut,
        uint tokenWeightOut,
        uint swapFee
    )
        internal pure
        returns (uint spotPrice)
    {
        uint numer = bdiv(tokenBalanceIn, tokenWeightIn);
        uint denom = bdiv(tokenBalanceOut, tokenWeightOut);
        uint ratio = bdiv(numer, denom);
        uint scale = bdiv(BONE, bsub(BONE, swapFee));
        return  (spotPrice = bmul(ratio, scale));
    }

    /**********************************************************************************************
    // calcOutGivenIn                                                                            //
    // aO = tokenAmountOut                                                                       //
    // bO = tokenBalanceOut                                                                      //
    // bI = tokenBalanceIn              /      /            bI             \    (wI / wO) \      //
    // aI = tokenAmountIn    aO = bO * |  1 - | --------------------------  | ^            |     //
    // wI = tokenWeightIn               \      \ ( bI + ( aI * ( 1 - sF )) /              /      //
    // wO = tokenWeightOut                                                                       //
    // sF = swapFee                                                                              //
    **********************************************************************************************/
    function calcOutGivenIn(
        uint tokenBalanceIn,
        uint tokenWeightIn,
        uint tokenBalanceOut,
        uint tokenWeightOut,
        uint tokenAmountIn,
        uint swapFee
    )
        internal pure
        returns (uint tokenAmountOut)
    {
        uint weightRatio = bdiv(tokenWeightIn, tokenWeightOut);
        uint adjustedIn = bsub(BONE, swapFee);
        adjustedIn = bmul(tokenAmountIn, adjustedIn);
        uint y = bdiv(tokenBalanceIn, badd(tokenBalanceIn, adjustedIn));
        uint foo = bpow(y, weightRatio);
        uint bar = bsub(BONE, foo);
        tokenAmountOut = bmul(tokenBalanceOut, bar);
        return tokenAmountOut;
    }

    /**********************************************************************************************
    // calcInGivenOut                                                                            //
    // aI = tokenAmountIn                                                                        //
    // bO = tokenBalanceOut               /  /     bO      \    (wO / wI)      \                 //
    // bI = tokenBalanceIn          bI * |  | ------------  | ^            - 1  |                //
    // aO = tokenAmountOut    aI =        \  \ ( bO - aO ) /                   /                 //
    // wI = tokenWeightIn           --------------------------------------------                 //
    // wO = tokenWeightOut                          ( 1 - sF )                                   //
    // sF = swapFee                                                                              //
    **********************************************************************************************/
    function calcInGivenOut(
        uint tokenBalanceIn,
        uint tokenWeightIn,
        uint tokenBalanceOut,
        uint tokenWeightOut,
        uint tokenAmountOut,
        uint swapFee
    )
        internal pure
        returns (uint tokenAmountIn)
    {
        uint weightRatio = bdiv(tokenWeightOut, tokenWeightIn);
        uint diff = bsub(tokenBalanceOut, tokenAmountOut);
        uint y = bdiv(tokenBalanceOut, diff);
        uint foo = bpow(y, weightRatio);
        foo = bsub(foo, BONE);
        tokenAmountIn = bsub(BONE, swapFee);
        tokenAmountIn = bdiv(bmul(tokenBalanceIn, foo), tokenAmountIn);
        return tokenAmountIn;
    }

    /**********************************************************************************************
    // calcPoolOutGivenSingleIn                                                                  //
    // pAo = poolAmountOut         /                                              \              //
    // tAi = tokenAmountIn        ///      /     //    wI \      \\       \     wI \             //
    // wI = tokenWeightIn        //| tAi *| 1 - || 1 - --  | * sF || + tBi \    --  \            //
    // tW = totalWeight     pAo=||  \      \     \\    tW /      //         | ^ tW   | * pS - pS //
    // tBi = tokenBalanceIn      \\  ------------------------------------- /        /            //
    // pS = poolSupply            \\                    tBi               /        /             //
    // sF = swapFee                \                                              /              //
    **********************************************************************************************/
    function calcPoolOutGivenSingleIn(
        uint tokenBalanceIn,
        uint tokenWeightIn,
        uint poolSupply,
        uint totalWeight,
        uint tokenAmountIn,
        uint swapFee
    )
        internal pure
        returns (uint poolAmountOut)
    {
        // Charge the trading fee for the proportion of tokenAi
        ///  which is implicitly traded to the other pool tokens.
        // That proportion is (1- weightTokenIn)
        // tokenAiAfterFee = tAi * (1 - (1-weightTi) * poolFee);
        uint normalizedWeight = bdiv(tokenWeightIn, totalWeight);
        uint zaz = bmul(bsub(BONE, normalizedWeight), swapFee); 
        uint tokenAmountInAfterFee = bmul(tokenAmountIn, bsub(BONE, zaz));

        uint newTokenBalanceIn = badd(tokenBalanceIn, tokenAmountInAfterFee);
        uint tokenInRatio = bdiv(newTokenBalanceIn, tokenBalanceIn);

        // uint newPoolSupply = (ratioTi ^ weightTi) * poolSupply;
        uint poolRatio = bpow(tokenInRatio, normalizedWeight);
        uint newPoolSupply = bmul(poolRatio, poolSupply);
        poolAmountOut = bsub(newPoolSupply, poolSupply);
        return poolAmountOut;
    }

    /**********************************************************************************************
    // calcSingleInGivenPoolOut                                                                  //
    // tAi = tokenAmountIn              //(pS + pAo)\     /    1    \\                           //
    // pS = poolSupply                 || ---------  | ^ | --------- || * bI - bI                //
    // pAo = poolAmountOut              \\    pS    /     \(wI / tW)//                           //
    // bI = balanceIn          tAi =  --------------------------------------------               //
    // wI = weightIn                              /      wI  \                                   //
    // tW = totalWeight                          |  1 - ----  |  * sF                            //
    // sF = swapFee                               \      tW  /                                   //
    **********************************************************************************************/
    function calcSingleInGivenPoolOut(
        uint tokenBalanceIn,
        uint tokenWeightIn,
        uint poolSupply,
        uint totalWeight,
        uint poolAmountOut,
        uint swapFee
    )
        internal pure
        returns (uint tokenAmountIn)
    {
        uint normalizedWeight = bdiv(tokenWeightIn, totalWeight);
        uint newPoolSupply = badd(poolSupply, poolAmountOut);
        uint poolRatio = bdiv(newPoolSupply, poolSupply);
      
        //uint newBalTi = poolRatio^(1/weightTi) * balTi;
        uint boo = bdiv(BONE, normalizedWeight); 
        uint tokenInRatio = bpow(poolRatio, boo);
        uint newTokenBalanceIn = bmul(tokenInRatio, tokenBalanceIn);
        uint tokenAmountInAfterFee = bsub(newTokenBalanceIn, tokenBalanceIn);
        // Do reverse order of fees charged in joinswap_ExternAmountIn, this way 
        //     ``` pAo == joinswap_ExternAmountIn(Ti, joinswap_PoolAmountOut(pAo, Ti)) ```
        //uint tAi = tAiAfterFee / (1 - (1-weightTi) * swapFee) ;
        uint zar = bmul(bsub(BONE, normalizedWeight), swapFee);
        tokenAmountIn = bdiv(tokenAmountInAfterFee, bsub(BONE, zar));
        return tokenAmountIn;
    }

    /**********************************************************************************************
    // calcSingleOutGivenPoolIn                                                                  //
    // tAo = tokenAmountOut            /      /                                             \\   //
    // bO = tokenBalanceOut           /      // pS - (pAi * (1 - eF)) \     /    1    \      \\  //
    // pAi = poolAmountIn            | bO - || ----------------------- | ^ | --------- | * b0 || //
    // ps = poolSupply                \      \\          pS           /     \(wO / tW)/      //  //
    // wI = tokenWeightIn      tAo =   \      \                                             //   //
    // tW = totalWeight                    /     /      wO \       \                             //
    // sF = swapFee                    *  | 1 - |  1 - ---- | * sF  |                            //
    // eF = exitFee                        \     \      tW /       /                             //
    **********************************************************************************************/
    function calcSingleOutGivenPoolIn(
        uint tokenBalanceOut,
        uint tokenWeightOut,
        uint poolSupply,
        uint totalWeight,
        uint poolAmountIn,
        uint swapFee
    )
        internal pure
        returns (uint tokenAmountOut)
    {
        uint normalizedWeight = bdiv(tokenWeightOut, totalWeight);
        // charge exit fee on the pool token side
        // pAiAfterExitFee = pAi*(1-exitFee)
        uint poolAmountInAfterExitFee = bmul(poolAmountIn, bsub(BONE, EXIT_FEE));
        uint newPoolSupply = bsub(poolSupply, poolAmountInAfterExitFee);
        uint poolRatio = bdiv(newPoolSupply, poolSupply);
     
        // newBalTo = poolRatio^(1/weightTo) * balTo;
        uint tokenOutRatio = bpow(poolRatio, bdiv(BONE, normalizedWeight));
        uint newTokenBalanceOut = bmul(tokenOutRatio, tokenBalanceOut);

        uint tokenAmountOutBeforeSwapFee = bsub(tokenBalanceOut, newTokenBalanceOut);

        // charge swap fee on the output token side 
        //uint tAo = tAoBeforeSwapFee * (1 - (1-weightTo) * swapFee)
        uint zaz = bmul(bsub(BONE, normalizedWeight), swapFee); 
        tokenAmountOut = bmul(tokenAmountOutBeforeSwapFee, bsub(BONE, zaz));
        return tokenAmountOut;
    }

    /**********************************************************************************************
    // calcPoolInGivenSingleOut                                                                  //
    // pAi = poolAmountIn               // /               tAo             \\     / wO \     \   //
    // bO = tokenBalanceOut            // | bO - -------------------------- |\   | ---- |     \  //
    // tAo = tokenAmountOut      pS - ||   \     1 - ((1 - (tO / tW)) * sF)/  | ^ \ tW /  * pS | //
    // ps = poolSupply                 \\ -----------------------------------/                /  //
    // wO = tokenWeightOut  pAi =       \\               bO                 /                /   //
    // tW = totalWeight           -------------------------------------------------------------  //
    // sF = swapFee                                        ( 1 - eF )                            //
    // eF = exitFee                                                                              //
    **********************************************************************************************/
    function calcPoolInGivenSingleOut(
        uint tokenBalanceOut,
        uint tokenWeightOut,
        uint poolSupply,
        uint totalWeight,
        uint tokenAmountOut,
        uint swapFee
    )
        internal pure
        returns (uint poolAmountIn)
    {

        // charge swap fee on the output token side 
        uint normalizedWeight = bdiv(tokenWeightOut, totalWeight);
        //uint tAoBeforeSwapFee = tAo / (1 - (1-weightTo) * swapFee) ;
        uint zoo = bsub(BONE, normalizedWeight);
        uint zar = bmul(zoo, swapFee); 
        uint tokenAmountOutBeforeSwapFee = bdiv(tokenAmountOut, bsub(BONE, zar));

        uint newTokenBalanceOut = bsub(tokenBalanceOut, tokenAmountOutBeforeSwapFee);
        uint tokenOutRatio = bdiv(newTokenBalanceOut, tokenBalanceOut);

        //uint newPoolSupply = (ratioTo ^ weightTo) * poolSupply;
        uint poolRatio = bpow(tokenOutRatio, normalizedWeight);
        uint newPoolSupply = bmul(poolRatio, poolSupply);
        uint poolAmountInAfterExitFee = bsub(poolSupply, newPoolSupply);

        // charge exit fee on the pool token side
        // pAi = pAiAfterExitFee/(1-exitFee)
        poolAmountIn = bdiv(poolAmountInAfterExitFee, bsub(BONE, EXIT_FEE));
        return poolAmountIn;
    }
}


//


library AddressSet {
    struct Data {
        address[] items;
        mapping(address => uint) lookup;
    }

    function length(Data storage s) internal view returns(uint) {
        return s.items.length;
    }

    function at(Data storage s, uint index) internal view returns(address) {
        return s.items[index];
    }

    function contains(Data storage s, address item) internal view returns(bool) {
        return s.lookup[item] != 0;
    }

    function add(Data storage s, address item) internal returns(bool) {
        if (s.lookup[item] > 0) {
            return false;
        }
        s.lookup[item] = s.items.push(item);
        return true;
    }

    function remove(Data storage s, address item) internal returns(bool) {
        uint index = s.lookup[item];
        if (index == 0) {
            return false;
        }
        if (index < s.items.length) {
            address lastItem = s.items[s.items.length - 1];
            s.items[index - 1] = lastItem;
            s.lookup[lastItem] = index;
        }
        s.items.length -= 1;
        delete s.lookup[item];
        return true;
    }
}


interface BalancerPool {
    function getFinalTokens() external view returns(address[] memory tokens);
    function getDenormalizedWeight(address token) external view returns(uint256);
    function getTotalDenormalizedWeight() external view returns(uint256);
    function getBalance(address token) external view returns(uint256);
    function getSwapFee() external view returns(uint256);
}


contract BalancerRegistry {
    using SafeMath for uint256;
    using AddressSet for AddressSet.Data;

    struct PairInfo {
        uint80 weight1;
        uint80 weight2;
        uint80 swapFee;
    }
    
    mapping(bytes32 => AddressSet.Data) private _pools;
    mapping(address => mapping(bytes32 => PairInfo)) public pairs;

    function pools(bytes32 key) public view returns(address[] memory) {
        return _pools[key].items;
    }
    
    function poolsLimited(bytes32 key, uint256 limit) public view returns(address[] memory result) {
        result = new address[](Math.min(limit, _pools[key].items.length));
        for (uint i = 0; i < result.length; i++) {
            result[i] = _pools[key].items[i];
        }
    }
    
    function getPoolReturn(BalancerPool pool, address fromToken, address destToken, uint256 amount) public view returns(uint256) {
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = amount;
        return getPoolReturns(pool, fromToken, destToken, amounts)[0];
    }
    
    function getPoolReturns(BalancerPool pool, address fromToken, address destToken, uint256[] memory amounts) public view returns(uint256[] memory returnAmounts) {
        PairInfo memory pairInfo = pairs[address(pool)][_createKey(fromToken, destToken)];
        returnAmounts = new uint256[](amounts.length);
        for (uint i = 0; i < amounts.length; i++) {
            returnAmounts[i] = BalancerLib.calcOutGivenIn(
                pool.getBalance(fromToken),
                uint256(fromToken < destToken ? pairInfo.weight1 : pairInfo.weight2),
                pool.getBalance(destToken),
                uint256(fromToken < destToken ? pairInfo.weight2 : pairInfo.weight1),
                amounts[i],
                pairInfo.swapFee
            );
        }
    }

    function addPool(BalancerPool pool) public {
        address[] memory tokens = pool.getFinalTokens();
        require(tokens.length <= 4, "BalancerRegistry: supporting pools with up to 4 tokens");
        
        uint256[] memory weights = new uint256[](tokens.length);
        for (uint i = 0; i < tokens.length; i++) {
            weights[i] = pool.getDenormalizedWeight(tokens[i]);
        }
        
        uint256 swapFee = pool.getSwapFee();
        uint256 listed = 0;
        for (uint i = 0; i < tokens.length; i++) {
            for (uint j = i + 1; j < tokens.length; j++) {
                bytes32 key = _createKey(tokens[i], tokens[j]);
                if (_pools[key].add(address(pool))) {
                    pairs[address(pool)][key] = PairInfo({
                        weight1: uint80(weights[tokens[i] < tokens[j] ? i : j]),
                        weight2: uint80(weights[tokens[i] < tokens[j] ? j : i]),
                        swapFee: uint80(swapFee)
                    });
                    listed++;
                }
            }
        }
        require(listed > 0, "All the assets were already listed");
    }

    function addPools(BalancerPool[] memory items) public {
        for (uint i = 0; i < items.length; i++) {
            addPool(items[i]);
        }
    }

    function _createKey(address token1, address token2) internal pure returns(bytes32) {
        return bytes32(
            (uint256(uint128((token1 < token2) ? token1 : token2)) << 128) |
            (uint256(uint128((token1 < token2) ? token2 : token1)))
        );
    }
}