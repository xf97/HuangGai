/**
 *Submitted for verification at Etherscan.io on 2020-05-12
*/

pragma solidity ^0.5.0;


contract ViewCallGasLimit {
    function check() public view returns(uint256) {
        return gasleft();
    }
}