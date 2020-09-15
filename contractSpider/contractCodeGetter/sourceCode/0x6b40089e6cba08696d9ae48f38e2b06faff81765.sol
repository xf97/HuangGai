/**
 *Submitted for verification at Etherscan.io on 2020-06-29
*/

pragma solidity ^0.4.26;


// ----------------------------------------------------------------------------
//
// Sikoba Network SKO utility token
//
// For details, please visit: https://www.sikoba.com
//
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
//
// SafeMath
//
// ----------------------------------------------------------------------------

library SafeMath {

    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }

    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }

    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

}


// ----------------------------------------------------------------------------
//
// Owned
//
// ----------------------------------------------------------------------------

contract Owned {

    address public owner;
    address public newOwner;

    mapping(address => bool) public isAdmin;

    event OwnershipTransferProposed(address indexed _from, address indexed _to);
    event OwnershipTransferred(address indexed _from, address indexed _to);

    event AdminChange(address indexed _admin, bool _status);

    modifier onlyOwner { require(msg.sender == owner); _; }
    modifier onlyAdmin { require(isAdmin[msg.sender]); _; }

    constructor() public {
        owner = msg.sender;
        isAdmin[owner] = true;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != owner);
        require(_newOwner != address(0x0));
        emit OwnershipTransferProposed(owner, _newOwner);
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function addAdmin(address _a) public onlyOwner {
        require(isAdmin[_a] == false);
        isAdmin[_a] = true;
        emit AdminChange(_a, true);
    }

    function removeAdmin(address _a) public onlyOwner {
        require(isAdmin[_a] == true);
        isAdmin[_a] = false;
        emit AdminChange(_a, false);
    }

}


// ----------------------------------------------------------------------------
//
// ERC20Interface
//
// ----------------------------------------------------------------------------

contract ERC20Interface {

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);

    function totalSupply() public view returns (uint);
    function balanceOf(address _owner) public view returns (uint balance);
    function transfer(address _to, uint _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
    function approve(address _spender, uint _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint remaining);

}

// ----------------------------------------------------------------------------
//
// ERC Token Standard #20
//
// ----------------------------------------------------------------------------

