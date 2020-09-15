/**
 *Submitted for verification at Etherscan.io on 2020-04-28
*/

pragma solidity 0.5.4;

// File: contracts/interfaces/IGovernanceRegistry.sol
/**
 * @title Governance Registry Interface
 */
interface IGovernanceRegistry {
    
    /**
     * @return true if @param account is a signee.
     */
    function isSignee(address account) external view returns (bool);

    /**
     * @return true if @param account is a vault.
     */
    function isVault(address account) external view returns (bool) ;

}

// File: contracts/interfaces/IToken.sol
/**
 * @title Token Interface
 * @dev Exposes token functionality
 */
interface IToken {

    function burn(uint256 amount) external ;

    function mint(address account, uint256 amount) external ;

}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol
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

    /**
     * @dev Emitted when the `owner` initiates a force transfer
     *
     * Note that `value` may be zero.
     * Note that `details` may be zero.
     */
    event ForceTransfer(address indexed from, address indexed to, uint256 value, bytes32 details);
}

// File: contracts/governance/Burner.sol
/**
 * @title Burner
 * @dev Burner contract for the AWG tokens.
 */
contract Burner {

    using SafeMath for uint256;

    uint256 public index;

    /**
     * @dev Fired when a token burn happens for the @param account.
     */
    event BurnFrom(address indexed account, address indexed vault, bytes32 indexed barId, uint256 value);

    /**
     * @dev Reference to governance registry contract.
     */
    IGovernanceRegistry public registry;

    /**
     * @dev Reference to minted token contract.
     */
    IToken public token;

    /**
     * @param governanceRegistry Deployed address of the Governance Registry smart contract.
     * @param mintedToken Specifies the minted token address.     
     */
    constructor(IGovernanceRegistry governanceRegistry, IToken mintedToken) public {
        registry = governanceRegistry;
        token = mintedToken;
    }

    /**
     * @notice Requires a call to `IERC20.approve` from @param account with the @param value to be burned.
     * @notice The spender param from the `IERC20.approve` function needs to be the address of the `Burner` contract (this).
     * @dev Burns tokens by transfering the 'to be burned' amount initially to this contract and then self burns the ammount. 
     * @param barId Use web3.utils.fromAscii(string).
     */
    function burn(address account, bytes32 barId ,uint256 value) onlyVault external {
        IERC20(address(token)).transferFrom(account, address(this), value);
        token.burn(value);
        emit BurnFrom(account, msg.sender, barId, value);          
    }

    /**
     * @dev Only a vault can call a function with this modifier.
     */
    modifier onlyVault() {
        require(registry.isVault(msg.sender), "Caller is not a vault");
        _;
    }
}