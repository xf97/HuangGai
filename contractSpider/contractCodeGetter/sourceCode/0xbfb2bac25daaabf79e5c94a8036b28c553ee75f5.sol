/**
 *Submitted for verification at Etherscan.io on 2020-07-23
*/

// File: contracts/spec_interfaces/IContractRegistry.sol

pragma solidity 0.5.16;

interface IContractRegistry {

	event ContractAddressUpdated(string contractName, address addr);

	/// @dev updates the contracts address and emits a corresponding event
	function set(string calldata contractName, address addr) external /* onlyGovernor */;

	/// @dev returns the current address of the
	function get(string calldata contractName) external view returns (address);
}

// File: contracts/spec_interfaces/ICommittee.sol

pragma solidity 0.5.16;


/// @title Elections contract interface
interface ICommittee {
	event GuardianCommitteeChange(address addr, uint256 weight, bool certification, bool inCommittee);
	event CommitteeSnapshot(address[] addrs, uint256[] weights, bool[] certification);

	// No external functions

	/*
     * Methods restricted to other Orbs contracts
     */

	/// @dev Called by: Elections contract
	/// Notifies a weight change for sorting to a relevant committee member.
    /// weight = 0 indicates removal of the member from the committee (for exmaple on unregister, voteUnready, voteOut)
	function memberWeightChange(address addr, uint256 weight) external returns (bool committeeChanged) /* onlyElectionContract */;

	/// @dev Called by: Elections contract
	/// Notifies a guardian certification change
	function memberCertificationChange(address addr, bool isCertified) external returns (bool committeeChanged) /* onlyElectionsContract */;

	/// @dev Called by: Elections contract
	/// Notifies a a member removal for exampl	e due to voteOut / voteUnready
	function removeMember(address addr) external returns (bool committeeChanged) /* onlyElectionContract */;

	/// @dev Called by: Elections contract
	/// Notifies a new member applicable for committee (due to registration, unbanning, certification change)
	function addMember(address addr, uint256 weight, bool isCertified) external returns (bool committeeChanged) /* onlyElectionsContract */;

	/// @dev Called by: Elections contract
	/// Returns the committee members and their weights
	function getCommittee() external view returns (address[] memory addrs, uint256[] memory weights, bool[] memory certification);

	/*
	 * Governance
	 */

	function setMaxTimeBetweenRewardAssignments(uint32 maxTimeBetweenRewardAssignments) external /* onlyFunctionalOwner onlyWhenActive */;
	function setMaxCommittee(uint8 maxCommitteeSize) external /* onlyFunctionalOwner onlyWhenActive */;

	event MaxTimeBetweenRewardAssignmentsChanged(uint32 newValue, uint32 oldValue);
	event MaxCommitteeSizeChanged(uint8 newValue, uint8 oldValue);

    /// @dev Updates the address calldata of the contract registry
	function setContractRegistry(IContractRegistry _contractRegistry) external /* onlyMigrationOwner */;

    /*
     * Getters
     */

    /// @dev returns the current committee
    /// used also by the rewards and fees contracts
	function getCommitteeInfo() external view returns (address[] memory addrs, uint256[] memory weights, address[] memory orbsAddrs, bool[] memory certification, bytes4[] memory ips);

	/// @dev returns the current settings of the committee contract
	function getSettings() external view returns (uint32 maxTimeBetweenRewardAssignments, uint8 maxCommitteeSize);
}

// File: contracts/spec_interfaces/IGuardiansRegistration.sol

pragma solidity 0.5.16;


/// @title Elections contract interface
interface IGuardiansRegistration {
	event GuardianRegistered(address addr);
	event GuardianDataUpdated(address addr, bytes4 ip, address orbsAddr, string name, string website, string contact);
	event GuardianUnregistered(address addr);
	event GuardianMetadataChanged(address addr, string key, string newValue, string oldValue);

	/*
     * External methods
     */

    /// @dev Called by a participant who wishes to register as a guardian
	function registerGuardian(bytes4 ip, address orbsAddr, string calldata name, string calldata website, string calldata contact) external;

    /// @dev Called by a participant who wishes to update its propertires
	function updateGuardian(bytes4 ip, address orbsAddr, string calldata name, string calldata website, string calldata contact) external;

	/// @dev Called by a participant who wishes to update its IP address (can be call by both main and Orbs addresses)
	function updateGuardianIp(bytes4 ip) external /* onlyWhenActive */;

    /// @dev Called by a participant to update additional guardian metadata properties.
    function setMetadata(string calldata key, string calldata value) external;

    /// @dev Called by a participant to get additional guardian metadata properties.
    function getMetadata(address addr, string calldata key) external view returns (string memory);

    /// @dev Called by a participant who wishes to unregister
	function unregisterGuardian() external;

    /// @dev Returns a guardian's data
    /// Used also by the Election contract
	function getGuardianData(address addr) external view returns (bytes4 ip, address orbsAddr, string memory name, string memory website, string memory contact, uint registration_time, uint last_update_time);

	/// @dev Returns the Orbs addresses of a list of guardians
	/// Used also by the committee contract
	function getGuardiansOrbsAddress(address[] calldata addrs) external view returns (address[] memory orbsAddrs);

	/// @dev Returns a guardian's ip
	/// Used also by the Election contract
	function getGuardianIp(address addr) external view returns (bytes4 ip);

	/// @dev Returns guardian ips
	function getGuardianIps(address[] calldata addr) external view returns (bytes4[] memory ips);


	/// @dev Returns true if the given address is of a registered guardian
	/// Used also by the Election contract
	function isRegistered(address addr) external view returns (bool);

	/*
     * Methods restricted to other Orbs contracts
     */

    /// @dev Translates a list guardians Ethereum addresses to Orbs addresses
    /// Used by the Election contract
	function getOrbsAddresses(address[] calldata ethereumAddrs) external view returns (address[] memory orbsAddr);

	/// @dev Translates a list guardians Orbs addresses to Ethereum addresses
	/// Used by the Election contract
	function getEthereumAddresses(address[] calldata orbsAddrs) external view returns (address[] memory ethereumAddr);

	/// @dev Resolves the ethereum address for a guardian, given an Ethereum/Orbs address
	function resolveGuardianAddress(address ethereumOrOrbsAddress) external view returns (address mainAddress);

}

// File: @openzeppelin/contracts/math/Math.sol

pragma solidity ^0.5.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// File: contracts/spec_interfaces/IProtocol.sol

pragma solidity 0.5.16;

interface IProtocol {
    event ProtocolVersionChanged(string deploymentSubset, uint256 currentVersion, uint256 nextVersion, uint256 fromTimestamp);

    /*
     *   External methods
     */

    /// @dev returns true if the given deployment subset exists (i.e - is registered with a protocol version)
    function deploymentSubsetExists(string calldata deploymentSubset) external view returns (bool);

    /// @dev returns the current protocol version for the given deployment subset.
    function getProtocolVersion(string calldata deploymentSubset) external view returns (uint256);

    /*
     *   Governor methods
     */

    /// @dev create a new deployment subset.
    function createDeploymentSubset(string calldata deploymentSubset, uint256 initialProtocolVersion) external /* onlyFunctionalOwner */;

    /// @dev schedules a protocol version upgrade for the given deployment subset.
    function setProtocolVersion(string calldata deploymentSubset, uint256 nextVersion, uint256 fromTimestamp) external /* onlyFunctionalOwner */;
}

// File: contracts/IStakeChangeNotifier.sol

pragma solidity 0.5.16;

