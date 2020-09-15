/**
 *Submitted for verification at Etherscan.io on 2020-07-27
*/

pragma solidity ^0.5.17;

/**
 * 
 * Vision Network Burn event
 * 
 * Simple contract to BURN VSN tokens forever, after holding them for a day.
 * Smart contract by community member George.
 * https://www.vision-network.io/
 * 
 */
 
contract Burn {
    
    ERC20 constant VSN = ERC20(0x456AE45c0CE901E2e7c99c0718031cEc0A7A59Ff);
    
    uint256 public timer;

    event tokensBurnt(uint256 tokens);
    
    
    /**
     * Set the timer after the VSN have entered the contract.
     * The timer will expire 24 hours after calling this function, enabling burn()
     * Anyone can call this function.
     */
    function setTimer() external {
        require(timer == 0);
        require(VSN.balanceOf(address(this)) > 0);
        timer = now + 24 hours;
    } 
    
    /**
     * Burn the VSN tokens after the timer has expired. Anyone can call this function.
     */
    function burn() external {
        require(timer != 0  && now > timer);
        uint256 balance = VSN.balanceOf(address(this));
        VSN.transfer(address(0), balance);
        emit tokensBurnt(balance);
        timer = 0;
    } 
    
    
}


interface ERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address who) external view returns (uint256);
  function allowance(address owner, address spender) external view returns (uint256);
  function transfer(address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  function approveAndCall(address spender, uint tokens, bytes calldata data) external returns (bool success);
  function transferFrom(address from, address to, uint256 value) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}