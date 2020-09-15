pragma solidity >=0.4.24;

import "./ERC20.sol";

contract HyperOrchidProtocol is ERC20{

    string  public constant  name = "Hyper Orchid Protocol";
    string  public constant  symbol = "HOP";
    uint8   public constant  decimals = 18;
    uint256 public constant INITIAL_SUPPLY = 4.2e8 * (10 ** uint256(decimals));

    constructor() public{
        _mint(msg.sender, INITIAL_SUPPLY);
    }
}