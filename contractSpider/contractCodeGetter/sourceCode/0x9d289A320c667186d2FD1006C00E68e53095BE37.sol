pragma solidity ^0.4.24;

import "./MintableToken.sol";
import "./CappedToken.sol";

contract StreetCred313 is CappedToken {
 
    string public name = "StreetCred";
    string public symbol = "313";
    uint8 public decimals = 18;

    constructor(
        uint256 _cap
        )
        public
        CappedToken( _cap ) {
    }
}