contract ERC20Token is ERC20Interface, Owned {

    using SafeMath for uint;

    uint public tokensIssuedTotal;
    mapping(address => uint) balances;
    mapping(address => mapping (address => uint)) allowed;

    function totalSupply() public view returns (uint) {
        return tokensIssuedTotal;
    }

    function balanceOf(address _owner) public view returns (uint) {
        return balances[_owner];
    }

    function transfer(address _to, uint _amount) public returns (bool) {
        require(_to != 0x0);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function approve(address _spender, uint _amount) public returns (bool) {
        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
        require(_to != 0x0);
        balances[_from] = balances[_from].sub(_amount);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Transfer(_from, _to, _amount);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint) {
        return allowed[_owner][_spender];
    }

}



// ----------------------------------------------------------------------------
//
// Sikoba SKO utility token
//
// ----------------------------------------------------------------------------

contract SikobaToken is ERC20Token {

    /*

    Token sales will be done by minting tokens using this contract and sending 
    these tokens to external token sale smart contracts. Unsold tokens can 
    be burned afterwards, if necessary.

    */


    // Utility variable

    uint constant E18 = 10**18;

    // Basic token data

    string public constant name = "Sikoba Token";
    string public constant symbol = "SKO";
    uint8 public constant decimals = 18;

    // SKO1 token migration

    address public SKO1_ADDRESS = 0x4994e81897a920c0FEA235eb8CEdEEd3c6fFF697;
    uint public constant SKO1_SUPPLY = 1510676914269009862443250;
    uint public sko1ExchangeReserve = 1510676914269009862443250;
    uint public sko1ExchangeDeadline = 1609459200; // 01-JAN-2021 00:00 UTC

    // Token parameters and minting

    uint public constant MAX_TOTAL_TOKEN_SUPPLY = 10**8 * E18; // 100,000,000
    uint public ownerMinted = 0;
    bool public mintingComplete = false;

    // Trade control and Locking

    bool public tokensTradeable = false;
    mapping (address => bool) public unlocked;

    // Migration control

    bool public isMigrationPhaseOpen = false;
    uint public tokensMigrated;


    // Events -----------------------------------------------------------------

    event Unlocked(address _account);
    event Minted(address _account, uint _tokens);
    event Burned(address _account, uint _tokens);
    event Sko1TokensExchanged(address _sender, uint _amount);
    event ExchangeReserveReleased(uint _amount);
    event TokenMigrationRequested(address _sender, uint _amount, uint _total);


    // ------------------------------------------------------------------------
    //
    // Basic Functions

    constructor() public {}

    function () public {}


    // ------------------------------------------------------------------------
    //
    // Owner Functions


    // Locking

    function unlock(address _account) public onlyAdmin {
        unlocked[_account] = true;
        emit Unlocked(_account);
    }

    function unlockMultiple(address[] _accounts) public onlyAdmin {
        require(_accounts.length <= 100);
        for (uint j; j < _accounts.length; j++) {
            unlocked[_accounts[j]] = true;
        }
    }
    
    // Declare Minting Complete
    
    function declareMintingComplete() public onlyOwner {
        mintingComplete = true;
    }

    // Declare Tradeable

    function makeTradeable() public onlyOwner {
        tokensTradeable = true;
    }

    // Declare Migration to Mainnet 

    function openMigrationPhase() public onlyOwner {
        isMigrationPhaseOpen = true;
    }


    // ------------------------------------------------------------------------
    //
    // Minting

    function mint(address _account, uint _tokens) public onlyOwner {
        _mint(_account, _tokens);
    }

    function mintMultiple(address[] _accounts, uint[] _tokens) public onlyOwner {
        require(_accounts.length <= 100);
        require(_accounts.length == _tokens.length);
        for (uint j; j < _accounts.length; j++) {
            _mint(_accounts[j], _tokens[j]);
        }
    }

    function availableToMint() public view returns(uint){
        return MAX_TOTAL_TOKEN_SUPPLY.sub(ownerMinted).sub(sko1ExchangeReserve);
    }

    function _mint(address _account, uint _tokens) private {
        require(mintingComplete == false);
        require(_account != 0x0);
        require(_tokens > 0);
        require(_tokens <= availableToMint());

        // update
        balances[_account] = balances[_account].add(_tokens);
        ownerMinted = ownerMinted.add(_tokens);
        tokensIssuedTotal = tokensIssuedTotal.add(_tokens);

        // log event
        emit Transfer(0x0, _account, _tokens);
        emit Minted(_account, _tokens);
    }


    // ------------------------------------------------------------------------
    //
    // SKO1 Exchange
    //
    // SKO1 token holder needs to call approve() before calling exchangeSKO1tokens()
    //
    // Burns sent SKO1 tokens, issues SKO tokens, reduces sko1ExchangeReserve


    function exchangeSKO1tokens(uint _tokens) public {
        require(now <= sko1ExchangeDeadline);
        require(sko1ExchangeReserve >= _tokens);
        require(ERC20Interface(SKO1_ADDRESS).transferFrom(msg.sender, 0x0, _tokens));
        sko1ExchangeReserve = sko1ExchangeReserve.sub(_tokens);
        _mint(msg.sender, _tokens);
        emit Sko1TokensExchanged(msg.sender, _tokens);
    }

    function releaseSKO1reserve() public onlyOwner {
        require(now > sko1ExchangeDeadline);
        emit ExchangeReserveReleased(sko1ExchangeReserve);
        sko1ExchangeReserve = 0;
    }


    // ------------------------------------------------------------------------
    //
    // Burn tokens

    function burn(uint _tokens) public {
        require(_tokens > 0);
        require(_tokens <= balances[msg.sender]);
        
        balances[msg.sender] = balances[msg.sender].sub(_tokens);
        tokensIssuedTotal = tokensIssuedTotal.sub(_tokens);
        
        emit Transfer(msg.sender, 0x0, _tokens);
        emit Burned(msg.sender, _tokens);        
    }

    function burnAll() public {
        burn(balances[msg.sender]);
    }


    // ------------------------------------------------------------------------
    //
    // Token Migration => Mainnet

    function requestTokenMigrationAll() public {
        requestTokenMigration(balances[msg.sender]);
    }

    function requestTokenMigration(uint _tokens) public {
        require(isMigrationPhaseOpen);
        require(_tokens > 0);
        require(_tokens <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(_tokens);
        tokensIssuedTotal = tokensIssuedTotal.sub(_tokens);
        tokensMigrated = tokensMigrated.add(_tokens);

        emit Transfer(msg.sender, 0x0, _tokens);
        emit TokenMigrationRequested(msg.sender, _tokens, tokensMigrated);
    }



    // ------------------------------------------------------------------------
    //
    // ERC20 functions


    /* Transfer out any accidentally sent ERC20 tokens */

    function transferAnyERC20Token(address _token_address, uint _amount) public onlyOwner returns (bool success) {
        return ERC20Interface(_token_address).transfer(owner, _amount);
    }

    /* Override "transfer" */

    function transfer(address _to, uint _amount) public returns (bool success) {
        require(tokensTradeable || unlocked[msg.sender]);
        return super.transfer(_to, _amount);
    }

    /* Override "transferFrom" */

    function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
        require(tokensTradeable || unlocked[_from]);
        return super.transferFrom(_from, _to, _amount);
    }

    /* Multiple token transfers from one address to save gas */

    function transferMultiple(address[] _addresses, uint[] _amounts) external {
        require(_addresses.length <= 100);
        require(_addresses.length == _amounts.length);
        for (uint j; j < _addresses.length; j++) {
            transfer(_addresses[j], _amounts[j]);
        }
    }
}