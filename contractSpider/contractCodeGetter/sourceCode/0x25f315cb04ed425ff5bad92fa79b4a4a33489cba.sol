/**
 *Submitted for verification at Etherscan.io on 2020-08-15
*/

pragma solidity ^0.5.17;

contract FixTendiesFarm {

    mapping (address => uint256) didBurn;

    function recordBurn() external {
        require(didBurn[msg.sender] == 0);
        didBurn[msg.sender] = 1;
    }

    function recordBurnOther(address a) external {
        didBurn[a] = 1;
    }
    
    function getDidBurn(address a) external view returns (bool b) {
        return (didBurn[a] == 1);
    }
}