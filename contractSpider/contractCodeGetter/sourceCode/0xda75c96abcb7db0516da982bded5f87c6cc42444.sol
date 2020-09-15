/**
 *Submitted for verification at Etherscan.io on 2020-05-18
*/

pragma solidity >=0.5.12;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}


library Date {
    struct _Date {
        uint16 year;
        uint8 month;
        uint8 day;
    }

    uint constant DAY_IN_SECONDS = 86400;
    uint constant YEAR_IN_SECONDS = 31536000;
    uint constant LEAP_YEAR_IN_SECONDS = 31622400;

    uint16 constant ORIGIN_YEAR = 1970;

    function isLeapYear(uint16 year) public pure returns (bool) {
        if (year % 4 != 0) {
                return false;
        }
        if (year % 100 != 0) {
                return true;
        }
        if (year % 400 != 0) {
                return false;
        }
        return true;
    }

    function leapYearsBefore(uint year) public pure returns (uint) {
        year -= 1;
        return year / 4 - year / 100 + year / 400;
    }

    function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
                return 31;
        }
        else if (month == 4 || month == 6 || month == 9 || month == 11) {
                return 30;
        }
        else if (isLeapYear(year)) {
                return 29;
        }
        else {
                return 28;
        }
    }

    function parseTimestamp(uint timestamp) internal pure returns (_Date memory dt) {
        uint secondsAccountedFor = 0;
        uint buf;
        uint8 i;

        // Year
        dt.year = getYear(timestamp);
        buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);

        secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
        secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);

        // Month
        uint secondsInMonth;
        for (i = 1; i <= 12; i++) {
                secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
                if (secondsInMonth + secondsAccountedFor > timestamp) {
                        dt.month = i;
                        break;
                }
                secondsAccountedFor += secondsInMonth;
        }

        // Day
        for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
                if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
                        dt.day = i;
                        break;
                }
                secondsAccountedFor += DAY_IN_SECONDS;
        }
    }

    function getYear(uint timestamp) public pure returns (uint16) {
        uint secondsAccountedFor = 0;
        uint16 year;
        uint numLeapYears;

        // Year
        year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
        numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);

        secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
        secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);

        while (secondsAccountedFor > timestamp) {
                if (isLeapYear(uint16(year - 1))) {
                        secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
                }
                else {
                        secondsAccountedFor -= YEAR_IN_SECONDS;
                }
                year -= 1;
        }
        return year;
    }

    function getMonth(uint timestamp) public pure returns (uint8) {
        return parseTimestamp(timestamp).month;
    }

    function getDay(uint timestamp) public pure returns (uint8) {
        return parseTimestamp(timestamp).day;
    }

    function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
        uint16 i;

        // Year
        for (i = ORIGIN_YEAR; i < year; i++) {
                if (isLeapYear(i)) {
                        timestamp += LEAP_YEAR_IN_SECONDS;
                }
                else {
                        timestamp += YEAR_IN_SECONDS;
                }
        }

        // Month
        uint8[12] memory monthDayCounts;
        monthDayCounts[0] = 31;
        if (isLeapYear(year)) {
                monthDayCounts[1] = 29;
        }
        else {
                monthDayCounts[1] = 28;
        }
        monthDayCounts[2] = 31;
        monthDayCounts[3] = 30;
        monthDayCounts[4] = 31;
        monthDayCounts[5] = 30;
        monthDayCounts[6] = 31;
        monthDayCounts[7] = 31;
        monthDayCounts[8] = 30;
        monthDayCounts[9] = 31;
        monthDayCounts[10] = 30;
        monthDayCounts[11] = 31;

        for (i = 1; i < month; i++) {
                timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
        }

        // Day
        timestamp += DAY_IN_SECONDS * (day - 1);

        return timestamp;
    }
}

/**
 * @title   Lition Pool Contract
 * @author  Patricio Mosse
 * @notice  This contract is used for staking LIT (ERC20) tokens to support a validator running in the Lition blockchain network and distribute rewards.
 **/
