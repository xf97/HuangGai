//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./ERC20.sol";

contract Alice is ERC20{
 
  constructor() ERC20("ALICE","ACE") public {
      uint256 initialSupply = 500000000;
      uint8 decimals = 18;
      uint256 totalSupply = initialSupply * 10 ** uint256(decimals);
      _setupDecimals(decimals);
      _mint(msg.sender, totalSupply);
  }
}