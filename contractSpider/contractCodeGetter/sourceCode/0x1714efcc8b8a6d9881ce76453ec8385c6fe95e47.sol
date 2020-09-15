/**
 *Submitted for verification at Etherscan.io on 2020-06-18
*/

// File: contracts\ERC20Interface.sol

pragma solidity ^0.4.24;

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

// File: contracts\EIP918Interface.sol

pragma solidity ^0.4.24;

contract EIP918Interface {

    /*
     * Externally facing mint function that is called by miners to validate challenge digests, calculate reward,
     * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Once complete,
     * a Mint event is emitted before returning a success indicator.
     **/
    function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);

    /*
     * Optional
     * Externally facing merge function that is called by miners to validate challenge digests, calculate reward,
     * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Additionally, the
     * merge function takes an array of target token addresses to be used in merged rewards. Once complete,
     * a Mint event is emitted before returning a success indicator.
     **/
    //function merge(uint256 nonce, bytes32 challenge_digest, address[] mineTokens) public returns (bool);

    /*
     * Returns the challenge number
     **/
    function getChallengeNumber() public view returns (bytes32);

    /*
     * Returns the mining difficulty. The number of digits that the digest of the PoW solution requires which 
     * typically auto adjusts during reward generation.
     **/
    function getMiningDifficulty() public view returns (uint);

    /*
     * Returns the mining target
     **/
    function getMiningTarget() public view returns (uint);

    /*
     * Return the current reward amount. Depending on the algorithm, typically rewards are divided every reward era 
     * as tokens are mined to provide scarcity
     **/
    function getMiningReward() public view returns (uint);
    
    /*
     * Upon successful verification and reward the mint method dispatches a Mint Event indicating the reward address, 
     * the reward amount, the epoch count and newest challenge number.
     **/
    event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);

}

// File: contracts\Owned.sol

pragma solidity ^0.4.24;

// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;
    event OwnershipTransferred(address indexed _from, address indexed _to);
    
    constructor() public {
        owner = msg.sender;
    }
	
    modifier onlyOwner {
        require(msg.sender == owner, "owner required");
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

// File: contracts\Admin.sol

pragma solidity ^0.4.24;


contract Admin is Owned
{
	/**
	 * @dev Event is raised when a new admin was added.
	 * @param admin Admin address performing the operation.
	 * @param account New admin address added.
	 */
	event AdminAdded(address indexed admin, address indexed account);
	
	/**
	 * @dev Event is raised when admin was removed.
	 * @param admin Admin address performing the operation.
	 * @param account Admin address being removed.
	 */
    event AdminRemoved(address indexed admin, address indexed account);
	
	/**
	 * @dev Event is raised when admin renounces to his admin role.
	 * @param account Admin address renouncing to his admin role.
	 */
	event AdminRenounced(address indexed account);
	
	
	
	mapping(address => bool) public admin;
	
	constructor()
		Owned()
		public
	{
		addAdmin(msg.sender);
	}
	
	modifier onlyAdmin() {
		require(admin[msg.sender], "Admin required");
		_;
	}
	
	function isAdmin(address _account) public view returns (bool) {
		return admin[_account];
	}
	
	function addAdmin(address _account) public onlyOwner {
		require(_account != address(0));
		require(!admin[_account], "Admin already added");
		admin[_account] = true;
		emit AdminAdded(msg.sender, _account);
	}
	
	function removeAdmin(address _account) public onlyOwner {
		require(_account != address(0));
		require(_account != owner, "Owner can not remove his admin role");
		require(admin[_account], "Remove admin only");
		admin[_account] = false;
		emit AdminRemoved(msg.sender, _account);
	}
	
	function renounceAdmin() public {
		require(msg.sender != owner, "Owner can not renounce to his admin role");
		require(admin[msg.sender], "Renounce admin only");
		admin[msg.sender] = false;
		emit AdminRenounced(msg.sender);
    }
}

// File: contracts\ApproveAndCallFallBack.sol

pragma solidity ^0.4.24;

// ----------------------------------------------------------------------------
// Contract function to receive approval and execute function in one call
//
// Borrowed from MiniMeToken
// ----------------------------------------------------------------------------
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
}

