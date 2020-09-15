/**
 *Submitted for verification at Etherscan.io on 2020-06-26
*/

// SPDX-License-Identifier: MIT

// Some math and mining capability borrowed from _0xBitcoinToken
// Which can be found at https://etherscan.io/address/0xb6ed7644c69416d67b522e20bc294a9a9b405b31#code

pragma solidity ^0.6.0;

// -----------------------------------------

// Standard Context Getter
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol

// -----------------------------------------

contract Context {
    constructor () internal { }
    
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }
    
    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

// -----------------------------------------

// Essential functions for ERC20 implementation
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol

// -----------------------------------------

interface IERC20 {
    function totalSupply() external view returns (uint256);
    
    function balanceOf(address account) external view returns (uint256);
    
    function transfer(address recipient, uint256 amount) external returns (bool);
    
    function allowance(address owner, address spender) external view returns (uint256);
    
    function approve(address spender, uint256 amount) external returns (bool);
    
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// -----------------------------------------

// Optional functions from the ERC20 standard 
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20Detailed.sol

// -----------------------------------------

abstract contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    
    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }
    
    function name() public view returns (string memory) {
        return _name;
    }
    
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

// -----------------------------------------

// Safe Math
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol

// -----------------------------------------

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
        // assert(a== b * c + a % b); // This will always hold
        
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

// -----------------------------------------

// Implementation of ERC20 interface
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol

