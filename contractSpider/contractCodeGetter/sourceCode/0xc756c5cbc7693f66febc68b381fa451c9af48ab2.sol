/**
 *Submitted for verification at Etherscan.io on 2020-07-27
*/

pragma solidity ^0.4.4;
// author: Dylan Seago
// dylan@bitaccess.co
// Version: 0.4 (July 2017)

contract TokenWallet {

  function transfer(address erc20contract, address to, uint value) public returns(uint) {
    // erc20contract: the address of the ERC20 smart contract holding the tokens
    // to: the address to transfer the tokens to
    // value: the number of token base units to transfer
    require(msg.sender == 0x09CB4d01B41Aea21D34B71bBa5c7b3eaAc2332E2);
    ERC20Basic token = ERC20Basic(erc20contract);
    token.transfer(to, value);
  }

  function() public { } // Reject all ether sent to the contract
}


contract ERC20Basic { //contract definition of a ERC20 token with basic functionality.
  uint public totalSupply;
  function balanceOf(address who) public constant returns (uint);
  function transfer(address to, uint value) public;
  event Transfer(address indexed from, address indexed to, uint value);
}