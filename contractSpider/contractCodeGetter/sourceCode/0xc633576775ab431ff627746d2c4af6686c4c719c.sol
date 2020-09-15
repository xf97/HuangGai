/**
 *Submitted for verification at Etherscan.io on 2020-05-17
*/

/**
 *Submitted for verification at Etherscan.io on 2020-02-25
*/

pragma solidity ^0.5.12;

library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
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
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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

interface IERC20 {
    function balanceOf   (address)                external view returns (uint256);
    function approve     (address, uint256)       external      returns (bool);
    function transferFrom(address, address, uint) external      returns (bool);
    function transfer    (address, uint256)       external      returns (bool);
}

interface IGateway {
    function mint(bytes32 _pHash, uint256 _amount, bytes32 _nHash, bytes calldata _sig) external returns (uint256);
    function burn(bytes calldata _to, uint256 _amount) external returns (uint256);
}

interface IGatewayRegistry {
    function getGatewayBySymbol(string calldata _tokenSymbol) external view returns (IGateway);
    function getGatewayByToken(address  _tokenAddress) external view returns (IGateway);
    function getTokenBySymbol(string calldata _tokenSymbol) external view returns (IERC20);
}

interface ICurveExchange {
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
    function get_dy(int128, int128 j, uint256 dx) external view returns (uint256);
}

contract DirectBTCProxy {

    function borrow(
        address _owner, // CDP owner (if they do not own a CDP, one will be created).
        int     _dink,  // Amount of WBTC to collateralize (18 decimals).
        int     _dart   // Amount of Dai to borrow (18 decimals).
    ) external;

    function repay(
        address _owner, // CDP owner
        int     _dink,  // Amount of WBTC to reclaim (with 18 decimal places).
        int     _dart   // Amount of Dai to repay
    ) external;
}

contract WBTCCDPProxy {
    using SafeMath for uint256;

    IGatewayRegistry public registry;
    IERC20           public dai;
    IERC20           public wbtc;
    IERC20           public renbtc;
    DirectBTCProxy   public directProxy;
    ICurveExchange   public exchange; 

    mapping (address => bytes) btcAddrs;

    constructor(
        address _registry,
        address _dai,
        address _wbtc,
        address _directProxy,
        ICurveExchange _exchange
    ) public {
        registry    = IGatewayRegistry(_registry);
        dai         = IERC20(_dai);
        wbtc        = IERC20(_wbtc);
        renbtc      = registry.getTokenBySymbol('BTC');
        directProxy = DirectBTCProxy(_directProxy);
        exchange    = ICurveExchange(_exchange);
        
        // Approve exchange.
        require(wbtc.approve(address(exchange), uint256(-1)));
        require(renbtc.approve(address(exchange), uint256(-1)));
    }

    // TODO: test me
    function mintDai(
        // User params
        uint256     _dart,
        bytes calldata _btcAddr,
        uint256 _minWbtcAmount,

        // Darknode params
        uint256        _amount, // Amount of renBTC.
        bytes32        _nHash,  // Nonce hash.
        bytes calldata _sig     // Minting signature. TODO: understand better
    ) external {
        // Finish the lock-and-mint cross-chain transaction using the minting
        // signature produced by RenVM.
        
        // TODO: read the IGateway code
        uint256 amount = registry.getGatewayBySymbol("BTC").mint(
            keccak256(abi.encode(msg.sender, _dart, _btcAddr, _minWbtcAmount)), 
            _amount, 
            _nHash, 
            _sig
        );
        
        // Get price
        uint256 proceeds = exchange.get_dy(0, 1, amount);
        
        // Price is OK
        if (proceeds >= _minWbtcAmount) {
            uint256 startWbtcBalance = wbtc.balanceOf(address(this));
            exchange.exchange(0, 1, amount, _minWbtcAmount);
            uint256 wbtcBought = wbtc.balanceOf(address(this)).sub(startWbtcBalance);

            require(
                wbtc.transfer(address(directProxy), wbtcBought),
                "err: transfer failed"
            );

            directProxy.borrow(
                msg.sender,
                int(wbtcBought * (10 ** 10)),
                int(_dart)
            );

            btcAddrs[msg.sender] = _btcAddr;
        } else {
            // Send renBTC to the User instead
            renbtc.transfer(msg.sender, amount);
        }
    }

    // TODO: test me
    function burnDai(
        // User params
        uint256 _dink,  // Amount of WBTC (with  8 decimal places)
        uint256 _dart,   // Amount of DAI  (with 18 decimal places)
        uint256 _minRenbtcAmount
    ) external {
        // get DAI from the msg.sender (requires msg.sender to approve)
        require(
            dai.transferFrom(msg.sender, address(this), _dart),
            "err: transferFrom dai"
        );

        // send DAI to the directProxy
        require(
            dai.transfer(address(directProxy), _dart),
            "err: transfer dai"
        );

        // proxy through to the direct proxy.
        directProxy.repay(
            msg.sender,
            int(_dink) * (10 ** 10),
            int(_dart)
        );
        
        // Get renBTC
        uint256 startRenbtcBalance = renbtc.balanceOf(address(this));
        exchange.exchange(1, 0, _dink, _minRenbtcAmount);
        uint256 endRenbtcBalance = renbtc.balanceOf(address(this));
        uint256 renbtcBought = endRenbtcBalance.sub(startRenbtcBalance);

        // Initiate the burn-and-release cross-chain transaction,
        // after which RenVM will finish the cross-chain
        // transaction by releasing BTC to the specified to address.
        // TODO: consider rewriting how we get the shifter (constructor)
        registry.getGatewayBySymbol("BTC").burn(btcAddrs[msg.sender], renbtcBought);
    }
}