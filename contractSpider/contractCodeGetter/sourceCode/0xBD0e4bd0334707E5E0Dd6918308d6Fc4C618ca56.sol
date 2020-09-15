/**
 *Submitted for verification at Etherscan.io on 2020-06-10
*/

pragma solidity >=0.5.1 <0.7.0;

contract KOwnerable {
    address[] public _KContractOwners = [
                address(0x7630A0f21Ac2FDe268eF62eBb1B06876DFe71909)
    ];
    constructor() public {
        _KContractOwners.push(msg.sender);
    }
    modifier KOwnerOnly() {
        bool exist = false;
        for ( uint i = 0; i < _KContractOwners.length; i++ ) {
            if ( _KContractOwners[i] == msg.sender ) {
                exist = true;
                break;
            }
        }
        require(exist); _;
    }
    modifier KDAODefense() {
        uint256 size;
        address payable safeAddr = msg.sender;
        assembly {size := extcodesize(safeAddr)}
        require( size == 0, "DAO_Warning" );
        _;
    }
}
contract KState is KOwnerable {
    uint public _CIDXX;
    Hosts public _KHost;
    constructor(uint cidxx) public {
        _CIDXX = cidxx;
    }
}
contract KContract is KState {
    modifier readonly {_;}
    modifier readwrite {_;}
    function implementcall() internal {
        (bool s, bytes memory r) = _KHost.getImplement(_CIDXX).delegatecall(msg.data);
        require(s);
        assembly {
            return( add(r, 0x20), returndatasize )
        }
    }
    function implementcall(uint subimplID) internal {
        (bool s, bytes memory r) = _KHost.getImplementSub(_CIDXX, subimplID).delegatecall(msg.data);
        require(s);
        assembly {
            return( add(r, 0x20), returndatasize )
        }
    }
        function _D(bytes calldata, uint m) external KOwnerOnly returns (bytes memory) {
        implementcall(m);
    }
}
pragma solidity >=0.5.0 <0.6.0;
interface USDTInterface {
    function totalSupply() external view returns (uint);
    function balanceOf(address who) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
        function transfer(address to, uint value) external;
    function approve(address spender, uint value) external;
    function transferFrom(address from, address to, uint value) external;
}
pragma solidity >=0.5.1 <0.7.0;
interface AssertPoolInterface{
    enum AssertPoolName {
        Nullable,
                Prepare,
                Treasure,
                Awards,
                Events
    }
        function PoolNameFromOperator(address operator) external returns (AssertPoolName);
        function Allowance(address operator) external returns (uint);
        function OperatorSend(address to, uint amount) external;
        function Auth_RecipientDelegate(uint amount) external;
}
pragma solidity >=0.5.1 <0.7.0;
contract AssertPoolState is AssertPoolInterface, KState(0xbdfa5467) {
        uint[5] public matchings = [
        0,
        0.2 szabo,
        0.2 szabo,
        0.4 szabo,
        0.2 szabo
    ];
        uint[5] public availTotalAmouns = [
        0,
        0,
        0,
        0,
        0
    ];
        address[5] public operators = [
        address(0x0),
        address(0x0),
        address(0x0),
        address(0x0),
        address(0x0)
    ];
    USDTInterface internal usdtInterface;
    address internal authAddress;
}
contract Hosts {
    address public owner;
    mapping(uint => mapping(uint => address)) internal impls;
    mapping(uint => uint) internal time;
    constructor() public {
        owner = msg.sender;
    }
    modifier restricted() {
        if (msg.sender == owner) _;
    }
    function latestTime(uint CIDXX) external view restricted returns (uint) {
        return time[CIDXX];
    }
    function setImplement(uint CIDXX, address implementer) external restricted {
        time[uint(CIDXX)] = now;
        impls[uint(CIDXX)][0] = implementer;
    }
    function setImplementSub(uint CIDXX, uint idx, address implementer) external restricted {
        time[uint(CIDXX)] = now;
        impls[uint(CIDXX)][idx] = implementer;
    }
    function getImplement(uint CIDXX) external view returns (address) {
        return impls[uint(CIDXX)][0];
    }
    function getImplementSub(uint CIDXX, uint idx) external view returns (address) {
        return impls[uint(CIDXX)][idx];
    }
}
pragma solidity >=0.5.1 <0.7.0;
contract AssertPool is AssertPoolState, KContract {
    constructor(
        USDTInterface usdInc,
        Hosts host
    ) public {
        _KHost = host;
        usdtInterface = usdInc;
    }
        function OWNER_SetSwapInterface(address swapInc) external KOwnerOnly {
        authAddress = swapInc;
    }
        function OWNER_SetOperator(address operator, AssertPoolName poolName) external KOwnerOnly {
        operators[uint(poolName)] = operator;
    }
        function OWNER_SetMatchings( uint[4] calldata ms ) external KOwnerOnly {
        require( ms[0] + ms[1] + ms[2] + ms[3] == 1 szabo );
        matchings[1] = ms[0];
        matchings[2] = ms[1];
        matchings[3] = ms[2];
        matchings[4] = ms[3];
    }
        function PoolNameFromOperator(address) external readonly returns (AssertPoolName) {
        super.implementcall();
    }
        function Allowance(address) external readonly returns (uint) {
        super.implementcall();
    }
        function OperatorSend(address, uint) external readwrite {
        super.implementcall();
    }
        function Auth_RecipientDelegate(uint) external readwrite {
        super.implementcall();
    }
}