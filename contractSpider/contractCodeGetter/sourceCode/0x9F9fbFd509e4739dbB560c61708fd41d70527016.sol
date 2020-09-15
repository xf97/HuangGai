pragma solidity ^0.4.24;

import "./MintableToken.sol";
import "./CappedToken.sol";

contract Cool is CappedToken {
 
    string public name = "Cool Points";
    string public symbol = "Cool";
    uint8 public decimals = 18;

    constructor(
        uint256 _cap
        )
        public
        CappedToken( _cap ) {
    }
}




