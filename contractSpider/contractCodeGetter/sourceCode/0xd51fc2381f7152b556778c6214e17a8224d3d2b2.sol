/**
 *Submitted for verification at Etherscan.io on 2020-07-12
*/

// File: localhost/shifter/ShifterRegistry.sol

pragma solidity ^0.6.0;


contract AdminAuth {

    using SafeERC20 for ERC20;

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

    /// @notice Destroy the contract
    function kill() public onlyOwner {
        selfdestruct(payable(owner));
    }

    /// @notice  withdraw stuck funds
    function withdrawStuckFunds(address _token, uint _amount) public onlyOwner {
        if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
            payable(owner).transfer(_amount);
        } else {
            ERC20(_token).safeTransfer(owner, _amount);
        }
    }
}


contract ShifterRegistry is AdminAuth {
    mapping (string => address) public contractAddresses;
    bool public finalized;

    function changeContractAddr(string memory _contractName, address _protoAddr) public onlyOwner {
        require(!finalized);
        contractAddresses[_contractName] = _protoAddr;
    }

    function lock() public onlyOwner {
        finalized = true;
    }

    function getAddr(string memory _contractName) public view returns (address contractAddr) {
        contractAddr = contractAddresses[_contractName];

        require(contractAddr != address(0), "No contract address registred");
    }

}

// File: localhost/mcd/Discount.sol

pragma solidity ^0.6.0;


contract Discount {
    address public owner;
    mapping(address => CustomServiceFee) public serviceFees;

    uint256 constant MAX_SERVICE_FEE = 400;

    struct CustomServiceFee {
        bool active;
        uint256 amount;
    }

    constructor() public {
        owner = msg.sender;
    }

    function isCustomFeeSet(address _user) public view returns (bool) {
        return serviceFees[_user].active;
    }

    function getCustomServiceFee(address _user) public view returns (uint256) {
        return serviceFees[_user].amount;
    }

    function setServiceFee(address _user, uint256 _fee) public {
        require(msg.sender == owner, "Only owner");
        require(_fee >= MAX_SERVICE_FEE || _fee == 0);

        serviceFees[_user] = CustomServiceFee({active: true, amount: _fee});
    }

    function disableServiceFee(address _user) public {
        require(msg.sender == owner, "Only owner");

        serviceFees[_user] = CustomServiceFee({active: false, amount: 0});
    }
}

// File: localhost/exchange/SaverExchangeHelper.sol

pragma solidity ^0.6.0;



contract SaverExchangeHelper {

    using SafeERC20 for ERC20;

    address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant DGD_ADDRESS = 0xE0B7927c4aF23765Cb51314A0E0521A9645F0E2A;

    address payable public constant WALLET_ID = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;
    address public constant DISCOUNT_ADDRESS = 0x1b14E8D511c9A4395425314f849bD737BAF8208F;

    address public constant KYBER_WRAPPER = 0x3d1D4D6Bb405b2366434cb7387803c7B662b8d71;
    address public constant UNISWAP_WRAPPER = 0xFF92ADA50cDC8009686867b4a470C8769bEdB22d;
    address public constant OASIS_WRAPPER = 0x9C499376B41A91349Ff93F99462a65962653e104;
    address public constant ERC20_PROXY_0X = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;
    address public constant ZRX_ALLOWLIST_ADDR = 0x019739e288973F92bDD3c1d87178E206E51fd911;


    function getDecimals(address _token) internal view returns (uint256) {
        if (_token == DGD_ADDRESS) return 9;
        if (_token == KYBER_ETH_ADDRESS) return 18;

        return ERC20(_token).decimals();
    }

    function getBalance(address _tokenAddr) internal view returns (uint balance) {
        if (_tokenAddr == KYBER_ETH_ADDRESS) {
            balance = address(this).balance;
        } else {
            balance = ERC20(_tokenAddr).balanceOf(address(this));
        }
    }

    function approve0xProxy(address _tokenAddr, uint _amount) internal {
        if (_tokenAddr != KYBER_ETH_ADDRESS) {
            ERC20(_tokenAddr).safeApprove(address(ERC20_PROXY_0X), _amount);
        }
    }

    function sendLeftover(address _srcAddr, address _destAddr, address payable _to) internal {
        // send back any leftover ether or tokens
        if (address(this).balance > 0) {
            _to.transfer(address(this).balance);
        }

        if (getBalance(_srcAddr) > 0) {
            ERC20(_srcAddr).safeTransfer(_to, getBalance(_srcAddr));
        }

        if (getBalance(_destAddr) > 0) {
            ERC20(_destAddr).safeTransfer(_to, getBalance(_destAddr));
        }
    }

    function sliceUint(bytes memory bs, uint256 start) internal pure returns (uint256) {
        require(bs.length >= start + 32, "slicing out of range");

        uint256 x;
        assembly {
            x := mload(add(bs, add(0x20, start)))
        }

        return x;
    }
}

