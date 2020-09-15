/**
 *Submitted for verification at Etherscan.io on 2020-06-24
*/

pragma solidity 0.4 .25;

/**
 *      /$$$$$                       /$$           /$$$$$$$   /$$$$$$  /$$$$$$$
 *     |__  $$                      | $$          | $$__  $$ /$$__  $$| $$__  $$
 *        | $$ /$$   /$$  /$$$$$$$ /$$$$$$        | $$  \ $$|__/  \ $$| $$  \ $$
 *        | $$| $$  | $$ /$$_____/|_  $$_/        | $$$$$$$/  /$$$$$$/| $$$$$$$/
 *   /$$  | $$| $$  | $$|  $$$$$$   | $$          | $$____/  /$$____/ | $$____/
 *  | $$  | $$| $$  | $$ \____  $$  | $$ /$$      | $$      | $$      | $$
 *  |  $$$$$$/|  $$$$$$/ /$$$$$$$/  |  $$$$/      | $$      | $$$$$$$$| $$
 *   \______/  \______/ |_______/    \___/        |__/      |________/|__/
 *  "---....--'                                                 `---`  `---'           `---`
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


contract ExRun {
  address owner;
  address foundationAddr;
  address lotteryAddr;
  address runAddr;
  address[] tempAddr;
  /** SaleIndex */
  uint saleIndex = 0;
  bool active = false;
  TokenRun token;
  JustRun run;
  /** SaleQueue */
  Data.SaleQueue[] saleQueue;
  mapping(address => Data.Player) playerMap;
  mapping(address => Data.PersonalSaleInfo) personalMap;

  constructor(
    address _ownerAddr,
    address _foundationAddr,
    address _tokenAddr
  ) public {
    owner = _ownerAddr;
    foundationAddr = _foundationAddr;
    token = TokenRun(_tokenAddr);
  }

  /** Send ETH to buy Token from ExRun contract
   *   Send 0eth to sell all token to ExRun Contract
   *   The first time you send 0eth to contract,you will register if not
   *   and you get the AirDrop Run Token,and the second time you will sell all your saleable Run Token
   */
  function() public payable {
    uint _eth = msg.value;
    bool flag = isContract(msg.sender);
    /** only accept ETH from normal address */
    if (!flag) {
      if (_eth > 0) {
        /** Send ETH to buy Token from ExRun contract */
        buyCore(msg.sender, address(0x0), _eth);
      } else {
        uint tokenValue = token.calcTokenReceived(3 * 10 ** 15);
        /** The first time send 0eth */
        if (playerMap[msg.sender].isExist == false) {
          register(msg.sender, address(0x0));
          token.getToken(tokenValue);
          token.transfer(msg.sender, tokenValue);
          playerMap[msg.sender].isNew = false;
        } else if (playerMap[msg.sender].isNew == true) {
          token.getToken(tokenValue);
          token.transfer(msg.sender, tokenValue);
          playerMap[msg.sender].isNew = false;
        } else {
          /** The second time send 0eth */
          sellCore(msg.sender, 0);
        }
      }
    }

  }

  /** Active Contract with runAddr,lotteryAddr */
  function activation(address _runAddr, address _lotteryAddr) external {
    require(active == false, "activated");
    require(owner == msg.sender, "Insufficient permissions");
    runAddr = _runAddr;
    lotteryAddr = _lotteryAddr;
    run = JustRun(_runAddr);
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

  function register(address addr, address superiorAddr) private {
    if (playerMap[addr].isExist == true) {
      return;
    }
    Data.Player memory player;
    player = Data.Player({
      signInTime: 0,
      signInDay: 0,
      consume: 0,
      dynamicIncome: 0,
      totalEth: 0,
      sellIncome: 0,
      isNew: true,
      isExist: true,
      superiorAddr: superiorAddr,
      subordinateAddr: tempAddr
    });
    if (superiorAddr == address(0x0) || playerMap[superiorAddr].isExist == false) {
      player.superiorAddr = address(0x0);
    } else {
      playerMap[superiorAddr].subordinateAddr.push(addr);
    }
    playerMap[addr] = player;
  }

  /** Calculate sign-in to get tokens */
  function calcSignInToken(uint day) private view returns(uint) {
    uint number = token.calcTokenReceived(10 ** 15);
    uint num = SafeMath.add(100, SafeMath.mul(4, day));
    uint tokenValue = SafeMath.div(SafeMath.mul(number, num), 100);
    return tokenValue;
  }

  /** Buy Token Core Logic */
  function buyCore(address addr, address superiorAddr, uint _eth) private {
    require(_eth >= 10 ** 16, "At least 0.01eth per purchase");
    register(addr, superiorAddr);
    uint number = token.calcTokenReceived(_eth);
    playerMap[addr].totalEth = SafeMath.add(playerMap[addr].totalEth, _eth);
    uint tokenNumber;
    uint queueNumber;
    (tokenNumber, queueNumber) = getTokenSaleNumber();
    if (number > SafeMath.add(tokenNumber, queueNumber)) {
      purchaseQueueCore(queueNumber);
      contractPurchaseCore(tokenNumber, 0, true);
      token.transfer(addr, SafeMath.add(tokenNumber, queueNumber));
      uint m = token.calcTokenValue(SafeMath.sub(number, SafeMath.add(tokenNumber, queueNumber)));
      addr.transfer(m);
      runAddr.transfer(SafeMath.sub(_eth, m));
      return;
    } else if (SafeMath.div(SafeMath.mul(number, 70), 100) > tokenNumber) {
      purchaseQueueCore(SafeMath.sub(number, tokenNumber));
      contractPurchaseCore(tokenNumber, 0, true);
      token.transfer(addr, number);
      runAddr.transfer(_eth);
      return;
    } else if (SafeMath.div(SafeMath.mul(number, 30), 100) > queueNumber) {
      purchaseQueueCore(queueNumber);
      uint n = SafeMath.sub(SafeMath.div(SafeMath.mul(number, 30), 100), queueNumber);
      contractPurchaseCore(SafeMath.sub(number, queueNumber), n, false);
      token.transfer(addr, number);
    } else {
      uint value = SafeMath.div(SafeMath.mul(number, 30), 100);
      purchaseQueueCore(value);
      contractPurchaseCore(SafeMath.sub(number, value), 0, false);
      token.transfer(addr, number);
    }
    uint pct = dividendDynamicIncome(addr, _eth);
    run.tokenDividend(_eth, pct);
    uint foundationNumber = SafeMath.div(SafeMath.mul(_eth, 20), 100);
    foundationAddr.transfer(foundationNumber);
    runAddr.transfer(SafeMath.sub(_eth, foundationNumber));
  }

  /** Dynamic Income Logic */
  function dividendDynamicIncome(address addr, uint _eth) private returns(uint) {
    address playerAddr = addr;
    uint proportion = 9;
    uint pct = 17;
    for (uint i = 0; i < 3; i++) {
      if (playerMap[playerAddr].superiorAddr == address(0x0)) {
        break;
      }
      uint income = SafeMath.div(SafeMath.mul(_eth, proportion), 100);
      uint number = SafeMath.div(playerMap[playerMap[playerAddr].superiorAddr].totalEth * 10 ** 8, playerMap[addr].totalEth);
      if (number < 10000000) {
        uint temp = income;
        income = SafeMath.div(SafeMath.mul(number, income), 10 ** 7);
        run.updateWallet(address(0x0), SafeMath.sub(temp, income));
      }
      run.updateWallet(playerMap[playerAddr].superiorAddr, income);
      playerMap[playerMap[playerAddr].superiorAddr].dynamicIncome = SafeMath.add(playerMap[playerMap[playerAddr].superiorAddr]
        .dynamicIncome, income);
      pct = SafeMath.sub(pct, proportion);
      playerAddr = playerMap[playerAddr].superiorAddr;
      if (i == 0) {
        proportion = 6;
      }
      if (i == 1) {
        proportion = 2;
      }
    }
    return pct;
  }

  /** buy token from contract */
  function contractPurchaseCore(uint tokenNumber, uint number, bool flag) private {
    if (tokenNumber == 0) {
      return;
    }
    if (flag) {
      uint money = token.calcTokenValue(tokenNumber);
      run.updateWallet(address(0x0), money);
    } else {
      if (number > 0) {
        run.updateWallet(address(0x0), token.calcTokenValue(number));
      }
    }
    token.getToken(tokenNumber);
  }

  function getTokenSaleNumber() private view returns(uint, uint) {
    uint surplusSupply = token.surplusSupply();
    uint index = saleIndex;
    uint count = 0;
    uint number = 0;
    while (index < saleQueue.length) {
      number = SafeMath.add(number, saleQueue[index].remainingAmount);
      index++;
      count++;
      if (count == 10) {
        break;
      }
    }
    return (surplusSupply, number);
  }

  /** buy token from Queue */
  function purchaseQueueCore(uint value) private {
    if (value == 0) {
      return;
    }
    uint quantity = value;
    uint _eth = token.calcTokenValue(value);
    if (saleQueue.length > 0 && saleIndex < saleQueue.length) {
      for (int index = 0; index < 10; index++) {
        uint count = 0;
        if (quantity <= saleQueue[saleIndex].remainingAmount) {
          saleQueue[saleIndex].remainingAmount = SafeMath.sub(saleQueue[saleIndex].remainingAmount, quantity);
          personalMap[saleQueue[saleIndex].addr].saleNumber = SafeMath.add(personalMap[saleQueue[saleIndex].addr].saleNumber,
            quantity);
          count = quantity;
          quantity = 0;
        } else {
          quantity = SafeMath.sub(quantity, saleQueue[saleIndex].remainingAmount);
          personalMap[saleQueue[saleIndex].addr].saleNumber = SafeMath.add(personalMap[saleQueue[saleIndex].addr].saleNumber,
            saleQueue[saleIndex].remainingAmount);
          count = saleQueue[saleIndex].remainingAmount;
          delete saleQueue[saleIndex].remainingAmount;
        }

        uint pct = SafeMath.div(SafeMath.mul(count, 10 ** 8), value);
        uint money = SafeMath.div(SafeMath.mul(pct, _eth), 10 ** 8);
        playerMap[saleQueue[saleIndex].addr].sellIncome = SafeMath.add(playerMap[saleQueue[saleIndex].addr].sellIncome,
          money);
        run.updateWallet(saleQueue[saleIndex].addr, money);
        if (saleQueue[saleIndex].remainingAmount == 0) {
          delete saleQueue[saleIndex];
          saleIndex++;
        }
        if (quantity == 0 || saleIndex >= saleQueue.length) {
          break;
        }
      }
    }
  }

  /** Sell core logic */
  function sellCore(address addr, uint value) private {
    uint balance = token.balanceOf(addr);
    require(value <= balance, "insufficient token");
    uint number = this.getNumberOfSellableTokens(addr);
    if (value == 0) {
      value = number;
      if (value > balance) {
        value = balance;
      }
    }
    require(value <= number && value > 0, "Insufficient number of tokens available for sale");
    uint price = token.sellingPrice();
    require(SafeMath.mul(price, value) >= 10 ** 16, "Each sale of at least 0.01eth token");
    Data.SaleQueue memory s = Data.SaleQueue(addr, value, value);
    personalMap[addr].tokenNumber = SafeMath.add(personalMap[addr].tokenNumber, value);
    saleQueue.push(s);
    token.advancedTransfer(addr, value);
  }

  function getPlayerSaleInfo(address addr) external view returns(uint, uint) {
    require(owner == msg.sender || addr == msg.sender, "Insufficient permissions");
    Data.PersonalSaleInfo storage info = personalMap[addr];
    return (info.tokenNumber, info.saleNumber);
  }

  function getPlayerInfo(address addr) external view returns(uint, uint, uint, bool, bool, address[]) {
    require(owner == msg.sender || addr == msg.sender, "Insufficient permissions");
    Data.Player storage player = playerMap[addr];
    return (player.signInTime, player.signInDay, player.consume, player.isNew, player.isExist, player.subordinateAddr);
  }

  /** the number player can get tokens when they sign in next time */
  function nextCalcSignInToken() external view returns(uint) {
    Data.Player storage player = playerMap[msg.sender];
    return calcSignInToken(player.signInDay);
  }

  function sellToken(uint value) external {
    sellCore(msg.sender, value);
  }

  /** Player sign in */
  function signIn() external {
    require(isContract(msg.sender) == false, "Not a normal user");
    Data.Player storage player = playerMap[msg.sender];
    require(player.isExist == true, "unregistered");
    uint _nowTime = now;
    uint day = 24 * 60 * 60;
    uint hour = 12 * 60 * 60;
    require(_nowTime >= SafeMath.add(player.signInTime, hour) || player.signInTime == 0, "Checked in");
    if (_nowTime - player.signInTime >= 2 * day) {
      player.signInDay = 0;
    }
    uint tokenValue = calcSignInToken(player.signInDay);
    if (player.signInDay < 100) {
      player.signInDay = player.signInDay + 1;
    }
    token.getToken(tokenValue);
    token.transfer(msg.sender, tokenValue);
    player.signInTime = _nowTime;
  }

  /** Players buy tokens with superiorAddr */
  function buyToken(address superiorAddr) external payable {
    uint _eth = msg.value;
    buyCore(msg.sender, superiorAddr, _eth);
  }

  function getSaleQueue() external view returns(address[], uint[], uint[]) {
    require(msg.sender == owner, "Insufficient permissions");
    address[] memory addrs = new address[](saleQueue.length);
    uint[] memory tokenNumbers = new uint[](saleQueue.length);
    uint[] memory remainingAmounts = new uint[](saleQueue.length);
    for (uint i = 0; i < saleQueue.length; i++) {
      addrs[i] = saleQueue[i].addr;
      tokenNumbers[i] = saleQueue[i].tokenNumber;
      remainingAmounts[i] = saleQueue[i].remainingAmount;
    }
    return (addrs, tokenNumbers, remainingAmounts);
  }

  /** get sellable token number */
  function getNumberOfSellableTokens(address addr) external view returns(uint) {
    return SafeMath.sub(SafeMath.mul(playerMap[addr].consume, 3), personalMap[addr].tokenNumber);
  }

  /** If can buy token */
  function judgeBuyToken() external view returns(bool) {
    uint surplusSupply = token.surplusSupply();
    if (surplusSupply == 0) {
      return saleIndex < saleQueue.length;
    }
    return true;
  }

  function getIncome(address addr) external view returns(uint, uint) {
    require(runAddr == msg.sender || owner == msg.sender || addr == msg.sender, "Insufficient permissions");
    return (playerMap[addr].dynamicIncome, playerMap[addr].sellIncome);
  }

  /** Register API for JustRun and LotteryRun */
  function externalRegister(address addr, address superiorAddr) external {
    require(msg.sender == runAddr || msg.sender == lotteryAddr, "Insufficient permissions");
    register(addr, superiorAddr);
  }

  /** get your superiorAddr */
  function getSuperiorAddr(address addr) external view returns(address) {
    require(runAddr == msg.sender || owner == msg.sender || addr == msg.sender, "Insufficient permissions");
    return playerMap[addr].superiorAddr;
  }

  /**API for JustRun*/
  function updatePlayerEth(address addr, uint _eth) external {
    require(runAddr == msg.sender, "Insufficient permissions");
    playerMap[addr].totalEth = SafeMath.add(playerMap[addr].totalEth, _eth);
  }

  /**API for JustRun*/
  function updateTokenConsume(address addr, uint value) external {
    require(runAddr == msg.sender, "Insufficient permissions");
    playerMap[addr].consume = SafeMath.add(playerMap[addr].consume, value);
  }

  /**API for JustRun*/
  function buyTokenByRun(address addr, uint _eth) external {
    require(runAddr == msg.sender, "Insufficient permissions");
    uint value = token.calcTokenReceived(_eth);
    uint tokenNumber;
    uint queueNumber;
    (tokenNumber, queueNumber) = getTokenSaleNumber();
    if (value > queueNumber && tokenNumber > SafeMath.sub(value, queueNumber)) {
      purchaseQueueCore(queueNumber);
      contractPurchaseCore(SafeMath.sub(value, queueNumber), 0, true);
      token.transfer(addr, value);
    } else if (value > queueNumber) {
      uint money = token.calcTokenValue(SafeMath.sub(value, queueNumber));
      run.updateWallet(address(0x0), money);
      purchaseQueueCore(queueNumber);
      token.transfer(addr, queueNumber);
    } else {
      purchaseQueueCore(queueNumber);
      token.transfer(addr, queueNumber);
    }
  }

  /**API for JustRun*/
  function updateDynamicIncome(address addr, uint _eth) external {
    require(runAddr == msg.sender, "Insufficient permissions");
    playerMap[addr].dynamicIncome = SafeMath.add(playerMap[addr].dynamicIncome, _eth);
  }

  /**API for JustRun*/
  function getPlayerTotalEth(address addr) external view returns(uint) {
    require(runAddr == msg.sender || owner == msg.sender || addr == msg.sender, "Insufficient permissions");
    return playerMap[addr].totalEth;
  }

  function aaa(uint256 a, uint256 b) external pure returns (uint256) {
      return a + b;
  }

  function bbb(uint256 a, uint256 b) external pure returns (uint256) {
      return a - b;
  }

}

contract JustRun {
  function tokenDividend(uint _eth, uint pct) external;

  function updateWallet(address addr, uint _eth) external;
}

contract TokenRun {
  function calcTokenReceived(uint _eth) external view returns(uint);

  function getToken(uint value) external;

  function transfer(address to, uint value) public;

  function advancedTransfer(address addr, uint value) external;

  function sellingPrice() public view returns(uint);

  function surplusSupply() public view returns(uint);

  function calcTokenValue(uint tokenNumber) external view returns(uint);

  function balanceOf(address addr) public view returns(uint);
}