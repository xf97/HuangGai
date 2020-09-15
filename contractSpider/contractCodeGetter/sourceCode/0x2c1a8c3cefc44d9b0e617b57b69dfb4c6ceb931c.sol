/**
 *Submitted for verification at Etherscan.io on 2020-06-10
*/

pragma solidity 0.6.8; // optimization runs: 200, evm version: istanbul
pragma experimental ABIEncoderV2;


interface BotCommanderV1Interface {
  event DaiToEthLimitOrderProcessed(
    address indexed smartWallet, uint256 daiGiven, uint256 etherReceived
  );
  event EthToDaiLimitOrderProcessed(
    address indexed smartWallet, uint256 etherGiven, uint256 daiReceived
  );
  event RoleModified(Role indexed role, address account);
  event RolePaused(Role indexed role);
  event RoleUnpaused(Role indexed role);

  enum Role {
    BOT_COMMANDER,
    PAUSER
  }

  struct RoleStatus {
    address account;
    bool paused;
  }

  struct DaiToEthArguments {
    address payable smartWallet;
    uint256 dDaiAmountToApprove;
    uint256 daiUnderlyingAmountToGive; // lower than maximum for partial fills
    uint256 maximumDaiUnderlyingAmountToGive;
    uint256 maximumEthPriceToAccept; // represented as a mantissa (n * 10^18)
    uint256 expiration;
    bytes32 salt;
    bytes approvalSignatures;
    bytes executionSignatures;
    address tradeTarget;
    bytes tradeData;
  }

  function redeemDDaiAndProcessDaiToEthLimitOrder(
    DaiToEthArguments calldata args
  ) external returns (uint256 etherReceived);

  struct EthToDaiArguments {
    address smartWallet;
    uint256 etherAmountToGive; // will be lower than maximum for partial fills
    uint256 maximumEtherAmountToGive;
    uint256 minimumEtherPriceToAccept; // represented as a mantissa (n * 10^18)
    uint256 expiration;
    bytes32 salt;
    bytes approvalSignatures;
    bytes executionSignatures;
    address tradeTarget;
    bytes tradeData;
  }

  function processEthToDaiLimitOrderAndMintDDai(
    EthToDaiArguments calldata args
  ) external returns (uint256 tokensReceived);

  function cancelDaiToEthLimitOrder(
    address smartWallet,
    uint256 maximumDaiUnderlyingAmountToGive,
    uint256 maximumEthPriceToAccept, // represented as a mantissa (n * 10^18)
    uint256 expiration,
    bytes32 salt
  ) external returns (bool success);

  function cancelEthToDaiLimitOrder(
    address smartWallet,
    uint256 maximumEtherAmountToGive,
    uint256 minimumEtherPriceToAccept, // represented as a mantissa (n * 10^18)
    uint256 expiration,
    bytes32 salt
  ) external returns (bool success);

  function setRole(Role role, address account) external;

  function removeRole(Role role) external;

  function pause(Role role) external;

  function unpause(Role role) external;

  function isPaused(Role role) external view returns (bool paused);

  function isRole(Role role) external view returns (bool hasRole);

  function getMetaTransactionMessageHash(
    bytes4 functionSelector,
    bytes calldata arguments,
    uint256 expiration,
    bytes32 salt
  ) external view returns (bytes32 messageHash, bool valid);

  function getBotCommander() external view returns (address botCommander);

  function getPauser() external view returns (address pauser);
}


interface ERC1271Interface {
  function isValidSignature(
    bytes calldata data, bytes calldata signatures
  ) external view returns (bytes4 magicValue);
}


interface ERC20Interface {
  function transfer(address, uint256) external returns (bool);
  function approve(address, uint256) external returns (bool);
  function balanceOf(address) external view returns (uint256);
  function allowance(address, address) external view returns (uint256);
}


interface DTokenInterface {
  function mint(
    uint256 underlyingToSupply
  ) external returns (uint256 dTokensMinted);
  function redeemUnderlying(
    uint256 underlyingToReceive
  ) external returns (uint256 dTokensBurned);
  function transfer(address, uint256) external returns (bool);
  function transferUnderlyingFrom(
    address sender, address recipient, uint256 underlyingEquivalentAmount
  ) external returns (bool success);
  function modifyAllowanceViaMetaTransaction(
    address owner,
    address spender,
    uint256 value,
    bool increase,
    uint256 expiration,
    bytes32 salt,
    bytes calldata signatures
  ) external returns (bool success);

