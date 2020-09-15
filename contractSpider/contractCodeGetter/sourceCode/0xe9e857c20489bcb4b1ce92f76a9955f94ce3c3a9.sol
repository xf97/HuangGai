/**
 *Submitted for verification at Etherscan.io on 2020-06-20
*/

pragma solidity ~0.4.25;

contract BCSC {
     
    mapping(address => uint256[]) public records;
    mapping(address => uint256[]) public exchanges;

    mapping(uint256 => address) public hashes;
    
    function publish(uint256 hash) public{
        require(hashes[hash]==0);
        hashes[hash]=msg.sender;
        records[msg.sender].push(hash);
    }
    function exchange(uint256 hash) public{
        require(hashes[hash]>0);
        exchanges[msg.sender].push(hash);
        return;
    }
    
    function exist(uint256 hash) public view returns (bool){
        return hashes[hash]!=0;
    }
    
    function getCount() public view returns( uint ){
         return records[msg.sender].length;
    }
    
    function getByIdx(uint idx) public view returns( uint256) {
        return records[msg.sender][idx];
    }

}