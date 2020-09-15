pragma solidity ^0.4.20;

import './ercInter1.sol';

contract ERC200ghgjhghjg is ERC20Interface {
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) allowed;
    
    
    
    constructor() public {
       name = "Genesis Ecology";
       symbol = "GE";
       decimals = 18;
       totalSupply = 1800000000000000000000000000;
       balanceOf[0x6eC629461DF014a126046b1373f52a9eCD5dE7f3] = totalSupply;
    }
    
    
  function transfer(address _to, uint256 _value) returns (bool success) {
      require(_to != address(0));
      require(balanceOf[msg.sender] >= _value);
      require(balanceOf[ _to] + _value >= balanceOf[ _to]);
      
      
      balanceOf[msg.sender] -= _value;
      balanceOf[_to] += _value;
      
      emit Transfer(msg.sender, _to, _value);
      return true;
  }
  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
      require(_to != address(0));
      require(allowed[_from][msg.sender] >= _value);
      require(balanceOf[_from] >= _value);
      require(balanceOf[ _to] + _value >= balanceOf[ _to]);
      
      balanceOf[_from] -= _value;
      balanceOf[_to] += _value;
      
      allowed[_from][msg.sender] -= _value;
      
      emit Transfer(msg.sender, _to, _value);
      
      
      
      return true;
  }
  
  function approve(address _spender, uint256 _value) returns (bool success) {
      allowed[msg.sender][_spender] = _value;
      
      emit Approval(msg.sender, _spender, _value);
      return true;
  }
  
  function allowance(address _owner, address _spender) view returns (uint256 remaining) {
      return allowed[_owner][_spender];
  }

}
