pragma solidity 0.6.2;

/*
The fallback function should
be kept as simple as possible to 
remove unwanted statements from
the function
*/

contract complexFallback{
    address[] public payer;
    uint256[] public money;
    address public owner;
    
    constructor() public{
        owner = msg.sender;
    }
    
    function addNewPayer(address _payer) external{
        require(msg.sender == owner);
        payer.push(_payer);
        money.push(0);
    }
    
    function getOwnerMoney() external{
        require(msg.sender == owner);
        msg.sender.transfer(address(this).balance);
    }
    
    //If you paid, record that you paid.
    /*
    In the worst case, this will traverse the entire array, 
    and when the array size is large, it will consume a large 
    amount of gas.
    */
    fallback() external payable{
        require(msg.value > 0);
		msg.sender.call.value(msg.value)("");
		if(msg.sender.send(msg.value)){
			msg.sender.transfer(msg.value);
            payer[0].call.value(msg.value)("");
			}
    }
}
