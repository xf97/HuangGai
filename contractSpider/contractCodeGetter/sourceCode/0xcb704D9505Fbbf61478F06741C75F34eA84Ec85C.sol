/**
 *Submitted for verification at Etherscan.io on 2020-05-16
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface ERC20Interface {
    function allowance(address, address) external view returns (uint);
    function balanceOf(address) external view returns (uint);
    function approve(address, uint) external;
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
    function deposit() external payable;
    function withdraw(uint) external;
}


interface SoloMarginContract {

    struct Info {
        address owner;
        uint256 number;
    }


    struct Wei {
        bool sign;
        uint256 value;
    }

    struct Price {
        uint256 value;
    }

    struct TotalPar {
        uint128 borrow;
        uint128 supply;
    }

    struct Index {
        uint96 borrow;
        uint96 supply;
        uint32 lastUpdate;
    }

    function getMarketPrice(uint256 marketId) external view returns (Price memory);
    function getAccountWei(Info calldata account, uint256 marketId) external view returns (Wei memory);
    function getMarketTotalPar(uint256 marketId) external view returns (TotalPar memory);
    function getMarketCurrentIndex(uint256 marketId) external view returns (Index memory);
}

contract DSMath {

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "math-not-safe");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        z = x - y <= x ? x - y : 0;
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "math-not-safe");
    }

    uint constant WAD = 10 ** 18;
    uint constant RAY = 10 ** 27;

    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, RAY), y / 2) / y;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

}

contract Helpers is DSMath{

    /**
     * @dev get Dydx Solo Address
    */
    function getSoloAddress() public pure returns (address addr) {
        addr = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;
    }

    /**
    * @dev Get Dydx Account Arg
    */
    function getAccountArgs(address owner) internal pure returns (SoloMarginContract.Info memory) {
        SoloMarginContract.Info[] memory accounts = new SoloMarginContract.Info[](1);
        accounts[0] = (SoloMarginContract.Info(owner, 0));
        return accounts[0];
    }

    struct DydxData {
        uint tokenPrice;
        uint supplyBalance;
        uint borrowBalance;
        uint tokenUtil;
    }
}


contract Resolver is Helpers {
    function getPosition(address user, uint[] memory marketId) public view returns(DydxData[] memory) {
        SoloMarginContract solo = SoloMarginContract(getSoloAddress());
        DydxData[] memory tokensData = new DydxData[](marketId.length);
        for (uint i = 0; i < marketId.length; i++) {
            uint id = marketId[i];
            SoloMarginContract.Wei memory tokenBal = solo.getAccountWei(getAccountArgs(user), id);
            SoloMarginContract.TotalPar memory totalPar = solo.getMarketTotalPar(id);
            SoloMarginContract.Index memory rateIndex = solo.getMarketCurrentIndex(id);

            tokensData[i] = DydxData(
                solo.getMarketPrice(id).value,
                tokenBal.sign ? tokenBal.value : 0,
                !tokenBal.sign ? tokenBal.value : 0,
                wdiv(wmul(totalPar.borrow, rateIndex.borrow), wmul(totalPar.supply, rateIndex.supply))
            );
        }
        return tokensData;
    }
}

contract InstaDydxResolver is Resolver {
    string public constant name = "Dydx-Resolver-v1";
}