/**
 *Submitted for verification at Etherscan.io on 2020-06-18
*/

pragma solidity 0.4.26;

/// @title uniquely identifies deployable (non-abstract) platform contract
/// @notice cheap way of assigning implementations to knownInterfaces which represent system services
///         unfortunatelly ERC165 does not include full public interface (ABI) and does not provide way to list implemented interfaces
///         EIP820 still in the making
/// @dev ids are generated as follows keccak256("neufund-platform:<contract name>")
///      ids roughly correspond to ABIs
contract IContractId {
    /// @param id defined as above
    /// @param version implementation version
    function contractId() public pure returns (bytes32 id, uint256 version);
}

/// @title access to snapshots of a token
/// @notice allows to implement complex token holder rights like revenue disbursal or voting
/// @notice snapshots are series of values with assigned ids. ids increase strictly. particular id mechanism is not assumed
contract ITokenSnapshots {

    ////////////////////////
    // Public functions
    ////////////////////////

    /// @notice Total amount of tokens at a specific `snapshotId`.
    /// @param snapshotId of snapshot at which totalSupply is queried
    /// @return The total amount of tokens at `snapshotId`
    /// @dev reverts on snapshotIds greater than currentSnapshotId()
    /// @dev returns 0 for snapshotIds less than snapshotId of first value
    function totalSupplyAt(uint256 snapshotId)
        public
        constant
        returns(uint256);

    /// @dev Queries the balance of `owner` at a specific `snapshotId`
    /// @param owner The address from which the balance will be retrieved
    /// @param snapshotId of snapshot at which the balance is queried
    /// @return The balance at `snapshotId`
    function balanceOfAt(address owner, uint256 snapshotId)
        public
        constant
        returns (uint256);

    /// @notice upper bound of series of snapshotIds for which there's a value in series
    /// @return snapshotId
    function currentSnapshotId()
        public
        constant
        returns (uint256);
}