contract LitionPool {
    using SafeMath for uint256;

    /**************************************************** Events **************************************************************/
    
    event NewStake(address indexed staker, uint256 totalStaked, uint8 lockupPeriod, bool compound);
    event StakeMigrated(address indexed staker, uint256 index);
    event StakeFinishedByUser(address indexed staker, uint256 totalRecovered, uint256 index);
    event StakeRestakedByUser(address indexed staker, uint256 totalStaked, uint8 lockupPeriod, bool compound);
    event StakeEnabledToBeFinished(address indexed staker, uint256 index);
    event StakeRemoved(address indexed staker, uint256 totalRecovered, uint256 index);
    event RewardsAccredited(address indexed staker, uint256 index, uint256 delta, uint256 total);
    event StakeIncreased(address indexed staker, uint256 index, uint256 delta, uint256 total);
    event RewardsWithdrawn(address indexed staker, uint256 index, uint256 total);
    event TransferredToVestingAccount(uint256 total);

    /**************************************************** Vars and structs **************************************************************/
    
    address public owner;
    IERC20 litionToken;
    bool public paused = false;

    struct Stake {
        uint256 createdOn;
        uint256 totalStaked;
        uint8 lockupPeriod;
        bool compound;
        uint256 rewards;
        bool finished;
    }
    
    address[] public stakers;
    mapping (address => Stake[]) public stakeListBySender;

    /**************************************************** Admin **************************************************************/

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor(IERC20 _litionToken) public {
        owner = msg.sender;
        litionToken = _litionToken;
    }

    function _transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner can't be the zero address");
        owner = newOwner;
    }
    
    function _switchPaused() public onlyOwner {
        paused = !paused;
    }

    function() external payable {
        revert();
    }

    /**************************************************** Public Interface for Stakers **************************************************************/

    function createNewStake(uint256 _amount, uint8 _lockupPeriod, bool _compound) public {
        require(!paused, "New stakes are paused");
        require(_isValidLockupPeriod(_lockupPeriod), "The lockup period is invalid");
        require(_amount >= 5000000000000000000000, "You must stake at least 5000 LIT");
        require(IERC20(litionToken).transferFrom(msg.sender, address(this), _amount), "Couldn't take the LIT from the sender");
        
        Stake memory stake = Stake({createdOn: now, 
                                    totalStaked:_amount, 
                                    lockupPeriod:_lockupPeriod, 
                                    compound:_compound, 
                                    rewards:0,
                                    finished:false});
                                    
        Stake[] storage stakes = stakeListBySender[msg.sender];
        stakes.push(stake);
        _addStakerIfNotExist(msg.sender);
        
        emit NewStake(msg.sender, _amount, _lockupPeriod, _compound);
    }
    
    function finishStake(uint256 _index) public {
        require(stakeListBySender[msg.sender].length > _index, "The stake doesn't exist");

        Stake memory stake = stakeListBySender[msg.sender][_index];

        require(stake.finished, "The stake is not finished yet");
        
        uint256 total = _closeStake(msg.sender, _index);
        
        emit StakeFinishedByUser(msg.sender, total, _index);
    }
    
    function restake(uint256 _index) public {
        require(stakeListBySender[msg.sender].length > _index, "The stake doesn't exist");

        Stake storage stake = stakeListBySender[msg.sender][_index];

        require(stake.finished, "The stake is not finished yet");
        
        stake.totalStaked = stake.totalStaked.add(stake.rewards);
        stake.rewards = 0;
        stake.createdOn = now;
        stake.finished = false;

        emit StakeRestakedByUser(msg.sender, stake.totalStaked, stake.lockupPeriod, stake.compound);
    }
    
    function withdrawRewards(uint256 _index) public {
        require(stakeListBySender[msg.sender].length > _index, "The stake doesn't exist");

        Stake storage stake = stakeListBySender[msg.sender][_index];

        require(stake.rewards > 0, "You don't have rewards to withdraw");
        
        uint256 total = stake.rewards;
        stake.rewards = 0;

        require(litionToken.transfer(msg.sender, total));

        emit RewardsWithdrawn(msg.sender, _index, total);
    }

    /**************************************************** Public Interface for Admin **************************************************************/

    function _accredit(address _staker, uint256 _index, uint256 _total) public onlyOwner {
        require(stakeListBySender[_staker].length > _index, "The stake doesn't exist");
        require(IERC20(litionToken).transferFrom(msg.sender, address(this), _total), "Couldn't take the LIT from the sender");

        Stake storage stake = stakeListBySender[_staker][_index];
        require(!stake.finished, "The stake is already finished");
        
        if (stake.compound) {
            stake.totalStaked += _total;

            emit StakeIncreased(_staker, _index, _total, stake.totalStaked);
        }
        else {
            stake.rewards += _total;

            emit RewardsAccredited(_staker, _index, _total, stake.rewards);
        }
        
        if (_isLockupPeriodFinished(stake.createdOn, stake.lockupPeriod)) {
            stake.finished = true;
            
            emit StakeEnabledToBeFinished(_staker, _index);
        }
    }
    
    function _accreditMultiple(address _staker, uint256[] memory _totals) public onlyOwner {
        require(stakeListBySender[_staker].length == _totals.length, "Invalid number of stakes");
        
        uint256 total = 0;
        for (uint256 i = 0; i < _totals.length; i++) {
            total = total.add(_totals[i]);
        }
        
        require(IERC20(litionToken).transferFrom(msg.sender, address(this), total), "Couldn't take the LIT from the sender");

        for (uint256 index = 0; index < _totals.length; index++) {
            Stake storage stake = stakeListBySender[_staker][index];
            require(!stake.finished, "The stake is already finished");
            
            if (stake.compound) {
                stake.totalStaked += _totals[index];
    
                emit StakeIncreased(_staker, index, _totals[index], stake.totalStaked);
            }
            else {
                stake.rewards += _totals[index];
    
                emit RewardsAccredited(_staker, index, _totals[index], stake.rewards);
            }
            
            if (_isLockupPeriodFinished(stake.createdOn, stake.lockupPeriod)) {
                stake.finished = true;
                
                emit StakeEnabledToBeFinished(_staker, index);
            }
        }
    }
    
    function _forceFinishStake(address _staker, uint256 _index) public onlyOwner {
        require(stakeListBySender[_staker].length > _index, "The stake doesn't exist");
        Stake storage stake = stakeListBySender[_staker][_index];
        require(!stake.finished, "The stake is already finished");
        stake.finished = true;
        
        emit StakeEnabledToBeFinished(_staker, _index);
    }

    function _transferLITToVestingAccount(uint256 _total) public onlyOwner {
        require(litionToken.transfer(msg.sender, _total));

        emit TransferredToVestingAccount(_total);
    }
    
    function _extractLitSentByMistake(uint256 amount, address _sendTo) public onlyOwner {
        require(litionToken.transfer(_sendTo, amount));
    }

    function _removeStaker(address _staker, uint256 _index) public onlyOwner {
        require(stakeListBySender[_staker].length > _index, "The stake doesn't exist");
        
        uint256 total = _closeStake(_staker, _index);

        emit StakeRemoved(_staker, total, _index);
    }

    /**************************************************** Pool Information **************************************************************/

    function getTotalInStake() public view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i < stakers.length; i++) {
            Stake[] memory stakes = stakeListBySender[stakers[i]];
            for (uint256 j = 0; j < stakes.length; j++) {
                if (!stakes[j].finished) {
                    total = total.add(stakes[j].totalStaked);
                }
            }
        }
        return total;
    }
    
    function getTotalStakes() public view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i < stakers.length; i++) {
            Stake[] memory stakes = stakeListBySender[stakers[i]];
            for (uint256 j = 0; j < stakes.length; j++) {
                if (!stakes[j].finished) {
                    total += 1;
                }
            }
        }
        return total;
    }
    
    function getTotalStakers() public view returns (uint256) {
        return stakers.length;
    }

    function getTotalStakesByStaker(address _staker) external view returns (uint256) {
        return stakeListBySender[_staker].length;
    }
    
    function getStake(address _staker, uint256 _index) external view returns (uint256 createdOn, uint256 totalStaked, uint8 lockupPeriod, bool compound, uint256 rewards, bool finished, uint256 lockupFinishes) {
        require(stakeListBySender[_staker].length > _index, "The stake doesn't exist");
        Stake memory stake = stakeListBySender[_staker][_index];
        createdOn = stake.createdOn;
        totalStaked = stake.totalStaked;
        lockupPeriod = stake.lockupPeriod;
        compound = stake.compound;
        rewards = stake.rewards;
        finished = stake.finished;
        lockupFinishes = getLockupFinishTimestamp(_staker, _index);
    }

    function getLockupFinishTimestamp(address _staker, uint256 _index) public view returns (uint256) {
        require(stakeListBySender[_staker].length > _index, "The stake doesn't exist");
        Stake memory stake = stakeListBySender[_staker][_index];
        return calculateFinishTimestamp(stake.createdOn, stake.lockupPeriod);
    }

    /**************************************************** Internal Admin - Lockups **************************************************************/

    function calculateFinishTimestamp(uint256 _timestamp, uint8 _lockupPeriod) public pure returns (uint256) {
        uint16 year = Date.getYear(_timestamp);
        uint8 month = Date.getMonth(_timestamp);
        month += _lockupPeriod;
        if (month > 12) {
            year += 1;
            month = month % 12;
        }
        uint8 day = Date.getDay(_timestamp);
        uint256 finishOn = Date.toTimestamp(year, month, day);
        return finishOn;
    }

    /**************************************************** Internal Admin - Stakes and Rewards **************************************************************/

    function _closeStake(address _staker, uint256 _index) internal returns (uint256) {
        uint256 totalStaked = stakeListBySender[_staker][_index].totalStaked;
        uint256 total = totalStaked + stakeListBySender[_staker][_index].rewards;
        
        _removeStakeByIndex(_staker, _index);
        if (stakeListBySender[_staker].length == 0) {
            _removeStakerByValue(_staker);
        }
        
        require(litionToken.transfer(_staker, total));

        return total;
    }
    
    /**************************************************** Internal Admin - Validations **************************************************************/
    
    function _isValidLockupPeriod(uint8 n) internal pure returns (bool) {
        if (n == 1) {
            return true;
        }
        else if (n == 3) {
            return true;
        }
        else if (n == 6) {
            return true;
        }
        else if (n == 12) {
            return true;
        }
        return false;
    }

    function _isLockupPeriodFinished(uint256 _timestamp, uint8 _lockupPeriod) internal view returns (bool) {
        return now > calculateFinishTimestamp(_timestamp, _lockupPeriod);
    }

    /**************************************************** Internal Admin - Arrays **************************************************************/

    function _addStakerIfNotExist(address _staker) internal {
        for (uint256 i = 0; i < stakers.length; i++) {
            if (stakers[i] == _staker) {
                return;
            }
        }
        stakers.push(_staker);
    }

    function _findStaker(address _value) internal view returns(uint) {
        uint i = 0;
        while (stakers[i] != _value) {
            i++;
        }
        return i;
    }

    function _removeStakerByValue(address _value) internal {
        uint i = _findStaker(_value);
        _removeStakerByIndex(i);
    }

    function _removeStakerByIndex(uint _i) internal {
        while (_i<stakers.length-1) {
            stakers[_i] = stakers[_i+1];
            _i++;
        }
        stakers.length--;
    }
    
    function _removeStakeByIndex(address _staker, uint _i) internal {
        Stake[] storage stakes = stakeListBySender[_staker];
        while (_i<stakes.length-1) {
            stakes[_i] = stakes[_i+1];
            _i++;
        }
        stakes.length--;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        require(c >= a);
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        require(c / a == b);
        return c;
    }
    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}