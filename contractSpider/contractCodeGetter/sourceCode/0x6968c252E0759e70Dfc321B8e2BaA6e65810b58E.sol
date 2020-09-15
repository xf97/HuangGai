pragma solidity ^0.4.24;

import "./MintableToken.sol";
import "./CappedToken.sol";

contract GIV is CappedToken {
 
    string public name = "Givcoin";
    string public symbol = "GIV";
    uint8 public decimals = 18;

    constructor(
        uint256 _cap
        )
        public
        CappedToken( _cap ) {
    }
}




