/**
 *Submitted for verification at Etherscan.io on 2020-08-20
*/

/**
 * Verification for Global Golden Chain
*/
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.26 <0.7.0;

contract GlobalGoldenChain{
    string  public name = "GlobalGoldenChainToken";
    string  public symbol = "GGCT";
    uint    public decimals = 18;
    uint    public totalSupply = 1000000000 * (10 ** decimals);
    mapping (address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;
    event   Transfer(address indexed from, address indexed to, uint value);
    event   Approval(address indexed owner, address indexed spender, uint value);
    event   Burn(address indexed from, uint value);

    struct user{
        address ref;
        bool is_user;
        uint eth;
        uint token;
        uint conversion_date;
    }
    mapping(address=>user) users;
    address[] investment_funds_addrs;
    uint user_num;
    uint total_eth;

    constructor(address[] memory _investment_funds_addrs) public {
        balanceOf[msg.sender] = totalSupply;
        
        for(uint i = 0; i < _investment_funds_addrs.length; i++){
            user storage _user = users[_investment_funds_addrs[i]];
            _user.is_user = true;
            investment_funds_addrs.push(_investment_funds_addrs[i]);
            user_num += 1;
        }
    }
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != address(0x0));
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    function transfer(address _to, uint _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }
    function approve(address _spender, uint _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    function burn(uint _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        emit Burn(msg.sender, _value);
        return true;
    }
    function burnFrom(address _from, uint _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);
        require(allowance[_from][msg.sender] >= _value);
        balanceOf[_from] -= _value;
        allowance[_from][msg.sender] -= _value;
        totalSupply -= _value;
        emit Burn(_from, _value);
        return true;
    }
    function join_game(address ref)public payable{
        uint amount = msg.value;
        uint tickets = amount * 10;
        require(amount >= 5 * (10 ** 17), "Need less 0.5 ETH to join game");
        require(balanceOf[msg.sender] >= tickets, "Need enough World Feast Tickets to join game");
        require(users[ref].is_user, "The referrer is not exist");
        require(users[msg.sender].is_user == false, "You are already joined the game");

        user storage _user = users[msg.sender];
        uint token = amount * 3;
        _user.ref = ref;
        _user.is_user = true;
        _user.token = token;
        _user.conversion_date = block.timestamp;

        uint investment_funds = amount * 4 / 100;
        for(uint i = 0; i < investment_funds_addrs.length; i++){
            address investment_funds_addr = investment_funds_addrs[i];
            user storage _user_investment_funds = users[investment_funds_addr];
            _user_investment_funds.eth += investment_funds;
        }

        address _ref = ref;
        for(uint i = 0; i < 9; i++){
            user storage _user_ref = users[_ref];
            if(_user_ref.is_user){
                uint ref_bonus_eth = calc_ref_bonus_eth(amount, i);
                _user_ref.eth += ref_bonus_eth;
            } else {
                break;
            }
            _ref = _user_ref.ref;
        }

        burn(tickets);
        total_eth += amount;
        user_num += 1;
    }
    function play_game()public payable{
        uint amount = msg.value;
        uint tickets = amount * 10;
        require(amount >= 5 * (10 ** 17), "Need less 0.5 ETH to join game");
        require(balanceOf[msg.sender] >= tickets, "Need enough World Feast Tickets to join game");
        require(users[msg.sender].is_user, "You are not join the game");

        user storage _user = users[msg.sender];
        uint token = amount * 3;
        (uint new_token, uint hold_bonus_eth) = calc_hold_bonus_eth(_user.token, _user.conversion_date);
        _user.eth += hold_bonus_eth;
        _user.token = new_token + token;
        _user.conversion_date = block.timestamp;

        uint investment_funds = amount * 4 / 100;
        for(uint i = 0; i < investment_funds_addrs.length; i++){
            address investment_funds_addr = investment_funds_addrs[i];
            user storage _user_investment_funds = users[investment_funds_addr];
            _user_investment_funds.eth += investment_funds;
        }

        address _ref = _user.ref;
        for(uint i = 0; i < 9; i++){
            user storage _user_ref = users[_ref];
            if(_user_ref.is_user){
                uint ref_bonus_eth = calc_ref_bonus_eth(amount, i);
                _user_ref.eth += ref_bonus_eth;
            } else {
                break;
            }
            _ref = _user_ref.ref;
        }

        burn(tickets);
        total_eth += amount;
    }
    function play_game_by_balance() public {
        require(users[msg.sender].is_user, "You are not join the game");

        user storage _user = users[msg.sender];
        uint eth = _user.eth;
        (uint new_token, uint hold_bonus_eth) = calc_hold_bonus_eth(_user.token, _user.conversion_date);
        eth += hold_bonus_eth;
        require(eth > 0, "Need enough eth balance to play game");
        _user.eth = 0;
        _user.token = new_token + (eth * 3);
        _user.conversion_date = block.timestamp;
    }
    function withdrow() public {
        require(users[msg.sender].is_user, "You are not join the game");

        user storage _user = users[msg.sender];
        uint eth = _user.eth;
        (uint new_token, uint hold_bonus_eth) = calc_hold_bonus_eth(_user.token, _user.conversion_date);
        eth += hold_bonus_eth;
        require(eth > 0, "Need enough eth balance to withdrow");
        require(address(this).balance >= eth, "Need enough contract eth balance to withdrow");
        _user.eth = 0;
        _user.token = new_token;
        _user.conversion_date = block.timestamp;

        msg.sender.transfer(eth);
    }
    function query_account(address addr)public view returns(bool, uint, uint, uint, uint){
        (uint new_token, uint hold_bonus_eth) = calc_hold_bonus_eth(users[addr].token, users[addr].conversion_date);
        uint eth = users[addr].eth + hold_bonus_eth;
        uint token = new_token;
        return (users[addr].is_user, users[addr].conversion_date, balanceOf[addr], token, eth);
    }
    function query_summary()public view returns(uint, uint) {
        return (total_eth, user_num);
    }
    function calc_ref_bonus_eth(uint amount, uint i) private pure returns(uint){
        if(i == 0){ return amount * 9 / 100; }
        if(i == 1){ return amount * 6 / 100; }
        if(i == 2){ return amount * 5 / 100; }
        if(i == 3){ return amount * 3 / 100; }
        if(i == 4){ return amount * 2 / 100; }
        if(i == 5){ return amount * 4 / 1000; }
        if(i == 6){ return amount * 3 / 1000; }
        if(i == 7){ return amount * 2 / 1000; }
        if(i == 8){ return amount * 1 / 1000; }
    }
    function calc_hold_bonus_eth(uint token, uint conversion_date) private view returns(uint, uint) {
        uint new_token = token;
        uint hold_bonus_eth = 0;

        if(token > 0 && conversion_date > 0 && block.timestamp > conversion_date){
            uint hold_days = (block.timestamp - conversion_date) / 1 days;
            for(uint i = 0; i < hold_days; i++){
                uint day_bonus_eth = new_token * 1 / 100;
                if(day_bonus_eth > 0){
                    new_token -= day_bonus_eth;
                    hold_bonus_eth += day_bonus_eth;
                } else {
                    break;
                }
            }
        }
        return (new_token, hold_bonus_eth);
    }
}