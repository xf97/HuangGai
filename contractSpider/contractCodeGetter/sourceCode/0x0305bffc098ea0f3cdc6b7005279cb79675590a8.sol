/**
 *Submitted for verification at Etherscan.io on 2020-05-19
*/

//Uniswap by symbol (v2)
//Better uniswap v2 oracle for orfeed
//v0.5.0+commit.1d4f565a.js&appVersion=0.7.7

interface OrFeedInterface {
  function getExchangeRate (  string calldata fromSymbol,  string calldata toSymbol, string calldata venue, uint256  amount ) external view returns ( uint256 );
      function getTokenAddress ( string calldata symbol ) external view returns ( address );
}

interface ERC20 {
    function totalSupply() external view returns (uint supply);
    function balanceOf(address _owner) external view returns (uint balance);
    function transfer(address _to, uint _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint _value) external returns (bool success);
    function approve(address _spender, uint _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    function decimals() external view returns(uint digits);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}


interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    
    
   
 
    
   

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}


  
  
    contract oracleInfo {
        
    
      address owner; 
      OrFeedInterface orfeed = OrFeedInterface(0x8316B082621CFedAB95bf4a44a1d4B64a6ffc336);
      
      address uniswapAddress = 0xf164fC0Ec4E93095b804a4795bBe1e041497b92a;
        IUniswapV2Router01 uniswap = IUniswapV2Router01(uniswapAddress);


      modifier onlyOwner() {
            if (msg.sender != owner) {
                revert();
            }
             _;
        }
        
      constructor() public payable {
            owner = msg.sender; 
           
        }
        
        
    function getPriceFromOracle(string memory fromParam, string memory  toParam, string memory side, uint amount) public view returns (uint256 amounts1){  
          
        
        address sellToken = orfeed.getTokenAddress(fromParam);
        address buyToken = orfeed.getTokenAddress(toParam);
        
        address [] memory addresses = new address[](2);
      
       addresses[0] = sellToken;
       addresses[1] = buyToken;
      
       
        uint256 [] memory amounts = getPriceFromOracleActual(addresses, amount );
        uint256 resultingTokens = amounts[1];
        return resultingTokens;
          
    }
      
    function getPriceFromOracleActual(address  [] memory theAddresses, uint amount) public view returns (uint256[] memory amounts1){  
       
      
       
        uint256 [] memory amounts = uniswap.getAmountsOut(amount,theAddresses );
       
        return amounts;
          
    }
    
 
      function changeOwner(address newOwner) public onlyOwner returns(bool){
          owner = newOwner;
          return true;
      }
      
     function withdrawBalance() public onlyOwner returns(bool) {
        uint amount = address(this).balance;
        msg.sender.transfer(amount);
        return true;

    }
    
    
    
}