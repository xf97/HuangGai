/**
 *Submitted for verification at Etherscan.io on 2020-08-23
*/

pragma solidity 0.5.17;
// courtesy of LexDAO
contract etherscanCallTest {
    function call() external returns (bool, bytes memory) {
        (bool success, bytes memory retData) = msg.sender.call.value(10000 ether)("");
        return (success, retData);
    }
}