/**
 *Submitted for verification at Etherscan.io on 2020-07-05
*/

/*


___________________________________________________________________
  _      _                                        ______           
  |  |  /          /                                /              
--|-/|-/-----__---/----__----__---_--_----__-------/-------__------
  |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
__/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_

    
    
    
██████╗ ██╗██╗     ██╗     ██╗ ██████╗ ███╗   ██╗ █████╗ ██╗██████╗ ███████╗
██╔══██╗██║██║     ██║     ██║██╔═══██╗████╗  ██║██╔══██╗██║██╔══██╗██╔════╝
██████╔╝██║██║     ██║     ██║██║   ██║██╔██╗ ██║███████║██║██████╔╝█████╗  
██╔══██╗██║██║     ██║     ██║██║   ██║██║╚██╗██║██╔══██║██║██╔══██╗██╔══╝  
██████╔╝██║███████╗███████╗██║╚██████╔╝██║ ╚████║██║  ██║██║██║  ██║███████╗
╚═════╝ ╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚══════╝
                                                                            
    
    

----------------------------------------------------------------------------
 Copyright (c) 2020 onwards Billionaire.ooo Inc. ( https://billionaire.ooo )
----------------------------------------------------------------------------

*/



pragma solidity 0.5.16; 


// Owner Handler
contract ownerShip    // Auction Contract Owner and OwherShip change
{
    //Global storage declaration
    address public ownerWallet;
    address private newOwner;
    //Event defined for ownership transfered
    event OwnershipTransferredEv(address indexed previousOwner, address indexed newOwner);

    //Sets owner only on first run
    constructor() public 
    {
        //Set contract owner
        ownerWallet = msg.sender;
        emit OwnershipTransferredEv(address(0), msg.sender);
    }

    function transferOwnership(address _newOwner) public onlyOwner 
    {
        newOwner = _newOwner;
    }

    //the reason for this flow is to protect owners from sending ownership to unintended address due to human error
    function acceptOwnership() public 
    {
        require(msg.sender == newOwner);
        emit OwnershipTransferredEv(ownerWallet, newOwner);
        ownerWallet = newOwner;
        newOwner = address(0);
    }

    //This will restrict function only for owner where attached
    modifier onlyOwner() 
    {
        require(msg.sender == ownerWallet);
        _;
    }

}

interface MultiadminInterface{
        function payamount(uint256 _amount) external;
    }

