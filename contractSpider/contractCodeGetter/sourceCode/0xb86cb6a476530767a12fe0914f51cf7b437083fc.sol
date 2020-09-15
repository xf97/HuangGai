/**
 *Submitted for verification at Etherscan.io on 2020-07-04
*/

pragma solidity 0.5.17;

interface Token {
    function balanceOf(address) external view returns (uint);
}

contract GetTokenBalances {
    Token gigToken = Token(0x838d8e11B160deC88Fe62BF0f743FB7000941e13);
    
    function getBalances(address[] memory accounts) public view returns (uint[] memory _balances, address[] memory _accounts) {
        uint[] memory balances = new uint[](accounts.length);
        for (uint i = 0; i < accounts.length; i++) {
            balances[i] = gigToken.balanceOf(accounts[i]);
        }
        return (balances, accounts);
    }
}