/**
 *Submitted for verification at Etherscan.io on 2020-08-07
*/

// File: contracts/SafeMath.sol

pragma solidity ^0.6.0;


library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "sa");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "se");
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "me");

        return c;
    }
}

// File: contracts/ERC20.sol

pragma solidity ^0.6.12;



contract ERC20 {
    using SafeMath for uint256;

    event  Approval(address indexed src, address indexed guy, uint wad);
    event  Transfer(address indexed src, address indexed dst, uint wad);

    uint256 public totalSupply;

    mapping (address => uint)                       public  balanceOf;
    mapping (address => mapping (address => uint))  public  allowance;

    function mint(address guy, uint256 wad) internal {
        balanceOf[guy] = balanceOf[guy].add(wad);
        totalSupply = totalSupply.add(wad);
        emit Transfer(address(0), guy, wad);
    }

    function approve(address guy, uint wad) external returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint wad) external returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public
        returns (bool)
    {
        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
            allowance[src][msg.sender] = allowance[src][msg.sender].sub(wad);
        }

        balanceOf[src] = balanceOf[src].sub(wad);
        balanceOf[dst] = balanceOf[dst].add(wad);

        emit Transfer(src, dst, wad);

        return true;
    }
}

// File: contracts/WETH.sol

pragma solidity ^0.6.12;


contract WETH {
    string public name     = "Wrapped Ether";
    string public symbol   = "WETH";
    uint8  public decimals = 18;

    event  Approval(address indexed src, address indexed guy, uint wad);
    event  Transfer(address indexed src, address indexed dst, uint wad);
    event  Deposit(address indexed dst, uint wad);
    event  Withdrawal(address indexed src, uint wad);

    mapping (address => uint)                       public  balanceOf;
    mapping (address => mapping (address => uint))  public  allowance;

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint wad) public {
        require(balanceOf[msg.sender] >= wad, "not enough");
        balanceOf[msg.sender] -= wad;
        msg.sender.transfer(wad);
        emit Withdrawal(msg.sender, wad);
    }

    function totalSupply() public view returns (uint) {
        return address(this).balance;
    }

    function approve(address guy, uint wad) public returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public
        returns (bool)
    {
        require(balanceOf[src] >= wad, "little balance");

        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
            require(allowance[src][msg.sender] >= wad, "not allowed");
            allowance[src][msg.sender] -= wad;
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        emit Transfer(src, dst, wad);

        return true;
    }
}

// File: contracts/Auction.sol

pragma solidity ^0.6.12;





contract Auction {
    using SafeMath for uint256;

    uint256 public immutable FROM_PRICE;
    uint256 public immutable DURATION;
    uint256 public immutable MIN_START;

    WETH public immutable WRAPPED_ETH;
    ERC20 public immutable HOARD;

    uint256 public started;

    uint256 private unlocked = 1;
    modifier lock() {
        require(unlocked == 1);
        unlocked = 0;
        _;
        unlocked = 1;
    }

    constructor(
        address _weth,
        uint256 _minWait,
        uint256 _fromPrice,
        uint256 _duration,
        address _hoard
    ) public {
        WRAPPED_ETH = WETH(address(uint160(_weth)));
        MIN_START = block.timestamp + _minWait;
        FROM_PRICE = _fromPrice;
        DURATION = _duration;
        HOARD = ERC20(_hoard);
    }

    function start() external lock {
        require(block.timestamp > MIN_START, "wait");

        uint256 balance = address(this).balance;

        require(balance != 0, "empty");
        require(started == 0, "on");

        WRAPPED_ETH.deposit.value(balance)();
        started = block.timestamp;
    }

    function stop() external lock {
        require(started != 0, "off");

        uint256 delta = block.timestamp - started;
        require(delta >= DURATION || WRAPPED_ETH.balanceOf(address(this)) == 0, "on");

        delete started;
    }

    function price(uint256 offer, uint256 delta) public view returns (uint256) {
        return offer.mul(DURATION.sub(delta)).mul(FROM_PRICE) / (DURATION * 1 ether);
    }

    function take(uint256 _val) external lock {
        uint256 _started = started;
        require(_started != 0, "not");

        uint256 delta = block.timestamp - _started;
        require(delta < DURATION, "old");

        uint256 balance = WRAPPED_ETH.balanceOf(address(this));
        uint256 offer = balance < _val ? balance : _val;

        uint256 cost = price(offer, delta);
        require(HOARD.transferFrom(msg.sender, address(1), cost), "s1e");
        require(WRAPPED_ETH.transfer(msg.sender, offer), "s2e");
    }

    receive() external payable {}
}

// File: contracts/Poof.sol

pragma solidity ^0.6.12;





