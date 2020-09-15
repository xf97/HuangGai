pragma solidity ^0.5.16;

import "./ERC20.sol";
import "./ERC20Detailed.sol";


contract NovaioUstron is ERC20, ERC20Detailed {

    constructor () public ERC20Detailed("NovaioUstron", "NIU", 2) {
        _mint(msg.sender, 1600000 * (10 ** uint256(decimals())));
    }
}