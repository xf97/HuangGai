/**
 *Submitted for verification at Etherscan.io on 2020-05-29
*/

pragma solidity ^0.5.0;

// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    // function safeTransferETH(address to, uint value) internal {
    //     (bool success,) = to.call{value:value}(new bytes(0));
    //     require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    // }
}

interface IUniswapV1Factory {
    function getExchange(address) external view returns (address);
}

interface IUniswapV1Exchange {
    function balanceOf(address owner) external view returns (uint);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function removeLiquidity(uint, uint, uint, uint) external returns (uint, uint);
    function tokenToEthSwapInput(uint, uint, uint) external returns (uint);
    function ethToTokenSwapInput(uint, uint) external payable returns (uint);
    // converting ERC20 to ERC20 and transfer
    function tokenToTokenSwapInput(
        uint256 tokens_sold,
        uint256 min_tokens_bought,
        uint256 min_eth_bought,
        uint256 deadline,
        address token_addr
    ) external returns (uint256 tokens_bought);
}

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

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

interface IUniswapV2Factory {
    function getPair (address tokenA, address tokenB) external view returns(address);
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
    function sub(uint256 a, uint256 b, string memory errorMessage)
        internal
        pure
        returns (uint256)
    {
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
    function div(uint256 a, uint256 b, string memory errorMessage)
        internal
        pure
        returns (uint256)
    {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage)
        internal
        pure
        returns (uint256)
    {
        require(b != 0, errorMessage);
        return a % b;
    }
}

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
    address payable public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address payable msgSender = _msgSender();
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
    function transferOwnership(address payable newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address payable newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract Uni_V1_V2_Pipe is Ownable {
    using SafeMath for uint;
    bool private stopped = false;
    uint16 public goodwill;
    address public dzgoodwillAddress;
    
    event liquidityTokensQty(uint, address, uint);
    
    IUniswapV1Factory public factoryV1;
    IUniswapV2Factory public factoryV2;
    IUniswapV2Router01 public router;
    
    address WETHAddress;

    constructor(uint16 _goodwill, address _dzgoodwillAddress) public {
        goodwill = _goodwill;
        dzgoodwillAddress = _dzgoodwillAddress;
        factoryV1 = IUniswapV1Factory(address(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95));
        factoryV2 = IUniswapV2Factory(address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f));
        router = IUniswapV2Router01(address(0xf164fC0Ec4E93095b804a4795bBe1e041497b92a));
        WETHAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    }
    
    // circuit breaker modifiers
    modifier stopInEmergency {
        if (stopped) {
            revert("Temporarily Paused");
        } else {
            _;
        }
    }

    // Remove Liquidity from UNI-V1 and add to toToken-WETH UNI-V2 Pool
    function V1_to_V2_Pipe(address fromTokenAddress, uint256 uniV1Amount, address toTokenAddress, address toWhomToIssue)
        external stopInEmergency returns (uint)
    {
        IUniswapV1Exchange exchangeV1 = IUniswapV1Exchange(factoryV1.getExchange(fromTokenAddress));
        require(exchangeV1.transferFrom(msg.sender, address(this), uniV1Amount), 'TRANSFER_FROM_FAILED');
        (uint amountETHV1, uint amountTokenV1) = exchangeV1.removeLiquidity(uniV1Amount, 1, 1, now.add(180));
        
        uint256 amountToToken;
        if(fromTokenAddress != toTokenAddress) {
            amountToToken = _token2Token(
                fromTokenAddress,
                toTokenAddress,
                amountTokenV1
            );
        } else {
            amountToToken = amountTokenV1;
        }
        
        TransferHelper.safeApprove(toTokenAddress, address(router), amountToToken);
        (uint amountTokenV2, uint amountETHV2, uint liquidityTokens) = router.addLiquidityETH.value(amountETHV1)(
            toTokenAddress,
            amountToToken,
            1,
            1,
            address(this),
            now.add(180)
        );
        
        uint256 goodwillPortion = SafeMath.div(
            SafeMath.mul(liquidityTokens, goodwill),
            10000
        );
        IERC20(factoryV2.getPair(toTokenAddress, WETHAddress)).transfer(
            dzgoodwillAddress,
            goodwillPortion
        );
        IERC20(factoryV2.getPair(toTokenAddress, WETHAddress)).transfer(
            toWhomToIssue,
            SafeMath.sub(liquidityTokens, goodwillPortion)
        );
        
        if (amountToToken > amountTokenV2) {
            TransferHelper.safeTransfer(toTokenAddress, msg.sender, amountToToken - amountTokenV2);
            emit liquidityTokensQty(SafeMath.sub(liquidityTokens, goodwillPortion), toTokenAddress, amountToToken - amountTokenV2);
        } else if (amountETHV1 > amountETHV2) {
            // addLiquidityETH guarantees that all of amountETHV1 or amountTokenV1 will be used, hence this else is safe
            (msg.sender).transfer(amountETHV1 - amountETHV2);
            emit liquidityTokensQty(SafeMath.sub(liquidityTokens, goodwillPortion), address(0), amountETHV1 - amountETHV2);
        }
        return SafeMath.sub(liquidityTokens, goodwillPortion);
    }
    
    function _token2Token(
        address _FromTokenContractAddress,
        address _ToTokenContractAddress,
        uint256 tokens2Trade
    ) internal returns (uint256 tokensBought) {
        IUniswapV1Exchange FromUniSwapExchangeContractAddress = IUniswapV1Exchange(
            factoryV1.getExchange(_FromTokenContractAddress)
        );

        IERC20(_FromTokenContractAddress).approve(
            address(FromUniSwapExchangeContractAddress),
            tokens2Trade
        );

        tokensBought = FromUniSwapExchangeContractAddress.tokenToTokenSwapInput(
            tokens2Trade,
            1,
            1,
            SafeMath.add(now, 300),
            _ToTokenContractAddress
        );

        require(tokensBought > 0, "Error in swapping ERC");
    }
    
    function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
        uint256 qty = _TokenAddress.balanceOf(address(this));
        _TokenAddress.transfer(_owner, qty);
    }
    
    function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
        require(
            _new_goodwill > 0 && _new_goodwill < 10000,
            "GoodWill Value not allowed"
        );
        goodwill = _new_goodwill;
    }
    
    function set_new_dzgoodwillAddress(address _new_dzgoodwillAddress)
        public
        onlyOwner
    {
        dzgoodwillAddress = _new_dzgoodwillAddress;
    }
    
    // - to Pause the contract
    function toggleContractActive() public onlyOwner {
        stopped = !stopped;
    }
    // - to withdraw any ETH balance sitting in the contract
    function withdraw() public onlyOwner {
        _owner.transfer(address(this).balance);
    }
    // - to kill the contract
    function destruct() public onlyOwner {
        selfdestruct(_owner);
    }
    
    function() external payable {}
}