contract Poof is ERC20 {
    using SafeMath for uint256;

    string public constant name     = "Poof.eth";
    string public constant symbol   = "POOF";
    uint8  public constant decimals = 18;

    event Poof();
    event NotPoof(address _win, uint256 _total);

    WETH private immutable WRAPPED_ETH;

    uint256 private constant PERIOD = 1 hours;
    uint256 private constant SLOPE = 256;

    uint256 private constant BASE = 100;
    uint256 private constant FEE = 10;

    address private immutable FEE_RECIPIENT_1;
    address private immutable FEE_RECIPIENT_2;

    uint256 private constant INIT_MIN = 0.1 ether;
    uint256 private constant DUST = 0.00001 ether;

    uint256 private constant SHIFT_LOOPS = 232;
    uint256 private constant SHIFT_PLAYS = 208;
    uint256 private constant SHIFT_LAST = 160;

    bytes32 private constant MASK_PLAYS = bytes32((2 ** uint256(24)) - 1);
    bytes32 private constant MASK_LAST = bytes32((2 ** uint256(48)) - 1);
    bytes32 private constant MASK_HEAD = bytes32((2 ** uint256(160)) - 1);

    bytes32 internal p_data;

    function sortTokens(address _tokenA, address _tokenB) private pure returns (address token0, address token1) {
        (token0, token1) = _tokenA < _tokenB ? (_tokenA, _tokenB) : (_tokenB, _tokenA);
    }

    function pairFor(
        address _factory,
        address _tokenA,
        address _tokenB
    ) private pure returns (address pair) {
        (address token0, address token1) = sortTokens(_tokenA, _tokenB);
        pair = address(uint256(keccak256(abi.encodePacked(
            hex'ff',
            _factory,
            keccak256(abi.encodePacked(token0, token1)),
            hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f'
        ))));
    }

    constructor(
        address _factory,
        address _shuf,
        address _weth,
        uint256 _minWait,
        uint256 _fromPrice,
        uint256 _duration
    ) public payable {
        address hoard_1 = pairFor(_factory, _weth, _shuf);
        address hoard_2 = pairFor(_factory, _weth, address(this));

        FEE_RECIPIENT_1 = address(new Auction(_weth, _minWait, _fromPrice, _duration, hoard_1));
        FEE_RECIPIENT_2 = address(new Auction(_weth, _minWait, _fromPrice, _duration, hoard_2));

        WRAPPED_ETH = WETH(address(uint160(_weth)));
        setData(address(this), block.timestamp, 0, 1);
    }

    function getData() public view returns (
        address head,
        uint256 last,
        uint256 plays,
        uint256 loops
    ) {
        bytes32 data = p_data;

        head = address(uint160(uint256(data & MASK_HEAD)));
        last = uint256((data >> SHIFT_LAST) & MASK_LAST);
        plays = uint256((data >> SHIFT_PLAYS) & MASK_PLAYS);
        loops = uint256(data >> SHIFT_LOOPS);
    }

    function setData(address _head, uint256 _last, uint256 _plays, uint256 _loops) private {
        p_data = (
            (bytes32(uint256(_head)) & MASK_HEAD) |
            ((bytes32(_last) & MASK_LAST) << SHIFT_LAST) |
            ((bytes32(_plays) & MASK_PLAYS) << SHIFT_PLAYS) |
            (bytes32(_loops) << SHIFT_LOOPS)
        );
    }

    function costFor(uint256 _plays, uint256 _delta) public pure returns (uint256) {
        uint256 start = INIT_MIN + ((INIT_MIN * _plays) / SLOPE);
        return DUST + ((start * (PERIOD - _delta)) / PERIOD);
    }

    receive() external payable {
        (
            address head,
            uint256 last,
            uint256 plays,
            uint256 loops
        ) = getData();

        uint256 delta = block.timestamp.sub(last);

        if (delta <= PERIOD) {
            uint256 cost = costFor(plays, delta);
            require(msg.value >= cost, "more (￣﹃￣)");

            setData(msg.sender, block.timestamp, plays + 1, loops);
            mint(head, 1 ether / loops);

            emit Poof();

            msg.sender.call{ value: msg.value - cost }("");
            return;
        }

        require(msg.value == 0, "wait");

        uint256 total = address(this).balance;
        uint256 fee = total.mul(FEE) / BASE;

        (bool success1,) = FEE_RECIPIENT_1.call{ value: fee}("");
        (bool success2,) = FEE_RECIPIENT_2.call{ value: fee}("");
        require(success1 && success2, "Error sending fees");

        emit NotPoof(head, total);

        setData(address(this), block.timestamp, 0, loops + 1);

        if (head != address(this)) {
            uint256 send = address(this).balance.sub(fee);
            WRAPPED_ETH.deposit.value(send)();
            WRAPPED_ETH.transfer(head, send);
        }
    }
}