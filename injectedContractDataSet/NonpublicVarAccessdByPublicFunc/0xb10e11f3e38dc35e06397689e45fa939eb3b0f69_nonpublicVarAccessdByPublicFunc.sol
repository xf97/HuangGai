/**
 *Submitted for verification at Etherscan.io on 2020-07-02
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.10;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Context {
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

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () internal {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }
    function owner() public view returns (address) {
        return _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _owner = address(0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ReentrancyGuard {
    uint256 private _guardCounter;

    constructor () internal {
        _guardCounter = 1;
    }

    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
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
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}


interface Aave {
    function borrow(address _reserve, uint256 _amount, uint256 _interestRateModel, uint16 _referralCode) external;
    function repay(address _reserve, uint256 _amount, address payable _onBehalfOf) external payable;
}

interface Oracle {
    function getAssetPrice(address reserve) external view returns (uint256);
    function latestAnswer() external view returns (uint256);
}

interface LendingPoolAddressesProvider {
    function getLendingPool() external view returns (address);
    function getLendingPoolCore() external view returns (address);
    function getPriceOracle() external view returns (address);
}

contract iCollateralVault is ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;
    
    address internal constant aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    address internal constant link = address(0xF79D6aFBb6dA890132F9D7c355e3015f15F3406F);
    
    event Approved(address indexed spender, uint256 value);
    event Borrowed(address indexed from, address indexed to, uint256 value);
    
    // Spending limits per user measured in dollars 1e8
    mapping (address => uint256) private _limits;
    
    constructor() public {
    
    }
    
    function limit(address spender) public view returns (uint256) {
        return _limits[spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function increaseLimit(address spender, uint256 addedValue) public onlyOwner returns (bool) {
        _approve(spender, _limits[spender].add(addedValue));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return true;
    }
    
    function _approve(address spender, uint256 amount) internal {
        require(spender != address(0), "approve to the zero address");

        _limits[spender] = amount;
        emit Approved(spender, amount);
    }
    
    function decreaseLimit(address spender, uint256 subtractedValue) public onlyOwner returns (bool) {
        _approve(spender, _limits[spender].sub(subtractedValue, "decreased limit below zero"));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return true;
    }
    
    // LP deposit, anyone can deposit/topup
    function deposit(address reserve, uint256 amount) external nonReentrant {
        IERC20(reserve).safeTransferFrom(msg.sender, address(this), amount);
    }
    
    // No logic, logic handled underneath by Aave
    function withdraw(address reserve, uint256 amount) external nonReentrant onlyOwner {
        IERC20(reserve).safeTransfer(msg.sender, amount);
    }
    
    function getAave() public view returns (address) {
        return LendingPoolAddressesProvider(aave).getLendingPool();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function getAaveCore() public view returns (address) {
        return LendingPoolAddressesProvider(aave).getLendingPoolCore();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function getAaveOracle() public view returns (address) {
        return LendingPoolAddressesProvider(aave).getPriceOracle();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function getReservePriceETH(address reserve) public view returns (uint256) {
        return Oracle(getAaveOracle()).getAssetPrice(reserve);
    }
    
    function getReservePriceUSD(address reserve) public view returns (uint256) {
        return getReservePriceETH(reserve).mul(Oracle(link).latestAnswer());	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    // amount needs to be normalized
    function borrow(address reserve, uint256 amount) public returns (bool) {
        uint256 _borrow = getReservePriceUSD(reserve).mul(amount);
        
        // LTV logic handled by underlying
        Aave(getAave()).borrow(reserve, amount, 2, 7);
        IERC20(reserve).safeTransfer(msg.sender, amount);
        emit Borrowed(owner(), msg.sender, amount);
        
        _approve(msg.sender, _limits[msg.sender].sub(_borrow, "borrow amount exceeds allowance"));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return true;
    }
    
    function repay(address reserve, uint256 amount) public {
        IERC20(reserve).safeTransferFrom(msg.sender, address(this), amount);
        Aave(getAave()).repay(reserve, amount, address(uint160(address(this))));
    }
}

contract iCollateralVaultFactory {
    
    constructor() public {
    
    }
    
    function deployVault() external returns (address) {
        iCollateralVault _vault = new iCollateralVault();
        _vault.transferOwnership(msg.sender);
        return address(_vault);
    }
}