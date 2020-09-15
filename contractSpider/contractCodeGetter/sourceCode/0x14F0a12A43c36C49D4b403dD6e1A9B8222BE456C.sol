pragma solidity ^0.4.24;

import "./MintableToken.sol";
import "./CappedToken.sol";

contract NHT is CappedToken {
 
    string public name = "VINX Coin";
    string public symbol = "VXC";
    uint8 public decimals = 18;

    constructor(
        uint256 _cap
        )
        public
        CappedToken( _cap ) {
    }
}




