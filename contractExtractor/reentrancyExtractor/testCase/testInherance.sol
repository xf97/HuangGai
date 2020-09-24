pragma solidity 0.6.0;

contract baseContract1{
	mapping(address=>uint256) public balance;

	
	function getMoney() external payable virtual{
	}
}

contract baseContract2{
	address owner;
	constructor() public{
		owner = msg.sender;
	}

	modifier onlyOwner(){
		require(msg.sender == owner);
		_;
	}
}

contract baseContract3 is baseContract1{
	function withdraw1() external{
		require(balance[msg.sender] > 0);
		msg.sender.transfer(balance[msg.sender]);
		balance[msg.sender] = 0;
	}

	function withdraw2() external{
		require(balance[msg.sender] > 0);
		msg.sender.send(balance[msg.sender]);
		balance[msg.sender] = 0;
	}

	function withdraw3() external{
		require(balance[msg.sender] > 0);
		msg.sender.call.value(balance[msg.sender])("");
		balance[msg.sender] = 0;
	}

	function noWithdraw() external{
		require(balance[msg.sender] > 0);
		msg.sender.call("");
		balance[msg.sender] = 0;
	}
}

contract myContract is baseContract2, baseContract3{
	mapping(address=>uint256) public noBalance;
	constructor() public payable{
		msg.sender.transfer(address(this).balance);
	}
	function withdraw1(uint256 _amount) public{
		require(balance[msg.sender] > _amount);
		//reentrancy
		msg.sender.call.value(_amount)("");
		balance[msg.sender] -= _amount;
	}

	function getMoney() override payable external{
		balance[msg.sender] += msg.value;
		balance[msg.sender] += 10;
		withdraw1(10);
	}

	fallback() external{
		balance[msg.sender] -= 10;
		revert();
	}
}