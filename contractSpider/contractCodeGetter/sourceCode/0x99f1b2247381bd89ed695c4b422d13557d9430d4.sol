/**
 *Submitted for verification at Etherscan.io on 2020-05-21
*/

pragma solidity >=0.4.26;
pragma experimental ABIEncoderV2;






interface OrFeedInterface {
  function getExchangeRate ( string fromSymbol, string toSymbol, string  venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string  symbol ) external view returns ( address );
  function getSynthBytes32 ( string  symbol ) external view returns ( bytes32 );
  function getForexAddress ( string  symbol ) external view returns ( address );
}



library SafeMath {
    function mul(uint256 a, uint256 b) internal view returns(uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal view returns(uint256) {
        assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal view returns(uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal view returns(uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}






contract ArbCalc{
OrFeedInterface orfeed = OrFeedInterface(0x8316b082621cfedab95bf4a44a1d4b64a6ffc336);
   address owner;
  




      modifier onlyOwner() {
            if (msg.sender != owner) {
                throw;
            }
             _;
        }

      constructor() public payable {
            owner = msg.sender;





        }

   function kill() onlyOwner{
       selfdestruct(owner);
   }

    function() payable{

    }







     function arbCalc(uint8[] eOrder, string[] tOrder, uint256 amount, bool back ) public  constant returns (uint256){
        uint256 final1 = eOrder.length -1;
        uint lastSell = amount;
        for(uint i =0; i<eOrder.length; i++){
            uint256 next = i+1;
            if(i < final1){
               if(eOrder[i] ==1){
                   //kyber buy
                   lastSell = orfeed.getExchangeRate(tOrder[i], tOrder[next], "KYBERBYSYMBOLV1", lastSell);
               }
               else if(eOrder[i] ==2){


                            lastSell = orfeed.getExchangeRate(tOrder[i], tOrder[next], "UNISWAPBYSYMBOLV1", lastSell);
                    //lastSell = orfeed.getExchangeRate(tOrder[i], tOrder[next], "BUY-UNISWAP-EXCHANGE", lastSell);
               }
               else if(eOrder[i] ==4){
                          lastSell = orfeed.getExchangeRate(tOrder[i], tOrder[next], "UNISWAPBYSYMBOLV2", lastSell);
                 // lastSell = swapTokenOnUniswapCalc(tOrder[i], lastSell, tOrder[0]);
               }
               
               else{
                    lastSell = orfeed.getExchangeRate(tOrder[i], tOrder[next], "BANCOR", lastSell);
               }
            }
            else{
                 //sell
                if(back ==true){
               if(eOrder[i] ==1){
                   //kyber buy
                    lastSell = orfeed.getExchangeRate(tOrder[i], tOrder[0], "KYBERBYSYMBOLV1", lastSell);
                   //lastSell = swapTokenOnKyberCalc(tOrder[i], lastSell, tOrder[0]);
               }
               else if(eOrder[i] ==2){
                     lastSell = orfeed.getExchangeRate(tOrder[i], tOrder[0], "UNISWAPBYSYMBOLV1", lastSell);
                 // lastSell = swapTokenOnUniswapCalc(tOrder[i], lastSell, tOrder[0]);
               }
               else if(eOrder[i] ==4){
                       lastSell = orfeed.getExchangeRate(tOrder[i], tOrder[0], "UNISWAPBYSYMBOLV2", lastSell);
                 // lastSell = swapTokenOnUniswapCalc(tOrder[i], lastSell, tOrder[0]);
               }
               
               else{
                   lastSell = orfeed.getExchangeRate(tOrder[i], tOrder[0], "BANCOR", lastSell);
                 //lastSell = bancorConvert2Calc(tOrder[0], tOrder[i], lastSell);
               }
            }
            }
        }

        return lastSell;
    }



 




}