/**
 *Submitted for verification at Etherscan.io on 2020-07-23
*/

pragma solidity ^0.5.0;

// openzeppelin-solidity@2.3.0 from NPM

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

contract ValidatorManagerContract {
    using SafeMath for uint256;

    /// \frac{threshold_num}{threshold_denom} signatures are required for
    /// validator approval to be granted
    uint8 public threshold_num;
    uint8 public threshold_denom;

    /// The list of currently elected validators
    address[] public validators;

    /// The powers of the currently elected validators
    uint64[] public powers;

    /// The current sum of powers of currently elected validators
    uint256 public totalPower;

    /// Nonce tracking per to prevent replay attacks on signature
    /// submission during validator rotation
    uint256 public nonce;

    /// Address of the loom token
    address public loomAddress;

    /// @notice  Event to log the change of the validator set.
    /// @param  _validators The initial list of validators
    /// @param  _powers The initial list of powers of each validator
    event ValidatorSetChanged(address[] _validators, uint64[] _powers);

    /// @notice View function that returns the powers array.
    /// @dev    Solidity should have exposed a getter function since the variable is declared public.
    /// @return powers The powers of the currently elected validators
    function getPowers() public view returns(uint64[] memory) {
        return powers;
    }

    /// @notice View function that returns the validators array.
    /// @dev    Solidity should have exposed a getter function since the variable is declared public.
    /// @return validators The currently elected validators
    function getValidators() public view returns(address[] memory) {
        return validators;
    }

    /// @notice Initialization of the system
    /// @param  _validators The initial list of validators
    /// @param  _powers The initial list of powers of each validator
    /// @param  _threshold_num The numerator of the fraction of power that needs
    ///         to sign for a call to be approved by a validator
    /// @param  _threshold_denom The denominator of the fraction of power that needs
    ///         to sign for a call to be approved by a validator
    /// @param  _loomAddress The LOOM token address
    constructor (
        address[] memory _validators,
        uint64[] memory _powers,
        uint8 _threshold_num,
        uint8 _threshold_denom,
        address _loomAddress
    ) 
        public 
    {
        threshold_num = _threshold_num;
        threshold_denom = _threshold_denom;
        require(threshold_num <= threshold_denom && threshold_num > 0, "Invalid threshold fraction.");
        loomAddress = _loomAddress;
        _rotateValidators(_validators, _powers);
    }

    /// @notice Changes the loom token address. (requires signatures from at least `threshold_num/threshold_denom`
    ///         validators, otherwise reverts)
    /// @param  _loomAddress The new loom token address
    /// @param  _signersIndexes Array of indexes of the validator's signatures based on
    ///         the currently elected validators
    /// @param  _v Array of `v` values from the validator signatures
    /// @param  _r Array of `r` values from the validator signatures
    /// @param  _s Array of `s` values from the validator signatures
    function setLoom(
        address _loomAddress,
        uint256[] calldata _signersIndexes, // Based on: https://github.com/cosmos/peggy/blob/master/ethereum-contracts/contracts/Valset.sol#L75
        uint8[] calldata _v,
        bytes32[] calldata _r,
        bytes32[] calldata _s
    ) 
        external 
    {
        // Hash the address of the contract along with the nonce and the
        // updated loom token address.
        bytes32 message = createMessage(
            keccak256(abi.encodePacked(_loomAddress))
        );

        // Check if the signatures match the threshold set in the constructor
        checkThreshold(message, _signersIndexes, _v, _r, _s);

        // Update state
        loomAddress = _loomAddress;
        nonce++;
    }

    /// @notice Changes the threshold of signatures required to pass the
    ///         validator signature check (requires signatures from at least `threshold_num/threshold_denom`
    ///         validators, otherwise reverts)
    /// @param  _num The new numerator
    /// @param  _denom The new denominator
    /// @param  _signersIndexes Array of indexes of the validator's signatures based on
    ///         the currently elected validators
    /// @param  _v Array of `v` values from the validator signatures
    /// @param  _r Array of `r` values from the validator signatures
    /// @param  _s Array of `s` values from the validator signatures
    function setQuorum(
        uint8 _num,
        uint8 _denom,
        uint256[] calldata _signersIndexes, // Based on: https://github.com/cosmos/peggy/blob/master/ethereum-contracts/contracts/Valset.sol#L75
        uint8[] calldata _v,
        bytes32[] calldata _r,
        bytes32[] calldata _s
    ) 
        external 
    {
        require(_num <= _denom && _num > 0, "Invalid threshold fraction");

        // Hash the address of the contract along with the nonce and the
        // updated validator set.
        bytes32 message = createMessage(
            keccak256(abi.encodePacked(_num, _denom))
        );

        // Check if the signatures match the threshold set in the consutrctor
        checkThreshold(message, _signersIndexes, _v, _r, _s);

        threshold_num = _num;
        threshold_denom = _denom;
        nonce++;
    }

    /// @notice Updates the validator set with new validators and powers
    ///         (requires signatures from at least `threshold_num/threshold_denom`
    ///         validators, otherwise reverts)
    /// @param  _newValidators The new validator set
    /// @param  _newPowers The new list of powers corresponding to the validator set
    /// @param  _signersIndexes Array of indexes of the validator's signatures based on
    ///         the currently elected validators
    /// @param  _v Array of `v` values from the validator signatures
    /// @param  _r Array of `r` values from the validator signatures
    /// @param  _s Array of `s` values from the validator signatures
    function rotateValidators(
        address[] calldata _newValidators, 
        uint64[] calldata  _newPowers,
        uint256[] calldata _signersIndexes, // Based on: https://github.com/cosmos/peggy/blob/master/ethereum-contracts/contracts/Valset.sol#L75
        uint8[] calldata _v,
        bytes32[] calldata _r,
        bytes32[] calldata _s
    ) 
        external 
    {
        // Hash the address of the contract along with the nonce and the
        // updated validator set and powers.
        bytes32 message = createMessage(
            keccak256(abi.encodePacked(_newValidators,_newPowers))
        );

        // Check if the signatures match the threshold set in the consutrctor
        checkThreshold(message, _signersIndexes, _v, _r, _s);

        // update validator set
        _rotateValidators(_newValidators, _newPowers);
        nonce++;
    }


    /// @notice Checks if the provided signature is valid on message by the
    ///         validator corresponding to `signersIndex`. Reverts if check fails
    /// @param  _message The messsage hash that was signed
    /// @param  _signersIndex The validator's index in the `validators` array
    /// @param  _v The v value of the validator's signature
    /// @param  _r The r value of the validator's signature
    /// @param  _s The s value of the validator's signature
    function signedByValidator(
        bytes32 _message,
        uint256 _signersIndex,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) 
        public 
        view
    {
        // prevent replay attacks by adding the nonce in the sig
        // if a validator signs an invalid nonce,
        // it won't pass the signature verification
        // since the nonce in the hash is stored in the contract
        address signer = ecrecover(_message, _v, _r, _s);
        require(validators[_signersIndex] == signer, "Message not signed by a validator");
    }

    /// @notice Completes if the message being passed was signed by the required
    ///         threshold of validators, otherwise reverts
    /// @param  _signersIndexes Array of indexes of the validator's signatures based on
    ///         the currently elected validators
    /// @param  _v Array of `v` values from the validator signatures
    /// @param  _r Array of `r` values from the validator signatures
    /// @param  _s Array of `s` values from the validator signatures
    function checkThreshold(bytes32 _message, uint256[] memory _signersIndexes, uint8[] memory _v, bytes32[] memory _r, bytes32[] memory _s) public view {
        uint256 sig_length = _v.length;

        require(sig_length <= validators.length,
                "checkThreshold:: Cannot submit more signatures than existing validators"
        );

        require(sig_length > 0 && sig_length == _r.length && _r.length == _s.length && sig_length == _signersIndexes.length,
                "checkThreshold:: Incorrect number of params"
        );

        // Signed message prefix
        bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _message));

        // Get total voted power while making sure all signatures submitted
        // were by validators without duplication
        uint256 votedPower;
        for (uint256 i = 0; i < sig_length; i++) {
            if (i > 0) {
                require(_signersIndexes[i] > _signersIndexes[i-1]);
            }

            // Skip malleable signatures / maybe better to revert instead of skipping?
            if (uint256(_s[i]) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
                continue;
            }
            address signer = ecrecover(hash, _v[i], _r[i], _s[i]);
            require(signer == validators[_signersIndexes[i]], "checkThreshold:: Recovered address is not a validator");

            votedPower = votedPower.add(powers[_signersIndexes[i]]);
        }

        require(votedPower * threshold_denom >= totalPower *
                threshold_num, "checkThreshold:: Not enough power from validators");
    }



    /// @notice Internal method that updates the state with the new validator
    ///         set and powers, as well as the new total power
    /// @param  _validators The initial list of validators
    /// @param  _powers The initial list of powers of each validator
    function _rotateValidators(address[] memory _validators, uint64[] memory _powers) internal {
        uint256 val_length = _validators.length;

        require(val_length == _powers.length, "_rotateValidators: Array lengths do not match!");

        require(val_length > 0, "Must provide more than 0 validators");

        uint256 _totalPower = 0;
        for (uint256 i = 0; i < val_length; i++) {
            _totalPower = _totalPower.add(_powers[i]);
        }

        // Set total power
        totalPower = _totalPower;

        // Set validators and their powers
        validators = _validators;
        powers = _powers;

        emit ValidatorSetChanged(_validators, _powers);
    }

    /// @notice Creates the message hash that includes replay protection and
    ///         binds the hash to this contract only.
    /// @param  hash The hash of the message being signed
    /// @return A hash on the hash of the message
    function createMessage(bytes32 hash)
    private
    view returns (bytes32)
    {
        return keccak256(
            abi.encodePacked(
                address(this),
                nonce,
                hash
            )
        );
    }

}

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

