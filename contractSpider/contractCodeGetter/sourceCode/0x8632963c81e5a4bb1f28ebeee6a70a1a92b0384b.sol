/**
 *Submitted for verification at Etherscan.io on 2020-08-07
*/

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

// File: @emilianobonassi/gas-saver/ChiGasSaver.sol

pragma solidity ^0.5.0;



contract IFreeFromUpTo is IERC20 {
    function freeFromUpTo(address from, uint256 value) external returns(uint256 freed);
}


contract ChiGasSaver {

    using SafeMath for uint256;

    modifier saveGas(address payable sponsor) {
        uint256 gasStart = gasleft();
        _;
        uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;

        IFreeFromUpTo chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
        chi.freeFromUpTo(sponsor, (gasSpent + 14154) / 41947);
    }
}

// File: contracts/GasTokenRefundModuleV2.sol

// File: @gnosis.pm/safe-contracts/contracts/common/SelfAuthorized.sol

pragma solidity >=0.5.0 <0.7.0;


/// @title SelfAuthorized - authorizes current contract to perform actions
/// @author Richard Meissner - <richard@gnosis.pm>
contract SelfAuthorized {
    modifier authorized() {
        require(msg.sender == address(this), "Method can only be called from this contract");
        _;
    }
}

// File: @gnosis.pm/safe-contracts/contracts/common/MasterCopy.sol

pragma solidity >=0.5.0 <0.7.0;



/// @title MasterCopy - Base for master copy contracts (should always be first super contract)
///         This contract is tightly coupled to our proxy contract (see `proxies/GnosisSafeProxy.sol`)
/// @author Richard Meissner - <richard@gnosis.io>
contract MasterCopy is SelfAuthorized {

    event ChangedMasterCopy(address masterCopy);

    // masterCopy always needs to be first declared variable, to ensure that it is at the same location as in the Proxy contract.
    // It should also always be ensured that the address is stored alone (uses a full word)
    address private masterCopy;

    /// @dev Allows to upgrade the contract. This can only be done via a Safe transaction.
    /// @param _masterCopy New contract address.
    function changeMasterCopy(address _masterCopy)
    public
    authorized
    {
        // Master copy address cannot be null.
        require(_masterCopy != address(0), "Invalid master copy address provided");
        masterCopy = _masterCopy;
        emit ChangedMasterCopy(_masterCopy);
    }
}

// File: @gnosis.pm/safe-contracts/contracts/common/Enum.sol

pragma solidity >=0.5.0 <0.7.0;


/// @title Enum - Collection of enums
/// @author Richard Meissner - <richard@gnosis.pm>
contract Enum {
    enum Operation {
        Call,
        DelegateCall
    }
}

// File: @gnosis.pm/safe-contracts/contracts/base/Executor.sol

pragma solidity >=0.5.0 <0.7.0;



/// @title Executor - A contract that can execute transactions
/// @author Richard Meissner - <richard@gnosis.pm>
contract Executor {

    function execute(address to, uint256 value, bytes memory data, Enum.Operation operation, uint256 txGas)
    internal
    returns (bool success)
    {
        if (operation == Enum.Operation.Call)
            success = executeCall(to, value, data, txGas);
        else if (operation == Enum.Operation.DelegateCall)
            success = executeDelegateCall(to, data, txGas);
        else
            success = false;
    }

    function executeCall(address to, uint256 value, bytes memory data, uint256 txGas)
    internal
    returns (bool success)
    {
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            success := call(txGas, to, value, add(data, 0x20), mload(data), 0, 0)
        }
    }

    function executeDelegateCall(address to, bytes memory data, uint256 txGas)
    internal
    returns (bool success)
    {
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
        }
    }
}

// File: @gnosis.pm/safe-contracts/contracts/base/ModuleManager.sol

pragma solidity >=0.5.0 <0.7.0;





