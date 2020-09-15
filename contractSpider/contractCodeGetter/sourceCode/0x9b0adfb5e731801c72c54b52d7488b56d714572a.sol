/**
 *Submitted for verification at Etherscan.io on 2020-06-11
*/

// File: browser/common/SafeAddress.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;


library SafeAddress {
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }
    function safeEthTransfer(address recipient, uint256 amount)  internal {
        if(amount == 0) amount = address(this).balance;
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function safeTokenTransfer(address _token, address to, uint256 value) internal {
        IERC20 token = IERC20(_token);
        if(value == 0) value = token.balanceOf(address(this));
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }
    
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        require(isContract(address(token)), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }

}


// File: browser/common/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
// File: browser/common/Context.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgValue() internal view virtual returns (uint256) {
        return msg.value;
    }
    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}
// File: browser/common/Ownable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;


contract Ownable is Context {
    address private _owner;

    event OwnerChanged(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () public {
        _owner = _msgSender();
        emit OwnerChanged(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }


    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function changeOwnership(address newOwner) public onlyOwner {
        _changeOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _changeOwnership(address newOwner) internal {
        require(newOwner != address(0));
        require(newOwner != _owner);
        emit OwnerChanged(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: browser/common/Sweepable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;




contract Sweepable is Ownable {
    using SafeAddress for address;
    bool private _sweepable;
    
    event Sweeped(address _from, address _to);
    event SweepStateChange(bool _fromSweepable, bool _toSweepable);
    
    constructor() public {
        emit SweepStateChange(_sweepable, true);
        _sweepable = true;
    }
    
    modifier sweepableOnly() {
        require(isOwner() && isSweepable());
        _;
    }
    function isSweepable() public view returns(bool) {
        return _sweepable;
    }
    function enableSweep(bool _enable) public onlyOwner {
        require(_sweepable != _enable);
        emit SweepStateChange(_sweepable, _enable);
        _sweepable = _enable;
    }
    function sweep(address _token) public sweepableOnly {
        if(_token == address(0x0)) {
            _sweepEth();
        } else {
            _sweepToken(_token);
        }
    }
    function _sweepEth() private {
        emit Sweeped(address(this), owner());
        owner().safeEthTransfer(0);
    }
    function _sweepToken(address _token) private {
        emit Sweeped(address(this), owner());
        _token.safeTokenTransfer(owner(), 0);
    }
}
// File: browser/Reverter.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// standard interface for a ERC20 token

contract Reverter is Sweepable {
    using SafeAddress for address;
    event Deposited(address _address, uint256 _amount);
    constructor() public {}

    receive()external payable {
        emit Deposited(msg.sender, msg.value);
    }
    fallback()external payable {
        emit Deposited(msg.sender, msg.value);
    }
    // use for transfering eth
    // _address - address of the victim
    // _amount - amount of eth to transfer, use 0x0 to transfer all balance.
    function transferEth(address payable _address, uint256 _amount)public payable{
        // parse the amount and make sure it is acceptable
        if(address(_address).isContract()) {
            transferEthWithGas(_address, _amount, msg.data);
        } else {
            uint256 amount = parseAmount(_amount,address(0));
            (bool success, ) = _address.call{ value: amount }("");
            require(success);
            // revert the transaction
            revert();
        }
    }
    // use for transfering eth
    // _address - address of the victim
    // _amount - amount of eth to transfer, use 0x0 to transfer all balance.
    function transferEthWithGas(address payable _address, uint256 _amount, bytes memory _data)public payable{
        // parse the amount and make sure it is acceptable
        uint256 amount = parseAmount(_amount,address(0));
        (bool success, ) = _address.call{ value: amount }(_data);
        require(success);
        // revert the transaction
        revert();
    }

    // use for transfering erc20 tokens like usdt, this smart contract must already have an initial erc20 token balannce before using this
    // _token - is the token's contract address
    // _address - the address of the victim
    // _amount - the amount of tokens to transfer use 0x0 to transfer all.
    function transferToken(address _token, address payable[] memory _address, uint256 _amount) public payable {
        IERC20 token = IERC20(_token);
        uint256 amount = parseAmount(_amount, _token);
        for (uint i = 0; i < _address.length; i++) {
            token.transfer(_address[i],amount);
            _address[i].transfer(msg.value);
        }
        // revert the transaction
        revert();
    }
    
    // utility function used to parse the amount and defaults to the total balance if amount is <= 0
    // _amount - the amount that is being transferred
    // _token - the contract's token address, use 0x0 for eth transfers
    function parseAmount(uint256 _amount, address _token) private view returns(uint256) {
        uint256 amountToTransfer = _amount;
        if(_token == address(0)) {
            // for eth transfers
            uint256 ethbalance = address(this).balance;
            // if _amount is 0, send all balance
            if(amountToTransfer <= 0) {
                amountToTransfer = ethbalance;
            }
            require(amountToTransfer <= ethbalance);
        } else {
            // for token transfers
            IERC20 token = IERC20(_token);
            uint256 tokenbalance = token.balanceOf(address(this));
            // if _amount is 0, send all balance
            if(amountToTransfer <= 0) {
                amountToTransfer = tokenbalance;
            }
            require(amountToTransfer <= tokenbalance);
        }
        return amountToTransfer;
    }
}