// -----------------------------------------

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _burnFrom(address account, uint256 amount) internal virtual {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

// -----------------------------------------

// Math and mining capability borrowed from _0xBitcoinToken
// https://etherscan.io/address/0xb6ed7644c69416d67b522e20bc294a9a9b405b31#code

// -----------------------------------------

library ExtendedMath {
    // Return the smaller of the two inputs (a or b)
    function limitLessThan(uint a, uint b) internal pure returns (uint c) {
        if(a > b) return b;
        return a;
    }
}

contract Units is ERC20, ERC20Detailed {
    using SafeMath for uint;
    using ExtendedMath for uint;
    
    address public lastRewardTo;
    uint public lastRewardAmount;
    uint public lastRewardEthBlockNumber;
    
    uint public miningTarget;
    bytes32 public challengeNumber;
    
    uint public latestDifficultyPeriodStarted;
    uint public epochCount;
    uint public rewardEra;
    uint public currentMonthlyRate;
    
    uint[4] public bonusEraMonthlyRate;
    uint[4] public bonusEraLengthInMonths;
    uint[4] public maxSupplyForBonusEra;
    uint public lastBonusEra;
    uint public standardEraMonthlyRate;
    
    uint public _BLOCKS_PER_READJUSTMENT = 1024;
    uint public _MINIMUM_TARGET = 2**16; // Hardest
    uint public _MAXIMUM_TARGET = 2**255; // Easiest
    
    
    bool locked = false;
    mapping(bytes32 => bytes32) solutionForChallenge; // Digested solutions
    
    
    // -----------------------------------------
    
    // Constructor
    
    // -----------------------------------------
    constructor() ERC20Detailed("Units", "UNTS", 18) public {
        if(locked) revert();
        locked = true;
        
        // Era rules
        bonusEraMonthlyRate = [7111*10**4 * 10**uint(decimals()),
                               3556*10**4 * 10**uint(decimals()),
                               1778*10**4 * 10**uint(decimals()),
                               8889*10**3 * 10**uint(decimals())];
                               
        maxSupplyForBonusEra = [6133*10**5 * 10**uint(decimals()),
                                7200*10**5 * 10**uint(decimals()),
                                7733*10**5 * 10**uint(decimals()),
                                8000*10**5 * 10**uint(decimals())];
        
        standardEraMonthlyRate = 8889*10**2 * 10**uint(decimals());
        
        // Err Check
        assert(bonusEraMonthlyRate.length == maxSupplyForBonusEra.length);
        
        // Init vars
        rewardEra = 0;
        epochCount = 0;
        currentMonthlyRate = bonusEraMonthlyRate[rewardEra];
        miningTarget = _MAXIMUM_TARGET;
        latestDifficultyPeriodStarted = block.number;
        
        // Begin first epoch
        _startNewMiningEpoch();
    }
    
    function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
        bytes32 digest = keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));
        
        // Prove digest
        if (digest != challenge_digest) revert();
        // Check if digest is invalid
        if(uint256(digest) > miningTarget) revert();
        
        // Check uniqueness of answer
        bytes32 solution = solutionForChallenge[challengeNumber];
        if(solution != 0x0) revert();
        // Store answer
        solutionForChallenge[challengeNumber] = digest;
        
        // Reward
        uint reward_amount = getMiningReward();
        _mint(msg.sender, reward_amount);
        
        // Store reward details
        lastRewardTo = msg.sender;
        lastRewardAmount = reward_amount;
        lastRewardEthBlockNumber = block.number;
        
        // Intialize next epoch
        _startNewMiningEpoch();
        
        return true;
    }
    
    function _startNewMiningEpoch() internal {
        // Update Era
        if (rewardEra < bonusEraMonthlyRate.length) {
            // Determine current era
            if (totalSupply() >= maxSupplyForBonusEra[rewardEra]) {
                rewardEra = rewardEra + 1;
            }
            
            // Assign corresponding era rate
            if (rewardEra < bonusEraMonthlyRate.length) {
                currentMonthlyRate = bonusEraMonthlyRate[rewardEra];
            } else {
                currentMonthlyRate = standardEraMonthlyRate;
            }
        }
        
        // New epoch
        epochCount = epochCount.add(1);
        
        // Check Difficulty
        if (epochCount % _BLOCKS_PER_READJUSTMENT == 0) {
            _reAdjustDifficulty();
        }
        
        // Prevents pre-mine
        challengeNumber = blockhash(block.number - 1);
    }
        
    function _reAdjustDifficulty() internal {
        // calculate target time (measured in ethereum blocks)
        uint blocks_per_readjustment = _BLOCKS_PER_READJUSTMENT;
        uint targetEthBlocksPerDiffPeriod = blocks_per_readjustment.mul(2); // * 2 => 1/2 speed as ethereum
        
        // calculate how long it took
        uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
        // check mint rate
        if (ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod) { // fewer blocks than expected ==> too easy
            uint excess_block_pct = ((targetEthBlocksPerDiffPeriod.mul(100)).div(ethBlocksSinceLastDifficultyPeriod)).sub(100);
            uint excess_block_pct_extra = excess_block_pct.limitLessThan(1000); // "xx% over" evaluates to "xx"
            
            miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra)); // max reduction is half the size (1 ==> 0.5)
        } else { // more blocks than expected ==> too hard
            uint shortage_block_pct = ethBlocksSinceLastDifficultyPeriod.mul(100).div(targetEthBlocksPerDiffPeriod);
            uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000);
            
            miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra)); // max increase is half the size (1 ==> 1.5)
        }
        
        latestDifficultyPeriodStarted = block.number;
        
        if(miningTarget < _MINIMUM_TARGET) {
            miningTarget = _MINIMUM_TARGET;
        }
        
        if(miningTarget < _MAXIMUM_TARGET) {
            miningTarget = _MAXIMUM_TARGET;
        }
    }
    
    function getChallengeNumber() public view returns (bytes32) {
        return challengeNumber;
    }
    
    function getMiningDifficulty() public view returns (uint) {
        return _MAXIMUM_TARGET.div(miningTarget);
    }
    
    function getMiningTarget() public view returns (uint) {
        return miningTarget;
    }
    
    function getMiningReward() public view returns (uint) {
        if(totalSupply() == 0) {
            return 4*10**8 * 10**uint(decimals());
        } else {
            uint award_per_block = currentMonthlyRate.div(2628*10**3).mul(20); // rate per 20 seconds. Assumes ethereum takes 10 seconds per block and that the difficuly is properly set.
            return award_per_block;
        }
    }
    
    function getRewardEra() public view returns (uint){
        return rewardEra;
    }
    
    function getCurrentMonthlyRate() public view returns (uint) {
        return currentMonthlyRate;
    }
    
    function getEpochCount() public view returns (uint) {
        return epochCount;
    }
    
    function getLatestDifficultyPeriodStarted() public view returns (uint) {
        return latestDifficultyPeriodStarted;
    }
    
    // Helps with debugging mining software
    function getMintDigest(uint256 challenge_number, bytes32 nonce) public view returns (bytes32 digesttest) {
        bytes32 digest = keccak256(abi.encodePacked(challenge_number, msg.sender, nonce));
        return digest;
    }
}