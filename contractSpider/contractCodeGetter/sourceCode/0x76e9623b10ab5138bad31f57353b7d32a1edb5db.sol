pragma solidity ^0.5.7;

import "./ERC20Standard.sol";

contract CRXToken is ERC20Standard {
    constructor() public {
        totalSupply = 720000000000000000000000000;
        name = "CreekEx Token";
        decimals = 18;
        symbol = "CRX";
        version = "1.0";
        balances[msg.sender] = totalSupply;
    }
}
