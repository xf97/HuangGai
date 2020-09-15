/**
 *Submitted for verification at Etherscan.io on 2020-05-03
*/

pragma solidity ^0.5.0; interface ERC20 {
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
} //TODO: currenlty only adjusted to kyber, but should be genric interfaces for more dec. exchanges
interface ExchangeInterface {
    function swapEtherToToken(uint256 _ethAmount, address _tokenAddress, uint256 _maxAmount)
        external
        payable
        returns (uint256, uint256);

    function swapTokenToEther(address _tokenAddress, uint256 _amount, uint256 _maxAmount)
        external
        returns (uint256);

    function swapTokenToToken(address _src, address _dest, uint256 _amount)
        external
        payable
        returns (uint256);

    function getExpectedRate(address src, address dest, uint256 srcQty)
        external
        view
        returns (uint256 expectedRate);
} contract SaverLogger {
    event Repay(
        uint256 indexed cdpId,
        address indexed owner,
        uint256 collateralAmount,
        uint256 daiAmount
    );
    event Boost(
        uint256 indexed cdpId,
        address indexed owner,
        uint256 daiAmount,
        uint256 collateralAmount
    );

    // solhint-disable-next-line func-name-mixedcase
    function LogRepay(uint256 _cdpId, address _owner, uint256 _collateralAmount, uint256 _daiAmount)
        public
    {
        emit Repay(_cdpId, _owner, _collateralAmount, _daiAmount);
    }

    // solhint-disable-next-line func-name-mixedcase
    function LogBoost(uint256 _cdpId, address _owner, uint256 _daiAmount, uint256 _collateralAmount)
        public
    {
        emit Boost(_cdpId, _owner, _daiAmount, _collateralAmount);
    }
} contract Discount {
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
} contract PipInterface {
    function read() public returns (bytes32);
} contract Spotter {
    struct Ilk {
        PipInterface pip;
        uint256 mat;
    }

    mapping (bytes32 => Ilk) public ilks;

    uint256 public par;

} contract Jug {
    struct Ilk {
        uint256 duty;
        uint256  rho;
    }

    mapping (bytes32 => Ilk) public ilks;

    function drip(bytes32) public returns (uint);
} contract Vat {

    struct Urn {
        uint256 ink;   // Locked Collateral  [wad]
        uint256 art;   // Normalised Debt    [wad]
    }

    struct Ilk {
        uint256 Art;   // Total Normalised Debt     [wad]
        uint256 rate;  // Accumulated Rates         [ray]
        uint256 spot;  // Price with Safety Margin  [ray]
        uint256 line;  // Debt Ceiling              [rad]
        uint256 dust;  // Urn Debt Floor            [rad]
    }

    mapping (bytes32 => mapping (address => Urn )) public urns;
    mapping (bytes32 => Ilk)                       public ilks;
    mapping (bytes32 => mapping (address => uint)) public gem;  // [wad]

    function can(address, address) public view returns (uint);
    function dai(address) public view returns (uint);
    function frob(bytes32, address, address, address, int, int) public;
    function hope(address) public;
    function move(address, address, uint) public;
} contract Gem {
    function dec() public returns (uint);
    function gem() public returns (Gem);
    function join(address, uint) public payable;
    function exit(address, uint) public;

    function approve(address, uint) public;
    function transfer(address, uint) public returns (bool);
    function transferFrom(address, address, uint) public returns (bool);
    function deposit() public payable;
    function withdraw(uint) public;
    function allowance(address, address) public returns (uint);
} contract DaiJoin {
    function vat() public returns (Vat);
    function dai() public returns (Gem);
    function join(address, uint) public payable;
    function exit(address, uint) public;
} contract Join {
    bytes32 public ilk;

    function dec() public view returns (uint);
    function gem() public returns (Gem);
    function join(address, uint) public payable;
    function exit(address, uint) public;
} contract TokenInterface {
    function allowance(address, address) public returns (uint256);

    function balanceOf(address) public returns (uint256);

    function approve(address, uint256) public;

    function transfer(address, uint256) public returns (bool);

    function transferFrom(address, address, uint256) public returns (bool);

    function deposit() public payable;

    function withdraw(uint256) public;
} contract SaverExchangeInterface {
    function getBestPrice(
        uint256 _amount,
        address _srcToken,
        address _destToken,
        uint256 _exchangeType
    ) public view returns (address, uint256);
} contract ConstantAddressesExchangeMainnet {
    address public constant MAKER_DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
    address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public constant MKR_ADDRESS = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2;
    address public constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address payable public constant WALLET_ID = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;
    address public constant LOGGER_ADDRESS = 0xeCf88e1ceC2D2894A0295DB3D86Fe7CE4991E6dF;
    address public constant DISCOUNT_ADDRESS = 0x1b14E8D511c9A4395425314f849bD737BAF8208F;

    address public constant GAS_TOKEN_INTERFACE_ADDRESS = 0x0000000000b3F879cb30FE243b4Dfee438691c04;
    address public constant SAVER_EXCHANGE_ADDRESS = 0x862F3dcF1104b8a9468fBb8B843C37C31B41eF09;

    // new MCD contracts
    address public constant MANAGER_ADDRESS = 0x5ef30b9986345249bc32d8928B7ee64DE9435E39;
    address public constant VAT_ADDRESS = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address public constant SPOTTER_ADDRESS = 0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3;
    address public constant PROXY_ACTIONS = 0x82ecD135Dce65Fbc6DbdD0e4237E0AF93FFD5038;

    address public constant JUG_ADDRESS = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
    address public constant DAI_JOIN_ADDRESS = 0x9759A6Ac90977b93B58547b4A71c78317f391A28;
    address public constant ETH_JOIN_ADDRESS = 0x2F0b23f53734252Bda2277357e97e1517d6B042A;
    address public constant MIGRATION_ACTIONS_PROXY = 0xe4B22D484958E582098A98229A24e8A43801b674;

    address public constant SAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
    address public constant DAI_ADDRESS = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    address payable public constant SCD_MCD_MIGRATION = 0xc73e0383F3Aff3215E6f04B0331D58CeCf0Ab849;

    // Our contracts
    address public constant ERC20_PROXY_0X = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;
    address public constant NEW_IDAI_ADDRESS = 0x6c1E2B0f67e00c06c8e2BE7Dc681Ab785163fF4D;
} contract ConstantAddressesExchangeKovan {
    address public constant MAKER_DAI_ADDRESS = 0xC4375B7De8af5a38a93548eb8453a498222C4fF2;
    address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public constant MKR_ADDRESS = 0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD;
    address public constant WETH_ADDRESS = 0xd0A1E359811322d97991E03f863a0C30C2cF029C;
    address payable public constant WALLET_ID = 0x54b44C6B18fc0b4A1010B21d524c338D1f8065F6;
    address public constant LOGGER_ADDRESS = 0x32d0e18f988F952Eb3524aCE762042381a2c39E5;
    address public constant DISCOUNT_ADDRESS = 0x1297c1105FEDf45E0CF6C102934f32C4EB780929;

    address public constant GAS_TOKEN_INTERFACE_ADDRESS = 0x0000000000170CcC93903185bE5A2094C870Df62;
    address public constant SAVER_EXCHANGE_ADDRESS = 0xACA7d11e3f482418C324aAC8e90AaD0431f692A6;

    // new MCD contracts
    address public constant MANAGER_ADDRESS = 0x1476483dD8C35F25e568113C5f70249D3976ba21;
    address public constant VAT_ADDRESS = 0xbA987bDB501d131f766fEe8180Da5d81b34b69d9;
    address public constant SPOTTER_ADDRESS = 0x3a042de6413eDB15F2784f2f97cC68C7E9750b2D;
    address public constant PROXY_ACTIONS = 0xd1D24637b9109B7f61459176EdcfF9Be56283a7B;

    address public constant JUG_ADDRESS = 0xcbB7718c9F39d05aEEDE1c472ca8Bf804b2f1EaD;
    address public constant DAI_JOIN_ADDRESS = 0x5AA71a3ae1C0bd6ac27A1f28e1415fFFB6F15B8c;
    address public constant ETH_JOIN_ADDRESS = 0x775787933e92b709f2a3C70aa87999696e74A9F8;
    address public constant MIGRATION_ACTIONS_PROXY = 0x433870076aBd08865f0e038dcC4Ac6450e313Bd8;

    address public constant SAI_ADDRESS = 0xC4375B7De8af5a38a93548eb8453a498222C4fF2;
    address public constant DAI_ADDRESS = 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa;

    address payable public constant SCD_MCD_MIGRATION = 0x411B2Faa662C8e3E5cF8f01dFdae0aeE482ca7b0;

    // Our contracts
    address public constant ERC20_PROXY_0X = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;
    address public constant NEW_IDAI_ADDRESS = 0x6c1E2B0f67e00c06c8e2BE7Dc681Ab785163fF4D;
} // solhint-disable-next-line no-empty-blocks
contract ConstantAddressesExchange is ConstantAddressesExchangeMainnet {} /// @title Helper methods for integration with SaverExchange
contract ExchangeHelper is ConstantAddressesExchange {

    /// @notice Swaps 2 tokens on the Saver Exchange
    /// @dev ETH is sent with Weth address
    /// @param _data [amount, minPrice, exchangeType, 0xPrice]
    /// @param _src Token address of the source token
    /// @param _dest Token address of the destination token
    /// @param _exchangeAddress Address of 0x exchange that should be called
    /// @param _callData data to call 0x exchange with
    function swap(uint[4] memory _data, address _src, address _dest, address _exchangeAddress, bytes memory _callData) internal returns (uint) {
        address wrapper;
        uint price;
        // [tokensReturned, tokensLeft]
        uint[2] memory tokens;
        bool success;

        // tokensLeft is equal to amount at the beginning
        tokens[1] = _data[0];

        _src = wethToKyberEth(_src);
        _dest = wethToKyberEth(_dest);

        // use this to avoid stack too deep error
        address[3] memory orderAddresses = [_exchangeAddress, _src, _dest];

        // if _data[2] == 4 use 0x if possible
        if (_data[2] == 4) {
            if (orderAddresses[1] != KYBER_ETH_ADDRESS) {
                ERC20(orderAddresses[1]).approve(address(ERC20_PROXY_0X), _data[0]);
            }

            (success, tokens[0], ) = takeOrder(orderAddresses, _callData, address(this).balance, _data[0]);

            // if specifically 4, then require it to be successfull
            require(success && tokens[0] > 0, "0x transaction failed");
        }

        // no 0x
        // if (_data[2] == 5) {
        //     (wrapper, price) = SaverExchangeInterface(SAVER_EXCHANGE_ADDRESS).getBestPrice(tokens[1], orderAddresses[1], orderAddresses[2], _data[2]);

        //     require(price > _data[1], "Slippage hit onchain price");

        //     if (orderAddresses[1] == KYBER_ETH_ADDRESS) {
        //         uint tRet;
        //         (tRet,) = ExchangeInterface(wrapper).swapEtherToToken.value(tokens[1])(tokens[1], orderAddresses[2], uint(-1));
        //         tokens[0] += tRet;
        //     } else {
        //         ERC20(orderAddresses[1]).transfer(wrapper, tokens[1]);

        //         if (orderAddresses[2] == KYBER_ETH_ADDRESS) {
        //             tokens[0] += ExchangeInterface(wrapper).swapTokenToEther(orderAddresses[1], tokens[1], uint(-1));
        //         } else {
        //             tokens[0] += ExchangeInterface(wrapper).swapTokenToToken(orderAddresses[1], orderAddresses[2], tokens[1]);
        //         }
        //     }

        //     return tokens[0];
        // }

        if (tokens[0] == 0) {
            (wrapper, price) = SaverExchangeInterface(SAVER_EXCHANGE_ADDRESS).getBestPrice(_data[0], orderAddresses[1], orderAddresses[2], _data[2]);

            require(price > _data[1] || _data[3] > _data[1], "Slippage hit");

            // handle 0x exchange, if equal price, try 0x to use less gas
            if (_data[3] >= price) {
                if (orderAddresses[1] != KYBER_ETH_ADDRESS) {
                    ERC20(orderAddresses[1]).approve(address(ERC20_PROXY_0X), _data[0]);
                }

                // when selling eth its possible that some eth isn't sold and it is returned back
                (success, tokens[0], tokens[1]) = takeOrder(orderAddresses, _callData, address(this).balance, _data[0]);
            }

            // if there are more tokens left, try to sell them on other exchanges
            if (tokens[1] > 0) {
                // as it stands today, this can happend only when selling ETH
                if (tokens[1] != _data[0]) {
                    (wrapper, price) = SaverExchangeInterface(SAVER_EXCHANGE_ADDRESS).getBestPrice(tokens[1], orderAddresses[1], orderAddresses[2], _data[2]);
                }

                require(price > _data[1], "Slippage hit onchain price");

                if (orderAddresses[1] == KYBER_ETH_ADDRESS) {
                    uint tRet;
                    (tRet,) = ExchangeInterface(wrapper).swapEtherToToken.value(tokens[1])(tokens[1], orderAddresses[2], uint(-1));
                    tokens[0] += tRet;
                } else {
                    ERC20(orderAddresses[1]).transfer(wrapper, tokens[1]);

                    if (orderAddresses[2] == KYBER_ETH_ADDRESS) {
                        tokens[0] += ExchangeInterface(wrapper).swapTokenToEther(orderAddresses[1], tokens[1], uint(-1));
                    } else {
                        tokens[0] += ExchangeInterface(wrapper).swapTokenToToken(orderAddresses[1], orderAddresses[2], tokens[1]);
                    }
                }
            }
        }

        return tokens[0];
    }

    // @notice Takes order from 0x and returns bool indicating if it is successful
    // @param _addresses [exchange, src, dst]
    // @param _data Data to send with call
    // @param _value Value to send with call
    // @param _amount Amount to sell
    function takeOrder(address[3] memory _addresses, bytes memory _data, uint _value, uint _amount) private returns(bool, uint, uint) {
        bool success;

        (success, ) = _addresses[0].call.value(_value)(_data);

        uint tokensLeft = _amount;
        uint tokensReturned = 0;
        if (success){
            // check how many tokens left from _src
            if (_addresses[1] == KYBER_ETH_ADDRESS) {
                tokensLeft = address(this).balance;
            } else {
                tokensLeft = ERC20(_addresses[1]).balanceOf(address(this));
            }

            // check how many tokens are returned
            if (_addresses[2] == KYBER_ETH_ADDRESS) {
                TokenInterface(WETH_ADDRESS).withdraw(TokenInterface(WETH_ADDRESS).balanceOf(address(this)));
                tokensReturned = address(this).balance;
            } else {
                tokensReturned = ERC20(_addresses[2]).balanceOf(address(this));
            }
        }

        return (success, tokensReturned, tokensLeft);
    }

    /// @notice Converts WETH -> Kybers Eth address
    /// @param _src Input address
    function wethToKyberEth(address _src) internal pure returns (address) {
        return _src == WETH_ADDRESS ? KYBER_ETH_ADDRESS : _src;
    }
} contract DSMath {
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
} contract DSAuthority {
    function canCall(address src, address dst, bytes4 sig) public view returns (bool);
} contract DSAuthEvents {
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
} contract DSNote {
    event LogNote(
        bytes4 indexed sig,
        address indexed guy,
        bytes32 indexed foo,
        bytes32 indexed bar,
        uint256 wad,
        bytes fax
    ) anonymous;

    modifier note {
        bytes32 foo;
        bytes32 bar;

        assembly {
            foo := calldataload(4)
            bar := calldataload(36)
        }

        emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);

        _;
    }
} contract DSProxy is DSAuth, DSNote {
    DSProxyCache public cache; // global cache for contracts

    constructor(address _cacheAddr) public {
        require(setCache(_cacheAddr));
    }

    function() external payable {}

    // use the proxy to execute calldata _data on contract _code
    function execute(bytes memory _code, bytes memory _data)
        public
        payable
        returns (address target, bytes32 response)
    {
        target = cache.read(_code);
        if (target == address(0)) {
            // deploy contract & store its address in cache
            target = cache.write(_code);
        }

        response = execute(target, _data);
    }

    function execute(address _target, bytes memory _data)
        public
        payable
        auth
        note
        returns (bytes32 response)
    {
        require(_target != address(0));

        // call contract in current context
        assembly {
            let succeeded := delegatecall(
                sub(gas, 5000),
                _target,
                add(_data, 0x20),
                mload(_data),
                0,
                32
            )
            response := mload(0) // load delegatecall output
            switch iszero(succeeded)
                case 1 {
                    // throw if delegatecall failed
                    revert(0, 0)
                }
        }
    }

    //set new cache
    function setCache(address _cacheAddr) public payable auth note returns (bool) {
        require(_cacheAddr != address(0)); // invalid cache address
        cache = DSProxyCache(_cacheAddr); // overwrite cache
        return true;
    }
}


