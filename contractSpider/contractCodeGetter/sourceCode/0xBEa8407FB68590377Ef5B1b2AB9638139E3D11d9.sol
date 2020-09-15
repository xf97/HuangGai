/**
 *Submitted for verification at Etherscan.io on 2020-07-01
*/

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

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

// File: openzeppelin-solidity/contracts/GSN/Context.sol

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

// File: openzeppelin-solidity/contracts/access/Roles.sol

pragma solidity ^0.5.0;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

// File: openzeppelin-solidity/contracts/access/roles/SignerRole.sol

pragma solidity ^0.5.0;



contract SignerRole is Context {
    using Roles for Roles.Role;

    event SignerAdded(address indexed account);
    event SignerRemoved(address indexed account);

    Roles.Role private _signers;

    constructor () internal {
        _addSigner(_msgSender());
    }

    modifier onlySigner() {
        require(isSigner(_msgSender()), "SignerRole: caller does not have the Signer role");
        _;
    }

    function isSigner(address account) public view returns (bool) {
        return _signers.has(account);
    }

    function addSigner(address account) public onlySigner {
        _addSigner(account);
    }

    function renounceSigner() public {
        _removeSigner(_msgSender());
    }

    function _addSigner(address account) internal {
        _signers.add(account);
        emit SignerAdded(account);
    }

    function _removeSigner(address account) internal {
        _signers.remove(account);
        emit SignerRemoved(account);
    }
}

// File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol

pragma solidity ^0.5.0;



contract PauserRole is Context {
    using Roles for Roles.Role;

    event PauserAdded(address indexed account);
    event PauserRemoved(address indexed account);

    Roles.Role private _pausers;

    constructor () internal {
        _addPauser(_msgSender());
    }

    modifier onlyPauser() {
        require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
        _;
    }

    function isPauser(address account) public view returns (bool) {
        return _pausers.has(account);
    }

    function addPauser(address account) public onlyPauser {
        _addPauser(account);
    }

    function renouncePauser() public {
        _removePauser(_msgSender());
    }

    function _addPauser(address account) internal {
        _pausers.add(account);
        emit PauserAdded(account);
    }

    function _removePauser(address account) internal {
        _pausers.remove(account);
        emit PauserRemoved(account);
    }
}

// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol

pragma solidity ^0.5.0;



