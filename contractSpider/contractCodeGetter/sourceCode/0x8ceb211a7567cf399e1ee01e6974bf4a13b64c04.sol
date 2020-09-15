/**
 *Submitted for verification at Etherscan.io on 2020-08-13
*/

pragma solidity >=0.5.0;

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

contract Ownable {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () public {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

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

interface IUniswapV2Pair {
    function sync() external;
}

interface IRebaseableERC20 {
    function balanceOf(address who) external view returns (uint256);
    function rebase(uint256 epoch, uint256 supplyDelta) external returns (uint256);
    function totalSupply() external view returns (uint256);
    function transferOwnership(address newOwner) external;
}

interface IExchangeRates {
    function calculateExchangeRateFor(IERC20 token1, IERC20 token2, address pool, uint256 decimals1, uint256 decimals2, uint256 addedDecimals) external view returns(uint256);
    function calculateUsdForToken(address token, address pool, uint256 tokenDecimals, uint256 precision) external view returns(uint256);
    function getUsdEtherPrice() external view returns(uint256);
}

contract Rebaser is Ownable {
    using SafeMath for uint256;
    
    IUniswapV2Pair public pool = IUniswapV2Pair(0x6c35c40447E8011a63aB05f088fa7cD914d66904); // Address of the IUniswapV2Pair for Weth / Token
    
    IRebaseableERC20 public token = IRebaseableERC20(0xf911a7ec46a2c6fa49193212fe4a2a9B95851c27);
    uint256 public tokenDecimals = 9;
    
    IExchangeRates rates = IExchangeRates(0x3eAfb425e22beCFAB10754Ef8BDE68B2AB640384);
    
    uint256 public lastRebase;
    uint256 public timeBetweenRebases = 24 hours;
    uint256 public lastExchangeRate = 0;
    
    bool public guarded = true;
    
    event RebaseSuccess(uint256 oldPrice, uint256 newPrice, uint256 delta);
    event RebaseFail(uint256 oldPrice, uint256 newPrice);
    
    constructor() public {
        lastRebase = now;
        lastExchangeRate = currentExchangeRate();
    }
    
    // Enforces only owner if the guarded 
    modifier onlyOwnerIfGuarded {
        canOperateRebase(msg.sender);
        _;
    }
    
    // Public function to return if address can operate rebase or not
    function canOperateRebase(address _a) public view returns(bool) {
        return ((guarded == false) || (_a == _owner));
    }
    
    // Size of next rebase
    function nextSupplyDelta() public view returns(uint256) {
        uint256 currentSupply = token.totalSupply();
        if (currentSupply < 100) {
            return 0;
        }
        return currentSupply.div(100);
    }
    
    // Public shouldRebase
    function shouldRebase(uint256 exchangeRate) public view returns(bool) {
        if (exchangeRate < lastExchangeRate) {
            return true;
        }
        return false;
    }
    
    // Public exchange rate variable
    function currentExchangeRate() public view returns(uint256) {
        return rates.calculateUsdForToken({
            token: address(token),
            pool: address(pool),
            tokenDecimals: tokenDecimals,
            precision: 4
        });
    }
    
    // Fully open rebasing. Openned to the public when the owner calls unguard
    function rebase() public onlyOwnerIfGuarded {
        require(now > lastRebase.add(timeBetweenRebases));
        
        uint256 exchangeRate = currentExchangeRate();
        
        if (shouldRebase(exchangeRate)) {
            uint256 supplyDelta = nextSupplyDelta();
            token.rebase(0, supplyDelta);
            pool.sync();
            emit RebaseSuccess(lastExchangeRate, exchangeRate, supplyDelta);
        }
        else {
            emit RebaseFail(lastExchangeRate, exchangeRate);
        }
        
        lastRebase = now;
        lastExchangeRate = exchangeRate;
    }
    
    /*
     MANAGEMENT AND TESTING.
    */
    // Switches contract from completely owner operated to public operated and gives up management rights.
    function unguard() public onlyOwner {
        guarded = false;
    }
    
    // Only owner operated manual rebasing. This right is given up when unguard() is called
    function _rebase() public onlyOwner {
        require(guarded == true);
        
        // Get current exchange rate
        uint256 exchangeRate = currentExchangeRate();
        
        // Get the proper supply delta
        uint256 supplyDelta = nextSupplyDelta();
        
        // Rebase and sync liquidity
        token.rebase(0, supplyDelta);
        pool.sync();
        
        // Emit success for external services to take action
        emit RebaseSuccess(lastExchangeRate, exchangeRate, supplyDelta);
        
        // Sync the state
        lastRebase = now;
        lastExchangeRate = exchangeRate;
    }
    
    // Syncs the exchange rate and rebase to the current transaction state. This right is given up when unguard() is called
    function refresh() public onlyOwner {
        require(guarded == true);
        
        lastExchangeRate = currentExchangeRate();
        lastRebase = now;
    }
    
    // Change token to test rebase
    function changeToken(address _token) public onlyOwner {
        require(guarded == true);
        token = IRebaseableERC20(_token);
    }
    
    // Change pool to test
    function changePool(address _pool) public onlyOwner {
        require(guarded == true);
        pool = IUniswapV2Pair(_pool);
    }
    
    // Modifies the period between rebases
    function changePeriod(uint256 _t) public onlyOwner {
        require(guarded == true);
        timeBetweenRebases = _t;
    }
    
    /*
     OWNERSHIP
    */
    // Transfers the rebase token to a new owner. This right is relinquished by renouncing ownership of the oracle.
    function transferTokenOwnership(address newOwner) public onlyOwner {
        token.transferOwnership(newOwner);
    }
}