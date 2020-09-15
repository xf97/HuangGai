pragma solidity ^0.6.4;

import "./interfaces.sol";
import "./owned.sol";
import "./mathlib.sol";


enum reservationstatus {CANCELLED, NOTACTIVATED, ACTIVATED, COMPLETED}


contract ReservationFactory is owned
{
    /*
        This contract will create new Reservation Contract between Guest and Host
    */
    
    address constant private dai_ = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    DaiErc20 private daiToken;

    //Reservation Fee in wad
    uint public reservationfee;
    
    uint constant private secondsin21hrs = 75600;
    
    //Switch that controls whether the factory is active
    bool public factorycontractactive;
    
    
    //Event for new Reservation Contract
    event NewReservationContractEvent(address indexed reservationcontractaddress, address indexed guest, address indexed host, uint rstart, uint rend, uint dprice, uint advpay, bytes8 rstartformat, bytes8 rendformat, uint eventtime);
    

    
    constructor() public 
	{
	    reservationfee = 1000000000000000000; //1 DAI
		factorycontractactive = true;
		daiToken = DaiErc20(dai_);
	}


    function setReservationFee(uint newfee) external onlyManager
    {
        /*
            Changes the Registration fee that is paid to the manager
            If new fee is set, it can never be greater than 10 DAI
        */
        
        require(newfee > 0 && newfee <=10000000000000000000);
        
        reservationfee = newfee;
    }
    

    function setFactoryContractSwitch() external onlyManager
    {
        /*
            Switch that controls whether the contract is active
        */
        
        factorycontractactive = factorycontractactive == true ? false : true;
    }
    
    function createnewReservationContract(address host, uint reservationstart, uint reservationend, uint dailyprice, uint advancepayment, bytes8 rstartformat, bytes8 rendformat) external 
    {
        /*
            Will Create a new reservation contract between guest and host
        */
        
        require(factorycontractactive, "Factory Contract should be Active");
        require(msg.sender != host,"Host and Guest can not be same");
        require(dailyprice > 0, "Daily Price should be > 0");
        require(now < mathlib.add(reservationstart,secondsin21hrs),"Too late to start this reservation");
        
        uint lengthofstay = mathlib.calculatereservationdays(reservationstart,reservationend);
        
        require(lengthofstay > 0,"Length of Stay should be > 0");
        
        uint totalreservationamount = mathlib.mul(dailyprice,lengthofstay);
        
        uint minadvpayment = lengthofstay > 5 ? mathlib.mul(dailyprice,2) : dailyprice;
        
        require(advancepayment >= minadvpayment && advancepayment <= totalreservationamount ,"Advance Payment should be >= minadvpayment and <= reservation amount ");
        
        //Check daitoken allowance for Factory contract
        require(daiToken.allowance(msg.sender,address(this)) >= mathlib.add(advancepayment, reservationfee), "daiToken allowance exceeded");
        
        Reservation ReservationContract = (new Reservation) (msg.sender, host, reservationstart, reservationend, dailyprice, advancepayment, lengthofstay, minadvpayment);
        
        //Transfer the advance payment to reservation contract
        daiToken.transferFrom(msg.sender, address(ReservationContract), advancepayment);
        
        //Transfer the reservation fee to factory manager
        daiToken.transferFrom(msg.sender, manager, reservationfee);

        emit NewReservationContractEvent(address(ReservationContract), msg.sender, host, reservationstart, reservationend, dailyprice, advancepayment, rstartformat, rendformat, now);
        
    }
    
}

