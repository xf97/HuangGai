// SPDX-License-Identifier: MIT

pragma solidity ^0.6.9;

import "./ERC20.sol";

contract LCG is ERC20("LCG Energy", "LCG") {

  /**
  * @param wallet Address of the wallet, where tokens will be minted to
  */
  constructor(address wallet) public {
    require(wallet != address(0));
    _mint(wallet, uint256(2.5e9).mul(1 ether));
  }
}
