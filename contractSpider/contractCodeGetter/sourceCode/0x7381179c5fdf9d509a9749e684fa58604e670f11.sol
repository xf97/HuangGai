/**
 *Submitted for verification at Etherscan.io on 2020-08-20
*/

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

// File: contracts/spec_interfaces/IContractRegistry.sol

pragma solidity 0.5.16;

interface IContractRegistry {

	event ContractAddressUpdated(string contractName, address addr);

	/// @dev updates the contracts address and emits a corresponding event
	function set(string calldata contractName, address addr) external /* onlyGovernor */;

	/// @dev returns the current address of the
	function get(string calldata contractName) external view returns (address);
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

// File: @openzeppelin/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

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
     *
     * _Available since v2.4.0._
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
     *
     * _Available since v2.4.0._
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
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: ../contracts/ProtocolWallet.sol

pragma solidity 0.5.16;






contract ProtocolWallet is IProtocolWallet, WithClaimableMigrationOwnership, WithClaimableFunctionalOwnership{
    using SafeMath for uint256;

    IERC20 public token;
    address public client;

    uint lastApprovedAt;
    uint annualRate;

    modifier onlyClient() {
        require(msg.sender == client, "caller is not the wallet client");

        _;
    }

    constructor(IERC20 _token, address _client) public {
        token = _token;
        client = _client;
        lastApprovedAt = now; // TODO init here, or in first call to setMaxAnnualRate?
    }

    /// @dev Returns the address of the underlying staked token.
    /// @return IERC20 The address of the token.
    function getToken() external view returns (IERC20) {
        return token;
    }

    /// @dev Returns the address of the underlying staked token.
    /// @return IERC20 The address of the token.
    function getBalance() public view returns (uint256 balance) {
        return token.balanceOf(address(this));
    }

    /// @dev Transfers the given amount of orbs tokens form the sender to this contract an update the pool.
    function topUp(uint256 amount) external {
        emit FundsAddedToPool(amount, getBalance() + amount);
        require(token.transferFrom(msg.sender, address(this), amount), "ProtocolWallet::topUp - insufficient allowance");
    }

    /// @dev Approves withdraw from pool to a spender, limited by the pool's MaxRate.
    /// A maximum of MaxRate x time period since the last Orbs transfer may be transferred out.
    /// Flow:
    /// PoolWallet.approveTransfer(amount);
    /// ERC20.transferFrom(PoolWallet, client, amount)
    function withdraw(uint256 amount) external onlyClient {
        uint duration = now - lastApprovedAt;
        uint maxAmount = duration.mul(annualRate).div(365 * 24 * 60 * 60);
        require(amount <= maxAmount, "ProtocolWallet:approve - requested amount is larger than allowed by rate");

        lastApprovedAt = now;
        if (amount > 0) {
            require(token.transfer(msg.sender, amount), "ProtocolWallet::withdraw - transfer failed");
        }
    }

    /* Governance */
    /// @dev Sets a new transfer rate for the Orbs pool.
    function setMaxAnnualRate(uint256 _annualRate) external onlyMigrationOwner {
        annualRate = _annualRate;
        emit MaxAnnualRateSet(_annualRate);
    }

    /// @dev transfer the entire pool's balance to a new wallet.
    function emergencyWithdraw() external onlyMigrationOwner {
        emit EmergencyWithdrawal(msg.sender);
        require(token.transfer(msg.sender, getBalance()), "ProtocolWallet::emergencyWithdraw - transfer failed");
    }

    /// @dev sets the address of the new contract
    function setClient(address _client) external onlyFunctionalOwner {
        client = _client;
        emit ClientSet(_client);
    }
}