/**
 *Submitted for verification at Etherscan.io on 2020-05-28
*/

pragma solidity 0.5.16;

/**
  * @title INexus
  * @dev Basic interface for interacting with the Nexus i.e. SystemKernel
  */
interface INexus {
    function governor() external view returns (address);
    function getModule(bytes32 key) external view returns (address);

    function proposeModule(bytes32 _key, address _addr) external;
    function cancelProposedModule(bytes32 _key) external;
    function acceptProposedModule(bytes32 _key) external;
    function acceptProposedModules(bytes32[] calldata _keys) external;

    function requestLockModule(bytes32 _key) external;
    function cancelLockModule(bytes32 _key) external;
    function lockModule(bytes32 _key) external;
}

/**
 * @title   Governable
 * @author  Stability Labs Pty. Ltd.
 * @notice  Simple contract implementing an Ownable pattern.
 * @dev     Derives from OpenZeppelin 2.3.0 Ownable.sol
 *          Modified to have custom name and features
 */
contract Governable {

    event GovernorChanged(address indexed previousGovernor, address indexed newGovernor);

    address private _governor;


    /**
     * @dev Initializes the contract setting the deployer as the initial Governor.
     */
    constructor () internal {
        _governor = msg.sender;
        emit GovernorChanged(address(0), _governor);
    }

    /**
     * @dev Returns the address of the current Governor.
     */
    function governor() public view returns (address) {
        return _governor;
    }

    /**
     * @dev Throws if called by any account other than the Governor.
     */
    modifier onlyGovernor() {
        require(isGovernor(), "GOV: caller is not the Governor");
        _;
    }

    /**
     * @dev Returns true if the caller is the current Governor.
     */
    function isGovernor() public view returns (bool) {
        return msg.sender == _governor;
    }

    /**
     * @dev Transfers Governance of the contract to a new account (`newGovernor`).
     * Can only be called by the current Governor.
     * @param _newGovernor Address of the new Governor
     */
    function changeGovernor(address _newGovernor) external onlyGovernor {
        _changeGovernor(_newGovernor);
    }

    /**
     * @dev Change Governance of the contract to a new account (`newGovernor`).
     * @param _newGovernor Address of the new Governor
     */
    function _changeGovernor(address _newGovernor) internal {
        require(_newGovernor != address(0), "GOV: new Governor is address(0)");
        emit GovernorChanged(_governor, _newGovernor);
        _governor = _newGovernor;
    }
}

/**
 * @title   ClaimableGovernor
 * @author  Stability Labs Pty. Ltd.
 * @notice  2 way handshake for Governance transfer
 */
contract ClaimableGovernor is Governable {

    event GovernorChangeClaimed(address indexed proposedGovernor);
    event GovernorChangeCancelled(address indexed governor, address indexed proposed);
    event GovernorChangeRequested(address indexed governor, address indexed proposed);

    address public proposedGovernor = address(0);

    /**
     * @dev Throws if called by any account other than the Proposed Governor.
     */
    modifier onlyProposedGovernor() {
        require(msg.sender == proposedGovernor, "Sender is not proposed governor");
        _;
    }

    constructor(address _governorAddr) public {
        _changeGovernor(_governorAddr);
    }

    //@override
    function changeGovernor(address) external onlyGovernor {
        revert("Direct change not allowed");
    }

    /**
     * @dev Current Governor request to proposes a new Governor
     * @param _proposedGovernor Address of the proposed Governor
     */
    function requestGovernorChange(address _proposedGovernor) public onlyGovernor {
        require(_proposedGovernor != address(0), "Proposed governor is address(0)");
        require(proposedGovernor == address(0), "Proposed governor already set");

        proposedGovernor = _proposedGovernor;
        emit GovernorChangeRequested(governor(), _proposedGovernor);
    }

    /**
     * @dev Current Governor cancel Governor change request
     */
    function cancelGovernorChange() public onlyGovernor {
        require(proposedGovernor != address(0), "Proposed Governor not set");

        emit GovernorChangeCancelled(governor(), proposedGovernor);
        proposedGovernor = address(0);
    }

    /**
     * @dev Proposed Governor can claim governance ownership
     */
    function claimGovernorChange() public onlyProposedGovernor {
        _changeGovernor(proposedGovernor);
        emit GovernorChangeClaimed(proposedGovernor);
        proposedGovernor = address(0);
    }
}
/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
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

/**
 * @title   DelayedClaimableGovernor
 * @author  Stability Labs Pty. Ltd.
 * @notice  Current Governor can initiate governance change request.
 *          After a defined delay, proposed Governor can claim governance
 *          ownership.
 */
