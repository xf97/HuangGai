pragma solidity ^0.6.0;

import "./ERC20.sol";

contract CSCToken is ERC20{

	constructor() ERC20("Count Surplus Coin","CSC") public {
		uint8 decimals = 18;
		
		uint256 totalSupply = 35000000 * 10 ** uint256(decimals);
		
		_setupDecimals(decimals);
		_mint(0xa01f304A43338639d269a64d4B9627322fB30dB8, totalSupply);
	}
	
}