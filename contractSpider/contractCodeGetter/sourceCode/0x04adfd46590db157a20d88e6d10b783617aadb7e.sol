/**
 *Submitted for verification at Etherscan.io on 2020-07-25
*/

pragma solidity ^0.5.17;

library SafeMath {
  function add(uint a, uint b) internal pure returns (uint c) {
    c = a + b;
    require(c >= a);
  }
  function sub(uint a, uint b) internal pure returns (uint c) {
    require(b <= a);
    c = a - b;
  }
  function mul(uint a, uint b) internal pure returns (uint c) {
    c = a * b;
    require(a == 0 || c / a == b);
  }
  function div(uint a, uint b) internal pure returns (uint c) {
    require(b > 0);
    c = a / b;
  }
}

contract ERC20Interface {
  function totalSupply() public view returns (uint);
  function balanceOf(address tokenOwner) public view returns (uint balance);
  function allowance(address tokenOwner, address spender) public view returns (uint remaining);
  function transfer(address to, uint tokens) public returns (bool success);
  function approve(address spender, uint tokens) public returns (bool success);
  function transferFrom(address from, address to, uint tokens) public returns (bool success);

  
}

contract ApproveAndCallFallBack {
  function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
}

contract Owned {
  address public owner;
  address public newOwner;

  event OwnershipTransferred(address indexed _from, address indexed _to);

  constructor() public {
    owner = msg.sender;
    
  }

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

}

contract PRESALE is Owned{
    
    
  using SafeMath for uint;
  ERC20Interface public token;
   
  uint256 public _tkns;
  address tokensalepool;
  uint256 public tSales;
  uint public otc;
  address payable saleswallet;

 
  constructor(ERC20Interface _token) public {
      
     token = _token;
     owner = msg.sender;
     
  }
   
 
 function _setSalesPool(address _setPool, uint _OTC, address payable _salewallet) public onlyOwner{
	    
	    tokensalepool = _setPool;
	    otc = _OTC*10**18;
	    saleswallet = _salewallet;
 }
	
 function () external payable {

    require(tokensalepool != 0x0000000000000000000000000000000000000000, "Salespool not yet set");
    require(msg.value <= 10 ether, "Amount is over the maximum purchase limit");
    require(msg.value != 0 ether, "Insufficient ether balance");
    
    uint _eth = msg.value;
    _tkns = (_eth / 0.00022 ether)*10**18;
   require(token.allowance(tokensalepool, address(this)) >= _tkns, "Insufficient tokens allowed from pool");
   require(token.balanceOf(tokensalepool) >= _tkns, "Insufficient tokens in the pool");
   require(tSales <= otc, "Maximum Sales Cap is reached");

    saleswallet.transfer(msg.value);
    token.transferFrom(tokensalepool, msg.sender, _tkns);
    tSales += _tkns;
    
   
  }
  
function buysales() public payable{

    require(tokensalepool != 0x0000000000000000000000000000000000000000, "Salespool not yet set");
    require(msg.value <= 10 ether, "Amount is over the maximum purchase limit");
    require(msg.value != 0 ether, "Insufficient ether balance");
    
    uint _eth = msg.value;
    _tkns = (_eth / 0.00022 ether)*10**18;
   require(token.allowance(tokensalepool, address(this)) >= _tkns, "Insufficient tokens allowed from pool");
   require(token.balanceOf(tokensalepool) >= _tkns, "Insufficient tokens in the pool");
   require(tSales <= otc, "Maximum Sales Cap is reached");

     saleswallet.transfer(msg.value);
     token.transferFrom(tokensalepool, msg.sender, _tkns);
    tSales += _tkns;
    
   
  }
 
}