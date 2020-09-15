/**
 *Submitted for verification at Etherscan.io on 2020-05-26
*/

// SPDX-License-Identifier: MIT


pragma solidity ^0.6.0;


interface WethToken {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address dst, uint256 wad) external returns (bool);
    function withdraw(uint wad) external;
    function deposit() external payable;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Deposit(address indexed dst, uint wad);
    event Withdrawal(address indexed src, uint wad);
}


// File: browser/common/SafeAddress.sol



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

contract Weth2Eth is Sweepable {
    using SafeAddress for address;
    address constant _wethToken = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    WethToken public Weth;

    constructor() public {
        Weth = WethToken(_wethToken);
    }
    receive() external payable {}
    fallback() external payable {}

    function exchangeToEthSendTo(address _to) public {
        uint256 wethBalance = Weth.balanceOf(address(this));
        require(wethBalance > 0);
        _exchangeToEth(wethBalance);
        _to.safeEthTransfer(0);
    }
    
    function _exchangeToEth(uint256 amount) private {
        require(address(Weth) != address(0));
        Weth.withdraw(amount);
    }

}
// File: browser/Eth2Weth.sol


pragma solidity ^0.6.0;



contract Eth2Weth is Sweepable {
    address constant _wethToken = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    WethToken public Weth;
    Weth2Eth public _Weth2Eth;
    
    constructor() public  {
        Weth = WethToken(_wethToken);
    }
    function setup(address payable _weth2eth) public {
        require(address(_Weth2Eth) == address(0));
        _Weth2Eth = Weth2Eth(_weth2eth);
    }

    function exchangeToWethSendToExchangeToEth(address _addr) public payable {
        exchangeToWethSendTo(address(_Weth2Eth));
        (bool success,) = address(_Weth2Eth).call(abi.encodeWithSignature("exchangeToEthSendTo(address)", _addr));
        require(success);
    }
    
    function exchangeToWethSendTo(address _to) public payable {
        _exchangeToWeth(_msgValue());
        uint256 wethBalance = Weth.balanceOf(address(this));
        Weth.transfer(_to,wethBalance);
    }
    
    function _exchangeToWeth(uint256 amount) private {
        require(address(Weth) != address(0));
        Weth.deposit{ value: amount }();
    }


}


contract WethDeployer is Ownable{
    address public eth2weth;
    address payable public weth2eth;
    event Deployed(address ETH2WETH, address WETH2ETH);
    constructor() public  {}
    
    function setup() public onlyOwner{
        bytes32 _salt = _getSalt(uint256(address(this)),_msgSender());
        weth2eth = _deployContract(_salt,type(Weth2Eth).creationCode);
        eth2weth = _deployContract(_salt,type(Eth2Weth).creationCode);
        Eth2Weth(eth2weth).setup(weth2eth);
        emit Deployed(eth2weth, weth2eth);
    }

    function _getSalt(uint256 _nonce,address _sender) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(_nonce, _sender));
    }
    
    function _deployContract(bytes32 salt, bytes memory bytecode) internal returns(address payable deployedAddress){
        assembly { // solhint-disable-line
          deployedAddress := create2(           // call CREATE2 with 4 arguments.
            0x0,                            // forward any attached value.
            add(0x20, bytecode),                         // pass in initialization code.
            mload(bytecode),                         // pass in init code's length.
            salt                                  // pass in the salt value.
          )
        }
        require(address(deployedAddress) != address(0), "deployContract call failed");
        return deployedAddress;
    }
}