/// @title An interface for notifying of stake change events (e.g., stake, unstake, partial unstake, restate, etc.).
interface IStakeChangeNotifier {
    /// @dev Notifies of stake change event.
    /// @param _stakeOwner address The address of the subject stake owner.
    /// @param _amount uint256 The difference in the total staked amount.
    /// @param _sign bool The sign of the added (true) or subtracted (false) amount.
    /// @param _updatedStake uint256 The updated total staked amount.
    function stakeChange(address _stakeOwner, uint256 _amount, bool _sign, uint256 _updatedStake) external;

    /// @dev Notifies of multiple stake change events.
    /// @param _stakeOwners address[] The addresses of subject stake owners.
    /// @param _amounts uint256[] The differences in total staked amounts.
    /// @param _signs bool[] The signs of the added (true) or subtracted (false) amounts.
    /// @param _updatedStakes uint256[] The updated total staked amounts.
    function stakeChangeBatch(address[] calldata _stakeOwners, uint256[] calldata _amounts, bool[] calldata _signs,
        uint256[] calldata _updatedStakes) external;

    /// @dev Notifies of stake migration event.
    /// @param _stakeOwner address The address of the subject stake owner.
    /// @param _amount uint256 The migrated amount.
    function stakeMigration(address _stakeOwner, uint256 _amount) external;
}

// File: contracts/interfaces/IElections.sol

pragma solidity 0.5.16;



/// @title Elections contract interface
interface IElections /* is IStakeChangeNotifier */ {
	// Election state change events
	event GuardianVotedUnready(address guardian);
	event GuardianVotedOut(address guardian);

	// Function calls
	event VoteUnreadyCasted(address voter, address subject);
	event VoteOutCasted(address voter, address subject);
	event StakeChanged(address addr, uint256 selfStake, uint256 delegated_stake, uint256 effective_stake);

	event GuardianStatusUpdated(address addr, bool readyToSync, bool readyForCommittee);

	// Governance
	event VoteUnreadyTimeoutSecondsChanged(uint32 newValue, uint32 oldValue);
	event MinSelfStakePercentMilleChanged(uint32 newValue, uint32 oldValue);
	event VoteOutPercentageThresholdChanged(uint8 newValue, uint8 oldValue);
	event VoteUnreadyPercentageThresholdChanged(uint8 newValue, uint8 oldValue);

	/*
	 * External methods
	 */

	/// @dev Called by a guardian as part of the automatic vote-out flow
	function voteUnready(address subject_addr) external;

	/// @dev casts a voteOut vote by the sender to the given address
	function voteOut(address subjectAddr) external;

	/// @dev Called by a guardian when ready to start syncing with other nodes
	function readyToSync() external;

	/// @dev Called by a guardian when ready to join the committee, typically after syncing is complete or after being voted out
	function readyForCommittee() external;

	/*
	 * Methods restricted to other Orbs contracts
	 */

	/// @dev Called by: delegation contract
	/// Notifies a delegated stake change event
	/// total_delegated_stake = 0 if addr delegates to another guardian
	function delegatedStakeChange(address addr, uint256 selfStake, uint256 delegatedStake, uint256 totalDelegatedStake) external /* onlyDelegationContract */;

	/// @dev Called by: guardian registration contract
	/// Notifies a new guardian was registered
	function guardianRegistered(address addr) external /* onlyGuardiansRegistrationContract */;

	/// @dev Called by: guardian registration contract
	/// Notifies a new guardian was unregistered
	function guardianUnregistered(address addr) external /* onlyGuardiansRegistrationContract */;

	/// @dev Called by: guardian registration contract
	/// Notifies on a guardian certification change
	function guardianCertificationChanged(address addr, bool isCertified) external /* onlyCertificationContract */;

	/*
     * Governance
	 */

	/// @dev Updates the address of the contract registry
	function setContractRegistry(IContractRegistry _contractRegistry) external /* onlyMigrationOwner */;

	function setVoteUnreadyTimeoutSeconds(uint32 voteUnreadyTimeoutSeconds) external /* onlyFunctionalOwner onlyWhenActive */;
	function setMinSelfStakePercentMille(uint32 minSelfStakePercentMille) external /* onlyFunctionalOwner onlyWhenActive */;
	function setVoteOutPercentageThreshold(uint8 voteUnreadyPercentageThreshold) external /* onlyFunctionalOwner onlyWhenActive */;
	function setVoteUnreadyPercentageThreshold(uint8 voteUnreadyPercentageThreshold) external /* onlyFunctionalOwner onlyWhenActive */;
	function getSettings() external view returns (
		uint32 voteUnreadyTimeoutSeconds,
		uint32 minSelfStakePercentMille,
		uint8 voteUnreadyPercentageThreshold,
		uint8 voteOutPercentageThreshold
	);
}

// File: contracts/spec_interfaces/ICertification.sol

pragma solidity 0.5.16;



/// @title Elections contract interface
interface ICertification /* is Ownable */ {
	event GuardianCertificationUpdate(address guardian, bool isCertified);

	/*
     * External methods
     */

    /// @dev Called by a guardian as part of the automatic vote unready flow
    /// Used by the Election contract
	function isGuardianCertified(address addr) external view returns (bool isCertified);

    /// @dev Called by a guardian as part of the automatic vote unready flow
    /// Used by the Election contract
	function setGuardianCertification(address addr, bool isCertified) external /* Owner only */ ;

	/*
	 * Governance
	 */

    /// @dev Updates the address calldata of the contract registry
	function setContractRegistry(IContractRegistry _contractRegistry) external /* onlyMigrationOwner */;

}

// File: contracts/spec_interfaces/ISubscriptions.sol

pragma solidity 0.5.16;


/// @title Subscriptions contract interface
interface ISubscriptions {
    event SubscriptionChanged(uint256 vcid, uint256 genRefTime, uint256 expiresAt, string tier, string deploymentSubset);
    event Payment(uint256 vcid, address by, uint256 amount, string tier, uint256 rate);
    event VcConfigRecordChanged(uint256 vcid, string key, string value);
    event SubscriberAdded(address subscriber);
    event VcCreated(uint256 vcid, address owner); // TODO what about isCertified, deploymentSubset?
    event VcOwnerChanged(uint256 vcid, address previousOwner, address newOwner);

    /*
     *   Methods restricted to other Orbs contracts
     */

    /// @dev Called by: authorized subscriber (plan) contracts
    /// Creates a new VC
    function createVC(string calldata tier, uint256 rate, uint256 amount, address owner, bool isCertified, string calldata deploymentSubset) external returns (uint, uint);

    /// @dev Called by: authorized subscriber (plan) contracts
    /// Extends the subscription of an existing VC.
    function extendSubscription(uint256 vcid, uint256 amount, address payer) external;

    /// @dev called by VC owner to set a VC config record. Emits a VcConfigRecordChanged event.
    function setVcConfigRecord(uint256 vcid, string calldata key, string calldata value) external /* onlyVcOwner */;

    /// @dev returns the value of a VC config record
    function getVcConfigRecord(uint256 vcid, string calldata key) external view returns (string memory);

    /// @dev Transfers VC ownership to a new owner (can only be called by the current owner)
    function setVcOwner(uint256 vcid, address owner) external /* onlyVcOwner */;

    /// @dev Returns the genesis ref time delay
    function getGenesisRefTimeDelay() external view returns (uint256);

    /*
     *   Governance methods
     */

    /// @dev Called by the owner to authorize a subscriber (plan)
    function addSubscriber(address addr) external /* onlyFunctionalOwner */;

    /// @dev Called by the owner to set the genesis ref time delay
    function setGenesisRefTimeDelay(uint256 newGenesisRefTimeDelay) external /* onlyFunctionalOwner */;

    /// @dev Updates the address of the contract registry
    function setContractRegistry(IContractRegistry _contractRegistry) external /* onlyMigrationOwner */;

}

