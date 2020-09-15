pragma solidity ^0.6.0;

import "./ERC20.sol";
import "./ERC20Burnable.sol";
import "./TokenTimelock.sol";

contract PICBTS is ERC20, ERC20Burnable{
    constructor(uint256 initialSupply) ERC20("PICBTS", "PBS") public {
        _mint(msg.sender, initialSupply);
    
    }
}