// File: localhost/utils/ZrxAllowlist.sol

pragma solidity ^0.6.0;


contract ZrxAllowlist is AdminAuth {

    mapping (address => bool) public zrxAllowlist;

    function setAllowlistAddr(address _zrxAddr, bool _state) public onlyOwner {
        zrxAllowlist[_zrxAddr] = _state;
    }

    function isZrxAddr(address _zrxAddr) public view returns (bool) {
        return zrxAllowlist[_zrxAddr];
    }
}

// File: localhost/interfaces/ExchangeInterfaceV2.sol

pragma solidity ^0.6.0;

interface ExchangeInterfaceV2 {
    function sell(address _srcAddr, address _destAddr, uint _srcAmount) external payable returns (uint);

    function buy(address _srcAddr, address _destAddr, uint _destAmount) external payable returns(uint);

    function getSellRate(address _srcAddr, address _destAddr, uint _srcAmount) external view returns (uint);

    function getBuyRate(address _srcAddr, address _destAddr, uint _srcAmount) external view returns (uint);
}

// File: localhost/interfaces/TokenInterface.sol

pragma solidity ^0.6.0;

abstract contract TokenInterface {
    function allowance(address, address) public virtual returns (uint256);

    function balanceOf(address) public virtual returns (uint256);

    function approve(address, uint256) public virtual;

    function transfer(address, uint256) public virtual returns (bool);

    function transferFrom(address, address, uint256) public virtual returns (bool);

    function deposit() public virtual payable;

    function withdraw(uint256) public virtual;
}

// File: localhost/DS/DSMath.sol

pragma solidity ^0.6.0;


contract DSMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x);
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x);
    }

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x / y;
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x <= y ? x : y;
    }

    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x >= y ? x : y;
    }

    function imin(int256 x, int256 y) internal pure returns (int256 z) {
        return x <= y ? x : y;
    }

    function imax(int256 x, int256 y) internal pure returns (int256 z) {
        return x >= y ? x : y;
    }

    uint256 constant WAD = 10**18;
    uint256 constant RAY = 10**27;

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

    // This famous algorithm is called "exponentiation by squaring"
    // and calculates x^n with x as fixed-point and n as regular unsigned.
    //
    // It's O(log n), instead of O(n) for naive repeated multiplication.
    //
    // These facts are why it works:
    //
    //  If n is even, then x^n = (x^2)^(n/2).
    //  If n is odd,  then x^n = x * x^(n-1),
    //   and applying the equation for even x gives
    //    x^n = x * (x^2)^((n-1) / 2).
    //
    //  Also, EVM division is flooring and
    //    floor[(n-1) / 2] = floor[n / 2].
    //
    function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
        z = n % 2 != 0 ? x : RAY;

        for (n /= 2; n != 0; n /= 2) {
            x = rmul(x, x);

            if (n % 2 != 0) {
                z = rmul(z, x);
            }
        }
    }
}

// File: localhost/exchange/SaverExchangeCore.sol

pragma solidity ^0.6.0;






