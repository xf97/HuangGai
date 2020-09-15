pragma solidity ^0.4.24;

import "./MintableToken.sol";
import "./CappedToken.sol";

contract OVOABT is CappedToken {

    string public name = "OVOABT";
    string public symbol = "OVO";
    uint8 public decimals = 18;

    constructor(
        uint256 _cap
        )
        public
        CappedToken( _cap ) {
    }
}

