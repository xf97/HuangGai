pragma solidity ^0.6.4;

import "./interfaces.sol";
import "./owned.sol";
import "./mathlib.sol";

enum savings {NO, DSR, COMPOUND}

enum escrowstatus {CANCELLED, NOTACTIVATED, ACTIVATED, SETTLED}

enum savestatus {NOTJOINED, JOINED, EXITED}

contract EscrowFactory is owned
{
    /*
        This contract will create new Escrow Contract between 2 Parties
    */
    
    address constant private dai_ = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    DaiErc20 private daiToken;

    //Escrow Fee in wad
    uint public escrowfee;
    
    //Switch that controls whether the factory is active
    bool public factorycontractactive;
    
    
    /** Events **/

    //Event for new Escrow Contract
    event NewEscrowEvent(address escrowcontractaddress, address indexed escrowpayer, address indexed escrowpayee, uint eventtime);
    
    //Event Overload
    event NewEscrowEvent(address escrowcontractaddress, address indexed escrowpayer, address indexed escrowpayee, address indexed escrowmoderator, uint eventtime);
    
    constructor() public 
	{
	    escrowfee = 1000000000000000000; //1 DAI
		factorycontractactive = true;
		daiToken = DaiErc20(dai_);
	}


    function setEscrowFee(uint newfee) external onlyManager
    {
        /*
            If in the future new fee is set, it can never be greater than 10 DAI
        */
        
        require(newfee > 0 && newfee <= 10000000000000000000);
        
        escrowfee = newfee;
    }
    

    function setFactoryContractSwitch() external onlyManager
    {
        /*
            Switch that controls whether the contract is active
        */
        
        factorycontractactive = factorycontractactive == true ? false : true;
    }
    
    function createNewEscrow(address escrowpayee, uint escrowamount, uint choice) external 
    {
        
        require(factorycontractactive, "Factory Contract should be Active");
        require(choice>=0 && choice<3,"enum values can be 0,1,2");
        require(msg.sender != escrowpayee,"The Payer & Payee should be different");
        require(escrowamount > 0,"Escrow amount has to be greater than 0");
        
        
        require(daiToken.allowance(msg.sender,address(this)) >= mathlib.add(escrowamount, escrowfee), "daiToken allowance exceeded");
        
        Escrow EscrowContract = (new Escrow) (msg.sender, escrowpayee, escrowamount, choice);
        
        //The Esrow Amount get transferred to the new escrow contract
        daiToken.transferFrom(msg.sender, address(EscrowContract), escrowamount);
        
        //Transfer the escrow fee to factory manager
        daiToken.transferFrom(msg.sender, manager, escrowfee);
        
        if (choice == uint(savings.DSR))
            {
                EscrowContract.joinDSR();
            }
        else if (choice == uint(savings.COMPOUND))
            {
                EscrowContract.joincDai();
            }
        
        
        emit NewEscrowEvent(address(EscrowContract), msg.sender , escrowpayee , now);
        
    }
    
    //Function Overload with Moderator
    function createNewEscrow(address escrowpayee, uint escrowamount, address escrowmoderator, uint escrowmoderatorfee, uint choice) external 
    {
        
        require(factorycontractactive, "Factory Contract should be Active");
        require(choice>=0 && choice<3,"enum values can be 0,1,2");
        require(msg.sender != escrowpayee && msg.sender != escrowmoderator && escrowpayee != escrowmoderator,"The Payer, payee & moderator should be different");
        require(escrowamount > 0,"Escrow amount has to be greater than 0");
    
        uint dailockedinnewescrow = mathlib.add(escrowamount,escrowmoderatorfee);
  
        require(daiToken.allowance(msg.sender,address(this)) >= mathlib.add(dailockedinnewescrow, escrowfee), "daiToken allowance exceeded");
        
        EscrowWithModerator EscrowContract = (new EscrowWithModerator) (msg.sender, escrowpayee, escrowamount, choice, escrowmoderator, escrowmoderatorfee);
        
        //The Esrow Amount and Moderator fee gets transferred to the new escrow contract
        daiToken.transferFrom(msg.sender, address(EscrowContract), dailockedinnewescrow);
        
        //Transfer the escrow fee to factory manager
        daiToken.transferFrom(msg.sender, manager, escrowfee);
        
        if (choice == uint(savings.DSR))
            {
                EscrowContract.joinDSR();
            }
        else if (choice == uint(savings.COMPOUND))
            {
                EscrowContract.joincDai();
            }
        
        emit NewEscrowEvent(address(EscrowContract), msg.sender , escrowpayee, escrowmoderator, now);
        
    }
    
}

