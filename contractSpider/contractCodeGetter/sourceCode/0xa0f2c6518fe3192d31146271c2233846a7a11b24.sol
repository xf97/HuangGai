/**
 *Submitted for verification at Etherscan.io on 2020-08-13
*/

pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;


contract Tester {
    function iSucceed() external pure returns (uint256) {
        return 1337;
    }
    
    function iFail() external pure returns (uint256) {
        revert("pwn!");
    }
}