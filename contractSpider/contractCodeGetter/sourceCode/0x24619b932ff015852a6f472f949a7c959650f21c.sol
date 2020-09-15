/**
 *Submitted for verification at Etherscan.io on 2020-07-25
*/

// SPDX-License-Identifier: MIT AND CC0-1.0

/*

 /$$   /$$                                          /$$           /$$                 /$$                
| $$  | $$                                         | $$          | $$                | $$                
| $$  | $$  /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$/$$$$$$        | $$        /$$$$$$ | $$$$$$$   /$$$$$$$
| $$$$$$$$ /$$__  $$| $$__  $$ /$$__  $$ /$$_____/_  $$_/        | $$       |____  $$| $$__  $$ /$$_____/
| $$__  $$| $$  \ $$| $$  \ $$| $$$$$$$$|  $$$$$$  | $$          | $$        /$$$$$$$| $$  \ $$|  $$$$$$ 
| $$  | $$| $$  | $$| $$  | $$| $$_____/ \____  $$ | $$ /$$      | $$       /$$__  $$| $$  | $$ \____  $$
| $$  | $$|  $$$$$$/| $$  | $$|  $$$$$$$ /$$$$$$$/ |  $$$$/      | $$$$$$$$|  $$$$$$$| $$$$$$$/ /$$$$$$$/
|__/  |__/ \______/ |__/  |__/ \_______/|_______/   \___/        |________/ \_______/|_______/ |_______/ 
                                                                                                         
                                                                                                         
'Honest Token ' token contract
Deployed to :    0x24619b932ff015852a6f472f949a7c959650f21c
Symbol      :   HTK
Name        :   Honest Token 
Total supply:   5,000,000
Decimals    :   18          
ICO Website :   honestlabs.win                                                                                                                                                                                                              
                                                                                                                                         
                                                                                                      
                                                                                                      
Visit our website at www.HonestLabs.win
Follow our first project in www.HonestTree.win or htree.win

The Honest Token is the Funds-Distribution Honest Labs' native token.

It is a ERC-20 token with the implementation of the ERC-2222 Fund Distribution Standar.

This means that any funds in ETHER that is sent to this contract (The token contract) will be 
proportionally distributed among token holders, even if token holders sell their tokens before 
having withdrawn their dividends.

This allows token holders to earn dividends in all projects that will pay it's revenues to the token contract.

In order to buy Honest Tokens (HTK), please go to www.honestlabs.win or just send funds to
the TOKEN ICO CROWDSALE contract: 0x474d52047c62545d596b22ee953f290d51fa1ac2!!

You can verify that 0x474d52047c62545d596b22ee953f290d51fa1ac2 is the ICO contract address in Etherscan using Metamask.
Read the variable: tokenSaleContractAddress().

If you read the code you will see that this address can be set only once. The variable tokenSaleContractAddressSetAndMinted should be "true"

If you send money to this contract (token contract address 0x474d52047c62545d596b22ee953f290d51fa1ac2),
your ETHER will be distributed among HTK token holders, but you won't receive any HTK. Prefer to buy HTK in the honestlabs.win webpage.

For Pre-ICO and ICO purposes, tokens transfer won't be allowed yet.
The only addresses that will be allowed to transfer tokens will be the ICO contract and The Honest Tree and Pharaoh Games contracts (for bounty)
After ICO (December 30th 2020, you will be able to transfer tokens and sell them on any exchange)
Check that tokenTransfersAllowed=true;
_________________________________________________

As written in the ICO webpage:
- Total Suppply:  5,000,000
- Pre-ICO and ICO: 85% = 4,250,000 (tranferred to the token ico crowdsale contract)
- Team: 8% = 400,000, sent to the team address
- Consultants: 4% = 200,000, sent to 3 addresses of our 3 Consultants
- Bounty Programs: 6% = 150,000 sent to the bounty address

One example of the bounty program is the 500 free HTK tokens that all 100 fist players of The Honest Tree game will receive.
This 50,000 tokens will be sent from this contract directly to the Honest Tree Game contract. Read the code.
The rest 150,000 will be sent to an address from where we will only send these tokens to our next 3 projects
(See www.honestlabs.win)

_____________________________________________________


The first project to implement this Funds Distribution Payment is The Honest Tree (visit www.honesttree.win)

All root node rewards are distibuted proportionally among Honest Tokens (HTK) holders!!!!

Buy HTK tokens in: http://www.honestlabs.win

IMPORTANT: In order for you to claim your Honest Tree root node's dividends, you must make sure to hold 
Honest Tree Tokens (HTTs) at the time of Honest Tree's root node's withdraw moment (every 15 days).
After any of those moments, you can safely sell or transfer your tokens, even before having withdrawn your funds,
and your past dividends will be honored. However, if you sell or transfer your HTT tokens, 
your won't receive any future Honest Tree's dividends.
*****

What is ERC-2222 ?
The ERC-2222 standard enables the token to represent claims on future cash flow of an asset
such as dividends, loan repayments, fee or revenue shares. This means that any incoming funds
can be distributed efficiently among large numbers of token holders.
Anyone can deposit funds and token holders can withdraw their claims.

The MOST IMPORTANT FEATURE OF ERC-222 STANDARD is that token holders CAN TRANSFER THEIR TOKENS
at any time and can be sure that their PAST CLAIMS TO THE CASH FLOW of the token WILL BE HONORED.

The interface provides methods to deposit funds, to get information about available funds and to withdraw funds.

In this implementation, payments are made in Ethers, and token holders are seen as fractional
owners of any future cash flow (mainly Honest Tree's root node's rewards, distributed very 90 days)


For more information see: https://github.com/ethereum/EIPs/issues/2222
This contact was based on the ERC-2222 implementation available in:
https://github.com/atpar/funds-distribution-token



This contract address: 0x474d52047c62545d596b22ee953f290d51fa1ac2
The Token Sale (ICO) contract address: 0x474d52047c62545d596b22ee953f290d51fa1ac2
The Honest Tree contract address: 0x8807b4d063359b8ed65cce6b5c540c84717a6a5e
The Pharaoh game contract address: Not set yet at the moment of contract verification (see functions)


*/