// File: contracts/spec_interfaces/IDelegation.sol

pragma solidity 0.5.16;


/// @title Elections contract interface
interface IDelegations /* is IStakeChangeNotifier */ {
    // Delegation state change events
	event DelegatedStakeChanged(address indexed addr, uint256 selfDelegatedStake, uint256 delegatedStake, address[] delegators, uint256[] delegatorTotalStakes);

    // Function calls
	event Delegated(address indexed from, address indexed to);

	/*
     * External methods
     */

	/// @dev Stake delegation
	function delegate(address to) external /* onlyWhenActive */;

	function refreshStakeNotification(address addr) external /* onlyWhenActive */;

	/*
	 * Governance
	 */

    /// @dev Updates the address calldata of the contract registry
	function setContractRegistry(IContractRegistry _contractRegistry) external /* onlyMigrationOwner */;

	function importDelegations(address[] calldata from, address[] calldata to, bool notifyElections) external /* onlyMigrationOwner onlyDuringDelegationImport */;
	function finalizeDelegationImport() external /* onlyMigrationOwner onlyDuringDelegationImport */;

	event DelegationsImported(address[] from, address[] to, bool notifiedElections);
	event DelegationImportFinalized();

	/*
	 * Getters
	 */

	function getDelegatedStakes(address addr) external view returns (uint256);
	function getSelfDelegatedStake(address addr) external view returns (uint256);
	function getDelegation(address addr) external view returns (address);
	function getTotalDelegatedStake() external view returns (uint256) ;


}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/IMigratableStakingContract.sol

pragma solidity 0.5.16;


/// @title An interface for staking contracts which support stake migration.
interface IMigratableStakingContract {
    /// @dev Returns the address of the underlying staked token.
    /// @return IERC20 The address of the token.
    function getToken() external view returns (IERC20);

    /// @dev Stakes ORBS tokens on behalf of msg.sender. This method assumes that the user has already approved at least
    /// the required amount using ERC20 approve.
    /// @param _stakeOwner address The specified stake owner.
    /// @param _amount uint256 The number of tokens to stake.
    function acceptMigration(address _stakeOwner, uint256 _amount) external;

    event AcceptedMigration(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
}

// File: contracts/IStakingContract.sol

pragma solidity 0.5.16;


/// @title An interface for staking contracts.
interface IStakingContract {
    /// @dev Stakes ORBS tokens on behalf of msg.sender. This method assumes that the user has already approved at least
    /// the required amount using ERC20 approve.
    /// @param _amount uint256 The amount of tokens to stake.
    function stake(uint256 _amount) external;

    /// @dev Unstakes ORBS tokens from msg.sender. If successful, this will start the cooldown period, after which
    /// msg.sender would be able to withdraw all of his tokens.
    /// @param _amount uint256 The amount of tokens to unstake.
    function unstake(uint256 _amount) external;

    /// @dev Requests to withdraw all of staked ORBS tokens back to msg.sender. Stake owners can withdraw their ORBS
    /// tokens only after previously unstaking them and after the cooldown period has passed (unless the contract was
    /// requested to release all stakes).
    function withdraw() external;

    /// @dev Restakes unstaked ORBS tokens (in or after cooldown) for msg.sender.
    function restake() external;

    /// @dev Distributes staking rewards to a list of addresses by directly adding rewards to their stakes. This method
    /// assumes that the user has already approved at least the required amount using ERC20 approve. Since this is a
    /// convenience method, we aren't concerned about reaching block gas limit by using large lists. We assume that
    /// callers will be able to properly batch/paginate their requests.
    /// @param _totalAmount uint256 The total amount of rewards to distributes.
    /// @param _stakeOwners address[] The addresses of the stake owners.
    /// @param _amounts uint256[] The amounts of the rewards.
    function distributeRewards(uint256 _totalAmount, address[] calldata _stakeOwners, uint256[] calldata _amounts) external;

    /// @dev Returns the stake of the specified stake owner (excluding unstaked tokens).
    /// @param _stakeOwner address The address to check.
    /// @return uint256 The total stake.
    function getStakeBalanceOf(address _stakeOwner) external view returns (uint256);

    /// @dev Returns the total amount staked tokens (excluding unstaked tokens).
    /// @return uint256 The total staked tokens of all stake owners.
    function getTotalStakedTokens() external view returns (uint256);

    /// @dev Returns the time that the cooldown period ends (or ended) and the amount of tokens to be released.
    /// @param _stakeOwner address The address to check.
    /// @return cooldownAmount uint256 The total tokens in cooldown.
    /// @return cooldownEndTime uint256 The time when the cooldown period ends (in seconds).
    function getUnstakeStatus(address _stakeOwner) external view returns (uint256 cooldownAmount,
        uint256 cooldownEndTime);

    /// @dev Migrates the stake of msg.sender from this staking contract to a new approved staking contract.
    /// @param _newStakingContract IMigratableStakingContract The new staking contract which supports stake migration.
    /// @param _amount uint256 The amount of tokens to migrate.
    function migrateStakedTokens(IMigratableStakingContract _newStakingContract, uint256 _amount) external;

