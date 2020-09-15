pragma solidity >=0.4.21;

import "./ERC20.sol";
import "./ERC20Detailed.sol";

contract BBQToken is ERC20, ERC20Detailed {
  uint256 public constant INITIAL_SUPPLY = 21000000000000000000000000;

  constructor () public ERC20Detailed("BBQ Coin", "BBQ", 18) {
    _mint(msg.sender, INITIAL_SUPPLY);
  }
}