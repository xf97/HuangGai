/**
 *Submitted for verification at Etherscan.io on 2020-08-12
*/

/**
 *Submitted for verification at Etherscan.io on 2019-09-16
*/

pragma solidity ^0.5.0;

contract UtilNiceTokenPlan {
    uint ethWei = 1 ether;

    function getLevel(uint value) public view returns(uint) {
        if (value >= 1*ethWei && value <= 5*ethWei) {
            return 1;
        }
        if (value >= 6*ethWei && value <= 10*ethWei) {
            return 2;
        }
        if (value >= 11*ethWei && value <= 15*ethWei) {
            return 3;
        }
        return 0;
    }

    function getLineLevel(uint value) public view returns(uint) {
        if (value >= 1*ethWei && value <= 5*ethWei) {
            return 1;
        }
        if (value >= 6*ethWei && value <= 10*ethWei) {
            return 2;
        }
        if (value >= 11*ethWei) {
            return 3;
        }
        return 0;
    }

    function getScByLevel(uint level) public pure returns(uint) {
        if (level == 1) {
            return 5;
        }
        if (level == 2) {
            return 7;
        }
        if (level == 3) {
            return 10;
        }
        return 0;
    }

    function getFireScByLevel(uint level) public pure returns(uint) {
        if (level == 1) {
            return 3;
        }
        if (level == 2) {
            return 6;
        }
        if (level == 3) {
            return 10;
        }
        return 0;
    }

    function getRecommendScaleByLevelAndTim(uint level,uint times) public pure returns(uint){
        if (level == 1 && times == 1) {
            return 50;
        }
        if (level == 2 && times == 1) {
            return 70;
        }
        if (level == 2 && times == 2) {
            return 50;
        }
        if (level == 3) {
            if(times == 1){
                return 100;
            }
            if (times == 2) {
                return 70;
            }
            if (times == 3) {
                return 50;
            }
            if (times >= 4 && times <= 10) {
                return 10;
            }
            if (times >= 11 && times <= 20) {
                return 5;
            }
            if (times >= 21) {
                return 1;
            }
        }
        return 0;
    }

    function compareStr(string memory _str, string memory str) public pure returns(bool) {
        if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
            return true;
        }
        return false;
    }
}

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor() internal {}
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

/**
 * @title WhitelistAdminRole
 * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
 */
contract WhitelistAdminRole is Context, Ownable {
    using Roles for Roles.Role;

    event WhitelistAdminAdded(address indexed account);
    event WhitelistAdminRemoved(address indexed account);

    Roles.Role private _whitelistAdmins;

    constructor () internal {
        _addWhitelistAdmin(_msgSender());
    }

    modifier onlyWhitelistAdmin() {
        require(isWhitelistAdmin(_msgSender()) || isOwner(), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
        _;
    }

    function isWhitelistAdmin(address account) public view returns (bool) {
        return _whitelistAdmins.has(account);
    }

    function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
        _addWhitelistAdmin(account);
    }

    function removeWhitelistAdmin(address account) public onlyOwner {
        _whitelistAdmins.remove(account);
        emit WhitelistAdminRemoved(account);
    }

    function renounceWhitelistAdmin() public {
        _removeWhitelistAdmin(_msgSender());
    }

    function _addWhitelistAdmin(address account) internal {
        _whitelistAdmins.add(account);
        emit WhitelistAdminAdded(account);
    }

    function _removeWhitelistAdmin(address account) internal {
        _whitelistAdmins.remove(account);
        emit WhitelistAdminRemoved(account);
    }
}

