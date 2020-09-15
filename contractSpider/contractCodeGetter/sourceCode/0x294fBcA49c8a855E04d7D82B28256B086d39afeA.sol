/**
 *Submitted for verification at Etherscan.io on 2020-06-17
*/

// File: @openzeppelin/contracts/utils/Address.sol

pragma solidity ^0.5.5;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
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
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// File: @openzeppelin/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
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

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
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

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol

pragma solidity ^0.5.0;




/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
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

// File: localhost/contracts/Config.sol

pragma solidity ^0.5.0;


contract Config {
    // function signature of "postProcess()"
    bytes4 constant POSTPROCESS_SIG = 0xc2722916;

    // Handler post-process type. Others should not happen now.
    enum HandlerType {Token, Custom, Others}
}

// File: localhost/contracts/lib/LibCache.sol

pragma solidity ^0.5.0;


library LibCache {
    function setAddress(bytes32[] storage _cache, address _input) internal {
        _cache.push(bytes32(uint256(uint160(_input))));
    }

    function set(bytes32[] storage _cache, bytes32 _input) internal {
        _cache.push(_input);
    }

    function setHandlerType(bytes32[] storage _cache, uint256 _input) internal {
        require(_input < uint96(-1), "Invalid Handler Type");
        _cache.push(bytes12(uint96(_input)));
    }

    function setSender(bytes32[] storage _cache, address _input) internal {
        require(_cache.length == 0, "cache not empty");
        setAddress(_cache, _input);
    }

    function getAddress(bytes32[] storage _cache)
        internal
        returns (address ret)
    {
        ret = address(uint160(uint256(peek(_cache))));
        _cache.pop();
    }

    function getSig(bytes32[] storage _cache) internal returns (bytes4 ret) {
        ret = bytes4(peek(_cache));
        _cache.pop();
    }

    function get(bytes32[] storage _cache) internal returns (bytes32 ret) {
        ret = peek(_cache);
        _cache.pop();
    }

    function peek(bytes32[] storage _cache)
        internal
        view
        returns (bytes32 ret)
    {
        require(_cache.length > 0, "cache empty");
        ret = _cache[_cache.length - 1];
    }

    function getSender(bytes32[] storage _cache)
        internal
        returns (address ret)
    {
        require(_cache.length > 0, "cache empty");
        ret = address(uint160(uint256(_cache[0])));
    }
}

// File: localhost/contracts/Cache.sol

pragma solidity ^0.5.0;



/// @notice A cache structure composed by a bytes32 array
contract Cache {
    using LibCache for bytes32[];

    bytes32[] cache;

    modifier isCacheEmpty() {
        require(cache.length == 0, "Cache not empty");
        _;
    }
}

// File: localhost/contracts/handlers/HandlerBase.sol

pragma solidity ^0.5.0;




contract HandlerBase is Cache, Config {
    function postProcess() external payable {
        revert("Invalid post process");
        /* Implementation template
        bytes4 sig = cache.getSig();
        if (sig == bytes4(keccak256(bytes("handlerFunction_1()")))) {
            // Do something
        } else if (sig == bytes4(keccak256(bytes("handlerFunction_2()")))) {
            bytes32 temp = cache.get();
            // Do something
        } else revert("Invalid post process");
        */
    }

    function _updateToken(address token) internal {
        cache.setAddress(token);
        // Ignore token type to fit old handlers
        // cache.setHandlerType(uint256(HandlerType.Token));
    }

    function _updatePostProcess(bytes32[] memory params) internal {
        for (uint256 i = params.length; i > 0; i--) {
            cache.set(params[i - 1]);
        }
        cache.set(msg.sig);
        cache.setHandlerType(uint256(HandlerType.Custom));
    }
}

// File: localhost/contracts/handlers/maker/IMaker.sol

pragma solidity ^0.5.0;

interface IMakerManager {
    function cdpCan(address, uint, address) external view returns (uint);
    function ilks(uint) external view returns (bytes32);
    function owns(uint) external view returns (address);
    function urns(uint) external view returns (address);
    function vat() external view returns (address);
    function open(bytes32, address) external returns (uint);
    function give(uint, address) external;
    function cdpAllow(uint, address, uint) external;
    function urnAllow(address, uint) external;
    function frob(uint, int, int) external;
    function flux(uint, address, uint) external;
    function move(uint, address, uint) external;
    function exit(address, uint, address, uint) external;
    function quit(uint, address) external;
    function enter(address, uint) external;
    function shift(uint, uint) external;

    function count(address) external view returns (uint256);
    function first(address) external view returns (uint256);
    function last(address) external view returns (uint256);
}

