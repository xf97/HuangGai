/**
 *Submitted for verification at Etherscan.io on 2020-07-09
*/

pragma solidity ^0.5.0;


interface IRelayRecipient {
    /**
     * @dev Returns the address of the {IRelayHub} instance this recipient interacts with.
     */
    function getHubAddr() external view returns (address);

    /**
     * @dev Called by {IRelayHub} to validate if this recipient accepts being charged for a relayed call. Note that the
     * recipient will be charged regardless of the execution result of the relayed call (i.e. if it reverts or not).
     *
     * The relay request was originated by `from` and will be served by `relay`. `encodedFunction` is the relayed call
     * calldata, so its first four bytes are the function selector. The relayed call will be forwarded `gasLimit` gas,
     * and the transaction executed with a gas price of at least `gasPrice`. `relay`'s fee is `transactionFee`, and the
     * recipient will be charged at most `maxPossibleCharge` (in wei). `nonce` is the sender's (`from`) nonce for
     * replay attack protection in {IRelayHub}, and `approvalData` is a optional parameter that can be used to hold a signature
     * over all or some of the previous values.
     *
     * Returns a tuple, where the first value is used to indicate approval (0) or rejection (custom non-zero error code,
     * values 1 to 10 are reserved) and the second one is data to be passed to the other {IRelayRecipient} functions.
     *
     * {acceptRelayedCall} is called with 50k gas: if it runs out during execution, the request will be considered
     * rejected. A regular revert will also trigger a rejection.
     */
    function acceptRelayedCall(
        address relay,
        address from,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata approvalData,
        uint256 maxPossibleCharge
    )
        external
        view
        returns (uint256, bytes memory);

    /**
     * @dev Called by {IRelayHub} on approved relay call requests, before the relayed call is executed. This allows to e.g.
     * pre-charge the sender of the transaction.
     *
     * `context` is the second value returned in the tuple by {acceptRelayedCall}.
     *
     * Returns a value to be passed to {postRelayedCall}.
     *
     * {preRelayedCall} is called with 100k gas: if it runs out during exection or otherwise reverts, the relayed call
     * will not be executed, but the recipient will still be charged for the transaction's cost.
     */
    function preRelayedCall(bytes calldata context) external returns (bytes32);

    /**
     * @dev Called by {IRelayHub} on approved relay call requests, after the relayed call is executed. This allows to e.g.
     * charge the user for the relayed call costs, return any overcharges from {preRelayedCall}, or perform
     * contract-specific bookkeeping.
     *
     * `context` is the second value returned in the tuple by {acceptRelayedCall}. `success` is the execution status of
     * the relayed call. `actualCharge` is an estimate of how much the recipient will be charged for the transaction,
     * not including any gas used by {postRelayedCall} itself. `preRetVal` is {preRelayedCall}'s return value.
     *
     *
     * {postRelayedCall} is called with 100k gas: if it runs out during execution or otherwise reverts, the relayed call
     * and the call to {preRelayedCall} will be reverted retroactively, but the recipient will still be charged for the
     * transaction's cost.
     */
    function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
}

interface IRelayHub {
    // Relay management

    /**
     * @dev Adds stake to a relay and sets its `unstakeDelay`. If the relay does not exist, it is created, and the caller
     * of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
     * cannot be its own owner.
     *
     * All Ether in this function call will be added to the relay's stake.
     * Its unstake delay will be assigned to `unstakeDelay`, but the new value must be greater or equal to the current one.
     *
     * Emits a {Staked} event.
     */
    function stake(address relayaddr, uint256 unstakeDelay) external payable;

