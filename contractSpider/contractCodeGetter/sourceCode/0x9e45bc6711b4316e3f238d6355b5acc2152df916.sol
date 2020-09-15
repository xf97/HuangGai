/**
 *Submitted for verification at Etherscan.io on 2020-08-19
*/

pragma solidity ^0.5.16;

/**
Get 20% profit every month with a contract Shareholder VOMER!
*
* - OBTAINING 20% PER 1 MONTH. (percentages are charged in equal parts every 1 sec)
* 0.6666% per 1 day
* 0.0275% per 1 hour
* 0.00045% per 1 minute
* 0.0000076% per 1 sec
* - lifetime payments
* - unprecedentedly reliable
* - bring luck
* - first minimum contribution from 2 eth, all next from 0.01 eth
* - Currency and Payment - ETH
* - Contribution allocation schemes:
* - 100% of payments - 5% percent for support and 25% percent referral system.
* 
* VOMER.net
*
* RECOMMENDED GAS LIMIT: 200,000
* RECOMMENDED GAS PRICE: https://ethgasstation.info/
* DO NOT TRANSFER DIRECTLY FROM AN EXCHANGE (only use your ETH wallet, from which you have a private key)
* You can check payments on the website etherscan.io, in the “Internal Txns” tab of your wallet.
*
* Referral system 25%.
* Payments to developers 5%

* Restart of the contract is also absent. If there is no money in the Fund, payments are stopped and resumed after the Fund is filled. Thus, the contract will work forever!
*
* How to use:
* 1. Send from your ETH wallet to the address of the smart contract
* Any amount from 2.00 ETH.
* 2. Confirm your transaction in the history of your application or etherscan.io, indicating the address of your wallet.
* Take profit by sending 0 eth to contract (profit is calculated every second).
*
**/

/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {

    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private initializing;

    /**
     * @dev Modifier to use in the initializer function of a contract.
     */
    modifier initializer() {
        require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

        bool isTopLevelCall = !initializing;
        if (isTopLevelCall) {
            initializing = true;
            initialized = true;
        }

        _;

        if (isTopLevelCall) {
            initializing = false;
        }
    }

    /// @dev Returns true if and only if the function is running in the constructor
    function isConstructor() private view returns (bool) {
        // extcodesize checks the size of the code stored in an address, and
        // address returns the current address. Since the code is still not
        // deployed when running a constructor, any checks on its code size will
        // yield zero, making it an effective way to detect if a contract is
        // under construction or not.
        address self = address(this);
        uint256 cs;
        assembly { cs := extcodesize(self) }
        return cs == 0;
    }

    // Reserved storage space to allow for layout changes in the future.
    uint256[50] private ______gap;
}