contract SaverExchangeCore is SaverExchangeHelper, DSMath {

    // first is empty to keep the legacy order in place
    enum ExchangeType { _, OASIS, KYBER, UNISWAP, ZEROX }

    enum ActionType { SELL, BUY }

    struct ExchangeData {
        address srcAddr;
        address destAddr;
        uint srcAmount;
        uint destAmount;
        uint minPrice;
        ExchangeType exchangeType;
        address exchangeAddr;
        bytes callData;
        uint256 price0x;
    }

    /// @notice Internal method that preforms a sell on 0x/on-chain
    /// @dev Usefull for other DFS contract to integrate for exchanging
    /// @param exData Exchange data struct
    /// @return (address, uint) Address of the wrapper used and destAmount
    function _sell(ExchangeData memory exData) internal returns (address, uint) {

        address wrapper;
        uint swapedTokens;
        bool success;
        uint tokensLeft = exData.srcAmount;

        // if 0x is selected try first the 0x order
        if (exData.exchangeType == ExchangeType.ZEROX) {
            approve0xProxy(exData.srcAddr, exData.srcAmount);

            (success, swapedTokens, tokensLeft) = takeOrder(exData, address(this).balance, ActionType.SELL);

            require(success, "0x order failed");

            wrapper = exData.exchangeAddr;
        }

        // check if we have already swapped with 0x, or tried swapping but failed
        if (tokensLeft > 0) {
            uint price;

            (wrapper, price)
                = getBestPrice(exData.srcAmount, exData.srcAddr, exData.destAddr, exData.exchangeType, ActionType.SELL);

            require(price > exData.minPrice || exData.price0x > exData.minPrice, "Slippage hit");

            // if 0x has better prices use 0x
            if (exData.price0x >= price && exData.exchangeType != ExchangeType.ZEROX) {
                approve0xProxy(exData.srcAddr, exData.srcAmount);

                (success, swapedTokens, tokensLeft) = takeOrder(exData, address(this).balance, ActionType.SELL);
            }

            // 0x either had worse price or we tried and order fill failed, so call on chain swap
            if (tokensLeft > 0) {
                require(price > exData.minPrice, "On chain slippage hit");

                swapedTokens = saverSwap(exData, wrapper, ActionType.SELL);
            }
        }

        require(getBalance(exData.destAddr) >= wmul(exData.minPrice, exData.srcAmount), "Double check min price");

        return (wrapper, swapedTokens);
    }

    /// @notice Internal method that preforms a buy on 0x/on-chain
    /// @dev Usefull for other DFS contract to integrate for exchanging
    /// @param exData Exchange data struct
    /// @return (address, uint) Address of the wrapper used and srcAmount
    function _buy(ExchangeData memory exData) internal returns (address, uint) {

        address wrapper;
        uint swapedTokens;
        bool success;

        require(exData.destAmount != 0, "Dest amount must be specified");

        // if 0x is selected try first the 0x order
        if (exData.exchangeType == ExchangeType.ZEROX) {
            approve0xProxy(exData.srcAddr, exData.srcAmount);

            (success, swapedTokens,) = takeOrder(exData, address(this).balance, ActionType.BUY);

            require(success, "0x order failed");

            wrapper = exData.exchangeAddr;
        }

        // check if we have already swapped with 0x, or tried swapping but failed
        if (getBalance(exData.destAddr) < exData.destAmount) {
            uint price;

            (wrapper, price)
                = getBestPrice(exData.destAmount, exData.srcAddr, exData.destAddr, exData.exchangeType, ActionType.BUY);

            require(price < exData.minPrice || exData.price0x < exData.minPrice, "Slippage hit");

            // if 0x has better prices use 0x
            if (exData.price0x != 0 && exData.price0x <= price && exData.exchangeType != ExchangeType.ZEROX) {
                approve0xProxy(exData.srcAddr, exData.srcAmount);

                (success, swapedTokens,) = takeOrder(exData, address(this).balance, ActionType.BUY);
            }

            // 0x either had worse price or we tried and order fill failed, so call on chain swap
            if (getBalance(exData.destAddr) < exData.destAmount) {
                require(price < exData.minPrice, "On chain slippage hit");

                swapedTokens = saverSwap(exData, wrapper, ActionType.BUY);
            }
        }

        require(getBalance(exData.destAddr) >= exData.destAmount, "Less then destAmount");

        return (wrapper, getBalance(exData.destAddr));
    }

    /// @notice Takes order from 0x and returns bool indicating if it is successful
    /// @param _exData Exchange data
    /// @param _ethAmount Ether fee needed for 0x order
    function takeOrder(
        ExchangeData memory _exData,
        uint256 _ethAmount,
        ActionType _type
    ) private returns (bool success, uint256, uint256) {

        // write in the exact amount we are selling/buing in an order
        if (_type == ActionType.SELL) {
            writeUint256(_exData.callData, 36, _exData.srcAmount);
        } else {
            writeUint256(_exData.callData, 36, _exData.destAmount);
        }

        if (ZrxAllowlist(ZRX_ALLOWLIST_ADDR).isZrxAddr(_exData.exchangeAddr)) {
            (success, ) = _exData.exchangeAddr.call{value: _ethAmount}(_exData.callData);
        } else {
            success = false;
        }

        uint256 tokensSwaped = 0;
        uint256 tokensLeft = _exData.srcAmount;

        if (success) {
            // check to see if any _src tokens are left over after exchange
            tokensLeft = getBalance(_exData.srcAddr);

            // convert weth -> eth if needed
            if (_exData.destAddr == KYBER_ETH_ADDRESS) {
                TokenInterface(WETH_ADDRESS).withdraw(
                    TokenInterface(WETH_ADDRESS).balanceOf(address(this))
                );
            }

            // get the current balance of the swaped tokens
            tokensSwaped = getBalance(_exData.destAddr);
        }

        return (success, tokensSwaped, tokensLeft);
    }

    /// @notice Returns the best estimated price from 2 exchanges
    /// @param _amount Amount of source tokens you want to exchange
    /// @param _srcToken Address of the source token
    /// @param _destToken Address of the destination token
    /// @param _exchangeType Which exchange will be used
    /// @param _type Type of action SELL|BUY
    /// @return (address, uint) The address of the best exchange and the exchange price
    function getBestPrice(
        uint256 _amount,
        address _srcToken,
        address _destToken,
        ExchangeType _exchangeType,
        ActionType _type
    ) public returns (address, uint256) {

        if (_exchangeType == ExchangeType.OASIS) {
            return (OASIS_WRAPPER, getExpectedRate(OASIS_WRAPPER, _srcToken, _destToken, _amount, _type));
        }

        if (_exchangeType == ExchangeType.KYBER) {
            return (KYBER_WRAPPER, getExpectedRate(KYBER_WRAPPER, _srcToken, _destToken, _amount, _type));
        }

        if (_exchangeType == ExchangeType.UNISWAP) {
            return (UNISWAP_WRAPPER, getExpectedRate(UNISWAP_WRAPPER, _srcToken, _destToken, _amount, _type));
        }

        uint expectedRateKyber = getExpectedRate(KYBER_WRAPPER, _srcToken, _destToken, _amount, _type);
        uint expectedRateUniswap = getExpectedRate(UNISWAP_WRAPPER, _srcToken, _destToken, _amount, _type);
        uint expectedRateOasis = getExpectedRate(OASIS_WRAPPER, _srcToken, _destToken, _amount, _type);

        if (_type == ActionType.SELL) {
            return getBiggestRate(expectedRateKyber, expectedRateUniswap, expectedRateOasis);
        } else {
            return getSmallestRate(expectedRateKyber, expectedRateUniswap, expectedRateOasis);
        }
    }

    /// @notice Return the expected rate from the exchange wrapper
    /// @dev In case of Oasis/Uniswap handles the different precision tokens
    /// @param _wrapper Address of exchange wrapper
    /// @param _srcToken From token
    /// @param _destToken To token
    /// @param _amount Amount to be exchanged
    /// @param _type Type of action SELL|BUY
    function getExpectedRate(
        address _wrapper,
        address _srcToken,
        address _destToken,
        uint256 _amount,
        ActionType _type
    ) public returns (uint256) {
        bool success;
        bytes memory result;

        if (_type == ActionType.SELL) {
            (success, result) = _wrapper.call(abi.encodeWithSignature(
                "getSellRate(address,address,uint256)",
                _srcToken,
                _destToken,
                _amount
            ));

        } else {
            (success, result) = _wrapper.call(abi.encodeWithSignature(
                "getBuyRate(address,address,uint256)",
                _srcToken,
                _destToken,
                _amount
            ));
        }

        if (success) {
            uint rate = sliceUint(result, 0);

            if (_wrapper != KYBER_WRAPPER) {
                rate = rate * (10**(18 - getDecimals(_destToken)));
            }

            return rate;
        }

        return 0;
    }

    /// @notice Calls wraper contract for exchage to preform an on-chain swap
    /// @param exData Exchange data struct
    /// @param _wrapper Address of exchange wrapper
    /// @param _type Type of action SELL|BUY
    /// @return swapedTokens For Sell that the destAmount, for Buy thats the srcAmount
    function saverSwap(ExchangeData memory exData, address _wrapper, ActionType _type) internal returns (uint swapedTokens) {
        uint ethValue = 0;

        if (exData.srcAddr == KYBER_ETH_ADDRESS) {
            ethValue = exData.srcAmount;
        } else {
            ERC20(exData.srcAddr).safeTransfer(_wrapper, ERC20(exData.srcAddr).balanceOf(address(this)));
        }

        if (_type == ActionType.SELL) {
            swapedTokens = ExchangeInterfaceV2(_wrapper).
                    sell{value: ethValue}(exData.srcAddr, exData.destAddr, exData.srcAmount);
        } else {
            swapedTokens = ExchangeInterfaceV2(_wrapper).
                    buy{value: ethValue}(exData.srcAddr, exData.destAddr, exData.destAmount);
        }
    }

    /// @notice Finds the biggest rate between exchanges, needed for sell rate
    /// @param _expectedRateKyber Kyber rate
    /// @param _expectedRateUniswap Uniswap rate
    /// @param _expectedRateOasis Oasis rate
    function getBiggestRate(
        uint _expectedRateKyber,
        uint _expectedRateUniswap,
        uint _expectedRateOasis
    ) internal pure returns (address, uint) {
        if (
            (_expectedRateUniswap >= _expectedRateKyber) && (_expectedRateUniswap >= _expectedRateOasis)
        ) {
            return (UNISWAP_WRAPPER, _expectedRateUniswap);
        }

        if (
            (_expectedRateKyber >= _expectedRateUniswap) && (_expectedRateKyber >= _expectedRateOasis)
        ) {
            return (KYBER_WRAPPER, _expectedRateKyber);
        }

        if (
            (_expectedRateOasis >= _expectedRateKyber) && (_expectedRateOasis >= _expectedRateUniswap)
        ) {
            return (OASIS_WRAPPER, _expectedRateOasis);
        }
    }

    /// @notice Finds the smallest rate between exchanges, needed for buy rate
    /// @param _expectedRateKyber Kyber rate
    /// @param _expectedRateUniswap Uniswap rate
    /// @param _expectedRateOasis Oasis rate
    function getSmallestRate(
        uint _expectedRateKyber,
        uint _expectedRateUniswap,
        uint _expectedRateOasis
    ) internal pure returns (address, uint) {
        if (
            (_expectedRateUniswap <= _expectedRateKyber) && (_expectedRateUniswap <= _expectedRateOasis)
        ) {
            return (UNISWAP_WRAPPER, _expectedRateUniswap);
        }

        if (
            (_expectedRateKyber <= _expectedRateUniswap) && (_expectedRateKyber <= _expectedRateOasis)
        ) {
            return (KYBER_WRAPPER, _expectedRateKyber);
        }

        if (
            (_expectedRateOasis <= _expectedRateKyber) && (_expectedRateOasis <= _expectedRateUniswap)
        ) {
            return (OASIS_WRAPPER, _expectedRateOasis);
        }
    }

    function writeUint256(bytes memory _b, uint256 _index, uint _input) internal pure {
        if (_b.length < _index + 32) {
            revert("Incorrent lengt while writting bytes32");
        }

        bytes32 input = bytes32(_input);

        _index += 32;

        // Read the bytes32 from array memory
        assembly {
            mstore(add(_b, _index), input)
        }
    }

    // solhint-disable-next-line no-empty-blocks
    receive() external virtual payable {}
}