contract Escrow
{
    savings public savingschoice;
    
    savestatus internal savingsstatus;
    
    escrowstatus public contractstatus;
    
    
    //Contract addresses
    address constant internal join_ = 0x9759A6Ac90977b93B58547b4A71c78317f391A28;
    address constant internal vat_ = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address constant internal pot_ = 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7;
    
    address constant internal dai_ = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    
    address constant internal cDai_ = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;
    
    address immutable internal fact_;
    
    // Contract interfaces
    PotLike  internal pot;
    JoinLike internal daiJoin;
    VatLike  internal vat;
    
    DaiErc20  internal daiToken;
    
    cDaiErc20 internal cDaiToken;
    
    uint constant internal RAY = 10 ** 27;
    
    address immutable public escrowpayer;
    address immutable public escrowpayee;
    
    bool public moderatoravailable;
    
    uint immutable public escrowamount;
    uint public escrowsettlementamount;
    
    
    //Escrow Status Change Event
    event ContractStatusEvent(escrowstatus cstatus, uint eventtime);

    constructor(address epayer,address epayee, uint eamount, uint choice) public
    {
        require(choice>=0 && choice<3,"enum values can be 0,1,2");
        
        contractstatus = escrowstatus.NOTACTIVATED;
        savingsstatus = savestatus.NOTJOINED;
        
        escrowpayer = epayer;
        escrowpayee = epayee;
        
        moderatoravailable = false;
        
        fact_ = msg.sender;
        
        daiToken = DaiErc20(dai_);
        
        
        if (choice == uint(savings.NO))
        {
            savingschoice = savings.NO;   
        }
        else if (choice == uint(savings.DSR))
        {
            savingschoice = savings.DSR;
            
            daiJoin = JoinLike(join_);
            vat = VatLike(vat_);
            pot = PotLike(pot_);
            
            vat.hope(join_);
            vat.hope(pot_);
            
            /*
                Approval for DSR. Infinite approval is not a problem in this case since this escow contract
                will only be used once
            */
            
            daiToken.approve(join_, uint(-1));
        }
        else if(choice == uint(savings.COMPOUND))
        {
            savingschoice = savings.COMPOUND;
            cDaiToken = cDaiErc20(cDai_);
            
            /*
                Approval for cDai Compound. Infinite approval is not a problem in this case since this escow contract
                will only be used once
            */
            
            daiToken.approve(cDai_, uint(-1));
        }
        
        escrowamount = eamount;
        escrowsettlementamount = eamount; //Both are same when contract is created
        
    }
    

    modifier onlyFactory()
    {
        require(msg.sender == fact_, "Only Factory");
        _;
    }
    
    modifier onlyPayer()
    {
        require(msg.sender == escrowpayer, "Only Payer");
        _;
    }
    
    modifier onlyPayee()
    {
        require(msg.sender == escrowpayee, "Only Payee");
        _;
    }
    
    function joinDSR() public onlyFactory
    {
        /*
            Deposit the contract amount in DSR    
        */
        
        require(savingsstatus == savestatus.NOTJOINED,"Already Joined");
        require(savingschoice == savings.DSR,"Savngs Choice is not DSR");
        uint joinbal = getContractBalance();
        uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
        daiJoin.join(address(this),joinbal);
        pot.join(mathlib.mul(joinbal, RAY) / chi);
        savingsstatus = savestatus.JOINED;
    }


    function exitAllDSR() internal
    {
        /*
            Exit the DSR. The amount locked in DSR is transferred back to the Escrow Contract
        */
        
        require(savingsstatus == savestatus.JOINED, "DSR not Joined or already exited");
        require(savingschoice == savings.DSR,"Savings Choice != savings.DSR");
        if (now > pot.rho()) pot.drip();
        pot.exit(pot.pie(address(this)));
        daiJoin.exit(address(this), daiJoin.vat().dai(address(this)) / RAY);
        savingsstatus = savestatus.EXITED;
    }
    
     function getBalanceDSR() public view returns (uint) 
    {
        
        /*
            Returns balance in Dai with DSR interest.
            The value of chi is updated everytime someone on the
            network calls the drip function.
            Drip should be called after joining the pot, to calculate new balance.
        */
    
        require(savingschoice == savings.DSR,"savingschoice != DSR");
        
        uint pie = pot.pie(address(this));
        uint chi = pot.chi();
        return mathlib.mul(pie,chi) / RAY;
    }
    
    function joincDai() public onlyFactory 
    {
        /*
            Deposit the contract amount in Compound Protocol.
            The contract will get the cDai Token.
        */
        
        require(savingsstatus == savestatus.NOTJOINED,"Already Joined");
        require(savingschoice == savings.COMPOUND ,"savingschoice != COMPOUND");
        uint joinbal = getContractBalance();
        uint mintResult = cDaiToken.mint(joinbal);
        require(mintResult == 0, "Error creating cDai");
        savingsstatus = savestatus.JOINED;
    }
    
    function exitallcDai() internal
    {
        /*
            Exit the Compound Protocol.
        */
        
        require(savingsstatus == savestatus.JOINED, "COMPOUND not Joined or already exited");
        require(savingschoice == savings.COMPOUND ,"savingschoice != COMPOUND");
        uint cdaibal = getBalancecDai();
        uint redeemResult = cDaiToken.redeem(cdaibal);
        require(redeemResult == 0, "Error Redeeming cDai to Dai");
        savingsstatus = savestatus.EXITED;
    }
    
    function getBalancecDai() public view returns(uint)
    {
        //Returns cDai token Balance for this escrow contract
        
        require(savingschoice == savings.COMPOUND,"savingschoice != COMPOUND");
        
        return cDaiToken.balanceOf(address(this));
    }
    
  
    function exitsavingsifJoined() internal returns(bool)
    {
        /*
            If contract amount is locked in DSR or Compound. This will exit from either
            and return the DAI back to the Escrow contract.
        */
        
            if (savingschoice == savings.NO)
            {
                    return true;
            }
            else if (savingschoice == savings.DSR)
            {
                     exitAllDSR();
                     return savingsstatus == savestatus.EXITED ? true : false;
            }
            else if (savingschoice == savings.COMPOUND)
            {
                    exitallcDai();
                    return savingsstatus == savestatus.EXITED ? true : false;
                    
            }
    }
    

    function getContractAddress() external view returns (address)
    {
        return address(this);
    }
    
    function getContractBalance() public view returns(uint)
    {
        //Gets contract balance in DAI
        
        return daiToken.balanceOf(address(this));
    }
    
    
    function setPayeeActivatedEscrow() external onlyPayee
    {
        /*
            The Payee has to activate the Escrow contract for it to be valid.
        */
        
        require(contractstatus == escrowstatus.NOTACTIVATED,"Escrow should be NOT Activated");
        
        contractstatus = escrowstatus.ACTIVATED;
        emit ContractStatusEvent(contractstatus,now);
    }
    

    function setCancelEscrow() external onlyPayer
    {
        /*
            Allows the escrow payer to cancel the escrow if the
            Escrow Payee has not activated it.
        */
        
        require(contractstatus == escrowstatus.NOTACTIVATED,"Escrow Should be Not Activated");
        
        require(exitsavingsifJoined() == true , "Savings not exited");
        
        uint fullbalance = getContractBalance();
        
        require(fullbalance > 0 ,"fullbalance should be > 0");
        
        daiToken.transfer(escrowpayer,fullbalance);
        
        contractstatus = escrowstatus.CANCELLED;
        emit ContractStatusEvent(contractstatus,now);
        
    }
    
    function setEscrowSettlementAmount(uint esettlementamount) virtual external onlyPayee
    {
        /*
         Very Important: Only the escrow Payee can change this amount to less than the agreed escrowamount
        */
        
        require(contractstatus == escrowstatus.ACTIVATED,"Escrow should be Activated");
        require(esettlementamount > 0 && esettlementamount < escrowamount, "New settlement Amount not correct");
        escrowsettlementamount = esettlementamount;
        
    }
    
    function withdrawFundsFromSavings() virtual external onlyPayer
    {
        /*
            This function will withdraw all funds from either DSR or COMPOUND
            back into the Escrow Contract.
        */
        
        require(contractstatus == escrowstatus.ACTIVATED || contractstatus == escrowstatus.NOTACTIVATED, "Escrow Cancelled or Settled");
        require(exitsavingsifJoined() == true , "Savings not exited");
        savingschoice = savings.NO;
    }
    
    function releaseFundsToPayee() virtual external onlyPayer
    {
        /*
            1) The payee gets paid
            2) Any remaining amount including interest is transferred to the Payer
        */
        
        require(contractstatus == escrowstatus.ACTIVATED, "Escrow Should be activated, but not settled");
        
        require(exitsavingsifJoined() == true , "Savings not exited");
        
        uint fullbalance = getContractBalance();
        
        //The contract balance has to be >= escrowsettlementamount
        require(fullbalance >= escrowsettlementamount);
        
        uint payeramt =  mathlib.sub(fullbalance,escrowsettlementamount);
        
        //Payee gets paid
        daiToken.transfer(escrowpayee,escrowsettlementamount);
         
        //Payer gets paid any remaining balance including interest 
        if (payeramt > 0)
        {
            daiToken.transfer(escrowpayer,payeramt);
        }
  
        contractstatus = escrowstatus.SETTLED;
        emit ContractStatusEvent(contractstatus,now);
        
    }
    
    function refundFullFundsToPayer() virtual external onlyPayee
    {
        /*
         1) The Payee refunds the entire amount to the payer.
        */
        
        require(contractstatus == escrowstatus.ACTIVATED, "Escrow Should be activated, but not settled");
        
        require(exitsavingsifJoined() == true , "Savings not exited");
        
        uint fullbalance = getContractBalance();
        
        require(fullbalance > 0 ,"fullbalance <= 0");
        
        //Payer gets refunded the full balance
        daiToken.transfer(escrowpayer,fullbalance);
         
        contractstatus = escrowstatus.SETTLED; 
        emit ContractStatusEvent(contractstatus,now);
        
    }
    
}