contract DSProxyCache {
    mapping(bytes32 => address) cache;

    function read(bytes memory _code) public view returns (address) {
        bytes32 hash = keccak256(_code);
        return cache[hash];
    }

    function write(bytes memory _code) public returns (address target) {
        assembly {
            target := create(0, add(_code, 0x20), mload(_code))
            switch iszero(extcodesize(target))
                case 1 {
                    // throw if contract failed to deploy
                    revert(0, 0)
                }
        }
        bytes32 hash = keccak256(_code);
        cache[hash] = target;
    }
} contract Manager {
    function last(address) public returns (uint);
    function cdpCan(address, uint, address) public view returns (uint);
    function ilks(uint) public view returns (bytes32);
    function owns(uint) public view returns (address);
    function urns(uint) public view returns (address);
    function vat() public view returns (address);
    function open(bytes32, address) public returns (uint);
    function give(uint, address) public;
    function cdpAllow(uint, address, uint) public;
    function urnAllow(address, uint) public;
    function frob(uint, int, int) public;
    function flux(uint, address, uint) public;
    function move(uint, address, uint) public;
    function exit(address, uint, address, uint) public;
    function quit(uint, address) public;
    function enter(address, uint) public;
    function shift(uint, uint) public;
} /// @title Helper methods for MCDSaverProxy
contract SaverProxyHelper is DSMath {

    /// @notice Returns a normalized debt _amount based on the current rate
    /// @param _amount Amount of dai to be normalized
    /// @param _rate Current rate of the stability fee
    /// @param _daiVatBalance Balance od Dai in the Vat for that CDP
    function normalizeDrawAmount(uint _amount, uint _rate, uint _daiVatBalance) internal pure returns (int dart) {
        if (_daiVatBalance < mul(_amount, RAY)) {
            dart = toPositiveInt(sub(mul(_amount, RAY), _daiVatBalance) / _rate);
            dart = mul(uint(dart), _rate) < mul(_amount, RAY) ? dart + 1 : dart;
        }
    }

    /// @notice Converts a number to Rad percision
    /// @param _wad The input number in wad percision
    function toRad(uint _wad) internal pure returns (uint) {
        return mul(_wad, 10 ** 27);
    }

    /// @notice Converts a number to 18 decimal percision
    /// @param _joinAddr Join address of the collateral
    /// @param _amount Number to be converted
    function convertTo18(address _joinAddr, uint256 _amount) internal returns (uint256) {
        return mul(_amount, 10 ** (18 - Join(_joinAddr).dec()));
    }

    /// @notice Converts a uint to int and checks if positive
    /// @param _x Number to be converted
    function toPositiveInt(uint _x) internal pure returns (int y) {
        y = int(_x);
        require(y >= 0, "int-overflow");
    }

    /// @notice Gets Dai amount in Vat which can be added to Cdp
    /// @param _vat Address of Vat contract
    /// @param _urn Urn of the Cdp
    /// @param _ilk Ilk of the Cdp
    function normalizePaybackAmount(address _vat, address _urn, bytes32 _ilk) internal view returns (int amount) {
        uint dai = Vat(_vat).dai(_urn);

        (, uint rate,,,) = Vat(_vat).ilks(_ilk);
        (, uint art) = Vat(_vat).urns(_ilk, _urn);

        amount = toPositiveInt(dai / rate);
        amount = uint(amount) <= art ? - amount : - toPositiveInt(art);
    }

    /// @notice Gets the whole debt of the CDP
    /// @param _vat Address of Vat contract
    /// @param _usr Address of the Dai holder
    /// @param _urn Urn of the Cdp
    /// @param _ilk Ilk of the Cdp
    function getAllDebt(address _vat, address _usr, address _urn, bytes32 _ilk) internal view returns (uint daiAmount) {
        (, uint rate,,,) = Vat(_vat).ilks(_ilk);
        (, uint art) = Vat(_vat).urns(_ilk, _urn);
        uint dai = Vat(_vat).dai(_usr);

        uint rad = sub(mul(art, rate), dai);
        daiAmount = rad / RAY;

        daiAmount = mul(daiAmount, RAY) < rad ? daiAmount + 1 : daiAmount;
    }

    /// @notice Gets the token address from the Join contract
    /// @param _joinAddr Address of the Join contract
    function getCollateralAddr(address _joinAddr) internal returns (address) {
        return address(Join(_joinAddr).gem());
    }

    /// @notice Gets CDP info (collateral, debt)
    /// @param _manager Manager contract
    /// @param _cdpId Id of the CDP
    /// @param _ilk Ilk of the CDP
    function getCdpInfo(Manager _manager, uint _cdpId, bytes32 _ilk) public view returns (uint, uint) {
        address vat = _manager.vat();
        address urn = _manager.urns(_cdpId);

        (uint collateral, uint debt) = Vat(vat).urns(_ilk, urn);
        (,uint rate,,,) = Vat(vat).ilks(_ilk);

        return (collateral, rmul(debt, rate));
    }

    /// @notice Address that owns the DSProxy that owns the CDP
    /// @param _manager Manager contract
    /// @param _cdpId Id of the CDP
    function getOwner(Manager _manager, uint _cdpId) public view returns (address) {
        DSProxy proxy = DSProxy(uint160(_manager.owns(_cdpId)));

        return proxy.owner();
    }
} /// @title Implements Boost and Repay for MCD CDPs
contract MCDSaverProxy is SaverProxyHelper, ExchangeHelper {

    uint public constant SERVICE_FEE = 400; // 0.25% Fee
    bytes32 public constant ETH_ILK = 0x4554482d41000000000000000000000000000000000000000000000000000000;
    bytes32 public constant USDC_ILK = 0x555344432d410000000000000000000000000000000000000000000000000000;

    Manager public constant manager = Manager(MANAGER_ADDRESS);
    Vat public constant vat = Vat(VAT_ADDRESS);
    DaiJoin public constant daiJoin = DaiJoin(DAI_JOIN_ADDRESS);
    Spotter public constant spotter = Spotter(SPOTTER_ADDRESS);

    /// @notice Checks if the collateral amount is increased after boost
    /// @param _cdpId The Id of the CDP
    modifier boostCheck(uint _cdpId) {
        bytes32 ilk = manager.ilks(_cdpId);
        address urn = manager.urns(_cdpId);

        (uint collateralBefore, ) = vat.urns(ilk, urn);

        _;

        (uint collateralAfter, ) = vat.urns(ilk, urn);

        require(collateralAfter > collateralBefore);
    }

    /// @notice Checks if ratio is increased after repay
    /// @param _cdpId The Id of the CDP
    modifier repayCheck(uint _cdpId) {
        bytes32 ilk = manager.ilks(_cdpId);

        uint beforeRatio = getRatio(_cdpId, ilk);

        _;

        uint afterRatio = getRatio(_cdpId, ilk);

        require(afterRatio > beforeRatio || afterRatio == 0);
    }

    /// @notice Repay - draws collateral, converts to Dai and repays the debt
    /// @dev Must be called by the DSProxy contract that owns the CDP
    /// @param _data Uint array [cdpId, amount, minPrice, exchangeType, gasCost, 0xPrice]
    /// @param _joinAddr Address of the join contract for the CDP collateral
    /// @param _exchangeAddress Address of 0x exchange that should be called
    /// @param _callData data to call 0x exchange with
    function repay(
        // cdpId, amount, minPrice, exchangeType, gasCost, 0xPrice
        uint[6] memory _data,
        address _joinAddr,
        address _exchangeAddress,
        bytes memory _callData
    ) public payable repayCheck(_data[0]) {

        address owner = getOwner(manager, _data[0]);
        bytes32 ilk = manager.ilks(_data[0]);

        // uint collDrawn;
        // uint daiAmount;
        // uint daiAfterFee;
        uint[3] memory temp;

        temp[0] = drawCollateral(_data[0], ilk, _joinAddr, _data[1]);

                                // collDrawn, minPrice, exchangeType, 0xPrice
        uint[4] memory swapData = [temp[0], _data[2], _data[3], _data[5]];
        temp[1] = swap(swapData, getCollateralAddr(_joinAddr), DAI_ADDRESS, _exchangeAddress, _callData);
        temp[2] = sub(temp[1], getFee(temp[1], _data[4], owner));

        paybackDebt(_data[0], ilk, temp[2], owner);

        // if there is some eth left (0x fee), return it to user
        if (address(this).balance > 0) {
            tx.origin.transfer(address(this).balance);
        }

        SaverLogger(LOGGER_ADDRESS).LogRepay(_data[0], owner, temp[0], temp[1]);
    }

    /// @notice Boost - draws Dai, converts to collateral and adds to CDP
    /// @dev Must be called by the DSProxy contract that owns the CDP
    /// @param _data Uint array [cdpId, daiAmount, minPrice, exchangeType, gasCost, 0xPrice]
    /// @param _joinAddr Address of the join contract for the CDP collateral
    /// @param _exchangeAddress Address of 0x exchange that should be called
    /// @param _callData data to call 0x exchange with
    function boost(
        // cdpId, daiAmount, minPrice, exchangeType, gasCost, 0xPrice
        uint[6] memory _data,
        address _joinAddr,
        address _exchangeAddress,
        bytes memory _callData
    ) public payable boostCheck(_data[0]) {
        address owner = getOwner(manager, _data[0]);
        bytes32 ilk = manager.ilks(_data[0]);

        // uint daiDrawn;
        // uint daiAfterFee;
        // uint collateralAmount;
        uint[3] memory temp;

        temp[0] = drawDai(_data[0], ilk, _data[1]);
        temp[1] = sub(temp[0], getFee(temp[0], _data[4], owner));
                                // daiAfterFee, minPrice, exchangeType, 0xPrice
        uint[4] memory swapData = [temp[1], _data[2], _data[3], _data[5]];
        temp[2] = swap(swapData, DAI_ADDRESS, getCollateralAddr(_joinAddr), _exchangeAddress, _callData);

        addCollateral(_data[0], _joinAddr, temp[2]);

        // if there is some eth left (0x fee), return it to user
        if (address(this).balance > 0) {
            tx.origin.transfer(address(this).balance);
        }

        SaverLogger(LOGGER_ADDRESS).LogBoost(_data[0], owner, temp[0], temp[2]);
    }

    /// @notice Draws Dai from the CDP
    /// @dev If _daiAmount is bigger than max available we'll draw max
    /// @param _cdpId Id of the CDP
    /// @param _ilk Ilk of the CDP
    /// @param _daiAmount Amount of Dai to draw
    function drawDai(uint _cdpId, bytes32 _ilk, uint _daiAmount) internal returns (uint) {
        uint rate = Jug(JUG_ADDRESS).drip(_ilk);
        uint daiVatBalance = vat.dai(manager.urns(_cdpId));

        uint maxAmount = getMaxDebt(_cdpId, _ilk);

        if (_daiAmount >= maxAmount) {
            _daiAmount = sub(maxAmount, 1);
        }

        manager.frob(_cdpId, int(0), normalizeDrawAmount(_daiAmount, rate, daiVatBalance));
        manager.move(_cdpId, address(this), toRad(_daiAmount));

        if (vat.can(address(this), address(DAI_JOIN_ADDRESS)) == 0) {
            vat.hope(DAI_JOIN_ADDRESS);
        }

        DaiJoin(DAI_JOIN_ADDRESS).exit(address(this), _daiAmount);

        return _daiAmount;
    }

    /// @notice Adds collateral to the CDP
    /// @param _cdpId Id of the CDP
    /// @param _joinAddr Address of the join contract for the CDP collateral
    /// @param _amount Amount of collateral to add
    function addCollateral(uint _cdpId, address _joinAddr, uint _amount) internal {
        int convertAmount = 0;

        if (_joinAddr == ETH_JOIN_ADDRESS) {
            Join(_joinAddr).gem().deposit.value(_amount)();
            convertAmount = toPositiveInt(_amount);
        } else {
            convertAmount = toPositiveInt(convertTo18(_joinAddr, _amount));
        }

        Join(_joinAddr).gem().approve(_joinAddr, _amount);
        Join(_joinAddr).join(address(this), _amount);

        vat.frob(
            manager.ilks(_cdpId),
            manager.urns(_cdpId),
            address(this),
            address(this),
            convertAmount,
            0
        );

    }

    /// @notice Draws collateral and returns it to DSProxy
    /// @dev If _amount is bigger than max available we'll draw max
    /// @param _cdpId Id of the CDP
    /// @param _ilk Ilk of the CDP
    /// @param _joinAddr Address of the join contract for the CDP collateral
    /// @param _amount Amount of collateral to draw
    function drawCollateral(uint _cdpId, bytes32 _ilk, address _joinAddr, uint _amount) internal returns (uint) {
        uint maxCollateral = getMaxCollateral(_cdpId, _ilk, _joinAddr);

        if (_amount >= maxCollateral) {
            _amount = sub(maxCollateral, 1);
        }

        uint frobAmount = _amount;

        if (Join(_joinAddr).dec() != 18) {
            frobAmount = _amount * (10 ** (18 - Join(_joinAddr).dec()));
        }

        manager.frob(_cdpId, -toPositiveInt(frobAmount), 0);
        manager.flux(_cdpId, address(this), frobAmount);

        Join(_joinAddr).exit(address(this), _amount);

        if (_joinAddr == ETH_JOIN_ADDRESS) {
            Join(_joinAddr).gem().withdraw(_amount); // Weth -> Eth
        }

        return _amount;
    }

    /// @notice Paybacks Dai debt
    /// @dev If the _daiAmount is bigger than the whole debt, returns extra Dai
    /// @param _cdpId Id of the CDP
    /// @param _ilk Ilk of the CDP
    /// @param _daiAmount Amount of Dai to payback
    /// @param _owner Address that owns the DSProxy that owns the CDP
    function paybackDebt(uint _cdpId, bytes32 _ilk, uint _daiAmount, address _owner) internal {
        address urn = manager.urns(_cdpId);

        uint wholeDebt = getAllDebt(VAT_ADDRESS, urn, urn, _ilk);

        if (_daiAmount > wholeDebt) {
            ERC20(DAI_ADDRESS).transfer(_owner, sub(_daiAmount, wholeDebt));
            _daiAmount = wholeDebt;
        }

        daiJoin.dai().approve(DAI_JOIN_ADDRESS, _daiAmount);
        daiJoin.join(urn, _daiAmount);

        manager.frob(_cdpId, 0, normalizePaybackAmount(VAT_ADDRESS, urn, _ilk));
    }

    /// @notice Calculates the fee amount
    /// @param _amount Dai amount that is converted
    /// @param _gasCost Used for Monitor, estimated gas cost of tx
    /// @param _owner The address that controlls the DSProxy that owns the CDP
    function getFee(uint _amount, uint _gasCost, address _owner) internal returns (uint feeAmount) {
        uint fee = SERVICE_FEE;

        if (Discount(DISCOUNT_ADDRESS).isCustomFeeSet(_owner)) {
            fee = Discount(DISCOUNT_ADDRESS).getCustomServiceFee(_owner);
        }

        feeAmount = (fee == 0) ? 0 : (_amount / fee);

        if (_gasCost != 0) {
            uint ethDaiPrice = getPrice(ETH_ILK);
            _gasCost = rmul(_gasCost, ethDaiPrice);

            feeAmount = add(feeAmount, _gasCost);
        }

        // fee can't go over 20% of the whole amount
        if (feeAmount > (_amount / 5)) {
            feeAmount = _amount / 5;
        }

        ERC20(DAI_ADDRESS).transfer(WALLET_ID, feeAmount);
    }

    /// @notice Gets the maximum amount of collateral available to draw
    /// @param _cdpId Id of the CDP
    /// @param _ilk Ilk of the CDP
    /// @param _joinAddr Joind address of collateral
    /// @dev Substracts 10 wei to aviod rounding error later on
    function getMaxCollateral(uint _cdpId, bytes32 _ilk, address _joinAddr) public view returns (uint) {
        uint price = getPrice(_ilk);

        (uint collateral, uint debt) = getCdpInfo(manager, _cdpId, _ilk);

        (, uint mat) = Spotter(SPOTTER_ADDRESS).ilks(_ilk);

        uint maxCollateral = sub(sub(collateral, (div(mul(mat, debt), price))), 10);

        uint normalizeMaxCollateral = maxCollateral;

        if (Join(_joinAddr).dec() != 18) {
            normalizeMaxCollateral = maxCollateral / (10 ** (18 - Join(_joinAddr).dec()));
        }

        return normalizeMaxCollateral;
    }

    /// @notice Gets the maximum amount of debt available to generate
    /// @param _cdpId Id of the CDP
    /// @param _ilk Ilk of the CDP
    /// @dev Substracts 10 wei to aviod rounding error later on
    function getMaxDebt(uint _cdpId, bytes32 _ilk) public view returns (uint) {
        uint price = getPrice(_ilk);

        (, uint mat) = spotter.ilks(_ilk);
        (uint collateral, uint debt) = getCdpInfo(manager, _cdpId, _ilk);

        return sub(sub(div(mul(collateral, price), mat), debt), 10);
    }

    /// @notice Gets a price of the asset
    /// @param _ilk Ilk of the CDP
    function getPrice(bytes32 _ilk) public view returns (uint) {
        (, uint mat) = spotter.ilks(_ilk);
        (,,uint spot,,) = vat.ilks(_ilk);

        return rmul(rmul(spot, spotter.par()), mat);
    }

    /// @notice Gets CDP ratio
    /// @param _cdpId Id of the CDP
    /// @param _ilk Ilk of the CDP
    function getRatio(uint _cdpId, bytes32 _ilk) public view returns (uint) {
        uint price = getPrice( _ilk);

        (uint collateral, uint debt) = getCdpInfo(manager, _cdpId, _ilk);

        if (debt == 0) return 0;

        return rdiv(wmul(collateral, price), debt);
    }

    /// @notice Gets CDP info (collateral, debt, price, ilk)
    /// @param _cdpId Id of the CDP
    function getCdpDetailedInfo(uint _cdpId) public view returns (uint collateral, uint debt, uint price, bytes32 ilk) {
        address urn = manager.urns(_cdpId);
        ilk = manager.ilks(_cdpId);

        (collateral, debt) = vat.urns(ilk, urn);
        (,uint rate,,,) = vat.ilks(ilk);

        debt = rmul(debt, rate);
        price = getPrice(ilk);
    }

} library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
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

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

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

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
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
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
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

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
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