    /**
     * @dev Emitted when a relay's stake or unstakeDelay are increased
     */
    event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);

    /**
     * @dev Registers the caller as a relay.
     * The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
     *
     * This function can be called multiple times, emitting new {RelayAdded} events. Note that the received
     * `transactionFee` is not enforced by {relayCall}.
     *
     * Emits a {RelayAdded} event.
     */
    function registerRelay(uint256 transactionFee, string calldata url) external;

    /**
     * @dev Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out
     * {RelayRemoved} events) lets a client discover the list of available relays.
     */
    event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);

    /**
     * @dev Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed.
     *
     * Can only be called by the owner of the relay. After the relay's `unstakeDelay` has elapsed, {unstake} will be
     * callable.
     *
     * Emits a {RelayRemoved} event.
     */
    function removeRelayByOwner(address relay) external;

    /**
     * @dev Emitted when a relay is removed (deregistered). `unstakeTime` is the time when unstake will be callable.
     */
    event RelayRemoved(address indexed relay, uint256 unstakeTime);

    /** Deletes the relay from the system, and gives back its stake to the owner.
     *
     * Can only be called by the relay owner, after `unstakeDelay` has elapsed since {removeRelayByOwner} was called.
     *
     * Emits an {Unstaked} event.
     */
    function unstake(address relay) external;

    /**
     * @dev Emitted when a relay is unstaked for, including the returned stake.
     */
    event Unstaked(address indexed relay, uint256 stake);

    // States a relay can be in
    enum RelayState {
        Unknown, // The relay is unknown to the system: it has never been staked for
        Staked, // The relay has been staked for, but it is not yet active
        Registered, // The relay has registered itself, and is active (can relay calls)
        Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
    }

    /**
     * @dev Returns a relay's status. Note that relays can be deleted when unstaked or penalized, causing this function
     * to return an empty entry.
     */
    function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);

    // Balance management

    /**
     * @dev Deposits Ether for a contract, so that it can receive (and pay for) relayed transactions.
     *
     * Unused balance can only be withdrawn by the contract itself, by calling {withdraw}.
     *
     * Emits a {Deposited} event.
     */
    function depositFor(address target) external payable;

    /**
     * @dev Emitted when {depositFor} is called, including the amount and account that was funded.
     */
    event Deposited(address indexed recipient, address indexed from, uint256 amount);

    /**
     * @dev Returns an account's deposits. These can be either a contracts's funds, or a relay owner's revenue.
     */
    function balanceOf(address target) external view returns (uint256);

    /**
     * Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
     * contracts can use it to reduce their funding.
     *
     * Emits a {Withdrawn} event.
     */
    function withdraw(uint256 amount, address payable dest) external;

    /**
     * @dev Emitted when an account withdraws funds from `RelayHub`.
     */
    event Withdrawn(address indexed account, address indexed dest, uint256 amount);

    // Relaying

    /**
     * @dev Checks if the `RelayHub` will accept a relayed operation.
     * Multiple things must be true for this to happen:
     *  - all arguments must be signed for by the sender (`from`)
     *  - the sender's nonce must be the current one
     *  - the recipient must accept this transaction (via {acceptRelayedCall})
     *
     * Returns a `PreconditionCheck` value (`OK` when the transaction can be relayed), or a recipient-specific error
     * code if it returns one in {acceptRelayedCall}.
     */
    function canRelay(
        address relay,
        address from,
        address to,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata signature,
        bytes calldata approvalData
    ) external view returns (uint256 status, bytes memory recipientContext);

    // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
    enum PreconditionCheck {
        OK,                         // All checks passed, the call can be relayed
        WrongSignature,             // The transaction to relay is not signed by requested sender
        WrongNonce,                 // The provided nonce has already been used by the sender
        AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
        InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
    }

    /**
     * @dev Relays a transaction.
     *
     * For this to succeed, multiple conditions must be met:
     *  - {canRelay} must `return PreconditionCheck.OK`
     *  - the sender must be a registered relay
     *  - the transaction's gas price must be larger or equal to the one that was requested by the sender
     *  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
     * recipient) use all gas available to them
     *  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
     * spent)
     *
     * If all conditions are met, the call will be relayed and the recipient charged. {preRelayedCall}, the encoded
     * function and {postRelayedCall} will be called in that order.
     *
     * Parameters:
     *  - `from`: the client originating the request
     *  - `to`: the target {IRelayRecipient} contract
     *  - `encodedFunction`: the function call to relay, including data
     *  - `transactionFee`: fee (%) the relay takes over actual gas cost
     *  - `gasPrice`: gas price the client is willing to pay
     *  - `gasLimit`: gas to forward when calling the encoded function
     *  - `nonce`: client's nonce
     *  - `signature`: client's signature over all previous params, plus the relay and RelayHub addresses
     *  - `approvalData`: dapp-specific data forwared to {acceptRelayedCall}. This value is *not* verified by the
     * `RelayHub`, but it still can be used for e.g. a signature.
     *
     * Emits a {TransactionRelayed} event.
     */
    function relayCall(
        address from,
        address to,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata signature,
        bytes calldata approvalData
    ) external;

    /**
     * @dev Emitted when an attempt to relay a call failed.
     *
     * This can happen due to incorrect {relayCall} arguments, or the recipient not accepting the relayed call. The
     * actual relayed call was not executed, and the recipient not charged.
     *
     * The `reason` parameter contains an error code: values 1-10 correspond to `PreconditionCheck` entries, and values
     * over 10 are custom recipient error codes returned from {acceptRelayedCall}.
     */
    event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);

    /**
     * @dev Emitted when a transaction is relayed. 
     * Useful when monitoring a relay's operation and relayed calls to a contract
     *
     * Note that the actual encoded function might be reverted: this is indicated in the `status` parameter.
     *
     * `charge` is the Ether value deducted from the recipient's balance, paid to the relay's owner.
     */
    event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);

    // Reason error codes for the TransactionRelayed event
    enum RelayCallStatus {
        OK,                      // The transaction was successfully relayed and execution successful - never included in the event
        RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
        PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
        PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
        RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
    }

    /**
     * @dev Returns how much gas should be forwarded to a call to {relayCall}, in order to relay a transaction that will
     * spend up to `relayedCallStipend` gas.
     */
    function requiredGas(uint256 relayedCallStipend) external view returns (uint256);

    /**
     * @dev Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
     */
    function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) external view returns (uint256);

     // Relay penalization. 
     // Any account can penalize relays, removing them from the system immediately, and rewarding the
    // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
    // still loses half of its stake.

    /**
     * @dev Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
     * different data (gas price, gas limit, etc. may be different).
     *
     * The (unsigned) transaction data and signature for both transactions must be provided.
     */
    function penalizeRepeatedNonce(bytes calldata unsignedTx1, bytes calldata signature1, bytes calldata unsignedTx2, bytes calldata signature2) external;

    /**
     * @dev Penalize a relay that sent a transaction that didn't target `RelayHub`'s {registerRelay} or {relayCall}.
     */
    function penalizeIllegalTransaction(bytes calldata unsignedTx, bytes calldata signature) external;

    /**
     * @dev Emitted when a relay is penalized.
     */
    event Penalized(address indexed relay, address sender, uint256 amount);

    /**
     * @dev Returns an account's nonce in `RelayHub`.
     */
    function getNonce(address from) external view returns (uint256);
}

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

