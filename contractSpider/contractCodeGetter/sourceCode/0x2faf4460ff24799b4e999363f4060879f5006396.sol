/**
 * SPDX-License-Identifier:MIT
 */
pragma solidity ^0.6.2;

import "@opengsn/gsn/contracts/BaseRelayRecipient.sol";

contract CaptureTheFlag is BaseRelayRecipient {

    event FlagCaptured(address previousHolder, address currentHolder);

    address public currentHolder = address(0);

    function versionRecipient() external override view returns (string memory) {
        return "1.0.0";
    }

    function setTrustedForwarder(address _trustedForwarder) public {
        trustedForwarder = _trustedForwarder;
    }

    function captureTheFlag() external {
        address previousHolder = currentHolder;

        currentHolder = _msgSender();

        emit FlagCaptured(previousHolder, currentHolder);
    }
}