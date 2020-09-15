/**
 *Submitted for verification at Etherscan.io on 2020-05-19
*/

pragma solidity 0.6.8;

interface UniswapFactory {
    function getExchange(address token) external view returns(address exchange);
}

interface Uniswap {
    function getEthToTokenInputPrice(uint256 eth_sold) external view returns(uint256);
}

contract Token {
    function ethRate() public view returns(uint256) {
        return Uniswap(UniswapFactory(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95).getExchange(0x6B175474E89094C44Da98b954EedeAC495271d0F)).getEthToTokenInputPrice(1 ether) / 1e18;
    }
}