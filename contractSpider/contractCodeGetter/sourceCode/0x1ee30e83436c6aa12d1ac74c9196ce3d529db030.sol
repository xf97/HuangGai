pragma solidity ^0.5.0;

import "./ERC20.sol";
import "./ERC20Detailed.sol";
import "./ERC20Mintable.sol";
import "./ERC20Pausable.sol";
import "./ERC20Burnable.sol";

contract CryptodidacteToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Pausable, ERC20Burnable {
    constructor(uint256 initialSupply, address initialHolder)
        public
        ERC20Detailed("Cryptodidacte Token", "CDT", 0)
    {
        // Mint the initial supply
        _mint(initialHolder, initialSupply);

        // Remove contract creator from Minters and Pausers
        _removeMinter(msg.sender);
        _removePauser(msg.sender);

        // Add initialHolder to Minters and Pausers
        _addMinter(initialHolder);
        _addPauser(initialHolder);
    }
}
