/**
 *Submitted for verification at Etherscan.io on 2020-05-02
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface CTokenInterface {
    function exchangeRateStored() external view returns (uint);
    function borrowRatePerBlock() external view returns (uint);
    function supplyRatePerBlock() external view returns (uint);
    function borrowBalanceStored(address) external view returns (uint);

    function balanceOf(address) external view returns (uint);
}

interface OrcaleComp {
    function getUnderlyingPrice(address) external view returns (uint);
}


contract Helpers {

    /**
     * @dev get Ethereum address
     */
    function getAddressETH() public pure returns (address) {
        return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    }

    /**
     * @dev get Compound Comptroller Address
     */
    function getComptrollerAddress() public pure returns (address) {
        return 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;
    }

    /**
     * @dev get Compound Orcale Address
     */
    function getOracleAddress() public pure returns (address) {
        return 0xDDc46a3B076aec7ab3Fc37420A8eDd2959764Ec4;
    }

    struct CompData {
        uint tokenPrice;
        uint exchangeRateStored;
        uint balanceOfUser;
        uint borrowBalanceStoredUser;
        uint supplyRatePerBlock;
        uint borrowRatePerBlock;
    }
}


contract Resolver is Helpers {

    function getPosition(address owner, address[] memory cAddress) public view returns (CompData[] memory) {
        CompData[] memory tokensData = new CompData[](cAddress.length);
        for (uint i = 0; i < cAddress.length; i++) {
            CTokenInterface cToken = CTokenInterface(cAddress[i]);
            tokensData[i] = CompData(
                OrcaleComp(getOracleAddress()).getUnderlyingPrice(cAddress[i]),
                cToken.exchangeRateStored(),
                cToken.balanceOf(owner),
                cToken.borrowBalanceStored(owner),
                cToken.supplyRatePerBlock(),
                cToken.borrowRatePerBlock()
            );
        }
        return tokensData;
    }

}


contract InstaCompoundResolver is Resolver {
    string public constant name = "Compound-Resolver-v1.1";
}