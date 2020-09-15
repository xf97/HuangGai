/**
 *Submitted for verification at Etherscan.io on 2020-05-11
*/

pragma solidity ^0.5.0;


contract Ether {
    function balanceOf(address wallet) external view returns (uint256) {
        return wallet.balance;
    }
}