/// @title Module Manager - A contract that manages modules that can execute transactions via this contract
/// @author Stefan George - <stefan@gnosis.pm>
/// @author Richard Meissner - <richard@gnosis.pm>
contract ModuleManager is SelfAuthorized, Executor {

    event EnabledModule(Module module);
    event DisabledModule(Module module);
    event ExecutionFromModuleSuccess(address indexed module);
    event ExecutionFromModuleFailure(address indexed module);

    address internal constant SENTINEL_MODULES = address(0x1);

    mapping (address => address) internal modules;

    function setupModules(address to, bytes memory data)
    internal
    {
        require(modules[SENTINEL_MODULES] == address(0), "Modules have already been initialized");
        modules[SENTINEL_MODULES] = SENTINEL_MODULES;
        if (to != address(0))
        // Setup has to complete successfully or transaction fails.
            require(executeDelegateCall(to, data, gasleft()), "Could not finish initialization");
    }

    /// @dev Allows to add a module to the whitelist.
    ///      This can only be done via a Safe transaction.
    /// @param module Module to be whitelisted.
    function enableModule(Module module)
    public
    authorized
    {
        // Module address cannot be null or sentinel.
        require(address(module) != address(0) && address(module) != SENTINEL_MODULES, "Invalid module address provided");
        // Module cannot be added twice.
        require(modules[address(module)] == address(0), "Module has already been added");
        modules[address(module)] = modules[SENTINEL_MODULES];
        modules[SENTINEL_MODULES] = address(module);
        emit EnabledModule(module);
    }

    /// @dev Allows to remove a module from the whitelist.
    ///      This can only be done via a Safe transaction.
    /// @param prevModule Module that pointed to the module to be removed in the linked list
    /// @param module Module to be removed.
    function disableModule(Module prevModule, Module module)
    public
    authorized
    {
        // Validate module address and check that it corresponds to module index.
        require(address(module) != address(0) && address(module) != SENTINEL_MODULES, "Invalid module address provided");
        require(modules[address(prevModule)] == address(module), "Invalid prevModule, module pair provided");
        modules[address(prevModule)] = modules[address(module)];
        modules[address(module)] = address(0);
        emit DisabledModule(module);
    }

    /// @dev Allows a Module to execute a Safe transaction without any further confirmations.
    /// @param to Destination address of module transaction.
    /// @param value Ether value of module transaction.
    /// @param data Data payload of module transaction.
    /// @param operation Operation type of module transaction.
    function execTransactionFromModule(address to, uint256 value, bytes memory data, Enum.Operation operation)
    public
    returns (bool success)
    {
        // Only whitelisted modules are allowed.
        require(msg.sender != SENTINEL_MODULES && modules[msg.sender] != address(0), "Method can only be called from an enabled module");
        // Execute transaction without further confirmations.
        success = execute(to, value, data, operation, gasleft());
        if (success) emit ExecutionFromModuleSuccess(msg.sender);
        else emit ExecutionFromModuleFailure(msg.sender);
    }

    /// @dev Allows a Module to execute a Safe transaction without any further confirmations and return data
    /// @param to Destination address of module transaction.
    /// @param value Ether value of module transaction.
    /// @param data Data payload of module transaction.
    /// @param operation Operation type of module transaction.
    function execTransactionFromModuleReturnData(address to, uint256 value, bytes memory data, Enum.Operation operation)
    public
    returns (bool success, bytes memory returnData)
    {
        success = execTransactionFromModule(to, value, data, operation);
        // solium-disable-next-line security/no-inline-assembly
        assembly {
        // Load free memory location
            let ptr := mload(0x40)
        // We allocate memory for the return data by setting the free memory location to
        // current free memory location + data size + 32 bytes for data size value
            mstore(0x40, add(ptr, add(returndatasize(), 0x20)))
        // Store the size
            mstore(ptr, returndatasize())
        // Store the data
            returndatacopy(add(ptr, 0x20), 0, returndatasize())
        // Point the return data to the correct memory location
            returnData := ptr
        }
    }

    /// @dev Returns array of first 10 modules.
    /// @return Array of modules.
    function getModules()
    public
    view
    returns (address[] memory)
    {
        (address[] memory array,) = getModulesPaginated(SENTINEL_MODULES, 10);
        return array;
    }

    /// @dev Returns array of modules.
    /// @param start Start of the page.
    /// @param pageSize Maximum number of modules that should be returned.
    /// @return Array of modules.
    function getModulesPaginated(address start, uint256 pageSize)
    public
    view
    returns (address[] memory array, address next)
    {
        // Init array with max page size
        array = new address[](pageSize);

        // Populate return array
        uint256 moduleCount = 0;
        address currentModule = modules[start];
        while(currentModule != address(0x0) && currentModule != SENTINEL_MODULES && moduleCount < pageSize) {
            array[moduleCount] = currentModule;
            currentModule = modules[currentModule];
            moduleCount++;
        }
        next = currentModule;
        // Set correct size of returned array
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            mstore(array, moduleCount)
        }
    }
}

