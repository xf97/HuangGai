/**
 *Submitted for verification at Etherscan.io on 2020-05-17
*/

// File: contracts/interfaces/IWETH9.sol

pragma solidity >=0.4.0;

interface IWETH9 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function balanceOf(address) external view returns (uint);

    function allowance(address, address) external view returns (uint);

    receive() external payable;

    function deposit() external payable;

    function withdraw(uint wad) external;

    function totalSupply() external view returns (uint);

    function approve(address guy, uint wad) external returns (bool);

    function transfer(address dst, uint wad) external returns (bool);

    function transferFrom(address src, address dst, uint wad)
    external
    returns (bool);
}

// File: contracts/interfaces/IAdvancedWETH.sol

pragma solidity >=0.4.0;

/// @title Advanced WETH Interface
/// @author Moody Salem
/// @notice Unlocks additional features for Wrapped Ether, or WETH, that allow you to interact with contracts that
///     use WETH transparently as if you were using ETH. Approve this contract to spend your WETH to use.
/// @dev The underlying assumption is that the user wants to use ETH and avoid unnecessary approvals, but ERC20 is
///     required to interact with many protocols. This contract enables a user to interact with protocols consuming
///     ERC20 without additional approvals.
interface IAdvancedWETH {
    /// @notice Returns the WETH contract that this Advanced WETH contract uses.
    /// @dev Returns the WETH contract that this Advanced WETH contract uses.
    /// @return the WETH contract used by this contract.
    function weth() external view returns (address payable);

    /// @notice Deposits any ETH sent to the contract, and transfers additional WETH from the caller,
    ///     and then approves and calls another contract `to` with data `data`.
    /// @dev Use this method to spend a combination of ETH and WETH as WETH. Refunds any unspent WETH to the caller as
    ///     ETH. Note that either `amount` or `msg.value` may be 0, but not both.
    /// @param amount The amount to transfer from the caller to this contract and approve for the `to` address, or 0.
    /// @param to The address to approve and call after minting WETH
    /// @param data The data to forward to the contract after minting WETH
    function depositAndTransferFromThenCall(uint amount, address to, bytes calldata data) external payable;

    /// @notice Unwrap and forward all WETH held by the contract to the given address. This should never be called
    ///     directly, but rather as a callback from a contract call that results in sending WETH to this contract.
    /// @dev Use this method as a callback from other contracts to unwrap WETH before forwarding to the user.
    /// @param to The address that should receive the unwrapped ETH.
    function withdrawTo(address payable to) external;
}

// File: contracts/AdvancedWETH.sol

pragma solidity =0.6.7;



// See interface for documentation.
contract AdvancedWETH is IAdvancedWETH {
    address payable public override immutable weth;

    constructor(address payable weth_) public {
        weth = weth_;
    }

    // See interface for documentation.
    function depositAndTransferFromThenCall(uint amount, address to, bytes calldata data) external override payable {
        if (msg.value > 0) {
            IWETH9(weth).deposit{value: msg.value}();
        }
        if (amount > 0) {
            IWETH9(weth).transferFrom(msg.sender, address(this), amount);
        }
        uint total = msg.value + amount;
        require(total >= msg.value, 'OVERFLOW'); // nobody should be this rich.
        require(total > 0, 'ZERO_INPUTS');
        IWETH9(weth).approve(to, total);
        (bool success,) = to.call(data);
        require(success, 'TO_CALL_FAILED');
        // unwrap and refund any unspent WETH.
        withdrawTo(msg.sender);
    }

    // Only the WETH contract may send ETH via a call to withdraw.
    receive() payable external { require(msg.sender == weth, 'WETH_ONLY'); }

    // See interface for documentation.
    function withdrawTo(address payable to) public override {
        uint wethBalance = IWETH9(weth).balanceOf(address(this));
        if (wethBalance > 0) {
            IWETH9(weth).withdraw(wethBalance);
            (bool success,) = to.call{value: wethBalance}('');
            require(success, 'WITHDRAW_TO_CALL_FAILED');
        }
    }
}