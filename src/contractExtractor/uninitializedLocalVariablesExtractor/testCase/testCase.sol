pragma solidity 0.6.2;

//based on slither

contract uninitStateLocalVar{
    address payable payee;
    uint256 public _order = 0;
    event Record(address indexed _donors, uint256 _number, uint256 _money);
    
    constructor() public{
        payee = msg.sender;
    }

    function giveMeMoney() external payable{
        uint256 number = 0;
        _order += 1;
        require(msg.value > 0);
        emit Record(msg.sender, number, msg.value);
    }

    function withdrawDonation() external{
        payee.transfer(address(this).balance);
    }
}
