pragma experimental ABIEncoderV2;
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

contract IAugurCreationDataGetter {
    struct MarketCreationData {
        string extraInfo;
        address marketCreator;
        bytes32[] outcomes;
        int256[] displayPrices;
        IMarket.MarketType marketType;
        uint256 recommendedTradeInterval;
    }

    function getMarketCreationData(IMarket _market) public view returns (MarketCreationData memory);
}

contract IUniverseFactory {
    function createUniverse(IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash, uint256[] memory _payoutNumerators) public returns (IUniverse);
}

library ContractExists {
    function exists(address _address) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(_address) }
        return size > 0;
    }
}

contract IOwnable {
    function getOwner() public view returns (address);
    function transferOwnership(address _newOwner) public returns (bool);
}

contract ITyped {
    function getTypeName() public view returns (bytes32);
}

contract ITime is ITyped {
    function getTimestamp() external view returns (uint256);
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

contract IAffiliates {
    function setFingerprint(bytes32 _fingerprint) external;
    function setReferrer(address _referrer) external;
    function getAccountFingerprint(address _account) external returns (bytes32);
    function getReferrer(address _account) external returns (address);
    function getAndValidateReferrer(address _account, IAffiliateValidator affiliateValidator) external returns (address);
    function affiliateValidators(address _affiliateValidator) external returns (bool);
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

contract IDisputeCrowdsourcer is IReportingParticipant, IERC20 {
    function initialize(IAugur _augur, IMarket market, uint256 _size, bytes32 _payoutDistributionHash, uint256[] memory _payoutNumerators, uint256 _crowdsourcerGeneration) public;
    function contribute(address _participant, uint256 _amount, bool _overload) public returns (uint256);
    function setSize(uint256 _size) public;
    function getRemainingToFill() public view returns (uint256);
    function correctSize() public returns (bool);
    function getCrowdsourcerGeneration() public view returns (uint256);
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

contract Augur is IAugur, IAugurCreationDataGetter {
    using SafeMathUint256 for uint256;
    using ContractExists for address;

    enum TokenType {
        ReputationToken,
        DisputeCrowdsourcer,
        ParticipationToken
    }

    event MarketCreated(IUniverse indexed universe, uint256 endTime, string extraInfo, IMarket market, address indexed marketCreator, address designatedReporter, uint256 feePerCashInAttoCash, int256[] prices, IMarket.MarketType marketType, uint256 numTicks, bytes32[] outcomes, uint256 noShowBond, uint256 timestamp);
    event InitialReportSubmitted(address indexed universe, address indexed reporter, address indexed market, address initialReporter, uint256 amountStaked, bool isDesignatedReporter, uint256[] payoutNumerators, string description, uint256 nextWindowStartTime, uint256 nextWindowEndTime, uint256 timestamp);
    event DisputeCrowdsourcerCreated(address indexed universe, address indexed market, address disputeCrowdsourcer, uint256[] payoutNumerators, uint256 size, uint256 disputeRound);
    event DisputeCrowdsourcerContribution(address indexed universe, address indexed reporter, address indexed market, address disputeCrowdsourcer, uint256 amountStaked, string description, uint256[] payoutNumerators, uint256 currentStake, uint256 stakeRemaining, uint256 disputeRound, uint256 timestamp);
    event DisputeCrowdsourcerCompleted(address indexed universe, address indexed market, address disputeCrowdsourcer, uint256[] payoutNumerators, uint256 nextWindowStartTime, uint256 nextWindowEndTime, bool pacingOn, uint256 totalRepStakedInPayout, uint256 totalRepStakedInMarket, uint256 disputeRound, uint256 timestamp);
    event InitialReporterRedeemed(address indexed universe, address indexed reporter, address indexed market, address initialReporter, uint256 amountRedeemed, uint256 repReceived, uint256[] payoutNumerators, uint256 timestamp);
    event DisputeCrowdsourcerRedeemed(address indexed universe, address indexed reporter, address indexed market, address disputeCrowdsourcer, uint256 amountRedeemed, uint256 repReceived, uint256[] payoutNumerators, uint256 timestamp);
    event ReportingParticipantDisavowed(address indexed universe, address indexed market, address reportingParticipant);
    event MarketParticipantsDisavowed(address indexed universe, address indexed market);
    event MarketFinalized(address indexed universe, address indexed market, uint256 timestamp, uint256[] winningPayoutNumerators);
    event MarketMigrated(address indexed market, address indexed originalUniverse, address indexed newUniverse);
    event UniverseForked(address indexed universe, IMarket forkingMarket);
    event UniverseCreated(address indexed parentUniverse, address indexed childUniverse, uint256[] payoutNumerators, uint256 creationTimestamp);
    event CompleteSetsPurchased(address indexed universe, address indexed market, address indexed account, uint256 numCompleteSets, uint256 timestamp);
    event CompleteSetsSold(address indexed universe, address indexed market, address indexed account, uint256 numCompleteSets, uint256 fees, uint256 timestamp);
    event TradingProceedsClaimed(address indexed universe, address indexed sender, address market, uint256 outcome, uint256 numShares, uint256 numPayoutTokens, uint256 fees, uint256 timestamp);
    event TokensTransferred(address indexed universe, address token, address indexed from, address indexed to, uint256 value, TokenType tokenType, address market);
    event TokensMinted(address indexed universe, address indexed token, address indexed target, uint256 amount, TokenType tokenType, address market, uint256 totalSupply);
    event TokensBurned(address indexed universe, address indexed token, address indexed target, uint256 amount, TokenType tokenType, address market, uint256 totalSupply);
    event TokenBalanceChanged(address indexed universe, address indexed owner, address token, TokenType tokenType, address market, uint256 balance, uint256 outcome);
    event DisputeWindowCreated(address indexed universe, address disputeWindow, uint256 startTime, uint256 endTime, uint256 id, bool initial);
    event InitialReporterTransferred(address indexed universe, address indexed market, address from, address to);
    event MarketTransferred(address indexed universe, address indexed market, address from, address to);
    event MarketOIChanged(address indexed universe, address indexed market, uint256 marketOI);
    event ParticipationTokensRedeemed(address indexed universe, address indexed disputeWindow, address indexed account, uint256 attoParticipationTokens, uint256 feePayoutShare, uint256 timestamp);
    event TimestampSet(uint256 newTimestamp);
    event ValidityBondChanged(address indexed universe, uint256 validityBond);
    event DesignatedReportStakeChanged(address indexed universe, uint256 designatedReportStake);
    event NoShowBondChanged(address indexed universe, uint256 noShowBond);
    event ReportingFeeChanged(address indexed universe, uint256 reportingFee);
    event ShareTokenBalanceChanged(address indexed universe, address indexed account, address indexed market, uint256 outcome, uint256 balance);
    event MarketRepBondTransferred(address indexed universe, address market, address from, address to);
    event WarpSyncDataUpdated(address indexed universe, uint256 warpSyncHash, uint256 marketEndTime);

    event RegisterContract(address contractAddress, bytes32 key);
    event FinishDeployment();

    mapping(address => bool) private markets;
    mapping(address => bool) private universes;
    mapping(address => bool) private crowdsourcers;
    mapping(address => bool) private trustedSender;

    mapping(address => MarketCreationData) private marketCreationData;

    address public uploader;
    mapping(bytes32 => address) private registry;

    ITime public time;
    IUniverse public genesisUniverse;

    uint256 public forkCounter;
    mapping (address => uint256) universeForkIndex;

    uint256 public upgradeTimestamp = Reporting.getInitialUpgradeTimestamp();

    int256 private constant DEFAULT_MIN_PRICE = 0;
    int256 private constant DEFAULT_MAX_PRICE = 1 ether;

    uint256 constant public TRADE_INTERVAL_VALUE = 10 ** 19; // Trade value of 10 DAI
    uint256 constant public MIN_TRADE_INTERVAL = 10**14; // We ignore "dust" portions of the min interval and for huge scalars have a larger min value
    uint256 constant public DEFAULT_RECOMMENDED_TRADE_INTERVAL = 10**17;
    uint256 private constant MAX_NUM_TICKS = 2 ** 256 - 2;

    ICash public cash;

    modifier onlyUploader() {
        require(msg.sender == uploader);
        _;
    }

    constructor() public {
        uploader = msg.sender;
    }

    //
    // Registry
    //

    function registerContract(bytes32 _key, address _address) public onlyUploader returns (bool) {
        require(registry[_key] == address(0), "Augur.registerContract: key has already been used in registry");
        require(_address.exists());
        registry[_key] = _address;
        if (_key == "ShareToken" || _key == "MarketFactory" || _key == "EthExchange") {
            trustedSender[_address] = true;
        } else if (_key == "Time") {
            time = ITime(_address);
        } else if (_key == "Cash") {
            cash = ICash(_address);
        }
        emit RegisterContract(_address, _key);
        return true;
    }

    /**
     * @notice Find the contract address for a particular key
     * @param _key The key to lookup
     * @return the address of the registered contract if one exists for the given key
     */
    function lookup(bytes32 _key) public view returns (address) {
        return registry[_key];
    }

    function finishDeployment() public onlyUploader returns (bool) {
        uploader = address(1);
        emit FinishDeployment();
        return true;
    }

    //
    // Universe
    //

    function createGenesisUniverse() public onlyUploader returns (IUniverse) {
        require(genesisUniverse == IUniverse(0));
        genesisUniverse = createUniverse(IUniverse(0), bytes32(0), new uint256[](0));
        return genesisUniverse;
    }

    function createChildUniverse(bytes32 _parentPayoutDistributionHash, uint256[] memory _parentPayoutNumerators) public returns (IUniverse) {
        IUniverse _parentUniverse = getAndValidateUniverse(msg.sender);
        return createUniverse(_parentUniverse, _parentPayoutDistributionHash, _parentPayoutNumerators);
    }

    function createUniverse(IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash, uint256[] memory _parentPayoutNumerators) private returns (IUniverse) {
        IUniverseFactory _universeFactory = IUniverseFactory(registry["UniverseFactory"]);
        IUniverse _newUniverse = _universeFactory.createUniverse(_parentUniverse, _parentPayoutDistributionHash, _parentPayoutNumerators);
        universes[address(_newUniverse)] = true;
        trustedSender[address(_newUniverse)] = true;
        emit UniverseCreated(address(_parentUniverse), address(_newUniverse), _parentPayoutNumerators, getTimestamp());
        return _newUniverse;
    }

    function isKnownUniverse(IUniverse _universe) public view returns (bool) {
        return universes[address(_universe)];
    }

    function getUniverseForkIndex(IUniverse _universe) public view returns (uint256) {
        return universeForkIndex[address(_universe)];
    }

    //
    // Crowdsourcers
    //

    function isKnownCrowdsourcer(IDisputeCrowdsourcer _crowdsourcer) public view returns (bool) {
        return crowdsourcers[address(_crowdsourcer)];
    }

    function disputeCrowdsourcerCreated(IUniverse _universe, address _market, address _disputeCrowdsourcer, uint256[] memory _payoutNumerators, uint256 _size, uint256 _disputeRound) public returns (bool) {
        require(isKnownUniverse(_universe));
        require(_universe.isContainerForMarket(IMarket(msg.sender)));
        crowdsourcers[_disputeCrowdsourcer] = true;
        emit DisputeCrowdsourcerCreated(address(_universe), _market, _disputeCrowdsourcer, _payoutNumerators, _size, _disputeRound);
        return true;
    }

    function isKnownFeeSender(address _feeSender) public view returns (bool) {
        return _feeSender == registry["ShareToken"] || markets[_feeSender];
    }

    //
    // Transfer
    //

    function trustedCashTransfer(address _from, address _to, uint256 _amount) public returns (bool) {
        require(trustedSender[msg.sender]);
        require(cash.transferFrom(_from, _to, _amount));
        return true;
    }

    function isTrustedSender(address _address) public returns (bool) {
        return trustedSender[_address];
    }

    //
    // Time
    //

    /// @notice Returns Augur’s internal Unix timestamp.
    /// @return (uint256) Augur’s internal Unix timestamp
    function getTimestamp() public view returns (uint256) {
        return time.getTimestamp();
    }

    //
    // Markets
    //

    function isKnownMarket(IMarket _market) public view returns (bool) {
        return markets[address(_market)];
    }

    function getMaximumMarketEndDate() public returns (uint256) {
        uint256 _now = getTimestamp();
        while (_now > upgradeTimestamp) {
            upgradeTimestamp = upgradeTimestamp.add(Reporting.getUpgradeCadence());
        }
        uint256 _upgradeCadenceDurationEndTime = upgradeTimestamp;
        uint256 _baseDurationEndTime = _now + Reporting.getBaseMarketDurationMaximum();
        return _baseDurationEndTime.max(_upgradeCadenceDurationEndTime);
    }

    function derivePayoutDistributionHash(uint256[] memory _payoutNumerators, uint256 _numTicks, uint256 _numOutcomes) public view returns (bytes32) {
        uint256 _sum = 0;
        // This is to force an Invalid report to be entirely payed out to Invalid
        require(_payoutNumerators[0] == 0 || _payoutNumerators[0] == _numTicks);
        require(_payoutNumerators.length == _numOutcomes, "Augur.derivePayoutDistributionHash: Malformed payout length");
        for (uint256 i = 0; i < _payoutNumerators.length; i++) {
            uint256 _value = _payoutNumerators[i];
            _sum = _sum.add(_value);
        }
        require(_sum == _numTicks, "Augur.derivePayoutDistributionHash: Malformed payout sum");
        return keccak256(abi.encodePacked(_payoutNumerators));
    }

    function getMarketCreationData(IMarket _market) public view returns (MarketCreationData memory) {
        return marketCreationData[address(_market)];
    }

    function getMarketType(IMarket _market) public view returns (IMarket.MarketType _marketType) {
        return marketCreationData[address(_market)].marketType;
    }

    function getMarketOutcomes(IMarket _market) public view returns (bytes32[] memory _outcomes) {
        return marketCreationData[address(_market)].outcomes;
    }

    function getMarketRecommendedTradeInterval(IMarket _market) public view returns (uint256) {
        return marketCreationData[address(_market)].recommendedTradeInterval;
    }

    //
    // Logging
    //

    function onCategoricalMarketCreated(uint256 _endTime, string memory _extraInfo, IMarket _market, address _marketCreator, address _designatedReporter, uint256 _feePerCashInAttoCash, bytes32[] memory _outcomes) public returns (bool) {
        IUniverse _universe = getAndValidateUniverse(msg.sender);
        markets[address(_market)] = true;
        int256[] memory _prices = new int256[](2);
        _prices[0] = DEFAULT_MIN_PRICE;
        _prices[1] = DEFAULT_MAX_PRICE;
        marketCreationData[address(_market)].extraInfo = _extraInfo;
        marketCreationData[address(_market)].marketCreator = _marketCreator;
        marketCreationData[address(_market)].outcomes = _outcomes;
        marketCreationData[address(_market)].marketType = IMarket.MarketType.CATEGORICAL;
        marketCreationData[address(_market)].recommendedTradeInterval = DEFAULT_RECOMMENDED_TRADE_INTERVAL;
        emit MarketCreated(_universe, _endTime, _extraInfo, _market, _marketCreator, _designatedReporter, _feePerCashInAttoCash, _prices, IMarket.MarketType.CATEGORICAL, 100, _outcomes, _universe.getOrCacheMarketRepBond(), getTimestamp());
        return true;
    }

    function onYesNoMarketCreated(uint256 _endTime, string memory _extraInfo, IMarket _market, address _marketCreator, address _designatedReporter, uint256 _feePerCashInAttoCash) public returns (bool) {
        IUniverse _universe = getAndValidateUniverse(msg.sender);
        markets[address(_market)] = true;
        int256[] memory _prices = new int256[](2);
        _prices[0] = DEFAULT_MIN_PRICE;
        _prices[1] = DEFAULT_MAX_PRICE;
        marketCreationData[address(_market)].extraInfo = _extraInfo;
        marketCreationData[address(_market)].marketCreator = _marketCreator;
        marketCreationData[address(_market)].marketType = IMarket.MarketType.YES_NO;
        marketCreationData[address(_market)].recommendedTradeInterval = DEFAULT_RECOMMENDED_TRADE_INTERVAL;
        emit MarketCreated(_universe, _endTime, _extraInfo, _market, _marketCreator, _designatedReporter, _feePerCashInAttoCash, _prices, IMarket.MarketType.YES_NO, 100, new bytes32[](0), _universe.getOrCacheMarketRepBond(), getTimestamp());
        return true;
    }

    function onScalarMarketCreated(uint256 _endTime, string memory _extraInfo, IMarket _market, address _marketCreator, address _designatedReporter, uint256 _feePerCashInAttoCash, int256[] memory _prices, uint256 _numTicks)  public returns (bool) {
        IUniverse _universe = getAndValidateUniverse(msg.sender);
        require(_prices.length == 2);
        require(_prices[0] < _prices[1]);
        uint256 _priceRange = uint256(_prices[1] - _prices[0]);
        require(_priceRange > _numTicks);
        markets[address(_market)] = true;
        marketCreationData[address(_market)].extraInfo = _extraInfo;
        marketCreationData[address(_market)].marketCreator = _marketCreator;
        marketCreationData[address(_market)].displayPrices = _prices;
        marketCreationData[address(_market)].marketType = IMarket.MarketType.SCALAR;
        marketCreationData[address(_market)].recommendedTradeInterval = getTradeInterval(_priceRange, _numTicks);
        emit MarketCreated(_universe, _endTime, _extraInfo, _market, _marketCreator, _designatedReporter, _feePerCashInAttoCash, _prices, IMarket.MarketType.SCALAR, _numTicks, new bytes32[](0), _universe.getOrCacheMarketRepBond(), getTimestamp());
        return true;
    }

    function getTradeInterval(uint256 _displayRange, uint256 _numTicks) public pure returns (uint256) {
        // Handle Warp Sync Market
        if (_numTicks == MAX_NUM_TICKS) {
            return MIN_TRADE_INTERVAL;
        }
        uint256 _displayAmount = TRADE_INTERVAL_VALUE.mul(10**18).div(_displayRange);
        uint256 _displayInterval = MIN_TRADE_INTERVAL;
        while (_displayInterval < _displayAmount) {
            _displayInterval = _displayInterval.mul(10);
        }
        _displayAmount = _displayInterval;
        return _displayInterval.mul(_displayRange).div(_numTicks).div(10**18);
    }

    function logInitialReportSubmitted(IUniverse _universe, address _reporter, address _market, address _initialReporter, uint256 _amountStaked, bool _isDesignatedReporter, uint256[] memory _payoutNumerators, string memory _description, uint256 _nextWindowStartTime, uint256 _nextWindowEndTime) public returns (bool) {
        require(isKnownUniverse(_universe));
        require(_universe.isContainerForMarket(IMarket(msg.sender)));
        emit InitialReportSubmitted(address(_universe), _reporter, _market, _initialReporter, _amountStaked, _isDesignatedReporter, _payoutNumerators, _description, _nextWindowStartTime, _nextWindowEndTime, getTimestamp());
        return true;
    }

    function logDisputeCrowdsourcerContribution(IUniverse _universe, address _reporter, address _market, address _disputeCrowdsourcer, uint256 _amountStaked, string memory _description, uint256[] memory _payoutNumerators, uint256 _currentStake, uint256 _stakeRemaining, uint256 _disputeRound) public returns (bool) {
        require(isKnownUniverse(_universe));
        require(_universe.isContainerForMarket(IMarket(msg.sender)));
        emit DisputeCrowdsourcerContribution(address(_universe), _reporter, _market, _disputeCrowdsourcer, _amountStaked, _description, _payoutNumerators, _currentStake, _stakeRemaining, _disputeRound, getTimestamp());
        return true;
    }

    function logDisputeCrowdsourcerCompleted(IUniverse _universe, address _market, address _disputeCrowdsourcer, uint256[] memory _payoutNumerators, uint256 _nextWindowStartTime, uint256 _nextWindowEndTime, bool _pacingOn, uint256 _totalRepStakedInPayout, uint256 _totalRepStakedInMarket, uint256 _disputeRound) public returns (bool) {
        require(isKnownUniverse(_universe));
        require(_universe.isContainerForMarket(IMarket(msg.sender)));
        emit DisputeCrowdsourcerCompleted(address(_universe), _market, _disputeCrowdsourcer, _payoutNumerators, _nextWindowStartTime, _nextWindowEndTime, _pacingOn, _totalRepStakedInPayout, _totalRepStakedInMarket, _disputeRound, getTimestamp());
        return true;
    }

    function logInitialReporterRedeemed(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256[] memory _payoutNumerators) public returns (bool) {
        require(isKnownUniverse(_universe));
        require(_universe.isContainerForReportingParticipant(IReportingParticipant(msg.sender)));
        emit InitialReporterRedeemed(address(_universe), _reporter, _market, msg.sender, _amountRedeemed, _repReceived, _payoutNumerators, getTimestamp());
        return true;
    }

    function logDisputeCrowdsourcerRedeemed(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256[] memory _payoutNumerators) public returns (bool) {
        IDisputeCrowdsourcer _disputeCrowdsourcer = IDisputeCrowdsourcer(msg.sender);
        require(isKnownCrowdsourcer(_disputeCrowdsourcer));
        emit DisputeCrowdsourcerRedeemed(address(_universe), _reporter, _market, address(_disputeCrowdsourcer), _amountRedeemed, _repReceived, _payoutNumerators, getTimestamp());
        return true;
    }

    function logReportingParticipantDisavowed(IUniverse _universe, IMarket _market) public returns (bool) {
        require(isKnownUniverse(_universe));
        require(_universe.isContainerForReportingParticipant(IReportingParticipant(msg.sender)));
        emit ReportingParticipantDisavowed(address(_universe), address(_market), msg.sender);
        return true;
    }

    function logMarketParticipantsDisavowed(IUniverse _universe) public returns (bool) {
        require(isKnownUniverse(_universe));
        IMarket _market = IMarket(msg.sender);
        require(_universe.isContainerForMarket(_market));
        emit MarketParticipantsDisavowed(address(_universe), address(_market));
        return true;
    }

    function logMarketFinalized(IUniverse _universe, uint256[] memory _winningPayoutNumerators) public returns (bool) {
        require(isKnownUniverse(_universe));
        IMarket _market = IMarket(msg.sender);
        require(_universe.isContainerForMarket(_market));
        emit MarketFinalized(address(_universe), address(_market), getTimestamp(), _winningPayoutNumerators);
        return true;
    }

    function logMarketMigrated(IMarket _market, IUniverse _originalUniverse) public returns (bool) {
        IUniverse _newUniverse = IUniverse(msg.sender);
        require(isKnownUniverse(_newUniverse));
        emit MarketMigrated(address(_market), address(_originalUniverse), address(_newUniverse));
        return true;
    }

    function logCompleteSetsPurchased(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets) public returns (bool) {
        require(msg.sender == registry["ShareToken"] || (isKnownUniverse(_universe) && _universe.isOpenInterestCash(msg.sender)));
        emit CompleteSetsPurchased(address(_universe), address(_market), _account, _numCompleteSets, getTimestamp());
        return true;
    }

    function logCompleteSetsSold(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets, uint256 _fees) public returns (bool) {
        require(msg.sender == registry["ShareToken"]);
        emit CompleteSetsSold(address(_universe), address(_market), _account, _numCompleteSets, _fees, getTimestamp());
        return true;
    }

    function logMarketOIChanged(IUniverse _universe, IMarket _market) public returns (bool) {
        require(msg.sender == registry["ShareToken"]);
        emit MarketOIChanged(address(_universe), address(_market), _market.getOpenInterest());
        return true;
    }

    function logTradingProceedsClaimed(IUniverse _universe, address _sender, address _market, uint256 _outcome, uint256 _numShares, uint256 _numPayoutTokens, uint256 _fees) public returns (bool) {
        require(msg.sender == registry["ShareToken"]);
        emit TradingProceedsClaimed(address(_universe), _sender, _market, _outcome, _numShares, _numPayoutTokens, _fees, getTimestamp());
        return true;
    }

    function logUniverseForked(IMarket _forkingMarket) public returns (bool) {
        require(isKnownUniverse(IUniverse(msg.sender)));
        forkCounter += 1;
        universeForkIndex[msg.sender] = forkCounter;
        emit UniverseForked(msg.sender, _forkingMarket);
        return true;
    }

    function logReputationTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value, uint256 _fromBalance, uint256 _toBalance) public returns (bool) {
        require(isKnownUniverse(_universe));
        require(_universe.getReputationToken() == IReputationToken(msg.sender));
        logTokensTransferred(address(_universe), msg.sender, _from, _to, _value, TokenType.ReputationToken, address(0), _fromBalance, _toBalance, 0);
        return true;
    }

    function logDisputeCrowdsourcerTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value, uint256 _fromBalance, uint256 _toBalance) public returns (bool) {
        IDisputeCrowdsourcer _disputeCrowdsourcer = IDisputeCrowdsourcer(msg.sender);
        require(isKnownCrowdsourcer(_disputeCrowdsourcer));
        logTokensTransferred(address(_universe), msg.sender, _from, _to, _value, TokenType.DisputeCrowdsourcer, address(_disputeCrowdsourcer.getMarket()), _fromBalance, _toBalance, 0);
        return true;
    }

    function logReputationTokensBurned(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool) {
        require(isKnownUniverse(_universe));
        require(_universe.getReputationToken() == IReputationToken(msg.sender));
        logTokensBurned(address(_universe), msg.sender, _target, _amount, TokenType.ReputationToken, address(0), _totalSupply, _balance, 0);
        return true;
    }

    function logReputationTokensMinted(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool) {
        require(isKnownUniverse(_universe));
        require(_universe.getReputationToken() == IReputationToken(msg.sender));
        logTokensMinted(address(_universe), msg.sender, _target, _amount, TokenType.ReputationToken, address(0), _totalSupply, _balance, 0);
        return true;
    }

    function logShareTokensBalanceChanged(address _account, IMarket _market, uint256 _outcome, uint256 _balance) public returns (bool) {
        require(msg.sender == registry["ShareToken"]);
        emit ShareTokenBalanceChanged(address(_market.getUniverse()), _account, address(_market), _outcome, _balance);
        return true;
    }

    function logDisputeCrowdsourcerTokensBurned(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool) {
        IDisputeCrowdsourcer _disputeCrowdsourcer = IDisputeCrowdsourcer(msg.sender);
        require(isKnownCrowdsourcer(_disputeCrowdsourcer));
        logTokensBurned(address(_universe), msg.sender, _target, _amount, TokenType.DisputeCrowdsourcer, address(_disputeCrowdsourcer.getMarket()), _totalSupply, _balance, 0);
        return true;
    }

    function logDisputeCrowdsourcerTokensMinted(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool) {
        IDisputeCrowdsourcer _disputeCrowdsourcer = IDisputeCrowdsourcer(msg.sender);
        require(isKnownCrowdsourcer(_disputeCrowdsourcer));
        logTokensMinted(address(_universe), msg.sender, _target, _amount, TokenType.DisputeCrowdsourcer, address(_disputeCrowdsourcer.getMarket()), _totalSupply, _balance, 0);
        return true;
    }

    function logDisputeWindowCreated(IDisputeWindow _disputeWindow, uint256 _id, bool _initial) public returns (bool) {
        require(isKnownUniverse(IUniverse(msg.sender)));
        emit DisputeWindowCreated(msg.sender, address(_disputeWindow), _disputeWindow.getStartTime(), _disputeWindow.getEndTime(), _id, _initial);
        return true;
    }

    function logParticipationTokensRedeemed(IUniverse _universe, address _account, uint256 _attoParticipationTokens, uint256 _feePayoutShare) public returns (bool) {
        require(isKnownUniverse(_universe));
        require(_universe.isContainerForDisputeWindow(IDisputeWindow(msg.sender)));
        emit ParticipationTokensRedeemed(address(_universe), msg.sender, _account, _attoParticipationTokens, _feePayoutShare, getTimestamp());
        return true;
    }

    function logTimestampSet(uint256 _newTimestamp) public returns (bool) {
        require(msg.sender == registry["Time"]);
        emit TimestampSet(_newTimestamp);
        return true;
    }

    function logInitialReporterTransferred(IUniverse _universe, IMarket _market, address _from, address _to) public returns (bool) {
        require(isKnownUniverse(_universe));
        require(_universe.isContainerForMarket(_market));
        require(msg.sender == address(_market.getInitialReporter()));
        emit InitialReporterTransferred(address(_universe), address(_market), _from, _to);
        return true;
    }

    function logMarketTransferred(IUniverse _universe, address _from, address _to) public returns (bool) {
        require(isKnownUniverse(_universe));
        IMarket _market = IMarket(msg.sender);
        require(_universe.isContainerForMarket(_market));
        emit MarketTransferred(address(_universe), address(_market), _from, _to);
        return true;
    }

    function logParticipationTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value, uint256 _fromBalance, uint256 _toBalance) public returns (bool) {
        require(isKnownUniverse(_universe));
        require(_universe.isContainerForDisputeWindow(IDisputeWindow(msg.sender)));
        logTokensTransferred(address(_universe), msg.sender, _from, _to, _value, TokenType.ParticipationToken, address(0), _fromBalance, _toBalance, 0);
        return true;
    }

    function logParticipationTokensBurned(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool) {
        require(isKnownUniverse(_universe));
        require(_universe.isContainerForDisputeWindow(IDisputeWindow(msg.sender)));
        logTokensBurned(address(_universe), msg.sender, _target, _amount, TokenType.ParticipationToken, address(0), _totalSupply, _balance, 0);
        return true;
    }

    function logParticipationTokensMinted(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool) {
        require(isKnownUniverse(_universe));
        require(_universe.isContainerForDisputeWindow(IDisputeWindow(msg.sender)));
        logTokensMinted(address(_universe), msg.sender, _target, _amount, TokenType.ParticipationToken, address(0), _totalSupply, _balance, 0);
        return true;
    }

    function logTokensTransferred(address _universe, address _token, address _from, address _to, uint256 _amount, TokenType _tokenType, address _market, uint256 _fromBalance, uint256 _toBalance, uint256 _outcome) private returns (bool) {
        emit TokensTransferred(_universe, _token, _from, _to, _amount, _tokenType, _market);
        emit TokenBalanceChanged(_universe, _from, _token, _tokenType, _market, _fromBalance, _outcome);
        emit TokenBalanceChanged(_universe, _to, _token, _tokenType, _market, _toBalance, _outcome);
        return true;
    }

    function logTokensBurned(address _universe, address _token, address _target, uint256 _amount, TokenType _tokenType, address _market, uint256 _totalSupply, uint256 _balance, uint256 _outcome) private returns (bool) {
        emit TokensBurned(_universe, _token, _target, _amount, _tokenType, _market, _totalSupply);
        emit TokenBalanceChanged(_universe, _target, _token, _tokenType, _market, _balance, _outcome);
        return true;
    }

    function logTokensMinted(address _universe, address _token, address _target, uint256 _amount, TokenType _tokenType, address _market, uint256 _totalSupply, uint256 _balance, uint256 _outcome) private returns (bool) {
        emit TokensMinted(_universe, _token, _target, _amount, _tokenType, _market, _totalSupply);
        emit TokenBalanceChanged(_universe, _target, _token, _tokenType, _market, _balance, _outcome);
        return true;
    }

    function logValidityBondChanged(uint256 _validityBond) public returns (bool) {
        IUniverse _universe = getAndValidateUniverse(msg.sender);
        emit ValidityBondChanged(address(_universe), _validityBond);
        return true;
    }

    function logDesignatedReportStakeChanged(uint256 _designatedReportStake) public returns (bool) {
        IUniverse _universe = getAndValidateUniverse(msg.sender);
        emit DesignatedReportStakeChanged(address(_universe), _designatedReportStake);
        return true;
    }

    function logNoShowBondChanged(uint256 _noShowBond) public returns (bool) {
        IUniverse _universe = getAndValidateUniverse(msg.sender);
        emit NoShowBondChanged(address(_universe), _noShowBond);
        return true;
    }

    function logReportingFeeChanged(uint256 _reportingFee) public returns (bool) {
        IUniverse _universe = getAndValidateUniverse(msg.sender);
        emit ReportingFeeChanged(address(_universe), _reportingFee);
        return true;
    }

    function logMarketRepBondTransferred(address _universe, address _from, address _to) public returns (bool) {
        require(isKnownMarket(IMarket(msg.sender)));
        emit MarketRepBondTransferred(_universe, msg.sender, _from, _to);
    }

    function logWarpSyncDataUpdated(address _universe, uint256 _warpSyncHash, uint256 _marketEndTime) public returns (bool) {
        require(msg.sender == registry["WarpSync"]);
        emit WarpSyncDataUpdated(_universe, _warpSyncHash, _marketEndTime);
    }

    function getAndValidateUniverse(address _untrustedUniverse) internal view returns (IUniverse) {
        IUniverse _universe = IUniverse(_untrustedUniverse);
        require(isKnownUniverse(_universe));
        return _universe;
    }
}