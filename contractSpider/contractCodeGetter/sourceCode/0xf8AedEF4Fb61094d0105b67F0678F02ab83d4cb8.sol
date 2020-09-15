pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

import "../../interfaces/permissions/IWhitelist.sol";
import "../../interfaces/trading/IFeeSchedule.sol";
import "../../libraries/LibOrder.sol";


/// @title FeeSchedule
/// @author Julian Wilson <julian@nextgenbt.com>
/// @notice Stores the oracle fee for each token (which will presumably all be the same)
contract FeeSchedule is IFeeSchedule {

    IWhitelist private systemParamsWhitelist;

    mapping(address => uint256) private oracleFees; // the convention is 10**20 = 100%

    event NewOracleFee(
        address indexed token,
        uint256 feeFrac
    );

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

    /// @notice Throws if the fee is too high.
    modifier underMaxOracleFee(uint256 feeFrac) {
        require(
            feeFrac < LibOrder.getOddsPrecision(),
            "ORACLE_FEE_TOO_HIGH"
        );
        _;
    }

    /// @notice Gets the oracle fee for the given token.
    /// @param token The token of interest.
    /// @return The oracle fee for this token.
    function getOracleFees(address token) public view returns (uint256) {
        return oracleFees[token];
    }

    /// @notice Sets the oracle fee for the given token.
    /// @param token The token to set.
    /// @param feeFrac The numerator of the fee fraction
    function setOracleFee(address token, uint256 feeFrac)
        public
        onlySystemParamsAdmin
        underMaxOracleFee(feeFrac)
    {
        oracleFees[token] = feeFrac;

        emit NewOracleFee(
            token,
            feeFrac
        );
    }
}