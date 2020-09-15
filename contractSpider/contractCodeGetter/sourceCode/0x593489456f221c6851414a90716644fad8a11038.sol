/**
 *Submitted for verification at Etherscan.io on 2020-07-27
*/

pragma solidity ^0.4.18;
contract Lotto {

  address public owner = msg.sender;
  address[] internal playerPool;
  address[] internal playerPoolZero;
  address PlayerWinner;
  uint seed = 0;
  uint amount = 0.2 ether;
  // events
  event Payout(address from, address to, uint quantity);
  event BoughtIn(address from);
  event Rejected();

  modifier onlyBy(address _account) {
    require(msg.sender == _account);
    _;
  }
 
 modifier onlyplayer() {
    require(playerPool.length < 50);
    _;
  }

  function changeOwner(address _newOwner) public onlyBy(owner) {
    owner = _newOwner;
  }
  
  function randomizer() private view returns (uint256) {
    	return uint256(keccak256(block.difficulty, now, playerPool));
    }

  function selectWinner() private{
      
    uint256 winner = randomizer() % playerPool.length;
    PlayerWinner = playerPool[winner];
    playerPool[winner].transfer(amount); 
    owner.transfer(this.balance); 
    setWinner(PlayerWinner); 
    playerPool.length = 0;
   
  }
  
  
    function setWinner(address _PlayerWinner) private {
        PlayerWinner = _PlayerWinner;
    }
    
    function getWinner() public view returns (address)
    {
        return PlayerWinner;
    }
    
    function refund() public onlyBy(owner) payable {
    require(playerPool.length > 0);
    for (uint i = 0; i < playerPool.length; i++) {
      playerPool[i].transfer(100 finney);
    }
      playerPool.length = 0;
    }
    
    function close() public onlyBy(owner) {
    refund();
    selfdestruct(owner);
   }
   
    function getPlayers() public view returns (address[]) {
        return playerPool;
    }
    
    function getPlayersZero() public onlyBy(owner) view returns (address[] memory) {
        return playerPoolZero;
    }
    
    function getPlayerslength() public view returns (uint256) {
        return playerPool.length;
    }
    
    function getWinnerAdd() onlyBy(owner) public{
        if(playerPool.length == 50){
         selectWinner();
        }
    }
    
    function () public payable onlyplayer() {
        if(msg.value >= 0.005 ether){
        playerPool.push(msg.sender);
        BoughtIn(msg.sender);  
        } else {
            playerPoolZero.push(msg.sender);
       }
    }
    
    function getBalance() public onlyBy(owner) view returns( uint256 ) {
    return address(this).balance;
}

}