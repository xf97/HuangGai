pragma solidity 0.5.15;

contract IAugur {
    function createChildUniverse(bytes32 _parentPayoutDistributionHash, uint256[] memory _parentPayoutNumerators) public returns (IUniverse);
    function isKnownUniverse(IUniverse _universe) public view returns (bool);
    function trustedCashTransfer(address _from, address _to, uint256 _amount) public returns (bool);
    function isTrustedSender(address _address) public returns (bool);
    function onCategoricalMarketCreated(uint256 _endTime, string memory _extraInfo, IMarket _market, address _marketCreator, address _designatedReporter, uint256 _feePerCashInAttoCash, bytes32[] memory _outcomes) public returns (bool);
    function onYesNoMarketCreated(uint256 _endTime, string memory _extraInfo, IMarket _market, address _marketCreator, address _designatedReporter, uint256 _feePerCashInAttoCash) public returns (bool);
    function onScalarMarketCreated(uint256 _endTime, string memory _extraInfo, IMarket _market, address _marketCreator, address _designatedReporter, uint256 _feePerCashInAttoCash, int256[] memory _prices, uint256 _numTicks)  public returns (bool);
    function logInitialReportSubmitted(IUniverse _universe, address _reporter, address _market, address _initialReporter, uint256 _amountStaked, bool _isDesignatedReporter, uint256[] memory _payoutNumerators, string memory _description, uint256 _nextWindowStartTime, uint256 _nextWindowEndTime) public returns (bool);
    function disputeCrowdsourcerCreated(IUniverse _universe, address _market, address _disputeCrowdsourcer, uint256[] memory _payoutNumerators, uint256 _size, uint256 _disputeRound) public returns (bool);
    function logDisputeCrowdsourcerContribution(IUniverse _universe, address _reporter, address _market, address _disputeCrowdsourcer, uint256 _amountStaked, string memory description, uint256[] memory _payoutNumerators, uint256 _currentStake, uint256 _stakeRemaining, uint256 _disputeRound) public returns (bool);
    function logDisputeCrowdsourcerCompleted(IUniverse _universe, address _market, address _disputeCrowdsourcer, uint256[] memory _payoutNumerators, uint256 _nextWindowStartTime, uint256 _nextWindowEndTime, bool _pacingOn, uint256 _totalRepStakedInPayout, uint256 _totalRepStakedInMarket, uint256 _disputeRound) public returns (bool);
    function logInitialReporterRedeemed(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256[] memory _payoutNumerators) public returns (bool);
    function logDisputeCrowdsourcerRedeemed(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256[] memory _payoutNumerators) public returns (bool);
    function logMarketFinalized(IUniverse _universe, uint256[] memory _winningPayoutNumerators) public returns (bool);
    function logMarketMigrated(IMarket _market, IUniverse _originalUniverse) public returns (bool);
    function logReportingParticipantDisavowed(IUniverse _universe, IMarket _market) public returns (bool);
    function logMarketParticipantsDisavowed(IUniverse _universe) public returns (bool);
    function logCompleteSetsPurchased(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets) public returns (bool);
    function logCompleteSetsSold(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets, uint256 _fees) public returns (bool);
    function logMarketOIChanged(IUniverse _universe, IMarket _market) public returns (bool);
    function logTradingProceedsClaimed(IUniverse _universe, address _sender, address _market, uint256 _outcome, uint256 _numShares, uint256 _numPayoutTokens, uint256 _fees) public returns (bool);
    function logUniverseForked(IMarket _forkingMarket) public returns (bool);
    function logReputationTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value, uint256 _fromBalance, uint256 _toBalance) public returns (bool);
    function logReputationTokensBurned(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);
    function logReputationTokensMinted(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);
    function logShareTokensBalanceChanged(address _account, IMarket _market, uint256 _outcome, uint256 _balance) public returns (bool);
    function logDisputeCrowdsourcerTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value, uint256 _fromBalance, uint256 _toBalance) public returns (bool);
    function logDisputeCrowdsourcerTokensBurned(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);
    function logDisputeCrowdsourcerTokensMinted(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);
    function logDisputeWindowCreated(IDisputeWindow _disputeWindow, uint256 _id, bool _initial) public returns (bool);
    function logParticipationTokensRedeemed(IUniverse universe, address _sender, uint256 _attoParticipationTokens, uint256 _feePayoutShare) public returns (bool);
    function logTimestampSet(uint256 _newTimestamp) public returns (bool);
    function logInitialReporterTransferred(IUniverse _universe, IMarket _market, address _from, address _to) public returns (bool);
    function logMarketTransferred(IUniverse _universe, address _from, address _to) public returns (bool);
    function logParticipationTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value, uint256 _fromBalance, uint256 _toBalance) public returns (bool);
    function logParticipationTokensBurned(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);
    function logParticipationTokensMinted(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);
    function logMarketRepBondTransferred(address _universe, address _from, address _to) public returns (bool);
    function logWarpSyncDataUpdated(address _universe, uint256 _warpSyncHash, uint256 _marketEndTime) public returns (bool);
    function isKnownFeeSender(address _feeSender) public view returns (bool);
    function lookup(bytes32 _key) public view returns (address);
    function getTimestamp() public view returns (uint256);
    function getMaximumMarketEndDate() public returns (uint256);
    function isKnownMarket(IMarket _market) public view returns (bool);
    function derivePayoutDistributionHash(uint256[] memory _payoutNumerators, uint256 _numTicks, uint256 numOutcomes) public view returns (bytes32);
    function logValidityBondChanged(uint256 _validityBond) public returns (bool);
    function logDesignatedReportStakeChanged(uint256 _designatedReportStake) public returns (bool);
    function logNoShowBondChanged(uint256 _noShowBond) public returns (bool);
    function logReportingFeeChanged(uint256 _reportingFee) public returns (bool);
    function getUniverseForkIndex(IUniverse _universe) public view returns (uint256);
}

contract IDisputeWindowFactory {
    function createDisputeWindow(IAugur _augur, uint256 _disputeWindowId, uint256 _windowDuration, uint256 _startTime, bool _participationTokensEnabled) public returns (IDisputeWindow);
}

contract IMarketFactory {
    function createMarket(IAugur _augur, uint256 _endTime, uint256 _feePerCashInAttoCash, IAffiliateValidator _affiliateValidator, uint256 _affiliateFeeDivisor, address _designatedReporterAddress, address _sender, uint256 _numOutcomes, uint256 _numTicks) public returns (IMarket _market);
}

contract IOICashFactory {
    function createOICash(IAugur _augur) public returns (IOICash);
}

contract IReputationTokenFactory {
    function createReputationToken(IAugur _augur, IUniverse _parentUniverse) public returns (IV2ReputationToken);
}

contract IOwnable {
    function getOwner() public view returns (address);
    function transferOwnership(address _newOwner) public returns (bool);
}

contract ITyped {
    function getTypeName() public view returns (bytes32);
}

library SafeMathUint256 {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a <= b) {
            return a;
        } else {
            return b;
        }
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a >= b) {
            return a;
        } else {
            return b;
        }
    }

    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            uint256 x = (y + 1) / 2;
            z = y;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function getUint256Min() internal pure returns (uint256) {
        return 0;
    }

    function getUint256Max() internal pure returns (uint256) {
        // 2 ** 256 - 1
        return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    }

    function isMultipleOf(uint256 a, uint256 b) internal pure returns (bool) {
        return a % b == 0;
    }

    // Float [fixed point] Operations
    function fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
        return div(mul(a, b), base);
    }

    function fxpDiv(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
        return div(mul(a, base), b);
    }
}

interface IERC1155 {