/**
 * @dev Implementation of the `IERC20` interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using `_mint`.
 * For a generic mechanism see `ERC20Mintable`.
 *
 * *For a detailed writeup see our guide [How to implement supply
 * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See `IERC20.approve`.
 */
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See `IERC20.totalSupply`.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See `IERC20.balanceOf`.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See `IERC20.transfer`.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev See `IERC20.allowance`.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See `IERC20.approve`.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev See `IERC20.transferFrom`.
     *
     * Emits an `Approval` event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of `ERC20`;
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `value`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to `approve` that can be used as a mitigation for
     * problems described in `IERC20.approve`.
     *
     * Emits an `Approval` event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to `approve` that can be used as a mitigation for
     * problems described in `IERC20.approve`.
     *
     * Emits an `Approval` event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to `transfer`, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a `Transfer` event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a `Transfer` event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

     /**
     * @dev Destoys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a `Transfer` event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an `Approval` event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /**
     * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See `_burn` and `_approve`.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
    }
}

/**
 * @title ERC20 interface for token contracts deployed to mainnet that let Ethereum Gateway mint the token.
 */
contract IERC20GatewayMintable is ERC20 {
    // Called by the Ethereum Gateway contract to mint tokens.
    //
    // NOTE: the Ethereum gateway will call this method unconditionally.
    function mintTo(address _to, uint256 _amount) public;
}

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

