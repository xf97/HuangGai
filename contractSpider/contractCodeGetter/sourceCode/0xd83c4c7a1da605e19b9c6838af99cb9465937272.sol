/**
 *Submitted for verification at Etherscan.io on 2020-08-18
*/

pragma solidity ^0.4.26;
contract SHRIMPTokenInterface {
    function transfer(address to, uint256 value) external returns(bool);
    function transferFrom(address from, address to, uint256 value) external returns(bool);
}

contract advertise {
    address public owner;
    uint public now_id;
    uint public ad_value;
    event Ad(uint indexed id,string content, uint amount);

    constructor()public{
        owner = msg.sender;
        now_id = 0;
        ad_value = 1e20;
    }
    function set_advalue(uint amount)public{
        require(msg.sender == owner);
        ad_value = amount;
    }
    function set_ad_noshrimp(string content)public returns (bool){
        emit Ad(now_id, content, 0);
        now_id++;
        return true;
    }
    function set_ad(string content, uint amount)public returns (bool){
        SHRIMPTokenInterface token = SHRIMPTokenInterface(0x38c4102D11893351cED7eF187fCF43D33eb1aBE6);
        token.transferFrom(msg.sender, address(this), amount);
        emit Ad(now_id, content, amount);
        now_id++;
        return true;
    }
    function withdraw_money(uint amount, address to) public returns (bool) {
        require(msg.sender == owner);
        SHRIMPTokenInterface token = SHRIMPTokenInterface(0x38c4102D11893351cED7eF187fCF43D33eb1aBE6);
        token.transfer(to, amount);
        return true;
    }
    function withdraw_eth(uint amount) public returns (bool) {
        require(msg.sender == owner);
        owner.transfer(amount);
        return true;
    }
    function withdraw_other(uint amount, address erc20) public returns (bool) {
        require(msg.sender == owner);
        SHRIMPTokenInterface token = SHRIMPTokenInterface(erc20);
        token.transfer(owner, amount);
        return true;
    }
}