/**
 *Submitted for verification at Etherscan.io on 2020-08-12
*/

pragma solidity 0.6.6;

interface IRealityCards {

    function collectRentAllTokens() external;

}

contract rentCollector {
    IRealityCards rc1 = IRealityCards(0x148Bb64E8910422E74f79feF1A2E830BDe0BB938); //election
    IRealityCards rc2 = IRealityCards(0xf30a16DdFDfbA014789E577bC59c6e2E89cEE0f5); //boxing
    IRealityCards rc3 = IRealityCards(0x231C66E7474FC300b000b35E1CF321D2405bb9f0); //curve
    
    function collectRentAllTokensAllMarkets() public 
    {
        rc1.collectRentAllTokens();
        rc2.collectRentAllTokens();
        rc3.collectRentAllTokens();
    }
}