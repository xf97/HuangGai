/**
 *Submitted for verification at Etherscan.io on 2020-05-10
*/

//Legacy contract to support the Buy-Kyber-Exchange functionality from earlier tutorials


interface OrFeedInterface {
  function getExchangeRate ( string fromSymbol, string toSymbol, string venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string symbol ) external view returns ( address );
  function getSynthBytes32 ( string symbol ) external view returns ( bytes32 );
  function getForexAddress ( string symbol ) external view returns ( address );
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

interface IKyberNetworkProxy {
    function maxGasPrice() external view returns(uint);
    function getUserCapInWei(address user) external view returns(uint);
    function getUserCapInTokenWei(address user, ERC20 token) external view returns(uint);
    function enabled() external view returns(bool);
    function info(bytes32 id) external view returns(uint);
    function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) external view returns (uint expectedRate, uint slippageRate);
    function tradeWithHint(ERC20 src, uint srcAmount, ERC20 dest, address destAddress, uint maxDestAmount, uint minConversionRate, address walletId, bytes  hint) external payable returns(uint);
    function swapEtherToToken(ERC20 token, uint minRate) external payable returns (uint);
    function swapTokenToEther(ERC20 token, uint tokenQty, uint minRate) external returns (uint);
}
interface Kyber {
    function getOutputAmount(ERC20 from, ERC20 to, uint256 amount) external view returns(uint256);

    function getInputAmount(ERC20 from, ERC20 to, uint256 amount) external view returns(uint256);
}



  
    // ERC20 Token Smart Contract
    contract oracleInfo {
        
    
      address owner; 
      OrFeedInterface orfeed = OrFeedInterface(0x8316b082621cfedab95bf4a44a1d4b64a6ffc336);
       address kyberProxyAddress = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
     IKyberNetworkProxy kyberProxy = IKyberNetworkProxy(kyberProxyAddress);


      modifier onlyOwner() {
            if (msg.sender != owner) {
                throw;
            }
             _;
        }
        
      constructor() public payable {
            owner = msg.sender; 
           
        }
        
        
    function getPriceFromOracle(string fromParam, string toParam, string  side, uint256 amount) public constant returns (uint256){  



      address sellToken = orfeed.getTokenAddress(fromParam);
        address buyToken = orfeed.getTokenAddress(toParam);
        
        ERC20 sellToken1 = ERC20(sellToken);
        ERC20 buyToken1 = ERC20(buyToken);
        
        uint sellDecim = sellToken1.decimals();
         uint buyDecim = buyToken1.decimals();


          
        Kyber kyber = Kyber(0xFd9304Db24009694c680885e6aa0166C639727D6);
        uint256 price;
          
         price = kyber.getInputAmount(buyToken1, sellToken1, amount);
                 
                
           
         
        return price;
        
          
    }
      
      
         
     
      
      function changeOwner(address newOwner) onlyOwner returns(bool){
          owner = newOwner;
          return true;
      }
      
     function withdrawBalance() onlyOwner returns(bool) {
        uint amount = this.balance;
        msg.sender.transfer(amount);
        return true;

    }
    
    
    
}