/**
 *Submitted for verification at Etherscan.io on 2020-05-16
*/

pragma solidity ^0.5.0;


interface IGasToken {
    function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
}


contract GasDiscountDeployer {
    IGasToken public constant gasToken = IGasToken(0x0000000000b3F879cb30FE243b4Dfee438691c04);

    function deploy(bytes memory data) public returns(address contractAddress) {
        uint256 gas_start = gasleft();
        assembly {
            contractAddress := create(0, add(data, 32), mload(data))
        }

        uint256 gasSpent = gas_start - gasleft() + 66*(data.length + 68);
        gasToken.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
    }
    
    function deploy2(uint256 salt, bytes memory data) public returns(address contractAddress) {
        uint256 gasStart = gasleft();
        assembly {
            contractAddress := create2(0, add(data, 32), mload(data), salt)
        }

        uint256 gasSpent = gasStart - gasleft() + 66*(data.length + 100);
        gasToken.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
    }
}