contract DelayedClaimableGovernor is ClaimableGovernor {

    using SafeMath for uint256;

    uint256 public delay = 0;
    uint256 public requestTime = 0;

    /**
     * @dev Initializes the contract with given delay
     * @param _governorAddr Initial governor
     * @param _delay    Delay in seconds for 2 way handshake
     */
    constructor(address _governorAddr, uint256 _delay)
        public
        ClaimableGovernor(_governorAddr)
    {
        require(_delay > 0, "Delay must be greater than zero");
        delay = _delay;
    }

    //@override
    /**
     * @dev Requests change of governor and logs request time
     * @param _proposedGovernor Address of the new governor
     */
    function requestGovernorChange(address _proposedGovernor) public onlyGovernor {
        requestTime = now;
        super.requestGovernorChange(_proposedGovernor);
    }

    //@override
    /**
     * @dev Cancels an outstanding governor change request by resetting request time
     */
    function cancelGovernorChange() public onlyGovernor {
        requestTime = 0;
        super.cancelGovernorChange();
    }

    //@override
    /**
     * @dev Proposed governor claims new position, callable after time elapsed
     */
    function claimGovernorChange() public onlyProposedGovernor {
        require(now >= (requestTime.add(delay)), "Delay not over");
        super.claimGovernorChange();
        requestTime = 0;
    }
}

/**
 * @title   Nexus
 * @author  Stability Labs Pty. Ltd.
 * @notice  This is the system address kernel, it also facilitates the changing of governor
 * @dev     The Nexus is mStable's Kernel, and allows the publishing and propagating
 *          of new system Modules. Other Modules will read from the Nexus
 */
