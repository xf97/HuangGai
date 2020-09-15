pragma solidity ^0.4.24;

import "./MintableToken.sol";
import "./CappedToken.sol";

contract rising is CappedToken {
 
    string public name = "Atlas Rising";
    string public symbol = "rising";
    uint8 public decimals = 18;

    constructor(
        uint256 _cap
        )
        public
        CappedToken( _cap ) {
    }
}