// File: contracts/openzeppelin-contracts/contracts/GSN/Context.sol
// SPDX-License-Identifier: MIT


pragma solidity ^0.6.0;

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
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: contracts/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol

// Licence: MIT

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
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

// File: contracts/openzeppelin-contracts/contracts/math/SafeMath.sol

// Licence: MIT

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
     *
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
     *
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
     *
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
     *
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/openzeppelin-contracts/contracts/utils/Address.sol

// Licence: MIT

pragma solidity ^0.6.2;

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
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: contracts/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol

// Licence: MIT

pragma solidity ^0.6.0;





/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

// File: contracts/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol

// Licence: MIT

pragma solidity ^0.6.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () internal {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: contracts/openzeppelin-contracts/contracts/access/Ownable.sol

// Licence: MIT

pragma solidity ^0.6.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: contracts/SafeMathUint.sol

// Licence: CC0-1.0
pragma solidity  ^0.6.2;
// Original code from https://github.com/atpar/funds-distribution-token/blob/master/contracts/external/math/SafeMathUint.sol

/**
 * @title SafeMathUint
 * @dev Math operations with safety checks that revert on error
 */
library SafeMathUint {
  function toInt256Safe(uint256 a) internal pure returns (int256) {
    int256 b = int256(a);
    require(b >= 0);
    return b;
  }
}

// File: contracts/SafeMathInt.sol

// Licence CC0-1.0
pragma solidity ^0.6.2;
// Original code from https://github.com/atpar/funds-distribution-token/blob/master/contracts/external/math/SafeMathInt.sol

/**
 * @title SafeMathInt
 * @dev Math operations with safety checks that revert on error
 * @dev SafeMath adapted for int256
 * Based on code of  https://github.com/RequestNetwork/requestNetwork/blob/master/packages/requestNetworkSmartContracts/contracts/base/math/SafeMathInt.sol
 */
library SafeMathInt {
  function mul(int256 a, int256 b) internal pure returns (int256) {
    // Prevent overflow when multiplying INT256_MIN with -1
    // https://github.com/RequestNetwork/requestNetwork/issues/43
    require(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));

    int256 c = a * b;
    require((b == 0) || (c / b == a));
    return c;
  }

  function div(int256 a, int256 b) internal pure returns (int256) {
    // Prevent overflow when dividing INT256_MIN by -1
    // https://github.com/RequestNetwork/requestNetwork/issues/43
    require(!(a == - 2**255 && b == -1) && (b > 0));

    return a / b;
  }

  function sub(int256 a, int256 b) internal pure returns (int256) {
    require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));

    return a - b;
  }

  function add(int256 a, int256 b) internal pure returns (int256) {
    int256 c = a + b;
    require((b >= 0 && c >= a) || (b < 0 && c < a));
    return c;
  }

  function toUint256Safe(int256 a) internal pure returns (uint256) {
    require(a >= 0);
    return uint256(a);
  }
}

