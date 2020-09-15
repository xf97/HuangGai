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
    
    address payable inv2;

    function get() public view returns (address, address) {
        return (owner, inv2);
    }
    
    function set(address payable investitor2) public onlyOwner {
        inv2 = investitor2;
    }
    
    receive() external payable {
        inv2.transfer(msg.value / 10);
        owner.transfer(address(this).balance);
    }
    
}