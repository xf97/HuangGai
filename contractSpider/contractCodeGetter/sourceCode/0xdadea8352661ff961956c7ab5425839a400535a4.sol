/**
 *Submitted for verification at Etherscan.io on 2020-07-03
*/

pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

interface IERC20 {
    // ERC20 Optional Views
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    // Views
    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);

    // Mutative functions
    function transfer(address to, uint value) external returns (bool);

    function approve(address spender, uint value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint value
    ) external returns (bool);

    // Events
    event Transfer(address indexed from, address indexed to, uint value);

    event Approval(address indexed owner, address indexed spender, uint value);
}

interface IBinaryOptionMarketManager {
    /* ========== TYPES ========== */

    struct Fees {
        uint poolFee;
        uint creatorFee;
        uint refundFee;
    }

    struct Durations {
        uint maxOraclePriceAge;
        uint expiryDuration;
        uint maxTimeToMaturity;
    }

    struct CreatorLimits {
        uint capitalRequirement;
        uint skewLimit;
    }

    /* ========== VIEWS / VARIABLES ========== */

    function fees() external view returns (uint poolFee, uint creatorFee, uint refundFee);
    function durations() external view returns (uint maxOraclePriceAge, uint expiryDuration, uint maxTimeToMaturity);
    function creatorLimits() external view returns (uint capitalRequirement, uint skewLimit);

    function marketCreationEnabled() external view returns (bool);
    function totalDeposited() external view returns (uint);

    function numActiveMarkets() external view returns (uint);
    function activeMarkets(uint index, uint pageSize) external view returns (address[] memory);
    function numMaturedMarkets() external view returns (uint);
    function maturedMarkets(uint index, uint pageSize) external view returns (address[] memory);

    /* ========== MUTATIVE FUNCTIONS ========== */

    function createMarket(
        bytes32 oracleKey, uint strikePrice,
        uint[2] calldata times, // [biddingEnd, maturity]
        uint[2] calldata bids // [longBid, shortBid]
    ) external returns (IBinaryOptionMarket);
    function resolveMarket(address market) external;
    function expireMarkets(address[] calldata market) external;
}



interface IBinaryOptionMarket {
    /* ========== TYPES ========== */

    enum Phase { Bidding, Trading, Maturity, Expiry }
    enum Side { Long, Short }

    struct Options {
        IBinaryOption long;
        IBinaryOption short;
    }

    struct Prices {
        uint long;
        uint short;
    }

    struct Times {
        uint biddingEnd;
        uint maturity;
        uint expiry;
    }

    struct OracleDetails {
        bytes32 key;
        uint strikePrice;
        uint finalPrice;
    }

    /* ========== VIEWS / VARIABLES ========== */

    function options() external view returns (IBinaryOption long, IBinaryOption short);
    function prices() external view returns (uint long, uint short);
    function times() external view returns (uint biddingEnd, uint maturity, uint destructino);
    function oracleDetails() external view returns (bytes32 key, uint strikePrice, uint finalPrice);
    function fees() external view returns (uint poolFee, uint creatorFee, uint refundFee);
    function creatorLimits() external view returns (uint capitalRequirement, uint skewLimit);

    function deposited() external view returns (uint);
    function creator() external view returns (address);
    function resolved() external view returns (bool);

    function phase() external view returns (Phase);
    function oraclePriceAndTimestamp() external view returns (uint price, uint updatedAt);
    function canResolve() external view returns (bool);
    function result() external view returns (Side);

    function pricesAfterBidOrRefund(Side side, uint value, bool refund) external view returns (uint long, uint short);
    function bidOrRefundForPrice(Side bidSide, Side priceSide, uint price, bool refund) external view returns (uint);

    function bidsOf(address account) external view returns (uint long, uint short);
    function totalBids() external view returns (uint long, uint short);
    function claimableBalancesOf(address account) external view returns (uint long, uint short);
    function totalClaimableSupplies() external view returns (uint long, uint short);
    function balancesOf(address account) external view returns (uint long, uint short);
    function totalSupplies() external view returns (uint long, uint short);
    function exercisableDeposits() external view returns (uint);

    /* ========== MUTATIVE FUNCTIONS ========== */

    function bid(Side side, uint value) external;
    function refund(Side side, uint value) external returns (uint refundMinusFee);

