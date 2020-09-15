pragma solidity >=0.4.21 <0.6.0;

import "./ERC20.sol";
import "./ERC20Detailed.sol";

// contract address: 0x14fe6eC757Bdd28745e75767581a6EFedEFe184C
contract LEOBTC50Token is ERC20, ERC20Detailed {
  uint256 public constant INITIAL_SUPPLY = 100000000000000000000000;

  constructor () public ERC20Detailed("LEOBTC50 Coin", "LEOBTC50", 18) {
    _mint(msg.sender, INITIAL_SUPPLY);
  }
}