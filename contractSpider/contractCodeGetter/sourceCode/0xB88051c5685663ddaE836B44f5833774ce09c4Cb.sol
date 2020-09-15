// SPDX-License-Identifier: BSD-3-Clause

pragma solidity 0.6.8;

import "./Bank.sol";

contract P2Distribute is Bank {

  constructor(address _rec1, uint _perc1, uint _amount1, address _rec2, uint _perc2, uint _amount2, address _rec3, uint _perc3, uint _amount3) public {
    reentry_status = ENTRY_ENABLED;

    require((_perc1 + _perc2 + _perc3) == 100, "Percentage does not equal 100%");

    createAccount(_rec1, address(this).balance, _perc1, _amount1);
    createAccount(_rec2, 0, _perc2, _amount2);
    createAccount(_rec3, 0, _perc3, _amount3);
  }
}