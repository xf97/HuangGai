/**
 *Submitted for verification at Etherscan.io on 2020-05-10
*/

// MIT License Copyright (c) 2020 iearn

// File: @openzeppelin\contracts\token\ERC20\IERC20.sol

pragma solidity ^0.5.0;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

// File: @openzeppelin\contracts\GSN\Context.sol

pragma solidity ^0.5.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
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

// File: @openzeppelin\contracts\ownership\Ownable.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: @openzeppelin\contracts\math\SafeMath.sol

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

// File: @openzeppelin\contracts\utils\Address.sol

pragma solidity ^0.5.5;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * IMPORTANT: It is unsafe to assume that an address for which this
     * function returns false is an externally-owned account (EOA) and not a
     * contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
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

interface IUniswapROI {
    function calcUniswapROI(address token) external view returns (uint256, uint256);
}

contract IUniswapAPR {
    function getBlocksPerYear() external view returns (uint256);
    function calcUniswapAPRFromROI(uint256 roi, uint256 createdAt) external view returns (uint256);
    function calcUniswapAPR(address token, uint256 createdAt) external view returns (uint256);
}

interface APRWithPoolOracle {

  function getDDEXAPR(address token) external view returns (uint256);
  function getDDEXAPRAdjusted(address token, uint256 _supply) external view returns (uint256);
  function getLENDFAPR(address token) external view returns (uint256);
  function getLENDFAPRAdjusted(address token, uint256 _supply) external view returns (uint256);
  function getCompoundAPR(address token) external view returns (uint256);
  function getCompoundAPRAdjusted(address token, uint256 _supply) external view returns (uint256);
  function getFulcrumAPR(address token) external view returns(uint256);
  function getFulcrumAPRAdjusted(address token, uint256 _supply) external view returns(uint256);
  function getDyDxAPR(uint256 marketId) external view returns(uint256);
  function getDyDxAPRAdjusted(uint256 marketId, uint256 _supply) external view returns(uint256);
  function getAaveCore() external view returns (address);
  function getAaveAPR(address token) external view returns (uint256);
  function getAaveAPRAdjusted(address token, uint256 _supply) external view returns (uint256);

}

interface IUniswapFactory {
    function getExchange(address token) external view returns (address exchange);
}

interface IYToken {
  function calcPoolValueInToken() external view returns (uint256);
  function decimals() external view returns (uint256);
}


