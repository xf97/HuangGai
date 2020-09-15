/**
 *Submitted for verification at Etherscan.io on 2020-07-25
*/

pragma solidity ^0.4.26;

/**
* @title SafeMath
* @dev Math operations with safety checks that throw on error
*/
contract SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
        return 0;
    }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
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
  
    function percent(uint value,uint numerator, uint denominator, uint precision) internal pure  returns(uint quotient) {
        uint _numerator  = numerator * 10 ** (precision+1);
        uint _quotient =  ((_numerator / denominator) + 5) / 10;
        return (value*_quotient/1000000000000000000);
    }
}

contract DIFI is SafeMath {
    string public constant name                         = "DIFI";                       // Name of the token
    string public constant symbol                       = "DI";                           // Symbol of token
    uint256 public constant decimals                    = 18;                               // Decimal of token
    uint256 public constant _totalsupply                = 200000000 * 10 ** decimals;       // 200 million total supply
    uint256 public constant _premined                   = 100000000 * 10 ** decimals;       // 100 million premined tokens
    uint256 public _mined                               = 0;                                // Mined tokens
    uint256 internal stakePer_                          = 100000000000000000;               // 0.2% Daily reward
    address public owner                                = msg.sender;                       // Owner of smart contract
    address public admin                                = 0x2ce288F5eC5CB5d674fCac0E59187A785351F011;// Admin of smart contract 

    mapping (address => uint256) balances;
    mapping (address => uint256) mintbalances;
    mapping (address => uint256) mintingTime;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    // Only owner can access the function
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }
    
    // Only admin can access the function
    modifier onlyAdmin() {
        if (msg.sender != admin) {
            revert();
        }
        _;
    }
    
    constructor() public {
        balances[admin]        = _premined;
        emit Transfer(0, admin, _premined);
    }
    
    // Token minting function
    function mint(uint256 _amount) public returns (bool success) {
        address _customerAddress    = msg.sender;
        require(_totalsupply > (SafeMath.add(_premined, _mined)));                                   // Total supply should be > premined token and mined token combined
        require(mintingTime[_customerAddress] == 0);                                                
        require(balances[msg.sender] >= _amount && _amount >= 0);
        mintbalances[_customerAddress]      = _amount;
        mintingTime[_customerAddress]       = now;
        return true;
    }
    
    function mintTokensROI(address _customerAddress) public view returns(uint256){
        uint256 timediff                    = SafeMath.sub(now, mintingTime[_customerAddress]);
        uint256 dayscount                   = SafeMath.div(timediff, 86400); //86400 Sec for 1 Day
        uint256 roiPercent                  = SafeMath.mul(dayscount, stakePer_);
        uint256 roiTokens                   = SafeMath.percent(mintbalances[_customerAddress],roiPercent,100,18);
        uint256 finalBalance                = roiTokens/1e18;
        return finalBalance;
    }
    
    function mintTokens(address _customerAddress) public view returns(uint256){
        return mintbalances[_customerAddress];
    }
    
    function mintTokensTime(address _customerAddress) public view returns(uint256){
        return mintingTime[_customerAddress];
    }
    
    function unmintTokens() public returns(bool success){
        address _customerAddress    = msg.sender;
        require(mintingTime[_customerAddress] > 0); 
        uint256 timediff                    = SafeMath.sub(now, mintingTime[_customerAddress]);
        uint256 dayscount                   = SafeMath.div(timediff, 86400); //86400 Sec for 1 Day
        uint256 roiPercent                  = SafeMath.mul(dayscount, stakePer_);
        uint256 roiTokens                   = SafeMath.percent(mintbalances[_customerAddress],roiPercent,100,18);
        balances[_customerAddress]          = SafeMath.add(balances[_customerAddress],roiTokens/1e18);
        _mined                              = SafeMath.add(_mined, roiTokens/1e18);
        mintbalances[_customerAddress]      = 0;
        mintingTime[_customerAddress]       = 0;
        return true;
    }
    
    function changeStakePercent(uint256 stakePercent) onlyAdmin public {
        stakePer_                           = stakePercent;
    }
    
    // Show token balance of address owner
    function balanceOf(address _owner) public view returns (uint256 balance) {
        uint256 finalBalance = SafeMath.sub(balances[_owner],mintbalances[_owner]);
        return finalBalance;
    }
    
    // Token transfer function
    // Token amount should be in 18 decimals (eg. 199 * 10 ** 18)
    function transfer(address _to, uint256 _amount ) public {
        uint256 finalBalance = SafeMath.sub(balances[msg.sender],mintbalances[msg.sender]);
        require(finalBalance >= _amount && _amount >= 0);
        balances[msg.sender]            = sub(balances[msg.sender], _amount);
        balances[_to]                   = add(balances[_to], _amount);
        emit Transfer(msg.sender, _to, _amount);
    }
    
    // Total Supply of DochStar
    function totalSupply() public pure returns (uint256 total_Supply) {
        total_Supply = _totalsupply;
    }
    
    // Change Admin of this contract
    function changeAdmin(address _newAdminAddress) external onlyOwner {
        admin = _newAdminAddress;
    }
    
}