/**
 *Submitted for verification at Etherscan.io on 2020-06-26
*/

pragma solidity 0.6.7;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
}

interface CToken {
    function mint(uint mintAmount) external returns (uint);
    function redeemUnderlying(uint redeemAmount) external returns (uint);
    function underlying() external returns (IERC20);
}

contract LinenWalletActions {
    function approveAndMint(CToken cToken, uint mintAmount) public returns (bool) {
        require(cToken.underlying().approve(address(cToken), mintAmount), "Approval was not successful");
        require(cToken.mint(mintAmount) == 0, "Mint was not successful");
        return true;
    }

    function redeemUnderlyingAndTransfer(CToken cToken, address to, uint redeemAmount) public returns (bool) {
        require(cToken.redeemUnderlying(redeemAmount) == 0, "Redeem Underlying was not successful");
        require(cToken.underlying().transfer(to, redeemAmount), "Transfer was not successful");
        return true;
    }
}