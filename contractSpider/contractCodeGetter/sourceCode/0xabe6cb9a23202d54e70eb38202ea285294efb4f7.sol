/**
 *Submitted for verification at Etherscan.io on 2020-08-01
*/

pragma solidity ^0.6.3;
contract starkminer {
    function checklasttwentyblock() view public returns(uint256, uint256) {
        if(uint256(blockhash(block.number-1)) % 7700 == 1){
            uint256 crew = uint256(blockhash(block.number-1)) % 7700;
            return (crew, block.number-1);
        }else if(uint256(blockhash(block.number-2)) % 7700 == 1){
            uint256 crew = uint256(blockhash(block.number-2)) % 7700;
            return (crew, block.number-2);
        } else if(uint256(blockhash(block.number-3)) % 7700 == 1){
            uint256 crew = uint256(blockhash(block.number-3)) % 7700;
            return (crew, block.number-3);
        }else if(uint256(blockhash(block.number-4)) % 7700 == 1){
            uint256 crew = uint256(blockhash(block.number-4)) % 7700;
            return (crew, block.number-4);
        }else if(uint256(blockhash(block.number-5)) % 7700 == 1){
            uint256 crew = uint256(blockhash(block.number-5)) % 7700;
            return (crew, block.number-5);
        } else if(uint256(blockhash(block.number-6)) % 7700 == 1){
            uint256 crew = uint256(blockhash(block.number-6)) % 7700;
            return (crew, block.number-6);
        } else if(uint256(blockhash(block.number-7)) % 7700 == 1){
            uint256 crew = uint256(blockhash(block.number-7)) % 7700;
            return (crew, block.number-7);
        } else if(uint256(blockhash(block.number-8)) % 7700 == 1){
            uint256 crew = uint256(blockhash(block.number-8)) % 7700;
            return (crew, block.number-8);
        } else if(uint256(blockhash(block.number-9)) % 7700 == 1){
            uint256 crew = uint256(blockhash(block.number-9)) % 7700;
            return (crew, block.number-9);
        } else if(uint256(blockhash(block.number-10)) % 7700 == 1){
            uint256 crew = uint256(blockhash(block.number-10)) % 7700;
            return (crew, block.number-10);
        } else if(uint256(blockhash(block.number-11)) % 7700 == 1){
            uint256 crew = uint256(blockhash(block.number-11)) % 7700;
            return (crew, block.number-11);
        } else if(uint256(blockhash(block.number-12)) % 7700 == 1){
            uint256 crew = uint256(blockhash(block.number-12)) % 7700;
            return (crew, block.number-12);
        } else if(uint256(blockhash(block.number-13)) % 7700 == 1){
            uint256 crew = uint256(blockhash(block.number-13)) % 7700;
            return (crew, block.number-13);
        } else if(uint256(blockhash(block.number-14)) % 7700 == 1){
            uint256 crew = uint256(blockhash(block.number-14)) % 7700;
            return (crew, block.number-14);
        } else if(uint256(blockhash(block.number-15)) % 7700 == 1){
            uint256 crew = uint256(blockhash(block.number-15)) % 7700;
            return (crew, block.number-15);
        }else {
            uint256 crew = uint256(blockhash(block.number-1)) % 7700;
            return (crew, block.number-1);
        }
    }
}