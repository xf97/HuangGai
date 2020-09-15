/**
 *Submitted for verification at Etherscan.io on 2020-05-25
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

// File: @openzeppelin/contracts/utils/Address.sol

pragma solidity ^0.5.5;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following 
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol

pragma solidity ^0.5.0;




/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: contracts/handlers/aave/IAToken.sol

pragma solidity ^0.5.0;

interface IAToken {
    function underlyingAssetAddress() external returns(address);
    function redirectInterestStream(address _to) external;
    function redirectInterestStreamOf(address _from, address _to) external;
    function allowInterestRedirectionTo(address _to) external;
    function redeem(uint256 _amount) external;
    function principalBalanceOf(address _user) external view returns(uint256);
    function isTransferAllowed(address _user, uint256 _amount) external view returns (bool);
    function getUserIndex(address _user) external view returns(uint256);
    function getInterestRedirectionAddress(address _user) external view returns(address);
    function getRedirectedBalance(address _user) external view returns(uint256);

    function totalSupply() external view returns (uint256 supply);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

// File: contracts/handlers/aave/ILendingPool.sol

pragma solidity ^0.5.0;

interface ILendingPool {
	function addressesProvider() external view returns(address);
	function deposit(address _reserve, uint256 _amount, uint16 _referralCode) external payable;
	function redeemUnderlying(address _reserve, address _user, uint256 _amount) external;
	function borrow(address _reserve, uint256 _amount, uint256 _interestRateMode, uint16 _referralCode) external;
	function repay(address _reserve, uint256 _amount, address _onBehalfOf) external payable;
	function swapBorrowRateMode(address _reserve) external;
	function rebalanceFixedBorrowRate(address _reserve, address _user) external;
	function setUserUseReserveAsCollateral(address _reserve, bool _useAsCollateral) external;
	function liquidationCall(address _collateral, address _reserve, address _user, uint256 _purchaseAmount, bool _receiveAToken) external payable;
	function flashLoan(address _receiver, address _reserve, uint256 _amount, bytes calldata _params) external;
	function getReserveConfigurationData(address _reserve) external view returns(uint256 ltv, uint256 liquidationThreshold, uint256 liquidationDiscount, address interestRateStrategyAddress, bool usageAsCollateralEnabled, bool borrowingEnabled, bool fixedBorrowRateEnabled, bool isActive);
	function getReserveData(address _reserve) external view returns(uint256 totalLiquidity, uint256 availableLiquidity, uint256 totalBorrowsFixed, uint256 totalBorrowsVariable, uint256 liquidityRate, uint256 variableBorrowRate, uint256 fixedBorrowRate, uint256 averageFixedBorrowRate, uint256 utilizationRate, uint256 liquidityIndex, uint256 variableBorrowIndex, address aTokenAddress, uint40 lastUpdateTimestamp);
	function getUserAccountData(address _user) external view returns(uint256 totalLiquidityETH, uint256 totalCollateralETH, uint256 totalBorrowsETH, uint256 availableBorrowsETH, uint256 currentLiquidationThreshold, uint256 ltv, uint256 healthFactor);
	function getUserReserveData(address _reserve, address _user) external view returns(uint256 currentATokenBalance, uint256 currentBorrowBalance, uint256 principalBorrowBalance, uint256 borrowRateMode, uint256 borrowRate, uint256 liquidityRate, uint256 originationFee, uint256 variableBorrowIndex, uint256 lastUpdateTimestamp, bool usageAsCollateralEnabled);
	function getReserves() external view;
}

// File: contracts/handlers/aave/ILendingPoolCore.sol

pragma solidity ^0.5.0;

interface ILendingPoolCore {
	function getReserveATokenAddress(address _reserve) external view returns (address);
}

// File: contracts/handlers/aave/ILendingPoolAddressesProvider.sol

pragma solidity ^0.5.0;

interface ILendingPoolAddressesProvider {
    function getLendingPool() external view returns (address);
    function setLendingPoolImpl(address _pool) external;

    function getLendingPoolCore() external view returns (address payable);
    function setLendingPoolCoreImpl(address _lendingPoolCore) external;

    function getLendingPoolConfigurator() external view returns (address);
    function setLendingPoolConfiguratorImpl(address _configurator) external;

    function getLendingPoolDataProvider() external view returns (address);
    function setLendingPoolDataProviderImpl(address _provider) external;

    function getLendingPoolParametersProvider() external view returns (address);
    function setLendingPoolParametersProviderImpl(address _parametersProvider) external;

    function getTokenDistributor() external view returns (address);
    function setTokenDistributor(address _tokenDistributor) external;

    function getFeeProvider() external view returns (address);
    function setFeeProviderImpl(address _feeProvider) external;

    function getLendingPoolLiquidationManager() external view returns (address);
    function setLendingPoolLiquidationManager(address _manager) external;

    function getLendingPoolManager() external view returns (address);
    function setLendingPoolManager(address _lendingPoolManager) external;

    function getPriceOracle() external view returns (address);
    function setPriceOracle(address _priceOracle) external;

    function getLendingRateOracle() external view returns (address);
    function setLendingRateOracle(address _lendingRateOracle) external;
}

// File: contracts/handlers/aave/FlashLoanReceiverBase.sol

pragma solidity ^0.5.0;






contract FlashLoanReceiverBase {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    address constant PROVIDER = 0x24a42fD28C976A61Df5D00D0599C34c4f90748c8;
    address constant ETHADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    function transferFundsBackToPoolInternal(address _reserve, uint256 _amount)
        internal
    {
        address payable core = ILendingPoolAddressesProvider(PROVIDER)
            .getLendingPoolCore();

        transferInternal(core, _reserve, _amount);
    }

    function transferInternal(
        address payable _destination,
        address _reserve,
        uint256 _amount
    ) internal {
        if (_reserve == ETHADDRESS) {
            _destination.call.value(_amount)("");
            return;
        }
        IERC20(_reserve).safeTransfer(_destination, _amount);
    }

    function getBalanceInternal(address _target, address _reserve)
        internal
        view
        returns (uint256)
    {
        if (_reserve == ETHADDRESS) {
            return _target.balance;
        }
        return IERC20(_reserve).balanceOf(_target);
    }
}

// File: contracts/handlers/HandlerBase.sol

pragma solidity ^0.5.0;


contract HandlerBase {
    address[] public tokens;

    function _updateToken(address token) internal {
        tokens.push(token);
    }
}

// File: contracts/handlers/aave/HAaveProtocol.sol

pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;


interface IProxy {
    function execs(address[] calldata tos, bytes[] calldata datas) external;
}

contract HAaveProtocol is HandlerBase, FlashLoanReceiverBase {
    using SafeERC20 for IERC20;
    
    uint16 constant REFERRAL_CODE = 56;

    function flashLoan(
        address _reserve,
        uint256 _amount,
        bytes calldata _params
    ) external payable {
        ILendingPool lendingPool = ILendingPool(
            ILendingPoolAddressesProvider(PROVIDER).getLendingPool()
        );
        lendingPool.flashLoan(address(this), _reserve, _amount, _params);

        // Update involved token
        if (_reserve != ETHADDRESS) _updateToken(_reserve);
    }

    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    ) external payable {
        (address[] memory tos, bytes[] memory datas) = abi.decode(
            _params,
            (address[], bytes[])
        );
        IProxy(address(this)).execs(tos, datas);
        transferFundsBackToPoolInternal(_reserve, _amount.add(_fee));
    }

    function deposit(
        address _reserve,
        uint256 _amount
    ) external payable {
        ILendingPool lendingPool = ILendingPool(
            ILendingPoolAddressesProvider(PROVIDER).getLendingPool()
        );

        if (_reserve == ETHADDRESS) {
            lendingPool.deposit.value(_amount)(_reserve, _amount, REFERRAL_CODE);
        } else {
            address lendingPoolCore = ILendingPoolAddressesProvider(PROVIDER).getLendingPoolCore();
            IERC20(_reserve).safeApprove(lendingPoolCore, _amount);
            lendingPool.deposit(_reserve, _amount, REFERRAL_CODE);
            IERC20(_reserve).safeApprove(lendingPoolCore, 0);
        }
        
        address aToken = _getAToken(_reserve);
        _updateToken(aToken);
    }

    function redeem(
        address _aToken,
        uint256 _amount
    ) external payable {
        IAToken(_aToken).redeem(_amount);
        address underlyingAsset = IAToken(_aToken).underlyingAssetAddress();
        if (underlyingAsset != ETHADDRESS)  _updateToken(underlyingAsset);
    }

    function _getAToken(address _reserve) internal view returns(address) {
        ILendingPoolCore lendingPoolCore = ILendingPoolCore(
            ILendingPoolAddressesProvider(PROVIDER).getLendingPoolCore()
        );
        address aToken = lendingPoolCore.getReserveATokenAddress(_reserve);
        require(aToken != address(0), "aToken should not be zero address");

        return aToken;
    }
}