/**
 *Submitted for verification at Etherscan.io on 2020-05-15
*/

pragma solidity ^0.5.17;

contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner || tx.origin == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

interface TokenInterface {
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title  Lition Vesting Contract
 * @author Patricio Mosse
 **/
contract LitionVesting is Ownable {
    using SafeMath for uint256;

    TokenInterface public token;
    
    address[] public holders;
    
    mapping (address => Holding[]) public holdings;

    struct Holding {
        uint256 totalTokens;
        uint256 unlockDate;
        bool claimed;
    }
    
    bool teamEcosystemCommunityInitialized = false;
    bool investorsAdvisors1Initialized = false;
    bool investorsAdvisors2Initialized = false;

    // Events
    event TokensReleased(address _to, uint256 _tokensReleased);
    
    // Dates
    uint256 april_01_2021 = 1617228000;
    
    uint256 july_15_2020 = 1594764000;
    uint256 october_15_2020 = 1602712800;
    uint256 january_15_2021 = 1610665200;
    uint256 april_15_2021 = 1618437600;
    
    uint256 july_15_2021 = 1626300000;
    
    uint256 june_30_2020 = 1593468000;
    uint256 december_31_2020 = 1609369200;
    uint256 june_30_2021 = 1625004000;
    uint256 december_31_2021 = 1640905200;
    
    // Wallets
    address teamWallet = 0x80BCd5a881A159d84521c8d06ab2c10edc486341;
    address ecosystemWallet = 0x25a13Edb1651DC729691134dB3a450f5D94292e9;
    address communityWallet = 0xA443e7c9EB6F0855eD237817CFbC2D74b87F60Fd;
    
    address investor_1_Wallet = 0xfe568f98dF64e7B49050FfE810D9f78952bb4f92;
    address investor_2_Wallet = 0x47C2F58aC01770e4bbeF401FDde1821c370BF5b0;
    address investor_3_Wallet = 0xeea95625332612fdbAB0713417d09e900028D9Fd;
    address investor_4_Wallet = 0xa9053549B32Ea35daf4999212d8Cb9f7b4ce3A7B;
    address investor_5_Wallet = 0xBf16D4B69619FbbeB878bb2D86c081aF1fc127b6;
    address investor_6_Wallet = 0xCcbc8e2713b96CC821bDdb74b6D71acd7d29c172;
    address investor_7_Wallet = 0x8121f802237A70C8D1220220D6B55786a436B78d;
    address investor_8_Wallet = 0x3f19FC15a62De71eaf5E8003c176f16b3c99822C;
    address investor_9_Wallet = 0xA579672BD4044f4f6C3502e571e370ECadeC9258;
    address investor_10_Wallet = 0x710a630B2409f3f702939FEAB09512c07eD140Ef;
    address investor_11_Wallet = 0x88FA0266C1036f52D20366a0203f9b3782CF794B;
    address investor_12_Wallet = 0xE1ED0F1a13515552fe0d5f779cCD56DB30f6DBa2;
    address investor_13_Wallet = 0x763c7C7Bf6b39FC5062E6FB8fd287dd3a3CF5f55;
    address investor_14_Wallet = 0x92cfdcEEb276a6Bc2f13B6907CD8E6aC245dD0FE;
    address investor_15_Wallet = 0xA21880528906dd770e22db5Bb1E2835fd693d8D8;
    address investor_16_Wallet = 0x7E3ace45Ffe3b6b7E5815057A4e29E6e18d6dD19;
    address investor_17_Wallet = 0xD1d4c1c16aEb26528D731dDB54Bb0Bff9608b6ca;
    address investor_18_Wallet = 0x8B4D7019c40084Ceb95a7B6FA6880312CF78be6a;
    address investor_19_Wallet = 0x055c484fF3592211eC2DA416edF9eAf900767E35;
    address investor_20_Wallet = 0x8f34031645D5609D0898e80566AFad1182232B63;
    address investor_21_Wallet = 0xEF4F09580673910d9FdcE1bc8D26389DBB75C7a0;
    address investor_22_Wallet = 0xa27A3A45Ed3218506c9d825990C80208DcEce99E;
    
    function getVestingByBeneficiary(address _beneficiary, uint256 _index) external view returns (uint256 totalTokens, uint256 unlockDate, bool claimed) {
        require(holdings[_beneficiary].length > _index, "The holding doesn't exist");
        Holding memory holding = holdings[_beneficiary][_index];
        totalTokens = holding.totalTokens;
        unlockDate = holding.unlockDate;
        claimed = holding.claimed;
    }
    
    function getTotalVestingsByBeneficiary(address _beneficiary) external view returns (uint256) {
        return holdings[_beneficiary].length;
    }

    function getTotalToClaimNowByBeneficiary(address _beneficiary) public view returns(uint256) {
        uint256 total = 0;
        
        for (uint256 i = 0; i < holdings[_beneficiary].length; i++) {
            Holding memory holding = holdings[_beneficiary][i];
            if (!holding.claimed && now > holding.unlockDate) {
                total = total.add(holding.totalTokens);
            }
        }

        return total;
    }
    
    function getTotalVested() public view returns(uint256) {
        uint256 total = 0;
        
        for (uint256 i = 0; i < holders.length; i++) {
            for (uint256 j = 0; j < holdings[holders[i]].length; j++) {
                Holding memory holding = holdings[holders[i]][j];
                total = total.add(holding.totalTokens);
            }
        }

        return total;
    }
    
    function getTotalClaimed() public view returns(uint256) {
        uint256 total = 0;
        
        for (uint256 i = 0; i < holders.length; i++) {
            for (uint256 j = 0; j < holdings[holders[i]].length; j++) {
                Holding memory holding = holdings[holders[i]][j];
                if (holding.claimed) {
                    total = total.add(holding.totalTokens);
                }
            }
        }

        return total;
    }

    function claimTokens() external
    {
        uint256 tokensToClaim = getTotalToClaimNowByBeneficiary(msg.sender);
        
        require(tokensToClaim > 0, "Nothing to claim");
        
        for (uint256 i = 0; i < holdings[msg.sender].length; i++) {
            Holding storage holding = holdings[msg.sender][i];
            if (!holding.claimed && now > holding.unlockDate) {
                holding.claimed = true;
                require(token.transfer(msg.sender, tokensToClaim), "Insufficient balance in vesting contract");
                emit TokensReleased(msg.sender, tokensToClaim);
            }
        }
    }
    
    function _addHolderToList(address _beneficiary) internal {
        for (uint256 i = 0; i < holders.length; i++) {
            if (holders[i] == _beneficiary) {
                return;
            }
        }
        holders.push(_beneficiary);
    }

    function _createVesting(address _beneficiary, uint256 _tokens, uint256 _unlockDate) internal {
        _addHolderToList(_beneficiary);
        Holding memory holding = Holding(_tokens, _unlockDate, false);
        holdings[_beneficiary].push(holding);
    }
    
    constructor(address _token) public {
        token = TokenInterface(_token);
    }
    
    function _initializeTeamEcosystemCommunity() public onlyOwner {
        require(!teamEcosystemCommunityInitialized, "Already initialized");
        teamEcosystemCommunityInitialized = true;
        
        // Team: 2.950.000
        _createVesting(teamWallet, 2950000000000000000000000, april_01_2021); 
        
        // Ecosystem: 8.080.000
        _createVesting(ecosystemWallet, 2020000000000000000000000, july_15_2020); 
        _createVesting(ecosystemWallet, 2020000000000000000000000, october_15_2020); 
        _createVesting(ecosystemWallet, 2020000000000000000000000, january_15_2021); 
        _createVesting(ecosystemWallet, 2020000000000000000000000, april_15_2021); 
        
        // Community: 8.937.500
        _createVesting(communityWallet, 1787500000000000000000000, july_15_2020); 
        _createVesting(communityWallet, 1787500000000000000000000, october_15_2020); 
        _createVesting(communityWallet, 1787500000000000000000000, january_15_2021); 
        _createVesting(communityWallet, 1787500000000000000000000, april_15_2021); 
        _createVesting(communityWallet, 1787500000000000000000000, july_15_2021); 
    }
    
    // Investors and advisors: 18.793.753
    function _initializeInvestorsAdvisors1() public onlyOwner {
        require(!investorsAdvisors1Initialized, "Already initialized");
        investorsAdvisors1Initialized = true;
        
        // - Total: 850.000
        _createVesting(investor_1_Wallet, 212500000000000000000000, june_30_2020); 
        _createVesting(investor_1_Wallet, 212500000000000000000000, december_31_2020); 
        _createVesting(investor_1_Wallet, 212500000000000000000000, june_30_2021); 
        _createVesting(investor_1_Wallet, 212500000000000000000000, december_31_2021); 
        
        // - Total: 2.125.000
        _createVesting(investor_2_Wallet, 531250000000000000000000, june_30_2020); 
        _createVesting(investor_2_Wallet, 531250000000000000000000, december_31_2020); 
        _createVesting(investor_2_Wallet, 531250000000000000000000, june_30_2021); 
        _createVesting(investor_2_Wallet, 531250000000000000000000, december_31_2021); 
        
        // - Total: 255.000
        _createVesting(investor_3_Wallet, 63750000000000000000000, june_30_2020); 
        _createVesting(investor_3_Wallet, 63750000000000000000000, december_31_2020); 
        _createVesting(investor_3_Wallet, 63750000000000000000000, june_30_2021); 
        _createVesting(investor_3_Wallet, 63750000000000000000000, december_31_2021); 

        // - Total: 2.656.250
        _createVesting(investor_4_Wallet, 664062500000000000000000, june_30_2020); 
        _createVesting(investor_4_Wallet, 664062500000000000000000, december_31_2020); 
        _createVesting(investor_4_Wallet, 664062500000000000000000, june_30_2021); 
        _createVesting(investor_4_Wallet, 664062500000000000000000, december_31_2021); 

        // - Total: 295.139 
        _createVesting(investor_5_Wallet, 73784750000000000000000, june_30_2020); 
        _createVesting(investor_5_Wallet, 73784750000000000000000, december_31_2020); 
        _createVesting(investor_5_Wallet, 73784750000000000000000, june_30_2021); 
        _createVesting(investor_5_Wallet, 73784750000000000000000, december_31_2021); 

        // - Total: 5.568.611
        _createVesting(investor_6_Wallet, 1392152750000000000000000, june_30_2020); 
        _createVesting(investor_6_Wallet, 1392152750000000000000000, december_31_2020); 
        _createVesting(investor_6_Wallet, 1392152750000000000000000, june_30_2021); 
        _createVesting(investor_6_Wallet, 1392152750000000000000000, december_31_2021); 

        // - Total: 42.500 
        _createVesting(investor_7_Wallet, 10625000000000000000000, june_30_2020); 
        _createVesting(investor_7_Wallet, 10625000000000000000000, december_31_2020); 
        _createVesting(investor_7_Wallet, 10625000000000000000000, june_30_2021); 
        _createVesting(investor_7_Wallet, 10625000000000000000000, december_31_2021); 

        // - Total: 807.353 
        _createVesting(investor_8_Wallet, 201838250000000000000000, june_30_2020); 
        _createVesting(investor_8_Wallet, 201838250000000000000000, december_31_2020); 
        _createVesting(investor_8_Wallet, 201838250000000000000000, june_30_2021); 
        _createVesting(investor_8_Wallet, 201838250000000000000000, december_31_2021); 

        // - Total: 850.000 
        _createVesting(investor_9_Wallet, 212500000000000000000000, june_30_2020); 
        _createVesting(investor_9_Wallet, 212500000000000000000000, december_31_2020); 
        _createVesting(investor_9_Wallet, 212500000000000000000000, june_30_2021); 
        _createVesting(investor_9_Wallet, 212500000000000000000000, december_31_2021); 

        // - Total: 425.000 
        _createVesting(investor_10_Wallet, 106250000000000000000000, june_30_2020); 
        _createVesting(investor_10_Wallet, 106250000000000000000000, december_31_2020); 
        _createVesting(investor_10_Wallet, 106250000000000000000000, june_30_2021); 
        _createVesting(investor_10_Wallet, 106250000000000000000000, december_31_2021); 

    }
    
    function _initializeInvestorsAdvisors2() public onlyOwner {
        require(!investorsAdvisors2Initialized, "Already initialized");
        investorsAdvisors2Initialized = true;

        // - Total: 63.750 
        _createVesting(investor_11_Wallet, 15937500000000000000000, june_30_2020); 
        _createVesting(investor_11_Wallet, 15937500000000000000000, december_31_2020); 
        _createVesting(investor_11_Wallet, 15937500000000000000000, june_30_2021); 
        _createVesting(investor_11_Wallet, 15937500000000000000000, december_31_2021); 

        // - Total: 63.750 
        _createVesting(investor_12_Wallet, 15937500000000000000000, june_30_2020); 
        _createVesting(investor_12_Wallet, 15937500000000000000000, december_31_2020); 
        _createVesting(investor_12_Wallet, 15937500000000000000000, june_30_2021); 
        _createVesting(investor_12_Wallet, 15937500000000000000000, december_31_2021); 

        // - Total: 21.250 
        _createVesting(investor_13_Wallet, 5312500000000000000000, june_30_2020); 
        _createVesting(investor_13_Wallet, 5312500000000000000000, december_31_2020); 
        _createVesting(investor_13_Wallet, 5312500000000000000000, june_30_2021); 
        _createVesting(investor_13_Wallet, 5312500000000000000000, december_31_2021); 

        // - Total: 212.500 
        _createVesting(investor_14_Wallet, 53125000000000000000000, june_30_2020); 
        _createVesting(investor_14_Wallet, 53125000000000000000000, december_31_2020); 
        _createVesting(investor_14_Wallet, 53125000000000000000000, june_30_2021); 
        _createVesting(investor_14_Wallet, 53125000000000000000000, december_31_2021); 

        // - Total: 607.143 
        _createVesting(investor_15_Wallet, 151785750000000000000000, june_30_2020); 
        _createVesting(investor_15_Wallet, 151785750000000000000000, december_31_2020); 
        _createVesting(investor_15_Wallet, 151785750000000000000000, june_30_2021); 
        _createVesting(investor_15_Wallet, 151785750000000000000000, december_31_2021); 

        // - Total: 5.865 
        _createVesting(investor_16_Wallet, 1466250000000000000000, june_30_2020); 
        _createVesting(investor_16_Wallet, 1466250000000000000000, december_31_2020); 
        _createVesting(investor_16_Wallet, 1466250000000000000000, june_30_2021); 
        _createVesting(investor_16_Wallet, 1466250000000000000000, december_31_2021); 

        // - Total: 616.250 
        _createVesting(investor_17_Wallet, 154062500000000000000000, june_30_2020); 
        _createVesting(investor_17_Wallet, 154062500000000000000000, december_31_2020); 
        _createVesting(investor_17_Wallet, 154062500000000000000000, june_30_2021); 
        _createVesting(investor_17_Wallet, 154062500000000000000000, december_31_2021); 

        // - Total: 308.125 
        _createVesting(investor_18_Wallet, 77031250000000000000000, june_30_2020); 
        _createVesting(investor_18_Wallet, 77031250000000000000000, december_31_2020); 
        _createVesting(investor_18_Wallet, 77031250000000000000000, june_30_2021); 
        _createVesting(investor_18_Wallet, 77031250000000000000000, december_31_2021); 

        // - Total: 63.750 
        _createVesting(investor_19_Wallet, 15937500000000000000000, june_30_2020); 
        _createVesting(investor_19_Wallet, 15937500000000000000000, december_31_2020); 
        _createVesting(investor_19_Wallet, 15937500000000000000000, june_30_2021); 
        _createVesting(investor_19_Wallet, 15937500000000000000000, december_31_2021); 

        // - Total: 1.020.000 
        _createVesting(investor_20_Wallet, 255000000000000000000000, june_30_2020); 
        _createVesting(investor_20_Wallet, 255000000000000000000000, december_31_2020); 
        _createVesting(investor_20_Wallet, 255000000000000000000000, june_30_2021); 
        _createVesting(investor_20_Wallet, 255000000000000000000000, december_31_2021); 

        // - Total: 311.367 
        _createVesting(investor_21_Wallet, 77841750000000000000000, june_30_2020); 
        _createVesting(investor_21_Wallet, 77841750000000000000000, december_31_2020); 
        _createVesting(investor_21_Wallet, 77841750000000000000000, june_30_2021); 
        _createVesting(investor_21_Wallet, 77841750000000000000000, december_31_2021); 

        // - Total: 1.636.250
        _createVesting(investor_22_Wallet, 409062500000000000000000, june_30_2020); 
        _createVesting(investor_22_Wallet, 409062500000000000000000, december_31_2020); 
        _createVesting(investor_22_Wallet, 409062500000000000000000, june_30_2021); 
        _createVesting(investor_22_Wallet, 409062500000000000000000, december_31_2021); 
    }

    function _claimUnallocated( address _sendTo) external onlyOwner{
        uint256 allTokens = token.balanceOf(address(this));
        token.transfer(_sendTo, allTokens);
    }
}