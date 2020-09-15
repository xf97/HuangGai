/**
 *Submitted for verification at Etherscan.io on 2020-05-08
*/

pragma solidity ^0.5.4;// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>

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


/**
 * @title Module
 * @dev Interface for a module.
 * A module MUST implement the addModule() method to ensure that a wallet with at least one module
 * can never end up in a "frozen" state.
 * @author Julien Niset - <julien@argent.xyz>
 */
interface Module {

    /**
     * @dev Inits a module for a wallet by e.g. setting some wallet specific parameters in storage.
     * @param _wallet The wallet.
     */
    function init(BaseWallet _wallet) external;

    /**
     * @dev Adds a module to a wallet.
     * @param _wallet The target wallet.
     * @param _module The modules to authorise.
     */
    function addModule(BaseWallet _wallet, Module _module) external;

    /**
    * @dev Utility method to recover any ERC20 token that was sent to the
    * module by mistake.
    * @param _token The token to recover.
    */
    function recoverToken(address _token) external;
}// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>

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


/**
 * @title BaseWallet
 * @dev Simple modular wallet that authorises modules to call its invoke() method.
 * @author Julien Niset - <julien@argent.xyz>
 */
contract BaseWallet {

    // The implementation of the proxy
    address public implementation;
    // The owner
    address public owner;
    // The authorised modules
    mapping (address => bool) public authorised;
    // The enabled static calls
    mapping (bytes4 => address) public enabled;
    // The number of modules
    uint public modules;

    event AuthorisedModule(address indexed module, bool value);
    event EnabledStaticCall(address indexed module, bytes4 indexed method);
    event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
    event Received(uint indexed value, address indexed sender, bytes data);
    event OwnerChanged(address owner);

    /**
     * @dev Throws if the sender is not an authorised module.
     */
    modifier moduleOnly {
        require(authorised[msg.sender], "BW: msg.sender not an authorized module");
        _;
    }

    /**
     * @dev Inits the wallet by setting the owner and authorising a list of modules.
     * @param _owner The owner.
     * @param _modules The modules to authorise.
     */
    function init(address _owner, address[] calldata _modules) external {
        require(owner == address(0) && modules == 0, "BW: wallet already initialised");
        require(_modules.length > 0, "BW: construction requires at least 1 module");
        owner = _owner;
        modules = _modules.length;
        for (uint256 i = 0; i < _modules.length; i++) {
            require(authorised[_modules[i]] == false, "BW: module is already added");
            authorised[_modules[i]] = true;
            Module(_modules[i]).init(this);
            emit AuthorisedModule(_modules[i], true);
        }
        if (address(this).balance > 0) {
            emit Received(address(this).balance, address(0), "");
        }
    }

    /**
     * @dev Enables/Disables a module.
     * @param _module The target module.
     * @param _value Set to true to authorise the module.
     */
    function authoriseModule(address _module, bool _value) external moduleOnly {
        if (authorised[_module] != _value) {
            emit AuthorisedModule(_module, _value);
            if (_value == true) {
                modules += 1;
                authorised[_module] = true;
                Module(_module).init(this);
            } else {
                modules -= 1;
                require(modules > 0, "BW: wallet must have at least one module");
                delete authorised[_module];
            }
        }
    }

    /**
    * @dev Enables a static method by specifying the target module to which the call
    * must be delegated.
    * @param _module The target module.
    * @param _method The static method signature.
    */
    function enableStaticCall(address _module, bytes4 _method) external moduleOnly {
        require(authorised[_module], "BW: must be an authorised module for static call");
        enabled[_method] = _module;
        emit EnabledStaticCall(_module, _method);
    }

    /**
     * @dev Sets a new owner for the wallet.
     * @param _newOwner The new owner.
     */
    function setOwner(address _newOwner) external moduleOnly {
        require(_newOwner != address(0), "BW: address cannot be null");
        owner = _newOwner;
        emit OwnerChanged(_newOwner);
    }

    /**
     * @dev Performs a generic transaction.
     * @param _target The address for the transaction.
     * @param _value The value of the transaction.
     * @param _data The data of the transaction.
     */
    function invoke(address _target, uint _value, bytes calldata _data) external moduleOnly returns (bytes memory _result) {
        bool success;
        // solium-disable-next-line security/no-call-value
        (success, _result) = _target.call.value(_value)(_data);
        if (!success) {
            // solium-disable-next-line security/no-inline-assembly
            assembly {
                returndatacopy(0, 0, returndatasize)
                revert(0, returndatasize)
            }
        }
        emit Invoked(msg.sender, _target, _value, _data);
    }

    /**
     * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
     * implement specific static methods. It delegates the static call to a target contract if the data corresponds
     * to an enabled method, or logs the call otherwise.
     */
    function() external payable {
        if (msg.data.length > 0) {
            address module = enabled[msg.sig];
            if (module == address(0)) {
                emit Received(msg.value, msg.sender, msg.data);
            } else {
                require(authorised[module], "BW: must be an authorised module for static call");
                // solium-disable-next-line security/no-inline-assembly
                assembly {
                    calldatacopy(0, 0, calldatasize())
                    let result := staticcall(gas, module, 0, calldatasize(), 0, 0)
                    returndatacopy(0, 0, returndatasize())
                    switch result
                    case 0 {revert(0, returndatasize())}
                    default {return (0, returndatasize())}
                }
            }
        }
    }
}// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>

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



/**
 * @title Owned
 * @dev Basic contract to define an owner.
 * @author Julien Niset - <julien@argent.im>
 */
contract Owned {

    // The owner
    address public owner;

    event OwnerChanged(address indexed _newOwner);

    /**
     * @dev Throws if the sender is not the owner.
     */
    modifier onlyOwner {
        require(msg.sender == owner, "Must be owner");
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
        require(_newOwner != address(0), "Address must not be null");
        owner = _newOwner;
        emit OwnerChanged(_newOwner);
    }
}

/**
 * ERC20 contract interface.
 */
contract ERC20 {
    function totalSupply() public view returns (uint);
    function decimals() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
}// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>

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



/**
 * @title ModuleRegistry
 * @dev Registry of authorised modules.
 * Modules must be registered before they can be authorised on a wallet.
 * @author Julien Niset - <julien@argent.im>
 */
contract ModuleRegistry is Owned {

    mapping (address => Info) internal modules;
    mapping (address => Info) internal upgraders;

    event ModuleRegistered(address indexed module, bytes32 name);
    event ModuleDeRegistered(address module);
    event UpgraderRegistered(address indexed upgrader, bytes32 name);
    event UpgraderDeRegistered(address upgrader);

    struct Info {
        bool exists;
        bytes32 name;
    }

    /**
     * @dev Registers a module.
     * @param _module The module.
     * @param _name The unique name of the module.
     */
    function registerModule(address _module, bytes32 _name) external onlyOwner {
        require(!modules[_module].exists, "MR: module already exists");
        modules[_module] = Info({exists: true, name: _name});
        emit ModuleRegistered(_module, _name);
    }

    /**
     * @dev Deregisters a module.
     * @param _module The module.
     */
    function deregisterModule(address _module) external onlyOwner {
        require(modules[_module].exists, "MR: module does not exist");
        delete modules[_module];
        emit ModuleDeRegistered(_module);
    }

        /**
     * @dev Registers an upgrader.
     * @param _upgrader The upgrader.
     * @param _name The unique name of the upgrader.
     */
    function registerUpgrader(address _upgrader, bytes32 _name) external onlyOwner {
        require(!upgraders[_upgrader].exists, "MR: upgrader already exists");
        upgraders[_upgrader] = Info({exists: true, name: _name});
        emit UpgraderRegistered(_upgrader, _name);
    }

    /**
     * @dev Deregisters an upgrader.
     * @param _upgrader The _upgrader.
     */
    function deregisterUpgrader(address _upgrader) external onlyOwner {
        require(upgraders[_upgrader].exists, "MR: upgrader does not exist");
        delete upgraders[_upgrader];
        emit UpgraderDeRegistered(_upgrader);
    }

    /**
    * @dev Utility method enbaling the owner of the registry to claim any ERC20 token that was sent to the
    * registry.
    * @param _token The token to recover.
    */
    function recoverToken(address _token) external onlyOwner {
        uint total = ERC20(_token).balanceOf(address(this));
        ERC20(_token).transfer(msg.sender, total);
    }

    /**
     * @dev Gets the name of a module from its address.
     * @param _module The module address.
     * @return the name.
     */
    function moduleInfo(address _module) external view returns (bytes32) {
        return modules[_module].name;
    }

    /**
     * @dev Gets the name of an upgrader from its address.
     * @param _upgrader The upgrader address.
     * @return the name.
     */
    function upgraderInfo(address _upgrader) external view returns (bytes32) {
        return upgraders[_upgrader].name;
    }

    /**
     * @dev Checks if a module is registered.
     * @param _module The module address.
     * @return true if the module is registered.
     */
    function isRegisteredModule(address _module) external view returns (bool) {
        return modules[_module].exists;
    }

    /**
     * @dev Checks if a list of modules are registered.
     * @param _modules The list of modules address.
     * @return true if all the modules are registered.
     */
    function isRegisteredModule(address[] calldata _modules) external view returns (bool) {
        for (uint i = 0; i < _modules.length; i++) {
            if (!modules[_modules[i]].exists) {
                return false;
            }
        }
        return true;
    }

    /**
     * @dev Checks if an upgrader is registered.
     * @param _upgrader The upgrader address.
     * @return true if the upgrader is registered.
     */
    function isRegisteredUpgrader(address _upgrader) external view returns (bool) {
        return upgraders[_upgrader].exists;
    }
}// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>

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


