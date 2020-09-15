/**
 *Submitted for verification at Etherscan.io on 2020-07-17
*/

// SPDX-License-Identifier: Leafan.Chan

pragma solidity ^0.6.0;


/**
 * @author  Leafan.Chan <leafan@qq.com>
 *
 * @dev     Contract for imtoken dapp test
 *
 * @notice  Use it for your own risk
 */


/**
 * @title EIP20NonStandardInterface
 * @dev Version of ERC20 with no return values for `transfer` and `transferFrom`
 *  See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
 */
interface EIP20NonStandardInterface {

    /**
     * @notice Get the total number of tokens in circulation
     */
    function totalSupply() external view returns (uint256);

    /**
     * @notice Gets the balance of the specified address
     * @param owner The address from which the balance will be retrieved
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    ///
    /// !!!!!!!!!!!!!!
    /// !!! NOTICE !!! `transfer` does not return a value, in violation of the ERC-20 specification
    /// !!!!!!!!!!!!!!
    ///

    /**
      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
      * @param dst The address of the destination account
      * @param amount The number of tokens to transfer
      */
    function transfer(address dst, uint256 amount) external;

    ///
    /// !!!!!!!!!!!!!!
    /// !!! NOTICE !!! `transferFrom` does not return a value, in violation of the ERC-20 specification
    /// !!!!!!!!!!!!!!
    ///

    /**
      * @notice Transfer `amount` tokens from `src` to `dst`
      * @param src The address of the source account
      * @param dst The address of the destination account
      * @param amount The number of tokens to transfer
      */
    function transferFrom(address src, address dst, uint256 amount) external;

    /**
      * @notice Approve `spender` to transfer up to `amount` from `src`
      * @dev This will overwrite the approval amount for `spender`
      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
      * @param spender The address of the account which may transfer tokens
      * @param amount The number of tokens that are approved
      */
    function approve(address spender, uint256 amount) external returns (bool success);

    /**
      * @notice Get the current allowance from `owner` for `spender`
      * @param owner The address of the account which owns the tokens to be spent
      * @param spender The address of the account which may transfer tokens
      */
    function allowance(address owner, address spender) external view returns (uint256 remaining);

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
}


contract MLFundTest {
    uint256 public constant etherUnit = 1e18;

    // commonly a pair should be base/quote
    // so ett is the base currency, usdt is the quote currency in our game.
    address public constant baseAddr    = 0x65eb823B91B0e17741Ef224dE3Da1ba4e439dfa7;   // ett token addr
    address public constant quoteAddr   = 0xdAC17F958D2ee523a2206206994597C13D831ec7;   // usdt token addr

    // convert token address to contract object
    EIP20NonStandardInterface public constant baseToken     = EIP20NonStandardInterface(baseAddr);
    EIP20NonStandardInterface public constant quoteToken    = EIP20NonStandardInterface(quoteAddr);

    address private _luckyPoolOwner;

    // constructor
    constructor() public {
        _luckyPoolOwner = msg.sender;
    }
    
    
    /**
     * @dev main mlfund function, deposit quote token, and return base token
     */
    function mlfund(uint256 amount) public returns(bool) {
        require(amount > 0, "amount should be greater than 0");
        uint256 testFunds = 10*etherUnit;

        require(baseToken.balanceOf(address(this)) > 0, "contract has no base token now, please retry.");

        quoteToken.transferFrom(msg.sender, _luckyPoolOwner, amount);

        // then do base token transfer
        baseToken.transfer(msg.sender, testFunds);
    }

}