// File: contracts/HonestToken.sol

// Licence: MIT
/*

 /$$   /$$                                          /$$           /$$                 /$$                
| $$  | $$                                         | $$          | $$                | $$                
| $$  | $$  /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$/$$$$$$        | $$        /$$$$$$ | $$$$$$$   /$$$$$$$
| $$$$$$$$ /$$__  $$| $$__  $$ /$$__  $$ /$$_____/_  $$_/        | $$       |____  $$| $$__  $$ /$$_____/
| $$__  $$| $$  \ $$| $$  \ $$| $$$$$$$$|  $$$$$$  | $$          | $$        /$$$$$$$| $$  \ $$|  $$$$$$ 
| $$  | $$| $$  | $$| $$  | $$| $$_____/ \____  $$ | $$ /$$      | $$       /$$__  $$| $$  | $$ \____  $$
| $$  | $$|  $$$$$$/| $$  | $$|  $$$$$$$ /$$$$$$$/ |  $$$$/      | $$$$$$$$|  $$$$$$$| $$$$$$$/ /$$$$$$$/
|__/  |__/ \______/ |__/  |__/ \_______/|_______/   \___/        |________/ \_______/|_______/ |_______/ 
                                                                                                         
                                                                                                         
                                                                                                       
                                                                                                      
                                                                                                      
Visit our website at www.honestlabs.win
Follow our first project in www.honesttree.win or htree.win

The Honest Token is the Funds-Distribution Honest Labs' native token.

It is a ERC-20 token with the implementation of the ERC-2222 Fund Distribution Standar.

This means that any funds in ETHER that is sent to this contract (The token contract) will be 
proportionally distributed among token holders, even if token holders sell their tokens before 
having withdrawn their dividends.

This allows token holders to earn dividends in all projects that will pay it's revenues to the token contract.

In order to buy Honest Tokens (HTK), please go to www.honestlabs.win or just send funds to
the TOKEN ICO CROWDSALE contract!!

The see the  TOKEN ICO CROWDSALE CONTRACT please read this contract in Etherscan using Metamask, and read the variable:
tokenSaleContractAddress().
If you read the code you will see that this address can be set only once. The variable tokenSaleContractAddressSetAndMinted should be "true"

Please don't send any funds to this contract, unless you want to experiment on the funds distribution mechanism
(or unless you want to give away Ethers to HTK tokens holdes :P )


For Pre-ICO and ICO purposes, tokens transfer won't be allowed yet.
The only addresses that will be allowed to transfer tokens will be the ICO contract and The Honest Tree Game contract (for bounty)
After ICO (December 30th 2020, you will be able to transfer tokens and sell them on any exchange)
Check that tokenTransfersAllowed=true;
_________________________________________________

As written in the ICO webpage:
- Total Suppply:  5,000,000
- Pre-ICO and ICO: 85% = 4,250,000 (tranferred to the token ico crowdsale contract)
- Team: 8% = 400,000, sent to the team address
- Consultants: 4% = 200,000, sent to 3 addresses of our 3 Consultants
- Bounty Programs: 6% = 150,000 sent to the bounty address

One example of the bounty program is the 500 free HTK tokens that all 100 fist players of The Honest Tree game will receive.
This 50,000 tokens will be sent from this contract directly to the Honest Tree Game contract. Read the code.
The rest 150,000 will be sent to an address from where we will only send these tokens to our next 3 projects
(See www.honestlabs.win)

_____________________________________________________


The first project to implement this Funds Distribution Payment is The Honest Tree (visit www.honesttree.win)

All root node rewards are distibuted proportionally among Honest Tokens (HTK) holders!!!!

Buy HTK tokens in: http://www.honestlabs.win

IMPORTANT: In order for you to claim your Honest Tree root node's dividends, you must make sure to hold 
Honest Tokens (HTKs) at the time of Honest Tree's root node's withdraw moment (every 15 days).
After any of those moments, you can safely sell or transfer your tokens, even before having withdrawn your funds,
and your past dividends will be honored. However, if you sell or transfer your HTT tokens, 
your won't receive any future Honest Tree's dividends.
*****

What is ERC-2222 ?
The ERC-2222 standard enables the token to represent claims on future cash flow of an asset
such as dividends, loan repayments, fee or revenue shares. This means that any incoming funds
can be distributed efficiently among large numbers of token holders.
Anyone can deposit funds and token holders can withdraw their claims.

The MOST IMPORTANT FEATURE OF ERC-222 STANDARD is that token holders CAN TRANSFER THEIR TOKENS
at any time and can be sure that their PAST CLAIMS TO THE CASH FLOW of the token WILL BE HONORED.

The interface provides methods to deposit funds, to get information about available funds and to withdraw funds.

In this implementation, payments are made in Ethers, and token holders are seen as fractional
owners of any future cash flow (mainly Honest Tree's root node's rewards, distributed very 90 days)


For more information see: https://github.com/ethereum/EIPs/issues/2222
This contact was based on the ERC-2222 implementation available in:
https://github.com/atpar/funds-distribution-token

*/