contract ERC20Gateway {
    using SafeERC20 for IERC20;

  /// @notice Event to log the withdrawal of a token from the Gateway.
  /// @param  owner Address of the entity that made the withdrawal.
  /// @param  kind The type of token withdrawn (ERC20/ERC721/ETH).
  /// @param  contractAddress Address of token contract the token belong to.
  /// @param  value For ERC721 this is the uid of the token, for ETH/ERC20 this is the amount.
  event TokenWithdrawn(address indexed owner, TokenKind kind, address contractAddress, uint256 value);

  /// @notice Event to log the deposit of a LOOM to the Gateway.
  /// @param  from Address of the entity that made the withdrawal.
  /// @param  amount The LOOM token amount that was deposited
  /// @param  loomCoinAddress Address of the LOOM token
  event LoomCoinReceived(address indexed from, uint256 amount, address loomCoinAddress);

  /// @notice Event to log the deposit of a ERC20 to the Gateway.
  /// @param  from Address of the entity that made the withdrawal.
  /// @param  amount The ERC20 token amount that was deposited
  /// @param  contractAddress Address of the ERC20 token
  event ERC20Received(address from, uint256 amount, address contractAddress);

  /// The LOOM token address
  address public loomAddress;

  //  A boolean to enable and disable deposit and withdraw
  bool isGatewayEnabled;

  /// Booleans to permit depositing arbitrary tokens to the gateways
  bool allowAnyToken;
  mapping (address => bool) public allowedTokens;

  // Contract deployer is the owner of this contract
  address public owner;

  function getOwner() public view returns(address) {
    return owner;
  }

  function getAllowAnyToken() public view returns(bool) {
    return allowAnyToken;
  }

  /// The nonces per withdrawer to prevent replays
  mapping (address => uint256) public nonces;

  /// The Validator Manager Contract
  ValidatorManagerContract public vmc;

  /// Enum for the various types of each token to notify clients during
  /// deposits and withdrawals
  enum TokenKind {
    ETH,
    ERC20,
    ERC721,
    ERC721X,
    LoomCoin
  }

  /// @notice Initialize the contract with the VMC
  /// @param _vmc the validator manager contrct address
  constructor(ValidatorManagerContract _vmc) public {
    vmc = _vmc;
    loomAddress = vmc.loomAddress();
    owner = msg.sender;
    isGatewayEnabled = true; // enable gateway by default
    allowAnyToken = true; // enable depositing arbitrary tokens by default
  }

  /// @notice Function to withdraw ERC20 tokens from the Gateway. Emits a
  /// ERC20Withdrawn event, or a LoomCoinWithdrawn event if the coin is LOOM
  /// token, according to the ValidatorManagerContract. If withdrawal amount is more than current balance,
  /// it will try to mint the token to user.
  /// @param  amount The amount being withdrawn
  /// @param  contractAddress The address of the token being withdrawn
  /// @param  _signersIndexes Array of indexes of the validator's signatures based on
  ///         the currently elected validators
  /// @param  _v Array of `v` values from the validator signatures
  /// @param  _r Array of `r` values from the validator signatures
  /// @param  _s Array of `s` values from the validator signatures
  function withdrawERC20(
      uint256 amount,
      address contractAddress,
      uint256[] calldata _signersIndexes,
      uint8[] calldata _v,
      bytes32[] calldata _r,
      bytes32[] calldata _s
  )
    gatewayEnabled
    external
  {
    bytes32 message = createMessageWithdraw(
            "\x10Withdraw ERC20:\n",
            keccak256(abi.encodePacked(amount, contractAddress))
    );

    // Ensure enough power has signed the withdrawal
    vmc.checkThreshold(message, _signersIndexes, _v, _r, _s);

    // Replay protection
    nonces[msg.sender]++;

    uint256 bal = IERC20(contractAddress).balanceOf(address(this));
    if (bal < amount) {
      IERC20GatewayMintable(contractAddress).mintTo(address(this), amount - bal);
    }
    IERC20(contractAddress).safeTransfer(msg.sender, amount);
    
    emit TokenWithdrawn(msg.sender, contractAddress == loomAddress ? TokenKind.LoomCoin : TokenKind.ERC20, contractAddress, amount);
  }

  // Approve and Deposit function for 2-step deposits
  // Requires first to have called `approve` on the specified ERC20 contract
  function depositERC20(uint256 amount, address contractAddress) gatewayEnabled external {
    IERC20(contractAddress).safeTransferFrom(msg.sender, address(this), amount);

    emit ERC20Received(msg.sender, amount, contractAddress);
    if (contractAddress == loomAddress) {
        emit LoomCoinReceived(msg.sender, amount, contractAddress);
    }
  }

  function getERC20(address contractAddress) external view returns (uint256) {
      return IERC20(contractAddress).balanceOf(address(this));
  }

    /// @notice Creates the message hash that includes replay protection and
    ///         binds the hash to this contract only.
    /// @param  hash The hash of the message being signed
    /// @return A hash on the hash of the message
  function createMessageWithdraw(string memory prefix, bytes32 hash)
    internal
    view
    returns (bytes32)
  {
    return keccak256(
      abi.encodePacked(
        prefix,
        msg.sender,
        nonces[msg.sender],
        address(this),
        hash
      )
    );
  }

  modifier gatewayEnabled() {
    require(isGatewayEnabled, "Gateway is disabled.");
    _;
  }

  /// @notice The owner can toggle allowing any token to be deposited / withdrawn from or to gateway
  /// @param enable a boolean value to enable or disable gateway
  function enableGateway(bool enable) public {
    require(msg.sender == owner, "enableGateway: only owner can enable or disable gateway");
    isGatewayEnabled = enable;
  }

  /// @notice Checks if the gateway allows deposits & withdrawals.
  /// @return true if deposits and withdrawals are allowed, false otherwise.
  function getGatewayEnabled() public view returns(bool) {
    return isGatewayEnabled;
  }

  /// @notice Checks if a token at `tokenAddress` is allowed
  /// @param  tokenAddress The token's address
  /// @return True if `allowAnyToken` is set, or if the token has been allowed
  function isTokenAllowed(address tokenAddress) public view returns(bool) {
    return allowAnyToken || allowedTokens[tokenAddress];
  }

  /// @notice The owner can toggle allowing any token to be deposited on
  ///         the sidechain
  /// @param allow Boolean to allow or not the token
  function toggleAllowAnyToken(bool allow) public {
    require(msg.sender == owner, "toggleAllowAnyToken: only owner can toggle");
    allowAnyToken = allow;
  }

  /// @notice The owner can toggle allowing a token to be deposited on
  ///         the sidechain
  /// @param  tokenAddress The token address
  /// @param  allow Boolean to allow or not the token
  function toggleAllowToken(address tokenAddress, bool allow) public {
    require(msg.sender == owner, "toggleAllowToken: only owner can toggle");
    allowedTokens[tokenAddress] = allow;
  }

}