interface IFlashLoanReceiver {

    function executeOperation(address _reserve, uint256 _amount, uint256 _fee, bytes calldata _params) external;
}

contract ILendingPoolAddressesProvider {

    function getLendingPool() public view returns (address);
    function setLendingPoolImpl(address _pool) public;

    function getLendingPoolCore() public view returns (address payable);
    function setLendingPoolCoreImpl(address _lendingPoolCore) public;

    function getLendingPoolConfigurator() public view returns (address);
    function setLendingPoolConfiguratorImpl(address _configurator) public;

    function getLendingPoolDataProvider() public view returns (address);
    function setLendingPoolDataProviderImpl(address _provider) public;

    function getLendingPoolParametersProvider() public view returns (address);
    function setLendingPoolParametersProviderImpl(address _parametersProvider) public;

    function getTokenDistributor() public view returns (address);
    function setTokenDistributor(address _tokenDistributor) public;


    function getFeeProvider() public view returns (address);
    function setFeeProviderImpl(address _feeProvider) public;

    function getLendingPoolLiquidationManager() public view returns (address);
    function setLendingPoolLiquidationManager(address _manager) public;

    function getLendingPoolManager() public view returns (address);
    function setLendingPoolManager(address _lendingPoolManager) public;

    function getPriceOracle() public view returns (address);
    function setPriceOracle(address _priceOracle) public;

    function getLendingRateOracle() public view returns (address);
    function setLendingRateOracle(address _lendingRateOracle) public;
}

