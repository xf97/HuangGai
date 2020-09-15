/**
 *Submitted for verification at Etherscan.io on 2020-07-09
*/

pragma solidity ^0.5.16;

// A Digital Disputable Buyer and Seller Agreement for Goods or Services. 
// Adapted from LEE - LexDAO Ether Escrow || author: Ro5s lexDAO ||
// Modified in part by Scott H. Stevenson for the Web3-WorldLaw and Web3vm system of protocols

contract DisputableBuyerSellerAgreement {
    
    address payable public buyer;
    address payable public seller;
    address payable public arbitrator;
    uint256 public priceValue;
    string public agreementTerms;
    string public disputeDescription;
    bool public agreementIsDisputed;
    bool public agreementIsCompleted;
    
    event ReleasedAgreement(uint256 indexed priceValue);
    event DisputedAgreement(address indexed complainant);
    event ResolvedAgreement(uint256 indexed resolvedBuyerPortion, uint256 indexed resolvedSellerPortion);
    
    constructor(
        address payable _buyer,
        address payable _seller,
        address payable _arbitrator,
        string memory _agreementTerms) payable public {
        buyer = _buyer;
        seller = _seller;
        arbitrator = _arbitrator;
        priceValue = msg.value;
        agreementTerms = _agreementTerms;
    }
    
    function releasePriceValue() public {
        require(msg.sender == buyer, "The current user must be the buyer.");
        require(agreementIsDisputed == false, "The agreement must not be in dispute.");
        address(seller).transfer(priceValue);
        agreementIsCompleted = true;
        emit ReleasedAgreement(priceValue);
    }
    
    function disputeAgreement(string memory _disputeDescription) public {
        require(msg.sender == buyer || msg.sender == seller, "The current user must be the buyer or seller." );
        require(agreementIsCompleted == false, "The agreement must not be completed.");
        agreementIsDisputed = true;
        disputeDescription = _disputeDescription;
        emit DisputedAgreement(msg.sender);
    }
    
    function resolveAgreement(uint256 resolvedBuyerPortion, uint256 resolvedSellerPortion) public {
        require(msg.sender == arbitrator, "The current user must be the arbitrator." );
        require(agreementIsDisputed == true, "The agreement must be in dispute." );
        uint256 arbitrationFee = priceValue / 20;
        require(resolvedBuyerPortion + resolvedSellerPortion + arbitrationFee == priceValue);
        address(buyer).transfer(resolvedBuyerPortion);
        address(seller).transfer(resolvedSellerPortion);
        address(arbitrator).transfer(arbitrationFee);
        agreementIsCompleted = true;
        emit ResolvedAgreement(resolvedBuyerPortion, resolvedSellerPortion);
    }
    
    function getAgreementBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract DisputableBuyerSellerAgreementGenerator {
    
    uint8 public DisputableBuyerSellerAgreementVersion = 1;
    
    address payable public arbitrator = 0x130093A5aEbc07e78e16f0EcEF09d1c45AfD8178; // Default Arbitrator
    
    DisputableBuyerSellerAgreement private DBSA;
    
    address[] public agreements;
    
    event AgreementDeployed(
        address indexed DisputableBuyerSellerAgreement, 
        address indexed _buyer, 
        address indexed _seller);
        
    event ArbitratorUpdated(address indexed newArbitrator);
    
    function newDBSA(
        address payable _seller, 
        string memory _agreementTerms) payable public {
        require(arbitrator != address(0), "The arbitrator cannot be the original agreement generator");
           
        DBSA = (new DisputableBuyerSellerAgreement).value(msg.value)(
            msg.sender,
            _seller,
            arbitrator,
            _agreementTerms);
        
        agreements.push(address(DBSA));
        
        emit AgreementDeployed(address(DBSA), msg.sender, _seller);

    }
    
    function getAgreementCount() public view returns (uint256 agreementCount) {
        return agreements.length;
    }
    
    function updateArbitrator(address payable newArbitrator) public {
        require(msg.sender == arbitrator, "The current user must be the current arbitrator.");
        arbitrator = newArbitrator;
        
        emit ArbitratorUpdated(newArbitrator);
    }
}