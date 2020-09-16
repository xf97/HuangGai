pragma solidity 0.6.0;

contract baseContract1{
	mapping(address=>uint256) public balance;

	function getMoney() external payable{
		balance[msg.sender] += msg.value;
	}
}

contract baseContract2{
	address owner;
	constructor() public{
		owner = msg.sender;
	}
}

contract baseContract3 is baseContract1{
	function withdraw() external{
		require(balance[msg.sender] > 0);
		msg.sender.transfer(balance[msg.sender]);
	}
}

contract myContract is baseContract2, baseContract3{
	
}