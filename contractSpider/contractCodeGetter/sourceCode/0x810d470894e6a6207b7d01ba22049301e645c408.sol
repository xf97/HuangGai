/**
 *Submitted for verification at Etherscan.io on 2020-05-29
*/

/**
 * Created on 2020-05-11
 * @summary: SE Auction Master Contract
 * @author: Fazri Zubair & Farhan Khwaja
 */

pragma solidity ^0.6.0;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (_a == 0) {
      return 0;
    }

    uint256 c = _a * _b;
    require (c / _a == _b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
    require (_b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = _a / _b;
    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    require (_b <= _a);
    uint256 c = _a - _b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
    uint256 c = _a + _b;
    require (c >= _a);

    return c;
  }
}

/**
 * Utility library of inline functions on addresses
 */
library AddressUtils {

  /**
  * Returns whether the target address is a contract
  * @dev This function will return false if invoked during the constructor of a contract,
  *  as the code is not actually created until after the constructor finishes.
  * @param addr address to check
  * @return whether the target address is a contract
  */
  function isContract(address addr) internal view returns (bool) {
    uint256 size;
    // XXX Currently there is no better way to check if there is a contract in an address
    // than to check the size of the code at that address.
    // See https://ethereum.stackexchange.com/a/14016/36603
    // for more details about how this works.
    // TODO Check this again before the Serenity release, because all addresses will be
    // contracts then.
    // solium-disable-next-line security/no-inline-assembly
    assembly {
      size := extcodesize(addr) 
    }
    return size > 0;
  }
}

interface ERC721TokenReceiver {
    /// @notice Handle the receipt of an NFT
    /// @dev The ERC721 smart contract calls this function on the
    /// recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
    /// of other than the magic value MUST result in the transaction being reverted.
    /// @notice The contract address is always the message sender.
    /// @param _operator The address which called `safeTransferFrom` function
    /// @param _from The address which previously owned the token
    /// @param _tokenId The NFT identifier which is being transferred
    /// @param _data Additional data with no specified format
    /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    /// unless throwing
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes32 _data) external returns(bytes4);
}

/* basic Interface to access any ERC721 standard functions
 * @title ERC721Token
 */
interface ERC721Token {
    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    
    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address);
    
    function approve(address _to, uint256 _tokenId) external;
    function transfer(address _to, uint256 _tokenId) external;
    function implementsERC721() external pure returns (bool);
}

/** Controls state and access rights for contract functions
 * @title Operational Control
 * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
 * Inspired and adapted from contract created by OpenZeppelin 
 * Ref: https://github.com/OpenZeppelin/zeppelin-solidity/
 */
