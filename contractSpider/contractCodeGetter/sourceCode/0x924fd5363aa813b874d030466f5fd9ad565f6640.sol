/**
 *Submitted for verification at Etherscan.io on 2020-08-16
*/

/**
 * Nemezida
 * https://nemezida.io/
 * 
 * telegram: https://t.me/nemezida_official
 */

pragma solidity ^0.5.11;

contract Nemezida {
    address public creator;
    uint public currentUserID;

    mapping(uint => uint) public levelPrice;
    mapping(address => User) public users;
    mapping(uint => address) public userAddresses;

    uint MAX_LEVEL = 6;
    uint REFERRALS_LIMIT = 2;

    uint LAST_PERSON_ROW_1 = 3;
    uint LAST_PERSON_ROW_2 = 7;
    uint LAST_PERSON_ROW_3 = 15;
    uint LAST_PERSON_ROW_4 = 31;
    uint LAST_PERSON_ROW_5 = 63;
    uint LAST_PERSON_ROW_6 = 127;
    uint LAST_PERSON_ROW_7 = 255;
    uint LAST_PERSON_ROW_8 = 511;
    uint LAST_PERSON_ROW_9 = 1023;
    uint LAST_PERSON_ROW_10 = 2047;
    uint LAST_PERSON_ROW_11 = 4095;
    uint LAST_PERSON_ROW_12 = 8191;
    uint LAST_PERSON_ROW_13 = 16383;
    uint LAST_PERSON_ROW_14 = 32767;
    uint LAST_PERSON_ROW_15 = 65535;
    uint LAST_PERSON_ROW_16 = 131071;
    uint LAST_PERSON_ROW_17 = 262143;
    uint LAST_PERSON_ROW_18 = 524287;
    uint LAST_PERSON_ROW_19 = 1048575;
    uint LAST_PERSON_ROW_20 = 2097151;
    uint LAST_PERSON_ROW_21 = 4194303;
    uint LAST_PERSON_ROW_22 = 8388607;
    uint LAST_PERSON_ROW_23 = 16777215;
    uint LAST_PERSON_ROW_24 = 33554431;
    uint LAST_PERSON_ROW_25 = 67108863;
    uint LAST_PERSON_ROW_26 = 134217727;
    uint LAST_PERSON_ROW_27 = 268435455;
    uint LAST_PERSON_ROW_28 = 536870911;
    uint LAST_PERSON_ROW_29 = 1073741823;
    uint LAST_PERSON_ROW_30 = 2147483647;

    uint defaultPercent;
    uint firstPercent;
    uint secondPercent;
    uint thirdPercent;
    uint fourthPercent;
    uint fifthPercent;

    struct User {
        uint id;
        uint referrerID;
        uint firstReferrerID;
        uint secondReferrerID;
        uint thirdReferrerID;
        uint fourthReferrerID;
        uint fifthReferrerID;
        address[] referrals;
        address[] firstReferrals;
        address[] secondReferrals;
        address[] thirdReferrals;
        address[] fourthReferrals;
        address[] fifthReferrals;
        mapping(uint => bool) levelActivity;
    }

    event RegisterUserEvent(address indexed user, address indexed referrer, uint time);
    event BuyLevelEvent(address indexed user, uint indexed level, uint time);
    event GetLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
    event GetLevelProfitEventFirst(address indexed user, address indexed referral, uint indexed level, uint time);
    event GetLevelProfitEventSecond(address indexed user, address indexed referral, uint indexed level, uint time);
    event GetLevelProfitEventThird(address indexed user, address indexed referral, uint indexed level, uint time);
    event GetLevelProfitEventFourth(address indexed user, address indexed referral, uint indexed level, uint time);
    event GetLevelProfitEventFifth(address indexed user, address indexed referral, uint indexed level, uint time);
    event LostLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
    event ResetLevelsEvent(address indexed user, uint time);

    modifier userNotRegistered() {
        require(users[msg.sender].id == 0, 'User is already registered');
        _;
    }

    modifier userRegistered() {
        require(users[msg.sender].id != 0, 'User does not exist');
        _;
    }

    modifier validReferrerID(uint _referrerID) {
        require(_referrerID > 0 && _referrerID <= currentUserID, 'Invalid referrer ID');
        _;
    }

    modifier validLevel(uint _level) {
        require(_level > 0 && _level <= MAX_LEVEL, 'Invalid level');
        _;
    }

    modifier validLevelAmount(uint _level) {
        require(msg.value == levelPrice[_level], 'Invalid level amount');
        _;
    }

    constructor() public {
        levelPrice[1] = 0.1 ether;
        levelPrice[2] = 0.15 ether;
        levelPrice[3] = 0.3 ether;
        levelPrice[4] = 0.5 ether;
        levelPrice[5] = 2 ether;
        levelPrice[6] = 10 ether;

        defaultPercent = 80;
        firstPercent = 8;
        secondPercent = 5;
        thirdPercent = 3;
        fourthPercent = 2;
        fifthPercent = 2;

        currentUserID++;

        creator = msg.sender;

        users[creator] = createNewUser(0, 1, 1, 1, 1, 1);
        userAddresses[currentUserID] = creator;

        for (uint i = 1; i <= MAX_LEVEL; i++) {
            users[creator].levelActivity[i] = true;
        }
    }

    function() external payable {
        uint level;

        for (uint i = 1; i <= MAX_LEVEL; i++) {
            if (msg.value == levelPrice[i]) {
                level = i;
                break;
            }
        }

        require(level > 0, 'Invalid amount has sent');

        if (users[msg.sender].id != 0) {
            buyLevel(level);
            return;
        }

        if (level != 1) {
            revert('Buy first level for 0.1 ETH');
        }

        address referrer = bytesToAddress(msg.data);
        if (referrer == address(0)) {
            registerUser(1);
        } else {
            registerUser(users[referrer].id);
        }
    }

    function registerUser(uint _referrerID) public payable userNotRegistered() validReferrerID(_referrerID) validLevelAmount(1) {
        uint firstReferrerID = _referrerID;
        uint secondReferrerID = users[userAddresses[firstReferrerID]].firstReferrerID;
        uint thirdReferrerID = users[userAddresses[firstReferrerID]].secondReferrerID;
        uint fourthReferrerID = users[userAddresses[firstReferrerID]].thirdReferrerID;
        uint fifthReferrerID = users[userAddresses[firstReferrerID]].fourthReferrerID;

        _referrerID = users[findReferrer(creator)].id;

        currentUserID++;

        users[msg.sender] = createNewUser(_referrerID, firstReferrerID, secondReferrerID, thirdReferrerID, fourthReferrerID, fifthReferrerID);

        userAddresses[currentUserID] = msg.sender;
        users[msg.sender].levelActivity[1] = true;

        users[userAddresses[_referrerID]].referrals.push(msg.sender);

        users[userAddresses[firstReferrerID]].firstReferrals.push(msg.sender);
        users[userAddresses[secondReferrerID]].secondReferrals.push(msg.sender);
        users[userAddresses[thirdReferrerID]].thirdReferrals.push(msg.sender);

        transferLevelPayment(1, msg.sender, 1);
        transferLevelPaymentFirst(1, msg.sender);
        transferLevelPaymentSecond(1, msg.sender);
        transferLevelPaymentThird(1, msg.sender);
        transferLevelPaymentFourth(1, msg.sender);
        transferLevelPaymentFifth(1, msg.sender);

        emit RegisterUserEvent(msg.sender, userAddresses[_referrerID], now);

        if (currentUserID == LAST_PERSON_ROW_5) {
            resetLevels(2, LAST_PERSON_ROW_1);
        } else if (currentUserID == LAST_PERSON_ROW_6) {
            resetLevels(2, LAST_PERSON_ROW_2);
        } else if (currentUserID == LAST_PERSON_ROW_7) {
            resetLevels(2, LAST_PERSON_ROW_3);
        } else if (currentUserID == LAST_PERSON_ROW_8) {
            resetLevels(2, LAST_PERSON_ROW_4);
        } else if (currentUserID == LAST_PERSON_ROW_9) {
            resetLevels(2, LAST_PERSON_ROW_5);
        } else if (currentUserID == LAST_PERSON_ROW_10) {
            resetLevels(2, LAST_PERSON_ROW_6);
        } else if (currentUserID == LAST_PERSON_ROW_11) {
            resetLevels(2, LAST_PERSON_ROW_7);
        } else if (currentUserID == LAST_PERSON_ROW_12) {
            resetLevels(2, LAST_PERSON_ROW_8);
        } else if (currentUserID == LAST_PERSON_ROW_13) {
            resetLevels(2, LAST_PERSON_ROW_9);
        } else if (currentUserID == LAST_PERSON_ROW_14) {
            resetLevels(2, LAST_PERSON_ROW_10);
        } else if (currentUserID == LAST_PERSON_ROW_15) {
            resetLevels(2, LAST_PERSON_ROW_11);
        } else if (currentUserID == LAST_PERSON_ROW_16) {
            resetLevels(2, LAST_PERSON_ROW_12);
        } else if (currentUserID == LAST_PERSON_ROW_17) {
            resetLevels(2, LAST_PERSON_ROW_13);
        } else if (currentUserID == LAST_PERSON_ROW_18) {
            resetLevels(2, LAST_PERSON_ROW_14);
        } else if (currentUserID == LAST_PERSON_ROW_19) {
            resetLevels(2, LAST_PERSON_ROW_15);
        } else if (currentUserID == LAST_PERSON_ROW_20) {
            resetLevels(2, LAST_PERSON_ROW_16);
        } else if (currentUserID == LAST_PERSON_ROW_21) {
            resetLevels(2, LAST_PERSON_ROW_17);
        } else if (currentUserID == LAST_PERSON_ROW_22) {
            resetLevels(2, LAST_PERSON_ROW_18);
        } else if (currentUserID == LAST_PERSON_ROW_23) {
            resetLevels(2, LAST_PERSON_ROW_19);
        } else if (currentUserID == LAST_PERSON_ROW_24) {
            resetLevels(2, LAST_PERSON_ROW_20);
        } else if (currentUserID == LAST_PERSON_ROW_25) {
            resetLevels(2, LAST_PERSON_ROW_21);
        } else if (currentUserID == LAST_PERSON_ROW_26) {
            resetLevels(2, LAST_PERSON_ROW_22);
        } else if (currentUserID == LAST_PERSON_ROW_27) {
            resetLevels(2, LAST_PERSON_ROW_23);
        } else if (currentUserID == LAST_PERSON_ROW_28) {
            resetLevels(2, LAST_PERSON_ROW_24);
        } else if (currentUserID == LAST_PERSON_ROW_29) {
            resetLevels(2, LAST_PERSON_ROW_25);
        } else if (currentUserID == LAST_PERSON_ROW_30) {
            resetLevels(2, LAST_PERSON_ROW_26);
        }
    }

    function buyLevel(uint _level) public payable userRegistered() validLevel(_level) validLevelAmount(_level) {
        for (uint l = _level - 1; l > 0; l--) {
            require(getUserLevelActivity(msg.sender, l), 'Buy the previous level');
        }

        require(!getUserLevelActivity(msg.sender, _level), 'User has already activated level');

        users[msg.sender].levelActivity[_level] = true;

        transferLevelPayment(_level, msg.sender, _level);
        transferLevelPaymentFirst(_level, msg.sender);
        transferLevelPaymentSecond(_level, msg.sender);
        transferLevelPaymentThird(_level, msg.sender);
        transferLevelPaymentFourth(_level, msg.sender);
        transferLevelPaymentFifth(_level, msg.sender);

        emit BuyLevelEvent(msg.sender, _level, now);
    }

    function resetLevels(uint startId, uint endId) internal {
        for (uint i = startId; i <= endId; i++) {
            for (uint level = 1; level <= MAX_LEVEL; level++) {
                users[userAddresses[i]].levelActivity[level] = false;
                emit ResetLevelsEvent(userAddresses[i], now);
            }
        }
    }

    function findReferrer(address _user) public view returns (address) {
        if (users[_user].referrals.length < REFERRALS_LIMIT) {
            return _user;
        }

        address[33554432] memory referrals;
        referrals[0] = users[_user].referrals[0];
        referrals[1] = users[_user].referrals[1];

        address referrer;

        for (uint i = 0; i < 33554432; i++) {
            if (users[referrals[i]].referrals.length < REFERRALS_LIMIT) {
                referrer = referrals[i];
                break;
            }

            if (i >= 512) {
                continue;
            }

            referrals[(i + 1) * 2] = users[referrals[i]].referrals[0];
            referrals[(i + 1) * 2 + 1] = users[referrals[i]].referrals[1];
        }

        require(referrer != address(0), 'Referrer was not found');

        return referrer;
    }

    function transferLevelPayment(uint _level, address _user, uint height) internal {
        address referrer = getUserUpline(_user, height);

        if (referrer == address(0)) {
            referrer = creator;
        }

        if (!getUserLevelActivity(referrer, _level)) {
            emit LostLevelProfitEvent(referrer, msg.sender, _level, now);
            transferLevelPayment(_level, referrer, 1);
            return;
        }

        if (addressToPayable(referrer).send(msg.value / 100 * defaultPercent)) {
            emit GetLevelProfitEvent(referrer, msg.sender, _level, now);
        }
    }

    function transferLevelPaymentFirst(uint _level, address _user) internal {
        address referrer = userAddresses[users[_user].firstReferrerID];

        if (referrer == address(0)) {
            referrer = creator;
        }

        if (!getUserLevelActivity(referrer, _level)) {
            emit LostLevelProfitEvent(referrer, msg.sender, _level, now);
            transferLevelPaymentFirst(_level, referrer);
            return;
        }

        if (addressToPayable(referrer).send(msg.value / 100 * firstPercent)) {
            emit GetLevelProfitEventFirst(referrer, msg.sender, _level, now);
        }
    }

    function transferLevelPaymentSecond(uint _level, address _user) internal {
        address referrer = userAddresses[users[_user].secondReferrerID];

        if (referrer == address(0)) {
            referrer = creator;
        }

        if (!getUserLevelActivity(referrer, _level)) {
            emit LostLevelProfitEvent(referrer, msg.sender, _level, now);
            transferLevelPaymentSecond(_level, referrer);
            return;
        }

        if (addressToPayable(referrer).send(msg.value / 100 * secondPercent)) {
            emit GetLevelProfitEventSecond(referrer, msg.sender, _level, now);
        }
    }

    function transferLevelPaymentThird(uint _level, address _user) internal {
        address referrer = userAddresses[users[_user].thirdReferrerID];

        if (referrer == address(0)) {
            referrer = creator;
        }

        if (!getUserLevelActivity(referrer, _level)) {
            emit LostLevelProfitEvent(referrer, msg.sender, _level, now);
            transferLevelPaymentThird(_level, referrer);
            return;
        }

        if (addressToPayable(referrer).send(msg.value / 100 * thirdPercent)) {
            emit GetLevelProfitEventThird(referrer, msg.sender, _level, now);
        }
    }

    function transferLevelPaymentFourth(uint _level, address _user) internal {
        address referrer = userAddresses[users[_user].thirdReferrerID];

        if (referrer == address(0)) {
            referrer = creator;
        }

        if (!getUserLevelActivity(referrer, _level)) {
            emit LostLevelProfitEvent(referrer, msg.sender, _level, now);
            transferLevelPaymentFourth(_level, referrer);
            return;
        }

        if (addressToPayable(referrer).send(msg.value / 100 * fourthPercent)) {
            emit GetLevelProfitEventFourth(referrer, msg.sender, _level, now);
        }
    }

    function transferLevelPaymentFifth(uint _level, address _user) internal {
        address referrer = userAddresses[users[_user].thirdReferrerID];

        if (referrer == address(0)) {
            referrer = creator;
        }

        if (!getUserLevelActivity(referrer, _level)) {
            emit LostLevelProfitEvent(referrer, msg.sender, _level, now);
            transferLevelPaymentFifth(_level, referrer);
            return;
        }

        if (addressToPayable(referrer).send(msg.value / 100 * fifthPercent)) {
            emit GetLevelProfitEventFifth(referrer, msg.sender, _level, now);
        }
    }


    function getUserUpline(address _user, uint height) public view returns (address) {
        if (height <= 0 || _user == address(0)) {
            return _user;
        }

        return this.getUserUpline(userAddresses[users[_user].referrerID], height - 1);
    }

    function getUserReferrals(address _user) public view returns (address[] memory) {
        return users[_user].referrals;
    }

    function getUserLevelActivity(address _user, uint _level) public view returns (bool) {
        return users[_user].levelActivity[_level];
    }

    function createNewUser(uint _referrerID, uint _firstReferrerID, uint _secondReferrerID, uint _thirdReferrerID, uint _fourthReferrerID, uint _fifthReferrerID) private view returns (User memory) {
        return User({
            id : currentUserID,
            referrerID : _referrerID,
            firstReferrerID : _firstReferrerID,
            secondReferrerID : _secondReferrerID,
            thirdReferrerID : _thirdReferrerID,
            fourthReferrerID : _fourthReferrerID,
            fifthReferrerID : _fifthReferrerID,
            referrals: new address[](0),
            firstReferrals: new address[](0),
            secondReferrals: new address[](0),
            thirdReferrals: new address[](0),
            fourthReferrals: new address[](0),
            fifthReferrals: new address[](0)
            });
    }

    function bytesToAddress(bytes memory _addr) private pure returns (address addr) {
        assembly {
            addr := mload(add(_addr, 20))
        }
    }

    function addressToPayable(address _addr) private pure returns (address payable) {
        return address(uint160(_addr));
    }
}