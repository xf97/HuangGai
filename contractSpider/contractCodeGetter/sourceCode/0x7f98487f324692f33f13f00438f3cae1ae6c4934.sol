/**
 *Submitted for verification at Etherscan.io on 2020-06-19
*/

pragma solidity ^0.4.26;

contract SciCC {
    string public version = '0.1';
    string public name='Scientific Computing Chain';
     
    mapping(address => uint256[]) public publishRecords;
    mapping(address => uint256[]) public exchangeRecords;

    mapping(uint256 => address) public imageHashes;
    
    function publishImageHash(uint256 imageHash) public{
        require(imageHashes[imageHash]==0);
        imageHashes[imageHash]=msg.sender;
        uint256[] storage deposit = publishRecords[msg.sender];
        deposit.push(imageHash);
        publishRecords[msg.sender] = deposit;
    }
    
    function getDepositCount() public view returns( uint ){
         uint256[] storage deposit = publishRecords[msg.sender];
         return deposit.length;
    }
    
    function getDepositHashByIndex(uint idx) public view returns( uint256) {
        uint256[] storage deposit = publishRecords[msg.sender];
         return deposit[idx];
    }
    
    function buy(uint256 hash) public{
        require(imageHashes[hash]>0);
        exchangeRecords[msg.sender].push(hash);
        return;
    }

}