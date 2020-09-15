/**
 *Submitted for verification at Etherscan.io on 2020-07-30
*/

pragma solidity ^0.5.16;

contract ImplementationResolver {

    address public owner;
    address public implementation;

    modifier onlyOwner {
        require(msg.sender == owner, 'Only owner is allowed to send this transaction');
        _;
    }

    constructor(address initialImplementation, address initialOwner) public {
        owner = initialOwner;
        implementation = initialImplementation;
    }

    function getImplementation() view public returns (address) {
        return implementation;
    }

    function changeOwnership(address newOwner) onlyOwner public {
        require(newOwner != address(0), "New owner cannot be address 0");
        owner = newOwner;
        emit NewOwner(newOwner);
    }

    function upgrade(address newImplementation) onlyOwner public {
        implementation = newImplementation;
        emit Upgraded(newImplementation);
    }

    event NewOwner(address newOwner);
    event Upgraded(address newImplementation);

}