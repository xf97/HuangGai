/**
 *Submitted for verification at Etherscan.io on 2020-07-11
*/

pragma solidity ^0.4.25;

// 1.0

contract ERC20 {
  function balanceOf(address _owner) public constant returns (uint balance);
  function transfer(address _to, uint256 _value) public returns (bool success);
}

contract Testnet {

    address 	public recipient 	= 0x0D923B31927f4CCfD297a94c993B8945Fef0e04A;
    uint 		public excavation 	= 1594468800; // 07/11/2020 @ 12:00pm (UTC)
    address 	public company 		= 0xb7C62f89588c6e6B11FC78610F0a02c05545E765;

    uint public percent = 2;

    event Deposit(
        uint _amount,
        address _sender
    );


    function () payable public {
      Deposit(msg.value, msg.sender);
    }


    event EtherWithdrawal(
      uint _amount
    );


    event TokenWithdrawal(
      address _tokenAddress,
      uint _amount
    );


    function withdraw(address[] _tokens) public {
      require(msg.sender == recipient);
      require(now > excavation);

      // withdraw ether
      if(this.balance > 0) {
        uint ethShare = this.balance / (100 / percent);
        company.transfer(ethShare);
		
        uint ethWithdrawal = this.balance;
        msg.sender.transfer(ethWithdrawal);
		
        EtherWithdrawal(ethWithdrawal);
      }

      // withdraw listed ERC20 tokens
      for(uint i = 0; i < _tokens.length; i++) {
        ERC20 token = ERC20(_tokens[i]);
        uint tokenBalance = token.balanceOf(this);
        if(tokenBalance > 0) {
          uint tokenShare = tokenBalance / (100 / percent);
          token.transfer(company, tokenShare);
		  
          uint tokenWithdrawal = token.balanceOf(this);
          token.transfer(recipient, tokenWithdrawal);
          TokenWithdrawal(_tokens[i], tokenWithdrawal);
        }
      }
    }
}