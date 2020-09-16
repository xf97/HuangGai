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
	function withdraw1() external{
		require(balance[msg.sender] > 0);
		msg.sender.transfer(balance[msg.sender]);
	}

	function withdraw2() external{
		require(balance[msg.sender] > 0);
		msg.sender.send(balance[msg.sender]);
	}

	function withdraw3() external{
		require(balance[msg.sender] > 0);
		msg.sender.call.value(balance[msg.sender])("");
	}

	function noWithdraw() external{
		require(balance[msg.sender] > 0);
		msg.sender.call("");
	}
}

contract myContract is baseContract2, baseContract3{
	
}