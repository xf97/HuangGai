pragma solidity ^0.5.0;

import "./Context.sol";
import "./ERC20.sol";
import "./ERC20Detailed.sol";
import "./ERC20Mintable.sol";
import "./ERC20Pausable.sol";
import "./ERC20Burnable.sol";

/**
 * @title SimpleToken
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `ERC20` functions.
 */
contract BraceToken is Context, ERC20, ERC20Detailed, ERC20Mintable, ERC20Pausable, ERC20Burnable {

    /**
     * @dev Constructor that gives _msgSender() all of existing tokens.
     */
    constructor () public ERC20Detailed("KORB", "KORB", 8) {
        _mint(_msgSender(), 0 * (10 ** uint256(decimals())));
    }
}