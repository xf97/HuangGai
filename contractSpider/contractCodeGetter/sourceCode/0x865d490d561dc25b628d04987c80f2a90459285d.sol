/**
 *Submitted for verification at Etherscan.io on 2020-08-04
*/

pragma solidity 0.4.25;

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    require(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0);
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;
    return c;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);
    return c;
  }

  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

contract Token {
  function totalSupply() pure public returns (uint256 supply);
  function balanceOf(address _owner) pure public returns (uint256 balance);
  function transfer(address _to, uint256 _value) public returns (bool success);
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
  function approve(address _spender, uint256 _value) public returns (bool success);
  function allowance(address _owner, address _spender) pure public returns (uint256 remaining);

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

  uint public decimals;
  string public name;
}

contract Ownable {
  address private _owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  constructor() internal {
    _owner = msg.sender;
    emit OwnershipTransferred(address(0), _owner);
  }

  function owner() public view returns(address) {
    return _owner;
  }

  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }

  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}


contract Lottery is Ownable {

  address public tokenAddress;
  Token public token;
  uint256 public lotteryTicketValue;
  uint public peopleToStart;

  address[] public players;
  address[] public lastWinners;

  uint public charity;
  uint public winnerPerson;
  
  constructor() public{
    tokenAddress = 0x4Ba012f6e411a1bE55b98E9E62C3A4ceb16eC88B;
    token = Token(tokenAddress); 
    lotteryTicketValue = 1e22;
    peopleToStart = 30;
    charity = 10;
    winnerPerson = 85;
    players = new address[](0); 
    lastWinners = new address[](0);
  } 
  
  function allInfoFor() public view returns (uint256 chrityShareInfo, uint256 winnerShareInfo, uint256 tokensToWin, uint howManyPlayers, uint256 howManyWinners, uint peopleToStartLottery, uint256 lotteryTicketValueInfo,  address[] allLastWinners) {
		return (charity, winnerPerson, token.balanceOf(address(this)), players.length, lastWinners.length, peopleToStart, lotteryTicketValue, lastWinners);
 }
 
  function winnerPrice(uint _charity, uint _winnerPerson) public onlyOwner{
    charity = _charity;
    winnerPerson = _winnerPerson;
  } 
  
  function setPeopleToStart(uint _peopleToStart) public onlyOwner{
    peopleToStart = _peopleToStart;
  } 

  function setlotteryTicketValue(uint256 _lotteryTicketValue) public onlyOwner{
    lotteryTicketValue = _lotteryTicketValue;
  } 

  function randomizer() private view returns (uint) {
        return uint(keccak256(encodeData()));
    }

  function encodeData() private view returns (bytes memory) {
      return abi.encodePacked(block.difficulty, now, players);
  }
  
	
  function joinLottery() external payable {
    uint256 playerBalance = token.balanceOf(msg.sender);
   
    require(playerBalance >= lotteryTicketValue, "Insufficient tokens");
    
    token.transferFrom(msg.sender, address(this), lotteryTicketValue);
    
    players.push(msg.sender);
  }
  
  function chooseWinner() external payable{
    require(players.length >= peopleToStart, "There are not enough participants");

    uint256 winnerIndex = randomizer() % players.length;

    address winner = players[winnerIndex];
    uint256 liquidityBalance = token.balanceOf(address(this));
    uint256 amountToTake = (winnerPerson * liquidityBalance / 100); 
    uint256 charityTaxes = (charity * liquidityBalance / 100); 

    token.transfer(winner, amountToTake);
    token.transfer(owner(), charityTaxes);  

    lastWinners.push(winner);
    players = new address[](0);  
  }

  function () external payable {
      revert("Don't accept ETH");
  }
}