// File: @gnosis.pm/safe-contracts/contracts/base/Module.sol

pragma solidity >=0.5.0 <0.7.0;




/// @title Module - Base class for modules.
/// @author Stefan George - <stefan@gnosis.pm>
/// @author Richard Meissner - <richard@gnosis.pm>
contract Module is MasterCopy {

    ModuleManager public manager;

    modifier authorized() {
        require(msg.sender == address(manager), "Method can only be called from manager");
        _;
    }

    function setManager()
    internal
    {
        // manager can only be 0 at initalization of contract.
        // Check ensures that setup function can only be called once.
        require(address(manager) == address(0), "Manager has already been set");
        manager = ModuleManager(msg.sender);
    }
}

// File: @gnosis.pm/safe-contracts/contracts/base/OwnerManager.sol

pragma solidity >=0.5.0 <0.7.0;


/// @title OwnerManager - Manages a set of owners and a threshold to perform actions.
/// @author Stefan George - <stefan@gnosis.pm>
/// @author Richard Meissner - <richard@gnosis.pm>
contract OwnerManager is SelfAuthorized {

    event AddedOwner(address owner);
    event RemovedOwner(address owner);
    event ChangedThreshold(uint256 threshold);

    address internal constant SENTINEL_OWNERS = address(0x1);

    mapping(address => address) internal owners;
    uint256 ownerCount;
    uint256 internal threshold;

    /// @dev Setup function sets initial storage of contract.
    /// @param _owners List of Safe owners.
    /// @param _threshold Number of required confirmations for a Safe transaction.
    function setupOwners(address[] memory _owners, uint256 _threshold)
    internal
    {
        // Threshold can only be 0 at initialization.
        // Check ensures that setup function can only be called once.
        require(threshold == 0, "Owners have already been setup");
        // Validate that threshold is smaller than number of added owners.
        require(_threshold <= _owners.length, "Threshold cannot exceed owner count");
        // There has to be at least one Safe owner.
        require(_threshold >= 1, "Threshold needs to be greater than 0");
        // Initializing Safe owners.
        address currentOwner = SENTINEL_OWNERS;
        for (uint256 i = 0; i < _owners.length; i++) {
            // Owner address cannot be null.
            address owner = _owners[i];
            require(owner != address(0) && owner != SENTINEL_OWNERS, "Invalid owner address provided");
            // No duplicate owners allowed.
            require(owners[owner] == address(0), "Duplicate owner address provided");
            owners[currentOwner] = owner;
            currentOwner = owner;
        }
        owners[currentOwner] = SENTINEL_OWNERS;
        ownerCount = _owners.length;
        threshold = _threshold;
    }

    /// @dev Allows to add a new owner to the Safe and update the threshold at the same time.
    ///      This can only be done via a Safe transaction.
    /// @param owner New owner address.
    /// @param _threshold New threshold.
    function addOwnerWithThreshold(address owner, uint256 _threshold)
    public
    authorized
    {
        // Owner address cannot be null.
        require(owner != address(0) && owner != SENTINEL_OWNERS, "Invalid owner address provided");
        // No duplicate owners allowed.
        require(owners[owner] == address(0), "Address is already an owner");
        owners[owner] = owners[SENTINEL_OWNERS];
        owners[SENTINEL_OWNERS] = owner;
        ownerCount++;
        emit AddedOwner(owner);
        // Change threshold if threshold was changed.
        if (threshold != _threshold)
            changeThreshold(_threshold);
    }

    /// @dev Allows to remove an owner from the Safe and update the threshold at the same time.
    ///      This can only be done via a Safe transaction.
    /// @param prevOwner Owner that pointed to the owner to be removed in the linked list
    /// @param owner Owner address to be removed.
    /// @param _threshold New threshold.
    function removeOwner(address prevOwner, address owner, uint256 _threshold)
    public
    authorized
    {
        // Only allow to remove an owner, if threshold can still be reached.
        require(ownerCount - 1 >= _threshold, "New owner count needs to be larger than new threshold");
        // Validate owner address and check that it corresponds to owner index.
        require(owner != address(0) && owner != SENTINEL_OWNERS, "Invalid owner address provided");
        require(owners[prevOwner] == owner, "Invalid prevOwner, owner pair provided");
        owners[prevOwner] = owners[owner];
        owners[owner] = address(0);
        ownerCount--;
        emit RemovedOwner(owner);
        // Change threshold if threshold was changed.
        if (threshold != _threshold)
            changeThreshold(_threshold);
    }

    /// @dev Allows to swap/replace an owner from the Safe with another address.
    ///      This can only be done via a Safe transaction.
    /// @param prevOwner Owner that pointed to the owner to be replaced in the linked list
    /// @param oldOwner Owner address to be replaced.
    /// @param newOwner New owner address.
    function swapOwner(address prevOwner, address oldOwner, address newOwner)
    public
    authorized
    {
        // Owner address cannot be null.
        require(newOwner != address(0) && newOwner != SENTINEL_OWNERS, "Invalid owner address provided");
        // No duplicate owners allowed.
        require(owners[newOwner] == address(0), "Address is already an owner");
        // Validate oldOwner address and check that it corresponds to owner index.
        require(oldOwner != address(0) && oldOwner != SENTINEL_OWNERS, "Invalid owner address provided");
        require(owners[prevOwner] == oldOwner, "Invalid prevOwner, owner pair provided");
        owners[newOwner] = owners[oldOwner];
        owners[prevOwner] = newOwner;
        owners[oldOwner] = address(0);
        emit RemovedOwner(oldOwner);
        emit AddedOwner(newOwner);
    }

    /// @dev Allows to update the number of required confirmations by Safe owners.
    ///      This can only be done via a Safe transaction.
    /// @param _threshold New threshold.
    function changeThreshold(uint256 _threshold)
    public
    authorized
    {
        // Validate that threshold is smaller than number of owners.
        require(_threshold <= ownerCount, "Threshold cannot exceed owner count");
        // There has to be at least one Safe owner.
        require(_threshold >= 1, "Threshold needs to be greater than 0");
        threshold = _threshold;
        emit ChangedThreshold(threshold);
    }

    function getThreshold()
    public
    view
    returns (uint256)
    {
        return threshold;
    }

    function isOwner(address owner)
    public
    view
    returns (bool)
    {
        return owner != SENTINEL_OWNERS && owners[owner] != address(0);
    }

    /// @dev Returns array of owners.
    /// @return Array of Safe owners.
    function getOwners()
    public
    view
    returns (address[] memory)
    {
        address[] memory array = new address[](ownerCount);

        // populate return array
        uint256 index = 0;
        address currentOwner = owners[SENTINEL_OWNERS];
        while(currentOwner != SENTINEL_OWNERS) {
            array[index] = currentOwner;
            currentOwner = owners[currentOwner];
            index ++;
        }
        return array;
    }
}


