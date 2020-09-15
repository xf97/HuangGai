/**
 *Submitted for verification at Etherscan.io on 2020-05-27
*/

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/GSN/Context.sol

pragma solidity ^0.5.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
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

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: contracts/interfaces/IUniswapV2Router01.sol

pragma solidity ^0.5.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

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
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// File: contracts/interfaces/IUniswapV2Pair.sol

pragma solidity ^0.5.2;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// File: contracts/IUSO.sol

pragma solidity ^0.5.2;






/**
* @title IUSO
* @author Tal Beja
*/
contract IUSO is Ownable {
  using SafeMath for uint256;
  using SafeMath for uint32;

  uint256 public liquidityPercent = 14;
  uint256 public buyinPercent = 1;

  address public uniswapRouterAddress = 0xf164fC0Ec4E93095b804a4795bBe1e041497b92a;
  address public fuseETHPairAddress = 0x4Ce3687fEd17e19324F23e305593Ab13bBd55c4D;

  address public fuseTokenAddress = 0x970B9bB2C0444F5E81e9d0eFb84C8ccdcdcAf84d;
  address public wethTokenAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

  address payable public fusePoolAddress = 0x1ce78dbc91f96Cf4a87B37F7711113289243889a;

  IUniswapV2Router01 public uniswapRouter = IUniswapV2Router01(uniswapRouterAddress);
  IUniswapV2Pair public fuseETHPair = IUniswapV2Pair(fuseETHPairAddress);
  IERC20 public fuseToken = IERC20(fuseTokenAddress);
  
  function setLiquidityPercent(uint256 _liquidityPercent) external onlyOwner {
    require (_liquidityPercent <= 100 - buyinPercent, "_liquidityPercent too big");
    liquidityPercent = _liquidityPercent;
  }

  function setBuyinPercent(uint256 _buyinPercent) external onlyOwner {
    require (_buyinPercent <= 100 - liquidityPercent, "_buyinPercent too big");
    buyinPercent = _buyinPercent;
  }

  function setUniswapRouterAddress(address _uniswapRouterAddress) external onlyOwner {
    require (_uniswapRouterAddress != address(0), "_uniswapRouterAddress cannot be 0");
    uniswapRouterAddress = _uniswapRouterAddress;
    uniswapRouter = IUniswapV2Router01(uniswapRouterAddress);
  }

  function setFuseETHPairAddress(address _fuseETHPairAddress) external onlyOwner {
    require (_fuseETHPairAddress != address(0), "_fuseETHPairAddress cannot be 0");
    fuseETHPairAddress = _fuseETHPairAddress;
    fuseETHPair = IUniswapV2Pair(fuseETHPairAddress);
  }

  function setFuseTokenAddress(address _fuseTokenAddress) external onlyOwner {
    require (_fuseTokenAddress != address(0), "_fuseTokenAddress cannot be 0");
    fuseTokenAddress = _fuseTokenAddress;
    fuseToken = IERC20(fuseTokenAddress);
  }

  function setWethTokenAddress(address _wethTokenAddress) external onlyOwner {
    require (_wethTokenAddress != address(0), "_wethTokenAddress cannot be 0");
    wethTokenAddress = _wethTokenAddress;
  }

  function setFusePoolAddress(address payable _fusePoolAddress) external onlyOwner {
    require (_fusePoolAddress != address(0), "_fusePoolAddress cannot be 0");
    fusePoolAddress = _fusePoolAddress;
  }

  function getTokenPayoutAmounts(uint256 _ethAmount) external view returns (
    uint256 fuseAmount,
    uint256 ethBuyinAmount,
    uint256 ethLiquidityAmount,
    uint256 ethToTeamAmount,
    uint256 fuseBuyoutAmount,
    uint256 fuseLiquidityAmount,
    uint256 fuseFromTeamAmount
  ) {
    uint256 fuseReserve;
    uint256 ethReserve;

    (fuseReserve, ethReserve, ) = fuseETHPair.getReserves();
    uint256 fuse2eth1 = fuseReserve.div(ethReserve);

    ethLiquidityAmount = _ethAmount.mul(liquidityPercent).div(100);
    fuseLiquidityAmount = uniswapRouter.quote(ethLiquidityAmount, ethReserve, fuseReserve);

    ethBuyinAmount = _ethAmount.mul(buyinPercent).div(100);
    ethToTeamAmount = _ethAmount.sub(ethLiquidityAmount).sub(ethBuyinAmount);

    fuseReserve = fuseReserve.add(fuseLiquidityAmount);
    ethReserve = ethReserve.add(ethLiquidityAmount);

    fuseBuyoutAmount = uniswapRouter.getAmountOut(ethBuyinAmount, ethReserve, fuseReserve);

    fuseReserve = fuseReserve.sub(fuseBuyoutAmount);
    ethReserve = ethReserve.add(ethBuyinAmount);

    uint256 fuse2eth2 = fuseReserve.div(ethReserve);
    uint256 fuse2eth = fuse2eth1.add(fuse2eth2).div(2);

    fuseAmount = _ethAmount.mul(fuse2eth);
    fuseFromTeamAmount = fuseAmount.sub(fuseBuyoutAmount);
  }

  function () external payable  {
    if (msg.sender == uniswapRouterAddress) {
      return fusePoolAddress.transfer(msg.value);
    }

    address[] memory weth2fusePath = new address[](2);
    weth2fusePath[0] = wethTokenAddress;
    weth2fusePath[1] = fuseTokenAddress;

    uint256 fuseReserve;
    uint256 ethReserve;

    (fuseReserve, ethReserve, ) = fuseETHPair.getReserves();
    uint256 fuse2eth1 = fuseReserve.div(ethReserve);

    uint256 ethLiquidityAmount = msg.value.mul(liquidityPercent).div(100);
    uint256 fuseLiquidityAmount = uniswapRouter.quote(ethLiquidityAmount, ethReserve, fuseReserve);

    uint256 ethBuyinAmount = msg.value.mul(buyinPercent).div(100);
    uint256 ethToTeamAmount = msg.value.sub(ethLiquidityAmount).sub(ethBuyinAmount);

    fuseToken.transferFrom(fusePoolAddress, address(this), fuseLiquidityAmount);
    fuseToken.approve(uniswapRouterAddress, fuseLiquidityAmount);

    uniswapRouter.addLiquidityETH.value(ethLiquidityAmount)(
      fuseTokenAddress,
      fuseLiquidityAmount,
      fuseLiquidityAmount.mul(99).div(100),
      uniswapRouter.quote(fuseLiquidityAmount, fuseReserve, ethReserve),
      fusePoolAddress,
      block.timestamp
    );

    (fuseReserve, ethReserve, ) = fuseETHPair.getReserves();
    uint256 fuseBuyoutAmount = uniswapRouter.getAmountOut(ethBuyinAmount, ethReserve, fuseReserve);

    (uint[] memory amounts) = uniswapRouter.swapExactETHForTokens.value(ethBuyinAmount)(
      fuseBuyoutAmount,
      weth2fusePath,
      msg.sender,
      block.timestamp
    );

    (fuseReserve, ethReserve, ) = fuseETHPair.getReserves();
    uint256 fuse2eth2 = fuseReserve.div(ethReserve);

    uint256 fuse2eth = fuse2eth1.add(fuse2eth2).div(2);
    uint256 fuseFromTeamAmount = msg.value.mul(fuse2eth).sub(amounts[1]);
    fusePoolAddress.transfer(ethToTeamAmount);
    require(fuseToken.transferFrom(fusePoolAddress, msg.sender, fuseFromTeamAmount));
  }
}