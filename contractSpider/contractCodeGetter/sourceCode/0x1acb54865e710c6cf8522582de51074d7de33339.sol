/**
 *Submitted for verification at Etherscan.io on 2020-06-24
*/

pragma solidity 0.4 .25;

/**
 *      /$$$$$                       /$$           /$$$$$$$                     
 *     |__  $$                      | $$          | $$__  $$                    
 *        | $$ /$$   /$$  /$$$$$$$ /$$$$$$        | $$  \ $$ /$$   /$$ /$$$$$$$ 
 *        | $$| $$  | $$ /$$_____/|_  $$_/        | $$$$$$$/| $$  | $$| $$__  $$
 *   /$$  | $$| $$  | $$|  $$$$$$   | $$          | $$__  $$| $$  | $$| $$  \ $$
 *  | $$  | $$| $$  | $$ \____  $$  | $$ /$$      | $$  \ $$| $$  | $$| $$  | $$
 *  |  $$$$$$/|  $$$$$$/ /$$$$$$$/  |  $$$$/      | $$  | $$|  $$$$$$/| $$  | $$
 *   \______/  \______/ |_______/    \___/        |__/  |__/ \______/ |__/  |__/
 * This product is protected under license.  Any unauthorized copy, modification, or use without 
 * express written consent from the creators is prohibited.
 * Get touch with us justrunio2020@gmail.com
 * WARNING:  THIS PRODUCT IS HIGHLY ADDICTIVE.  IF YOU HAVE AN ADDICTIVE NATURE.  DO NOT PLAY.
 */
pragma solidity ^ 0.4 .24;

/**
 * @title SafeMath v0.1.9
 * @dev Math operations with safety checks that throw on error
 * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
 * - added sqrt
 * - added sq
 * - added pwr 
 * - changed asserts to requires with error log outputs
 * - removed div, its useless
 */
library SafeMath {

  /**
   * @dev Multiplies two numbers, throws on overflow.
   */
  function mul(uint256 a, uint256 b)
  internal
  pure
  returns(uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    require(c / a == b, "SafeMath mul failed");
    return c;
  }

  /**
   * @dev Integer division of two numbers, truncating the quotient.
   */
  function div(uint256 a, uint256 b) internal pure returns(uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
   */
  function sub(uint256 a, uint256 b)
  internal
  pure
  returns(uint256) {
    require(b <= a, "SafeMath sub failed");
    return a - b;
  }

  /**
   * @dev Adds two numbers, throws on overflow.
   */
  function add(uint256 a, uint256 b)
  internal
  pure
  returns(uint256 c) {
    c = a + b;
    require(c >= a, "SafeMath add failed");
    return c;
  }

  /**
   * @dev gives square root of given x.
   */
  function sqrt(uint256 x)
  internal
  pure
  returns(uint256 y) {
    uint256 z = ((add(x, 1)) / 2);
    y = x;
    while (z < y) {
      y = z;
      z = ((add((x / z), z)) / 2);
    }
  }

  /**
   * @dev gives square. multiplies x by x
   */
  function sq(uint256 x)
  internal
  pure
  returns(uint256) {
    return (mul(x, x));
  }

  /**
   * @dev x to the power of y 
   */
  function pwr(uint256 x, uint256 y)
  internal
  pure
  returns(uint256) {
    if (x == 0)
      return (0);
    else if (y == 0)
      return (1);
    else {
      uint256 z = x;
      for (uint256 i = 1; i < y; i++)
        z = mul(z, x);
      return (z);
    }
  }
}


pragma solidity 0.4 .25;

library Data {

  struct Player {

    uint signInTime;

    uint signInDay;

    uint consume;

    uint dynamicIncome;

    uint totalEth;

    uint sellIncome;

    bool isNew;

    bool isExist;

    address superiorAddr;

    address[] subordinateAddr;
  }

  struct PlayerData {

    uint wallet;

    uint runIncome;

    uint withdrawnIncome;

    uint totalPerformance;

    uint settledLotteryIncome;
  }

  struct Run {

    uint runPool;

    uint endTime;

    uint totalConsume;

    uint record;

    uint count;

    uint num;

    uint count2;

    uint totalEth;

    uint[] recordArr;

    address lastAddr;

    address[] lastAddrs;

    mapping(address => uint) plyrMask;

    mapping(address => uint) consumeMap;

    mapping(address => uint) personalEth;
  }

  struct Scratch {

    uint prizeNumber;

    mapping(address => mapping(uint => uint)) roundIncome;

    mapping(address => mapping(uint => uint[])) numberMap;

    mapping(address => mapping(uint => uint[])) ethMap;

    mapping(address => mapping(uint => uint[])) winMap;
  }

  struct Lottery {

    uint lotteryPool;

    uint unopenedBonus;

    uint number;

    uint time;

    uint tokenNumber;

    mapping(uint => uint[]) winNumber;

    mapping(address => uint[]) lotteryMap;

    mapping(uint => uint) awardAmount;
  }

  struct SaleQueue {

    address addr;

    uint tokenNumber;

    uint remainingAmount;

  }

  struct PersonalSaleInfo {

    uint tokenNumber;

    uint saleNumber;
  }

  function rand(uint256 _length, uint256 num, uint256 salt) internal view returns(uint256) {
    uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, num, salt)));
    return random % _length;
  }

  function returnArray(uint len, uint range, uint number, uint salt) internal view returns(uint[]) {
    uint[] memory numberArray = new uint[](len);
    uint i = 0;
    while (true) {
      number = number + 9;
      uint temp = rand(range, number, salt);
      if (temp == 0) {
        continue;
      }
      numberArray[i] = temp;
      i++;
      if (i == len) {
        break;
      }
    }
    return numberArray;
  }

  function generatePrizeNumber(uint256 seed, uint256 salt) internal view returns(uint) {
    uint number = 0;
    while (number < 10000) {
      seed++;
      number = rand(100000, seed, salt);
    }
    return number;
  }
}