/// @title GasToken Refund Module - Allows to execute transactions using CHI Gas Tokens.
/// @author Emiliano Bonassi - <bonassi.emiliano@gmail.com>
contract GasTokenRefundModuleV2 is Module, ChiGasSaver {
    using SafeMath for uint256;

    string public constant NAME = "GasToken Refund Module";
    string public constant VERSION = "2.0.0";

    /// @dev Setup function sets initial storage of contract.
    /// @param _manager Address of the manager, the safe contract.
    function setup(address payable _manager) public {
        require(address(manager) == address(0), "Manager has already been set");
        if (_manager == address(0)) {
            manager = ModuleManager(msg.sender);
        } else {
            manager = ModuleManager(_manager);
        }
    }

    /// @dev Returns if executed correctly.
    /// @param to Recipient.
    /// @param value Value.
    /// @param data Data.
    /// @return Returns if transaction can be executed.
    function executeWithGasTokenRefund(
        address to,
        uint256 value,
        bytes memory data
    )
    public
    saveGas(address(uint160(address(manager))))
    returns (bool) {
        // Only Safe owners are allowed to execute transactions.
        require(OwnerManager(address(manager)).isOwner(msg.sender), "Method can only be called by an owner");
        require(manager.execTransactionFromModule(to, value, data, Enum.Operation.Call), "Could not execute transaction");

        return true;
    }
}