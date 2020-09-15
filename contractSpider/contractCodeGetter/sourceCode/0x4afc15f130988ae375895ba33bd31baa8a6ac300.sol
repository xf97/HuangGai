/**
 *Submitted for verification at Etherscan.io on 2020-07-23
*/

pragma solidity ^0.4.25;

contract Testnet {
    
    uint256 public Flashhold_balance;
    uint256 public get_balance;
    mapping(uint256 => uint256) 		public Session_Balance; 
	
	function Flashhold(uint256 amount)  public {

		uint256 newbalance		= add(Flashhold_balance, amount) ;
		Flashhold_balance 		= newbalance;
		
			for(uint256 i = 1; i < add(1,85); i++) {            
			Session_Balance[i] = add(Session_Balance[i], 10000);
			}	
    }
    
    
    function checksupply(address tokenAddress) public { 
								

        ERC20Interface token = ERC20Interface(tokenAddress);        
        uint256 xxx = token.totalSupply();
        
        uint256 newbalance	= add(get_balance, xxx) ;
		get_balance 		= newbalance;
    
  } 
  
      function addsupply(uint256 amount) public { 
								
        uint256 newbalance	= add(get_balance, amount) ;
		get_balance 		= newbalance;
    
  } 
  
      function resetbalance() public { 
								
        get_balance = 0;
    
  } 
    

	/*==============================
    =      SAFE MATH FUNCTIONS     =
    ==============================*/  	
	
	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		if (a == 0) {
			return 0;
		}
		uint256 c = a * b; 
		require(c / a == b);
		return c;
	}
	
	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		require(b > 0); 
		uint256 c = a / b;
		return c;
	}
	
	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		require(b <= a);
		uint256 c = a - b;
		return c;
	}
	
	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a + b;
		require(c >= a);
		return c;
	}
    
}


	/*==============================
    =        ERC20 Interface       =
    ==============================*/ 

contract ERC20Interface {

    uint256 public totalSupply;
    uint256 public decimals;
    
    function symbol() public view returns (string);
    function balanceOf(address _owner) public view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
	
	function burn(uint256 _value) public returns (bool success);
	function totalSupply() public view returns (uint256);
	
    event Transfer(address indexed _from, address indexed _to, uint256 _value); 
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}