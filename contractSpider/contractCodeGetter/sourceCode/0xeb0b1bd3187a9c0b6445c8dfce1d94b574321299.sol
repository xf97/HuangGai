/**
 *Submitted for verification at Etherscan.io on 2020-08-16
*/

pragma solidity 0.6.6;

interface IRealityCards {

    function collectRentAllTokens() external;
    function numberOfTokens() external view returns(uint); 
    function currentOwnerRemainingDeposit(uint) external view returns(uint);

}

contract rentCollector {
    IRealityCards rc1 = IRealityCards(0x148Bb64E8910422E74f79feF1A2E830BDe0BB938); //election
    IRealityCards rc2 = IRealityCards(0xf30a16DdFDfbA014789E577bC59c6e2E89cEE0f5); //boxing
    IRealityCards rc3 = IRealityCards(0x231C66E7474FC300b000b35E1CF321D2405bb9f0); //curve
    
    function hasExpired() external view returns (bool) {
        bool _expired = false;
        
        //rc1:
        for (uint i = 0; i < rc1.numberOfTokens(); i++) {
            if (rc1.currentOwnerRemainingDeposit(i) == 0) {
                _expired = true;
            }
        }
        
        //rc2:
        for (uint i = 0; i < rc2.numberOfTokens(); i++) {
            if (rc2.currentOwnerRemainingDeposit(i) == 0) {
                _expired = true;
            }
        }
        
        //rc3:
        for (uint i = 0; i < rc3.numberOfTokens(); i++) {
            if (rc3.currentOwnerRemainingDeposit(i) == 0) {
                _expired = true;
            }
        }
        
    return _expired;
        
    }
    
    function collectRentAllTokensAllMarkets() public 
    {
        bool _expired;
        
        //rc1:
        _expired = false;
        for (uint i = 0; i < rc1.numberOfTokens(); i++) {
            if (rc1.currentOwnerRemainingDeposit(i) == 0) {
                _expired = true;
            }
        if (_expired) {
            rc1.collectRentAllTokens(); 
            }
        }
        
        //rc2:
        _expired = false;
        for (uint i = 0; i < rc2.numberOfTokens(); i++) {
            if (rc2.currentOwnerRemainingDeposit(i) == 0) {
                _expired = true;
            }
        if (_expired) {
            rc2.collectRentAllTokens(); 
            }
        }
        
        //rc3:
        _expired = false;
        for (uint i = 0; i < rc3.numberOfTokens(); i++) {
            if (rc3.currentOwnerRemainingDeposit(i) == 0) {
                _expired = true;
            }
        if (_expired) {
            rc3.collectRentAllTokens(); 
            }
        }
        
    }
}