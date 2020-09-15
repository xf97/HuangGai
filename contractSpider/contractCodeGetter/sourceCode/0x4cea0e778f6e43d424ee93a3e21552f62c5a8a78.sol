/**
 *Submitted for verification at Etherscan.io on 2020-06-05
*/

// Proxy contract, which allows owner to redeem funds after they use this contract to call another that may or may not send fund to this contract.
//Additionally deploys saved gas to get rebate if gas token is present

interface ERC20 {
    function totalSupply() public view returns (uint supply);
    function balanceOf(address _owner) public view returns (uint balance);
    function transfer(address _to, uint _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
    function approve(address _spender, uint _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint remaining);
    function decimals() public view returns(uint digits);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

interface ERC20GasToken {
    function name (  ) external view returns ( string memory);
  function freeFromUpTo ( address from, uint256 value ) external returns ( uint256 freed );
  function approve ( address spender, uint256 value ) external returns ( bool success );
  function totalSupply (  ) external view returns ( uint256 supply );
  function transferFrom ( address from, address to, uint256 value ) external returns ( bool success );
  function decimals (  ) external view returns ( uint8 );
  function freeFrom ( address from, uint256 value ) external returns ( bool success );
  function freeUpTo ( uint256 value ) external returns ( uint256 freed );
  function balanceOf ( address owner ) external view returns ( uint256 balance );
  function symbol (  ) external view returns ( string memory);
  function mint ( uint256 value ) external;
  function transfer ( address to, uint256 value ) external returns ( bool success );
  function free ( uint256 value ) external returns ( bool success );
  function allowance ( address owner, address spender ) external view returns ( uint256 remaining );
}



contract EfficientProxy{
    
    address owner = msg.sender;
    address public logic_contract;
    ERC20GasToken gasToken = ERC20GasToken(0x0000000000b3F879cb30FE243b4Dfee438691c04);
     
     modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner of the contract");
        _;
    }
    
    function setLogicContract(address _c) public onlyOwner returns (bool success){
        logic_contract = _c;
        return true;
    }

    function  () payable public {

        address target = logic_contract;
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize)
            let result := delegatecall(gas, target, ptr, calldatasize, 0, 0)
            let size := returndatasize
            returndatacopy(ptr, 0, size)
            switch result
            case 0 { revert(ptr, size) }
            case 1 { return(ptr, size) }
        }
        
        if(gasToken.balanceOf(this) >0){
            gasToken.freeFromUpTo(address(this), gasToken.balanceOf(this));
        }
        
    }
    
    function withdrawOwnerETH() onlyOwner returns(bool) {
        uint amount = this.balance;
        msg.sender.transfer(amount);
        return true;
    }
    
    function withdrawOwnerTokens(address tokenAddress) onlyOwner{
        ERC20 token = ERC20(tokenAddress);
        uint256 currentTokenBalance = token.balanceOf(this);
        token.transfer(msg.sender, currentTokenBalance);
    }

    
}