/**
 * @title Storage
 * @dev Base contract for the storage of a wallet.
 * @author Julien Niset - <julien@argent.im>
 */
contract Storage {

    /**
     * @dev Throws if the caller is not an authorised module.
     */
    modifier onlyModule(BaseWallet _wallet) {
        require(_wallet.authorised(msg.sender), "TS: must be an authorized module to call this method");
        _;
    }
}// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>

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


interface IGuardianStorage{

    /**
     * @dev Lets an authorised module add a guardian to a wallet.
     * @param _wallet The target wallet.
     * @param _guardian The guardian to add.
     */
    function addGuardian(BaseWallet _wallet, address _guardian) external;

    /**
     * @dev Lets an authorised module revoke a guardian from a wallet.
     * @param _wallet The target wallet.
     * @param _guardian The guardian to revoke.
     */
    function revokeGuardian(BaseWallet _wallet, address _guardian) external;

    /**
     * @dev Checks if an account is a guardian for a wallet.
     * @param _wallet The target wallet.
     * @param _guardian The account.
     * @return true if the account is a guardian for a wallet.
     */
    function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool);
}// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>

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




/**
 * @title GuardianStorage
 * @dev Contract storing the state of wallets related to guardians and lock.
 * The contract only defines basic setters and getters with no logic. Only modules authorised
 * for a wallet can modify its state.
 * @author Julien Niset - <julien@argent.im>
 * @author Olivier Van Den Biggelaar - <olivier@argent.im>
 */
contract GuardianStorage is IGuardianStorage, Storage {

    struct GuardianStorageConfig {
        // the list of guardians
        address[] guardians;
        // the info about guardians
        mapping (address => GuardianInfo) info;
        // the lock's release timestamp
        uint256 lock;
        // the module that set the last lock
        address locker;
    }

    struct GuardianInfo {
        bool exists;
        uint128 index;
    }

    // wallet specific storage
    mapping (address => GuardianStorageConfig) internal configs;

    // *************** External Functions ********************* //

    /**
     * @dev Lets an authorised module add a guardian to a wallet.
     * @param _wallet The target wallet.
     * @param _guardian The guardian to add.
     */
    function addGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
        GuardianStorageConfig storage config = configs[address(_wallet)];
        config.info[_guardian].exists = true;
        config.info[_guardian].index = uint128(config.guardians.push(_guardian) - 1);
    }

    /**
     * @dev Lets an authorised module revoke a guardian from a wallet.
     * @param _wallet The target wallet.
     * @param _guardian The guardian to revoke.
     */
    function revokeGuardian(BaseWallet _wallet, address _guardian) external onlyModule(_wallet) {
        GuardianStorageConfig storage config = configs[address(_wallet)];
        address lastGuardian = config.guardians[config.guardians.length - 1];
        if (_guardian != lastGuardian) {
            uint128 targetIndex = config.info[_guardian].index;
            config.guardians[targetIndex] = lastGuardian;
            config.info[lastGuardian].index = targetIndex;
        }
        config.guardians.length--;
        delete config.info[_guardian];
    }

    /**
     * @dev Returns the number of guardians for a wallet.
     * @param _wallet The target wallet.
     * @return the number of guardians.
     */
    function guardianCount(BaseWallet _wallet) external view returns (uint256) {
        return configs[address(_wallet)].guardians.length;
    }

    /**
     * @dev Gets the list of guaridans for a wallet.
     * @param _wallet The target wallet.
     * @return the list of guardians.
     */
    function getGuardians(BaseWallet _wallet) external view returns (address[] memory) {
        GuardianStorageConfig storage config = configs[address(_wallet)];
        address[] memory guardians = new address[](config.guardians.length);
        for (uint256 i = 0; i < config.guardians.length; i++) {
            guardians[i] = config.guardians[i];
        }
        return guardians;
    }

    /**
     * @dev Checks if an account is a guardian for a wallet.
     * @param _wallet The target wallet.
     * @param _guardian The account.
     * @return true if the account is a guardian for a wallet.
     */
    function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool) {
        return configs[address(_wallet)].info[_guardian].exists;
    }

    /**
     * @dev Lets an authorised module set the lock for a wallet.
     * @param _wallet The target wallet.
     * @param _releaseAfter The epoch time at which the lock should automatically release.
     */
    function setLock(BaseWallet _wallet, uint256 _releaseAfter) external onlyModule(_wallet) {
        configs[address(_wallet)].lock = _releaseAfter;
        if (_releaseAfter != 0 && msg.sender != configs[address(_wallet)].locker) {
            configs[address(_wallet)].locker = msg.sender;
        }
    }

    /**
     * @dev Checks if the lock is set for a wallet.
     * @param _wallet The target wallet.
     * @return true if the lock is set for the wallet.
     */
    function isLocked(BaseWallet _wallet) external view returns (bool) {
        return configs[address(_wallet)].lock > now;
    }

    /**
     * @dev Gets the time at which the lock of a wallet will release.
     * @param _wallet The target wallet.
     * @return the time at which the lock of a wallet will release, or zero if there is no lock set.
     */
    function getLock(BaseWallet _wallet) external view returns (uint256) {
        return configs[address(_wallet)].lock;
    }

    /**
     * @dev Gets the address of the last module that modified the lock for a wallet.
     * @param _wallet The target wallet.
     * @return the address of the last module that modified the lock for a wallet.
     */
    function getLocker(BaseWallet _wallet) external view returns (address) {
        return configs[address(_wallet)].locker;
    }
}/* The MIT License (MIT)

Copyright (c) 2016 Smart Contract Solutions, Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */



/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

    /**
    * @dev Multiplies two numbers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0); // Solidity only automatically asserts when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two numbers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }

    /**
    * @dev Returns ceil(a / b).
    */
    function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        if(a % b == 0) {
            return c;
        }
        else {
            return c + 1;
        }
    }

    // from DSMath - operations on fixed precision floats

    uint256 constant WAD = 10 ** 18;
    uint256 constant RAY = 10 ** 27;

    function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }
    function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }
    function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
    function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, RAY), y / 2) / y;
    }
}
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







/**
 * @title BaseModule
 * @dev Basic module that contains some methods common to all modules.
 * @author Julien Niset - <julien@argent.im>
 */