// File: contracts\SafeMath.sol

pragma solidity ^0.4.24;

// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------
library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

// File: contracts\ExtendedMath.sol

pragma solidity ^0.4.24;

library ExtendedMath {
    //return the smaller of the two inputs (a or b)
    function limitLessThan(uint a, uint b) internal pure returns (uint c) {
        if(a > b) return b;
        return a;
    }
}

// File: contracts\0xCATE_v2.sol

pragma solidity ^0.4.24;








// ----------------------------------------------------------------------------
// '0xCatether Token' contract
// Mineable ERC20 Token using Proof Of Work
//
// Symbol      : 0xCATE
// Name        : 0xCatether Token
// Total supply: No Limit
// Decimals    : 4
//
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and an
// initial fixed supply
// ----------------------------------------------------------------------------
contract _0xCatetherToken is ERC20Interface, EIP918Interface, ApproveAndCallFallBack, Owned, Admin
{
    using SafeMath for uint;
    using ExtendedMath for uint;
	
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
    uint public latestDifficultyPeriodStarted;
    uint public epochCount;//number of 'blocks' mined
    
	//a little number
    uint public  _MINIMUM_TARGET = 2**16;
    //a big number is easier ; just find a solution that is smaller
    uint public  _MAXIMUM_TARGET = 2**224; //bitcoin uses 224
    
	uint public miningTarget;
    bytes32 public challengeNumber;   //generate a new one when a new reward is minted
    address public lastRewardTo;
    uint public lastRewardAmount;
    uint public lastRewardEthBlockNumber;
	
    // a bunch of maps to know where this is going (pun intended)
    
    mapping(bytes32 => bytes32) public solutionForChallenge;
    mapping(uint => uint) public targetForEpoch;
    mapping(uint => uint) public timeStampForEpoch;
    mapping(address => address) public donationsTo;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    event Donation(address donation);
    event DonationAddressOf(address donator, address donnationAddress);
    event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
	
	uint public tokensMinted;
	
	// transfers enabled/disabled control
	bool public transfersEnabled;
	event TransfersEnabled(address indexed admin);
	event TransfersDisabled(address indexed admin);
	
	// mining enabled/disabled control
	bool public miningEnabled;
	event MiningEnabled(address indexed admin);
	event MiningDisabled(address indexed admin);
	
	// migrate deprecated contract tokens to this new one
	bool public migrationEnabled;
	event MigrationEnabled(address indexed admin);
	event MigrationDisabled(address indexed admin);
	
	event MigratedTokens(address indexed user, uint tokens);
	
	address public deprecatedContractAddress;
	
	
	
    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor() public{
        symbol = "0xCATE";
        name = "0xCatether Token";
        
        decimals = 4;
		
		// needed as reference and to migrate tokens from deprecated contract
		deprecatedContractAddress = 0x8F7DbF90E71285552a687097220E1035C2e87639;
		
		
		
		//*** get data from deprecated contract ***//
		tokensMinted = 0; //will add as we migrate old tokens and from mining
		_totalSupply = 0; //total supply will increment as users claim and migrate tokens from deprecated contract
        epochCount = 15516; //this is the latest epoch count from deprecated contract
        
        challengeNumber = bytes32(0x781504f93328a5bf6401754a85baab350e71a11d9051cc86a8ff6f9ebcf38477); //challengeNumber from deprecated contract on the main network
        targetForEpoch[(epochCount - 1)] = _MAXIMUM_TARGET;
        solutionForChallenge[challengeNumber] = "42"; // ahah yes
		timeStampForEpoch[(epochCount - 1)] = block.timestamp;
        latestDifficultyPeriodStarted = block.number;
        
        targetForEpoch[epochCount] = _MAXIMUM_TARGET;
        miningTarget = _MAXIMUM_TARGET;
		//*** --- ***//
		
		
		
		// transfers are enabled by default
		transfersEnabled = true;
		emit TransfersEnabled(msg.sender);
		
		// enable mining by default
		miningEnabled = true;
		emit MiningEnabled(msg.sender);
		
		// migration is enabled by default
		migrationEnabled = true;
		emit MigrationEnabled(msg.sender);
    }
	
	modifier whenMiningEnabled {
		require(miningEnabled, "Mining disabled");
		_;
	}
	
	modifier whenTransfersEnabled {
		require(transfersEnabled, "Transfers disabled");
		_;
	}
	
	modifier whenMigrationEnabled {
		require(migrationEnabled, "Migration disabled");
		_;
	}
	
	
	
	/**
	 * @dev Enable transfers if disabled and viceversa, executed only by admin.
	 * @return bool
	 */
	function enableTransfers(bool enable) public onlyAdmin returns (bool) {
		if (transfersEnabled != enable) {
			transfersEnabled = enable;
			if (enable)
				emit TransfersEnabled(msg.sender);
			else emit TransfersDisabled(msg.sender);
			return true;
		}
		return false;
	}
	
	/**
	 * @dev Enable mining if disabled and viceversa, executed only by admin.
	 * @return bool
	 */
	function enableMining(bool enable) public onlyAdmin returns (bool) {
		if (miningEnabled != enable) {
			miningEnabled = enable;
			if (enable)
				emit MiningEnabled(msg.sender);
			else emit MiningDisabled(msg.sender);
			return true;
		}
		return false;
	}
	
	/**
	 * @dev Enable deprecated contract tokens migration if disabled and viceversa, executed only by admin.
	 * @return bool
	 */
	function enableMigration(bool enable) public onlyAdmin returns (bool) {
		if (migrationEnabled != enable) {
			migrationEnabled = enable;
			if (enable)
				emit MigrationEnabled(msg.sender);
			else emit MigrationDisabled(msg.sender);
			return true;
		}
		return false;
	}
	
	
	
    function mint(uint256 nonce, bytes32 challenge_digest) public whenMiningEnabled returns (bool success) {
		
        //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
        bytes32 digest =  keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));
        
		//the challenge digest must match the expected
        require(digest == challenge_digest, "challenge_digest error");
		
        //the digest must be smaller than the target
        require(uint256(digest) <= miningTarget, "miningTarget error");
        
		//only allow one reward for each challenge
		bytes32 solution = solutionForChallenge[challengeNumber]; /// bug fix, 'challengeNumber' instead of 'challenge_digest'
        solutionForChallenge[challengeNumber] = digest;
        require(solution == 0x0, "solution exists");  //prevent the same answer from awarding twice
        
		uint reward_amount = getMiningReward();
        balances[msg.sender] = balances[msg.sender].add(reward_amount);
        _totalSupply = _totalSupply.add(reward_amount);
		tokensMinted = tokensMinted.add(reward_amount);
		
        //set readonly diagnostics data
        lastRewardTo = msg.sender;
        lastRewardAmount = reward_amount;
        lastRewardEthBlockNumber = block.number;
        
		_startNewMiningEpoch();
        emit Mint(msg.sender, reward_amount, epochCount, challengeNumber );
		return true;
    }

    //a new 'block' to be mined
    function _startNewMiningEpoch() internal {
		
		timeStampForEpoch[epochCount] = block.timestamp;
        epochCount = epochCount.add(1);
		
		//Difficulty adjustment following the DigiChieldv3 implementation (Tempered-SMA)
		// Allows more thorough protection against multi-pool hash attacks
		// https://github.com/zawy12/difficulty-algorithms/issues/9
		miningTarget = _reAdjustDifficulty(epochCount);
		
		//make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
		//do this last since this is a protection mechanism in the mint() function
		challengeNumber = blockhash(block.number.sub(1));
    }
	
    //https://github.com/zawy12/difficulty-algorithms/issues/21
    //readjust the target via a tempered EMA
    function _reAdjustDifficulty(uint epoch) internal returns (uint) {
    
        uint timeTarget = 300;  // We want miners to spend 5 minutes to mine each 'block'
        uint N = 6180;          //N = 1000*n, ratio between timeTarget and windowTime (31-ish minutes)
                                // (Ethereum doesn't handle floating point numbers very well)
        uint elapsedTime = timeStampForEpoch[epoch.sub(1)].sub(timeStampForEpoch[epoch.sub(2)]); // will revert if current timestamp is smaller than the previous one
        
		targetForEpoch[epoch] = (targetForEpoch[epoch.sub(1)].mul(10000)).div( N.mul(3920).div(N.sub(1000).add(elapsedTime.mul(1042).div(timeTarget))).add(N));
		
		//              newTarget   =   Tampered EMA-retarget on the last 6 blocks (a bit more, it's an approximation)
		// 				Also, there's an adjust factor, in order to correct the delays induced by the time it takes for transactions to confirm
		//				Difficulty is adjusted to the time it takes to produce a valid hash. Here, if we set it to take 300 seconds, it will actually take 
		//				300 seconds + TxConfirmTime to validate that block. So, we wad a little % to correct that lag time.
		//				Once Ethereum scales, it will actually make block times go a lot faster. There's no perfect answer to this problem at the moment
		
        latestDifficultyPeriodStarted = block.number;
		
		targetForEpoch[epoch] = adjustTargetInBounds(targetForEpoch[epoch]);
		
		return targetForEpoch[epoch];
    }
	
	function adjustTargetInBounds(uint target) internal view returns (uint newTarget) {
		newTarget = target;
		
		if (newTarget < _MINIMUM_TARGET) //very difficult
		{
			newTarget = _MINIMUM_TARGET;
		}
		
		if (newTarget > _MAXIMUM_TARGET) //very easy
		{
			newTarget = _MAXIMUM_TARGET;
		}
	}
	
    //this is a recent ethereum block hash, used to prevent pre-mining future blocks
    function getChallengeNumber() public view returns (bytes32) {
        return challengeNumber;
    }

    //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
    function getMiningDifficulty() public view returns (uint) {
		return _MAXIMUM_TARGET.div(targetForEpoch[epochCount]);
	}
	
	function getMiningTarget() public view returns (uint) {
		return targetForEpoch[epochCount];
	}
	
	//There's no limit to the coin supply
    //reward follows more or less the same emmission rate as Dogecoins'. 5 minutes per block / 105120 block in one year (roughly)
    function getMiningReward() public view returns (uint) {
        bytes32 digest = solutionForChallenge[challengeNumber];
        if(epochCount > 160000) return (50000   * 10**uint(decimals) );									//  14.4 M/day / ~ 1.0B Tokens in 20'000 blocks (coin supply @100'000th block ~ 150 Billions)
        if(epochCount > 140000) return (75000   * 10**uint(decimals) );									//  21.6 M/day / ~ 1.5B Tokens in 20'000 blocks (coin supply @100'000th block ~ 149 Billions)
        if(epochCount > 120000) return (125000  * 10**uint(decimals) );									//  36.0 M/day / ~ 2.5B Tokens in 20'000 blocks (coin supply @100'000th block ~ 146 Billions)
        if(epochCount > 100000) return (250000  * 10**uint(decimals) );									//  72.0 M/day / ~ 5.0B Tokens in 20'000 blocks (coin supply @100'000th block ~ 141 Billions) (~ 1 year elapsed)
        if(epochCount > 80000) return  (500000  * 10**uint(decimals) );									// 144.0 M/day / ~10.0B Tokens in 20'000 blocks (coin supply @ 80'000th block ~ 131 Billions)
        if(epochCount > 60000) return  (1000000 * 10**uint(decimals) );       							// 288.0 M/day / ~20.0B Tokens in 20'000 blocks (coin supply @ 60'000th block ~ 111 Billions)
        if(epochCount > 40000) return  ((uint256(keccak256(abi.encodePacked(digest))) % 2500000) * 10**uint(decimals) );	// 360.0 M/day / ~25.0B Tokens in 20'000 blocks (coin supply @ 40'000th block ~  86 Billions)
        if(epochCount > 20000) return  ((uint256(keccak256(abi.encodePacked(digest))) % 3500000) * 10**uint(decimals) );	// 504.0 M/day / ~35.0B Tokens in 20'000 blocks (coin supply @ 20'000th block ~  51 Billions)
                               return  ((uint256(keccak256(abi.encodePacked(digest))) % 5000000) * 10**uint(decimals) );	// 720.0 M/day / ~50.0B Tokens in 20'000 blocks 
    }

    //help debug mining software (even though challenge_digest isn't used, this function is constant and helps troubleshooting mining issues)
    function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
		return keccak256(abi.encodePacked(challenge_number,msg.sender,nonce));
	}

    //help debug mining software
    function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
		bytes32 digest = keccak256(abi.encodePacked(challenge_number,msg.sender,nonce));
		if(uint256(digest) > testTarget) revert();
		return (digest == challenge_digest);
	}

    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }
	
	
	
    function changeDonation(address donationAddress) public returns (bool success) {
        donationsTo[msg.sender] = donationAddress;
        
        emit DonationAddressOf(msg.sender , donationAddress); 
        return true;
    }
	
	
	
    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public whenTransfersEnabled returns (bool success) {
        
		return transferAndDonateTo(to, tokens, donationsTo[msg.sender]);
    }
    
    function transferAndDonateTo(address to, uint tokens, address donation) public whenTransfersEnabled returns (bool success) {
        require(to != address(0), "to address required");
		
		uint donation_tokens; //0 by default
		if (donation != address(0))
			donation_tokens = 5000;
		
        balances[msg.sender] = (balances[msg.sender].sub(tokens)).add(5000); // 0.5 CATE for the sender
        balances[to] = balances[to].add(tokens);
        balances[donation] = balances[donation].add(donation_tokens); // 0.5 CATE for the sender's specified donation address
		
		_totalSupply = _totalSupply.add(donation_tokens.add(5000));
		
        emit Transfer(msg.sender, to, tokens);
		emit Donation(msg.sender);
		if (donation != address(0)) {
			emit Donation(donation);
		}
        return true;
    }
	
    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account
    //
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
    // recommends that there are no checks for the approval double-spend attack
    // as this should be implemented in user interfaces
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens) public whenTransfersEnabled returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    //
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens) public whenTransfersEnabled returns (bool success) {
        require(to != address(0), "to address required");
		
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        
		address donation = donationsTo[msg.sender];
		uint donation_tokens; //0 by default
		if (donation != address(0))
			donation_tokens = 5000;
		
		balances[donation] = balances[donation].add(donation_tokens); // 0.5 CATE for the sender's donation address
        balances[msg.sender] = balances[msg.sender].add(5000); // 0.5 CATE for the sender
        _totalSupply = _totalSupply.add(donation_tokens.add(5000));
		
		emit Transfer(from, to, tokens);
		emit Donation(msg.sender);
		if (donation != address(0)) {
			emit Donation(donation);
		}
        
        return true;
    }
	
    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account. The `spender` contract function
    // `receiveApproval(...)` is then executed
    // ------------------------------------------------------------------------
    function approveAndCall(address spender, uint tokens, bytes memory data) public whenTransfersEnabled returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
        return true;
    }
	
	// ---
	// Migrate deprecated contract tokens using ApproveAndCallFallBack interface function.
	// ---
	function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public whenMigrationEnabled {
		
		require(token == deprecatedContractAddress, "Wrong deprecated contract address");
		
		//this contract becomes the owner of tokens from old contract
		require(ERC20Interface(deprecatedContractAddress).transferFrom(from, address(this), tokens), "oldToken.transferFrom failed");
		
		balances[from] = balances[from].add(tokens);
		_totalSupply = _totalSupply.add(tokens);
		tokensMinted = tokensMinted.add(tokens); //migrated tokens are minted in old contract
		emit MigratedTokens(from, tokens);
	}
	
	
	
    // ------------------------------------------------------------------------
    // Don't accept ETH
    // ------------------------------------------------------------------------
    function () external payable {
        revert();
    }
    
    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
}