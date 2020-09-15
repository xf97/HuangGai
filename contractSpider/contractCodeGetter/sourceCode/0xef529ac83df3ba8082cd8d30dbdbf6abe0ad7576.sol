/**
 *Submitted for verification at Etherscan.io on 2020-05-09
*/

/*
0x777a32d8291B045a825A5a9057052AC737e1F2b2

Contract that reads DAI price on KYBER  and UNISWAP an does a trade when triggerd in the node JS app

USES THE NEW SYMBOLS FOR ORFEED

trades tested, needs DAI in smart contract to trade DAI - ETH arb

withdrawl DAI tested

*/



interface OrFeedInterface {
  function getExchangeRate ( string fromSymbol, string toSymbol, string venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string symbol ) external view returns ( address );
  function getSynthBytes32 ( string symbol ) external view returns ( bytes32 );
  function getForexAddress ( string symbol ) external view returns ( address );
}





contract Trader{
    
   
    OrFeedInterface orfeed= OrFeedInterface(0x8316b082621cfedab95bf4a44a1d4b64a6ffc336);
   
    
    
    function getDAIKyberBuyPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "DAI", "KYBERBYSYMBOLV1", 1000000000000000000);
        return currentPrice;
    }

    function getUSDCKyberBuyPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "USDC", "KYBERBYSYMBOLV1", 1000000000000000000);
        return currentPrice;
    }
    function getPAXKyberBuyPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "PAX", "KYBERBYSYMBOLV1", 1000000000000000000);
        return currentPrice;
    }

     function getDAIUniswapBuyPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "DAI", "UNISWAPBYSYMBOLV1", 1000000000000000000);
        return currentPrice;
    }

     function getUSDCUniswapBuyPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "USDC", "UNISWAPBYSYMBOLV1", 1000000000000000000);
        return currentPrice;
    }

      function getPAXUniswapBuyPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "PAX", "UNISWAPBYSYMBOLV1", 1000000000000000000);
        return currentPrice;
    }
    
    function getDAIBancorBuyPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "DAI", "BANCOR", 1000000000000000000);
        return currentPrice;
    }

     function getUSDCBancorBuyPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "USDC", "BANCOR", 1000000000000000000);
        return currentPrice;
    }

      function getPAXBancorBuyPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "PAX", "BANCOR", 1000000000000000000);
        return currentPrice;
    }







    function getDAIKyberSellPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "DAI", "KYBERBYSYMBOLV1", 1000000000000000000);
        return currentPrice;
    }

    function getUSDCKyberSellPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "USDC", "KYBERBYSYMBOLV1", 1000000000000000000);
        return currentPrice;
    }
    function getPAXKyberSellPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "PAX", "KYBERBYSYMBOLV1", 1000000000000000000);
        return currentPrice;
    }
    
     function getDAIUniswapSellPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "DAI", "UNISWAPBYSYMBOLV1", 1000000000000000000);
        return currentPrice;
    }

     function getUSDCUniswapSellPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "USDC", "UNISWAPBYSYMBOLV1", 1000000000000000000);
        return currentPrice;
    }

      function getPAXUniswapSellPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "PAX", "UNISWAPBYSYMBOLV1", 1000000000000000000);
        return currentPrice;
    }

    function getDAIBancorSellPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "DAI", "BANCOR", 1000000000000000000);
        return currentPrice;
    }

     function getUSDCBancorSellPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "USDC", "BANCOR", 1000000000000000000);
        return currentPrice;
    }

      function getPAXBancorSellPrice() constant returns (uint256){
       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "PAX", "BANCOR", 1000000000000000000);
        return currentPrice;
    }



    
    
    
    
    
}