// File: localhost/interfaces/DSProxyInterface.sol

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

// File: localhost/utils/FlashLoanReceiverBase.sol

pragma solidity ^0.6.0;


interface IFlashLoanReceiver {
    function executeOperation(address _reserve, uint256 _amount, uint256 _fee, bytes calldata _params) external;
}

abstract contract ILendingPoolAddressesProvider {

    function getLendingPool() public view virtual returns (address);
    function setLendingPoolImpl(address _pool) public virtual;

    function getLendingPoolCore() public virtual view returns (address payable);
    function setLendingPoolCoreImpl(address _lendingPoolCore) public virtual;

    function getLendingPoolConfigurator() public virtual view returns (address);
    function setLendingPoolConfiguratorImpl(address _configurator) public virtual;

    function getLendingPoolDataProvider() public virtual view returns (address);
    function setLendingPoolDataProviderImpl(address _provider) public virtual;

    function getLendingPoolParametersProvider() public virtual view returns (address);
    function setLendingPoolParametersProviderImpl(address _parametersProvider) public virtual;

    function getTokenDistributor() public virtual view returns (address);
    function setTokenDistributor(address _tokenDistributor) public virtual;


    function getFeeProvider() public virtual view returns (address);
    function setFeeProviderImpl(address _feeProvider) public virtual;

    function getLendingPoolLiquidationManager() public virtual view returns (address);
    function setLendingPoolLiquidationManager(address _manager) public virtual;

    function getLendingPoolManager() public virtual view returns (address);
    function setLendingPoolManager(address _lendingPoolManager) public virtual;

    function getPriceOracle() public virtual view returns (address);
    function setPriceOracle(address _priceOracle) public virtual;

    function getLendingRateOracle() public view virtual returns (address);
    function setLendingRateOracle(address _lendingRateOracle) public virtual;
}

