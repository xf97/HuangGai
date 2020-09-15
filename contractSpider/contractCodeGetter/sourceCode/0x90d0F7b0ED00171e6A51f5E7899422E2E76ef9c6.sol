/**
 *Submitted for verification at Etherscan.io on 2020-05-10
*/

// MIT License Copyright (c) 2020 iearn

// File: @openzeppelin\contracts\token\ERC20\IERC20.sol

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

pragma solidity ^0.5.0;

interface IUniswapFactory {
    function getExchange(address token) external view returns (address exchange);
}

interface IUniswapExchange {
    function totalSupply() external view returns (uint256);
}

contract UniswapAPR is Ownable {
    using SafeMath for uint;
    using Address for address;

    address public UNI;

    // Ease of use functions, can also use generic lookups for new tokens
    address public CDAI;
    address public CBAT;
    address public CETH;
    address public CREP;
    address public CSAI;
    address public CUSDC;
    address public CWBTC;
    address public CZRX;

    address public IZRX;
    address public IREP;
    address public IKNC;
    address public IBAT;
    address public IWBTC;
    address public IUSDC;
    address public IETH;
    address public ISAI;
    address public IDAI;
    address public ILINK;
    address public ISUSD;

    address public ADAI;
    address public ATUSD;
    address public AUSDC;
    address public AUSDT;
    address public ASUSD;
    address public ALEND;
    address public ABAT;
    address public AETH;
    address public ALINK;
    address public AKNC;
    address public AREP;
    address public AMKR;
    address public AMANA;
    address public AZRX;
    address public ASNX;
    address public AWBTC;

    address public DAI;
    address public TUSD;
    address public USDC;
    address public USDT;
    address public SUSD;
    address public LEND;
    address public BAT;
    address public ETH;
    address public LINK;
    address public KNC;
    address public REP;
    address public MKR;
    address public MANA;
    address public ZRX;
    address public SNX;
    address public WBTC;

    constructor() public {
        UNI = address(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);

        CDAI = address(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
        CBAT = address(0x6C8c6b02E7b2BE14d4fA6022Dfd6d75921D90E4E);
        CETH = address(0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5);
        CREP = address(0x158079Ee67Fce2f58472A96584A73C7Ab9AC95c1);
        CSAI = address(0xF5DCe57282A584D2746FaF1593d3121Fcac444dC);
        CUSDC = address(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
        CWBTC = address(0xC11b1268C1A384e55C48c2391d8d480264A3A7F4);
        CZRX = address(0xB3319f5D18Bc0D84dD1b4825Dcde5d5f7266d407);

        IZRX = address(0xA7Eb2bc82df18013ecC2A6C533fc29446442EDEe);
        IREP = address(0xBd56E9477Fc6997609Cf45F84795eFbDAC642Ff1);
        IKNC = address(0x1cC9567EA2eB740824a45F8026cCF8e46973234D);
        IWBTC = address(0xBA9262578EFef8b3aFf7F60Cd629d6CC8859C8b5);
        IUSDC = address(0xF013406A0B1d544238083DF0B93ad0d2cBE0f65f);
        IETH = address(0x77f973FCaF871459aa58cd81881Ce453759281bC);
        ISAI = address(0x14094949152EDDBFcd073717200DA82fEd8dC960);
        IDAI = address(0x493C57C4763932315A328269E1ADaD09653B9081);
        ILINK = address(0x1D496da96caf6b518b133736beca85D5C4F9cBc5);
        ISUSD = address(0x49f4592E641820e928F9919Ef4aBd92a719B4b49);

        ADAI = address(0xfC1E690f61EFd961294b3e1Ce3313fBD8aa4f85d);
        ATUSD = address(0x4DA9b813057D04BAef4e5800E36083717b4a0341);
        AUSDC = address(0x9bA00D6856a4eDF4665BcA2C2309936572473B7E);
        AUSDT = address(0x71fc860F7D3A592A4a98740e39dB31d25db65ae8);
        ASUSD = address(0x625aE63000f46200499120B906716420bd059240);
        ALEND = address(0x7D2D3688Df45Ce7C552E19c27e007673da9204B8);
        ABAT = address(0xE1BA0FB44CCb0D11b80F92f4f8Ed94CA3fF51D00);
        AETH = address(0x3a3A65aAb0dd2A17E3F1947bA16138cd37d08c04);
        ALINK = address(0xA64BD6C70Cb9051F6A9ba1F163Fdc07E0DfB5F84);
        AKNC = address(0x9D91BE44C06d373a8a226E1f3b146956083803eB);
        AREP = address(0x71010A9D003445aC60C4e6A7017c1E89A477B438);
        AMKR = address(0x7deB5e830be29F91E298ba5FF1356BB7f8146998);
        AMANA = address(0x6FCE4A401B6B80ACe52baAefE4421Bd188e76F6f);
        AZRX = address(0x6Fb0855c404E09c47C3fBCA25f08d4E41f9F062f);
        ASNX = address(0x328C4c80BC7aCa0834Db37e6600A6c49E12Da4DE);
        AWBTC = address(0xFC4B8ED459e00e5400be803A9BB3954234FD50e3);

        DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        TUSD = address(0x0000000000085d4780B73119b644AE5ecd22b376);
        USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        USDT = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
        SUSD = address(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);
        LEND = address(0x80fB784B7eD66730e8b1DBd9820aFD29931aab03);
        BAT = address(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
        ETH = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
        LINK = address(0x514910771AF9Ca656af840dff83E8264EcF986CA);
        KNC = address(0xdd974D5C2e2928deA5F71b9825b8b646686BD200);
        REP = address(0x1985365e9f78359a9B6AD760e32412f4a445E862);
        MKR = address(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2);
        MANA = address(0x0F5D2fB29fb7d3CFeE444a200298f468908cC942);
        ZRX = address(0xE41d2489571d322189246DaFA5ebDe1F4699F498);
        SNX = address(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F);
        WBTC = address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
    }

    function getCDAIUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(CDAI);
    }
    function getCBATUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(CBAT);
    }
    function getCETHUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(CETH);
    }
    function getCREPUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(CREP);
    }
    function getCSAIUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(CSAI);
    }
    function getCUSDCUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(CUSDC);
    }
    function getCWBTCUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(CWBTC);
    }
    function getCZRXUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(CZRX);
    }


    function getIZRXUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(IZRX);
    }
    function getIREPUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(IREP);
    }
    function getIKNCUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(IKNC);
    }
    function getIWBTCUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(IWBTC);
    }
    function getIUSDCUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(IUSDC);
    }
    function getIETHUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(IETH);
    }
    function getISAIUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(ISAI);
    }
    function getIDAIUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(IDAI);
    }
    function getILINKUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(ILINK);
    }
    function getISUSDUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(ISUSD);
    }

    function getADAIUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(ADAI);
    }
    function getATUSDUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(ATUSD);
    }
    function getAUSDCUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(AUSDC);
    }
    function getAUSDTUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(AUSDT);
    }
    function getASUSDUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(ASUSD);
    }
    function getALENDUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(ALEND);
    }
    function getABATUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(ABAT);
    }
    function getAETHUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(AETH);
    }
    function getALINKUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(ALINK);
    }
    function getAKNCUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(AKNC);
    }
    function getAREPUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(AREP);
    }
    function getAMKRUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(AMKR);
    }
    function getAMANAUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(AMANA);
    }
    function getAZRXUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(AZRX);
    }
    function getASNXUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(ASNX);
    }
    function getAWBTCUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(AWBTC);
    }

    function getDAIUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(DAI);
    }
    function getTUSDUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(TUSD);
    }
    function getUSDCUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(USDC);
    }
    function getUSDTUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(USDT);
    }
    function getSUSDUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(SUSD);
    }
    function getLENDUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(LEND);
    }
    function getBATUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(BAT);
    }
    function getETHUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(ETH);
    }
    function getLINKUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(LINK);
    }
    function getKNCUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(KNC);
    }
    function getREPUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(REP);
    }
    function getMKRUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(MKR);
    }
    function getMANAUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(MANA);
    }
    function getZRXUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(ZRX);
    }
    function getSNXUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(SNX);
    }
    function getWBTCUniROI() public view returns (uint256, uint256) {
      return calcUniswapROI(WBTC);
    }

    function calcUniswapROI(address token) public view returns (uint256, uint256) {
        IUniswapFactory factory = IUniswapFactory(UNI);
        IUniswapExchange exchange = IUniswapExchange(factory.getExchange(token));

        uint totalShares = exchange.totalSupply();
        uint ethBalance = address(exchange).balance;
        uint ret = 0;
        if (ethBalance > 10) {
          ret = ethBalance.mul(1000).div(totalShares);
        }
        return (ret, ethBalance);
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