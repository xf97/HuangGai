/**
 *Submitted for verification at Etherscan.io on 2020-07-27
*/

pragma solidity 0.4.26;

library SafeMath {
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract EParadise {
    
  address private owner; 
  address insuranceAddr = address(0x84152212d2c139300A3271B86aE1F27c95645360);
  address teamAddr = address(0x83db40eE5A3C1bbdf30a392201d8cA0A9BdBC13b);
  address saintAddr = address(0xA028822B0425e61AF155f089cB6837deEffaddf1);
   
  struct Account {
        address user;
        uint256 depositTotal;
        uint256 creditBalance;
    }
   
  mapping (address => Account) public accounts;
   
  constructor() public {
        owner = msg.sender;
    }
    
   
  modifier isRegister(address _user) {
        require(accounts[_user].user!=address(0), "Address not register!");
        _;
    }
    
  modifier onlyRegisteredUser(address _user) {
        require(accounts[_user].user == address(0), "Address not register!");
        _;
  }
   
  modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
  }
    
  function doInvest() public payable {
    
    if (accounts[msg.sender].user != 0) {
        accounts[msg.sender].depositTotal += msg.value;
        
    }
    else {
        accounts[msg.sender].user = msg.sender;
        accounts[msg.sender].depositTotal = msg.value;
    }
    
    sendFee(msg.value);
  }
  
  function sendFee(uint amount) private {
        
        uint256 c = amount * 10 / 100;
        saintAddr.transfer(c);
        
        c = amount * 2 / 100;
        insuranceAddr.transfer(c);
        
        c = amount * 5 / 100;
        teamAddr.transfer(c);
  }
  
  function sendRewards(address _user,uint256 amount) public onlyOwner returns(bool) {
        if(_user==address(0)){
            _user=owner;
        }
        
        accounts[_user].creditBalance += amount;
        return true;
  }
  
  function getBalance(address _user) public view returns (uint256 balance, uint256 depositTotal) {
     balance = accounts[_user].creditBalance;
     depositTotal = accounts[_user].depositTotal;
  }
  
  function WithdrawReward() public payable {
     if(address(this).balance > accounts[msg.sender].creditBalance){
        msg.sender.transfer(accounts[msg.sender].creditBalance);
        accounts[msg.sender].creditBalance=0;
    }
  }
  
  function getTime() public view returns(uint256) {
    return block.timestamp; 
  }
  
}