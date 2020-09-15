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
    ICurve curve;
    IERC20 DAI;
    IERC20 sUSD;

    constructor(ICurve _curve, IERC20 _DAI, IERC20 _sUSD) public {
        curve = _curve;
        DAI = _DAI;
        sUSD = _sUSD;

        DAI.approve(msg.sender, 10000000 * 1e18);
        sUSD.approve(msg.sender, 10000000 * 1e18);
    }

    function stakeDAI(uint256 amount) external {
        DAI.approve(address(curve), amount);
        curve.exchange(0, 3, amount, 0);
    }
}