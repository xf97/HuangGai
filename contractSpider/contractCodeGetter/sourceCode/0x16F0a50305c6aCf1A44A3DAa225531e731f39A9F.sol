/**
 *Submitted for verification at Etherscan.io on 2020-05-11
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface OneSplitInterface {
    function getExpectedReturn(
        TokenInterface fromToken,
        TokenInterface toToken,
        uint256 amount,
        uint256 parts,
        uint256 disableFlags
    )
    external
    view
    returns(
        uint256 returnAmount,
        uint256[] memory distribution
    );
}

interface TokenInterface {
    function decimals() external view returns (uint);
    function totalSupply() external view returns (uint256);
    function balanceOf(address) external view returns (uint);
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


contract OneSplitHelpers is Helpers {
    /**
     * @dev Return 1Split Address
     */
    function getOneSplitAddress() internal pure returns (address) {
        return 0xC586BeF4a0992C495Cf22e1aeEE4E446CECDee0E;
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
        TokenInterface buyAddr,
        uint expectedAmt,
        TokenInterface sellAddr,
        uint sellAmt,
        uint slippage
    ) internal view returns (uint unitAmt) {
        uint _sellAmt = convertTo18(sellAddr.decimals(), sellAmt);
        uint _buyAmt = convertTo18(buyAddr.decimals(), expectedAmt);
        unitAmt = wdiv(_buyAmt, _sellAmt);
        unitAmt = wmul(unitAmt, sub(WAD, slippage));
    }
}


contract Resolver is OneSplitHelpers {

    function getBuyAmount(
        address buyAddr,
        address sellAddr,
        uint sellAmt,
        uint slippage,
        uint distribution,
        uint disableDexes
    ) public view returns (uint buyAmt, uint unitAmt, uint[] memory distributions) {
        TokenInterface _buyAddr = TokenInterface(buyAddr);
        TokenInterface _sellAddr = TokenInterface(sellAddr);
        (buyAmt, distributions) = OneSplitInterface(getOneSplitAddress())
                .getExpectedReturn(
                    _sellAddr,
                    _buyAddr,
                    sellAmt,
                    distribution,
                    disableDexes
                    );
        unitAmt = getBuyUnitAmt(_buyAddr, buyAmt, _sellAddr, sellAmt, slippage);
    }
}


contract InstaOneSplitResolver is Resolver {
    string public constant name = "1Split-Resolver-v1";
}