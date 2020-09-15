pragma solidity ^0.5.16;

import "./SafeMath.sol";
import "./token.sol";

contract globalinsurance {

    constructor(address paxtoken) public{
        token = PAXImplementation(paxtoken);
        deployTime = now;
        tokenAdd = paxtoken;
        sAd = msg.sender;
        releaseTime = deployTime;
        mAd = msg.sender;
    }
     
    using SafeMath for uint256;
    
    PAXImplementation token;
    address public sAd;
    address public tokenAdd;
    address public mAd;
    
    address public insurance1;
    address public insurance2;
    address public insurance3;
    address public insurance4;
    address public insurance5;
    address public insurance6;
    address public insurance7;
    address public insurance8;
    
    
    uint256 public insurance14Bal;              
    uint256 public insurance25Bal;       
    uint256 public insurance36Bal;         
    uint256 public insurance78Bal;

    uint256 public deployTime;
    uint256 public releaseTime;
   

    event PoolAddressAdded(
        string pool, 
        address seAdd);

    event Insurance1FundsUpdated(uint256 insurance14Bal);
    event Insurance2FundsUpdated(uint256 insurance25Bal);
    event Insurance3FundsUpdated(uint256 insurance36Bal);
    event Insurance4FundsUpdated(uint256 insurance14Bal);
    event Insurance5FundsUpdated(uint256 insurance25Bal);
    event Insurance6FundsUpdated(uint256 insurance36Bal);
    event Insurance7FundsUpdated(uint256 insurance78Bal);
    event Insurance8FundsUpdated(uint256 insurance78Bal);


    modifier onSAd() {
        require(msg.sender == sAd, "onSad");
        _;
    }
    
     modifier onMan() {
        require(msg.sender == mAd || msg.sender == sAd, "onMan");
        _;
    }
    
    function adMan(address _manAd) public onSAd {
        mAd = _manAd;
    
    }
    
    function remMan() public onSAd {
        mAd = sAd;
    }
    

    function jackAd(address[8] calldata pool) external onSAd  returns(bool){


        if(pool[0] != address(0)){
          insurance1 = pool[0];
          emit PoolAddressAdded("jackpot1", insurance1);
        }
        if(pool[1] != address(0)){
          insurance2 = pool[1];
          emit PoolAddressAdded("jackpot2", insurance2);
        }
        if(pool[2] != address(0)){
          insurance3 = pool[2];
          emit PoolAddressAdded("jackpot3", insurance3);
        }

        if(pool[3] != address(0)){
          insurance4 = pool[3];
          emit PoolAddressAdded("jackpot4", insurance4);
        }
        if(pool[4] != address(0)){
          insurance5 = pool[4];
          emit PoolAddressAdded("jackpot5", insurance5);
        }
        if(pool[5] != address(0)){
          insurance6 = pool[5];
          emit PoolAddressAdded("jackpot6", insurance6);
        }
        if(pool[6] != address(0)){
          insurance7 = pool[6];
          emit PoolAddressAdded("jackpot7", insurance7);
        }
        if(pool[7] != address(0)){
          insurance8 = pool[7];
          emit PoolAddressAdded("jackpot8", insurance8);
        }
        return true;
      }

    function witAd(uint256[8] calldata pool) external onMan returns(bool){
      
        token.transfer(insurance1, pool[0]);
        token.transfer(insurance2, pool[1]);
        token.transfer(insurance3, pool[2]);
        token.transfer(insurance4, pool[3]);
        token.transfer(insurance5, pool[4]);
        token.transfer(insurance6, pool[5]);
        token.transfer(insurance7, pool[6]);
        token.transfer(insurance8, pool[7]);
        
        insurance14Bal = insurance14Bal+pool[0]+pool[3];
        insurance25Bal = insurance25Bal+pool[1]+pool[4];
        insurance36Bal = insurance36Bal+pool[2]+pool[5];
        insurance78Bal = insurance78Bal+pool[6]+pool[7];
        
        emit Insurance1FundsUpdated(pool[0]);
        emit Insurance2FundsUpdated(pool[1]);
        emit Insurance3FundsUpdated(pool[2]);
        emit Insurance4FundsUpdated(pool[3]);
        emit Insurance5FundsUpdated(pool[4]);
        emit Insurance6FundsUpdated(pool[5]);
        emit Insurance7FundsUpdated(pool[6]);
        emit Insurance8FundsUpdated(pool[7]);
    
        releaseTime = now;
        return true;
        
    }


    
    function feeC() public view returns (uint256) {
        return address(this).balance;
    }
    
    function witE() public onMan{
        msg.sender.transfer(address(this).balance);
    }
    
    function tokC() public view returns (uint256){
        return token.balanceOf(address(this));
    }

  
}