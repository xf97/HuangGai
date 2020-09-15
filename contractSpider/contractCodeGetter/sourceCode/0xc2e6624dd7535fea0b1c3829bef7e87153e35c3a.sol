/**
 *Submitted for verification at Etherscan.io on 2020-06-17
*/

// File: contracts/interfaces/IAaveLendingPool.sol

pragma solidity ^0.6.0;

abstract contract IAaveLendingPool {
  function deposit(
    address _reserve,
    uint256 _amount,
    uint16 _referralCode
  ) public virtual;
}

// File: contracts/interfaces/IERC20.sol

pragma solidity ^0.6.0;

abstract contract IERC20 {
  function balanceOf(address user) external virtual view returns (uint256);

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external virtual returns (bool);

  function transfer(address recipient, uint256 amount)
    external
    virtual
    returns (bool);

  function allowance(address owner, address spender)
    external
    virtual
    view
    returns (uint256);

  function approve(address spender, uint256 amount)
    external
    virtual
    returns (bool);
}

// File: contracts/interfaces/IADai.sol

pragma solidity ^0.6.0;


abstract contract IADai is IERC20 {
  function redeem(uint256 _amount) public virtual;
  // function redirectInterestStream(address _to) public virtual;
}

// File: contracts/interfaces/IPoolDeposits.sol

pragma solidity ^0.6.0;

