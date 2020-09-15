pragma solidity > 0.6.1 < 0.7.0;

import "./provableAPI_0.6.sol";

interface IERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  function mint(address account, uint256 amount) external;
  function burn(address account, uint256 amount) external;
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Owned {
  address public owner;
  address public newOwner;

  event OwnershipTransferred(address indexed _from, address indexed _to);

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address _newOwner) public onlyOwner {
    newOwner = _newOwner;
  }
  function acceptOwnership() public {
    require(msg.sender == newOwner);
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
    newOwner = address(0);
  }
}

contract xETHFlip is Owned, usingProvable {
  using SafeMath for uint;

  event BetEvent(bytes32 queryId, address account, uint256 amount);
  event BetOutcome(bytes32 queryId, address account, uint256 amount, bool win);
  event LogNewProvableQuery(string description);

  constructor() public {
    provable_setProof(proofType_Ledger);
    provable_setCustomGasPrice(5000000000);
    maximumBetRatio = 10;
    minimumBet = 10**16;
    tokenBase = 100 * 10**18;
    tokenRatio = 10000 * 10**6;
    odds = 47;
  }

  uint256 GAS_FOR_CALLBACK = 200000;
  uint256 public minimumBet;
  uint256 public maximumBetRatio;
  uint256 public odds;

  IERC20 token;
  uint256 public tokenBase;
  uint256 public tokenRatio;

  struct betstruct {
    address payable account;
    uint256 amount;
    bool resolved;
  }

  mapping(bytes32 => betstruct) public bets;

  receive() external payable {
    uint256 _eth = msg.value;
    uint256 _maximumBet = getMaximumBet();
    uint256 _toMint = _eth.mul(tokenRatio).div(10**6).add(tokenBase);

    token.mint(msg.sender, _toMint);

    if (_eth > _maximumBet) {
      revert();
    }

    else if(_eth >= minimumBet) {
      uint256 QUERY_EXECUTION_DELAY = 0;

      bytes32 _queryId =  provable_newRandomDSQuery(
        QUERY_EXECUTION_DELAY,
        NUM_RANDOM_BYTES_REQUESTED,
        GAS_FOR_CALLBACK
      );

      bets[_queryId].account = msg.sender;
      bets[_queryId].amount = _eth;

      emit BetEvent(_queryId, msg.sender, _eth);
    }
  }

  function getMaximumBet() public view returns(uint256) {
    uint256 _amount = address(this).balance.div(maximumBetRatio);
    return(_amount);
  }

  function setToken(IERC20 _token) public onlyOwner() {
    token = _token;
  }
  function setTokenBase(uint256 _amount) public onlyOwner() {
    tokenBase = _amount;
  }
  function setTokenRatio(uint256 _amount) public onlyOwner() {
    tokenRatio = _amount;
  }
  function setMinimumBet(uint256 _amount) public onlyOwner() {
    minimumBet = _amount;
  }
  function setMaximumBet(uint256 _amount) public onlyOwner() {
    maximumBetRatio = _amount;
  }
  function setOdds(uint256 _odds) public onlyOwner() {
    odds = _odds;
  }
  function receiveBank() public payable {
  }
  function withdrawBank(uint256 amount) public onlyOwner() {
    address payable account = msg.sender;
    account.transfer(amount);
  }
  function setprovablegasprice(uint256 _price) public onlyOwner() {
    provable_setCustomGasPrice(_price);
  }
  function setgasforcallback(uint256 _gas) public onlyOwner() {
    GAS_FOR_CALLBACK = _gas;
  }
  function withdrawTokens(IERC20 _token, uint256 _amount) public onlyOwner() {
    _token.transfer(msg.sender, _amount);
  }

  uint256 constant MAX_INT_FROM_BYTE = 256;
  uint256 constant NUM_RANDOM_BYTES_REQUESTED = 7;

  function __callback(
    bytes32 _queryId,
    string memory _result,
    bytes memory _proof
  )
  override
  public
  {
    require(msg.sender == provable_cbAddress());

    if (
      provable_randomDS_proofVerify__returnCode(
        _queryId,
        _result,
        _proof
      ) != 0
    ) {

    } else {

      uint256 _returnValue = uint256(keccak256(abi.encodePacked(_result))) % 100;

      if(_returnValue < odds) {
        address payable _account = bets[_queryId].account;
        uint256 _amount = bets[_queryId].amount.mul(2);
        _account.transfer(_amount);
        emit BetOutcome(_queryId, bets[_queryId].account, bets[_queryId].amount, true);
      }
      else {
        emit BetOutcome(_queryId, bets[_queryId].account, bets[_queryId].amount, false);
      }

    }
  }


}

library SafeMath {
  /**
  * @dev Returns the addition of two unsigned integers, reverting on
  * overflow.
  *
  * Counterpart to Solidity's `+` operator.
  *
  * Requirements:
  * - Addition cannot overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

  /**
  * @dev Returns the subtraction of two unsigned integers, reverting on
  * overflow (when the result is negative).
  *
  * Counterpart to Solidity's `-` operator.
  *
  * Requirements:
  * - Subtraction cannot overflow.
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }

  /**
  * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
  * overflow (when the result is negative).
  *
  * Counterpart to Solidity's `-` operator.
  *
  * Requirements:
  * - Subtraction cannot overflow.
  *
  * _Available since v2.4.0._
  */
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Returns the multiplication of two unsigned integers, reverting on
  * overflow.
  *
  * Counterpart to Solidity's `*` operator.
  *
  * Requirements:
  * - Multiplication cannot overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

  /**
  * @dev Returns the integer division of two unsigned integers. Reverts on
  * division by zero. The result is rounded towards zero.
  *
  * Counterpart to Solidity's `/` operator. Note: this function uses a
  * `revert` opcode (which leaves remaining gas untouched) while Solidity
  * uses an invalid opcode to revert (consuming all remaining gas).
  *
  * Requirements:
  * - The divisor cannot be zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }

  /**
  * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
  * division by zero. The result is rounded towards zero.
  *
  * Counterpart to Solidity's `/` operator. Note: this function uses a
  * `revert` opcode (which leaves remaining gas untouched) while Solidity
  * uses an invalid opcode to revert (consuming all remaining gas).
  *
  * Requirements:
  * - The divisor cannot be zero.
  *
  * _Available since v2.4.0._
  */
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
  * Reverts when dividing by zero.
  *
  * Counterpart to Solidity's `%` operator. This function uses a `revert`
  * opcode (which leaves remaining gas untouched) while Solidity uses an
  * invalid opcode to revert (consuming all remaining gas).
  *
  * Requirements:
  * - The divisor cannot be zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }

  /**
  * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
  * Reverts with custom message when dividing by zero.
  *
  * Counterpart to Solidity's `%` operator. This function uses a `revert`
  * opcode (which leaves remaining gas untouched) while Solidity uses an
  * invalid opcode to revert (consuming all remaining gas).
  *
  * Requirements:
  * - The divisor cannot be zero.
  *
  * _Available since v2.4.0._
  */
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}