    /// @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred,
    ///      including zero value transfers as well as minting or burning.
    /// Operator will always be msg.sender.
    /// Either event from address `0x0` signifies a minting operation.
    /// An event to address `0x0` signifies a burning or melting operation.
    /// The total value transferred from address 0x0 minus the total value transferred to 0x0 may
    /// be used by clients and exchanges to be added to the "circulating supply" for a given token ID.
    /// To define a token ID with no initial balance, the contract SHOULD emit the TransferSingle event
    /// from `0x0` to `0x0`, with the token creator as `_operator`.
    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 value
    );

    /// @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred,
    ///      including zero value transfers as well as minting or burning.
    ///Operator will always be msg.sender.
    /// Either event from address `0x0` signifies a minting operation.
    /// An event to address `0x0` signifies a burning or melting operation.
    /// The total value transferred from address 0x0 minus the total value transferred to 0x0 may
    /// be used by clients and exchanges to be added to the "circulating supply" for a given token ID.
    /// To define multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event
    /// from `0x0` to `0x0`, with the token creator as `_operator`.
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    /// @dev MUST emit when an approval is updated.
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    /// @dev MUST emit when the URI is updated for a token ID.
    /// URIs are defined in RFC 3986.
    /// The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema".
    event URI(
        string value,
        uint256 indexed id
    );

    /// @notice Transfers value amount of an _id from the _from address to the _to address specified.
    /// @dev MUST emit TransferSingle event on success.
    /// Caller must be approved to manage the _from account's tokens (see isApprovedForAll).
    /// MUST throw if `_to` is the zero address.
    /// MUST throw if balance of sender for token `_id` is lower than the `_value` sent.
    /// MUST throw on any other error.
    /// When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0).
    /// If so, it MUST call `onERC1155Received` on `_to` and revert if the return value
    /// is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`.
    /// @param from    Source address
    /// @param to      Target address
    /// @param id      ID of the token type
    /// @param value   Transfer amount
    /// @param data    Additional data with no specified format, sent in call to `_to`
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    )
        external;

    /// @notice Send multiple types of Tokens from a 3rd party in one transfer (with safety call).
    /// @dev MUST emit TransferBatch event on success.
    /// Caller must be approved to manage the _from account's tokens (see isApprovedForAll).
    /// MUST throw if `_to` is the zero address.
    /// MUST throw if length of `_ids` is not the same as length of `_values`.
    ///  MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_values` sent.
    /// MUST throw on any other error.
    /// When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0).
    /// If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return value
    /// is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`.
    /// @param from    Source addresses
    /// @param to      Target addresses
    /// @param ids     IDs of each token type
    /// @param values  Transfer amounts per token type
    /// @param data    Additional data with no specified format, sent in call to `_to`
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    )
        external;

    /// @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
    /// @dev MUST emit the ApprovalForAll event on success.
    /// @param operator  Address to add to the set of authorized operators
    /// @param approved  True if the operator is approved, false to revoke approval
    function setApprovalForAll(address operator, bool approved) external;

    /// @notice Queries the approval status of an operator for a given owner.
    /// @param owner     The owner of the Tokens
    /// @param operator  Address of authorized operator
    /// @return           True if the operator is approved, false if not
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /// @notice Get the balance of an account's Tokens.
    /// @param owner  The address of the token holder
    /// @param id     ID of the Token
    /// @return        The _owner's balance of the Token type requested
    function balanceOf(address owner, uint256 id) external view returns (uint256);

    /// @notice Get the total supply of a Token.
    /// @param id     ID of the Token
    /// @return        The total supply of the Token type requested
    function totalSupply(uint256 id) external view returns (uint256);

    /// @notice Get the balance of multiple account/token pairs
    /// @param owners The addresses of the token holders
    /// @param ids    ID of the Tokens
    /// @return        The _owner's balance of the Token types requested
    function balanceOfBatch(
        address[] calldata owners,
        uint256[] calldata ids
    )
        external
        view
        returns (uint256[] memory balances_);
}

contract IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) public view returns (uint256);
    function transfer(address to, uint256 amount) public returns (bool);
    function transferFrom(address from, address to, uint256 amount) public returns (bool);
    function approve(address spender, uint256 amount) public returns (bool);
    function allowance(address owner, address spender) public view returns (uint256);

    // solhint-disable-next-line no-simple-event-func-name
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ICash is IERC20 {
}

contract IAffiliateValidator {
    function validateReference(address _account, address _referrer) external view returns (bool);
}

contract IDisputeWindow is ITyped, IERC20 {
    function invalidMarketsTotal() external view returns (uint256);
    function validityBondTotal() external view returns (uint256);

    function incorrectDesignatedReportTotal() external view returns (uint256);
    function initialReportBondTotal() external view returns (uint256);

    function designatedReportNoShowsTotal() external view returns (uint256);
    function designatedReporterNoShowBondTotal() external view returns (uint256);

    function initialize(IAugur _augur, IUniverse _universe, uint256 _disputeWindowId, bool _participationTokensEnabled, uint256 _duration, uint256 _startTime) public;
    function trustedBuy(address _buyer, uint256 _attotokens) public returns (bool);
    function getUniverse() public view returns (IUniverse);
    function getReputationToken() public view returns (IReputationToken);
    function getStartTime() public view returns (uint256);
    function getEndTime() public view returns (uint256);
    function getWindowId() public view returns (uint256);
    function isActive() public view returns (bool);
    function isOver() public view returns (bool);
    function onMarketFinalized() public;
    function redeem(address _account) public returns (bool);
}

contract IMarket is IOwnable {
    enum MarketType {
        YES_NO,
        CATEGORICAL,
        SCALAR
    }

    function initialize(IAugur _augur, IUniverse _universe, uint256 _endTime, uint256 _feePerCashInAttoCash, IAffiliateValidator _affiliateValidator, uint256 _affiliateFeeDivisor, address _designatedReporterAddress, address _creator, uint256 _numOutcomes, uint256 _numTicks) public;
    function derivePayoutDistributionHash(uint256[] memory _payoutNumerators) public view returns (bytes32);
    function doInitialReport(uint256[] memory _payoutNumerators, string memory _description, uint256 _additionalStake) public returns (bool);
    function getUniverse() public view returns (IUniverse);
    function getDisputeWindow() public view returns (IDisputeWindow);
    function getNumberOfOutcomes() public view returns (uint256);
    function getNumTicks() public view returns (uint256);
    function getMarketCreatorSettlementFeeDivisor() public view returns (uint256);
    function getForkingMarket() public view returns (IMarket _market);
    function getEndTime() public view returns (uint256);
    function getWinningPayoutDistributionHash() public view returns (bytes32);
    function getWinningPayoutNumerator(uint256 _outcome) public view returns (uint256);
    function getWinningReportingParticipant() public view returns (IReportingParticipant);
    function getReputationToken() public view returns (IV2ReputationToken);
    function getFinalizationTime() public view returns (uint256);
    function getInitialReporter() public view returns (IInitialReporter);
    function getDesignatedReportingEndTime() public view returns (uint256);
    function getValidityBondAttoCash() public view returns (uint256);
    function affiliateFeeDivisor() external view returns (uint256);
    function getNumParticipants() public view returns (uint256);
    function getDisputePacingOn() public view returns (bool);
    function deriveMarketCreatorFeeAmount(uint256 _amount) public view returns (uint256);
    function recordMarketCreatorFees(uint256 _marketCreatorFees, address _sourceAccount, bytes32 _fingerprint) public returns (bool);
    function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
    function isFinalizedAsInvalid() public view returns (bool);
    function finalize() public returns (bool);
    function isFinalized() public view returns (bool);
    function getOpenInterest() public view returns (uint256);
}

contract IOICash is IERC20 {
    function initialize(IAugur _augur, IUniverse _universe) external;
}

interface IRepOracle {
    function getLastUpdateTimestamp(address _reputationToken) external view returns (uint256);
    function poke(address _reputationTokenAddress) external returns (uint256);
}

contract IReportingParticipant {
    function getStake() public view returns (uint256);
    function getPayoutDistributionHash() public view returns (bytes32);
    function liquidateLosing() public;
    function redeem(address _redeemer) public returns (bool);
    function isDisavowed() public view returns (bool);
    function getPayoutNumerator(uint256 _outcome) public view returns (uint256);
    function getPayoutNumerators() public view returns (uint256[] memory);
    function getMarket() public view returns (IMarket);
    function getSize() public view returns (uint256);
}

contract IInitialReporter is IReportingParticipant, IOwnable {
    function initialize(IAugur _augur, IMarket _market, address _designatedReporter) public;
    function report(address _reporter, bytes32 _payoutDistributionHash, uint256[] memory _payoutNumerators, uint256 _initialReportStake) public;
    function designatedReporterShowed() public view returns (bool);
    function initialReporterWasCorrect() public view returns (bool);
    function getDesignatedReporter() public view returns (address);
    function getReportTimestamp() public view returns (uint256);
    function migrateToNewUniverse(address _designatedReporter) public;
    function returnRepFromDisavow() public;
}

contract IReputationToken is IERC20 {
    function migrateOutByPayout(uint256[] memory _payoutNumerators, uint256 _attotokens) public returns (bool);
    function migrateIn(address _reporter, uint256 _attotokens) public returns (bool);
    function trustedReportingParticipantTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
    function trustedMarketTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
    function trustedUniverseTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
    function trustedDisputeWindowTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
    function getUniverse() public view returns (IUniverse);
    function getTotalMigrated() public view returns (uint256);
    function getTotalTheoreticalSupply() public view returns (uint256);
    function mintForReportingParticipant(uint256 _amountMigrated) public returns (bool);
}

