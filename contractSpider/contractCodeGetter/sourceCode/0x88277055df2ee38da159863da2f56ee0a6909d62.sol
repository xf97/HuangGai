/**
 *Submitted for verification at Etherscan.io on 2020-07-09
*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.23 <0.7.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

pragma solidity >=0.4.23 <0.7.0;

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
    uint256 c = add(a,m);
    uint256 d = sub(c,1);
    return mul(div(d,m),m);
  }
}

pragma solidity >=0.4.23 <0.7.0;


/*
--------------------------------------------------------------------------
-        Distribution Contract for the Analys-X (XYS) Token              -
-                   Written by: Admirral                                 -
-                     ~~~~~~~~~~~~~~~~                                   -
-    This contract will track XYS stakers and distribute payments        -
-    received from users who purchase Analys-X products. All payments    -
-    will be received in XYS tokens.                                     -
-                                                                        -
-    Only 100 stakers will be allowed at any one time.                   -
-    When a new user stakes, the oldest on the list is removed and       -
-    they receive their stake back. The price to stake                   -
-    increases by 1% after each new stake.                               -
-                                                                        -
-    When product fees are collected, 90% of that fee is redistributed   -
-    to the 100 addresses on the list.                                   -
--------------------------------------------------------------------------
*/

contract Distribute is IERC20 {
    using SafeMath for uint256;

    // EVENTS
    event Stake(address indexed user);
    event Purchase(address indexed user, uint256 amount);
    event Withdraw(address indexed user);

    //basic identifiers - ERC20 Standard
    string public name = "ANALYSX";
    string public symbol = "XYS";
    uint256 public decimals = 6;

    //total Supply - currently 40'000'000
    uint256 private _totalSupply = 40000000 * (10 ** decimals);

    // balances and allowance - ERC20 Standard
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    // Staked Token Tracking
    mapping (address => uint256) public _staked;

    // Users earnings from staking
    mapping (address => uint256) private _earned;

    // Is user on staking list? 
    mapping (address => bool) public _isStaked;

    // Stake List
    address[100] private _stakeList;

    // initial staking fee
    uint256 public _initialFee = 100000 * (10 ** decimals);

    // Current Staking Fee
    uint256 public _stakeFee;

    // Total Amount Staked;
    uint256 public _totalStaked;

    // Time of Previous Staker
    uint256 public _lastStakerTime;

    // Contract owner Address
    address payable _owner;


    // Constructor
    constructor(address payable owner) public {

        // mints tokens
        _mint(owner, _totalSupply);

        // Sets owner of contract
        _owner = owner;  

        // Sets staking fee to initial amount             
        _stakeFee = _initialFee;

        // initiates time of most recent staker
        _lastStakerTime = block.timestamp;

        // fills stakeList with owner.
        for (uint i = 0; i <= 99; i++) {
            _stakeList[i] = _owner;
        }

    }

    // ---------------------------------
    // --       ERC20 Functions       --
    // --        Open Zeppelin        --
    // ---------------------------------

    function totalSupply() override public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public override view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) override public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) override public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) override public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) override public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 value) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
    }

    // --------------------------------------
    // --       Custom Functions           --
    // --------------------------------------

    // Owner modifier. Functions with this modifier can only be called by contract owner
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    } 

    // checks if the sending user is owner. Returns true or false
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    // change owner
    function changeOwner(address payable newOwner) public onlyOwner {
        _owner = newOwner;
    }

    // Returns users stake earnings
    function checkReward() public view returns (uint256) {
        return _earned[msg.sender];
    }

    // returns staker list
    function showStakers() public view returns (address[100] memory) {
        return _stakeList;
    }

    // Stake Function
    function stake() public {
        require(msg.sender != _owner, "Owner cannot stake");
        require(_balances[msg.sender] >= _stakeFee, "Insufficient Tokens");
        require(_isStaked[msg.sender] == false, "You are already staking");
        require(_staked[msg.sender] == 0, "You have stake"); // Maybe redundant?

        // updates new stakers balances and records stake
        _balances[msg.sender] = _balances[msg.sender].sub(_stakeFee);
        _staked[msg.sender] = _stakeFee;
        _totalStaked = _totalStaked.add(_stakeFee);

        // updates staking fee
        uint256 stakeIncrease = _stakeFee.div(100);
        _stakeFee = _stakeFee.add(stakeIncrease);
        _lastStakerTime = block.timestamp;

        // updates stake list
        updateStaking();

        emit Stake(msg.sender);

    }
    
    // Remove a user from staking, and replace slot with _owner address
    function exitStake() public returns(bool) {
        require(msg.sender != _owner, "owner cannot exit");
        require(_isStaked[msg.sender] == true, "You are not staking");
        require(_staked[msg.sender] != 0, "You don't have stake"); // Maybe redundant?
        
        for (uint i = 0; i < 99; i++) {
            if (_stakeList[i] == msg.sender) {
                _balances[msg.sender] = _balances[msg.sender].add(_earned[msg.sender]).add(_staked[msg.sender]);
                _staked[msg.sender] = 0;
                _earned[msg.sender] = 0;
                _stakeList[i] = _owner;
                _isStaked[msg.sender] = false;
                return true;
            }
        }
        return false;
    }

    //Adds new user to staking list, removes oldest user, returns their stake
    function updateStaking() internal {

        // Refunds the user at the end of the list
        address lastUser = _stakeList[99];
        _balances[lastUser] = _balances[lastUser].add(_staked[lastUser]);
        _staked[lastUser] = 0;
        _isStaked[lastUser] = false;
        
        // Gives the final user their collected rewards
        _balances[lastUser] = _balances[lastUser].add(_earned[lastUser]);
        _earned[lastUser] = 0;

        // Updates positions on list
        for (uint i = 99; i > 0; i--) {
            uint previous = i.sub(1);
            address previousUser = _stakeList[previous];
            _stakeList[i] = previousUser;
        }

        // Inserts new staker to top of list
        _stakeList[0] = msg.sender;
        _isStaked[msg.sender] = true;
    }

    // Function to purchase service (any price is possible, product is offerred off-chain)
    function purchaseService(uint256 price, address purchaser) public {
        
        // Check if user has required balance
        require (_balances[purchaser] >= price, "Insufficient funds");
        
        // token value must be > 0.001 to avoid computation errors)
        require (price > 1000, "Value too Small");

        // 10% goes to owner (this can be adjusted)
        uint256 ownerShare = price.div(10);
        uint256 toSplit = price.sub(ownerShare);
        uint256 stakeShare = toSplit.div(100);
        _earned[_owner] = _earned[_owner].add(ownerShare);

        // distributes funds to each staker, except the last one. 
        for (uint i = 0; i < 99; i++) {
            
            // adds stakeShare to each user
            _earned[_stakeList[i]] = _earned[_stakeList[i]].add(stakeShare);
            
            // We subtract from toSplit to produce a final amount for the final staker
            toSplit = toSplit.sub(stakeShare);
        }
        
        // toSplit should be equal or slightly higher than stakeShare. This is to avoid accidental burning.
        _earned[_stakeList[99]] = _earned[_stakeList[99]].add(toSplit);
        
        // Remove the price from sender.
        _balances[purchaser] = _balances[purchaser].sub(price);

        emit Purchase(purchaser, price);
    }

    // Stakers can call this function to claim their funds without leaving the pool. 
    function withdraw() public {
        require(_earned[msg.sender] > 0, "Stake some more");
        _balances[msg.sender] = _balances[msg.sender].add(_earned[msg.sender]);
        _earned[msg.sender] = 0;

        emit Withdraw(msg.sender);
    }

    // Resets staking price. Can only be usable if no new staker has entered the pool in 1 month (2592000 seconds)
    function stakeReset() public  onlyOwner {
        require(block.timestamp.sub(_lastStakerTime) >= 2592000, "not enough time has passed");
        _stakeFee = _initialFee;
    }
}