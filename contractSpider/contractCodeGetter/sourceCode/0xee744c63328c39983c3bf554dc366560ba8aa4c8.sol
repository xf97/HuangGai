/**
 *Submitted for verification at Etherscan.io on 2020-05-20
*/

/**
* ==========================================================
*
* XoXo Network
* FIRST EVER FULLY DECENTRALIZED GLOBAL POWERLINE AUTOPOOL
*
* Website  : https://xoxo.run
* Telegram : https://t.me/xoxonetwork_official
*
* ==========================================================
**/

pragma solidity >=0.5.12 <0.7.0;

contract XoXo {

    struct User {
        uint id;
        uint referrerCount;
        uint referrerID;
        address[] referrals;
    }
    
    struct UsersPool2 {
        uint id;
        uint referrerID;
        uint reinvestCount;
    }
    
    struct Pool_2_Slots {
        address userAddress;
        uint referrerID;
        uint eventsCount;
    }
    
    struct UsersPool3 {
        uint id;
        uint referrerID;
        uint reinvestCount;
    }
    
    struct Pool_3_Slots {
        address userAddress;
        uint referrerID;
        uint eventsCount;
    }
    
    struct UsersPool4 {
        uint id;
        uint referrerID;
        uint reinvestCount;
    }
    
    struct Pool_4_Slots {
        address userAddress;
        uint referrerID;
        uint eventsCount;
    }
    
    struct UsersPool5 {
        uint id;
        uint referrerID;
        uint reinvestCount;
    }
    
    struct Pool_5_Slots {
        address userAddress;
        uint referrerID;
        uint eventsCount;
    }
    
    struct UsersPool6 {
        uint id;
        uint referrerID;
        uint reinvestCount;
    }
    
    struct Pool_6_Slots {
        address userAddress;
        uint referrerID;
        uint eventsCount;
    }
    
    struct UsersPool7 {
        uint id;
        uint referrerID;
        uint reinvestCount;
    }
    
    struct Pool_7_Slots {
        address userAddress;
        uint referrerID;
        uint eventsCount;
    }
    
    modifier validReferrerID(uint _referrerID) {
        require(_referrerID > 0 && _referrerID < newUserId, 'Invalid referrer ID');
        _;
    }
    
    event RegisterUserEvent(uint userId, address indexed user, address indexed referrer, uint time, uint8 indexed autopool, uint amount);
    event DistributeUplineEvent(uint amount, address indexed sponsor, uint level, uint time);

    mapping(address => User) public users;
    
    mapping(address => UsersPool2) public users_2;
    mapping(uint => Pool_2_Slots) public pool_slots_2;
    
    mapping(address => UsersPool3) public users_3;
    mapping(uint => Pool_3_Slots) public pool_slots_3;
    
    mapping(address => UsersPool4) public users_4;
    mapping(uint => Pool_4_Slots) public pool_slots_4;
    
    mapping(address => UsersPool5) public users_5;
    mapping(uint => Pool_5_Slots) public pool_slots_5;
    
    mapping(address => UsersPool6) public users_6;
    mapping(uint => Pool_6_Slots) public pool_slots_6;
    
    mapping(address => UsersPool7) public users_7;
    mapping(uint => Pool_7_Slots) public pool_slots_7;
    
    mapping(uint => address) public idToAddress;
    mapping(address => uint) public balances;
    
    mapping (uint => uint) public uplineAmount;
    
    uint public newUserId = 1;
    uint public newUserId_ap2 = 1;
    uint public activeSlot_ap2 = 1;
    uint public newUserId_ap3 = 1;
    uint public activeSlot_ap3 = 1;
    uint public newUserId_ap4 = 1;
    uint public activeSlot_ap4 = 1;
    uint public newUserId_ap5 = 1;
    uint public activeSlot_ap5 = 1;
    uint public newUserId_ap6 = 1;
    uint public activeSlot_ap6 = 1;
    uint public newUserId_ap7 = 1;
    uint public activeSlot_ap7 = 1;
    
    address public owner;
    
    constructor(address _ownerAddress) public {
        
        uplineAmount[1] = 50;
        uplineAmount[2] = 25;
        uplineAmount[3] = 15;
        uplineAmount[4] = 10;
        
        owner = _ownerAddress;
        
        User memory user = User({
            id: newUserId,
            referrerCount: uint(0),
            referrerID: uint(0),
            referrals: new address[](0)
        });
        
        users[_ownerAddress] = user;
        idToAddress[newUserId] = _ownerAddress;
        newUserId++;
        
        //////
        
        UsersPool2 memory user2 = UsersPool2({
            id: newUserId_ap2,
            referrerID: uint(0),
            reinvestCount: uint(0)
        });
        
        users_2[_ownerAddress] = user2;
        
        Pool_2_Slots memory _newslot2 = Pool_2_Slots({
            userAddress: _ownerAddress,
            referrerID: uint(0),
            eventsCount: uint(0)
        });
        
        pool_slots_2[newUserId_ap2] = _newslot2;
        
        newUserId_ap2++;
        
        //////
        
        UsersPool3 memory user3 = UsersPool3({
            id: newUserId_ap3,
            referrerID: uint(0),
            reinvestCount: uint(0)
        });
        
        users_3[_ownerAddress] = user3;
        
        Pool_3_Slots memory _newslot3 = Pool_3_Slots({
            userAddress: _ownerAddress,
            referrerID: uint(0),
            eventsCount: uint(0)
        });
        
        pool_slots_3[newUserId_ap3] = _newslot3;
        
        newUserId_ap3++;
        
        //////
        
        UsersPool4 memory user4 = UsersPool4({
            id: newUserId_ap4,
            referrerID: uint(0),
            reinvestCount: uint(0)
        });
        
        users_4[_ownerAddress] = user4;
        
        Pool_4_Slots memory _newslot4 = Pool_4_Slots({
            userAddress: _ownerAddress,
            referrerID: uint(0),
            eventsCount: uint(0)
        });
        
        pool_slots_4[newUserId_ap4] = _newslot4;
        
        newUserId_ap4++;
        
        //////
        
        UsersPool5 memory user5 = UsersPool5({
            id: newUserId_ap5,
            referrerID: uint(0),
            reinvestCount: uint(0)
        });
        
        users_5[_ownerAddress] = user5;
        
        Pool_5_Slots memory _newslot5 = Pool_5_Slots({
            userAddress: _ownerAddress,
            referrerID: uint(0),
            eventsCount: uint(0)
        });
        
        pool_slots_5[newUserId_ap5] = _newslot5;
        
        newUserId_ap5++;
        
        //////
        
        UsersPool6 memory user6 = UsersPool6({
            id: newUserId_ap6,
            referrerID: uint(0),
            reinvestCount: uint(0)
        });
        
        users_6[_ownerAddress] = user6;
        
        Pool_6_Slots memory _newslot6 = Pool_6_Slots({
            userAddress: _ownerAddress,
            referrerID: uint(0),
            eventsCount: uint(0)
        });
        
        pool_slots_6[newUserId_ap6] = _newslot6;
        
        newUserId_ap6++;
        
        //////
                
        UsersPool7 memory user7 = UsersPool7({
            id: newUserId_ap7,
            referrerID: uint(0),
            reinvestCount: uint(0)
        });
        
        users_7[_ownerAddress] = user7;
        
        Pool_7_Slots memory _newslot7 = Pool_7_Slots({
            userAddress: _ownerAddress,
            referrerID: uint(0),
            eventsCount: uint(0)
        });
        
        pool_slots_7[newUserId_ap7] = _newslot7;
        
        newUserId_ap7++;
        
    }
    
    function participatePool1(uint _referrerId) 
      public 
      payable 
      validReferrerID(_referrerId) 
    {
        
        require(msg.value == 0.1 ether, "Participation fee is 0.1 ETH");
        require(!isUserExists(msg.sender), "User already registered");

        address _userAddress = msg.sender;
        
        uint32 size;
        assembly {
            size := extcodesize(_userAddress)
        }
        require(size == 0, "cannot be a contract");
        
        users[_userAddress] = User({
            id: newUserId,
            referrerCount: uint(0),
            referrerID: _referrerId,
            referrals: new address[](0)
        });
        idToAddress[newUserId] = _userAddress;
        emit RegisterUserEvent(newUserId, msg.sender, idToAddress[_referrerId], now, 2, msg.value);
        
        newUserId++;
        
        users[idToAddress[_referrerId]].referrals.push(_userAddress);
        users[idToAddress[_referrerId]].referrerCount++;
        
        uint amountToDistribute = msg.value;
        address sponsorAddress = idToAddress[_referrerId];        
        
        for (uint32 i = 1; i <= 4; i++) {
            
            if ( isUserExists(sponsorAddress) ) {
                amountToDistribute -= payUpline(sponsorAddress, i);
                address _nextSponsorAddress = idToAddress[users[sponsorAddress].referrerID];
                sponsorAddress = _nextSponsorAddress;
            }
            
        }
        
        if (amountToDistribute > 0) {
            payFirstLine(idToAddress[1], amountToDistribute);
        }
        
    }
    
    function participatePool2() 
      public 
      payable 
    {
        require(msg.value == 0.2 ether, "Participation fee in Autopool is 0.2 ETH");
        require(isUserExists(msg.sender), "User not present in AP1");
        require(isUserQualified(msg.sender), "User not qualified in AP1");
        require(!isUserExists2(msg.sender), "User already registered in AP2");
        
        uint _referrerId = users[msg.sender].referrerID;
        
        UsersPool2 memory user2 = UsersPool2({
            id: newUserId_ap2,
            referrerID: _referrerId,
            reinvestCount: uint(0)
        });
        users_2[msg.sender] = user2;
        
        Pool_2_Slots memory _newslot = Pool_2_Slots({
            userAddress: msg.sender,
            referrerID: _referrerId,
            eventsCount: uint(0)
        });
        
        pool_slots_2[newUserId_ap2] = _newslot;
        emit RegisterUserEvent(newUserId_ap2, msg.sender, idToAddress[_referrerId], now, 2, msg.value);
        
        newUserId_ap2++;
        
        uint eventCount = pool_slots_2[activeSlot_ap2].eventsCount;
        uint newEventCount = eventCount + 1;

        if (newEventCount == 3) {

            Pool_2_Slots memory _reinvestslot = Pool_2_Slots({
                userAddress: pool_slots_2[activeSlot_ap2].userAddress,
                referrerID: pool_slots_2[activeSlot_ap2].referrerID,
                eventsCount: uint(0)
            });
            
            pool_slots_2[newUserId_ap2] = _reinvestslot;
            emit RegisterUserEvent(newUserId_ap2, pool_slots_2[activeSlot_ap2].userAddress, idToAddress[pool_slots_2[activeSlot_ap2].referrerID], now, 2, msg.value);
        
            newUserId_ap2++;
            activeSlot_ap2++;
            
            payUpline(idToAddress[_referrerId], 1);
            
            if (pool_slots_2[activeSlot_ap2].referrerID > 0)
                payUpline(idToAddress[pool_slots_2[activeSlot_ap2].referrerID], 1);
            else 
                payUpline(idToAddress[1], 1);
            
        }
        
        if (eventCount < 3) {
            
            if(eventCount == 0) {
                payUpline(pool_slots_2[activeSlot_ap2].userAddress, 1);
                payUpline(idToAddress[_referrerId], 1);
            }
            if(eventCount == 1) {
                payUpline(idToAddress[_referrerId], 1);
                
                if (pool_slots_2[activeSlot_ap2].referrerID > 0)
                    payUpline(idToAddress[pool_slots_2[activeSlot_ap2].referrerID], 1);
                else 
                    payUpline(idToAddress[1], 1);
            }

            pool_slots_2[activeSlot_ap2].eventsCount++;
            
        }
        
    }
    
    function participatePool3() 
      public 
      payable 
    {
        require(msg.value == 0.3 ether, "Participation fee in Autopool is 0.3 ETH");
        require(isUserExists(msg.sender), "User not present in AP1");
        require(isUserQualified(msg.sender), "User not qualified in AP1");
        require(!isUserExists3(msg.sender), "User already registered in AP3");
        
        uint _referrerId = users[msg.sender].referrerID;
        
        UsersPool3 memory user3 = UsersPool3({
            id: newUserId_ap3,
            referrerID: _referrerId,
            reinvestCount: uint(0)
        });
        users_3[msg.sender] = user3;
        
        Pool_3_Slots memory _newslot = Pool_3_Slots({
            userAddress: msg.sender,
            referrerID: _referrerId,
            eventsCount: uint(0)
        });
        
        pool_slots_3[newUserId_ap3] = _newslot;
        emit RegisterUserEvent(newUserId_ap3, msg.sender, idToAddress[_referrerId], now, 3, msg.value);
        
        newUserId_ap3++;
        
        uint eventCount = pool_slots_3[activeSlot_ap3].eventsCount;
        uint newEventCount = eventCount + 1;

        if (newEventCount == 3) {

            Pool_3_Slots memory _reinvestslot = Pool_3_Slots({
                userAddress: pool_slots_3[activeSlot_ap3].userAddress,
                referrerID: pool_slots_3[activeSlot_ap3].referrerID,
                eventsCount: uint(0)
            });
            
            pool_slots_3[newUserId_ap3] = _reinvestslot;
            emit RegisterUserEvent(newUserId_ap3, pool_slots_3[activeSlot_ap3].userAddress, idToAddress[pool_slots_3[activeSlot_ap3].referrerID], now, 3, msg.value);
        
            newUserId_ap3++;
            activeSlot_ap3++;
            
            payUpline(idToAddress[_referrerId], 1);
            
            if (pool_slots_3[activeSlot_ap3].referrerID > 0)
                payUpline(idToAddress[pool_slots_3[activeSlot_ap3].referrerID], 1);
            else 
                payUpline(idToAddress[1], 1);
            
        }
        
        if (eventCount < 3) {
            
            if(eventCount == 0) {
                payUpline(pool_slots_3[activeSlot_ap3].userAddress, 1);
                payUpline(idToAddress[_referrerId], 1);
            }
            if(eventCount == 1) {
                payUpline(idToAddress[_referrerId], 1);
                
                if (pool_slots_3[activeSlot_ap3].referrerID > 0)
                    payUpline(idToAddress[pool_slots_3[activeSlot_ap3].referrerID], 1);
                else 
                    payUpline(idToAddress[1], 1);
            }

            pool_slots_3[activeSlot_ap3].eventsCount++;
            
        }
        
    }
    
    function participatePool4() 
      public 
      payable 
    {
        require(msg.value == 0.4 ether, "Participation fee in Autopool is 0.4 ETH");
        require(isUserExists(msg.sender), "User not present in AP1");
        require(isUserQualified(msg.sender), "User not qualified in AP1");
        require(!isUserExists4(msg.sender), "User already registered in AP4");
        
        uint _referrerId = users[msg.sender].referrerID;
        
        UsersPool4 memory user4 = UsersPool4({
            id: newUserId_ap4,
            referrerID: _referrerId,
            reinvestCount: uint(0)
        });
        users_4[msg.sender] = user4;
        
        Pool_4_Slots memory _newslot = Pool_4_Slots({
            userAddress: msg.sender,
            referrerID: _referrerId,
            eventsCount: uint(0)
        });
        
        pool_slots_4[newUserId_ap4] = _newslot;
        emit RegisterUserEvent(newUserId_ap4, msg.sender, idToAddress[_referrerId], now, 4, msg.value);
        
        newUserId_ap4++;
        
        uint eventCount = pool_slots_4[activeSlot_ap4].eventsCount;
        uint newEventCount = eventCount + 1;

        if (newEventCount == 3) {

            Pool_4_Slots memory _reinvestslot = Pool_4_Slots({
                userAddress: pool_slots_4[activeSlot_ap4].userAddress,
                referrerID: pool_slots_4[activeSlot_ap4].referrerID,
                eventsCount: uint(0)
            });
            
            pool_slots_4[newUserId_ap4] = _reinvestslot;
            emit RegisterUserEvent(newUserId_ap4, pool_slots_4[activeSlot_ap4].userAddress, idToAddress[pool_slots_4[activeSlot_ap4].referrerID], now, 4, msg.value);
        
            newUserId_ap4++;
            activeSlot_ap4++;
            
            payUpline(idToAddress[_referrerId], 1);
            
            if (pool_slots_4[activeSlot_ap4].referrerID > 0)
                payUpline(idToAddress[pool_slots_4[activeSlot_ap4].referrerID], 1);
            else 
                payUpline(idToAddress[1], 1);
            
        }
        
        if (eventCount < 3) {
            
            if(eventCount == 0) {
                payUpline(pool_slots_4[activeSlot_ap4].userAddress, 1);
                payUpline(idToAddress[_referrerId], 1);
            }
            if(eventCount == 1) {
                payUpline(idToAddress[_referrerId], 1);
                
                if (pool_slots_4[activeSlot_ap4].referrerID > 0)
                    payUpline(idToAddress[pool_slots_4[activeSlot_ap4].referrerID], 1);
                else 
                    payUpline(idToAddress[1], 1);
            }

            pool_slots_4[activeSlot_ap4].eventsCount++;
            
        }
        
    }
    
    function participatePool5() 
      public 
      payable 
    {
        require(msg.value == 0.5 ether, "Participation fee in Autopool is 0.5 ETH");
        require(isUserExists(msg.sender), "User not present in AP1");
        require(isUserQualified(msg.sender), "User not qualified in AP1");
        require(!isUserExists5(msg.sender), "User already registered in AP5");
        
        uint _referrerId = users[msg.sender].referrerID;
        
        UsersPool5 memory user5 = UsersPool5({
            id: newUserId_ap5,
            referrerID: _referrerId,
            reinvestCount: uint(0)
        });
        users_5[msg.sender] = user5;
        
        Pool_5_Slots memory _newslot = Pool_5_Slots({
            userAddress: msg.sender,
            referrerID: _referrerId,
            eventsCount: uint(0)
        });
        
        pool_slots_5[newUserId_ap5] = _newslot;
        emit RegisterUserEvent(newUserId_ap5, msg.sender, idToAddress[_referrerId], now, 5, msg.value);
        
        newUserId_ap5++;
        
        uint eventCount = pool_slots_5[activeSlot_ap5].eventsCount;
        uint newEventCount = eventCount + 1;

        if (newEventCount == 3) {

            Pool_5_Slots memory _reinvestslot = Pool_5_Slots({
                userAddress: pool_slots_5[activeSlot_ap5].userAddress,
                referrerID: pool_slots_5[activeSlot_ap5].referrerID,
                eventsCount: uint(0)
            });
            
            pool_slots_5[newUserId_ap5] = _reinvestslot;
            emit RegisterUserEvent(newUserId_ap5, pool_slots_5[activeSlot_ap5].userAddress, idToAddress[pool_slots_5[activeSlot_ap5].referrerID], now, 5, msg.value);
        
            newUserId_ap5++;
            activeSlot_ap5++;
            
            payUpline(idToAddress[_referrerId], 1);
            
            if (pool_slots_5[activeSlot_ap5].referrerID > 0)
                payUpline(idToAddress[pool_slots_5[activeSlot_ap5].referrerID], 1);
            else 
                payUpline(idToAddress[1], 1);
            
        }
        
        if (eventCount < 3) {
            
            if(eventCount == 0) {
                payUpline(pool_slots_5[activeSlot_ap5].userAddress, 1);
                payUpline(idToAddress[_referrerId], 1);
            }
            if(eventCount == 1) {
                payUpline(idToAddress[_referrerId], 1);
                
                if (pool_slots_5[activeSlot_ap5].referrerID > 0)
                    payUpline(idToAddress[pool_slots_5[activeSlot_ap5].referrerID], 1);
                else 
                    payUpline(idToAddress[1], 1);
            }

            pool_slots_5[activeSlot_ap5].eventsCount++;
            
        }
        
    }
    
    function participatePool6() 
      public 
      payable 
    {
        require(msg.value == 0.7 ether, "Participation fee in Autopool is 0.7 ETH");
        require(isUserExists(msg.sender), "User not present in AP1");
        require(isUserQualified(msg.sender), "User not qualified in AP1");
        require(!isUserExists6(msg.sender), "User already registered in AP6");
        
        uint _referrerId = users[msg.sender].referrerID;
        
        UsersPool6 memory user6 = UsersPool6({
            id: newUserId_ap6,
            referrerID: _referrerId,
            reinvestCount: uint(0)
        });
        users_6[msg.sender] = user6;
        
        Pool_6_Slots memory _newslot = Pool_6_Slots({
            userAddress: msg.sender,
            referrerID: _referrerId,
            eventsCount: uint(0)
        });
        
        pool_slots_6[newUserId_ap6] = _newslot;
        emit RegisterUserEvent(newUserId_ap6, msg.sender, idToAddress[_referrerId], now, 6, msg.value);
        
        newUserId_ap6++;
        
        uint eventCount = pool_slots_6[activeSlot_ap6].eventsCount;
        uint newEventCount = eventCount + 1;

        if (newEventCount == 3) {

            Pool_6_Slots memory _reinvestslot = Pool_6_Slots({
                userAddress: pool_slots_6[activeSlot_ap6].userAddress,
                referrerID: pool_slots_6[activeSlot_ap6].referrerID,
                eventsCount: uint(0)
            });
            
            pool_slots_6[newUserId_ap6] = _reinvestslot;
            emit RegisterUserEvent(newUserId_ap6, pool_slots_6[activeSlot_ap6].userAddress, idToAddress[pool_slots_6[activeSlot_ap6].referrerID], now, 6, msg.value);
        
            newUserId_ap6++;
            activeSlot_ap6++;
            
            payUpline(idToAddress[_referrerId], 1);
            
            if (pool_slots_6[activeSlot_ap6].referrerID > 0)
                payUpline(idToAddress[pool_slots_6[activeSlot_ap6].referrerID], 1);
            else 
                payUpline(idToAddress[1], 1);
            
        }
        
        if (eventCount < 3) {
            
            if(eventCount == 0) {
                payUpline(pool_slots_6[activeSlot_ap6].userAddress, 1);
                payUpline(idToAddress[_referrerId], 1);
            }
            if(eventCount == 1) {
                payUpline(idToAddress[_referrerId], 1);
                
                if (pool_slots_6[activeSlot_ap6].referrerID > 0)
                    payUpline(idToAddress[pool_slots_6[activeSlot_ap6].referrerID], 1);
                else 
                    payUpline(idToAddress[1], 1);
            }

            pool_slots_6[activeSlot_ap6].eventsCount++;
            
        }
        
    }
    
    function participatePool7() 
      public 
      payable 
    {
        require(msg.value == 1 ether, "Participation fee in Autopool is 1 ETH");
        require(isUserExists(msg.sender), "User not present in AP1");
        require(isUserQualified(msg.sender), "User not qualified in AP1");
        require(!isUserExists7(msg.sender), "User already registered in AP7");
        
        uint _referrerId = users[msg.sender].referrerID;
        
        UsersPool7 memory user7 = UsersPool7({
            id: newUserId_ap7,
            referrerID: _referrerId,
            reinvestCount: uint(0)
        });
        users_7[msg.sender] = user7;
        
        Pool_7_Slots memory _newslot = Pool_7_Slots({
            userAddress: msg.sender,
            referrerID: _referrerId,
            eventsCount: uint(0)
        });
        
        pool_slots_7[newUserId_ap7] = _newslot;
        emit RegisterUserEvent(newUserId_ap7, msg.sender, idToAddress[_referrerId], now, 7, msg.value);
        
        newUserId_ap7++;
        
        uint eventCount = pool_slots_7[activeSlot_ap7].eventsCount;
        uint newEventCount = eventCount + 1;

        if (newEventCount == 3) {

            Pool_7_Slots memory _reinvestslot = Pool_7_Slots({
                userAddress: pool_slots_7[activeSlot_ap7].userAddress,
                referrerID: pool_slots_7[activeSlot_ap7].referrerID,
                eventsCount: uint(0)
            });
            
            pool_slots_7[newUserId_ap7] = _reinvestslot;
            emit RegisterUserEvent(newUserId_ap7, pool_slots_7[activeSlot_ap7].userAddress, idToAddress[pool_slots_7[activeSlot_ap7].referrerID], now, 7, msg.value);
        
            newUserId_ap7++;
            activeSlot_ap7++;
            
            payUpline(idToAddress[_referrerId], 1);
            
            if (pool_slots_7[activeSlot_ap7].referrerID > 0)
                payUpline(idToAddress[pool_slots_7[activeSlot_ap7].referrerID], 1);
            else 
                payUpline(idToAddress[1], 1);
            
        }
        
        if (eventCount < 3) {
            
            if(eventCount == 0) {
                payUpline(pool_slots_7[activeSlot_ap7].userAddress, 1);
                payUpline(idToAddress[_referrerId], 1);
            }
            if(eventCount == 1) {
                payUpline(idToAddress[_referrerId], 1);
                
                if (pool_slots_7[activeSlot_ap7].referrerID > 0)
                    payUpline(idToAddress[pool_slots_7[activeSlot_ap7].referrerID], 1);
                else 
                    payUpline(idToAddress[1], 1);
            }

            pool_slots_7[activeSlot_ap7].eventsCount++;
            
        }
        
    }
    
    
    function payUpline(address _sponsorAddress, uint _refLevel) private returns (uint distributeAmount) {
        
        require( _refLevel <= 4);
        distributeAmount = msg.value / 100 * uplineAmount[_refLevel];
        if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
            balances[_sponsorAddress] += distributeAmount;
            emit DistributeUplineEvent(distributeAmount, _sponsorAddress, _refLevel, now);
        }
        
        return distributeAmount;

    }
    
    function payFirstLine(address _sponsorAddress, uint payAmount) private returns (uint distributeAmount) {
        
        distributeAmount = payAmount;
        if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
            balances[_sponsorAddress] += distributeAmount;
            emit DistributeUplineEvent(distributeAmount, _sponsorAddress, 1, now);
        }
        
        return distributeAmount;
        
    }
    
    function isUserQualified(address _userAddress) public view returns (bool) {
        return (users[_userAddress].referrerCount > 0);
    }
    
    function isUserExists(address _userAddress) public view returns (bool) {
        return (users[_userAddress].id != 0);
    }
    
    function isUserExists2(address _userAddress) public view returns (bool) {
        return (users_2[_userAddress].id != 0);
    }
    
    function isUserExists3(address _userAddress) public view returns (bool) {
        return (users_3[_userAddress].id != 0);
    }
    
    function isUserExists4(address _userAddress) public view returns (bool) {
        return (users_4[_userAddress].id != 0);
    }
    
    function isUserExists5(address _userAddress) public view returns (bool) {
        return (users_5[_userAddress].id != 0);
    }
    
    function isUserExists6(address _userAddress) public view returns (bool) {
        return (users_6[_userAddress].id != 0);
    }
    
    function isUserExists7(address _userAddress) public view returns (bool) {
        return (users_7[_userAddress].id != 0);
    }
    
    function getUserReferrals(address _userAddress)
        public
        view
        returns (address[] memory)
      {
        return users[_userAddress].referrals;
      }
    
}