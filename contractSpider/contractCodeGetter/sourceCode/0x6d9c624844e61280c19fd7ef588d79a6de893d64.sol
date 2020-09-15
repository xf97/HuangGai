/**
 *Submitted for verification at Etherscan.io on 2020-06-25
*/

pragma solidity ^0.6.0;

interface TokenInterface {
    function balanceOf(address) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint256);
}


contract Resolver {

    function getBalances(address owner, address[] memory tknAddress) public view returns (uint[] memory) {
        uint[] memory tokensBal = new uint[](tknAddress.length);
        for (uint i = 0; i < tknAddress.length; i++) {
            if (tknAddress[i] == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
                tokensBal[i] = owner.balance;
            } else {
                TokenInterface token = TokenInterface(tknAddress[i]);
                tokensBal[i] = token.balanceOf(owner);
            }
        }
        return tokensBal;
    }

    function getAllowances(address owner, address spender, address[] memory tknAddress) public view returns (uint[] memory) {
        uint[] memory tokenAllowances = new uint[](tknAddress.length);
        for (uint i = 0; i < tknAddress.length; i++) {
            if (tknAddress[i] == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
                tokenAllowances[i] = 0;
            } else {
                TokenInterface token = TokenInterface(tknAddress[i]);
                tokenAllowances[i] = token.allowance(owner, spender);
            }
        }
        return tokenAllowances;
    }

}


contract InstaERC20Resolver is Resolver {

    string public constant name = "ERC20-Resolver-v1";

}