contract BaseModule is Module {

    // Empty calldata
    bytes constant internal EMPTY_BYTES = "";

    // The adddress of the module registry.
    ModuleRegistry internal registry;
    // The address of the Guardian storage
    GuardianStorage internal guardianStorage;

    /**
     * @dev Throws if the wallet is locked.
     */
    modifier onlyWhenUnlocked(BaseWallet _wallet) {
        // solium-disable-next-line security/no-block-members
        require(!guardianStorage.isLocked(_wallet), "BM: wallet must be unlocked");
        _;
    }

    event ModuleCreated(bytes32 name);
    event ModuleInitialised(address wallet);

    constructor(ModuleRegistry _registry, GuardianStorage _guardianStorage, bytes32 _name) public {
        registry = _registry;
        guardianStorage = _guardianStorage;
        emit ModuleCreated(_name);
    }

    /**
     * @dev Throws if the sender is not the target wallet of the call.
     */
    modifier onlyWallet(BaseWallet _wallet) {
        require(msg.sender == address(_wallet), "BM: caller must be wallet");
        _;
    }

    /**
     * @dev Throws if the sender is not the owner of the target wallet or the module itself.
     */
    modifier onlyWalletOwner(BaseWallet _wallet) {
        require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
        _;
    }

    /**
     * @dev Throws if the sender is not the owner of the target wallet.
     */
    modifier strictOnlyWalletOwner(BaseWallet _wallet) {
        require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
        _;
    }

    /**
     * @dev Inits the module for a wallet by logging an event.
     * The method can only be called by the wallet itself.
     * @param _wallet The wallet.
     */
    function init(BaseWallet _wallet) public onlyWallet(_wallet) {
        emit ModuleInitialised(address(_wallet));
    }

    /**
     * @dev Adds a module to a wallet. First checks that the module is registered.
     * @param _wallet The target wallet.
     * @param _module The modules to authorise.
     */
    function addModule(BaseWallet _wallet, Module _module) external strictOnlyWalletOwner(_wallet) {
        require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
        _wallet.authoriseModule(address(_module), true);
    }

    /**
    * @dev Utility method enbaling anyone to recover ERC20 token sent to the
    * module by mistake and transfer them to the Module Registry.
    * @param _token The token to recover.
    */
    function recoverToken(address _token) external {
        uint total = ERC20(_token).balanceOf(address(this));
        ERC20(_token).transfer(address(registry), total);
    }

    /**
     * @dev Helper method to check if an address is the owner of a target wallet.
     * @param _wallet The target wallet.
     * @param _addr The address.
     */
    function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
        return _wallet.owner() == _addr;
    }

    /**
     * @dev Helper method to invoke a wallet.
     * @param _wallet The target wallet.
     * @param _to The target address for the transaction.
     * @param _value The value of the transaction.
     * @param _data The data of the transaction.
     */
    function invokeWallet(address _wallet, address _to, uint256 _value, bytes memory _data) internal returns (bytes memory _res) {
        bool success;
        // solium-disable-next-line security/no-call-value
        (success, _res) = _wallet.call(abi.encodeWithSignature("invoke(address,uint256,bytes)", _to, _value, _data));
        if (success && _res.length > 0) { //_res is empty if _wallet is an "old" BaseWallet that can't return output values
            (_res) = abi.decode(_res, (bytes));
        } else if (_res.length > 0) {
            // solium-disable-next-line security/no-inline-assembly
            assembly {
                returndatacopy(0, 0, returndatasize)
                revert(0, returndatasize)
            }
        } else if (!success) {
            revert("BM: wallet invoke reverted");
        }
    }
}// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>

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



/**
 * @title RelayerModule
 * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer.
 * @author Julien Niset - <julien@argent.im>
 */
contract RelayerModule is BaseModule {

    uint256 constant internal BLOCKBOUND = 10000;

    mapping (address => RelayerConfig) public relayer;

    struct RelayerConfig {
        uint256 nonce;
        mapping (bytes32 => bool) executedTx;
    }

    event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);

    /**
     * @dev Throws if the call did not go through the execute() method.
     */
    modifier onlyExecute {
        require(msg.sender == address(this), "RM: must be called via execute()");
        _;
    }

    /* ***************** Abstract method ************************* */

    /**
    * @dev Gets the number of valid signatures that must be provided to execute a
    * specific relayed transaction.
    * @param _wallet The target wallet.
    * @param _data The data of the relayed transaction.
    * @return The number of required signatures.
    */
    function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) internal view returns (uint256);

    /**
    * @dev Validates the signatures provided with a relayed transaction.
    * The method MUST throw if one or more signatures are not valid.
    * @param _wallet The target wallet.
    * @param _data The data of the relayed transaction.
    * @param _signHash The signed hash representing the relayed transaction.
    * @param _signatures The signatures as a concatenated byte array.
    */
    function validateSignatures(
        BaseWallet _wallet,
        bytes memory _data,
        bytes32 _signHash,
        bytes memory _signatures) internal view returns (bool);

    /* ************************************************************ */

    /**
    * @dev Executes a relayed transaction.
    * @param _wallet The target wallet.
    * @param _data The data for the relayed transaction
    * @param _nonce The nonce used to prevent replay attacks.
    * @param _signatures The signatures as a concatenated byte array.
    * @param _gasPrice The gas price to use for the gas refund.
    * @param _gasLimit The gas limit to use for the gas refund.
    */
    function execute(
        BaseWallet _wallet,
        bytes calldata _data,
        uint256 _nonce,
        bytes calldata _signatures,
        uint256 _gasPrice,
        uint256 _gasLimit
    )
        external
        returns (bool success)
    {
        uint startGas = gasleft();
        bytes32 signHash = getSignHash(address(this), address(_wallet), 0, _data, _nonce, _gasPrice, _gasLimit);
        require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
        require(verifyData(address(_wallet), _data), "RM: the wallet authorized is different then the target of the relayed data");
        uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
        if ((requiredSignatures * 65) == _signatures.length) {
            if (verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
                if (requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures)) {
                    // solium-disable-next-line security/no-call-value
                    (success,) = address(this).call(_data);
                    refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
                }
            }
        }
        emit TransactionExecuted(address(_wallet), success, signHash);
    }

    /**
    * @dev Gets the current nonce for a wallet.
    * @param _wallet The target wallet.
    */
    function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
        return relayer[address(_wallet)].nonce;
    }

    /**
    * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
    * @param _from The starting address for the relayed transaction (should be the module)
    * @param _to The destination address for the relayed transaction (should be the wallet)
    * @param _value The value for the relayed transaction
    * @param _data The data for the relayed transaction
    * @param _nonce The nonce used to prevent replay attacks.
    * @param _gasPrice The gas price to use for the gas refund.
    * @param _gasLimit The gas limit to use for the gas refund.
    */
    function getSignHash(
        address _from,
        address _to,
        uint256 _value,
        bytes memory _data,
        uint256 _nonce,
        uint256 _gasPrice,
        uint256 _gasLimit
    )
        internal
        pure
        returns (bytes32)
    {
        return keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
        ));
    }

    /**
    * @dev Checks if the relayed transaction is unique.
    * @param _wallet The target wallet.
    * @param _signHash The signed hash of the transaction
    */
    function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 /* _nonce */, bytes32 _signHash) internal returns (bool) {
        if (relayer[address(_wallet)].executedTx[_signHash] == true) {
            return false;
        }
        relayer[address(_wallet)].executedTx[_signHash] = true;
        return true;
    }

    /**
    * @dev Checks that a nonce has the correct format and is valid.
    * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
    * @param _wallet The target wallet.
    * @param _nonce The nonce
    */
    function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
        if (_nonce <= relayer[address(_wallet)].nonce) {
            return false;
        }
        uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
        if (nonceBlock > block.number + BLOCKBOUND) {
            return false;
        }
        relayer[address(_wallet)].nonce = _nonce;
        return true;
    }

    /**
    * @dev Recovers the signer at a given position from a list of concatenated signatures.
    * @param _signedHash The signed hash
    * @param _signatures The concatenated signatures.
    * @param _index The index of the signature to recover.
    */
    function recoverSigner(bytes32 _signedHash, bytes memory _signatures, uint _index) internal pure returns (address) {
        uint8 v;
        bytes32 r;
        bytes32 s;
        // we jump 32 (0x20) as the first slot of bytes contains the length
        // we jump 65 (0x41) per signature
        // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
            s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
            v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
        }
        require(v == 27 || v == 28); // solium-disable-line error-reason
        return ecrecover(_signedHash, v, r, s);
    }

    /**
    * @dev Refunds the gas used to the Relayer.
    * For security reasons the default behavior is to not refund calls with 0 or 1 signatures.
    * @param _wallet The target wallet.
    * @param _gasUsed The gas used.
    * @param _gasPrice The gas price for the refund.
    * @param _gasLimit The gas limit for the refund.
    * @param _signatures The number of signatures used in the call.
    * @param _relayer The address of the Relayer.
    */
    function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
        uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
        // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
        if (_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
            if (_gasPrice > tx.gasprice) {
                amount = amount * tx.gasprice;
            } else {
                amount = amount * _gasPrice;
            }
            invokeWallet(address(_wallet), _relayer, amount, EMPTY_BYTES);
        }
    }

    /**
    * @dev Returns false if the refund is expected to fail.
    * @param _wallet The target wallet.
    * @param _gasUsed The expected gas used.
    * @param _gasPrice The expected gas price for the refund.
    */
    function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
        if (_gasPrice > 0 &&
            _signatures > 1 &&
            (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(address(this)) == false)) {
            return false;
        }
        return true;
    }

    /**
    * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
    * as the wallet passed as the input of the execute() method.
    @return false if the addresses are different.
    */
    function verifyData(address _wallet, bytes memory _data) private pure returns (bool) {
        require(_data.length >= 36, "RM: Invalid dataWallet");
        address dataWallet;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            //_data = {length:32}{sig:4}{_wallet:32}{...}
            dataWallet := mload(add(_data, 0x24))
        }
        return dataWallet == _wallet;
    }

    /**
    * @dev Parses the data to extract the method signature.
    */
    function functionPrefix(bytes memory _data) internal pure returns (bytes4 prefix) {
        require(_data.length >= 4, "RM: Invalid functionPrefix");
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            prefix := mload(add(_data, 0x20))
        }
    }
}// Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>

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




