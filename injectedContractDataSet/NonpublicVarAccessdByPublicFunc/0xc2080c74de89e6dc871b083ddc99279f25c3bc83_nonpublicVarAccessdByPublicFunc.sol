/**
 *Submitted for verification at Etherscan.io on 2020-10-18
*/

pragma solidity ^0.5.16;

/**
 * Math operations with safety checks
 */
library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint a, uint b) internal pure returns (uint) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint a, uint b) internal pure returns (uint) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address internal owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }


    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        owner = newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}

contract LIZVIP is Ownable{
    using SafeMath for uint;

    uint32[5] internal totalVipCount = [0,0,0,0,0];
    mapping (address => uint8) internal vipPowerMap;
    mapping (address => address) internal vipLevelToUp;
    mapping (address => address[]) internal vipLevelToDown;
    mapping (address => uint) internal vipBuyProfit;

    event BuyVip(address indexed from, uint256 amount);
    event VipLevelPro(address indexed from, address indexed to,uint256 amount, uint8 level);
    event AddAdviser(address indexed down, address indexed up);
    event GovWithdraw(address indexed to, uint256 value);

    uint constant private vipBasePrice = 1 ether;
    uint constant private vipBaseProfit = 30 finney;
    uint constant private vipExtraStakeRate = 10 ether;

    constructor()public {
    }

    function buyVipWithAdviser(address _adviser) public payable{
        require(_adviser != address(0) , "zero address input");
        if(vipPowerMap[msg.sender] == 0){	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            if( _adviser != msg.sender && isVip(_adviser)){
                vipLevelToUp[msg.sender] = _adviser;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                emit AddAdviser(msg.sender,_adviser);
            }
        }
        buyVip();
    }

    function buyVip() public payable{
        uint8 addP = uint8(msg.value/vipBasePrice);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint8 oldP = vipPowerMap[msg.sender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint8 newP = oldP + addP;
        require(newP > 0, "vip level over min");
        require(newP <= 5, "vip level over max");
        require(addP*vipBasePrice == msg.value, "1 to 5 ether only");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        totalVipCount[newP-1] = totalVipCount[newP-1] + 1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if(oldP>0){
            totalVipCount[oldP-1] = totalVipCount[oldP-1] - 1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        vipPowerMap[msg.sender] = newP;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        doVipLevelProfit(oldP, addP);

        emit BuyVip(msg.sender, msg.value);
    }
    function doVipLevelProfit(uint8 oldP, uint8 addP) private {
        address current = msg.sender;
        for(uint8 i = 1;i<=3;i++){
            address upper = vipLevelToUp[current];
            if(upper == address(0)){
                return;
            }
            if(oldP == 0){
                vipLevelToDown[upper].push(msg.sender);
            }
            uint profit = vipBaseProfit*i*addP;
            address(uint160(upper)).transfer(profit);
            vipBuyProfit[upper] = vipBuyProfit[upper].add(profit);

            emit VipLevelPro(msg.sender,upper,profit,i);
            current = upper;
        }
    }


    function govWithdraw(uint256 _amount)onlyOwner public {
        require(_amount > 0, "!zero input");

        msg.sender.transfer(_amount);
        emit GovWithdraw(msg.sender, _amount);
    }

    function isVip(address account) public view returns (bool) {
        return vipPowerMap[account]>0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function vipPower(address account) public view returns (uint) {
        return vipPowerMap[account];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function vipBuySubCountOf(address account) public view returns (uint) {
        return vipLevelToDown[account].length;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function vipBuyProfitOf(address account) public view returns (uint) {
        return vipBuyProfit[account];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function totalPowerStake() public view returns (uint) {
        uint vipAdd = 0;
        for(uint8 i = 0;i<5;i++){
            vipAdd = vipAdd+vipExtraStakeRate*totalVipCount[i]*(i+1);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        return vipAdd;
    }

    function powerStakeOf(address account) public view returns (uint) {
        return vipPowerMap[account]*vipExtraStakeRate;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}