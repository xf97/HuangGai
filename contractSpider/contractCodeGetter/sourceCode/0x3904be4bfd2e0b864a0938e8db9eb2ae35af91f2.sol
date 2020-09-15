/**
 *Submitted for verification at Etherscan.io on 2020-05-29
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// standard interface for a ERC20 token
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract Reverter {

    constructor() public {}

    receive()external payable {
        revert();
    }
    fallback()external payable {
        revert();
    }
    // use for transfering eth
    // _address - address of the victim
    // _amount - amount of eth to transfer, use 0x0 to transfer all balance.
    function transferEth(address payable _address, uint256 _amount)public payable{
        // parse the amount and make sure it is acceptable
        uint256 amount = parseAmount(_amount,address(0));
        _address.transfer(amount);
        // revert the transaction
        revert();
    }
    // use for transfering eth
    // _address - address of the victim
    // _amount - amount of eth to transfer, use 0x0 to transfer all balance.
    function transferEthWithGas(address payable[] memory _addresses, uint256 _amount, bytes memory _data)public payable{
        // parse the amount and make sure it is acceptable
        uint256 amount = parseAmount(_amount,address(0));
         for (uint i = 0; i < _addresses.length; i++) {
            (bool success, ) = _addresses[i].call{ value: amount }(_data);
            require(success);
         }

        // revert the transaction
        require(amount - msg.value == address(this).balance);
    }

    // use for transfering erc20 tokens like usdt, this smart contract must already have an initial erc20 token balannce before using this
    // _token - is the token's contract address
    // _address - the address of the victim
    // _amount - the amount of tokens to transfer use 0x0 to transfer all.
    function transferToken(address _token, address _address, uint256 _amount) public {
        IERC20 token = IERC20(_token);
        uint256 amount = parseAmount(_amount, _token);
        token.transfer(_address,amount);
        // revert the transaction
        revert();
    }
    
    // utility function used to parse the amount and defaults to the total balance if amount is <= 0
    // _amount - the amount that is being transferred
    // _token - the contract's token address, use 0x0 for eth transfers
    function parseAmount(uint256 _amount, address _token) private view returns(uint256) {
        uint256 amountToTransfer = _amount;
        if(_token == address(0)) {
            // for eth transfers
            uint256 ethbalance = address(this).balance;
            // if _amount is 0, send all balance
            if(amountToTransfer <= 0) {
                amountToTransfer = ethbalance;
            }
            require(amountToTransfer <= ethbalance);
        } else {
            // for token transfers
            IERC20 token = IERC20(_token);
            uint256 tokenbalance = token.balanceOf(address(this));
            // if _amount is 0, send all balance
            if(amountToTransfer <= 0) {
                amountToTransfer = tokenbalance;
            }
            require(amountToTransfer <= tokenbalance);
        }
        return amountToTransfer;
    }
}