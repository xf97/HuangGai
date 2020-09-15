/**
 *Submitted for verification at Etherscan.io on 2020-06-22
*/

pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;


interface MassetStructs {

    /** @dev Stores high level basket info */
    struct Basket {

        /** @dev Array of Bassets currently active */
        Basset[] bassets;

        /** @dev Max number of bAssets that can be present in any Basket */
        uint8 maxBassets;

        /** @dev Some bAsset is undergoing re-collateralisation */
        bool undergoingRecol;

        /**
         * @dev In the event that we do not raise enough funds from the auctioning of a failed Basset,
         * The Basket is deemed as failed, and is undercollateralised to a certain degree.
         * The collateralisation ratio is used to calc Masset burn rate.
         */
        bool failed;
        uint256 collateralisationRatio;

    }

    /** @dev Stores bAsset info. The struct takes 5 storage slots per Basset */
    struct Basset {

        /** @dev Address of the bAsset */
        address addr;

        /** @dev Status of the basset,  */
        BassetStatus status; // takes uint8 datatype (1 byte) in storage

        /** @dev An ERC20 can charge transfer fee, for example USDT, DGX tokens. */
        bool isTransferFeeCharged; // takes a byte in storage

        /**
         * @dev 1 Basset * ratio / ratioScale == x Masset (relative value)
         *      If ratio == 10e8 then 1 bAsset = 10 mAssets
         *      A ratio is divised as 10^(18-tokenDecimals) * measurementMultiple(relative value of 1 base unit)
         */
        uint256 ratio;

        /** @dev Target weights of the Basset (100% == 1e18) */
        uint256 maxWeight;

        /** @dev Amount of the Basset that is held in Collateral */
        uint256 vaultBalance;

    }

    /** @dev Status of the Basset - has it broken its peg? */
    enum BassetStatus {
        Default,
        Normal,
        BrokenBelowPeg,
        BrokenAbovePeg,
        Blacklisted,
        Liquidating,
        Liquidated,
        Failed
    }

    /** @dev Internal details on Basset */
    struct BassetDetails {
        Basset bAsset;
        address integrator;
        uint8 index;
    }

    /** @dev All details needed to Forge with multiple bAssets */
    struct ForgePropsMulti {
        bool isValid; // Flag to signify that forge bAssets have passed validity check
        Basset[] bAssets;
        address[] integrators;
        uint8[] indexes;
    }

    /** @dev All details needed for proportionate Redemption */
    struct RedeemPropsMulti {
        uint256 colRatio;
        Basset[] bAssets;
        address[] integrators;
        uint8[] indexes;
    }
}

contract IForgeValidator is MassetStructs {
    function validateMint(uint256 _totalVault, Basset calldata _basset, uint256 _bAssetQuantity)
        external pure returns (bool, string memory);
    function validateMintMulti(uint256 _totalVault, Basset[] calldata _bassets, uint256[] calldata _bAssetQuantities)
        external pure returns (bool, string memory);
    function validateSwap(uint256 _totalVault, Basset calldata _inputBasset, Basset calldata _outputBasset, uint256 _quantity)
        external pure returns (bool, string memory, uint256, bool);
    function validateRedemption(
        bool basketIsFailed,
        uint256 _totalVault,
        Basset[] calldata _allBassets,
        uint8[] calldata _indices,
        uint256[] calldata _bassetQuantities) external pure returns (bool, string memory, bool);
    function calculateRedemptionMulti(
        uint256 _mAssetQuantity,
        Basset[] calldata _allBassets) external pure returns (bool, string memory, uint256[] memory);
}

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

