pragma solidity 0.6.0;

contract baseContract1{
	mapping(address=>uint256) balance;
}

contract baseContract2 is baseContract1{
	mapping(address=>uint256) noBalance;
	function getMoney() external payable{
		require(balance[msg.sender] + msg.value >= balance[msg.sender]);
		addMoney(msg.value);
	}

	function addMoney(uint256 _money) internal{
		balance[msg.sender] += msg.value;
		noBalance[msg.sender] = 0;
	}
}

contract myContract is baseContract2{
	constructor() public{

	}

	function sendMoney(uint256 _amount) external{
		require(balance[msg.sender] >= _amount);
		msg.sender.transfer(_amount);
		balance[msg.sender] -= _amount;
		noBalance[msg.sender] += 10;
	}
}