    event Staked(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
    event Unstaked(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
    event Withdrew(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
    event Restaked(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
    event MigratedStake(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
}

// File: contracts/interfaces/IRewards.sol

pragma solidity 0.5.16;



/// @title Rewards contract interface
interface IRewards {

    function assignRewards() external;
    function assignRewardsToCommittee(address[] calldata generalCommittee, uint256[] calldata generalCommitteeWeights, bool[] calldata certification) external /* onlyCommitteeContract */;

    // staking

    event StakingRewardsDistributed(address indexed distributer, uint256 fromBlock, uint256 toBlock, uint split, uint txIndex, address[] to, uint256[] amounts);
    event StakingRewardsAssigned(address[] assignees, uint256[] amounts); // todo balance?
    event StakingRewardsAddedToPool(uint256 added, uint256 total);
    event MaxDelegatorsStakingRewardsChanged(uint32 maxDelegatorsStakingRewardsPercentMille);

    /// @return Returns the currently unclaimed orbs token reward balance of the given address.
    function getStakingRewardBalance(address addr) external view returns (uint256 balance);

    /// @dev Distributes msg.sender's orbs token rewards to a list of addresses, by transferring directly into the staking contract.
    /// @dev `to[0]` must be the sender's main address
    /// @dev Total delegators reward (`to[1:n]`) must be less then maxDelegatorsStakingRewardsPercentMille of total amount
    function distributeOrbsTokenStakingRewards(uint256 totalAmount, uint256 fromBlock, uint256 toBlock, uint split, uint txIndex, address[] calldata to, uint256[] calldata amounts) external;

    /// @dev Transfers the given amount of orbs tokens form the sender to this contract an update the pool.
    function topUpStakingRewardsPool(uint256 amount) external;

    /*
    *   Reward-governor methods
    */

    /// @dev Assigns rewards and sets a new monthly rate for the pro-rata pool.
    function setAnnualStakingRewardsRate(uint256 annual_rate_in_percent_mille, uint256 annual_cap) external /* onlyFunctionalOwner */;


    // fees

    event FeesAssigned(uint256 generalGuardianAmount, uint256 certifiedGuardianAmount);
    event FeesWithdrawn(address guardian, uint256 amount);
    event FeesWithdrawnFromBucket(uint256 bucketId, uint256 withdrawn, uint256 total, bool isCertified);
    event FeesAddedToBucket(uint256 bucketId, uint256 added, uint256 total, bool isCertified);

    /*
     *   External methods
     */

    /// @return Returns the currently unclaimed orbs token reward balance of the given address.
    function getFeeBalance(address addr) external view returns (uint256 balance);

    /// @dev Transfer all of msg.sender's outstanding balance to their account
    function withdrawFeeFunds() external;

    /// @dev Called by: subscriptions contract
    /// Top-ups the certification fee pool with the given amount at the given rate (typically called by the subscriptions contract)
    function fillCertificationFeeBuckets(uint256 amount, uint256 monthlyRate, uint256 fromTimestamp) external;

    /// @dev Called by: subscriptions contract
    /// Top-ups the general fee pool with the given amount at the given rate (typically called by the subscriptions contract)
    function fillGeneralFeeBuckets(uint256 amount, uint256 monthlyRate, uint256 fromTimestamp) external;

    function getTotalBalances() external view returns (uint256 feesTotalBalance, uint256 stakingRewardsTotalBalance, uint256 bootstrapRewardsTotalBalance);

    // bootstrap

    event BootstrapRewardsAssigned(uint256 generalGuardianAmount, uint256 certifiedGuardianAmount);
    event BootstrapAddedToPool(uint256 added, uint256 total);
    event BootstrapRewardsWithdrawn(address guardian, uint256 amount);

    /*
     *   External methods
     */

    /// @return Returns the currently unclaimed bootstrap balance of the given address.
    function getBootstrapBalance(address addr) external view returns (uint256 balance);

    /// @dev Transfer all of msg.sender's outstanding balance to their account
    function withdrawBootstrapFunds() external;

    /// @return The timestamp of the last reward assignment.
    function getLastRewardAssignmentTime() external view returns (uint256 time);

    /// @dev Transfers the given amount of bootstrap tokens form the sender to this contract and update the pool.
    /// Assumes the tokens were approved for transfer
    function topUpBootstrapPool(uint256 amount) external;

    /*
     * Reward-governor methods
     */

    /// @dev Assigns rewards and sets a new monthly rate for the geenral commitee bootstrap.
    function setGeneralCommitteeAnnualBootstrap(uint256 annual_amount) external /* onlyFunctionalOwner */;

    /// @dev Assigns rewards and sets a new monthly rate for the certification commitee bootstrap.
    function setCertificationCommitteeAnnualBootstrap(uint256 annual_amount) external /* onlyFunctionalOwner */;

    event EmergencyWithdrawal(address addr);

    function emergencyWithdraw() external /* onlyMigrationManager */;

    /*
     * General governance
     */

    /// @dev Updates the address of the contract registry
    function setContractRegistry(IContractRegistry _contractRegistry) external /* onlyMigrationOwner */;


}

// File: @openzeppelin/contracts/GSN/Context.sol

pragma solidity ^0.5.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: contracts/WithClaimableMigrationOwnership.sol

pragma solidity 0.5.16;


/**
 * @title Claimable
 * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
 * This allows the new owner to accept the transfer.
 */
contract WithClaimableMigrationOwnership is Context{
    address private _migrationOwner;
    address pendingMigrationOwner;

    event MigrationOwnershipTransferred(address indexed previousMigrationOwner, address indexed newMigrationOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial migrationMigrationOwner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _migrationOwner = msgSender;
        emit MigrationOwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current migrationOwner.
     */
    function migrationOwner() public view returns (address) {
        return _migrationOwner;
    }

    /**
     * @dev Throws if called by any account other than the migrationOwner.
     */
    modifier onlyMigrationOwner() {
        require(isMigrationOwner(), "WithClaimableMigrationOwnership: caller is not the migrationOwner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current migrationOwner.
     */
    function isMigrationOwner() public view returns (bool) {
        return _msgSender() == _migrationOwner;
    }

    /**
     * @dev Leaves the contract without migrationOwner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current migrationOwner.
     *
     * NOTE: Renouncing migrationOwnership will leave the contract without an migrationOwner,
     * thereby removing any functionality that is only available to the migrationOwner.
     */
    function renounceMigrationOwnership() public onlyMigrationOwner {
        emit MigrationOwnershipTransferred(_migrationOwner, address(0));
        _migrationOwner = address(0);
    }

    /**
     * @dev Transfers migrationOwnership of the contract to a new account (`newOwner`).
     */
    function _transferMigrationOwnership(address newMigrationOwner) internal {
        require(newMigrationOwner != address(0), "MigrationOwner: new migrationOwner is the zero address");
        emit MigrationOwnershipTransferred(_migrationOwner, newMigrationOwner);
        _migrationOwner = newMigrationOwner;
    }

    /**
     * @dev Modifier throws if called by any account other than the pendingOwner.
     */
    modifier onlyPendingMigrationOwner() {
        require(msg.sender == pendingMigrationOwner, "Caller is not the pending migrationOwner");
        _;
    }
    /**
     * @dev Allows the current migrationOwner to set the pendingOwner address.
     * @param newMigrationOwner The address to transfer migrationOwnership to.
     */
    function transferMigrationOwnership(address newMigrationOwner) public onlyMigrationOwner {
        pendingMigrationOwner = newMigrationOwner;
    }
    /**
     * @dev Allows the pendingMigrationOwner address to finalize the transfer.
     */
    function claimMigrationOwnership() external onlyPendingMigrationOwner {
        _transferMigrationOwnership(pendingMigrationOwner);
        pendingMigrationOwner = address(0);
    }
}

// File: contracts/Lockable.sol

pragma solidity 0.5.16;



/**
 * @title Claimable
 * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
 * This allows the new owner to accept the transfer.
 */
contract Lockable is WithClaimableMigrationOwnership {

    bool public locked;

    event Locked();
    event Unlocked();

    function lock() external onlyMigrationOwner {
        locked = true;
        emit Locked();
    }

    function unlock() external onlyMigrationOwner {
        locked = false;
        emit Unlocked();
    }

    modifier onlyWhenActive() {
        require(!locked, "contract is locked for this operation");

        _;
    }
}

// File: contracts/spec_interfaces/IProtocolWallet.sol

pragma solidity 0.5.16;



pragma solidity 0.5.16;

/// @title Protocol Wallet interface
interface IProtocolWallet {
    event FundsAddedToPool(uint256 added, uint256 total);
    event ClientSet(address client);
    event MaxAnnualRateSet(uint256 maxAnnualRate);
    event EmergencyWithdrawal(address addr);

    /// @dev Returns the address of the underlying staked token.
    /// @return IERC20 The address of the token.
    function getToken() external view returns (IERC20);

    /// @dev Returns the address of the underlying staked token.
    /// @return IERC20 The address of the token.
    function getBalance() external view returns (uint256 balance);

    /// @dev Transfers the given amount of orbs tokens form the sender to this contract an update the pool.
    function topUp(uint256 amount) external;

    /// @dev Withdraw from pool to a the sender's address, limited by the pool's MaxRate.
    /// A maximum of MaxRate x time period since the last Orbs transfer may be transferred out.
    /// Flow:
    /// PoolWallet.approveTransfer(amount);
    /// ERC20.transferFrom(PoolWallet, client, amount)
    function withdraw(uint256 amount) external; /* onlyClient */

    /* Governance */
    /// @dev Sets a new transfer rate for the Orbs pool.
    function setMaxAnnualRate(uint256 annual_rate) external; /* onlyMigrationManager */

    /// @dev transfer the entire pool's balance to a new wallet.
    function emergencyWithdraw() external; /* onlyMigrationManager */

    /// @dev sets the address of the new contract
    function setClient(address client) external; /* onlyFunctionalManager */
}

// File: contracts/ContractRegistryAccessor.sol

pragma solidity 0.5.16;













contract ContractRegistryAccessor is WithClaimableMigrationOwnership {

    IContractRegistry contractRegistry;

    event ContractRegistryAddressUpdated(address addr);

    function setContractRegistry(IContractRegistry _contractRegistry) external onlyMigrationOwner {
        contractRegistry = _contractRegistry;
        emit ContractRegistryAddressUpdated(address(_contractRegistry));
    }

    function getProtocolContract() public view returns (IProtocol) {
        return IProtocol(contractRegistry.get("protocol"));
    }

    function getRewardsContract() public view returns (IRewards) {
        return IRewards(contractRegistry.get("rewards"));
    }

    function getCommitteeContract() public view returns (ICommittee) {
        return ICommittee(contractRegistry.get("committee"));
    }

    function getElectionsContract() public view returns (IElections) {
        return IElections(contractRegistry.get("elections"));
    }

    function getDelegationsContract() public view returns (IDelegations) {
        return IDelegations(contractRegistry.get("delegations"));
    }

    function getGuardiansRegistrationContract() public view returns (IGuardiansRegistration) {
        return IGuardiansRegistration(contractRegistry.get("guardiansRegistration"));
    }

    function getCertificationContract() public view returns (ICertification) {
        return ICertification(contractRegistry.get("certification"));
    }

    function getStakingContract() public view returns (IStakingContract) {
        return IStakingContract(contractRegistry.get("staking"));
    }

    function getSubscriptionsContract() public view returns (ISubscriptions) {
        return ISubscriptions(contractRegistry.get("subscriptions"));
    }

    function getStakingRewardsWallet() public view returns (IProtocolWallet) {
        return IProtocolWallet(contractRegistry.get("stakingRewardsWallet"));
    }

    function getBootstrapRewardsWallet() public view returns (IProtocolWallet) {
        return IProtocolWallet(contractRegistry.get("bootstrapRewardsWallet"));
    }

}

// File: contracts/WithClaimableFunctionalOwnership.sol

pragma solidity 0.5.16;


/**
 * @title Claimable
 * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
 * This allows the new owner to accept the transfer.
 */
contract WithClaimableFunctionalOwnership is Context{
    address private _functionalOwner;
    address pendingFunctionalOwner;

    event FunctionalOwnershipTransferred(address indexed previousFunctionalOwner, address indexed newFunctionalOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial functionalFunctionalOwner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _functionalOwner = msgSender;
        emit FunctionalOwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current functionalOwner.
     */
    function functionalOwner() public view returns (address) {
        return _functionalOwner;
    }

    /**
     * @dev Throws if called by any account other than the functionalOwner.
     */
    modifier onlyFunctionalOwner() {
        require(isFunctionalOwner(), "WithClaimableFunctionalOwnership: caller is not the functionalOwner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current functionalOwner.
     */
    function isFunctionalOwner() public view returns (bool) {
        return _msgSender() == _functionalOwner;
    }

    /**
     * @dev Leaves the contract without functionalOwner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current functionalOwner.
     *
     * NOTE: Renouncing functionalOwnership will leave the contract without an functionalOwner,
     * thereby removing any functionality that is only available to the functionalOwner.
     */
    function renounceFunctionalOwnership() public onlyFunctionalOwner {
        emit FunctionalOwnershipTransferred(_functionalOwner, address(0));
        _functionalOwner = address(0);
    }

    /**
     * @dev Transfers functionalOwnership of the contract to a new account (`newOwner`).
     */
    function _transferFunctionalOwnership(address newFunctionalOwner) internal {
        require(newFunctionalOwner != address(0), "FunctionalOwner: new functionalOwner is the zero address");
        emit FunctionalOwnershipTransferred(_functionalOwner, newFunctionalOwner);
        _functionalOwner = newFunctionalOwner;
    }

    /**
     * @dev Modifier throws if called by any account other than the pendingOwner.
     */
    modifier onlyPendingFunctionalOwner() {
        require(msg.sender == pendingFunctionalOwner, "Caller is not the pending functionalOwner");
        _;
    }
    /**
     * @dev Allows the current functionalOwner to set the pendingOwner address.
     * @param newFunctionalOwner The address to transfer functionalOwnership to.
     */
    function transferFunctionalOwnership(address newFunctionalOwner) public onlyFunctionalOwner {
        pendingFunctionalOwner = newFunctionalOwner;
    }
    /**
     * @dev Allows the pendingFunctionalOwner address to finalize the transfer.
     */
    function claimFunctionalOwnership() external onlyPendingFunctionalOwner {
        _transferFunctionalOwnership(pendingFunctionalOwner);
        pendingFunctionalOwner = address(0);
    }
}

// File: solidity-bytes-utils/contracts/BytesLib.sol

/*
 * @title Solidity Bytes Arrays Utils
 * @author Gonçalo Sá <goncalo.sa@consensys.net>
 *
 * @dev Bytes tightly packed arrays utility library for ethereum contracts written in Solidity.
 *      The library lets you concatenate, slice and type cast bytes arrays both in memory and storage.
 */

pragma solidity ^0.5.0;


library BytesLib {
    function concat(
        bytes memory _preBytes,
        bytes memory _postBytes
    )
        internal
        pure
        returns (bytes memory)
    {
        bytes memory tempBytes;

        assembly {
            // Get a location of some free memory and store it in tempBytes as
            // Solidity does for memory variables.
            tempBytes := mload(0x40)

            // Store the length of the first bytes array at the beginning of
            // the memory for tempBytes.
            let length := mload(_preBytes)
            mstore(tempBytes, length)

            // Maintain a memory counter for the current write location in the
            // temp bytes array by adding the 32 bytes for the array length to
            // the starting location.
            let mc := add(tempBytes, 0x20)
            // Stop copying when the memory counter reaches the length of the
            // first bytes array.
            let end := add(mc, length)

            for {
                // Initialize a copy counter to the start of the _preBytes data,
                // 32 bytes into its memory.
                let cc := add(_preBytes, 0x20)
            } lt(mc, end) {
                // Increase both counters by 32 bytes each iteration.
                mc := add(mc, 0x20)
                cc := add(cc, 0x20)
            } {
                // Write the _preBytes data into the tempBytes memory 32 bytes
                // at a time.
                mstore(mc, mload(cc))
            }

            // Add the length of _postBytes to the current length of tempBytes
            // and store it as the new length in the first 32 bytes of the
            // tempBytes memory.
            length := mload(_postBytes)
            mstore(tempBytes, add(length, mload(tempBytes)))

            // Move the memory counter back from a multiple of 0x20 to the
            // actual end of the _preBytes data.
            mc := end
            // Stop copying when the memory counter reaches the new combined
            // length of the arrays.
            end := add(mc, length)

            for {
                let cc := add(_postBytes, 0x20)
            } lt(mc, end) {
                mc := add(mc, 0x20)
                cc := add(cc, 0x20)
            } {
                mstore(mc, mload(cc))
            }

            // Update the free-memory pointer by padding our last write location
            // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
            // next 32 byte block, then round down to the nearest multiple of
            // 32. If the sum of the length of the two arrays is zero then add 
            // one before rounding down to leave a blank 32 bytes (the length block with 0).
            mstore(0x40, and(
              add(add(end, iszero(add(length, mload(_preBytes)))), 31),
              not(31) // Round down to the nearest 32 bytes.
            ))
        }

        return tempBytes;
    }

    function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
        assembly {
            // Read the first 32 bytes of _preBytes storage, which is the length
            // of the array. (We don't need to use the offset into the slot
            // because arrays use the entire slot.)
            let fslot := sload(_preBytes_slot)
            // Arrays of 31 bytes or less have an even value in their slot,
            // while longer arrays have an odd value. The actual length is
            // the slot divided by two for odd values, and the lowest order
            // byte divided by two for even values.
            // If the slot is even, bitwise and the slot with 255 and divide by
            // two to get the length. If the slot is odd, bitwise and the slot
            // with -1 and divide by two.
            let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
            let mlength := mload(_postBytes)
            let newlength := add(slength, mlength)
            // slength can contain both the length and contents of the array
            // if length < 32 bytes so let's prepare for that
            // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
            switch add(lt(slength, 32), lt(newlength, 32))
            case 2 {
                // Since the new array still fits in the slot, we just need to
                // update the contents of the slot.
                // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
                sstore(
                    _preBytes_slot,
                    // all the modifications to the slot are inside this
                    // next block
                    add(
                        // we can just add to the slot contents because the
                        // bytes we want to change are the LSBs
                        fslot,
                        add(
                            mul(
                                div(
                                    // load the bytes from memory
                                    mload(add(_postBytes, 0x20)),
                                    // zero all bytes to the right
                                    exp(0x100, sub(32, mlength))
                                ),
                                // and now shift left the number of bytes to
                                // leave space for the length in the slot
                                exp(0x100, sub(32, newlength))
                            ),
                            // increase length by the double of the memory
                            // bytes length
                            mul(mlength, 2)
                        )
                    )
                )
            }
            case 1 {
                // The stored value fits in the slot, but the combined value
                // will exceed it.
                // get the keccak hash to get the contents of the array
                mstore(0x0, _preBytes_slot)
                let sc := add(keccak256(0x0, 0x20), div(slength, 32))

                // save new length
                sstore(_preBytes_slot, add(mul(newlength, 2), 1))

                // The contents of the _postBytes array start 32 bytes into
                // the structure. Our first read should obtain the `submod`
                // bytes that can fit into the unused space in the last word
                // of the stored array. To get this, we read 32 bytes starting
                // from `submod`, so the data we read overlaps with the array
                // contents by `submod` bytes. Masking the lowest-order
                // `submod` bytes allows us to add that value directly to the
                // stored value.

                let submod := sub(32, slength)
                let mc := add(_postBytes, submod)
                let end := add(_postBytes, mlength)
                let mask := sub(exp(0x100, submod), 1)

                sstore(
                    sc,
                    add(
                        and(
                            fslot,
                            0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
                        ),
                        and(mload(mc), mask)
                    )
                )

                for {
                    mc := add(mc, 0x20)
                    sc := add(sc, 1)
                } lt(mc, end) {
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } {
                    sstore(sc, mload(mc))
                }

                mask := exp(0x100, sub(mc, end))

                sstore(sc, mul(div(mload(mc), mask), mask))
            }
            default {
                // get the keccak hash to get the contents of the array
                mstore(0x0, _preBytes_slot)
                // Start copying to the last used word of the stored array.
                let sc := add(keccak256(0x0, 0x20), div(slength, 32))

                // save new length
                sstore(_preBytes_slot, add(mul(newlength, 2), 1))

                // Copy over the first `submod` bytes of the new data as in
                // case 1 above.
                let slengthmod := mod(slength, 32)
                let mlengthmod := mod(mlength, 32)
                let submod := sub(32, slengthmod)
                let mc := add(_postBytes, submod)
                let end := add(_postBytes, mlength)
                let mask := sub(exp(0x100, submod), 1)

                sstore(sc, add(sload(sc), and(mload(mc), mask)))
                
                for { 
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } lt(mc, end) {
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } {
                    sstore(sc, mload(mc))
                }

                mask := exp(0x100, sub(mc, end))

                sstore(sc, mul(div(mload(mc), mask), mask))
            }
        }
    }

    function slice(
        bytes memory _bytes,
        uint _start,
        uint _length
    )
        internal
        pure
        returns (bytes memory)
    {
        require(_bytes.length >= (_start + _length));

        bytes memory tempBytes;

        assembly {
            switch iszero(_length)
            case 0 {
                // Get a location of some free memory and store it in tempBytes as
                // Solidity does for memory variables.
                tempBytes := mload(0x40)

                // The first word of the slice result is potentially a partial
                // word read from the original array. To read it, we calculate
                // the length of that partial word and start copying that many
                // bytes into the array. The first word we copy will start with
                // data we don't care about, but the last `lengthmod` bytes will
                // land at the beginning of the contents of the new array. When
                // we're done copying, we overwrite the full first word with
                // the actual length of the slice.
                let lengthmod := and(_length, 31)

                // The multiplication in the next line is necessary
                // because when slicing multiples of 32 bytes (lengthmod == 0)
                // the following copy loop was copying the origin's length
                // and then ending prematurely not copying everything it should.
                let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
                let end := add(mc, _length)

                for {
                    // The multiplication in the next line has the same exact purpose
                    // as the one above.
                    let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
                } lt(mc, end) {
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } {
                    mstore(mc, mload(cc))
                }

                mstore(tempBytes, _length)

                //update free-memory pointer
                //allocating the array padded to 32 bytes like the compiler does now
                mstore(0x40, and(add(mc, 31), not(31)))
            }
            //if we want a zero-length slice let's just return a zero-length array
            default {
                tempBytes := mload(0x40)

                mstore(0x40, add(tempBytes, 0x20))
            }
        }

        return tempBytes;
    }

    function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
        require(_bytes.length >= (_start + 20));
        address tempAddress;

        assembly {
            tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
        }

        return tempAddress;
    }

    function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
        require(_bytes.length >= (_start + 1));
        uint8 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x1), _start))
        }

        return tempUint;
    }

    function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
        require(_bytes.length >= (_start + 2));
        uint16 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x2), _start))
        }

