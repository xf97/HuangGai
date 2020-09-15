/**
 *Submitted for verification at Etherscan.io on 2020-05-26
*/

pragma solidity >=0.5.6;


interface xEtherTokensContractInterface {
    function ecosystemDividends() external payable;
}


contract XetherSicboLottery {
    uint256 public HOUSE_EDGE_MINIMUM_AMOUNT = 0.0009 ether;
    uint256 public TICKET_PRICE = 0.01 ether;
    uint256 public MAX_AMOUNT = 100 ether;
    uint256 constant BET_EXPIRATION_BLOCKS = 250;
    uint16 constant JACKPOT_MODULO = 10000;
    uint256 public JACKPOT_FEE = 0.001 ether;
    uint256 lastTicketTime = now;
    uint8 averageLotteryLock = 1;

    uint256 public MIN_BET = 0.01 ether;
    uint256 public MIN_JACKPOT_BET = 0.1 ether;

    address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    uint256 public maxProfitLottery = 5 ether;
    uint256 public maxProfitSicbo = 1 ether;
    uint8 public TICKET_MAX_COUNT = 100;

    uint256 public sicboTableLimit = 2 ether;
    uint8[] public sumPayput = [
        61,
        31,
        18,
        13,
        9,
        7,
        7,
        7,
        7,
        9,
        13,
        18,
        31,
        61
    ];
    uint8[2][15] public pairBet = [
        [1, 2],
        [1, 3],
        [1, 4],
        [1, 5],
        [1, 6],
        [2, 3],
        [2, 4],
        [2, 5],
        [2, 6],
        [3, 4],
        [3, 5],
        [3, 6],
        [4, 5],
        [4, 6],
        [5, 6]
    ];

    uint8 public DIVIDENDS_PERCENT = 10; // 1% example: 15 will be 1.5%
    uint8 public ADVERTISE_PERCENT = 0; // 1%
    uint8 public HOUSE_EDGE_PERCENT = 10; // 1%
    uint16 constant PERCENTAGES_BASE = 1000;
    uint256 constant DIVIDENDS_LIMIT = 1 ether;

    uint16 public luckyNumberLottery = 7777;
    uint16 public luckyNumberSicbo = 777;
    uint256 public jackpotSizeLottery;
    uint256 public jackpotSizeSicbo;
    uint256 public jackpotSize = 0;

    uint8 public gamesStopped = 0;

    struct Ticket {
        uint256 amount;
        uint256 count;
        uint40 placeBlockNumber;
        address payable gambler;
        uint128 locked;
        uint256 clientSeed;
    }
    mapping(uint256 => Ticket) tickets;

    struct Bet {
        uint256 totalBetAmount;
        uint128 locked;
        mapping(uint8 => uint256) amount;
        mapping(uint8 => uint8) bettype;
        uint40 placeBlockNumber;
        uint256 clientSeed;
        mapping(uint8 => uint256) nums;
        address payable gambler;
        uint8 betsCount;
    }
    mapping(uint256 => Bet) bets;
    mapping(address => uint256) public bonusProgrammAccumulated;

    xEtherTokensContractInterface public xEtherTokensContract;

    address public owner;
    address private nextOwner;
    address public moderator;

    uint256 public totalDividends = 0;
    uint256 public totalAdvertise = 0;

    address public secretSigner;
    address public croupier;
    uint128 public lockedInBetsLottery;
    uint128 public lockedInBetsSicbo;

    event PaymentLottery(
        address beneficiary,
        uint256 commit,
        uint256 amount,
        string paymentType,
        uint256[] numbers
    );
    event PaymentSicbo(
        address beneficiary,
        uint256 commit,
        uint256 amount,
        string paymentType
    );
    event JackpotSicboPayment(
        address indexed beneficiary,
        uint256 commit,
        uint256 amount
    );
    event JackpotLotteryPayment(
        address indexed beneficiary,
        uint256 commit,
        uint256 amount
    );

    event PayDividendsSuccess(uint256 time, uint256 amount);
    event PayDividendsFailed(uint256 time, uint256 amount);

    event CommitLottery(uint256 commit, uint256 clientSeed, uint256 amount);
    event CommitSicbo(uint256 commit, uint256 clientSeed, uint256 amount);

    modifier onlyModeration {
        require(
            msg.sender == owner || msg.sender == moderator,
            "Moderation methods called by non-moderator."
        );
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "OnlyOwner methods called by non-owner.");
        _;
    }

    modifier onlyCroupier {
        require(
            msg.sender == croupier,
            "OnlyCroupier methods called by non-croupier."
        );
        _;
    }

    function approveNextOwner(address _nextOwner) external onlyOwner {
        require(_nextOwner != owner, "Cannot approve current owner.");
        nextOwner = _nextOwner;
    }

    function acceptNextOwner() external {
        require(
            msg.sender == nextOwner,
            "Can only accept preapproved new owner."
        );
        owner = nextOwner;
    }

    function setMaxProfit(uint256 _maxProfit, uint8 game) public onlyOwner {
        require(
            _maxProfit < MAX_AMOUNT,
            "maxProfit cant be great then top limit."
        );

        if (game == 0) {
            maxProfitSicbo = _maxProfit;
        } else {
            maxProfitLottery = _maxProfit;
        }
    }

    function changeMaxTickets(uint8 _newMaxTickets) external onlyOwner {
        require(
            0 <= _newMaxTickets && _newMaxTickets < 1000,
            "Wrong tickets number"
        );
        TICKET_MAX_COUNT = _newMaxTickets;
    }

    function getBonusProgrammLevel(address gambler)
        public
        view
        returns (uint8 discount)
    {
        uint256 accumulated = bonusProgrammAccumulated[gambler];
        discount = 0;

        if (accumulated >= 20 ether && accumulated < 100 ether) {
            discount = 1;
        } else if (accumulated >= 100 ether && accumulated < 500 ether) {
            discount = 2;
        } else if (accumulated >= 500 ether && accumulated < 1000 ether) {
            discount = 3;
        } else if (accumulated >= 1000 ether && accumulated < 5000 ether) {
            discount = 4;
        } else if (accumulated >= 5000 ether) {
            discount = 5;
        }
    }

    function() external payable {}

    function setNewPercents(
        uint8 newHouseEdgePercent,
        uint8 newDividendsPercent,
        uint8 newAdvertPercent
    ) external onlyModeration {
        // We guarantee that dividends will be minimum 0.5%
        require(newDividendsPercent >= 5, "dividentds limit");
        // Total percentages not greater then 3%
        require(
            newHouseEdgePercent + newDividendsPercent + newAdvertPercent <= 30,
            "Total percentages not greater then 3%"
        );

        HOUSE_EDGE_PERCENT = newHouseEdgePercent;
        ADVERTISE_PERCENT = newAdvertPercent;
        DIVIDENDS_PERCENT = newDividendsPercent;
    }

    function setAdditionalVariables(
        uint256 he,
        uint256 mjb,
        uint256 jf,
        uint256 mb,
        uint256 ma,
        uint8 al
    ) external onlyModeration {
        if (he != 0 && he > 0) {
            HOUSE_EDGE_MINIMUM_AMOUNT = he;
        }
        if (mjb != 0 && mjb > 0) {
            MIN_JACKPOT_BET = mjb;
        }
        if (jf != 0 && jf > 0) {
            JACKPOT_FEE = jf;
        }
        if (mb != 0 && mb > 0) {
            MIN_BET = mb;
        }
        if (ma != 0 && ma > 0) {
            MAX_AMOUNT = ma;
        }
        if (al != 0 && al > 0) {
            averageLotteryLock = al;
        }
    }

    function stopGames(uint8 _stopGames) external onlyModeration {
        gamesStopped = _stopGames;
    }

    function setTableLimit(uint256 _newTableLimit) public onlyModeration {
        require(
            _newTableLimit < MAX_AMOUNT,
            "tableLimit cant be great then top limit."
        );
        sicboTableLimit = _newTableLimit;
    }

    function setXEtherContract(address xEtherContract) external onlyModeration {
        xEtherTokensContract = xEtherTokensContractInterface(xEtherContract);
    }

    function setAddresses(
        address newCroupier,
        address newSecretSigner,
        address newModerator
    ) external onlyModeration {
        secretSigner = newSecretSigner;
        croupier = newCroupier;
        moderator = newModerator;
    }

    function increaseJackpot(uint256 increaseAmount, uint8 game)
        external
        onlyModeration
    {
        require(
            increaseAmount <= address(this).balance,
            "Increase amount larger than balance."
        );

        if (game == 0) {
            require(
                jackpotSizeSicbo + lockedInBetsSicbo + increaseAmount <=
                    address(this).balance,
                "Not enough funds."
            );
            jackpotSizeSicbo += uint128(increaseAmount);
        } else {
            require(
                jackpotSizeLottery + lockedInBetsLottery + increaseAmount <=
                    address(this).balance,
                "Not enough funds."
            );
            jackpotSizeLottery += uint128(increaseAmount);
        }
    }

    function releaseLockedInBetSicboAmount() external onlyModeration {
        lockedInBetsSicbo = 0;
    }

    function releaseLockedInBetLotteryAmount() external onlyModeration {
        lockedInBetsLottery = 0;
    }

    function withdrawFunds(address payable beneficiary, uint256 withdrawAmount)
        external
        onlyOwner
    {
        require(
            withdrawAmount <= address(this).balance,
            "Increase amount larger than balance."
        );
        require(
            jackpotSizeSicbo +
                jackpotSizeLottery +
                lockedInBetsSicbo +
                lockedInBetsLottery +
                withdrawAmount <=
                address(this).balance,
            "Not enough funds."
        );
        sendFundsSicbo(beneficiary, withdrawAmount, 0, "withdraw");
    }

    function withdrawAdvertiseFunds(
        address payable beneficiary,
        uint256 withdrawAmount
    ) external onlyOwner {
        require(
            withdrawAmount <= totalAdvertise,
            "Increase amount larger than balance."
        );
        totalAdvertise = 0;
        sendFundsSicbo(beneficiary, withdrawAmount, 0, "withdraw");
    }

    function withdrawLotteryJackpot(
        address payable beneficiary,
        uint256 withdrawAmount
    ) external onlyOwner {
        require(
            withdrawAmount <= jackpotSizeLottery,
            "Increase amount larger than balance."
        );
        require(
            now >= lastTicketTime + 1 days,
            "Withdraw jacpot on 1 day inactivity"
        );
        jackpotSizeLottery -= withdrawAmount;
        uint256[] memory tmp;
        sendFundsLottery(beneficiary, withdrawAmount, 0, "withdraw", tmp);
    }

    function end() external onlyOwner {
        require(
            lockedInBetsSicbo == 0 && lockedInBetsLottery == 0,
            "All bets should be processed (settled or refunded) before self-destruct."
        );
        selfdestruct(address(uint160(owner)));
    }

    function sendDividends() public payable {
        if (address(xEtherTokensContract) != address(0)) {
            uint256 tmpDividends = totalDividends;
            xEtherTokensContract.ecosystemDividends.value(tmpDividends)();
            totalDividends = 0;

            emit PayDividendsSuccess(now, tmpDividends);
        }
    }

    // ----------- SicBo ------------
    function placeBet(
        uint8[] calldata betType,
        uint256[] calldata betNums,
        uint256[] calldata betAmount,
        uint256 commitLastBlock,
        uint256 commit,
        uint256 clientSeed,
        bytes32 r,
        bytes32 s
    ) external payable {
        require(gamesStopped == 0, "Games is running");

        Bet storage bet = bets[commit];

        require(
            msg.value <= sicboTableLimit,
            "Bets sum must be LTE table limit"
        );
        require(
            uint8(betNums.length) == uint8(betType.length) &&
                uint8(betNums.length) == uint8(betAmount.length),
            "Arguments length not match"
        );
        bet.betsCount = uint8(betNums.length);

        require(bet.gambler == address(0), "Bet should be in a 'clean' state.");
        require(block.number <= commitLastBlock, "Commit has expired.");
        require(
            secretSigner ==
                ecrecover(
                    keccak256(
                        abi.encodePacked(uint40(commitLastBlock), commit)
                    ),
                    27,
                    r,
                    s
                ) ||
                secretSigner ==
                ecrecover(
                    keccak256(
                        abi.encodePacked(uint40(commitLastBlock), commit)
                    ),
                    28,
                    r,
                    s
                ),
            "ECDSA signature is not valid."
        );

        if (totalDividends >= DIVIDENDS_LIMIT) {
            sendDividends();
        }

        bet.gambler = msg.sender;
        placeBetProcess(commit, betType, betNums, betAmount);

        lockedInBetsSicbo += bet.locked;
        require(
            lockedInBetsSicbo <= address(this).balance,
            "Cannot afford to lose this bet."
        );

        bonusProgrammAccumulated[msg.sender] += msg.value;

        bet.totalBetAmount = msg.value;
        bet.placeBlockNumber = uint40(block.number);
        bet.clientSeed = clientSeed;

        emit CommitSicbo(commit, clientSeed, msg.value);
    }

    function placeBetProcess(
        uint256 commit,
        uint8[] memory betType,
        uint256[] memory betNums,
        uint256[] memory betAmount
    ) internal {
        Bet storage bet = bets[commit];

        uint256 totalBetAmount = 0;
        uint128 possibleWinAmount;

        uint256 jackpotFee = msg.value >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
        uint256 feeToJP = msg.value >= MIN_JACKPOT_BET
            ? JACKPOT_FEE / bet.betsCount
            : 0;

        for (uint8 count = 0; count < bet.betsCount; count += 1) {
            require(
                betAmount[count] >= MIN_BET && betAmount[count] <= MAX_AMOUNT,
                "Amount should be within range."
            );

            totalBetAmount += betAmount[count];
            require(
                totalBetAmount <= msg.value,
                "Total bets amount should be LTE amount"
            );

            uint8[3] memory tmp1;

            possibleWinAmount = getDiceWinAmount(
                betAmount[count] - feeToJP,
                betType[count],
                bet.gambler,
                betNums[count],
                tmp1,
                true
            );
            require(
                possibleWinAmount <= betAmount[count] + maxProfitSicbo,
                "maxProfitPlinko limit violation."
            );

            if (possibleWinAmount > bet.locked) {
                bet.locked = possibleWinAmount;
            }

            bet.nums[count] = betNums[count];
            bet.bettype[count] = betType[count];
            bet.amount[count] = betAmount[count];
        }

        jackpotSizeSicbo += uint128(jackpotFee);
    }

    function settleBet(uint256 reveal) external onlyCroupier {
        uint256 commit = uint256(keccak256(abi.encodePacked(reveal)));

        Bet storage bet = bets[commit];
        uint256 placeBlockNumber = bet.placeBlockNumber;

        require(bet.totalBetAmount > 0, "Bet already processed");
        require(
            block.number > placeBlockNumber,
            "settleBet in the same block as placeBet, or before."
        );
        require(
            block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS,
            "Can't be queried by EVM."
        );

        settleBet(bet, reveal);
    }

    function settleBet(Bet storage bet, uint256 reveal) private {
        require(bet.totalBetAmount != 0, "Bet should be in an 'active' state");
        address payable gambler = bet.gambler;
        bytes32 entropy = keccak256(abi.encodePacked(reveal, bet.clientSeed));

        uint8[3] memory dice = [
            uint8((uint256(entropy) % 6) + 1),
            uint8(((uint256(entropy) / 6) % 6) + 1),
            uint8(((uint256(entropy) / 6 / 6) % 6) + 1)
        ];

        uint256 diceWin = 0;
        uint256 possibleWinAmount = 0;
        uint256 feeToJP = bet.totalBetAmount >= MIN_JACKPOT_BET
            ? JACKPOT_FEE / bet.betsCount
            : 0;

        for (uint8 index = 0; index < bet.betsCount; index += 1) {
            possibleWinAmount = getDiceWinAmount(
                bet.amount[index] - feeToJP,
                bet.bettype[index],
                bet.gambler,
                bet.nums[index],
                dice,
                false
            );
            diceWin += possibleWinAmount;
        }

        lockedInBetsSicbo -= bet.locked;

        uint256 jackpotWin = checkJackPotWin(entropy, 6, 0);
        if (jackpotWin > 0) {
            emit JackpotSicboPayment(
                gambler,
                uint256(keccak256(abi.encodePacked(reveal))),
                jackpotWin
            );
        }

        sendFundsSicbo(
            gambler,
            diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin,
            uint256(keccak256(abi.encodePacked(reveal))),
            "payment"
        );

        bet.totalBetAmount = 0;
    }

    function getDiceWinAmount(
        uint256 amount,
        uint8 betType,
        address gambler,
        uint256 nums,
        uint8[3] memory dice,
        bool init
    ) private returns (uint128 winAmount) {
        uint256 tmp = 0;
        uint256 totalPercentages = HOUSE_EDGE_PERCENT +
            ADVERTISE_PERCENT +
            DIVIDENDS_PERCENT;
        uint256 houseEdge = (amount *
            (totalPercentages - getBonusProgrammLevel(gambler))) /
            PERCENTAGES_BASE;

        if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
            houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
        }

        if (init) {
            totalDividends += (amount * DIVIDENDS_PERCENT) / PERCENTAGES_BASE;
            totalAdvertise += (amount * ADVERTISE_PERCENT) / PERCENTAGES_BASE;

            if (betType == 0 || betType == 1) {
                require(nums == 0, "Wrong number");
                tmp = amount * 2;
            }
            if (betType == 2) {
                require(nums > 0 && nums <= 6, "Wrong number");
                tmp = amount * 4;
            }
            if (betType == 3) {
                require(nums >= 0 && nums <= 14, "Wrong number");
                tmp = amount * 6;
            }
            if (betType == 4) {
                require(nums >= 4 && nums <= 17, "Wrong number");
                tmp = amount * sumPayput[nums - 4];
            }
            if (betType == 5) {
                require(nums >= 1 && nums <= 6, "Wrong number");
                tmp = amount * 11;
            }
            if (betType == 6) {
                require(nums >= 1 && nums <= 6, "Wrong number");
                tmp = amount * 181;
            }
            if (betType == 7) {
                require(nums == 0, "Wrong number");
                tmp = amount * 31;
            }

            winAmount = uint128(tmp);
        } else {
            uint8 rate = checkBet(betType, nums, dice);
            winAmount = uint128((amount - houseEdge) * rate);
        }
    }

    function checkBet(
        uint8 betType,
        uint256 nums,
        uint8[3] memory dices
    ) private view returns (uint8 rate) {
        uint8 sum = dices[0] + dices[1] + dices[2];
        uint8 ismatch = 0;
        rate = 0;

        if (betType == 0) {
            // Small bet
            if (dices[0] == dices[1] && dices[0] == dices[2]) {
                rate = 0;
            } else if (sum >= 4 && sum <= 10) {
                rate = 2;
            }
        }

        if (betType == 1) {
            // Big bet
            if (dices[0] == dices[1] && dices[0] == dices[2]) {
                rate = 0;
            } else if (sum >= 11 && sum <= 17) {
                rate = 2;
            }
        }

        if (betType == 2) {
            // Number bets
            if (nums == dices[0]) {
                rate += 1;
            }
            if (nums == dices[1]) {
                rate += 1;
            }
            if (nums == dices[2]) {
                rate += 1;
            }

            rate += (rate > 0) ? 1 : 0;
        }

        if (betType == 3) {
            // Pair bets
            ismatch = 0;
            uint8[2] memory tmpNums = pairBet[nums];
            if (tmpNums[0] != tmpNums[1]) {
                if (
                    tmpNums[0] == dices[0] ||
                    tmpNums[0] == dices[1] ||
                    tmpNums[0] == dices[2]
                ) {
                    ismatch += 1;
                }
                if (
                    tmpNums[1] == dices[0] ||
                    tmpNums[1] == dices[1] ||
                    tmpNums[1] == dices[2]
                ) {
                    ismatch += 1;
                }

                rate = (ismatch == 2) ? 6 : 0;
            }
        }

        if (betType == 4 && nums == sum && (sum >= 4 && sum <= 17)) {
            // Total bets
            rate = sumPayput[sum - 4];
        }

        if (betType == 5) {
            // 5 Double bets
            if (
                dices[0] == dices[1] ||
                dices[1] == dices[2] ||
                dices[0] == dices[2]
            ) {
                if (dices[0] == dices[1] && dices[0] == nums) {
                    rate = 11;
                }
                if (dices[1] == dices[2] && dices[1] == nums) {
                    rate = 11;
                }
                if (dices[0] == dices[2] && dices[0] == nums) {
                    rate = 11;
                }
            }
        }

        if (betType == 6) {
            // 6 Triple bets
            if (dices[0] == dices[1] && dices[0] == dices[2]) {
                if (dices[0] == nums) {
                    rate = 181;
                }
            }
        }

        if (betType == 7) {
            // 7 Three of a kind
            if (dices[0] == dices[1] && dices[0] == dices[2]) {
                rate = 31;
            }
        }
    }

    function checkForTicketWin(uint256 number) private pure returns (uint256) {
        if (number == 2000) {
            return 1000;
        } else if (1999 >= number && number >= 1998) {
            return 800;
        } else if (1998 > number && number >= 1994) {
            return 500;
        } else if (1994 > number && number >= 1984) {
            return 200;
        } else if (1984 > number && number >= 1964) {
            return 100;
        } else if (1964 > number && number >= 1924) {
            return 50;
        } else if (1924 > number && number >= 1824) {
            return 20;
        } else if (1824 > number && number >= 1500) {
            return 10;
        } else if (1499 > number && number >= 1250) {
            return 5;
        } else if (1249 > number && number >= 1000) {
            return 3;
        } else if (999 > number && number >= 500) {
            return 1;
        }

        return 0;
    }

    // --------------- Lottery ----------------
    function buyTicket(
        uint256 commitLastBlock,
        uint256 commit,
        uint256 clientSeed,
        bytes32 r,
        bytes32 s
    ) external payable {
        require(gamesStopped == 0, "Games is running");

        Ticket storage ticket = tickets[commit];
        require(
            ticket.gambler == address(0),
            "Bet should be in a 'clean' state."
        );

        uint256 amount = msg.value;
        uint256 ticketsCount = amount / TICKET_PRICE;

        require(
            0 < ticketsCount && ticketsCount <= TICKET_MAX_COUNT,
            "Tickets is not in range"
        );
        require(amount >= TICKET_PRICE, "Amount should be within range.");
        require(block.number <= commitLastBlock, "Commit has expired.");
        require(
            secretSigner ==
                ecrecover(
                    keccak256(
                        abi.encodePacked(uint40(commitLastBlock), commit)
                    ),
                    27,
                    r,
                    s
                ) ||
                secretSigner ==
                ecrecover(
                    keccak256(
                        abi.encodePacked(uint40(commitLastBlock), commit)
                    ),
                    28,
                    r,
                    s
                ),
            "ECDSA signature is not valid."
        );

        if (totalDividends >= DIVIDENDS_LIMIT) {
            sendDividends();
        }

        uint256 totalPercentages = HOUSE_EDGE_PERCENT +
            ADVERTISE_PERCENT +
            DIVIDENDS_PERCENT;
        uint256 houseEdge = (amount * totalPercentages) / PERCENTAGES_BASE;

        if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
            houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
        }

        totalDividends += (amount * DIVIDENDS_PERCENT) / PERCENTAGES_BASE;
        totalAdvertise += (amount * ADVERTISE_PERCENT) / PERCENTAGES_BASE;

        uint256 possibleWinAmount = ticketsCount *
            TICKET_PRICE *
            averageLotteryLock; // lock average possible win

        // check if we can pay max profit for 1 ticket
        require(
            TICKET_PRICE * 100 <= address(this).balance,
            "Can't pay max profit"
        );
        require(
            possibleWinAmount <= amount + maxProfitLottery,
            "maxProfit limit violation."
        );

        lockedInBetsLottery += uint128(possibleWinAmount);

        require(
            jackpotSizeLottery + lockedInBetsLottery <= address(this).balance,
            "Cannot afford to lose this bet."
        );

        ticket.count = ticketsCount;
        ticket.amount = ticketsCount * TICKET_PRICE - houseEdge;
        ticket.placeBlockNumber = uint40(block.number);
        ticket.gambler = msg.sender;
        ticket.locked = uint128(possibleWinAmount);
        ticket.clientSeed = clientSeed;

        lastTicketTime = now;

        emit CommitLottery(commit, clientSeed, amount);
    }

    function processTickets(uint256 reveal) external onlyCroupier {
        uint256 commit = uint256(keccak256(abi.encodePacked(reveal)));

        Ticket storage ticket = tickets[commit];
        uint256 placeBlockNumber = ticket.placeBlockNumber;

        require(
            block.number > placeBlockNumber,
            "settleBet in the same block as placeBet, or before."
        );
        require(
            block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS,
            "Blockhash can't be queried by EVM."
        );

        _processTickets(ticket, reveal);
    }

    function _processTickets(Ticket storage ticket, uint256 reveal) private {
        bytes32 entropy;
        uint256[] memory ticketsWins = new uint256[](ticket.count);
        uint256 ticketNumber;
        uint256 winRate;
        uint256 totalRate = 0;
        uint256 jackpotWin = 0;
        uint256 zeroTickets = 0;
        uint256 commit = uint256(keccak256(abi.encodePacked(reveal)));

        for (uint8 index = 0; index < ticket.count; index += 1) {
            entropy = keccak256(
                abi.encodePacked(reveal, ticket.clientSeed, index)
            );
            ticketNumber = uint256(entropy) % 2000;
            winRate = checkForTicketWin(ticketNumber);
            ticketsWins[index] = ticketNumber;
            totalRate += winRate;

            if (winRate == 0) {
                zeroTickets += 1;
            }

            jackpotWin += checkJackPotWin(entropy, ticketNumber, 1);
            if (jackpotWin > 0) {
                emit JackpotLotteryPayment(ticket.gambler, commit, jackpotWin);
            }
        }

        if (zeroTickets != 0) {
            jackpotSizeLottery += (zeroTickets * TICKET_PRICE) / 2;
        }

        lockedInBetsLottery -= uint128(ticket.locked);

        uint256 winAmount = ((ticket.amount / ticket.count) * totalRate) /
            10 +
            jackpotWin;

        sendFundsLottery(
            ticket.gambler,
            winAmount == 0 ? 1 wei : winAmount,
            commit,
            "payment",
            ticketsWins
        );
    }

    function checkJackPotWin(
        bytes32 entropy,
        uint256 randMod,
        uint8 game
    ) internal returns (uint256 jackpotWin) {
        jackpotWin = 0;
        uint256 jackpotRng = (uint256(entropy) / randMod) % JACKPOT_MODULO;

        if (game == 0) {
            if (jackpotRng == luckyNumberSicbo) {
                jackpotWin = jackpotSizeSicbo;
                jackpotSizeSicbo = 0;
            }
        } else {
            if (jackpotRng == luckyNumberLottery) {
                jackpotWin = jackpotSizeLottery;
                jackpotSizeLottery = 0;
            }
        }
    }

    function sendFundsLottery(
        address payable beneficiary,
        uint256 amount,
        uint256 commit,
        string memory paymentType,
        uint256[] memory numbers
    ) private {
        if (beneficiary.send(amount)) {
            emit PaymentLottery(
                beneficiary,
                commit,
                amount,
                paymentType,
                numbers
            );
        } else {
            emit PaymentLottery(
                beneficiary,
                commit,
                amount,
                paymentType,
                numbers
            );
        }
    }

    function sendFundsSicbo(
        address payable beneficiary,
        uint256 amount,
        uint256 commit,
        string memory paymentType
    ) private {
        if (beneficiary.send(amount)) {
            emit PaymentSicbo(beneficiary, commit, amount, paymentType);
        } else {
            emit PaymentSicbo(beneficiary, commit, amount, paymentType);
        }
    }

    function refundLotteryBet(uint256 commit) external {
        Ticket storage ticket = tickets[commit];
        uint256 amount = ticket.amount;

        require(amount != 0, "Bet should be in an 'active' state");
        require(
            block.number > ticket.placeBlockNumber + BET_EXPIRATION_BLOCKS,
            "Blockhash can't be queried by EVM."
        );

        ticket.amount = 0;
        lockedInBetsLottery -= ticket.locked;

        uint256[] memory tmp;
        sendFundsLottery(ticket.gambler, amount, commit, "refund", tmp);
    }

    function refundBetSicbo(uint256 commit) external {
        Bet storage bet = bets[commit];
        uint256 amount = bet.totalBetAmount;

        require(amount != 0, "Bet should be in an 'active' state");
        require(
            block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS,
            "Blockhash can't be queried by EVM."
        );

        bet.totalBetAmount = 0;

        for (uint8 index = 0; index < bet.betsCount; index += 1) {
            bet.amount[index] = 0;
        }

        lockedInBetsSicbo -= bet.locked;

        if (amount >= MIN_JACKPOT_BET && jackpotSizeSicbo > JACKPOT_FEE) {
            jackpotSizeSicbo -= uint128(JACKPOT_FEE);
        }

        sendFundsSicbo(bet.gambler, amount, commit, "refund");
    }
}