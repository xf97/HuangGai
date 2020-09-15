// "SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import './Distribute.sol';
import './Owned.sol';

contract Monitoring is Owned{
    
    struct Register{
        address _addressToMonitor;
        uint256 _hours;
        uint256 _startTime;
    }
    
    mapping(address => Register[]) public userMonitoringAddresses;
    mapping(address => uint256) public totalAddressMonitoring;
    
    Distribute public dst;
    
    uint256 _perHour = 500; // multiplied by 10 already
    
    constructor(address _distributAddress, address payable _owner) public{
        dst = Distribute(_distributAddress);
        owner = _owner;
    }

    function startMonitoring(address _addressToMonitor, uint256 _hours) public {
        require(_addressToMonitor != address(0));
        require(_hours != 0);
        
        // Register
        userMonitoringAddresses[msg.sender].push(Register({
             _addressToMonitor: _addressToMonitor,
             _hours: _hours,
             _startTime: now
        }));
        
        // make a purchase
        dst.purchaseService(_calculatePrice(_hours), msg.sender);
        
        // increase total addresses monitoring by an address count
        totalAddressMonitoring[msg.sender] = totalAddressMonitoring[msg.sender] + 1;
    }
    
    function _calculatePrice(uint256 _hours) public view returns(uint256 _price){
        return ((((_hours) * (_perHour))/10) * 10 ** (dst.decimals()));
    }
    
    function changeHourlyRate(uint256 _rate) public onlyOwner{
        _perHour = _rate;
    }
}