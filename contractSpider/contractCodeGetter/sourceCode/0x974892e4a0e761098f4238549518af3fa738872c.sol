/**
 *Submitted for verification at Etherscan.io on 2020-08-15
*/

pragma solidity ^0.5.17;

contract FixTendiesFarm {

    mapping (address => uint256) didBurn;
    
    address constant owner = 0x4BC821fef2ff947B57585a5FDBC73690Db288A49;

    function recordBurn() external {
        require(didBurn[msg.sender] == 0);
        didBurn[msg.sender] = 1;
    }

    function recordBurnOther(address a) external {
        require(msg.sender == owner);
        didBurn[a] = 1;
    }
    
    function getDidBurn(address a) external view returns (bool b) {
        return (didBurn[a] == 1);
    }
    
    function removeBurn(address a) external {
        require(msg.sender == owner);
        didBurn[a] = 0;
    }
}