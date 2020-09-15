pragma solidity ^0.6.3;

import "./ERC20.sol";

contract ArbicoinToken is ERC20 {
    constructor() ERC20("Arbicoin", "ARBIS") public {
        uint256 initialSupply_ = 10_000_000_000;
        uint8 decimals_ = 2;

        _setupDecimals(decimals_);
        _mint(msg.sender, initialSupply_ * (10 ** uint256(decimals_)));
    }
}
