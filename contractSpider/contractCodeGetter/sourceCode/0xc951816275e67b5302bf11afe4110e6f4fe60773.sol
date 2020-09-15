/**
 *Submitted for verification at Etherscan.io on 2020-07-12
*/

// File: contracts/interfaces/IDeerfiV1Pair.sol

pragma solidity >=0.5.0;

interface IDeerfiV1Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amountLiqidity);
    event Burn(address indexed sender, uint amountLiqidity, address indexed to);
    event LongSwap(
        address indexed sender,
        uint amountTradeTokenIn,
        uint amountLongTokenOut,
        address indexed to
    );
    event CloseSwap(
        address indexed sender,
        uint amountLongTokenIn,
        uint amountTradeTokenOut,
        address indexed to
    );
    event Sync(uint256 reserveTradeToken);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function tradeToken() external view returns (address);
    function fromToken() external view returns (address);
    function toToken() external view returns (address);
    function longToken() external view returns (address);

    function getReserves() external view returns (uint256 reserveTradeToken);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amountTradeToken);
    function swap(address to) external;
    function closeSwap(address to) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address, address, address) external;
}

// File: contracts/interfaces/IDeerfiV1ERC20.sol

pragma solidity >=0.5.0;

interface IDeerfiV1ERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
}

// File: contracts/libraries/SafeMath.sol

pragma solidity =0.5.16;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}

// File: contracts/DeerfiV1ERC20.sol

pragma solidity =0.5.16;



