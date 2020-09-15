/**
 *Submitted for verification at Etherscan.io on 2020-05-18
*/

pragma solidity ^0.6.8;

//SPDX-License-Identifier: MIT

contract Owner {
    
    address payable owner;

    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }
    
    constructor() public {
        owner = msg.sender;
        emit OwnerSet(address(0), owner);
    }

    function changeOwner(address payable newOwner) public onlyOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }
}


contract FoxInvSplit is Owner {
    
    uint256 per1;
    uint256 per2;
    address payable inv2;

    
    function get() public view returns (address, address, uint256, uint256) {
        return (owner, inv2, per1, per2);
    }
    
    function set(address payable investitor2, uint256 percentual2) public onlyOwner {
        per1 = 10 - percentual2;
        per2 = percentual2;
        inv2 = investitor2;
    }
        
    function withdrawETH() external onlyOwner {
        owner.transfer(address(this).balance);
    }
    
    receive() external payable {
        owner.transfer(msg.value * per1 / 10);
        inv2.transfer(msg.value * per2 / 10);
    }
    
}