/**
 *Submitted for verification at Etherscan.io on 2020-07-13
*/

/**
 * Copyright 2017-2020, bZeroX, LLC <https://bzx.network/>. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0.
 */

pragma solidity 0.5.17;


contract IERC20 {
    string public name;
    uint8 public decimals;
    string public symbol;
    function totalSupply() public view returns (uint256);
    function balanceOf(address _who) public view returns (uint256);
    function allowance(address _owner, address _spender) public view returns (uint256);
    function approve(address _spender, uint256 _value) public returns (bool);
    function transfer(address _to, uint256 _value) public returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "unauthorized");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract BZRXv1Converter is Ownable {

    event ConvertBZRX(
        address indexed sender,
        uint256 amount
    );

    IERC20 public constant BZRXv1 = IERC20(0x1c74cFF0376FB4031Cd7492cD6dB2D66c3f2c6B9);
    IERC20 public constant BZRX = IERC20(0x56d811088235F11C8920698a204A5010a788f4b3);

    uint256 public totalConverted;
    uint256 public terminationTimestamp;

    function convert(
        uint256 _tokenAmount)
        external
    {
        require((
            _getTimestamp() < terminationTimestamp &&
            msg.sender != address(1)) ||
            msg.sender == owner(), "convert not allowed");

        BZRXv1.transferFrom(
            msg.sender,
            address(1), // burn address, since transfers to address(0) are not allowed by the token
            _tokenAmount
        );

        BZRX.transfer(
            msg.sender,
            _tokenAmount
        );

        // overflow condition cannot be reached since the above will throw for bad amounts
        totalConverted += _tokenAmount;

        emit ConvertBZRX(
            msg.sender,
            _tokenAmount
        );
    }

    // open convert tool to the public
    function initialize()
        external
        onlyOwner
    {
        require(terminationTimestamp == 0, "already initialized");
        terminationTimestamp = _getTimestamp() + 60 * 60 * 24 * 365; // one year from now
    }

    // funds unclaimed after one year can be rescued
    function rescue(
        address _receiver,
        uint256 _amount)
        external
        onlyOwner
    {
        require(_getTimestamp() > terminationTimestamp, "unauthorized");

        BZRX.transfer(
            _receiver,
            _amount
        );
    }

    function _getTimestamp()
        internal
        view
        returns (uint256)
    {
        return block.timestamp;
    }
}