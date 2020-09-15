pragma solidity >= 0.5.0;

import "./ERC20.sol";

contract BT is ERC20{

    string  public constant  name = "Blockchain Password Token";
    string  public constant  symbol = "BT";
    uint8   public constant  decimals = 18;
    uint256 public constant INITIAL_SUPPLY = 1e8 * (10 ** uint256(decimals));

    constructor() public{
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function burn(uint amount) external{
        _burn(msg.sender, amount);
    }

    function burnFrom(address account, uint amount) external{
        _burnFrom(account, amount);
    }
}