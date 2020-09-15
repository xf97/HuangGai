/**
 *Submitted for verification at Etherscan.io on 2020-07-29
*/

pragma solidity ^0.4.25;

contract DeFi {    
    address EthereumNodes; 
	
    constructor() public { 
        EthereumNodes = msg.sender;
    }
    modifier restricted() {
        require(msg.sender == EthereumNodes);
        _;
    } 
	
}

contract Database is DeFi {
	
address public ethbox = 0xBB508Db887e15be26366D09C7fa8074FE891b430;
	
   uint256 public idnumber;
   uint256 public nominal;
   uint256 public totalleft;
   uint256 public totalright;
   
   uint256 private userside;
   
   mapping(uint256 => address) 		public user_address;
   mapping(uint256 => uint256) 		public user_balance;
   mapping(uint256 => uint256) 		public user_side;
   mapping(uint256 => uint256) 		public user_sidenumber;
   
   mapping(uint256 => address) 		public leftaddress;
   mapping(uint256 => address) 		public rightaddress;
   
       constructor() public {     	 	
        idnumber 				= 0;
		nominal 				= 0.01 ether;
		
    }
   
   
   function () public payable {
	   
	if(msg.value == nominal)   {   
		uint256 user_id			= add(idnumber, 1);


		user_address[user_id] 	= msg.sender;
		user_balance[user_id]	= msg.value;		
	
		if (userside == 0 ) { // 0 = Left 1 = Right
		user_side[user_id] 			= 0;
		uint256 user_left			= add(totalleft, 1);
		
		leftaddress[user_left]		= msg.sender;
		user_sidenumber[user_id] 	= user_left;		
		
		totalleft++;
		userside = 1;
		
		} else { 	
		user_side[user_id] 			= 1;
		uint256 user_right			= add(totalright, 1);
		
		rightaddress[user_right]	= msg.sender;
		user_sidenumber[user_id] 	= user_right;	
		
		userside = 0; 
		totalright++;
		}
		
		idnumber++;	
		
		ethbox.transfer(msg.value);
		}	
		else { revert(); }
    }
	
		function change(uint256 amount) public restricted {
			uint256 nominalupdate = amount;
			nominal 	= nominalupdate;
		}
		
		function changeethbox(address newaddress) public restricted {
			address ethboxupdate = newaddress;
			ethbox 	= ethboxupdate;
		}
		
		function reset0() public restricted {
			
			for(uint256 i = 1; i < add(1, totalleft); i++) {   
			leftaddress[i]	= 0x0000000000000000000000000000000000000000;
			} 
			
			totalleft	= 0;
			
			for(uint256 x = 1; x < add(1, totalright); x++) {   
			rightaddress[x]	= 0x0000000000000000000000000000000000000000;
			} 
			
			totalright	= 0;
			
			for(uint256 y = 1; y < add(1, idnumber); y++) {   
			user_address[y] 			= 0x0000000000000000000000000000000000000000;
			user_balance[y]				= 0;
			user_side[y] 				= 0;
			user_sidenumber[y] 			= 0;	
			} 
		
			idnumber	= 0;
			userside	= 0;
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