/**
 * @title OnlyOwnerModule
 * @dev Module that extends BaseModule and RelayerModule for modules where the execute() method
 * must be called with one signature frm the owner.
 * @author Julien Niset - <julien@argent.im>
 */
contract OnlyOwnerModule is BaseModule, RelayerModule {

    // bytes4 private constant IS_ONLY_OWNER_MODULE = bytes4(keccak256("isOnlyOwnerModule()"));

   /**
    * @dev Returns a constant that indicates that the module is an OnlyOwnerModule.
    * @return The constant bytes4(keccak256("isOnlyOwnerModule()"))
    */
    function isOnlyOwnerModule() external pure returns (bytes4) {
        // return IS_ONLY_OWNER_MODULE;
        return this.isOnlyOwnerModule.selector;
    }

    /**
     * @dev Adds a module to a wallet. First checks that the module is registered.
     * Unlike its overrided parent, this method can be called via the RelayerModule's execute()
     * @param _wallet The target wallet.
     * @param _module The modules to authorise.
     */
    function addModule(BaseWallet _wallet, Module _module) external onlyWalletOwner(_wallet) {
        require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
        _wallet.authoriseModule(address(_module), true);
    }

    // *************** Implementation of RelayerModule methods ********************* //

    // Overrides to use the incremental nonce and save some gas
    function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 /* _signHash */) internal returns (bool) {
        return checkAndUpdateNonce(_wallet, _nonce);
    }

    function validateSignatures(
        BaseWallet _wallet,
        bytes memory /* _data */,
        bytes32 _signHash,
        bytes memory _signatures
    )
        internal
        view
        returns (bool)
    {
        address signer = recoverSigner(_signHash, _signatures, 0);
        return isOwner(_wallet, signer); // "OOM: signer must be owner"
    }

    function getRequiredSignatures(BaseWallet /* _wallet */, bytes memory /* _data */) internal view returns (uint256) {
        return 1;
    }
}

contract GemLike {
    function balanceOf(address) public view returns (uint);
    function transferFrom(address, address, uint) public returns (bool);
    function approve(address, uint) public returns (bool success);
    function decimals() public view returns (uint);
    function transfer(address,uint) external returns (bool);
}

contract DSTokenLike {
    function mint(address,uint) external;
    function burn(address,uint) external;
}

contract VatLike {
    function can(address, address) public view returns (uint);
    function dai(address) public view returns (uint);
    function hope(address) public;
    function wards(address) public view returns (uint);
    function ilks(bytes32) public view returns (uint Art, uint rate, uint spot, uint line, uint dust);
    function urns(bytes32, address) public view returns (uint ink, uint art);
    function frob(bytes32, address, address, address, int, int) public;
    function slip(bytes32,address,int) external;
    function move(address,address,uint) external;
}

contract JoinLike {
    function ilk() public view returns (bytes32);
    function gem() public view returns (GemLike);
    function dai() public view returns (GemLike);
    function join(address, uint) public;
    function exit(address, uint) public;
    VatLike public vat;
    uint    public live;
}

contract ManagerLike {
    function vat() public view returns (address);
    function urns(uint) public view returns (address);
    function open(bytes32, address) public returns (uint);
    function frob(uint, int, int) public;
    function give(uint, address) public;
    function move(uint, address, uint) public;
    function flux(uint, address, uint) public;
    function shift(uint, uint) public;
    mapping (uint => bytes32) public ilks;
    mapping (uint => address) public owns;
}

contract ScdMcdMigrationLike {
    function swapSaiToDai(uint) public;
    function swapDaiToSai(uint) public;
    function migrate(bytes32) public returns (uint);
    JoinLike public saiJoin;
    JoinLike public wethJoin;
    JoinLike public daiJoin;
    ManagerLike public cdpManager;
    SaiTubLike public tub;
}

contract ValueLike {
    function peek() public returns (uint, bool);
}

contract SaiTubLike {
    function skr() public view returns (GemLike);
    function gem() public view returns (GemLike);
    function gov() public view returns (GemLike);
    function sai() public view returns (GemLike);
    function pep() public view returns (ValueLike);
    function bid(uint) public view returns (uint);
    function ink(bytes32) public view returns (uint);
    function tab(bytes32) public returns (uint);
    function rap(bytes32) public returns (uint);
    function shut(bytes32) public;
    function exit(uint) public;
}

contract VoxLike {
    function par() public returns (uint);
}

contract JugLike {
    function drip(bytes32) external;
}

contract PotLike {
    function chi() public view returns (uint);
    function pie(address) public view returns (uint);
    function drip() public;
}


/**
 * @title MakerRegistry
 * @dev Simple registry containing a mapping between token collaterals and their corresponding Maker Join adapters.
 * @author Olivier VDB - <olivier@argent.xyz>
 */
contract MakerRegistry is Owned {

    VatLike public vat;
    address[] public tokens;
    mapping (address => Collateral) public collaterals;
    mapping (bytes32 => address) public collateralTokensByIlks;

    struct Collateral {
        bool exists;
        uint128 index;
        JoinLike join;
        bytes32 ilk;
    }

    event CollateralAdded(address indexed _token);
    event CollateralRemoved(address indexed _token);

    constructor(VatLike _vat) public {
        vat = _vat;
    }

    /**
     * @dev Adds a new token as possible CDP collateral.
     * @param _joinAdapter The Join Adapter for the token.
     */
    function addCollateral(JoinLike _joinAdapter) external onlyOwner {
        require(vat.wards(address(_joinAdapter)) == 1, "MR: _joinAdapter not authorised in vat");
        address token = address(_joinAdapter.gem());
        require(!collaterals[token].exists, "MR: collateral already added");
        collaterals[token].exists = true;
        collaterals[token].index = uint128(tokens.push(token) - 1);
        collaterals[token].join = _joinAdapter;
        bytes32 ilk = _joinAdapter.ilk();
        collaterals[token].ilk = ilk;
        collateralTokensByIlks[ilk] = token;
        emit CollateralAdded(token);
    }

    /**
     * @dev Removes a token as possible CDP collateral.
     * @param _token The token to remove as collateral.
     */
    function removeCollateral(address _token) external onlyOwner {
        require(collaterals[_token].exists, "MR: collateral does not exist");
        delete collateralTokensByIlks[collaterals[_token].ilk];

        address last = tokens[tokens.length - 1];
        if (_token != last) {
            uint128 targetIndex = collaterals[_token].index;
            tokens[targetIndex] = last;
            collaterals[last].index = targetIndex;
        }
        tokens.length --;
        delete collaterals[_token];
        emit CollateralRemoved(_token);
    }

    /**
    * @dev Gets the list of supported collaterals.
    */
    function getCollateralTokens() external view returns (address[] memory _tokens) {
        _tokens = new address[](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
            _tokens[i] = tokens[i];
        }
        return _tokens;
    }

    /**
     * @dev Gets the ilk for a given token collateral.
     * @param _token The token collateral.
     */
    function getIlk(address _token) external view returns (bytes32 _ilk) {
        _ilk = collaterals[_token].ilk;
    }

    /**
    * @dev Gets the join adapter and collateral token for a given ilk.
    */
    function getCollateral(bytes32 _ilk) external view returns (JoinLike _join, GemLike _token) {
        _token = GemLike(collateralTokensByIlks[_ilk]);
        _join = collaterals[address(_token)].join;
    }
}// Copyright (C) 2019  Argent Labs Ltd. <https://argent.xyz>

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







