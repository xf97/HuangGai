/**
 *Submitted for verification at Etherscan.io on 2020-07-05
*/

pragma solidity 0.5.16;

contract owned {
    address  payable public owner;
    address payable internal newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = tx.origin;
        emit OwnershipTransferred(address(0), owner);
    }

    modifier onlyOwner {
        require(tx.origin == owner);
        _;
    }

    function transferOwnership(address payable _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    //this flow is to prevent transferring ownership to wrong wallet by mistake
    function acceptOwnership() public {
        require(tx.origin == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

interface usdtInterface
{
    function transfer(address _to, uint256 _amount) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool);    
    
}

contract Multipartner is owned{
    
    
    
    using SafeMath for uint256;
    
    mapping(uint256=>uint256) public poolRecord;
    mapping(address=>uint256) public partner;
    
    mapping(address=>uint256) public partnerWithdrawRecord;
    
    uint256 public poolAmt=0;
    uint256 public count=0;
    uint256 public globalPercent=0;
    
    address public baseContractaddress;
    
    address public usdtaddress;
    
    event Transfer(address _from, address _to, uint256 _amount);
    event AddPartner(address _owner, address _partner, uint256 _percent);
    event RemovePartner(address _owner, address _partner, uint256 _timestamp);
    
    // function () external payable{}
    
    function payamount(uint256 _amount) public{
        
        require(msg.sender==baseContractaddress);
        require(_amount!=0,"Invalid Amount");
        
        poolAmt=poolAmt.add(_amount);
        count=count.add(1);
        poolRecord[count]=poolAmt;
        
        emit Transfer(tx.origin,address(this),_amount);
        
    }
    
    function addBaseContract(address _add) public onlyOwner{
        require(_add!=address(0));
        
        baseContractaddress=_add;
    }
    
    constructor(address _usdtaddress) public{
        require(_usdtaddress!=address(0),"Invalid address");
        usdtaddress=_usdtaddress;
    }

    
    function addpartner(address _partner, uint256 _percent) public onlyOwner{
        require(partner[_partner]==0,"Already Exist");
        require(_partner!=address(0) && _percent!=0,"Invalid Argument");
        require(globalPercent+_percent<=100,"Invalid Percentage for partner");
        
        partner[_partner]=_percent;
        globalPercent=globalPercent.add(_percent);
        
        emit AddPartner(tx.origin,_partner,_percent);
    }
    
    function removePartner(address _partner) public onlyOwner{
        require(partner[_partner]!=0,"Partner not exist");
        
        globalPercent=globalPercent.sub(partner[_partner]);
        delete partner[_partner];
        
        emit RemovePartner(tx.origin,_partner,block.timestamp);
    }
    
    function partnerbalance(address _user) public view returns(uint256)
    {
        uint256 percent=0;
        if(_user==owner)
        {
            percent=100-globalPercent;
        }
        else
        {
            percent=partner[_user];
        }
        uint256 eligible=calculatePercentage(poolRecord[count].sub(poolRecord[partnerWithdrawRecord[_user]]),percent.mul(100));
        return eligible;
    }
    
    function withdraw() public{
        require(partner[tx.origin]!=0 || tx.origin==owner,"You are not a partner");
        
        uint256 eligible=partnerbalance(tx.origin);
         partnerWithdrawRecord[tx.origin]=count;
        
        usdtInterface(usdtaddress).transfer(tx.origin,eligible);
        // msg.sender.transfer(eligible);
        
        emit Transfer(address(this),tx.origin,eligible);
        
       
        
    }
    
    
     function calculatePercentage(uint256 PercentOf, uint256 percentTo ) internal pure returns (uint256) 
    {
        uint256 factor = 10000;
        uint256 c = PercentOf.mul(percentTo).div(factor);
        return c;
    }
}