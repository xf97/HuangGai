/**
 *Submitted for verification at Etherscan.io on 2020-05-05
*/

pragma solidity ^0.5.15;

contract TubLike {
    function bite(bytes32) public;
}

contract BiteCdps {
    TubLike public tub;

    constructor(address tub_) public {
        tub = TubLike(tub_);
    }

    function bite(bytes32[] memory ids) public {
        for(uint256 i = 0; i < ids.length; i++) {
            tub.bite(ids[i]);
        }
    }
}