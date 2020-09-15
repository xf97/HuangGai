/**
 *Submitted for verification at Etherscan.io on 2020-06-02
*/

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/dolomite-options/protocol/interfaces/IOptionsController.sol

/*
 * Copyright 2020 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.13;
pragma experimental ABIEncoderV2;

contract IOptionsController {

    function name() public view returns (bytes32);
    function symbol() public view returns (bytes32);
    function decimals() public view returns (uint8);
    function totalSupply() public view returns (uint);
    function balanceOf(address owner) public view returns (uint);
    function allowance(address owner, address spender) public view returns (uint);

    function transfer(address from, address to, uint amount) public returns (bool);
    function transferFrom(address from, address to, address spender, uint amount) public returns (bool);
    function approve(address owner, address spender, uint amount) public returns (bool);

}

// File: contracts/dolomite-options/protocol/impl/OptionsTokenProxyImpl.sol

/*
 * Copyright 2020 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.13;




//contract OptionsTokenImpl is IERC20 {
contract OptionsTokenProxyImpl {

    // keccack("org.zeppelinos.proxy.implementation")
    bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;

    constructor(address _implementation) public {
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
            sstore(slot, _implementation)
        }
    }

    function() external {
        // _optionsTokenImpl must be a local variable to be accessed in inline assembly
        address impl = _implementation();
        assembly {
            calldatacopy(0, 0, calldatasize)
            let result := delegatecall(gas, impl, 0, calldatasize, 0, 0)
            returndatacopy(0, 0, returndatasize)
            switch result
            case 0 {
                revert(0, returndatasize)
            }
            default {
                return (0, returndatasize)
            }
        }
    }

    function _implementation() internal view returns (address impl) {
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
            impl := sload(slot)
        }
    }

}