/**
 *Submitted for verification at Etherscan.io on 2020-07-30
*/

/*
    SPDX-License-Identifier: MIT
    A Bankteller Production
    Bankroll Network
    Copyright 2020
*/
pragma solidity ^0.4.25;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Not current owner");
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Non-zero address required");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract Token {
    function approve(address spender, uint256 value) public returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool);

    function transfer(address to, uint256 value) public returns (bool);

    function balanceOf(address who) public view returns (uint256);
}

contract UniSwapV2LiteRouter {
    //function ethToTokenSwapInput(uint256 min_tokens) public payable returns (uint256);
    function WETH() external pure returns (address);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] path,
        address to,
        uint256 deadline
    ) external returns (uint256[] amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] amounts);

    function getAmountsOut(uint256 amountIn, address[] path)
        external
        view
        returns (uint256[] amounts);
}

/*
 * @dev Moon is a perpetual rewards contract
 */

contract BankrollNetworkMoon is Ownable {
    using SafeMath for uint256;

    /*=================================
    =            MODIFIERS            =
    =================================*/

    /// @dev Only people with tokens
    modifier onlyBagholders {
        require(myTokens() > 0, "Insufficient tokens");
        _;
    }

    /// @dev Only people with profits
    modifier onlyStronghands {
        require(myDividends() > 0, "Insufficient dividends");
        _;
    }

    /*==============================
    =            EVENTS            =
    ==============================*/

    event onLeaderBoard(
        address indexed customerAddress,
        uint256 invested,
        uint256 tokens,
        uint256 soldTokens,
        uint256 timestamp
    );

    event onTokenPurchase(
        address indexed customerAddress,
        uint256 incomingeth,
        uint256 tokensMinted,
        uint256 timestamp
    );

    event onTokenSell(
        address indexed customerAddress,
        uint256 tokensBurned,
        uint256 ethEarned,
        uint256 timestamp
    );

    event onReinvestment(
        address indexed customerAddress,
        uint256 ethReinvested,
        uint256 tokensMinted,
        uint256 timestamp
    );

    event onWithdraw(
        address indexed customerAddress,
        uint256 ethWithdrawn,
        uint256 timestamp
    );

    event onClaim(
        address indexed customerAddress,
        uint256 tokens,
        uint256 timestamp
    );

    event onTransfer(
        address indexed from,
        address indexed to,
        uint256 tokens,
        uint256 timestamp
    );

    event onUpdateIntervals(uint256 payout, uint256 fund);

    event onCollateraltoReward(
        uint256 collateralAmount,
        uint256 rewardAmount,
        uint256 timestamp
    );

    event onEthtoCollateral(
        uint256 ethAmount,
        uint256 tokenAmount,
        uint256 timestamp
    );

    event onRewardtoCollateral(
        uint256 ethAmount,
        uint256 tokenAmount,
        uint256 timestamp
    );

    event onBalance(uint256 balance, uint256 rewardBalance, uint256 timestamp);

    event onDonation(address indexed from, uint256 amount, uint256 timestamp);

    event onRouterUpdate(address oldAddress, address newAddress);

    event onFlushUpdate(uint256 oldFlushSize, uint256 newFlushSize);

    // Onchain Stats!!!
    struct Stats {
        uint256 invested;
        uint256 reinvested;
        uint256 withdrawn;
        uint256 rewarded;
        uint256 contributed;
        uint256 transferredTokens;
        uint256 receivedTokens;
        uint256 xInvested;
        uint256 xReinvested;
        uint256 xRewarded;
        uint256 xContributed;
        uint256 xWithdrawn;
        uint256 xTransferredTokens;
        uint256 xReceivedTokens;
    }

    /*=====================================
    =            CONFIGURABLES            =
    =====================================*/

    /// @dev 15% dividends for token purchase
    uint8 internal constant entryFee_ = 10;

    /// @dev 5% dividends for token selling
    uint8 internal constant exitFee_ = 10;

    uint8 internal constant instantFee = 20;

    uint8 constant payoutRate_ = 2;

    uint256 internal constant magnitude = 2**64;

    /*=================================
     =            DATASETS            =
     ================================*/

    // amount of shares for each address (scaled number)
    mapping(address => uint256) private tokenBalanceLedger_;
    mapping(address => int256) private payoutsTo_;
    mapping(address => Stats) private stats;
    //on chain referral tracking
    uint256 private tokenSupply_;
    uint256 private profitPerShare_;
    uint256 public totalDeposits;
    uint256 internal lastBalance_;

    uint256 public players;
    uint256 public totalTxs;
    uint256 public collateralBuffer_;
    uint256 public lastPayout;
    uint256 public lastFunding;
    uint256 public totalClaims;

    uint256 public balanceInterval = 6 hours;
    uint256 public payoutInterval = 2 seconds;
    uint256 public fundingInterval = 2 seconds;
    uint256 public flushSize = 0.00000000001 ether;

    address public swapAddress;
    address public rewardAddress;
    address public collateralAddress;

    Token private rewardToken;
    Token private collateralToken;
    UniSwapV2LiteRouter private swap;

    /*=======================================
    =            PUBLIC FUNCTIONS           =
    =======================================*/

    constructor(
        address _collateralAddress,
        address _rewardAddress,
        address _swapAddress
    ) public Ownable() {
        rewardAddress = _rewardAddress;
        rewardToken = Token(_rewardAddress);

        collateralAddress = _collateralAddress;
        collateralToken = Token(_collateralAddress);

        swapAddress = _swapAddress;
        swap = UniSwapV2LiteRouter(_swapAddress);

        lastPayout = now;
        lastFunding = now;
    }

    /// @dev Converts all incoming eth to tokens for the caller, and passes down the referral addy (if any)
    function buy() public payable returns (uint256) {
        return buyFor(msg.sender);
    }

    /// @dev Converts all incoming eth to tokens for the caller, and passes down the referral addy (if any)
    function buyFor(address _customerAddress) public payable returns (uint256) {
        require(msg.value > 0, "Non-zero amount required");

        //Convert ETH to collateral
        uint256 _buy_amount = ethToCollateral(msg.value);

        totalDeposits += _buy_amount;
        uint256 amount = purchaseTokens(_customerAddress, _buy_amount);

        emit onLeaderBoard(
            _customerAddress,
            stats[_customerAddress].invested,
            tokenBalanceLedger_[_customerAddress],
            stats[_customerAddress].withdrawn,
            now
        );

        //distribute
        distribute();

        return amount;
    }

    /**
     * @dev Fallback function to handle eth that was send straight to the contract
     *  Unfortunately we cannot use a referral address this way.
     */
    function() public payable {
        //Just bounce
        require(false, "This contract does not except ETH");
    }

    /// @dev Converts all of caller's dividends to tokens.
    function reinvest() public onlyStronghands {
        // fetch dividends
        uint256 _dividends = myDividends();
        // retrieve ref. bonus later in the code

        // pay out the dividends virtually
        address _customerAddress = msg.sender;
        payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);

        // dispatch a buy order with the virtualized "withdrawn dividends"
        uint256 _tokens = purchaseTokens(msg.sender, _dividends);

        // fire event
        emit onReinvestment(_customerAddress, _dividends, _tokens, now);

        //Stats
        stats[_customerAddress].reinvested = SafeMath.add(
            stats[_customerAddress].reinvested,
            _dividends
        );
        stats[_customerAddress].xReinvested += 1;

        emit onLeaderBoard(
            _customerAddress,
            stats[_customerAddress].invested,
            tokenBalanceLedger_[_customerAddress],
            stats[_customerAddress].withdrawn,
            now
        );

        //distribute
        distribute();
    }

    /// @dev Withdraws all of the callers earnings.
    function withdraw() public onlyStronghands {
        // setup data
        address _customerAddress = msg.sender;
        uint256 _dividends = myDividends();

        // update dividend tracker
        payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);

        // lambo delivery service
        collateralToken.transfer(_customerAddress, _dividends);

        //stats
        stats[_customerAddress].withdrawn = SafeMath.add(
            stats[_customerAddress].withdrawn,
            _dividends
        );
        stats[_customerAddress].xWithdrawn += 1;
        totalTxs += 1;

        // fire event
        emit onWithdraw(_customerAddress, _dividends, now);

        //distribute
        distribute();
    }

    /// @dev Liquifies STCK to collateral tokens.
    function sell(uint256 _amountOfTokens) public onlyBagholders {
        // setup data
        address _customerAddress = msg.sender;

        require(
            _amountOfTokens <= tokenBalanceLedger_[_customerAddress],
            "Amount of tokens is greater than balance"
        );

        // data setup
        uint256 _undividedDividends = SafeMath.mul(_amountOfTokens, exitFee_) /
            100;
        uint256 _taxedeth = SafeMath.sub(_amountOfTokens, _undividedDividends);

        // burn the sold tokens
        tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfTokens);
        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(
            tokenBalanceLedger_[_customerAddress],
            _amountOfTokens
        );

        // update dividends tracker
        int256 _updatedPayouts = (int256)(
            profitPerShare_ * _amountOfTokens + (_taxedeth * magnitude)
        );
        payoutsTo_[_customerAddress] -= _updatedPayouts;

        //drip and buybacks applied after supply is updated
        allocateFees(_undividedDividends);

        // fire event
        emit onTokenSell(_customerAddress, _amountOfTokens, _taxedeth, now);

        emit onLeaderBoard(
            _customerAddress,
            stats[_customerAddress].invested,
            tokenBalanceLedger_[_customerAddress],
            stats[_customerAddress].withdrawn,
            now
        );

        //distribute
        distribute();
    }

    /**
     * @dev Transfer tokens from the caller to a new holder.
     *  Zero fees
     */
    function transfer(address _toAddress, uint256 _amountOfTokens)
        external
        onlyBagholders
        returns (bool)
    {
        // setup
        address _customerAddress = msg.sender;

        // make sure we have the requested tokens
        require(
            _amountOfTokens <= tokenBalanceLedger_[_customerAddress],
            "Amount of tokens is greater than balance"
        );

        // withdraw all outstanding dividends first
        if (myDividends() > 0) {
            withdraw();
        }

        // exchange tokens
        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(
            tokenBalanceLedger_[_customerAddress],
            _amountOfTokens
        );
        tokenBalanceLedger_[_toAddress] = SafeMath.add(
            tokenBalanceLedger_[_toAddress],
            _amountOfTokens
        );

        // update dividend trackers
        payoutsTo_[_customerAddress] -= (int256)(
            profitPerShare_ * _amountOfTokens
        );
        payoutsTo_[_toAddress] += (int256)(profitPerShare_ * _amountOfTokens);

        /* Members
            A player can be initialized by buying or receiving and we want to add the user ASAP
         */
        if (
            stats[_toAddress].invested == 0 &&
            stats[_toAddress].receivedTokens == 0
        ) {
            players += 1;
        }

        //Stats
        stats[_customerAddress].xTransferredTokens += 1;
        stats[_customerAddress].transferredTokens += _amountOfTokens;
        stats[_toAddress].receivedTokens += _amountOfTokens;
        stats[_toAddress].xReceivedTokens += 1;
        totalTxs += 1;

        // fire event
        emit onTransfer(_customerAddress, _toAddress, _amountOfTokens, now);

        emit onLeaderBoard(
            _customerAddress,
            stats[_customerAddress].invested,
            tokenBalanceLedger_[_customerAddress],
            stats[_customerAddress].withdrawn,
            now
        );

        emit onLeaderBoard(
            _toAddress,
            stats[_toAddress].invested,
            tokenBalanceLedger_[_toAddress],
            stats[_toAddress].withdrawn,
            now
        );

        // ERC20
        return true;
    }

    /*=====================================
    =      HELPERS AND CALCULATORS        =
    =====================================*/

    /**
     * @dev Method to view the current collateral stored in the contract
     */
    function totalTokenBalance() public view returns (uint256) {
        return collateralToken.balanceOf(address(this));
    }

    /**
     * @dev Method to view the current collateral stored in the contract
     */
    function totalRewardTokenBalance() public view returns (uint256) {
        return rewardToken.balanceOf(address(this));
    }

    /// @dev Retrieve the total token supply.
    function totalSupply() public view returns (uint256) {
        return tokenSupply_;
    }

    /// @dev Retrieve the tokens owned by the caller.
    function myTokens() public view returns (uint256) {
        address _customerAddress = msg.sender;
        return balanceOf(_customerAddress);
    }

    /**
     * @dev Retrieve the dividends owned by the caller.
     */
    function myDividends() public view returns (uint256) {
        address _customerAddress = msg.sender;
        return dividendsOf(_customerAddress);
    }

    /// @dev Retrieve the token balance of any single address.
    function balanceOf(address _customerAddress) public view returns (uint256) {
        return tokenBalanceLedger_[_customerAddress];
    }

    /// @dev Retrieve the token balance of any single address.
    function tokenBalance(address _customerAddress)
        public
        view
        returns (uint256)
    {
        return _customerAddress.balance;
    }

    /// @dev Retrieve the dividend balance of any single address.
    function dividendsOf(address _customerAddress)
        public
        view
        returns (uint256)
    {
        return
            (uint256)(
                (int256)(
                    profitPerShare_ * tokenBalanceLedger_[_customerAddress]
                ) - payoutsTo_[_customerAddress]
            ) / magnitude;
    }

    /// @dev Return the sell price of 1 individual token.
    function sellPrice() public pure returns (uint256) {
        uint256 _eth = 1e18;
        uint256 _dividends = SafeMath.div(SafeMath.mul(_eth, exitFee_), 100);
        uint256 _taxedeth = SafeMath.sub(_eth, _dividends);

        return _taxedeth;
    }

    /// @dev Return the buy price of 1 individual token.
    function buyPrice() public pure returns (uint256) {
        uint256 _eth = 1e18;
        uint256 _dividends = SafeMath.div(SafeMath.mul(_eth, entryFee_), 100);
        uint256 _taxedeth = SafeMath.add(_eth, _dividends);

        return _taxedeth;
    }

    /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
    function calculateTokensReceived(uint256 _ethToSpend)
        public
        view
        returns (uint256)
    {
        //Get the amount of the token in ETH and compare to the swapSize
        address[] memory path = new address[](2);
        path[0] = swap.WETH();
        path[1] = collateralAddress;

        uint256[] memory amounts = swap.getAmountsOut(_ethToSpend, path);

        uint256 _dividends = SafeMath.div(
            SafeMath.mul(amounts[1], entryFee_),
            100
        );
        uint256 _taxedeth = SafeMath.sub(amounts[1], _dividends);
        uint256 _amountOfTokens = _taxedeth;

        return _amountOfTokens;
    }

    /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
    function calculateethReceived(uint256 _tokensToSell)
        public
        view
        returns (uint256)
    {
        require(
            _tokensToSell <= tokenSupply_,
            "Tokens to sell greater than supply"
        );
        uint256 _eth = _tokensToSell;
        uint256 _dividends = SafeMath.div(SafeMath.mul(_eth, exitFee_), 100);
        uint256 _taxedeth = SafeMath.sub(_eth, _dividends);
        return _taxedeth;
    }

    /// @dev Stats of any single address
    function statsOf(address _customerAddress)
        public
        view
        returns (uint256[14] memory)
    {
        Stats memory s = stats[_customerAddress];
        uint256[14] memory statArray = [
            s.invested,
            s.withdrawn,
            s.rewarded,
            s.contributed,
            s.transferredTokens,
            s.receivedTokens,
            s.xInvested,
            s.xRewarded,
            s.xContributed,
            s.xWithdrawn,
            s.xTransferredTokens,
            s.xReceivedTokens,
            s.reinvested,
            s.xReinvested
        ];
        return statArray;
    }

    /// @dev Calculate daily estimate of collateral tokens awarded
    function dailyEstimate(address _customerAddress)
        public
        view
        returns (uint256)
    {
        uint256 share = totalRewardTokenBalance().mul(payoutRate_).div(100);

        
        uint256 amount = (tokenSupply_ > 0)
                ? share.mul(tokenBalanceLedger_[_customerAddress]).div(
                    tokenSupply_
                )
                : 0;

        if (amount > 0){
            address[] memory path = new address[](3);
            path[0] = rewardAddress;
            path[1] = swap.WETH();
            path[2] = collateralAddress;

            
            uint256[] memory amounts = swap.getAmountsOut(amount, path);
            return amounts[2];
        }
        
        return  0;      
    }

    /*==========================================
    =            INTERNAL FUNCTIONS            =
    ==========================================*/

    /// @dev Distribute undividend in and out fees across drip pools and instant divs
    function allocateFees(uint256 fee) private {
        uint256 _share = fee.div(100);
        uint256 _instant = _share.mul(instantFee);
        uint256 _collateral = fee.safeSub(_instant);

        //Apply divs
        profitPerShare_ = SafeMath.add(
            profitPerShare_,
            (_instant * magnitude) / tokenSupply_
        );

        //Add to dividend drip pools
        collateralBuffer_ += _collateral;
    }

    // @dev Distribute drip pools
    function distribute() private {
        if (now.safeSub(lastBalance_) > balanceInterval) {
            emit onBalance(totalTokenBalance(), totalRewardTokenBalance(), now);
            lastBalance_ = now;
        }

        if (now.safeSub(lastPayout) > payoutInterval && totalRewardTokenBalance() > 0) {
            //Don't distribute if we don't have  sufficient profit
            //A portion of the dividend is paid out according to the rate
            uint256 share = totalRewardTokenBalance()
                .mul(payoutRate_)
                .div(100)
                .div(24 hours);
            //divide the profit by seconds in the day
            uint256 profit = share * now.safeSub(lastPayout);

            //Get the amount of the token in ETH and compare to the swapSize
            address[] memory path = new address[](2);
            path[0] = rewardAddress;
            path[1] = swap.WETH();

            if (profit > 0){
                uint256[] memory amounts = swap.getAmountsOut(profit, path);

                if (amounts[1] > flushSize) {
                    profit = rewardToCollateral(profit);

                    totalClaims += profit;

                    //Apply reward bonus as collateral bonus divs
                    profitPerShare_ = SafeMath.add(
                        profitPerShare_,
                        (profit * magnitude) / tokenSupply_
                    );

                    lastPayout = now;
                } else {
                    fundRewardPool();
                }
            } else {
                fundRewardPool();
            }
        } else {
            fundRewardPool();
        }
    }

    /// @dev Fund reward pool using the router; initial time and size logic gates and orchestration
    function fundRewardPool() private {
        //Only buy once
        if (SafeMath.safeSub(now, lastFunding) >= fundingInterval) {
            //Get the amount of the token in ETH and compare to the swapSize
            address[] memory path = new address[](2);
            path[0] = collateralAddress;
            path[1] = swap.WETH();

            if (collateralBuffer_ > 0){
                uint256[] memory amounts = swap.getAmountsOut(
                    collateralBuffer_,
                    path
                );

                if (amounts[1] >= flushSize) {
                    uint256 amount = collateralBuffer_;

                    //reset Collector
                    collateralBuffer_ = 0;

                    //reward token buyback; tokens come to address(this) in the rewardsToken
                    collateralToReward(amount);

                    lastFunding = now;
                }
            }
        }
    }

    //Execute the buyback against the router using WETH as a bridge
    function collateralToReward(uint256 amount) private returns (uint256) {
        address[] memory path = new address[](3);
        path[0] = collateralAddress;
        path[1] = swap.WETH();
        path[2] = rewardAddress;

        //Need to be able to approve the collateral token for transfer
        require(
            collateralToken.approve(swapAddress, amount),
            "Amount approved not available"
        );

        uint256[] memory amounts = swap.swapExactTokensForTokens(
            amount,
            1,
            path,
            address(this),
            now + 24 hours
        );

        //2nd index is token amount
        emit onCollateraltoReward(amount, amounts[2], now);

        return amounts[2];
    }

    function rewardToCollateral(uint256 amount) private returns (uint256) {
        address[] memory path = new address[](3);
        path[0] = rewardAddress;
        path[1] = swap.WETH();
        path[2] = collateralAddress;

        //Need to be able to approve the collateral token for transfer
        require(
            rewardToken.approve(swapAddress, amount),
            "Amount approved not available"
        );

        uint256[] memory amounts = swap.swapExactTokensForTokens(
            amount,
            1,
            path,
            address(this),
            now + 24 hours
        );

        //2nd index is token amount
        emit onRewardtoCollateral(amount, amounts[2], now);

        return amounts[2];
    }

    /// @dev ETH to tokens
    function ethToCollateral(uint256 amount) private returns (uint256) {
        address[] memory path = new address[](2);
        path[0] = swap.WETH();
        path[1] = collateralAddress;

        uint256[] memory amounts = swap.swapExactETHForTokens.value(amount)(
            1,
            path,
            address(this),
            now + 24 hours
        );

        //2nd index is token amount
        emit onEthtoCollateral(amount, amounts[1], now);

        return amounts[1];
    }

    /// @dev Internal function to actually purchase the tokens.
    function purchaseTokens(address _customerAddress, uint256 _incomingtokens)
        internal
        returns (uint256)
    {
        /* Members */
        if (
            stats[_customerAddress].invested == 0 &&
            stats[_customerAddress].receivedTokens == 0
        ) {
            players += 1;
        }

        totalTxs += 1;

        // data setup
        uint256 _undividedDividends = SafeMath.mul(_incomingtokens, entryFee_) /
            100;
        uint256 _amountOfTokens = SafeMath.sub(
            _incomingtokens,
            _undividedDividends
        );

        // fire event
        emit onTokenPurchase(
            _customerAddress,
            _incomingtokens,
            _amountOfTokens,
            now
        );

        // yes we know that the safemath function automatically rules out the "greater then" equation.
        require(
            _amountOfTokens > 0 &&
                SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_,
            "Tokens need to be positive"
        );

        // we can't give people infinite eth
        if (tokenSupply_ > 0) {
            // add tokens to the pool
            tokenSupply_ += _amountOfTokens;
        } else {
            // add tokens to the pool
            tokenSupply_ = _amountOfTokens;
        }

        // update circulating supply & the ledger address for the customer
        tokenBalanceLedger_[_customerAddress] = SafeMath.add(
            tokenBalanceLedger_[_customerAddress],
            _amountOfTokens
        );

        // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
        // really i know you think you do but you don't
        int256 _updatedPayouts = (int256)(profitPerShare_ * _amountOfTokens);
        payoutsTo_[_customerAddress] += _updatedPayouts;

        //drip and buybacks; instant requires being called after supply is updated
        allocateFees(_undividedDividends);

        //Stats
        stats[_customerAddress].invested += _incomingtokens;
        stats[_customerAddress].xInvested += 1;

        return _amountOfTokens;
    }

    /*==========================================
    =            ADMIN FUNCTIONS               =
    ==========================================*/

    /**
     * @dev Update the router address to account for movement in liquidity long term
     */
    function updateSwapRouter(address _swapAddress) public onlyOwner() {
        emit onRouterUpdate(swapAddress, _swapAddress);
        swapAddress = _swapAddress;
        swap = UniSwapV2LiteRouter(_swapAddress);
    }

    /**
     * @dev Update the flushSize (how often buy backs happen in terms of amount of ETH accumulated)
     */
    function updateFlushSize(uint256 _flushSize) public onlyOwner() {
        require(
            _flushSize >= 0.01 ether && _flushSize <= 5 ether,
            "Flush size is out of range"
        );

        emit onFlushUpdate(flushSize, _flushSize);
        flushSize = _flushSize;
    }

    /**
     * @dev Update Intervals
     */
    function updateIntervals(uint256 _payout, uint256 _fund)
        public
        onlyOwner()
    {
        require(
            _payout >= 2 seconds && _payout <= 24 hours,
            "Interval out of range"
        );
        require(
            _fund >= 2 seconds && _fund <= 24 hours,
            "Interval out of range"
        );

        payoutInterval = _payout;
        fundingInterval = _fund;

        emit onUpdateIntervals(_payout, _fund);
    }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    /**
     * @dev Multiplies two numbers, throws on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
     * @dev Integer division of two numbers, truncating the quotient.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

    /**
     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /* @dev Subtracts two numbers, else returns zero */
    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
        if (b > a) {
            return 0;
        } else {
            return a - b;
        }
    }

    /**
     * @dev Adds two numbers, throws on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}