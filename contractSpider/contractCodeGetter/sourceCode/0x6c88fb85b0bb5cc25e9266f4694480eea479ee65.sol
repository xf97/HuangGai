/**
 *Submitted for verification at Etherscan.io on 2020-09-08
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.11;

contract Test {
    uint public x;

    function set(uint _x) external {
        x = _x;
    }
}