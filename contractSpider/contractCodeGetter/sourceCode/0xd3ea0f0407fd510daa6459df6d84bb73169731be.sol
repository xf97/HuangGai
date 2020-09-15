/**
 *Submitted for verification at Etherscan.io on 2020-05-16
*/

/*
|| <🤖️> Smart Terms of Service (STOS) <📜️> ||

DEAR MSG.SENDER(S):

/ STOS is a project in beta.
// Please audit and use at your own risk.
/// Entry into STOS shall not create an attorney/client relationship.
//// Likewise, STOS should not be construed as legal advice or replacement for professional counsel.
///// STEAL THIS C0D3SL4W 

~presented by Open, ESQ || lexDAO LLC
*/

pragma solidity 0.5.17;

interface IToken { // brief ERC-20 interface
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

/*********************
SMART TERMS OF SERVICE
> `$RCLE Legal Wrapper
*********************/
contract RCLETermsOfService { 
    // internal token references
    address public leethToken = 0x5A844590c5b8f40ae56190771d06c60b9ab1Da1C; // $RCLE
    IToken private leeth = IToken(leethToken);
    address public ownerToken = 0xa6CB74128e193DA7D82C43056a2dE4a5a672EAF7; // $RCKEY
    IToken private owner = IToken(ownerToken);
    // stos 
    uint256 inducementRate;
    uint256 offerAmount;
    uint8 public version;
    string public emoji = "🎩📜";
    string public offer;
    string public terms;
    
    // signature tracking 
    uint256 public signature; 
    mapping (uint256 => Signature) public sigs;
    
    struct Signature {  
        address signatory; 
        uint256 number;
        uint8 version;
        string details;
        string terms;
        bool redemption; 
    }
    
    event Signed(address indexed signatory, uint256 indexed number, string indexed details);
    event InducementRateUpgraded(uint256 indexed inducementRate);
    event OfferUpgraded(string indexed offer);
    event OfferAmountUpgraded(uint256 indexed offerAmount);
    event SignatureUpgraded(address indexed signatory, uint256 indexed number, string indexed details);
    event TermsUpgraded(uint8 indexed version, string indexed terms);
    
    constructor (uint256 _inducementRate, uint256 _offerAmount, string memory _offer, string memory _terms) public {
        inducementRate = _inducementRate;
        offerAmount = _offerAmount;
        offer = _offer;
        terms = _terms;
    } 
    
    /***************
    STOS FUNCTIONS
    ***************/
    function signOffer(string memory details) public {
	    uint256 number = signature + 1; 
	    signature = signature + 1;
	    
        sigs[number] = Signature( 
                msg.sender,
                number,
                version,
                details,
                terms,
                true);
                
        leeth.transferFrom(msg.sender, address(this), offerAmount);
        emit Signed(msg.sender, number, details);
    }
    
    function signTerms(string memory details) public {
        require(leeth.balanceOf(msg.sender) > 0, "leethToken balance insufficient");
	    uint256 number = signature + 1; 
	    signature = signature + 1;
	    
        sigs[number] = Signature( 
                msg.sender,
                number,
                version,
                details,
                terms,
                false);
                
        leeth.transfer(msg.sender, leeth.balanceOf(msg.sender) / inducementRate);
        emit Signed(msg.sender, number, details);
    } 
    
    function upgradeSignature(uint256 number, string memory details) public {
        Signature storage sig = sigs[number];
        require(msg.sender == sig.signatory);
        
        sig.version = version;
        sig.details = details;
        sig.terms = terms;

        emit SignatureUpgraded(msg.sender, number, details);
    } 
    
    /***************
    MGMT FUNCTIONS
    ***************/
    // offer / terms
    function upgradeOffer(string memory _offer) public {
        require(owner.balanceOf(msg.sender) > 0, "ownerToken balance insufficient");
        offer = _offer;
        emit OfferUpgraded(offer);
    } 
    
    function upgradeTerms(string memory _terms) public {
        require(owner.balanceOf(msg.sender) > 0, "ownerToken balance insufficient");
        version = version + 1;
        terms = _terms;
        emit TermsUpgraded(version, terms);
    } 
    
    // leeth mgmt
    function upgradeInducementRate(uint256 _inducementRate) public {
        require(owner.balanceOf(msg.sender) > 0, "ownerToken balance insufficient");
        inducementRate = _inducementRate;
        emit InducementRateUpgraded(inducementRate);
    }
    
     function upgradeOfferAmount(uint256 _offerAmount) public {
        require(owner.balanceOf(msg.sender) > 0, "ownerToken balance insufficient");
        offerAmount = _offerAmount;
        emit OfferAmountUpgraded(offerAmount);
    }
    
    function withdrawLEETH() public {
        require(owner.balanceOf(msg.sender) > 0, "ownerToken balance insufficient");
        leeth.transfer(msg.sender, leeth.balanceOf(address(this)));
    } 
}