contract OperationalControl {
  /// Facilitates access & control for the game.
  /// Roles:
  ///  -The Managers (Primary/Secondary): Has universal control of all elements (No ability to withdraw)
  ///  -The Banker: The Bank can withdraw funds and adjust fees / prices.
  ///  -otherManagers: Contracts that need access to functions for gameplay

  /// @dev Emited when contract is upgraded
  event ContractUpgrade(address newContract);

  /// @dev The addresses of the accounts (or contracts) that can execute actions within each roles.
  address public managerPrimary;
  address public managerSecondary;
  address payable public bankManager;

  // Contracts that require access for gameplay
  mapping(address => uint8) public otherManagers;

  // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
  bool public paused = false;

  // @dev Keeps track whether the contract erroredOut. When that is true, most actions are blocked & 
  // refund can be claimed
  bool public error = false;

  /**
  * @dev Operation modifiers for limiting access only to Managers
  */
  modifier onlyManager() {
    require (msg.sender == managerPrimary || msg.sender == managerSecondary || otherManagers[msg.sender] == 1);
    _;
  }

  /**
  * @dev Operation modifiers for limiting access only to Bank Manager
  */
  modifier onlyBanker() {
    require (msg.sender == bankManager);
    _;
  }

  /**
  * @dev Operation modifiers for any Operators
  */
  modifier anyOperator() {
    require (
        msg.sender == managerPrimary ||
        msg.sender == managerSecondary ||
        msg.sender == bankManager ||
        otherManagers[msg.sender] == 1
    );
    _;
  }

  /**
  * @dev Assigns a new address to act as the Primary Manager.
  * @param _newGM    New primary manager address
  */
  function setPrimaryManager(address _newGM) external onlyManager {
    require (_newGM != address(0));

    managerPrimary = _newGM;
  }

  /**
  * @dev Assigns a new address to act as the Secondary Manager.
  * @param _newGM    New Secondary Manager Address
  */
  function setSecondaryManager(address _newGM) external onlyManager {
    require (_newGM != address(0));

    managerSecondary = _newGM;
  }

  /**
    * @dev Assigns a new address to act as the Bank Manager.
    * @param _newBM    New Bank Manager Address
    */
  function setBankManager(address payable _newBM) external onlyManager {
    require (_newBM != address(0));

    bankManager = _newBM;
  }

  /// @dev Assigns a new address to act as the Other Manager. (State = 1 is active, 0 is disabled)
  function setOtherManager(address _newOp, uint8 _state) external onlyManager {
    require (_newOp != address(0));

    otherManagers[_newOp] = _state;
  }

  /// @dev Batch function assigns a new address to act as the Other Manager. (State = 1 is active, 0 is disabled)
  function batchSetOtherManager(address[] calldata _newOp, uint8[] calldata _state) external onlyManager {
	  for (uint ii = 0; ii < _newOp.length; ii++){
		require (_newOp[ii] != address(0));

    	otherManagers[_newOp[ii]] = _state[ii];
	  }
  }

  /*** Pausable functionality adapted from OpenZeppelin ***/

  /// @dev Modifier to allow actions only when the contract IS NOT paused
  modifier whenNotPaused() {
    require (!paused);
    _;
  }

  /// @dev Modifier to allow actions only when the contract IS paused
  modifier whenPaused {
    require (paused);
    _;
  }

  /// @dev Modifier to allow actions only when the contract has Error
  modifier whenError {
    require (error);
    _;
  }

  /**
    * @dev Called by any Operator role to pause the contract.
    * Used only if a bug or exploit is discovered (Here to limit losses / damage)
    */
  function pause() external onlyManager whenNotPaused {
    paused = true;
  }

  /**
  * @dev Unpauses the smart contract. Can only be called by the Game Master
  */
  function unpause() public onlyManager whenPaused {
    // can't unpause if contract was upgraded
    paused = false;
  }

  /**
  * @dev Errors out the contract thus mkaing the contract non-functionable
  */
  function hasError() public onlyManager whenPaused {
    error = true;
  }

  /**
  * @dev Removes the Error Hold from the contract and resumes it for working
  */
  function noError() public onlyManager whenPaused whenError {
    error = false;
  }
}

/**
 * @title      SEAuction
 * @dev        Scarcity Engine Auction Contract
 * @notice     This helps in creating auctions for items for Scarcity Engine
 */