library EthAddressLib {

    function ethAddress() internal pure returns(address) {
        return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    }
}

abstract contract FlashLoanReceiverBase is IFlashLoanReceiver {

    using SafeERC20 for ERC20;
    using SafeMath for uint256;

    ILendingPoolAddressesProvider public addressesProvider;

    constructor(ILendingPoolAddressesProvider _provider) public {
        addressesProvider = _provider;
    }

    receive () external virtual payable {}

    function transferFundsBackToPoolInternal(address _reserve, uint256 _amount) internal {

        address payable core = addressesProvider.getLendingPoolCore();

        transferInternal(core,_reserve, _amount);
    }

    function transferInternal(address payable _destination, address _reserve, uint256  _amount) internal {
        if(_reserve == EthAddressLib.ethAddress()) {
            //solium-disable-next-line
            _destination.call{value: _amount}("");
            return;
        }

        ERC20(_reserve).safeTransfer(_destination, _amount);


    }

    function getBalanceInternal(address _target, address _reserve) internal view returns(uint256) {
        if(_reserve == EthAddressLib.ethAddress()) {

            return _target.balance;
        }

        return ERC20(_reserve).balanceOf(_target);

    }
}

// File: localhost/utils/Address.sol

pragma solidity ^0.6.0;

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

// File: localhost/interfaces/ERC20.sol