  function getMetaTransactionMessageHash(
    bytes4 functionSelector,
    bytes calldata arguments,
    uint256 expiration,
    bytes32 salt
  ) external view returns (bytes32 digest, bool valid);
  function allowance(address, address) external view returns (uint256);
}


interface EtherizerV2Interface {
  function transferFrom(
    address from, address to, uint256 value
  ) external returns (bool);
  function modifyAllowanceViaMetaTransaction(
    address owner,
    address spender,
    uint256 value,
    bool increase,
    uint256 expiration,
    bytes32 salt,
    bytes calldata signatures
  ) external returns (bool success);

  function getMetaTransactionMessageHash(
    bytes4 functionSelector,
    bytes calldata arguments,
    uint256 expiration,
    bytes32 salt
  ) external view returns (bytes32 digest, bool valid);
  function allowance(
    address owner, address spender
  ) external view returns (uint256 amount);
}


library SafeMath {
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a, "SafeMath: subtraction overflow");

    return a - b;
  }

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0, "SafeMath: division by zero");
    return a / b;
  }
}


/**
 * @notice Contract module which provides a basic access control mechanism,
 * where there is an account (an owner) that can be granted exclusive access
 * to specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 *
 * In order to transfer ownership, a recipient must be specified, at which point
 * the specified recipient can call `acceptOwnership` and take ownership.
 */
