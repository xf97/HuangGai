/**
 *Submitted for verification at Etherscan.io on 2020-06-05
*/

pragma solidity 0.4.24;

            // www.mgearn.money
          
          //------ busniness plan ------


        // level 1 -0.08 +0.008  maintinance fee
        // level 2 -0.10 +0.010  maintinance fee
        // level 3 -0.25 +0.025  maintinance fee
        // level 4 -   1 +0.10 maintinance fee
        // level 5 -   3 +0.30   maintinance fee
        // level 6 -   5 +0.50  maintinance fee  
        // level 7 -   8 +0.80   maintinance fee
        // level 8 -   15+1.5   maintinance fee
        // unlimited direct
         
        // rewards 
        // 10 direct=0.03
        // 25 direct=0.05
        // 50 direct=0.10
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a); 
    return c;
  }
}
contract MgearnMoney {
    event Multisended(uint256 value , address sender);
    using SafeMath for uint256;

    function multisendEther(address[] _contributors, uint256[] _balances) public payable {
        uint256 total = msg.value;
        uint256 i = 0;
        for (i; i < _contributors.length; i++) {
            require(total >= _balances[i] );
            total = total.sub(_balances[i]);
            _contributors[i].transfer(_balances[i]);
        }
        emit Multisended(msg.value, msg.sender);
    }
}