pragma solidity ^0.4.24;

import "./MintableToken.sol";
import "./CappedToken.sol";

contract c137 is CappedToken {
 
    string public name = "Shmeckles";
    string public symbol = "c137";
    uint8 public decimals = 18;

    constructor(
        uint256 _cap
        )
        public
        CappedToken( _cap ) {
    }
}