contract GSNRecipient is IRelayRecipient, Context {
    // Default RelayHub address, deployed on mainnet and all testnets at the same address
    address private _relayHub = 0xD216153c06E857cD7f72665E0aF1d7D82172F494;

    uint256 constant private RELAYED_CALL_ACCEPTED = 0;
    uint256 constant private RELAYED_CALL_REJECTED = 11;

    // How much gas is forwarded to postRelayedCall
    uint256 constant internal POST_RELAYED_CALL_MAX_GAS = 100000;

    /**
     * @dev Emitted when a contract changes its {IRelayHub} contract to a new one.
     */
    event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);

    /**
     * @dev Returns the address of the {IRelayHub} contract for this recipient.
     */
    function getHubAddr() public view returns (address) {
        return _relayHub;
    }

    /**
     * @dev Switches to a new {IRelayHub} instance. This method is added for future-proofing: there's no reason to not
     * use the default instance.
     *
     * IMPORTANT: After upgrading, the {GSNRecipient} will no longer be able to receive relayed calls from the old
     * {IRelayHub} instance. Additionally, all funds should be previously withdrawn via {_withdrawDeposits}.
     */
    function _upgradeRelayHub(address newRelayHub) internal {
        address currentRelayHub = _relayHub;
        require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
        require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");

        emit RelayHubChanged(currentRelayHub, newRelayHub);

        _relayHub = newRelayHub;
    }

    /**
     * @dev Returns the version string of the {IRelayHub} for which this recipient implementation was built. If
     * {_upgradeRelayHub} is used, the new {IRelayHub} instance should be compatible with this version.
     */
    // This function is view for future-proofing, it may require reading from
    // storage in the future.
    function relayHubVersion() public view returns (string memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return "1.0.0";
    }

    /**
     * @dev Withdraws the recipient's deposits in `RelayHub`.
     *
     * Derived contracts should expose this in an external interface with proper access control.
     */
    function _withdrawDeposits(uint256 amount, address payable payee) internal {
        IRelayHub(_relayHub).withdraw(amount, payee);
    }

    // Overrides for Context's functions: when called from RelayHub, sender and
    // data require some pre-processing: the actual sender is stored at the end
    // of the call data, which in turns means it needs to be removed from it
    // when handling said data.

    /**
     * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
     * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).
     *
     * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.
     */
    function _msgSender() internal view returns (address payable) {
        if (msg.sender != _relayHub) {
            return msg.sender;
        } else {
            return _getRelayedCallSender();
        }
    }

    /**
     * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,
     * and a reduced version for GSN relayed calls (where msg.data contains additional information).
     *
     * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.
     */
    function _msgData() internal view returns (bytes memory) {
        if (msg.sender != _relayHub) {
            return msg.data;
        } else {
            return _getRelayedCallData();
        }
    }

    // Base implementations for pre and post relayedCall: only RelayHub can invoke them, and data is forwarded to the
    // internal hook.

    /**
     * @dev See `IRelayRecipient.preRelayedCall`.
     *
     * This function should not be overriden directly, use `_preRelayedCall` instead.
     *
     * * Requirements:
     *
     * - the caller must be the `RelayHub` contract.
     */
    function preRelayedCall(bytes calldata context) external returns (bytes32) {
        require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
        return _preRelayedCall(context);
    }

    /**
     * @dev See `IRelayRecipient.preRelayedCall`.
     *
     * Called by `GSNRecipient.preRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
     * must implement this function with any relayed-call preprocessing they may wish to do.
     *
     */
    function _preRelayedCall(bytes memory context) internal returns (bytes32);

    /**
     * @dev See `IRelayRecipient.postRelayedCall`.
     *
     * This function should not be overriden directly, use `_postRelayedCall` instead.
     *
     * * Requirements:
     *
     * - the caller must be the `RelayHub` contract.
     */
    function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external {
        require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
        _postRelayedCall(context, success, actualCharge, preRetVal);
    }

    /**
     * @dev See `IRelayRecipient.postRelayedCall`.
     *
     * Called by `GSNRecipient.postRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
     * must implement this function with any relayed-call postprocessing they may wish to do.
     *
     */
    function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal;

    /**
     * @dev Return this in acceptRelayedCall to proceed with the execution of a relayed call. Note that this contract
     * will be charged a fee by RelayHub
     */
    function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
        return _approveRelayedCall("");
    }

    /**
     * @dev See `GSNRecipient._approveRelayedCall`.
     *
     * This overload forwards `context` to _preRelayedCall and _postRelayedCall.
     */
    function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
        return (RELAYED_CALL_ACCEPTED, context);
    }

    /**
     * @dev Return this in acceptRelayedCall to impede execution of a relayed call. No fees will be charged.
     */
    function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
        return (RELAYED_CALL_REJECTED + errorCode, "");
    }

    /*
     * @dev Calculates how much RelayHub will charge a recipient for using `gas` at a `gasPrice`, given a relayer's
     * `serviceFee`.
     */
    function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
        // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be
        // charged for 1.4 times the spent amount.
        return (gas * gasPrice * (100 + serviceFee)) / 100;
    }

    function _getRelayedCallSender() private pure returns (address payable result) {
        // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
        // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
        // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
        // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
        // bytes. This can always be done due to the 32-byte prefix.

        // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
        // easiest/most-efficient way to perform this operation.

        // These fields are not accessible from assembly
        bytes memory array = msg.data;
        uint256 index = msg.data.length;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
            result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
        }
        return result;
    }

    function _getRelayedCallData() private pure returns (bytes memory) {
        // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,
        // we must strip the last 20 bytes (length of an address type) from it.

        uint256 actualDataLength = msg.data.length - 20;
        bytes memory actualData = new bytes(actualDataLength);

        for (uint256 i = 0; i < actualDataLength; ++i) {
            actualData[i] = msg.data[i];
        }

        return actualData;
    }
}

