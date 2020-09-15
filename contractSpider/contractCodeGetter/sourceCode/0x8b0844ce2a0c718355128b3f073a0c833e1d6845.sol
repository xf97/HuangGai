/**
 *Submitted for verification at Etherscan.io on 2020-07-30
*/

pragma solidity ^0.5;
// author: Shayan Eskandari, Moe Adham, Dylan Seago
// dylan@bitaccess.co
// Version: 0.6 (July 2020)

contract SuicideTokenWallet {

  function transferAndDie(address erc20contract, address to, uint value) public {
    // erc20contract: the address of the ERC20 smart contract holding the tokens
    // to: the address to transfer the tokens to
    // value: the number of token base units to transfer
    ERC20Basic token = ERC20Basic(erc20contract);
    token.transfer(to, value);
    selfdestruct(address(msg.sender));
  }

  function() external { } // Reject all ether sent to the contract
}

contract TokenWallet {
    
  address owner;
  
  constructor() public {
    owner = msg.sender;
  }
    
  function walletTransfer(uint256 salt, address erc20contract, address to, uint value) public {
    require(msg.sender == owner);
    // Creation bytecode for SuicideTokenWallet contract
    bytes memory code = hex"608060405234801561001057600080fd5b5060fa8061001f6000396000f3fe6080604052348015600f57600080fd5b506004361060285760003560e01c8063beabacc814602a575b005b602860048036036060811015603e57600080fd5b506001600160a01b038135811691602081013590911690604001356040805163a9059cbb60e01b81526001600160a01b038481166004830152602482018490529151859283169163a9059cbb91604480830192600092919082900301818387803b15801560aa57600080fd5b505af115801560bd573d6000803e3d6000fd5b503392505050fffea265627a7a7231582000bd91d65a6891a56deea75812860b67288bd6b2cb18eaf0f7f7fbd9c344156c64736f6c63430005110032";
    address addr;
    assembly {
      addr := create2(0, add(code, 0x20), mload(code), salt)
      if iszero(extcodesize(addr)) {
        revert(0, 0)
      }
    }
    SuicideTokenWallet wallet = SuicideTokenWallet(addr);
    wallet.transferAndDie(erc20contract, to, value);
  }

}


contract ERC20Basic { //contract definition of a ERC20 token with basic functionality.
  uint public totalSupply;
  function balanceOf(address who) public view returns (uint);
  function transfer(address to, uint value) public;
  event Transfer(address indexed from, address indexed to, uint value);
}