contract JustRun {

  address owner;
  address exAddr;
  address techAddr;
  address lotteryAddr;
  uint recordId = 0;
  uint public rid = 1;
  // uint timeInterval = 24 * 60 * 60;
  uint timeInterval = 15 * 60;
  bool active = false;
  uint[] numArr;
  address[] inVain = new address[](6);

  TokenRun token;
  ExRun ex;
  LotteryRun lottery;

  mapping(address => Data.PlayerData) dataMap;
  mapping(uint => Data.Run) public runGame;
  mapping(uint => uint) roundMask;

  constructor(
    address _ownerAddr,
    address _tokenAddr,
    address _exAddr,
    address _techAddr
  ) public {
    owner = _ownerAddr;
    token = TokenRun(_tokenAddr);
    ex = ExRun(_exAddr);
    exAddr = _exAddr;
    techAddr = _techAddr;
  }
  /** Send ETH to join runGame (Make sure you have enough run token)
   *	Send 0eth withdraw your all ETH
   */
  function() public payable {
    uint _eth = msg.value;
    bool flag = isContract(msg.sender);
    if (!flag) {
      if (_eth > 0) {
        participateCore(msg.sender, address(0x0), _eth);
      } else {
        withdrawCore(msg.sender, 0);
      }
    }
  }

  function isContract(address _addr) private view returns(bool) {
    uint size;
    assembly {
      size: = extcodesize(_addr)
    }
    return size > 0;
  }

  /** Join Run core logic */
  function participateCore(address addr, address superiorAddr, uint _eth) private {
    require(_eth >= 10 ** 17, "Participate in run at least 0.1eth");
    require(token.balanceOf(addr) >= token.calcTokenRequired(_eth), "not enough token");
    ex.externalRegister(addr, superiorAddr);
    uint _now = now;
    if (_now < runGame[rid].endTime) {
      /**Run core logic */
      runCore(addr, _eth);
    } else {
      /**End the run and start one new run */
      endRound(addr, _eth);
    }
  }

  function calcAllIncome() private view returns(uint) {
    uint totalIncome = 0;
    for (uint i = 1; i <= rid; i++) {
      uint totalEth = runGame[i].personalEth[msg.sender];
      uint income = calcIncome(i);
      totalEth = SafeMath.mul(totalEth, 2);
      if (income > totalEth) {
        totalIncome = SafeMath.add(totalIncome, totalEth);
      } else {
        totalIncome = SafeMath.add(totalIncome, income);
      }
    }

    return totalIncome;
  }

  /** Calc player's Income */
  function calcIncome(uint roundID) private view returns(uint) {
    Data.Run storage run = runGame[roundID];
    uint totalIncome = SafeMath.sub(SafeMath.mul(roundMask[roundID], run.consumeMap[msg.sender]), run.plyrMask[msg.sender]);
    return totalIncome;
  }

  function getTotalIncome() private view returns(uint) {
    Data.PlayerData storage pd = dataMap[msg.sender];
    return SafeMath.add(calcAllIncome(), pd.wallet);
  }

  function withdrawCore(address addr, uint _eth) private {
    Data.PlayerData storage pd = dataMap[addr];
    uint lotteryIncome = lottery.getAllLotteryIncome(addr, true);
    pd.settledLotteryIncome = SafeMath.add(pd.settledLotteryIncome, lotteryIncome);
    pd.wallet = SafeMath.add(pd.wallet, lotteryIncome);
    uint income = getTotalIncome();
    income = SafeMath.sub(income, pd.withdrawnIncome);
    require(income > _eth, "balance Insufficient");
    if (_eth == 0) {
      _eth = income;
    }
    uint handlingFee = lottery.deductionFee(addr, _eth);
    pd.withdrawnIncome = SafeMath.add(pd.withdrawnIncome, _eth);
    _eth = SafeMath.sub(_eth, handlingFee);
    addr.transfer(_eth);
  }

  /**Run core logic */
  function runCore(address addr, uint _eth) private {
    Data.Run storage run = runGame[rid];
    runOperation(addr, _eth);
    address superiorAddr = ex.getSuperiorAddr(addr);
    uint number = SafeMath.div(_eth, 10);
    uint number3 = SafeMath.div(SafeMath.mul(_eth, 3), 100);
    uint number7 = SafeMath.div(SafeMath.mul(_eth, 7), 100);
    run.runPool = SafeMath.add(number, run.runPool);
    ex.buyTokenByRun(address(0x0), number);
    if (superiorAddr != address(0x0)) {
      uint subEth = ex.getPlayerTotalEth(addr);
      uint superEth = ex.getPlayerTotalEth(superiorAddr);
      uint num = SafeMath.div(superEth * 10 ** 8, subEth);
      if (num < 10000000) {
        uint temp = number;
        number = SafeMath.div(SafeMath.mul(num, number), 10 ** 7);
        dataMap[techAddr].wallet = SafeMath.add(dataMap[techAddr].wallet, SafeMath.sub(temp, number));
      }
      dataMap[superiorAddr].wallet = SafeMath.add(dataMap[superiorAddr].wallet, number);
      ex.updateDynamicIncome(superiorAddr, number);
    } else {
      dataMap[techAddr].wallet = SafeMath.add(dataMap[techAddr].wallet, number);
    }

    lottery.updateLotteryPool(number7);
    dataMap[techAddr].wallet = SafeMath.add(dataMap[techAddr].wallet, number3);

  }

  function runOperation(address addr, uint _eth) private {
    Data.Run storage run = runGame[rid];
    Data.PlayerData storage pd = dataMap[addr];
    pd.totalPerformance = SafeMath.add(pd.totalPerformance, _eth);
    run.totalEth = SafeMath.add(run.totalEth, _eth);
    uint n = SafeMath.div(run.totalEth / 10 ** 18, 400);
    if (n > 0 && n - run.count > 0) {
      run.num = SafeMath.add(run.num, n - run.count);
      run.count = n;
    }

    uint n1 = SafeMath.div(run.totalEth / 10 ** 16, run.num);
    if (n1 > 0 && n1 - run.count2 > 0) {
      uint temp = SafeMath.mul(n1 - run.count2, 100 * 10 ** 8);
      run.totalConsume = SafeMath.sub(run.totalConsume, temp);
      run.count2 = n1;
    }

    uint value = token.calcTokenRequired(_eth);
    run.totalConsume = SafeMath.add(run.totalConsume, value);
    run.consumeMap[addr] = SafeMath.add(run.consumeMap[addr], value);
    run.record = run.record + 1;
    run.personalEth[addr] = SafeMath.add(run.personalEth[addr], _eth);

    uint amount = 0;
    if (run.record > 0) {
      amount = SafeMath.div(SafeMath.mul(_eth, 60), 100);
      amount = SafeMath.div(amount, run.totalConsume);
      roundMask[rid] = SafeMath.add(roundMask[rid], amount);
      run.plyrMask[addr] = SafeMath.add(run.plyrMask[addr], SafeMath.mul(SafeMath.sub(roundMask[rid], amount), value));
    }

    token.burn(addr, value);
    ex.updateTokenConsume(addr, value);

    ex.updatePlayerEth(addr, _eth);

    run.lastAddr = addr;
    run.lastAddrs[recordId] = addr;
    recordId++;
    if (recordId > 5) {
      recordId = 0;
    }


    timeExtended(_eth);
  }

  /**End the run and start one new run */
  function endRound(address addr, uint _eth) private {
    Data.Run storage run = runGame[rid];
    uint lastPot = SafeMath.div(SafeMath.mul(run.runPool, 50), 100);
    uint nextRoundFunds = SafeMath.div(SafeMath.mul(run.runPool, 20), 100);
    uint reward = SafeMath.div(SafeMath.mul(run.runPool, 5), 100);

    dataMap[run.lastAddr].wallet = SafeMath.add(dataMap[run.lastAddr].wallet, lastPot);
    dataMap[run.lastAddr].runIncome = SafeMath.add(dataMap[run.lastAddr].runIncome, lastPot);

    address superiorAddr = ex.getSuperiorAddr(run.lastAddr);
    if (superiorAddr != address(0x0)) {
      dataMap[superiorAddr].wallet = SafeMath.add(dataMap[superiorAddr].wallet, reward);
      dataMap[superiorAddr].runIncome = SafeMath.add(dataMap[superiorAddr].runIncome, reward);
    } else {
      dataMap[techAddr].wallet = SafeMath.add(dataMap[techAddr].wallet, reward);
    }
    dataMap[techAddr].wallet = SafeMath.add(dataMap[techAddr].wallet, reward);
    uint amount = SafeMath.div(nextRoundFunds, 5);
    for (uint i = 0; i < run.lastAddrs.length; i++) {
      if ((i + 1) % 6 == recordId) {
        continue;
      }
      dataMap[run.lastAddrs[i]].wallet = SafeMath.add(dataMap[run.lastAddrs[i]].wallet, amount);
      dataMap[run.lastAddrs[i]].runIncome = SafeMath.add(dataMap[run.lastAddrs[i]].runIncome, amount);
    }
    recordId = 0;
    rid++;
    runGame[rid] = Data.Run({
      runPool: nextRoundFunds,
      endTime: now + timeInterval,
      totalConsume: 0,
      record: 0,
      num: 270,
      count: 0,
      count2: 0,
      totalEth: 0,
      recordArr: numArr,
      lastAddr: address(0x0),
      lastAddrs: inVain
    });
    runCore(addr, _eth);
  }

  /**Extend the Run end time */
  function timeExtended(uint _eth) private {
    Data.Run storage run = runGame[rid];
    uint count = SafeMath.div(_eth, 10 ** 16);
    uint nowTime = now;
    if (run.endTime < nowTime) {
      return;
    }
    uint laveTime = SafeMath.sub(run.endTime, nowTime);
    // uint day = 24 * 60 * 60;
    uint day = 15 * 60;
    // uint minute = 10 * 60;
    uint minute = 60;
    if (_eth >= 10 ** 16) {
      laveTime = SafeMath.add(laveTime, SafeMath.mul(minute, count));
      if (laveTime <= day) {
        run.endTime = SafeMath.add(nowTime, laveTime);
      } else {
        run.endTime = SafeMath.add(nowTime, day);
      }
    }
  }

  function getEth() external {
    require(owner == msg.sender, "Insufficient permissions");
    owner.transfer(this.balance);
  }

  function getPlayerData(address addr) external view returns(uint, uint, uint, uint) {
    // require(owner == msg.sender || addr == msg.sender, "Insufficient permissions");
    Data.PlayerData storage pd = dataMap[addr];
    return (pd.wallet, pd.runIncome, pd.withdrawnIncome, pd.totalPerformance);
  }

  /** Active Contract with lotteryAddr */
  function activation(
    address _lotteryAddr
  ) external {
    require(active == false, "activated");
    require(owner == msg.sender, "Insufficient permissions");
    runGame[rid] = Data.Run({
      runPool: 0,
      endTime: now + timeInterval,
      totalConsume: 0,
      record: 0,
      num: 270,
      count: 0,
      count2: 0,
      totalEth: 0,
      recordArr: numArr,
      lastAddr: address(0x0),
      lastAddrs: inVain
    });
    lottery = LotteryRun(_lotteryAddr);
    lotteryAddr = _lotteryAddr;
    active = true;

  }

  function participateInRun(address superiorAddr) external payable {
    participateCore(msg.sender, superiorAddr, msg.value);
  }

  function getLastAddrs(uint roundID) external view returns(address[]) {
    return runGame[roundID].lastAddrs;
  }

  function getmask() external view returns(uint, uint) {
    Data.Run storage run = runGame[rid];
    return (roundMask[rid], run.plyrMask[msg.sender]);
  }

  /** get all return info */
  function dividendInfo() external view returns(uint, uint, uint, uint) {
    Data.Run storage run = runGame[rid];
    uint totalEth = run.personalEth[msg.sender];
    totalEth = SafeMath.mul(totalEth, 2);
    uint totalIncome = calcIncome(rid);
    uint number = totalIncome;
    uint remainingNumber = 0;
    uint exceedNumber = 0;
    if (totalIncome > totalEth) {
      number = totalEth;
      exceedNumber = SafeMath.sub(totalIncome, totalEth);
    } else {
      remainingNumber = SafeMath.sub(totalEth, totalIncome);
    }
    return (run.personalEth[msg.sender], number, remainingNumber, exceedNumber);
  }

  /** get player income */
  function getPlayerIncome() external view returns(uint, uint) {
    Data.PlayerData storage pd = dataMap[msg.sender];
    uint totalIncome = getTotalIncome();
    totalIncome = SafeMath.sub(totalIncome, pd.settledLotteryIncome);
    totalIncome = SafeMath.add(totalIncome, lottery.getAllLotteryIncome(msg.sender, false));
    return (totalIncome, pd.withdrawnIncome);
  }

  function getVariousIncome() external view returns(uint, uint, uint, uint, uint) {
    Data.PlayerData storage pd = dataMap[msg.sender];
    uint dynamicIncome;
    uint sellIncome;
    (dynamicIncome, sellIncome) = ex.getIncome(msg.sender);
    uint lotteryIncome = lottery.getAllLotteryIncome(msg.sender, false);
    return (pd.runIncome, calcAllIncome(), dynamicIncome, sellIncome, lotteryIncome);
  }

  function withdraw() external {
    withdrawCore(msg.sender, 0);
  }

  function balanceWithdraw(uint _eth) external {
    withdrawCore(msg.sender, _eth);
  }

  function getRunPool() external view returns(uint) {
    return runGame[rid].runPool;
  }

  /**  API for ExRun*/
  function tokenDividend(uint _eth, uint pct) external {
    require(msg.sender == exAddr, "Insufficient permissions");
    uint lotteryPool = SafeMath.div(SafeMath.mul(_eth, 13), 100);
    lottery.updateLotteryPool(lotteryPool);
    uint runPool = SafeMath.div(SafeMath.mul(_eth, 20), 100);
    Data.Run storage run = runGame[rid];
    run.runPool = SafeMath.add(run.runPool, runPool);
    timeExtended(runPool);
    if (pct > 0) {
      uint amount = SafeMath.div(SafeMath.mul(_eth, pct), 100);
      dataMap[techAddr].wallet = SafeMath.add(dataMap[techAddr].wallet, amount);
    }


  }
  /**  API for ExRun*/
  function updateWallet(address addr, uint _eth) external {
    require(exAddr == msg.sender, "Insufficient permissions");
    if (addr == address(0x0)) {
      dataMap[techAddr].wallet = SafeMath.add(dataMap[techAddr].wallet, _eth);
    } else {
      dataMap[addr].wallet = SafeMath.add(dataMap[addr].wallet, _eth);
    }
  }
  /**  API for LotteryRun*/
  function updateRunPool(address addr, uint _eth, bool flag) external {
    require(lotteryAddr == msg.sender, "Insufficient permissions");
    uint number3 = SafeMath.div(SafeMath.mul(_eth, 3), 100);
    dataMap[techAddr].wallet = SafeMath.add(dataMap[techAddr].wallet, number3);

    if (flag) {
      uint number97 = SafeMath.sub(_eth, number3);
      addr.transfer(number97);
      runGame[rid].runPool = SafeMath.sub(runGame[rid].runPool, _eth);
    } else {
      runGame[rid].runPool = SafeMath.add(runGame[rid].runPool, SafeMath.sub(_eth, number3));
      timeExtended(_eth);
    }

  }

  function aaa(uint256 a, uint256 b) external pure returns (uint256) {
      return a + b;
  }

  function bbb(uint256 a, uint256 b) external pure returns (uint256) {
      return a - b;
  }

}

contract TokenRun {
  function calcTokenRequired(uint _eth) external view returns(uint);

  function burn(address addr, uint value) public;

  function surplusSupply() public view returns(uint);

  function getToken(address addr, uint value) external;

  function balanceOf(address addr) public view returns(uint);
}

contract ExRun {
  function externalRegister(address addr, address superiorAddr) external;

  function updateTokenConsume(address addr, uint value) external;

  function getSuperiorAddr(address addr) external view returns(address);

  function buyTokenByRun(address addr, uint _eth) external;

  function updateDynamicIncome(address addr, uint _eth) external;

  function getIncome(address addr) external view returns(uint, uint);

  function updatePlayerEth(address addr, uint _eth) external;

  function getPlayerTotalEth(address addr) external view returns(uint);
}

contract LotteryRun {
  function getAllLotteryIncome(address addr, bool flag) external view returns(uint);

  function updateLotteryPool(uint value) external;

  function deductionFee(address addr, uint _eth) external returns(uint);
}