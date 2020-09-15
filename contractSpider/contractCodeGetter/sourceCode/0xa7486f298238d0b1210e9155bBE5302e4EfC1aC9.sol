/**
 *Submitted for verification at Etherscan.io on 2020-05-21
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


/// @title Implements enum Method
abstract contract StaticV2 {

    enum Method { Boost, Repay }

    struct CdpHolder {
        uint128 minRatio;
        uint128 maxRatio;
        uint128 optimalRatioBoost;
        uint128 optimalRatioRepay;
        address owner;
        uint cdpId;
        bool boostEnabled;
        bool nextPriceEnabled;
    }

    struct SubPosition {
        uint arrPos;
        bool subscribed;
    }
}

abstract contract ISubscriptionsV2 is StaticV2 {

    function getOwner(uint _cdpId) external view virtual returns(address);
    function getSubscribedInfo(uint _cdpId) public view virtual returns(bool, uint128, uint128, uint128, uint128, address, uint coll, uint debt);
    function getCdpHolder(uint _cdpId) public view virtual returns (bool subscribed, CdpHolder memory);
}

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

/// @title Implements logic for calling MCDSaverProxy always from same contract
contract MCDMonitorProxyV2 is AdminAuth {

    uint public CHANGE_PERIOD;
    address public monitor;
    address public newMonitor;
    address public lastMonitor;
    uint public changeRequestedTimestamp;

    mapping(address => bool) public allowed;

    event MonitorChangeInitiated(address oldMonitor, address newMonitor);
    event MonitorChangeCanceled();
    event MonitorChangeFinished(address monitor);
    event MonitorChangeReverted(address monitor);

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
        CHANGE_PERIOD = _changePeriod * 1 days;
    }

    /// @notice Only monitor contract is able to call execute on users proxy
    /// @param _owner Address of cdp owner (users DSProxy address)
    /// @param _saverProxy Address of MCDSaverProxy
    /// @param _data Data to send to MCDSaverProxy
    function callExecute(address _owner, address _saverProxy, bytes memory _data) public payable onlyMonitor {
        // execute reverts if calling specific method fails
        DSProxyInterface(_owner).execute{value: msg.value}(_saverProxy, _data);

        // return if anything left
        if (address(this).balance > 0) {
            msg.sender.transfer(address(this).balance);
        }
    }

    /// @notice Allowed users are able to set Monitor contract without any waiting period first time
    /// @param _monitor Address of Monitor contract
    function setMonitor(address _monitor) public onlyAllowed {
        require(monitor == address(0));
        monitor = _monitor;
    }

    /// @notice Allowed users are able to start procedure for changing monitor
    /// @dev after CHANGE_PERIOD needs to call confirmNewMonitor to actually make a change
    /// @param _newMonitor address of new monitor
    function changeMonitor(address _newMonitor) public onlyAllowed {
        require(changeRequestedTimestamp == 0);

        changeRequestedTimestamp = now;
        lastMonitor = monitor;
        newMonitor = _newMonitor;

        emit MonitorChangeInitiated(lastMonitor, newMonitor);
    }

    /// @notice At any point allowed users are able to cancel monitor change
    function cancelMonitorChange() public onlyAllowed {
        require(changeRequestedTimestamp > 0);

        changeRequestedTimestamp = 0;
        newMonitor = address(0);

        emit MonitorChangeCanceled();
    }

    /// @notice Anyone is able to confirm new monitor after CHANGE_PERIOD if process is started
    function confirmNewMonitor() public onlyAllowed {
        require((changeRequestedTimestamp + CHANGE_PERIOD) < now);
        require(changeRequestedTimestamp != 0);
        require(newMonitor != address(0));

        monitor = newMonitor;
        newMonitor = address(0);
        changeRequestedTimestamp = 0;

        emit MonitorChangeFinished(monitor);
    }

    /// @notice Its possible to revert monitor to last used monitor
    function revertMonitor() public onlyAllowed {
        require(lastMonitor != address(0));

        monitor = lastMonitor;

        emit MonitorChangeReverted(monitor);
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

    function setChangePeriod(uint _periodInDays) public onlyAllowed {
        require(_periodInDays * 1 days > CHANGE_PERIOD);

        CHANGE_PERIOD = _periodInDays * 1 days;
    }

    /// @notice In case something is left in contract, owner is able to withdraw it
    /// @param _token address of token to withdraw balance
    function withdrawToken(address _token) public onlyOwner {
        uint balance = ERC20(_token).balanceOf(address(this));
        ERC20(_token).transfer(msg.sender, balance);
    }

    /// @notice In case something is left in contract, owner is able to withdraw it
    function withdrawEth() public onlyOwner {
        uint balance = address(this).balance;
        msg.sender.transfer(balance);
    }
}

contract ConstantAddressesMainnet {
    address public constant MAKER_DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
    address public constant IDAI_ADDRESS = 0x14094949152EDDBFcd073717200DA82fEd8dC960;
    address public constant SOLO_MARGIN_ADDRESS = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;
    address public constant CDAI_ADDRESS = 0xF5DCe57282A584D2746FaF1593d3121Fcac444dC;
    address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public constant MKR_ADDRESS = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2;
    address public constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant VOX_ADDRESS = 0x9B0F70Df76165442ca6092939132bBAEA77f2d7A;
    address public constant PETH_ADDRESS = 0xf53AD2c6851052A81B42133467480961B2321C09;
    address public constant TUB_ADDRESS = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
    address payable public constant WALLET_ID = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;
    address public constant LOGGER_ADDRESS = 0xeCf88e1ceC2D2894A0295DB3D86Fe7CE4991E6dF;
    address public constant OTC_ADDRESS = 0x794e6e91555438aFc3ccF1c5076A74F42133d08D;
    address public constant DISCOUNT_ADDRESS = 0x1b14E8D511c9A4395425314f849bD737BAF8208F;

    address public constant KYBER_WRAPPER = 0x8F337bD3b7F2b05d9A8dC8Ac518584e833424893;
    address public constant UNISWAP_WRAPPER = 0x1e30124FDE14533231216D95F7798cD0061e5cf8;
    address public constant ETH2DAI_WRAPPER = 0xd7BBB1777E13b6F535Dec414f575b858ed300baF;
    address public constant OASIS_WRAPPER = 0x9aBE2715D2d99246269b8E17e9D1b620E9bf6558;

    address public constant KYBER_INTERFACE = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
    address public constant UNISWAP_FACTORY = 0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95;
    address public constant FACTORY_ADDRESS = 0x5a15566417e6C1c9546523066500bDDBc53F88C7;
    address public constant PIP_INTERFACE_ADDRESS = 0x729D19f657BD0614b4985Cf1D82531c67569197B;

    address public constant PROXY_REGISTRY_INTERFACE_ADDRESS = 0x4678f0a6958e4D2Bc4F1BAF7Bc52E8F3564f3fE4;
    address public constant GAS_TOKEN_INTERFACE_ADDRESS = 0x0000000000b3F879cb30FE243b4Dfee438691c04;

    address public constant SAVINGS_LOGGER_ADDRESS = 0x89b3635BD2bAD145C6f92E82C9e83f06D5654984;
    address public constant AUTOMATIC_LOGGER_ADDRESS = 0xAD32Ce09DE65971fFA8356d7eF0B783B82Fd1a9A;

    address public constant SAVER_EXCHANGE_ADDRESS = 0x6eC6D98e2AF940436348883fAFD5646E9cdE2446;

    // Kovan addresses, not used on mainnet
    address public constant COMPOUND_DAI_ADDRESS = 0x25a01a05C188DaCBCf1D61Af55D4a5B4021F7eeD;
    address public constant STUPID_EXCHANGE = 0x863E41FE88288ebf3fcd91d8Dbb679fb83fdfE17;

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
    address public constant SUBSCRIPTION_ADDRESS = 0x83152CAA0d344a2Fd428769529e2d490A88f4393;
    address public constant MONITOR_ADDRESS = 0x3F4339816EDEF8D3d3970DB2993e2e0Ec6010760;

    address public constant NEW_CDAI_ADDRESS = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;
    address public constant NEW_IDAI_ADDRESS = 0x493C57C4763932315A328269E1ADaD09653B9081;

    address public constant ERC20_PROXY_0X = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;
}

contract ConstantAddressesKovan {
    address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public constant WETH_ADDRESS = 0xd0A1E359811322d97991E03f863a0C30C2cF029C;
    address public constant MAKER_DAI_ADDRESS = 0xC4375B7De8af5a38a93548eb8453a498222C4fF2;
    address public constant MKR_ADDRESS = 0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD;
    address public constant VOX_ADDRESS = 0xBb4339c0aB5B1d9f14Bd6e3426444A1e9d86A1d9;
    address public constant PETH_ADDRESS = 0xf4d791139cE033Ad35DB2B2201435fAd668B1b64;
    address public constant TUB_ADDRESS = 0xa71937147b55Deb8a530C7229C442Fd3F31b7db2;
    address public constant LOGGER_ADDRESS = 0x32d0e18f988F952Eb3524aCE762042381a2c39E5;
    address payable public constant WALLET_ID = 0x54b44C6B18fc0b4A1010B21d524c338D1f8065F6;
    address public constant OTC_ADDRESS = 0x4A6bC4e803c62081ffEbCc8d227B5a87a58f1F8F;
    address public constant COMPOUND_DAI_ADDRESS = 0x25a01a05C188DaCBCf1D61Af55D4a5B4021F7eeD;
    address public constant SOLO_MARGIN_ADDRESS = 0x4EC3570cADaAEE08Ae384779B0f3A45EF85289DE;
    address public constant IDAI_ADDRESS = 0xA1e58F3B1927743393b25f261471E1f2D3D9f0F6;
    address public constant CDAI_ADDRESS = 0xb6b09fBffBa6A5C4631e5F7B2e3Ee183aC259c0d;
    address public constant STUPID_EXCHANGE = 0x863E41FE88288ebf3fcd91d8Dbb679fb83fdfE17;
    address public constant DISCOUNT_ADDRESS = 0x1297c1105FEDf45E0CF6C102934f32C4EB780929;
    address public constant SAI_SAVER_PROXY = 0xADB7c74bCe932fC6C27ddA3Ac2344707d2fBb0E6;

    address public constant KYBER_WRAPPER = 0x68c56FF0E7BBD30AF9Ad68225479449869fC1bA0;
    address public constant UNISWAP_WRAPPER = 0x2A4ee140F05f1Ba9A07A020b07CCFB76CecE4b43;
    address public constant ETH2DAI_WRAPPER = 0x823cde416973a19f98Bb9C96d97F4FE6C9A7238B;
    address public constant OASIS_WRAPPER = 0x0257Ba4876863143bbeDB7847beC583e4deb6fE6;

    address public constant SAVER_EXCHANGE_ADDRESS = 0xACA7d11e3f482418C324aAC8e90AaD0431f692A6;

    address public constant FACTORY_ADDRESS = 0xc72E74E474682680a414b506699bBcA44ab9a930;
    //
    address public constant PIP_INTERFACE_ADDRESS = 0xA944bd4b25C9F186A846fd5668941AA3d3B8425F;
    address public constant PROXY_REGISTRY_INTERFACE_ADDRESS = 0x64A436ae831C1672AE81F674CAb8B6775df3475C;
    address public constant GAS_TOKEN_INTERFACE_ADDRESS = 0x0000000000170CcC93903185bE5A2094C870Df62;
    address public constant KYBER_INTERFACE = 0x692f391bCc85cefCe8C237C01e1f636BbD70EA4D;

    address public constant SAVINGS_LOGGER_ADDRESS = 0x2aa889D809B29c608dA99767837D189dAe12a874;

    // Rinkeby, when no Kovan
    address public constant UNISWAP_FACTORY = 0xf5D915570BC477f9B8D6C0E980aA81757A3AaC36;

    // new MCD contracts
    address public constant MANAGER_ADDRESS = 0x1476483dD8C35F25e568113C5f70249D3976ba21;
    address public constant VAT_ADDRESS = 0xbA987bDB501d131f766fEe8180Da5d81b34b69d9;
    address public constant SPOTTER_ADDRESS = 0x3a042de6413eDB15F2784f2f97cC68C7E9750b2D;

    address public constant JUG_ADDRESS = 0xcbB7718c9F39d05aEEDE1c472ca8Bf804b2f1EaD;
    address public constant DAI_JOIN_ADDRESS = 0x5AA71a3ae1C0bd6ac27A1f28e1415fFFB6F15B8c;
    address public constant ETH_JOIN_ADDRESS = 0x775787933e92b709f2a3C70aa87999696e74A9F8;
    address public constant MIGRATION_ACTIONS_PROXY = 0x433870076aBd08865f0e038dcC4Ac6450e313Bd8;
    address public constant PROXY_ACTIONS = 0xd1D24637b9109B7f61459176EdcfF9Be56283a7B;

    address public constant SAI_ADDRESS = 0xC4375B7De8af5a38a93548eb8453a498222C4fF2;
    address public constant DAI_ADDRESS = 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa;

    address payable public constant SCD_MCD_MIGRATION = 0x411B2Faa662C8e3E5cF8f01dFdae0aeE482ca7b0;

    // Our contracts
    address public constant SUBSCRIPTION_ADDRESS = 0xFC41f79776061a396635aD0b9dF7a640A05063C1;
    address public constant MONITOR_ADDRESS = 0xfC1Fc0502e90B7A3766f93344E1eDb906F8A75DD;

    // TODO: find out what the
    address public constant NEW_CDAI_ADDRESS = 0xe7bc397DBd069fC7d0109C0636d06888bb50668c;
    address public constant NEW_IDAI_ADDRESS = 0x6c1E2B0f67e00c06c8e2BE7Dc681Ab785163fF4D;
}

// solhint-disable-next-line no-empty-blocks
contract ConstantAddresses is ConstantAddressesMainnet {}

abstract contract GasTokenInterface is ERC20 {
    function free(uint256 value) public virtual returns (bool success);

    function freeUpTo(uint256 value) public virtual returns (uint256 freed);

    function freeFrom(address from, uint256 value) public virtual returns (bool success);

    function freeFromUpTo(address from, uint256 value) public virtual returns (uint256 freed);
}

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

abstract contract Vat {

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

    function can(address, address) virtual public view returns (uint);
    function dai(address) virtual public view returns (uint);
    function frob(bytes32, address, address, address, int, int) virtual public;
    function hope(address) virtual public;
    function move(address, address, uint) virtual public;
}

abstract contract PipInterface {
    function read() public virtual returns (bytes32);
}

abstract contract Spotter {
    struct Ilk {
        PipInterface pip;
        uint256 mat;
    }

    mapping (bytes32 => Ilk) public ilks;

    uint256 public par;

}

contract AutomaticLogger {
    event CdpRepay(uint indexed cdpId, address indexed caller, uint amount, uint beforeRatio, uint afterRatio, address logger);
    event CdpBoost(uint indexed cdpId, address indexed caller, uint amount, uint beforeRatio, uint afterRatio, address logger);

    function logRepay(uint cdpId, address caller, uint amount, uint beforeRatio, uint afterRatio) public {
        emit CdpRepay(cdpId, caller, amount, beforeRatio, afterRatio, msg.sender);
    }

    function logBoost(uint cdpId, address caller, uint amount, uint beforeRatio, uint afterRatio) public {
        emit CdpBoost(cdpId, caller, amount, beforeRatio, afterRatio, msg.sender);
    }
}

/// @title Implements logic that allows bots to call Boost and Repay
contract MCDMonitorV2 is AdminAuth, ConstantAddresses, DSMath, StaticV2 {

    uint public REPAY_GAS_TOKEN = 30;
    uint public BOOST_GAS_TOKEN = 19;

    uint constant public MAX_GAS_PRICE = 80000000000; // 80 gwei

    uint public REPAY_GAS_COST = 2200000;
    uint public BOOST_GAS_COST = 1500000;

    MCDMonitorProxyV2 public monitorProxyContract;
    ISubscriptionsV2 public subscriptionsContract;
    GasTokenInterface gasToken = GasTokenInterface(GAS_TOKEN_INTERFACE_ADDRESS);
    address public automaticSaverProxyAddress;

    Manager public manager = Manager(MANAGER_ADDRESS);
    Vat public vat = Vat(VAT_ADDRESS);
    Spotter public spotter = Spotter(SPOTTER_ADDRESS);
    AutomaticLogger public logger = AutomaticLogger(AUTOMATIC_LOGGER_ADDRESS);

    /// @dev Addresses that are able to call methods for repay and boost
    mapping(address => bool) public approvedCallers;

    modifier onlyApproved() {
        require(approvedCallers[msg.sender]);
        _;
    }

    constructor(address _monitorProxy, address _subscriptions, address _automaticSaverProxyAddress) public {
        approvedCallers[msg.sender] = true;

        monitorProxyContract = MCDMonitorProxyV2(_monitorProxy);
        subscriptionsContract = ISubscriptionsV2(_subscriptions);
        automaticSaverProxyAddress = _automaticSaverProxyAddress;
    }

    /// @notice Bots call this method to repay for user when conditions are met
    /// @dev If the contract ownes gas token it will try and use it for gas price reduction
    /// @param _data Array of uints representing [cdpId, daiAmount, minPrice, exchangeType, gasCost, 0xPrice]
    /// @param _nextPrice Next price in Maker protocol
    /// @param _joinAddr Address of collateral join for specific CDP
    /// @param _exchangeAddress Address to call 0x exchange
    /// @param _callData Bytes representing call data for 0x exchange
    function repayFor(
        uint[6] memory _data, // cdpId, daiAmount, minPrice, exchangeType, gasCost, 0xPrice
        uint256 _nextPrice,
        address _joinAddr,
        address _exchangeAddress,
        bytes memory _callData
    ) public payable onlyApproved {
        if (gasToken.balanceOf(address(this)) >= BOOST_GAS_TOKEN) {
            gasToken.free(BOOST_GAS_TOKEN);
        }

        uint ratioBefore;
        bool isAllowed;
        (isAllowed, ratioBefore) = canCall(Method.Repay, _data[0], _nextPrice);
        require(isAllowed);

        uint gasCost = calcGasCost(REPAY_GAS_COST);
        _data[4] = gasCost;

        monitorProxyContract.callExecute{value: msg.value}(subscriptionsContract.getOwner(_data[0]), automaticSaverProxyAddress, abi.encodeWithSignature("automaticRepay(uint256[6],address,address,bytes)", _data, _joinAddr, _exchangeAddress, _callData));

        uint ratioAfter;
        bool isGoodRatio;
        (isGoodRatio, ratioAfter) = ratioGoodAfter(Method.Repay, _data[0], _nextPrice);
        // doesn't allow user to repay too much
        require(isGoodRatio);

        returnEth();

        logger.logRepay(_data[0], msg.sender, _data[1], ratioBefore, ratioAfter);
    }

    /// @notice Bots call this method to boost for user when conditions are met
    /// @dev If the contract ownes gas token it will try and use it for gas price reduction
    /// @param _data Array of uints representing [cdpId, collateralAmount, minPrice, exchangeType, gasCost, 0xPrice]
    /// @param _nextPrice Next price in Maker protocol
    /// @param _joinAddr Address of collateral join for specific CDP
    /// @param _exchangeAddress Address to call 0x exchange
    /// @param _callData Bytes representing call data for 0x exchange
    function boostFor(
        uint[6] memory _data, // cdpId, daiAmount, minPrice, exchangeType, gasCost, 0xPrice
        uint256 _nextPrice,
        address _joinAddr,
        address _exchangeAddress,
        bytes memory _callData
    ) public payable onlyApproved {
        if (gasToken.balanceOf(address(this)) >= REPAY_GAS_TOKEN) {
            gasToken.free(REPAY_GAS_TOKEN);
        }

        uint ratioBefore;
        bool isAllowed;
        (isAllowed, ratioBefore) = canCall(Method.Boost, _data[0], _nextPrice);
        require(isAllowed);

        uint gasCost = calcGasCost(BOOST_GAS_COST);
        _data[4] = gasCost;

        monitorProxyContract.callExecute{value: msg.value}(subscriptionsContract.getOwner(_data[0]), automaticSaverProxyAddress, abi.encodeWithSignature("automaticBoost(uint256[6],address,address,bytes)", _data, _joinAddr, _exchangeAddress, _callData));

        uint ratioAfter;
        bool isGoodRatio;
        (isGoodRatio, ratioAfter) = ratioGoodAfter(Method.Boost, _data[0], _nextPrice);
        // doesn't allow user to boost too much
        require(isGoodRatio);

        returnEth();

        logger.logBoost(_data[0], msg.sender, _data[1], ratioBefore, ratioAfter);
    }

/******************* INTERNAL METHODS ********************************/
    function returnEth() internal {
        // return if some eth left
        if (address(this).balance > 0) {
            msg.sender.transfer(address(this).balance);
        }
    }

