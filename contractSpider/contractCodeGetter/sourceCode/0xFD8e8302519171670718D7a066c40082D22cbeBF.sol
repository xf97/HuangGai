pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

import "./Whitelist.sol";
import "../../interfaces/permissions/ISuperAdminRole.sol";


/// @title OutcomeReporterWhitelist
/// @author Julian Wilson <julian@nextgenbt.com>
/// @notice A whitelist that represents all members allowed to
///         report on markets in the protocol.
contract OutcomeReporterWhitelist is Whitelist {
    constructor(ISuperAdminRole _superAdminRole) public Whitelist(_superAdminRole) {}
}