pragma solidity ^0.5.7;

import "./ERC20Standard.sol";

contract NewToken is ERC20Standard {
	constructor() public {
		totalSupply = 148869;
		name = "Pedik coin";
		decimals = 0;
		symbol = "PDK";
		version = "1.0";
		balances[msg.sender] = totalSupply;
	}
}
