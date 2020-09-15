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

// File: contracts/interfaces/INoLossDao.sol

pragma solidity ^0.6.0;

abstract contract INoLossDao {
  function userHasNotVotedThisIterationAndIsNotProposal(address userAddress)
    external
    virtual
    view
    returns (bool);

  function noLossDeposit(address userAddress) external virtual returns (bool);

  function noLossWithdraw(address userAddress) external virtual returns (bool);

  function noLossCreateProposal(
    string calldata proposalHash,
    address benefactorAddress
  ) external virtual returns (uint256 newProposalId);

  function noLossWithdrawProposal(address benefactorAddress)
    external
    virtual
    returns (bool);
}

// File: contracts/interfaces/ILendingPoolAddressesProvider.sol

pragma solidity ^0.6.0;

abstract contract ILendingPoolAddressesProvider {
  function getLendingPool() public virtual view returns (address);

  function getLendingPoolCore() public virtual view returns (address);
}

// INSERT LATER INTO NOLOSSDAO
// Therefore, whenever it's required to access the LendingPool contract
// it is recommended to fetch the correct address from the LendingPoolAddressesProvider smart contract.

// Just want to get it to compile. coIo'lll suese this terminal ::DD
// LendingPoolAddressesProvider provider = LendingPoolAddressesProvider(
//     0x24a42fD28C976A61Df5D00D0599C34c4f90748c8
// );
// LendingPool lendingPool = LendingPool(provider.getLendingPool());

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

// File: contracts/PoolDeposits.sol

pragma solidity 0.6.10;






// import '@nomiclabs/buidler/console.sol';

