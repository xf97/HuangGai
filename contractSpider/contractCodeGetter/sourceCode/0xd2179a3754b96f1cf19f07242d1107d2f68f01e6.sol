/**
 *Submitted for verification at Etherscan.io on 2020-06-13
*/

// File: contracts/interfaces/IIdleRebalancerV3.sol

/**
 * @title: Idle Rebalancer interface
 * @author: Idle Labs Inc., idle.finance
 */
pragma solidity 0.5.16;

interface IIdleRebalancerV3 {
  function getAllocations() external view returns (uint256[] memory _allocations);
}

// File: @openzeppelin/contracts/GSN/Context.sol

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

// File: @openzeppelin/contracts/ownership/Ownable.sol

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

// File: contracts/IdleRebalancerV3SUSD.sol

/**
 * @title: Idle Rebalancer contract
 * @summary: Used for calculating amounts to lend on each implemented protocol.
 *           This implementation works with Compound and Fulcrum only,
 *           when a new protocol will be added this should be replaced
 * @author: Idle Labs Inc., idle.finance
 */
pragma solidity 0.5.16;




contract IdleRebalancerV3SUSD is IIdleRebalancerV3, Ownable {
  using SafeMath for uint256;
  uint256[] public lastAmounts;
  address[] public lastAmountsAddresses;
  address public rebalancerManager;
  address public idleToken;

  /**
   * @param _aToken : aToken address
   * @param _rebalancerManager : rebalancerManager address
   */
  constructor(address _aToken, address _rebalancerManager) public {
    require(_aToken != address(0) && _rebalancerManager != address(0), 'some addr is 0');
    rebalancerManager = _rebalancerManager;

    // Initially 100% on first lending protocol
    lastAmounts = [100000];
    lastAmountsAddresses = [_aToken];
  }

  /**
   * Throws if called by any account other than rebalancerManager.
   */
  modifier onlyRebalancerAndIdle() {
    require(msg.sender == rebalancerManager || msg.sender == idleToken, "Only rebalacer and IdleToken");
    _;
  }

  /**
   * It allows owner to set the allowed rebalancer address
   *
   * @param _rebalancerManager : rebalance manager address
   */
  function setRebalancerManager(address _rebalancerManager)
    external onlyOwner {
      require(_rebalancerManager != address(0), "_rebalancerManager addr is 0");

      rebalancerManager = _rebalancerManager;
  }

  function setIdleToken(address _idleToken)
    external onlyOwner {
      require(idleToken == address(0), "idleToken addr already set");
      require(_idleToken != address(0), "_idleToken addr is 0");
      idleToken = _idleToken;
  }

  /**
   * It adds a new token address to lastAmountsAddresses list
   *
   * @param _newToken : new interest bearing token address
   */
  function setNewToken(address _newToken)
    external onlyOwner {
      require(_newToken != address(0), "New token should be != 0");
      for (uint256 i = 0; i < lastAmountsAddresses.length; i++) {
        if (lastAmountsAddresses[i] == _newToken) {
          return;
        }
      }

      lastAmountsAddresses.push(_newToken);
      lastAmounts.push(0);
  }
  // end onlyOwner

  /**
   * Used by Rebalance manager to set the new allocations
   *
   * @param _allocations : array with allocations in percentages (100% => 100000)
   * @param _addresses : array with addresses of tokens used, should be equal to lastAmountsAddresses
   */
  function setAllocations(uint256[] calldata _allocations, address[] calldata _addresses)
    external onlyRebalancerAndIdle
  {
    require(_allocations.length == lastAmounts.length, "Alloc lengths are different, allocations");
    require(_allocations.length == _addresses.length, "Alloc lengths are different, addresses");

    uint256 total;
    for (uint256 i = 0; i < _allocations.length; i++) {
      require(_addresses[i] == lastAmountsAddresses[i], "Addresses do not match");
      total = total.add(_allocations[i]);
      lastAmounts[i] = _allocations[i];
    }
    require(total == 100000, "Not allocating 100%");
  }

  function getAllocations()
    external view returns (uint256[] memory _allocations) {
    return lastAmounts;
  }

  function getAllocationsLength()
    external view returns (uint256) {
    return lastAmounts.length;
  }
}