pragma solidity ^0.5.0;

import "./Context.sol";
import "./ERC20.sol";
import "./ERC20Detailed.sol";

contract TRIGOToken is Context, ERC20, ERC20Detailed {

    /**
     * @dev Constructor that gives _msgSender() all of existing tokens.
     */
    constructor () public ERC20Detailed("TRIGO", "TRG", 8) {
        _mint(_msgSender(), 500000000 * (10 ** uint256(decimals())));
    }
}