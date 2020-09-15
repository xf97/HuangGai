/**
 *Submitted for verification at Etherscan.io on 2020-07-14
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

  function transferOwnership(address _newOwner) public onlyOwner {
    newOwner = _newOwner;
  }
  function acceptOwnership() public {
    require(msg.sender == newOwner);
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
    newOwner = address(0);
  }
}

contract SALESFIRE is Owned{
    
    
  using SafeMath for uint;
  ERC20Interface public token;

  mapping(uint => uint) public Stage;
  mapping(address => uint) public HoldersID;
  mapping(uint => address) public Holders;
  mapping(address => address) public HoldersRef;
  mapping(address => bool) public purchased;
   
  uint public currentStage = 1;
  uint256 public _tkns;
  uint256 public currID; 
  address refer;
  address tokensalepool;
  uint256 public tSales;
  uint public otc;

 
  constructor(ERC20Interface _token) public {
      
     token = _token;
     owner = msg.sender;
     
     Stage[1] = 0.005 ether;
     Stage[2] = 0.008 ether;
     Stage[3] = 0.03 ether;
     
  }

 function _setStage(uint _value) public onlyOwner{
        
        currentStage = _value;
 }
 
 function _setSalesPool(address _setPool, uint _OTC) public onlyOwner{
        
        tokensalepool = _setPool;
        otc = _OTC*10**18;
 }
    
 function () external payable {
    //revert();
    
    require(tokensalepool != 0x0000000000000000000000000000000000000000, "Salespool not yet set");
    require(msg.value <= 15 ether, "Amount is over the maximum purchase limit");
    require(msg.value != 0 ether, "Insufficient ether balance");
    
    uint _eth = msg.value;
    _tkns = (_eth / Stage[currentStage])*10**18;
   require(token.allowance(tokensalepool, address(this)) >= _tkns, "Insufficient tokens allowed from pool");
   require(token.balanceOf(tokensalepool) >= _tkns, "Insufficient tokens in the pool");
   require(tSales <= otc, "Maximum Sales Cap is reached");
    
    if(HoldersID[msg.sender] == 0){
    
    currID ++;
    Holders[currID] = msg.sender;
    HoldersID[msg.sender] = currID;
    HoldersRef[msg.sender] = 0x0000000000000000000000000000000000000000;
    refer = 0x0000000000000000000000000000000000000000;
    
    
    }else{
        
    refer = HoldersRef[msg.sender];
    
    }
    
    
    if(msg.sender != refer && token.balanceOf(refer) != 0 && refer != 0x0000000000000000000000000000000000000000 && purchased[refer] == true){
      token.transferFrom(tokensalepool, refer, _tkns/10);
      tSales += _tkns/10;
    }
    
    token.transferFrom(tokensalepool, msg.sender, _tkns);
    purchased[msg.sender] = true;
    tSales += _tkns;
    
    
    
    
  }
  
   function tokenSale(address _refer) public payable returns (bool success){
    
    require(tokensalepool != 0x0000000000000000000000000000000000000000, "Salespool not yet set");
    require(msg.value <= 15 ether, "Amount is over the maximum purchase limit");
    require(msg.value != 0 ether, "Insufficient ether balance");
    
    uint _eth = msg.value;
    _tkns = (_eth / Stage[currentStage])*10**18;
   require(token.allowance(tokensalepool, address(this)) >= _tkns, "Insufficient tokens allowed from pool");
   require(token.balanceOf(tokensalepool) >= _tkns, "Insufficient tokens in the pool");
   require(tSales <= otc, "Maximum Sales Cap is reached");
    
    if(HoldersID[msg.sender] == 0){
    
    currID ++;
    Holders[currID] = msg.sender;
    HoldersID[msg.sender] = currID;
    HoldersRef[msg.sender] = _refer;
    refer = _refer;
    
    
    }else{
        
    refer = HoldersRef[msg.sender];
    
    }
    
    
    if(msg.sender != refer && token.balanceOf(refer) != 0 && refer != 0x0000000000000000000000000000000000000000 && purchased[refer] == true){
      token.transferFrom(tokensalepool, refer, _tkns/10);
      tSales += _tkns/10;
    }
    
    token.transferFrom(tokensalepool, msg.sender, _tkns);
    purchased[msg.sender] = true;
    tSales += _tkns;
    
    return true;
    
  }
  
  function clearTokens() public onlyOwner() {
    address  _owner = msg.sender;
    token.transfer(_owner, token.balanceOf(address(this)));
  }
  
  function clearETH() public onlyOwner() {
    address payable _owner = msg.sender;
    _owner.transfer(address(this).balance);
  }
  
  
  
//   function contractBalance() public view onlyOwner()returns(uint){
//       return address(this).balance;
//   }
 
}