contract IEarnAPRWithPool is Ownable {
    using SafeMath for uint;
    using Address for address;

    mapping(address => uint256) public pools;
    mapping(address => address) public compound;
    mapping(address => address) public fulcrum;
    mapping(address => address) public aave;
    mapping(address => address) public aaveUni;
    mapping(address => uint256) public dydx;
    mapping(address => address) public yTokens;

    address public UNI;
    address public UNIROI;
    address public UNIAPR;
    address public APR;

    constructor() public {
        UNI = address(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);
        UNIROI = address(0x90d0F7b0ED00171e6A51f5E7899422E2E76ef9c6);
        UNIAPR = address(0xdEf7978959623fFb12e276DBDa7530eC0Bb6586a);
        APR = address(0x07e80474e6F1690770Cd5337885661A1e6b7Dcd1);

        addPool(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643, 9000629);
        addPool(0xF5DCe57282A584D2746FaF1593d3121Fcac444dC, 7723867);
        addPool(0x6B175474E89094C44Da98b954EedeAC495271d0F, 8939330);
        addPool(0x0000000000085d4780B73119b644AE5ecd22b376, 7794100);
        addPool(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 6783192);
        addPool(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51, 8623684);
        addPool(0x0D8775F648430679A709E98d2b0Cb6250d2887EF, 6660894);
        addPool(0x514910771AF9Ca656af840dff83E8264EcF986CA, 6627987);
        addPool(0xdd974D5C2e2928deA5F71b9825b8b646686BD200, 6627984);
        addPool(0x1985365e9f78359a9B6AD760e32412f4a445E862, 6627994);
        addPool(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2, 6627956);
        addPool(0xE41d2489571d322189246DaFA5ebDe1F4699F498, 6627972);
        addPool(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F, 8314762);
        addPool(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, 7004537);

        addCToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643); // cDAI
        addCToken(0x0D8775F648430679A709E98d2b0Cb6250d2887EF, 0x6C8c6b02E7b2BE14d4fA6022Dfd6d75921D90E4E); // cBAT
        addCToken(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5); // cETH
        addCToken(0x1985365e9f78359a9B6AD760e32412f4a445E862, 0x158079Ee67Fce2f58472A96584A73C7Ab9AC95c1); // cREP
        addCToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 0x39AA39c021dfbaE8faC545936693aC917d5E7563); // cUSDC
        addCToken(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, 0xC11b1268C1A384e55C48c2391d8d480264A3A7F4); // cWBTC
        addCToken(0xE41d2489571d322189246DaFA5ebDe1F4699F498, 0xB3319f5D18Bc0D84dD1b4825Dcde5d5f7266d407); // cZRX


        addAToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, 0x6B175474E89094C44Da98b954EedeAC495271d0F); // aDAI
        addAToken(0x0000000000085d4780B73119b644AE5ecd22b376, 0x0000000000085d4780B73119b644AE5ecd22b376); // aTUSD
        addAToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48); // aUSDC
        addAToken(0xdAC17F958D2ee523a2206206994597C13D831ec7, 0xdAC17F958D2ee523a2206206994597C13D831ec7); // aUSDT
        addAToken(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51, 0x57Ab1ec28D129707052df4dF418D58a2D46d5f51); // aSUSD
        addAToken(0x80fB784B7eD66730e8b1DBd9820aFD29931aab03, 0x80fB784B7eD66730e8b1DBd9820aFD29931aab03); // aLEND
        addAToken(0x0D8775F648430679A709E98d2b0Cb6250d2887EF, 0x0D8775F648430679A709E98d2b0Cb6250d2887EF); // aBAT
        addAToken(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE); // aETH
        addAToken(0x514910771AF9Ca656af840dff83E8264EcF986CA, 0x514910771AF9Ca656af840dff83E8264EcF986CA); // aLINK
        addAToken(0xdd974D5C2e2928deA5F71b9825b8b646686BD200, 0xdd974D5C2e2928deA5F71b9825b8b646686BD200); // aKNC
        addAToken(0x1985365e9f78359a9B6AD760e32412f4a445E862, 0x1985365e9f78359a9B6AD760e32412f4a445E862); // aREP
        addAToken(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2, 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2); // aMKR
        addAToken(0x0F5D2fB29fb7d3CFeE444a200298f468908cC942, 0x0F5D2fB29fb7d3CFeE444a200298f468908cC942); // aMANA
        addAToken(0xE41d2489571d322189246DaFA5ebDe1F4699F498, 0xE41d2489571d322189246DaFA5ebDe1F4699F498); // aZRX
        addAToken(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F, 0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F); // aSNX
        addAToken(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599); // aWBTC

        addAUniToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, 0xfC1E690f61EFd961294b3e1Ce3313fBD8aa4f85d); // aDAI
        addAUniToken(0x0000000000085d4780B73119b644AE5ecd22b376, 0x4DA9b813057D04BAef4e5800E36083717b4a0341); // aTUSD
        addAUniToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 0x9bA00D6856a4eDF4665BcA2C2309936572473B7E); // aUSDC
        addAUniToken(0xdAC17F958D2ee523a2206206994597C13D831ec7, 0x71fc860F7D3A592A4a98740e39dB31d25db65ae8); // aUSDT
        addAUniToken(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51, 0x625aE63000f46200499120B906716420bd059240); // aSUSD
        addAUniToken(0x80fB784B7eD66730e8b1DBd9820aFD29931aab03, 0x7D2D3688Df45Ce7C552E19c27e007673da9204B8); // aLEND
        addAUniToken(0x0D8775F648430679A709E98d2b0Cb6250d2887EF, 0xE1BA0FB44CCb0D11b80F92f4f8Ed94CA3fF51D00); // aBAT
        addAUniToken(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, 0x3a3A65aAb0dd2A17E3F1947bA16138cd37d08c04); // aETH
        addAUniToken(0x514910771AF9Ca656af840dff83E8264EcF986CA, 0xA64BD6C70Cb9051F6A9ba1F163Fdc07E0DfB5F84); // aLINK
        addAUniToken(0xdd974D5C2e2928deA5F71b9825b8b646686BD200, 0x9D91BE44C06d373a8a226E1f3b146956083803eB); // aKNC
        addAUniToken(0x1985365e9f78359a9B6AD760e32412f4a445E862, 0x71010A9D003445aC60C4e6A7017c1E89A477B438); // aREP
        addAUniToken(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2, 0x7deB5e830be29F91E298ba5FF1356BB7f8146998); // aMKR
        addAUniToken(0x0F5D2fB29fb7d3CFeE444a200298f468908cC942, 0x6FCE4A401B6B80ACe52baAefE4421Bd188e76F6f); // aMANA
        addAUniToken(0xE41d2489571d322189246DaFA5ebDe1F4699F498, 0x6Fb0855c404E09c47C3fBCA25f08d4E41f9F062f); // aZRX
        addAUniToken(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F, 0x328C4c80BC7aCa0834Db37e6600A6c49E12Da4DE); // aSNX
        addAUniToken(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, 0xFC4B8ED459e00e5400be803A9BB3954234FD50e3); // aWBTC

        addIToken(0xE41d2489571d322189246DaFA5ebDe1F4699F498, 0xA7Eb2bc82df18013ecC2A6C533fc29446442EDEe); // iZRX
        addIToken(0x1985365e9f78359a9B6AD760e32412f4a445E862, 0xBd56E9477Fc6997609Cf45F84795eFbDAC642Ff1); // iREP
        addIToken(0xdd974D5C2e2928deA5F71b9825b8b646686BD200, 0x1cC9567EA2eB740824a45F8026cCF8e46973234D); // iKNC
        addIToken(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, 0xBA9262578EFef8b3aFf7F60Cd629d6CC8859C8b5); // iWBTC
        addIToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 0xF013406A0B1d544238083DF0B93ad0d2cBE0f65f); // iUSDC
        addIToken(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, 0x77f973FCaF871459aa58cd81881Ce453759281bC); // iETH
        addIToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, 0x493C57C4763932315A328269E1ADaD09653B9081); // iDAI
        addIToken(0x514910771AF9Ca656af840dff83E8264EcF986CA, 0x1D496da96caf6b518b133736beca85D5C4F9cBc5); // iLINK
        addIToken(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51, 0x49f4592E641820e928F9919Ef4aBd92a719B4b49); // iSUSD

        addDToken(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, 0); // dETH
        addDToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 2); // dUSDC
        addDToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, 3); // dDAI

        addYToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, 0x9D25057e62939D3408406975aD75Ffe834DA4cDd); // yDAI
        addYToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 0xa2609B2b43AC0F5EbE27deB944d2a399C201E3dA); // yUSDC
        addYToken(0xdAC17F958D2ee523a2206206994597C13D831ec7, 0xa1787206d5b1bE0f432C4c4f96Dc4D1257A1Dd14); // yUSDT
        addYToken(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51, 0x36324b8168f960A12a8fD01406C9C78143d41380); // ySUSD
        addYToken(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, 0x04EF8121aD039ff41d10029c91EA1694432514e9); // yWBTC

    }

    // Wrapper for legacy v1 token support
    function recommend(address _token) public view returns (
      string memory choice,
      uint256 capr,
      uint256 iapr,
      uint256 aapr,
      uint256 dapr
    ) {
      ( , capr, , iapr, , aapr, , dapr, , ) = getAPROptionsInc(_token);
      return (choice, capr, iapr, aapr, dapr);
    }

    function getAPROptionsInc(address _token) public view returns (
      uint256 _uniswap,
      uint256 _compound,
      uint256 _unicompound,
      uint256 _fulcrum,
      uint256 _unifulcrum,
      uint256 _aave,
      uint256 _uniaave,
      uint256 _dydx,
      uint256 _ddex,
      uint256 _lendf
    ) {
      address yToken = yTokens[_token];
      uint256 _supply = 0;
      if (yToken != address(0)) {
        _supply = IYToken(yToken).calcPoolValueInToken();
      }
      return getAPROptionsAdjusted(_token, _supply);
    }

    function getAPROptions(address _token) public view returns (
      uint256 _uniswap,
      uint256 _compound,
      uint256 _unicompound,
      uint256 _fulcrum,
      uint256 _unifulcrum,
      uint256 _aave,
      uint256 _uniaave,
      uint256 _dydx,
      uint256 _ddex,
      uint256 _lendf
    ) {
      return getAPROptionsAdjusted(_token, 0);
    }

    function getAPROptionsAdjusted(address _token, uint256 _supply) public view returns (
      uint256 _uniswap,
      uint256 _compound,
      uint256 _unicompound,
      uint256 _fulcrum,
      uint256 _unifulcrum,
      uint256 _aave,
      uint256 _uniaave,
      uint256 _dydx,
      uint256 _ddex,
      uint256 _lendf
    ) {
      uint256 created = pools[_token];

      if (created > 0) {
        _uniswap = IUniswapAPR(UNIAPR).calcUniswapAPR(_token, created);
      }
      address addr = compound[_token];
      if (addr != address(0)) {
        _compound = APRWithPoolOracle(APR).getCompoundAPR(addr);
        created = pools[addr];
        if (created > 0) {
          _unicompound = IUniswapAPR(UNIAPR).calcUniswapAPR(addr, created);
        }
      }
      addr = fulcrum[_token];
      if (addr != address(0)) {
        _fulcrum = APRWithPoolOracle(APR).getFulcrumAPRAdjusted(addr, _supply);
        created = pools[addr];
        if (created > 0) {
          _unifulcrum = IUniswapAPR(UNIAPR).calcUniswapAPR(addr, created);
        }
      }
      addr = aave[_token];
      if (addr != address(0)) {
        _aave = APRWithPoolOracle(APR).getAaveAPRAdjusted(addr, _supply);
        addr = aaveUni[_token];
        created = pools[addr];
        if (created > 0) {
          _uniaave = IUniswapAPR(UNIAPR).calcUniswapAPR(addr, created);
        }
      }

      _dydx = dydx[_token];
      if (_dydx > 0 || _token == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)) {
        _dydx = APRWithPoolOracle(APR).getDyDxAPRAdjusted(_dydx, _supply);
      }

      _ddex = APRWithPoolOracle(APR).getDDEXAPRAdjusted(_token, _supply);
      _lendf = APRWithPoolOracle(APR).getLENDFAPRAdjusted(_token, _supply);

      return (
        _uniswap,
        _compound,
        _unicompound,
        _fulcrum,
        _unifulcrum,
        _aave,
        _uniaave,
        _dydx,
        _ddex,
        _lendf
      );
    }

    function viewPool(address _token) public view returns (
      address token,
      address unipool,
      uint256 created,
      string memory name,
      string memory symbol
    ) {
      token = _token;
      unipool = IUniswapFactory(UNI).getExchange(_token);
      created = pools[_token];
      name = IERC20(_token).name();
      symbol = IERC20(_token).symbol();
      return (token, unipool, created, name, symbol);
    }

    function addPool(
      address token,
      uint256 created
    ) public onlyOwner {
        pools[token] = created;
    }

    function addCToken(
      address token,
      address cToken
    ) public onlyOwner {
        compound[token] = cToken;
    }

    function addIToken(
      address token,
      address iToken
    ) public onlyOwner {
        fulcrum[token] = iToken;
    }

    function addAToken(
      address token,
      address aToken
    ) public onlyOwner {
        aave[token] = aToken;
    }

    function addAUniToken(
      address token,
      address aToken
    ) public onlyOwner {
        aaveUni[token] = aToken;
    }

    function addYToken(
      address token,
      address yToken
    ) public onlyOwner {
        yTokens[token] = yToken;
    }

    function addDToken(
      address token,
      uint256 dToken
    ) public onlyOwner {
        dydx[token] = dToken;
    }

    function set_new_UNIROI(address _new_UNIROI) public onlyOwner {
        UNIROI = _new_UNIROI;
    }
    function set_new_UNI(address _new_UNI) public onlyOwner {
        UNI = _new_UNI;
    }
    function set_new_UNIAPR(address _new_UNIAPR) public onlyOwner {
        UNIAPR = _new_UNIAPR;
    }
    function set_new_APR(address _new_APR) public onlyOwner {
        APR = _new_APR;
    }

    // incase of half-way error
    function inCaseTokenGetsStuck(IERC20 _TokenAddress) onlyOwner public {
        uint qty = _TokenAddress.balanceOf(address(this));
        _TokenAddress.transfer(msg.sender, qty);
    }
    // incase of half-way error
    function inCaseETHGetsStuck() onlyOwner public{
        (bool result, ) = msg.sender.call.value(address(this).balance)("");
        require(result, "transfer of ETH failed");
    }
}