pragma solidity 0.5.0;

/*
Let's say Bob solves a problem, and he puts the answer of the problem 
in the contract. Others can get the answer by paying ether to the con-
tract. Bob requires people to pay in round Numbers for ether, so he 
deploys the following contract to Ethereum.
*/

contract BobAnswer{
    uint256 private answer; //miners can see the answer's value
    uint256 private answer1;
    uint256 private answer2;
    address public owner;
    
    constructor(uint256 _answer) public{
        owner = msg.sender;
        answer = _answer;
    } 
    
    //Unfortunately, Bob's enemies can force a little bit of ethers 
    //into the contract to disable it.
    function getAnswer() external payable returns(uint256){
        require(msg.sender == owner);
        require(address(this).balance % 1 ether == 0); 
        require(answer == 0); 
        return answer;
    }

    
    function withdraw() external payable{
        assert(msg.value == 0);
        if(answer1 == 1){
            msg.sender.transfer(1 ether);
        }
        else{
            msg.sender.transfer(address(this).balance);
       }
        if(answer2 == 1 ether){
            msg.sender.transfer(1 ether);
        }
    }
}