// standard methods of VotingCenter contract that governs voting procedures on the whole platform
contract IVotingCenter is IContractId {

    /// @dev Creates a proposal, uniquely identifiable by its assigned proposalId
    /// @param proposalId unique identifier of the proposal, e.g. ipfs-hash of info
    /// @param token a token where balances give voting power to holders
    /// @param campaignDuration duration (s) in which proposal has to gather enough votes to be made public (see campaignQuorum)
    /// @param campaignQuorumFraction fraction (10**18 = 1) of token holders who have to support a proposal in order for it to be trigger an event
    /// @param votingPeriod total duration (s) in which the proposal can be voted on by tokenholders after it was created
    /// @param votingLegalRep a legal representative for the vote, which may provide off-chain voting results
    /// @param offchainVotePeriod duration (s) after voting is ended when voting legal rep may provide results
    /// @param totalVotingPower combined voting power of on-chain (token total supply) and held off-chain (ie. shares) expressed in tokens
    /// @param action initiator defined action code on which voting happens
    /// @param actionPayload initiator defined action payload on which voting happens
    function addProposal(
        bytes32 proposalId,
        ITokenSnapshots token,
        uint32 campaignDuration,
        uint256 campaignQuorumFraction,
        uint32 votingPeriod,
        address votingLegalRep,
        uint32 offchainVotePeriod,
        uint256 totalVotingPower,
        uint256 action,
        bytes actionPayload,
        bool enableObserver
    )
        public;

    /// @dev increase the voting power on a given proposal by the token balance of the sender
    ///   throws if proposal does not exist or the vote on it has ended already. Votes are final,
    ///   changing the vote is not allowed
    /// @dev reverts if proposal does not exist
    /// @param proposalId of the proposal to be voted on
    /// @param voteInFavor if true, voting power goes for proposal, if false - against
    function vote(bytes32 proposalId, bool voteInFavor)
        public;

    /// @notice add off-chain votes, inFavor + against may not cross the offchainVotingPower, but may be less
    ///         to reflect abstaining from vote
    /// @param inFavor voting power (expressed in tokens) being in favor of the proposal
    /// @param against voting power (expressed in tokens) being against the proposal
    /// @param documentUri official document with final voting results
    function addOffchainVote(bytes32 proposalId, uint256 inFavor, uint256 against, string documentUri)
        public;


    /// @notice Returns the current tally of a proposal. Only Final proposal have immutable tally
    /// @return the voting power on a finished proposal and the total voting power
    /// @dev please again note that VotingCenter does not say if voting passed in favor or against. it just carries on
    ///      the voting and it's up to initiator to say what is the outcome, see IProposalObserver
    function tally(bytes32 proposalId)
        public
        constant
        returns(
            uint8 s,
            uint256 inFavor,
            uint256 against,
            uint256 offchainInFavor,
            uint256 offchainAgainst,
            uint256 tokenVotingPower,
            uint256 totalVotingPower,
            uint256 campaignQuorumTokenAmount,
            address initiator,
            bool hasObserverInterface
        );

    /// @notice returns official document with off-chain vote result/statement
    /// @dev meaningful only in final state
    function offchainVoteDocumentUri(bytes32 proposalId)
        public
        constant
        returns (string);

    /// @notice obtains proposal after internal state is updated due to time
    /// @dev    this is the getter you should use
    /// @dev reverts if proposal does not exist
    function timedProposal(bytes32 proposalId)
        public
        constant
        returns (
            uint8 s,
            address token,
            uint256 snapshotId,
            address initiator,
            address votingLegalRep,
            uint256 campaignQuorumTokenAmount,
            uint256 offchainVotingPower,
            uint256 action,
            bytes actionPayload,
            bool enableObserver,
            uint32[5] deadlines
        );

    /// @notice obtains proposal state without time transitions
    /// @dev    used mostly to detect propositions requiring timed transitions
    /// @dev reverts if proposal does not exist
    function proposal(bytes32 proposalId)
        public
        constant
        returns (
            uint8 s,
            address token,
            uint256 snapshotId,
            address initiator,
            address votingLegalRep,
            uint256 campaignQuorumTokenAmount,
            uint256 offchainVotingPower,
            uint256 action,
            bytes actionPayload,
            bool enableObserver,
            uint32[5] deadlines
        );

    /// @notice tells if voter cast a for/against vote or abstained
    /// @dev reverts if proposal does not exist
    /// @return see TriState in VotingProposal
    function getVote(bytes32 proposalId, address voter)
        public
        constant
        returns (uint8);

    /// @notice tells if proposal with given id was opened
    function hasProposal(bytes32 proposalId)
        public
        constant
        returns (bool);

    /// @notice returns voting power for given proposal / voter
    /// @dev voters with zero voting power cannot participate in voting
    function getVotingPower(bytes32 proposalId, address voter)
        public
        constant
        returns (uint256);
}

contract IVotingController is IContractId {
    // token must be NEU or equity token
    // if initiator is not equity token then proposals start in campaign mode
    // if token is NEU then default values must apply
    function onAddProposal(bytes32 proposalId, address initiator, address token)
        public
        constant
        returns (bool);

    /// @notice check wether the disbursal controller may be changed
    function onChangeVotingController(address sender, IVotingController newController)
        public
        constant
        returns (bool);
}

