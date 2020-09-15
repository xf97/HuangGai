/**
 *Submitted for verification at Etherscan.io on 2020-05-08
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface ICurve {
    function get_virtual_price() external returns (uint256 out);

    function underlying_coins(int128 tokenId) external view returns (address token);

    function calc_token_amount(uint256[4] calldata amounts, bool deposit) external view returns (uint256 amount);

    function get_dy(int128 sellTokenId, int128 buyTokenId, uint256 sellTokenAmt) external view returns (uint256 buyTokenAmt);

    // Used when there's an underlying token. Example:- cdai, cusdc, etc. If not then
    function get_dy_underlying(int128 sellTokenId, int128 buyTokenId, uint256 sellTokenAmt) external returns (uint256 buyTokenAmt);

    function exchange(int128 sellTokenId, int128 buyTokenId, uint256 sellTokenAmt, uint256 minBuyToken) external;

    // Used when there's an underlying token. Example:- cdai, cusdc, etc.
    function exchange_underlying(int128 sellTokenId, int128 buyTokenId, uint256 sellTokenAmt, uint256 minBuyToken) external;

    function remove_liquidity(uint256 _amount, uint256[4] calldata min_amounts) external;

    function remove_liquidity_imbalance(uint256[4] calldata amounts, uint256 max_burn_amount) external;
}

interface ICurveZap {

    function calc_withdraw_one_coin(uint256 _token_amount, int128 i) external returns (uint256 amount);

    function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 min_uamount) external;

}

interface TokenInterface {
    function decimals() external view returns (uint);
}


contract DSMath {

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "math-not-safe");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "math-not-safe");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "sub-overflow");
    }

    uint constant WAD = 10 ** 18;

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

}


contract Helpers is DSMath {
    /**
     * @dev get Ethereum address
     */
    function getAddressETH() public pure returns (address) {
        return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    }
}


contract CurveHelpers is Helpers {
    /**
     * @dev Return Curve Swap Address
     */
    function getCurveSwapAddr() internal pure returns (address) {
        return 0xA5407eAE9Ba41422680e2e00537571bcC53efBfD;
    }

    /**
     * @dev Return Curve Token Address
     */
    function getCurveTokenAddr() internal pure returns (address) {
        return 0xC25a3A3b969415c80451098fa907EC722572917F;
    }

    /**
     * @dev Return Curve Zap Address
     */
    function getCurveZapAddr() internal pure returns (address) {
        return 0xFCBa3E75865d2d561BE8D220616520c171F12851;
    }

    function getTokenI(address token) internal pure returns (int128 i) {
        if (token == address(0x6B175474E89094C44Da98b954EedeAC495271d0F)) {
            // DAI Token
            i = 0;
        } else if (token == address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)) {
            // USDC Token
            i = 1;
        } else if (token == address(0xdAC17F958D2ee523a2206206994597C13D831ec7)) {
            // USDT Token
            i = 2;
        } else if (token == address(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51)) {
            // sUSD Token
            i = 3;
        } else {
            revert("token-not-found.");
        }
    }

    function getTokenAddr(ICurve curve, uint256 i) internal view returns (address token) {
        token = curve.underlying_coins(int128(i));
        require(token != address(0), "token-not-found.");
    }

    function getTokenDecimals(address buy, address sell) internal view returns(uint _buyDec, uint _sellDec){
        _buyDec = buy == getAddressETH() ? 18 : TokenInterface(buy).decimals();
        _sellDec = sell == getAddressETH() ? 18 : TokenInterface(sell).decimals();
    }

    function convertTo18(uint _dec, uint256 _amt) internal pure returns (uint256 amt) {
        amt = mul(_amt, 10 ** (18 - _dec));
    }

    function convert18ToDec(uint _dec, uint256 _amt) internal pure returns (uint256 amt) {
        amt = (_amt / 10 ** (18 - _dec));
    }

    function getBuyUnitAmt(
        address buyAddr,
        address sellAddr,
        uint sellAmt,
        uint buyAmt,
        uint slippage
    ) internal view returns (uint unitAmt) {
        uint _sellAmt = convertTo18(TokenInterface(sellAddr).decimals(), sellAmt);
        uint _buyAmt = convertTo18(TokenInterface(buyAddr).decimals(), buyAmt);
        unitAmt = wdiv(_buyAmt, _sellAmt);
        unitAmt = wmul(unitAmt, sub(WAD, slippage));
    }

    function getDepositUnitAmt(
        address token,
        uint depositAmt,
        uint curveAmt,
        uint slippage
    ) internal view returns (uint unitAmt) {
        uint _depositAmt = convertTo18(TokenInterface(token).decimals(), depositAmt);
        uint _curveAmt = convertTo18(TokenInterface(getCurveTokenAddr()).decimals(), curveAmt);
        unitAmt = wdiv(_curveAmt, _depositAmt);
        unitAmt = wmul(unitAmt, sub(WAD, slippage));
    }

    function getWithdrawtUnitAmt(
        address token,
        uint withdrawAmt,
        uint curveAmt,
        uint slippage
    ) internal view returns (uint unitAmt) {
        uint _withdrawAmt = convertTo18(TokenInterface(token).decimals(), withdrawAmt);
        uint _curveAmt = convertTo18(TokenInterface(getCurveTokenAddr()).decimals(), curveAmt);
        unitAmt = wdiv(_curveAmt, _withdrawAmt);
        unitAmt = wmul(unitAmt, add(WAD, slippage));
    }
}


contract Resolver is CurveHelpers {

    function getBuyAmount(address buyAddr, address sellAddr, uint sellAmt, uint slippage) public view returns (uint buyAmt, uint unitAmt) {
        buyAmt = ICurve(getCurveSwapAddr()).get_dy(getTokenI(sellAddr), getTokenI(buyAddr), sellAmt);
        unitAmt = getBuyUnitAmt(buyAddr, sellAddr, sellAmt, buyAmt, slippage);
    }

    function getDepositAmount(address token, uint depositAmt, uint slippage) public view returns (uint curveAmt, uint unitAmt) {
        uint[4] memory amts;
        amts[uint(getTokenI(token))] = depositAmt;
        curveAmt = ICurve(getCurveSwapAddr()).calc_token_amount(amts, true);
        unitAmt = getDepositUnitAmt(token, depositAmt, curveAmt, slippage);
    }


    function getWithdrawAmount(address token, uint withdrawAmt, uint slippage) public view returns (uint curveAmt, uint unitAmt) {
        uint[4] memory amts;
        amts[uint(getTokenI(token))] = withdrawAmt;
        curveAmt = ICurve(getCurveSwapAddr()).calc_token_amount(amts, false);
        unitAmt = getWithdrawtUnitAmt(token, withdrawAmt, curveAmt, slippage);
    }
}


contract InstaCurveResolver is Resolver {
    string public constant name = "Curve-Resolver-v1";
}