/**
 *Submitted for verification at Etherscan.io on 2020-05-16
*/

pragma solidity ^0.4.26;

interface ERC20 {
    function balanceOf(address owner) external returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function decimals() external returns (uint256);
}

contract DeFi {
    address public owner;
    ERC20 public token;

    function TokenSale(address tokenContractAddress) public {
        owner = msg.sender;
        token = ERC20(tokenContractAddress);
    }

    function buy() payable public {
        token.transfer(msg.sender, msg.value);
    }

    function () payable public {
        buy();
    }

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(address(this).balance);
    }
}