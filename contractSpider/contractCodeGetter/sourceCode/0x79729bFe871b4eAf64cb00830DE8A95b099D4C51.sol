pragma solidity ^0.4.24;

import "./MintableToken.sol";
import "./CappedToken.sol";

contract NOC is CappedToken {
 
    string public name = "Nexabook Coin";
    string public symbol = "NOC";
    uint8 public decimals = 18;

    constructor(
        uint256 _cap
        )
        public
        CappedToken( _cap ) {
    }
}




