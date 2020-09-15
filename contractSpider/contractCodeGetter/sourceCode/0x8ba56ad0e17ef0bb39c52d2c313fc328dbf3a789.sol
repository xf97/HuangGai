/**
 *Submitted for verification at Etherscan.io on 2020-08-04
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
        require(b <= a, "SafeMath: subtraction overflow");
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
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
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
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
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
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
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
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
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
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/interfaces/IPriceOracleGetter.sol

pragma solidity ^0.5.0;

/**
* @title IPriceOracleGetter interface
* @notice Interface for the Aave price oracle.
**/

interface IPriceOracleGetter {
    /**
    * @dev returns the asset price in ETH
    * @param _asset the address of the asset
    * @return the ETH price of the asset
    **/
    function getAssetPrice(address _asset) external view returns (uint256);
}

// File: openzeppelin-solidity/contracts/utils/Address.sol

pragma solidity ^0.5.0;

/**
 * @dev Collection of functions related to the address type,
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * > It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol

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
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
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

// File: contracts/libraries/EthAddressLib.sol

pragma solidity ^0.5.0;

library EthAddressLib {

    /**
    * @dev returns the address used within the protocol to identify ETH
    * @return the address assigned to ETH
     */
    function ethAddress() internal pure returns(address) {
        return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    }
}

// File: contracts/libraries/UintConstants.sol

pragma solidity ^0.5.0;

library UintConstants {
    /**
    * @dev returns max uint256
    * @return max uint256
     */
    function maxUint() internal pure returns(uint256) {
        return uint256(-1);
    }

    /**
    * @dev returns max uint256-1
    * @return max uint256-1
     */
    function maxUintMinus1() internal pure returns(uint256) {
        return uint256(-1) - 1;
    }
}

// File: contracts/interfaces/IExchangeAdapter.sol

pragma solidity ^0.5.0;





contract IExchangeAdapter {
    using SafeERC20 for IERC20;

    event Exchange(
        address indexed from,
        address indexed to,
        address indexed platform,
        uint256 fromAmount,
        uint256 toAmount
    );

    function approveExchange(IERC20[] calldata _tokens) external;

    function exchange(address _from, address _to, uint256 _amount, uint256 _maxSlippage) external returns(uint256);
}

// File: contracts/interfaces/IKyberNetworkProxyInterface.sol

pragma solidity ^0.5.0;


interface IKyberNetworkProxyInterface {
    function maxGasPrice() external view returns(uint);
    function getUserCapInWei(address user) external view returns(uint);
    function getUserCapInTokenWei(address user, IERC20 token) external view returns(uint);
    function enabled() external view returns(bool);
    function info(bytes32 id) external view returns(uint);
    function getExpectedRate(IERC20 src, IERC20 dest, uint srcQty)
        external view returns (uint expectedRate, uint slippageRate);
    function tradeWithHint(
        IERC20 src,
        uint srcAmount,
        IERC20 dest,
        address destAddress,
        uint maxDestAmount,
        uint minConversionRate,
        address walletId,
        bytes calldata hint) external payable returns(uint);
}

// File: contracts/fees/KyberAdapter.sol

pragma solidity ^0.5.0;







/// @title KyberAdapter
/// @author Aave
/// @notice Implements the logic to exchange assets through KyberNetwork
/// The hardcoded parameters are:
/// 0x76B47460d7F7c5222cFb6b6A75615ab10895DDe4: AAVE_PRICES_PROVIDER. Contract providing prices of the assets

contract KyberAdapter is IExchangeAdapter {
    using SafeMath for uint256;

    uint256 public constant MAX_UINT = 2**256 - 1;

    uint256 public constant MAX_UINT_MINUS_ONE = (2 ** 256 - 1) - 1;

    /// @notice A value of 1 will execute the trade according to market price in the time of the transaction confirmation
    uint256 public constant MIN_CONVERSION_RATE = 1;

    /// @notice the address of the Aave price provider
    address public constant AAVE_PRICES_PROVIDER = 0x76B47460d7F7c5222cFb6b6A75615ab10895DDe4;

    address public constant KYBER_ETH_MOCK_ADDRESS = address(
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
    );

    /// @notice Kyber Proxy contract to trade tokens/ETH to tokenToBurn
    IKyberNetworkProxyInterface public constant KYBER_PROXY = IKyberNetworkProxyInterface(
        0x9AAb3f75489902f3a48495025729a0AF77d4b11e
    );

    event KyberAdapterSetup(address oneSplit, address priceOracle, uint256 splitParts);

    /// @notice "Infinite" approval for all the tokens initialized
    /// @param _tokens the list of token addresses to approve
    function approveExchange(IERC20[] calldata _tokens) external {
        for (uint256 i = 0; i < _tokens.length; i++) {
            if (address(_tokens[i]) != EthAddressLib.ethAddress()) {
                _tokens[i].safeApprove(address(KYBER_PROXY), MAX_UINT_MINUS_ONE);
            }
        }
    }

    /// @notice Exchanges _amount of _from token (or ETH) to _to token (or ETH)
    /// - Uses EthAddressLib.ethAddress() as the reference on 1Split of ETH
    /// @param _from The asset to exchange from
    /// @param _to The asset to exchange to
    /// @param _amount The amount to exchange
    /// @param _maxSlippage Max slippage acceptable, taken into account after the goodSwap()
    function exchange(address _from, address _to, uint256 _amount, uint256 _maxSlippage)
        external
        returns (uint256)
    {
        address _kyberFromRef = _from;
        uint256 value = 0;

        if (_from == EthAddressLib.ethAddress()) {
            value = _amount;
        }

        //as kyber uses a different proxy address for the USDT token, we internally
        //remap the address used in the protocol with the proxy used by kyber
        if (_from == 0x0000000000085d4780B73119b644AE5ecd22b376) {
            _kyberFromRef = 0x8dd5fbCe2F6a956C3022bA3663759011Dd51e73E;
        }

        uint256 _fromAssetPriceInWei = IPriceOracleGetter(AAVE_PRICES_PROVIDER).getAssetPrice(
            _from
        );
        uint256 _toAssetPriceInWei = IPriceOracleGetter(AAVE_PRICES_PROVIDER).getAssetPrice(_to);
        uint256 _toBalanceBefore = IERC20(_to).balanceOf(address(this));

        uint256 _amountReceived = KYBER_PROXY.tradeWithHint.value(value)(
            // _from token (or ETH mock address)
            IERC20(_kyberFromRef),
            // amount of the _from token to trade
            _amount,
            // _to token (or ETH mock address)
            IERC20(_to),
            // address which will receive the _to token amount traded
            address(this),
            // max amount to receive, no limit, using the max uint
            MAX_UINT,
            // conversion rate, use 1 for market price
            MIN_CONVERSION_RATE,
            // Related with a referral program, not needed
            0x0000000000000000000000000000000000000000,
            // Related with filtering of reserves by permisionless or not. Not needed
            ""
        );


        require(
            (_toAssetPriceInWei.mul(_amountReceived).mul(100)).div(
                    _fromAssetPriceInWei.mul(_amount)
                ) >=
                (100 - _maxSlippage),
            "INVALID_SLIPPAGE"
        );

        emit Exchange(
            _from,
            _to,
            0x1814222fa8c8c1C1bf380e3BBFBd9De8657Da476,
            _amount,
            _amountReceived
        );
        return _amountReceived;
    }
}