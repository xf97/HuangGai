/**
 *Submitted for verification at Etherscan.io on 2020-06-24
*/

pragma solidity >=0.4.21 <0.6.0;

contract MultiSigInterface{
  function update_and_check_reach_majority(uint64 id, string memory name, bytes32 hash, address sender) public returns (bool);
  function is_signer(address addr) public view returns(bool);
}

contract MultiSigTools{
  MultiSigInterface public multisig_contract;
  constructor(address _contract) public{
    require(_contract!= address(0x0));
    multisig_contract = MultiSigInterface(_contract);
  }

  modifier only_signer{
    require(multisig_contract.is_signer(msg.sender), "only a signer can call in MultiSigTools");
    _;
  }

  modifier is_majority_sig(uint64 id, string memory name) {
    bytes32 hash = keccak256(abi.encodePacked(msg.sig, msg.data));
    if(multisig_contract.update_and_check_reach_majority(id, name, hash, msg.sender)){
      _;
    }
  }

  event TransferMultiSig(address _old, address _new);

  function transfer_multisig(uint64 id, address _contract) public only_signer
  is_majority_sig(id, "transfer_multisig"){
    require(_contract != address(0x0));
    address old = address(multisig_contract);
    multisig_contract = MultiSigInterface(_contract);
    emit TransferMultiSig(old, _contract);
  }
}

contract TransferableToken{
    function balanceOf(address _owner) public returns (uint256 balance) ;
    function transfer(address _to, uint256 _amount) public returns (bool success) ;
    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) ;
}


contract TokenClaimer{

    event ClaimedTokens(address indexed _token, address indexed _to, uint _amount);
    /// @notice This method can be used by the controller to extract mistakenly
    ///  sent tokens to this contract.
    /// @param _token The address of the token contract that you want to recover
    ///  set to 0 in case you want to extract ether.
  function _claimStdTokens(address _token, address payable to) internal {
        if (_token == address(0x0)) {
            to.transfer(address(this).balance);
            return;
        }
        TransferableToken token = TransferableToken(_token);
        uint balance = token.balanceOf(address(this));

        (bool status,) = _token.call(abi.encodeWithSignature("transfer(address,uint256)", to, balance));
        require(status, "call failed");
        emit ClaimedTokens(_token, to, balance);
  }
}

library SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a, "add");
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a, "sub");
        c = a - b;
    }
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b, "mul");
    }
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0, "div");
        c = a / b;
    }
}

contract SimpleMultiSigVote is MultiSigTools, TokenClaimer{

  struct InternalData{
    bool exist;
    bool determined;
    uint start_height;
    uint end_height;
    address owner;
    string announcement;
    string value;
    uint64 vote_id;
  }

  mapping (bytes32 => InternalData) public vote_status;
  uint public determined_vote_number;
  uint public created_vote_number;

  constructor(address _multisig) MultiSigTools(_multisig) public{
    determined_vote_number = 0;
    created_vote_number = 0;
  }

  event VoteCreate(bytes32 _hash, uint _start_height, uint _end_height);
  event VoteChange(bytes32 _hash, uint _start_height, uint _end_height, string announcement);
  event VotePass(bytes32 _hash, string _value);

  modifier vote_exist(bytes32 _hash){
    require(vote_status[_hash].exist, "vote not exist");
    _;
  }

  function createVote(bytes32 _hash, uint _start_height, uint _end_height)
    public
    returns (bool){
    require(!vote_status[_hash].exist, "already exist");
    require(_end_height > block.number, "end height too small");
    require(_end_height > _start_height, "end height should be greater than start height");
    if(_start_height == 0){
      _start_height = block.number;
    }
    InternalData storage d = vote_status[_hash];

    d.exist = true;
    d.determined = false;
    d.start_height = _start_height;
    d.end_height = _end_height;
    d.owner = msg.sender;
    d.vote_id = 0;
    created_vote_number += 1;
    emit VoteCreate(_hash, _start_height, _end_height);
    return true;
  }

  function changeVoteInfo(bytes32 _hash, uint _start_height, uint _end_height, string memory announcement) public
    vote_exist(_hash)
    returns (bool){
    InternalData storage d = vote_status[_hash];
    require(d.owner == msg.sender, "only creator can change vote info");

    if(_end_height != 0){
      require(_end_height > block.number, "end height too small");
      d.end_height = _end_height;
    }
    require(d.start_height > block.number, "already start, cannot change start height");
    if(_start_height != 0){
      require(_start_height >= block.number, "start block too small");
      d.start_height = _start_height;
    }

    require(d.end_height > d.start_height, "end height should be greater than start height");

    d.announcement = announcement;
    emit VoteChange(_hash, _start_height, _end_height, announcement);
    return true;
  }
  function vote_internal(uint64 id, bytes32 _hash, string memory _value) private
    vote_exist(_hash)
    only_signer
    is_majority_sig(id, "vote")
    returns (bool){
    InternalData storage d = vote_status[_hash];
    require(d.start_height <= block.number, "vote not start yet");
    require(d.end_height >= block.number, "vote already end");

    d.value = _value;
    d.determined = true;
    emit VotePass(_hash, _value);
    determined_vote_number += 1;
    return true;
  }

  function vote(uint64 id, bytes32 _hash, string memory _value) public
    returns (bool){
    InternalData storage d = vote_status[_hash];
    require(d.start_height <= block.number, "vote not start yet");
    require(d.end_height >= block.number, "vote already end");

    uint64 tid = id;
    if(d.vote_id == 0){
      d.vote_id = id;
    }else{
      tid = d.vote_id;
    }
    return vote_internal(tid, _hash, _value);
  }

  function isVoteDetermined(bytes32 _hash) public view returns (bool){
    return vote_status[_hash].determined;
  }

  function checkVoteValue(bytes32 _hash) public view returns(string memory value){
    require(vote_status[_hash].exist, "not exist");
    require(vote_status[_hash].determined, "not determined");

    value = vote_status[_hash].value;
  }

  function voteInfo(bytes32 _hash) public
  vote_exist(_hash)
  view returns(bool determined, uint start_height, uint end_height, address owner, string memory announcement, string memory value){

    InternalData storage d = vote_status[_hash];
    return (d.determined, d.start_height, d.end_height, d.owner, d.announcement, d.value);
  }

  function claimStdTokens(uint64 id, address _token, address payable to) public only_signer is_majority_sig(id, "claimStdTokens"){
    _claimStdTokens(_token, to);
  }
}

contract SimpleMultiSigVoteFactory {
  event NewSimpleMultiSigVote(address addr);

  function createSimpleMultiSigVote(address _multisig) public returns(address){
    SimpleMultiSigVote smsv = new SimpleMultiSigVote(_multisig);

    emit NewSimpleMultiSigVote(address(smsv));
    return address(smsv);
  }
}