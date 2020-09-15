// "SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import {
    GelatoActionsStandard
} from "@gelatonetwork/core/contracts/actions/GelatoActionsStandard.sol";
import {ChiToken} from "./ChiToken.sol";
import {
    DataFlow
} from "@gelatonetwork/core/contracts/gelato_core/interfaces/IGelatoCore.sol";
import {GelatoBytes} from "@gelatonetwork/core/contracts/libraries/GelatoBytes.sol";

/// @notice This action wraps around ChiToken.mint
/// @dev Use in conjunction with selfProviderGasLimit Gelato Task config
contract ActionChiMint is GelatoActionsStandard {

    ChiToken public immutable chiToken;
    constructor(ChiToken _chiToken) public { chiToken = _chiToken; }

    // ======= DEV HELPERS =========
    /// @dev use this function to encode the data off-chain for the action data field
    function getActionData(address _recipient, uint256 _chiAmount)
        public
        pure
        virtual
        returns(bytes memory)
    {
        if (_chiAmount > 140)
            revert("ActionChiMint.getActionData: max 140 CHI");
        return abi.encodeWithSelector(this.action.selector, _recipient, _chiAmount);
    }

    // ======= ACTION IMPLEMENTATION DETAILS =========
    /// @dev Call ChaiToken.mint via UserProxy (Delegatecall)
    function action(address _recipient, uint256 _chiAmount)
        public
        virtual
        delegatecallOnly("ActionChiMint.action")
    {
        try chiToken.mint(_chiAmount) {
        } catch Error(string memory error) {
            revert(string(abi.encodePacked("ActionChiMint.action.mint:", error)));
        } catch {
            revert("ActionChiMint.action.mint: unknown error");
        }

        try chiToken.transfer(_recipient, _chiAmount) returns (bool success) {
            require(success, "ActionChiMint.action.transfer: unsuccessful");
        } catch Error(string memory error) {
            revert(string(abi.encodePacked("ActionChiMint.action.transfer:", error)));
        } catch {
            revert("ActionChiMint.action.transfer: unknown error");
        }
    }

    // ===== ACTION TERMS CHECK ========
    // Make sure
    function termsOk(
        uint256,  // taskReceipId
        address,  // _userProxy
        bytes calldata _actionData,
        DataFlow,
        uint256,  // value
        uint256  // cycleId
    )
        public
        view
        virtual
        override
        returns(string memory)
    {
        if (this.action.selector != GelatoBytes.calldataSliceSelector(_actionData))
            return "ActionChiMint: invalid action selector";

        uint256 _chiAmount = abi.decode(_actionData[36:68], (uint256));

        // We want to restrict to 140 CHI minted max per TX
        // https://medium.com/@1inch.exchange/1inch-introduces-chi-gastoken-d0bd5bb0f92b
        if (_chiAmount > 140 || _chiAmount == 0)
            return "ActionChiMint: invalid chi amount";

        // STANDARD return string to signal actionConditions Ok
        return OK;
    }
}