contract Reservation
{
    reservationstatus public contractstatus;
    
    uint constant private secondsinday = 86400;
    uint constant private secondsin21hrs = 75600;
    
    //This value will hold the time 21 Hrs after reservation start
    uint immutable private reservationstart21Hrs;

    address constant private dai_ = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    DaiErc20 private daiToken;
    
    address immutable  public factory;
    
    address immutable public guest;
    address immutable public host;
    
    uint immutable public reservationstart;
    uint immutable public reservationend;
    uint immutable public dailyprice;
    uint immutable public lengthofstay;
    
    /*
        The cancellation fee will only be charged if the guest cancels after the valid cancellation period.
    */
    uint immutable public cancellationfee;
    
    uint immutable public advancepayment;
    
    //Reservation Status Change Event
    event ContractStatusEvent(reservationstatus cstatus, uint eventtime);

    constructor(address guestin,address hostin, uint rstart, uint rend, uint dprice, uint advpay, uint lstay, uint minadvpay) public
    {
        daiToken = DaiErc20(dai_);
        
        contractstatus = reservationstatus.NOTACTIVATED;
        
        guest = guestin;
        host = hostin;
        
        factory = msg.sender;
        
        reservationstart = rstart;
        reservationend = rend;
        
        reservationstart21Hrs = mathlib.add(rstart,secondsin21hrs);
        
        dailyprice = dprice;
        advancepayment = advpay;
        
        lengthofstay = lstay;
        
        cancellationfee = minadvpay;
        
    }
    

    modifier onlyGuest()
    {
        require(msg.sender == guest, "Only Guest");
        _;
    }
    
    modifier onlyHost()
    {
        require(msg.sender == host, "Only Host");
        _;
    }
    
    
    function getContractAddress() external view returns (address)
    {
        //This reservation Contract address
        
        return address(this);
    }
    
    function getContractBalance() public view returns(uint)
    {
        //The contract balance in DAI
        
        return daiToken.balanceOf(address(this));
    }
    
    
    function setHostAcceptsReservation() external onlyHost
    {
        /*
            1) Host has to activate the reservation for it to be valid
            2) Host can activate the reservation upto 21 Hrs after reservation start
        */
        
        require(contractstatus == reservationstatus.NOTACTIVATED,"Reservation should be NOTACTIVATED");
        
        require(now < reservationstart21Hrs,"Reservation Can be ACTIVATED upto 21 Hrs after reservation start");
        
        contractstatus = reservationstatus.ACTIVATED;
        emit ContractStatusEvent(contractstatus,now);
    }
    
   function setHostCancelsReservation() external onlyHost
    {
        /*
            1) Allows the host to cancel the reservation anytime if NOTACTIVATED
            2) Allows the host to cancel the reservation upto 21 Hrs after reservation start if ACTIVATED
            3) Guest gets a Full Refund Instantly, since the Host is cancelling
        */
        
        require(contractstatus == reservationstatus.NOTACTIVATED || contractstatus == reservationstatus.ACTIVATED,"Reservation must be ACTIVATED or NOTACTIVATED");
        
        uint fullbalance = getContractBalance();
         
        if (contractstatus == reservationstatus.NOTACTIVATED)
        {
            
             daiToken.transfer(guest,fullbalance);
        }
        else if (contractstatus == reservationstatus.ACTIVATED)
        {
    
            require(now < reservationstart21Hrs,"Reservation Can be CANCELLED upto 21 Hrs after reservation start");
            
            daiToken.transfer(guest, fullbalance);
        }
         
        contractstatus = reservationstatus.CANCELLED;
        emit ContractStatusEvent(contractstatus,now);
    }
    
    function setGuestCancelReservation() external onlyGuest
    {
        /*
            1) Guest can cancel the reservation anytime if NOTACTIVATED
            2) Guest can cancel the reservation upto 21 Hrs after reservation start if ACTIVATED
            3) If length of stay is 5 days or less, cancel upto 3 days before reservation start, otherwise a cancellation fee of dailyprice is applied
            4) If length of stay is greater than 5 days, cancel upto 5 days before reservation start, otherwise a cancellation fee of 2*dailyprice is applied
        */
        
        require(contractstatus == reservationstatus.NOTACTIVATED || contractstatus == reservationstatus.ACTIVATED,"Reservation must be ACTIVATED or NOTACTIVATED");
        
        uint fullbalance = getContractBalance();
        
        if (contractstatus == reservationstatus.NOTACTIVATED)
        {
           
            daiToken.transfer(guest,fullbalance);
        }
        else if (contractstatus == reservationstatus.ACTIVATED)
        {
            
            require(now < reservationstart21Hrs,"Guest can only cancel upto 21 Hrs after reservation start");
            
            uint cancellationperiod = lengthofstay > 5 ? 5 : 3;
            
            if (now < mathlib.sub(reservationstart,mathlib.mul(cancellationperiod,secondsinday)))
            {
                daiToken.transfer(guest,fullbalance);
            }
            else
            {
                
                uint guestdue = mathlib.sub(fullbalance,cancellationfee);
                
                //Host gets compensated for cancellation    
                 daiToken.transfer(host,cancellationfee);
                 
                 //Guest gets refunded the remaining balance
                 if (guestdue > 0)
                 {
                    daiToken.transfer(guest,guestdue);
                 }
            }
        }
        
        contractstatus = reservationstatus.CANCELLED;
        emit ContractStatusEvent(contractstatus,now);
    }
    
   function setHostClaimsRent() external onlyHost
    {
        /*
            Host can claim the rent 21 Hrs after reservation start
        */
        
        require(contractstatus == reservationstatus.ACTIVATED, "Reservation has to be ACTIVATED");
        
        require(now >= reservationstart21Hrs,"Host can only claim the rent 21 Hrs after reservation start");
        
        //Host claims the entire contract balance
         daiToken.transfer(host,getContractBalance());
         
        contractstatus = reservationstatus.COMPLETED;
        emit ContractStatusEvent(contractstatus,now);
    }
    
     function setHostRefundsPartRent(uint refundamount) external onlyHost
    {
        /*
            1) Host can refund the Guest a part of or full contract balance amount 21 Hrs after reservation start
            2) The remaining balance if any will be transferred to the Host. 
        */
        
        require(contractstatus == reservationstatus.ACTIVATED, "Reservation has to be ACTIVATED");
        
        require(now >= reservationstart21Hrs, "Host can refund part of contract balance 21 Hrs after Reservation Start");
        
        uint fullbalance = getContractBalance();
        
        require(refundamount > 0 && refundamount <= fullbalance, "Refund amount should be > 0 && <= contractbalance");
        
        uint hostdue = mathlib.sub(fullbalance,refundamount);
        
        //The refund amount is transferred to the guest
        daiToken.transfer(guest,refundamount);
        
        //The remaining amount is transffered to the Host
        if (hostdue > 0)
        {
            daiToken.transfer(host,hostdue);
        }
        
        contractstatus = reservationstatus.COMPLETED;
        emit ContractStatusEvent(contractstatus,now);
    }

}

