/**
 * @title MakerV2Base
 * @dev Common base to MakerV2Invest and MakerV2Loan.
 * @author Olivier VDB - <olivier@argent.xyz>
 */
contract MakerV2Base is BaseModule, RelayerModule, OnlyOwnerModule {

    bytes32 constant private NAME = "MakerV2Manager";

    // The address of the (MCD) DAI token
    GemLike internal daiToken;
    // The address of the SAI <-> DAI migration contract
    address internal scdMcdMigration;
    // The address of the Dai Adapter
    JoinLike internal daiJoin;
    // The address of the Vat
    VatLike internal vat;

    uint256 constant internal RAY = 10 ** 27;

    using SafeMath for uint256;

    // *************** Constructor ********************** //

    constructor(
        ModuleRegistry _registry,
        GuardianStorage _guardianStorage,
        ScdMcdMigrationLike _scdMcdMigration
    )
        BaseModule(_registry, _guardianStorage, NAME)
        public
    {
        scdMcdMigration = address(_scdMcdMigration);
        daiJoin = _scdMcdMigration.daiJoin();
        daiToken = daiJoin.dai();
        vat = daiJoin.vat();
    }

}// Copyright (C) 2019  Argent Labs Ltd. <https://argent.xyz>

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


/**
 * @title MakerV2Invest
 * @dev Module to lock/unlock MCD DAI into/from Maker's Pot
 * @author Olivier VDB - <olivier@argent.xyz>
 */
contract MakerV2Invest is MakerV2Base {

    // The address of the Pot
    PotLike internal pot;

    // *************** Events ********************** //

    // WARNING: in a previous version of this module, the third parameter of `InvestmentRemoved`
    // represented the *fraction* (out of 10000) of the investment withdrawn, not the absolute amount withdrawn
    event InvestmentRemoved(address indexed _wallet, address _token, uint256 _amount);
    event InvestmentAdded(address indexed _wallet, address _token, uint256 _amount, uint256 _period);

    // *************** Constructor ********************** //

    constructor(PotLike _pot) public {
        pot = _pot;
    }

    // *************** External/Public Functions ********************* //

    /**
    * @dev Lets the wallet owner deposit MCD DAI into the DSR Pot.
    * @param _wallet The target wallet.
    * @param _amount The amount of DAI to deposit
    */
    function joinDsr(
        BaseWallet _wallet,
        uint256 _amount
    )
        external
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        // Execute drip to get the chi rate updated to rho == now, otherwise join will fail
        pot.drip();
        // Approve DAI adapter to take the DAI amount
        invokeWallet(address(_wallet), address(daiToken), 0, abi.encodeWithSignature("approve(address,uint256)", address(daiJoin), _amount));
        // Join DAI into the vat (_amount of external DAI is burned and the vat transfers _amount of internal DAI from the adapter to the _wallet)
        invokeWallet(address(_wallet), address(daiJoin), 0, abi.encodeWithSignature("join(address,uint256)", address(_wallet), _amount));
        // Approve the pot to take out (internal) DAI from the wallet's balance in the vat
        grantVatAccess(_wallet, address(pot));
        // Compute the pie value in the pot
        uint256 pie = _amount.mul(RAY) / pot.chi();
        // Join the pie value to the pot
        invokeWallet(address(_wallet), address(pot), 0, abi.encodeWithSignature("join(uint256)", pie));
        // Emitting event
        emit InvestmentAdded(address(_wallet), address(daiToken), _amount, 0);
    }

    /**
    * @dev Lets the wallet owner withdraw MCD DAI from the DSR pot.
    * @param _wallet The target wallet.
    * @param _amount The amount of DAI to withdraw.
    */
    function exitDsr(
        BaseWallet _wallet,
        uint256 _amount
    )
        external
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        // Execute drip to count the savings accumulated until this moment
        pot.drip();
        // Calculates the pie value in the pot equivalent to the DAI wad amount
        uint256 pie = _amount.mul(RAY) / pot.chi();
        // Exit DAI from the pot
        invokeWallet(address(_wallet), address(pot), 0, abi.encodeWithSignature("exit(uint256)", pie));
        // Allow adapter to access the _wallet's DAI balance in the vat
        grantVatAccess(_wallet, address(daiJoin));
        // Check the actual balance of DAI in the vat after the pot exit
        uint bal = vat.dai(address(_wallet));
        // It is necessary to check if due to rounding the exact _amount can be exited by the adapter.
        // Otherwise it will do the maximum DAI balance in the vat
        uint256 withdrawn = bal >= _amount.mul(RAY) ? _amount : bal / RAY;
        invokeWallet(address(_wallet), address(daiJoin), 0, abi.encodeWithSignature("exit(address,uint256)", address(_wallet), withdrawn));
        // Emitting event
        emit InvestmentRemoved(address(_wallet), address(daiToken), withdrawn);
    }

    /**
    * @dev Lets the wallet owner withdraw their entire MCD DAI balance from the DSR pot.
    * @param _wallet The target wallet.
    */
    function exitAllDsr(
        BaseWallet _wallet
    )
        external
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        // Execute drip to count the savings accumulated until this moment
        pot.drip();
        // Gets the total pie belonging to the _wallet
        uint256 pie = pot.pie(address(_wallet));
        // Exit DAI from the pot
        invokeWallet(address(_wallet), address(pot), 0, abi.encodeWithSignature("exit(uint256)", pie));
        // Allow adapter to access the _wallet's DAI balance in the vat
        grantVatAccess(_wallet, address(daiJoin));
        // Exits the DAI amount corresponding to the value of pie
        uint256 withdrawn = pot.chi().mul(pie) / RAY;
        invokeWallet(address(_wallet), address(daiJoin), 0, abi.encodeWithSignature("exit(address,uint256)", address(_wallet), withdrawn));
        // Emitting event
        emit InvestmentRemoved(address(_wallet), address(daiToken), withdrawn);
    }

    /**
    * @dev Returns the amount of DAI currently held in the DSR pot.
    * @param _wallet The target wallet.
    * @return The DSR balance.
    */
    function dsrBalance(BaseWallet _wallet) external view returns (uint256 _balance) {
        return pot.chi().mul(pot.pie(address(_wallet))) / RAY;
    }

    /* ****************************************** Internal method ******************************************* */

    /**
    * @dev Grant access to the wallet's internal DAI balance in the VAT to an operator.
    * @param _wallet The target wallet.
    * @param _operator The grantee of the access
    */
    function grantVatAccess(BaseWallet _wallet, address _operator) internal {
        if (vat.can(address(_wallet), _operator) == 0) {
            invokeWallet(address(_wallet), address(vat), 0, abi.encodeWithSignature("hope(address)", _operator));
        }
    }
}// Copyright (C) 2019  Argent Labs Ltd. <https://argent.xyz>

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



interface IUniswapFactory {
    function getExchange(address _token) external view returns(IUniswapExchange);
}

