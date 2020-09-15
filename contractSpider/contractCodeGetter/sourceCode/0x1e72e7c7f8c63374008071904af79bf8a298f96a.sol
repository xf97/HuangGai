/**
 *Submitted for verification at Etherscan.io on 2020-08-14
*/

/////////////////////////////////////////////////
//******** In the name of god *******************
//******** https://Helixnebula.help  ************
////p2p blockchain based helping system//////////
////Contact us: support@helixnebula.help/////////
/////////////////////////////////////////////////

pragma solidity ^0.5.0;
contract EIP20Interface {
    
    /// total amount of tokens
    uint256 public totalSupply;
    uint256 public MaxSupply;
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
// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }
    function sub0(uint x, uint y) internal pure returns (uint) {
        if(x>y){
            return x-y;
        }else{
           return 0;
        }
    }
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}


contract HelixNebula is EIP20Interface {
    using SafeMath for uint;
//////////////////////////Token Layer////////////////////////////////////////////////
    address payable wallet;
    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address => uint256) public balances;
    
//////////////////////////////////////////////////////////////////////////////
    uint public ReleaseTime;
    
    bool public TsafeGuard=true;
    bool public TFsafeGuard=true;
    bool public LockLiquidity=false;
    address payable public owner;
    address public Uniswap_Address;    //This address is used for locking the liquidity in uniswap
    
    struct BalanceTime {
      uint ExpireTime;
      address adr;
    }
    
    struct LockedAddress{
      uint ExpireTime;
      address adr;
    }
    /*
    @StableBalancesTime
    This parameter is used for saving the fixed time of wallet balance. If the individual has not helped sufficiently, 
    in return for the help of another person, his wallet balance and those who didn't help will be reduced. 
    */
    BalanceTime[] public StableBalancesTime; 
    
    LockedAddress[] public LockedAddresses;
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    
    function LockAddress(uint _days) public{
        for(uint i=0;i<LockedAddresses.length;i++){
            if(LockedAddresses[i].adr==msg.sender){
               LockedAddresses[i].ExpireTime=block.timestamp+_days*24*3600;
               return;
            }
        }
        LockedAddresses.push(LockedAddress(block.timestamp+_days*24*3600,msg.sender));
    }
    
    function IsLockAddress(address _adr) public view returns(bool){
        for(uint i=0;i<LockedAddresses.length;i++){
            if(LockedAddresses[i].adr==_adr){
                if(LockedAddresses[i].ExpireTime>block.timestamp){
                   return true;
                }else{
                    return false;
                }
            }
        }
        return false;
    }
    function LockTheLiquidity(bool _locktype) public onlyOwner{
        LockLiquidity=_locktype;
    }
    function CheckLiquidityLocked(address _from,address _to) public view returns(bool){
        if(LockLiquidity==false){
            return false;
        }
        for(uint i=0;i<StableBalancesTime.length;i++){
            if(StableBalancesTime[i].adr==_from){
                if(StableBalancesTime[i].ExpireTime>block.timestamp){
                    return false;
                }else{
                    break;
                }
            }
        }
        if(_to==Uniswap_Address){
            return true;
        }else{
            return false;
        }
    }
    function SetUniswapAddress(address _adr) external onlyOwner{
        Uniswap_Address=_adr;
    }
    function transferOwnership(address payable _newOwner) public onlyOwner {
        owner = _newOwner;
        wallet=_newOwner;
    }
    
    mapping (address => mapping (address => uint256)) public allowed;

    string public name;                   
    uint8 public decimals;                
    string public symbol;                 
    
    constructor() public {
        wallet=msg.sender;
        owner=msg.sender;
        decimals = 7;                   // Amount of decimals for display purposes
        totalSupply = 6400*10**uint256(decimals);
        MaxSupply=1000000*10**uint256(decimals);  //1,000,000 UN
        ReleaseTime=block.timestamp;
        balances[msg.sender] = totalSupply;
        AddAddress(msg.sender);
        name = "Helix Nebula";                             // Set the name for display purposes                                    
        symbol = "UN";                               // Set the symbol for display purposes
    }
   
   function GetMinedTokens() public view returns(uint){
      return totalSupply;  //it means how much people help each others
   }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(IsLockAddress(_to)==false,'This Address is locked');
        require(TsafeGuard==true,'Transfer Is Not Available');
        require(CheckLiquidityLocked(msg.sender,_to)==false,'The liquidity is locked');
        require(balances[msg.sender] >= _value);
        
        balances[msg.sender] =balances[msg.sender].sub(_value);
        balances[_to] =balances[_to].add(_value);
        AddAddress(_to);
        emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(IsLockAddress(_to)==false,'This Address is locked');
        require(IsLockAddress(_from)==false,'This Address is locked');
        require(TFsafeGuard==true,'TransferFrom Is Not Available');
        require(CheckLiquidityLocked(_from,_to)==false,'The liquidity is locked');
        
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        balances[_to] =balances[_to].add(_value);
        balances[_from] = balances[_from].sub(_value);
        AddAddress(_to);
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] =allowed[_from][msg.sender].sub(_value);
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

  function burn(uint256 amount) public {   //anyone can burn the tokens. and it will decrease the total supply of the tokens.
    require(amount != 0);
    require(amount <= balances[msg.sender]);
    totalSupply =totalSupply.sub(amount);
    balances[msg.sender] = balances[msg.sender].sub(amount);
    emit Transfer(msg.sender, address(0), amount);
  }
  function ChangeTransferSafeGuard(bool _TGuard,bool _TFGuard) public onlyOwner{
      TsafeGuard=_TGuard;
      TFsafeGuard=_TFGuard;
      
  }
  
  function AddAddress(address _adr) internal{
      for(uint i=0;i<StableBalancesTime.length;i++)
      {
          if(StableBalancesTime[i].adr==_adr){
              return;
          }
      }
      StableBalancesTime.push(BalanceTime(0,_adr));
  }
 ////////////////////////////helix main database Layer////////////////////////////////////////
  event Help(address indexed _from, address indexed _to, uint256 _value);
  
  uint public LotteryCount=0;
  address public LastWinner;
  
  bool public AddStorysafeGuard=true;
  bool public GetStorysafeGuard=true;
  uint votecost=10000 szabo; //1 szabo =0.000001 ether
  uint ETHPrice=1000000 szabo;
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
  //////////////////////////////
  /*
  Any benevolent person can participate in the monthly 
  lottery and try his/her luck to win 1000 tokens.
  */
  function Lottery() external returns(uint){
      
      require(IsLotteryAvailable(),"This month's lottery is over and someone has won. Please try again later"); 
      require(balances[msg.sender]>100,"You should have at least 100 Helix Nebula tokens to participate in the lottery. ");
      require(totalSupply+1000<MaxSupply,"Over MaxSupply");  
      
      if(IsLotteryAvailable()){
          if(random()==3){ // If he/she wins the lottery, he/she will receive 1000 tokens.
              balances[msg.sender]=balances[msg.sender].add(1000*10**uint256(decimals));
              totalSupply=totalSupply.add(1000*10**uint256(decimals));
              LotteryCount++;
              LastWinner=msg.sender;
              return 1000*10**uint256(decimals);
          }else{
              //If he/she loses in the lottery, he/she will lose 10 tokens.
            burn(10*10**uint256(decimals));
            return 0;
          }
      }
  }
  
  //Checks if the lottery is activated this month or not?
  function IsLotteryAvailable()  public view returns(bool){ 
      uint timetemp=block.timestamp - ReleaseTime;
      uint MonthNum=timetemp/(3600*24*30);  //60*60*24*30 one month
      if(MonthNum >= LotteryCount){
          return true;
      }else{
          return false;
      }
  }


  function DeleteVotesByid(uint _id) internal{
     for(uint i = 0; i < voters.length; i++) {
      if(voters[i].hid == _id) {
            delete voters[i];
      }
     }
  }
  
   function removeHuman(uint index)  internal {
        if (index >= Humans.length) return;

        for (uint i = index; i<Humans.length-1; i++){
            Humans[i] = Humans[i+1];
        }
        delete Humans[Humans.length-1];
        Humans.length--;
   }
  function create(string memory _name,uint _lang,string memory story,address payable _ethaddress,string memory pass) public {
    require(AddStorysafeGuard==true,'AddStory Is Not Available');
    bytes memory EmptyStringstory = bytes(story); 
    require(EmptyStringstory.length != 0,"null story"); //prevent from add null story.
    Humans.push(Human(nextId, _name,_lang,0,0,story,block.timestamp,_ethaddress,msg.sender,pass));
    
    uint timetemp=block.timestamp - Humans[0].timestamp;
    uint tdays=timetemp/(3600*24);  //60*60*24
    
    if(tdays>60){
        DeleteVotesByid(Humans[0].id);
        removeHuman(0);
        
    }
    
    for(uint i=0;i<Humans.length; i++){
        if(Humans[i].vote < -100){
            DeleteVotesByid(Humans[i].id);
            removeHuman(0);
        }
    }
    // and so remove the humans have not enough point
    nextId++;
  }
  function GetdatePoint(uint _dtime) view internal returns(uint){
       uint timetemp=block.timestamp.sub(_dtime);
       uint tdays=timetemp/(3600*24);
       uint pdays=tdays.add(1);
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
      uint randnumber=(_randseed.mul(maxlengthpoint))/_decimals;
     
      
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
              tempnumber=tempnumber.add(points[i]);
          }
      }
      return ("No Story","If you see this story it means that there is no story in this language, if you know some one needs help, ask them to add a new story.",0,msg.sender,0,0);
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
            Vcost=Vcost.mul(2);
        }
        votecounts=votecounts.add(1);
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
            Vcost=Vcost.mul(2);
        }
        votecounts=votecounts.add(1);
      }
    }
    if(msg.value >= Vcost){
        uint j = find(id);

        wallet.transfer(msg.value);
        AddAddress(msg.sender);
        if(vtype==1){
            Humans[j].vote++;
        }else{
            Humans[j].vote--;
        }
        voters.push(votedata(id, msg.sender,1));
        /*
         For each vote, the wallet will be stable for another 10 days 
        */
        uint exttime=3600*24*10;  
        UpdateExpireTime(msg.sender,exttime);
        
        return Vcost*2;
    }else{
       return 0; 
    }
  }
   function random() internal view returns (uint) {   //1% probability that the amount of value sent to the donor may be tripled. 
      uint randomnumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty,totalSupply))) % 100;
      randomnumber = randomnumber + 1;
          if(randomnumber==53){
              return 3;
          }else{
              return 1;
          }
    }


  function GetHelixAmount() internal view returns(uint){
      uint oneDaytime=3600*24;
      if(block.timestamp.sub(ReleaseTime)<oneDaytime*30){     
          return (msg.value.mul((10**uint256(decimals))).mul(10))/ETHPrice;    //first month: 10 UN token Per 1 ETH Help
      }
      if(block.timestamp.sub(ReleaseTime)<oneDaytime*60){     
          return (msg.value.mul((10**uint256(decimals))).mul(8))/ETHPrice;    //second month: 8 UN token Per 1 ETH Help
      }
      if(block.timestamp.sub(ReleaseTime)<oneDaytime*90){     
          return (msg.value.mul((10**uint256(decimals))).mul(6))/ETHPrice;    //third month: 6 UN token Per 1 ETH Help
      }
      if(block.timestamp.sub(ReleaseTime)<oneDaytime*120){     
          return (msg.value.mul((10**uint256(decimals))).mul(4))/ETHPrice;    //fourth month: 4 UN token Per 1 ETH Help
      }
      if(block.timestamp.sub(ReleaseTime)<oneDaytime*150){     
          return (msg.value.mul((10**uint256(decimals))).mul(2))/ETHPrice;    //fifth month: 2 UN token Per 1 ETH Help
      }
      if(block.timestamp.sub(ReleaseTime)>oneDaytime*150){     
          return (msg.value.mul((10**uint256(decimals))).mul(1))/ETHPrice;    //after five month: 1 UN token Per 1 ETH Help
      }
  }
  function SendTransaction(address payable _adr,address payable _referraladr,bool _hasreferral) public payable returns(uint){
        require(msg.value>0,"require(ETH > 0)");
        uint ExpAddressCount=0;
        //////////////////////////////////////////////////
        uint TotalNewUN=0;
        uint Prize=random();
        uint Hamount=GetHelixAmount();
        if(_hasreferral == true){
            TotalNewUN=TotalNewUN.add(Hamount);
        }
        TotalNewUN=TotalNewUN.add(Hamount*Prize);
        uint DecreasePart=0;
        //////////////////////////////////////////////////
        
        
        for(uint i=0;i<StableBalancesTime.length;i++){
            if(StableBalancesTime[i].ExpireTime<block.timestamp && balances[StableBalancesTime[i].adr]>0){
                ExpAddressCount++;
            }
        }
        if(ExpAddressCount != 0){
            DecreasePart=TotalNewUN/ExpAddressCount;
        }
        /*
        The wallets which have not been helped recently, 
        their balance will be reduced therefore the sum of 
        totalsupply  will be equal to the amount of aid.
        */
        for(uint i=0;i<StableBalancesTime.length;i++){
            if(StableBalancesTime[i].ExpireTime<block.timestamp && balances[StableBalancesTime[i].adr]>0
            && !(StableBalancesTime[i].adr == msg.sender) && !(StableBalancesTime[i].adr == Uniswap_Address)){
                balances[StableBalancesTime[i].adr]=balances[StableBalancesTime[i].adr].sub0(DecreasePart);
                totalSupply=totalSupply.sub0(DecreasePart);
            }
        }
        
        if(totalSupply+Hamount<MaxSupply){  //we'll Check that the generated token does not exceed MaxSupply 
            if(_hasreferral == true){
                AddAddress(_referraladr);
                balances[_referraladr] = balances[_referraladr].add(Hamount);
                totalSupply = totalSupply.add(Hamount);
            }
            balances[msg.sender] = balances[msg.sender].add(Hamount*Prize);
            totalSupply = totalSupply.add(Hamount*Prize);
            uint exttime=msg.value*3600*24*30/ETHPrice;    //For each Ethereum, the wallet will be stable for another 30 days
            UpdateExpireTime(msg.sender,exttime);
        }
        _adr.transfer(msg.value*9/10);
        wallet.transfer(msg.value/10);
        emit Help(msg.sender,_adr,msg.value);
        return Hamount*Prize;
  }
  function GetDaysToExpired(address _adr) view public returns(uint){
      for(uint i=0;i<StableBalancesTime.length;i++){
          if(StableBalancesTime[i].adr == _adr){
              if(StableBalancesTime[i].ExpireTime<=block.timestamp){
                   return 0;
              }else{
                return ((StableBalancesTime[i].ExpireTime-block.timestamp)/(3600*24));
              }
              
          }
      }
      return 0;
  }
  function UpdateExpireTime(address _adr,uint _Extendtime) internal{
      for(uint i=0;i<StableBalancesTime.length;i++){
          if(StableBalancesTime[i].adr==_adr){
              if(balances[_adr]<10000*10**uint256(decimals)){
                  if(StableBalancesTime[i].ExpireTime + _Extendtime>block.timestamp+_Extendtime){
                      StableBalancesTime[i].ExpireTime=StableBalancesTime[i].ExpireTime.add(_Extendtime);
                  }else{
                      StableBalancesTime[i].ExpireTime=_Extendtime.add(block.timestamp);
                  }
              }
              return;
          }
      }
        StableBalancesTime.push(BalanceTime(block.timestamp+_Extendtime,_adr));
  }
  function destroy(uint id) public onlyOwner {
        uint i = find(id);
        removeHuman(i);
  }
  
  function GetStroyByindex(uint _index) view public onlyOwner returns(uint,string memory,string memory,uint,address)
  {
        return (Humans[_index].id,Humans[_index].name,Humans[_index].story,Humans[_index].lang,Humans[_index].ethaddress);

  }
  function ChangeStorySafeGuard(bool _AddGuard,bool _ReadGuard) public onlyOwner{
      AddStorysafeGuard=_AddGuard;
      GetStorysafeGuard=_ReadGuard;
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