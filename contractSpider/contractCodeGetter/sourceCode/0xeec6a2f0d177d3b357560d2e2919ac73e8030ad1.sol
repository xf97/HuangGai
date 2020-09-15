/**
 *Submitted for verification at Etherscan.io on 2020-07-02
*/

//TrustSmartContract

pragma solidity ^0.5.7;


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

  address payable public owner;
  address public manager;
  address payable public ownerWallet;

  constructor() public {
    owner = msg.sender;
    manager = msg.sender;
    ownerWallet = 0xA52d80ff42d76087dA694753c2BD092b25FCdD90;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "only for owner");
    _;
  }

  modifier onlyOwnerOrManager() {
     require((msg.sender == owner)||(msg.sender == manager), "only for owner or manager");
      _;
  }

  function transferOwnership(address payable newOwner) public onlyOwner {
    owner = newOwner;
  }

  function setManager(address _manager) public onlyOwnerOrManager {
      manager = _manager;
  }
}

contract TrustSmartContract is Ownable {

    event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
    event buyLevelEvent(address indexed _user, uint _level, uint _time);
    event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
    event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
    event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
    //------------------------------

    mapping (uint => uint) public LEVEL_PRICE;
    mapping (uint => uint)  LEVEL_DURATION;
    uint REFERRER_1_LEVEL_LIMIT = 3;
    uint PERIOD_LENGTH = 365 days;
    uint256 public totalEth;
    uint[7] personsPerLevel;
    mapping (address => uint256) personalIncome;
    
    


    struct UserStruct {
        bool isExist;
        uint id;
        uint referrerID;
        address[] referral;
        mapping (uint => uint) levelExpired;
    }

    mapping (address => UserStruct) public users;
    mapping (uint => address) public userList;
    uint public currUserID = 0;




    constructor() public {

        LEVEL_PRICE[1] = 0.05 ether;
        LEVEL_PRICE[2] = 0.10 ether;
        LEVEL_PRICE[3] = 0.30 ether;
        LEVEL_PRICE[4] = 1 ether;
        LEVEL_PRICE[5] = 3 ether;
        LEVEL_PRICE[6] = 5 ether;
        
        LEVEL_DURATION[1] = 25 days;
        LEVEL_DURATION[2] = 35 days;
        LEVEL_DURATION[3] = 45 days;
        LEVEL_DURATION[4] = 55 days;
        LEVEL_DURATION[5] = 65 days;
        LEVEL_DURATION[6] = 100 days;

        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist : true,
            id : currUserID,
            referrerID : 0,
            referral : new address[](0)
        });
        users[ownerWallet] = userStruct;
        userList[currUserID] = ownerWallet;

        users[ownerWallet].levelExpired[1] = 77777777777;
        users[ownerWallet].levelExpired[2] = 77777777777;
        users[ownerWallet].levelExpired[3] = 77777777777;
        users[ownerWallet].levelExpired[4] = 77777777777;
        users[ownerWallet].levelExpired[5] = 77777777777;
        users[ownerWallet].levelExpired[6] = 77777777777;
    }

    function () external payable {

        uint level;

        if(msg.value == LEVEL_PRICE[1]){
            level = 1;
        }else if(msg.value == LEVEL_PRICE[2]){
            level = 2;
        }else if(msg.value == LEVEL_PRICE[3]){
            level = 3;
        }else if(msg.value == LEVEL_PRICE[4]){
            level = 4;
        }else if(msg.value == LEVEL_PRICE[5]){
            level = 5;
        }else if(msg.value == LEVEL_PRICE[6]){
            level = 6;
        }else if(msg.value == LEVEL_PRICE[7]){
            level = 7;
        }else if(msg.value == LEVEL_PRICE[8]){
            level = 8;
        }else {
            revert('Incorrect Value send');
        }

        if(users[msg.sender].isExist){      //if user exixts buy level else register user
            buyLevel(level);
        } else if(level == 1) {
            uint refId = 0;
            address referrer = bytesToAddress(msg.data);

            if (users[referrer].isExist){   //check valid refferer id
                refId = users[referrer].id;
            } else {
                revert('Incorrect referrer');
            }

            regUser(refId);
        } else {
            revert("Please buy first level for 0.05 ETH");
        }
    }

    function regUser(uint _referrerID) public payable {
        require(!users[msg.sender].isExist, 'User exist');

        require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');

        require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');


        if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT)  //if evel limit reached find free referer on upline
        {
            _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
        }


        UserStruct memory userStruct;       //register new user
        currUserID++;

        userStruct = UserStruct({
            isExist : true,
            id : currUserID,
            referrerID : _referrerID,
            referral : new address[](0)
        });

        users[msg.sender] = userStruct;
        userList[currUserID] = msg.sender;

        users[msg.sender].levelExpired[1] = now + LEVEL_DURATION[1];
        users[msg.sender].levelExpired[2] = 0;
        users[msg.sender].levelExpired[3] = 0;
        users[msg.sender].levelExpired[4] = 0;
        users[msg.sender].levelExpired[5] = 0;
        users[msg.sender].levelExpired[6] = 0;

        users[userList[_referrerID]].referral.push(msg.sender);

        payForLevel(1, msg.sender);
        
        personsPerLevel[1]++;

        emit regLevelEvent(msg.sender, userList[_referrerID], now);
    }

    function buyLevel(uint _level) public payable {
        require(users[msg.sender].isExist, 'User not exist');

        require( _level>0 && _level <= 8, 'Incorrect level');

        if(_level == 1){
            require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
            users[msg.sender].levelExpired[1] += LEVEL_DURATION[1];
            personsPerLevel[1]++;
        } else {
            require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');

            for(uint l =_level-1; l>0; l-- ){
                require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
            }

            if(users[msg.sender].levelExpired[_level] == 0){
                users[msg.sender].levelExpired[_level] = now + LEVEL_DURATION[_level];
                personsPerLevel[_level]++;
            } else {
                users[msg.sender].levelExpired[_level] += LEVEL_DURATION[_level];
                personsPerLevel[_level]++;
            }
        }
        payForLevel(_level, msg.sender);
        emit buyLevelEvent(msg.sender, _level, now);
    }
    
    function payForLevel(uint _level, address _user) internal {
        
        address referrer = getUserReferrer(_user, _level);

        if(!users[referrer].isExist){
            referrer = userList[1];
        }

        if(users[referrer].levelExpired[_level] >= now ){
            
            totalEth += msg.value;
            
            require(ownerWallet.send(0.01 ether),"unable to transfer admin share");
            require(address(uint160(referrer)).send((LEVEL_PRICE[_level] - 0.01 ether)),"unable to transfer to upline after admin");
            personalIncome[referrer] += LEVEL_PRICE[_level] - 0.01 ether;
            emit getMoneyForLevelEvent(referrer, msg.sender, _level, now);
        } else {
            emit lostMoneyForLevelEvent(referrer, msg.sender, _level, now);
            payForLevel(_level,referrer);
        }
    }
    
    function getUserReferrer(address _user, uint _level) public view returns (address) {
      if (_level == 0 || _user == address(0)) {
        return _user;
      }

      return this.getUserReferrer(userList[users[_user].referrerID], _level - 1);
    }

    function findFreeReferrer(address _user) public view returns(address) {
        if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT){
            return _user;
        }

        address[] memory referrals = new address[](2045);
        referrals[0] = users[_user].referral[0]; 
        referrals[1] = users[_user].referral[1];
        referrals[2] = users[_user].referral[2];

        address freeReferrer;
        bool noFreeReferrer = true;

        for(uint i =0; i<2045;i++){
            if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT){
                if(i<1021){
                    referrals[(i+1)*3] = users[referrals[i]].referral[0];
                    referrals[(i+1)*3+1] = users[referrals[i]].referral[1];
                    referrals[(i+1)*3+2] = users[referrals[i]].referral[2];
                }
            }else{
                if(users[referrals[i]].referral.length>0){
                    noFreeReferrer = false;
                    freeReferrer = referrals[i];
                    break;   
                }
            }
        }
        if(noFreeReferrer){
            return findFreeReferrer(userList[1]);
        }
        require(!noFreeReferrer, 'No Free Referrer');
        return freeReferrer;

    }

    function viewUserReferral(address _user) public view returns(address[] memory) {
        return users[_user].referral;
    }
    
    function viewPersonsPerLevel() public view returns(uint[7] memory) {
        return personsPerLevel;
    }

    function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
        return users[_user].levelExpired[_level];
    }
    function viewPersonalIncome(address _user) public view returns(uint) {
        return personalIncome[_user];
    }
    
    function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
}