contract NiceTokenPlan is UtilNiceTokenPlan, WhitelistAdminRole {

    using SafeMath for *;

    string constant private name = "NiceTokenPlan Official";

    uint ethWei = 1 ether;

    address payable private devAddr = address(0x7F1C3d369A3bEb8eDCe11A7b3a7132D234431F47);

    struct User{
        uint id;
        address userAddress;
        string inviteCode;
        string referrer;
        uint staticLevel;
        uint dynamicLevel;
        uint allInvest;
        uint freezeAmount;
        uint unlockAmount;
        uint allStaticAmount;
        uint allDynamicAmount;
        uint hisStaticAmount;
        uint hisDynamicAmount;
        Invest[] invests;
        uint staticFlag;
    }

    struct UserGlobal {
        uint id;
        address userAddress;
        string inviteCode;
        string referrer;
    }

    struct Invest{
        address userAddress;
        uint investAmount;
        uint investTime;
        uint times;
    }

    string constant systemCode = "99999999";
    uint coefficient = 10;
    uint startTime;
    uint investCount = 0;
    mapping(uint => uint) rInvestCount;
    uint investMoney = 0;
    mapping(uint => uint) rInvestMoney;
    uint uid = 0;
    uint rid = 1;
    uint period = 3 days;
    mapping (uint => mapping(address => User)) userRoundMapping;
    mapping(address => UserGlobal) userMapping;
    mapping (string => address) addressMapping;
    mapping (uint => address) public indexMapping;


    modifier isHuman() {
        address addr = msg.sender;
        uint codeLength;

        assembly {codeLength := extcodesize(addr)}
        require(codeLength == 0, "sorry humans only");
        require(tx.origin == msg.sender, "sorry, human only");
        _;
    }

    event LogInvestIn(address indexed who, uint indexed uid, uint amount, uint time, string inviteCode, string referrer);
    event LogWithdrawProfit(address indexed who, uint indexed uid, uint amount, uint time);
    event LogRedeem(address indexed who, uint indexed uid, uint amount, uint now);

    
    constructor () public {
    }

    function () external payable {
    }

    function activeGame(uint time) external onlyWhitelistAdmin
    {
        require(time > now, "invalid game start time");
        startTime = time;
    }

    function setCoefficient(uint coeff) external onlyWhitelistAdmin
    {
        require(coeff > 0, "invalid coeff");
        coefficient = coeff;
    }

    function gameStart() public view returns(bool) {
        return startTime != 0 && now > startTime;
    }

    function investIn(string memory inviteCode, string memory referrer)
        public
        isHuman()
        payable
    {
        require(gameStart(), "game not start");
        require(msg.value >= 1*ethWei && msg.value <= 15*ethWei, "between 1 and 15");
        require(msg.value == msg.value.div(ethWei).mul(ethWei), "invalid msg value");

        UserGlobal storage userGlobal = userMapping[msg.sender];
        if (userGlobal.id == 0) {
            require(!compareStr(inviteCode, ""), "empty invite code");
            address referrerAddr = getUserAddressByCode(referrer);
            require(uint(referrerAddr) != 0, "referer not exist");
            require(referrerAddr != msg.sender, "referrer can't be self");
            
            require(!isUsed(inviteCode), "invite code is used");

            registerUser(msg.sender, inviteCode, referrer);
        }

        User storage user = userRoundMapping[rid][msg.sender];
        if (uint(user.userAddress) != 0) {
            require(user.freezeAmount.add(msg.value) <= 15*ethWei, "can not beyond 15 eth");
            user.allInvest = user.allInvest.add(msg.value);
            user.freezeAmount = user.freezeAmount.add(msg.value);
            user.staticLevel = getLevel(user.freezeAmount);
            user.dynamicLevel = getLineLevel(user.freezeAmount.add(user.unlockAmount));
        } else {
            user.id = userGlobal.id;
            user.userAddress = msg.sender;
            user.freezeAmount = msg.value;
            user.staticLevel = getLevel(msg.value);
            user.allInvest = msg.value;
            user.dynamicLevel = getLineLevel(msg.value);
            user.inviteCode = userGlobal.inviteCode;
            user.referrer = userGlobal.referrer;
        }

        Invest memory invest = Invest(msg.sender, msg.value, now, 0);
        user.invests.push(invest);

        investCount = investCount.add(1);
        investMoney = investMoney.add(msg.value);
        rInvestCount[rid] = rInvestCount[rid].add(1);
        rInvestMoney[rid] = rInvestMoney[rid].add(msg.value);

        sendFeetoAdmin(msg.value);
        emit LogInvestIn(msg.sender, userGlobal.id, msg.value, now, userGlobal.inviteCode, userGlobal.referrer);
    }

    function withdrawProfit()
        public
        isHuman()
    {
        require(gameStart(), "game not start");
        User storage user = userRoundMapping[rid][msg.sender];
        uint sendMoney = user.allStaticAmount.add(user.allDynamicAmount);

        bool isEnough = false;
        uint resultMoney = 0;
        (isEnough, resultMoney) = isEnoughBalance(sendMoney);
        if (!isEnough) {
            endRound();
        }

        if (resultMoney > 0) {
            sendMoneyToUser(msg.sender, resultMoney);
            user.allStaticAmount = 0;
            user.allDynamicAmount = 0;
            emit LogWithdrawProfit(msg.sender, user.id, resultMoney, now);
        }
    }

    function isEnoughBalance(uint sendMoney) private view returns (bool, uint){
        if (sendMoney >= address(this).balance) {
            return (false, address(this).balance);
        } else {
            return (true, sendMoney);
        }
    }

    function sendMoneyToUser(address payable userAddress, uint money) private {
        userAddress.transfer(money);
    }

    function calStaticProfit(address userAddr) external onlyWhitelistAdmin returns(uint)
    {
        return calStaticProfitInner(userAddr);
    }

    function calStaticProfitInner(address userAddr) private returns(uint)
    {
        User storage user = userRoundMapping[rid][userAddr];
        if (user.id == 0) {
            return 0;
        }

        uint scale = getScByLevel(user.staticLevel);
        uint allStatic = 0;
        for (uint i = user.staticFlag; i < user.invests.length; i++) {
            Invest storage invest = user.invests[i];
            uint startDay = invest.investTime.sub(8 hours).div(1 days).mul(1 days);
            uint staticGaps = now.sub(8 hours).sub(startDay).div(1 days);

            uint unlockDay = now.sub(invest.investTime).div(1 days);

            if(staticGaps > 5){
                staticGaps = 5;
            }
            if (staticGaps > invest.times) {
                allStatic += staticGaps.sub(invest.times).mul(scale).mul(invest.investAmount).div(1000);
                invest.times = staticGaps;
            }

            if (unlockDay >= 5) {
                user.staticFlag++;
                user.freezeAmount = user.freezeAmount.sub(invest.investAmount);
                user.unlockAmount = user.unlockAmount.add(invest.investAmount);
                user.staticLevel = getLevel(user.freezeAmount);
            }

        }
        allStatic = allStatic.mul(coefficient).div(10);
        user.allStaticAmount = user.allStaticAmount.add(allStatic);
        user.hisStaticAmount = user.hisStaticAmount.add(allStatic);
        userRoundMapping[rid][userAddr] = user;
        return user.allStaticAmount;
    }

    function calDynamicProfit(uint start, uint end) external onlyWhitelistAdmin {
        for (uint i = start; i <= end; i++) {
            address userAddr = indexMapping[i];
            User memory user = userRoundMapping[rid][userAddr];
            calStaticProfitInner(userAddr);
            if (user.freezeAmount >= 1*ethWei) {
                uint scale = getScByLevel(user.staticLevel);
                calUserDynamicProfit(user.referrer, user.freezeAmount, scale);
            }
        }
    }

    function registerUserInfo(address user, string calldata inviteCode, string calldata referrer) external onlyOwner {
        registerUser(user, inviteCode, referrer);
    }

    function calUserDynamicProfit(string memory referrer, uint money, uint shareSc) private {
        string memory tmpReferrer = referrer;
        
        for (uint i = 1; i <= 30; i++) {
            if (compareStr(tmpReferrer, "")) {
                break;
            }
            address tmpUserAddr = addressMapping[tmpReferrer];
            User storage calUser = userRoundMapping[rid][tmpUserAddr];
            
            uint fireSc = getFireScByLevel(calUser.staticLevel);
            uint recommendSc = getRecommendScaleByLevelAndTim(calUser.dynamicLevel, i);
            uint moneyResult = 0;
            if (money <= calUser.freezeAmount.add(calUser.unlockAmount)) {
                moneyResult = money;
            } else {
                moneyResult = calUser.freezeAmount.add(calUser.unlockAmount);
            }
            
            if (recommendSc != 0) {
                uint tmpDynamicAmount = moneyResult.mul(shareSc).mul(fireSc).mul(recommendSc);
                tmpDynamicAmount = tmpDynamicAmount.div(1000).div(10).div(100);

                tmpDynamicAmount = tmpDynamicAmount.mul(coefficient).div(10);
                calUser.allDynamicAmount = calUser.allDynamicAmount.add(tmpDynamicAmount);
                calUser.hisDynamicAmount = calUser.hisDynamicAmount.add(tmpDynamicAmount);
            }

            tmpReferrer = calUser.referrer;
        }
    }

    function redeem()
        public
        isHuman()
    {
        require(gameStart(), "game not start");
        User storage user = userRoundMapping[rid][msg.sender];
        require(user.id > 0, "user not exist");

        calStaticProfitInner(msg.sender);

        uint sendMoney = user.unlockAmount;

        bool isEnough = false;
        uint resultMoney = 0;

        (isEnough, resultMoney) = isEnoughBalance(sendMoney);

        if (!isEnough) {
            endRound();
        }

        if (resultMoney > 0) {
            sendMoneyToUser(msg.sender, resultMoney);
            user.unlockAmount = 0;
            user.staticLevel = getLevel(user.freezeAmount);
            user.dynamicLevel = getLineLevel(user.freezeAmount);

            emit LogRedeem(msg.sender, user.id, resultMoney, now);
        }
    }

    function endRound() private {
        rid++;
        startTime = now.add(period).div(1 days).mul(1 days);
        coefficient = 10;
    }

    function isUsed(string memory code) public view returns(bool) {
        address user = getUserAddressByCode(code);
        return uint(user) != 0;
    }

    function getUserAddressByCode(string memory code) public view returns(address) {
        return addressMapping[code];
    }

    function sendFeetoAdmin(uint amount) private {
        devAddr.transfer(amount.div(25));
    }

    function getGameInfo() public isHuman() view returns(uint, uint, uint, uint, uint, uint, uint, uint) {
        return (
            rid,
            uid,
            startTime,
            investCount,
            investMoney,
            rInvestCount[rid],
            rInvestMoney[rid],
            coefficient
        );
    }

    function getUserInfo(address user, uint roundId) public isHuman() view returns(
        uint[10] memory ct, string memory inviteCode, string memory referrer
    ) {

        if(roundId == 0){
            roundId = rid;
        }

        User memory userInfo = userRoundMapping[roundId][user];

        ct[0] = userInfo.id;
        ct[1] = userInfo.staticLevel;
        ct[2] = userInfo.dynamicLevel;
        ct[3] = userInfo.allInvest;
        ct[4] = userInfo.freezeAmount;
        ct[5] = userInfo.unlockAmount;
        ct[6] = userInfo.allStaticAmount;
        ct[7] = userInfo.allDynamicAmount;
        ct[8] = userInfo.hisStaticAmount;
        ct[9] = userInfo.hisDynamicAmount;

        inviteCode = userInfo.inviteCode;
        referrer = userInfo.referrer;

        return (
            ct,
            inviteCode,
            referrer
        );
    }

    function getUserById(uint id) public view returns(address){
        return indexMapping[id];
    }

    function getLatestUnlockAmount(address userAddr) public view returns(uint)
    {
        User memory user = userRoundMapping[rid][userAddr];
        uint allUnlock = user.unlockAmount;
        for (uint i = user.staticFlag; i < user.invests.length; i++) {
            Invest memory invest = user.invests[i];
            uint unlockDay = now.sub(invest.investTime).div(1 days);

            if (unlockDay >= 5) {
                allUnlock = allUnlock.add(invest.investAmount);
            }
        }
        return allUnlock;
    }

    function registerUser(address user, string memory inviteCode, string memory referrer) private {
        UserGlobal storage userGlobal = userMapping[user];
        uid++;
        userGlobal.id = uid;
        userGlobal.userAddress = user;
        userGlobal.inviteCode = inviteCode;
        userGlobal.referrer = referrer;

        addressMapping[inviteCode] = user;
        indexMapping[uid] = user;
    }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

    /**
    * @dev Multiplies two numbers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "mul overflow");

        return c;
    }

    /**
    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "div zero"); // Solidity only automatically asserts when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "lower sub bigger");
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two numbers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "overflow");

        return c;
    }

    /**
    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "mod zero");
        return a % b;
    }
}