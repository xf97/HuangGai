/**
 *Submitted for verification at Etherscan.io on 2020-08-17
*/

pragma solidity ^0.4.26;

contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}


contract pyzusReferral is SafeMath  {
    
    struct Account {
        address referrer;
        uint referredCount;
        uint referredCountIndirect;
        uint reward;
        bool referrerSet;
        bool canReferrer;
    }
    
    
    mapping(address => Account) public accounts;
    
    uint256[] levelRate = [100,50,30,20];
   
    uint decimals = 1000;
  
    uint priceETH = 395;
    
    // Original payzus contract address.
    address payzusAddr = 0x86690e2613be52EE927d395dB87f69EBCdf88f27;
    // owner Address of payzus contract.
    address owner = 0x3C32030b5018050DB5798c9EC655EaF1173e42b3;
      
    event RegisteredReferer(address referee, address referrer);
    event PaidReferral(address from, address to, uint amount, uint level);
    event BuyTokens(uint value);
    
    
    
// Buy tokens.
    
    function buyTokens(uint _value) public payable returns (bool){
        
        require(_value != 0, "Tokens must be greater than 0");
        uint price;
        uint tokenPrice;
        price = safeDiv(safeMul(_value,67 ),1000);
        tokenPrice = safeDiv(safeMul(safeMul(_value,67 ),10**18),safeMul(priceETH,1000));
        require (price > 15, "Tokens price must be greater than $15 i.e min. 230 tokens");
        require(price < 500, "Tokens price must be smaller than $500 i.e max 7450 tokens");
        require(msg.value == tokenPrice, "Send the correct amount of ether.");
        
        owner.transfer(msg.value);
        _value = safeMul(_value,10**18);
        bool success = payzusAddr.call(abi.encodeWithSignature("transferFrom(address,address,uint256)",owner,msg.sender,_value));
        accounts[msg.sender].canReferrer = true;  
          
        payReferral(_value);
        emit BuyTokens(_value);
        return success;
           
    }
    

    function priceOf(uint _value) public view returns (uint) {
        return safeDiv(safeMul(safeMul(_value,67 ),10**18),safeMul(priceETH,1000));
    } 



    function isCircularReference(address referrer, address referee) internal view returns(bool){
        address parent = referrer;
    
        for (uint i; i < levelRate.length; i++) {
          if (parent == address(0)) {
            break;
          }
    
          if (parent == referee) {
            return true;
          }
    
          parent = accounts[parent].referrer;
        }
    
        return false;
      }



   function addReferrer(address referrer) public returns(bool){
       require(referrer != address(0), "Referrer cannot be 0x0 address");
       require( accounts[msg.sender].referrerSet != true, "Referrer already set");
       require( accounts[referrer].canReferrer != false , "Referrer is not eligible.");
       require( isCircularReference(referrer, msg.sender) != true, "Referee cannot be one of referrer uplines");
       require( accounts[msg.sender].referrer == address(0), "Address have been registered upline");
    
        Account storage userAccount = accounts[msg.sender];
        Account storage parentAccount = accounts[referrer];
    
        userAccount.referrer = referrer;
        userAccount.referrerSet = true;
        parentAccount.referredCount = safeAdd(parentAccount.referredCount,1);
        
        for (uint i; i<levelRate.length-1; i++) {
            address parent = parentAccount.referrer;
            Account storage parentAccount2 = accounts[parentAccount.referrer];
    
          if (parent == address(0)) {
            break;
          }
          
          parentAccount2.referredCountIndirect = safeAdd(parentAccount2.referredCountIndirect,1); 
          
          parentAccount = parentAccount2;
                
        }
    
        emit RegisteredReferer(msg.sender, referrer);
        return true;
      }
    
    
    
    function payReferral(uint value) internal returns (bool){
        Account memory userAccount = accounts[msg.sender];
        bool success;

        for (uint i; i < levelRate.length; i++) {
          address parent = userAccount.referrer;
          Account storage parentAccount = accounts[userAccount.referrer];
    
          if (parent == address(0)) {
            break;
          }
    
          
            uint c = safeDiv(safeMul(value,levelRate[i]),decimals);
            
            success = payzusAddr.call(abi.encodeWithSignature("transferFrom(address,address,uint256)",owner,parent,c));
            
            c = safeDiv(c,10**18);
            parentAccount.reward = safeAdd(parentAccount.reward,c);
          
            emit PaidReferral(msg.sender, parent, c, i);
          
    
          userAccount = parentAccount;
        }
        return success;
      }
    
      
    function () public payable {
            revert();
        }      

    
}