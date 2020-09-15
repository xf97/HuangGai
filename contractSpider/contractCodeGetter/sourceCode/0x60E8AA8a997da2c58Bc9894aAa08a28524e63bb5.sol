pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

import "../../interfaces/trading/IFillOrder.sol";
import "../../interfaces/trading/ITokenTransferProxy.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";


/// @title TokenTransferProxy
/// @author Julian Wilson <julian@nextgenbt.com>
/// @notice Transfers tokens on behalf of the user.
contract TokenTransferProxy is ITokenTransferProxy {

    IFillOrder private fillOrder;

    constructor (IFillOrder _fillOrder) public {
        fillOrder = _fillOrder;
    }

    /// @notice Throws if the caller is not a fill order contract derivative
    modifier onlyFillOrder() {
        require(
            msg.sender == address(fillOrder),
            "ONLY_FILL_ORDER"
        );
        _;
    }

    /// @notice Uses `transferFrom` and ERC20 approval to transfer tokens.
    ///         Only callable by whitelisted addresses.
    /// @param token The address of the ERC20 token to transfer on the user's behalf.
    /// @param from The address of the user.
    /// @param to The destination address.
    /// @param value The amount to transfer.
    function transferFrom(
        address token,
        address from,
        address to,
        uint256 value
    )
        public
        onlyFillOrder
        returns (bool)
    {
        return IERC20(token).transferFrom(from, to, value);
    }
}