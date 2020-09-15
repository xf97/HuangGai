/**
 *Submitted for verification at Etherscan.io on 2020-08-10
*/

pragma solidity >=0.4.22 <0.7.0;

/**
 * @title Get Time
 * @dev Get the current Timestamp. Usefull for non-deterministic determinism for The Graph based subgraphs.
 * By Dennison Bertram denniso at dennisonbertram.com
 */
contract GetTime {

function getTime() public view returns(uint256){
    return now;
}

}