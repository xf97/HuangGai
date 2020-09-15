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

interface IUniswapROI {

    function getCDAIUniROI() external view returns (uint256, uint256);
    function getCBATUniROI() external view returns (uint256, uint256);
    function getCETHUniROI() external view returns (uint256, uint256);
    function getCREPUniROI() external view returns (uint256, uint256);
    function getCSAIUniROI() external view returns (uint256, uint256);
    function getCUSDCUniROI() external view returns (uint256, uint256);
    function getCWBTCUniROI() external view returns (uint256, uint256);
    function getCZRXUniROI() external view returns (uint256, uint256);


    function getIZRXUniROI() external view returns (uint256, uint256);
    function getIREPUniROI() external view returns (uint256, uint256);
    function getIKNCUniROI() external view returns (uint256, uint256);
    function getIWBTCUniROI() external view returns (uint256, uint256);
    function getIUSDCUniROI() external view returns (uint256, uint256);
    function getIETHUniROI() external view returns (uint256, uint256);
    function getISAIUniROI() external view returns (uint256, uint256);
    function getIDAIUniROI() external view returns (uint256, uint256);
    function getILINKUniROI() external view returns (uint256, uint256);
    function getISUSDUniROI() external view returns (uint256, uint256);

    function getADAIUniROI() external view returns (uint256, uint256);
    function getATUSDUniROI() external view returns (uint256, uint256);
    function getAUSDCUniROI() external view returns (uint256, uint256);
    function getAUSDTUniROI() external view returns (uint256, uint256);
    function getASUSDUniROI() external view returns (uint256, uint256);
    function getALENDUniROI() external view returns (uint256, uint256);
    function getABATUniROI() external view returns (uint256, uint256);
    function getAETHUniROI() external view returns (uint256, uint256);
    function getALINKUniROI() external view returns (uint256, uint256);
    function getAKNCUniROI() external view returns (uint256, uint256);
    function getAREPUniROI() external view returns (uint256, uint256);
    function getAMKRUniROI() external view returns (uint256, uint256);
    function getAMANAUniROI() external view returns (uint256, uint256);
    function getAZRXUniROI() external view returns (uint256, uint256);
    function getASNXUniROI() external view returns (uint256, uint256);
    function getAWBTCUniROI() external view returns (uint256, uint256);

    function getDAIUniROI() external view returns (uint256, uint256);
    function getTUSDUniROI() external view returns (uint256, uint256);
    function getUSDCUniROI() external view returns (uint256, uint256);
    function getUSDTUniROI() external view returns (uint256, uint256);
    function getSUSDUniROI() external view returns (uint256, uint256);
    function getLENDUniROI() external view returns (uint256, uint256);
    function getBATUniROI() external view returns (uint256, uint256);
    function getETHUniROI() external view returns (uint256, uint256);
    function getLINKUniROI() external view returns (uint256, uint256);
    function getKNCUniROI() external view returns (uint256, uint256);
    function getREPUniROI() external view returns (uint256, uint256);
    function getMKRUniROI() external view returns (uint256, uint256);
    function getMANAUniROI() external view returns (uint256, uint256);
    function getZRXUniROI() external view returns (uint256, uint256);
    function getSNXUniROI() external view returns (uint256, uint256);
    function getWBTCUniROI() external view returns (uint256, uint256);

    function calcUniswapROI(address token) external view returns (uint256, uint256);
}


