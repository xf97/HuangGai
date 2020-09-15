//SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

import "./ERC20.sol";

contract BTF is ERC20{
 
  constructor() ERC20("Bitcoin Exchange Traded Fund","BTF") public {
      uint256 initialSupply = 2000000;
      uint8 decimals = 18;
      uint256 totalSupply = initialSupply * 10 ** uint256(decimals);
      _setupDecimals(decimals);
      _mint(msg.sender, totalSupply);
  }
}