contract Nexus is INexus, DelayedClaimableGovernor {

    event ModuleProposed(bytes32 indexed key, address addr, uint256 timestamp);
    event ModuleAdded(bytes32 indexed key, address addr, bool isLocked);
    event ModuleCancelled(bytes32 indexed key);
    event ModuleLockRequested(bytes32 indexed key, uint256 timestamp);
    event ModuleLockEnabled(bytes32 indexed key);
    event ModuleLockCancelled(bytes32 indexed key);

    /** @dev Struct to store information about current modules */
    struct Module {
        address addr;       // Module address
        bool isLocked;      // Module lock status
    }

    /** @dev Struct to store information about proposed modules */
    struct Proposal {
        address newAddress; // Proposed Module address
        uint256 timestamp;  // Timestamp when module upgrade was proposed
    }

    // 1 week delayed upgrade period
    uint256 public constant UPGRADE_DELAY = 1 weeks;

    // Module-key => Module
    mapping(bytes32 => Module) public modules;
    // Module-address => Module-key
    mapping(address => bytes32) private addressToModule;
    // Module-key => Proposal
    mapping(bytes32 => Proposal) public proposedModules;
    // Module-key => Timestamp when lock was proposed
    mapping(bytes32 => uint256) public proposedLockModules;

    // Init flag to allow add modules at the time of deplyment without delay
    bool public initialized = false;

    /**
     * @dev Modifier allows functions calls only when contract is not initialized.
     */
    modifier whenNotInitialized() {
        require(!initialized, "Nexus is already initialized");
        _;
    }

    /**
     * @dev Initialises the Nexus and adds the core data to the Kernel (itself and governor)
     * @param _governorAddr Governor address
     */
    constructor(address _governorAddr)
        public
        DelayedClaimableGovernor(_governorAddr, UPGRADE_DELAY)
    {}

    /**
     * @dev Adds multiple new modules to the system to initialize the
     *      Nexus contract with default modules. This should be called first
     *      after deploying Nexus contract.
     * @param _keys         Keys of the new modules in bytes32 form
     * @param _addresses    Contract addresses of the new modules
     * @param _isLocked     IsLocked flag for the new modules
     * @param _governorAddr New Governor address
     * @return bool         Success of publishing new Modules
     */
    function initialize(
        bytes32[] calldata _keys,
        address[] calldata _addresses,
        bool[] calldata _isLocked,
        address _governorAddr
    )
        external
        onlyGovernor
        whenNotInitialized
        returns (bool)
    {
        uint256 len = _keys.length;
        require(len > 0, "No keys provided");
        require(len == _addresses.length, "Insufficient address data");
        require(len == _isLocked.length, "Insufficient locked statuses");

        for(uint256 i = 0 ; i < len; i++) {
            _publishModule(_keys[i], _addresses[i], _isLocked[i]);
        }

        if(_governorAddr != governor()) _changeGovernor(_governorAddr);

        initialized = true;
        return true;
    }

    /***************************************
                MODULE ADDING
    ****************************************/

    /**
     * @dev Propose a new or update existing module
     * @param _key  Key of the module
     * @param _addr Address of the module
     */
    function proposeModule(bytes32 _key, address _addr)
        external
        onlyGovernor
    {
        require(_key != bytes32(0x0), "Key must not be zero");
        require(_addr != address(0), "Module address must not be 0");
        require(!modules[_key].isLocked, "Module must be unlocked");
        require(modules[_key].addr != _addr, "Module already has same address");
        Proposal storage p = proposedModules[_key];
        require(p.timestamp == 0, "Module already proposed");

        p.newAddress = _addr;
        p.timestamp = now;
        emit ModuleProposed(_key, _addr, now);
    }

    /**
     * @dev Cancel a proposed module request
     * @param _key Key of the module
     */
    function cancelProposedModule(bytes32 _key)
        external
        onlyGovernor
    {
        uint256 timestamp = proposedModules[_key].timestamp;
        require(timestamp > 0, "Proposed module not found");

        delete proposedModules[_key];
        emit ModuleCancelled(_key);
    }

    /**
     * @dev Accept and publish an already proposed module
     * @param _key Key of the module
     */
    function acceptProposedModule(bytes32 _key)
        external
        onlyGovernor
    {
        _acceptProposedModule(_key);
    }

    /**
     * @dev Accept and publish already proposed modules
     * @param _keys Keys array of the modules
     */
    function acceptProposedModules(bytes32[] calldata _keys)
        external
        onlyGovernor
    {
        uint256 len = _keys.length;
        require(len > 0, "Keys array empty");

        for(uint256 i = 0 ; i < len; i++) {
            _acceptProposedModule(_keys[i]);
        }
    }

    /**
     * @dev Accept a proposed module
     * @param _key Key of the module
     */
    function _acceptProposedModule(bytes32 _key) internal {
        Proposal memory p = proposedModules[_key];
        require(_isDelayOver(p.timestamp), "Module upgrade delay not over");

        delete proposedModules[_key];
        _publishModule(_key, p.newAddress, false);
    }

    /**
     * @dev Internal func to publish a module to kernel
     * @param _key      Key of the new module in bytes32 form
     * @param _addr     Contract address of the new module
     * @param _isLocked Flag to lock a module
     */
    function _publishModule(bytes32 _key, address _addr, bool _isLocked) internal {
        require(addressToModule[_addr] == bytes32(0x0), "Modules must have unique addr");
        require(!modules[_key].isLocked, "Module must be unlocked");
        // Old no longer points to a moduleAddress
        address oldModuleAddr = modules[_key].addr;
        if(oldModuleAddr != address(0x0)) {
            addressToModule[oldModuleAddr] = bytes32(0x0);
        }
        modules[_key].addr = _addr;
        modules[_key].isLocked = _isLocked;
        addressToModule[_addr] = _key;
        emit ModuleAdded(_key, _addr, _isLocked);
    }

    /***************************************
                MODULE LOCKING
    ****************************************/

    /**
     * @dev Request to lock an existing module
     * @param _key Key of the module
     */
    function requestLockModule(bytes32 _key)
        external
        onlyGovernor
    {
        require(moduleExists(_key), "Module must exist");
        require(!modules[_key].isLocked, "Module must be unlocked");
        require(proposedLockModules[_key] == 0, "Lock already proposed");

        proposedLockModules[_key] = now;
        emit ModuleLockRequested(_key, now);
    }

    /**
     * @dev Cancel a lock module request
     * @param _key Key of the module
     */
    function cancelLockModule(bytes32 _key)
        external
        onlyGovernor
    {
        require(proposedLockModules[_key] > 0, "Module lock request not found");

        delete proposedLockModules[_key];
        emit ModuleLockCancelled(_key);
    }

    /**
     * @dev Permanently lock a module to its current settings
     * @param _key Bytes32 key of the module
     */
    function lockModule(bytes32 _key)
        external
        onlyGovernor
    {
        require(_isDelayOver(proposedLockModules[_key]), "Delay not over");

        modules[_key].isLocked = true;
        delete proposedLockModules[_key];
        emit ModuleLockEnabled(_key);
    }

    /***************************************
                HELPERS & GETTERS
    ****************************************/

    /**
     * @dev Checks if a module exists
     * @param _key  Key of the module
     * @return      Returns 'true' when a module exists, otherwise 'false'
     */
    function moduleExists(bytes32 _key) public view returns (bool) {
        if(_key != 0 && modules[_key].addr != address(0))
            return true;
        return false;
    }

    /**
     * @dev Get the module address
     * @param _key  Key of the module
     * @return      Return the address of the module
     */
    function getModule(bytes32 _key) external view returns (address addr) {
        addr = modules[_key].addr;
    }

    /**
     * @dev Checks if upgrade delay over
     * @param _timestamp    Timestamp to check
     * @return              Return 'true' when delay is over, otherwise 'false'
     */
    function _isDelayOver(uint256 _timestamp) private view returns (bool) {
        if(_timestamp > 0 && now >= _timestamp.add(UPGRADE_DELAY))
            return true;
        return false;
    }
}