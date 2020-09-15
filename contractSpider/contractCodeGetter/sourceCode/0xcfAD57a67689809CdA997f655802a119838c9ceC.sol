/**
 *Submitted for verification at Etherscan.io on 2020-06-30
*/

pragma solidity ^0.4.24;

/**Copyright (C) 2020 US Benscoin Protocol *Code by Ann Mandriana
*All righst reserved.
*Author : Benscoin Beni Syahroni Company supported by Ann Mandriana & Dimas Fachri
*/

interface Benscoin { function receiveApproval (address _from, uint256 _value, address _token, bytes _extradata) external;}

contract BenscoinProtocol {
    address public owner;
    
    constructor(){
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function transferOwnership (address newOwner) onlyOwner {
        owner = newOwner;
    }
}

contract BeniSyahroni is BenscoinProtocol {

    string public name = "Benscoin";
    string public symbol = "BSC";
    uint8 public decimals = 7;
    uint256 public totalSupply;
    
    mapping (address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public frozenAccount;
    
    event Transfer ( address indexed from, address indexed to, uint256 value );
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed from, uint256 value);
    event FrozenFunds(address target, bool frozen);
    
    constructor(
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol
        ) public{
            totalSupply = initialSupply*10**uint256(decimals);
            balanceOf[msg.sender] = totalSupply;
            name = tokenName;
            symbol = tokenSymbol;
    }
    
/** TRANSFER SECTION by Beni Syahroni,S.Pd.I
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
    /// END of TRANSFER of Benscoin $BSC ///
    
    
    /// Allowance of $BSC ///
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
        Benscoin spender = Benscoin(_spender);
        
        if(approve(_spender,_value)){
            spender.receiveApproval(msg.sender, _value, this, _extradata);
            return true;
        }
    }
    /// Allowance of $BSC End ///
    
    /// BURN of $BSC ///
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
    /// BURN of $BSC End ///
    
    function PreMining (address target, uint256 miningAmount) onlyOwner {
        balanceOf[target] += miningAmount;
        totalSupply += miningAmount;
    }

    /// We only do it if there is a Stolen from Market Exchange or Reported as Scam ///
    function freezeAccount (address target, bool freeze) onlyOwner {
        frozenAccount[target] = freeze;
        emit FrozenFunds (target, freeze);
    }
    /// End of Frozen Acoount Safety ///
    
    
    
/** Beni Syahroni S,Pd.I
*©2020 by US Benscoin Protocol, Ann Mandriana & Beni Syahroni
*/
}