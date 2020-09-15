/**
 *Submitted for verification at Etherscan.io on 2020-06-10
*/

pragma solidity ^0.4.26;

// This is the smart contract for FiatDex protocol version 2
// Anyone can use this smart contract to exchange Fiat for DAI or vice-versa without trusting the counterparty
// The goal of the FiatDex protocol is to remove the dependence on fiat to crypto gatekeepers for those who want to trade cryptocurrency
// There are no arbitrators or third party custodians. Collateral is used as leverage on the traders.

//Abstract ERC20 contract
contract ERC20 {
  uint public totalSupply;

  event Transfer(address indexed from, address indexed to, uint value);  
  event Approval(address indexed owner, address indexed spender, uint value);

  function balanceOf(address who) public constant returns (uint);
  function allowance(address owner, address spender) public constant returns (uint);

  function transfer(address to, uint value) public returns (bool ok);
  function transferFrom(address from, address to, uint value) public returns (bool ok);
  function approve(address spender, uint value) public returns (bool ok);  
}

contract FiatDex_protocol_v2 {

  address public owner; // This is the address of the current owner of the contract, this address collects fees, nothing more, nothing less
  address public daiAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // This is the addresss for the MakerDAO contract
  uint256 public version = 2; // This is the version of the protocol running

  constructor() public {
    owner = msg.sender; // Set the contract creator to the first owner
  }

  enum States {
    NOTOPEN, // Default state
    INITIALIZED, // daiTrader has put DAI into the contract
    REFUNDED, // daiTrader has refunded before fiatTrader has put any amount into the swap
    ACTIVE, // fiatTrader has put DAI collateral into the contract
    CLOSED, // daiTrader has finalized the amounts, dai is transferred, collateral returned
    FIATABORT, // fiatTrader has aborted the swap
    DAIABORT // daiTrader has aborted the swap
  }

  struct Swap {
    States swapState;
    uint256 sendAmount;
    address fiatTrader;
    address daiTrader;
    uint256 openTime;
    uint256 daiTraderCollateral;
    uint256 fiatTraderCollateral;
    uint256 feeAmount;
  }

  mapping (bytes32 => Swap) private swaps; // Create the swaps map

  event Open(bytes32 _tradeID, address _fiatTrader, uint256 _sendAmount); // Auxillary events
  event Close(bytes32 _tradeID, uint256 _fee);
  event Canceled(bytes32 _tradeID, uint256 _fee);
  event ChangedOwnership(address _newOwner);

  // daiTrader can only open swap positions from tradeIDs that haven't already been used
  modifier onlyNotOpenSwaps(bytes32 _tradeID) {
    require (swaps[_tradeID].swapState == States.NOTOPEN);
    _;
  }

  // fiatTrader can only add collateral to swap positions that have just been opened
  modifier onlyInitializedSwaps(bytes32 _tradeID) {
    require (swaps[_tradeID].swapState == States.INITIALIZED);
    _;
  }

  // daiTrader is trying to finalize/abort the swap position or fiatTrader is trying to abort, check this first
  modifier onlyActiveSwaps(bytes32 _tradeID) {
    require (swaps[_tradeID].swapState == States.ACTIVE);
    _;
  }

  // View functions
  function viewSwap(bytes32 _tradeID) public view returns (
    States swapState, 
    uint256 sendAmount,
    address daiTrader, 
    address fiatTrader, 
    uint256 openTime, 
    uint256 daiTraderCollateral, 
    uint256 fiatTraderCollateral,
    uint256 feeAmount
  ) {
    Swap memory swap = swaps[_tradeID];
    return (swap.swapState, swap.sendAmount, swap.daiTrader, swap.fiatTrader, swap.openTime, swap.daiTraderCollateral, swap.fiatTraderCollateral, swap.feeAmount);
  }

  function viewFiatDexSpecs() public view returns (
    uint256 _version, 
    address _owner
  ) {
    return (version, owner);
  }

  // Action functions
  function changeContractOwner(address _newOwner) public {
    require (msg.sender == owner); // Only the current owner can change the ownership of the contract
    
    owner = _newOwner; // Update the owner

     // Trigger ownership change event.
    emit ChangedOwnership(_newOwner);
  }

  // daiTrader opens the swap position
  function openSwap(bytes32 _tradeID, address _fiatTrader, uint256 _erc20Value) public onlyNotOpenSwaps(_tradeID) {
    ERC20 daiContract = ERC20(daiAddress); // Load the DAI contract
    require (_erc20Value > 0); // Cannot open a swap position with a zero amount of DAI
    require(_erc20Value <= daiContract.allowance(msg.sender, address(this))); // We must transfer less than that we approve in the ERC20 token contract

    // Calculate some values
    uint256 _sendAmount = (_erc20Value * 2) / 5; // Essentially the same as dividing by 2.5 (or multiplying by 2/5)
    require (_sendAmount > 0); // Fail if the amount is so small that the sendAmount will be non-existant
    uint256 _daiTraderCollateral = _erc20Value - _sendAmount; // Collateral will be whatever is not being sent to fiatTrader

    // Store the details of the swap.
    Swap memory swap = Swap({
      swapState: States.INITIALIZED,
      sendAmount: _sendAmount,
      daiTrader: msg.sender,
      fiatTrader: _fiatTrader,
      openTime: now,
      daiTraderCollateral: _daiTraderCollateral,
      fiatTraderCollateral: 0,
      feeAmount: 0
    });
    swaps[_tradeID] = swap;

    // Now transfer the tokens
    require(daiContract.transferFrom(msg.sender, address(this), _erc20Value)); // Now take the tokens from the sending user and store in this contract

    // Trigger open event.
    emit Open(_tradeID, _fiatTrader, _sendAmount);
  }

  // fiatTrader adds collateral to the open swap
  function addFiatTraderCollateral(bytes32 _tradeID, uint256 _erc20Value) public onlyInitializedSwaps(_tradeID) {
    Swap storage swap = swaps[_tradeID]; // Get information about the swap position
    require (_erc20Value >= swap.daiTraderCollateral); // Cannot send less than what the daiTrader has in collateral
    require (msg.sender == swap.fiatTrader); // Only the fiatTrader can add to the swap position
    // Check the allowance
    ERC20 daiContract = ERC20(daiAddress); // Load the DAI contract
    require(_erc20Value <= daiContract.allowance(msg.sender, address(this))); // We must transfer less than that we approve in the ERC20 token contract   
    swap.fiatTraderCollateral = _erc20Value;
    swap.swapState = States.ACTIVE; // Now fiatTrader needs to send fiat

    // Now transfer the tokens
    require(daiContract.transferFrom(msg.sender, address(this), _erc20Value)); // Now take the tokens from the sending user and store in this contract    
  }

  // daiTrader is refunding as fiatTrader never sent the collateral
  function refundSwap(bytes32 _tradeID) public onlyInitializedSwaps(_tradeID) {
    // Refund the swap.
    Swap storage swap = swaps[_tradeID];
    require (msg.sender == swap.daiTrader); // Only the daiTrader can call this function to refund
    swap.swapState = States.REFUNDED; // Swap is now refunded, sending all DAI back

    // Transfer the DAI value from this contract back to the DAI trader.
    ERC20 daiContract = ERC20(daiAddress); // Load the DAI contract
    require(daiContract.transfer(swap.daiTrader, swap.sendAmount + swap.daiTraderCollateral));

     // Trigger cancel event.
    emit Canceled(_tradeID, 0);
  }

  // daiTrader is aborting as fiatTrader failed to hold up its part of the swap
  // Aborting refunds the sendAmount to daiTrader but returns part of the collateral based on the penalty
  // Penalty must be between 75-100%
  function diaTraderAbort(bytes32 _tradeID, uint256 penaltyPercent) public onlyActiveSwaps(_tradeID) {
    // diaTrader aborted the swap.
    require (penaltyPercent >= 75000 && penaltyPercent <= 100000); // Penalty must be between 75-100%

    Swap storage swap = swaps[_tradeID];
    require (msg.sender == swap.daiTrader); // Only the daiTrader can call this function to abort
    swap.swapState = States.DAIABORT; // Swap is now aborted

    // Calculate the penalty amounts
    uint256 penaltyAmount = (swap.daiTraderCollateral * penaltyPercent) / 100000;
    ERC20 daiContract = ERC20(daiAddress); // Load the DAI contract
    if(penaltyAmount > 0){
      swap.feeAmount = penaltyAmount;
      require(daiContract.transfer(owner, penaltyAmount * 2));
    }   

    // Transfer the DAI send amount and collateral from this contract back to the DAI trader.
    require(daiContract.transfer(swap.daiTrader, swap.sendAmount + swap.daiTraderCollateral - penaltyAmount));
  
    // Transfer the DAI collateral from this contract back to the fiat trader.
    require(daiContract.transfer(swap.fiatTrader, swap.fiatTraderCollateral - penaltyAmount));

     // Trigger cancel event.
    emit Canceled(_tradeID, penaltyAmount);
  }

  // fiatTrader is aborting due to unexpected difficulties sending fiat
  // Aborting refunds the sendAmount to daiTrader but returns part of the collateral based on the penalty
  // Penalty must be between 2.5-100%
  function fiatTraderAbort(bytes32 _tradeID, uint256 penaltyPercent) public onlyActiveSwaps(_tradeID) {
    // fiatTrader aborted the swap.
    require (penaltyPercent >= 2500 && penaltyPercent <= 100000); // Penalty must be between 2.5-100%

    Swap storage swap = swaps[_tradeID];
    require (msg.sender == swap.fiatTrader); // Only the fiatTrader can call this function to abort
    swap.swapState = States.FIATABORT; // Swap is now aborted

    // Calculate the penalty amounts
    uint256 penaltyAmount = (swap.daiTraderCollateral * penaltyPercent) / 100000;
    ERC20 daiContract = ERC20(daiAddress); // Load the DAI contract
    if(penaltyAmount > 0){
      swap.feeAmount = penaltyAmount;
      require(daiContract.transfer(owner, penaltyAmount * 2));
    }   

    // Transfer the DAI send amount and collateral from this contract back to the DAI trader.
    require(daiContract.transfer(swap.daiTrader, swap.sendAmount + swap.daiTraderCollateral - penaltyAmount));
  
    // Transfer the DAI collateral from this contract back to the fiat trader.
    require(daiContract.transfer(swap.fiatTrader, swap.fiatTraderCollateral - penaltyAmount));

     // Trigger cancel event.
    emit Canceled(_tradeID, penaltyAmount);
  }

  // daiTrader is completing the swap position as fiatTrader has sent the fiat
  function finalizeSwap(bytes32 _tradeID) public onlyActiveSwaps(_tradeID) {
    // Complete the swap and charge the 1% fee on the sent amount
    Swap storage swap = swaps[_tradeID];
    require (msg.sender == swap.daiTrader); // Only the daiTrader can call this function to close
    swap.swapState = States.CLOSED; // Swap is now closed, sending all ETH, prevent re-entry

    // Calculate the fee which should be 1%
    uint256 feeAmount = 0; // This is the amount of fee in DAI
    uint256 feePercent = 1000; // For feePercent, 1 = 0.001%, 1000 = 1%
    feeAmount = (swap.sendAmount * feePercent) / 100000;

    // Transfer all the DAI to the appropriate parties, the owner will get some DAI as a fee
    ERC20 daiContract = ERC20(daiAddress); // Load the DAI contract
    if(feeAmount > 0){
      swap.feeAmount = feeAmount;
      require(daiContract.transfer(owner, swap.feeAmount));
    }

    // Transfer the DAI collateral from this contract back to the DAI trader.
    require(daiContract.transfer(swap.daiTrader, swap.daiTraderCollateral));

    // Transfer the DAI collateral back to fiatTrader and the sendAmount from daiTrader minus fee
    require(daiContract.transfer(swap.fiatTrader, swap.sendAmount - feeAmount + swap.fiatTraderCollateral));

     // Trigger close event showing the fee.
    emit Close(_tradeID, feeAmount);
  }
}