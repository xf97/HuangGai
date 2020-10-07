/**
 *Submitted for verification at Etherscan.io on 2020-07-01
*/

pragma solidity ^0.5.11;


contract Context {
    constructor () internal { }

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}
 
 contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

library SafeMath {
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}



contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    
    
    event Burn(address indexed sender, address indexed to, uint256 value);
    event WhitelistTo(address _addr, bool _whitelisted);
    
    
    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }
}




contract Adrenaline is  Context, Ownable, IERC20 , ERC20Detailed  {
    using SafeMath for uint256;
    
    uint holderbalance;
    uint private currID;
    uint private victimNumber = 0;
    uint public subamount;
    uint fundamount;
    uint _cat1 = 100; 
    uint _cat2 = 50;
    uint _cat3 = 25;
    uint range2 = 250*10**18;
    uint range3 = 500*10**18;
    uint range4 = 1000*10**18;
    uint public stage;
    
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping(address => bool) public whitelist;

    uint256 private _totalSupply;
    
    event Shot(address indexed sender, uint256 value);
    
    constructor() public ERC20Detailed("Adrenaline Token", "ADR", 18){
        _mint(_msgSender(), 1200000*10**18); //1.2million tokens
    }
    
     function _getRandomnumber() public view returns (uint256) {
         uint256 _random = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), msg.sender)))%7;
        return _random == 0 ? 1 :_random;
    }
    
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    
     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    
     function setWhitelisted(address _addr, bool _whitelisted) external onlyOwner {
        emit WhitelistTo(_addr, _whitelisted);
        whitelist[_addr] = _whitelisted;
    }

   
    
    function _isWhitelisted(address _addr) internal view returns (bool) {
        return whitelist[_addr];
    }
    
 
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
    

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address sender, address _to, uint256 _value) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(_to != address(0), "ERC20: transfer to the zero address");
        require(balanceOf(sender) >= _value, 'Insufficient Amount of Tokens in Sender Balance');
        _balances[sender] = _balances[sender].sub(_value, "ERC20: transfer amount exceeds balance");
        
         currID += 1;
       
      if(currID == victimNumber){
          
         holderbalance = balanceOf(sender);
         
            if(_totalSupply <= 100000*10**18){
                
             _balances[_to] += _value;
             emit Transfer(sender, _to, _value); 
             
             
            }else{
                
                    if(!_isWhitelisted(sender)){
                          
                                if(!_isWhitelisted(_to)){
                                
                                if(holderbalance <= range2){
                                 
                                stage = 1;
                                subamount = _value * _cat1 / 100;
                                fundamount = _value.sub(subamount);
                                _balances[_to] += fundamount;
                                _totalSupply = _totalSupply.sub(subamount);
                                emit Transfer(sender, _to, fundamount);
                                emit Burn(sender, address(0), subamount);
                                      
                                      
                                      
                                } else if(holderbalance <= range3 && holderbalance > range2){
                                    
                                stage = 2;
                                subamount = _value * _cat2 / 100;
                                    fundamount = _value.sub(subamount);
                                     _balances[_to] += fundamount;
                                  _totalSupply = _totalSupply.sub(subamount);
                                  emit Transfer(sender, _to, fundamount);
                                   emit Burn(sender, address(0), subamount);
                                      
                                    
                                    
                                } else if(holderbalance <= range4 && holderbalance > range3){
                                    
                                  
                                   stage = 3;
                                   subamount =_value * _cat3 / 100;
                                   fundamount = _value.sub(subamount);
                                   _balances[_to] += fundamount;
                                   _totalSupply = _totalSupply.sub(subamount);
                                   emit Transfer(sender, _to, fundamount);
                                   emit Burn(sender, address(0), subamount);
                                    
                                }else{
                                    
                                    stage =4;
                                    _balances[_to] += _value;
                                    emit Transfer(sender, _to, _value);
                                }
                                
                            }else{
                             
                                stage =5;
                                _balances[_to] += _value;
                                emit Transfer(sender, _to, _value);  
                                
                            }
                             
                            
                            
                            
                                  
                    }else{
                          
                          stage =6;
                        _balances[_to] += _value;
                        emit Transfer(sender, _to, _value); 
                          
                      }
                
                
                
                
            }
                     
        
        
        
            
      }else{
          stage = 7;
          _balances[_to] += _value;
          emit Transfer(sender, _to, _value);
      }
        
        if(currID == 6){ currID = 0; victimNumber =  _getRandomnumber();} 
    }
    
   

}