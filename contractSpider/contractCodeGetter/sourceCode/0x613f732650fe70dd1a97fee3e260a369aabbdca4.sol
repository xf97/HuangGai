pragma solidity ^0.6.0;

import "ERC20.sol";

contract LFGToken is ERC20 {
    constructor() ERC20("Alphabets", "LFG") public {
        _mint(msg.sender, 100000000000000000000000000);
    }
}