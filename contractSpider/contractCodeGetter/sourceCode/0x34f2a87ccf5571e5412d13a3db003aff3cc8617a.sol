/**
 *Submitted for verification at Etherscan.io on 2020-07-30
*/

// SPDX-License-Identifier: MIT

// Created by Henry Harder (c) 2020
// A simple contract wallet that burns CHI to save on transactions.
// Use at your peril.

pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

abstract contract IFreeUpTo {
    function freeUpTo(uint256 value) external virtual returns (uint256 freed);
}

abstract contract IERC20 {
    function approve(address _spender, uint256 _value) public virtual returns (bool success);
    function balanceOf(address _owner) public virtual view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public virtual returns (bool success);
}

contract FixinCHI {
    modifier discount {
        uint256 gasStart = gasleft();
        _;
        uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
        IFreeUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c).freeUpTo((gasSpent + 14154) / 41947);
    }
}

contract GasWallet is FixinCHI {
    // Revert reasons:
    // 0 - caller not admin
    // 1 - caller not user or admin
    // 2 - mutex set
    // 3 - contract disabled
    // 4 - balance too low
    // 5 - multi-call argument length mis-match
    // 6 - hit fallback function

    event Created(address wallet, address admin);
    
    bool public enabled = false;
    uint256 public constant MAX_ALLOWANCE = (2 ** 256) - 1;
    
    bool private _isMutexSet = false;
    address payable private _admin;
    mapping (address => bool) private _users;
    
    modifier onlyAdmin {
        require(msg.sender == _admin, "0");
        _;
    }
    
    modifier userOrAdmin {
        require(msg.sender == _admin || _users[msg.sender], "1");
        _;
    }
    
    modifier mutex {
        require(!_isMutexSet, "2");
        _isMutexSet = true;
        _;
        _isMutexSet = false;
    }
    
    modifier notDisabled {
        require(enabled, "3");
        _;
    }
    
    constructor(address payable admin) {
        enabled = true;
        _admin = admin;
        emit Created(address(this), _admin);
    }
    
    function isUser(address who) public view returns (bool) {
        return _users[who];
    }
    
    function setApproval(address token, address spender, uint256 allowance) public discount userOrAdmin notDisabled {
        if (allowance == 0) {
            allowance = MAX_ALLOWANCE;
        }
        
        IERC20 _token = IERC20(token);
        _token.approve(spender, allowance);
    }
    
    function revokeApproval(address token, address spender) public discount userOrAdmin notDisabled {
        IERC20 _token = IERC20(token);
        _token.approve(spender, 0);
    }
    
    function sendTokens(address token, address to, uint256 amount) public discount userOrAdmin notDisabled {
        IERC20 _token = IERC20(token);
        _token.transfer(to, amount);
    }
    
    function sendEther(address payable to, uint256 amount) public discount userOrAdmin notDisabled {
        require(address(this).balance >= amount, "4");
        to.transfer(amount);
    }
    
    function addUser(address payable user) public onlyAdmin notDisabled {
        _users[user] = true;
    }
    
    function removeUser(address user) public onlyAdmin notDisabled {
        _users[user] = false;
    }
    
    
    function disable() public onlyAdmin notDisabled {
        enabled = false;
    }
    
    function escapeEther() public onlyAdmin {
        _admin.transfer(address(this).balance);
    }
    
    function escapeToken(address token) public onlyAdmin {
        IERC20 _token = IERC20(token);
        _token.transfer(_admin, _token.balanceOf(address(this)));
    }
    
    function deploy(
        bytes memory code
    ) public discount mutex userOrAdmin notDisabled returns(address newContract) {
        assembly {
            newContract := create(0, add(code, 32), mload(code))
        }
    }
    
    function execute(
        address target,
        uint256 value,
        bytes calldata data
    ) public payable discount mutex userOrAdmin notDisabled returns (bytes memory result) {
        require(address(this).balance >= value, "4");
        
        bool ok;
        (ok, result) = target.call{value: value}(data);
        require(ok, "TX_REVERT");
    }
    
    function batchExecute(
        address[] calldata targets,
        uint256[] calldata values,
        bytes[] calldata datas
    ) public payable discount userOrAdmin notDisabled returns (bytes[] memory results) {
        require((targets.length == values.length) && (values.length == datas.length), "5");
        for (uint i = 0; i < targets.length; i++) {
            results[i] = execute(targets[i], values[i], datas[i]);
        }
    }
    
    receive() external payable notDisabled {}
    
    fallback() external payable {
        revert("6");
    }
}