/**
 *Submitted for verification at Etherscan.io on 2020-06-09
*/

pragma solidity 0.5.6;
pragma solidity ^0.5.5;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following 
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

contract FlipCoin {
    uint constant private PERIOD_EXPIRED = 1 days;
    uint internal platformFeeAccumulated;
    address payable private creator;
    mapping (uint => uint) internal CHALLENGES;
    mapping (address  => mapping (uint  => uint)) internal currentGames;

    constructor(address payable _creator) public {
        CHALLENGES[1] = 0.01 ether;
        CHALLENGES[2] = 0.05 ether;
        CHALLENGES[3] = 0.1 ether;
        CHALLENGES[4] = 0.5 ether;
        CHALLENGES[5] = 1 ether;
        CHALLENGES[6] = 2 ether;
        CHALLENGES[7] = 5 ether;
        CHALLENGES[8] = 10 ether;
        creator = _creator;
        platformFeeAccumulated = 0;
    }

    event GameResult(
        address indexed betMaker,
        uint256 bet,
        address indexed winner,
        address indexed loser,
        uint256 prize,
        uint timestamp
    );

    event BetMade(
        address indexed player,
        uint256 amount,
        uint timestamp
    );

    event Withdrawn(
        address indexed player,
        uint256 amount,
        uint timestamp
    );

    modifier onlyCreator() {
        require(msg.sender == creator, "Caller is not the creator");
        _;
    }

    function destroy() external onlyCreator {
        selfdestruct(creator);
    }

    function getMyBets() external view returns (uint[] memory) {
        uint[] memory bets = new uint[](9);
        for (uint i = 1; i <= 8; i++) {
            if (currentGames[msg.sender][i] > 0) {
                bets[i] = currentGames[msg.sender][i];
            }
        }
        return bets;
    }

    function WithdrawPlatformFee () external onlyCreator {
        require(platformFeeAccumulated > 0, "Not enought balance");
        uint balance = address(this).balance;
        uint valueToWithdraw = balance > platformFeeAccumulated ? platformFeeAccumulated : balance;
        assert(valueToWithdraw > 0);
        creator.transfer(valueToWithdraw);
        platformFeeAccumulated -= valueToWithdraw;
    }

    function () external payable {
        require(msg.value != 0, "Bet cannot be zero");
        require(msg.sender != address(0), "This wallet is not allowed");

        address opponent = bytesToAddress(msg.data);
        require(msg.sender != opponent, "bet maker and opponent cannot be the same");

        uint betIndex = 0;
        for (uint i = 1; i <= 8; i++) {
            if (CHALLENGES[i] == msg.value) {
                betIndex = i;
                break;
            }
        }

        require(betIndex > 0, "bet must be one of the predefined");

        if(opponent == address(0)) {
            makeBet(betIndex);
        } else {
            if(!closeBet(betIndex, Address.toPayable(opponent))) {
                makeBet(betIndex);
            }
        }
    }

    function withdrawMyBets() external {
        uint amountToWithdraw = 0;
        uint8[9] memory bets = [0, 0, 0, 0, 0, 0, 0, 0, 0];
        for (uint i = 1; i <= 8; i++) {
            if(currentGames[msg.sender][i] > 0 && now > currentGames[msg.sender][i]) {
                amountToWithdraw += CHALLENGES[i];
                delete currentGames[msg.sender][i];
                bets[i] = 1;
            }
        }

        require(amountToWithdraw > 0, "At least one bet should be expired");
        msg.sender.transfer(amountToWithdraw);

        for (uint i = 1; i <= 8; i++) {
            if(bets[i] != 0) {
                emit Withdrawn(msg.sender, CHALLENGES[i], now);
            }
        }
    }

    function bytesToAddress(bytes memory bys) private pure returns (address payable  addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }

    function random() private view returns (bool) {
        require(!Address.isContract(msg.sender), "Game cannot be executed by contract address");
        uint blockNumberOffset = uint(keccak256(abi.encodePacked(address(this).balance))) % 100;
        return uint(blockhash(block.number - 10 - blockNumberOffset)) % 2 == 0 ? true : false;
    }

    function closeBet(uint betIndex, address payable opponent) private returns (bool) {
        if(currentGames[opponent][betIndex] == 0)
            return false;
        if (now > currentGames[opponent][betIndex])
            return false;
        uint full = mul256(CHALLENGES[betIndex], 2); // 2% comission.
        uint percent = div256(full, 100);
        platformFeeAccumulated += mul256(percent, 2);
        uint prize = mul256(percent, 98); // 98% is prize.
        if(random()) {
            msg.sender.transfer(prize);
            emit GameResult(opponent, CHALLENGES[betIndex], msg.sender, opponent, prize, now);
        } else {
            opponent.transfer(prize);
            emit GameResult(opponent, CHALLENGES[betIndex], opponent, msg.sender, prize, now);
        }
        delete currentGames[opponent][betIndex];
        return true;
    }

    function makeBet(uint betIndex) private {
        require (currentGames[msg.sender][betIndex] == 0, "Bet with this value already exists");
        currentGames[msg.sender][betIndex] = now + PERIOD_EXPIRED;
        emit BetMade(msg.sender, CHALLENGES[betIndex], now);
    }

    function mul256(uint a, uint b) private pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "Multiplication overflow");

        return c;
    }

    function div256(uint a, uint b) private pure returns (uint) {
        require(b > 0, "Division by zero");
        return a / b;
    }
}