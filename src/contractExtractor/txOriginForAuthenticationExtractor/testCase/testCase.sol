pragma solidity 0.6.2;

/*
tx.origin is not without its proper application, such 
as the following statement that effectively rejects 
the contract call. tx.origin in this contract is innocent.
*/

contract gray_badTxorigin{
    uint256 public visitTimes;
    address owner;
    
    constructor() public{
        visitTimes = 0;
        owner = msg.sender;
        address owner1 = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        require(msg.sender == owner, "hahaha");
        assert(msg.sender == owner);
        _;
    }

    
    //Only real user access is recorded, not contract access.
    function visitContract() onlyOwner external{
        require(owner == msg.sender);
        visitTimes += 1;
    }
    
    function getTimes() view external returns(uint256){
        return visitTimes;
    }
}