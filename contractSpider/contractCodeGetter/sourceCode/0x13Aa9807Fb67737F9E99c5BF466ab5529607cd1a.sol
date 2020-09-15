/**
 *Submitted for verification at Etherscan.io on 2020-06-02
*/

pragma solidity ^0.6.0;


abstract contract DSProxyInterface {

    /// Truffle wont compile if this isn't commented
    // function execute(bytes memory _code, bytes memory _data)
    //     public virtual
    //     payable
    //     returns (address, bytes32);

    function execute(address _target, bytes memory _data) public virtual payable returns (bytes32);

    function setCache(address _cacheAddr) public virtual payable returns (bool);

    function owner() public virtual returns (address);
}

/// @title Implements logic for calling MCDSaverProxy always from same contract
contract MCDMonitorProxy {

    uint public CHANGE_PERIOD;
    address public monitor;
    address public owner;
    address public newMonitor;
    uint public changeRequestedTimestamp;

    mapping(address => bool) public allowed;

    // if someone who is allowed become malicious, owner can't be changed
    modifier onlyAllowed() {
        require(allowed[msg.sender] || msg.sender == owner);
        _;
    }

    modifier onlyMonitor() {
        require (msg.sender == monitor);
        _;
    }

    constructor(uint _changePeriod) public {
        owner = msg.sender;
        CHANGE_PERIOD = _changePeriod * 1 days;
    }

    /// @notice Allowed users are able to set Monitor contract without any waiting period first time
    /// @param _monitor Address of Monitor contract
    function setMonitor(address _monitor) public onlyAllowed {
        require(monitor == address(0));
        monitor = _monitor;
    }

    /// @notice Only monitor contract is able to call execute on users proxy
    /// @param _owner Address of cdp owner (users DSProxy address)
    /// @param _saverProxy Address of MCDSaverProxy
    /// @param _data Data to send to MCDSaverProxy
    function callExecute(address _owner, address _saverProxy, bytes memory _data) public onlyMonitor {
        // execute reverts if calling specific method fails
        DSProxyInterface(_owner).execute(_saverProxy, _data);
    }

    /// @notice Allowed users are able to start procedure for changing monitor
    /// @dev after CHANGE_PERIOD needs to call confirmNewMonitor to actually make a change
    /// @param _newMonitor address of new monitor
    function changeMonitor(address _newMonitor) public onlyAllowed {
        changeRequestedTimestamp = now;
        newMonitor = _newMonitor;
    }

    /// @notice At any point allowed users are able to cancel monitor change
    function cancelMonitorChange() public onlyAllowed {
        changeRequestedTimestamp = 0;
        newMonitor = address(0);
    }

    /// @notice Anyone is able to confirm new monitor after CHANGE_PERIOD if process is started
    function confirmNewMonitor() public onlyAllowed {
        require((changeRequestedTimestamp + CHANGE_PERIOD) < now);
        require(changeRequestedTimestamp != 0);
        require(newMonitor != address(0));

        monitor = newMonitor;
        newMonitor = address(0);
        changeRequestedTimestamp = 0;
    }

    /// @notice Allowed users are able to add new allowed user
    /// @param _user Address of user that will be allowed
    function addAllowed(address _user) public onlyAllowed {
        allowed[_user] = true;
    }

    /// @notice Allowed users are able to remove allowed user
    /// @dev owner is always allowed even if someone tries to remove it from allowed mapping
    /// @param _user Address of allowed user
    function removeAllowed(address _user) public onlyAllowed {
        allowed[_user] = false;
    }
}

/// @title Implements enum Method
contract Static {

    enum Method { Boost, Repay }
}

abstract contract ISubscriptions is Static {

    function canCall(Method _method, uint _cdpId) external virtual view returns(bool, uint);
    function getOwner(uint _cdpId) external virtual view returns(address);
    function ratioGoodAfter(Method _method, uint _cdpId) external virtual view returns(bool, uint);
    function getRatio(uint _cdpId) public view virtual returns (uint);
    function getSubscribedInfo(uint _cdpId) public virtual view returns(bool, uint128, uint128, uint128, uint128, address, uint coll, uint debt);
    function unsubscribeIfMoved(uint _cdpId) public virtual;
}

