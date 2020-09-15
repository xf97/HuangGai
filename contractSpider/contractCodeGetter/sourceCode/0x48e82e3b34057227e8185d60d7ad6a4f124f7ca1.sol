/**
 *Submitted for verification at Etherscan.io on 2020-05-16
*/

pragma solidity ^0.5.0;


interface IGasToken {
    function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
}


contract GasDiscountDeployer {
    IGasToken public constant gasToken = IGasToken(0x0000000000b3F879cb30FE243b4Dfee438691c04);

    modifier makeGasDiscount {
        uint256 gasStart = gasleft();
        _;
        uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
        gasToken.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
    }

    function deploy(bytes memory data) public makeGasDiscount returns(address contractAddress) {
        assembly {
            contractAddress := create(0, add(data, 32), mload(data))
        }
    }
    
    function deploy2(uint256 salt, bytes memory data) public makeGasDiscount returns(address contractAddress) {
        assembly {
            contractAddress := create2(0, add(data, 32), mload(data), salt)
        }
    }
}