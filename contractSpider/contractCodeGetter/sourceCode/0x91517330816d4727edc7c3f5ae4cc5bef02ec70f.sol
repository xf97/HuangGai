/**
 *Submitted for verification at Etherscan.io on 2020-05-20
*/

pragma solidity ^0.4.26;


contract Owned {
    address public owner;
    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor () public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}



contract ERC20 {
  uint256 public totalSupply;
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool); //real elf
  //function transfer(address _to, uint256 _value) public;
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  //function burnTokens(uint256 _amount) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract LockMapping is Owned {

    using SafeMath for uint256;
	event NewReceipt(uint256 receiptId, address asset, address owner, uint256 endTime);

	address public asset = 0xbf2179859fc6D5BEE9Bf9158632Dc51678a4100e;
	uint256 public saveTime = 86400*15; //15 days;
    uint256 public receiptCount = 0;

	struct Receipt {

		address asset;		
	    address owner;
	    string targetAddress;
	    uint256 amount;
	    uint256 startTime;
	    uint256 endTime;
	    bool finished;

  	}


  	Receipt[] public receipts;

  	mapping (uint256 => address) private receiptToOwner;
  	mapping (address => uint256[]) private ownerToReceipts;


  	modifier haveAllowance(address _asset, uint256 _amount) {

  		uint256 allowance = ERC20(asset).allowance(msg.sender, address(this));
	    require(allowance >= _amount);
	    _;
	}

	modifier exceedEndtime(uint256 _id) {

	    require(receipts[_id].endTime != 0 && receipts[_id].endTime <= now);
	    _;
	}

	modifier notFinished(uint256 _id) {

	    require(receipts[_id].finished == false);
	    _;
	}


  	function _createReceipt(
  		address _asset,
  		address _owner,
  		string _targetAddress,
  		uint256 _amount,
  		uint256 _startTime,
  		uint256 _endTime,
  		bool _finished
  		) internal {

	    uint256 id = receipts.push(Receipt(_asset, _owner, _targetAddress, _amount, _startTime, _endTime, _finished)) - 1;

        receiptCount = id + 1;
	    receiptToOwner[id] = msg.sender;
	    ownerToReceipts[msg.sender].push(id);
	    emit NewReceipt(id, _asset, _owner, _endTime);
	}


	//create new receipt
	function createReceipt(uint256 _amount, string targetAddress) external haveAllowance(asset,_amount) {

		//other processes

		//deposit token to this contract
		require (ERC20(asset).transferFrom(msg.sender, address(this), _amount));

		//
	    _createReceipt(asset, msg.sender, targetAddress, _amount, now, now + saveTime, false );
  	}

  	//finish the receipt and withdraw bonus and token
  	function finishReceipt(uint256 _id) external notFinished(_id) exceedEndtime(_id) {
        // only receipt owner can finish receipt
        require (msg.sender == receipts[_id].owner);
        ERC20(asset).transfer(receipts[_id].owner, receipts[_id].amount );
	    receipts[_id].finished = true;
  	}

    function getMyReceipts(address _address) external view returns (uint256[]){

        return ownerToReceipts[_address];

    }

    function getLockTokens(address _address) external view returns (uint256){
        uint256[] memory myReceipts = ownerToReceipts[_address!=address(0) ? _address:msg.sender];
        uint256 amount = 0;

        for(uint256 i=0; i< myReceipts.length; i++) {
            if(receipts[myReceipts[i]].finished == false){
                amount += receipts[myReceipts[i]].amount;
            }

        }

        return amount;
    }

  	function fixSaveTime(uint256 _period) external onlyOwner {
  		saveTime = _period;
  	}

    function getReceiptInfo(uint256 index) public view returns(bytes32, string, uint256, bool){

        return (sha256(index), receipts[index].targetAddress, receipts[index].amount, receipts[index].finished);

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