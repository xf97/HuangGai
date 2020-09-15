/**
 *Submitted for verification at Etherscan.io on 2020-05-04
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface KyberInterface {
    function getExpectedRate(
        address src,
        address dest,
        uint srcQty
    ) external view returns (uint, uint);
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


contract KyberHelpers is Helpers {
    /**
     * @dev Kyber Proxy Address
     */
    function getAddressKyber() public pure returns (address) {
        return 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
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
        uint expectedRate,
        uint slippage
    ) internal view returns (uint unitAmt, uint _buyAmt) {
        (uint _buyDec, uint _sellDec) = getTokenDecimals(buyAddr, sellAddr);
        unitAmt = wmul(expectedRate, sub(WAD, slippage));
        uint _sellAmt = convertTo18(_sellDec, sellAmt);
        _buyAmt = wmul(_sellAmt, expectedRate);
        _buyAmt = convert18ToDec(_buyDec, _buyAmt);
    }

}


contract Resolver is KyberHelpers {

    function getBuyAmount(address buyAddr, address sellAddr, uint sellAmt, uint slippage) public view returns (uint buyAmt, uint unitAmt) {
        (uint expectedRate, ) = KyberInterface(getAddressKyber()).getExpectedRate(sellAddr, buyAddr, sellAmt);
        (unitAmt, buyAmt) = getBuyUnitAmt(buyAddr, sellAddr, sellAmt, expectedRate, slippage);
    }

}


contract InstaKyberResolver is Resolver {
    string public constant name = "Kyber-Resolver-v1";
}