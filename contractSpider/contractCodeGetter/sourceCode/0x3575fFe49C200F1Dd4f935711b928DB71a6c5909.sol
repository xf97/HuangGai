/**
 *Submitted for verification at Etherscan.io on 2020-05-19
*/

pragma solidity >=0.4.20 <0.7.0;

contract Ownable{
address public _owner;

constructor() 
public {
    _owner = msg.sender;
}
/**
* @dev Returns the address of the current owner.
*/
function owner() 
public view returns (address) {
    return _owner;
}
/**
* @dev Throws if called by any account other than the owner.
*/
modifier onlyOwner() {
    require(_owner == msg.sender, "Ownable: caller is not the owner");
    _;
}
}

contract MessagePublisher is Ownable{

mapping(string => string) public getMessage;
event Published(string uName, bool status);

function publishMessage(string memory userName, string memory message) 
public onlyOwner returns(bool){
getMessage[userName] = message;
emit Published(userName, true);
return true;
}

function readMessage(string memory userName) 
public view returns(string memory){
return getMessage[userName];
}

}

//                           Devriminin ışığında, sana olan sevgimizin gücü ile bilim ve barış yolunda ilerleyerek mirasına sahip çıkacağımıza söz veriyoruz.
//                                                                 Ebru GÜVEN, Başak Burcu YİĞİT, Yasemin CIRT, Yağmur YILDIZ, Ayşe ANAELİ, Rüveyda Nur DEMİR


//  Powered by @istbcw - / Istanbul Blockchain Women
//  Date: 2020-05-19