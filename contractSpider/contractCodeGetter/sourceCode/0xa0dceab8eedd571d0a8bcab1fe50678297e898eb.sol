/**
 *Submitted for verification at Etherscan.io on 2020-07-29
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

// Interface necessary to interact with CHI
abstract contract IFreeUpTo {
	function freeUpTo(uint256 _value) public virtual returns (uint256 _freed);
}

// Minimum required ERC20 interface
abstract contract IERC20 {
    function totalSupply() public virtual view returns (uint256);
    function transfer(address _to, uint256 _value) public virtual returns (bool ok);
    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool ok);
    function balanceOf(address _owner) public virtual returns (uint256 balance);
    function approve(address _spender, uint256 _value) public virtual returns (bool success);
    function allowance(address _owner, address _spender) public virtual view returns (uint256 amt);
}

// A simple contract wallet that burns CHI when it can (from itself).
contract GasWallet {
    
    event Spawned(address _this);       // Emitted on construction
    event UserChanged(address _user);   // User is changed to new address
    
    // Maximum ERC-20 allowance
    uint256 public constant MAX_ALLOWANCE = (2 ** 256) - 1;
    
    // In emergencies, can be disabled and only the excape functions will work
    bool public enabled = true;
    
    // Admin doesn't change
    // Escaped funds go to admin
    address payable constant admin = 0xBb4068bac37ef5975210fA0cf03C0984f2D1542c;
    
    // User can call authorized methods and can be changed by the user or the admin
    address payable user = 0xA916B82Ff122591cC88AaC0D64cE30A8e3e16081;
    
    // Gas token (CHI) doesn't change
    IFreeUpTo constant chi = IFreeUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
    
    // Burn CHI gas tokens, if possible
    modifier discount {
        uint256 gasStart = gasleft();
        _;
        uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
        chi.freeUpTo((gasSpent + 14154) / 41947);
    }
    
    // Allow the user or the admin to call the function
    modifier auth {
        require(msg.sender == admin || msg.sender == user, "auth");
        _;
    }
    
    // Require the contract is enabled
    modifier notDisabled {
        require(enabled, "disabled");
        _;
    }
    
    constructor() {
        emit Spawned(address(this));
        emit UserChanged(user);
    }
    
    // Set an ERC-20 approval for _spender to spend _amount of _token.
    // If _amount is 0, an "unlimited" approval will be set.
    // To remove an allowance, use revokeTokenApproval
    function setTokenApproval(
        address _token,
        address _spender,
        uint256 _amount
    ) public discount auth notDisabled {
        if (_amount == 0) {
            _amount = MAX_ALLOWANCE;
        }
        IERC20 token = IERC20(_token);
        token.approve(_spender, _amount);
    }
    
    // Remove allowance for _spender to spend _token from this
    function revokeTokenApproval(address _token, address _spender) public discount auth notDisabled {
        IERC20 token = IERC20(_token);
        token.approve(_spender, 0);
    }
    
    // Change the user to a new address
    function setUser(address payable _user) public auth notDisabled {
        emit UserChanged(_user);
        user = _user;
    }

    // Send the full contracts balance of any ERC-20 token back to the admin    
    function escapeToken(address _token) public auth {
        IERC20 token = IERC20(_token);
        token.transfer(admin, token.balanceOf(address(this)));
    }
    
    // Send the admin all ETH in the contract
    function escapeEther() public auth {
        admin.transfer(address(this).balance);
    }
    
    // Disable further proxy transactions (cannot be re-enabled)
    // Funds can still be escaped once disabled
    function disable() public auth notDisabled {
        enabled = false;
    }
    
    // Deploy a contract (discount costs with CHI)
    function deploy(bytes memory _code) public discount auth notDisabled returns(address _contract) {
        assembly {
            _contract := create(0, add(_code, 32), mload(_code))
        }
    }
    
    // Execute a transaction from the gas wallet
    // _target: the target address to call
    // _value: the wei value to include with the transaction
    // _data: calldata to include with the transaction
    function execute(
        address _target,
        uint256 _value,
        bytes memory _data
    ) payable public discount auth notDisabled returns (bytes memory){
        require(address(this).balance >= _value, "bad_value");
        (bool ok, bytes memory ret) = _target.call{value: _value}(_data);
        require(ok, "tx_revert");
        return ret;
    }
    
    // Allow the contract to receive ether if it is not disabled
    receive() external payable notDisabled {}
    
    // Fallback does not allow missing functions
    fallback() external payable {
        revert("no_calldata");
    }
}