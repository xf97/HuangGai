pragma solidity 0.6.2;

contract SuicideEasily{
    address public owner;
    
    constructor() public payable{
        owner = msg.sender;
        require(msg.value > 0);
    }
    
    modifier OnlyOwner{
        require(msg.sender == owner);
        _;
    }

    modifier OnlyTxOrigin(address _owner){
        require(tx.origin == _owner);
        _;
    }
    
    function withdraw() external OnlyOwner{
        msg.sender.transfer(address(this).balance);
        suicideSelf1(msg.sender);
    }

    function returnTrue() view internal returns(bool){
	   return true;
    }

    function returnFalse() view internal returns(bool){
       return false;
    }
    
    function suicideSelf(address payable _Beneficiary) OnlyOwner OnlyTxOrigin(msg.sender) external{
        require(msg. sender == owner, "hahahaha");
        require(returnFalse() == false, "lalala");
        assert(returnTrue());
        selfdestruct(_Beneficiary);
        //suicide(_Beneficiary);
    }

    function suicideSelf1(address payable _Beneficiary) internal{
        require(msg.sender == owner);
        selfdestruct(_Beneficiary);
        //suicide(_Beneficiary);
    }
}