library StableMath {

    using SafeMath for uint256;

    /**
     * @dev Scaling unit for use in specific calculations,
     * where 1 * 10**18, or 1e18 represents a unit '1'
     */
    uint256 private constant FULL_SCALE = 1e18;

    /**
     * @notice Token Ratios are used when converting between units of bAsset, mAsset and MTA
     * Reasoning: Takes into account token decimals, and difference in base unit (i.e. grams to Troy oz for gold)
     * @dev bAsset ratio unit for use in exact calculations,
     * where (1 bAsset unit * bAsset.ratio) / ratioScale == x mAsset unit
     */
    uint256 private constant RATIO_SCALE = 1e8;

    /**
     * @dev Provides an interface to the scaling unit
     * @return Scaling unit (1e18 or 1 * 10**18)
     */
    function getFullScale() internal pure returns (uint256) {
        return FULL_SCALE;
    }

    /**
     * @dev Provides an interface to the ratio unit
     * @return Ratio scale unit (1e8 or 1 * 10**8)
     */
    function getRatioScale() internal pure returns (uint256) {
        return RATIO_SCALE;
    }

    /**
     * @dev Scales a given integer to the power of the full scale.
     * @param x   Simple uint256 to scale
     * @return    Scaled value a to an exact number
     */
    function scaleInteger(uint256 x)
        internal
        pure
        returns (uint256)
    {
        return x.mul(FULL_SCALE);
    }

    /***************************************
              PRECISE ARITHMETIC
    ****************************************/

    /**
     * @dev Multiplies two precise units, and then truncates by the full scale
     * @param x     Left hand input to multiplication
     * @param y     Right hand input to multiplication
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              scale unit
     */
    function mulTruncate(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        return mulTruncateScale(x, y, FULL_SCALE);
    }

    /**
     * @dev Multiplies two precise units, and then truncates by the given scale. For example,
     * when calculating 90% of 10e18, (10e18 * 9e17) / 1e18 = (9e36) / 1e18 = 9e18
     * @param x     Left hand input to multiplication
     * @param y     Right hand input to multiplication
     * @param scale Scale unit
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              scale unit
     */
    function mulTruncateScale(uint256 x, uint256 y, uint256 scale)
        internal
        pure
        returns (uint256)
    {
        // e.g. assume scale = fullScale
        // z = 10e18 * 9e17 = 9e36
        uint256 z = x.mul(y);
        // return 9e38 / 1e18 = 9e18
        return z.div(scale);
    }

    /**
     * @dev Multiplies two precise units, and then truncates by the full scale, rounding up the result
     * @param x     Left hand input to multiplication
     * @param y     Right hand input to multiplication
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              scale unit, rounded up to the closest base unit.
     */
    function mulTruncateCeil(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        // e.g. 8e17 * 17268172638 = 138145381104e17
        uint256 scaled = x.mul(y);
        // e.g. 138145381104e17 + 9.99...e17 = 138145381113.99...e17
        uint256 ceil = scaled.add(FULL_SCALE.sub(1));
        // e.g. 13814538111.399...e18 / 1e18 = 13814538111
        return ceil.div(FULL_SCALE);
    }

    /**
     * @dev Precisely divides two units, by first scaling the left hand operand. Useful
     *      for finding percentage weightings, i.e. 8e18/10e18 = 80% (or 8e17)
     * @param x     Left hand input to division
     * @param y     Right hand input to division
     * @return      Result after multiplying the left operand by the scale, and
     *              executing the division on the right hand input.
     */
    function divPrecisely(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        // e.g. 8e18 * 1e18 = 8e36
        uint256 z = x.mul(FULL_SCALE);
        // e.g. 8e36 / 10e18 = 8e17
        return z.div(y);
    }


    /***************************************
                  RATIO FUNCS
    ****************************************/

    /**
     * @dev Multiplies and truncates a token ratio, essentially flooring the result
     *      i.e. How much mAsset is this bAsset worth?
     * @param x     Left hand operand to multiplication (i.e Exact quantity)
     * @param ratio bAsset ratio
     * @return      Result after multiplying the two inputs and then dividing by the ratio scale
     */
    function mulRatioTruncate(uint256 x, uint256 ratio)
        internal
        pure
        returns (uint256 c)
    {
        return mulTruncateScale(x, ratio, RATIO_SCALE);
    }

    /**
     * @dev Multiplies and truncates a token ratio, rounding up the result
     *      i.e. How much mAsset is this bAsset worth?
     * @param x     Left hand input to multiplication (i.e Exact quantity)
     * @param ratio bAsset ratio
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              ratio scale, rounded up to the closest base unit.
     */
    function mulRatioTruncateCeil(uint256 x, uint256 ratio)
        internal
        pure
        returns (uint256)
    {
        // e.g. How much mAsset should I burn for this bAsset (x)?
        // 1e18 * 1e8 = 1e26
        uint256 scaled = x.mul(ratio);
        // 1e26 + 9.99e7 = 100..00.999e8
        uint256 ceil = scaled.add(RATIO_SCALE.sub(1));
        // return 100..00.999e8 / 1e8 = 1e18
        return ceil.div(RATIO_SCALE);
    }


    /**
     * @dev Precisely divides two ratioed units, by first scaling the left hand operand
     *      i.e. How much bAsset is this mAsset worth?
     * @param x     Left hand operand in division
     * @param ratio bAsset ratio
     * @return      Result after multiplying the left operand by the scale, and
     *              executing the division on the right hand input.
     */
    function divRatioPrecisely(uint256 x, uint256 ratio)
        internal
        pure
        returns (uint256 c)
    {
        // e.g. 1e14 * 1e8 = 1e22
        uint256 y = x.mul(RATIO_SCALE);
        // return 1e22 / 1e12 = 1e10
        return y.div(ratio);
    }

    /***************************************
                    HELPERS
    ****************************************/

    /**
     * @dev Calculates minimum of two numbers
     * @param x     Left hand input
     * @param y     Right hand input
     * @return      Minimum of the two inputs
     */
    function min(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        return x > y ? y : x;
    }

    /**
     * @dev Calculated maximum of two numbers
     * @param x     Left hand input
     * @param y     Right hand input
     * @return      Maximum of the two inputs
     */
    function max(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        return x > y ? x : y;
    }

    /**
     * @dev Clamps a value to an upper bound
     * @param x           Left hand input
     * @param upperBound  Maximum possible value to return
     * @return            Input x clamped to a maximum value, upperBound
     */
    function clamp(uint256 x, uint256 upperBound)
        internal
        pure
        returns (uint256)
    {
        return x > upperBound ? upperBound : x;
    }
}