    function claimOptions() external returns (uint longClaimed, uint shortClaimed);
    function exerciseOptions() external returns (uint);
}




interface IBinaryOption {
    /* ========== VIEWS / VARIABLES ========== */

    function market() external view returns (IBinaryOptionMarket);

    function bidOf(address account) external view returns (uint);
    function totalBids() external view returns (uint);

    function balanceOf(address account) external view returns (uint);
    function totalSupply() external view returns (uint);

    function claimableBalanceOf(address account) external view returns (uint);
    function totalClaimableSupply() external view returns (uint);
}



contract BinaryOptionMarketData {


    struct OptionValues {
        uint long;
        uint short;
    }

    struct Deposits {
        uint deposited;
        uint exercisableDeposits;
    }

    struct Resolution {
        bool resolved;
        bool canResolve;
    }

    struct OraclePriceAndTimestamp {
        uint price;
        uint updatedAt;
    }

    // used for things that don't change over the lifetime of the contract
    struct MarketParameters {
        address creator;
        IBinaryOptionMarket.Options options;
        IBinaryOptionMarket.Times times;
        IBinaryOptionMarket.OracleDetails oracleDetails;
        IBinaryOptionMarketManager.Fees fees;
        IBinaryOptionMarketManager.CreatorLimits creatorLimits;
    }

    struct MarketData {
        OraclePriceAndTimestamp oraclePriceAndTimestamp;
        IBinaryOptionMarket.Prices prices;
        Deposits deposits;
        Resolution resolution;
        IBinaryOptionMarket.Phase phase;
        IBinaryOptionMarket.Side result;
        OptionValues totalBids;
        OptionValues totalClaimableSupplies;
        OptionValues totalSupplies;
    }

    struct AccountData {
        OptionValues bids;
        OptionValues claimable;
        OptionValues balances;
    }

    function getMarketParameters(IBinaryOptionMarket market) public view returns (MarketParameters memory) {

        (IBinaryOption long, IBinaryOption short) = market.options();
        (uint biddingEndDate, uint maturityDate, uint expiryDate) = market.times();
        (bytes32 key, uint strikePrice, uint finalPrice) = market.oracleDetails();
        (uint poolFee, uint creatorFee, uint refundFee) = market.fees();

        MarketParameters memory data = MarketParameters(
            market.creator(),
            IBinaryOptionMarket.Options(long, short),
            IBinaryOptionMarket.Times(biddingEndDate,maturityDate,expiryDate),
            IBinaryOptionMarket.OracleDetails(key, strikePrice, finalPrice),
            IBinaryOptionMarketManager.Fees(poolFee, creatorFee, refundFee),
            IBinaryOptionMarketManager.CreatorLimits(0, 0)
        );

        // Stack too deep otherwise.
        (uint capitalRequirement, uint skewLimit) = market.creatorLimits();
        data.creatorLimits = IBinaryOptionMarketManager.CreatorLimits(capitalRequirement, skewLimit);
        return data;
    }

    function getMarketData(IBinaryOptionMarket market) public view returns (MarketData memory) {

        (uint price, uint updatedAt) = market.oraclePriceAndTimestamp();
        (uint longClaimable, uint shortClaimable) = market.totalClaimableSupplies();
        (uint longSupply, uint shortSupply) = market.totalSupplies();
        (uint longBids, uint shortBids) = market.totalBids();
        (uint longPrice, uint shortPrice) = market.prices();

        return MarketData(
            OraclePriceAndTimestamp(price, updatedAt),
            IBinaryOptionMarket.Prices(longPrice, shortPrice),
            Deposits(market.deposited(), market.exercisableDeposits()),
            Resolution(market.resolved(), market.canResolve()),
            market.phase(),
            market.result(),
            OptionValues(longBids, shortBids),
            OptionValues(longClaimable, shortClaimable),
            OptionValues(longSupply, shortSupply)
        );
    }

    function getAccountMarketData(IBinaryOptionMarket market, address account) public view returns (AccountData memory) {
        (uint longBid, uint shortBid) = market.bidsOf(account);
        (uint longClaimable, uint shortClaimable) = market.claimableBalancesOf(account);
        (uint longBalance, uint shortBalance) = market.balancesOf(account);

        return AccountData(
            OptionValues(longBid, shortBid),
            OptionValues(longClaimable, shortClaimable),
            OptionValues(longBalance, shortBalance)
        );
    }
}