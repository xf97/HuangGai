pragma solidity 0.5.16;


contract Initializable {
    bool public initialized;

    /// @notice Throws if this contract has already been initialized.
    modifier notInitialized() {
        require(!initialized, "ALREADY_INITIALIZED");
        _;
    }
}