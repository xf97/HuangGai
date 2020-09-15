pragma solidity ^0.4.25;

import "./GTRX.sol";

contract TokenTimelock {

  GTRX public token;
  address public beneficiary;
  uint256 public releaseTime;

  constructor(
    GTRX _token,
    address _beneficiary,
    uint256 _releaseTime
  )
    public
  {
    require(_releaseTime > block.timestamp);
    token = _token;
    beneficiary = _beneficiary;
    releaseTime = _releaseTime;
  }

  function release() public {
    require(block.timestamp >= releaseTime);

    uint256 amount = token.balanceOf(address(this));
    require(amount > 0);

    token.transfer(beneficiary, amount);
  }
}