/**
 *Submitted for verification at Etherscan.io on 2020-06-01
*/

/*
|| <📜️️> Smart Terms of Service (STOS) <⚖> ||

DEAR MSG.SENDER(S):

/ STOS is a project in beta.
// Please audit and use at your own risk.
/// Entry into STOS shall not create an attorney/client relationship.
//// Likewise, STOS should not be construed as legal advice or replacement for professional counsel.
///// STEAL THIS C0D3SL4W 

~presented by Open, ESQ || LexDAO LLC
*/

pragma solidity 0.5.17;

interface IToken { // brief ERC-20 interface
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

/*********************
SMART TERMS OF SERVICE
> `$LXM Legal Wrapper
*********************/
contract TermsOfService { 
    // internal token references
    address public leethToken = 0x15Dbc0A51FAD8F932872cB00EfC868f52FA99807; // $LXM
    IToken private leeth = IToken(leethToken);
    address public ownerToken = 0x7bfCB5772FE0BDB53Ad829340dD92123Ed1196eC; // $LXKEY
    IToken private owner = IToken(ownerToken);
    // stos 
    uint256 public purchaseRate;
    uint256 public redemptionAmount;
    string public emoji = "📜⚖";
    string public offer;
    string public terms;
    
    // signature tracking 
    uint256 public signature; 
    mapping (uint256 => Signature) public sigs;
    
    struct Signature {  
        address signatory;
        uint256 number;
        string details;
        string terms;
    }
    
    event OfferUpgraded(string indexed _offer);
    event Purchased(address indexed sender, uint256 indexed purchaseAmount);
    event PurchaseRateUpgraded(uint256 indexed _purchaseRate);
    event RedemptionAmountUpgraded(uint256 indexed _redemptionAmount);
    event Signed(address indexed signatory, uint256 indexed number, string indexed details);
    event TermsUpgraded(string indexed _terms);
    
    constructor (uint256 _purchaseRate, uint256 _redemptionAmount, string memory _offer, string memory _terms) public {
        purchaseRate = _purchaseRate;
        redemptionAmount = _redemptionAmount;
        offer = _offer;
        terms = _terms;
    } 
    
    /*************
    STOS FUNCTIONS
    *************/
    function() external payable { 
        uint256 purchaseAmount = msg.value * purchaseRate;
        leeth.transfer(msg.sender, purchaseAmount);
        emit Purchased(msg.sender, purchaseAmount);
    } 
    
    function redeemOffer(string memory details) public {
	    uint256 number = signature + 1; 
	    signature = signature + 1;
	    
        sigs[number] = Signature( 
            msg.sender,
            number,
            details,
            terms);
                
        leeth.transferFrom(msg.sender, address(this), redemptionAmount);
        emit Signed(msg.sender, number, details);
    }
 
    /*************
    MGMT FUNCTIONS
    *************/
    modifier onlyOwner () {
        require(owner.balanceOf(msg.sender) > 0, "ownerToken balance insufficient");
        _;
    }
    
    // offer / terms
    function upgradeOffer(string memory _offer) public onlyOwner {
        offer = _offer;
        emit OfferUpgraded(_offer);
    } 
    
    function upgradeTerms(string memory _terms) public onlyOwner {
        terms = _terms;
        emit TermsUpgraded(_terms);
    } 
    
    // leeth mgmt
    function upgradePurchaseRate(uint256 _purchaseRate) public onlyOwner {
        purchaseRate = _purchaseRate;
        emit PurchaseRateUpgraded(_purchaseRate);
    }
    
    function upgradeRedemptionAmount(uint256 _redemptionAmount) public onlyOwner {
        redemptionAmount = _redemptionAmount;
        emit RedemptionAmountUpgraded(_redemptionAmount);
    }
    
    function withdrawETH() public onlyOwner {
        address(msg.sender).transfer(address(this).balance);
    }
    
    function withdrawLEETH() public onlyOwner {
        leeth.transfer(msg.sender, leeth.balanceOf(address(this)));
    } 
}