abstract contract Manager {
    function last(address) virtual public returns (uint);
    function cdpCan(address, uint, address) virtual public view returns (uint);
    function ilks(uint) virtual public view returns (bytes32);
    function owns(uint) virtual public view returns (address);
    function urns(uint) virtual public view returns (address);
    function vat() virtual public view returns (address);
    function open(bytes32, address) virtual public returns (uint);
    function give(uint, address) virtual public;
    function cdpAllow(uint, address, uint) virtual public;
    function urnAllow(address, uint) virtual public;
    function frob(uint, int, int) virtual public;
    function flux(uint, address, uint) virtual public;
    function move(uint, address, uint) virtual public;
    function exit(address, uint, address, uint) virtual public;
    function quit(uint, address) virtual public;
    function enter(address, uint) virtual public;
    function shift(uint, uint) virtual public;
}

contract AdminAuth {

    address public owner;
    address public admin;

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    /// @notice Admin is set by owner first time, after that admin is super role and has permission to change owner
    /// @param _admin Address of multisig that becomes admin
    function setAdminByOwner(address _admin) public {
        require(msg.sender == owner);
        require(admin == address(0));

        admin = _admin;
    }

    /// @notice Admin is able to set new admin
    /// @param _admin Address of multisig that becomes new admin
    function setAdminByAdmin(address _admin) public {
        require(msg.sender == admin);

        admin = _admin;
    }

    /// @notice Admin is able to change owner
    /// @param _owner Address of new owner
    function setOwnerByAdmin(address _owner) public {
        require(msg.sender == admin);

        owner = _owner;
    }
}

contract Auth is AdminAuth {

	bool public ALL_AUTHORIZED = false;

	mapping(address => bool) public authorized;

	modifier onlyAuthorized() {
        require(ALL_AUTHORIZED || authorized[msg.sender]);
        _;
    }

	constructor() public {
		authorized[msg.sender] = true;
	}

	function setAuthorized(address _user, bool _approved) public onlyOwner {
		authorized[_user] = _approved;
	}

	function setAllAuthorized(bool _authorized) public onlyOwner {
		ALL_AUTHORIZED = _authorized;
	}
}

abstract contract DSGuard {
    function canCall(address src_, address dst_, bytes4 sig) public view virtual returns (bool);

    function permit(bytes32 src, bytes32 dst, bytes32 sig) public virtual;

    function forbid(bytes32 src, bytes32 dst, bytes32 sig) public virtual;

    function permit(address src, address dst, bytes32 sig) public virtual;

    function forbid(address src, address dst, bytes32 sig) public virtual;
}

abstract contract DSGuardFactory {
    function newGuard() public virtual returns (DSGuard guard);
}

abstract contract DSAuthority {
    function canCall(address src, address dst, bytes4 sig) public virtual view returns (bool);
}

contract DSAuthEvents {
    event LogSetAuthority(address indexed authority);
    event LogSetOwner(address indexed owner);
}

contract DSAuth is DSAuthEvents {
    DSAuthority public authority;
    address public owner;

    constructor() public {
        owner = msg.sender;
        emit LogSetOwner(msg.sender);
    }

    function setOwner(address owner_) public auth {
        owner = owner_;
        emit LogSetOwner(owner);
    }

    function setAuthority(DSAuthority authority_) public auth {
        authority = authority_;
        emit LogSetAuthority(address(authority));
    }

    modifier auth {
        require(isAuthorized(msg.sender, msg.sig));
        _;
    }

    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
        if (src == address(this)) {
            return true;
        } else if (src == owner) {
            return true;
        } else if (authority == DSAuthority(0)) {
            return false;
        } else {
            return authority.canCall(src, address(this), sig);
        }
    }
}

contract ProxyPermission {
    address public constant FACTORY_ADDRESS = 0x5a15566417e6C1c9546523066500bDDBc53F88C7;

    /// @notice Called in the context of DSProxy to authorize an address
    /// @param _contractAddr Address which will be authorized
    function givePermission(address _contractAddr) public {
        address currAuthority = address(DSAuth(address(this)).authority());
        DSGuard guard = DSGuard(currAuthority);

        if (currAuthority == address(0)) {
            guard = DSGuardFactory(FACTORY_ADDRESS).newGuard();
            DSAuth(address(this)).setAuthority(DSAuthority(address(guard)));
        }

        guard.permit(_contractAddr, address(this), bytes4(keccak256("execute(address,bytes)")));
    }

    /// @notice Called in the context of DSProxy to remove authority of an address
    /// @param _contractAddr Auth address which will be removed from authority list
    function removePermission(address _contractAddr) public {
        address currAuthority = address(DSAuth(address(this)).authority());
        
        // if there is no authority, that means that contract doesn't have permission
        if (currAuthority == address(0)) {
            return;
        }

        DSGuard guard = DSGuard(currAuthority);
        guard.forbid(_contractAddr, address(this), bytes4(keccak256("execute(address,bytes)")));
    }
}