        return tempUint;
    }

    function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
        require(_bytes.length >= (_start + 4));
        uint32 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x4), _start))
        }

        return tempUint;
    }

    function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
        require(_bytes.length >= (_start + 8));
        uint64 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x8), _start))
        }

        return tempUint;
    }

    function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
        require(_bytes.length >= (_start + 12));
        uint96 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0xc), _start))
        }

        return tempUint;
    }

    function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
        require(_bytes.length >= (_start + 16));
        uint128 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x10), _start))
        }

        return tempUint;
    }

    function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
        require(_bytes.length >= (_start + 32));
        uint256 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x20), _start))
        }

        return tempUint;
    }

    function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
        require(_bytes.length >= (_start + 32));
        bytes32 tempBytes32;

        assembly {
            tempBytes32 := mload(add(add(_bytes, 0x20), _start))
        }

        return tempBytes32;
    }

    function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
        bool success = true;

        assembly {
            let length := mload(_preBytes)

            // if lengths don't match the arrays are not equal
            switch eq(length, mload(_postBytes))
            case 1 {
                // cb is a circuit breaker in the for loop since there's
                //  no said feature for inline assembly loops
                // cb = 1 - don't breaker
                // cb = 0 - break
                let cb := 1

                let mc := add(_preBytes, 0x20)
                let end := add(mc, length)

                for {
                    let cc := add(_postBytes, 0x20)
                // the next line is the loop condition:
                // while(uint(mc < end) + cb == 2)
                } eq(add(lt(mc, end), cb), 2) {
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } {
                    // if any of these checks fails then arrays are not equal
                    if iszero(eq(mload(mc), mload(cc))) {
                        // unsuccess:
                        success := 0
                        cb := 0
                    }
                }
            }
            default {
                // unsuccess:
                success := 0
            }
        }

        return success;
    }

    function equalStorage(
        bytes storage _preBytes,
        bytes memory _postBytes
    )
        internal
        view
        returns (bool)
    {
        bool success = true;

        assembly {
            // we know _preBytes_offset is 0
            let fslot := sload(_preBytes_slot)
            // Decode the length of the stored array like in concatStorage().
            let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
            let mlength := mload(_postBytes)

            // if lengths don't match the arrays are not equal
            switch eq(slength, mlength)
            case 1 {
                // slength can contain both the length and contents of the array
                // if length < 32 bytes so let's prepare for that
                // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
                if iszero(iszero(slength)) {
                    switch lt(slength, 32)
                    case 1 {
                        // blank the last byte which is the length
                        fslot := mul(div(fslot, 0x100), 0x100)

                        if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
                            // unsuccess:
                            success := 0
                        }
                    }
                    default {
                        // cb is a circuit breaker in the for loop since there's
                        //  no said feature for inline assembly loops
                        // cb = 1 - don't breaker
                        // cb = 0 - break
                        let cb := 1

                        // get the keccak hash to get the contents of the array
                        mstore(0x0, _preBytes_slot)
                        let sc := keccak256(0x0, 0x20)

                        let mc := add(_postBytes, 0x20)
                        let end := add(mc, mlength)

                        // the next line is the loop condition:
                        // while(uint(mc < end) + cb == 2)
                        for {} eq(add(lt(mc, end), cb), 2) {
                            sc := add(sc, 1)
                            mc := add(mc, 0x20)
                        } {
                            if iszero(eq(sload(sc), mload(mc))) {
                                // unsuccess:
                                success := 0
                                cb := 0
                            }
                        }
                    }
                }
            }
            default {
                // unsuccess:
                success := 0
            }
        }

        return success;
    }
}