interface IUniswapExchange {
    function getEthToTokenOutputPrice(uint256 _tokensBought) external view returns (uint256);
    function getEthToTokenInputPrice(uint256 _ethSold) external view returns (uint256);
    function getTokenToEthOutputPrice(uint256 _ethBought) external view returns (uint256);
    function getTokenToEthInputPrice(uint256 _tokensSold) external view returns (uint256);
}

/**
 * @title MakerV2Loan
 * @dev Module to migrate old CDPs and open and manage new vaults. The vaults managed by
 * this module are directly owned by the module. This is to prevent a compromised wallet owner
 * from being able to use `TransferManager.callContract()` to transfer ownership of a vault
 * (a type of asset NOT protected by a wallet's daily limit) to another account.
 * @author Olivier VDB - <olivier@argent.xyz>
 */
contract MakerV2Loan is MakerV2Base {

    // The address of the MKR token
    GemLike internal mkrToken;
    // The address of the WETH token
    GemLike internal wethToken;
    // The address of the WETH Adapter
    JoinLike internal wethJoin;
    // The address of the Jug
    JugLike internal jug;
    // The address of the Vault Manager (referred to as 'CdpManager' to match Maker's naming)
    ManagerLike internal cdpManager;
    // The address of the SCD Tub
    SaiTubLike internal tub;
    // The Maker Registry in which all supported collateral tokens and their adapters are stored
    MakerRegistry internal makerRegistry;
    // The Uniswap Exchange contract for DAI
    IUniswapExchange internal daiUniswap;
    // The Uniswap Exchange contract for MKR
    IUniswapExchange internal mkrUniswap;
    // Mapping [wallet][ilk] -> loanId, that keeps track of cdp owners
    // while also enforcing a maximum of one loan per token (ilk) and per wallet
    // (which will make future upgrades of the module easier)
    mapping(address => mapping(bytes32 => bytes32)) public loanIds;
    // Lock used by nonReentrant()
    bool private _notEntered = true;

    // Mock token address for ETH
    address constant internal ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    // ****************** Events *************************** //

    // Emitted when an SCD CDP is converted into an MCD vault
    event CdpMigrated(address indexed _wallet, bytes32 _oldCdpId, bytes32 _newVaultId);
    // Vault management events
    event LoanOpened(
        address indexed _wallet,
        bytes32 indexed _loanId,
        address _collateral,
        uint256 _collateralAmount,
        address _debtToken,
        uint256 _debtAmount
    );
    event LoanClosed(address indexed _wallet, bytes32 indexed _loanId);
    event CollateralAdded(address indexed _wallet, bytes32 indexed _loanId, address _collateral, uint256 _collateralAmount);
    event CollateralRemoved(address indexed _wallet, bytes32 indexed _loanId, address _collateral, uint256 _collateralAmount);
    event DebtAdded(address indexed _wallet, bytes32 indexed _loanId, address _debtToken, uint256 _debtAmount);
    event DebtRemoved(address indexed _wallet, bytes32 indexed _loanId, address _debtToken, uint256 _debtAmount);


    // *************** Modifiers *************************** //

    /**
     * @dev Throws if the sender is not an authorised module.
     */
    modifier onlyModule(BaseWallet _wallet) {
        require(_wallet.authorised(msg.sender), "MV2: sender unauthorized");
        _;
    }

    /**
     * @dev Prevents call reentrancy
     */
    modifier nonReentrant() {
        require(_notEntered, "MV2: reentrant call");
        _notEntered = false;
        _;
        _notEntered = true;
    }

    // *************** Constructor ********************** //

    constructor(
        JugLike _jug,
        MakerRegistry _makerRegistry,
        IUniswapFactory _uniswapFactory
    )
        public
    {
        cdpManager = ScdMcdMigrationLike(scdMcdMigration).cdpManager();
        tub = ScdMcdMigrationLike(scdMcdMigration).tub();
        wethJoin = ScdMcdMigrationLike(scdMcdMigration).wethJoin();
        wethToken = wethJoin.gem();
        mkrToken = tub.gov();
        jug = _jug;
        makerRegistry = _makerRegistry;
        daiUniswap = _uniswapFactory.getExchange(address(daiToken));
        mkrUniswap = _uniswapFactory.getExchange(address(mkrToken));
        // Authorize daiJoin to exit DAI from the module's internal balance in the vat
        vat.hope(address(daiJoin));
    }

    // *************** External/Public Functions ********************* //

    /* ********************************** Implementation of Loan ************************************* */

   /**
     * @dev Opens a collateralized loan.
     * @param _wallet The target wallet.
     * @param _collateral The token used as a collateral.
     * @param _collateralAmount The amount of collateral token provided.
     * @param _debtToken The token borrowed (must be the address of the DAI contract).
     * @param _debtAmount The amount of tokens borrowed.
     * @return The ID of the created vault.
     */
    function openLoan(
        BaseWallet _wallet,
        address _collateral,
        uint256 _collateralAmount,
        address _debtToken,
        uint256 _debtAmount
    )
        external
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
        returns (bytes32 _loanId)
    {
        verifySupportedCollateral(_collateral);
        require(_debtToken == address(daiToken), "MV2: debt token not DAI");
        _loanId = bytes32(openVault(_wallet, _collateral, _collateralAmount, _debtAmount));
        emit LoanOpened(address(_wallet), _loanId, _collateral, _collateralAmount, _debtToken, _debtAmount);
    }

    /**
     * @dev Adds collateral to a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the target vault.
     * @param _collateral The token used as a collateral.
     * @param _collateralAmount The amount of collateral to add.
     */
    function addCollateral(
        BaseWallet _wallet,
        bytes32 _loanId,
        address _collateral,
        uint256 _collateralAmount
    )
        external
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        verifyLoanOwner(_wallet, _loanId);
        addCollateral(_wallet, uint256(_loanId), _collateralAmount);
        emit CollateralAdded(address(_wallet), _loanId, _collateral, _collateralAmount);
    }

    /**
     * @dev Removes collateral from a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the target vault.
     * @param _collateral The token used as a collateral.
     * @param _collateralAmount The amount of collateral to remove.
     */
    function removeCollateral(
        BaseWallet _wallet,
        bytes32 _loanId,
        address _collateral,
        uint256 _collateralAmount
    )
        external
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        verifyLoanOwner(_wallet, _loanId);
        removeCollateral(_wallet, uint256(_loanId), _collateralAmount);
        emit CollateralRemoved(address(_wallet), _loanId, _collateral, _collateralAmount);
    }

    /**
     * @dev Increases the debt by borrowing more token from a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the target vault.
     * @param _debtToken The token borrowed (must be the address of the DAI contract).
     * @param _debtAmount The amount of token to borrow.
     */
    function addDebt(
        BaseWallet _wallet,
        bytes32 _loanId,
        address _debtToken,
        uint256 _debtAmount
    )
        external
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        verifyLoanOwner(_wallet, _loanId);
        addDebt(_wallet, uint256(_loanId), _debtAmount);
        emit DebtAdded(address(_wallet), _loanId, _debtToken, _debtAmount);
    }

    /**
     * @dev Decreases the debt by repaying some token from a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the target vault.
     * @param _debtToken The token to repay (must be the address of the DAI contract).
     * @param _debtAmount The amount of token to repay.
     */
    function removeDebt(
        BaseWallet _wallet,
        bytes32 _loanId,
        address _debtToken,
        uint256 _debtAmount
    )
        external
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        verifyLoanOwner(_wallet, _loanId);
        updateStabilityFee(uint256(_loanId));
        removeDebt(_wallet, uint256(_loanId), _debtAmount);
        emit DebtRemoved(address(_wallet), _loanId, _debtToken, _debtAmount);
    }

    /**
     * @dev Closes a collateralized loan by repaying all debts (plus interest) and redeeming all collateral.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the target vault.
     */
    function closeLoan(
        BaseWallet _wallet,
        bytes32 _loanId
    )
        external
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        verifyLoanOwner(_wallet, _loanId);
        updateStabilityFee(uint256(_loanId));
        closeVault(_wallet, uint256(_loanId));
        emit LoanClosed(address(_wallet), _loanId);
    }

    /* *************************************** Other vault methods ***************************************** */

    /**
     * @dev Lets a vault owner transfer their vault from their wallet to the present module so the vault
     * can be managed by the module.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the target vault.
     */
    function acquireLoan(
        BaseWallet _wallet,
        bytes32 _loanId
    )
        external
        nonReentrant
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        require(cdpManager.owns(uint256(_loanId)) == address(_wallet), "MV2: wrong vault owner");
        // Transfer the vault from the wallet to the module
        invokeWallet(
            address(_wallet),
            address(cdpManager),
            0,
            abi.encodeWithSignature("give(uint256,address)", uint256(_loanId), address(this))
        );
        require(cdpManager.owns(uint256(_loanId)) == address(this), "MV2: failed give");
        // Mark the incoming vault as belonging to the wallet (or merge it into the existing vault if there is one)
        assignLoanToWallet(_wallet, _loanId);
    }

    /**
     * @dev Lets a SCD CDP owner migrate their CDP to use the new MCD engine.
     * Requires MKR or ETH to pay the SCD governance fee
     * @param _wallet The target wallet.
     * @param _cup id of the old SCD CDP to migrate
     */
    function migrateCdp(
        BaseWallet _wallet,
        bytes32 _cup
    )
        external
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
        returns (bytes32 _loanId)
    {
        (uint daiPerMkr, bool ok) = tub.pep().peek();
        if (ok && daiPerMkr != 0) {
            // get governance fee in MKR
            uint mkrFee = tub.rap(_cup).wdiv(daiPerMkr);
            // Convert some ETH into MKR with Uniswap if necessary
            buyTokens(_wallet, mkrToken, mkrFee, mkrUniswap);
            // Transfer the MKR to the Migration contract
            invokeWallet(address(_wallet), address(mkrToken), 0, abi.encodeWithSignature("transfer(address,uint256)", address(scdMcdMigration), mkrFee));
        }
        // Transfer ownership of the SCD CDP to the migration contract
        invokeWallet(address(_wallet), address(tub), 0, abi.encodeWithSignature("give(bytes32,address)", _cup, address(scdMcdMigration)));
        // Update stability fee rate
        jug.drip(wethJoin.ilk());
        // Execute the CDP migration
        _loanId = bytes32(ScdMcdMigrationLike(scdMcdMigration).migrate(_cup));
        // Mark the new vault as belonging to the wallet (or merge it into the existing vault if there is one)
        _loanId = assignLoanToWallet(_wallet, _loanId);

        emit CdpMigrated(address(_wallet), _cup, _loanId);
    }

    /**
     * @dev Lets a future upgrade of this module transfer a vault to itself
     * @param _wallet The target wallet.
     * @param _loanId The ID of the target vault.
     */
    function giveVault(
        BaseWallet _wallet,
        bytes32 _loanId
    )
        external
        onlyModule(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        verifyLoanOwner(_wallet, _loanId);
        cdpManager.give(uint256(_loanId), msg.sender);
        clearLoanOwner(_wallet, _loanId);
    }

    /* ************************************** Internal Functions ************************************** */

    function toInt(uint256 _x) internal pure returns (int _y) {
        _y = int(_x);
        require(_y >= 0, "MV2: int overflow");
    }

    function assignLoanToWallet(BaseWallet _wallet, bytes32 _loanId) internal returns (bytes32 _assignedLoanId) {
        bytes32 ilk = cdpManager.ilks(uint256(_loanId));
        // Check if the user already holds a vault in the MakerV2Manager
        bytes32 existingLoanId = loanIds[address(_wallet)][ilk];
        if (existingLoanId > 0) {
            // Merge the new loan into the existing loan
            cdpManager.shift(uint256(_loanId), uint256(existingLoanId));
            return existingLoanId;
        }
        // Record the new vault as belonging to the wallet
        loanIds[address(_wallet)][ilk] = _loanId;
        return _loanId;
    }

    function clearLoanOwner(BaseWallet _wallet, bytes32 _loanId) internal {
        delete loanIds[address(_wallet)][cdpManager.ilks(uint256(_loanId))];
    }

    function verifyLoanOwner(BaseWallet _wallet, bytes32 _loanId) internal view {
        require(loanIds[address(_wallet)][cdpManager.ilks(uint256(_loanId))] == _loanId, "MV2: unauthorized loanId");
    }

    function verifySupportedCollateral(address _collateral) internal view {
        if (_collateral != ETH_TOKEN_ADDRESS) {
            (bool collateralSupported,,,) = makerRegistry.collaterals(_collateral);
            require(collateralSupported, "MV2: unsupported collateral");
        }
    }

    function buyTokens(
        BaseWallet _wallet,
        GemLike _token,
        uint256 _tokenAmountRequired,
        IUniswapExchange _uniswapExchange
    )
        internal
    {
        // get token balance
        uint256 tokenBalance = _token.balanceOf(address(_wallet));
        if (tokenBalance < _tokenAmountRequired) {
            // Not enough tokens => Convert some ETH into tokens with Uniswap
            uint256 etherValueOfTokens = _uniswapExchange.getEthToTokenOutputPrice(_tokenAmountRequired - tokenBalance);
            // solium-disable-next-line security/no-block-members
            invokeWallet(address(_wallet), address(_uniswapExchange), etherValueOfTokens, abi.encodeWithSignature("ethToTokenSwapOutput(uint256,uint256)", _tokenAmountRequired - tokenBalance, now));
        }
    }

    function joinCollateral(
        BaseWallet _wallet,
        uint256 _cdpId,
        uint256 _collateralAmount,
        bytes32 _ilk
    )
        internal
    {
        // Get the adapter and collateral token for the vault
        (JoinLike gemJoin, GemLike collateral) = makerRegistry.getCollateral(_ilk);
        // Convert ETH to WETH if needed
        if (gemJoin == wethJoin) {
            invokeWallet(address(_wallet), address(wethToken), _collateralAmount, abi.encodeWithSignature("deposit()"));
        }
        // Send the collateral to the module
        invokeWallet(
            address(_wallet),
            address(collateral),
            0,
            abi.encodeWithSignature("transfer(address,uint256)", address(this), _collateralAmount)
        );
        // Approve the adapter to pull the collateral from the module
        collateral.approve(address(gemJoin), _collateralAmount);
        // Join collateral to the adapter. The first argument to `join` is the address that *technically* owns the vault
        gemJoin.join(cdpManager.urns(_cdpId), _collateralAmount);
    }

    function joinDebt(
        BaseWallet _wallet,
        uint256 _cdpId,
        uint256 _debtAmount //  art.mul(rate).div(RAY) === [wad]*[ray]/[ray]=[wad]
    )
        internal
    {
        // Send the DAI to the module
        invokeWallet(address(_wallet), address(daiToken), 0, abi.encodeWithSignature("transfer(address,uint256)", address(this), _debtAmount));
        // Approve the DAI adapter to burn DAI from the module
        daiToken.approve(address(daiJoin), _debtAmount);
        // Join DAI to the adapter. The first argument to `join` is the address that *technically* owns the vault
        // To avoid rounding issues, we substract one wei to the amount joined
        daiJoin.join(cdpManager.urns(_cdpId), _debtAmount.sub(1));
    }

    function drawAndExitDebt(
        BaseWallet _wallet,
        uint256 _cdpId,
        uint256 _debtAmount,
        uint256 _collateralAmount,
        bytes32 _ilk
    )
        internal
    {
        // Get the accumulated rate for the collateral type
        (, uint rate,,,) = vat.ilks(_ilk);
        // Express the debt in the RAD units used internally by the vat
        uint daiDebtInRad = _debtAmount.mul(RAY);
        // Lock the collateral and draw the debt. To avoid rounding issues we add an extra wei of debt
        cdpManager.frob(_cdpId, toInt(_collateralAmount), toInt(daiDebtInRad.div(rate) + 1));
        // Transfer the (internal) DAI debt from the cdp's urn to the module.
        cdpManager.move(_cdpId, address(this), daiDebtInRad);
        // Mint the DAI token and exit it to the user's wallet
        daiJoin.exit(address(_wallet), _debtAmount);
    }

    function updateStabilityFee(
        uint256 _cdpId
    )
        internal
    {
        jug.drip(cdpManager.ilks(_cdpId));
    }

    function debt(
        uint256 _cdpId
    )
        internal
        view
        returns (uint256 _fullRepayment, uint256 _maxNonFullRepayment)
    {
        bytes32 ilk = cdpManager.ilks(_cdpId);
        (, uint256 art) = vat.urns(ilk, cdpManager.urns(_cdpId));
        if (art > 0) {
            (, uint rate,,, uint dust) = vat.ilks(ilk);
            _maxNonFullRepayment = art.mul(rate).sub(dust).div(RAY);
            _fullRepayment = art.mul(rate).div(RAY)
                .add(1) // the amount approved is 1 wei more than the amount repaid, to avoid rounding issues
                .add(art-art.mul(rate).div(RAY).mul(RAY).div(rate)); // adding 1 extra wei if further rounding issues are expected
        }
    }

    function collateral(
        uint256 _cdpId
    )
        internal
        view
        returns (uint256 _collateralAmount)
    {
        (_collateralAmount,) = vat.urns(cdpManager.ilks(_cdpId), cdpManager.urns(_cdpId));
    }

    function verifyValidRepayment(
        uint256 _cdpId,
        uint256 _debtAmount
    )
        internal
        view
    {
        (uint256 fullRepayment, uint256 maxRepayment) = debt(_cdpId);
        require(_debtAmount <= maxRepayment || _debtAmount == fullRepayment, "MV2: repay less or full");
    }

     /**
     * @dev Lets the owner of a wallet open a new vault. The owner must have enough collateral
     * in their wallet.
     * @param _wallet The target wallet
     * @param _collateral The token to use as collateral in the vault.
     * @param _collateralAmount The amount of collateral to lock in the vault.
     * @param _debtAmount The amount of DAI to draw from the vault
     * @return The id of the created vault.
     */
    // solium-disable-next-line security/no-assign-params
    function openVault(
        BaseWallet _wallet,
        address _collateral,
        uint256 _collateralAmount,
        uint256 _debtAmount
    )
        internal
        returns (uint256 _cdpId)
    {
        // Continue with WETH as collateral instead of ETH if needed
        if (_collateral == ETH_TOKEN_ADDRESS) {
            _collateral = address(wethToken);
        }
        // Get the ilk for the collateral
        bytes32 ilk = makerRegistry.getIlk(_collateral);
        // Open a vault if there isn't already one for the collateral type (the vault owner will effectively be the module)
        _cdpId = uint256(loanIds[address(_wallet)][ilk]);
        if (_cdpId == 0) {
            _cdpId = cdpManager.open(ilk, address(this));
            // Mark the vault as belonging to the wallet
            loanIds[address(_wallet)][ilk] = bytes32(_cdpId);
        }
        // Move the collateral from the wallet to the vat
        joinCollateral(_wallet, _cdpId, _collateralAmount, ilk);
        // Draw the debt and exit it to the wallet
        if (_debtAmount > 0) {
            drawAndExitDebt(_wallet, _cdpId, _debtAmount, _collateralAmount, ilk);
        }
    }

    /**
     * @dev Lets the owner of a vault add more collateral to their vault. The owner must have enough of the
     * collateral token in their wallet.
     * @param _wallet The target wallet
     * @param _cdpId The id of the vault.
     * @param _collateralAmount The amount of collateral to add to the vault.
     */
    function addCollateral(
        BaseWallet _wallet,
        uint256 _cdpId,
        uint256 _collateralAmount
    )
        internal
    {
        // Move the collateral from the wallet to the vat
        joinCollateral(_wallet, _cdpId, _collateralAmount, cdpManager.ilks(_cdpId));
        // Lock the collateral
        cdpManager.frob(_cdpId, toInt(_collateralAmount), 0);
    }

    /**
     * @dev Lets the owner of a vault remove some collateral from their vault
     * @param _wallet The target wallet
     * @param _cdpId The id of the vault.
     * @param _collateralAmount The amount of collateral to remove from the vault.
     */
    function removeCollateral(
        BaseWallet _wallet,
        uint256 _cdpId,
        uint256 _collateralAmount
    )
        internal
    {
        // Unlock the collateral
        cdpManager.frob(_cdpId, -toInt(_collateralAmount), 0);
        // Transfer the (internal) collateral from the cdp's urn to the module.
        cdpManager.flux(_cdpId, address(this), _collateralAmount);
        // Get the adapter for the collateral
        (JoinLike gemJoin,) = makerRegistry.getCollateral(cdpManager.ilks(_cdpId));
        // Exit the collateral from the adapter.
        gemJoin.exit(address(_wallet), _collateralAmount);
        // Convert WETH to ETH if needed
        if (gemJoin == wethJoin) {
            invokeWallet(address(_wallet), address(wethToken), 0, abi.encodeWithSignature("withdraw(uint256)", _collateralAmount));
        }
    }

    /**
     * @dev Lets the owner of a vault draw more DAI from their vault.
     * @param _wallet The target wallet
     * @param _cdpId The id of the vault.
     * @param _amount The amount of additional DAI to draw from the vault.
     */
    function addDebt(
        BaseWallet _wallet,
        uint256 _cdpId,
        uint256 _amount
    )
        internal
    {
        // Draw and exit the debt to the wallet
        drawAndExitDebt(_wallet, _cdpId, _amount, 0, cdpManager.ilks(_cdpId));
    }

    /**
     * @dev Lets the owner of a vault partially repay their debt. The repayment is made up of
     * the outstanding DAI debt plus the DAI stability fee.
     * The method will use the user's DAI tokens in priority and will, if needed, convert the required
     * amount of ETH to cover for any missing DAI tokens.
     * @param _wallet The target wallet
     * @param _cdpId The id of the vault.
     * @param _amount The amount of DAI debt to repay.
     */
    function removeDebt(
        BaseWallet _wallet,
        uint256 _cdpId,
        uint256 _amount
    )
        internal
    {
        verifyValidRepayment(_cdpId, _amount);
        // Convert some ETH into DAI with Uniswap if necessary
        buyTokens(_wallet, daiToken, _amount, daiUniswap);
        // Move the DAI from the wallet to the vat.
        joinDebt(_wallet, _cdpId, _amount);
        // Get the accumulated rate for the collateral type
        (, uint rate,,,) = vat.ilks(cdpManager.ilks(_cdpId));
        // Repay the debt. To avoid rounding issues we reduce the repayment by one wei
        cdpManager.frob(_cdpId, 0, -toInt(_amount.sub(1).mul(RAY).div(rate)));
    }

    /**
     * @dev Lets the owner of a vault close their vault. The method will:
     * 1) repay all debt and fee
     * 2) free all collateral
     * @param _wallet The target wallet
     * @param _cdpId The id of the CDP.
     */
    function closeVault(
        BaseWallet _wallet,
        uint256 _cdpId
    )
        internal
    {
        (uint256 fullRepayment,) = debt(_cdpId);
        // Repay the debt
        if (fullRepayment > 0) {
            removeDebt(_wallet, _cdpId, fullRepayment);
        }
        // Remove the collateral
        uint256 ink = collateral(_cdpId);
        if (ink > 0) {
            removeCollateral(_wallet, _cdpId, ink);
        }
    }

}// Copyright (C) 2019  Argent Labs Ltd. <https://argent.xyz>

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




/**
 * @title MakerV2Manager
 * @dev Module to lock/unlock MCD DAI into/from Maker's Pot,
 * migrate old CDPs and open and manage new CDPs.
 * @author Olivier VDB - <olivier@argent.xyz>
 */
contract MakerV2Manager is MakerV2Base, MakerV2Invest, MakerV2Loan {

    // *************** Constructor ********************** //

    constructor(
        ModuleRegistry _registry,
        GuardianStorage _guardianStorage,
        ScdMcdMigrationLike _scdMcdMigration,
        PotLike _pot,
        JugLike _jug,
        MakerRegistry _makerRegistry,
        IUniswapFactory _uniswapFactory
    )
        MakerV2Base(_registry, _guardianStorage, _scdMcdMigration)
        MakerV2Invest(_pot)
        MakerV2Loan(_jug, _makerRegistry, _uniswapFactory)
        public
    {
    }

}