/**
 *Submitted for verification at Etherscan.io on 2020-08-16
*/

pragma solidity ^0.5.15;

library SafeMath {
	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a + b;
		require(c >= a, "SafeMath: addition overflow");

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
	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		if (a == 0) {
			return 0;
		}

		uint256 c = a * b;
		require(c / a == b, "SafeMath: multiplication overflow");

		return c;
    }
	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		return div(a, b, "SafeMath: division by zero");
	}
	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
		// Solidity only automatically asserts when dividing by 0
		require(b > 0, errorMessage);
		uint256 c = a / b;

		return c;
	}
	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
		return mod(a, b, "SafeMath: modulo by zero");
	}
	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
		require(b != 0, errorMessage);
		return a % b;
	}
}

library Address {
	function isContract(address account) internal view returns (bool) {
		bytes32 codehash;
		bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
		assembly { codehash := extcodehash(account) }
		return (codehash != 0x0 && codehash != accountHash);
	}
	function toPayable(address account) internal pure returns (address payable) {
		return address(uint160(account));
	}
	function sendValue(address payable recipient, uint256 amount) internal {
		require(address(this).balance >= amount, "Address: insufficient balance");
		(bool success, ) = recipient.call.value(amount)("");
		require(success, "Address: unable to send value, recipient may have reverted");
	}
}

library SafeERC20 {
	using SafeMath for uint256;
	using Address for address;

	function safeTransfer(IERC20 token, address to, uint256 value) internal {
		callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
	}

	function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
		callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
	}

	function safeApprove(IERC20 token, address spender, uint256 value) internal {
		require((value == 0) || (token.allowance(address(this), spender) == 0), "SafeERC20: approve from non-zero to non-zero allowance");
		callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
	}
	function callOptionalReturn(IERC20 token, bytes memory data) private {
		require(address(token).isContract(), "SafeERC20: call to non-contract");
		(bool success, bytes memory returndata) = address(token).call(data);
		require(success, "SafeERC20: low-level call failed");

		if (returndata.length > 0) {
			require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
		}
	}
}

interface IERC20 {
	function totalSupply() external view returns (uint256);
	function balanceOf(address account) external view returns (uint256);
	function transfer(address recipient, uint256 amount) external returns (bool);
	function allowance(address owner, address spender) external view returns (uint256);
	function decimals() external view returns (uint256);
	function approve(address spender, uint256 amount) external returns (bool);
	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface StakingPool {
	function getReward() external;
	function stake(uint256) external;
	function balanceOf(address) external view returns (uint256);
	function exit() external;
}

interface UniswapRouter {
	function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
	function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint amountA, uint amountB, uint liquidity);
	function removeLiquidity(address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB);
}

contract YamAutomation {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;
	
	address constant private _yam = address(0x0e2298E3B3390e3b945a5456fBf59eCc3f55DA16);
	address constant private _ycrv = address(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8);
	address constant private _univ2 = address(0x2C7a51A357d5739C5C74Bf3C96816849d2c9F726);
	address constant private _stakingpool = address(0xADDBCd6A68BFeb6E312e82B30cE1EB4a54497F4c);
	address constant private _unirouter = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
	
	address public owner;
    
    modifier isOwner() {
        require(msg.sender == owner, "No owner");
        _;
    }
    
    constructor() public {
        owner = msg.sender;
        IERC20(_univ2).safeApprove(_stakingpool, uint(-1));
        IERC20(_yam).safeApprove(_unirouter, uint(-1));
        IERC20(_ycrv).safeApprove(_unirouter, uint(-1));
    }
    
    function balanceStaked() public view returns (uint256 balance) {
        balance = StakingPool(_stakingpool).balanceOf(address(this));
    }
    
    function balanceOfToken(address token) public view returns (uint256 balance) {
        balance = IERC20(token).balanceOf(address(this));
    }
    
    function deposit(uint256 amount) external isOwner() {
        require(IERC20(_univ2).balanceOf(msg.sender) > 0, "not enough token to deposit");
        
        IERC20(_univ2).safeTransferFrom(msg.sender, address(this), amount);
        StakingPool(_stakingpool).stake(amount);
    }
    
    function exit() external isOwner() {
        require(balanceStaked() > 0, "not enough token to withdraw");
        
        StakingPool(_stakingpool).exit();
        
        UniswapRouter(_unirouter).removeLiquidity(
            _yam,
            _ycrv,
            IERC20(_univ2).balanceOf(address(this)),
            0,
            0,
            msg.sender,
            block.timestamp.add(1800)
            );
        
        IERC20(_yam).transfer(msg.sender,IERC20(_yam).balanceOf(address(this)));
        IERC20(_ycrv).transfer(msg.sender,IERC20(_ycrv).balanceOf(address(this)));
    }
    
    function reinvest() external isOwner() {
        StakingPool(_stakingpool).getReward();
        
        address[] memory path2 = new address[](2);
        path2[0] = address(_yam);
        path2[1] = address(_ycrv);
        
        UniswapRouter(_unirouter).swapExactTokensForTokens(
            IERC20(_yam).balanceOf(address(this)).div(2),
            0,
            path2,
            address(this),
            block.timestamp.add(1800)
		);
		
        UniswapRouter(_unirouter).addLiquidity(
            _yam,
            _ycrv,
            IERC20(_yam).balanceOf(address(this)),
            IERC20(_ycrv).balanceOf(address(this)),
            0,
            0,
            address(this),
            block.timestamp.add(1800)
		);
		
		StakingPool(_stakingpool).stake(IERC20(_univ2).balanceOf(address(this)));
    }
    
    
    //EMERGENCY FUNCTIONS
    function individualApproval(address token, address contractSpender) public isOwner() {
        IERC20(token).safeApprove(contractSpender, uint(-1));    
    }
    
    function withdraw(address token) external isOwner() {
        require(IERC20(token).balanceOf(address(this)) > 0, "no balance of token");
        
        IERC20(token).transfer(msg.sender,IERC20(token).balanceOf(address(this)));
    }
    
    function exitWithoutRemoveLiquidity() external isOwner() {
        StakingPool(_stakingpool).exit();
        
        IERC20(_univ2).transfer(msg.sender,IERC20(_univ2).balanceOf(address(this)));
        IERC20(_yam).transfer(msg.sender,IERC20(_yam).balanceOf(address(this)));
    }
	
    function exitPool() external isOwner() {
        StakingPool(_stakingpool).exit();
    }
    //EMERGENCY FUNCTIONS
}