// File: ../contracts/Committee.sol

pragma solidity 0.5.16;







/// @title Elections contract interface
contract Committee is ICommittee, ContractRegistryAccessor, WithClaimableFunctionalOwnership, Lockable {
	using BytesLib for bytes;

	uint constant MAX_COMMITTEE_ARRAY_SIZE = 32; // Cannot be greater than 32 (number of bytes in bytes32)

	struct CommitteeMember {
		address addr;
		uint96 weight;
	}
	CommitteeMember[] public committee;

	struct MemberData {
		uint96 weight;
		uint8 pos;
		bool isMember;
		bool isCertified;

		bool inCommittee;
	}
	mapping (address => MemberData) membersData;

	// Derived properties
	struct CommitteeInfo {
		uint32 committeeBitmap; // TODO redundant, sort bytes can be used instead
		uint8 minCommitteeMemberPos;
		uint8 committeeSize;
	}
	CommitteeInfo committeeInfo;
	bytes32 committeeSortBytes;

	struct Settings {
		uint32 maxTimeBetweenRewardAssignments;
		uint8 maxCommitteeSize;
	}
	Settings settings;

	modifier onlyElectionsContract() {
		require(msg.sender == address(getElectionsContract()), "caller is not the elections");

		_;
	}

	function findFreePos(CommitteeInfo memory info) private pure returns (uint8 pos) {
		pos = 0;
		uint32 bitmap = info.committeeBitmap;
		while (bitmap & 1 == 1) {
			bitmap >>= 1;
			pos++;
		}
	}

	function qualifiesToEnterCommittee(address addr, MemberData memory data, CommitteeInfo memory info, Settings memory _settings) private view returns (bool qualified, uint8 entryPos) {
		if (!data.isMember || data.weight == 0) {
			return (false, 0);
		}

		if (info.committeeSize < _settings.maxCommitteeSize) {
			return (true, findFreePos(info));
		}

		CommitteeMember memory minMember = committee[info.minCommitteeMemberPos];
		if (data.weight < minMember.weight || data.weight == minMember.weight && addr < minMember.addr) {
			return (false, 0);
		}

		return (true, info.minCommitteeMemberPos);
	}

	function saveMemberData(address addr, MemberData memory data) private {
		if (data.isMember) {
			membersData[addr] = data;
		} else {
			delete membersData[addr];
		}
	}

	function updateOnMemberChange(address addr, MemberData memory data) private returns (bool committeeChanged) {
		CommitteeInfo memory info = committeeInfo;
		Settings memory _settings = settings;
		bytes memory sortBytes = abi.encodePacked(committeeSortBytes);

		if (!data.inCommittee) {
			(bool qualified, uint8 entryPos) = qualifiesToEnterCommittee(addr, data, info, _settings);
			if (!qualified) {
				saveMemberData(addr, data);
				return false;
			}

			(info, sortBytes) = removeMemberAtPos(entryPos, sortBytes, info);
			(info, sortBytes) = addToCommittee(addr, data, entryPos, sortBytes, info);
		}

		(info, sortBytes) = (data.isMember && data.weight > 0) ?
			rankMember(addr, data, sortBytes, info) :
			removeMemberFromCommittee(data, sortBytes, info);

		emit GuardianCommitteeChange(addr, data.weight, data.isCertified, data.inCommittee);

		saveMemberData(addr, data);

		committeeInfo = info;
		committeeSortBytes = sortBytes.toBytes32(0);

		assignRewardsIfNeeded(_settings);

		return true;
	}

	function addToCommittee(address addr, MemberData memory data, uint8 entryPos, bytes memory sortBytes, CommitteeInfo memory info) private returns (CommitteeInfo memory newInfo, bytes memory newSortByes) {
		committee[entryPos] = CommitteeMember({
			addr: addr,
			weight: data.weight
		});
		data.inCommittee = true;
		data.pos = entryPos;
		info.committeeBitmap |= uint32(uint(1) << entryPos);
		info.committeeSize++;

		sortBytes[info.committeeSize - 1] = byte(entryPos);
		return (info, sortBytes);
	}

	function removeMemberFromCommittee(MemberData memory data, bytes memory sortBytes, CommitteeInfo memory info) private returns (CommitteeInfo memory newInfo, bytes memory newSortBytes) {
		uint rank = 0;
		while (uint8(sortBytes[rank]) != data.pos) {
			rank++;
		}

		for (; rank < info.committeeSize - 1; rank++) {
			sortBytes[rank] = sortBytes[rank + 1];
		}
		sortBytes[rank] = 0;

		info.committeeSize--;
		if (info.committeeSize > 0) {
			info.minCommitteeMemberPos = uint8(sortBytes[info.committeeSize - 1]);
		}
		info.committeeBitmap &= ~uint32(uint(1) << data.pos);

		delete committee[data.pos];
		data.inCommittee = false;

		return (info, sortBytes);
	}

	function removeMemberAtPos(uint8 pos, bytes memory sortBytes, CommitteeInfo memory info) private returns (CommitteeInfo memory newInfo, bytes memory newSortBytes) {
		if (info.committeeBitmap & (uint(1) << pos) == 0) {
			return (info, sortBytes);
		}

		address addr = committee[pos].addr;
		MemberData memory data = membersData[addr];

		(newInfo, newSortBytes) = removeMemberFromCommittee(data, sortBytes, info);

		emit GuardianCommitteeChange(addr, data.weight, data.isCertified, false);

		membersData[addr] = data;
	}

	function rankMember(address addr, MemberData memory data, bytes memory sortBytes, CommitteeInfo memory info) private view returns (CommitteeInfo memory newInfo, bytes memory newSortBytes) {
		uint rank = 0;
		while (uint8(sortBytes[rank]) != data.pos) {
			rank++;
		}

		CommitteeMember memory cur = CommitteeMember({addr: addr, weight: data.weight});
		CommitteeMember memory next;

		while (rank < info.committeeSize - 1) {
			next = committee[uint8(sortBytes[rank + 1])];
			if (cur.weight > next.weight || cur.weight == next.weight && cur.addr > next.addr) break;

			(sortBytes[rank], sortBytes[rank + 1]) = (sortBytes[rank + 1], sortBytes[rank]);
			rank++;
		}

		while (rank > 0) {
			next = committee[uint8(sortBytes[rank - 1])];
			if (cur.weight < next.weight || cur.weight == next.weight && cur.addr < next.addr) break;

			(sortBytes[rank], sortBytes[rank - 1]) = (sortBytes[rank - 1], sortBytes[rank]);
			rank--;
		}

		info.minCommitteeMemberPos = uint8(sortBytes[info.committeeSize - 1]);
		return (info, sortBytes);
	}

	function getMinCommitteeMemberWeight() external view returns (uint96) {
		return committee[committeeInfo.minCommitteeMemberPos].weight;
	}

	function assignRewardsIfNeeded(Settings memory _settings) private {
        IRewards rewardsContract = getRewardsContract();
        uint lastAssignment = rewardsContract.getLastRewardAssignmentTime();
        if (now - lastAssignment < _settings.maxTimeBetweenRewardAssignments) {
             return;
        }

		(address[] memory committeeAddrs, uint[] memory committeeWeights, bool[] memory committeeCertification) = _getCommittee();
        rewardsContract.assignRewardsToCommittee(committeeAddrs, committeeWeights, committeeCertification);

		emit CommitteeSnapshot(committeeAddrs, committeeWeights, committeeCertification);
	}

	constructor(uint _maxCommitteeSize, uint32 maxTimeBetweenRewardAssignments) public {
		require(_maxCommitteeSize > 0, "maxCommitteeSize must be larger than 0");
		require(_maxCommitteeSize <= MAX_COMMITTEE_ARRAY_SIZE, "maxCommitteeSize must be 32 at most");
		settings = Settings({
			maxCommitteeSize: uint8(_maxCommitteeSize),
			maxTimeBetweenRewardAssignments: maxTimeBetweenRewardAssignments
		});

		committee.length = MAX_COMMITTEE_ARRAY_SIZE;
	}

	/*
	 * Methods restricted to other Orbs contracts
	 */

	/// @dev Called by: Elections contract
	/// Notifies a weight change for sorting to a relevant committee member.
	/// weight = 0 indicates removal of the member from the committee (for example on unregister, voteUnready, voteOut)
	function memberWeightChange(address addr, uint256 weight) external onlyElectionsContract onlyWhenActive returns (bool committeeChanged) {
		require(uint256(uint96(weight)) == weight, "weight is out of range");

		MemberData memory data = membersData[addr];
		if (!data.isMember) {
			return false;
		}
		data.weight = uint96(weight);
		if (data.inCommittee) {
			committee[data.pos].weight = data.weight;
		}
		return updateOnMemberChange(addr, data);
	}

	function memberCertificationChange(address addr, bool isCertified) external onlyElectionsContract onlyWhenActive returns (bool committeeChanged) {
		MemberData memory data = membersData[addr];
		if (!data.isMember) {
			return false;
		}

		data.isCertified = isCertified;
		return updateOnMemberChange(addr, data);
	}

	function addMember(address addr, uint256 weight, bool isCertified) external onlyElectionsContract onlyWhenActive returns (bool committeeChanged) {
		require(uint256(uint96(weight)) == weight, "weight is out of range");

		if (membersData[addr].isMember) {
			return false;
		}

		return updateOnMemberChange(addr, MemberData({
			isMember: true,
			weight: uint96(weight),
			isCertified: isCertified,
			inCommittee: false,
			pos: uint8(-1)
		}));
	}

	/// @dev Called by: Elections contract
	/// Notifies a a member removal for example due to voteOut / voteUnready
	function removeMember(address addr) external onlyElectionsContract onlyWhenActive returns (bool committeeChanged) {
		MemberData memory data = membersData[addr];

		if (!membersData[addr].isMember) {
			return false;
		}

		data.isMember = false;
		return updateOnMemberChange(addr, data);
	}

	/// @dev Called by: Elections contract
	/// Returns the committee members and their weights
	function getCommittee() external view returns (address[] memory addrs, uint256[] memory weights, bool[] memory certification) {
		return _getCommittee();
	}

	/// @dev Called by: Elections contract
	/// Returns the committee members and their weights
	function _getCommittee() public view returns (address[] memory addrs, uint256[] memory weights, bool[] memory certification) {
		CommitteeInfo memory _committeeInfo = committeeInfo;
		uint bitmap = uint(_committeeInfo.committeeBitmap);
		uint committeeSize = _committeeInfo.committeeSize;

		addrs = new address[](committeeSize);
		weights = new uint[](committeeSize);
		certification = new bool[](committeeSize);
		uint aInd = 0;
		uint pInd = 0;
		MemberData memory md;
		bitmap = uint(_committeeInfo.committeeBitmap);
		while (bitmap != 0) {
			if (bitmap & 1 == 1) {
				addrs[aInd] = committee[pInd].addr;
				md = membersData[addrs[aInd]];
				weights[aInd] = md.weight;
				certification[aInd] = md.isCertified;
				aInd++;
			}
			bitmap >>= 1;
			pInd++;
		}
	}

	/*
	 * Governance
	 */

	function setMaxTimeBetweenRewardAssignments(uint32 maxTimeBetweenRewardAssignments) external onlyFunctionalOwner /* todo onlyWhenActive */ {
		emit MaxTimeBetweenRewardAssignmentsChanged(maxTimeBetweenRewardAssignments, settings.maxTimeBetweenRewardAssignments);
		settings.maxTimeBetweenRewardAssignments = maxTimeBetweenRewardAssignments;
	}

	function setMaxCommittee(uint8 maxCommitteeSize) external onlyFunctionalOwner /* todo onlyWhenActive */ {
		require(maxCommitteeSize > 0, "maxCommitteeSize must be larger than 0");
		require(maxCommitteeSize <= MAX_COMMITTEE_ARRAY_SIZE, "maxCommitteeSize must be 32 at most");
		Settings memory _settings = settings;
		emit MaxCommitteeSizeChanged(maxCommitteeSize, _settings.maxCommitteeSize);
		_settings.maxCommitteeSize = maxCommitteeSize;
		settings = _settings;

		CommitteeInfo memory info = committeeInfo;
		if (maxCommitteeSize >= info.committeeSize) {
			return;
		}

		bytes memory sortBytes = abi.encodePacked(committeeSortBytes);
		for (int rank = int(info.committeeSize); rank >= int(maxCommitteeSize); rank--) {
			(info, sortBytes) = removeMemberAtPos(uint8(sortBytes[uint(rank)]), sortBytes, info);
		}
		committeeInfo = info;
		committeeSortBytes = sortBytes.toBytes32(0);
	}

	/*
     * Getters
     */

	/// @dev returns the current committee
	/// used also by the rewards and fees contracts
	function getCommitteeInfo() external view returns (address[] memory addrs, uint256[] memory weights, address[] memory orbsAddrs, bool[] memory certification, bytes4[] memory ips) {
		(addrs, weights, certification) = _getCommittee();
		return (addrs, weights, _loadOrbsAddresses(addrs), certification, _loadIps(addrs));
	}

	function getSettings() external view returns (uint32 maxTimeBetweenRewardAssignments, uint8 maxCommitteeSize) {
		Settings memory _settings = settings;
		maxTimeBetweenRewardAssignments = _settings.maxTimeBetweenRewardAssignments;
		maxCommitteeSize = _settings.maxCommitteeSize;
	}

	/*
	 * Private
	 */

	function _loadOrbsAddresses(address[] memory addrs) private view returns (address[] memory) {
		return getGuardiansRegistrationContract().getGuardiansOrbsAddress(addrs);
	}

	function _loadIps(address[] memory addrs) private view returns (bytes4[] memory) {
		return getGuardiansRegistrationContract().getGuardianIps(addrs);
	}

	function _loadCertification(address[] memory addrs) private view returns (bool[] memory) {
		bool[] memory certification = new bool[](addrs.length);
		for (uint i = 0; i < addrs.length; i++) {
			certification[i] = membersData[addrs[i]].isCertified;
		}
		return certification;
	}

}