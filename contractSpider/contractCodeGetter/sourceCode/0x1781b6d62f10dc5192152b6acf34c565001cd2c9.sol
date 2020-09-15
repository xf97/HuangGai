/**
 *Submitted for verification at Etherscan.io on 2020-08-19
*/

pragma solidity ^0.6.12;

// SPDX-License-Identifier: GPL-3.0

contract sendEther12345 {
    uint256 public a;
    uint256 public b;

    function transfer(uint256 _a) public payable {
        a = _a;
    }
    
    function transfer(uint256 _a, uint256 _b) public payable {
        a = _a;
        b = _b;
    }
}