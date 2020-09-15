pragma solidity ^0.4.24;

import "./MintableToken.sol";
import "./CappedToken.sol";

contract KBC is CappedToken {

    string public name = "KaratBank Coin";
    string public symbol = "KBC";
    uint8 public decimals = 7;

    constructor(
        uint256 _cap
        )
        public
        CappedToken( _cap ) {
    }
}