abstract contract IPoolDeposits {
  mapping(address => uint256) public depositedDai;

  function usersDeposit(address userAddress)
    external
    virtual
    view
    returns (uint256);

  function changeProposalAmount(uint256 amount) external virtual;

  function redirectInterestStreamToWinner(address _winner) external virtual;

  function distributeInterest(
    address[] calldata receivers,
    uint256[] calldata percentages,
    address winner,
    uint256 iteration
  ) external virtual;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol

pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/upgrades/contracts/Initializable.sol

pragma solidity >=0.4.24 <0.7.0;


/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

// File: contracts/NoLossDao_v0.sol

pragma solidity 0.6.10;

// import "./interfaces/IERC20.sol";



// import '@nomiclabs/buidler/console.sol';



/** @title No Loss Dao Contract. */
contract NoLossDao_v0 is Initializable {
  using SafeMath for uint256;

  //////// MASTER //////////////
  address public admin;

  //////// Iteration specific //////////
  uint256 public votingInterval;
  uint256 public proposalIteration;

  ///////// Proposal specific ///////////
  uint256 public proposalId;
  uint256 public proposalDeadline; // keeping track of time
  mapping(uint256 => string) public proposalIdentifier;
  mapping(address => uint256) public benefactorsProposal; // benefactor -> proposal id
  mapping(uint256 => address) public proposalOwner; // proposal id -> benefactor (1:1 mapping)
  enum ProposalState {DoesNotExist, Withdrawn, Active, Cooldown} // Add Cooldown state and pending state
  mapping(uint256 => ProposalState) public state; // ProposalId to current state

  //////// User specific //////////
  mapping(address => uint256) public iterationJoined; // Which iteration did user join DAO
  mapping(uint256 => mapping(address => uint256)) public usersNominatedProject; // iteration -> user -> chosen project

  //////// DAO / VOTE specific //////////
  mapping(uint256 => mapping(uint256 => uint256)) public proposalVotes; /// iteration -> proposalId -> num votes
  mapping(uint256 => uint256) public topProject;
  mapping(address => address) public voteDelegations; // For vote proxy

  //////// Necessary to fund dev and miners //////////
  address[] interestReceivers; // in v0, the interestReceivers is the address of the miner.
  uint256[] percentages;

  ///////// DEFI Contrcats ///////////
  IPoolDeposits public depositContract;

  // Crrate blank 256 arrays of fixed length for upgradability.

  ///////// Events ///////////
  event VoteDelegated(address indexed user, address delegatedTo);
  event VotedDirect(
    address indexed user,
    uint256 indexed iteration,
    uint256 indexed proposalId
  );
  event VotedViaProxy(
    address indexed proxy,
    address user,
    uint256 indexed iteration,
    uint256 indexed proposalId
  );
  event IterationChanged(
    uint256 indexed newIterationId,
    address miner,
    uint256 timeStamp
  );
  event IterationWinner(
    uint256 indexed propsalIteration,
    address indexed winner,
    uint256 indexed projectId
  );
  event InterestConfigChanged(
    address[] addresses,
    uint256[] percentages,
    uint256 iteration
  );
  // Test these events
  event ProposalActive(
    uint256 indexed proposalId,
    address benefactor,
    uint256 iteration
  );
  event ProposalCooldown(uint256 indexed proposalId, uint256 iteration);
  event ProposalWithdrawn(uint256 indexed proposalId, uint256 iteration);

  ////////////////////////////////////
  //////// Modifiers /////////////////
  ////////////////////////////////////
  modifier onlyAdmin() {
    require(msg.sender == admin, 'Not admin');
    _;
  }

  modifier hasDeposit(address givenAddress) {
    require(
      depositContract.depositedDai(givenAddress) > 0,
      'User has no stake'
    );
    _;
  }

  modifier noVoteYet(address givenAddress) {
    require(
      usersNominatedProject[proposalIteration][givenAddress] == 0,
      'User already voted this iteration'
    );
    _;
  }

  modifier userHasActiveProposal(address givenAddress) {
    require(
      state[benefactorsProposal[givenAddress]] == ProposalState.Active,
      'User proposal does not exist'
    );
    _;
  }

  modifier userHasNoActiveProposal(address givenAddress) {
    require(
      state[benefactorsProposal[givenAddress]] != ProposalState.Active,
      'User has an active proposal'
    );
    _;
  }

  modifier userHasNoProposal(address givenAddress) {
    require(benefactorsProposal[givenAddress] == 0, 'User has a proposal');
    _;
  }

  modifier proposalActive(uint256 propId) {
    require(state[propId] == ProposalState.Active, 'Proposal is not active');
    _;
  }

  modifier proxyRight(address delegatedFrom) {
    require(
      voteDelegations[delegatedFrom] == msg.sender,
      'User does not have proxy right'
    );
    _;
  }

  // We reset the iteration back to zero when a user leaves. Means this modifier will no longer protect.
  // But, its okay because it cannot be exploited. When 0, the user will have zero deposit.
  // Therefore that modifier will always catch them in that case :)
  modifier joinedInTime(address givenAddress) {
    require(
      iterationJoined[givenAddress] < proposalIteration,
      'User only eligible to vote next iteration'
    );
    _;
  }

  modifier lockInFulfilled(address givenAddress) {
    require(
      iterationJoined[givenAddress] + 2 < proposalIteration,
      'Benefactor has not fulfilled the minimum lockin period of 2 iterations'
    );
    _;
  }
  modifier iterationElapsed() {
    require(proposalDeadline < now, 'iteration interval not ended');
    _;
  }

  modifier depositContractOnly() {
    require(
      address(depositContract) == msg.sender, // Is this a valid way of getting the address?
      'function can only be called by deposit contract'
    );
    _;
  }

  ////////////////////////////////////
  //////// SETUP CONTRACT////////////
  //// NOTE: Upgradable at the moment
  function initialize(
    address depositContractAddress,
    uint256 _votingInterval,
    uint256 _lengthOfIterationZero
  ) public initializer {
    depositContract = IPoolDeposits(depositContractAddress);
    admin = msg.sender;
    votingInterval = _votingInterval;
    // Length of the 1st iteration can be set here. For mainnet we use 2 months to 'warmup' the dao (5184000 = 60days)
    proposalDeadline = now.add(_lengthOfIterationZero);
    interestReceivers.push(admin); // This will change to miner when iterationchanges
    percentages.push(15); // 1.5% for miner
    interestReceivers.push(admin);
    percentages.push(135); // 13.5% for devlopers

    emit IterationChanged(0, msg.sender, now);
  }

  ///////////////////////////////////
  /////// Config functions //////////
  ///////////////////////////////////

  /// @dev Changes the time iteration  between intervals
  /// @param newInterval new time interval between interations
  function changeVotingInterval(uint256 newInterval) public onlyAdmin {
    votingInterval = newInterval;
  }

  /// @dev Changes the amount required to stake for new proposal
  /// @param amount how much new amount is.
  function changeProposalStakingAmount(uint256 amount) public onlyAdmin {
    depositContract.changeProposalAmount(amount);
  }

  /// @dev Admin function for setting the who recieves interest and what percentage.
  /// @param _interestReceivers The list of addresses to recieve interest
  /// @param _percentages The percentage they each will recieve
  function setInterestReceivers(
    address[] memory _interestReceivers,
    uint256[] memory _percentages
  ) public onlyAdmin {
    require(
      _interestReceivers.length == _percentages.length,
      'Arrays should be equal length'
    );
    uint256 percentagesSum = 0;
    for (uint256 i = 0; i < _percentages.length; i++) {
      percentagesSum = percentagesSum.add(_percentages[i]);
    }
    require(percentagesSum < 1000, 'Percentages total too high');

    interestReceivers = _interestReceivers;
    percentages = _percentages;
    emit InterestConfigChanged(
      _interestReceivers,
      _percentages,
      proposalIteration
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////// Deposit & withdraw function for users //////////
  ////////and proposal holders (benefactors) /////////////
  ////////////////////////////////////////////////////////

  /// @dev Returns true if the user has not voted this iteration and they are not a proposal
  /// @param userAddress address of the user we are checking
  /// @return boolean true if user hasn't voted and isn't a proposal
  /// Indentical to modifier, hasNoVote && userHasNoProposal, but funciton need for poolDeposits to allow partial withdrawl
  function userHasNotVotedThisIterationAndIsNotProposal(address userAddress)
    external
    view
    returns (bool)
  {
    return
      usersNominatedProject[proposalIteration][userAddress] == 0 &&
      benefactorsProposal[userAddress] == 0;
  }

  /// @dev Checks whether user is eligible deposit and sets the proposal iteration joined, to the current iteration
  /// @param userAddress address of the user wanting to deposit
  /// @return boolean whether the above executes successfully
  function noLossDeposit(address userAddress)
    external
    depositContractOnly
    userHasNoProposal(userAddress) // Checks they are not a benefactor
    returns (bool)
  {
    iterationJoined[userAddress] = proposalIteration;
    return true;
  }

  /// @dev Checks whether user is eligible to withdraw their deposit and sets the proposal iteration joined to zero
  /// @param userAddress address of the user wanting to withdraw
  /// @return boolean whether the above executes successfully
  function noLossWithdraw(address userAddress)
    external
    depositContractOnly
    noVoteYet(userAddress)
    userHasNoProposal(userAddress)
    returns (bool)
  {
    iterationJoined[userAddress] = 0;
    return true;
  }

  /// @dev Checks whether user is eligible to create a proposal then creates it. Executes a range of logic to add the new propsal (increments proposal ID, sets proposal owner, sets iteration joined, etc...)
  /// @param _proposalIdentifier Hash of the proposal text
  /// @param benefactorAddress address of benefactor creating proposal
  /// @return newProposalId boolean whether the above executes successfully
  function noLossCreateProposal(
    string calldata _proposalIdentifier,
    address benefactorAddress
  ) external depositContractOnly returns (uint256 newProposalId) {
    proposalId = proposalId.add(1);

    proposalIdentifier[proposalId] = _proposalIdentifier;
    proposalOwner[proposalId] = benefactorAddress;
    benefactorsProposal[benefactorAddress] = proposalId;
    state[proposalId] = ProposalState.Active;
    iterationJoined[benefactorAddress] = proposalIteration;
    emit ProposalActive(proposalId, benefactorAddress, proposalIteration);
    return proposalId;
  }

  /// @dev Checks whether user is eligible to withdraw their proposal
  /// Sets the state of the users proposal to withdrawn
  /// resets the iteration of user joined back to 0
  /// @param benefactorAddress address of benefactor withdrawing proposal
  /// @return boolean whether the above is possible
  function noLossWithdrawProposal(address benefactorAddress)
    external
    depositContractOnly
    userHasActiveProposal(benefactorAddress)
    lockInFulfilled(benefactorAddress)
    returns (bool)
  {
    uint256 benefactorsProposalId = benefactorsProposal[benefactorAddress];
    iterationJoined[benefactorAddress] = 0;
    state[benefactorsProposalId] = ProposalState.Withdrawn;
    emit ProposalWithdrawn(benefactorsProposalId, proposalIteration);
    return true;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////// DAO voting functionality  //////////////////////
  ////////////////////////////////////////////////////////

  /// @dev Allows user to delegate their full voting power to another user
  /// @param delegatedAddress the address to which you are delegating your voting rights
  function delegateVoting(address delegatedAddress)
    external
    hasDeposit(msg.sender)
    userHasNoActiveProposal(msg.sender)
    userHasNoActiveProposal(delegatedAddress)
  {
    voteDelegations[msg.sender] = delegatedAddress;
    emit VoteDelegated(msg.sender, delegatedAddress);
  }

  /// @dev Allows user to vote for an active proposal. Once voted they cannot withdraw till next iteration.
  /// @param proposalIdToVoteFor Id of the proposal they are voting for
  function voteDirect(
    uint256 proposalIdToVoteFor // breaking change -> function name change from vote to voteDirect
  )
    external
    proposalActive(proposalIdToVoteFor)
    noVoteYet(msg.sender)
    hasDeposit(msg.sender)
    userHasNoActiveProposal(msg.sender)
    joinedInTime(msg.sender)
  {
    _vote(proposalIdToVoteFor, msg.sender);
    emit VotedDirect(msg.sender, proposalIteration, proposalIdToVoteFor);
  }

  /// @dev Allows user proxy to vote on behalf of a user.
  /// @param proposalIdToVoteFor Id of the proposal they are voting for
  /// @param delegatedFrom user they are voting on behalf of
  function voteProxy(uint256 proposalIdToVoteFor, address delegatedFrom)
    external
    proposalActive(proposalIdToVoteFor)
    proxyRight(delegatedFrom)
    noVoteYet(delegatedFrom)
    hasDeposit(delegatedFrom)
    userHasNoActiveProposal(delegatedFrom)
    userHasNoActiveProposal(msg.sender)
    joinedInTime(delegatedFrom)
  {
    _vote(proposalIdToVoteFor, delegatedFrom);
    emit VotedViaProxy(
      msg.sender,
      delegatedFrom,
      proposalIteration,
      proposalIdToVoteFor
    );
  }

  /// @dev Internal function casting the actual vote from the requested address
  /// @param proposalIdToVoteFor Id of the proposal they are voting for
  /// @param voteAddress address the vote is stemming from
  function _vote(uint256 proposalIdToVoteFor, address voteAddress) internal {
    usersNominatedProject[proposalIteration][voteAddress] = proposalIdToVoteFor;
    proposalVotes[proposalIteration][proposalIdToVoteFor] = proposalVotes[proposalIteration][proposalIdToVoteFor]
      .add(depositContract.depositedDai(voteAddress));


      uint256 topProjectVotes
     = proposalVotes[proposalIteration][topProject[proposalIteration]];

    // Currently, proposal getting to top vote first will win [this is fine]
    if (
      proposalVotes[proposalIteration][proposalIdToVoteFor] > topProjectVotes
    ) {
      topProject[proposalIteration] = proposalIdToVoteFor;
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////// Iteration changer / mining function  //////////////////////
  ///////////////////////////////////////////////////////////////////

  /// @dev Anyone can call this every 2 weeks (more specifically every *iteration interval*) to receive a reward, and increment onto the next iteration of voting
  function distributeFunds() external iterationElapsed {
    interestReceivers[0] = msg.sender; // Set the miners address to receive a small reward

    if (proposalIteration > 0) {
      // distribute interest from previous week.
      uint256 previousIterationTopProject = topProject[proposalIteration.sub(
        1
      )];
      if (previousIterationTopProject != 0) {
        // Only if last winner is not withdrawn (i.e. st ill in cooldown) make it active again
        if (state[previousIterationTopProject] == ProposalState.Cooldown) {
          state[previousIterationTopProject] = ProposalState.Active;
          emit ProposalActive(
            previousIterationTopProject,
            proposalOwner[previousIterationTopProject],
            proposalIteration
          );
        }

        address previousWinner = proposalOwner[previousIterationTopProject]; // This cannot be null, since we check that there was a winner above.
        depositContract.distributeInterest(
          interestReceivers,
          percentages,
          previousWinner,
          proposalIteration
        );
      }

      uint256 iterationTopProject = topProject[proposalIteration];
      if (iterationTopProject != 0) {
        // TODO: Do some asserts here for safety...
        if (state[iterationTopProject] != ProposalState.Withdrawn) {
          state[iterationTopProject] = ProposalState.Cooldown;
          emit ProposalCooldown(iterationTopProject, proposalIteration);
        }
        address winner = proposalOwner[iterationTopProject]; // This cannot be null, since we check that there was a winner above.
        emit IterationWinner(proposalIteration, winner, iterationTopProject);
      }
    }

    proposalDeadline = now.add(votingInterval);
    proposalIteration = proposalIteration.add(1);

    // send winning miner a little surprise [NFT]
    emit IterationChanged(proposalIteration, msg.sender, now);
  }
}