contract Billionaire is ownerShip {
  

    //public variables
    uint public maxDownLimit = 2;
    uint public levelLifeTime = 8640000;  // = 100 days;
    uint public lastIDCount = 0;
    struct userInfo {
        bool joined;
        uint id;
        uint referrerID;
        address[] referral;
        mapping(uint => uint) levelExpired;
    }
    mapping(uint => uint) public priceOfLevel;
    mapping (address => userInfo) public userInfos;
    mapping (uint => address) public userAddressByID;
    
    address public multiadminAddress;


    //events
    event regLevelEv(uint indexed _userID, address indexed _userWallet, uint indexed _referrerID, address _refererWallet, uint _originalReferrer, uint _time);
    event levelBuyEv(address indexed _user, uint _level, uint _amount, uint _time);
    event paidForLevelEv(address indexed _user, address indexed _referral, uint _level, uint _amount, uint _time);
    event lostForLevelEv(address indexed _user, address indexed _referral, uint _level, uint _amount, uint _time);


    
    /**
     * constructor makes all the levels upgraded of ID 1 - owner
     */
    constructor(address _multiadminAddress) public {
        
        require(_multiadminAddress!=address(0));
        
        multiadminAddress=_multiadminAddress;
        
        priceOfLevel[1] = 0.25 ether;
        priceOfLevel[2] = 0.40 ether;
        priceOfLevel[3] = 1 ether;
        priceOfLevel[4] = 4 ether;
        priceOfLevel[5] = 10 ether;
        priceOfLevel[6] = 25 ether;
        priceOfLevel[7] = 30 ether;
        priceOfLevel[8] = 50 ether;
        priceOfLevel[9] = 70 ether;
        priceOfLevel[10] = 100 ether;

        userInfo memory UserInfo;
        lastIDCount++;

        UserInfo = userInfo({
            joined: true,
            id: lastIDCount,
            referrerID: 0,
            referral: new address[](0)
        });
        userInfos[multiadminAddress] = UserInfo;
        userAddressByID[lastIDCount] = multiadminAddress;

        for(uint i = 1; i <= 10; i++) {
            userInfos[multiadminAddress].levelExpired[i] = 99999999999;
            emit paidForLevelEv(multiadminAddress, address(0), i, priceOfLevel[i], now);
            emit levelBuyEv(multiadminAddress, i, priceOfLevel[i], now);
        }
        
        emit regLevelEv(lastIDCount, multiadminAddress, 0, address(0), 0, now);

    }


    /**
     * It also registers users as well as buys level, if user sends ether directly to the smart contract address.
     */
    function () external payable {
        uint level;

        if(msg.value == priceOfLevel[1]) level = 1;
        else if(msg.value == priceOfLevel[2]) level = 2;
        else if(msg.value == priceOfLevel[3]) level = 3;
        else if(msg.value == priceOfLevel[4]) level = 4;
        else if(msg.value == priceOfLevel[5]) level = 5;
        else if(msg.value == priceOfLevel[6]) level = 6;
        else if(msg.value == priceOfLevel[7]) level = 7;
        else if(msg.value == priceOfLevel[8]) level = 8;
        else if(msg.value == priceOfLevel[9]) level = 9;
        else if(msg.value == priceOfLevel[10]) level = 10;
        else revert('Incorrect Value send');

        if(userInfos[msg.sender].joined) buyLevel(level);
        else if(level == 1) {
            uint refId = 1;
            address referrer = bytesToAddress(msg.data);

            if(userInfos[referrer].joined) refId = userInfos[referrer].id;

            regUser(refId);
        }
        else revert('Please buy first level for 0.03 ETH');
    }

    
    /**
     * This function register the user in the system. He has to provide referrer ID.
     */
    function regUser(uint _referrerID) public payable {
        uint originalReferrerID = _referrerID;
        require(!userInfos[msg.sender].joined, 'User exist');
        require(_referrerID > 0 && _referrerID <= lastIDCount, 'Incorrect referrer Id');
        require(msg.value == priceOfLevel[1], 'Incorrect Value');

        if(userInfos[userAddressByID[_referrerID]].referral.length >= maxDownLimit) _referrerID = userInfos[findFreeReferrer(userAddressByID[_referrerID])].id;

        userInfo memory UserInfo;
        lastIDCount++;

        UserInfo = userInfo({
            joined: true,
            id: lastIDCount,
            referrerID: _referrerID,
            referral: new address[](0)
        });

        userInfos[msg.sender] = UserInfo;
        userAddressByID[lastIDCount] = msg.sender;

        userInfos[msg.sender].levelExpired[1] = now + levelLifeTime;

        userInfos[userAddressByID[_referrerID]].referral.push(msg.sender);

        payForLevel(1, msg.sender);

        emit regLevelEv(lastIDCount, msg.sender, _referrerID, userAddressByID[_referrerID], originalReferrerID, now);
        emit levelBuyEv(msg.sender, 1, msg.value, now);
    }

    
    /**
     * This function to buy any level. User has to specify level number to buy it.
     */
    function buyLevel(uint _level) public payable {
        require(userInfos[msg.sender].joined, 'User not exist'); 
        require(_level > 0 && _level <= 10, 'Incorrect level');
        
        //owner can buy levels without paying anything
        if(msg.sender!=ownerWallet){
            require(msg.value == priceOfLevel[_level], 'Incorrect Value');
        }
        
        if(_level == 1) {
            userInfos[msg.sender].levelExpired[1] += levelLifeTime;
        }
        else {
            
            for(uint l =_level - 1; l > 0; l--) require(userInfos[msg.sender].levelExpired[l] >= now, 'Buy the previous level');

            if(userInfos[msg.sender].levelExpired[_level] == 0) userInfos[msg.sender].levelExpired[_level] = now + levelLifeTime;
            else userInfos[msg.sender].levelExpired[_level] += levelLifeTime;
        }

        payForLevel(_level, msg.sender);

        emit levelBuyEv(msg.sender, _level, msg.value, now);
    }
    
    
    /**
     * Internal function to which distributes fund.
     */
    function payForLevel(uint _level, address _user) internal {
        address referer;
        address referer1;
        address referer2;
        address referer3;
        address referer4;

        if(_level == 1 || _level == 6) {
            referer = userAddressByID[userInfos[_user].referrerID];
        }
        else if(_level == 2 || _level == 7) {
            referer1 = userAddressByID[userInfos[_user].referrerID];
            referer = userAddressByID[userInfos[referer1].referrerID];
        }
        else if(_level == 3 || _level == 8) {
            referer1 = userAddressByID[userInfos[_user].referrerID];
            referer2 = userAddressByID[userInfos[referer1].referrerID];
            referer = userAddressByID[userInfos[referer2].referrerID];
        }
        else if(_level == 4 || _level == 9) {
            referer1 = userAddressByID[userInfos[_user].referrerID];
            referer2 = userAddressByID[userInfos[referer1].referrerID];
            referer3 = userAddressByID[userInfos[referer2].referrerID];
            referer = userAddressByID[userInfos[referer3].referrerID];
        }
        else if(_level == 5 || _level == 10) {
            referer1 = userAddressByID[userInfos[_user].referrerID];
            referer2 = userAddressByID[userInfos[referer1].referrerID];
            referer3 = userAddressByID[userInfos[referer2].referrerID];
            referer4 = userAddressByID[userInfos[referer3].referrerID];
            referer = userAddressByID[userInfos[referer4].referrerID];
        }

        if(!userInfos[referer].joined) referer = userAddressByID[1];

        bool sent = false;
        if(userInfos[referer].levelExpired[_level] >= now) {
            
            if(referer==multiadminAddress)
            {
                sent = address(uint160(ownerWallet)).send(priceOfLevel[_level]);
            }
            else
            {
                sent = address(uint160(referer)).send(priceOfLevel[_level]);
            }
            
            
            
            if (sent) {
            
                emit paidForLevelEv(referer, msg.sender, _level, msg.value, now);
            }
        }
        if(!sent) {
            emit lostForLevelEv(referer, msg.sender, _level, msg.value, now);
            
            address(uint160(multiadminAddress)).transfer(priceOfLevel[_level]);
            MultiadminInterface(multiadminAddress).payamount(msg.value);
        
            //payForLevel(_level, referer);
        }
    }
    
    
    /**
     * Find available free referrer in the matrix. It search maximum 126 positions.
     * For any chances where matrix goes beyond 126 position, then UI should supply correct referrer ID, to avoid hitting this limit.
     */
    function findFreeReferrer(address _user) public view returns(address) {
        if(userInfos[_user].referral.length < maxDownLimit) return _user;

        address[] memory referrals = new address[](126);
        referrals[0] = userInfos[_user].referral[0];
        referrals[1] = userInfos[_user].referral[1];

        address freeReferrer;
        bool noFreeReferrer = true;

        for(uint i = 0; i < 126; i++) {
            if(userInfos[referrals[i]].referral.length == maxDownLimit) {
                if(i < 62) {
                    referrals[(i+1)*2] = userInfos[referrals[i]].referral[0];
                    referrals[(i+1)*2+1] = userInfos[referrals[i]].referral[1];
                }
            }
            else {
                noFreeReferrer = false;
                freeReferrer = referrals[i];
                break;
            }
        }

        require(!noFreeReferrer, 'No Free Referrer');

        return freeReferrer;
    }
    
    
    /**
     * See user's referrals.
     */
    function viewUserReferral(address _user) public view returns(address[] memory) {
        return userInfos[_user].referral;
    }
    
    
    /**
     * See user's level expire.
     */
    function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
        return userInfos[_user].levelExpired[_level];
    }
    
    
    /**
     * assembly function which converts buytes to address.
     */
    function bytesToAddress(bytes memory bys) private pure returns (address addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
    
    
    /**
     * output the array of timestamp of user last joined. This is used to see the expiration of all the levels.
     */
    function viewTimestampSinceJoined(address usr) public view returns(uint256[10] memory timeSinceJoined )
    {
        if(userInfos[usr].joined)
        {
            for(uint256 i=0;i<10;i++)
            {
                uint256 t = userInfos[usr].levelExpired[i+1];
                if(t>now)
                {
                    timeSinceJoined[i] = (t-now);
                }
            }
        }
        return timeSinceJoined;
    }
    
    function changeMultiadminAddress(address _add) public onlyOwner{
        require(_add!=address(0));
        
        multiadminAddress=_add;
    }
  
    
   
    
}