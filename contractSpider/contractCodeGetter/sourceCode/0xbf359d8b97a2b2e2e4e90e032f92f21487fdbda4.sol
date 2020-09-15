/**
 *Submitted for verification at Etherscan.io on 2020-08-13
*/

pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;


interface TestyInterface {
  event CallSuccess(
    bytes32 actionID,
    bool rolledBack,
    uint256 nonce,
    address to,
    bytes data,
    bytes returnData
  );

  event CallFailure(
    bytes32 actionID,
    uint256 nonce,
    address to,
    bytes data,
    string revertReason
  );

  // ABIEncoderV2 uses an array of Calls for executing generic batch calls.
  struct Call {
    address to;
    bytes data;
  }

  // ABIEncoderV2 uses an array of CallReturns for handling generic batch calls.
  struct CallReturn {
    bool ok;
    bytes returnData;
  }

  function executeAction(
    address to,
    bytes calldata data,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok, bytes memory returnData);

  function executeActionWithAtomicBatchCalls(
    Call[] calldata calls,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool[] memory ok, bytes[] memory returnData);
}


// TOTALLY PUBLIC CONTRACT, DON'T SEND ME ANY MONEY!
contract Testy is TestyInterface {
  function executeAction(
    address to,
    bytes calldata data,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok, bytes memory returnData) {
    (ok, returnData) = to.call(data);
    
    // Emit a CallSuccess or CallFailure event based on the outcome of the call.
    if (ok) {
      // Note: while the call succeeded, the action may still have "failed"
      // (for example, successful calls to Compound can still return an error).
      emit CallSuccess(bytes32("actionID"), false, 1, to, data, returnData);
    } else {
      // Note: while the call failed, the nonce will still be incremented, which
      // will invalidate all supplied signatures.
      emit CallFailure(bytes32("actionID"), 1, to, data, string(returnData));
    }
  }

  function executeActionWithAtomicBatchCalls(
    Call[] memory calls,
    uint256 minimumActionGas,
    bytes memory userSignature,
    bytes memory dharmaSignature
  ) public returns (bool[] memory ok, bytes[] memory returnData) {
    ok = new bool[](calls.length);
    returnData = new bytes[](calls.length);

    // Make the atomic self-call - if any call fails, calls that preceded it
    // will be rolled back and calls that follow it will not be made.
    (bool externalOk, bytes memory rawCallResults) = address(this).call(
      abi.encodeWithSelector(
        this._executeActionWithAtomicBatchCallsAtomic.selector, calls
      )
    );

    // Parse data returned from self-call into each call result and store / log.
    CallReturn[] memory callResults = abi.decode(rawCallResults, (CallReturn[]));
    for (uint256 i = 0; i < callResults.length; i++) {
      Call memory currentCall = calls[i];

      // Set the status and the return data / revert reason from the call.
      ok[i] = callResults[i].ok;
      returnData[i] = callResults[i].returnData;

      // Emit CallSuccess or CallFailure event based on the outcome of the call.
      if (callResults[i].ok) {
        // Note: while the call succeeded, the action may still have "failed".
        emit CallSuccess(
          bytes32("actionID"),
          !externalOk, // If another call failed this will have been rolled back
          1,
          currentCall.to,
          currentCall.data,
          callResults[i].returnData
        );
      } else {
        // Note: while the call failed, the nonce will still be incremented,
        // which will invalidate all supplied signatures.
        emit CallFailure(
          bytes32("actionID"),
          1,
          currentCall.to,
          currentCall.data,
          string(callResults[i].returnData)
        );

        // exit early - any calls after the first failed call will not execute.
        break;
      }
    }
  }

  function _executeActionWithAtomicBatchCallsAtomic(
    Call[] memory calls
  ) public returns (CallReturn[] memory callResults) {
    bool rollBack = false;
    callResults = new CallReturn[](calls.length);

    for (uint256 i = 0; i < calls.length; i++) {
      // Perform low-level call and set return values using result.
      (bool ok, bytes memory returnData) = calls[i].to.call(calls[i].data);
      callResults[i] = CallReturn({ok: ok, returnData: returnData});
      if (!ok) {
        // Exit early - any calls after the first failed call will not execute.
        rollBack = true;
        break;
      }
    }

    if (rollBack) {
      // Wrap in length encoding and revert (provide data instead of a string).
      bytes memory callResultsBytes = abi.encode(callResults);
      assembly { revert(add(32, callResultsBytes), mload(callResultsBytes)) }
    }
  }
}