/** @title Pooled Deposits Contract*/
contract PoolDeposits {
  using SafeMath for uint256;

  address public admin;
  uint256 public totalDepositedDai;
  mapping(address => uint256) public depositedDai;

  uint256 public proposalAmount; // Stake required to submit a proposal

  ///////// DEFI Contrcats ///////////
  IERC20 public daiContract;
  IAaveLendingPool public aaveLendingContract;
  IADai public adaiContract;
  INoLossDao public noLossDaoContract;
  ILendingPoolAddressesProvider public provider;
  address public aaveLendingContractCore;

  //////// EMERGENCY MODULE ONLY ///////
  uint256 public emergencyVoteAmount;
  mapping(address => bool) public emergencyVoted;
  mapping(address => uint256) public timeJoined;
  bool public isEmergencyState;

  ///////// Events ///////////
  event DepositAdded(address indexed user, uint256 amount);
  event ProposalAdded(
    address indexed benefactor,
    uint256 indexed proposalId,
    string proposalIdentifier
  );
  event DepositWithdrawn(address indexed user);
  event PartialDepositWithdrawn(address indexed user, uint256 amount);
  event ProposalWithdrawn(address indexed benefactor);
  event InterestSent(address indexed user, uint256 amount);
  event WinnerPayout(
    address indexed user,
    uint256 indexed iteration,
    uint256 amount
  );

  ///////// Emergency Events ///////////
  event EmergencyStateReached(
    address indexed user,
    uint256 timeStamp,
    uint256 totalDaiInContract,
    uint256 totalEmergencyVotes
  );
  event EmergencyVote(address indexed user, uint256 emergencyVoteAmount);
  event RemoveEmergencyVote(address indexed user, uint256 emergencyVoteAmount);
  event ADaiRedeemFailed();
  event EmergencyWithdrawl(address indexed user);

  ///////////////////////////////////////////////////////////////////
  //////// EMERGENCY MODIFIERS //////////////////////////////////////
  ///////////////////////////////////////////////////////////////////
  modifier emergencyEnacted() {
    require(
      totalDepositedDai < emergencyVoteAmount.mul(2), //safe 50%
      '50% of total pool needs to have voted for emergency state'
    );
    require(
      totalDepositedDai > 200000000000000000000000, //200 000 DAI needed in contract
      '200 000DAI required in pool before emergency state can be declared'
    );
    _;
  }
  modifier noEmergencyVoteYet() {
    require(emergencyVoted[msg.sender] == false, 'Already voted for emergency');
    _;
  }
  modifier stableState() {
    require(isEmergencyState == false, 'State of emergency declared');
    _;
  }
  modifier emergencyState() {
    require(isEmergencyState == true, 'State of emergency not declared');
    _;
  }
  // Required to be part of the pool for 100 days. Make it costly to borrow and put into state of emergency.
  modifier eligibleToEmergencyVote() {
    require(
      timeJoined[msg.sender].add(8640000) < now,
      'Need to have joined for 100days to vote an emergency'
    );
    _;
  }
  ////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////
  //////// Modifiers /////////////////
  ////////////////////////////////////
  modifier onlyAdmin() {
    require(msg.sender == admin, 'Not admin');
    _;
  }

  modifier noLossDaoContractOnly() {
    require(
      address(noLossDaoContract) == msg.sender, // Is this a valid way of getting the address?
      'function can only be called by no Loss Dao contract'
    );
    _;
  }

  modifier allowanceAvailable(uint256 amount) {
    require(
      amount <= daiContract.allowance(msg.sender, address(this)), // checking the pool deposits contract
      'amount not available'
    );
    _;
  }

  modifier requiredDai(uint256 amount) {
    require(
      daiContract.balanceOf(msg.sender) >= amount,
      'User does not have enough DAI'
    );
    _;
  }

  modifier blankUser() {
    require(depositedDai[msg.sender] == 0, 'Person is already a user');
    _;
  }

  modifier userStaked() {
    require(depositedDai[msg.sender] > 0, 'User has no stake');
    _;
  }

  modifier hasNotEmergencyVoted() {
    require(!emergencyVoted[msg.sender], 'User has emergency voted');
    _;
  }

  modifier validAmountToWithdraw(uint256 amount) {
    // NOTE: if you want to withdraw 100% of your balance use the `exit` function. The `exit` function does the correct update in the noLossDao.
    require(amount < depositedDai[msg.sender], 'Cannot withdraw full balance');
    _;
  }

  modifier userHasNotVotedThisIterationAndIsNotProposal() {
    require(
      noLossDaoContract.userHasNotVotedThisIterationAndIsNotProposal(
        msg.sender
      ),
      'User already voted this iteration or is a proposal'
    );
    _;
  }

  modifier validInterestSplitInput(
    address[] memory addresses,
    uint256[] memory percentages
  ) {
    require(addresses.length == percentages.length, 'Input length not equal');
    _;
  }

  /***************
    Contract set-up: Not Upgradaable
    ***************/
  constructor(
    address daiAddress,
    address aDaiAddress,
    // lendingPoolAddressProvider should be one of below depending on deployment
    // kovan 0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5
    // mainnet 0x24a42fD28C976A61Df5D00D0599C34c4f90748c8
    address lendingPoolAddressProvider,
    address noLossDaoAddress,
    uint256 _proposalAmount
  ) public {
    daiContract = IERC20(daiAddress);
    provider = ILendingPoolAddressesProvider(lendingPoolAddressProvider);
    adaiContract = IADai(aDaiAddress);
    noLossDaoContract = INoLossDao(noLossDaoAddress);
    admin = msg.sender;
    proposalAmount = _proposalAmount; // if we want this configurable put in other contract
    isEmergencyState = false;
  }

  /// @dev allows the proposalAmount (amount proposal has to stake to enter the pool) to be configurable
  /// @param amount new proposalAmount
  function changeProposalAmount(uint256 amount) external noLossDaoContractOnly {
    proposalAmount = amount;
  }

  /// @dev allows the admin to be chanded. Note admin can only declare an emergency
  /// @param newAdmin address of the new admin
  function changeAdmin(address newAdmin) external onlyAdmin {
    admin = newAdmin;
  }

  /// @dev Internal function completing the actual deposit to Aave and crediting users account
  /// @param amount amount being deosited into pool
  function _depositFunds(uint256 amount) internal {
    aaveLendingContract = IAaveLendingPool(provider.getLendingPool());
    aaveLendingContractCore = provider.getLendingPoolCore();

    daiContract.transferFrom(msg.sender, address(this), amount);
    daiContract.approve(aaveLendingContractCore, amount);
    aaveLendingContract.deposit(address(daiContract), amount, 30);

    timeJoined[msg.sender] = now;
    depositedDai[msg.sender] = depositedDai[msg.sender].add(amount);
    totalDepositedDai = totalDepositedDai.add(amount);
  }

  /// @dev Internal function completing the actual redemption from Aave and sendinding funds back to user
  /// @param amount the user wants to withdraw from the DAOcare pool
  function _withdrawFunds(uint256 amount) internal {
    depositedDai[msg.sender] = depositedDai[msg.sender].sub(amount);
    totalDepositedDai = totalDepositedDai.sub(amount);

    try adaiContract.redeem(amount)  {
      daiContract.transfer(msg.sender, amount);
    } catch {
      emit ADaiRedeemFailed();
      adaiContract.transfer(msg.sender, amount);
    }
  }

  /// @dev Lets a user join DAOcare through depositing
  /// @param amount the user wants to deposit into the DAOcare pool
  function deposit(uint256 amount)
    external
    hasNotEmergencyVoted
    allowanceAvailable(amount)
    requiredDai(amount)
    stableState
  {
    // NOTE: if the user adds a deposit they won't be able to vote in that iteration
    _depositFunds(amount);
    noLossDaoContract.noLossDeposit(msg.sender);
    emit DepositAdded(msg.sender, amount);
  }

  /// @dev Lets a user withdraw their original amount sent to DAOcare
  /// Calls the NoLossDao conrrtact to determine eligibility to withdraw
  function exit() external userStaked {
    uint256 amount = depositedDai[msg.sender];
    // NOTE: it is critical that _removeEmergancyVote happens before _withdrawFunds.
    _removeEmergencyVote();
    _withdrawFunds(amount);
    noLossDaoContract.noLossWithdraw(msg.sender);
    emit DepositWithdrawn(msg.sender);
  }

  /// @dev Lets a user withdraw some of their amount
  /// Checks they have not voted
  function withdrawDeposit(uint256 amount)
    external
    // If this user has voted to call an emergancy, they cannot do a partial withdrawal
    hasNotEmergencyVoted
    validAmountToWithdraw(amount) // not trying to withdraw full amount (eg. amount is less than the total)
    userHasNotVotedThisIterationAndIsNotProposal // checks they have not voted
  {
    _withdrawFunds(amount);
    emit PartialDepositWithdrawn(msg.sender, amount);
  }

  /// @dev Lets user create proposal
  /// @param proposalIdentifier hash of the users new proposal
  function createProposal(string calldata proposalIdentifier)
    external
    blankUser
    allowanceAvailable(proposalAmount)
    requiredDai(proposalAmount)
    stableState
    returns (uint256 newProposalId)
  {
    _depositFunds(proposalAmount);
    uint256 proposalId = noLossDaoContract.noLossCreateProposal(
      proposalIdentifier,
      msg.sender
    );
    emit ProposalAdded(msg.sender, proposalId, proposalIdentifier);
    return proposalId;
  }

  /// @dev Lets user withdraw proposal
  function withdrawProposal() external {
    _withdrawFunds(depositedDai[msg.sender]);
    noLossDaoContract.noLossWithdrawProposal(msg.sender);
    emit ProposalWithdrawn(msg.sender);
  }

  /// @dev Internal function splitting and sending the accrued interest between winners.
  /// @param receivers An array of the addresses to split between
  /// @param percentages the respective percentage to split
  /// @param winner The person who will recieve this distribution
  /// @param iteration the iteration of the dao
  /// @param totalInterestFromIteration Total interest that should be split to relevant parties
  /// @param tokenContract will be aDai or Dai (depending on try catch in distributeInterst - `redeem`)
  function _distribute(
    address[] calldata receivers,
    uint256[] calldata percentages,
    address winner,
    uint256 iteration,
    uint256 totalInterestFromIteration,
    address tokenContract
  ) internal {
    IERC20 payoutToken = IERC20(tokenContract);

    uint256 winnerPayout = totalInterestFromIteration;
    for (uint256 i = 0; i < receivers.length; i++) {
      uint256 amountToSend = totalInterestFromIteration.mul(percentages[i]).div(
        1000
      );
      payoutToken.transfer(receivers[i], amountToSend);
      winnerPayout = winnerPayout.sub(amountToSend); //SafeMath prevents this going below 0
      emit InterestSent(receivers[i], amountToSend);
    }

    payoutToken.transfer(winner, winnerPayout);
    emit WinnerPayout(winner, winnerPayout, iteration);
  }

  /// @dev Tries to redeem aDai and send acrrued interest to winners. Falls back to Dai.
  /// @param receivers An array of the addresses to split between
  /// @param percentages the respective percentage to split
  /// @param winner address of the winning proposal
  /// @param iteration the iteration of the dao
  function distributeInterest(
    address[] calldata receivers,
    uint256[] calldata percentages,
    address winner,
    uint256 iteration
  )
    external
    validInterestSplitInput(receivers, percentages)
    noLossDaoContractOnly
  {
    uint256 amountToRedeem = adaiContract.balanceOf(address(this)).sub(
      totalDepositedDai
    );
    try adaiContract.redeem(amountToRedeem)  {
      _distribute(
        receivers,
        percentages,
        winner,
        iteration,
        amountToRedeem,
        address(daiContract)
      );
    } catch {
      _distribute(
        receivers,
        percentages,
        winner,
        iteration,
        amountToRedeem,
        address(adaiContract)
      );
    }
  }

  //////////////////////////////////////////////////
  //////// EMERGENCY MODULE FUNCTIONS  //////////////
  ///////////////////////////////////////////////////

  /// @dev Internal function setting the emergency state of contract to true.
  function _declareStateOfEmergency() internal {
    isEmergencyState = true;
    emit EmergencyStateReached(
      msg.sender,
      now,
      totalDepositedDai,
      emergencyVoteAmount
    );
  }

  /// @dev Allows admin to activate emergency state
  function adminActivateEmergency() external onlyAdmin {
    _declareStateOfEmergency();
  }

  /// @dev Declares a state of emergency and enables emergency withdrawls that are not dependant on any external smart contracts
  function declareStateOfEmergency() external emergencyEnacted {
    _declareStateOfEmergency();
  }

  /// @dev Immediately lets yoou withdraw your funds in an state of emergency
  function emergencyWithdraw() external userStaked emergencyState {
    _withdrawFunds(depositedDai[msg.sender]);
    emit EmergencyWithdrawl(msg.sender);
  }

  /// @dev lets users vote that the a state of emergency should be decalred
  /// Requires time lock here to defeat flash loan punks
  function voteEmergency()
    external
    userStaked
    noEmergencyVoteYet
    eligibleToEmergencyVote
  {
    emergencyVoted[msg.sender] = true;
    emergencyVoteAmount = emergencyVoteAmount.add(depositedDai[msg.sender]);
    emit EmergencyVote(msg.sender, depositedDai[msg.sender]);
  }

  /// @dev Internal function removing a users emergency vote if they leave the pool
  function _removeEmergencyVote() internal {
    if (emergencyVoted[msg.sender] == true) {
      emergencyVoted[msg.sender] = false;
      emergencyVoteAmount = emergencyVoteAmount.sub(depositedDai[msg.sender]);
      emit RemoveEmergencyVote(msg.sender, depositedDai[msg.sender]);
    }
  }
}