interface IERC777 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the smallest part of the token that is not divisible. This
     * means all token operations (creation, movement and destruction) must have
     * amounts that are a multiple of this number.
     *
     * For most token contracts, this value will equal 1.
     */
    function granularity() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by an account (`owner`).
     */
    function balanceOf(address owner) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * If send or receive hooks are registered for the caller and `recipient`,
     * the corresponding functions will be called with `data` and empty
     * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
     *
     * Emits a {Sent} event.
     *
     * Requirements
     *
     * - the caller must have at least `amount` tokens.
     * - `recipient` cannot be the zero address.
     * - if `recipient` is a contract, it must implement the {IERC777Recipient}
     * interface.
     */
    function send(address recipient, uint256 amount, bytes calldata data) external;

    /**
     * @dev Destroys `amount` tokens from the caller's account, reducing the
     * total supply.
     *
     * If a send hook is registered for the caller, the corresponding function
     * will be called with `data` and empty `operatorData`. See {IERC777Sender}.
     *
     * Emits a {Burned} event.
     *
     * Requirements
     *
     * - the caller must have at least `amount` tokens.
     */
    function burn(uint256 amount, bytes calldata data) external;

    /**
     * @dev Returns true if an account is an operator of `tokenHolder`.
     * Operators can send and burn tokens on behalf of their owners. All
     * accounts are their own operator.
     *
     * See {operatorSend} and {operatorBurn}.
     */
    function isOperatorFor(address operator, address tokenHolder) external view returns (bool);

    /**
     * @dev Make an account an operator of the caller.
     *
     * See {isOperatorFor}.
     *
     * Emits an {AuthorizedOperator} event.
     *
     * Requirements
     *
     * - `operator` cannot be calling address.
     */
    function authorizeOperator(address operator) external;

    /**
     * @dev Make an account an operator of the caller.
     *
     * See {isOperatorFor} and {defaultOperators}.
     *
     * Emits a {RevokedOperator} event.
     *
     * Requirements
     *
     * - `operator` cannot be calling address.
     */
    function revokeOperator(address operator) external;

    /**
     * @dev Returns the list of default operators. These accounts are operators
     * for all token holders, even if {authorizeOperator} was never called on
     * them.
     *
     * This list is immutable, but individual holders may revoke these via
     * {revokeOperator}, in which case {isOperatorFor} will return false.
     */
    function defaultOperators() external view returns (address[] memory);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
     * be an operator of `sender`.
     *
     * If send or receive hooks are registered for `sender` and `recipient`,
     * the corresponding functions will be called with `data` and
     * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
     *
     * Emits a {Sent} event.
     *
     * Requirements
     *
     * - `sender` cannot be the zero address.
     * - `sender` must have at least `amount` tokens.
     * - the caller must be an operator for `sender`.
     * - `recipient` cannot be the zero address.
     * - if `recipient` is a contract, it must implement the {IERC777Recipient}
     * interface.
     */
    function operatorSend(
        address sender,
        address recipient,
        uint256 amount,
        bytes calldata data,
        bytes calldata operatorData
    ) external;

    /**
     * @dev Destoys `amount` tokens from `account`, reducing the total supply.
     * The caller must be an operator of `account`.
     *
     * If a send hook is registered for `account`, the corresponding function
     * will be called with `data` and `operatorData`. See {IERC777Sender}.
     *
     * Emits a {Burned} event.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     * - the caller must be an operator for `account`.
     */
    function operatorBurn(
        address account,
        uint256 amount,
        bytes calldata data,
        bytes calldata operatorData
    ) external;

    event Sent(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 amount,
        bytes data,
        bytes operatorData
    );

    event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);

    event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);

    event AuthorizedOperator(address indexed operator, address indexed tokenHolder);

    event RevokedOperator(address indexed operator, address indexed tokenHolder);
}

