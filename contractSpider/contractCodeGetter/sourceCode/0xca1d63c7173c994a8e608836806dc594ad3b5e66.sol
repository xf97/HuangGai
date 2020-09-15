/**
 *Submitted for verification at Etherscan.io on 2020-04-30
*/

pragma solidity ^0.6.0;

interface IToken {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract DropToken { // transfer msg.sender token to recipients per approved drop amount w/ msg.
    event TokenDropped(string indexed message);
    
    function DropTKN(uint256 amount, address tokenAddress, address[] memory recipients, string memory message) public {
        IToken token = IToken(tokenAddress);
        uint256 amounts = amount / recipients.length;
        for (uint256 i = 0; i < recipients.length; i++) {
	         token.transferFrom(msg.sender, recipients[i], amounts);
        }
	    emit TokenDropped(message);
    }
}