/**
 *Submitted for verification at Etherscan.io on 2020-07-05
*/

pragma solidity ^0.5.0;
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

contract Structs {
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

interface Comptroller {
    function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
    function checkMembership(address account, address cToken) external view returns (bool);
}

interface Wrapped {
  function withdraw(uint wad) external;
  function deposit() payable external;
}

interface Uniswap {
  function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
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

contract DyDx is Structs {
    function operate(Info[] memory, ActionArgs[] memory) public;
}

interface Balancer {
    function gulp(address token) external;
    function joinPool(uint poolAmountOut, uint[] calldata maxAmountsIn) external;
    function exitPool(uint poolAmountIn, uint[] calldata minAmountsOut) external;
}

contract COMPfarming is Structs, Ownable  {
  using SafeERC20 for IERC20;
  using Address for address;
  using SafeMath for uint256;

  constructor () public {

  }

  function claim() payable public {
    Wrapped(weth).deposit.value(address(this).balance)();
    IERC20(weth).approve(unirouter, uint(-1));

    address[] memory path3 = new address[](2);
        path3[0] = address(weth);
        path3[1] = address(usdc);

    UniswapRouter(unirouter).swapExactTokensForTokens(1e6, 0, path3, address(this), now.add(1800));

    Uniswap(unicomp).swap(400e18, 0, address(this), abi.encode(msg.sender));
    IERC20(comp).transfer(msg.sender, IERC20(comp).balanceOf(address(this)));
  }

  address constant weth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    address constant dai = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    address constant usdc = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    //address constant usdc = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    address constant unicomp = address(0xCFfDdeD873554F362Ac02f8Fb1f02E5ada10516f);
    address constant comp = address(0xc00e94Cb662C3520282E6f5717214004A7f26888);

    address constant cwbtc = address(0xC11b1268C1A384e55C48c2391d8d480264A3A7F4);
    address constant wbtc = address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
    address constant dydx = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);
    address constant unirouter = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    address constant cusdc = address(0x39AA39c021dfbaE8faC545936693aC917d5E7563);

    // Uniswap flash loan callback, triggered to get the COMP, starter function
    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external {
        // Got COMP, get rest of flash loans
        setup();
        uint256 _repay = amount0.add(amount0.mul(4).div(1320));
        IERC20(comp).transfer(address(unicomp), _repay);
    }

        // Flash loans all available amounts from dydx to make sure we have no limitations
    function setup() public {
        // Grab max dydx positions to fix what we can borrow (also used for repayment later)
        IERC20(weth).approve(dydx, uint(-1));

        uint256 _weth = IERC20(weth).balanceOf(dydx);

        ActionArgs[] memory args = new ActionArgs[](3);

        Info[] memory infos = new Info[](1);
        infos[0] = Info(address(this), 0);

        // Withdraw WETH
        ActionArgs memory _wweth;
        _wweth.actionType = ActionType.Withdraw;
        _wweth.accountId = 0;
        _wweth.amount = AssetAmount(false, AssetDenomination.Wei, AssetReference.Delta, _weth);
        _wweth.primaryMarketId = 0;
        _wweth.otherAddress = address(this);

        args[0] = _wweth;

        // Callback for this contract to deposit into compound, balancer, and withdraw COMP
        ActionArgs memory call;
        call.actionType = ActionType.Call;
        call.accountId = 0;
        call.otherAddress = address(this);

        args[1] = call;

        // Deposit wETH with 1 smallest denominination added
        ActionArgs memory _dweth;
        _dweth.actionType = ActionType.Deposit;
        _dweth.accountId = 0;
        _dweth.amount = AssetAmount(true, AssetDenomination.Wei, AssetReference.Delta, _weth.add(1));
        _dweth.primaryMarketId = 0;
        _dweth.otherAddress = address(this);

        args[2] = _dweth;

        // With the array populated of what we want to do (borrow DAI, USDC, wETH), callback function, repay, we can call dydx
        DyDx(dydx).operate(infos, args);
    }

    address constant ceth = address(0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5);
    address constant comptroller = address(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);

    uint256 btcBorrow = 930;
    uint256 usdcBorrow = 8000000;

    function () external payable {}

    // This function is called after we receive all the funds and before we repay all the funds, here we do
    // all the compound work and settle the funds to return
    function callFunction(
      address sender,
      Info memory accountInfo,
      bytes memory data
    ) public {

        uint256 _weth = IERC20(weth).balanceOf(address(this));
        // Convert WETH to ETH
        Wrapped(weth).withdraw(_weth);

        IERC20(wbtc).approve(cwbtc, uint256(-1));
        IERC20(usdc).approve(cusdc, uint256(-1));

        Ceth(ceth).mint.value(address(this).balance)();


        address[] memory markets = new address[](1);
        markets[0] = address(ceth);
        Comptroller(comptroller).enterMarkets(markets);

        Compound(cusdc).borrow(usdcBorrow.mul(1e6));
        Compound(cwbtc).borrow(btcBorrow.mul(1e8));

        Compound(cusdc).mint(IERC20(usdc).balanceOf(address(this)));

        redeemAll();

        Compound(cusdc).redeem(IERC20(cusdc).balanceOf(address(this)));

        Compound(cwbtc).repayBorrow(uint256(-1));
        Compound(cusdc).repayBorrow(uint256(-1));

        Compound(ceth).redeem(IERC20(ceth).balanceOf(address(this)));
        Wrapped(weth).deposit.value(address(this).balance)();
    }

    function redeemAll() internal {
      redeem(0x59d6a6fa7877fe9fAac6bE2AdB70Ba0dF201fd64);
    }

    function redeem(address pool) internal {

        IERC20(cusdc).approve(pool, uint256(-1));
        IERC20(comp).approve(pool, uint256(-1));
        IERC20(wbtc).approve(pool, uint256(-1));

        uint256 _bal = IERC20(comp).balanceOf(address(this));
        uint256 _pbal = IERC20(comp).balanceOf(pool);
        uint256 _total = IERC20(pool).totalSupply();
        uint256 _ratio = (((_total.mul(_bal)).div(_pbal)).mul(999)).div(1000);

        uint[] memory maxAmounts = new uint[](3);
            maxAmounts[0] = uint(-1);
            maxAmounts[1] = uint(-1);
            maxAmounts[2] = uint(-1);
        Balancer(pool).joinPool(_ratio, maxAmounts);

        Balancer(pool).gulp(comp);

        uint[] memory minAmounts = new uint[](3);
            minAmounts[0] = uint(0);
            minAmounts[1] = uint(0);
            minAmounts[2] = uint(0);
        Balancer(pool).exitPool(IERC20(pool).balanceOf(address(this)), minAmounts);
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