/******************* STATIC METHODS ********************************/

    /// @notice Returns an address that owns the CDP
    /// @param _cdpId Id of the CDP
    function getOwner(uint _cdpId) public view returns(address) {
        return manager.owns(_cdpId);
    }

    /// @notice Gets CDP info (collateral, debt)
    /// @param _cdpId Id of the CDP
    /// @param _ilk Ilk of the CDP
    function getCdpInfo(uint _cdpId, bytes32 _ilk) public view returns (uint, uint) {
        address urn = manager.urns(_cdpId);

        (uint collateral, uint debt) = vat.urns(_ilk, urn);
        (,uint rate,,,) = vat.ilks(_ilk);

        return (collateral, rmul(debt, rate));
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
    /// @param _nextPrice Next price for user
    function getRatio(uint _cdpId, uint _nextPrice) public view returns (uint) {
        bytes32 ilk = manager.ilks(_cdpId);
        uint price = (_nextPrice == 0) ? getPrice(ilk) : _nextPrice;

        (uint collateral, uint debt) = getCdpInfo(_cdpId, ilk);

        if (debt == 0) return 0;

        return rdiv(wmul(collateral, price), debt) / (10 ** 18);
    }

    /// @notice Checks if Boost/Repay could be triggered for the CDP
    /// @dev Called by MCDMonitor to enforce the min/max check
    function canCall(Method _method, uint _cdpId, uint _nextPrice) public view returns(bool, uint) {
        bool subscribed;
        CdpHolder memory holder;
        (subscribed, holder) = subscriptionsContract.getCdpHolder(_cdpId);

        // check if cdp is subscribed
        if (!subscribed) return (false, 0);

        // check if using next price is allowed
        if (_nextPrice > 0 && !holder.nextPriceEnabled) return (false, 0);

        // check if boost and boost allowed
        if (_method == Method.Boost && !holder.boostEnabled) return (false, 0);

        // check if owner is still owner
        if (getOwner(_cdpId) != holder.owner) return (false, 0);

        uint currRatio = getRatio(_cdpId, _nextPrice);

        if (_method == Method.Repay) {
            return (currRatio < holder.minRatio, currRatio);
        } else if (_method == Method.Boost) {
            return (currRatio > holder.maxRatio, currRatio);
        }
    }

    /// @dev After the Boost/Repay check if the ratio doesn't trigger another call
    function ratioGoodAfter(Method _method, uint _cdpId, uint _nextPrice) public view returns(bool, uint) {
        CdpHolder memory holder;

        (, holder) = subscriptionsContract.getCdpHolder(_cdpId);

        uint currRatio = getRatio(_cdpId, _nextPrice);

        if (_method == Method.Repay) {
            return (currRatio < holder.maxRatio, currRatio);
        } else if (_method == Method.Boost) {
            return (currRatio > holder.minRatio, currRatio);
        }
    }

    /// @notice Calculates gas cost (in Eth) of tx
    /// @dev Gas price is limited to MAX_GAS_PRICE to prevent attack of draining user CDP
    /// @param _gasAmount Amount of gas used for the tx
    function calcGasCost(uint _gasAmount) public view returns (uint) {
        uint gasPrice = tx.gasprice <= MAX_GAS_PRICE ? tx.gasprice : MAX_GAS_PRICE;

        return mul(gasPrice, _gasAmount);
    }

/******************* OWNER ONLY OPERATIONS ********************************/

    /// @notice Allows owner to change gas cost for boost operation, but only up to 3 millions
    /// @param _gasCost New gas cost for boost method
    function changeBoostGasCost(uint _gasCost) public onlyOwner {
        require(_gasCost < 3000000);

        BOOST_GAS_COST = _gasCost;
    }

    /// @notice Allows owner to change gas cost for repay operation, but only up to 3 millions
    /// @param _gasCost New gas cost for repay method
    function changeRepayGasCost(uint _gasCost) public onlyOwner {
        require(_gasCost < 3000000);

        REPAY_GAS_COST = _gasCost;
    }

    /// @notice Allows owner to change the amount of gas token burned per function call
    /// @param _gasAmount Amount of gas token
    /// @param _isRepay Flag to know for which function we are setting the gas token amount
    function changeGasTokenAmount(uint _gasAmount, bool _isRepay) public onlyOwner {
        if (_isRepay) {
            REPAY_GAS_TOKEN = _gasAmount;
        } else {
            BOOST_GAS_TOKEN = _gasAmount;
        }
    }

    /// @notice Adds a new bot address which will be able to call repay/boost
    /// @param _caller Bot address
    function addCaller(address _caller) public onlyOwner {
        approvedCallers[_caller] = true;
    }

    /// @notice Removes a bot address so it can't call repay/boost
    /// @param _caller Bot address
    function removeCaller(address _caller) public onlyOwner {
        approvedCallers[_caller] = false;
    }

    /// @notice If any tokens gets stuck in the contract owner can withdraw it
    /// @param _tokenAddress Address of the ERC20 token
    /// @param _to Address of the receiver
    /// @param _amount The amount to be sent
    function transferERC20(address _tokenAddress, address _to, uint _amount) public onlyOwner {
        ERC20(_tokenAddress).transfer(_to, _amount);
    }

    /// @notice If any Eth gets stuck in the contract owner can withdraw it
    /// @param _to Address of the receiver
    /// @param _amount The amount to be sent
    function transferEth(address payable _to, uint _amount) public onlyOwner {
        _to.transfer(_amount);
    }
}