contract IShareToken is ITyped, IERC1155 {
    function initialize(IAugur _augur) external;
    function initializeMarket(IMarket _market, uint256 _numOutcomes, uint256 _numTicks) public;
    function unsafeTransferFrom(address _from, address _to, uint256 _id, uint256 _value) public;
    function unsafeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _values) public;
    function claimTradingProceeds(IMarket _market, address _shareHolder, bytes32 _fingerprint) external returns (uint256[] memory _outcomeFees);
    function getMarket(uint256 _tokenId) external view returns (IMarket);
    function getOutcome(uint256 _tokenId) external view returns (uint256);
    function getTokenId(IMarket _market, uint256 _outcome) public pure returns (uint256 _tokenId);
    function getTokenIds(IMarket _market, uint256[] memory _outcomes) public pure returns (uint256[] memory _tokenIds);
    function buyCompleteSets(IMarket _market, address _account, uint256 _amount) external returns (bool);
    function buyCompleteSetsForTrade(IMarket _market, uint256 _amount, uint256 _longOutcome, address _longRecipient, address _shortRecipient) external returns (bool);
    function sellCompleteSets(IMarket _market, address _holder, address _recipient, uint256 _amount, bytes32 _fingerprint) external returns (uint256 _creatorFee, uint256 _reportingFee);
    function sellCompleteSetsForTrade(IMarket _market, uint256 _outcome, uint256 _amount, address _shortParticipant, address _longParticipant, address _shortRecipient, address _longRecipient, uint256 _price, address _sourceAccount, bytes32 _fingerprint) external returns (uint256 _creatorFee, uint256 _reportingFee);
    function totalSupplyForMarketOutcome(IMarket _market, uint256 _outcome) public view returns (uint256);
    function balanceOfMarketOutcome(IMarket _market, uint256 _outcome, address _account) public view returns (uint256);
    function lowestBalanceOfMarketOutcomes(IMarket _market, uint256[] memory _outcomes, address _account) public view returns (uint256);
}

contract IUniverse {
    function creationTime() external view returns (uint256);
    function marketBalance(address) external view returns (uint256);

    function fork() public returns (bool);
    function updateForkValues() public returns (bool);
    function getParentUniverse() public view returns (IUniverse);
    function createChildUniverse(uint256[] memory _parentPayoutNumerators) public returns (IUniverse);
    function getChildUniverse(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse);
    function getReputationToken() public view returns (IV2ReputationToken);
    function getForkingMarket() public view returns (IMarket);
    function getForkEndTime() public view returns (uint256);
    function getForkReputationGoal() public view returns (uint256);
    function getParentPayoutDistributionHash() public view returns (bytes32);
    function getDisputeRoundDurationInSeconds(bool _initial) public view returns (uint256);
    function getOrCreateDisputeWindowByTimestamp(uint256 _timestamp, bool _initial) public returns (IDisputeWindow);
    function getOrCreateCurrentDisputeWindow(bool _initial) public returns (IDisputeWindow);
    function getOrCreateNextDisputeWindow(bool _initial) public returns (IDisputeWindow);
    function getOrCreatePreviousDisputeWindow(bool _initial) public returns (IDisputeWindow);
    function getOpenInterestInAttoCash() public view returns (uint256);
    function getTargetRepMarketCapInAttoCash() public view returns (uint256);
    function getOrCacheValidityBond() public returns (uint256);
    function getOrCacheDesignatedReportStake() public returns (uint256);
    function getOrCacheDesignatedReportNoShowBond() public returns (uint256);
    function getOrCacheMarketRepBond() public returns (uint256);
    function getOrCacheReportingFeeDivisor() public returns (uint256);
    function getDisputeThresholdForFork() public view returns (uint256);
    function getDisputeThresholdForDisputePacing() public view returns (uint256);
    function getInitialReportMinValue() public view returns (uint256);
    function getPayoutNumerators() public view returns (uint256[] memory);
    function getReportingFeeDivisor() public view returns (uint256);
    function getPayoutNumerator(uint256 _outcome) public view returns (uint256);
    function getWinningChildPayoutNumerator(uint256 _outcome) public view returns (uint256);
    function isOpenInterestCash(address) public view returns (bool);
    function isForkingMarket() public view returns (bool);
    function getCurrentDisputeWindow(bool _initial) public view returns (IDisputeWindow);
    function getDisputeWindowStartTimeAndDuration(uint256 _timestamp, bool _initial) public view returns (uint256, uint256);
    function isParentOf(IUniverse _shadyChild) public view returns (bool);
    function updateTentativeWinningChildUniverse(bytes32 _parentPayoutDistributionHash) public returns (bool);
    function isContainerForDisputeWindow(IDisputeWindow _shadyTarget) public view returns (bool);
    function isContainerForMarket(IMarket _shadyTarget) public view returns (bool);
    function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
    function migrateMarketOut(IUniverse _destinationUniverse) public returns (bool);
    function migrateMarketIn(IMarket _market, uint256 _cashBalance, uint256 _marketOI) public returns (bool);
    function decrementOpenInterest(uint256 _amount) public returns (bool);
    function decrementOpenInterestFromMarket(IMarket _market) public returns (bool);
    function incrementOpenInterest(uint256 _amount) public returns (bool);
    function getWinningChildUniverse() public view returns (IUniverse);
    function isForking() public view returns (bool);
    function deposit(address _sender, uint256 _amount, address _market) public returns (bool);
    function withdraw(address _recipient, uint256 _amount, address _market) public returns (bool);
    function createScalarMarket(uint256 _endTime, uint256 _feePerCashInAttoCash, IAffiliateValidator _affiliateValidator, uint256 _affiliateFeeDivisor, address _designatedReporterAddress, int256[] memory _prices, uint256 _numTicks, string memory _extraInfo) public returns (IMarket _newMarket);
}

contract IV2ReputationToken is IReputationToken {
    function parentUniverse() external returns (IUniverse);
    function burnForMarket(uint256 _amountToBurn) public returns (bool);
    function mintForWarpSync(uint256 _amountToMint, address _target) public returns (bool);
}