contract ERC20Token
{
    mapping (address => uint256) public balanceOf;
    function transfer(address _to, uint256 _value) public;
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
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
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    uint256 constant WAD = 10 ** 18;

    function wdiv(uint x, uint y) internal pure returns (uint256 z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

    function wmul(uint x, uint y) internal pure returns (uint256 z) {
        z = add(mul(x, y), WAD / 2) / WAD;
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
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
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
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
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
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

contract Ownable {
    address payable public owner = msg.sender;
    address payable public newOwnerCandidate;

    modifier onlyOwner()
    {
        require(msg.sender == owner);
        _;
    }

    function changeOwnerCandidate(address payable newOwner) public onlyOwner {
        newOwnerCandidate = newOwner;
    }

    function acceptOwner() public {
        require(msg.sender == newOwnerCandidate);
        owner = newOwnerCandidate;
    }
}

contract ShareholderVomer is Initializable
{
    using SafeMath for *;

    struct InvestorData {
        uint96 lastDatetime;
        uint96 totalDepositedVMR;   
        uint96 totalWithdrawnVMR;   
        uint96 totalWithdrawnEther; 
        
        uint96 totalPartnerWithdrawnEther;
        uint96 pendingPartnerRewardEther;
        uint96 specialPartnerRewardEther;
        uint8 specialPartnerPercent;
    }
    
    address payable public owner;
    address payable public newOwnerCandidate;
    
    ERC20Token VMR_Token;
    
    uint256 public minEtherAmount;
    
    mapping (address => InvestorData) investors;
    mapping(address => address) refList;
    mapping(address => bool) public admins;
    
    uint256 VMR_ETH_RATE_IN;
    uint256 VMR_ETH_RATE_OUT;
    
    address payable public supportAddress;
    uint256 public fundsLockedtoWithdraw;
    uint256 public dateUntilFundsLocked;
    
    modifier onlyOwner()
    {
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyAdmin()
    {
        require(admins[msg.sender]);
        _;
    }

    function initialize() initializer public {
        VMR_Token = ERC20Token(0x063b98a414EAA1D4a5D4fC235a22db1427199024); 
        
        minEtherAmount = 0.0001 ether;
        owner = 0xBeEF483F3dbBa7FC428ebe37060e5b9561219E3d;
        VMR_ETH_RATE_IN = 1e18;             
        VMR_ETH_RATE_OUT = 1e18 * 90 / 100; //90%
    }

    function getPaymentInfo() view public returns (uint256 rateIn, uint256 rateOut) {
        rateIn = VMR_ETH_RATE_IN;
        rateOut = VMR_ETH_RATE_OUT;
    }

    function setNewEthRateIn(uint256 newVMR_ETH_RATE_IN_Wei) onlyOwner public {
        require(newVMR_ETH_RATE_IN_Wei > 0);
        VMR_ETH_RATE_IN = newVMR_ETH_RATE_IN_Wei;
    }
    
    function setNewEthRateOut(uint256 newVMR_ETH_RATE_OUT_Wei) onlyOwner public {
        require(newVMR_ETH_RATE_OUT_Wei > 0);
        VMR_ETH_RATE_OUT = newVMR_ETH_RATE_OUT_Wei;
    }

    function setSupportAddress(address payable newSupportAddress) onlyOwner public {
        require(newSupportAddress != address(0));
        supportAddress = newSupportAddress;
    }
    
    function safeEthTransfer(address target, uint256 amount) internal {
        address payable payableTarget = address(uint160(target));
        (bool ok, ) = payableTarget.call.value(amount)("");
        require(ok);
    }

    function setAdmin(address newAdmin, bool activate) onlyOwner public {
        admins[newAdmin] = activate;
    }
    
    function withdraw(uint256 amount)  public onlyOwner {
        if (dateUntilFundsLocked > now) require(address(this).balance.sub(amount) > fundsLockedtoWithdraw);
        owner.transfer(amount);
    }
    
    function lockFunds(uint256 amount) public onlyOwner {
        // funds lock is active
        if (dateUntilFundsLocked > now) {
            require(amount > fundsLockedtoWithdraw);
        }
        fundsLockedtoWithdraw = amount;
        dateUntilFundsLocked = now + 30 days;
    }
    
    function changeOwnerCandidate(address payable newOwner) public onlyOwner {
        newOwnerCandidate = newOwner;
    }
    
    function acceptOwner() public {
        require(msg.sender == newOwnerCandidate);
        owner = newOwnerCandidate;
    }
    
    function bytesToAddress(bytes memory bys) private pure returns (address payable addr) {
        assembly {
          addr := mload(add(bys,20))
        } 
    }
    // function for transfer any token from contract
    function transferTokens (address token, address target, uint256 amount) onlyOwner public
    {
        ERC20Token(token).transfer(target, amount);
    }
    
    function getInfo(address userAddress) view public returns (uint256 contractBalance, uint96 pendingUserRewardVMR, uint96 pendingUserRewardEther, uint96 totalDepositedVMR, uint96 totalWithdrawnVMR, uint96 totalWithdrawnEther, uint96 totalPartnerWithdrawnEther,
            uint96 pendingPartnerRewardEther, uint96 specialPartnerRewardEther, uint96 specialPartnerPercent, address partner) 
    {
        contractBalance = address(this).balance;
        
        InvestorData memory data = investors[userAddress];
        
        totalDepositedVMR = data.totalDepositedVMR;
        totalWithdrawnVMR = data.totalWithdrawnVMR;
        totalWithdrawnEther = data.totalWithdrawnEther;
        totalPartnerWithdrawnEther = data.totalPartnerWithdrawnEther;
        pendingPartnerRewardEther = data.pendingPartnerRewardEther;
        specialPartnerRewardEther = data.specialPartnerRewardEther;
        specialPartnerPercent = uint96(data.specialPartnerPercent);
        
        pendingUserRewardVMR = uint96(data.totalDepositedVMR.mul(20).div(100).mul(block.timestamp - data.lastDatetime).div(30 days));
        pendingUserRewardEther = uint96(pendingUserRewardVMR.mul(VMR_ETH_RATE_OUT) / 1e18);
        
        partner = refList[userAddress];
    }
    
    function setupRef() internal returns (address) {
        
        address partner = refList[msg.sender];
        if (partner == address(0))
        {
            if (msg.data.length == 20) {
                partner = bytesToAddress(msg.data);
                
                require(partner != msg.sender, "You can't ref yourself");

                refList[msg.sender] = partner;
            }
        }
        return partner;
    }

    function setSpecialPartner(address userAddress, uint96 specialPartnerRewardEther, uint8 specialPartnerPercent) public onlyAdmin 
    {
        InvestorData storage data = investors[userAddress];
        data.specialPartnerRewardEther = specialPartnerRewardEther;
        data.specialPartnerPercent = specialPartnerPercent;
    }

    function setUserData(address userAddress, uint96 lastDatetime, uint96 totalDepositedVMR, uint96 totalWithdrawnVMR, uint96 totalWithdrawnEther, uint96 totalPartnerWithdrawnEther,  uint96 pendingPartnerRewardEther) public onlyAdmin 
    {
        InvestorData storage data = investors[userAddress];
        if (lastDatetime > 0) data.lastDatetime = lastDatetime;
        if (totalDepositedVMR > 0) data.totalDepositedVMR = totalDepositedVMR;
        if (totalWithdrawnVMR > 0) data.totalWithdrawnVMR = totalWithdrawnVMR;
        if (totalWithdrawnEther > 0) data.totalWithdrawnEther = totalWithdrawnEther;
        if (totalPartnerWithdrawnEther > 0) data.totalPartnerWithdrawnEther = totalPartnerWithdrawnEther;
        if (pendingPartnerRewardEther > 0) data.pendingPartnerRewardEther = pendingPartnerRewardEther;
    }
    
    
    function () payable external
    {
        require(msg.sender == tx.origin); // prevent bots to interact with contract
        
        if (msg.sender == owner) return; 
        
        InvestorData storage data = investors[msg.sender];
        
        address partnerAddress = setupRef();
        require(partnerAddress != address(0)); 
        
        if (msg.value > 0)
        {
            require(msg.value > minEtherAmount);
            //
            InvestorData storage partnerData = investors[partnerAddress];
            uint8 p = partnerData.specialPartnerPercent;
            uint96 specialPartnerRewardEther = partnerData.specialPartnerRewardEther;
            if (p > 0) {
                uint96 reward = uint96(msg.value.mul(p).div(100));
                if (specialPartnerRewardEther > reward) {
                    specialPartnerRewardEther -= reward;
                } else {
                    reward = uint96(specialPartnerRewardEther + (100 - specialPartnerRewardEther * 100 / reward) * msg.value.mul(25).div(100) / 100);
                    specialPartnerRewardEther = 0;
                    partnerData.specialPartnerPercent = 0;
                }
                
                partnerData.specialPartnerRewardEther = specialPartnerRewardEther;
                partnerData.pendingPartnerRewardEther += reward;
            } else {
                partnerData.pendingPartnerRewardEther += uint96(msg.value.mul(25).div(100)); 
                if (supportAddress != address(0)) safeEthTransfer(supportAddress, msg.value.mul(5).div(100));
            }
        }
        
        // вывод прибыли партнёра
        if (data.pendingPartnerRewardEther > 0) {
            uint96 reward = data.pendingPartnerRewardEther;
            data.pendingPartnerRewardEther = 0;
            data.totalPartnerWithdrawnEther += reward;
            safeEthTransfer(msg.sender, reward);
        }

        // totalProfitVMR
        if (data.totalDepositedVMR != 0 && data.lastDatetime > 0) {
            // 20% per 30 days
            uint96 rewardVMR = uint96(data.totalDepositedVMR.mul(20).div(100).mul(block.timestamp - data.lastDatetime).div(30 days));
            uint96 rewardEther = uint96(rewardVMR.mul(VMR_ETH_RATE_OUT) / 1e18);
            data.totalWithdrawnEther += rewardEther;
            data.totalWithdrawnVMR += rewardVMR;
            
            safeEthTransfer(msg.sender, rewardEther);
        }

        data.lastDatetime = uint96(block.timestamp);
        if (msg.value > 0) data.totalDepositedVMR = uint96(data.totalDepositedVMR.add(msg.value.mul(70).div(100) * VMR_ETH_RATE_IN / 1e18));
    }
}