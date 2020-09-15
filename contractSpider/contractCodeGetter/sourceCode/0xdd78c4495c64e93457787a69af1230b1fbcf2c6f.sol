/**
 *Submitted for verification at Etherscan.io on 2020-06-17
*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;


struct Account {
    uint256 etherBalance;
    uint256[] tokenBalances;
}


interface ERC20Interface {
    function balanceOf(address account) external view returns (uint256 balance);
}


interface BalanceCheckerInterface {
    function balancesOf(
        ERC20Interface[] calldata tokens, address[] calldata accounts
    ) external view returns (Account[] memory accountBalances);
}


/// Quickly check the Ether balance, as well as the balance of each
/// supplied ERC20 token, for a collection of accounts.
/// @author 0age
contract BalanceChecker is BalanceCheckerInterface {
    function balancesOf(
        ERC20Interface[] calldata tokens, address[] calldata accounts
    ) external view override returns (Account[] memory) {
        Account[] memory accountBalances = new Account[](accounts.length);

        for (uint256 i = 0; i < accounts.length; i++) {
            address account = accounts[i];

            uint256[] memory tokenBalances = new uint256[](tokens.length);

            for (uint256 j = 0; j < tokens.length; j++) {
                tokenBalances[j] = tokens[j].balanceOf(account);
            }

            accountBalances[i].etherBalance = account.balance;
            accountBalances[i].tokenBalances = tokenBalances;
        }

        return accountBalances;
    }
}