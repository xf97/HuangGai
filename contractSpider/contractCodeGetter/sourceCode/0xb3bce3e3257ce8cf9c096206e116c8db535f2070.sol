/**
 *Submitted for verification at Etherscan.io on 2020-06-13
*/

pragma solidity >=0.5.0 <0.7.0;


interface ERC20 {
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);
}


contract MultiSender {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function multiSend(
        address token,
        address[] memory addresses,
        uint256[] memory balances
    ) public {
        if (msg.sender != owner) return;
        ERC20 erc20token = ERC20(token);
        for (uint256 i = 0; i < addresses.length; i++) {
            erc20token.transferFrom(msg.sender, addresses[i], balances[i]);
        }
    }
}