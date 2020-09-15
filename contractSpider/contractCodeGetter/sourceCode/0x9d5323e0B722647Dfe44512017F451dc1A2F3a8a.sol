pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

import "../../libraries/LibOrder.sol";
import "../../interfaces/trading/IFillOrder.sol";
import "../../interfaces/trading/ICancelOrder.sol";
import "../../interfaces/trading/IFills.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";


/// @title Fills
/// @author Julian Wilson <julian@nextgenbt.com>
/// @notice Stores the "fullness" of each order, whose ID
///         is its hash.
contract Fills is IFills {
    using LibOrder for LibOrder.Order;
    using SafeMath for uint256;

    IFillOrder private fillOrder;
    ICancelOrder private cancelOrder;

    mapping(bytes32 => uint256) private filled;
    mapping(bytes32 => bool) private cancelled;
    mapping(bytes32 => bool) private fillHashSubmitted;

    /// @notice Throws if the caller is not the FillOrder contract.
    modifier onlyFillOrder() {
        require(
            msg.sender == address(fillOrder),
            "ONLY_FILL_ORDER"
        );
        _;
    }

    /// @notice Throws if the caller is not the CancelOrder contract.
    modifier onlyCancelOrderContract() {
        require(
            msg.sender == address(cancelOrder),
            "ONLY_CANCEL_ORDER_CONTRACT"
        );
        _;
    }

    constructor(IFillOrder _fillOrder, ICancelOrder _cancelOrder) public {
        fillOrder = _fillOrder;
        cancelOrder = _cancelOrder;
    }

    /// @notice Fill an order by the given amount.
    /// @param order The order to fill.
    /// @param amount The amount to fill it by.
    /// @return The new filled amount for this order.
    function fill(
        LibOrder.Order memory order,
        uint256 amount
    )
        public
        onlyFillOrder
        returns (uint256)
    {
        bytes32 orderHash = order.getOrderHash();
        filled[orderHash] = filled[orderHash].add(amount);
        return filled[orderHash];
    }

    /// @notice Cancels an order.
    /// @param order The order to cancel.
    function cancel(LibOrder.Order memory order)
        public
        onlyCancelOrderContract
    {
        bytes32 orderHash = order.getOrderHash();
        cancelled[orderHash] = true;
    }

    function setFillHashSubmitted(bytes32 fillHash)
        public
        onlyFillOrder
    {
        fillHashSubmitted[fillHash] = true;
    }

    function getFilled(bytes32 orderHash) public view returns (uint256) {
        return filled[orderHash];
    }

    function getCancelled(bytes32 orderHash) public view returns (bool) {
        return cancelled[orderHash];
    }

    function getFillHashSubmitted(bytes32 orderHash) public view returns (bool) {
        return fillHashSubmitted[orderHash];
    }

    /// @notice Check if an order has sufficient space.
    /// @param order The order to examine.
    /// @param takerAmount The amount to fill.
    /// @return true if there is enough space, false otherwise.
    function orderHasSpace(
        LibOrder.Order memory order,
        uint256 takerAmount
    )
        public
        view
        returns (bool)
    {
        return takerAmount <= remainingSpace(order);
    }

    /// @notice Gets the remaining space for an order.
    /// @param order The order to check.
    /// @return The remaining space on the order. It returns 0 if
    ///         the order is cancelled.
    function remainingSpace(LibOrder.Order memory order)
        public
        view
        returns (uint256)
    {
        bytes32 orderHash = order.getOrderHash();
        if (cancelled[orderHash]) {
            return 0;
        } else {
            return order.totalBetSize.sub(filled[orderHash]);
        }
    }

    /// @notice Checks if the order is cancelled.
    /// @param order The order to check.
    /// @return true if the order is cancelled, false otherwise.
    function isOrderCancelled(LibOrder.Order memory order)
        public
        view
        returns(bool)
    {
        bytes32 orderHash = order.getOrderHash();
        return cancelled[orderHash];
    }
}