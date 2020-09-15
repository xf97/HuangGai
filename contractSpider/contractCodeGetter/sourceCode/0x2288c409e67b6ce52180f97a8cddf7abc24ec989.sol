/**
 *Submitted for verification at Etherscan.io on 2020-08-03
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.5.17;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function decimals() external view returns (uint);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

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
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
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
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface Controller {
    function vaults(address) external view returns (address);
    function rewards() external view returns (address);
}

interface Rewards {
    function withdraw(uint) external;
    function getReward() external;
    function stake(uint) external;
    function balanceOf(address) external view returns (uint);
    function exit() external;
}

/*

 A strategy must implement the following calls;
 
 - deposit()
 - withdraw(address) must exclude any tokens used in the yield - Controller role - withdraw should return to Controller
 - withdraw(uint) - Controller | Vault role - withdraw should always return to vault
 - withdrawAll() - Controller | Vault role - withdraw should always return to vault
 - balanceOf()
 
 Where possible, strategies must remain as immutable as possible, instead of updating variables, we update the contract by linking it in the controller
 
*/

interface ICurveFi {

  function get_virtual_price() external view returns (uint);
  function add_liquidity(
    uint256[4] calldata amounts,
    uint256 min_mint_amount
  ) external;
  function remove_liquidity_imbalance(
    uint256[4] calldata amounts,
    uint256 max_burn_amount
  ) external;
  function remove_liquidity(
    uint256 _amount,
    uint256[4] calldata amounts
  ) external;
  function exchange(
    int128 from, int128 to, uint256 _from_amount, uint256 _min_to_amount
  ) external;
}

interface Synthetix {
    function issueMaxSynths() external;
    function burnSynths(uint) external;
    function debtBalanceOf(address account, bytes32 currencyKey) external view returns (uint);
    function transferableSynthetix(address account) external view returns (uint transferable);
    function burnSynthsToTarget() external;
    function maxIssuableSynths(address) external view returns (uint);
}

interface SynthetixEscrow {
    function vest() external;
}

interface SynthetixFees {
    function claimFees() external;
    function feesAvailable(address) external view returns (uint totalFees,uint totalRewards);
    function isFeesClaimable(address) external view returns (bool);
}

interface SynthetixExchange {
    function rateForCurrency(bytes32 currencyKey) external view returns (uint rate);
}