interface IERC777Sender {
    /**
     * @dev Called by an {IERC777} token contract whenever a registered holder's
     * (`from`) tokens are about to be moved or destroyed. The type of operation
     * is conveyed by `to` being the zero address or not.
     *
     * This call occurs _before_ the token contract's state is updated, so
     * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
     *
     * This function may revert to prevent the operation from being executed.
     */
    function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external;
}

interface IERC777Recipient {
    /**
     * @dev Called by an {IERC777} token contract whenever tokens are being
     * moved or created into a registered account (`to`). The type of operation
     * is conveyed by `from` being the zero address or not.
     *
     * This call occurs _after_ the token contract's state is updated, so
     * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
     *
     * This function may revert to prevent the operation from being executed.
     */
    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external;
}

interface IERC1820Registry {
    /**
     * @dev Sets `newManager` as the manager for `account`. A manager of an
     * account is able to set interface implementers for it.
     *
     * By default, each account is its own manager. Passing a value of `0x0` in
     * `newManager` will reset the manager to this initial state.
     *
     * Emits a {ManagerChanged} event.
     *
     * Requirements:
     *
     * - the caller must be the current manager for `account`.
     */
    function setManager(address account, address newManager) external;

    /**
     * @dev Returns the manager for `account`.
     *
     * See {setManager}.
     */
    function getManager(address account) external view returns (address);