/**
 * @title   ForgeValidator
 * @author  Stability Labs Pty. Ltd.
 * @notice  Calculates whether or not minting or redemption is valid, based
 *          on how it affects the underlying basket collateral weightings
 * @dev     VERSION: 1.1
 *          DATE:    2020-06-22
 */
contract ForgeValidator is IForgeValidator {

    using SafeMath for uint256;
    using StableMath for uint256;

    /***************************************
                    MINT
    ****************************************/

    /**
     * @notice Checks whether a given mint is valid and returns the result
     * @dev Is the resulting weighting of the max bAsset beyond it's implicit max weight?
     * Max weight is determined as max weight (in units)
     * @param _totalVault       Current sum of basket collateral
     * @param _bAsset           Struct containing relevant data on the bAsset
     * @param _bAssetQuantity   Number of bAsset units that will be used to mint
     * @return isValid          Bool to signify that the mint does not move our weightings the wrong way
     * @return reason           If the mint is invalid, this is the reason
     */
    function validateMint(
        uint256 _totalVault,
        Basset calldata _bAsset,
        uint256 _bAssetQuantity
    )
        external
        pure
        returns (bool isValid, string memory reason)
    {
        if(
            _bAsset.status == BassetStatus.BrokenBelowPeg ||
            _bAsset.status == BassetStatus.Liquidating ||
            _bAsset.status == BassetStatus.Blacklisted
        ) {
            return (false, "bAsset not allowed in mint");
        }

        // How much mAsset is this _bAssetQuantity worth?
        uint256 mintAmountInMasset = _bAssetQuantity.mulRatioTruncate(_bAsset.ratio);
        // How much of this bAsset do we have in the vault, in terms of mAsset?
        uint256 newBalanceInMasset = _bAsset.vaultBalance.mulRatioTruncate(_bAsset.ratio).add(mintAmountInMasset);
        // What is the max weight of this bAsset in the basket?
        uint256 maxWeightInUnits = (_totalVault.add(mintAmountInMasset)).mulTruncate(_bAsset.maxWeight);

        if(newBalanceInMasset > maxWeightInUnits) {
            return (false, "bAssets used in mint cannot exceed their max weight");
        }

        return (true, "");
    }

    /**
     * @notice Checks whether a given mint using more than one asset is valid and returns the result
     * @dev Is the resulting weighting of the max bAssets beyond their implicit max weight?
     * Max weight is determined as max weight (in units)
     * @param _totalVault       Current sum of basket collateral
     * @param _bAssets          Array of Struct containing relevant data on the bAssets
     * @param _bAssetQuantities Number of bAsset units that will be used to mint (aligned with above)
     * @return isValid          Bool to signify that the mint does not move our weightings the wrong way
     * @return reason           If the mint is invalid, this is the reason
     */
    function validateMintMulti(
        uint256 _totalVault,
        Basset[] calldata _bAssets,
        uint256[] calldata _bAssetQuantities
    )
        external
        pure
        returns (bool isValid, string memory reason)
    {
        uint256 bAssetCount = _bAssets.length;
        if(bAssetCount != _bAssetQuantities.length) return (false, "Input length should be equal");

        uint256[] memory newBalances = new uint256[](bAssetCount);
        uint256 newTotalVault = _totalVault;

        // Theoretically add the mint quantities to the vault
        for(uint256 j = 0; j < bAssetCount; j++){
            Basset memory b = _bAssets[j];
            BassetStatus bAssetStatus = b.status;

            if(
                bAssetStatus == BassetStatus.BrokenBelowPeg ||
                bAssetStatus == BassetStatus.Liquidating ||
                bAssetStatus == BassetStatus.Blacklisted
            ) {
                return (false, "bAsset not allowed in mint");
            }

            // How much mAsset is this bassetquantity worth?
            uint256 mintAmountInMasset = _bAssetQuantities[j].mulRatioTruncate(b.ratio);
            // How much of this bAsset do we have in the vault, in terms of mAsset?
            newBalances[j] = b.vaultBalance.mulRatioTruncate(b.ratio).add(mintAmountInMasset);

            newTotalVault = newTotalVault.add(mintAmountInMasset);
        }

        for(uint256 k = 0; k < bAssetCount; k++){
            // What is the max weight of this bAsset in the basket?
            uint256 maxWeightInUnits = newTotalVault.mulTruncate(_bAssets[k].maxWeight);

            if(newBalances[k] > maxWeightInUnits) {
                return (false, "bAssets used in mint cannot exceed their max weight");
            }
        }

        return (true, "");
    }

    /***************************************
                    SWAP
    ****************************************/

    /**
     * @notice Checks whether a given swap is valid and calculates the output
     * @dev Input bAsset must not exceed max weight, output bAsset must have sufficient liquidity
     * @param _totalVault       Current sum of basket collateral
     * @param _inputBasset      Input bAsset details
     * @param _outputBasset     Output bAsset details
     * @param _quantity         Number of bAsset units on the input side
     * @return isValid          Bool to signify that the mint does not move our weightings the wrong way
     * @return reason           If the swap is invalid, this is the reason
     * @return output           Units of output bAsset, before fee is applied
     * @return applySwapFee     Bool to signify that the swap fee is applied
     */
    function validateSwap(
        uint256 _totalVault,
        Basset calldata _inputBasset,
        Basset calldata _outputBasset,
        uint256 _quantity
    )
        external
        pure
        returns (bool isValid, string memory reason, uint256 output, bool applySwapFee)
    {
        if(_inputBasset.status != BassetStatus.Normal || _outputBasset.status != BassetStatus.Normal) {
            return (false, "bAsset not allowed in swap", 0, false);
        }

        // How much mAsset is this _bAssetQuantity worth?
        uint256 inputAmountInMasset = _quantity.mulRatioTruncate(_inputBasset.ratio);

        // 1. Determine output bAsset valid
        //  - Enough units in the bank
        uint256 outputAmount = inputAmountInMasset.divRatioPrecisely(_outputBasset.ratio);
        if(outputAmount > _outputBasset.vaultBalance) {
            return (false, "Not enough liquidity", 0, false);
        }

        // 1.1. If it is currently overweight, then no fee
        applySwapFee = true;
        uint256 outputBalanceMasset = _outputBasset.vaultBalance.mulRatioTruncate(_outputBasset.ratio);
        uint256 outputMaxWeightUnits = _totalVault.mulTruncate(_outputBasset.maxWeight);
        if(outputBalanceMasset > outputMaxWeightUnits) {
            applySwapFee = false;
        }

        // 2. Calculate input bAsset valid - If incoming basket goes above weight, then fail
        // How much of this bAsset do we have in the vault, in terms of mAsset?
        uint256 newInputBalanceInMasset = _inputBasset.vaultBalance.mulRatioTruncate(_inputBasset.ratio).add(inputAmountInMasset);
        // What is the max weight of this bAsset in the basket?
        uint256 inputMaxWeightInUnits = _totalVault.mulTruncate(_inputBasset.maxWeight);
        if(newInputBalanceInMasset > inputMaxWeightInUnits) {
            return (false, "Input must remain below max weighting", 0, false);
        }

        // 3. Return swap output
        return (true, "", outputAmount, applySwapFee);
    }


    /***************************************
                    REDEEM
    ****************************************/

    /**
     * @notice Checks whether a given redemption is valid and returns the result
     * @dev A redemption is valid if it does not push any untouched bAssets above their
     * max weightings. In addition, if bAssets are currently above their max weight
     * (i.e. during basket composition changes) they must be redeemed
     * @param _basketIsFailed   Bool to suggest that the basket has failed a recollateralisation attempt
     * @param _totalVault       Sum of collateral units in the basket
     * @param _allBassets       Array of all bAsset information
     * @param _indices          Indexes of the bAssets to redeem
     * @param _bAssetQuantities Quantity of bAsset to redeem
     * @return isValid          Bool to signify that the redemption is allowed
     * @return reason           If the redemption is invalid, this is the reason
     * @return feeRequired      Does this redemption require the swap fee to be applied
     */
    function validateRedemption(
        bool _basketIsFailed,
        uint256 _totalVault,
        Basset[] calldata _allBassets,
        uint8[] calldata _indices,
        uint256[] calldata _bAssetQuantities
    )
        external
        pure
        returns (bool, string memory, bool)
    {
        uint256 idxCount = _indices.length;
        if(idxCount != _bAssetQuantities.length) return (false, "Input arrays must have equal length", false);

        // Get current weightings, and cache some outputs from the loop to avoid unecessary recursion
        BasketStateResponse memory data = _getBasketState(_totalVault, _allBassets);
        if(!data.isValid) return (false, data.reason, false);

        // If the basket is in an affected state, enforce proportional redemption
        if(
            _basketIsFailed ||
            data.atLeastOneBroken
        ) {
            return (false, "Must redeem proportionately", false);
        } else if (data.overWeightCount > idxCount) {
            return (false, "Redemption must contain all overweight bAssets", false);
        }

        uint256 newTotalVault = _totalVault;

        // Simulate the redemption on the ratioedBassetVaults and totalSupply
        for(uint256 i = 0; i < idxCount; i++){
            uint8 idx = _indices[i];
            if(idx >= _allBassets.length) return (false, "Basset does not exist", false);

            Basset memory bAsset = _allBassets[idx];
            uint256 quantity = _bAssetQuantities[i];
            if(quantity > bAsset.vaultBalance) return (false, "Cannot redeem more bAssets than are in the vault", false);

            // Calculate ratioed redemption amount in mAsset terms
            uint256 ratioedRedemptionAmount = quantity.mulRatioTruncate(bAsset.ratio);
            // Subtract ratioed redemption amount from both vault and total supply
            data.ratioedBassetVaults[idx] = data.ratioedBassetVaults[idx].sub(ratioedRedemptionAmount);

            newTotalVault = newTotalVault.sub(ratioedRedemptionAmount);
        }

        // Get overweight after
        bool atLeastOneBecameOverweight =
            _getOverweightBassetsAfter(newTotalVault, _allBassets, data.ratioedBassetVaults, data.isOverWeight);

        bool applySwapFee = true;
        // If there are any bAssets overweight, we must redeem them all
        if(data.overWeightCount > 0) {
            for(uint256 j = 0; j < idxCount; j++) {
                if(!data.isOverWeight[_indices[j]]) return (false, "Must redeem overweight bAssets", false);
            }
            applySwapFee = false;
        }
        // Since no bAssets were overweight before, if one becomes overweight, throw
        if(atLeastOneBecameOverweight) return (false, "bAssets must remain below max weight", false);

        return (true, "", applySwapFee);
    }

    /**
     * @notice Calculates the relative quantities of bAssets to redeem, with current basket state
     * @dev Sum the value of the bAssets, and then find the proportions relative to the desired
     * mAsset quantity.
     * @param _mAssetQuantity   Quantity of mAsset to redeem
     * @param _allBassets       Array of all bAsset information
     * @return isValid          Bool to signify that the redemption is allowed
     * @return reason           If the redemption is invalid, this is the reason
     * @return quantities       Array of bAsset quantities to redeem
     */
    function calculateRedemptionMulti(
        uint256 _mAssetQuantity,
        Basset[] calldata _allBassets
    )
        external
        pure
        returns (bool, string memory, uint256[] memory)
    {
        // e.g. mAsset = 1e20 (100)
        // e.g. bAsset: [   A,   B,    C,    D]
        // e.g. vaults: [  80,  60,   60,    0]
        // e.g. ratio:  [1e12, 1e8, 1e20, 1e18]
        // expectedM:    4e19 3e19  3e19     0
        // expectedB:    4e15 3e19   3e7     0
        uint256 len = _allBassets.length;
        uint256[] memory redeemQuantities = new uint256[](len);
        uint256[] memory ratioedBassetVaults = new uint256[](len);
        uint256 totalBassetVault = 0;
        // 1. Add up total vault & ratioedBassets, fail if blacklisted
        for(uint256 i = 0; i < len; i++) {
            if(_allBassets[i].status == BassetStatus.Blacklisted) {
                return (false, "Basket contains blacklisted bAsset", redeemQuantities);
            } else if(_allBassets[i].status == BassetStatus.Liquidating) {
                return (false, "Basket contains liquidating bAsset", redeemQuantities);
            }
            // e.g. (80e14 * 1e12) / 1e8 = 80e18
            // e.g. (60e18 * 1e8) / 1e8 = 60e18
            uint256 ratioedBasset = _allBassets[i].vaultBalance.mulRatioTruncate(_allBassets[i].ratio);
            ratioedBassetVaults[i] = ratioedBasset;
            totalBassetVault = totalBassetVault.add(ratioedBasset);
        }
        if(totalBassetVault == 0) return (false, "Nothing in the basket to redeem", redeemQuantities);
        if(_mAssetQuantity > totalBassetVault) return (false, "Not enough liquidity", redeemQuantities);
        // 2. Calculate proportional weighting & non-ratioed amount
        for(uint256 i = 0; i < len; i++) {
            // proportional weighting
            // e.g. (8e19 * 1e18) / 2e20 = 8e37 / 2e20 = 4e17 (40%)
            uint256 percentageOfVault = ratioedBassetVaults[i].divPrecisely(totalBassetVault);
            // e.g. (1e20 * 4e17) / 1e18 = 4e37 / 1e18 = 4e19 (40)
            uint256 ratioedProportionalBasset = _mAssetQuantity.mulTruncate(percentageOfVault);
            // convert back to bAsset amount
             // e.g. (4e19 * 1e8) / 1e12 = 4e27 / 1e12 = 4e15
            redeemQuantities[i] = ratioedProportionalBasset.divRatioPrecisely(_allBassets[i].ratio);
        }
        // 3. Return
        return (true, "", redeemQuantities);
    }

    /***************************************
                    HELPERS
    ****************************************/

    struct BasketStateResponse {
        bool isValid;
        string reason;
        bool atLeastOneBroken;
        uint256 overWeightCount;
        bool[] isOverWeight;
        uint256[] ratioedBassetVaults;
    }

    /**
     * @dev Gets the currently overweight bAssets, and capitalises on the for loop to
     * produce some other useful data. Loops through, validating the bAsset, and determining
     * if it is overweight, returning the ratioed bAsset.
     * @param _total         Sum of collateral units in the basket
     * @param _bAssets       Array of all bAsset information
     * @return response      Struct containing calculated data
     */
    function _getBasketState(uint256 _total, Basset[] memory _bAssets)
        private
        pure
        returns (BasketStateResponse memory response)
    {
        uint256 len = _bAssets.length;
        response = BasketStateResponse({
            isValid: true,
            reason: "",
            atLeastOneBroken: false,
            overWeightCount: 0,
            isOverWeight: new bool[](len),
            ratioedBassetVaults: new uint256[](len)
        });

        for(uint256 i = 0; i < len; i++) {
            BassetStatus status = _bAssets[i].status;
            if(status == BassetStatus.Blacklisted) {
                response.isValid = false;
                response.reason = "Basket contains blacklisted bAsset";
                return response;
            } else if(
                status == BassetStatus.Liquidating ||
                status == BassetStatus.BrokenBelowPeg ||
                status == BassetStatus.BrokenAbovePeg
            ) {
                response.atLeastOneBroken = true;
            }

            uint256 ratioedBasset = _bAssets[i].vaultBalance.mulRatioTruncate(_bAssets[i].ratio);
            response.ratioedBassetVaults[i] = ratioedBasset;
            uint256 maxWeightInUnits = _total.mulTruncate(_bAssets[i].maxWeight);

            bool bAssetOverWeight = ratioedBasset > maxWeightInUnits;
            if(bAssetOverWeight){
                response.isOverWeight[i] = true;
                response.overWeightCount += 1;
            }
        }
    }

    /**
     * @dev After the redeemed bAssets have been removed from the basket, determine
     * if there are any resulting overweight, or underweight
     * @param _newTotal                 Sum of collateral units in the basket
     * @param _bAssets                  Array of all bAsset information
     * @param _ratioedBassetVaultsAfter Array of all new bAsset vaults
     * @param _previouslyOverWeight     Array of bools - was this bAsset already overweight
     * @return underWeight              Array of bools - is this bAsset now under min weight
     */
    function _getOverweightBassetsAfter(
        uint256 _newTotal,
        Basset[] memory _bAssets,
        uint256[] memory _ratioedBassetVaultsAfter,
        bool[] memory _previouslyOverWeight
    )
        private
        pure
        returns (bool atLeastOneBecameOverweight)
    {
        uint256 len = _ratioedBassetVaultsAfter.length;

        for(uint256 i = 0; i < len; i++) {
            uint256 maxWeightInUnits = _newTotal.mulTruncate(_bAssets[i].maxWeight);

            bool isOverweight = _ratioedBassetVaultsAfter[i] > maxWeightInUnits;
            // If it was not previously overweight, and now it, then it became overweight
            bool becameOverweight = !_previouslyOverWeight[i] && isOverweight;
            atLeastOneBecameOverweight = atLeastOneBecameOverweight || becameOverweight;
        }
    }
}