contract TwoStepOwnable {
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  address private _owner;

  address private _newPotentialOwner;

  /**
   * @notice Initialize contract with transaction submitter as initial owner.
   */
  constructor() internal {
    _owner = tx.origin;
    emit OwnershipTransferred(address(0), _owner);
  }

  /**
   * @notice Allows a new account (`newOwner`) to accept ownership.
   * Can only be called by the current owner.
   */
  function transferOwnership(address newOwner) external onlyOwner {
    require(
      newOwner != address(0),
      "TwoStepOwnable: new potential owner is the zero address."
    );

    _newPotentialOwner = newOwner;
  }

  /**
   * @notice Cancel a transfer of ownership to a new account.
   * Can only be called by the current owner.
   */
  function cancelOwnershipTransfer() external onlyOwner {
    delete _newPotentialOwner;
  }

  /**
   * @notice Transfers ownership of the contract to the caller.
   * Can only be called by a new potential owner set by the current owner.
   */
  function acceptOwnership() external {
    require(
      msg.sender == _newPotentialOwner,
      "TwoStepOwnable: current owner must set caller as new potential owner."
    );

    delete _newPotentialOwner;

    emit OwnershipTransferred(_owner, msg.sender);

    _owner = msg.sender;
  }

  /**
   * @notice Returns the address of the current owner.
   */
  function owner() external view returns (address) {
    return _owner;
  }

  /**
   * @notice Returns true if the caller is the current owner.
   */
  function isOwner() public view returns (bool) {
    return msg.sender == _owner;
  }

  /**
   * @notice Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(isOwner(), "TwoStepOwnable: caller is not the owner.");
    _;
  }
}


/**
 * @title BotCommanderV1
 * @author 0age
 * @notice BotCommander is a contract for performing meta-transaction-enabled
 * limit orders against external automated money markets or other sources of
 * on-chain liquidity. V1 only supports trades between Dharma Dai and Ether —
 * Eth-to-dDai trades require that `triggerEtherTransfer` is implemented on
 * the account making the trade, and all trades require that they implement
 * the `isValidSignature` function specified by ERC-1271 for enabling
 * meta-transaction functionality.
 */
contract BotCommanderV1 is BotCommanderV1Interface, TwoStepOwnable {
  using SafeMath for uint256;

  // Maintain a role status mapping with assigned accounts and paused states.
  mapping(uint256 => RoleStatus) private _roles;

  // Maintain a mapping of invalid meta-transaction message hashes.
  mapping (bytes32 => bool) private _invalidMetaTxHashes;

  ERC20Interface internal constant _DAI = ERC20Interface(
    0x6B175474E89094C44Da98b954EedeAC495271d0F
  );

  DTokenInterface internal constant _DDAI = DTokenInterface(
    0x00000000001876eB1444c986fD502e618c587430
  );

  EtherizerV2Interface internal constant _ETH = EtherizerV2Interface(
    0x723B51b72Ae89A3d0c2a2760f0458307a1Baa191
  );

  constructor() public {
    // Approve dDai to transfer Dai on behalf of this contract in order to mint.
    _DAI.approve(address(_DDAI), type(uint256).max);
  }

  receive() external payable {}

  /**
   * @notice Only callable by the bot commander or the owner. Enforces the
   * expiration (or skips if it is set to zero), validates the execution
   * signatures using ERC-1271 against the smart wallet, initiates an
   * approval meta-transaction against Dharma Dai, pulls in the necessary
   * Dharma Dai, redeems it for Dai, sets an allowance for the provided
   * trade target, calls the trade target with the supplied trade data,
   * ensures that the call was successful, calculates the required Ether
   * that must be received back based on the specified Dai amount and price,
   * ensures that at least that amount was returned, sends it to the smart
   * wallet, and emits an event.
   * @return etherReceived The amount of Ether received from the trade.
   */
  function redeemDDaiAndProcessDaiToEthLimitOrder(
    DaiToEthArguments calldata args
  ) external override onlyOwnerOr(Role.BOT_COMMANDER) returns (
    uint256 etherReceived
  ) {
    _enforceExpiration(args.expiration);

    // Construct the meta-transaction's "context" information and validate it.
    bytes memory context = _constructContext(
      this.redeemDDaiAndProcessDaiToEthLimitOrder.selector,
      args.expiration,
      args.salt,
      abi.encode(
        args.smartWallet,
        args.maximumDaiUnderlyingAmountToGive,
        args.maximumEthPriceToAccept
      )
    );
    _validateMetaTransaction(
      args.smartWallet, context, args.executionSignatures
    );

    // try call to `modifyAllowanceViaMetaTransaction` on dDai
    _tryApprovalViaMetaTransaction(
      address(_DDAI),
      args.smartWallet,
      args.dDaiAmountToApprove,
      args.expiration,
      args.salt,
      args.approvalSignatures
    );

    // Make the transfer in.
    bool ok = _DDAI.transferUnderlyingFrom(
      args.smartWallet, address(this), args.daiUnderlyingAmountToGive
    );
    require(ok, "Dharma Dai transfer in failed.");

    // redeem dDai for Dai
    _DDAI.redeemUnderlying(args.daiUnderlyingAmountToGive);

    // Ensure that target has allowance to transfer tokens.
    if (_DAI.allowance(address(this), args.tradeTarget) != type(uint256).max) {
      _DAI.approve(args.tradeTarget, type(uint256).max);
    }

    // Call into the provided target, providing data.
    (ok,) = args.tradeTarget.call(args.tradeData);

    // Revert with reason if the call was not successful.
    _revertOnFailure(ok);

    // Determine the total Ether balance of this contract.
    etherReceived = address(this).balance;

    // Determine minumum ether required based on given Dai and price.
    uint256 etherExpected = (args.daiUnderlyingAmountToGive.mul(1e18)).div(
      args.maximumEthPriceToAccept
    );

    // Ensure that enough Ether was received.
    require(
      etherReceived >= etherExpected,
      "Trade did not result in the expected amount of Ether."
    );

    // Transfer the Ether to the smart wallet and revert on failure.
    (ok, ) = args.smartWallet.call{value: etherReceived}("");

     // Revert with reason if the call was not successful.
    _revertOnFailure(ok);

    emit DaiToEthLimitOrderProcessed(
      args.smartWallet, args.daiUnderlyingAmountToGive, etherReceived
    );
  }

  /**
   * @notice Only callable by the bot commander or the owner. Enforces the
   * expiration (or skips if it is set to zero), validates the execution
   * signatures using ERC-1271 against the smart wallet, initiates an
   * approval meta-transaction against EtherizerV2, pulls in the necessary
   * Ether, calls the trade target with available ether and the supplied data,
   * ensures that the call was successful, calculates the required Dai
   * that must be received back based on the specified Ether amount and price,
   * ensures that at least that amount was returned, mints Dharma Dai, sends it
   * to the smart wallet, and emits an event.
   * @return daiReceived The amount of Dai received from the trade.
   */
  function processEthToDaiLimitOrderAndMintDDai(
    EthToDaiArguments calldata args
  ) external override onlyOwnerOr(Role.BOT_COMMANDER) returns (
    uint256 daiReceived
  ) {
    _enforceExpiration(args.expiration);

    // Construct the meta-transaction's "context" information and validate it.
    bytes memory context = _constructContext(
      this.redeemDDaiAndProcessDaiToEthLimitOrder.selector,
      args.expiration,
      args.salt,
      abi.encode(
        args.smartWallet,
        args.maximumEtherAmountToGive,
        args.minimumEtherPriceToAccept
      )
    );
    _validateMetaTransaction(
      args.smartWallet, context, args.executionSignatures
    );

    // try call to `modifyAllowanceViaMetaTransaction` on dDai
    _tryApprovalViaMetaTransaction(
      address(_ETH),
      args.smartWallet,
      args.maximumEtherAmountToGive,
      args.expiration,
      args.salt,
      args.approvalSignatures
    );

    // call `transferFrom` on Etherizer, moving funds in from smart wallet
    bool ok = _ETH.transferFrom(
        args.smartWallet, address(this), args.etherAmountToGive
    );
    require(ok, "Ether transfer in failed.");

    // Call into the provided target, supplying ETH and data.
    (ok,) = args.tradeTarget.call{value: address(this).balance}(args.tradeData);

    // Revert with reason if the call was not successful.
    _revertOnFailure(ok);

    // Determine the total Dai balance of this contract.
    daiReceived = _DAI.balanceOf(address(this));

    // Determine expected amount of Dai based on minimum ether price supplied.
    uint256 daiExpected = args.etherAmountToGive.mul(
      args.minimumEtherPriceToAccept
    ) / 1e18;

    // Ensure that enough Dai was received.
    require(
      daiReceived >= daiExpected,
      "Trade did not result in the expected amount of Dai."
    );

    uint256 dDaiReceived = _DDAI.mint(daiReceived);

    // Transfer the dDai to the caller and revert on failure.
    ok = (_DDAI.transfer(msg.sender, dDaiReceived));
    require(ok, "Dharma Dai transfer out failed.");

    emit EthToDaiLimitOrderProcessed(
      args.smartWallet, args.etherAmountToGive, daiReceived
    );
  }

  /**
   * @notice Cancels a potential Dai-to-Eth limit order. Only the smart wallet
   * in question or the bot controller may call this.
   * @param expiration uint256 A timestamp indicating how long the modification
   * meta-transaction is valid for - a value of zero will signify no expiration.
   * @param salt bytes32 An arbitrary salt to be provided as an additional input
   * to the hash digest used to validate the signatures.
   * @return success A boolean indicating whether the cancellation was
   * successful.
   */
  function cancelDaiToEthLimitOrder(
    address smartWallet,
    uint256 maximumDaiUnderlyingAmountToGive,
    uint256 maximumEthPriceToAccept, // represented as a mantissa (n * 10^18)
    uint256 expiration,
    bytes32 salt
  ) external override returns (bool success) {
    _enforceExpiration(expiration);
    _enforceValidCanceller(smartWallet);

    // Construct the meta-transaction's "context" information.
    bytes memory context = _constructContext(
      this.redeemDDaiAndProcessDaiToEthLimitOrder.selector,
      expiration,
      salt,
      abi.encode(
        smartWallet, maximumDaiUnderlyingAmountToGive, maximumEthPriceToAccept
      )
    );

    // Construct the message hash using the provided context.
    bytes32 messageHash = keccak256(context);

    // Ensure message hash has not been used or cancelled and invalidate it.
    require(
      !_invalidMetaTxHashes[messageHash], "Meta-transaction already invalid."
    );
    _invalidMetaTxHashes[messageHash] = true;

    success = true;
  }

  /**
   * @notice Cancels a potential Dai-to-Eth limit order. Only the smart wallet
   * in question or the bot controller may call this.
   * @param expiration uint256 A timestamp indicating how long the modification
   * meta-transaction is valid for - a value of zero will signify no expiration.
   * @param salt bytes32 An arbitrary salt to be provided as an additional input
   * to the hash digest used to validate the signatures.
   * @return success A boolean indicating whether the cancellation was
   * successful.
   */
  function cancelEthToDaiLimitOrder(
    address smartWallet,
    uint256 maximumEtherAmountToGive,
    uint256 minimumEtherPriceToAccept, // represented as a mantissa (n * 10^18)
    uint256 expiration,
    bytes32 salt
  ) external override returns (bool success) {
    _enforceExpiration(expiration);

    _enforceValidCanceller(smartWallet);

    // Construct the meta-transaction's "context" information.
    bytes memory context = _constructContext(
      this.redeemDDaiAndProcessDaiToEthLimitOrder.selector,
      expiration,
      salt,
      abi.encode(
        smartWallet, maximumEtherAmountToGive, minimumEtherPriceToAccept
      )
    );

    // Construct the message hash using the provided context.
    bytes32 messageHash = keccak256(context);

    // Ensure message hash has not been used or cancelled and invalidate it.
    require(
      !_invalidMetaTxHashes[messageHash], "Meta-transaction already invalid."
    );
    _invalidMetaTxHashes[messageHash] = true;

    success = true;
  }

  /**
   * @notice Pause a currently unpaused role and emit a `RolePaused` event. Only
   * the owner or the designated pauser may call this function. Also, bear in
   * mind that only the owner may unpause a role once paused.
   * @param role The role to pause.
   */
  function pause(Role role) external override onlyOwnerOr(Role.PAUSER) {
    RoleStatus storage storedRoleStatus = _roles[uint256(role)];
    require(!storedRoleStatus.paused, "Role in question is already paused.");
    storedRoleStatus.paused = true;
    emit RolePaused(role);
  }

  /**
   * @notice Unpause a currently paused role and emit a `RoleUnpaused` event.
   * Only the owner may call this function.
   * @param role The role to pause.
   */
  function unpause(Role role) external override onlyOwner {
    RoleStatus storage storedRoleStatus = _roles[uint256(role)];
    require(storedRoleStatus.paused, "Role in question is already unpaused.");
    storedRoleStatus.paused = false;
    emit RoleUnpaused(role);
  }

  /**
   * @notice Set a new account on a given role and emit a `RoleModified` event
   * if the role holder has changed. Only the owner may call this function.
   * @param role The role that the account will be set for.
   * @param account The account to set as the designated role bearer.
   */
  function setRole(Role role, address account) external override onlyOwner {
    require(account != address(0), "Must supply an account.");
    _setRole(role, account);
  }

  /**
   * @notice Remove any current role bearer for a given role and emit a
   * `RoleModified` event if a role holder was previously set. Only the owner
   * may call this function.
   * @param role The role that the account will be removed from.
   */
  function removeRole(Role role) external override onlyOwner {
    _setRole(role, address(0));
  }

  /**
   * @notice View function to determine a meta-transaction message hash, and to
   * determine if it is still valid (i.e. it has not yet been used and is not
   * expired). The returned message hash will need to be prefixed using EIP-191
   * 0x45 and hashed again in order to generate a final digest for the required
   * signature - in other words, the same procedure utilized by `eth_Sign`.
   * @param functionSelector bytes4 The function selector for the given
   * meta-transaction. There are two function selectors available for V1:
   *  1. 0x03f9dae5: `redeemDDaiAndProcessDaiToEthLimitOrder`
   *  2. 0x088263dd: `processEthToDaiLimitOrderAndMintDDai`
   * @param arguments bytes The abi-encoded function arguments (aside from the
   * `expiration`, `salt`, and `signatures` arguments) that should be supplied
   * to the given function. There are three arguments for each function: the
   * smart wallet address, the maximum amount that the wallet is willing to
   * trade, and the limit price (denominated as the price in Dai for 1 Ether,
   * multiplied by 10^18).
   * @param expiration uint256 A timestamp indicating how long the given
   * meta-transaction is valid for - a value of zero will signify no expiration.
   * @param salt bytes32 An arbitrary salt to be provided as an additional input
   * to the hash digest used to validate the signatures.
   * @return messageHash The message hash corresponding to the meta-transaction.
   */
  function getMetaTransactionMessageHash(
    bytes4 functionSelector,
    bytes calldata arguments,
    uint256 expiration,
    bytes32 salt
  ) external view override returns (bytes32 messageHash, bool valid) {
    // Construct the meta-transaction's message hash based on relevant context.
    messageHash = keccak256(
      abi.encodePacked(
        address(this), functionSelector, expiration, salt, arguments
      )
    );

    // The meta-transaction is valid if it has not been used and is not expired.
    valid = (
      !_invalidMetaTxHashes[messageHash] && (
        expiration == 0 || now <= expiration
      )
    );
  }

  /**
   * @notice External view function to check whether or not the functionality
   * associated with a given role is currently paused or not. The owner or the
   * pauser may pause any given role (including the pauser itself), but only the
   * owner may unpause functionality. Additionally, the owner may call paused
   * functions directly.
   * @param role The role to check the pause status on.
   * @return paused A boolean to indicate if the functionality associated with
   * the role in question is currently paused.
   */
  function isPaused(Role role) external view override returns (bool paused) {
    paused = _isPaused(role);
  }

  /**
   * @notice External view function to check whether the caller is the current
   * role holder.
   * @param role The role to check for.
   * @return hasRole A boolean indicating if the caller has the specified role.
   */
  function isRole(Role role) external view override returns (bool hasRole) {
    hasRole = _isRole(role);
  }

  /**
   * @notice External view function to check the account currently holding the
   * bot commander role. The bot commander can execute and cancel limit orders.
   * @return botCommander The address of the current bot commander, or the null
   * address if none is set.
   */
  function getBotCommander() external view override returns (
    address botCommander
  ) {
    botCommander = _roles[uint256(Role.BOT_COMMANDER)].account;
  }

  /**
   * @notice External view function to check the account currently holding the
   * pauser role. The pauser can pause any role from taking its standard action,
   * though the owner will still be able to call the associated function in the
   * interim and is the only entity able to unpause the given role once paused.
   * @return pauser The address of the current pauser, or the null address if
   * none is set.
   */
  function getPauser() external view override returns (address pauser) {
    pauser = _roles[uint256(Role.PAUSER)].account;
  }

  /**
   * @notice Private function to enforce that a given Meta-transaction
   * has not been used before and that the signature is valid according
   * to the owner (using ERC-1271).
   * @param owner address The account originating the meta-transaction.
   * @param context bytes Information about the meta-transaction.
   * @param signatures bytes Signature or signatures used to validate
   * the meta-transaction.
   */
  function _validateMetaTransaction(
    address owner, bytes memory context, bytes memory signatures
  ) private {
    // Construct the message hash using the provided context.
    bytes32 messageHash = keccak256(context);

    // Ensure message hash has not been used or cancelled and invalidate it.
    require(
      !_invalidMetaTxHashes[messageHash], "Meta-transaction no longer valid."
    );
    _invalidMetaTxHashes[messageHash] = true;

    // Construct the digest to compare signatures against using EIP-191 0x45.
    bytes32 digest = keccak256(
      abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash)
    );

    // Validate via ERC-1271 against the owner account.
    bytes memory data = abi.encode(digest, context);
    bytes4 magic = ERC1271Interface(owner).isValidSignature(data, signatures);
    require(magic == bytes4(0x20c13b0b), "Invalid signatures.");
  }

  /**
   * @notice Private function to set an approval, or to continue if a given
   * meta-transaction has been used for an approval before but allowance is still
   * set (for instance, by a griefer that has lifted it from calldata while the
   * transaction is still in the mempool and used it to frontrun the call). If
   * one of these steps fails, revert.
   * @param ownerSmartWallet address The wallet of the owner.
   * @param value uint256 The amount of dDai to approve.
   * @param expiration uint256 The timestamp where the meta-transaction expires.
   * @param salt bytes32 The salt associated with the meta-transaction.
   * @param signatures bytes The signature or signatures associated with the
   * meta-transaction.
   */
  function _tryApprovalViaMetaTransaction(
    address approver,
    address ownerSmartWallet,
    uint256 value,
    uint256 expiration,
    bytes32 salt,
    bytes memory signatures
  ) private {
    // Attempt to modify the allowance.
    (bool ok, bytes memory returnData) = approver.call(
      abi.encodeWithSelector(
        _DDAI.modifyAllowanceViaMetaTransaction.selector,
        ownerSmartWallet,
        address(this),
        value,
        true, // increase
        expiration,
        salt,
        signatures
      )
    );

    // Protect against griefing via frontrunning by handling specific reverts.
    if (!ok) {
      DTokenInterface approverContract = DTokenInterface(approver);
      // Determine whether the meta-transaction in question has been used yet.
      (, bool valid) = approverContract.getMetaTransactionMessageHash(
        _DDAI.modifyAllowanceViaMetaTransaction.selector,
        abi.encode(ownerSmartWallet, address(this), value, true),
        expiration,
        salt
      );

      // Revert with the original message if it has not been used.
      if (valid) {
        assembly { revert(add(32, returnData), mload(returnData)) }
      }

      // If it has been used, determine if there is still sufficient allowance.
      uint256 allowance = approverContract.allowance(
        ownerSmartWallet, address(this)
      );

      // Revert with the original message if allowance is insufficient.
      if (allowance < value) {
        assembly { revert(add(32, returnData), mload(returnData)) }
      }
    }
  }

  /**
   * @notice Private function to set a new account on a given role and emit a
   * `RoleModified` event if the role holder has changed.
   * @param role The role that the account will be set for.
   * @param account The account to set as the designated role bearer.
   */
  function _setRole(Role role, address account) private {
    RoleStatus storage storedRoleStatus = _roles[uint256(role)];

    if (account != storedRoleStatus.account) {
      storedRoleStatus.account = account;
      emit RoleModified(role, account);
    }
  }

  /**
   * @notice Private view function to check whether the caller is the current
   * role holder.
   * @param role The role to check for.
   * @return hasRole A boolean indicating if the caller has the specified role.
   */
  function _isRole(Role role) private view returns (bool hasRole) {
    hasRole = msg.sender == _roles[uint256(role)].account;
  }

  /**
   * @notice Private view function to check whether the given role is paused or
   * not.
   * @param role The role to check for.
   * @return paused A boolean indicating if the specified role is paused or not.
   */
  function _isPaused(Role role) private view returns (bool paused) {
    paused = _roles[uint256(role)].paused;
  }

  function _constructContext(
    bytes4 functionSelector,
    uint256 expiration,
    bytes32 salt,
    bytes memory arguments
  ) private view returns (bytes memory context) {
    context = abi.encodePacked(
      address(this), functionSelector, expiration, salt, arguments
    );
  }

  function _enforceExpiration(uint256 expiration) private view {
    require(
      expiration == 0 || now <= expiration,
      "Execution meta-transaction expired."
    );
  }

  function _enforceValidCanceller(address smartWallet) private view {
    require(
      msg.sender == smartWallet || msg.sender == _roles[uint256(
        Role.BOT_COMMANDER
      )].account,
      "Only wallet in question or bot commander role may cancel."
    );
  }

  /// @notice pass along revert reasons on external calls.
  function _revertOnFailure(bool ok) private pure {
    if (!ok) {
      assembly {
        returndatacopy(0, 0, returndatasize())
        revert(0, returndatasize())
      }
    }
  }

  /**
   * @notice Modifier that throws if called by any account other than the owner
   * or the supplied role, or if the caller is not the owner and the role in
   * question is paused.
   * @param role The role to require unless the caller is the owner. Permitted
   * roles are bot commander (0) and pauser (1).
   */
  modifier onlyOwnerOr(Role role) {
    if (!isOwner()) {
      require(_isRole(role), "Caller does not have a required role.");
      require(!_isPaused(role), "Role in question is currently paused.");
    }
    _;
  }
}