/**
 *Submitted for verification at Etherscan.io on 2020-06-02
*/

pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;


interface IChi {
    function freeUpTo(uint256 value) external returns (uint256 freed);
    function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
}


contract ChiSpender {
    IChi public constant chi = IChi(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);

    address public owner = msg.sender;

    function burnChi(uint gasSpent) external {
        require(msg.sender == owner, "Access restricted");
        chi.freeFromUpTo(tx.origin, (gasSpent + 14154) / 41130);
    }
}