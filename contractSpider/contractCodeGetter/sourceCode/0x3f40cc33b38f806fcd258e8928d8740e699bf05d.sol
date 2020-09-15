pragma solidity ^0.5.0;

import "./ERC20.sol";
import "./ERC20Detailed.sol";
import "./ERC20Burnable.sol";

contract YourStoryEverywhere is ERC20, ERC20Detailed, ERC20Burnable { 
    constructor(uint256 initialSupply) public ERC20Detailed("PRANOS", "PRANOS", 18) {
        _mint(msg.sender, initialSupply * (10 ** uint256(decimals())));
    }
}