interface IMakerVat {
    function can(address, address) external view returns (uint);
    function ilks(bytes32) external view returns (uint, uint, uint, uint, uint);
    function dai(address) external view returns (uint);
    function urns(bytes32, address) external view returns (uint, uint);
    function frob(bytes32, address, address, address, int, int) external;
    function hope(address) external;
    function move(address, address, uint) external;
}

interface IMakerGemJoin {
    function dec() external returns (uint);
    function gem() external returns (address);
    function join(address, uint) external payable;
    function exit(address, uint) external;
}

// File: localhost/contracts/handlers/maker/IDSProxy.sol

pragma solidity ^0.5.0;

interface IDSProxy {
    function execute(address _target, bytes calldata _data) external payable returns (bytes32 response);
}

interface IDSProxyFactory {
    function isProxy(address proxy) external view returns (bool);
    function build() external returns (address);
    function build(address owner) external returns (address);
}

interface IDSProxyRegistry {
    function proxies(address input) external returns (address);
    function build() external returns (address);
    function build(address owner) external returns (address);
}

// File: localhost/contracts/handlers/maker/HMaker.sol

pragma solidity ^0.5.0;






contract HMaker is HandlerBase {
    using SafeERC20 for IERC20;

    address constant PROXY_ACTIONS = 0x82ecD135Dce65Fbc6DbdD0e4237E0AF93FFD5038;
    address constant CDP_MANAGER = 0x5ef30b9986345249bc32d8928B7ee64DE9435E39;
    address constant PROXY_REGISTRY = 0x4678f0a6958e4D2Bc4F1BAF7Bc52E8F3564f3fE4;
    address constant MCD_JUG = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
    address constant DAI_TOKEN = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    modifier cdpAllowed(uint256 cdp) {
        IMakerManager manager = IMakerManager(CDP_MANAGER);
        address owner = manager.owns(cdp);
        address sender = cache.getSender();
        require(
            IDSProxyRegistry(PROXY_REGISTRY).proxies(sender) == owner ||
                manager.cdpCan(owner, cdp, sender) == 1,
            "Unauthorized sender of cdp"
        );
        _;
    }

    function openLockETHAndDraw(
        uint256 value,
        address ethJoin,
        address daiJoin,
        bytes32 ilk,
        uint256 wadD
    ) external payable returns (uint256 cdp) {
        IDSProxy proxy = IDSProxy(_getProxy(address(this)));
        cdp = uint256(
            proxy.execute.value(value)(
                PROXY_ACTIONS,
                abi.encodeWithSelector(
                    // selector of "openLockETHAndDraw(address,address,address,address,bytes32,uint256)"
                    0xe685cc04,
                    CDP_MANAGER,
                    MCD_JUG,
                    ethJoin,
                    daiJoin,
                    ilk,
                    wadD
                )
            )
        );

        // Update post process
        bytes32[] memory params = new bytes32[](1);
        params[0] = bytes32(cdp);
        _updatePostProcess(params);
    }

    function openLockGemAndDraw(
        address gemJoin,
        address daiJoin,
        bytes32 ilk,
        uint256 wadC,
        uint256 wadD
    ) external payable returns (uint256 cdp) {
        IDSProxy proxy = IDSProxy(_getProxy(address(this)));
        address token = IMakerGemJoin(gemJoin).gem();
        IERC20(token).safeApprove(address(proxy), wadC);
        cdp = uint256(
            proxy.execute(
                PROXY_ACTIONS,
                abi.encodeWithSelector(
                    // selector of "openLockGemAndDraw(address,address,address,address,bytes32,uint256,uint256,bool)"
                    0xdb802a32,
                    CDP_MANAGER,
                    MCD_JUG,
                    gemJoin,
                    daiJoin,
                    ilk,
                    wadC,
                    wadD,
                    true
                )
            )
        );
        IERC20(token).safeApprove(address(proxy), 0);

        // Update post process
        bytes32[] memory params = new bytes32[](1);
        params[0] = bytes32(cdp);
        _updatePostProcess(params);
    }

    function safeLockETH(
        uint256 value,
        address ethJoin,
        uint256 cdp
    ) external payable {
        IDSProxy proxy = IDSProxy(_getProxy(address(this)));
        address owner = _getProxy(cache.getSender());
        proxy.execute.value(value)(
            PROXY_ACTIONS,
            abi.encodeWithSelector(
                // selector of "safeLockETH(address,address,uint256,address)"
                0xee284576,
                CDP_MANAGER,
                ethJoin,
                cdp,
                owner
            )
        );
    }

    function safeLockGem(
        address gemJoin,
        uint256 cdp,
        uint256 wad
    ) external payable {
        IDSProxy proxy = IDSProxy(_getProxy(address(this)));
        address owner = _getProxy(cache.getSender());
        address token = IMakerGemJoin(gemJoin).gem();
        IERC20(token).safeApprove(address(proxy), wad);
        proxy.execute(
            PROXY_ACTIONS,
            abi.encodeWithSelector(
                // selector of "safeLockGem(address,address,uint256,uint256,bool,address)"
                0xead64729,
                CDP_MANAGER,
                gemJoin,
                cdp,
                wad,
                true,
                owner
            )
        );
        IERC20(token).safeApprove(address(proxy), 0);
    }

    function freeETH(
        address ethJoin,
        uint256 cdp,
        uint256 wad
    ) external payable cdpAllowed(cdp) {
        // Check msg.sender authority
        IDSProxy proxy = IDSProxy(_getProxy(address(this)));
        proxy.execute(
            PROXY_ACTIONS,
            abi.encodeWithSelector(
                // selector of "freeETH(address,address,uint256,uint256)"
                0x7b5a3b43,
                CDP_MANAGER,
                ethJoin,
                cdp,
                wad
            )
        );
    }

    function freeGem(
        address gemJoin,
        uint256 cdp,
        uint256 wad
    ) external payable cdpAllowed(cdp) {
        // Check msg.sender authority
        IDSProxy proxy = IDSProxy(_getProxy(address(this)));
        address token = IMakerGemJoin(gemJoin).gem();
        proxy.execute(
            PROXY_ACTIONS,
            abi.encodeWithSelector(
                // selector of "freeGem(address,address,uint256,uint256)"
                0x6ab6a491,
                CDP_MANAGER,
                gemJoin,
                cdp,
                wad
            )
        );

        // Update post process
        _updateToken(token);
    }

    function draw(
        address daiJoin,
        uint256 cdp,
        uint256 wad
    ) external payable cdpAllowed(cdp) {
        // Check msg.sender authority
        IDSProxy proxy = IDSProxy(_getProxy(address(this)));
        proxy.execute(
            PROXY_ACTIONS,
            abi.encodeWithSelector(
                // selector of "draw(address,address,address,uint256,uint256)"
                0x9f6f3d5b,
                CDP_MANAGER,
                MCD_JUG,
                daiJoin,
                cdp,
                wad
            )
        );

        // Update post process
        _updateToken(DAI_TOKEN);
    }

    function wipe(
        address daiJoin,
        uint256 cdp,
        uint256 wad
    ) external payable {
        IDSProxy proxy = IDSProxy(_getProxy(address(this)));
        IERC20(DAI_TOKEN).safeApprove(address(proxy), wad);
        proxy.execute(
            PROXY_ACTIONS,
            abi.encodeWithSelector(
                // selector of "wipe(address,address,uint256,uint256)"
                0x4b666199,
                CDP_MANAGER,
                daiJoin,
                cdp,
                wad
            )
        );
        IERC20(DAI_TOKEN).safeApprove(address(proxy), 0);
    }

    function wipeAll(address daiJoin, uint256 cdp) external payable {
        IDSProxy proxy = IDSProxy(_getProxy(address(this)));
        IERC20(DAI_TOKEN).safeApprove(address(proxy), uint256(-1));
        proxy.execute(
            PROXY_ACTIONS,
            abi.encodeWithSelector(
                // selector of "wipeAll(address,address,uint256)"
                0x036a2395,
                CDP_MANAGER,
                daiJoin,
                cdp
            )
        );
        IERC20(DAI_TOKEN).safeApprove(address(proxy), 0);
    }

    function postProcess() external payable {
        bytes4 sig = cache.getSig();
        // selector of openLockETHAndDraw(uint256,address,address,bytes32,uint256)
        // and openLockGemAndDraw(address,address,bytes32,uint256,uint256)
        if (sig == 0x5481e4a4 || sig == 0x73af24e7) {
            _transferCdp(uint256(cache.get()));
            uint256 amount = IERC20(DAI_TOKEN).balanceOf(address(this));
            if (amount > 0)
                IERC20(DAI_TOKEN).safeTransfer(cache.getSender(), amount);
        } else revert("Invalid post process");
    }

    function _getProxy(address user) internal returns (address) {
        return IDSProxyRegistry(PROXY_REGISTRY).proxies(user);
    }

    function _transferCdp(uint256 cdp) internal {
        IDSProxy proxy = IDSProxy(_getProxy(address(this)));
        proxy.execute(
            PROXY_ACTIONS,
            abi.encodeWithSelector(
                // selector of "giveToProxy(address,address,uint256,address)"
                0x493c2049,
                PROXY_REGISTRY,
                CDP_MANAGER,
                cdp,
                cache.getSender()
            )
        );
    }
}