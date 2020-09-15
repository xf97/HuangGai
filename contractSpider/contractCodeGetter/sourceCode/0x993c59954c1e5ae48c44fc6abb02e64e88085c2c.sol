pragma solidity 0.5.14;
import "./DappToken.sol";
contract XProtocal {
    using SafeMath for uint256;
    struct UserStruct {
        uint id;
        uint orignalRefID;
        uint referrerID;
        uint currentLevel;
        uint totalEarningEth;
        address[] referral;
    }
    struct LevelStruct {
        uint ethValue;
        uint tokenValue;
        uint tokenOrignalValue;
    }
    address public ownerAddress;
    uint public adminFee = 15 ether;
    uint public currentId = 0;
    uint referrer1Limit = 2;
    bool public lockStatus;
    bytes32 private secretPhase;
    XProtocalToken Token;
    mapping (uint => LevelStruct) public LEVEL_PRICE;
    mapping (address => UserStruct) public users;
    mapping (uint => address) public userList;
    mapping (address => mapping (uint => uint)) public EarnedEth;
    mapping (address => uint) public loopCheck;
    mapping (address => uint) public createdDate;
    event regLevelEvent(address indexed UserAddress, uint indexed UserId, uint Time);
    event buyLevelEvent(address indexed UserAddress, uint Levelno, uint Time);
    event getMoneyForLevelEvent(address indexed UserAddress, uint UserId, address indexed ReferrerAddress, uint ReferrerId, uint Levelno, uint orignalRefID, uint Time);
    event lostMoneyForLevelEvent(address indexed UserAddress, uint UserId, address indexed ReferrerAddress, uint ReferrerId, uint Levelno, uint LevelPrice, uint Time);    
    constructor(XProtocalToken _tokkenAddress, bytes32 _secretPhase) public {
        ownerAddress = msg.sender;
        secretPhase = _secretPhase;
        Token = _tokkenAddress;
        LEVEL_PRICE[1] = LevelStruct({
            ethValue: 0.1 ether,
            tokenOrignalValue: 2,
            tokenValue: 10
        });
        LEVEL_PRICE[2] = LevelStruct({
            ethValue: 0.15 ether,
            tokenOrignalValue: 3,
            tokenValue: 15
        });
        LEVEL_PRICE[3] = LevelStruct({
            ethValue: 0.5 ether,
            tokenOrignalValue: 10,
            tokenValue: 50
        });
        LEVEL_PRICE[4] = LevelStruct({
            ethValue: 3 ether,
            tokenOrignalValue: 120,
            tokenValue: 600
        });
        LEVEL_PRICE[5] = LevelStruct({
            ethValue: 5 ether,
            tokenOrignalValue: 200,
            tokenValue: 1000
        });
        LEVEL_PRICE[6] = LevelStruct({
            ethValue: 10 ether,
            tokenOrignalValue: 400,
            tokenValue: 2000
        });
        LEVEL_PRICE[7] = LevelStruct({
            ethValue: 22 ether,
            tokenOrignalValue: 1320,
            tokenValue: 6600
        });
        LEVEL_PRICE[8] = LevelStruct({
            ethValue: 28 ether,
            tokenOrignalValue: 1680,
            tokenValue: 8400
        });
        LEVEL_PRICE[9] = LevelStruct({
            ethValue: 36 ether,
            tokenOrignalValue: 2160,
            tokenValue: 10800
        });
        UserStruct memory userStruct;
        currentId = currentId.add(1);
        userStruct = UserStruct({
            id: currentId,
            orignalRefID: 1,
            referrerID: 0,
            currentLevel:1,
            totalEarningEth:0,
            referral: new address[](0)
        });
        users[ownerAddress] = userStruct;
        userList[currentId] = ownerAddress;
        users[ownerAddress].currentLevel = 9;
    } 
    modifier onlyOwner() {
        require(msg.sender == ownerAddress, "Only owner");
        _;
    }
    function regUser(uint _referrerID, uint _orignalRef) external payable {
        require(lockStatus == false, "Contract Locked");
        require(users[msg.sender].id == 0, "User exist");
        require(_referrerID <= currentId, "Incorrect parentID Id");
        require(_orignalRef <= currentId, "Incorrect referrer Id");
        require(msg.value == LEVEL_PRICE[1].ethValue, "Incorrect Value");
        require(users[userList[_referrerID]].referral.length  < referrer1Limit, "User already have 2 childs");
        UserStruct memory userStruct;
        currentId = currentId.add(1);
        userStruct = UserStruct({
            id: currentId,
            referrerID: _referrerID,
            currentLevel: 1,
            orignalRefID: _orignalRef,
            totalEarningEth:0,
            referral: new address[](0)
        });
        users[msg.sender] = userStruct;
        userList[currentId] = msg.sender;
        users[userList[_referrerID]].referral.push(msg.sender);
        loopCheck[msg.sender] = 0;
        createdDate[msg.sender] = now;
        loopCheck[msg.sender] = 0;
        payForLevel(true, 1, msg.sender, ((LEVEL_PRICE[1].ethValue.mul(adminFee)).div(10**20)));
        emit regLevelEvent(msg.sender, currentId, now);
        Token.mint(msg.sender, LEVEL_PRICE[1].tokenValue, secretPhase);
        Token.mint(userList[_orignalRef], LEVEL_PRICE[1].tokenOrignalValue, secretPhase);
    }
    function buyLevel(uint256 _level) external payable {
        require(lockStatus == false, "Contract Locked");
        require(users[msg.sender].id != 0, "User not exist"); 
        require(_level > 0 && _level <= 9, "Incorrect level");
        require(msg.value == LEVEL_PRICE[_level].ethValue, "Incorrect Value");
        if (_level == 1) {
            users[msg.sender].currentLevel = 1;
        } else {
            if(users[msg.sender].currentLevel + 1 != _level) {
                require(users[msg.sender].currentLevel + 1 == _level, "Buy the previous level");
            }
            users[msg.sender].currentLevel = _level;
        }
        loopCheck[msg.sender] = 0;
        payForLevel(true, _level, msg.sender, ((LEVEL_PRICE[_level].ethValue.mul(adminFee)).div(10**20)));
        emit buyLevelEvent(msg.sender, _level, now);
        Token.mint(msg.sender, LEVEL_PRICE[_level].tokenValue, secretPhase);
        Token.mint(userList[users[msg.sender].orignalRefID], LEVEL_PRICE[_level].tokenOrignalValue, secretPhase);
    }
    function payForLevel(bool _isNew, uint _level, address _userAddress, uint _adminPrice) internal {
            address referer;
            if(_isNew) {
                if (_level == 1 || _level == 4 || _level == 7) {
                    referer = userList[users[_userAddress].referrerID];
                } else if (_level == 2 || _level == 5 || _level == 8) {
                    referer = userList[users[_userAddress].referrerID];
                    referer = userList[users[referer].referrerID];
                } else if (_level == 3 || _level == 6 || _level == 9) {
                    referer = userList[users[_userAddress].referrerID];
                    referer = userList[users[referer].referrerID];
                    referer = userList[users[referer].referrerID];
                }
            } else {
                referer = userList[users[_userAddress].referrerID];
            }
            if (loopCheck[msg.sender] >= 9) {
                referer = userList[1];
            }
            if (users[referer].currentLevel >= _level) {
                require((address(uint160(referer)).send(LEVEL_PRICE[_level].ethValue.sub(_adminPrice))) && 
                    (address(uint160(ownerAddress)).send(_adminPrice)));
                users[referer].totalEarningEth = users[referer].totalEarningEth.add(LEVEL_PRICE[_level].ethValue);
                EarnedEth[referer][_level] = EarnedEth[referer][_level].add(LEVEL_PRICE[_level].ethValue);
                emit getMoneyForLevelEvent(msg.sender, users[msg.sender].id, referer, users[referer].id, _level, users[msg.sender].orignalRefID, now);
        } else {
            if (loopCheck[msg.sender] < 9) {
                loopCheck[msg.sender] = loopCheck[msg.sender].add(1);
                emit lostMoneyForLevelEvent(msg.sender, users[msg.sender].id, referer, users[referer].id, _level, LEVEL_PRICE[_level].ethValue ,now);
                payForLevel(false, _level, referer, _adminPrice);
            }
        }
    }
    function viewUserReferral(address _userAddress) external view returns (address[] memory) {
        return users[_userAddress].referral;
    }
    function contractLock(bool _lockStatus) public onlyOwner returns (bool) {
        lockStatus = _lockStatus;
        return true;
    }
    function updateFeePercentage(uint256 _adminFee) public onlyOwner returns (bool) {
        adminFee = _adminFee.mul(10**18);
        return true;  
    }
    function failSafe(address payable _toUser, uint _amount) public onlyOwner returns (bool) {
        require(_toUser != address(0), "Invalid Address");
        require(address(this).balance >= _amount, "Insufficient balance");
        (_toUser).transfer(_amount);
        return true;
    }
    function () external payable {
        revert("Invalid Transaction");
    }
}