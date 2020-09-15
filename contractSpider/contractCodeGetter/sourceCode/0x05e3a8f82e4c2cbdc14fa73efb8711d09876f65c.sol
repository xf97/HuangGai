/**
 *Submitted for verification at Etherscan.io on 2020-06-15
*/

pragma solidity ^0.6.0;

interface IERC20 {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

contract UnlimitSubscription {
    IERC20 constant XRT = IERC20(0x7dE91B204C1C737bcEe6F000AAA6569Cf7061cb7);
    IERC20 constant DAI = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    IUniswapV2Router01 constant ROUTER = IUniswapV2Router01(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    
    uint256 public priceInDAI;
    uint256 public count = 0;
    address owner;
    address dao;
    
    event Subscribed(address indexed buyer, uint256 indexed price);
    
    constructor() public {
        owner = msg.sender;
        DAI.approve(address(ROUTER), 2**255 - 1);
    }
    
    function ethXrtPath() pure internal returns(address[] memory path) {
        path = new address[](2);
        path[0] = ROUTER.WETH();
        path[1] = address(XRT);
    }
    
    function daiXrtPath() pure internal returns(address[] memory path) {
        path = new address[](3);
        path[0] = address(DAI);
        path[1] = ROUTER.WETH();
        path[2] = address(XRT);
    }
    
    function xrtDaiPath() pure internal returns(address[] memory path) {
        path = new address[](3);
        path[0] = address(XRT);
        path[1] = ROUTER.WETH();
        path[2] = address(DAI);
    }
    
    /*
     * Private functions
     */

    function setPriceInDai(uint256 _price) external {
        require(msg.sender == owner);
        priceInDAI = _price;
    }
    
    function setOwner(address _owner) external {
        require(msg.sender == owner);
        owner = _owner;
    }
    
    function setDAO(address _dao) external {
        require(msg.sender == owner);
        dao = _dao;
    }

    /*
     * Public functions
     */
    
    function currentPrice() public view returns(uint256) {
        return ROUTER.getAmountsIn(priceInDAI, xrtDaiPath())[0];
    }
    
    function subscribe(uint256 _deadline) external payable {
        require(++count <= 1000);
        uint256 price = currentPrice();
        
        emit Subscribed(msg.sender, price);
        
        if (msg.value > 0) {
            ROUTER.swapExactETHForTokens{value: msg.value}(price, ethXrtPath(), dao, _deadline);
        } else if (DAI.allowance(msg.sender, address(this)) >= priceInDAI) {
            require(DAI.transferFrom(msg.sender, address(this), priceInDAI));
            ROUTER.swapExactTokensForTokens(priceInDAI, price, daiXrtPath(), dao, _deadline);
        } else {
            require(XRT.transferFrom(msg.sender, dao, price));
        }
    }
}