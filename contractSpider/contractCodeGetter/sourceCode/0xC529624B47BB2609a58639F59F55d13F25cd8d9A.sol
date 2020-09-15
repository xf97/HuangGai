/**
 *Submitted for verification at Etherscan.io on 2020-06-19
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.5.17;

contract Migrations {
  address public owner;
  uint public last_completed_migration;

  constructor() public {
    owner = msg.sender;
  }

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
}