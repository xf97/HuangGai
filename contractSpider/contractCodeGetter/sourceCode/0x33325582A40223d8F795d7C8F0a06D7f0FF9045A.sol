/**
 *Submitted for verification at Etherscan.io on 2020-07-13
*/

pragma solidity ^0.4.24;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
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

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Token {
    function transfer(address, uint256) public returns (bool) {}

    function transferFrom(
        address,
        address,
        uint256
    ) public returns (bool) {}

    function getSppIdFromHash(bytes32) public returns (uint256) {}

    function setLastPaidAt(bytes32) public returns (bool) {}

    function setRemainingToBeFulfilled(bytes32, uint256)
        public
        returns (bool)
    {}

    function getRemainingToBeFulfilledByHash(bytes32)
        public
        returns (uint256)
    {}

    function setcurrentTokenStats(
        bytes32,
        uint256,
        uint256
    ) public returns (bool) {}

    uint256 public decimals;
    string public name;
}

contract TradeEngine {
    using SafeMath for uint256;

    address public admin;
    address public bnsAddress;
    address public feeAccount;
    address private potentialAdmin;
    uint256 public fee;
    address public usdt;
    uint256 public flag = 0;
    uint256 public discount = 2500000000;
    uint256 public discountLockTill;

    mapping(address => mapping(address => uint256)) public tokens;
    mapping(address => mapping(bytes32 => bool)) public orders;
    mapping(address => mapping(bytes32 => uint256)) public orderFills;
    mapping(address => uint256) public rateToken;
    mapping(address => bool) public dontTakeFeeInBns;

    event Order(
        address indexed tokenGet,
        uint256 amountGet,
        address indexed tokenGive,
        uint256 amountGive,
        uint256 expires,
        uint256 nonce,
        address indexed user
    );
    event Cancel(
        address indexed tokenGet,
        uint256 amountGet,
        address indexed tokenGive,
        uint256 amountGive,
        uint256 expires,
        uint256 nonce,
        address indexed user
    );
    event Trade(
        address indexed tokenGet,
        uint256 amountGet,
        address tokenGive,
        uint256 amountGive,
        address indexed get,
        address indexed give
    );
    event Deposit(
        address indexed token,
        address indexed user,
        uint256 amount,
        uint256 balance
    );
    event Withdraw(
        address indexed token,
        address indexed user,
        uint256 amount,
        uint256 balance
    );
    event DeductFee(
        address indexed payer,
        address indexed token,
        uint256 amount
    );

    constructor() public {
        admin = msg.sender;
        discountLockTill = now + (365 * 86400);
    }

    function() public {
        revert();
    }

    modifier _ownerOnly() {
        require(msg.sender == admin);
        _;
    }

    bool public scLock = false;

    modifier _ifNotLocked() {
        require(scLock == false);
        _;
    }

    function setLock() public _ownerOnly {
        scLock = !scLock;
    }

    function changeAdmin(address admin_) public {
        if (msg.sender != admin) revert();
        potentialAdmin = admin_;
    }

    function becomeAdmin() public {
        if (potentialAdmin == msg.sender) admin = msg.sender;
    }

    function deposit() public payable {
        tokens[0][msg.sender] = SafeMath.add(tokens[0][msg.sender], msg.value);
        emit Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
    }

    function withdraw(uint256 amount) public {
        if (tokens[0][msg.sender] < amount) revert();
        tokens[0][msg.sender] = SafeMath.sub(tokens[0][msg.sender], amount);
        if (!msg.sender.call.value(amount)()) revert();
        emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
    }

    function depositToken(address token, uint256 amount) public {
        //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
        if (token == 0) revert();
        if (!Token(token).transferFrom(msg.sender, this, amount)) revert();
        tokens[token][msg.sender] = SafeMath.add(
            tokens[token][msg.sender],
            amount
        );
        emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
    }

    function withdrawToken(address token, uint256 amount) public {
        if (token == 0) revert();
        if (tokens[token][msg.sender] < amount) revert();
        tokens[token][msg.sender] = SafeMath.sub(
            tokens[token][msg.sender],
            amount
        );
        if (!Token(token).transfer(msg.sender, amount)) revert();
        emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
    }

    function balanceOf(address token, address user)
        public
        view
        returns (uint256 balance)
    {
        return tokens[token][user];
    }

    function order(
        address tokenGet,
        uint256 amountGet,
        address tokenGive,
        uint256 amountGive,
        uint256 expires,
        uint256 nonce
    ) public _ifNotLocked {
        bytes32 hash = sha256(
            abi.encodePacked(
                this,
                tokenGet,
                amountGet,
                tokenGive,
                amountGive,
                expires,
                nonce
            )
        );
        orders[msg.sender][hash] = true;
        emit Order(
            tokenGet,
            amountGet,
            tokenGive,
            amountGive,
            expires,
            nonce,
            msg.sender
        );
    }

    function orderBNS(
        address tokenGet,
        uint256 amountGet,
        address tokenGive,
        uint256 amountGive,
        uint256 expires,
        uint256 nonce,
        address customerAddress
    ) public returns (bool success) {
        if (msg.sender != bnsAddress) {
            return false;
        }
        bytes32 hash = sha256(
            abi.encodePacked(
                this,
                tokenGet,
                amountGet,
                tokenGive,
                amountGive,
                expires,
                nonce
            )
        );
        orders[customerAddress][hash] = true;
        emit Order(
            tokenGet,
            amountGet,
            tokenGive,
            amountGive,
            expires,
            nonce,
            customerAddress
        );
        return true;
    }

    function trade(
        address tokenGet,
        uint256 amountGet,
        address tokenGive,
        uint256 amountGive,
        uint256 expires,
        uint256 nonce,
        address user,
        uint256 amount
    ) public _ifNotLocked {
        bytes32 hash = sha256(
            abi.encodePacked(
                this,
                tokenGet,
                amountGet,
                tokenGive,
                amountGive,
                expires,
                nonce
            )
        );
        if (
            !(orders[user][hash] &&
                block.number <= expires &&
                SafeMath.add(orderFills[user][hash], amount) <= amountGet)
        ) revert();
        tradeBalances(
            tokenGet,
            amountGet,
            tokenGive,
            amountGive,
            user,
            amount,
            hash
        );
        orderFills[user][hash] = SafeMath.add(orderFills[user][hash], amount);
        emit Trade(
            tokenGet,
            amount,
            tokenGive,
            (amountGive * amount) / amountGet,
            user,
            msg.sender
        );
    }

    function tradeBalances(
        address tokenGet,
        uint256 amountGet,
        address tokenGive,
        uint256 amountGive,
        address user,
        uint256 amount,
        bytes32 hash
    ) private {
        uint256 satisfied = SafeMath.div(
            SafeMath.mul(amountGive, amount),
            amountGet
        );
        uint256 feeTokenGet = (amount * fee) / 10000;
        uint256 feeTokenGive = (satisfied * fee) / 10000;
        flag = 0;

        tokens[tokenGet][msg.sender] = SafeMath.sub(
            tokens[tokenGet][msg.sender],
            amount
        );
        tokens[tokenGet][user] = SafeMath.add(tokens[tokenGet][user], amount);

        require(
            TradeEngine(this).deductFee(user, tokenGet, feeTokenGet),
            "unable to charge fee 1"
        );

        if (Token(bnsAddress).getSppIdFromHash(hash) != 0) {
            if (flag == 1) {
                require(
                    Token(bnsAddress).setcurrentTokenStats(
                        hash,
                        amount,
                        satisfied
                    ),
                    "fail7"
                );
                flag = 0;
            } else {
                require(
                    Token(bnsAddress).setcurrentTokenStats(
                        hash,
                        amount - feeTokenGet,
                        satisfied
                    ),
                    "fail8"
                );
            }
        }

        tokens[tokenGive][user] = SafeMath.sub(
            tokens[tokenGive][user],
            satisfied
        );
        tokens[tokenGive][msg.sender] = SafeMath.add(
            tokens[tokenGive][msg.sender],
            satisfied
        );

        require(
            TradeEngine(this).deductFee(msg.sender, tokenGive, feeTokenGive),
            "unable to charge fee 2"
        );
        flag = 0;

        if (Token(bnsAddress).getSppIdFromHash(hash) != 0) {
            if (
                Token(bnsAddress).getRemainingToBeFulfilledByHash(hash) ==
                satisfied
            ) {
                require(Token(bnsAddress).setLastPaidAt(hash), "fail1");
                // require(Token(bnsAddress).setOnGoing(hash),"fail2");
                require(
                    Token(bnsAddress).setRemainingToBeFulfilled(
                        hash,
                        satisfied
                    ),
                    "fail3"
                );
            } else {
                require(
                    Token(bnsAddress).setRemainingToBeFulfilled(
                        hash,
                        satisfied
                    ),
                    "fail4"
                );
            }
        }
    }

    function testTrade(
        address tokenGet,
        uint256 amountGet,
        address tokenGive,
        uint256 amountGive,
        uint256 expires,
        uint256 nonce,
        address user,
        uint256 amount,
        address sender
    ) public view returns (bool) {
        if (
            !(block.number <= expires &&
                tokens[tokenGet][sender] >= amount &&
                availableVolume(
                    tokenGet,
                    amountGet,
                    tokenGive,
                    amountGive,
                    expires,
                    nonce,
                    user
                ) >=
                amount)
        ) return false;
        return true;
    }

    function availableVolume(
        address tokenGet,
        uint256 amountGet,
        address tokenGive,
        uint256 amountGive,
        uint256 expires,
        uint256 nonce,
        address user
    ) public view returns (uint256) {
        bytes32 hash = sha256(
            abi.encodePacked(
                this,
                tokenGet,
                amountGet,
                tokenGive,
                amountGive,
                expires,
                nonce
            )
        );
        if (!(orders[user][hash] && block.number <= expires)) return 0;
        uint256 available1 = SafeMath.sub(amountGet, orderFills[user][hash]);
        uint256 available2 = SafeMath.mul(tokens[tokenGive][user], amountGet) /
            amountGive;
        if (available1 < available2) return available1;
        return available2;
    }

    function amountFilled(
        address tokenGet,
        uint256 amountGet,
        address tokenGive,
        uint256 amountGive,
        uint256 expires,
        uint256 nonce,
        address user
    ) public view returns (uint256) {
        bytes32 hash = sha256(
            abi.encodePacked(
                this,
                tokenGet,
                amountGet,
                tokenGive,
                amountGive,
                expires,
                nonce
            )
        );
        return orderFills[user][hash];
    }

    function cancelOrder(
        address tokenGet,
        uint256 amountGet,
        address tokenGive,
        uint256 amountGive,
        uint256 expires,
        uint256 nonce
    ) public {
        bytes32 hash = sha256(
            abi.encodePacked(
                this,
                tokenGet,
                amountGet,
                tokenGive,
                amountGive,
                expires,
                nonce
            )
        );
        if (!orders[msg.sender][hash]) revert();
        orderFills[msg.sender][hash] = amountGet;
        orders[msg.sender][hash] = false;
        // if(Token(bnsAddress).getSppIdFromHash(hash)!=0) require(Token(bnsAddress).setOnGoing(hash),"fail6");
        emit Cancel(
            tokenGet,
            amountGet,
            tokenGive,
            amountGive,
            expires,
            nonce,
            msg.sender
        );
    }

    function _deduct(
        address _payer,
        address _token,
        uint256 _amount
    ) internal {
        tokens[_token][_payer] = tokens[_token][_payer].sub(_amount);
        tokens[_token][feeAccount] = tokens[_token][feeAccount].add(_amount);
        emit DeductFee(_payer, _token, _amount);
    }

    function deductFee(
        address payer,
        address token,
        uint256 amount
    ) public returns (bool res) {
        require(
            (msg.sender == address(this) || msg.sender == bnsAddress),
            "this can only be called by bnsAddress or this contract"
        );

        if (dontTakeFeeInBns[payer] == true) {
            _deduct(payer, token, amount);
            return true;
        }

        uint256 eqvltBNS;
        uint256 feeBNS;

        eqvltBNS = SafeMath.div(
            SafeMath.div(
                SafeMath.mul(
                    SafeMath.mul(amount, rateToken[token]),
                    10**Token(bnsAddress).decimals()
                ),
                10**Token(token).decimals()
            ),
            rateToken[bnsAddress]
        );

        feeBNS = ((eqvltBNS * (100 - (discount / 100000000))) / 100);
        if (tokens[bnsAddress][payer] >= feeBNS) {
            flag = 1;
            _deduct(payer, bnsAddress, feeBNS);
            return true;
        } else {
            _deduct(payer, token, amount);
            return true;
        }

        return false;
    }

    function setAddresses(address usdt1, address feeAccount1)
        public
        _ownerOnly
    {
        usdt = usdt1;
        feeAccount = feeAccount1;
    }

    function setDiscount() public _ownerOnly {
        require(
            now >= discountLockTill,
            "too early to change discount rate..."
        );
        discount = SafeMath.div(discount, 2);
        discountLockTill = SafeMath.add(discountLockTill, (365 * 86400));
    }

    function toggleTakingBnsAsFee() public {
        dontTakeFeeInBns[msg.sender] = !dontTakeFeeInBns[msg.sender];
    }

    function setRateToken(address[] token, uint256[] rate) public _ownerOnly {
        for (uint256 i = 0; i < token.length; i++) {
            rateToken[token[i]] = rate[i];
        }
    }

    function setbnsAddress(address _add) public _ownerOnly {
        bnsAddress = _add;
    }

    function setFeePercent(uint256 fee1) public _ownerOnly {
        require((fee1 <= 50), "cant be more than 50");
        fee = fee1;
    }
}