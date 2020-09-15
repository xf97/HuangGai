/**
 *Submitted for verification at Etherscan.io on 2020-08-20
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;


contract EtherBoard{
    struct Slot{
        address payable ownerAddress;
        string imageCID;
        string caption;
        string link;
        uint currentPrice;
        uint numOfSales;
    }
    mapping (uint => Slot) public slots;
    address[] managers;
    uint startingPrice;
    uint soldBlocks;
    uint numOfSlots;
    uint constant COMMISION_PERCENT = 20;
    uint constant INCREASE_PERCENT = 20;

    constructor(uint givenPrice, address[] memory managerAdresses) payable {
        for(uint i = 0; i < managerAdresses.length; i++){
            managers.push(managerAdresses[i]);
        }
        startingPrice = givenPrice;
        numOfSlots = 10;
    }

    function isManager(address userAddress) public view returns(bool) {
        for(uint i = 0; i < managers.length; i++){
            if(managers[i] == userAddress) return true;
        }
        return false;
    }

    function processPayment(string memory caption, string memory link, string memory imageCID, uint index) public payable {
        Slot storage slot = slots[index];
        bool managerCheck = isManager(msg.sender);
        // In order to avoid buying blocks that is already owned
        require(msg.sender != address(0), "Invalid address for operation");
        require(index >= 0 && index <= numOfSlots, "Invalid slot index");
        require(managerCheck == false, "Invalid operation for manager");
        bool firstSale = true;
        if(slot.currentPrice > 0){
            require(msg.value >= slot.currentPrice, "Insufficient fund");
            firstSale = false;
        } else {
            require(msg.value >= startingPrice, "Insufficient fund");
        }
        uint currentPrice = msg.value;
        uint newPrice = currentPrice + currentPrice * INCREASE_PERCENT / 100;
        uint totalProfit = newPrice - currentPrice;
        uint systemProfit = totalProfit * COMMISION_PERCENT / 100;
        uint ownerBalance = currentPrice - systemProfit;
        if(firstSale){
            uint ownerShare = ownerBalance / managers.length;
            for(uint i = 0; i < managers.length; i++){
                payable(managers[i]).transfer(ownerShare);
            }
            soldBlocks += 1;
            if(soldBlocks == numOfSlots){
                numOfSlots += 1;
            }
        } else {
            slot.ownerAddress.transfer(ownerBalance);
        }
        uint equalManagerShare = systemProfit / managers.length;
        for(uint i = 0; i < managers.length; i++){
            payable(managers[i]).transfer(equalManagerShare);
        }
        slot.ownerAddress = msg.sender;
        slot.currentPrice = newPrice;
        slot.imageCID = imageCID;
        slot.caption = caption;
        slot.link = link;
        slot.numOfSales += 1;
    }
    
    function getContractConstants() public view returns (uint, uint, uint, uint){
        return (startingPrice, COMMISION_PERCENT, INCREASE_PERCENT, numOfSlots);
    }

    modifier managerAuth() {
        bool managerCheck = isManager(msg.sender);
        require(managerCheck == true, "Only managers can use this operation");
        _;
    }

    function changeStartingPrice(uint newPrice) public payable managerAuth {
        startingPrice = newPrice;
    }
}