library EthAddressLib {

    function ethAddress() internal pure returns(address) {
        return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    }
}

contract FlashLoanReceiverBase is IFlashLoanReceiver {

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    ILendingPoolAddressesProvider public addressesProvider;

    constructor(ILendingPoolAddressesProvider _provider) public {
        addressesProvider = _provider;
    }

    function () external payable {
    }

    function transferFundsBackToPoolInternal(address _reserve, uint256 _amount) internal {

        address payable core = addressesProvider.getLendingPoolCore();

        transferInternal(core,_reserve, _amount);
    }

    function transferInternal(address payable _destination, address _reserve, uint256  _amount) internal {
        if(_reserve == EthAddressLib.ethAddress()) {
            //solium-disable-next-line
            _destination.call.value(_amount)("");
            return;
        }

        IERC20(_reserve).safeTransfer(_destination, _amount);


    }

    function getBalanceInternal(address _target, address _reserve) internal view returns(uint256) {
        if(_reserve == EthAddressLib.ethAddress()) {

            return _target.balance;
        }

        return IERC20(_reserve).balanceOf(_target);

    }
} contract MCDSaverFlashLoan is MCDSaverProxy, FlashLoanReceiverBase {
    Manager public constant MANAGER = Manager(MANAGER_ADDRESS);

    ILendingPoolAddressesProvider public LENDING_POOL_ADDRESS_PROVIDER = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);

    address payable public owner;

    constructor()
        FlashLoanReceiverBase(LENDING_POOL_ADDRESS_PROVIDER)
        public {
            owner = msg.sender;
    }

    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params)
    external {

        //check the contract has the specified balance
        require(_amount <= getBalanceInternal(address(this), _reserve),
            "Invalid balance for the contract");

        (
            uint[6] memory data,
            address joinAddr,
            address exchangeAddress,
            bytes memory callData,
            bool isRepay
        )
         = abi.decode(_params, (uint256[6],address,address,bytes,bool));

        if (isRepay) {
            repayWithLoan(data, _amount, joinAddr, exchangeAddress, callData, _fee);
        } else {
            boostWithLoan(data, _amount, joinAddr, exchangeAddress, callData, _fee);
        }

        transferFundsBackToPoolInternal(_reserve, _amount.add(_fee));

        // if there is some eth left (0x fee), return it to user
        if (address(this).balance > 0) {
            tx.origin.transfer(address(this).balance);
        }
    }

    function boostWithLoan(
        uint256[6] memory _data,
        uint256 _loanAmount,
        address _joinAddr,
        address _exchangeAddress,
        bytes memory _callData,
        uint _fee
    ) internal boostCheck(_data[0]) {

        // maxDebt,    daiDrawn,   dfsFee,     amountToSwap, swapedAmount
        // amounts[0], amounts[1], amounts[2], amounts[3],   amounts[4]
        uint[] memory amounts = new uint[](5);
        address owner = getOwner(MANAGER, _data[0]);

        // Draw users Dai
        amounts[0] = getMaxDebt(_data[0], manager.ilks(_data[0]));
        amounts[1] = drawDai(_data[0], MANAGER.ilks(_data[0]), amounts[0]);

        // Calc. fees
        amounts[2] = getFee((amounts[1] + _loanAmount), _data[4], owner);
        amounts[3] = (amounts[1] + _loanAmount) - amounts[2];

        // Swap Dai to collateral
        amounts[4] = swap(
            [amounts[3], _data[2], _data[3], _data[5]],
            DAI_ADDRESS,
            getCollateralAddr(_joinAddr),
            _exchangeAddress,
            _callData
        );

        // Return collateral
        addCollateral(_data[0], _joinAddr, amounts[4]);

        // Draw Dai to repay the flash loan
        drawDai(_data[0],  manager.ilks(_data[0]), (_loanAmount + _fee));

        SaverLogger(LOGGER_ADDRESS).LogBoost(_data[0], owner, (amounts[1] + _loanAmount), amounts[4]);
    }

    function repayWithLoan(
        uint256[6] memory _data,
        uint256 _loanAmount,
        address _joinAddr,
        address _exchangeAddress,
        bytes memory _callData,
        uint _fee
    ) internal repayCheck(_data[0]) {

        // maxColl,    collDrawn,  swapedAmount, dfsFee
        // amounts[0], amounts[1], amounts[2],   amounts[3]
        uint[] memory amounts = new uint[](4);
        address owner = getOwner(MANAGER, _data[0]);

        // Draw collateral
        amounts[0] = getMaxCollateral(_data[0], manager.ilks(_data[0]), _joinAddr);
        amounts[1] = drawCollateral(_data[0], manager.ilks(_data[0]), _joinAddr, amounts[0]);

        // Swap for Dai
        amounts[2] = swap(
            [(amounts[1] + _loanAmount), _data[2], _data[3], _data[5]],
            getCollateralAddr(_joinAddr),
            DAI_ADDRESS,
            _exchangeAddress,
            _callData
        );

        // Get our fee
        amounts[3] = getFee(amounts[2], _data[4], owner);

        uint paybackAmount = (amounts[2] - amounts[3]);
        paybackAmount = limitLoanAmount(_data[0], manager.ilks(_data[0]), paybackAmount, owner);

        // Payback the debt
        paybackDebt(_data[0], MANAGER.ilks(_data[0]), paybackAmount, owner);

        // Draw collateral to repay the flash loan
        drawCollateral(_data[0], manager.ilks(_data[0]), _joinAddr, (_loanAmount + _fee));

        SaverLogger(LOGGER_ADDRESS).LogRepay(_data[0], owner, (amounts[1] + _loanAmount), amounts[2]);
    }

    function() external payable {}

    /// @notice Handles that the amount is not bigger than cdp debt and not dust
    function limitLoanAmount(uint _cdpId, bytes32 _ilk, uint _paybackAmount, address _owner) internal returns (uint256) {
        uint debt = getAllDebt(address(vat), manager.urns(_cdpId), manager.urns(_cdpId), _ilk);

        if (_paybackAmount > debt) {
            ERC20(DAI_ADDRESS).transfer(_owner, (_paybackAmount - debt));
            return debt;
        }

        uint debtLeft = debt - _paybackAmount;

        // Less than dust value
        if (debtLeft < 20 ether) {
            uint amountOverDust = ((20 ether) - debtLeft);

            ERC20(DAI_ADDRESS).transfer(_owner, amountOverDust);

            return (_paybackAmount - amountOverDust);
        }

        return _paybackAmount;
    }

    // ADMIN ONLY FAIL SAFE FUNCTION IF FUNDS GET STUCK
    function withdrawStuckFunds(address _tokenAddr, uint _amount) public {
        require(msg.sender == owner, "Only owner");

        if (_tokenAddr == KYBER_ETH_ADDRESS) {
            owner.transfer(_amount);
        } else {
            ERC20(_tokenAddr).transfer(owner, _amount);
        }
    }
}