library Reporting {
    uint256 private constant DESIGNATED_REPORTING_DURATION_SECONDS = 1 days;
    uint256 private constant DISPUTE_ROUND_DURATION_SECONDS = 7 days;
    uint256 private constant INITIAL_DISPUTE_ROUND_DURATION_SECONDS = 1 days;
    uint256 private constant DISPUTE_WINDOW_BUFFER_SECONDS = 1 hours;
    uint256 private constant FORK_DURATION_SECONDS = 60 days;

    uint256 private constant BASE_MARKET_DURATION_MAXIMUM = 30 days; // A market of 30 day length can always be created
    uint256 private constant UPGRADE_CADENCE = 365 days;
    uint256 private constant INITIAL_UPGRADE_TIMESTAMP = 1627776000; // Aug 1st 2021

    uint256 private constant INITIAL_REP_SUPPLY = 11 * 10 ** 6 * 10 ** 18; // 11 Million REP

    uint256 private constant AFFILIATE_SOURCE_CUT_DIVISOR = 5; // The trader gets 20% of the affiliate fee when an affiliate fee is taken

    uint256 private constant DEFAULT_VALIDITY_BOND = 10 ether; // 10 Cash (Dai)
    uint256 private constant VALIDITY_BOND_FLOOR = 10 ether; // 10 Cash (Dai)
    uint256 private constant DEFAULT_REPORTING_FEE_DIVISOR = 10000; // .01% fees
    uint256 private constant MAXIMUM_REPORTING_FEE_DIVISOR = 10000; // Minimum .01% fees
    uint256 private constant MINIMUM_REPORTING_FEE_DIVISOR = 3; // Maximum 33.3~% fees. Note than anything less than a value of 2 here will likely result in bugs such as divide by 0 cases.

    uint256 private constant TARGET_INVALID_MARKETS_DIVISOR = 100; // 1% of markets are expected to be invalid
    uint256 private constant TARGET_INCORRECT_DESIGNATED_REPORT_MARKETS_DIVISOR = 100; // 1% of markets are expected to have an incorrect designate report
    uint256 private constant TARGET_DESIGNATED_REPORT_NO_SHOWS_DIVISOR = 20; // 5% of markets are expected to have a no show
    uint256 private constant TARGET_REP_MARKET_CAP_MULTIPLIER = 5; // We multiply and divide by constants since we may want to multiply by a fractional amount

    uint256 private constant FORK_THRESHOLD_DIVISOR = 40; // 2.5% of the total REP supply being filled in a single dispute bond will trigger a fork
    uint256 private constant MAXIMUM_DISPUTE_ROUNDS = 20; // We ensure that after 20 rounds of disputes a fork will occur
    uint256 private constant MINIMUM_SLOW_ROUNDS = 8; // We ensure that at least 8 dispute rounds take DISPUTE_ROUND_DURATION_SECONDS+ seconds to complete until the next round begins

    function getDesignatedReportingDurationSeconds() internal pure returns (uint256) { return DESIGNATED_REPORTING_DURATION_SECONDS; }
    function getInitialDisputeRoundDurationSeconds() internal pure returns (uint256) { return INITIAL_DISPUTE_ROUND_DURATION_SECONDS; }
    function getDisputeWindowBufferSeconds() internal pure returns (uint256) { return DISPUTE_WINDOW_BUFFER_SECONDS; }
    function getDisputeRoundDurationSeconds() internal pure returns (uint256) { return DISPUTE_ROUND_DURATION_SECONDS; }
    function getForkDurationSeconds() internal pure returns (uint256) { return FORK_DURATION_SECONDS; }
    function getBaseMarketDurationMaximum() internal pure returns (uint256) { return BASE_MARKET_DURATION_MAXIMUM; }
    function getUpgradeCadence() internal pure returns (uint256) { return UPGRADE_CADENCE; }
    function getInitialUpgradeTimestamp() internal pure returns (uint256) { return INITIAL_UPGRADE_TIMESTAMP; }
    function getDefaultValidityBond() internal pure returns (uint256) { return DEFAULT_VALIDITY_BOND; }
    function getValidityBondFloor() internal pure returns (uint256) { return VALIDITY_BOND_FLOOR; }
    function getTargetInvalidMarketsDivisor() internal pure returns (uint256) { return TARGET_INVALID_MARKETS_DIVISOR; }
    function getTargetIncorrectDesignatedReportMarketsDivisor() internal pure returns (uint256) { return TARGET_INCORRECT_DESIGNATED_REPORT_MARKETS_DIVISOR; }
    function getTargetDesignatedReportNoShowsDivisor() internal pure returns (uint256) { return TARGET_DESIGNATED_REPORT_NO_SHOWS_DIVISOR; }
    function getTargetRepMarketCapMultiplier() internal pure returns (uint256) { return TARGET_REP_MARKET_CAP_MULTIPLIER; }
    function getMaximumReportingFeeDivisor() internal pure returns (uint256) { return MAXIMUM_REPORTING_FEE_DIVISOR; }
    function getMinimumReportingFeeDivisor() internal pure returns (uint256) { return MINIMUM_REPORTING_FEE_DIVISOR; }
    function getDefaultReportingFeeDivisor() internal pure returns (uint256) { return DEFAULT_REPORTING_FEE_DIVISOR; }
    function getInitialREPSupply() internal pure returns (uint256) { return INITIAL_REP_SUPPLY; }
    function getAffiliateSourceCutDivisor() internal pure returns (uint256) { return AFFILIATE_SOURCE_CUT_DIVISOR; }
    function getForkThresholdDivisor() internal pure returns (uint256) { return FORK_THRESHOLD_DIVISOR; }
    function getMaximumDisputeRounds() internal pure returns (uint256) { return MAXIMUM_DISPUTE_ROUNDS; }
    function getMinimumSlowRounds() internal pure returns (uint256) { return MINIMUM_SLOW_ROUNDS; }
}

contract IAugurTrading {
    function lookup(bytes32 _key) public view returns (address);
    function logProfitLossChanged(IMarket _market, address _account, uint256 _outcome, int256 _netPosition, uint256 _avgPrice, int256 _realizedProfit, int256 _frozenFunds, int256 _realizedCost) public returns (bool);
    function logOrderCreated(IUniverse _universe, bytes32 _orderId, bytes32 _tradeGroupId) public returns (bool);
    function logOrderCanceled(IUniverse _universe, IMarket _market, address _creator, uint256 _tokenRefund, uint256 _sharesRefund, bytes32 _orderId) public returns (bool);
    function logOrderFilled(IUniverse _universe, address _creator, address _filler, uint256 _price, uint256 _fees, uint256 _amountFilled, bytes32 _orderId, bytes32 _tradeGroupId) public returns (bool);
    function logMarketVolumeChanged(IUniverse _universe, address _market, uint256 _volume, uint256[] memory _outcomeVolumes, uint256 _totalTrades) public returns (bool);
    function logZeroXOrderFilled(IUniverse _universe, IMarket _market, bytes32 _orderHash, bytes32 _tradeGroupId, uint8 _orderType, address[] memory _addressData, uint256[] memory _uint256Data) public returns (bool);
    function logZeroXOrderCanceled(address _universe, address _market, address _account, uint256 _outcome, uint256 _price, uint256 _amount, uint8 _type, bytes32 _orderHash) public;
}

contract IOrders {
    function saveOrder(uint256[] calldata _uints, bytes32[] calldata _bytes32s, Order.Types _type, IMarket _market, address _sender) external returns (bytes32 _orderId);
    function removeOrder(bytes32 _orderId) external returns (bool);
    function getMarket(bytes32 _orderId) public view returns (IMarket);
    function getOrderType(bytes32 _orderId) public view returns (Order.Types);
    function getOutcome(bytes32 _orderId) public view returns (uint256);
    function getAmount(bytes32 _orderId) public view returns (uint256);
    function getPrice(bytes32 _orderId) public view returns (uint256);
    function getOrderCreator(bytes32 _orderId) public view returns (address);
    function getOrderSharesEscrowed(bytes32 _orderId) public view returns (uint256);
    function getOrderMoneyEscrowed(bytes32 _orderId) public view returns (uint256);
    function getOrderDataForCancel(bytes32 _orderId) public view returns (uint256, uint256, Order.Types, IMarket, uint256, address);
    function getOrderDataForLogs(bytes32 _orderId) public view returns (Order.Types, address[] memory _addressData, uint256[] memory _uint256Data);
    function getBetterOrderId(bytes32 _orderId) public view returns (bytes32);
    function getWorseOrderId(bytes32 _orderId) public view returns (bytes32);
    function getBestOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
    function getWorstOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
    function getLastOutcomePrice(IMarket _market, uint256 _outcome) public view returns (uint256);
    function getOrderId(Order.Types _type, IMarket _market, uint256 _amount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);
    function getTotalEscrowed(IMarket _market) public view returns (uint256);
    function isBetterPrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
    function isWorsePrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
    function assertIsNotBetterPrice(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);
    function assertIsNotWorsePrice(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);
    function recordFillOrder(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled, uint256 _fill) external returns (bool);
    function setPrice(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);
}

