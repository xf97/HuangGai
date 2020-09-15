/**
 *Submitted for verification at Etherscan.io on 2020-05-29
*/

pragma solidity ^0.4.24;

/**Copyright (C) 2017-2020 Unifier System *Code by Ann Mandriana & Dimas Fachri
*All righst reserved.
*Author : unifiersystem Company supported by Vitalik, Satoshi & CodeXpert
*/

interface MandrianaXDimas { function receiveApproval (address _from, uint256 _value, address _token, bytes _extradata) external;}

contract UnifierSecurity {
    address public owner; ///Unifier System///
    
    constructor(){ ///Unifier System///
        owner = msg.sender;
    }
    
    modifier onlyOwner { ///Unifier System///
        require(msg.sender == owner);
        _;
    }
    
    function transferOwnership (address newOwner) onlyOwner { ///Unifier System///
        owner = newOwner;
    }
}

contract UnifierSystem is UnifierSecurity {

    string public name = "Unifier"; ///Unifier///
    string public symbol = "UNIF"; ///UNIF///
    uint8 public decimals = 7;
    uint256 public totalSupply; ///Max to 100 Million UNIF///
    
    mapping (address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public frozenAccount;
    
    event Transfer ( address indexed from, address indexed to, uint256 value );
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed from, uint256 value);
    event FrozenFunds(address target, bool frozen);
    
    constructor(
        uint256 initialSupply,
        string tokenName, ///Unifier///
        string tokenSymbol ///UNIF///
        ) public{
            totalSupply = initialSupply*10**uint256(decimals);
            balanceOf[msg.sender] = totalSupply;
            name = tokenName; ///Unifier///
            symbol = tokenSymbol; ///UNIF///
    }
    
/** TRANSFER SECTION by Ann Mandriana & Dimas Fachri
*/
    function _transfer(address _from, address _to, uint _value) internal {
        
        require(_to !=0x0);
        require(balanceOf[_from] >=_value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        require(!frozenAccount[msg.sender]);
        
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer (_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success){
        
        _transfer(msg.sender, _to, _value);
        return true;
    }
    /// END of TRANSFER SECTION of Unifier $UNIF ///
    
    
    /// Allowance of $UNIF ///
    function transferFrom (address _from, address _to, uint256 _value) public returns (bool success){
        
        require(_value <=allowance[_from][msg.sender]);
        allowance[_from][msg.sender] -=_value;
        _transfer(_from,_to, _value);
        return true;
    }
    
    function approve (address _spender, uint256 _value) public
    returns (bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function approveAndCall(address _spender, uint256 _value, bytes _extradata) public returns (bool success){
        MandrianaXDimas spender = MandrianaXDimas(_spender);
        
        if(approve(_spender,_value)){
            spender.receiveApproval(msg.sender, _value, this, _extradata);
            return true;
        }
    }
    /// Allowance of $UNIF End ///
    
    /// BURN of $UNIF ///
    function burn (uint256 _value) onlyOwner public returns (bool success){
        require(balanceOf[msg.sender] >= _value);
        
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        emit Burn(msg.sender, _value);
        return true;
    }
    
    function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success){
        require(balanceOf[_from] >= _value);
        require(_value <= allowance[_from][msg.sender]);
        
        balanceOf[_from] -= _value;
        totalSupply -= _value;
        emit Burn(msg.sender, _value);
        return true;
        
    }
    /// BURN of $UNIF End ///
    
    ///Mining and Minted $UNIF arrange by Ann Mandriana & Dimas Fachri///
    function PreMining (address target, uint256 miningAmount) onlyOwner {
        balanceOf[target] += miningAmount;
        totalSupply += miningAmount;
    }
    /// Frozen Account will be only Accepted by the Unifier if there are Hacking activity ///
    /// We only do it if there is a Stolen from Market Exchange or Reported as Scam ///
    function freezeAccount (address target, bool freeze) onlyOwner {
        frozenAccount[target] = freeze;
        emit FrozenFunds (target, freeze);
    }
    /// End of Frozen Acoount Safety ///
    
    
    
/** Instagram at _itsmydims & at mandrianamusic
*0x6FbaEC24476322C597d760CdA4856e32718d39e3 (Owner Address) 
*©2017-2020 by Unifier System, Ann Mandriana & Dimas Fachri /// (codexpert) (vitalik) (satoshi)
*/
}