library Math {
    ////////////////////////
    // Internal functions
    ////////////////////////

    // absolute difference: |v1 - v2|
    function absDiff(uint256 v1, uint256 v2)
        internal
        pure
        returns(uint256)
    {
        return v1 > v2 ? v1 - v2 : v2 - v1;
    }

    // divide v by d, round up if remainder is 0.5 or more
    function divRound(uint256 v, uint256 d)
        internal
        pure
        returns(uint256)
    {
        return add(v, d/2) / d;
    }

    // computes decimal decimalFraction 'frac' of 'amount' with maximum precision (multiplication first)
    // both amount and decimalFraction must have 18 decimals precision, frac 10**18 represents a whole (100% of) amount
    // mind loss of precision as decimal fractions do not have finite binary expansion
    // do not use instead of division
    function decimalFraction(uint256 amount, uint256 frac)
        internal
        pure
        returns(uint256)
    {
        // it's like 1 ether is 100% proportion
        return proportion(amount, frac, 10**18);
    }

    // computes part/total of amount with maximum precision (multiplication first)
    // part and total must have the same units
    function proportion(uint256 amount, uint256 part, uint256 total)
        internal
        pure
        returns(uint256)
    {
        return divRound(mul(amount, part), total);
    }

    //
    // Open Zeppelin Math library below
    //

    function mul(uint256 a, uint256 b)
        internal
        pure
        returns (uint256)
    {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function sub(uint256 a, uint256 b)
        internal
        pure
        returns (uint256)
    {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b)
        internal
        pure
        returns (uint256)
    {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function min(uint256 a, uint256 b)
        internal
        pure
        returns (uint256)
    {
        return a < b ? a : b;
    }

    function max(uint256 a, uint256 b)
        internal
        pure
        returns (uint256)
    {
        return a > b ? a : b;
    }
}

/// @notice should be implemented by all contracts that initate the voting center procedure
///         must be implemented by all contracts that initate voting procedure AND request observer callbacks
contract IVotingObserver {
    /// @notice if requested, voting center will pass state transitions of proposal to observer
    /// @dev refer to VotingProposal for state variable values
    function onProposalStateTransition(
        bytes32 proposalId,
        uint8 oldState,
        uint8 newState)
        public;

    /// @notice only observer may tell if vote was in favor or not, voting center only carries on voting procedure
    ///         example is equity token controller as observer which will count outcome as passed depending on company bylaws
    /// @param votingCenter at which voting center to look for the results
    /// @param proposalId for which proposalId to deliver results
    /// @return true means inFavor, false means agains, revert means that procedure is not yet final or any other problem
    /// @dev please note the revert/false distinction above, do not returns false in case voting is unknown or not yet final
    function votingResult(address votingCenter, bytes32 proposalId)
        public
        constant
        returns (bool inFavor);
}

library VotingProposal {
    ////////////////////////
    // Constants
    ////////////////////////

    uint256 private constant STATES_COUNT = 5;

    ////////////////////////
    // Types
    ////////////////////////

    enum State {
        // Initial state where voting owner can build quorum for public visibility
        Campaigning,
        // has passed campaign-quorum in time, voting publicly announced
        Public,
        // reveal state where meta-transactions are gathered
        Reveal,
        // For votings that have off-chain counterpart, this is the time to upload the tally
        Tally,
        // Vote count will not change and tally is available, terminal state
        Final
    }

    // Łukasiewicz logic values for state of a vote of particular voter
    /// @dev note that Abstain is meaningful only in Final/Tally state
    enum TriState {
        Abstain,
        InFavor,
        Against
    }

    /// @dev note that voting power is always expressed in tokens of the associated snapshot token
    ///     and reflect decimals of the token. voting power of 1 token with 18 decimals is Q18
    struct Proposal {
        // voting power comes from here
        ITokenSnapshots token;
        // balances at this snapshot count
        uint256 snapshotId;
        // on-chain tally
        uint256 inFavor;
        uint256 against;
        // off-chain tally
        uint256 offchainInFavor;
        uint256 offchainAgainst;

        // quorum needed to reach public phase
        uint256 campaignQuorumTokenAmount;

        // off-chain voting power
        uint256 offchainVotingPower;

        // voting initiator
        IVotingObserver initiator;
        // voting legal representative
        address votingLegalRep;

        // proposal action as set by initiator
        uint256 action;
        // on chain proposal action payload
        bytes actionPayload;
        // off-chain official results
        string offchainVoteDocumentUri;

        // when states end, indexed by state, keep it word aligned
        uint32[STATES_COUNT] deadlines;

        // current state of the voting
        State state;

        // observer function requested to owner?
        bool observing;

        // you can vote only once
        mapping (address => TriState) hasVoted;
    }

    /////////////////////////
    // Events
    ////////////////////////

    event LogProposalStateTransition(
        bytes32 indexed proposalId,
        address initiator,
        address votingLegalRep,
        address token,
        State oldState,
        State newState
    );

    /////////////////////////
    // Internal Lib Functions
    ////////////////////////

    function isVotingOpen(VotingProposal.Proposal storage p)
        internal
        constant
        returns (bool)
    {
        return p.state == State.Campaigning || p.state == State.Public;
    }

    function isRelayOpen(VotingProposal.Proposal storage p)
        internal
        constant
        returns (bool)
    {
        return isVotingOpen(p) || p.state == State.Reveal;
    }

    function initialize(
        Proposal storage p,
        bytes32 proposalId,
        ITokenSnapshots token,
        uint256 snapshotId,
        uint32 campaignDuration,
        uint256 campaignQuorumFraction,
        uint32 votingPeriod,
        address votingLegalRep,
        uint32 offchainVotePeriod,
        uint256 totalVotingPower,
        uint256 action,
        bool enableObserver
    )
        internal
    {
        uint256 totalTokenVotes = token.totalSupplyAt(snapshotId);
        require(totalTokenVotes > 0, "NF_VC_EMPTY_TOKEN");
        require(totalVotingPower == 0 || totalVotingPower >= totalTokenVotes, "NF_VC_TOTPOWER_LT_TOKEN");

        // set initial deadlines
        uint32[STATES_COUNT] memory deadlines;
        uint32 t = uint32(now);
        deadlines[0] = t;
        deadlines[1] = t + campaignDuration;
        // no reveal now
        deadlines[2] = deadlines[3] = t + votingPeriod;
        // offchain voting deadline
        // if all voting power belongs to token holders then off-chain tally must be skipped
        deadlines[4] = deadlines[3] + (totalVotingPower == totalTokenVotes ? 0 : offchainVotePeriod);

        // can't use struct constructor because it goes through memory
        // p is already allocated storage slot
        p.token = token;
        p.snapshotId = snapshotId;
        p.observing = enableObserver;

        p.votingLegalRep = votingLegalRep;
        p.offchainVotingPower = totalVotingPower > 0 ? Math.sub(totalVotingPower, totalTokenVotes) : 0;

        // campaign must cross total voting power
        p.campaignQuorumTokenAmount = Math.decimalFraction(totalTokenVotes + p.offchainVotingPower, campaignQuorumFraction);
        require(p.campaignQuorumTokenAmount <= totalTokenVotes, "NF_VC_NO_CAMP_VOTING_POWER");

        p.initiator = IVotingObserver(msg.sender);
        p.deadlines = deadlines;
        p.state = State.Campaigning;
        p.action = action;

        // advance campaigning state to public if quorum not specified
        // that will also emit event if such transition happen
        advanceLogicState(p, proposalId);
    }

    // @dev don't use `else if` and keep sorted by time and call `state()`
    //     or else multiple transitions won't cascade properly.
    function advanceTimedState(Proposal storage p, bytes32 proposalId)
        internal
    {
        uint32 t = uint32(now);
        // campaign timeout to final
        if (p.state == State.Campaigning && t >= p.deadlines[uint32(State.Public)]) {
            transitionTo(p, proposalId, State.Final);
        }
        // other states go one by one, terminal state stops
        while(p.state != State.Final && t >= p.deadlines[uint32(p.state) + 1]) {
            transitionTo(p, proposalId, State(uint8(p.state) + 1));
        }
    }

    // @notice transitions due to business logic
    // @dev called after logic
    function advanceLogicState(Proposal storage p, bytes32 proposalId)
        internal
    {
        // State state = p.state;
        // if crossed campaign quorum
        if (p.state == State.Campaigning && p.inFavor + p.against >= p.campaignQuorumTokenAmount) {
            // go to public state
            transitionTo(p, proposalId, State.Public);
        }
        // if off-chain tally done
        if (p.state == State.Tally && p.offchainAgainst + p.offchainInFavor > 0) {
            // finalize
            transitionTo(p, proposalId, State.Final);
        }
    }

    /// @notice executes transition state function
    function transitionTo(Proposal storage p, bytes32 proposalId, State newState)
        private
    {
        State oldState = p.state;
        // get deadline for old state and check the delta for other states
        uint32 delta;
        uint32 deadline = p.deadlines[uint256(oldState) + 1];
        // if transition came before deadline, count time from timestamp, if after always count from deadline
        if (uint32(now) < deadline) {
            delta = deadline - uint32(now);
        }
        if (delta > 0) {
            // shift dealines for other states
            uint32[STATES_COUNT] memory newDeadlines = p.deadlines;
            for (uint256 ii = uint256(oldState) + 1; ii < STATES_COUNT; ii += 1) {
                newDeadlines[ii] -= delta;
            }
            p.deadlines = newDeadlines;
        }
        // write storage
        p.state = newState;

        // do not emit events and observer if campaigning failed
        if (oldState == State.Campaigning && newState == State.Final) {
            return;
        }

        emit LogProposalStateTransition(proposalId, p.initiator, p.votingLegalRep, p.token, oldState, newState);
        if (p.observing) {
            // call observer on best-effort. ignore errors
            bytes4 sel = p.initiator.onProposalStateTransition.selector;
            (address(p.initiator)).call(
                abi.encodeWithSelector(sel, proposalId, oldState, newState)
                );
        }
    }
}

/// Contract to allow voting based on a snapshotable token (with relayed, batched voting)
contract VotingCenter is IVotingCenter {

    using VotingProposal for VotingProposal.Proposal;

    /////////////////////////
    // Modifiers
    ////////////////////////

    // @dev This modifier needs to be applied to all external non-constant functions.
    //  this modifier goes _before_ other state modifiers like `onlyState`.
    //  after function body execution state may transition again in `advanceLogicState`
    modifier withStateTransition(bytes32 proposalId) {
        VotingProposal.Proposal storage p = ensureExistingProposal(proposalId);
        // switch state due to time
        VotingProposal.advanceTimedState(p, proposalId);
        // execute function body
        _;
        // switch state due to business logic
        VotingProposal.advanceLogicState(p, proposalId);
    }

    // @dev This modifier needs to be applied to all external non-constant functions.
    //  this modifier goes _before_ other state modifiers like `onlyState`.
    //  note that this function actually modifies state so it will generate warnings
    //  and is incompatible with STATICCALL
    modifier withTimedTransition(bytes32 proposalId) {
        VotingProposal.Proposal storage p = ensureExistingProposal(proposalId);
        // switch state due to time
        VotingProposal.advanceTimedState(p, proposalId);
        // execute function body
        _;
    }

    modifier withVotingOpen(bytes32 proposalId) {
        VotingProposal.Proposal storage p = _proposals[proposalId];
        require(VotingProposal.isVotingOpen(p), "NV_VC_VOTING_CLOSED");
        _;
    }

    modifier withRelayingOpen(bytes32 proposalId) {
        VotingProposal.Proposal storage p = _proposals[proposalId];
        require(VotingProposal.isRelayOpen(p), "NV_VC_VOTING_CLOSED");
        _;
    }

    modifier onlyTally(bytes32 proposalId) {
        VotingProposal.Proposal storage p = _proposals[proposalId];
        require(p.state == VotingProposal.State.Tally, "NV_VC_NOT_TALLYING");
        _;
    }

    /////////////////////////
    // Mutable state
    ////////////////////////

    mapping (bytes32 => VotingProposal.Proposal) private _proposals;
    IVotingController private _votingController;


    /////////////////////////
    // Events
    ////////////////////////

    // must be in sync with library event, events cannot be shared
    event LogProposalStateTransition(
        bytes32 indexed proposalId,
        address initiator,
        address votingLegalRep,
        address token,
        VotingProposal.State oldState,
        VotingProposal.State newState
    );

    // logged when voter casts a vote
    event LogVoteCast(
        bytes32 indexed proposalId,
        address initiator,
        address token,
        address voter,
        bool voteInFavor,
        uint256 power
    );

    // logged when proposal legal rep provides off-chain voting results
    event LogOffChainProposalResult(
        bytes32 indexed proposalId,
        address initiator,
        address token,
        address votingLegalRep,
        uint256 inFavor,
        uint256 against,
        string documentUri
    );

    // logged when controller changed
    event LogChangeVotingController(
        address oldController,
        address newController,
        address by
    );

    ////////////////////////
    // Constructor
    ////////////////////////

    constructor(IVotingController controller) public {
        _votingController = controller;
    }

    /////////////////////////
    // Public functions
    ////////////////////////

    //
    // IVotingCenter implementation
    //

    function addProposal(
        bytes32 proposalId,
        ITokenSnapshots token,
        uint32 campaignDuration,
        uint256 campaignQuorumFraction,
        uint32 votingPeriod,
        address votingLegalRep,
        uint32 offchainVotePeriod,
        uint256 totalVotingPower,
        uint256 action,
        bytes actionPayload,
        bool enableObserver
    )
        public
    {
        require(token != address(0));
        VotingProposal.Proposal storage p = _proposals[proposalId];

        require(p.token == address(0), "NF_VC_P_ID_NON_UNIQ");
        // campaign duration must be less or eq total voting period
        require(campaignDuration <= votingPeriod, "NF_VC_CAMPAIGN_OVR_TOTAL");
        require(campaignQuorumFraction <= 10**18, "NF_VC_INVALID_CAMPAIGN_Q");
        require(
            campaignQuorumFraction == 0 && campaignDuration == 0 ||
            campaignQuorumFraction > 0 && campaignDuration > 0,
            "NF_VC_CAMP_INCONSISTENT"
        );
        require(
            offchainVotePeriod > 0 && totalVotingPower > 0 && votingLegalRep != address(0) ||
            offchainVotePeriod == 0 && totalVotingPower == 0 && votingLegalRep == address(0),
            "NF_VC_TALLY_INCONSISTENT"
        );

        // take sealed snapshot
        uint256 sId = token.currentSnapshotId() - 1;

        p.initialize(
            proposalId,
            token,
            sId,
            campaignDuration,
            campaignQuorumFraction,
            votingPeriod,
            votingLegalRep,
            offchainVotePeriod,
            totalVotingPower,
            action,
            enableObserver
        );
        // we should do it in initialize bo stack is too small
        p.actionPayload = actionPayload;
        // call controller now when proposal is available via proposal method
        require(_votingController.onAddProposal(proposalId, msg.sender, token), "NF_VC_CTR_ADD_REJECTED");
    }

    function vote(bytes32 proposalId, bool voteInFavor)
        public
        withStateTransition(proposalId)
        withVotingOpen(proposalId)
    {
        VotingProposal.Proposal storage p = _proposals[proposalId];
        require(p.hasVoted[msg.sender] == VotingProposal.TriState.Abstain, "NF_VC_ALREADY_VOTED");
        castVote(p, proposalId, voteInFavor, msg.sender);
    }

    function addOffchainVote(bytes32 proposalId, uint256 inFavor, uint256 against, string documentUri)
        public
        withStateTransition(proposalId)
        onlyTally(proposalId)
    {
        VotingProposal.Proposal storage p = _proposals[proposalId];
        require(msg.sender == p.votingLegalRep, "NF_VC_ONLY_VOTING_LEGAL_REP");
        // may not cross offchainVotingPower
        require(inFavor + against <= p.offchainVotingPower, "NF_VC_EXCEEDS_OFFLINE_V_POWER");
        require(inFavor + against > 0, "NF_VC_NO_OFF_EMPTY_VOTE");

        p.offchainInFavor = inFavor;
        p.offchainAgainst = against;
        p.offchainVoteDocumentUri = documentUri;

        emit LogOffChainProposalResult(proposalId, p.initiator, p.token, msg.sender, inFavor, against, documentUri);
    }

    function tally(bytes32 proposalId)
        public
        constant
        withTimedTransition(proposalId)
        returns(
            uint8 s,
            uint256 inFavor,
            uint256 against,
            uint256 offchainInFavor,
            uint256 offchainAgainst,
            uint256 tokenVotingPower,
            uint256 totalVotingPower,
            uint256 campaignQuorumTokenAmount,
            address initiator,
            bool hasObserverInterface
        )
    {
        VotingProposal.Proposal storage p = ensureExistingProposal(proposalId);

        s = uint8(p.state);
        inFavor = p.inFavor;
        against = p.against;
        offchainInFavor = p.offchainInFavor;
        offchainAgainst = p.offchainAgainst;
        initiator = p.initiator;
        hasObserverInterface = p.observing;
        tokenVotingPower = p.token.totalSupplyAt(p.snapshotId);
        totalVotingPower = tokenVotingPower + p.offchainVotingPower;
        campaignQuorumTokenAmount = p.campaignQuorumTokenAmount;
    }

    function offchainVoteDocumentUri(bytes32 proposalId)
        public
        constant
        returns (string)
    {
        VotingProposal.Proposal storage p = ensureExistingProposal(proposalId);
        return p.offchainVoteDocumentUri;
    }

    function timedProposal(bytes32 proposalId)
        public
        withTimedTransition(proposalId)
        constant
        returns (
            uint8 s,
            address token,
            uint256 snapshotId,
            address initiator,
            address votingLegalRep,
            uint256 campaignQuorumTokenAmount,
            uint256 offchainVotingPower,
            uint256 action,
            bytes actionPayload,
            bool enableObserver,
            uint32[5] deadlines
        )
    {
        VotingProposal.Proposal storage p = ensureExistingProposal(proposalId);

        s = uint8(p.state);
        token = p.token;
        snapshotId = p.snapshotId;
        enableObserver = p.observing;
        campaignQuorumTokenAmount = p.campaignQuorumTokenAmount;
        initiator = p.initiator;
        votingLegalRep = p.votingLegalRep;
        offchainVotingPower = p.offchainVotingPower;
        deadlines = p.deadlines;
        action = p.action;
        actionPayload = p.actionPayload;
    }

    function proposal(bytes32 proposalId)
        public
        constant
        returns (
            uint8 s,
            address token,
            uint256 snapshotId,
            address initiator,
            address votingLegalRep,
            uint256 campaignQuorumTokenAmount,
            uint256 offchainVotingPower,
            uint256 action,
            bytes actionPayload,
            bool enableObserver,
            uint32[5] deadlines
            )
    {
        VotingProposal.Proposal storage p = ensureExistingProposal(proposalId);

        s = uint8(p.state);
        token = p.token;
        snapshotId = p.snapshotId;
        enableObserver = p.observing;
        campaignQuorumTokenAmount = p.campaignQuorumTokenAmount;
        initiator = p.initiator;
        votingLegalRep = p.votingLegalRep;
        offchainVotingPower = p.offchainVotingPower;
        deadlines = p.deadlines;
        action = p.action;
        actionPayload = p.actionPayload;
    }

    function getVote(bytes32 proposalId, address voter)
        public
        constant
        returns (uint8)
    {
        VotingProposal.Proposal storage p = ensureExistingProposal(proposalId);
        return uint8(p.hasVoted[voter]);
    }

    function hasProposal(bytes32 proposalId)
        public
        constant
        returns (bool)
    {
        VotingProposal.Proposal storage p = _proposals[proposalId];
        return p.token != address(0);
    }

    function getVotingPower(bytes32 proposalId, address voter)
        public
        constant
        returns (uint256)
    {
        VotingProposal.Proposal storage p = ensureExistingProposal(proposalId);
        return p.token.balanceOfAt(voter, p.snapshotId);
    }

    //
    // IContractId Implementation
    //

    function contractId()
        public
        pure
        returns (bytes32 id, uint256 version)
    {
        return (0xbbf540c4111754f6dbce914d5e55e1c0cb26515adbc288b5ea8baa544adfbfa4, 0);
    }

    //
    // IVotingController hook
    //

    /// @notice get current controller
    function votingController()
        public
        constant
        returns (IVotingController)
    {
        return _votingController;
    }

    /// @notice update current controller
    function changeVotingController(IVotingController newController)
        public
    {
        require(_votingController.onChangeVotingController(msg.sender, newController), "NF_VC_CHANGING_CTR_REJECTED");
        address oldController = address(_votingController);
        _votingController = newController;
        emit LogChangeVotingController(oldController, address(newController), msg.sender);
    }

    //
    // Other methods
    //

    /// @dev same as vote, only for a relayed vote. Will throw if provided signature (v,r,s) does not match
    ///  the address of the voter
    /// @param voter address whose token balance should be used as voting power
    function relayedVote(
        bytes32 proposalId,
        bool voteInFavor,
        address voter,
        bytes32 r,
        bytes32 s,
        uint8 v
    )
        public
        withStateTransition(proposalId)
        withRelayingOpen(proposalId)
    {
        // check that message signature matches the voter address
        assert(isValidSignature(proposalId, voteInFavor, voter, r, s, v));
        // solium-enable indentation
        VotingProposal.Proposal storage p = _proposals[proposalId];
        require(p.hasVoted[voter] == VotingProposal.TriState.Abstain, "NF_VC_ALREADY_VOTED");
        castVote(p, proposalId, voteInFavor, voter);
    }

    // batches should be grouped by proposal, that allows to tally in place and write to storage once
    function batchRelayedVotes(
        bytes32 proposalId,
        bool[] votePreferences,
        bytes32[] r,
        bytes32[] s,
        uint8[] v
    )
        public
        withStateTransition(proposalId)
        withRelayingOpen(proposalId)
    {
        assert(
            votePreferences.length == r.length && r.length == s.length && s.length == v.length
        );
        relayBatchInternal(
            proposalId,
            votePreferences,
            r, s, v
        );
    }

    function handleStateTransitions(bytes32 proposalId)
        public
        withTimedTransition(proposalId)
    {}

    //
    // Utility public functions
    //

    function isValidSignature(
        bytes32 proposalId,
        bool voteInFavor,
        address voter,
        bytes32 r,
        bytes32 s,
        uint8 v
    )
        public
        constant
        returns (bool)
    {
        // solium-disable indentation
        return ecrecoverVoterAddress(proposalId, voteInFavor, r, s, v) == voter;
    }

    function ecrecoverVoterAddress(
        bytes32 proposalId,
        bool voteInFavor,
        bytes32 r,
        bytes32 s,
        uint8 v
    )
        public
        constant
        returns (address)
    {
        // solium-disable indentation
        return ecrecover(
            keccak256(abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                keccak256(abi.encodePacked(byte(0), address(this), proposalId, voteInFavor)))),
            v, r, s);
    }

    /////////////////////////
    // Internal functions
    ////////////////////////

    function ensureExistingProposal(bytes32 proposalId)
        internal
        constant
        returns (VotingProposal.Proposal storage p)
    {
        p = _proposals[proposalId];
        require(p.token != address(0), "NF_VC_PROP_NOT_EXIST");
        return p;
    }

    /////////////////////////
    // Private functions
    ////////////////////////

    /// @dev increase the votecount on a given proposal by the token balance of a given address,
    ///   throws if proposal does not exist or the vote on it has ended already. Votes are final,
    ///   changing the vote is not allowed
    /// @param p proposal storage pointer
    /// @param proposalId of the proposal to be voted on
    /// @param voteInFavor of the desired proposal
    /// @param voter address whose tokenBalance is to be used as voting-power
    function castVote(VotingProposal.Proposal storage p, bytes32 proposalId, bool voteInFavor, address voter)
        private
    {
        uint256 power = p.token.balanceOfAt(voter, p.snapshotId);
        if (voteInFavor) {
            p.inFavor = Math.add(p.inFavor, power);
        } else {
            p.against = Math.add(p.against, power);
        }
        markVoteCast(p, proposalId, voter, voteInFavor, power);
    }

    function relayBatchInternal(
        bytes32 proposalId,
        bool[] votePreferences,
        bytes32[] r,
        bytes32[] s,
        uint8[] v
    )
        private
    {
        uint256 inFavor;
        uint256 against;
        VotingProposal.Proposal storage p = _proposals[proposalId];
        for (uint256 i = 0; i < votePreferences.length; i++) {
            uint256 power = relayBatchElement(
                p,
                proposalId,
                votePreferences[i],
                r[i], s[i], v[i]);
            if (votePreferences[i]) {
                inFavor = Math.add(inFavor, power);
            } else {
                against = Math.add(against, power);
            }
        }
        // write votes to storage
        p.inFavor = Math.add(p.inFavor, inFavor);
        p.against = Math.add(p.against, against);
    }

    function relayBatchElement(
        VotingProposal.Proposal storage p,
        bytes32 proposalId,
        bool voteInFavor,
        bytes32 r,
        bytes32 s,
        uint8 v
    )
        private
        returns (uint256 power)
    {
        // recover voter from signature, mangled data produces mangeld voter address, which will be
        // eliminated later
        address voter = ecrecoverVoterAddress(
            proposalId,
            voteInFavor,
            r, s, v
        );
        // cast vote if not cast before
        if (p.hasVoted[voter] == VotingProposal.TriState.Abstain) {
            power = p.token.balanceOfAt(voter, p.snapshotId);
            // if not holding token, power is 0
            markVoteCast(p, proposalId, voter, voteInFavor, power);
        }
        // returns voting power which is zero in case of failed vote
    }

    function markVoteCast(VotingProposal.Proposal storage p, bytes32 proposalId, address voter, bool voteInFavor, uint256 power)
        private
    {
        if (power > 0) {
            p.hasVoted[voter] = voteInFavor ? VotingProposal.TriState.InFavor : VotingProposal.TriState.Against;
            emit LogVoteCast(proposalId, p.initiator, p.token, voter, voteInFavor, power);
        }
    }
}