/**
 *Submitted for verification at Etherscan.io on 2020-05-01
*/

pragma solidity^0.6.2;

interface ERC20Interface {
    function balanceOf(address whom) external view returns (uint256);
}

contract GratitudeDispenser {
    address private gratitudeTokenAddress;
    
    // sets up the gratitude token addressthat can be checked on later
    constructor(address _gratitudeTokenAddress) public {
        gratitudeTokenAddress = _gratitudeTokenAddress;
    }

    function claim() external {
        uint256 callerGratitudeTokenBalance = ERC20Interface(gratitudeTokenAddress).balanceOf(msg.sender);
        if (callerGratitudeTokenBalance >= 1e18) {
            msg.sender.transfer(address(this).balance);
        }
    }
    
    fallback () external payable {
    }
}