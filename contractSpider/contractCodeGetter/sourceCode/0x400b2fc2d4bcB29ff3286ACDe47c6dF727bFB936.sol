import "./StandardToken.sol";
pragma solidity ^0.4.8;
contract MToken is StandardToken {
    /* Public variables of the token */
    string public name;                   //名称: eg Davie
    uint8 public decimals;                //最多的小数位数How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
    string public symbol;                 //token简称: eg DAC
    string public version = 'H0.1';       //版本

    function MToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol,address owner) {
        balances[owner] = _initialAmount; // 初始token数量给予消息发送者
        totalSupply = _initialAmount;         // 设置初始总量
        name = _tokenName;                   // token名称
        decimals = _decimalUnits;           // 小数位数
        symbol = _tokenSymbol;             // token简称
    }
   
}