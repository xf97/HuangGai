/**
 *Submitted for verification at Etherscan.io on 2020-08-14
*/

// File: contracts/AmpleforthInterface.sol

pragma solidity 0.4.24;

interface AmpleforthInterface {
  function pushReport(uint256 payload) external;
  function purgeReports() external;
}

// File: contracts/MockAmpleforth.sol

pragma solidity 0.4.24;


contract MockAmpleforth is AmpleforthInterface {
  event PushReport(uint256 payload);
  event Rebase();
  event Purge();

  function pushReport(uint256 payload) external {
    emit PushReport(payload);
  }

  function rebase() external {
    emit Rebase();
  }

  function purgeReports() external {
    emit Purge();
  }
}