pragma solidity  0.6.10;







contract HonestLabsToken is ERC20, ReentrancyGuard, Ownable{
    using SafeMath for uint256;
	using SafeMathUint for uint256;
	using SafeMathInt for int256;
	
	//see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
	uint256 constant internal pointsMultiplier = 2**128;
	uint256 internal pointsPerShare;

	mapping(address => int256) private pointsCorrection;
	mapping(address => uint256) private withdrawnFunds;
	
    uint256 public creationDate;
    
    
    uint256 public ICO_deadline;
	bool public tokenTransfersAllowed;
	
    
    
    /*
    HTK totalSupply will be 5000000 HTK (5,000,000)
    
    Distributed in the following way:
    
    * 4,250,000 (85%) for Pre-ICO and ICO Crowdsale.
    * 400,000 (8%) for the developers team. 
    * 200,000 (6%) for consultants:
        100,000 for consultant 1
        50,000 for consultant 2
        50,000 for consultant 3
    * 150,000 for bounty
        50,000 for The Honest Tree Ambassadors
        50,000 for the Pharaoh
        50,000 for the Exchange
    */
    
    // Token ICO Crowdsale contract
    address public tokenSaleContractAddress;
    
    // Crowdsale tokens are only minted once
	bool public tokenSaleContractAddressSetAndMinted; 
	
	 
	// Hence, the game contract should hold them
	address public HonestTreeGameContractAddress;
	// Honest Tree Game tokens are only minted once
	bool public HonestTreeGameTokensMinted;
	
	
	// The Pharaoh Game will also have bounty tokens
	address public PharaohGameContractAddress;
	// The Pharaoh Game tokens are only minted once
	bool public PharaohGameTokensMinted;
	
	
	
    constructor() ERC20("Honest Token", "HTK") public {
        tokenTransfersAllowed=false;
        tokenSaleContractAddressSetAndMinted=false;
        HonestTreeGameTokensMinted=false;
        _mint(address(0x42097Ca4Dd76059433518F4723C67A91a76f2a11),400000* 10**18); // Team 400,000
        _mint(address(0xD42063e7F95e948d1e3d938E392C16eED4be9B61), 100000 * 10**18); //Gemke 100,000
        _mint(address(0xd78e22A144318CDEC8cab092621A6bB259bd78E2), 50000 * 10**18); //Berend-jan 50,000
        _mint(address(0x78B7999dd49F29071ffc40cB247e8f561ed2E814), 50000 * 10**18); //Tyler 50,000
        _mint(address(0xcf2cC5Cc5B10327CeD00000b34b4010092660aA3),50000* 10**18); // 50,000 For the Exchange Bounty programs
    
        creationDate=now;
        
        //Epoch timestamp: 1609459199
        // Date and time (GMT): Thursday, December 31, 2020 23:59:59 
        ICO_deadline=1609459199;
    }
    
    function setTokenSaleAddressAndMintTokens(address _tokenSaleContractAddress) 
        public
        onlyOwner
        nonReentrant
        returns (bool) {
            //Token Sale Contract is set only once. Tokens are minted only once.
            require(!tokenSaleContractAddressSetAndMinted);
            
            require(_tokenSaleContractAddress != address(this),'The sale contract address should be different as this one');
            require(_tokenSaleContractAddress != address(0x0),'Cannot be the 0x0 address');
            
            tokenSaleContractAddress = _tokenSaleContractAddress;
            _mint(tokenSaleContractAddress, 4250000 * 10**18); //4,250,000
            
            //This function can never be called again:
            tokenSaleContractAddressSetAndMinted=true;
            return true;
   }
   
   function setHonestTreeGameContractAddressAndMintTokens(address _HonestTreeGameContractAddress) 
        public
        onlyOwner
        nonReentrant
        returns (bool) {
            //Honest Tree Game Contract Address is set only once. Tokens are minted only once.
            require(!HonestTreeGameTokensMinted);
            
            require(_HonestTreeGameContractAddress != address(this),'The game address should be different as this one');
            require(_HonestTreeGameContractAddress != address(0x0),'The game address cannot be 0x0');
            
            HonestTreeGameContractAddress = _HonestTreeGameContractAddress;
            uint256 gameTokensAmount=(50000 * 10**18); //500 for the first 100 players
            _mint(HonestTreeGameContractAddress, gameTokensAmount);
            //This function can never be called again:
            HonestTreeGameTokensMinted=true;
            return true;
   }
   
   
    function setPharaohGameContractAddressAndMintTokens(address _PharaohGameContractAddress) 
        public
        onlyOwner
        nonReentrant
        returns (bool) {
            //Pharaoh Game Contract Address is set only once. Tokens are minted only once.
            require(!PharaohGameTokensMinted);
            
            require(_PharaohGameContractAddress != address(this),'The game address should be different as this one');
            require(_PharaohGameContractAddress != address(0x0),'The game address cannot be 0x0');
            
            PharaohGameContractAddress = _PharaohGameContractAddress;
            uint256 gameTokensAmount=(50000 * 10**18); //500 for the first 100 players
            _mint(PharaohGameContractAddress, gameTokensAmount);
            //This function can never be called again:
            PharaohGameTokensMinted=true;
            return true;
   }
   
   /*
	 * Tokens transfer (other from game contract and sale contract) are only allowed 
	 * after 120 days of the contract creation.
	 * Anyone can call this function in order to allow token transfer
	 */
    
    function allowTokenTransfer() public {
      
      require(!tokenTransfersAllowed,'Token Transfer are already allowed');
      
        
      require(now>ICO_deadline,'Wait until 31 December 2020, 23:59:59');
      
      // From now on, anyone can transfer and sale their tokens :). Moon!
      tokenTransfersAllowed = true;
      emit tokenTransfersAllowedEvent();

   }
   
   function seeDate() public view returns (uint){
       return now;
   }
   
   /***************** EVENTS ******************/
    /**
	 * @dev This event emits when new funds are distributed
	 * @param by the address of the sender who distributed funds
	 * @param fundsDistributed the amount of funds received for distribution
	 */
	event FundsDistributed(address indexed by, uint256 fundsDistributed);

	/**
	 * @dev This event emits when distributed funds are withdrawn by a token holder.
	 * @param by the address of the receiver of funds
	 * @param fundsWithdrawn the amount of funds that were withdrawn
	 */
	event FundsWithdrawn(address indexed by, uint256 fundsWithdrawn);
	
	event tokenTransfersAllowedEvent();
	
	/****************************************/
	
	/**
	 * @notice Withdraws available funds for user.
	 */
	function withdrawFunds() 
		external
		nonReentrant
	{
		uint256 withdrawableFunds = _prepareWithdraw();
		
		(bool success, ) = msg.sender.call{value: withdrawableFunds}("");
        require(success, "Transfer failed.");
	}

	
	fallback () external payable {
		if (msg.value > 0) {
			_distributeFunds(msg.value);
			emit FundsDistributed(msg.sender, msg.value);
		}
	}
	
	receive () external payable {
		if (msg.value > 0) {
			_distributeFunds(msg.value);
			emit FundsDistributed(msg.sender, msg.value);
		}
	}
	
	function distributeFunds() external payable returns(bool) {
	    require(msg.value > 0, 'No value in message');
	    _distributeFunds(msg.value);
		emit FundsDistributed(msg.sender, msg.value);
        return true;
	}
	
	
		/** 
	 * prev. distributeDividends
	 * @notice Distributes funds to token holders.
	 * @dev It reverts if the total supply of tokens is 0.
	 * It emits the `FundsDistributed` event if the amount of received ether is greater than 0.
	 * About undistributed funds:
	 *   In each distribution, there is a small amount of funds which does not get distributed,
	 *     which is `(msg.value * pointsMultiplier) % totalSupply()`.
	 *   With a well-chosen `pointsMultiplier`, the amount funds that are not getting distributed
	 *     in a distribution can be less than 1 (base unit).
	 *   We can actually keep track of the undistributed ether in a distribution
	 *     and try to distribute it in the next distribution ....... todo implement  
	 */
	function _distributeFunds(uint256 value) internal {
		require(totalSupply() > 0, "Token._distributeFunds: SUPPLY_IS_ZERO");

		if (value > 0) {
			pointsPerShare = pointsPerShare.add(
				value.mul(pointsMultiplier) / totalSupply()
			);
			emit FundsDistributed(msg.sender, value);
		}
	}

	/**
	 * prev. withdrawDividend
	 * @notice Prepares funds withdrawal
	 * @dev It emits a `FundsWithdrawn` event if the amount of withdrawn ether is greater than 0.
	 */
	function _prepareWithdraw() internal returns (uint256) {
		uint256 _withdrawableDividend = withdrawableFundsOf(msg.sender);
	
		withdrawnFunds[msg.sender] = withdrawnFunds[msg.sender].add(_withdrawableDividend);
		
		emit FundsWithdrawn(msg.sender, _withdrawableDividend);

		return _withdrawableDividend;
	}

	/** 
	 * prev. withdrawableDividendOf
	 * @notice View the amount of funds that an address can withdraw.
	 * @param _owner The address of a token holder.
	 * @return The amount funds that `_owner` can withdraw.
	 */
	function withdrawableFundsOf(address _owner) public view returns(uint256) {
		return accumulativeFundsOf(_owner).sub(withdrawnFunds[_owner]);
	}
	
	/**
	 * prev. withdrawnDividendOf
	 * @notice View the amount of funds that an address has withdrawn.
	 * @param _owner The address of a token holder.
	 * @return The amount of funds that `_owner` has withdrawn.
	 */
	function withdrawnFundsOf(address _owner) public view returns(uint256) {
		return withdrawnFunds[_owner];
	}

	/**
	 * prev. accumulativeDividendOf
	 * @notice View the amount of funds that an address has earned in total.
	 * @dev accumulativeFundsOf(_owner) = withdrawableFundsOf(_owner) + withdrawnFundsOf(_owner)
	 * = (pointsPerShare * balanceOf(_owner) + pointsCorrection[_owner]) / pointsMultiplier
	 * @param _owner The address of a token holder.
	 * @return The amount of funds that `_owner` has earned in total.
	 */
	function accumulativeFundsOf(address _owner) public view returns(uint256) {
		return pointsPerShare.mul(balanceOf(_owner)).toInt256Safe()
			.add(pointsCorrection[_owner]).toUint256Safe() / pointsMultiplier;
	}
	
	
	
	
    function validateTransfer(address _sender, address _to) private view {
        require(_to != address(0),'You cannot send to 0x address');
	       
        if (tokenTransfersAllowed) {
         return;
        }
        
        // Before the token sale has finished, only the Token Sale Contract and The Honest Tree Game contract can transfer
        // This allows the Contracts to move tokens while the sale is still ongoing.
        
        require(isTokenSaleContractOrGame(_sender),'Tokens transfer are not allowed yet');
        
    }
    
    function isTokenSaleContractOrGame(address _address) private view returns (bool) {
      return ((_address == tokenSaleContractAddress) || (_address == HonestTreeGameContractAddress) || (_address == PharaohGameContractAddress));
        
    }
    
    


	/**
	 * @dev Internal function that transfer tokens from one address to another.
	 * Update pointsCorrection to keep funds unchanged.
	 * @param from The address to transfer from.
	 * @param to The address to transfer to.
	 * @param value The amount to be transferred.
	 */
	function _transfer(address from, address to, uint256 value) internal override {
	    validateTransfer(from, to);
		super._transfer(from, to, value);

		int256 _magCorrection = pointsPerShare.mul(value).toInt256Safe();
		pointsCorrection[from] = pointsCorrection[from].add(_magCorrection);
		pointsCorrection[to] = pointsCorrection[to].sub(_magCorrection);
	}

	/**
	 * @dev Internal function that mints tokens to an account.
	 * Update pointsCorrection to keep funds unchanged.
	 * @param account The account that will receive the created tokens.
	 * @param value The amount that will be created.
	 */
	function _mint(address account, uint256 value) internal override {
		super._mint(account, value);

		pointsCorrection[account] = pointsCorrection[account]
			.sub( (pointsPerShare.mul(value)).toInt256Safe() );
	}
	
	/** 
	 * @dev Internal function that burns an amount of the token of a given account.
	 * Update pointsCorrection to keep funds unchanged.
	 * @param account The account whose tokens will be burnt.
	 * @param value The amount that will be burnt.
	 */
	function _burn(address account, uint256 value) internal override {
		super._burn(account, value);

		pointsCorrection[account] = pointsCorrection[account]
			.add( (pointsPerShare.mul(value)).toInt256Safe() );
	}
    

	
}