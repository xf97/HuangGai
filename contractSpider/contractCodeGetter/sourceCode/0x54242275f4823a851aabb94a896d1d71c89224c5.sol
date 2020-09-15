/**
 *Submitted for verification at Etherscan.io on 2020-08-03
*/

// File: @openzeppelin\upgrades\contracts\Initializable.sol

pragma solidity >=0.4.24 <0.7.0;


/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

// File: contracts\multisig\MultiOwnable.sol

pragma solidity ^0.5.16;



contract MultiOwnable is
    Initializable
{

    struct VoteInfo {
        uint16 votesCounter;
        uint64 curVote;
        mapping(uint => mapping (address => bool)) isVoted; // [curVote][owner]
    }


    uint public constant MIN_VOTES = 2;

    mapping(bytes => VoteInfo) public votes;
    mapping(address => bool) public  multiOwners;

    uint public multiOwnersCounter;


    event VoteForCalldata(address _owner, bytes _data);


    modifier onlyMultiOwners {
        require(multiOwners[msg.sender], "Permission denied");

        uint curVote = votes[msg.data].curVote;

        // vote for current call
        if (!votes[msg.data].isVoted[curVote][msg.sender]) {
            votes[msg.data].isVoted[curVote][msg.sender] = true;
            votes[msg.data].votesCounter++;
        }

        if (votes[msg.data].votesCounter >= MIN_VOTES ||
            votes[msg.data].votesCounter >= multiOwnersCounter
        ){
            // iterate to new vote for this msg.data
            votes[msg.data].votesCounter = 0;
            votes[msg.data].curVote++;
            _;
        } else {
            emit VoteForCalldata(msg.sender, msg.data);
        }

    }


    // ** INITIALIZERS **

    function initialize() public initializer {
        _addOwner(msg.sender);
    }

    function initialize(address[] memory _newOwners) public initializer {
        require(_newOwners.length > 0, "Array lengths have to be greater than zero");

        for (uint i = 0; i < _newOwners.length; i++) {
            _addOwner(_newOwners[i]);
        }
    }


    // ** ONLY_MULTI_OWNERS functions **


    function addOwner(address _newOwner) public onlyMultiOwners {
        _addOwner(_newOwner);
    }


    function addOwners(address[] memory _newOwners) public onlyMultiOwners {
        require(_newOwners.length > 0, "Array lengths have to be greater than zero");

        for (uint i = 0; i < _newOwners.length; i++) {
            _addOwner(_newOwners[i]);
        }
    }

    function removeOwner(address _exOwner) public onlyMultiOwners {
        _removeOwner(_exOwner);
    }

    function removeOwners(address[] memory _exOwners) public onlyMultiOwners {
        require(_exOwners.length > 0, "Array lengths have to be greater than zero");

        for (uint i = 0; i < _exOwners.length; i++) {
            _removeOwner(_exOwners[i]);
        }
    }


    // ** INTERNAL functions **

    function _addOwner(address _newOwner) internal {
        require(!multiOwners[_newOwner], "The owner has already been added");

        // UPD states
        multiOwners[_newOwner] = true;
        multiOwnersCounter++;
    }

    function _removeOwner(address _exOwner) internal {
        require(multiOwners[_exOwner], "This address is not the owner");
        require(multiOwnersCounter > 1, "At least one owner required");

        // UPD states
        multiOwners[_exOwner] = false;
        multiOwnersCounter--;   // safe
    }

}

// File: contracts\multisig\interfaces\IAdminUpgradeabilityProxy.sol

pragma solidity ^0.5.16;


interface IAdminUpgradeabilityProxy {
    function changeAdmin(address newAdmin) external;
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes calldata data) external payable;
}

// File: contracts\multisig\ProxyAdminMultisig.sol

pragma solidity ^0.5.16;


// **INTERFACES**



/**
 * @title ProxyAdminMultisig
 * @dev This contract is the admin of a proxy, and is in charge
 * of upgrading it as well as transferring it to another admin.
 */
contract ProxyAdminMultisig is MultiOwnable {

    constructor() public {
        address[] memory newOwners = new address[](2);
        newOwners[0] = 0xdAE0aca4B9B38199408ffaB32562Bf7B3B0495fE;
        newOwners[1] = 0xBE1A1E7304E397A765aB0837ea2f5Cb7b4ca125C;
        initialize(newOwners);
    }
    /**
     * @dev Returns the current implementation of a proxy.
     * This is needed because only the proxy admin can query it.
     * @return The address of the current implementation of the proxy.
     */
    function getProxyImplementation(IAdminUpgradeabilityProxy proxy) public view returns (address) {
        // We need to manually run the static call since the getter cannot be flagged as view
        // bytes4(keccak256("implementation()")) == 0x5c60da1b
        (bool success, bytes memory returndata) = address(proxy).staticcall(hex"5c60da1b");
        require(success);
        return abi.decode(returndata, (address));
    }

    /**
     * @dev Returns the admin of a proxy. Only the admin can query it.
     * @return The address of the current admin of the proxy.
     */
    function getProxyAdmin(IAdminUpgradeabilityProxy proxy) public view returns (address) {
        // We need to manually run the static call since the getter cannot be flagged as view
        // bytes4(keccak256("admin()")) == 0xf851a440
        (bool success, bytes memory returndata) = address(proxy).staticcall(hex"f851a440");
        require(success);
        return abi.decode(returndata, (address));
    }

    /**
     * @dev Changes the admin of a proxy.
     * @param proxy Proxy to change admin.
     * @param newAdmin Address to transfer proxy administration to.
     */
    function changeProxyAdmin(IAdminUpgradeabilityProxy proxy, address newAdmin) public onlyMultiOwners {
        proxy.changeAdmin(newAdmin);
    }

    /**
     * @dev Upgrades a proxy to the newest implementation of a contract.
     * @param proxy Proxy to be upgraded.
     * @param implementation the address of the Implementation.
     */
    function upgrade(IAdminUpgradeabilityProxy proxy, address implementation) public onlyMultiOwners {
        proxy.upgradeTo(implementation);
    }

    /**
     * @dev Upgrades a proxy to the newest implementation of a contract and forwards a function call to it.
     * This is useful to initialize the proxied contract.
     * @param proxy Proxy to be upgraded.
     * @param implementation Address of the Implementation.
     * @param data Data to send as msg.data in the low level call.
     * It should include the signature and the parameters of the function to be called, as described in
     * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
     */
    function upgradeAndCall(IAdminUpgradeabilityProxy proxy, address implementation, bytes memory data) public payable onlyMultiOwners {
        proxy.upgradeToAndCall.value(msg.value)(implementation, data);
    }
}