pragma solidity ^0.4.24;

import "./MintableToken.sol";
import "./CappedToken.sol";

contract NHT is CappedToken {
 
    string public name = "Coin Announce Token";
    string public symbol = "CAT";
    uint8 public decimals = 8;

    constructor(
        uint256 _cap
        )
        public
        CappedToken( _cap ) {
    }
}




