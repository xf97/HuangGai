/**
 *Submitted for verification at Etherscan.io on 2020-07-19
*/

pragma solidity ^0.4.21;
/***
 *     _______             __            __       __            __                           
 *    |       \           |  \          |  \     /  \          |  \                          
 *    | $$$$$$$\  ______   \$$ _______  | $$\   /  $$  ______  | $$   __   ______    ______  
 *    | $$__| $$ |      \ |  \|       \ | $$$\ /  $$$ |      \ | $$  /  \ /      \  /      \ 
 *    | $$    $$  \$$$$$$\| $$| $$$$$$$\| $$$$\  $$$$  \$$$$$$\| $$_/  $$|  $$$$$$\|  $$$$$$\
 *    | $$$$$$$\ /      $$| $$| $$  | $$| $$\$$ $$ $$ /      $$| $$   $$ | $$    $$| $$   \$$
 *    | $$  | $$|  $$$$$$$| $$| $$  | $$| $$ \$$$| $$|  $$$$$$$| $$$$$$\ | $$$$$$$$| $$      
 *    | $$  | $$ \$$    $$| $$| $$  | $$| $$  \$ | $$ \$$    $$| $$  \$$\ \$$     \| $$      
 *     \$$   \$$  \$$$$$$$ \$$ \$$   \$$ \$$      \$$  \$$$$$$$ \$$   \$$  \$$$$$$$ \$$      
 *              
 *  
 * v 1.1.0
 *  "I believe in large dividends!"                                                                                         
 *
 *  Ethereum Commonwealth.gg Rainmaker(based on contract @ ETC:0xa4ee9e650951b987d23367e29ce49f5350706a49)

 *  What?
 *  -> Holds onto eWLTH tokens, and can ONLY reinvest in the eWLTH contract and accumulate more tokens.
 *  -> This contract CANNOT sell, give, or transfer any tokens it owns.
 */

contract Hourglass {
    function reinvest() public {}
    function myTokens() public view returns(uint256) {}
    function myDividends(bool) public view returns(uint256) {}
}

contract RainMaker {
    Hourglass eWLTH;
    address public eWLTHAddress = 0x5833C959C3532dD5B3B6855D590D70b01D2d9fA6;

    function RainMaker() public {
        eWLTH = Hourglass(eWLTHAddress);
    }

    function makeItRain() public {
        eWLTH.reinvest();
    }

    function myTokens() public view returns(uint256) {
        return eWLTH.myTokens();
    }
    
    function myDividends() public view returns(uint256) {
        return eWLTH.myDividends(true);
    }
}