contract UniswapAPR is Ownable {
    using SafeMath for uint;
    using Address for address;

    uint256 public ADAICreateAt;
    uint256 public CDAICreateAt;
    uint256 public CETHCreateAt;
    uint256 public CSAICreateAt;
    uint256 public CUSDCCreateAt;
    uint256 public DAICreateAt;
    uint256 public IDAICreateAt;
    uint256 public ISAICreateAt;
    uint256 public SUSDCreateAt;
    uint256 public TUSDCreateAt;
    uint256 public USDCCreateAt;
    uint256 public CHAICreateAt;

    address public UNIROI;
    address public CHAI;

    uint256 public blocksPerYear;

    constructor() public {
      ADAICreateAt = 9248529;
      CDAICreateAt = 9000629;
      CETHCreateAt = 7716382;
      CSAICreateAt = 7723867;
      CUSDCCreateAt = 7869920;
      DAICreateAt = 8939330;
      IDAICreateAt = 8975121;
      ISAICreateAt = 8362506;
      SUSDCreateAt = 8623684;
      TUSDCreateAt = 7794100;
      USDCCreateAt = 6783192;
      CHAICreateAt = 9028682;

      UNIROI = address(0x90d0F7b0ED00171e6A51f5E7899422E2E76ef9c6);
      CHAI = address(0x6C3942B383bc3d0efd3F36eFa1CBE7C8E12C8A2B);
      blocksPerYear = 2102400;
    }


    function set_new_UNIROI(address _new_UNIROI) public onlyOwner {
        UNIROI = _new_UNIROI;
    }
    function set_new_CHAI(address _new_CHAI) public onlyOwner {
        CHAI = _new_CHAI;
    }

    function set_new_blocksPerYear(uint256 _new_blocksPerYear) public onlyOwner {
        blocksPerYear = _new_blocksPerYear;
    }

    function getBlocksPerYear() public view returns (uint256) {
      return blocksPerYear;
    }

    function calcUniswapAPRADAI() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getADAIUniROI();
      return (calcUniswapAPRFromROI(roi, ADAICreateAt), liquidity);
    }
    function calcUniswapAPRCDAI() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getCDAIUniROI();
      return (calcUniswapAPRFromROI(roi, CDAICreateAt), liquidity);
    }
    function calcUniswapAPRCETH() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getCETHUniROI();
      return (calcUniswapAPRFromROI(roi, CETHCreateAt), liquidity);
    }
    function calcUniswapAPRCSAI() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getCSAIUniROI();
      return (calcUniswapAPRFromROI(roi, CSAICreateAt), liquidity);
    }
    function calcUniswapAPRCUSDC() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getCUSDCUniROI();
      return (calcUniswapAPRFromROI(roi, CUSDCCreateAt), liquidity);
    }
    function calcUniswapAPRDAI() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getDAIUniROI();
      return (calcUniswapAPRFromROI(roi, DAICreateAt), liquidity);
    }
    function calcUniswapAPRIDAI() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getIDAIUniROI();
      return (calcUniswapAPRFromROI(roi, IDAICreateAt), liquidity);
    }
    function calcUniswapAPRISAI() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getISAIUniROI();
      return (calcUniswapAPRFromROI(roi, ISAICreateAt), liquidity);
    }
    function calcUniswapAPRSUSD() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getSUSDUniROI();
      return (calcUniswapAPRFromROI(roi, SUSDCreateAt), liquidity);
    }
    function calcUniswapAPRTUSD() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getTUSDUniROI();
      return (calcUniswapAPRFromROI(roi, TUSDCreateAt), liquidity);
    }
    function calcUniswapAPRUSDC() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getUSDCUniROI();
      return (calcUniswapAPRFromROI(roi, USDCCreateAt), liquidity);
    }
    function calcUniswapAPRCHAI() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).calcUniswapROI(CHAI);
      return (calcUniswapAPRFromROI(roi, CHAICreateAt), liquidity);
    }

    function calcUniswapAPRFromROI(uint256 roi, uint256 createdAt) public view returns (uint256) {
      require(createdAt < block.number, "invalid createAt block");
      uint256 roiFrom = block.number.sub(createdAt);
      uint256 baseAPR = roi.mul(1e15).mul(blocksPerYear).div(roiFrom);
      uint256 adjusted = blocksPerYear.mul(1e18).div(roiFrom);
      return baseAPR.add(1e18).sub(adjusted);
    }

    function calcUniswapAPR(address token, uint256 createdAt) public view returns (uint256) {
      require(createdAt < block.number, "invalid createAt block");
      // ROI returned as shifted 1e4
      (uint256 roi,) = IUniswapROI(UNIROI).calcUniswapROI(token);
      uint256 roiFrom = block.number.sub(createdAt);
      uint256 baseAPR = roi.mul(1e15).mul(blocksPerYear).div(roiFrom);
      uint256 adjusted = blocksPerYear.mul(1e18).div(roiFrom);
      return baseAPR.add(1e18).sub(adjusted);
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