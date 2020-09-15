pragma solidity ^0.4.20;

import "./base.sol";

contract SPT_tokenI is ERC20 {
    function mint(uint wad) public;
    function burn(uint wad) public;
    function mint(address guy, uint wad) public;
    function burn(address guy, uint wad) public;

    function setOwner(address owner_) public;
    function getOwner() public view returns(address);
}

contract SPT_token is DSTokenBase, SPT_tokenI {
    address owner;
    string public name;
    string public symbol;
    uint256 public decimals = 18; // standard token precision. override to customize

    constructor(address owner_, string name_, string symbol_) public DSTokenBase(0) {
        if(owner_ == address(0)) owner = msg.sender;
        else owner = owner_;

        name = name_;
        symbol = symbol_;
    }

    event Mint(address indexed guy, uint wad);
    event Burn(address indexed guy, uint wad);

    function setOwner(address owner_) public onlyOwner {owner = owner_;}

    function getOwner() public view returns(address) {return owner;}

    function mint(uint wad) public {
        mint(msg.sender, wad);
    }
    function burn(uint wad) public {
        burn(msg.sender, wad);
    }
    function mint(address guy, uint wad) public onlyOwner {
        _balances[guy] = add(_balances[guy], wad);
        _supply = add(_supply, wad);
        emit Mint(guy, wad);
    }
    function burn(address guy, uint wad) public onlyOwner {
        if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
            require(_approvals[guy][msg.sender] >= wad, "ds-token-insufficient-approval");
            _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
        }

        require(_balances[guy] >= wad, "ds-token-insufficient-balance");
        _balances[guy] = sub(_balances[guy], wad);
        _supply = sub(_supply, wad);
        emit Burn(guy, wad);
    }

    modifier onlyOwner() {
        require(msg.sender == owner,"");
        _;
    }
}