/**
 *Submitted for verification at Etherscan.io on 2020-05-16
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

// File: @openzeppelin/contracts/utils/Address.sol

pragma solidity ^0.5.5;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * IMPORTANT: It is unsafe to assume that an address for which this
     * function returns false is an externally-owned account (EOA) and not a
     * contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
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

// File: contracts/interfaces/iERC20Fulcrum.sol

pragma solidity 0.5.16;

interface iERC20Fulcrum {
  function mint(
    address receiver,
    uint256 depositAmount)
    external
    returns (uint256 mintAmount);

  function burn(
    address receiver,
    uint256 burnAmount)
    external
    returns (uint256 loanAmountPaid);

  function tokenPrice()
    external
    view
    returns (uint256 price);

  function supplyInterestRate()
    external
    view
    returns (uint256);

  function rateMultiplier()
    external
    view
    returns (uint256);
  function baseRate()
    external
    view
    returns (uint256);

  function borrowInterestRate()
    external
    view
    returns (uint256);

  function avgBorrowInterestRate()
    external
    view
    returns (uint256);

  function protocolInterestRate()
    external
    view
    returns (uint256);

  function spreadMultiplier()
    external
    view
    returns (uint256);

  function totalAssetBorrow()
    external
    view
    returns (uint256);

  function totalAssetSupply()
    external
    view
    returns (uint256);

  function nextSupplyInterestRate(uint256)
    external
    view
    returns (uint256);

  function nextBorrowInterestRate(uint256)
    external
    view
    returns (uint256);
  function nextLoanInterestRate(uint256)
    external
    view
    returns (uint256);
  function totalSupplyInterestRate(uint256)
    external
    view
    returns (uint256);

  function claimLoanToken()
    external
    returns (uint256 claimedAmount);

  function dsr()
    external
    view
    returns (uint256);

  function chaiPrice()
    external
    view
    returns (uint256);
}

// File: contracts/interfaces/ILendingProtocol.sol

pragma solidity 0.5.16;

interface ILendingProtocol {
  function mint() external returns (uint256);
  function redeem(address account) external returns (uint256);
  function nextSupplyRate(uint256 amount) external view returns (uint256);
  function nextSupplyRateWithParams(uint256[] calldata params) external view returns (uint256);
  function getAPR() external view returns (uint256);
  function getPriceInToken() external view returns (uint256);
  function token() external view returns (address);
  function underlying() external view returns (address);
  function availableLiquidity() external view returns (uint256);
}

// File: contracts/interfaces/IIdleToken.sol

/**
 * @title: Idle Token interface
 * @author: Idle Labs Inc., idle.finance
 */
pragma solidity 0.5.16;

interface IIdleToken {
  // view
  /**
   * IdleToken price calculation, in underlying
   *
   * @return : price in underlying token
   */
  function tokenPrice() external view returns (uint256 price);

  /**
   * underlying token decimals
   *
   * @return : decimals of underlying token
   */
  function tokenDecimals() external view returns (uint256 decimals);

  /**
   * Get APR of every ILendingProtocol
   *
   * @return addresses: array of token addresses
   * @return aprs: array of aprs (ordered in respect to the `addresses` array)
   */
  function getAPRs() external view returns (address[] memory addresses, uint256[] memory aprs);

  // external
  // We should save the amount one has deposited to calc interests

  /**
   * Used to mint IdleTokens, given an underlying amount (eg. DAI).
   * This method triggers a rebalance of the pools if needed
   * NOTE: User should 'approve' _amount of tokens before calling mintIdleToken
   * NOTE 2: this method can be paused
   *
   * @param _amount : amount of underlying token to be lended
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return mintedTokens : amount of IdleTokens minted
   */
  function mintIdleToken(uint256 _amount, uint256[] calldata _clientProtocolAmounts) external returns (uint256 mintedTokens);

