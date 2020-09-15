/**
 *Submitted for verification at Etherscan.io on 2020-06-24
*/

pragma solidity 0.4 .25;

/**
 *      /$$$$$                       /$$           /$$                   /$$     /$$                                  
 *     |__  $$                      | $$          | $$                  | $$    | $$                                  
 *        | $$ /$$   /$$  /$$$$$$$ /$$$$$$        | $$        /$$$$$$  /$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$  /$$   /$$
 *        | $$| $$  | $$ /$$_____/|_  $$_/        | $$       /$$__  $$|_  $$_/|_  $$_/   /$$__  $$ /$$__  $$| $$  | $$
 *   /$$  | $$| $$  | $$|  $$$$$$   | $$          | $$      | $$  \ $$  | $$    | $$    | $$$$$$$$| $$  \__/| $$  | $$
 *  | $$  | $$| $$  | $$ \____  $$  | $$ /$$      | $$      | $$  | $$  | $$ /$$| $$ /$$| $$_____/| $$      | $$  | $$
 *  |  $$$$$$/|  $$$$$$/ /$$$$$$$/  |  $$$$/      | $$$$$$$$|  $$$$$$/  |  $$$$/|  $$$$/|  $$$$$$$| $$      |  $$$$$$$
 *   \______/  \______/ |_______/    \___/        |________/ \______/    \___/   \___/   \_______/|__/       \____  $$
 *                                                                                                          /$$  | $$
 *                                                                                                         |  $$$$$$/
 *                                                                                                           \______/
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

contract LotteryRun {

  address owner;
  address runAddr;
  address exAddr;
  address[] winEthAddr = new address[](10);
  uint[] winEth = new uint[](10);
  uint winEthIndex = 0;
  address[] winTokenAddr = new address[](10);
  uint[] winToken = new uint[](10);
  uint winTokenIndex = 0;
  uint public rid = 1;
  uint public scratchRoundID = 1;
  uint public scratchRecord = 1;
  // uint timeInterval = 4 * 60 * 60;
  uint timeInterval = 60;
  uint seed;
  uint salt;
  bool active = false;

  mapping(address => uint) recordMap;

  TokenRun token;
  ExRun ex;
  JustRun run;

  mapping(uint => Data.Lottery) public lotteryGame;
  mapping(uint => Data.Scratch) public scratchGame;
  mapping(address => mapping(uint => uint)) public scratchIncome;

  constructor(
    address _ownerAddr,
    address _tokenAddr,
    address _exAddr
  ) public {
    owner = _ownerAddr;
    token = TokenRun(_tokenAddr);
    ex = ExRun(_exAddr);
    exAddr = _exAddr;
  }
  /** Send ETH to join TICKET RUN
   */
  function() public payable {
    uint _eth = msg.value;
    bool flag = isContract(msg.sender);
    if (!flag) {
      if (_eth > 0) {
        ethParticipateCore(msg.sender, address(0x0), _eth);
      }
    }
  }

  /** Active Contract with runAddr */
  function activation(
    address _runAddr,
    uint _seed,
    uint _salt
  ) external {
    require(active == false, "activated");
    require(owner == msg.sender, "Insufficient permissions");
    lotteryGame[rid] = Data.Lottery({
      lotteryPool: 0,
      unopenedBonus: 0,
      number: 1,
      time: now + timeInterval,
      tokenNumber: 0
    });
    runAddr = _runAddr;
    run = JustRun(_runAddr);
    seed = _seed;
    salt = _salt;
    scratchGame[scratchRoundID] = Data.Scratch({
      prizeNumber: Data.generatePrizeNumber(seed, salt)
    });
    seed = SafeMath.sub(seed, Data.rand(seed, seed, salt));
    active = true;

  }

  /** Verify that the address is a contract address */
  function isContract(address _addr) private view returns(bool) {
    uint size;
    assembly {
      size: = extcodesize(_addr)
    }
    return size > 0;
  }

  /** get one round lottery income*/
  function getLotteryIncome(address addr, uint roundId) private view returns(uint) {
    Data.Lottery storage lottery = lotteryGame[roundId];
    uint income = 0;
    for (uint i = 0; i < 4; i++) {
      if (lottery.awardAmount[i] != 0) {
        income = SafeMath.add(income, calcWinIncome(lottery.lotteryMap[addr], lottery.winNumber[i], lottery.awardAmount[
          i]));
      }
    }
    return income;
  }

  /** Calc Lottery Income */
  function calcWinIncome(uint[] lottoArr, uint[] arr, uint amount) private pure returns(uint) {
    uint income = 0;
    for (uint i = 0; i < arr.length; i++) {
      uint j = 0;
      while (j < lottoArr.length) {
        if (arr[i] >= lottoArr[j] && arr[i] <= lottoArr[j + 1]) {
          income = SafeMath.add(income, amount);
        }
        j = j + 3;
      }
    }
    return income;
  }

  /** Buy Lottery Logic */
  function buyLotto(address addr, uint value, uint tokenValue) private {
    Data.Lottery storage lottery = lotteryGame[rid];
    lottery.lotteryMap[addr].push(lottery.number);
    lottery.lotteryMap[addr].push(SafeMath.add(lottery.number, value - 1));
    lottery.number = SafeMath.add(lottery.number, value);
    lottery.lotteryMap[addr].push(0);
    lottery.tokenNumber = SafeMath.add(lottery.tokenNumber, tokenValue);
  }

  function prizeDistribution(uint[] winningNumber, uint divide, uint num, bool flag) private returns(uint) {
    Data.Lottery storage lottery = lotteryGame[rid];
    uint number = 0;
    uint prize = 0;
    if (num != 0) {
      prize = SafeMath.div(SafeMath.mul(lottery.lotteryPool, divide), 10);
    }
    if (flag) {
      uint personal = 0;
      if (num == 0) {
        personal = SafeMath.div(SafeMath.mul(lottery.unopenedBonus, 50), 100);
        number = personal;
      } else if (num == 1) {
        personal = SafeMath.div(lottery.unopenedBonus, 10);
        number = personal;
        personal = SafeMath.add(personal, prize);
        personal = SafeMath.div(personal, winningNumber.length);
      } else if (num == 2) {
        personal = SafeMath.div(lottery.unopenedBonus, 100);
        number = personal;
        personal = SafeMath.add(personal, prize);
        personal = SafeMath.div(personal, winningNumber.length);
      } else {
        personal = SafeMath.div(prize, winningNumber.length);
      }
      lottery.awardAmount[num] = personal;
    } else {
      lottery.unopenedBonus = SafeMath.add(lottery.unopenedBonus, prize);
    }
    return number;
  }

  /** ETH Buy TICKET Logic */
  function ethParticipateCore(address addr, address superiorAddr, uint _eth) private {
    require(_eth >= 10 ** 16, "Participate in scratch at least 0.01 eth");
    ex.externalRegister(addr, superiorAddr);
    runAddr.transfer(_eth);
    run.updateRunPool(addr, _eth, false);
    uint runPool = run.getRunPool();
    uint income = scratchCore(addr, 1, _eth, runPool);
    if (income != 0) {
      scratchIncome[addr][1] = SafeMath.add(scratchIncome[addr][1], income);
      winEthAddr[winEthIndex] = addr;
      winEth[winEthIndex] = income;
      winEthIndex++;
      if (winEthIndex > 9) {
        winEthIndex = 0;
      }
      run.updateRunPool(addr, income, true);
    }
  }

  function scratchCore(address addr, uint way, uint num, uint pool) private returns(uint) {
    uint prizeNumber = scratchGame[scratchRoundID].prizeNumber;

    uint number = Data.rand(100000, seed, salt);
    seed = SafeMath.add(seed, Data.rand(100, seed, salt));

    scratchGame[scratchRoundID].numberMap[addr][way].push(number);
    scratchGame[scratchRoundID].ethMap[addr][way].push(num);
    uint multiple = scratchNumber(prizeNumber, number);
    uint income = 0;
    if (multiple != 0) {
      income = SafeMath.mul(num, multiple);
      if (way == 1) {
        uint amount = SafeMath.div(SafeMath.mul(pool, 60), 100);
        if (income > amount) {
          income = amount;
        }
      } else {
        if (income > pool) {
          income = pool;
        }
      }
    }
    scratchGame[scratchRoundID].winMap[addr][way].push(income);
    if (scratchRecord % 100 == 0) {
      scratchRoundID++;
      seed = SafeMath.sub(seed, Data.rand(seed, seed, salt));
      scratchGame[scratchRoundID].prizeNumber = Data.generatePrizeNumber(seed, salt);
      seed = SafeMath.add(seed, Data.rand(100, seed, salt));
    }
    scratchRecord++;
    return income;
  }

  function scratchNumber(uint prizeNumber, uint number) private pure returns(uint) {
    if (number >= 10000) {
      return getMultiple(prizeNumber, number, 5);
    } else if (number >= 1000) {
      return getMultiple(prizeNumber, number, 4);
    } else if (number >= 100) {
      return getMultiple(prizeNumber, number, 3);
    } else if (number >= 10) {
      return getMultiple(prizeNumber, number, 2);
    } else {
      return getMultiple(prizeNumber, number, 1);
    }
  }

  function getMultiple(uint prizeNumber, uint number, uint count) private pure returns(uint) {
    for (uint i = count; i > 0; i--) {
      if (prizeNumber % (10 ** i) == number % (10 ** i)) {
        if (i == 5) {
          return 10000;
        } else if (i == 4) {
          return 1000;
        } else if (i == 3) {
          return 100;
        } else if (i == 2) {
          return 10;
        } else {
          return 5;
        }

      }

    }
    return 0;
  }

  function winAmount() external view returns(address[], uint[], address[], uint[]) {
    return (winEthAddr, winEth, winTokenAddr, winToken);
  }

  function getScratchNumber(uint roundID) external view returns(uint[], uint[], uint[], uint[], uint[], uint[]) {
    return (
      scratchGame[roundID].numberMap[msg.sender][1],
      scratchGame[roundID].ethMap[msg.sender][1],
      scratchGame[roundID].winMap[msg.sender][1],
      scratchGame[roundID].numberMap[msg.sender][2],
      scratchGame[roundID].ethMap[msg.sender][2],
      scratchGame[roundID].winMap[msg.sender][2]
    );
  }

  function tokenParticipateInScratch(address superiorAddr, uint value) external {
    uint price = token.sellingPrice();
    uint surplusSupply = token.surplusSupply();
    require(token.balanceOf(msg.sender) >= value, "not enough token");
    require(SafeMath.mul(price, value) >= 10 ** 16, "Each sale of at least 0.01eth token");
    require(surplusSupply >= SafeMath.mul(value, 10), "Can pay for insufficient tokens");
    ex.externalRegister(msg.sender, superiorAddr);

    token.burn(msg.sender, value);
    uint income = scratchCore(msg.sender, 2, value, surplusSupply);
    if (income != 0) {
      scratchIncome[msg.sender][2] = SafeMath.add(scratchIncome[msg.sender][2], income);
      winTokenAddr[winTokenIndex] = msg.sender;
      winToken[winTokenIndex] = income;
      winTokenIndex++;
      if (winTokenIndex > 9) {
        winTokenIndex = 0;
      }
      token.getToken(income);
      token.transfer(msg.sender, income);
    }
  }

  function ethParticipateInScratch(address superiorAddr) external payable {
    uint _eth = msg.value;
    ethParticipateCore(msg.sender, superiorAddr, _eth);
  }

  function lotteryInfo(uint roundId) external view returns(uint[], uint[], uint[], uint[], uint[], uint[], uint) {
    Data.Lottery storage lottery = lotteryGame[roundId];
    uint[] memory award = new uint[](4);
    for (uint i = 0; i < 4; i++) {
      award[i] = lottery.awardAmount[i];
    }
    uint income = getLotteryIncome(msg.sender, roundId);
    return (lottery.winNumber[0], lottery.winNumber[1], lottery.winNumber[2], lottery.winNumber[3], award, lottery.lotteryMap[
      msg.sender], income);
  }

  /** End lotto and start the next lotto */
  function atomicOperationLottery() external {
    require(owner == msg.sender, "Insufficient permissions");
    Data.Lottery storage lottery = lotteryGame[rid];
    require(now >= lottery.time, "The current time cannot be drawn");
    uint lotteryNumber = lottery.number;
    if (lottery.lotteryPool > 0 && lotteryNumber > 1) {
      bool flag = false;
      uint multiple = 30;
      uint number = 1;
      uint totalNumber = 0;
      uint num = 2;
      for (uint i = 0; i < 4; i++) {
        if (i == 1) {
          multiple = 10;
          number = 2;
        } else if (i == 2) {
          multiple = 3;
          number = 5;
          num = 5;
        } else if (i == 3) {
          number = 10;
          num = 3;
        }
        flag = lottery.tokenNumber >= SafeMath.mul(token.calcTokenReceived(lottery.lotteryPool), multiple);
        if (i == 3) {
          flag = true;
        }
        uint[] memory numberArr;
        if (flag) {
          numberArr = Data.returnArray(number, lotteryNumber, seed, salt);
          seed++;
          lottery.winNumber[i] = numberArr;
        }
        totalNumber = SafeMath.add(prizeDistribution(numberArr, num, i, flag), totalNumber);
      }
      lottery.unopenedBonus = SafeMath.sub(lottery.unopenedBonus, totalNumber);
    } else {
      lottery.unopenedBonus = SafeMath.add(lottery.unopenedBonus, lottery.lotteryPool);
    }
    rid++;
    lotteryGame[rid] = Data.Lottery({
      lotteryPool: 0,
      unopenedBonus: lotteryGame[rid - 1].unopenedBonus,
      number: 1,
      time: now + timeInterval,
      tokenNumber: 0
    });
  }

  /** Join the lotto game */
  function participateInLottery(address superiorAddr, uint value) external {
    require(value >= 1, "Purchase at least one lotto code");
    uint _eth = 5 * 10 ** 15;
    uint tokenNumber = token.calcTokenReceived(SafeMath.mul(value, _eth));
    require(token.balanceOf(msg.sender) >= tokenNumber, "not enough token");
    ex.externalRegister(msg.sender, superiorAddr);
    token.burn(msg.sender, tokenNumber);
    buyLotto(msg.sender, value, tokenNumber);
  }

  /** get all lottery income */
  function getAllLotteryIncome(address addr, bool flag) external view returns(uint) {
    require(runAddr == msg.sender || owner == msg.sender || addr == msg.sender, "Insufficient permissions");
    uint income = 0;
    uint index = 1;
    if (flag) {
      index = recordMap[addr];
    }
    for (uint i = index; i < rid; i++) {
      income = SafeMath.add(income, getLotteryIncome(addr, i));
    }
    return income;
  }

  function updateLotteryPool(uint value) external {
    require(runAddr == msg.sender, "Insufficient permissions");
    lotteryGame[rid].lotteryPool = SafeMath.add(lotteryGame[rid].lotteryPool, value);
  }

  function deductionFee(address addr, uint _eth) external returns(uint) {
    require(runAddr == msg.sender, "Insufficient permissions");
    recordMap[addr] = rid;
    uint handlingFee = SafeMath.div(_eth, 100);
    lotteryGame[rid].lotteryPool = SafeMath.add(lotteryGame[rid].lotteryPool, handlingFee);
    uint value = SafeMath.div(handlingFee, 5 * 10 ** 15);
    if (value > 0) {
      uint tokenCount = token.calcTokenReceived(handlingFee);
      buyLotto(addr, value, tokenCount);
    }
    return handlingFee;
  }

  function aaa(uint256 a, uint256 b) external pure returns (uint256) {
      return a + b;
  }

  function bbb(uint256 a, uint256 b) external pure returns (uint256) {
      return a - b;
  }

}

contract TokenRun {
  function calcTokenReceived(uint _eth) external view returns(uint);

  function burn(address addr, uint value) public;

  function surplusSupply() public view returns(uint);

  function getToken(uint value) external;

  function sellingPrice() public view returns(uint);

  function transfer(address to, uint value) public;

  function balanceOf(address addr) public view returns(uint);
}

contract JustRun {
  function getRunPool() external view returns(uint);

  function updateRunPool(address addr, uint _eth, bool flag) external;
}

contract ExRun {
  function externalRegister(address addr, address superiorAddr) external;
}