library Order {
    using SafeMathUint256 for uint256;

    enum Types {
        Bid, Ask
    }

    enum TradeDirections {
        Long, Short
    }

    struct Data {
        // Contracts
        IMarket market;
        IAugur augur;
        IAugurTrading augurTrading;
        IShareToken shareToken;
        ICash cash;

        // Order
        bytes32 id;
        address creator;
        uint256 outcome;
        Order.Types orderType;
        uint256 amount;
        uint256 price;
        uint256 sharesEscrowed;
        uint256 moneyEscrowed;
        bytes32 betterOrderId;
        bytes32 worseOrderId;
    }

    function create(IAugur _augur, IAugurTrading _augurTrading, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data memory) {
        require(_outcome < _market.getNumberOfOutcomes(), "Order.create: Outcome is not within market range");
        require(_price != 0, "Order.create: Price may not be 0");
        require(_price < _market.getNumTicks(), "Order.create: Price is outside of market range");
        require(_attoshares > 0, "Order.create: Cannot use amount of 0");
        require(_creator != address(0), "Order.create: Creator is 0x0");

        IShareToken _shareToken = IShareToken(_augur.lookup("ShareToken"));

        return Data({
            market: _market,
            augur: _augur,
            augurTrading: _augurTrading,
            shareToken: _shareToken,
            cash: ICash(_augur.lookup("Cash")),
            id: 0,
            creator: _creator,
            outcome: _outcome,
            orderType: _type,
            amount: _attoshares,
            price: _price,
            sharesEscrowed: 0,
            moneyEscrowed: 0,
            betterOrderId: _betterOrderId,
            worseOrderId: _worseOrderId
        });
    }

    //
    // "public" functions
    //

    function getOrderId(Order.Data memory _orderData, IOrders _orders) internal view returns (bytes32) {
        if (_orderData.id == bytes32(0)) {
            bytes32 _orderId = calculateOrderId(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, block.number, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed);
            require(_orders.getAmount(_orderId) == 0, "Order.getOrderId: New order had amount. This should not be possible");
            _orderData.id = _orderId;
        }
        return _orderData.id;
    }

    function calculateOrderId(Order.Types _type, IMarket _market, uint256 _amount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) internal pure returns (bytes32) {
        return sha256(abi.encodePacked(_type, _market, _amount, _price, _sender, _blockNumber, _outcome, _moneyEscrowed, _sharesEscrowed));
    }

    function getOrderTradingTypeFromMakerDirection(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {
        return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
    }

    function getOrderTradingTypeFromFillerDirection(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {
        return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
    }

    function saveOrder(Order.Data memory _orderData, bytes32 _tradeGroupId, IOrders _orders) internal returns (bytes32) {
        getOrderId(_orderData, _orders);
        uint256[] memory _uints = new uint256[](5);
        _uints[0] = _orderData.amount;
        _uints[1] = _orderData.price;
        _uints[2] = _orderData.outcome;
        _uints[3] = _orderData.moneyEscrowed;
        _uints[4] = _orderData.sharesEscrowed;
        bytes32[] memory _bytes32s = new bytes32[](4);
        _bytes32s[0] = _orderData.betterOrderId;
        _bytes32s[1] = _orderData.worseOrderId;
        _bytes32s[2] = _tradeGroupId;
        _bytes32s[3] = _orderData.id;
        return _orders.saveOrder(_uints, _bytes32s, _orderData.orderType, _orderData.market, _orderData.creator);
    }
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

contract IFormulas {
    function calculateFloatingValue(uint256 _totalBad, uint256 _total, uint256 _targetDivisor, uint256 _previousValue, uint256 _floor) public pure returns (uint256 _newValue);
    function calculateValidityBond(IDisputeWindow  _previousDisputeWindow, uint256 _previousValidityBondInAttoCash) public view returns (uint256);
    function calculateDesignatedReportStake(IDisputeWindow  _previousDisputeWindow, uint256 _previousDesignatedReportStakeInAttoRep, uint256 _initialReportMinValue) public view returns (uint256);
    function calculateDesignatedReportNoShowBond(IDisputeWindow  _previousDisputeWindow, uint256 _previousDesignatedReportNoShowBondInAttoRep, uint256 _initialReportMinValue) public view returns (uint256);
}

contract Universe is IUniverse {
    using SafeMathUint256 for uint256;

    uint256 public creationTime;
    mapping(address => uint256) public marketBalance;

    IAugur public augur;
    IUniverse private parentUniverse;
    IFormulas public formulas;
    IShareToken public shareToken;
    bytes32 private parentPayoutDistributionHash;
    uint256[] public payoutNumerators;
    IV2ReputationToken private reputationToken;
    IOICash public openInterestCash;
    IMarket private forkingMarket;
    bytes32 private tentativeWinningChildUniversePayoutDistributionHash;
    uint256 private forkEndTime;
    uint256 private forkReputationGoal;
    uint256 private disputeThresholdForFork;
    uint256 private disputeThresholdForDisputePacing;
    uint256 private initialReportMinValue;
    mapping(uint256 => IDisputeWindow) public disputeWindows;
    mapping(address => bool) private markets;
    mapping(bytes32 => IUniverse) private childUniverses;
    uint256 private openInterestInAttoCash;
    IMarketFactory public marketFactory;
    IDisputeWindowFactory public disputeWindowFactory;

    mapping (address => uint256) public validityBondInAttoCash;
    mapping (address => uint256) public designatedReportStakeInAttoRep;
    mapping (address => uint256) public designatedReportNoShowBondInAttoRep;
    uint256 public previousValidityBondInAttoCash;
    uint256 public previousDesignatedReportStakeInAttoRep;
    uint256 public previousDesignatedReportNoShowBondInAttoRep;

    mapping (address => uint256) public shareSettlementFeeDivisor;
    uint256 public previousReportingFeeDivisor;

    uint256 constant public INITIAL_WINDOW_ID_BUFFER = 365 days * 10 ** 8;
    uint256 constant public DEFAULT_NUM_OUTCOMES = 2;
    uint256 constant public DEFAULT_NUM_TICKS = 1000;

    uint256 public totalBalance;
    ICash public cash;

    IRepOracle public repOracle;

    constructor(IAugur _augur, IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash, uint256[] memory _payoutNumerators) public {
        augur = _augur;
        creationTime = _augur.getTimestamp();
        parentUniverse = _parentUniverse;
        parentPayoutDistributionHash = _parentPayoutDistributionHash;
        payoutNumerators = _payoutNumerators;
        reputationToken = IReputationTokenFactory(augur.lookup("ReputationTokenFactory")).createReputationToken(augur, parentUniverse);
        marketFactory = IMarketFactory(augur.lookup("MarketFactory"));
        disputeWindowFactory = IDisputeWindowFactory(augur.lookup("DisputeWindowFactory"));
        openInterestCash = IOICashFactory(augur.lookup("OICashFactory")).createOICash(augur);
        shareToken = IShareToken(augur.lookup("ShareToken"));
        repOracle = IRepOracle(augur.lookup("RepOracle"));
        updateForkValues();
        formulas = IFormulas(augur.lookup("Formulas"));
        cash = ICash(augur.lookup("Cash"));
        assertContractsNotZero();
    }

    function assertContractsNotZero() private view {
        require(marketFactory != IMarketFactory(0));
        require(disputeWindowFactory != IDisputeWindowFactory(0));
        require(shareToken != IShareToken(0));
        require(formulas != IFormulas(0));
        require(cash != ICash(0));
    }

    function fork() public returns (bool) {
        updateForkValues();
        require(!isForking());
        require(isContainerForMarket(IMarket(msg.sender)));
        forkingMarket = IMarket(msg.sender);
        forkEndTime = augur.getTimestamp().add(Reporting.getForkDurationSeconds());
        augur.logUniverseForked(forkingMarket);
        return true;
    }

    function updateForkValues() public returns (bool) {
        require(!isForking());
        uint256 _totalRepSupply = reputationToken.getTotalTheoreticalSupply();
        forkReputationGoal = _totalRepSupply.div(2); // 50% of REP migrating results in a victory in a fork
        disputeThresholdForFork = _totalRepSupply.div(Reporting.getForkThresholdDivisor()); // 2.5% of the total rep supply
        initialReportMinValue = disputeThresholdForFork.div(3).div(2**(Reporting.getMaximumDisputeRounds()-2)).add(1); // This value will result in a maximum 20 round dispute sequence
        disputeThresholdForDisputePacing = disputeThresholdForFork.div(2**(Reporting.getMinimumSlowRounds()+1)); // Disputes begin normal pacing once there are 8 rounds remaining in the fastest case to fork. The "last" round is the one that causes a fork and requires no time so the exponent here is 9 to provide for that many rounds actually occurring.
        return true;
    }

    function getPayoutNumerator(uint256 _outcome) public view returns (uint256) {
        return payoutNumerators[_outcome];
    }

    function getWinningChildPayoutNumerator(uint256 _outcome) public view returns (uint256) {
        return getWinningChildUniverse().getPayoutNumerator(_outcome);
    }

    /**
     * @return This Universe's parent universe or 0x0 if this is the Genesis universe
     */
    function getParentUniverse() public view returns (IUniverse) {
        return parentUniverse;
    }

    /**
     * @return The Bytes32 payout distribution hash of the parent universe or 0x0 if this is the Genesis universe
     */
    function getParentPayoutDistributionHash() public view returns (bytes32) {
        return parentPayoutDistributionHash;
    }

    /**
     * @return The REP token associated with this Universe
     */
    function getReputationToken() public view returns (IV2ReputationToken) {
        return reputationToken;
    }

    /**
     * @return The market in this universe that has triggered a fork if there is one
     */
    function getForkingMarket() public view returns (IMarket) {
        return forkingMarket;
    }

    /**
     * @return The end of the window to migrate REP for the fork if one has occurred in this Universe
     */
    function getForkEndTime() public view returns (uint256) {
        return forkEndTime;
    }

    /**
     * @return The amount of REP migrated into a child universe needed to win a fork
     */
    function getForkReputationGoal() public view returns (uint256) {
        return forkReputationGoal;
    }

    /**
     * @return The amount of REP in a single bond that will trigger a fork if filled
     */
    function getDisputeThresholdForFork() public view returns (uint256) {
        return disputeThresholdForFork;
    }

    /**
     * @return The amount of REP in a single bond that will trigger slow dispute rounds for a market
     */
    function getDisputeThresholdForDisputePacing() public view returns (uint256) {
        return disputeThresholdForDisputePacing;
    }

    /**
     * @return The minimum size of the initial report bond
     */
    function getInitialReportMinValue() public view returns (uint256) {
        return initialReportMinValue;
    }

    /**
     * @return The payout array associated with this universe if it is a child universe from a fork
     */
    function getPayoutNumerators() public view returns (uint256[] memory) {
        return payoutNumerators;
    }

    /**
     * @param _disputeWindowId The id for a dispute window.
     * @return The dispute window for the associated id
     */
    function getDisputeWindow(uint256 _disputeWindowId) public view returns (IDisputeWindow) {
        return disputeWindows[_disputeWindowId];
    }

    /**
     * @return a Bool indicating if this Universe is forking or has forked
     */
    function isForking() public view returns (bool) {
        return forkingMarket != IMarket(0);
    }

    function isForkingMarket() public view returns (bool) {
        return forkingMarket == IMarket(msg.sender);
    }

    /**
     * @param _parentPayoutDistributionHash The payout distribution hash associated with a child Universe to get
     * @return a Universe contract
     */
    function getChildUniverse(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse) {
        return childUniverses[_parentPayoutDistributionHash];
    }

    /**
     * @param _timestamp The timestamp of the desired dispute window
     * @param _initial Bool indicating if the window is an initial dispute window or a standard dispute window
     * @return The id of the specified dispute window
     */
    function getDisputeWindowId(uint256 _timestamp, bool _initial) public view returns (uint256) {
        uint256 _windowId = _timestamp.sub(Reporting.getDisputeWindowBufferSeconds()).div(getDisputeRoundDurationInSeconds(_initial));
        if (_initial) {
            _windowId = _windowId.add(INITIAL_WINDOW_ID_BUFFER);
        }
        return _windowId;
    }

    /**
     * @param _initial Bool indicating if the window is an initial dispute window or a standard dispute window
     * @return The duration in seconds for a dispute window
     */
    function getDisputeRoundDurationInSeconds(bool _initial) public view returns (uint256) {
        return _initial ? Reporting.getInitialDisputeRoundDurationSeconds() : Reporting.getDisputeRoundDurationSeconds();
    }

    /**
     * @param _timestamp The timestamp of the desired dispute window
     * @param _initial Bool indicating if the window is an initial dispute window or a standard dispute window
     * @return The dispute window for the specified params
     */
    function getOrCreateDisputeWindowByTimestamp(uint256 _timestamp, bool _initial) public returns (IDisputeWindow) {
        uint256 _windowId = getDisputeWindowId(_timestamp, _initial);
        if (disputeWindows[_windowId] == IDisputeWindow(0)) {
            (uint256 _startTime, uint256 _duration) = getDisputeWindowStartTimeAndDuration(_timestamp, _initial);
            IDisputeWindow _disputeWindow = disputeWindowFactory.createDisputeWindow(augur, _windowId, _duration, _startTime, !_initial);
            disputeWindows[_windowId] = _disputeWindow;
            augur.logDisputeWindowCreated(_disputeWindow, _windowId, _initial);
        }
        return disputeWindows[_windowId];
    }

    function getDisputeWindowStartTimeAndDuration(uint256 _timestamp, bool _initial) public view returns (uint256 _startTime, uint256 _duration) {
        _duration = getDisputeRoundDurationInSeconds(_initial);
        uint256 _buffer = Reporting.getDisputeWindowBufferSeconds();
        _startTime = _timestamp.sub(_buffer).div(_duration).mul(_duration).add(_buffer);
    }

    /**
     * @param _timestamp The timestamp of the desired dispute window
     * @param _initial Bool indicating if the window is an initial dispute window or a standard dispute window
     * @return The dispute window for the specified params if it exists
     */
    function getDisputeWindowByTimestamp(uint256 _timestamp, bool _initial) public view returns (IDisputeWindow) {
        uint256 _windowId = getDisputeWindowId(_timestamp, _initial);
        return disputeWindows[_windowId];
    }

    /**
     * @param _initial Bool indicating if the window is an initial dispute window or a standard dispute window
     * @return The dispute window before the previous one
     */
    function getOrCreatePreviousPreviousDisputeWindow(bool _initial) public returns (IDisputeWindow) {
        return getOrCreateDisputeWindowByTimestamp(augur.getTimestamp().sub(getDisputeRoundDurationInSeconds(_initial).mul(2)), _initial);
    }

    /**
     * @param _initial Bool indicating if the window is an initial dispute window or a standard dispute window
     * @return The dispute window before the current one
     */
    function getOrCreatePreviousDisputeWindow(bool _initial) public returns (IDisputeWindow) {
        return getOrCreateDisputeWindowByTimestamp(augur.getTimestamp().sub(getDisputeRoundDurationInSeconds(_initial)), _initial);
    }

    /**
     * @param _initial Bool indicating if the window is an initial dispute window or a standard dispute window
     * @return The current dispute window
     */
    function getOrCreateCurrentDisputeWindow(bool _initial) public returns (IDisputeWindow) {
        return getOrCreateDisputeWindowByTimestamp(augur.getTimestamp(), _initial);
    }

    /**
     * @param _initial Bool indicating if the window is an initial dispute window or a standard dispute window
     * @return The current dispute window if it exists
     */
    function getCurrentDisputeWindow(bool _initial) public view returns (IDisputeWindow) {
        return getDisputeWindowByTimestamp(augur.getTimestamp(), _initial);
    }

    /**
     * @param _initial Bool indicating if the window is an initial dispute window or a standard dispute window
     * @return The dispute window after the current one
     */
    function getOrCreateNextDisputeWindow(bool _initial) public returns (IDisputeWindow) {
        return getOrCreateDisputeWindowByTimestamp(augur.getTimestamp().add(getDisputeRoundDurationInSeconds(_initial)), _initial);
    }

    /**
     * @param _parentPayoutNumerators Array of payouts for each outcome associated with the desired child Universe
     * @return The specified Universe
     */
    function createChildUniverse(uint256[] memory _parentPayoutNumerators) public returns (IUniverse) {
        bytes32 _parentPayoutDistributionHash = forkingMarket.derivePayoutDistributionHash(_parentPayoutNumerators);
        IUniverse _childUniverse = getChildUniverse(_parentPayoutDistributionHash);
        if (_childUniverse == IUniverse(0)) {
            _childUniverse = augur.createChildUniverse(_parentPayoutDistributionHash, _parentPayoutNumerators);
            childUniverses[_parentPayoutDistributionHash] = _childUniverse;
        }
        return _childUniverse;
    }

    function updateTentativeWinningChildUniverse(bytes32 _parentPayoutDistributionHash) public returns (bool) {
        IUniverse _tentativeWinningUniverse = getChildUniverse(tentativeWinningChildUniversePayoutDistributionHash);
        IUniverse _updatedUniverse = getChildUniverse(_parentPayoutDistributionHash);
        uint256 _currentTentativeWinningChildUniverseRepMigrated = 0;
        if (_tentativeWinningUniverse != IUniverse(0)) {
            _currentTentativeWinningChildUniverseRepMigrated = _tentativeWinningUniverse.getReputationToken().getTotalMigrated();
        }
        uint256 _updatedUniverseRepMigrated = _updatedUniverse.getReputationToken().getTotalMigrated();
        if (_updatedUniverseRepMigrated > _currentTentativeWinningChildUniverseRepMigrated) {
            tentativeWinningChildUniversePayoutDistributionHash = _parentPayoutDistributionHash;
        }
        if (_updatedUniverseRepMigrated >= forkReputationGoal) {
            forkingMarket.finalize();
        }
        return true;
    }

    /**
     * @return The child Universe which won in a fork if one exists
     */
    function getWinningChildUniverse() public view returns (IUniverse) {
        require(isForking());
        require(tentativeWinningChildUniversePayoutDistributionHash != bytes32(0));
        IUniverse _tentativeWinningUniverse = getChildUniverse(tentativeWinningChildUniversePayoutDistributionHash);
        uint256 _winningAmount = _tentativeWinningUniverse.getReputationToken().getTotalMigrated();
        require(_winningAmount >= forkReputationGoal || augur.getTimestamp() > forkEndTime);
        return _tentativeWinningUniverse;
    }

    function isContainerForDisputeWindow(IDisputeWindow _shadyDisputeWindow) public view returns (bool) {
        uint256 _disputeWindowId = _shadyDisputeWindow.getWindowId();
        IDisputeWindow _legitDisputeWindow = disputeWindows[_disputeWindowId];
        return _shadyDisputeWindow == _legitDisputeWindow;
    }

    function isContainerForMarket(IMarket _shadyMarket) public view returns (bool) {
        return markets[address(_shadyMarket)];
    }

    function migrateMarketOut(IUniverse _destinationUniverse) public returns (bool) {
        IMarket _market = IMarket(msg.sender);
        require(isContainerForMarket(_market));
        markets[msg.sender] = false;
        uint256 _cashBalance = marketBalance[address(msg.sender)];
        uint256 _marketOI = shareToken.totalSupplyForMarketOutcome(_market, 0).mul(_market.getNumTicks());
        withdraw(address(this), _cashBalance, msg.sender);
        openInterestInAttoCash = openInterestInAttoCash.sub(_marketOI);
        cash.approve(address(augur), _cashBalance);
        _destinationUniverse.migrateMarketIn(_market, _cashBalance, _marketOI);
        return true;
    }

    function migrateMarketIn(IMarket _market, uint256 _cashBalance, uint256 _marketOI) public returns (bool) {
        require(address(parentUniverse) == msg.sender);
        markets[address(_market)] = true;
        deposit(address(msg.sender), _cashBalance, address(_market));
        openInterestInAttoCash = openInterestInAttoCash.add(_marketOI);
        augur.logMarketMigrated(_market, parentUniverse);
        return true;
    }

    function isContainerForReportingParticipant(IReportingParticipant _shadyReportingParticipant) public view returns (bool) {
        IMarket _shadyMarket = _shadyReportingParticipant.getMarket();
        if (_shadyMarket == IMarket(0) || !isContainerForMarket(_shadyMarket)) {
            return false;
        }
        return _shadyMarket.isContainerForReportingParticipant(_shadyReportingParticipant);
    }

    function isParentOf(IUniverse _shadyChild) public view returns (bool) {
        bytes32 _parentPayoutDistributionHash = _shadyChild.getParentPayoutDistributionHash();
        return getChildUniverse(_parentPayoutDistributionHash) == _shadyChild;
    }

    function decrementOpenInterest(uint256 _amount) public returns (bool) {
        require(msg.sender == address(shareToken));
        openInterestInAttoCash = openInterestInAttoCash.sub(_amount);
        return true;
    }

    function decrementOpenInterestFromMarket(IMarket _market) public returns (bool) {
        require(isContainerForMarket(IMarket(msg.sender)));
        uint256 _amount = shareToken.totalSupplyForMarketOutcome(_market, 0).mul(_market.getNumTicks());
        openInterestInAttoCash = openInterestInAttoCash.sub(_amount);
        return true;
    }

    function incrementOpenInterest(uint256 _amount) public returns (bool) {
        require(msg.sender == address(shareToken));
        openInterestInAttoCash = openInterestInAttoCash.add(_amount);
        return true;
    }

    /**
     * @return The total amount of Cash in the system which is at risk (Held in escrow for Shares)
     */
    function getOpenInterestInAttoCash() public view returns (uint256) {
        return openInterestInAttoCash;
    }

    /**
     * @return The OI Cash contract
     */
    function isOpenInterestCash(address _address) public view returns (bool) {
        return _address == address(openInterestCash);
    }

    /**
     * @return The Market Cap of this Universe's REP
     */
    function pokeRepMarketCapInAttoCash() public returns (uint256) {
        uint256 _attoCashPerRep = repOracle.poke(address(reputationToken));
        return getRepMarketCapInAttoCashInternal(_attoCashPerRep);
    }

    function getRepMarketCapInAttoCashInternal(uint256 _attoCashPerRep) private view returns (uint256) {
        return reputationToken.getTotalTheoreticalSupply().mul(_attoCashPerRep).div(10 ** 18);
    }

    /**
     * @return The Target Market Cap of this Universe's REP for use in calculating the Reporting Fee
     */
    function getTargetRepMarketCapInAttoCash() public view returns (uint256) {
        // Target MCAP = OI * TARGET_MULTIPLIER
        uint256 _totalOI = openInterestCash.totalSupply().add(getOpenInterestInAttoCash());
        return _totalOI.mul(Reporting.getTargetRepMarketCapMultiplier());
    }

    /**
     * @return The Validity bond required for this dispute window
     */
    function getOrCacheValidityBond() public returns (uint256) {
        IDisputeWindow _disputeWindow = getOrCreateCurrentDisputeWindow(false);
        IDisputeWindow  _previousDisputeWindow = getOrCreatePreviousPreviousDisputeWindow(false);
        uint256 _currentValidityBondInAttoCash = validityBondInAttoCash[address(_disputeWindow)];
        if (_currentValidityBondInAttoCash != 0) {
            return _currentValidityBondInAttoCash;
        }
        if (previousValidityBondInAttoCash == 0) {
            previousValidityBondInAttoCash = Reporting.getDefaultValidityBond();
        }
        _currentValidityBondInAttoCash = formulas.calculateValidityBond(_previousDisputeWindow, previousValidityBondInAttoCash);
        validityBondInAttoCash[address(_disputeWindow)] = _currentValidityBondInAttoCash;
        previousValidityBondInAttoCash = _currentValidityBondInAttoCash;
        augur.logValidityBondChanged(_currentValidityBondInAttoCash);
        return _currentValidityBondInAttoCash;
    }

    /**
     * @return The Designated Report stake for this dispute window
     */
    function getOrCacheDesignatedReportStake() public returns (uint256) {
        updateForkValues();
        IDisputeWindow _disputeWindow = getOrCreateCurrentDisputeWindow(false);
        IDisputeWindow _previousDisputeWindow = getOrCreatePreviousPreviousDisputeWindow(false);
        uint256 _currentDesignatedReportStakeInAttoRep = designatedReportStakeInAttoRep[address(_disputeWindow)];
        if (_currentDesignatedReportStakeInAttoRep != 0) {
            return _currentDesignatedReportStakeInAttoRep;
        }
        if (previousDesignatedReportStakeInAttoRep == 0) {
            previousDesignatedReportStakeInAttoRep = initialReportMinValue;
        }
        _currentDesignatedReportStakeInAttoRep = formulas.calculateDesignatedReportStake(_previousDisputeWindow, previousDesignatedReportStakeInAttoRep, initialReportMinValue);
        designatedReportStakeInAttoRep[address(_disputeWindow)] = _currentDesignatedReportStakeInAttoRep;
        previousDesignatedReportStakeInAttoRep = _currentDesignatedReportStakeInAttoRep;
        augur.logDesignatedReportStakeChanged(_currentDesignatedReportStakeInAttoRep);
        return _currentDesignatedReportStakeInAttoRep;
    }

    /**
     * @return The No Show bond for this dispute window
     */
    function getOrCacheDesignatedReportNoShowBond() public returns (uint256) {
        IDisputeWindow _disputeWindow = getOrCreateCurrentDisputeWindow(false);
        IDisputeWindow _previousDisputeWindow = getOrCreatePreviousPreviousDisputeWindow(false);
        uint256 _currentDesignatedReportNoShowBondInAttoRep = designatedReportNoShowBondInAttoRep[address(_disputeWindow)];
        if (_currentDesignatedReportNoShowBondInAttoRep != 0) {
            return _currentDesignatedReportNoShowBondInAttoRep;
        }
        if (previousDesignatedReportNoShowBondInAttoRep == 0) {
            previousDesignatedReportNoShowBondInAttoRep = initialReportMinValue;
        }
        _currentDesignatedReportNoShowBondInAttoRep = formulas.calculateDesignatedReportNoShowBond(_previousDisputeWindow, previousDesignatedReportNoShowBondInAttoRep, initialReportMinValue);
        designatedReportNoShowBondInAttoRep[address(_disputeWindow)] = _currentDesignatedReportNoShowBondInAttoRep;
        previousDesignatedReportNoShowBondInAttoRep = _currentDesignatedReportNoShowBondInAttoRep;
        augur.logNoShowBondChanged(_currentDesignatedReportNoShowBondInAttoRep);
        return _currentDesignatedReportNoShowBondInAttoRep;
    }

    /**
     * @return The required REP bond for market creation this dispute window
     */
    function getOrCacheMarketRepBond() public returns (uint256) {
        return getOrCacheDesignatedReportNoShowBond().max(getOrCacheDesignatedReportStake());
    }

    /**
     * @dev this should be used in contracts so that the fee is actually set
     * @return The reporting fee for this dispute window
     */
    function getOrCacheReportingFeeDivisor() public returns (uint256) {
        IDisputeWindow _disputeWindow = getOrCreateCurrentDisputeWindow(false);
        uint256 _currentFeeDivisor = shareSettlementFeeDivisor[address(_disputeWindow)];
        if (_currentFeeDivisor != 0) {
            return _currentFeeDivisor;
        }

        _currentFeeDivisor = calculateReportingFeeDivisorInternal();

        shareSettlementFeeDivisor[address(_disputeWindow)] = _currentFeeDivisor;
        previousReportingFeeDivisor = _currentFeeDivisor;
        augur.logReportingFeeChanged(_currentFeeDivisor);
        return _currentFeeDivisor;
    }

    /**
     * @dev this should be used for estimation purposes as it is a view and does not actually freeze or recalculate the rate
     * @return The reporting fee for this dispute window
     */
    function getReportingFeeDivisor() public view returns (uint256) {
        IDisputeWindow _disputeWindow = getCurrentDisputeWindow(false);
        uint256 _currentFeeDivisor = shareSettlementFeeDivisor[address(_disputeWindow)];
        if (_currentFeeDivisor != 0) {
            return _currentFeeDivisor;
        }

        if (previousReportingFeeDivisor == 0) {
            return Reporting.getDefaultReportingFeeDivisor();
        }

        return previousReportingFeeDivisor;
    }

    function calculateReportingFeeDivisorInternal() private returns (uint256) {
        uint256 _repMarketCapInAttoCash = pokeRepMarketCapInAttoCash();
        uint256 _targetRepMarketCapInAttoCash = getTargetRepMarketCapInAttoCash();
        uint256 _reportingFeeDivisor = 0;
        if (previousReportingFeeDivisor == 0 || _targetRepMarketCapInAttoCash == 0) {
            _reportingFeeDivisor = Reporting.getDefaultReportingFeeDivisor();
        } else {
            _reportingFeeDivisor = previousReportingFeeDivisor.mul(_repMarketCapInAttoCash).div(_targetRepMarketCapInAttoCash);
        }

        _reportingFeeDivisor = _reportingFeeDivisor
            .max(Reporting.getMinimumReportingFeeDivisor())
            .min(Reporting.getMaximumReportingFeeDivisor());

        return _reportingFeeDivisor;
    }

    /**
     * @notice Create a Yes / No Market
     * @param _endTime The time at which the event should be reported on. This should be safely after the event outcome is known and verifiable
     * @param _feePerCashInAttoCash The market creator fee specified as the attoCash to be taken from every 1 Cash which is received during settlement
     * @param _affiliateValidator Optional contract which validate the referrer for any attempt at distributing affiliate fees
     * @param _affiliateFeeDivisor The percentage of market creator fees which is designated for affiliates specified as a divisor (4 would mean that 25% of market creator fees may go toward affiliates)
     * @param _designatedReporterAddress The address which will provide the initial report on the market
     * @param _extraInfo Additional info about the market in JSON format.
     * @return The created Market
     */
    function createYesNoMarket(uint256 _endTime, uint256 _feePerCashInAttoCash, IAffiliateValidator _affiliateValidator, uint256 _affiliateFeeDivisor, address _designatedReporterAddress, string memory _extraInfo) public returns (IMarket _newMarket) {
        _newMarket = createMarketInternal(_endTime, _feePerCashInAttoCash, _affiliateValidator, _affiliateFeeDivisor, _designatedReporterAddress, msg.sender, DEFAULT_NUM_OUTCOMES, DEFAULT_NUM_TICKS);
        augur.onYesNoMarketCreated(_endTime, _extraInfo, _newMarket, msg.sender, _designatedReporterAddress, _feePerCashInAttoCash);
        return _newMarket;
    }

    /**
     * @notice Create a Categorical Market
     * @param _endTime The time at which the event should be reported on. This should be safely after the event outcome is known and verifiable
     * @param _feePerCashInAttoCash The market creator fee specified as the attoCash to be taken from every 1 Cash which is received during settlement
     * @param _affiliateValidator Optional contract which validate the referrer for any attempt at distributing affiliate fees
     * @param _affiliateFeeDivisor The percentage of market creator fees which is designated for affiliates specified as a divisor (4 would mean that 25% of market creator fees may go toward affiliates)
     * @param _designatedReporterAddress The address which will provide the initial report on the market
     * @param _outcomes Array of outcome labels / descriptions
     * @param _extraInfo Additional info about the market in JSON format.
     * @return The created Market
     */
    function createCategoricalMarket(uint256 _endTime, uint256 _feePerCashInAttoCash, IAffiliateValidator _affiliateValidator, uint256 _affiliateFeeDivisor, address _designatedReporterAddress, bytes32[] memory _outcomes, string memory _extraInfo) public returns (IMarket _newMarket) {
        _newMarket = createMarketInternal(_endTime, _feePerCashInAttoCash, _affiliateValidator, _affiliateFeeDivisor, _designatedReporterAddress, msg.sender, uint256(_outcomes.length), DEFAULT_NUM_TICKS);
        augur.onCategoricalMarketCreated(_endTime, _extraInfo, _newMarket, msg.sender, _designatedReporterAddress, _feePerCashInAttoCash, _outcomes);
        return _newMarket;
    }

    /**
     * @notice Create a Scalar Market
     * @param _endTime The time at which the event should be reported on. This should be safely after the event outcome is known and verifiable
     * @param _feePerCashInAttoCash The market creator fee specified as the attoCash to be taken from every 1 Cash which is received during settlement
     * @param _affiliateValidator Optional contract which validate the referrer for any attempt at distributing affiliate fees
     * @param _affiliateFeeDivisor The percentage of market creator fees which is designated for affiliates specified as a divisor (4 would mean that 25% of market creator fees may go toward affiliates)
     * @param _designatedReporterAddress The address which will provide the initial report on the market
     * @param _prices 2 element Array comprising a min price and max price in atto units in order to support decimal values. For example if the display range should be between .1 and .5 the prices should be 10**17 and 5 * 10 ** 17 respectively
     * @param _numTicks The number of ticks for the market. This controls the valid price range. Assume a market with min/maxPrices of 0 and 10**18. A numTicks of 100 would mean that the available valid display prices would be .01 to .99 with step size .01. Similarly a numTicks of 10 would be .1 to .9 with a step size of .1.
     * @param _extraInfo Additional info about the market in JSON format.
     * @return The created Market
     */
    function createScalarMarket(uint256 _endTime, uint256 _feePerCashInAttoCash, IAffiliateValidator _affiliateValidator, uint256 _affiliateFeeDivisor, address _designatedReporterAddress, int256[] memory _prices, uint256 _numTicks, string memory _extraInfo) public returns (IMarket _newMarket) {
        _newMarket = createMarketInternal(_endTime, _feePerCashInAttoCash, _affiliateValidator, _affiliateFeeDivisor, _designatedReporterAddress, msg.sender, DEFAULT_NUM_OUTCOMES, _numTicks);
        augur.onScalarMarketCreated(_endTime, _extraInfo, _newMarket, msg.sender, _designatedReporterAddress, _feePerCashInAttoCash, _prices, _numTicks);
        return _newMarket;
    }

    function createMarketInternal(uint256 _endTime, uint256 _feePerCashInAttoCash, IAffiliateValidator _affiliateValidator, uint256 _affiliateFeeDivisor, address _designatedReporterAddress, address _sender, uint256 _numOutcomes, uint256 _numTicks) private returns (IMarket _newMarket) {
        reputationToken.trustedUniverseTransfer(_sender, address(marketFactory), getOrCacheMarketRepBond());
        _newMarket = marketFactory.createMarket(augur, _endTime, _feePerCashInAttoCash, _affiliateValidator, _affiliateFeeDivisor, _designatedReporterAddress, _sender, _numOutcomes, _numTicks);
        markets[address(_newMarket)] = true;
        shareToken.initializeMarket(_newMarket, _numOutcomes + 1, _numTicks); // To account for Invalid
        return _newMarket;
    }

    function deposit(address _sender, uint256 _amount, address _market) public returns (bool) {
        require(augur.isTrustedSender(msg.sender) || msg.sender == _sender || msg.sender == address(openInterestCash));
        augur.trustedCashTransfer(_sender, address(this), _amount);
        totalBalance = totalBalance.add(_amount);
        marketBalance[_market] = marketBalance[_market].add(_amount);
        return true;
    }

    function withdraw(address _recipient, uint256 _amount, address _market) public returns (bool) {
        if (_amount == 0) {
            return true;
        }
        require(augur.isTrustedSender(msg.sender) || augur.isKnownMarket(IMarket(msg.sender)) || msg.sender == address(openInterestCash));
        totalBalance = totalBalance.sub(_amount);
        marketBalance[_market] = marketBalance[_market].sub(_amount);
        require(cash.transfer(_recipient, _amount));
        return true;
    }

    function runPeriodicals() external returns (bool) {
        uint256 _blockTimestamp = block.timestamp;
        uint256 _timeSinceLastRepOracleUpdate = _blockTimestamp - repOracle.getLastUpdateTimestamp(address(reputationToken));
        if (_timeSinceLastRepOracleUpdate > 1 days) {
            repOracle.poke(address(reputationToken));
        }
        return true;
    }
}