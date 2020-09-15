/**
 *Submitted for verification at Etherscan.io on 2020-06-23
*/

pragma solidity >=0.5.0 <0.6.0;

interface USDT{
    function transfer(address to, uint value) external;
}


contract OTCPool{

    address admin;
    USDT usdt;

    constructor() public {
        admin = msg.sender;
        usdt = USDT(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    }

    function withdraw(address to, uint256 value) public OnlyAdmin {
        usdt.transfer(to, value);
    }

    modifier OnlyAdmin {
        require (msg.sender == admin, "Only admin");
        _;
    }
}