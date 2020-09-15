pragma solidity ^0.5.17;

import "./Implementation.sol";
import "./Ownable.sol";


contract Proxy is Implementation, Ownable {

    constructor(address _implementation) public Ownable() {
        _setImplementation(_implementation);
    }

    /**
     * @dev Fallback function allowing to perform a delegatecall
     * to the given implementation. This function will return
     * whatever the implementation call returns
     */
    function ()
        external
        payable
    {
        address impl = implementation;
        require(impl != address(0), "Implementation address is invalid");
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize)
            let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
            let size := returndatasize
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }

    /**
     * @dev Upgrades the implementation address
     * @param _newImplementation address of the new implementation
     */
    function upgradeTo(address _newImplementation)
        external onlyOwner
    {
        require(
            implementation != _newImplementation,
            "New implementation address already set"
        );
        isSetup = false;
        _setImplementation(_newImplementation);
    }

    /**
     * @dev Sets the address of the current implementation
     * @param _newImp address of the new implementation
     */
    function _setImplementation(address _newImp) internal {
        implementation = _newImp;
    }
}