  /**
   * @param _amount : amount of underlying token to be lended
   * @return : address[] array with all token addresses used,
   *                          eg [cTokenAddress, iTokenAddress]
   * @return : uint256[] array with all amounts for each protocol in order,
   *                   eg [amountCompound, amountFulcrum]
   */
  function getParamsForMintIdleToken(uint256 _amount) external returns (address[] memory, uint256[] memory);

  /**
   * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
   * This method triggers a rebalance of the pools if needed
   * NOTE: If the contract is paused or iToken price has decreased one can still redeem but no rebalance happens.
   * NOTE 2: If iToken price has decresed one should not redeem (but can do it) otherwise he would capitalize the loss.
   *         Ideally one should wait until the black swan event is terminated
   *
   * @param _amount : amount of IdleTokens to be burned
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return redeemedTokens : amount of underlying tokens redeemed
   */
  function redeemIdleToken(uint256 _amount, bool _skipRebalance, uint256[] calldata _clientProtocolAmounts)
    external returns (uint256 redeemedTokens);

  /**
   * @param _amount : amount of IdleTokens to be burned
   * @param _skipRebalance : whether to skip the rebalance process or not
   * @return : address[] array with all token addresses used,
   *                          eg [cTokenAddress, iTokenAddress]
   * @return : uint256[] array with all amounts for each protocol in order,
   *                   eg [amountCompound, amountFulcrum]
   */
  function getParamsForRedeemIdleToken(uint256 _amount, bool _skipRebalance)
    external returns (address[] memory, uint256[] memory);

  /**
   * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
   * and send interest-bearing tokens (eg. cDAI/iDAI) directly to the user.
   * Underlying (eg. DAI) is not redeemed here.
   *
   * @param _amount : amount of IdleTokens to be burned
   */
  function redeemInterestBearingTokens(uint256 _amount) external;

  /**
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return claimedTokens : amount of underlying tokens claimed
   */
  function claimITokens(uint256[] calldata _clientProtocolAmounts) external returns (uint256 claimedTokens);

  /**
   * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
   * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
   * @return : whether has rebalanced or not
   */
  function rebalance(uint256 _newAmount, uint256[] calldata _clientProtocolAmounts) external returns (bool);

  /**
   * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
   * @return : address[] array with all token addresses used,
   *                          eg [cTokenAddress, iTokenAddress]
   * @return : uint256[] array with all amounts for each protocol in order,
   *                   eg [amountCompound, amountFulcrum]
   */
  function getParamsForRebalance(uint256 _newAmount) external returns (address[] memory, uint256[] memory);
}

// File: contracts/IdlePriceCalculator.sol

/**
 * @title: Idle Price Calculator contract
 * @summary: Used for calculating the current IdleToken price in underlying (eg. DAI)
 *          price is: Net Asset Value / totalSupply
 * @author: Idle Labs Inc., idle.finance
 */
pragma solidity 0.5.16;






contract IdlePriceCalculator {
  using SafeMath for uint256;
  /**
   * IdleToken price calculation, in underlying (eg. DAI)
   *
   * @return : price in underlying token
   */
  function tokenPrice(
    uint256 totalSupply,
    address idleToken,
    address[] calldata currentTokensUsed,
    address[] calldata protocolWrappersAddresses
  )
    external view
    returns (uint256 price) {
      require(currentTokensUsed.length == protocolWrappersAddresses.length, "Different Length");

      if (totalSupply == 0) {
        return 10**(IIdleToken(idleToken).tokenDecimals());
      }

      uint256 currPrice;
      uint256 currNav;
      uint256 totNav;

      for (uint256 i = 0; i < currentTokensUsed.length; i++) {
        currPrice = ILendingProtocol(protocolWrappersAddresses[i]).getPriceInToken();
        // NAV = price * poolSupply
        currNav = currPrice.mul(IERC20(currentTokensUsed[i]).balanceOf(idleToken));
        totNav = totNav.add(currNav);
      }

      price = totNav.div(totalSupply); // idleToken price in token wei
  }
}