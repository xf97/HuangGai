/**
 *Submitted for verification at Etherscan.io on 2020-06-29
*/

pragma solidity ^0.5.0;

contract EIP20Interface {
    /* This is a slight change to the ERC20 base standard.
    function totalSupply() constant returns (uint256 supply);
    is replaced with:
    uint256 public totalSupply;
    This automatically creates a getter function for the totalSupply.
    This is moved to the base contract since public getter functions are not
    currently recognised as an implementation of the matching abstract
    function by the compiler.
    */
    /// total amount of tokens
    uint256 public totalSupply;

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) public view returns (uint256 balance);

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) public returns (bool success);

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) public returns (bool success);

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    // solhint-disable-next-line no-simple-event-func-name
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}


contract HelixNebula is EIP20Interface {

//////////////////////////Token Layer////////////////////////////////////////////////
    address payable wallet;
    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;

    string public name;                   
    uint8 public decimals;                
    string public symbol;                 
    
    constructor() public {
        wallet=msg.sender;
        totalSupply = 70000000000000000;                        // Update total supply
        balances[msg.sender] = totalSupply;
        name = "HelixNebula";                                   // Set the name for display purposes
        decimals = 7;                            // Amount of decimals for display purposes
        symbol = "UN";                               // Set the symbol for display purposes
    }
 
   function GetMinedTokens() public view returns(uint){
      return totalSupply-balances[wallet];  //it means how much people help each others
   }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);
        require(msg.sender != wallet);    //the owner of wallet can not send any HelixNebula Token to anyone .
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

 ////////////////////////////helix main database Layer////////////////////////////////////////
    
  uint votecost=10000 szabo; //1 szabo =0.000001 ether
  uint HelixPrice=100000 szabo; //0.1 ether
  uint trigger=0;
  struct votedata{
      uint hid;
      address voterad;
      uint vtype;  //0 means mines 1 means plus
  }
  struct Human {
    uint id;
    string name;
    uint lang;
    int vote;
    uint views;
    string story;
    uint timestamp;
    address payable ethaddress;
    address payable ownerAddress;
    string pass;
  }
  votedata[] public voters;
  Human[] public Humans;
  uint public nextId = 1;
  
  function DeleteVotesByid(uint _id) internal{
     for(uint i = 0; i < voters.length; i++) {
      if(voters[i].hid == _id) {
            delete voters[i];
      }
     }
  }
  function create(string memory _name,uint _lang,string memory story,address payable _ethaddress,string memory pass) public {
    bytes memory EmptyStringstory = bytes(story); 
    require(EmptyStringstory.length > 4,"null story"); //prevent from add null story.
    Humans.push(Human(nextId, _name,_lang,0,0,story,block.timestamp,_ethaddress,msg.sender,pass));
    
    uint timetemp=block.timestamp - Humans[0].timestamp;
    uint tdays=timetemp/(3600*24);
    
    if(tdays>60){
        DeleteVotesByid(Humans[0].id);
        delete Humans[0];
        
    }
    
    for(uint i=0;i<Humans.length; i++){
        if(Humans[i].vote < -100){
            DeleteVotesByid(Humans[i].id);
            delete Humans[i];
        }
    }
    // and so remove the humans have not enough point
    nextId++;
  }
  function GetdatePoint(uint _dtime) view internal returns(uint){
       uint timetemp=block.timestamp - _dtime;
       uint tdays=timetemp/(3600*24);
       uint pdays=tdays+1;
       uint points=((120-pdays)**2)/pdays;
       return points;
  }

  function GetRandomHuman(uint _randseed,uint _decimals,uint _lang) public view returns(string memory,string memory,int,address,uint,uint){  
      uint[] memory points=new uint[](Humans.length);
      uint maxlengthpoint=0;
      for(uint i = 0; i < Humans.length; i++) 
      {
          if(Humans[i].lang != _lang){
               points[i]=0;
          }else{
              uint daypoint=GetdatePoint(Humans[i].timestamp);
              int uvotes=Humans[i].vote*10;
              int mpoints=int(daypoint)+uvotes;
              if(mpoints<0){
                  mpoints=1;
              }
              points[i]=uint(mpoints);
              maxlengthpoint=maxlengthpoint+uint(mpoints);
          }
      }
      uint randnumber=(_randseed  * maxlengthpoint)/_decimals;
     
      
      uint tempnumber=0;
      for(uint i = 0; i < points.length; i++) {
          if(tempnumber<randnumber && randnumber<tempnumber+points[i] && points[i] !=0){
              uint timetemp=block.timestamp - Humans[i].timestamp;
              uint tdays=timetemp/(3600*24);
              if(60-tdays>0){
                  return (Humans[i].name,Humans[i].story,Humans[i].vote,Humans[i].ethaddress,Humans[i].id,60-tdays);
              }else{
                  return ("Problem","We have problem . please refersh again.",0,msg.sender,0,0);
              }
          }else{
              tempnumber=tempnumber+points[i];
          }
      }
      return ("No Story","If you see this story it means that there is no story at this language, if you know some one need help, ask them to add new story.",0,msg.sender,0,0);
  }

  function read(uint id) internal view  returns(uint, string memory) {
    uint i = find(id);
    return(Humans[i].id, Humans[i].name);
  }
  function GetVotedata(uint id) view public returns(int256,uint)
  {
     uint Vcost=votecost;
     uint votecounts=0;
     uint hindex=find(id);
     for(uint i = 0; i < voters.length; i++) {
      if(voters[i].hid == id && voters[i].voterad == msg.sender) {
        if(votecounts>0){
            Vcost=Vcost*2;
        }
        votecounts++;
      }
    } 
    return(Humans[hindex].vote,Vcost);
  }
  function vote(uint id,uint vtype) public payable returns(uint){
      
    uint votecounts=0;
    uint Vcost=votecost;
    for(uint i = 0; i < voters.length; i++) {
      if(voters[i].hid == id && voters[i].voterad == msg.sender) {
        if(votecounts>0){
            Vcost=Vcost*2;
        }
        votecounts++;
      }
    }
    if(msg.value >= Vcost){
        uint j = find(id);
        if(balances[wallet]>(10**7)){
            balances[wallet] -=10**7;
            balances[msg.sender] +=10**7;
            wallet.transfer(msg.value);
        }else{
            if(vtype==1){
                Humans[j].ethaddress.transfer(msg.value);
            }else{
                wallet.transfer(msg.value);
            }
        }
        if(vtype==1){
            Humans[j].vote++;
        }else{
            Humans[j].vote--;
        }
        voters.push(votedata(id, msg.sender,1));
        return Vcost*2;
    }else{
       return 0; 
    }
  }
  
  function SendTransaction(address payable _adr,address payable _referraladr,bool _hasreferral) public payable{
      uint HelixToTransfer=msg.value/HelixPrice;
      
      if(balances[wallet]>(2*HelixToTransfer*(10**7))){
          if(_hasreferral == true){
            balances[_referraladr] += HelixToTransfer*(10**7);
            balances[wallet] -= HelixToTransfer*(10**7);
          }
          balances[msg.sender] += HelixToTransfer*(10**7);
          balances[wallet] -= HelixToTransfer*(10**7);
          _adr.transfer(msg.value*9/10);
          wallet.transfer(msg.value/10);
      }else{
          _adr.transfer(msg.value); //if the main helix nebula wallet is empty. all helpings send to the needy
      }
  }
  
  function destroy(uint id) public {
      if(msg.sender==wallet){
        uint i = find(id);
        delete Humans[i];
      }else{
        revert('Access denied!');
      }
      
  }
  
  function GetStroyByindex(uint _index)view public returns(uint,string memory,string memory,uint,address)
  {
      if(msg.sender==wallet){
        return (Humans[_index].id,Humans[_index].name,Humans[_index].story,Humans[_index].lang,Humans[_index].ethaddress);
      }
      revert('Access denied!');
  }
  
  function find(uint id) view internal returns(uint) {
    for(uint i = 0; i < Humans.length; i++) {
      if(Humans[i].id == id) {
        return i;
      }
    }
    revert('User does not exist!');
  }
}