pragma solidity ^0.6.0;

interface ERC20 {
    function totalSupply() external view returns (uint256 supply);

    function balanceOf(address _owner) external view returns (uint256 balance);

    function transfer(address _to, uint256 _value) external returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value)
        external
        returns (bool success);

    function approve(address _spender, uint256 _value) external returns (bool success);

    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    function decimals() external view returns (uint256 digits);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

// File: localhost/utils/SafeERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;



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
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

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

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(ERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     */
    function safeApprove(ERC20 token, address spender, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function _callOptionalReturn(ERC20 token, bytes memory data) private {

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: localhost/auth/AdminAuth.sol

pragma solidity ^0.6.0;



// File: localhost/shifter/LoanShifterReceiver.sol

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;






/// @title LoanShifterReceiver Recevies the Aave flash loan and calls actions through users DSProxy
contract LoanShifterReceiver is SaverExchangeCore, FlashLoanReceiverBase, AdminAuth {

    ILendingPoolAddressesProvider public LENDING_POOL_ADDRESS_PROVIDER = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    address public constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    ShifterRegistry public constant shifterRegistry = ShifterRegistry(0xD280c91397C1f8826a82a9432D65e4215EF22e55);

    struct ParamData {
        bytes proxyData1;
        bytes proxyData2;
        address proxy;
        address debtAddr;
        uint8 protocol1;
        uint8 protocol2;
        uint8 swapType;
    }

    constructor() FlashLoanReceiverBase(LENDING_POOL_ADDRESS_PROVIDER) public {}

    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params)
    external override {
        // Format the call data for DSProxy
        (ParamData memory paramData, ExchangeData memory exchangeData)
                                 = packFunctionCall(_amount, _fee, _params);

        address protocolAddr1 = shifterRegistry.getAddr(getNameByProtocol(paramData.protocol1));
        address protocolAddr2 = shifterRegistry.getAddr(getNameByProtocol(paramData.protocol2));

        // Send Flash loan amount to DSProxy
        sendToProxy(payable(paramData.proxy), _reserve, _amount);

        // Execute the Close operation
        DSProxyInterface(paramData.proxy).execute(protocolAddr1, paramData.proxyData1);

        if (paramData.swapType == 1) { // COLL_SWAP
            exchangeData.srcAmount = getBalance(exchangeData.srcAddr);
            (, uint amount) = _sell(exchangeData);

            sendToProxy(payable(paramData.proxy), exchangeData.destAddr, amount);
        } else {
            sendToProxy(payable(paramData.proxy), exchangeData.srcAddr, getBalance(exchangeData.srcAddr));
        }

        // Execute the Open operation
        DSProxyInterface(paramData.proxy).execute(protocolAddr2, paramData.proxyData2);

        if (paramData.swapType == 2) { // DEBT_SWAP
            exchangeData.destAmount = getBalance(exchangeData.destAddr);
            _buy(exchangeData);
        }

        // Repay FL
        transferFundsBackToPoolInternal(_reserve, _amount.add(_fee));

        // if there is some eth left (0x fee), return it to user
        if (address(this).balance > 0) {
            tx.origin.transfer(address(this).balance);
        }
    }

    function packFunctionCall(uint _amount, uint _fee, bytes memory _params)
        internal pure returns (ParamData memory paramData, ExchangeData memory exchangeData) {

        (
            uint[8] memory numData, // collAmount, debtAmount, id1, id2, srcAmount, destAmount, minPrice, price0x
            address[6] memory addrData, // addrLoan1, addrLoan2, debtAddr, srcAddr, destAddr, exchangeAddr
            uint8[4] memory enumData, // fromProtocol, toProtocol, swapType, exchangeType
            bytes memory callData,
            address proxy
        )
        = abi.decode(_params, (uint256[8],address[6],uint8[4],bytes,address));

        bytes memory proxyData1;
        bytes memory proxyData2;
        uint openDebtAmount = (_amount + _fee);

        if (enumData[2] == 2) { // DEBT_SWAP
            openDebtAmount =  numData[4]; // srcAmount
        }

        if (enumData[0] == 0) { // MAKER
            proxyData1 = abi.encodeWithSignature(
            "close(uint256,address,uint256,uint256)",
                                numData[2], addrData[0], _amount, numData[0]);

            proxyData2 = abi.encodeWithSignature(
            "open(uint256,address,uint256)",
                                numData[3], addrData[1], openDebtAmount);
        } else if(enumData[0] == 1) { // COMPOUND
            proxyData1 = abi.encodeWithSignature(
            "close(address,address,uint256,uint256)",
                                addrData[0], addrData[2], numData[0], numData[1]);

            // Figures out the debt token of the second loan
            address debtAddr2 = addrData[4] == address(0) ? addrData[2] : addrData[4];

            proxyData2 = abi.encodeWithSignature(
            "open(address,address,uint256)",
                                addrData[1], debtAddr2, openDebtAmount);
        }


        paramData = ParamData({
            proxyData1: proxyData1,
            proxyData2: proxyData2,
            debtAddr: addrData[2],
            proxy: proxy,
            swapType: enumData[2],
            protocol1: enumData[0],
            protocol2: enumData[1]
        });

        exchangeData = SaverExchangeCore.ExchangeData({
            srcAddr: addrData[3],
            destAddr: addrData[4],
            srcAmount: numData[4],
            destAmount: numData[5],
            minPrice: numData[6],
            exchangeType: ExchangeType(enumData[3]),
            exchangeAddr: addrData[5],
            callData: callData,
            price0x: numData[7]
        });

    }

    function sendToProxy(address payable _proxy, address _reserve, uint _amount) internal {
        if (_reserve != ETH_ADDRESS) {
            ERC20(_reserve).safeTransfer(_proxy, _amount);
        }

        _proxy.transfer(address(this).balance);
    }

    function getNameByProtocol(uint8 _proto) internal pure returns (string memory) {
        if (_proto == 0) {
            return "MCD_SHIFTER";
        } else if (_proto == 1) {
            return "COMP_SHIFTER";
        }
    }

    receive() external override(FlashLoanReceiverBase, SaverExchangeCore) payable {}
}