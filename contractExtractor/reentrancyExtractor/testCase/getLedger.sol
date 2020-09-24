pragma solidity 0.6.0;

contract baseContract1{
	mapping(address=>uint256) balance;
	mapping(address=>uint256) noBalance;
}

contract baseContract2 is baseContract1{
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

	function sendMoney(uint256 _account) external{
		require(balance[msg.sender] >= _account);
		msg.sender.transfer(_account);
	}
}