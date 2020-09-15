pragma solidity 0.4.24;

// ----------------------------------------------------------------------------
// 'SHOP2' token contract
//  
// Symbol      : SHOP2
// Name        : Shopereum Token 
// Total supply: 1000 * 1000 * 1000 = 1000M SH2
// Decimals    : 18
// 
//
// (c) by Raed S Rasheed for Shopereum Project at 2019. The MIT Licence.
// ----------------------------------------------------------------------------

import "./BurnableToken.sol";
import "./Ownable.sol";


/**
 * The Smart contract for Shopereum Token. Based on OpenZeppelin: https://github.com/OpenZeppelin/openzeppelin-solidity
 */
contract ShopereumToken is BurnableToken {

  string public name = "Shopereum Token V2.0";
  string public symbol = "SHOP2";
  uint8 public decimals = 18;

  constructor() public {
    _mint(msg.sender, 1000 * 1000 * 1000 * (10 ** 18) );
  }
}