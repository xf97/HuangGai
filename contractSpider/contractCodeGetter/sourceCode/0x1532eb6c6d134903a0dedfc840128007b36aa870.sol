/**
 *Submitted for verification at Etherscan.io on 2020-06-30
*/

pragma solidity ^0.6.6;
pragma experimental ABIEncoderV2;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
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

contract ReentrancyGuard {
    uint256 private _guardCounter;

    constructor () internal {
        _guardCounter = 1;
    }

    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
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

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }
    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
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

interface Structs {
    struct Val {
        uint256 value;
    }

    enum ActionType {
      Deposit,   // supply tokens
      Withdraw,  // borrow tokens
      Transfer,  // transfer balance between accounts
      Buy,       // buy an amount of some token (externally)
      Sell,      // sell an amount of some token (externally)
      Trade,     // trade tokens against another account
      Liquidate, // liquidate an undercollateralized or expiring account
      Vaporize,  // use excess tokens to zero-out a completely negative account
      Call       // send arbitrary data to an address
    }

    enum AssetDenomination {
        Wei // the amount is denominated in wei
    }

    enum AssetReference {
        Delta // the amount is given as a delta from the current value
    }

    struct AssetAmount {
        bool sign; // true if positive
        AssetDenomination denomination;
        AssetReference ref;
        uint256 value;
    }

    struct ActionArgs {
        ActionType actionType;
        uint256 accountId;
        AssetAmount amount;
        uint256 primaryMarketId;
        uint256 secondaryMarketId;
        address otherAddress;
        uint256 otherAccountId;
        bytes data;
    }

    struct Info {
        address owner;  // The address that owns the account
        uint256 number; // A nonce that allows a single address to control many accounts
    }

    struct Wei {
        bool sign; // true if positive
        uint256 value;
    }
}

interface Compound {
  function mint(uint mintAmount) external returns (uint);
  function redeem(uint redeemTokens) external returns (uint);
  function borrow(uint borrowAmount) external returns (uint);
  function repayBorrow(uint repayAmount) external returns (uint);
}

interface Ceth {
  function mint() payable external;
  function redeem(uint redeemTokens) external returns (uint);
  function borrow(uint borrowAmount) external returns (uint);
  function repayBorrow(uint repayAmount) external returns (uint);
}

interface Weth {
  function withdraw(uint256 wad) external;
  function deposit() payable external;
}

interface Uniswap {
  function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
  function token0() external view returns (address);
  function token1() external view returns (address);
}

interface UniswapRouter {
  function swapExactTokensForTokens(
  uint amountIn,
  uint amountOutMin,
  address[] calldata path,
  address to,
  uint deadline
) external returns (uint[] memory amounts);
}

interface IUniswapV2Callee {
    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
}

interface DyDx is Structs {
    function getAccountWei(Info memory account, uint256 marketId) external view returns (Wei memory);
    function operate(Info[] memory, ActionArgs[] memory) external;
}