contract EscrowWithModerator is Escrow
{
    
    address immutable public escrowmoderator;
    uint immutable public escrowmoderatorfee;
    
    constructor(address epayer,address epayee, uint eamount, uint choice, address emoderator, uint emoderatorfee) Escrow(epayer, epayee, eamount, choice) public
    {

        moderatoravailable = true;
    
        escrowmoderator = emoderator;
        escrowmoderatorfee = emoderatorfee;
        
        
    }
    
    modifier onlyPayerOrModerator()
    {
        require(msg.sender == escrowpayer || msg.sender == escrowmoderator, "Only Payer or Moderator");
        _;
    }
    
    modifier onlyPayeeOrModerator()
    {
        require(msg.sender == escrowpayee || msg.sender == escrowmoderator, "Only Payee or Moderator");
        _;
    }
    

    function setEscrowSettlementAmount(uint esettlementamount) override external onlyPayeeOrModerator
    {
        /*
         Very Important: Only the escrow Payee or Moderator can change this amount to less than the agreed escrowamount
        */
        
        require(contractstatus == escrowstatus.ACTIVATED,"Escrow should be Activated");
        require(esettlementamount > 0 && esettlementamount < escrowamount ,"escrow settlementamount is incorrect");
        escrowsettlementamount = esettlementamount;
    }
    
    function withdrawFundsFromSavings() override external onlyPayerOrModerator
    {
        /*
            This function will withdraw all funds from either DSR or COMPOUND
            back into the Escrow Contract
        */
       
        require(contractstatus == escrowstatus.ACTIVATED || contractstatus == escrowstatus.NOTACTIVATED, "Escrow Cancelled or Settled");
        require(exitsavingsifJoined() == true , "Savings not exited");
        savingschoice = savings.NO;
    }
    
    function releaseFundsToPayee() override external onlyPayerOrModerator
    {
        /*
            1) The payee gets paid
            2) The moderator gets paid the moderation fee if exists
            3) Any remaining amount including interest is transferred to the Payer
        */
        
        require(contractstatus == escrowstatus.ACTIVATED, "Escrow Should be activated, but not settled");
        
        require(exitsavingsifJoined() == true , "Savings not exited");
        
        uint fullbalance = getContractBalance();
        
        uint minamtrequired = mathlib.add(escrowsettlementamount,escrowmoderatorfee);
        
        //The contract balance has to be >= escrowsettlementamount and moderatorfee
        require(fullbalance >= minamtrequired);
        
        uint payeramt = mathlib.sub(fullbalance,minamtrequired);
        
        //Payee gets paid
        daiToken.transfer(escrowpayee,escrowsettlementamount);
        
        //Moderator gets paid
        if (escrowmoderatorfee > 0)
        {
            daiToken.transfer(escrowmoderator,escrowmoderatorfee);
        }
        
        //Payer gets paid any remaining balance including interest 
        if (payeramt > 0)
        {
            daiToken.transfer(escrowpayer,payeramt);
        }
        
        contractstatus = escrowstatus.SETTLED;
        emit ContractStatusEvent(contractstatus,now);
    
    }
    
    function refundFullFundsToPayer() override external onlyPayeeOrModerator
    {
        /*
             1) The payer gets refunded the full amount
             2) The moderator gets paid the moderation fee if exists before the payer gets refunded the full amount.
        */
        
        require(contractstatus == escrowstatus.ACTIVATED, "Escrow Should be activated, but not settled");
        
        require(exitsavingsifJoined() == true , "Savings not exited");
        
        uint fullbalance = getContractBalance();
        
        require(fullbalance > 0 , "fullbalance < 0");
        
        if (escrowmoderatorfee > 0)
        {
            if (fullbalance > escrowmoderatorfee)
            {
                uint payeramt = mathlib.sub(fullbalance,escrowmoderatorfee);
                daiToken.transfer(escrowmoderator,escrowmoderatorfee);
                daiToken.transfer(escrowpayer,payeramt);
            }
            else
            {
                daiToken.transfer(escrowmoderator,fullbalance);
            }
        }
        else
        {
             daiToken.transfer(escrowpayer,fullbalance);
        }
        
        contractstatus = escrowstatus.SETTLED;
        emit ContractStatusEvent(contractstatus,now);

    }
    
}
