contract SEAuction is OperationalControl {
  using SafeMath for uint256;
  using AddressUtils for address;

  /*** EVENTS ***/
  
  /// @dev Event Fired a user bids for an item
  event SEBidPlaced(address userWallet, uint256 ethBid);

  /// @dev This event is fired when an ETH winner is decalred 
  event SEAuctionETHWinner(address userAddress, uint256 buyingPrice, uint256 assetId);

  /// @dev This event is fired when a GFC winner is decalred. userAddressc can ScarcityEngine address
  /// thus bytes32. can be transformed to string
  event SEAuctionGFCWinner(bytes32 userAddress, uint256 buyingPrice, uint256 assetId);

  /// @dev This event is fired when we do a refund when a buy request can't be fulfilled
  event SEAuctionRefund(address to, uint256 ethValue);

  mapping(address => uint256) public userETHBalance;
  address[] private allBidders;
  
  // AuctionId associated with SEAuctionMaster
  uint256 public auctionId;
  // Current winner of Auction
  address public winner;
  // Winner Price
  uint256 public winningBid;
  // NFT Contract Address
  address public nftAddress;
  // Price (in wei) at beginning of sale
  uint256 public startingPrice;
  // Duration (in seconds) of sale
  uint256 public duration;
  // Time when sale started
  // NOTE: 0 if this sale has been concluded
  uint256 public startedAt;
  // ERC721 AssetID
  uint256 public assetId;
  // DApp Name
  bytes32 public dAppName;
  // Bool for transfer tokenId
  bool public transferToken;

  uint256 private maxBid;

  /**
  * @dev Constructor function
  */
  constructor (uint256 _auctionId, address payable _owner, uint256 _startingPrice, uint256 _startedAt, 
    uint256 _duration, uint256 _assetId, bytes32 _dAppName, address _nftAddress) public {
    require (_owner != address(0));
    paused = true;
    error = false;
    managerPrimary = _owner;
    managerSecondary = _owner;
    bankManager = _owner;
    otherManagers[_owner] = 1;
    
    auctionId = _auctionId;
    startingPrice = _startingPrice;
    maxBid = _startingPrice;
    duration = _duration;
    assetId = _assetId;
    dAppName = _dAppName;
    startedAt = _startedAt;
    nftAddress = _nftAddress;
    transferToken = false;
  }
  
  function isAuctionActive() external view returns(bool){
      return (now <= (startedAt.add(duration)) && winner == address(0));
  }

    // This function is called for all messages sent to
    // this contract, except plain Ether transfers
    // (there is no other function except the receive function).
    // Any call with non-empty calldata to this contract will execute
    // the fallback function (even if Ether is sent along with the call).
    fallback() external payable {  }

    /// @dev allows the contract to accept ETH
    receive() external payable {
	    // Auctions needs to be Open to allow ETH to be passed
      require (this.isAuctionActive());
      
      uint256 _potentialUserBalance = userETHBalance[msg.sender].add(msg.value);
      // Checking Sender Addr & ETH
      require (address(msg.sender) != address(0));
      require (_potentialUserBalance > maxBid);
      
      _incrementBalance(msg.sender, msg.value);
      uint256 _userBalance = userETHBalance[msg.sender];
      maxBid = _userBalance;
    
	  emit SEBidPlaced(msg.sender, msg.value);
    }

  function _incrementBalance(address bidder, uint256 ethValue) private {
    if(userETHBalance[bidder] == 0){
      userETHBalance[bidder] = ethValue;
      allBidders.push(bidder);
    }else{
      uint256 _userBalance = userETHBalance[bidder];
      userETHBalance[bidder] = _userBalance.add(ethValue);
    }
  }

  function auctionWinner(address _winner, address _nftAddress) external anyOperator {
    require(address(_winner) != address(0), "Winner cannot be 0x0");
    
    uint256 _userBalance = userETHBalance[_winner];
    userETHBalance[_winner] = 0;
    bankManager.transfer(_userBalance);
    winner = _winner;
    if(transferToken){
      require(address(_nftAddress) != address(0), "NFT Address cannot be 0x0");
      ERC721Token _nft = ERC721Token(_nftAddress);
      require(_nft.ownerOf(assetId) == address(this));
	  _nft.transferFrom(address(this), _winner, assetId);
    }
    emit SEAuctionETHWinner(_winner, _userBalance, assetId);
  }

  function auctionWinnerWithGFC(bytes32 winnerBytes32, uint256 gfcToETH) external anyOperator {
    require(gfcToETH > 0, "Winning GFC-ETH cannot be 0");
    winner = address(bankManager);
    emit SEAuctionGFCWinner(winnerBytes32, gfcToETH, assetId);
  }
  
  function refundETH(address payable [] calldata refundAddresses) external anyOperator{
    for(uint i=0;i< refundAddresses.length;i++){
        require(refundAddresses[i] != address(0));
        uint256 _userBalance = userETHBalance[refundAddresses[i]];
        userETHBalance[refundAddresses[i]] = 0;
        refundAddresses[i].transfer(_userBalance);
        emit SEAuctionRefund(refundAddresses[i], _userBalance);
    }
  }
  
  function getAuctionDetails() external view returns(address winnerAddress, uint256 startPrice, uint256 startingTime, 
    uint256 endingTime, uint256 auctionDuration, uint256 assetID, bytes32 dApp, address nftContractAddress){
    return (
        winner,
        startingPrice,
        startedAt, 
        startedAt.add(duration), 
        duration,
        assetId, 
        dAppName, 
        nftAddress
    );
  }
  
  function totalNumberOfBidders() external view returns(uint256){
      return allBidders.length;
  }
  
  function updateTransferBool(bool flag) external anyOperator {
      transferToken = flag;
  }
  
  function getMaxBidValue() external view returns(uint256){
      return maxBid;
  }
  
  function transferAssetFromContract(address to, address nftAddress, uint256 assetId) external anyOperator{
    require(nftAddress != address(0), "NFT Contract Cannot be 0x0");
    
    ERC721Token _nft = ERC721Token(nftAddress);
    
    _nft.transferFrom(address(this), to, assetId);
  }
  
  function withdrawBalance() public onlyBanker {
      bankManager.transfer(address(this).balance);
  }
}

/**
 * @title      SEAuctionMaster
 * @dev        Scarcity Engine Master Auction Contract
 * @notice     Master auction Contract for Scarcity Engine
 */
