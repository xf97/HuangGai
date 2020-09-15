pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

import "../../interfaces/permissions/ISuperAdminRole.sol";
import "./Whitelist.sol";


/// @title OutcomeReporterWhitelist
/// @author Julian Wilson <julian@nextgenbt.com>
/// @notice A whitelist that represents all members allowed to
///         change parameters in the protocol.
contract SystemParamsWhitelist is Whitelist {
    constructor(ISuperAdminRole _superAdminRole) public Whitelist(_superAdminRole) {}
}