    /**
     * @dev Sets the `implementer` contract as `account`'s implementer for
     * `interfaceHash`.
     *
     * `account` being the zero address is an alias for the caller's address.
     * The zero address can also be used in `implementer` to remove an old one.
     *
     * See {interfaceHash} to learn how these are created.
     *
     * Emits an {InterfaceImplementerSet} event.
     *
     * Requirements:
     *
     * - the caller must be the current manager for `account`.
     * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
     * end in 28 zeroes).
     * - `implementer` must implement {IERC1820Implementer} and return true when
     * queried for support, unless `implementer` is the caller. See
     * {IERC1820Implementer-canImplementInterfaceForAddress}.
     */
    function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;

    /**
     * @dev Returns the implementer of `interfaceHash` for `account`. If no such
     * implementer is registered, returns the zero address.
     *
     * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
     * zeroes), `account` will be queried for support of it.
     *
     * `account` being the zero address is an alias for the caller's address.
     */
    function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);

    /**
     * @dev Returns the interface hash for an `interfaceName`, as defined in the
     * corresponding
     * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
     */
    function interfaceHash(string calldata interfaceName) external pure returns (bytes32);

    /**
     *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
     *  @param account Address of the contract for which to update the cache.
     *  @param interfaceId ERC165 interface for which to update the cache.
     */
    function updateERC165Cache(address account, bytes4 interfaceId) external;

    /**
     *  @notice Checks whether a contract implements an ERC165 interface or not.
     *  If the result is not cached a direct lookup on the contract address is performed.
     *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
     *  {updateERC165Cache} with the contract address.
     *  @param account Address of the contract to check.
     *  @param interfaceId ERC165 interface to check.
     *  @return True if `account` implements `interfaceId`, false otherwise.
     */
    function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);

    /**
     *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
     *  @param account Address of the contract to check.
     *  @param interfaceId ERC165 interface to check.
     *  @return True if `account` implements `interfaceId`, false otherwise.
     */
    function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);

    event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);

    event ManagerChanged(address indexed account, address indexed newManager);
}

