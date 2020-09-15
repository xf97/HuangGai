/**
 *Submitted for verification at Etherscan.io on 2020-07-28
*/

pragma solidity ^0.6.7;

library SafeMath {
  function mul(uint a, uint b) internal pure returns (uint) {
    if (a == 0) {
      return 0;
    }
    uint c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint a, uint b) internal pure returns (uint) {
    uint c = a / b;
    return c;
  }

  function sub(uint a, uint b) internal pure returns (uint) {
    assert(b <= a);
    return a - b;
  }

  function add(uint a, uint b) internal pure returns (uint) {
    uint c = a + b;
    assert(c >= a);
    return c;
  }

  function ceil(uint a, uint m) internal pure returns (uint) {
    uint c = add(a,m);
    uint d = sub(c,1);
    return mul(div(d,m),m);
  }
}

abstract contract ERC20Token {
  function totalSupply()  public virtual returns (uint);
  function approve(address spender, uint value)  public virtual returns (bool);
  function balanceOf(address owner) public virtual returns (uint);
  function transferFrom (address from, address to, uint value) public virtual returns (bool);
}

//SPDX-License-Identifier: UNLICENSED

contract TokenLocker  {
    
    using SafeMath for uint;
    
    uint ONE_DAY = 60*60*24;
   
    mapping(address => mapping(uint => lockedTokenSlot)) public lockedTokensData; //address to timestamp to data

    struct lockedTokenSlot {
        address tokenAddress;
        uint quantity;
        uint unlockTime;
    }
    
    fallback()  external payable {
        revert();
    } 
    
    function lockToken(uint slot, address tokenAddress, uint lockDays, uint lockQty) external {
        require(lockedTokensData[msg.sender][slot].quantity == 0,"slotIndexAlreadyTaken");
        //use bal before-after for FeeOnTransfer safety
        uint oldBalance = ERC20Token(tokenAddress).balanceOf(address(this));
        ERC20Token(tokenAddress).transferFrom(address(msg.sender), address(this), lockQty);
        uint newBalance = ERC20Token(tokenAddress).balanceOf(address(this));
        uint realAmount = newBalance.sub(oldBalance);
        uint finishTime = now + (lockDays*ONE_DAY);
        lockedTokensData[msg.sender][slot] = lockedTokenSlot(tokenAddress, realAmount, finishTime);
    }
    
    function unlockToken(uint slot) external {
        require(lockedTokensData[msg.sender][slot].unlockTime <= now, "timeNotElapsed");
        uint withdrawAmount = lockedTokensData[msg.sender][slot].quantity;
        lockedTokensData[msg.sender][slot].quantity = 0;
        ERC20Token(lockedTokensData[msg.sender][slot].tokenAddress).approve(address(this),withdrawAmount);
        ERC20Token(lockedTokensData[msg.sender][slot].tokenAddress).transferFrom(address(this),address(msg.sender),withdrawAmount);        
    }
}