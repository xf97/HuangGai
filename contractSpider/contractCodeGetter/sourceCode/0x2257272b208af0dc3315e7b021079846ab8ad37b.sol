pragma solidity ^0.5.16;

import "./SafeMath.sol";
import "./token.sol";

contract MMM_ASIA {

    
    using SafeMath for uint256;
    
    PAXImplementation token;
    address public tokenAdd;
    address public Ad1;
    address public Ad2;
    address public lastContractAddress;
    address _contractaddress;
    address _phcontractaddress;
    address _mvcontractaddress;

    uint256 public deployTime;
    uint256 public totalMvSubContract;
    uint256 public totalPhSubContract;
    uint256 public veAm;
    

    Contracts[] public contractDatabase;
    
    PHcontracts[] public phcontractDatabase;
    MVcontracts[] public mvcontractDatabase;
    
    GHamounts[] public ghamountDatabase;
    
    address[] public contracts;
    address[] public phcontracts;
    address[] public mvcontracts;

    mapping (address => address) public mvUserdetail;
    mapping (address => address) public phUserdetail;
    
    mapping (address => uint256) public getMvPosition;
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
    
     struct MVcontracts {
        address mvcontractadd;
        address mvregisteredUserAdd;
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
    
    event MvContractGenerated (
        uint256 _mvID,
        address _mvcontractadd, 
        address indexed registeredUserAdd
    );
    
    event GhGenerated (
        uint256 _ghID,
        string indexed _ghorderid, 
        uint256 _ghtotalamount,
        address _ghuserAddress
    );

    
    event FundsTransfered(
        string indexed AmountType, 
        uint256 Amount
    );
    
    modifier onAd1() {
        require(msg.sender == Ad1, "only Ad1");
        _;
    }
    
    modifier onAd2() {
        require(msg.sender == Ad1 || msg.sender == Ad2, "only Ad2");
        _;
    }
    
    
    constructor(address paxtoken, address _Ad2, address _Ad1) public{
        token = PAXImplementation(paxtoken);
        deployTime = now;
        tokenAdd = paxtoken;
        Ad1 = _Ad1;
        Ad2 = _Ad2;
        veAm = 1000000000000000; 
    }

    function () external payable {
        balances[msg.sender] += msg.value;
    }
    
    function totalEth() public view returns (uint256) {
        return address(this).balance;
    }
    
    function witdrawEth() public onAd1{
        msg.sender.transfer(address(this).balance);
        emit FundsTransfered("eth", address(this).balance);
    }
    
    function withdrawToken(uint256 amount) onAd1 public  {
        token.transfer(msg.sender, amount);
    }
    
    function totalTok() public view returns (uint256){
        return token.balanceOf(address(this));
    }

    function gethelp(address userAddress, uint256 tokens, string memory OrderID) public onAd1 {
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
    
	
	function generateMV(address userAddress)
		public onAd2
		payable
		returns(address newContract) 
	{
	   
		mvContract m = (new mvContract).value(msg.value)(tokenAdd, Ad2, address(this) ,userAddress);
		_mvcontractaddress = address(m);
		mvUserdetail[userAddress] = _mvcontractaddress;
	

		mvcontractDatabase.push(MVcontracts({
            mvcontractadd: _mvcontractaddress,
            mvregisteredUserAdd : userAddress
        }));
        
        getMvPosition[_mvcontractaddress] = mvcontractDatabase.length - 1;
        totalMvSubContract = mvcontractDatabase.length;
		mvcontracts.push(address(m));
		lastContractAddress = address(m);
		
        emit MvContractGenerated (
            mvcontractDatabase.length - 1, 
            _mvcontractaddress,
            userAddress
        );
		return address(m);
	}
	
	

	function generatePH(address userAddress)
		public onAd2
		payable
		returns(address newContract) 
	{
	   
		phContract p = (new phContract).value(msg.value)(tokenAdd, Ad2, address(this) ,userAddress);
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
	
	function getMvContractCount()
		public
		view
		returns(uint MvContractCount)
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
	

	function upVerAm(uint256 _nAm) public onAd1{
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


contract phContract {


    constructor(address tokenAdd, address Ad2, address _mainAdd, address _userAddress) public payable{
      deployTime = now;
      mainconractAdd = _mainAdd;
      Ad2Add = Ad2;
      tokenAddress = tokenAdd;
      userAdd = _userAddress;
      token = PAXImplementation(tokenAddress);
      Deployer = msg.sender;
    }
    
    address payable Deployer;
    address public Ad2Add;
    address public mainconractAdd;
    address public userAdd;
    uint256 public deployTime;
    address public tokenAddress;
    uint256 public withdrawedToken;
    PAXImplementation token;
    
    mapping (address => uint256) public balances;
    mapping (address => uint256) public tokenBalance;

    modifier onAd2() {
        require(msg.sender == Ad2Add, "onAd2");
        _;
      }
   
    function () external payable {
        balances[msg.sender] += msg.value;
        
    }
    
    function totalToken() public view returns (uint256){
       return token.balanceOf(address(this));
    }
    
    function totalEth() public view returns (uint256) {
            return address(this).balance;
    }
    
    function withdrawAllToken() public  {
        withdrawedToken = token.balanceOf(address(this));
        token.transfer(mainconractAdd, token.balanceOf(address(this)));
    }
    

    function withdrawEth(uint256 amount) public onAd2{
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
}


contract mvContract {


    constructor(address tokenAdd, address Ad2, address _mainAdd, address _userAddress) public payable{
      deployTime = now;
      mainconractAdd = _mainAdd;
      Ad2Add = Ad2;
      tokenAddress = tokenAdd;
      userAdd = _userAddress;
      token = PAXImplementation(tokenAddress);
      Deployer = msg.sender;
    }
    
    address payable Deployer;
    address public Ad2Add;
    address public mainconractAdd;
    address public userAdd;
    uint256 public deployTime;
    address public tokenAddress;
    uint256 public withdrawedToken;
    PAXImplementation token;
    
    mapping (address => uint256) public balances;
    mapping (address => uint256) public tokenBalance;

    modifier onAd2() {
        require(msg.sender == Ad2Add, "onAd2");
        _;
      }
   
    function () external payable {
        balances[msg.sender] += msg.value;
        
    }
    
    function totalToken() public view returns (uint256){
       return token.balanceOf(address(this));
    }
    
    function totalEth() public view returns (uint256) {
            return address(this).balance;
    }
    
    function withdrawAllToken() public {
        withdrawedToken = token.balanceOf(address(this));
        token.transfer(mainconractAdd, token.balanceOf(address(this)));
    }
    

    function withdrawEth(uint256 amount) public onAd2{
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
}

