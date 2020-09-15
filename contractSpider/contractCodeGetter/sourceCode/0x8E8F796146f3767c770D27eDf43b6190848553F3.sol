pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

import "../interfaces/permissions/IWhitelist.sol";
import "../interfaces/ISystemParameters.sol";


/// @title SystemParameters
/// @author Julian Wilson <julian@nextgenbt.com>
/// @notice Stores system parameters.
contract SystemParameters is ISystemParameters {
    address private oracleFeeRecipient;

    IWhitelist private systemParamsWhitelist;

    constructor(IWhitelist _systemParamsWhitelist) public {
        systemParamsWhitelist = _systemParamsWhitelist;
    }

    /// @notice Throws if the caller is not a system params admin.
    modifier onlySystemParamsAdmin() {
        require(
            systemParamsWhitelist.getWhitelisted(msg.sender),
            "NOT_SYSTEM_PARAM_ADMIN"
        );
        _;
    }

    /// @notice Sets the oracle fee recipient. Only callable by SystemParams admins.
    /// @param newOracleFeeRecipient The new oracle fee recipient address
    function setNewOracleFeeRecipient(address newOracleFeeRecipient)
        public
        onlySystemParamsAdmin
    {
        oracleFeeRecipient = newOracleFeeRecipient;
    }

    function getOracleFeeRecipient() public view returns (address) {
        return oracleFeeRecipient;
    }
}