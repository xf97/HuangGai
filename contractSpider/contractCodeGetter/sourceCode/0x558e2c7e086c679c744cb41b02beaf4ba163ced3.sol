/**
 *Submitted for verification at Etherscan.io on 2020-05-11
*/

// File: contracts/lib/Owned.sol

// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.6.4;

/**
 * @title Owned
 * @dev Basic contract to define an owner.
 * @author Julien Niset - <julien@argent.xyz>
 */
contract Owned {

    // The owner
    address public owner;

    event OwnerChanged(address indexed _newOwner);

    /**
     * @dev Throws if the sender is not the owner.
     */
    modifier onlyOwner {
        require(msg.sender == owner, "O: Must be owner");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Lets the owner transfer ownership of the contract to a new owner.
     * @param _newOwner The new owner.
     */
    function changeOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "O: _newOwner must not be 0");
        owner = _newOwner;
        emit OwnerChanged(_newOwner);
    }
}

// File: contracts/MethodRegistry.sol

// Copyright (C) 2020  Argent Labs Ltd. <https://argent.xyz>

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.6.7;
pragma experimental ABIEncoderV2;


/**
 * @title MethodRegistry
 * @dev Registry of (contract, method signature) tuples.
 * @author Olivier Vdb - <olivier@argent.xyz>
 */
contract MethodRegistry is Owned {

    event Registration(address indexed _contract, bytes4 _method);
    event Deregistration(address indexed _contract, bytes4 _method);

    mapping(address => mapping(bytes4 => bool)) public isRegistered; // [contract_addr][method_sig] => bool

    // Used by `addList()` and `removeList()`
    struct ContractMethod {
        address addr;
        bytes4 method;
    }

    /************************ External Methods *******************************/

    function add(address _contract, bytes4 _method) external onlyOwner {
        _add(_contract, _method);
    }

    function remove(address _contract, bytes4 _method) external onlyOwner {
        _remove(_contract, _method);
    }

    function addList(ContractMethod[] calldata _contractMethods) external onlyOwner {
        for(uint i = 0; i < _contractMethods.length; i++) {
            _add(_contractMethods[i].addr, _contractMethods[i].method);
        }
    }

    function removeList(ContractMethod[] calldata _contractMethods) external onlyOwner {
        for(uint i = 0; i < _contractMethods.length; i++) {
            _remove(_contractMethods[i].addr, _contractMethods[i].method);
        }
    }

    /************************ Internal Methods *******************************/

    function _add(address _contract, bytes4 _method) internal {
        require(!isRegistered[_contract][_method], "MR: Already registered");
        isRegistered[_contract][_method] = true;
        emit Registration(_contract, _method);
    }

    function _remove(address _contract, bytes4 _method) internal {
        require(isRegistered[_contract][_method], "MR: Not registered");
        delete isRegistered[_contract][_method];
        emit Deregistration(_contract, _method);
    }
}