/**
 *Submitted for verification at Etherscan.io on 2020-06-19
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

interface TokenInterface {
    function balanceOf(address) external view returns (uint);
}


interface OrcaleComp {
    function getUnderlyingPrice(address) external view returns (uint);
}

interface ComptrollerLensInterface {
    function markets(address) external view returns (bool, uint);
    function getAccountLiquidity(address) external view returns (uint, uint, uint);
    function claimComp(address) external;
    function compAccrued(address) external view returns (uint);
}

interface CompReadInterface {
    struct CompBalanceMetadataExt {
        uint balance;
        uint votes;
        address delegate;
        uint allocated;
    }

    function getCompBalanceMetadataExt(
        TokenInterface comp,
        ComptrollerLensInterface comptroller,
        address account
    ) external returns (CompBalanceMetadataExt memory);
}



contract Helpers {
    /**
     * @dev get Compound Comptroller
     */
    function getComptroller() public pure returns (ComptrollerLensInterface) {
        return ComptrollerLensInterface(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);
    }

    /**
     * @dev get Compound Orcale Address
     */
    function getOracleAddress() public pure returns (address) {
        return 0xDDc46a3B076aec7ab3Fc37420A8eDd2959764Ec4;
    }

    /**
     * @dev get Comp Read Address
     */
    function getCompReadAddress() public pure returns (address) {
        return 0xd513d22422a3062Bd342Ae374b4b9c20E0a9a074;
    }

    /**
     * @dev get Comp Token Address
     */
    function getCompToken() public pure returns (TokenInterface) {
        return TokenInterface(0xc00e94Cb662C3520282E6f5717214004A7f26888);
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

    function getCompoundData(address owner, address[] memory cAddress) public view returns (CompData[] memory) {
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

    function getPosition(
        address owner,
        address[] memory cAddress
    )
        public
        returns (CompData[] memory, CompReadInterface.CompBalanceMetadataExt memory)
    {
        return (
            getCompoundData(owner, cAddress),
            CompReadInterface(getCompReadAddress()).getCompBalanceMetadataExt(
                getCompToken(),
                getComptroller(),
                owner
            )
        );
    }

}


contract InstaCompoundResolver is Resolver {
    string public constant name = "Compound-Resolver-v1.2";
}