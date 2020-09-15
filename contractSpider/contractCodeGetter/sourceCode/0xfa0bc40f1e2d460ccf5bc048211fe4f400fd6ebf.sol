pragma solidity ^0.6.0;

import "./ERC20.sol";
contract JUSD is ERC20 {
    using SafeMath for uint256;

    address public governance;
    mapping (address => bool) public minters;

    constructor(uint256 initialSupply) public ERC20("JUSD", "JUSD") {
        governance = msg.sender;
        _mint(msg.sender, initialSupply);
    }
    function mint(address account, uint amount) public {
        require(minters[msg.sender], "!minter");
        _mint(account, amount);
    }
    function burn(address account, uint256 amount) public {
        _burn(account, amount);
    }

    function setGovernance(address _governance) public {
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }

    function addMinter(address _minter) public {
        require(msg.sender == governance, "!governance");
        minters[_minter] = true;
    }

    function removeMinter(address _minter) public {
        require(msg.sender == governance, "!governance");
        minters[_minter] = false;
    }
}