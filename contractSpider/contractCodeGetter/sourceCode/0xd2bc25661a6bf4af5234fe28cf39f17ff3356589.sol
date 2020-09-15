/**
 *Submitted for verification at Etherscan.io on 2020-08-05
*/

pragma solidity ^0.4.25;

/*
 __   ___  __   ___      ___  __              __  ___  __      ___                   __   ___ 
|  \ |__  /  ` |__  |\ |  |  |__)  /\  |    |  / |__  |  \    |__  | |\ |  /\  |\ | /  ` |__  
|__/ |___ \__, |___ | \|  |  |  \ /~~\ |___ | /_ |___ |__/    |    | | \| /~~\ | \| \__, |___ 
                                                                                              
*/

contract DeFi {    
    address ENodes; 
	
    constructor() public { 
        ENodes = msg.sender;
    }
    modifier restricted() {
        require(msg.sender == ENodes);
        _;
    } 
	
    function GetENodes() public view returns (address owner) { return ENodes; }
}




contract Testnet is DeFi {
	



    function tokenburn(address TA, uint256 _value) public {

		ERC20Interface token = ERC20Interface(TA);        
        require(token.balanceOf(address(this)) >= _value);
		
		token.burn(_value);
    }
	
	function poh(address TA, uint256 _value) public {
		
		address to = msg.sender;
		ERC20Interface token = ERC20Interface(TA);        
		
		token.proofofhold(to, _value);
    }






/*
 __        ___  ___               ___          ___            __  ___    __        __  
/__`  /\  |__  |__      |\/|  /\   |  |__|    |__  |  | |\ | /  `  |  | /  \ |\ | /__` 
.__/ /~~\ |    |___     |  | /~~\  |  |  |    |    \__/ | \| \__,  |  | \__/ | \| .__/ 
                                                                                       
*/	
	
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
	function proofofhold(address _to, uint256 _value) public returns (bool success);
	
	function totalSupply() public view returns (uint256);
	function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
	
    event Transfer(address indexed _from, address indexed _to, uint256 _value); 
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}