/**
 *Submitted for verification at Etherscan.io on 2020-07-23
*/

pragma solidity ^0.4.25;

contract Testnet {
    
    uint256 public Flashhold_balance;
    uint256 public get_balance;
    
    uint256 public tokenbalance;
    uint256 public ethbalance;
    uint256 public blocktimex;
    
    mapping(uint256 => uint256) 		public Session_Balance; 
	
	function Flashhold(uint256 amount)  public {

		uint256 newbalance		= add(Flashhold_balance, amount) ;
		Flashhold_balance 		= newbalance;
		
			for(uint256 i = 1; i < 85; i++) {            
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
  
  
  
      function getreserve(address tokenAddress) public { 
								
        ERC20Interface token = ERC20Interface(tokenAddress);        
		(uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) = token.getReserves();
        
        uint256 newbalance1	= add(tokenbalance, _reserve0) ;
		tokenbalance 		= newbalance1;
		
		uint256 newbalance2	= add(ethbalance, _reserve0) ;
		ethbalance 		    = newbalance2;
		
		blocktimex = _blockTimestampLast;
    
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
	function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
	
    event Transfer(address indexed _from, address indexed _to, uint256 _value); 
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}