contract SEAuctionMaster is OperationalControl {
  using SafeMath for uint256;
  using AddressUtils for address;
  
  /// @dev Auction Created
  event SEAuctionCreated(address newAuctionContract, uint256 assetId, uint256 startPrice, bytes32 indexed dAppName, uint256 startDate, uint256 endDate, uint256 seAuctionID);

  /**
  * @dev Constructor function
  */
  constructor () public {
    require (msg.sender != address(0));
    paused = true;
    error = false;
    managerPrimary = msg.sender;
    managerSecondary = msg.sender;
    bankManager = msg.sender;
    otherManagers[msg.sender] = 1;
  }
  
  struct Auction {
    uint256 auctionId;
    address payable contractAddress;
    uint256 assetId;
    address nftAddress;
    uint256 startPrice;
    uint256 startedAt;
    uint256 duration;
    bytes32 dAppName;
    uint256 winningPrice;
  }
  
  bool public canTransferOnAuction = false;
  Auction[] public auctions;
  
  function createAuction(uint256 assetId, address nftAddress, uint256 startPrice, uint256 duration, bytes32 dAppName) external onlyManager{
    require(nftAddress != address(0), "NFT Contract Cannot be 0x0");
    
    ERC721Token _nft = ERC721Token(nftAddress);
    require(duration != 0, "Duration cannot be zero");
    
    uint256 _currentTime = now;
    SEAuction _itemAuctionContract = new SEAuction(auctions.length, msg.sender, startPrice, _currentTime, duration, assetId, dAppName, nftAddress);
    
    address payable _contractAddress = address(_itemAuctionContract);
    
    Auction memory _itemAuction = Auction(
      auctions.length,
      _contractAddress,
      assetId,
      nftAddress,
      startPrice,
      _currentTime,
      duration,
      dAppName,
      0
    );

    auctions.push(_itemAuction);
    
    if(canTransferOnAuction){
        require(_nft.ownerOf(assetId) == address(this), "Auction Contract is not the owner");
        _nft.transferFrom(address(this), _contractAddress, assetId);
    }
    emit SEAuctionCreated(_contractAddress, assetId, startPrice, dAppName, _currentTime, _currentTime.add(duration), auctions.length - 1);
  }
  
  function refundFromAuction(address payable auctionContract, address payable [] calldata refundAddresses) external anyOperator {
    require(auctionContract != address(0));
    SEAuction _auctionContract = SEAuction(auctionContract);
    _auctionContract.refundETH(refundAddresses);
  }
  
  function getAuctionDetail(uint256 auctionID) external view returns(address winnerAddress, uint256 startPrice, uint256 startingTime, 
    uint256 endingTime, uint256 auctionDuration, uint256 assetId, bytes32 dApp, bytes32 auctionData, address nftContractAddress){
      Auction memory _auctionData = auctions[auctionID];
      SEAuction _auctionContract = SEAuction(_auctionData.contractAddress);
      _auctionContract.getAuctionDetails();
  }
  
  function updateAssetTransferForAuction(uint256 auctionID, bool flag) external {
      Auction memory _auctionData = auctions[auctionID];
      SEAuction _auctionContract = SEAuction(_auctionData.contractAddress);
      _auctionContract.updateTransferBool(flag);
  }
  
  function batchUpdateAssetTransferForAuction(uint256 [] calldata auctionIDs, bool flag) external {
      for(uint8 i=0;i<auctionIDs.length;i++){
        Auction memory _auctionData = auctions[auctionIDs[i]];
        SEAuction _auctionContract = SEAuction(_auctionData.contractAddress);
        _auctionContract.updateTransferBool(flag);
      }
  }
  
  function approveManager(uint256 auctionID, address approvedAddress) external anyOperator {
    Auction memory _auctionData = auctions[auctionID];
    ERC721Token _nft = ERC721Token(_auctionData.nftAddress);
    _nft.approve(approvedAddress, _auctionData.assetId);
  }
  
  function updateCanTransferOnAuction(bool flag) external anyOperator{
      canTransferOnAuction = flag;
  }
  
  function checkOwner(uint256 assetId, address nftAddress) external view returns (address){
    require(nftAddress != address(0), "NFT Contract Cannot be 0x0");
    
    ERC721Token _nft = ERC721Token(nftAddress);
    
    return _nft.ownerOf(assetId);
  }
  
  function transferStuckAsset(address to, address nftAddress, uint256 assetId) external anyOperator{
    require(nftAddress != address(0), "NFT Contract Cannot be 0x0");
    
    ERC721Token _nft = ERC721Token(nftAddress);
    
    _nft.transferFrom(address(this), to, assetId);
  }
    
  function withdrawBalance() public onlyBanker {
      bankManager.transfer(address(this).balance);
  }
}