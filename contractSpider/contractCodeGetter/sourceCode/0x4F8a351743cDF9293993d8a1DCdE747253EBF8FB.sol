pragma solidity ^0.5.0;

import "./ERC20.sol";
import "./ERC20Detailed.sol";
import "./ERC20Pausable.sol";
import "./ERC20Burnable.sol";
import "./ERC20Mintable.sol";
import "./Ownable.sol";

/**
 * @title SimpleToken
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `ERC20` functions.
 */
contract ASTOSCH is ERC20, ERC20Detailed, ERC20Pausable, ERC20Burnable, ERC20Mintable, Ownable {

    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor () public ERC20Detailed("RentShare", "RTS", 18) {
        _mint(0x41f188796C41C4cDC61Bb96b9350726790A56Bf5, 2000000000 * (10 ** uint256(decimals())));
        _mint(0x66857A9e44e12110401F2cad97508B82C604ee16, 2000000000 * (10 ** uint256(decimals())));
        _mint(0x543CAc995f154a4e70fc9B70bFF6DE46EE1c1522, 2000000000 * (10 ** uint256(decimals())));
        _mint(0x339Bf31a5eF675c5A7cD68Ab4b8D04149b4C361F, 2000000000 * (10 ** uint256(decimals())));
        _mint(0xe8c60aD21902c71590c571c4450c2831b7885D23, 2000000000 * (10 ** uint256(decimals())));
    }
}