pragma solidity ^0.5.0;

import "./SafeMath.sol";

contract ConnectChainToken {
    using SafeMath for uint256;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    address private _official;
    address private _owner;
    uint256 private _cap;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    constructor(address official) public {
        _symbol = "CCTN";
        _name = "Connect Chain token";
        _decimals = 18;
        _official = official;
        _owner = msg.sender;
        _cap = 1000 * 10**uint256(_decimals);

        _totalSupply = 300000000 * 10**uint256(_decimals);
        _balances[_official] = 300000000 * 10**uint256(_decimals);

        emit Transfer(address(0), _official, _totalSupply);
    }

    function ownerAddress() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner(), "caller is not the owner");
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function officialAddress() public view returns (address) {
        return _official;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "transfer from the zero address");
        require(recipient != address(0), "transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "transfer amount exceeds balance");
        if (sender == _official) {
            _balances[recipient] = _balances[recipient].add(amount);
            emit Transfer(sender, recipient, amount);
        } else {
            uint256 fee = amount / 1000;
            if (fee > _cap) {
                fee = _cap;
            }
            require(fee > 0, "transfer amount to small");
            uint256 real = amount.sub(fee);
            _balances[recipient] = _balances[recipient].add(real);
            _balances[_official] = _balances[_official].add(fee);
            emit Transfer(sender, recipient, real);
            emit Transfer(sender, _official, fee);
        }
    }

/**********
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
***********/
    function _burn(address account, uint256 value) internal {
        require(account != address(0), "burn from the zero address");

        _balances[account] = _balances[account].sub(value, "burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(value);
        emit Transfer(account, address(0), value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "approve from the zero address");
        require(spender != address(0), "approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "burn amount exceeds allowance"));
    }

    function transferOfficial(address newOfficial) public onlyOwner {
        require(newOfficial != address(0), "official to the zero address");
        _balances[newOfficial] = _balances[newOfficial].add(_balances[_official]);
        emit OfficialTransferred(_official, newOfficial);
        emit Transfer(_official, newOfficial, _balances[_official]);
        _balances[_official] = 0;
        _official = newOfficial;
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function burnFrom(address account, uint256 amount) public {
        _burnFrom(account, amount);
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    event OfficialTransferred(address indexed previousOfficial , address indexed newOfficial);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


}
