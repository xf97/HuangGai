/**
 *Submitted for verification at Etherscan.io on 2020-07-28
*/

pragma solidity ^0.5.13;

library SafeMath {

    function mul(uint a, uint b) internal pure returns (uint) {
        uint c = a * b;
        require(a == 0 || c / a == b);
        return c;
    }

    function div(uint a, uint b) internal pure returns (uint) {
        require(b > 0);
        uint c = a / b;
        require(a == b * c + a % b);
        return c;
    }

    function sub(uint a, uint b) internal pure returns (uint) {
        require(b <= a);
        return a - b;
    }

    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a);
        return c;
    }

    function max64(uint64 a, uint64 b) internal pure returns (uint64) {
        return a >= b ? a : b;
    }

    function min64(uint64 a, uint64 b) internal pure returns (uint64) {
        return a < b ? a : b;
    }

    function max256(uint a, uint b) internal pure returns (uint) {
        return a >= b ? a : b;
    }

    function min256(uint a, uint b) internal pure returns (uint) {
        return a < b ? a : b;
    }
}

interface GeneralERC20 {
	function transfer(address to, uint256 value) external;
	function transferFrom(address from, address to, uint256 value) external;
	function approve(address spender, uint256 value) external;
	function balanceOf(address spender) external view returns (uint);
	function allowance(address owner, address spender) external view returns (uint);
}

library SafeERC20 {
	function checkSuccess()
		private
		pure
		returns (bool)
	{
		uint256 returnValue = 0;

		assembly {
			// check number of bytes returned from last function call
			switch returndatasize

			// no bytes returned: assume success
			case 0x0 {
				returnValue := 1
			}

			// 32 bytes returned: check if non-zero
			case 0x20 {
				// copy 32 bytes into scratch space
				returndatacopy(0x0, 0x0, 0x20)

				// load those bytes into returnValue
				returnValue := mload(0x0)
			}

			// not sure what was returned: don't mark as success
			default { }
		}

		return returnValue != 0;
	}

	function transfer(address token, address to, uint256 amount) internal {
		GeneralERC20(token).transfer(to, amount);
		require(checkSuccess());
	}

	function transferFrom(address token, address from, address to, uint256 amount) internal {
		GeneralERC20(token).transferFrom(from, to, amount);
		require(checkSuccess());
	}

	function approve(address token, address spender, uint256 amount) internal {
		GeneralERC20(token).approve(spender, amount);
		require(checkSuccess());
	}
}
// @TODO: should we use a newer solidity?
pragma experimental ABIEncoderV2;


/*contract ADXSupplyController {
	function mintBondFromBondBurn() public {
		// @TODO: check if this staking contract is allowed
		// this presumes the token of the staking contract as well
	}
}*/

contract ADXToken {
	using SafeMath for uint;

	// Constants
	string public constant symbol = "ADX";
	string public constant name = "AdEx Network";
	uint8 public constant decimals = 18;

	// Mutable variables
	uint public totalSupply;
	mapping(address => uint) balances;
	mapping(address => mapping(address => uint)) allowed;

	event Approval(address indexed owner, address indexed spender, uint amount);
	event Transfer(address indexed from, address indexed to, uint amount);

	address public supplyController = address(0);
	address public prevToken = address(0);
	constructor(address supplyControllerAddr, address prevTokenAddr) public {
		supplyController = supplyControllerAddr;
		prevToken = prevTokenAddr;
	}

	function balanceOf(address owner) public view returns (uint balance) {
		return balances[owner];
	}

	function transfer(address to, uint amount) public returns (bool success) {
		balances[msg.sender] = balances[msg.sender].sub(amount);
		balances[to] = balances[to].add(amount);
		emit Transfer(msg.sender, to, amount);
		return true;
	}

	function allowance(address owner, address spender) public view returns (uint remaining) {
		return allowed[owner][spender];
	}

	function approve(address spender, uint amount) public returns (bool success) {
		allowed[msg.sender][spender] = amount;
		emit Approval(msg.sender, spender, amount);
		return true;
	}

	function transferFrom(address from, address to, uint amount) public returns (bool success) {
		balances[from] = balances[from].sub(amount);
		allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
		balances[to] = balances[to].add(amount);
		emit Transfer(from, to, amount);
		return true;
	}

	// Supply control
	function mint(address owner, uint amount) public {
		require(msg.sender == supplyController);
		totalSupply = totalSupply.add(amount);
		balances[owner] = balances[owner].add(amount);
		// Because of https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer-1
		emit Transfer(address(0), owner, amount);
	}

	function upgradeSupplyController(address newSupplyController) public {
		require(msg.sender == supplyController);
		supplyController = newSupplyController;
	}

	// Swapping: multiplier is 10**(18-4)
	uint constant PREV_TO_CURRENT_TOKEN_MULTIPLIER = 100000000000000;
	function swap(uint prevTokenAmount) public {
		uint amount = prevTokenAmount.mul(PREV_TO_CURRENT_TOKEN_MULTIPLIER);
		totalSupply = totalSupply.add(amount);
		balances[msg.sender] = balances[msg.sender].add(amount);
		SafeERC20.transferFrom(prevToken, msg.sender, address(0), prevTokenAmount);
	}
}