contract COMPfarming is ReentrancyGuard, Ownable, Structs, IUniswapV2Callee  {
  using SafeERC20 for IERC20;
  using Address for address;
  using SafeMath for uint256;

  address constant public weth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
  address constant public dai = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
  address constant public usdc = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

  address constant public bat = address(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
  address constant public rep = address(0x1985365e9f78359a9B6AD760e32412f4a445E862);
  address constant public usdt = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
  address constant public wbtc = address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
  address constant public zrx = address(0xE41d2489571d322189246DaFA5ebDe1F4699F498);

  address constant public dydx = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);

  address constant public ceth = address(0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5);
  address constant public cdai = address(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
  address constant public cusdc = address(0x39AA39c021dfbaE8faC545936693aC917d5E7563);

  address constant public cbat = address(0x6C8c6b02E7b2BE14d4fA6022Dfd6d75921D90E4E);
  address constant public crep = address(0x158079Ee67Fce2f58472A96584A73C7Ab9AC95c1);
  address constant public cusdt = address(0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9);
  address constant public cwbtc = address(0xC11b1268C1A384e55C48c2391d8d480264A3A7F4);
  address constant public czrx = address(0xB3319f5D18Bc0D84dD1b4825Dcde5d5f7266d407);

  address constant public unicomp = address(0xCFfDdeD873554F362Ac02f8Fb1f02E5ada10516f);
  address constant public unirouter = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

  address constant public comp = address(0xc00e94Cb662C3520282E6f5717214004A7f26888);

  uint256 public btcBorrow = 1380;
  uint256 public batBorrow = 49000000;

  constructor () public {
    
  }

  function farm() payable public {
    IERC20(dai).approve(dydx, uint(-1));
    IERC20(usdc).approve(dydx, uint(-1));
    IERC20(weth).approve(dydx, uint(-1));

    IERC20(weth).approve(unirouter, uint(-1));

    Weth(weth).deposit.value(address(this).balance)();

    address[] memory path1 = new address[](2);
        path1[0] = address(weth);
        path1[1] = address(dai);

    UniswapRouter(unirouter).swapExactTokensForTokens(1e13, 0, path1, address(this), now.add(1800));

    address[] memory path2 = new address[](2);
        path2[0] = address(weth);
        path2[1] = address(usdc);

    UniswapRouter(unirouter).swapExactTokensForTokens(1e13, 0, path2, address(this), now.add(1800));
    Uniswap(unicomp).swap(IERC20(comp).balanceOf(address(unicomp)), 0, address(this), abi.encode(msg.sender));
  }
  
    // Uniswap flash loan callback, triggered to get the COMP, starter function
  function uniswapV2Call(address, uint amount0, uint amount1, bytes calldata) external override {
    // Got COMP, get rest of flash loans
    setup();
    IERC20(Uniswap(unicomp).token0()).transfer(unicomp, amount0);
    IERC20(Uniswap(unicomp).token1()).transfer(unicomp, amount1);
  }

  // Flash loans all available amounts from dydx to make sure we have no limitations
  function setup() public {
    Info[] memory infos = new Info[](1);
    ActionArgs[] memory args = new ActionArgs[](6);

    infos[0] = Info(address(this), 0);

    // Grab max dydx positions to fix what we can borrow (also used for repayment later)
    uint256 _dai = IERC20(dai).balanceOf(dydx);
    uint256 _usdc = IERC20(usdc).balanceOf(dydx);
    uint256 _weth = IERC20(weth).balanceOf(dydx);

    // Withdraw DAI
    ActionArgs memory _wdai;
    _wdai.actionType = ActionType.Withdraw;
    _wdai.accountId = 0;
    _wdai.amount = AssetAmount(false, AssetDenomination.Wei, AssetReference.Delta, _dai);
    _wdai.primaryMarketId = 3;
    _wdai.otherAddress = address(this);

    args[0] = _wdai;

    // Withdraw USDC
    ActionArgs memory _wusdc;
    _wusdc.actionType = ActionType.Withdraw;
    _wusdc.accountId = 0;
    _wusdc.amount = AssetAmount(false, AssetDenomination.Wei, AssetReference.Delta, _usdc);
    _wusdc.primaryMarketId = 2;
    _wusdc.otherAddress = address(this);

    args[1] = _wusdc;

    // Withdraw WETH
    ActionArgs memory _wweth;
    _wweth.actionType = ActionType.Withdraw;
    _wweth.accountId = 0;
    _wweth.amount = AssetAmount(false, AssetDenomination.Wei, AssetReference.Delta, _weth);
    _wweth.primaryMarketId = 0;
    _wweth.otherAddress = address(this);

    args[2] = _wweth;

    // Callback for this contract to deposit into compound, balancer, and withdraw COMP
    ActionArgs memory call;
    call.actionType = ActionType.Call;
    call.accountId = 0;
    call.otherAddress = address(this);

    args[3] = call;

    // Deposit DAI with 1 smallest denominination added
    ActionArgs memory _ddai;
    _ddai.actionType = ActionType.Deposit;
    _ddai.accountId = 0;
    _ddai.amount = AssetAmount(true, AssetDenomination.Wei, AssetReference.Delta, _dai.add(1));
    _ddai.primaryMarketId = 3;
    _ddai.otherAddress = address(this);

    args[4] = _ddai;

    // Deposit USDC with 1 smallest denominination added
    ActionArgs memory _dusdc;
    _dusdc.actionType = ActionType.Deposit;
    _dusdc.accountId = 0;
    _dusdc.amount = AssetAmount(true, AssetDenomination.Wei, AssetReference.Delta, _usdc.add(1));
    _dusdc.primaryMarketId = 2;
    _dusdc.otherAddress = address(this);

    args[5] = _dusdc;

    // Deposit wETH with 1 smallest denominination added
    ActionArgs memory _dweth;
    _dweth.actionType = ActionType.Deposit;
    _dweth.accountId = 0;
    _dweth.amount = AssetAmount(true, AssetDenomination.Wei, AssetReference.Delta, _weth.add(1));
    _dweth.primaryMarketId = 0;
    _dweth.otherAddress = address(this);

    args[6] = _dweth;

    // With the array populated of what we want to do (borrow DAI, USDC, wETH), callback function, repay, we can call dydx
    DyDx(dydx).operate(infos, args);
  }

  // This function is called after we receive all the funds and before we repay all the funds, here we do
  // all the compound work and settle the funds to return
  function callFunction(
      address,
      Info memory,
      bytes memory
  ) public {
    uint256 _dai = IERC20(dai).balanceOf(address(this));
    uint256 _usdc = IERC20(usdc).balanceOf(address(this));
    uint256 _weth = IERC20(weth).balanceOf(address(this));

    // Convert WETH to ETH
    Weth(weth).withdraw(_weth);

    Ceth(ceth).mint.value(address(this).balance)();
    Compound(cusdc).mint(_usdc);
    Compound(cdai).mint(_dai);

    // wBTC + cBAT
    // cUSDC + cUSDT
    // cDAI + cUSDT

    Compound(cwbtc).borrow(btcBorrow.mul(1e8));
    Compound(cbat).borrow(batBorrow.mul(1e18));

    Compound(cwbtc).mint(IERC20(wbtc).balanceOf(address(this)));
    Compound(cbat).mint(IERC20(bat).balanceOf(address(this)));

    Compound(cwbtc).redeem(IERC20(cwbtc).balanceOf(address(this)));
    Compound(cbat).redeem(IERC20(cbat).balanceOf(address(this)));

    Compound(cwbtc).repayBorrow(IERC20(wbtc).balanceOf(address(this)));
    Compound(cbat).repayBorrow(IERC20(bat).balanceOf(address(this)));

    Compound(cdai).redeem(IERC20(cdai).balanceOf(address(this)));
    Compound(cusdc).redeem(IERC20(cusdc).balanceOf(address(this)));
    Compound(ceth).redeem(IERC20(ceth).balanceOf(address(this)));

    Weth(weth).deposit.value(address(this).balance)();
  }

  // incase of half-way error
  function inCaseTokenGetsStuck(IERC20 _TokenAddress) onlyOwner public {
      uint qty = _TokenAddress.balanceOf(address(this));
      _TokenAddress.safeTransfer(msg.sender, qty);
  }

  // incase of half-way error
  function inCaseETHGetsStuck() onlyOwner public{
      (bool result, ) = msg.sender.call.value(address(this).balance)("");
      require(result, "transfer of ETH failed");
  }
}