contract SubscriptionsMigration is Auth {

	// proxyPermission address
	address public proxyPermission;


	address public monitorProxyAddress = 0x93Efcf86b6a7a33aE961A7Ec6C741F49bce11DA7;
	// v1 monitor proxy
	MCDMonitorProxy public monitorProxyContract = MCDMonitorProxy(monitorProxyAddress);
	// v1 subscriptions contract
	ISubscriptions public subscriptionsContract = ISubscriptions(0x83152CAA0d344a2Fd428769529e2d490A88f4393);
	// v2 subscriptions proxy with "migrate" method
	address public subscriptionsProxyV2address = 0xd6f2125bF7FE2bc793dE7685EA7DEd8bff3917DD;
	// v2 subscriptions address (needs to be passed to migrate method)
	address public subscriptionsV2address = 0xC45d4f6B6bf41b6EdAA58B01c4298B8d9078269a;
	// v1 subscriptions address
	address public subscriptionsV1address = 0x83152CAA0d344a2Fd428769529e2d490A88f4393;
	// v1 subscriptions proxy address
	address public subscriptionsProxyV1address = 0xA5D33b02dBfFB3A9eF26ec21F15c43BdB53EB455;
	// manager to check if owner is valid
	Manager public manager = Manager(0x5ef30b9986345249bc32d8928B7ee64DE9435E39);

	constructor(address _proxyPermission) public {
		proxyPermission = _proxyPermission;
	}

	function migrate(uint[] memory _cdps) public onlyAuthorized {

		for (uint i=0; i<_cdps.length; i++) {
			if (_cdps[i] == 0) continue;

			bool sub;
			uint minRatio;
			uint maxRatio;
			uint optimalRepay;
			uint optimalBoost;
			address cdpOwner;
			uint collateral;

			// get data for specific cdp
			(sub, minRatio, maxRatio, optimalRepay, optimalBoost, cdpOwner, collateral,) = subscriptionsContract.getSubscribedInfo(_cdps[i]);

			// if user is not the owner anymore, we will have to unsub him manually
			if (cdpOwner != _getOwner(_cdps[i])) {
				continue;
			} 

			// call migrate method on SubscriptionsProxyV2 through users DSProxy if cdp is subbed and have collateral
			if (sub && collateral > 0) {
				monitorProxyContract.callExecute(cdpOwner, subscriptionsProxyV2address, abi.encodeWithSignature("migrate(uint256,uint128,uint128,uint128,uint128,bool,bool,address)", _cdps[i], minRatio, maxRatio, optimalBoost, optimalRepay, true, true, subscriptionsV2address));
			} else {
				// if cdp is subbed but no collateral, just unsubscribe user
				if (sub) {
					_unsubscribe(_cdps[i], cdpOwner);
				}
			}

			// don't remove authority here because we wouldn't be able to unsub or migrate if user have more than one cdp
		}
	}

	function removeAuthority(address[] memory _users) public onlyAuthorized {

		for (uint i=0; i<_users.length; i++) {
			_removeAuthority(_users[i]);
		}
	}

	function _unsubscribe(uint _cdpId, address _cdpOwner) internal onlyAuthorized {
		address currAuthority = address(DSAuth(_cdpOwner).authority());
		// if no authority return
		if (currAuthority == address(0)) return;
        DSGuard guard = DSGuard(currAuthority);

        // if we don't have permission on specific authority, return
        if (!guard.canCall(monitorProxyAddress, _cdpOwner, bytes4(keccak256("execute(address,bytes)")))) return;

        // call unsubscribe on v1 proxy through users DSProxy
		monitorProxyContract.callExecute(_cdpOwner, subscriptionsProxyV1address, abi.encodeWithSignature("unsubscribe(uint256,address)", _cdpId, subscriptionsV1address));
	}

	function _removeAuthority(address _cdpOwner) internal onlyAuthorized {

		address currAuthority = address(DSAuth(_cdpOwner).authority());
		// if no authority return
		if (currAuthority == address(0)) return;
        DSGuard guard = DSGuard(currAuthority);

        // if we don't have permission, that means its already removed
        if (!guard.canCall(monitorProxyAddress, _cdpOwner, bytes4(keccak256("execute(address,bytes)")))) return;

		monitorProxyContract.callExecute(_cdpOwner, proxyPermission, abi.encodeWithSignature("removePermission(address)", monitorProxyAddress));
	}

	/// @notice Returns an address that owns the CDP
    /// @param _cdpId Id of the CDP
    function _getOwner(uint _cdpId) internal view returns(address) {
        return manager.owns(_cdpId);
    }
}