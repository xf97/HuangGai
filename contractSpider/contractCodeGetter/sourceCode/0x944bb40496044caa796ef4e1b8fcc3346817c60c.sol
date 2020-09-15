/**
 *Submitted for verification at Etherscan.io on 2020-07-04
*/

pragma solidity ^0.5.0;

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () internal {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }
    function owner() public view returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint;

    mapping (address => uint) private _balances;

    mapping (address => mapping (address => uint)) private _allowances;

    uint private _totalSupply;
    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }
    function balanceOf(address account) public view returns (uint) {
        return _balances[account];
    }
    function transfer(address recipient, uint amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function allowance(address owner, address spender) public view returns (uint) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function increaseAllowance(address spender, uint addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _transfer(address sender, address recipient, uint amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }
    function _mint(address account, uint amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
    function _burn(address account, uint amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
    function _approve(address owner, address spender, uint amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    function _burnFrom(address account, uint amount) internal {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
    }
}

contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
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
}

contract ReentrancyGuard {
    uint private _guardCounter;

    constructor () internal {
        _guardCounter = 1;
    }

    modifier nonReentrant() {
        _guardCounter += 1;
        uint localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint a, uint b) internal pure returns (uint) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint a, uint b) internal pure returns (uint) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
    function mod(uint a, uint b) internal pure returns (uint) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }
    function sendValue(address payable recipient, uint amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

library SafeERC20 {
    using SafeMath for uint;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface AaveToken {
    function underlyingAssetAddress() external returns (address);
}

interface Oracle {
    function getAssetPrice(address reserve) external view returns (uint);
    function latestAnswer() external view returns (uint);
}

interface LendingPoolAddressesProvider {
    function getLendingPool() external view returns (address);
    function getLendingPoolCore() external view returns (address);
    function getPriceOracle() external view returns (address);
}

interface UniswapRouter {
  function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
  ) external returns (uint amountA, uint amountB, uint liquidity);
  function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function factory() external view returns (address);
}
interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

contract SupplyToken is ERC20, ERC20Detailed, Ownable {
  using SafeERC20 for IERC20;
  using Address for address;
  using SafeMath for uint;

  constructor (
      string memory name,
      string memory symbol,
      uint8 decimals
  ) public ERC20Detailed(name, symbol, decimals) {}

  function mint(address account, uint amount) public onlyOwner {
      _mint(account, amount);
  }
  function burn(address account, uint amount) public onlyOwner {
      _burn(account, amount);
  }
}

contract StableAMM is ERC20, ERC20Detailed, ReentrancyGuard {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint;

    address public constant aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    address public constant link = address(0xF79D6aFBb6dA890132F9D7c355e3015f15F3406F);
    address public constant unirouter = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    mapping (address => address) public tokens;

    constructor () public ERC20Detailed("Aave AMM USD", "aUSD", 18) {}

    function getAaveOracle() public view returns (address) {
        return LendingPoolAddressesProvider(aave).getPriceOracle();
    }

    function getReservePriceETH(address reserve) public view returns (uint) {
        return Oracle(getAaveOracle()).getAssetPrice(reserve);
    }

    function getReservePriceUSD(address reserve) public view returns (uint) {
        return getReservePriceETH(reserve).mul(Oracle(link).latestAnswer());
    }

    function deposit(address aaveToken, uint amount) external nonReentrant {
        IERC20(aaveToken).safeTransferFrom(msg.sender, address(this), amount);
        address reserve = AaveToken(aaveToken).underlyingAssetAddress();
        // 26 decimals, 18 for ETH 8 for USD
        uint value = getReservePriceUSD(reserve).mul(amount).div(1e26);
        _mint(address(this), value); // Amount of aUSD to mint

        IERC20(aaveToken).safeApprove(unirouter, 0);
        IERC20(aaveToken).safeApprove(unirouter, amount);

        IERC20(address(this)).safeApprove(unirouter, 0);
        IERC20(address(this)).safeApprove(unirouter, value);

        (, , uint liquidity) = UniswapRouter(unirouter).addLiquidity(
            aaveToken,
            address(this),
            amount,
            value,
            0,
            0,
            address(this),
            now.add(1800)
        );

        address pair = IUniswapV2Factory(UniswapRouter(unirouter).factory()).getPair(aaveToken, address(this));
        if (tokens[pair] == address(0)) {
          tokens[pair] = address(new SupplyToken(
            string(abi.encodePacked("Aave ",ERC20Detailed(pair).name())),
            string(abi.encodePacked("a",ERC20Detailed(pair).symbol())),
            ERC20Detailed(pair).decimals()
          ));
        }
        SupplyToken(tokens[pair]).mint(msg.sender, liquidity);
    }

    function withdraw(address aaveToken, uint amount) external nonReentrant {
      address pair = IUniswapV2Factory(UniswapRouter(unirouter).factory()).getPair(aaveToken, address(this));
      SupplyToken(tokens[pair]).burn(msg.sender, amount);

      IERC20(pair).safeApprove(unirouter, 0);
      IERC20(pair).safeApprove(unirouter, amount);
      
      (uint amountA, uint amountB) = UniswapRouter(unirouter).removeLiquidity(
          aaveToken,
          address(this),
          amount,
          0,
          0,
          address(this),
          now.add(1800)
      );
      address reserve = AaveToken(aaveToken).underlyingAssetAddress();
      uint value = getReservePriceUSD(reserve).mul(amount).div(1e26);
      if (value > amountB) {
        value = amountB;
      }
      _burn(address(this), value); // Amount of aUSD to mint
      IERC20(aaveToken).safeTransfer(msg.sender, amountA);
      if (amountB > value) {
        IERC20(address(this)).transfer(msg.sender, amountB.sub(value));
      }
    }
}