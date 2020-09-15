/**
 *Submitted for verification at Etherscan.io on 2020-04-30
*/

pragma solidity ^0.6.0;

interface IToken {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract customDropToken { // transfer msg.sender token to recipients per approved index drop amounts w/ msg.
    event TokenDropped(string indexed message);
     
    function customDropTKN(uint256[] memory amounts, address tokenAddress, address[] memory recipients, string memory message) public {
        IToken token = IToken(tokenAddress);
        for (uint256 i = 0; i < recipients.length; i++) {
	         token.transferFrom(msg.sender, recipients[i], amounts[i]);
        }
	    emit TokenDropped(message);
    }
}