contract BatchTransfer is GSNRecipient, IERC777Sender, IERC777Recipient {
    
    IERC1820Registry private _erc1820 = // See EIP1820
        IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
    bytes32 constant private TOKENS_SENDER_INTERFACE_HASH = // See EIP777
        keccak256("ERC777TokensSender");
    bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH = // See EIP777
        keccak256("ERC777TokensRecipient");

    mapping(address => uint) public balances;
    IERC777 public token;

    constructor(address _token) public {
        token = IERC777(_token);
        // Register as a token receiver
        _erc1820.setInterfaceImplementer(
            address(this), 
            TOKENS_RECIPIENT_INTERFACE_HASH, 
            address(this)
        );
        // Register as a token sender
        _erc1820.setInterfaceImplementer(
            address(this), 
            TOKENS_SENDER_INTERFACE_HASH, 
            address(this)
        );
    }

    function tokensToSend(
        address /*operator*/,
        address /*from*/,
        address /*to*/,
        uint256 /*amount*/,
        bytes calldata /*userData*/,
        bytes calldata /*operatorData*/
    ) external {
        require(
            _msgSender() == address(token), 
            "Can only be called by the GeoDB GeoTokens contract"
        );
    }

    function tokensReceived(
        address /*operator*/,
        address from,
        address /*to*/,
        uint256 amount,
        bytes calldata /*userData*/,
        bytes calldata /*operatorData*/
    ) external {
        require(
            _msgSender() == address(token), 
            "Can only receive GeoDB GeoTokens"
        );
        balances[from] += amount;
    }

    function send(address[] calldata to, uint[] calldata amount) external {
        require(to.length == amount.length, "Recipients and amounts mismatch");
        uint balance = balances[_msgSender()];

        for(uint i = 0; i < to.length; i += 1) {
            if(balance >= amount[i]) {
                balance -= amount[i];
                token.send(to[i], amount[i], "");
            } else {
                token.operatorSend(_msgSender(), to[i], amount[i], "", "");
            }
        }
        balances[_msgSender()] = balance;
    }

    function uniSend(address[] calldata to, uint amount) external {
        uint balance = balances[_msgSender()];

        for(uint i = 0; i < to.length; i += 1) {
            if(balance >= amount) {
                balance -= amount;
                token.send(to[i], amount, "");
            } else {
                token.operatorSend(_msgSender(), to[i], amount, "", "");
            }
        }
        balances[_msgSender()] = balance;
    }

    function acceptRelayedCall(
        address /*relay*/,
        address from,
        bytes calldata /*encodedFunction*/,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 /*gasLimit*/,
        uint256 /*nonce*/,
        bytes calldata /*approvalData*/,
        uint256 maxPossibleCharge
    ) external view returns (uint256, bytes memory) {
        return _approveRelayedCall(abi.encode(from, maxPossibleCharge, transactionFee, gasPrice));
    }

    function _preRelayedCall(bytes memory context) internal returns (bytes32){}

    function _postRelayedCall(
        bytes memory /*context*/, 
        bool, 
        uint256 /*actualCharge*/, 
        bytes32
    ) internal {}
}