/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
contract Pausable is Context, PauserRole {
    /**
     * @dev Emitted when the pause is triggered by a pauser (`account`).
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by a pauser (`account`).
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state. Assigns the Pauser role
     * to the deployer.
     */
    constructor () internal {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    /**
     * @dev Called by a pauser to pause, triggers stopped state.
     */
    function pause() public onlyPauser whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Called by a pauser to unpause, returns to normal state.
     */
    function unpause() public onlyPauser whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// File: openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol

pragma solidity ^0.5.0;



/**
 * @title WhitelistAdminRole
 * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
 */
contract WhitelistAdminRole is Context {
    using Roles for Roles.Role;

    event WhitelistAdminAdded(address indexed account);
    event WhitelistAdminRemoved(address indexed account);

    Roles.Role private _whitelistAdmins;

    constructor () internal {
        _addWhitelistAdmin(_msgSender());
    }

    modifier onlyWhitelistAdmin() {
        require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
        _;
    }

    function isWhitelistAdmin(address account) public view returns (bool) {
        return _whitelistAdmins.has(account);
    }

    function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
        _addWhitelistAdmin(account);
    }

    function renounceWhitelistAdmin() public {
        _removeWhitelistAdmin(_msgSender());
    }

    function _addWhitelistAdmin(address account) internal {
        _whitelistAdmins.add(account);
        emit WhitelistAdminAdded(account);
    }

    function _removeWhitelistAdmin(address account) internal {
        _whitelistAdmins.remove(account);
        emit WhitelistAdminRemoved(account);
    }
}

// File: openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol

pragma solidity ^0.5.0;




/**
 * @title WhitelistedRole
 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
 * it), and not Whitelisteds themselves.
 */
contract WhitelistedRole is Context, WhitelistAdminRole {
    using Roles for Roles.Role;

    event WhitelistedAdded(address indexed account);
    event WhitelistedRemoved(address indexed account);

    Roles.Role private _whitelisteds;

    modifier onlyWhitelisted() {
        require(isWhitelisted(_msgSender()), "WhitelistedRole: caller does not have the Whitelisted role");
        _;
    }

    function isWhitelisted(address account) public view returns (bool) {
        return _whitelisteds.has(account);
    }

    function addWhitelisted(address account) public onlyWhitelistAdmin {
        _addWhitelisted(account);
    }

    function removeWhitelisted(address account) public onlyWhitelistAdmin {
        _removeWhitelisted(account);
    }

    function renounceWhitelisted() public {
        _removeWhitelisted(_msgSender());
    }

    function _addWhitelisted(address account) internal {
        _whitelisteds.add(account);
        emit WhitelistedAdded(account);
    }

    function _removeWhitelisted(address account) internal {
        _whitelisteds.remove(account);
        emit WhitelistedRemoved(account);
    }
}

// File: contracts/aave/ILendingPool.sol

pragma solidity ^0.5.8;

interface ILendingPool {
    function flashLoan(address payable _receiver, address _reserve, uint _amount, bytes calldata _params) external;

    function deposit(address _reserve, uint256 _amount, uint16 _referralCode) external payable;

    function setUserUseReserveAsCollateral(address _reserve, bool _useAsCollateral) external;

    function borrow(address _reserve, uint256 _amount, uint256 _interestRateMode, uint16 _referralCode) external;

    function repay(address _reserve, uint256 _amount, address payable _onBehalfOf) external;

    function getUserReserveData(address _reserve, address _user)
    external
    view
    returns (
        uint256 currentATokenBalance,
        uint256 currentBorrowBalance,
        uint256 principalBorrowBalance,
        uint256 borrowRateMode,
        uint256 borrowRate,
        uint256 liquidityRate,
        uint256 originationFee,
        uint256 variableBorrowIndex,
        uint256 lastUpdateTimestamp,
        bool usageAsCollateralEnabled
    );

    function getReserveData(address _reserve)
    external
    view
    returns (
        uint256 totalLiquidity,
        uint256 availableLiquidity,
        uint256 totalBorrowsStable,
        uint256 totalBorrowsVariable,
        uint256 liquidityRate,
        uint256 variableBorrowRate,
        uint256 stableBorrowRate,
        uint256 averageStableBorrowRate,
        uint256 utilizationRate,
        uint256 liquidityIndex,
        uint256 variableBorrowIndex,
        address aTokenAddress,
        uint40 lastUpdateTimestamp
    );
}

// File: contracts/aave/IAToken.sol

pragma solidity ^0.5.8;

interface IAToken {

    function balanceOf(address _user) external view returns (uint256);

    function redeem(uint256 _amount) external;

    function principalBalanceOf(address _user) external view returns (uint256);

    function getInterestRedirectionAddress(address _user) external view returns (address);

    function allowInterestRedirectionTo(address _to) external;

    function redirectInterestStream(address _to) external;

    function isTransferAllowed(address _user, uint256 _amount) external view returns (bool);

}

// File: contracts/ERC20.sol

pragma solidity ^0.5.8;

interface ERC20 {
    function totalSupply() external view returns (uint256 supply);

    function balanceOf(address _owner) external view returns (uint256 balance);

    function transfer(address _to, uint256 _value) external returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value)
    external
    returns (bool success);

    function approve(address _spender, uint256 _value) external returns (bool success);

    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    function decimals() external view returns (uint256 digits);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

// File: contracts/aave/ILendingPoolAddressesProvider.sol

pragma solidity ^0.5.8;

contract ILendingPoolAddressesProvider {

    function getLendingPool() public view returns (address);

    function setLendingPoolImpl(address _pool) public;

    function getLendingPoolCore() public view returns (address payable);

    function setLendingPoolCoreImpl(address _lendingPoolCore) public;

    function getLendingPoolConfigurator() public view returns (address);

    function setLendingPoolConfiguratorImpl(address _configurator) public;

    function getLendingPoolDataProvider() public view returns (address);

    function setLendingPoolDataProviderImpl(address _provider) public;

    function getLendingPoolParametersProvider() public view returns (address);

    function setLendingPoolParametersProviderImpl(address _parametersProvider) public;

    function getTokenDistributor() public view returns (address);

    function setTokenDistributor(address _tokenDistributor) public;


    function getFeeProvider() public view returns (address);

    function setFeeProviderImpl(address _feeProvider) public;

    function getLendingPoolLiquidationManager() public view returns (address);

    function setLendingPoolLiquidationManager(address _manager) public;

    function getLendingPoolManager() public view returns (address);

    function setLendingPoolManager(address _lendingPoolManager) public;

    function getPriceOracle() public view returns (address);

    function setPriceOracle(address _priceOracle) public;

    function getLendingRateOracle() public view returns (address);

    function setLendingRateOracle(address _lendingRateOracle) public;

}

// File: contracts/TokenConverter.sol

pragma solidity ^0.5.8;

interface TokenConverter {

    function swapMyErc(uint srcQty, address payable destAddress) external returns (uint256);

    function swapMyEth(address destAddress) external payable returns (uint256);
}

// File: contracts/ReInsuranceVault.sol

pragma solidity ^0.5.8;








contract ReInsuranceVault is WhitelistedRole {

    using SafeMath for uint256;

    ILendingPoolAddressesProvider public aaveAddressesProvider;
    TokenConverter public converter;

    address public ADAI_ADDRESS;
    address public AAVE_LENDING_POOL;
    address public AAVE_LENDING_POOL_CORE;
    address public DAI_ADDRESS;
    uint16 referralCode;

    address operator;

    constructor (address _operator, address _adai, address _aaveProvider, address _dai, uint16 _referralCode, address _converter) public {
        operator = _operator;
        converter = TokenConverter(_converter);
        aaveAddressesProvider = ILendingPoolAddressesProvider(_aaveProvider);
        ADAI_ADDRESS = _adai;
        AAVE_LENDING_POOL = aaveAddressesProvider.getLendingPool();
        AAVE_LENDING_POOL_CORE = aaveAddressesProvider.getLendingPoolCore();
        DAI_ADDRESS = _dai;
        referralCode = _referralCode;
    }

    /**
    * @dev Msg.sender deposits DAI into here, and the actual interest will be forwarded to 'operator'
    * Usually called by the Vault which holds DAI
    **/
    function deposit(uint _amount) public onlyWhitelistAdmin {
        address _user = msg.sender;
        // move token into here
        require(ERC20(DAI_ADDRESS).transferFrom(_user, address(this), _amount));
        depositAave(_amount);
    }

    function depositAave(uint _amount) public onlyWhitelistAdmin {
        ERC20(DAI_ADDRESS).approve(AAVE_LENDING_POOL_CORE, uint(- 1));
        ILendingPool(AAVE_LENDING_POOL).deposit(DAI_ADDRESS, _amount, referralCode);
        //TODO
        //Keep track of each the depositor's balance:
        //initial aToken + keep track of interest + terminal fee
        /*if (IAToken(ADAI_ADDRESS).getInterestRedirectionAddress(address(this)) == address(0)) {
            //first deposit
            //start redirecting interest to 'operator'
            IAToken(ADAI_ADDRESS).redirectInterestStream(operator);
        }*/
    }

    /**
    * @dev Msg.sender triggers the withdrawal from Aave, the DAI will be moved to the caller
    * Usually called by the Vault
    **/
    function withdraw(uint _amount) public onlyWhitelistAdmin {
        address _user = msg.sender;

        //if not used as a collateral
        require(IAToken(ADAI_ADDRESS).isTransferAllowed(address(this), _amount));
        IAToken(ADAI_ADDRESS).redeem(_amount);

        // return dai we have to user
        ERC20(DAI_ADDRESS).transfer(_user, _amount);
    }

    /**
    * @dev Operator withdraws his interest, receiving DAI back
    **/
    function withdrawInterest(uint _amount) public onlyWhitelistAdmin {
        //temporary move aDAI into here
        require(ERC20(ADAI_ADDRESS).transferFrom(msg.sender, address(this), _amount));
        withdraw(_amount);
    }

    function balance() external view returns (uint256) {
        return IAToken(ADAI_ADDRESS).balanceOf(address(this));
    }

    function getLendingAPY() external view returns (uint256) {
        (,,,,uint256 liquidityRate,,,,,,,,) = ILendingPool(AAVE_LENDING_POOL).getReserveData(DAI_ADDRESS);
        return liquidityRate;
    }

    /**
    * @dev Sums up (current) differences between cumulated aToken balance and historic deposit
    * And sums it up for every depositor
    **/
    function getLifetimeProfit() external view returns (uint256) {
        //TODO not really accurate data
        return ERC20(ADAI_ADDRESS).balanceOf(address(this));
    }
}

// File: contracts/Vault.sol

pragma solidity ^0.5.8;





contract Vault is WhitelistedRole {

    ReInsuranceVault public reInsuranceVault;
    TokenConverter public converter;
    ERC20 public token;

    event LogEthReceived(
        uint256 amount,
        address indexed account
    );

    event LogEthSent(
        uint256 amount,
        address indexed account
    );

    event LogTokenSent(
        uint256 amount,
        address indexed account
    );

    /**
    * @dev funding vault is allowed
    * Might be a free will or from a token converter
    **/
    function() external payable {
        emit LogEthReceived(msg.value, msg.sender);
    }

    constructor (address _operator, address _adai, address _aaveProvider, address _dai, uint16 _referralCode, address _converter) public {
        token = ERC20(_dai);
        converter = TokenConverter(_converter);
        reInsuranceVault = new ReInsuranceVault(_operator, _adai, _aaveProvider, _dai, _referralCode, _converter);
        reInsuranceVault.addWhitelistAdmin(_operator);
    }

    function withdrawDAI(uint256 _payment) public onlyWhitelistAdmin {
        require(_payment > 0 && token.balanceOf(address(this)) >= _payment, "Insufficient funds in the fund");
        token.transfer(msg.sender, _payment);
        emit LogTokenSent(_payment, msg.sender);
    }

    function withdrawETH(address payable _operator, uint256 _payment) public onlyWhitelistAdmin {
        require(address(this).balance > 0, 'Vault is empty');
        _operator.transfer(_payment);
        emit LogEthSent(_payment, _operator);
    }

    function depositReinsurance(uint _amount) public onlyWhitelistAdmin {
        uint256 _tokenAmount = converter.swapMyEth.value(_amount)(address(reInsuranceVault));
        reInsuranceVault.depositAave(_tokenAmount);
    }

    function withdrawReinsurance(uint _amount) public onlyWhitelistAdmin {
        //aDai -> DAI and move here
        reInsuranceVault.withdraw(_amount);
        //allow converter to use our DAI
        token.approve(address(converter), _amount);
        //convert DAI -> ETH and move it here
        converter.swapMyErc(_amount, address(this));
    }

    function balance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

}

// File: contracts/TrainDelay.sol

pragma solidity ^0.5.8;





/**
 * @title TrainDelay
 * @dev Autonomous machinery to register active protections, underwrite them and perform the payout if the event occurs
 *
 */
contract TrainDelay is SignerRole, Pausable {

    using SafeMath for uint256;
    uint256 public constant PROFIT_SHARE_THRESHOLD = 500 finney;
    uint256 public constant PROFIT_DISTRIBUTION = 10; //%

    Vault public vault;
    IUnderwriter public underwriter;

    struct Application {
        address payable holder;
        uint256 premium;
        uint256 payout60;
        uint256 payoutCancelled;
        bool valid;
    }

    struct Trip {
        bytes32 trainNumber;
        Application[] applications;
        uint256 cumulatedWeightedPayout;
    }

    mapping(bytes32 => Trip) public trips;
    uint256 public preservedPremiums;

    event ApplicationCreated
    (
        address payable holder,
        bytes32 tripId,
        uint256 tripIndex,
        bytes32 trainNumber,
        bytes32 origin,
        bytes32 destination,
        uint256 departureDateTime,
        uint256 arrivalDateTime,
        uint256 punctuality,
        uint256 premium,
        uint256[2] premiumMultipliers
    );

    event ApplicationResolved
    (
        address payable holder,
        uint256 premium,
        uint256 payout,
        bytes32 tripId
    );


    /**
    * @dev Default fallback function, just deposits funds to the vault
    */
    function() external payable {
        address(vault).transfer(msg.value);
    }

    constructor (address payable underwriterAddress, address _adai, address _aaveProvider, address _dai, uint16 _referralCode, address _converter) public {
        vault = new Vault(msg.sender, _adai, _aaveProvider, _dai, _referralCode, _converter);
        vault.addWhitelistAdmin(msg.sender);
        underwriter = IUnderwriter(underwriterAddress);
    }

    function applyForPolicy(
        bytes32 trainNumber,
        bytes32 origin,
        bytes32 destination,
        uint256 departureDateTime,
        uint256 arrivalDateTime,
        uint256 punctuality
    ) external payable whenNotPaused {
        uint256 premium = msg.value;
        address payable holder = msg.sender;
        require(underwriter.validPremium(premium), "TrainDelay: invalid premium");

        bytes32 tripId = keccak256(
            abi.encodePacked(trainNumber, departureDateTime, arrivalDateTime)
        );
        Trip storage trip = trips[tripId];
        if (trip.trainNumber == "") {
            //first policy for this trip
            trip.trainNumber = trainNumber;
        }

        uint256[2] memory premiumMultipliers = underwriter.getOrCreateRisk(trainNumber, punctuality);
        trip.cumulatedWeightedPayout = trip.cumulatedWeightedPayout.add(premium.mul(premiumMultipliers[1]).div(underwriter.getPrecision()));
        require(trip.cumulatedWeightedPayout <= underwriter.maxCumulatedPayout(), "TrainDelay: trip risk limit");

        Application memory application = Application(holder, premium,
            premium.mul(premiumMultipliers[0]).div(underwriter.getPrecision()),
            premium.mul(premiumMultipliers[1]).div(underwriter.getPrecision()),
            true);
        trip.applications.push(application);

        address(vault).transfer(premium);
        emit ApplicationCreated(holder, tripId, trip.applications.length - 1, trainNumber, origin, destination, departureDateTime, arrivalDateTime, punctuality, premium, premiumMultipliers);
    }

    function claimTripDelegated(bytes32 tripId, bytes32 cause) external onlySigner {
        for (uint8 i = 0; i < trips[tripId].applications.length; i++) {
            Application memory application = trips[tripId].applications[i];
            if (cause == '-1' || application.valid == false) {
                //missing arrival/departure data fot the trip
                //OR
                //this application was invalidated
                withdrawVault(application.premium, application.holder);
                emit ApplicationResolved(application.holder, application.premium, application.premium, tripId);
            }
            else if (cause == 0) {
                //on-time
                emit ApplicationResolved(application.holder, application.premium, 0, tripId);
                preservedPremiums = preservedPremiums.add(application.premium);
            }
            else if (cause == '60') {
                //delay
                withdrawVault(application.payout60, application.holder);
                emit ApplicationResolved(application.holder, application.premium, application.payout60, tripId);
            } else if (cause == 'cancelled') {
                //delay
                withdrawVault(application.payoutCancelled, application.holder);
                emit ApplicationResolved(application.holder, application.premium, application.payoutCancelled, tripId);
            }
            else {
                require(false, 'TrainDelay: cause not supported');
            }
        }
        shareProfit();
        resolveTrip(tripId);
    }

    function shareProfit() internal {
        if (preservedPremiums > PROFIT_SHARE_THRESHOLD) {
            vault.depositReinsurance(preservedPremiums.mul(PROFIT_DISTRIBUTION).div(100));
            preservedPremiums = 0;
        }
    }

    /**
    * @dev custodial invalidation of a particular application
    **/
    function invalidateApplication(bytes32 tripId, uint256 index) public onlySigner {
        trips[tripId].applications[index].valid = false;
    }

    function resolveTrip(bytes32 tripId) internal onlySigner {
        delete trips[tripId];
    }

    function withdrawVault(uint256 amount, address payable intermediary) public onlySigner {
        require(intermediary != address(0));
        vault.withdrawETH(intermediary, amount);
    }


    function replaceUnderwriter(address payable newUnderwriter) public onlySigner {
        underwriter = IUnderwriter(newUnderwriter);
    }

}

interface IUnderwriter {

    function getRisk(bytes32 trainNumber, uint256 punctuality) external view returns (uint256[2] memory);

    function getOrCreateRisk(bytes32 trainNumber, uint256 punctuality) external returns (uint256[2] memory);

    function validPremium(uint256 premium) external view returns (bool);

    function maxCumulatedPayout() external view returns (uint256);

    function getPrecision() external view returns (uint256);

}