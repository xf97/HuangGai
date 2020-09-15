/*
  Copyright 2019,2020 StarkWare Industries Ltd.

  Licensed under the Apache License, Version 2.0 (the "License").
  You may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  https://www.starkware.co/open-source-license/

  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions
  and limitations under the License.
*/
pragma solidity ^0.5.2;

import "ApprovalChain.sol";
import "AvailabilityVerifiers.sol";
import "Freezable.sol";
import "MainGovernance.sol";
import "Operator.sol";
import "Tokens.sol";
import "Users.sol";
import "Verifiers.sol";
import "Deposits.sol";
import "Escapes.sol";
import "FullWithdrawals.sol";
import "StateRoot.sol";
import "UpdateState.sol";
import "Withdrawals.sol";
import "IECDSA.sol";
import "IFactRegistry.sol";

contract StarkExchange is
    IVerifierActions,
    MainGovernance,
    ApprovalChain,
    AvailabilityVerifiers,
    Operator,
    Freezable,
    Tokens,
    Users,
    StateRoot,
    Deposits,
    Verifiers,
    Withdrawals,
    FullWithdrawals,
    Escapes,
    UpdateState
{
    string constant public VERSION = "1.0.1";
    string constant INIT_TAG = "INIT_TAG_Starkware.StarkExchange.2020";

    /*
      Determines the key to the intialized mapping.
    */
    function initKey() internal pure returns(bytes32 key){
        key = keccak256(abi.encode(INIT_TAG, VERSION));
    }

    function internalInitialize(
        IFactRegistry escapeVerifier,
        IECDSA ecdsaContract,
        uint256 initialSequenceNumber,
        uint256 initialVaultRoot,
        uint256 initialOrderRoot,
        uint256 initialVaultTreeHeight,
        uint256 initialOrderTreeHeight
    )
    internal
    {
        initGovernance();
        Operator.initialize();
        StateRoot.initialize(initialSequenceNumber, initialVaultRoot,
            initialOrderRoot, initialVaultTreeHeight, initialOrderTreeHeight);
        Escapes.initialize(escapeVerifier);
        Users.initialize(ecdsaContract);
    }

    /*
      Called from the proxy, upon upgradeTo.
      If already initialized (determinted by the initKey) - will skip altogether.
      If not init yet && init data is not empty:
      1. extract data to init parameters.
      2. call internalInitializer with those params.
    */
    function initialize(bytes calldata data)
        external
    {
        bytes32 key = initKey();

        // Skip initialize if already been initialized.
        if (!initialized[key]){
            // If data is empty - skip internalInitializer.
            if (data.length > 0){
                // Ensure data length is exactly the correct size.
                // 224 = 2 * sizeof(address) + 5 * sizeof(uint256).
                require(data.length == 224, "INCORRECT_INIT_DATA_SIZE");
                IFactRegistry escapeVerifier;
                IECDSA ecdsaContract;
                uint256 initialSequenceNumber;
                uint256 initialVaultRoot;
                uint256 initialOrderRoot;
                uint256 initialVaultTreeHeight;
                uint256 initialOrderTreeHeight;
                (
                    escapeVerifier,
                    ecdsaContract,
                    initialSequenceNumber,
                    initialVaultRoot,
                    initialOrderRoot,
                    initialVaultTreeHeight,
                    initialOrderTreeHeight
                ) = abi.decode(data,
                    (IFactRegistry, IECDSA, uint256, uint256, uint256, uint256, uint256));

                internalInitialize(
                    escapeVerifier,
                    ecdsaContract,
                    initialSequenceNumber,
                    initialVaultRoot,
                    initialOrderRoot,
                    initialVaultTreeHeight,
                    initialOrderTreeHeight
                );
            }
            initialized[key] = true;
        }
    }
}
