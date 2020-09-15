/**
 *Submitted for verification at Etherscan.io on 2020-05-28
*/

// File: contracts/TimeLockTokenEscrow.sol

pragma solidity ^0.6.6;

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
    bool private _notEntered;

    constructor () internal {
        // Storing an initial non-zero value makes deployment a bit more
        // expensive, but in exchange the refund on every call to nonReentrant
        // will be lower in amount. Since refunds are capped to a percetange of
        // the total transaction's gas, it is best to keep them low in cases
        // like this one, to increase the likelihood of the full refund coming
        // into effect.
        _notEntered = true;
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
        require(_notEntered, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _notEntered = false;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _notEntered = true;
    }
}

contract TimeLockTokenEscrow is ReentrancyGuard {

    event Lockup(
        uint256 indexed _depositId,
        address indexed _creator,
        address indexed _beneficiary,
        uint256 _amount,
        uint256 _lockedUntil
    );

    event Withdrawal(
        uint256 indexed _depositId,
        address indexed _beneficiary,
        address indexed _caller,
        uint256 _amount
    );

    struct TimeLock {
        address creator;
        uint256 amount;
        uint256 lockedUntil;
    }

    IERC20 public token;

    // Deposit ID -> beneficiary -> TimeLock data mappings
    mapping(uint256 => mapping(address => TimeLock)) public beneficiaryToTimeLock;

    // Reverse lookup for beneficiary to deposits
    mapping(address => uint256[]) beneficiaryToDepositIds;

    // An incrementing ID counter for each new deposit
    uint256 public depositIdPointer = 0;

    constructor(IERC20 _token) public {
        token = _token;
    }

    /**
     * @dev Locks the the given amount of tokens to the beneficiary for the given amount of time
     * @param _beneficiary address the beneficiary
     * @param _amount uint256 the amount to lockup
     * @param _lockedUntil uint256 the time when the timelock expires
    */
    function lock(address _beneficiary, uint256 _amount, uint256 _lockedUntil) external nonReentrant {
        require(_beneficiary != address(0), "You cannot lock up tokens for the zero address");
        require(_amount > 0, "Lock up amount of zero tokens is invalid");
        require(token.allowance(msg.sender, address(this)) >= _amount, "The contract does not have enough of an allowance to escrow");

        // generate next deposit ID to use for the address
        depositIdPointer = depositIdPointer + 1;

        // Add reverse mapping for query help
        beneficiaryToDepositIds[_beneficiary].push(depositIdPointer);

        beneficiaryToTimeLock[depositIdPointer][_beneficiary] = TimeLock({
            creator : msg.sender,
            amount : _amount,
            lockedUntil : _lockedUntil
            });

        emit Lockup(depositIdPointer, msg.sender, _beneficiary, _amount, _lockedUntil);

        bool transferSuccess = token.transferFrom(msg.sender, address(this), _amount);
        require(transferSuccess, "Failed to escrow tokens into the contract");
    }

    /**
     * @dev Withdraw the locked up amount for the given deposit and beneficiary
     * @param _depositId uint256 the deposit ID
     * @param _beneficiary address the beneficiary
     */
    function withdrawal(uint256 _depositId, address _beneficiary) external nonReentrant {
        TimeLock storage lockup = beneficiaryToTimeLock[_depositId][_beneficiary];
        require(lockup.amount > 0, "There are no tokens locked up for this address");
        require(now >= lockup.lockedUntil, "Tokens are still locked up");

        uint256 transferAmount = lockup.amount;
        lockup.amount = 0;

        emit Withdrawal(_depositId, _beneficiary, msg.sender, transferAmount);

        bool transferSuccess = token.transfer(_beneficiary, transferAmount);
        require(transferSuccess, "Failed to send tokens to the beneficiary");
    }

    /**
     * @dev Used to enumerate a beneficiaries deposits
     * @param _beneficiary address the beneficiary to find any deposit IDs for
     * @return depositIds uint256[] of deposit IDs for the given beneficiary
    */
    function getDepositIdsForBeneficiary(address _beneficiary) external view returns (uint256[] memory depositIds) {
        return beneficiaryToDepositIds[_beneficiary];
    }

    /**
     * @dev Used to get the time lock config for the deposit ID and beneficiary
     * @param _depositId uint256 the deposit to look up
     * @param _beneficiary address the beneficiary which matches the deposit ID
     * @return _creator address the creator of the time lock
     * @return _amount uint256 the amount of tokens locked
     * @return _lockedUntil uint256 for when the timelock expires
    */
    function getLockForDepositIdAndBeneficiary(uint256 _depositId, address _beneficiary)
    external view returns (address _creator, uint256 _amount, uint256 _lockedUntil) {
        TimeLock storage lockup = beneficiaryToTimeLock[_depositId][_beneficiary];
        return (
        lockup.creator,
        lockup.amount,
        lockup.lockedUntil
        );
    }

}