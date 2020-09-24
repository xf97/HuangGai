pragma solidity 0.6.0;

contract myContract{

	function withdraw1(uint256 _amount) external{
		msg.sender.transfer(_amount);
	}

	fallback() payable external{
		revert();
	}
}
