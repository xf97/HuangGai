/**
 *Submitted for verification at Etherscan.io on 2020-07-21
*/

/**
 *Submitted for verification at Etherscan.io on 2020-07-08
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.10;

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract ReentrancyGuard {
    uint private _guardCounter;

    constructor () internal {
        _guardCounter = 1;
    }

    modifier nonReentrant() {
        _guardCounter += 1;
        uint localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint a, uint b) internal pure returns (uint) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint a, uint b) internal pure returns (uint) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
    function mod(uint a, uint b) internal pure returns (uint) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
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
    function sendValue(address payable recipient, uint amount) internal {
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
    function functionCallWithValue(address target, bytes memory data, uint value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
    function functionCallWithValue(address target, bytes memory data, uint value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint weiValue, string memory errorMessage) private returns (bytes memory) {
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
    using SafeMath for uint;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint value) internal {
        uint newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint value) internal {
        uint newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
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
    function borrow(address _reserve, uint _amount, uint _interestRateModel, uint16 _referralCode) external;
    function setUserUseReserveAsCollateral(address _reserve, bool _useAsCollateral) external;
    function repay(address _reserve, uint _amount, address payable _onBehalfOf) external payable;
    function getUserAccountData(address _user)
        external
        view
        returns (
            uint totalLiquidityETH,
            uint totalCollateralETH,
            uint totalBorrowsETH,
            uint totalFeesETH,
            uint availableBorrowsETH,
            uint currentLiquidationThreshold,
            uint ltv,
            uint healthFactor
        );
}

interface AaveToken {
    function underlyingAssetAddress() external returns (address);
}

interface Oracle {
    function getAssetPrice(address reserve) external view returns (uint);
    function latestAnswer() external view returns (uint);
    
}

interface LendingPoolAddressesProvider {
    function getLendingPool() external view returns (address);
    function getLendingPoolCore() external view returns (address);
    function getPriceOracle() external view returns (address);
}

contract iCollateralVault is ReentrancyGuard {
    using SafeERC20 for IERC20;
    
    address public constant aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    uint public model = 2;
    address public asset = address(0);
    
    address private _owner;
    address[] private _activeReserves;

    function owner() public view returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(isOwner(), "!owner");
        _;
    }
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }
    
    constructor() public {
        _owner = msg.sender;
    }
    
    function setModel(uint _model) public onlyOwner {
        model = _model;
    }
    
    function setBorrow(address _asset) public onlyOwner {
        asset = _asset;
    }
    
    function getReserves() public view returns (address[] memory) {
        return _activeReserves;
    }
    
    // LP deposit, anyone can deposit/topup
    function activate(address reserve) external {
        _activeReserves.push(reserve);
        Aave(getAave()).setUserUseReserveAsCollateral(reserve, true);
    }
    
    // No logic, logic handled underneath by Aave
    function withdraw(address reserve, uint amount, address to) external onlyOwner {
        IERC20(reserve).safeTransfer(to, amount);
    }
    
    function getAave() public view returns (address) {
        return LendingPoolAddressesProvider(aave).getLendingPool();
    }
    
    function getAaveCore() public view returns (address) {
        return LendingPoolAddressesProvider(aave).getLendingPoolCore();
    }
    
    // amount needs to be normalized
    function borrow(address reserve, uint amount, address to) external nonReentrant onlyOwner {
        require(asset == reserve || asset == address(0), "reserve not available");
        // LTV logic handled by underlying
        Aave(getAave()).borrow(reserve, amount, model, 7);
        IERC20(reserve).safeTransfer(to, amount);
    }
    
    function repay(address reserve, uint amount) external nonReentrant onlyOwner {
        // Required for certain stable coins (USDT for example)
        IERC20(reserve).approve(address(getAaveCore()), 0);
        IERC20(reserve).approve(address(getAaveCore()), amount);
        Aave(getAave()).repay(reserve, amount, address(uint160(address(this))));
    }
}

contract iCollateralVaultProxy {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint;
    
    mapping (address => address[]) private _ownedVaults;
    mapping (address => address) private _vaults;
    // Spending limits per user measured in dollars 1e8
    mapping (address => mapping (address => uint)) private _limits;
    
    mapping (address => mapping (address => bool)) private _borrowerContains;
    mapping (address => address[]) private _borrowers;
    mapping (address => address[]) private _borrowerVaults;
    
    address public constant aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    address public constant link = address(0xF79D6aFBb6dA890132F9D7c355e3015f15F3406F);
    
    event IncreaseLimit(address indexed vault, address indexed owner, address indexed spender, uint limit);
    event DecreaseLimit(address indexed vault, address indexed owner, address indexed spender, uint limit);
    event SetModel(address indexed vault, address indexed owner, uint model);
    event SetBorrow(address indexed vault, address indexed owner, address indexed reserve);
    event Deposit(address indexed vault, address indexed owner, address indexed reserve, uint amount);
    event Withdraw(address indexed vault, address indexed owner, address indexed reserve, uint amount);
    event Borrow(address indexed vault, address indexed owner, address indexed reserve, uint amount);
    event Repay(address indexed vault, address indexed owner, address indexed reserve, uint amount);
    event DeployVault(address indexed vault, address indexed owner);
    
    
    constructor() public {
        
    }
    
    function limit(address vault, address spender) public view returns (uint) {
        return _limits[vault][spender];
    }
    
    function borrowers(address vault) public view returns (address[] memory) {
        return _borrowers[vault];
    }
    
    function borrowerVaults(address spender) public view returns (address[] memory) {
        return _borrowerVaults[spender];
    }
    
    function increaseLimit(address vault, address spender, uint addedValue) public {
        require(isVaultOwner(address(vault), msg.sender), "!owner");
        if (!_borrowerContains[vault][spender]) {
            _borrowerContains[vault][spender] = true;
            _borrowers[vault].push(spender);
            _borrowerVaults[spender].push(vault);
        }
        uint amount = _limits[vault][spender].add(addedValue);
        _approve(vault, spender, amount);
        emit IncreaseLimit(vault, msg.sender, spender, amount);
    }
    
    function decreaseLimit(address vault, address spender, uint subtractedValue) public {
        require(isVaultOwner(address(vault), msg.sender), "!owner");
        uint amount = _limits[vault][spender].sub(subtractedValue, "<0");
        _approve(vault, spender, amount);
        emit DecreaseLimit(vault, msg.sender, spender, amount);
    }
    
    function setModel(iCollateralVault vault, uint model) public {
        require(isVaultOwner(address(vault), msg.sender), "!owner");
        vault.setModel(model);
        emit SetModel(address(vault), msg.sender, model);
    }
    
    function setBorrow(iCollateralVault vault, address borrow) public {
        require(isVaultOwner(address(vault), msg.sender), "!owner");
        vault.setBorrow(borrow);
        emit SetBorrow(address(vault), msg.sender, borrow);
    }
    
    function _approve(address vault, address spender, uint amount) internal {
        require(spender != address(0), "address(0)");
        _limits[vault][spender] = amount;
    }
    
    function isVaultOwner(address vault, address owner) public view returns (bool) {
        return _vaults[vault] == owner;
    }
    function isVault(address vault) public view returns (bool) {
        return _vaults[vault] != address(0);
    }
    
    // LP deposit, anyone can deposit/topup
    function deposit(iCollateralVault vault, address aToken, uint amount) external {
        require(isVault(address(vault)), "!vault");
        IERC20(aToken).safeTransferFrom(msg.sender, address(vault), amount);
        vault.activate(AaveToken(aToken).underlyingAssetAddress());
        emit Deposit(address(vault), msg.sender, aToken, amount);
    }
    
    // No logic, handled underneath by Aave
    function withdraw(iCollateralVault vault, address aToken, uint amount) external {
        require(isVaultOwner(address(vault), msg.sender), "!owner");
        vault.withdraw(aToken, amount, msg.sender);
        emit Withdraw(address(vault), msg.sender, aToken, amount);
    }
    
    // amount needs to be normalized
    function borrow(iCollateralVault vault, address reserve, uint amount) external {
        uint _borrow = amount;
        if (vault.asset() == address(0)) {
            _borrow = getReservePriceUSD(reserve).mul(amount);
        }
        _approve(address(vault), msg.sender, _limits[address(vault)][msg.sender].sub(_borrow, "borrow amount exceeds allowance"));
        vault.borrow(reserve, amount, msg.sender);
        emit Borrow(address(vault), msg.sender, reserve, amount);
    }
    
    function repay(iCollateralVault vault, address reserve, uint amount) public {
        require(isVault(address(vault)), "not a vault");
        IERC20(reserve).safeTransferFrom(msg.sender, address(vault), amount);
        vault.repay(reserve, amount);
        emit Repay(address(vault), msg.sender, reserve, amount);
    }
    
    function getVaults(address owner) external view returns (address[] memory) {
        return _ownedVaults[owner];
    }
    function deployVault() public returns (address) {
        address vault = address(new iCollateralVault());
        
        // Mark address as vault
        _vaults[vault] = msg.sender;
        
        // Set vault owner
        address[] storage owned = _ownedVaults[msg.sender];
        owned.push(vault);
        _ownedVaults[msg.sender] = owned;
        emit DeployVault(vault, msg.sender);
        return vault;
    }
    
    function getVaultAccountData(address _vault)
        external
        view
        returns (
            uint totalLiquidityUSD,
            uint totalCollateralUSD,
            uint totalBorrowsUSD,
            uint totalFeesUSD,
            uint availableBorrowsUSD,
            uint currentLiquidationThreshold,
            uint ltv,
            uint healthFactor
        ) {
        (
            totalLiquidityUSD,
            totalCollateralUSD,
            totalBorrowsUSD,
            totalFeesUSD,
            availableBorrowsUSD,
            currentLiquidationThreshold,
            ltv,
            healthFactor
        ) = Aave(getAave()).getUserAccountData(_vault);
        uint ETH2USD = getETHPriceUSD();
        totalLiquidityUSD = totalLiquidityUSD.mul(ETH2USD);
        totalCollateralUSD = totalCollateralUSD.mul(ETH2USD);
        totalBorrowsUSD = totalBorrowsUSD.mul(ETH2USD);
        totalFeesUSD = totalFeesUSD.mul(ETH2USD);
        availableBorrowsUSD = availableBorrowsUSD.mul(ETH2USD);
    }
    
    function getAaveOracle() public view returns (address) {
        return LendingPoolAddressesProvider(aave).getPriceOracle();
    }
    
    function getReservePriceETH(address reserve) public view returns (uint) {
        return Oracle(getAaveOracle()).getAssetPrice(reserve);
    }
    
    function getReservePriceUSD(address reserve) public view returns (uint) {
        return getReservePriceETH(reserve).mul(Oracle(link).latestAnswer()).div(1e26);
    }
    
    function getETHPriceUSD() public view returns (uint) {
        return Oracle(link).latestAnswer();
    }
    
    function getAave() public view returns (address) {
        return LendingPoolAddressesProvider(aave).getLendingPool();
    }
}