contract StrategySNXSUSD {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;
    
    address constant public want = address(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F);
    address constant public curve = address(0xA5407eAE9Ba41422680e2e00537571bcC53efBfD);
    address constant public snx = address(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F);
    address constant public scrv = address(0xC25a3A3b969415c80451098fa907EC722572917F);
    address constant public rewards = address(0xDCB6A51eA3CA5d3Fd898Fd6564757c7aAeC3ca92);
    address constant public susd = address(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);
    address constant public fees = address(0xb440DD674e1243644791a4AdfE3A2AbB0A92d309);
    address constant public escrow = address(0xb671F2210B1F6621A2607EA63E6B2DC3e2464d1F);
    address constant public exchange = address(0xba727c69636491ecdfE3E6F64cBE9428aD371e48);
    
    address constant public dai = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    address constant public usdt = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    address constant public usdc = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    
    uint constant public fee = 50;
    uint constant public max = 10000;
    
    address public governance;
    address public controller;
    
    constructor(address _controller) public {
        governance = msg.sender;
        controller = _controller;
    }
    
    function deposit() public {
        // Mint sUSD
        uint _issuable = Synthetix(snx).maxIssuableSynths(address(this));
        if (_issuable > 0) {
            Synthetix(snx).issueMaxSynths();
        }
        
        // Mint sCRV
        uint _susd = IERC20(susd).balanceOf(address(this));
        if (_susd > 0) {
            IERC20(susd).safeApprove(curve, 0);
            IERC20(susd).safeApprove(curve, _susd);
            ICurveFi(curve).add_liquidity([0,0,0,_susd],0);
        }
        
        // Stake sCRV
        uint _scrv = IERC20(scrv).balanceOf(address(this));
        if (_scrv > 0) {
            IERC20(scrv).safeApprove(rewards, 0);
            IERC20(scrv).safeApprove(rewards, _scrv);
            Rewards(rewards).stake(_scrv);
        }
    }
    
    function harvestAndCompound() public {
        harvest();
        deposit();
    }
    
    function harvest() public {
        uint _before = balanceOfWant();
        burnSynthsToTarget();
        claimRewards();
        // Claim SNX rewards from Rewards pool
        claimFees();
        // Claim escrow (if available ~ 12 months)
        vest();
        uint _after = balanceOfWant();
        uint _fee = (_after.sub(_before)).mul(fee).div(max);
        IERC20(want).safeTransfer(Controller(controller).rewards(), _fee);
    }
    
    function burnSynthsToTarget() public {
        uint _issuable = Synthetix(snx).maxIssuableSynths(address(this));
        uint _debt = Synthetix(snx).debtBalanceOf(address(this), "sUSD");
        // check to avoid the sub revert in burnSynthsToTarget() use deposit instead to increase
        if (_debt > _issuable) {
            Synthetix(snx).burnSynthsToTarget();
        }
    }
    
    function claimRewards() public {
        Rewards(rewards).getReward();
    }
    
    function vest() public {
        SynthetixEscrow(escrow).vest();
    }
    
    function claimFees() public {
        // Claim weekly fees (if available)
        if (SynthetixFees(fees).isFeesClaimable(address(this))) {
            SynthetixFees(fees).claimFees();
        }
    }
    
    // Controller only function for creating additional rewards from dust
    function withdraw(IERC20 _asset) external returns (uint balance) {
        require(msg.sender == controller, "!controller");
        require(want != address(_asset), "want");
        balance = _asset.balanceOf(address(this));
        _asset.safeTransfer(controller, balance);
    }
    
    // Withdraw partial funds, normally used with a vault withdrawal
    function withdraw(uint _amount) external {
        require(msg.sender == controller, "!controller");
        uint _balance = Synthetix(snx).transferableSynthetix(address(this));
        if (_balance < _amount) {
            _amount = _withdrawSome(_amount.sub(_balance));
            _amount = _amount.add(_balance);
        }
        
        //address _vault = Controller(controller).vaults(address(want));
        //require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
        uint _fee = _amount.mul(fee).div(max);
        IERC20(want).safeTransfer(Controller(controller).rewards(), _fee);
        IERC20(want).safeTransfer(controller, _amount.sub(_fee));
    }
    
    // Withdraw all funds, normally used when migrating strategies
    function withdrawAll() external returns (uint balance) {
        require(msg.sender == controller, "!controller");
        _withdrawAll();
        balance = Synthetix(snx).transferableSynthetix(address(this));
        
        //address _vault = Controller(controller).vaults(address(want));
        //require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
        IERC20(want).safeTransfer(controller, balance);
    }
    
    function withdrawSUSD(uint _amount) internal returns (uint) {
        uint _before = IERC20(susd).balanceOf(address(this));
        
        IERC20(scrv).safeApprove(curve, 0);
        IERC20(scrv).safeApprove(curve, _amount);
        ICurveFi(curve).remove_liquidity(_amount, [uint256(0),0,0,0]);
        
        uint256 _dai = IERC20(dai).balanceOf(address(this));
        uint256 _usdc = IERC20(usdc).balanceOf(address(this));
        uint256 _usdt = IERC20(usdt).balanceOf(address(this));
        
        if (_dai > 0) {
            IERC20(dai).safeApprove(curve, 0);
            IERC20(dai).safeApprove(curve, _dai);
            ICurveFi(curve).exchange(0, 3, _dai, 0);
        }
        if (_usdc > 0) {
            IERC20(usdc).safeApprove(curve, 0);
            IERC20(usdc).safeApprove(curve, _usdc);
            ICurveFi(curve).exchange(1, 3, _usdc, 0);
        }
        if (_usdt > 0) {
            IERC20(usdt).safeApprove(curve, 0);
            IERC20(usdt).safeApprove(curve, _usdt);
            ICurveFi(curve).exchange(2, 3, _usdt, 0);
        }
        
        uint _after = IERC20(susd).balanceOf(address(this));
        return _after.sub(_before);
    }
    
    function _withdrawAll() internal {
        Rewards(rewards).exit();
        withdrawSUSD(IERC20(scrv).balanceOf(address(this)));
        uint _debt = Synthetix(snx).debtBalanceOf(address(this), "sUSD");
        if (IERC20(susd).balanceOf(address(this))<_debt) {
            _debt = IERC20(susd).balanceOf(address(this));
        }
        if (_debt > 0) {
            Synthetix(snx).burnSynths(_debt);
        }
    }
    
    function _withdrawSome(uint _amount) internal returns (uint) {
        uint _ratio = balanceOfRewards().mul(_amount).div(balanceOfLocked());
        uint _withdrew = withdrawSUSD(_ratio);
        uint _before = Synthetix(snx).transferableSynthetix(address(this));
        Synthetix(snx).burnSynths(_withdrew);
        uint _after = Synthetix(snx).transferableSynthetix(address(this));
        uint _diff = _after.sub(_before);
        if (_diff < _amount) {
            _amount = _diff;
        }
        return _amount;
    }
    
    function balanceOfLocked() public view returns (uint) {
        return balanceOfWant().sub(Synthetix(snx).transferableSynthetix(address(this)));
    }
    
    function balanceOfWant() public view returns (uint) {
        return IERC20(want).balanceOf(address(this));
    }
    
    function balanceOfRewards() public view returns (uint) {
        return Rewards(rewards).balanceOf(address(this));
    }
    
    function balanceOf() public view returns (uint) {
        return balanceOfWant();
    }
    
    function setGovernance(address _governance) external {
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }
    
    function setController(address _controller) external {
        require(msg.sender == governance, "!governance");
        controller = _controller;
    }
}