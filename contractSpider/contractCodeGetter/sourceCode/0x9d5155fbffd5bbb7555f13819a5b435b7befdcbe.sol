pragma solidity <= 0.5.4;

import 'SafeMath.sol';
import 'Ownable.sol';
import 'Address.sol';
import 'IERC20.sol';

contract TristersLightCoin is Ownable, IERC20 {

    using SafeMath for uint256;
    using Address for address;

    string public constant name = 'Trister’s Light Coin';
    string public constant symbol = 'Trister';
    uint256 public constant decimals = 18;
    uint256 public constant totalSupply = 8000 * 10000 * 10 ** decimals;

    uint256 public constant FounderAllocation = 500 * 10000 * 10 ** decimals;
    uint256 public constant FounderLockupAmount = 300 * 10000 * 10 ** decimals;
    uint256 public constant FounderLockupCliff = 180 days;
    uint256 public constant FounderReleaseInterval = 30 days;
    uint256 public constant FounderReleaseAmount = 50 * 10000 * 10 ** decimals;

    address public founder = address(0);
    uint256 public founderLockupStartTime = 0;
    uint256 public founderReleasedAmount = 0;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed from, address indexed to, uint256 value);
    event ChangeFounder(address indexed previousFounder, address indexed newFounder);
    event SetMinter(address indexed minter);

    constructor(address _founder, address _operator) public {
        require(_founder != address(0), "TristersLightCoin: founder is the zero address");
        require(_operator != address(0), "TristersLightCoin: operator is the zero address");
        founder = _founder;
        founderLockupStartTime = block.timestamp;
        _balances[address(this)] = totalSupply;
        _transfer(address(this), _operator, FounderAllocation.sub(FounderLockupAmount));
    }

    function release() public {
        uint256 currentTime = block.timestamp;
        uint256 cliffTime = founderLockupStartTime.add(FounderLockupCliff);
        if (currentTime < cliffTime) return;
        if (founderReleasedAmount >= FounderLockupAmount) return;
        uint256 month = currentTime.sub(cliffTime).div(FounderReleaseInterval);
        uint256 releaseAmount = month.mul(FounderReleaseAmount);
        if (releaseAmount > FounderLockupAmount) releaseAmount = FounderLockupAmount;
        if (releaseAmount <= founderReleasedAmount) return;
        uint256 amount = releaseAmount.sub(founderReleasedAmount);
        founderReleasedAmount = releaseAmount;
        _transfer(address(this), founder, amount);
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address from, address to) public view returns (uint256) {
        return _allowances[from][to];
    }

    function approve(address to, uint256 amount) public returns (bool) {
        _approve(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        uint256 remaining = _allowances[from][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance");

        _transfer(from, to, amount);
        _approve(from, msg.sender, remaining);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _balances[from] = _balances[from].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[to] = _balances[to].add(amount);
        emit Transfer(from, to, amount);
    }

    function _approve(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: approve from the zero address");
        require(to != address(0), "ERC20: approve to the zero address");

        _allowances[from][to] = amount;
        emit Approval(from, to, amount);
    }

    function changeFounder(address _founder) public onlyOwner {
        require(_founder != address(0), "TristersLightCoin: founder is the zero address");

        emit ChangeFounder(founder, _founder);
        founder = _founder;
    }

    function setMinter(address minter) public onlyOwner {
        require(minter != address(0), "TristersLightCoin: minter is the zero address");
        require(minter.isContract(), "TristersLightCoin: minter is not contract");
        _transfer(address(this), minter, totalSupply.sub(FounderAllocation));
        emit SetMinter(minter);
    }

}