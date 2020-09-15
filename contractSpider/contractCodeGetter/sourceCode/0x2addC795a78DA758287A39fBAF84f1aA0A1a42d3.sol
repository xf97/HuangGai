/**
 *Submitted for verification at Etherscan.io on 2020-06-17
*/

pragma solidity ^0.6.8;

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

interface ICurve {
    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy
    )
        external;

    function exchange_underlying(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy
    )
        external;
}

contract CurveWrapper {
    ICurve public curve;
    IERC20 public DAI;
    IERC20 public sUSD;

    event ExchangeDaiTosUSD(uint256 from, uint256 to);

    constructor(ICurve _curve, IERC20 _DAI, IERC20 _sUSD) public {
        curve = _curve;
        DAI = _DAI;
        sUSD = _sUSD;

        DAI.approve(msg.sender, 10000000 * 1e18);
        sUSD.approve(msg.sender, 10000000 * 1e18);
    }

    function exchangeDaiTosUSD(uint256 amount) external {
        require(DAI.allowance(msg.sender, address(this)) < amount, 'Not Allowed');
        uint256 balance = DAI.balanceOf(msg.sender);
        require(balance >= amount, 'Insufficient Dai');
        require(DAI.transferFrom(msg.sender, address(this), amount), 'Failed Deposit Dai');
        DAI.approve(address(curve), amount);
        uint256 sUSDBalance = sUSD.balanceOf(address(this));
        curve.exchange(0, 3, amount, 0);
        uint256 result = sUSD.balanceOf(address(this)) - sUSDBalance;
        require(result <= sUSD.balanceOf(address(this)) && result > 0, 'Invalid Status');
        sUSD.transfer(msg.sender, result);

        emit ExchangeDaiTosUSD(amount, result);
    }
}