contract DeerfiV1ERC20 is IDeerfiV1ERC20 {
    using SafeMath for uint;

    string public constant name = 'Deerfi';
    string public constant symbol = 'DF-V1';
    uint8 public constant decimals = 18;
    uint  public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    bytes32 public DOMAIN_SEPARATOR;
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint) public nonces;

    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    constructor() public {
        uint chainId;
        assembly {
            chainId := chainid
        }
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes(name)),
                keccak256(bytes('1')),
                chainId,
                address(this)
            )
        );
    }

    function _mint(address to, uint value) internal {
        totalSupply = totalSupply.add(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(address(0), to, value);
    }

    function _burn(address from, uint value) internal {
        balanceOf[from] = balanceOf[from].sub(value);
        totalSupply = totalSupply.sub(value);
        emit Transfer(from, address(0), value);
    }

    function _approve(address owner, address spender, uint value) private {
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _transfer(address from, address to, uint value) private {
        balanceOf[from] = balanceOf[from].sub(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint value) external returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint value) external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) external returns (bool) {
        if (allowance[from][msg.sender] != uint(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        }
        _transfer(from, to, value);
        return true;
    }

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        require(deadline >= block.timestamp, 'DeerfiV1: EXPIRED');
        bytes32 digest = keccak256(
            abi.encodePacked(
                '\x19\x01',
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == owner, 'DeerfiV1: INVALID_SIGNATURE');
        _approve(owner, spender, value);
    }
}

// File: contracts/libraries/Math.sol

pragma solidity =0.5.16;

// a library for performing various math operations

library Math {
    function min(uint x, uint y) internal pure returns (uint z) {
        z = x < y ? x : y;
    }
}

// File: contracts/interfaces/IERC20.sol

pragma solidity >=0.5.0;

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

// File: contracts/interfaces/IDeerfiV1Factory.sol

pragma solidity >=0.5.0;

interface IDeerfiV1Factory {
    event PairCreated(address indexed tradeToken, address indexed fromToken, address indexed toToken, address pair, address longToken, uint);
    event FeedPairCreated(address indexed tokenA, address indexed tokenB, address indexed feedPair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function feeFactor() external view returns (uint16);

    function getPair(address tradeToken, address fromToken, address toToken) external view returns (address pair);
    function getFeedPair(address tokenA, address tokenB) external view returns (address feedPair);
    function allPairsLength() external view returns (uint);
    function allFeedPairsLength() external view returns (uint);

    function createPair(address tradeToken, address fromToken, address toToken) external returns (address pair);
    function setFeedPair(address tokenA, address tokenB, uint8 decimalsA, uint8 decimalsB,
        address aggregator0, address aggregator1, uint8 decimals0, uint8 decimals1, bool isReverse0, bool isReverse1) external returns (address feedPair);

    function setFeeTo(address) external;
    function setFeeFactor(uint16) external;
    function setFeeToSetter(address) external;
}

// File: contracts/interfaces/IDeerfiV1FeedPair.sol

pragma solidity >=0.5.0;

interface IDeerfiV1FeedPair {
    function factory() external view returns (address);
    function tokenA() external view returns (address);
    function tokenB() external view returns (address);
    function decimalsA() external view returns (uint8);
    function decimalsB() external view returns (uint8);
    function aggregator0() external view returns (address);
    function aggregator1() external view returns (address);
    function decimals0() external view returns (uint8);
    function decimals1() external view returns (uint8);
    function isReverse0() external view returns (bool);
    function isReverse1() external view returns (bool);
    function initialize(address, address, uint8, uint8, address, address, uint8, uint8, bool, bool) external;
    function getReserves() external view returns (uint reserveA, uint reserveB);
}

// File: contracts/interfaces/IDeerfiV1SwapToken.sol

pragma solidity >=0.5.0;

interface IDeerfiV1SwapToken {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function mint(address to, uint value) external returns (bool);
    function burn(address from, uint value) external returns (bool);

    function transferOwnership(address _newOwner) external;
}

// File: contracts/libraries/Ownable.sol

pragma solidity =0.5.16;

/**
 * @title Ownable contract
 * @dev The Ownable contract has an owner address, and provides basic authorization control functions.
 */
contract Ownable {
    address public owner;

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier validAddress(address _address) {
        require(_address != address(0));
        _;
    }

    // Events
    event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);

    /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
    constructor(address _owner) public validAddress(_owner) {
        owner = _owner;
    }

    /// @dev Allows the current owner to transfer control of the contract to a newOwner.
    /// @param _newOwner The address to transfer ownership to.
    function transferOwnership(address _newOwner) public onlyOwner validAddress(_newOwner) {
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}

// File: contracts/DeerfiV1SwapToken.sol

pragma solidity =0.5.16;




contract DeerfiV1SwapToken is IDeerfiV1SwapToken, Ownable {
    using SafeMath for uint;

    string public constant name = 'Deerfi Swap Token';
    string public constant symbol = 'DFT-V1';
    uint8 public constant decimals = 18;
    uint  public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    constructor() Ownable(msg.sender) public {
    }

    function _approve(address owner, address spender, uint value) private {
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _transfer(address from, address to, uint value) private {
        balanceOf[from] = balanceOf[from].sub(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint value) external returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint value) external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) external returns (bool) {
        if (allowance[from][msg.sender] != uint(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        }
        _transfer(from, to, value);
        return true;
    }

    function mint(address to, uint value) external onlyOwner returns (bool) {
        totalSupply = totalSupply.add(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(address(0), to, value);
        return true;
    }

    function burn(address from, uint value) external onlyOwner returns (bool){
        balanceOf[from] = balanceOf[from].sub(value);
        totalSupply = totalSupply.sub(value);
        emit Transfer(from, address(0), value);
        return true;
    }
}

// File: contracts/DeerfiV1Pair.sol

pragma solidity =0.5.16;








contract DeerfiV1Pair is IDeerfiV1Pair, DeerfiV1ERC20 {
    using SafeMath for uint;

    uint public constant MINIMUM_LIQUIDITY = 10**3;
    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
    bytes4 private constant MINT_SELECTOR = bytes4(keccak256(bytes('mint(address,uint256)')));
    bytes4 private constant BURN_SELECTOR = bytes4(keccak256(bytes('burn(address,uint256)')));

    address public factory;
    address public tradeToken;
    address public fromToken;
    address public toToken;
    address public longToken;

    uint256 private reserveTradeToken;  // uses single storage slot, accessible via getReserves

    uint public kLast; // reserveTradeToken, as of immediately after the most recent liquidity event

    uint private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, 'DeerfiV1: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    function getReserves() public view returns (uint256 _reserveTradeToken) {
        _reserveTradeToken = reserveTradeToken;
    }

    function _safeTransfer(address token, address to, uint value) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'DeerfiV1: TRANSFER_FAILED');
    }

    function _safeMint(address token, address to, uint value) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(MINT_SELECTOR, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'DeerfiV1: MINT_FAILED');
    }

    function _safeBurn(address token, address from, uint value) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(BURN_SELECTOR, from, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'DeerfiV1: BURN_FAILED');
    }

    event Mint(address indexed sender, uint amountLiqidity);
    event Burn(address indexed sender, uint amountLiqidity, address indexed to);
    event LongSwap(
        address indexed sender,
        uint amountTradeTokenIn,
        uint amountLongTokenOut,
        address indexed to
    );
    event CloseSwap(
        address indexed sender,
        uint amountLongTokenIn,
        uint amountTradeTokenOut,
        address indexed to
    );
    event Sync(uint256 reserveTradeToken);

    constructor() public {
        factory = msg.sender;
    }

    // calculates the CREATE2 address for a feed pair without making any external calls
    function feedPairFor(address tokenA, address tokenB) internal view returns (address feedPair) {
        feedPair = address(uint(keccak256(abi.encodePacked(
            hex'ff',
            factory,
            keccak256(abi.encodePacked(tokenA, tokenB)),
            hex'b557e6ca017e5e64c7b98af8b844db236b5b74c622e26e209bef1f92d2e5b7df' // init code hash
        ))));
    }

    // called once by the factory at time of deployment
    function initialize(address _tradeToken, address _fromToken, address _toToken, address _longToken) external {
        require(msg.sender == factory, 'DeerfiV1: FORBIDDEN'); // sufficient check
        tradeToken = _tradeToken;
        fromToken = _fromToken;
        toToken = _toToken;
        longToken = _longToken;
    }

    // update reserves and, on the first call per block
    function _update(uint balanceTradeToken) private {
        require(balanceTradeToken <= uint256(-1), 'DeerfiV1: OVERFLOW');
        reserveTradeToken = uint256(balanceTradeToken);
        emit Sync(reserveTradeToken);
    }

    // if fee is on, mint liquidity equivalent to 1/6th of the growth in
    function _mintFee(uint256 rootK) private returns (bool feeOn) {
        address feeTo = IDeerfiV1Factory(factory).feeTo();
        feeOn = feeTo != address(0);
        uint _kLast = kLast; // gas savings
        if (feeOn) {
            if (_kLast != 0) {
                if (rootK > _kLast) {
                    uint numerator = totalSupply.mul(rootK.sub(_kLast));
                    uint denominator = rootK.mul(5).add(_kLast);
                    uint liquidity = numerator / denominator;
                    if (liquidity > 0) _mint(feeTo, liquidity);
                }
            }
        } else if (_kLast != 0) {
            kLast = 0;
        }
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) internal pure returns (uint amountB) {
        require(amountA >= 0, 'DeerfiV1: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'DeerfiV1: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // this low-level function should be called from a contract which performs important safety checks
    function mint(address to) external lock returns (uint liquidity) {
        uint256 _reserveTradeToken = getReserves(); // gas savings
        uint balanceTradeToken = IERC20(tradeToken).balanceOf(address(this));
        uint amountTradeToken = balanceTradeToken.sub(_reserveTradeToken);

        uint256 amountUserTradeToken;
        {
        (uint reserveOut, uint reserveIn) = IDeerfiV1FeedPair(feedPairFor(fromToken, toToken)).getReserves();
        uint amountSwapTokenIn = IERC20(longToken).totalSupply();
        amountUserTradeToken = Math.min(quote(amountSwapTokenIn, reserveIn, reserveOut), _reserveTradeToken);
        }

        bool feeOn = _mintFee(_reserveTradeToken.sub(amountUserTradeToken));
        uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee

        if (_totalSupply == 0 || _reserveTradeToken <= amountUserTradeToken) {
            liquidity = amountTradeToken.sub(MINIMUM_LIQUIDITY);
           _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
        } else {
            liquidity = Math.min(amountTradeToken.mul(_totalSupply) / (_reserveTradeToken.sub(amountUserTradeToken)), amountTradeToken);
        }
        require(liquidity > 0, 'DeerfiV1: INSUFFICIENT_LIQUIDITY_MINTED');
        _mint(to, liquidity);

        _update(balanceTradeToken);
        if (feeOn) kLast = uint(reserveTradeToken.sub(amountUserTradeToken)); // reserve0 and reserve1 are up-to-date
        emit Mint(msg.sender, amountTradeToken);
    }

    // this low-level function should be called from a contract which performs important safety checks
    function burn(address to) external lock returns (uint amountTradeToken) {
        uint256 _reserveTradeToken = getReserves(); // gas savings
        address _tradeToken = tradeToken;           // gas savings
        uint balanceTradeToken = IERC20(_tradeToken).balanceOf(address(this));
        uint liquidity = balanceOf[address(this)];

        uint amountUserTradeToken;
        {
        (uint reserveOut, uint reserveIn) = IDeerfiV1FeedPair(feedPairFor(fromToken, toToken)).getReserves();
        uint amountSwapTokenIn = IERC20(longToken).totalSupply();
        amountUserTradeToken = Math.min(quote(amountSwapTokenIn, reserveIn, reserveOut), _reserveTradeToken);
        }

        bool feeOn = _mintFee(_reserveTradeToken.sub(amountUserTradeToken));
        uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee

        amountTradeToken = liquidity.mul(balanceTradeToken.sub(amountUserTradeToken)) / _totalSupply; // using balances ensures pro-rata distribution
        require(amountTradeToken > 0, 'DeerfiV1: INSUFFICIENT_LIQUIDITY_BURNED');
        _burn(address(this), liquidity);
        _safeTransfer(_tradeToken, to, amountTradeToken);
        balanceTradeToken = IERC20(_tradeToken).balanceOf(address(this));

        _update(balanceTradeToken);
        if (feeOn) kLast = uint(reserveTradeToken.sub(amountUserTradeToken)); // reserve0 and reserve1 are up-to-date
        emit Burn(msg.sender, amountTradeToken, to);
    }

    // this low-level function should be called from a contract which performs important safety checks
    function swap(address to) external lock {
        uint256 _reserveTradeToken = getReserves(); // gas savings

        uint balanceTradeToken;
        uint reserveIn;
        uint reserveOut;
        address _swapToken = longToken;
        { // scope for _token{0,1}, avoids stack too deep errors
        address _tradeToken = tradeToken;
        require(to != _tradeToken, 'DeerfiV1: INVALID_TO');
        (reserveIn, reserveOut) = IDeerfiV1FeedPair(feedPairFor(fromToken, toToken)).getReserves();
        balanceTradeToken = IERC20(_tradeToken).balanceOf(address(this));
        }
        uint amountTradeTokenIn = balanceTradeToken > _reserveTradeToken ? balanceTradeToken.sub(_reserveTradeToken) : 0;
        require(amountTradeTokenIn > 0, 'DeerfiV1: INSUFFICIENT_INPUT_AMOUNT');
        uint16 feeFactor = IDeerfiV1Factory(factory).feeFactor();
        uint amountSwapTokenOut = quote(amountTradeTokenIn, reserveIn, reserveOut).mul(feeFactor) / (1000);
        require(amountSwapTokenOut > 0, 'DeerfiV1: INSUFFICIENT_OUTPUT_AMOUNT');
        _safeMint(_swapToken, to, amountSwapTokenOut); // optimistically mint tokens

        _update(balanceTradeToken);
        emit LongSwap(msg.sender, amountTradeTokenIn, amountSwapTokenOut, to);
    }

    // this low-level function should be called from a contract which performs important safety checks
    function closeSwap(address to) external lock {
        uint amountSwapTokenIn;
        uint reserveIn;
        uint reserveOut;
        address _tradeToken = tradeToken;
        { // scope for _token{0,1}, avoids stack too deep errors
        address _swapToken = longToken;
        require(to != _tradeToken, 'DeerfiV1: INVALID_TO');
        (reserveOut, reserveIn) = IDeerfiV1FeedPair(feedPairFor(fromToken, toToken)).getReserves();
        amountSwapTokenIn = IERC20(_swapToken).balanceOf(address(this));
        require(amountSwapTokenIn > 0, 'DeerfiV1: INSUFFICIENT_INPUT_AMOUNT');
        _safeBurn(_swapToken, address(this), amountSwapTokenIn); // optimistically mint tokens
        }
        uint16 feeFactor = IDeerfiV1Factory(factory).feeFactor();
        uint amountTradeTokenOut = quote(amountSwapTokenIn, reserveIn, reserveOut).mul(feeFactor) / (1000);
        require(amountTradeTokenOut > 0, 'DeerfiV1: INSUFFICIENT_OUTPUT_AMOUNT');
        _safeTransfer(_tradeToken, to, amountTradeTokenOut); // optimistically transfer tokens
        uint balanceTradeToken = IERC20(_tradeToken).balanceOf(address(this));

        _update(balanceTradeToken);
        emit CloseSwap(msg.sender, amountSwapTokenIn, amountTradeTokenOut, to);
    }

    // force balances to match reserves
    function skim(address to) external lock {
        address _tradeToken = tradeToken; // gas savings
        _safeTransfer(_tradeToken, to, IERC20(_tradeToken).balanceOf(address(this)).sub(reserveTradeToken));
    }

    // force reserves to match balances
    function sync() external lock {
        _update(IERC20(tradeToken).balanceOf(address(this)));
    }
}