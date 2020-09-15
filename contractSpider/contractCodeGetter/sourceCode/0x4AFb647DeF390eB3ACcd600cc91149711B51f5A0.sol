/**
 *Submitted for verification at Etherscan.io on 2020-06-06
*/

// File: @openzeppelin/upgrades/contracts/Initializable.sol

pragma solidity >=0.4.24 <0.7.0;


/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

// File: contracts/ReentrancyGuardEmber.sol

pragma solidity ^0.5.0;


/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 */
contract ReentrancyGuardEmber is Initializable {
    // counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    function initialize() public initializer {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }

    uint256[50] private ______gap;
}

// File: @openzeppelin/upgrades/contracts/cryptography/ECDSA.sol

pragma solidity ^0.5.2;

/**
 * @title Elliptic curve signature operations
 * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
 * TODO Remove this library once solidity supports passing a signature to ecrecover.
 * See https://github.com/ethereum/solidity/issues/864
 *
 * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/79dd498b16b957399f84b9aa7e720f98f9eb83e3/contracts/cryptography/ECDSA.sol
 * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
 * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
 * build/artifacts folder) as well as the vanilla implementation from an openzeppelin version.
 */

library OpenZeppelinUpgradesECDSA {
    /**
     * @dev Recover signer address from a message by using their signature
     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
     * @param signature bytes signature, the signature is generated using web3.eth.sign()
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        // Check the signature length
        if (signature.length != 65) {
            return (address(0));
        }

        // Divide the signature in r, s and v variables
        bytes32 r;
        bytes32 s;
        uint8 v;

        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solhint-disable-next-line no-inline-assembly
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return address(0);
        }

        if (v != 27 && v != 28) {
            return address(0);
        }

        // If the signature is valid (and not malleable), return the signer address
        return ecrecover(hash, v, r, s);
    }

    /**
     * toEthSignedMessageHash
     * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
     * and hash the result
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}

// File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol

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
contract Context is Initializable {
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

// File: @openzeppelin/contracts-ethereum-package/contracts/access/Roles.sol

pragma solidity ^0.5.0;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

// File: @openzeppelin/contracts-ethereum-package/contracts/access/roles/WhitelistAdminRole.sol

pragma solidity ^0.5.0;




/**
 * @title WhitelistAdminRole
 * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
 */
contract WhitelistAdminRole is Initializable, Context {
    using Roles for Roles.Role;

    event WhitelistAdminAdded(address indexed account);
    event WhitelistAdminRemoved(address indexed account);

    Roles.Role private _whitelistAdmins;

    function initialize(address sender) public initializer {
        if (!isWhitelistAdmin(sender)) {
            _addWhitelistAdmin(sender);
        }
    }

    modifier onlyWhitelistAdmin() {
        require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
        _;
    }

    function isWhitelistAdmin(address account) public view returns (bool) {
        return _whitelistAdmins.has(account);
    }

    function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
        _addWhitelistAdmin(account);
    }

    function renounceWhitelistAdmin() public {
        _removeWhitelistAdmin(_msgSender());
    }

    function _addWhitelistAdmin(address account) internal {
        _whitelistAdmins.add(account);
        emit WhitelistAdminAdded(account);
    }

    function _removeWhitelistAdmin(address account) internal {
        _whitelistAdmins.remove(account);
        emit WhitelistAdminRemoved(account);
    }

    uint256[50] private ______gap;
}

// File: contracts/access/roles/WhitelistedRoleEmber.sol

pragma solidity ^0.5.0;






// import "./WhitelistAdminRoleEmber.sol";

/**
 * @title WhitelistedRole
 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
 * it), and not Whitelisteds themselves.
 */
contract WhitelistedRoleEmber is Initializable, Context, WhitelistAdminRole {
    using Roles for Roles.Role;

    event WhitelistedAdded(address indexed account);
    event WhitelistedRemoved(address indexed account);

    Roles.Role private _whitelisteds;

    modifier onlyWhitelisted() {
        require(isWhitelisted(_msgSender()), "WhitelistedRole: caller does not have the Whitelisted role");
        _;
    }

    function initialize(address sender) public initializer {
        WhitelistAdminRole.initialize(sender);
    }

    function isWhitelisted(address account) public view returns (bool) {
        return _whitelisteds.has(account);
    }

    function addWhitelisted(address account) public onlyWhitelistAdmin {
        _addWhitelisted(account);
    }

    function addSignedWhitelisted(address account, bytes memory signature) public {
        address signer = getWhitelistedRoleActionSigner('addSignedWhitelisted', account, signature);
        require(signer != address(0), "Invalid signature");
        require(isWhitelistAdmin(signer), "signer is not an admin");
        _addWhitelisted(account);
    }

    function addSignedWhitelistAdmin(address account, bytes memory signature) public {
        address signer = getWhitelistedRoleActionSigner('addSignedWhitelistAdmin', account, signature);
        require(signer != address(0), "Invalid signature");
        require(isWhitelistAdmin(signer), "signer is not an admin");
        _addWhitelistAdmin(account);
    }

    function getWhitelistedRoleActionSigner(string memory action, address account, bytes memory _signature) private view returns (address) {
      bytes32 msgHash = OpenZeppelinUpgradesECDSA.toEthSignedMessageHash(
      keccak256(
          abi.encodePacked(
            action,
            account,
            address(this)
          )
        )
      );
      return OpenZeppelinUpgradesECDSA.recover(msgHash, _signature);
    }

    function removeWhitelisted(address account) public onlyWhitelistAdmin {
        _removeWhitelisted(account);
    }

    function renounceWhitelisted() public {
        _removeWhitelisted(_msgSender());
    }

    function _addWhitelisted(address account) internal {
        _whitelisteds.add(account);
        emit WhitelistedAdded(account);
    }

    function _removeWhitelisted(address account) internal {
        _whitelisteds.remove(account);
        emit WhitelistedRemoved(account);
    }

    uint256[50] private ______gap;
}

// File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 *
 * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
 * metering changes introduced in the Istanbul hardfork.
 */
contract ReentrancyGuard {
    bool private _notEntered;

    constructor () internal {
        // Storing an initial non-zero value makes deployment a bit more
        // expensive, but in exchange the refund on every call to nonReentrant
        // will be lower in amount. Since refunds are capped to a percetange of
        // the total transaction's gas, it is best to keep them low in cases
        // like this one, to increase the likelihood of the full refund coming
        // into effect.
        _notEntered = true;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_notEntered, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _notEntered = false;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _notEntered = true;
    }
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

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

// File: set-protocol-contracts/contracts/lib/CommonMath.sol

/*
    Copyright 2018 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;



library CommonMath {
    using SafeMath for uint256;

    uint256 public constant SCALE_FACTOR = 10 ** 18;
    uint256 public constant MAX_UINT_256 = 2 ** 256 - 1;

    /**
     * Returns scale factor equal to 10 ** 18
     *
     * @return  10 ** 18
     */
    function scaleFactor()
        internal
        pure
        returns (uint256)
    {
        return SCALE_FACTOR;
    }

    /**
     * Calculates and returns the maximum value for a uint256
     *
     * @return  The maximum value for uint256
     */
    function maxUInt256()
        internal
        pure
        returns (uint256)
    {
        return MAX_UINT_256;
    }

    /**
     * Increases a value by the scale factor to allow for additional precision
     * during mathematical operations
     */
    function scale(
        uint256 a
    )
        internal
        pure
        returns (uint256)
    {
        return a.mul(SCALE_FACTOR);
    }

    /**
     * Divides a value by the scale factor to allow for additional precision
     * during mathematical operations
    */
    function deScale(
        uint256 a
    )
        internal
        pure
        returns (uint256)
    {
        return a.div(SCALE_FACTOR);
    }

    /**
    * @dev Performs the power on a specified value, reverts on overflow.
    */
    function safePower(
        uint256 a,
        uint256 pow
    )
        internal
        pure
        returns (uint256)
    {
        require(a > 0);

        uint256 result = 1;
        for (uint256 i = 0; i < pow; i++){
            uint256 previousResult = result;

            // Using safemath multiplication prevents overflows
            result = previousResult.mul(a);
        }

        return result;
    }

    /**
    * @dev Performs division where if there is a modulo, the value is rounded up
    */
    function divCeil(uint256 a, uint256 b)
        internal
        pure
        returns(uint256)
    {
        return a.mod(b) > 0 ? a.div(b).add(1) : a.div(b);
    }

    /**
     * Checks for rounding errors and returns value of potential partial amounts of a principal
     *
     * @param  _principal       Number fractional amount is derived from
     * @param  _numerator       Numerator of fraction
     * @param  _denominator     Denominator of fraction
     * @return uint256          Fractional amount of principal calculated
     */
    function getPartialAmount(
        uint256 _principal,
        uint256 _numerator,
        uint256 _denominator
    )
        internal
        pure
        returns (uint256)
    {
        // Get remainder of partial amount (if 0 not a partial amount)
        uint256 remainder = mulmod(_principal, _numerator, _denominator);

        // Return if not a partial amount
        if (remainder == 0) {
            return _principal.mul(_numerator).div(_denominator);
        }

        // Calculate error percentage
        uint256 errPercentageTimes1000000 = remainder.mul(1000000).div(_numerator.mul(_principal));

        // Require error percentage is less than 0.1%.
        require(
            errPercentageTimes1000000 < 1000,
            "CommonMath.getPartialAmount: Rounding error exceeds bounds"
        );

        return _principal.mul(_numerator).div(_denominator);
    }
    
    /*
     * Gets the rounded up log10 of passed value
     *
     * @param  _value         Value to calculate ceil(log()) on
     * @return uint256        Output value
     */
    function ceilLog10(
        uint256 _value
    )
        internal
        pure 
        returns (uint256)
    {
        // Make sure passed value is greater than 0
        require (
            _value > 0,
            "CommonMath.ceilLog10: Value must be greater than zero."
        );

        // Since log10(1) = 0, if _value = 1 return 0
        if (_value == 1) return 0;

        // Calcualte ceil(log10())
        uint256 x = _value - 1;

        uint256 result = 0;

        if (x >= 10 ** 64) {
            x /= 10 ** 64;
            result += 64;
        }
        if (x >= 10 ** 32) {
            x /= 10 ** 32;
            result += 32;
        }
        if (x >= 10 ** 16) {
            x /= 10 ** 16;
            result += 16;
        }
        if (x >= 10 ** 8) {
            x /= 10 ** 8;
            result += 8;
        }
        if (x >= 10 ** 4) {
            x /= 10 ** 4;
            result += 4;
        }
        if (x >= 100) {
            x /= 100;
            result += 2;
        }
        if (x >= 10) {
            result += 1;
        }

        return result + 1;
    }
}

// File: set-protocol-contracts/contracts/lib/AddressArrayUtils.sol

// Pulled in from Cryptofin Solidity package in order to control Solidity compiler version
// https://github.com/cryptofinlabs/cryptofin-solidity/blob/master/contracts/array-utils/AddressArrayUtils.sol

pragma solidity 0.5.7;


library AddressArrayUtils {

    /**
     * Finds the index of the first occurrence of the given element.
     * @param A The input array to search
     * @param a The value to find
     * @return Returns (index and isIn) for the first occurrence starting from index 0
     */
    function indexOf(address[] memory A, address a) internal pure returns (uint256, bool) {
        uint256 length = A.length;
        for (uint256 i = 0; i < length; i++) {
            if (A[i] == a) {
                return (i, true);
            }
        }
        return (0, false);
    }

    /**
    * Returns true if the value is present in the list. Uses indexOf internally.
    * @param A The input array to search
    * @param a The value to find
    * @return Returns isIn for the first occurrence starting from index 0
    */
    function contains(address[] memory A, address a) internal pure returns (bool) {
        bool isIn;
        (, isIn) = indexOf(A, a);
        return isIn;
    }

    /**
     * Returns the combination of the two arrays
     * @param A The first array
     * @param B The second array
     * @return Returns A extended by B
     */
    function extend(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
        uint256 aLength = A.length;
        uint256 bLength = B.length;
        address[] memory newAddresses = new address[](aLength + bLength);
        for (uint256 i = 0; i < aLength; i++) {
            newAddresses[i] = A[i];
        }
        for (uint256 j = 0; j < bLength; j++) {
            newAddresses[aLength + j] = B[j];
        }
        return newAddresses;
    }

    /**
     * Returns the array with a appended to A.
     * @param A The first array
     * @param a The value to append
     * @return Returns A appended by a
     */
    function append(address[] memory A, address a) internal pure returns (address[] memory) {
        address[] memory newAddresses = new address[](A.length + 1);
        for (uint256 i = 0; i < A.length; i++) {
            newAddresses[i] = A[i];
        }
        newAddresses[A.length] = a;
        return newAddresses;
    }

    /**
     * Returns the intersection of two arrays. Arrays are treated as collections, so duplicates are kept.
     * @param A The first array
     * @param B The second array
     * @return The intersection of the two arrays
     */
    function intersect(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
        uint256 length = A.length;
        bool[] memory includeMap = new bool[](length);
        uint256 newLength = 0;
        for (uint256 i = 0; i < length; i++) {
            if (contains(B, A[i])) {
                includeMap[i] = true;
                newLength++;
            }
        }
        address[] memory newAddresses = new address[](newLength);
        uint256 j = 0;
        for (uint256 k = 0; k < length; k++) {
            if (includeMap[k]) {
                newAddresses[j] = A[k];
                j++;
            }
        }
        return newAddresses;
    }

    /**
     * Returns the union of the two arrays. Order is not guaranteed.
     * @param A The first array
     * @param B The second array
     * @return The union of the two arrays
     */
    function union(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
        address[] memory leftDifference = difference(A, B);
        address[] memory rightDifference = difference(B, A);
        address[] memory intersection = intersect(A, B);
        return extend(leftDifference, extend(intersection, rightDifference));
    }

    /**
     * Computes the difference of two arrays. Assumes there are no duplicates.
     * @param A The first array
     * @param B The second array
     * @return The difference of the two arrays
     */
    function difference(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
        uint256 length = A.length;
        bool[] memory includeMap = new bool[](length);
        uint256 count = 0;
        // First count the new length because can't push for in-memory arrays
        for (uint256 i = 0; i < length; i++) {
            address e = A[i];
            if (!contains(B, e)) {
                includeMap[i] = true;
                count++;
            }
        }
        address[] memory newAddresses = new address[](count);
        uint256 j = 0;
        for (uint256 k = 0; k < length; k++) {
            if (includeMap[k]) {
                newAddresses[j] = A[k];
                j++;
            }
        }
        return newAddresses;
    }

    /**
    * Removes specified index from array
    * Resulting ordering is not guaranteed
    * @return Returns the new array and the removed entry
    */
    function pop(address[] memory A, uint256 index)
        internal
        pure
        returns (address[] memory, address)
    {
        uint256 length = A.length;
        address[] memory newAddresses = new address[](length - 1);
        for (uint256 i = 0; i < index; i++) {
            newAddresses[i] = A[i];
        }
        for (uint256 j = index + 1; j < length; j++) {
            newAddresses[j - 1] = A[j];
        }
        return (newAddresses, A[index]);
    }

    /**
     * @return Returns the new array
     */
    function remove(address[] memory A, address a)
        internal
        pure
        returns (address[] memory)
    {
        (uint256 index, bool isIn) = indexOf(A, a);
        if (!isIn) {
            revert();
        } else {
            (address[] memory _A,) = pop(A, index);
            return _A;
        }
    }

    /**
     * Returns whether or not there's a duplicate. Runs in O(n^2).
     * @param A Array to search
     * @return Returns true if duplicate, false otherwise
     */
    function hasDuplicate(address[] memory A) internal pure returns (bool) {
        if (A.length == 0) { 
            return false;
        }
        for (uint256 i = 0; i < A.length - 1; i++) {
            for (uint256 j = i + 1; j < A.length; j++) {
                if (A[i] == A[j]) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Returns whether the two arrays are equal.
     * @param A The first array
     * @param B The second array
     * @return True is the arrays are equal, false if not.
     */
    function isEqual(address[] memory A, address[] memory B) internal pure returns (bool) {
        if (A.length != B.length) {
            return false;
        }
        for (uint256 i = 0; i < A.length; i++) {
            if (A[i] != B[i]) {
                return false;
            }
        }
        return true;
    }
}

// File: set-protocol-contracts/contracts/core/interfaces/ICore.sol

/*
    Copyright 2018 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;


/**
 * @title ICore
 * @author Set Protocol
 *
 * The ICore Contract defines all the functions exposed in the Core through its
 * various extensions and is a light weight way to interact with the contract.
 */
interface ICore {
    /**
     * Return transferProxy address.
     *
     * @return address       transferProxy address
     */
    function transferProxy()
        external
        view
        returns (address);

    /**
     * Return vault address.
     *
     * @return address       vault address
     */
    function vault()
        external
        view
        returns (address);

    /**
     * Return address belonging to given exchangeId.
     *
     * @param  _exchangeId       ExchangeId number
     * @return address           Address belonging to given exchangeId
     */
    function exchangeIds(
        uint8 _exchangeId
    )
        external
        view
        returns (address);

    /*
     * Returns if valid set
     *
     * @return  bool      Returns true if Set created through Core and isn't disabled
     */
    function validSets(address)
        external
        view
        returns (bool);

    /*
     * Returns if valid module
     *
     * @return  bool      Returns true if valid module
     */
    function validModules(address)
        external
        view
        returns (bool);

    /**
     * Return boolean indicating if address is a valid Rebalancing Price Library.
     *
     * @param  _priceLibrary    Price library address
     * @return bool             Boolean indicating if valid Price Library
     */
    function validPriceLibraries(
        address _priceLibrary
    )
        external
        view
        returns (bool);

    /**
     * Exchanges components for Set Tokens
     *
     * @param  _set          Address of set to issue
     * @param  _quantity     Quantity of set to issue
     */
    function issue(
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Issues a specified Set for a specified quantity to the recipient
     * using the caller's components from the wallet and vault.
     *
     * @param  _recipient    Address to issue to
     * @param  _set          Address of the Set to issue
     * @param  _quantity     Number of tokens to issue
     */
    function issueTo(
        address _recipient,
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Converts user's components into Set Tokens held directly in Vault instead of user's account
     *
     * @param _set          Address of the Set
     * @param _quantity     Number of tokens to redeem
     */
    function issueInVault(
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Function to convert Set Tokens into underlying components
     *
     * @param _set          The address of the Set token
     * @param _quantity     The number of tokens to redeem. Should be multiple of natural unit.
     */
    function redeem(
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Redeem Set token and return components to specified recipient. The components
     * are left in the vault
     *
     * @param _recipient    Recipient of Set being issued
     * @param _set          Address of the Set
     * @param _quantity     Number of tokens to redeem
     */
    function redeemTo(
        address _recipient,
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Function to convert Set Tokens held in vault into underlying components
     *
     * @param _set          The address of the Set token
     * @param _quantity     The number of tokens to redeem. Should be multiple of natural unit.
     */
    function redeemInVault(
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Composite method to redeem and withdraw with a single transaction
     *
     * Normally, you should expect to be able to withdraw all of the tokens.
     * However, some have central abilities to freeze transfers (e.g. EOS). _toExclude
     * allows you to optionally specify which component tokens to exclude when
     * redeeming. They will remain in the vault under the users' addresses.
     *
     * @param _set          Address of the Set
     * @param _to           Address to withdraw or attribute tokens to
     * @param _quantity     Number of tokens to redeem
     * @param _toExclude    Mask of indexes of tokens to exclude from withdrawing
     */
    function redeemAndWithdrawTo(
        address _set,
        address _to,
        uint256 _quantity,
        uint256 _toExclude
    )
        external;

    /**
     * Deposit multiple tokens to the vault. Quantities should be in the
     * order of the addresses of the tokens being deposited.
     *
     * @param  _tokens           Array of the addresses of the ERC20 tokens
     * @param  _quantities       Array of the number of tokens to deposit
     */
    function batchDeposit(
        address[] calldata _tokens,
        uint256[] calldata _quantities
    )
        external;

    /**
     * Withdraw multiple tokens from the vault. Quantities should be in the
     * order of the addresses of the tokens being withdrawn.
     *
     * @param  _tokens            Array of the addresses of the ERC20 tokens
     * @param  _quantities        Array of the number of tokens to withdraw
     */
    function batchWithdraw(
        address[] calldata _tokens,
        uint256[] calldata _quantities
    )
        external;

    /**
     * Deposit any quantity of tokens into the vault.
     *
     * @param  _token           The address of the ERC20 token
     * @param  _quantity        The number of tokens to deposit
     */
    function deposit(
        address _token,
        uint256 _quantity
    )
        external;

    /**
     * Withdraw a quantity of tokens from the vault.
     *
     * @param  _token           The address of the ERC20 token
     * @param  _quantity        The number of tokens to withdraw
     */
    function withdraw(
        address _token,
        uint256 _quantity
    )
        external;

    /**
     * Transfer tokens associated with the sender's account in vault to another user's
     * account in vault.
     *
     * @param  _token           Address of token being transferred
     * @param  _to              Address of user receiving tokens
     * @param  _quantity        Amount of tokens being transferred
     */
    function internalTransfer(
        address _token,
        address _to,
        uint256 _quantity
    )
        external;

    /**
     * Deploys a new Set Token and adds it to the valid list of SetTokens
     *
     * @param  _factory              The address of the Factory to create from
     * @param  _components           The address of component tokens
     * @param  _units                The units of each component token
     * @param  _naturalUnit          The minimum unit to be issued or redeemed
     * @param  _name                 The bytes32 encoded name of the new Set
     * @param  _symbol               The bytes32 encoded symbol of the new Set
     * @param  _callData             Byte string containing additional call parameters
     * @return setTokenAddress       The address of the new Set
     */
    function createSet(
        address _factory,
        address[] calldata _components,
        uint256[] calldata _units,
        uint256 _naturalUnit,
        bytes32 _name,
        bytes32 _symbol,
        bytes calldata _callData
    )
        external
        returns (address);

    /**
     * Exposes internal function that deposits a quantity of tokens to the vault and attributes
     * the tokens respectively, to system modules.
     *
     * @param  _from            Address to transfer tokens from
     * @param  _to              Address to credit for deposit
     * @param  _token           Address of token being deposited
     * @param  _quantity        Amount of tokens to deposit
     */
    function depositModule(
        address _from,
        address _to,
        address _token,
        uint256 _quantity
    )
        external;

    /**
     * Exposes internal function that withdraws a quantity of tokens from the vault and
     * deattributes the tokens respectively, to system modules.
     *
     * @param  _from            Address to decredit for withdraw
     * @param  _to              Address to transfer tokens to
     * @param  _token           Address of token being withdrawn
     * @param  _quantity        Amount of tokens to withdraw
     */
    function withdrawModule(
        address _from,
        address _to,
        address _token,
        uint256 _quantity
    )
        external;

    /**
     * Exposes internal function that deposits multiple tokens to the vault, to system
     * modules. Quantities should be in the order of the addresses of the tokens being
     * deposited.
     *
     * @param  _from              Address to transfer tokens from
     * @param  _to                Address to credit for deposits
     * @param  _tokens            Array of the addresses of the tokens being deposited
     * @param  _quantities        Array of the amounts of tokens to deposit
     */
    function batchDepositModule(
        address _from,
        address _to,
        address[] calldata _tokens,
        uint256[] calldata _quantities
    )
        external;

    /**
     * Exposes internal function that withdraws multiple tokens from the vault, to system
     * modules. Quantities should be in the order of the addresses of the tokens being withdrawn.
     *
     * @param  _from              Address to decredit for withdrawals
     * @param  _to                Address to transfer tokens to
     * @param  _tokens            Array of the addresses of the tokens being withdrawn
     * @param  _quantities        Array of the amounts of tokens to withdraw
     */
    function batchWithdrawModule(
        address _from,
        address _to,
        address[] calldata _tokens,
        uint256[] calldata _quantities
    )
        external;

    /**
     * Expose internal function that exchanges components for Set tokens,
     * accepting any owner, to system modules
     *
     * @param  _owner        Address to use tokens from
     * @param  _recipient    Address to issue Set to
     * @param  _set          Address of the Set to issue
     * @param  _quantity     Number of tokens to issue
     */
    function issueModule(
        address _owner,
        address _recipient,
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Expose internal function that exchanges Set tokens for components,
     * accepting any owner, to system modules
     *
     * @param  _burnAddress         Address to burn token from
     * @param  _incrementAddress    Address to increment component tokens to
     * @param  _set                 Address of the Set to redeem
     * @param  _quantity            Number of tokens to redeem
     */
    function redeemModule(
        address _burnAddress,
        address _incrementAddress,
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Expose vault function that increments user's balance in the vault.
     * Available to system modules
     *
     * @param  _tokens          The addresses of the ERC20 tokens
     * @param  _owner           The address of the token owner
     * @param  _quantities      The numbers of tokens to attribute to owner
     */
    function batchIncrementTokenOwnerModule(
        address[] calldata _tokens,
        address _owner,
        uint256[] calldata _quantities
    )
        external;

    /**
     * Expose vault function that decrement user's balance in the vault
     * Only available to system modules.
     *
     * @param  _tokens          The addresses of the ERC20 tokens
     * @param  _owner           The address of the token owner
     * @param  _quantities      The numbers of tokens to attribute to owner
     */
    function batchDecrementTokenOwnerModule(
        address[] calldata _tokens,
        address _owner,
        uint256[] calldata _quantities
    )
        external;

    /**
     * Expose vault function that transfer vault balances between users
     * Only available to system modules.
     *
     * @param  _tokens           Addresses of tokens being transferred
     * @param  _from             Address tokens being transferred from
     * @param  _to               Address tokens being transferred to
     * @param  _quantities       Amounts of tokens being transferred
     */
    function batchTransferBalanceModule(
        address[] calldata _tokens,
        address _from,
        address _to,
        uint256[] calldata _quantities
    )
        external;

    /**
     * Transfers token from one address to another using the transfer proxy.
     * Only available to system modules.
     *
     * @param  _token          The address of the ERC20 token
     * @param  _quantity       The number of tokens to transfer
     * @param  _from           The address to transfer from
     * @param  _to             The address to transfer to
     */
    function transferModule(
        address _token,
        uint256 _quantity,
        address _from,
        address _to
    )
        external;

    /**
     * Expose transfer proxy function to transfer tokens from one address to another
     * Only available to system modules.
     *
     * @param  _tokens         The addresses of the ERC20 token
     * @param  _quantities     The numbers of tokens to transfer
     * @param  _from           The address to transfer from
     * @param  _to             The address to transfer to
     */
    function batchTransferModule(
        address[] calldata _tokens,
        uint256[] calldata _quantities,
        address _from,
        address _to
    )
        external;
}

// File: set-protocol-contracts/contracts/core/interfaces/ISetToken.sol

/*
    Copyright 2018 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;

/**
 * @title ISetToken
 * @author Set Protocol
 *
 * The ISetToken interface provides a light-weight, structured way to interact with the
 * SetToken contract from another contract.
 */
interface ISetToken {

    /* ============ External Functions ============ */

    /*
     * Get natural unit of Set
     *
     * @return  uint256       Natural unit of Set
     */
    function naturalUnit()
        external
        view
        returns (uint256);

    /*
     * Get addresses of all components in the Set
     *
     * @return  componentAddresses       Array of component tokens
     */
    function getComponents()
        external
        view
        returns (address[] memory);

    /*
     * Get units of all tokens in Set
     *
     * @return  units       Array of component units
     */
    function getUnits()
        external
        view
        returns (uint256[] memory);

    /*
     * Checks to make sure token is component of Set
     *
     * @param  _tokenAddress     Address of token being checked
     * @return  bool             True if token is component of Set
     */
    function tokenIsComponent(
        address _tokenAddress
    )
        external
        view
        returns (bool);

    /*
     * Mint set token for given address.
     * Can only be called by authorized contracts.
     *
     * @param  _issuer      The address of the issuing account
     * @param  _quantity    The number of sets to attribute to issuer
     */
    function mint(
        address _issuer,
        uint256 _quantity
    )
        external;

    /*
     * Burn set token for given address
     * Can only be called by authorized contracts
     *
     * @param  _from        The address of the redeeming account
     * @param  _quantity    The number of sets to burn from redeemer
     */
    function burn(
        address _from,
        uint256 _quantity
    )
        external;

    /**
    * Transfer token for a specified address
    *
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(
        address to,
        uint256 value
    )
        external;
}

// File: set-protocol-contracts/contracts/core/interfaces/IVault.sol

/*
    Copyright 2018 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;

/**
 * @title IVault
 * @author Set Protocol
 *
 * The IVault interface provides a light-weight, structured way to interact with the Vault
 * contract from another contract.
 */
interface IVault {

    /*
     * Withdraws user's unassociated tokens to user account. Can only be
     * called by authorized core contracts.
     *
     * @param  _token          The address of the ERC20 token
     * @param  _to             The address to transfer token to
     * @param  _quantity       The number of tokens to transfer
     */
    function withdrawTo(
        address _token,
        address _to,
        uint256 _quantity
    )
        external;

    /*
     * Increment quantity owned of a token for a given address. Can
     * only be called by authorized core contracts.
     *
     * @param  _token           The address of the ERC20 token
     * @param  _owner           The address of the token owner
     * @param  _quantity        The number of tokens to attribute to owner
     */
    function incrementTokenOwner(
        address _token,
        address _owner,
        uint256 _quantity
    )
        external;

    /*
     * Decrement quantity owned of a token for a given address. Can only
     * be called by authorized core contracts.
     *
     * @param  _token           The address of the ERC20 token
     * @param  _owner           The address of the token owner
     * @param  _quantity        The number of tokens to deattribute to owner
     */
    function decrementTokenOwner(
        address _token,
        address _owner,
        uint256 _quantity
    )
        external;

    /**
     * Transfers tokens associated with one account to another account in the vault
     *
     * @param  _token          Address of token being transferred
     * @param  _from           Address token being transferred from
     * @param  _to             Address token being transferred to
     * @param  _quantity       Amount of tokens being transferred
     */

    function transferBalance(
        address _token,
        address _from,
        address _to,
        uint256 _quantity
    )
        external;


    /*
     * Withdraws user's unassociated tokens to user account. Can only be
     * called by authorized core contracts.
     *
     * @param  _tokens          The addresses of the ERC20 tokens
     * @param  _owner           The address of the token owner
     * @param  _quantities      The numbers of tokens to attribute to owner
     */
    function batchWithdrawTo(
        address[] calldata _tokens,
        address _to,
        uint256[] calldata _quantities
    )
        external;

    /*
     * Increment quantites owned of a collection of tokens for a given address. Can
     * only be called by authorized core contracts.
     *
     * @param  _tokens          The addresses of the ERC20 tokens
     * @param  _owner           The address of the token owner
     * @param  _quantities      The numbers of tokens to attribute to owner
     */
    function batchIncrementTokenOwner(
        address[] calldata _tokens,
        address _owner,
        uint256[] calldata _quantities
    )
        external;

    /*
     * Decrements quantites owned of a collection of tokens for a given address. Can
     * only be called by authorized core contracts.
     *
     * @param  _tokens          The addresses of the ERC20 tokens
     * @param  _owner           The address of the token owner
     * @param  _quantities      The numbers of tokens to attribute to owner
     */
    function batchDecrementTokenOwner(
        address[] calldata _tokens,
        address _owner,
        uint256[] calldata _quantities
    )
        external;

   /**
     * Transfers tokens associated with one account to another account in the vault
     *
     * @param  _tokens           Addresses of tokens being transferred
     * @param  _from             Address tokens being transferred from
     * @param  _to               Address tokens being transferred to
     * @param  _quantities       Amounts of tokens being transferred
     */
    function batchTransferBalance(
        address[] calldata _tokens,
        address _from,
        address _to,
        uint256[] calldata _quantities
    )
        external;

    /*
     * Get balance of particular contract for owner.
     *
     * @param  _token    The address of the ERC20 token
     * @param  _owner    The address of the token owner
     */
    function getOwnerBalance(
        address _token,
        address _owner
    )
        external
        view
        returns (uint256);
}

// File: set-protocol-contracts/contracts/core/modules/lib/ExchangeIssuanceLibrary.sol

/*
    Copyright 2018 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;







/**
 * @title ExchangeIssuanceLibrary
 * @author Set Protocol
 *
 * The ExchangeIssuanceLibrary contains functions for validating exchange order data
 */
library ExchangeIssuanceLibrary {
    using SafeMath for uint256;
    using AddressArrayUtils for address[];

    // ============ Structs ============

    struct ExchangeIssuanceParams {
        address setAddress;
        uint256 quantity;
        uint8[] sendTokenExchangeIds;
        address[] sendTokens;
        uint256[] sendTokenAmounts;
        address[] receiveTokens;
        uint256[] receiveTokenAmounts;
    }

    /**
     * Validates that the quantity to issue is positive and a multiple of the Set natural unit.
     *
     * @param _set                The address of the Set
     * @param _quantity           The quantity of Sets to issue or redeem
     */
    function validateQuantity(
        address _set,
        uint256 _quantity
    )
        internal
        view
    {
        // Make sure quantity to issue is greater than 0
        require(
            _quantity > 0,
            "ExchangeIssuanceLibrary.validateQuantity: Quantity must be positive"
        );

        // Make sure Issue quantity is multiple of the Set natural unit
        require(
            _quantity.mod(ISetToken(_set).naturalUnit()) == 0,
            "ExchangeIssuanceLibrary.validateQuantity: Quantity must be multiple of natural unit"
        );
    }

    /**
     * Validates that the required Components and amounts are valid components and positive.
     * Duplicate receive token values are not allowed
     *
     * @param _receiveTokens           The addresses of components required for issuance
     * @param _receiveTokenAmounts     The quantities of components required for issuance
     */
    function validateReceiveTokens(
        address[] memory _receiveTokens,
        uint256[] memory _receiveTokenAmounts
    )
        internal
        view
    {
        uint256 receiveTokensCount = _receiveTokens.length;

        // Make sure required components array is non-empty
        require(
            receiveTokensCount > 0,
            "ExchangeIssuanceLibrary.validateReceiveTokens: Receive tokens must not be empty"
        );

        // Ensure the receive tokens has no duplicates
        require(
            !_receiveTokens.hasDuplicate(),
            "ExchangeIssuanceLibrary.validateReceiveTokens: Receive tokens must not have duplicates"
        );

        // Make sure required components and required component amounts are equal length
        require(
            receiveTokensCount == _receiveTokenAmounts.length,
            "ExchangeIssuanceLibrary.validateReceiveTokens: Receive tokens and amounts must be equal length"
        );

        for (uint256 i = 0; i < receiveTokensCount; i++) {
            // Make sure all required component amounts are non-zero
            require(
                _receiveTokenAmounts[i] > 0,
                "ExchangeIssuanceLibrary.validateReceiveTokens: Component amounts must be positive"
            );
        }
    }

    /**
     * Validates that the tokens received exceeds what we expect
     *
     * @param _vault                        The address of the Vault
     * @param _receiveTokens                The addresses of components required for issuance
     * @param _requiredBalances             The quantities of components required for issuance
     * @param _userToCheck                  The address of the user
     */
    function validatePostExchangeReceiveTokenBalances(
        address _vault,
        address[] memory _receiveTokens,
        uint256[] memory _requiredBalances,
        address _userToCheck
    )
        internal
        view
    {
        // Get vault instance
        IVault vault = IVault(_vault);

        // Check that caller's receive tokens in Vault have been incremented correctly
        for (uint256 i = 0; i < _receiveTokens.length; i++) {
            uint256 currentBal = vault.getOwnerBalance(
                _receiveTokens[i],
                _userToCheck
            );

            require(
                currentBal >= _requiredBalances[i],
                "ExchangeIssuanceLibrary.validatePostExchangeReceiveTokenBalances: Insufficient receive token acquired"
            );
        }
    }

    /**
     * Validates that the send tokens inputs are valid. Since tokens are sent to various exchanges,
     * duplicate send tokens are valid
     *
     * @param _core                         The address of Core
     * @param _sendTokenExchangeIds         List of exchange wrapper enumerations corresponding to 
     *                                          the wrapper that will handle the component
     * @param _sendTokens                   The address of the send tokens
     * @param _sendTokenAmounts             The quantities of send tokens
     */
    function validateSendTokenParams(
        address _core,
        uint8[] memory _sendTokenExchangeIds,
        address[] memory _sendTokens,
        uint256[] memory _sendTokenAmounts
    )
        internal
        view
    {
        require(
            _sendTokens.length > 0,
            "ExchangeIssuanceLibrary.validateSendTokenParams: Send token inputs must not be empty"
        );

        require(
            _sendTokenExchangeIds.length == _sendTokens.length && 
            _sendTokens.length == _sendTokenAmounts.length,
            "ExchangeIssuanceLibrary.validateSendTokenParams: Send token inputs must be of the same length"
        );

        ICore core = ICore(_core);

        for (uint256 i = 0; i < _sendTokenExchangeIds.length; i++) {
            // Make sure all exchanges are valid
            require(
                core.exchangeIds(_sendTokenExchangeIds[i]) != address(0),
                "ExchangeIssuanceLibrary.validateSendTokenParams: Must be valid exchange"
            );

            // Make sure all send token amounts are non-zero
            require(
                _sendTokenAmounts[i] > 0,
                "ExchangeIssuanceLibrary.validateSendTokenParams: Send amounts must be positive"
            );
        }
    }
}

// File: set-protocol-contracts/contracts/lib/IERC20.sol

/*
    Copyright 2018 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;


/**
 * @title IERC20
 * @author Set Protocol
 *
 * Interface for using ERC20 Tokens. This interface is needed to interact with tokens that are not
 * fully ERC20 compliant and return something other than true on successful transfers.
 */
interface IERC20 {
    function balanceOf(
        address _owner
    )
        external
        view
        returns (uint256);

    function allowance(
        address _owner,
        address _spender
    )
        external
        view
        returns (uint256);

    function transfer(
        address _to,
        uint256 _quantity
    )
        external;

    function transferFrom(
        address _from,
        address _to,
        uint256 _quantity
    )
        external;

    function approve(
        address _spender,
        uint256 _quantity
    )
        external
        returns (bool);

    function totalSupply()
        external
        returns (uint256);
}

// File: set-protocol-contracts/contracts/lib/ERC20Wrapper.sol

/*
    Copyright 2018 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;




/**
 * @title ERC20Wrapper
 * @author Set Protocol
 *
 * This library contains functions for interacting wtih ERC20 tokens, even those not fully compliant.
 * For all functions we will only accept tokens that return a null or true value, any other values will
 * cause the operation to revert.
 */
library ERC20Wrapper {

    // ============ Internal Functions ============

    /**
     * Check balance owner's balance of ERC20 token
     *
     * @param  _token          The address of the ERC20 token
     * @param  _owner          The owner who's balance is being checked
     * @return  uint256        The _owner's amount of tokens
     */
    function balanceOf(
        address _token,
        address _owner
    )
        external
        view
        returns (uint256)
    {
        return IERC20(_token).balanceOf(_owner);
    }

    /**
     * Checks spender's allowance to use token's on owner's behalf.
     *
     * @param  _token          The address of the ERC20 token
     * @param  _owner          The token owner address
     * @param  _spender        The address the allowance is being checked on
     * @return  uint256        The spender's allowance on behalf of owner
     */
    function allowance(
        address _token,
        address _owner,
        address _spender
    )
        internal
        view
        returns (uint256)
    {
        return IERC20(_token).allowance(_owner, _spender);
    }

    /**
     * Transfers tokens from an address. Handle's tokens that return true or null.
     * If other value returned, reverts.
     *
     * @param  _token          The address of the ERC20 token
     * @param  _to             The address to transfer to
     * @param  _quantity       The amount of tokens to transfer
     */
    function transfer(
        address _token,
        address _to,
        uint256 _quantity
    )
        external
    {
        IERC20(_token).transfer(_to, _quantity);

        // Check that transfer returns true or null
        require(
            checkSuccess(),
            "ERC20Wrapper.transfer: Bad return value"
        );
    }

    /**
     * Transfers tokens from an address (that has set allowance on the proxy).
     * Handle's tokens that return true or null. If other value returned, reverts.
     *
     * @param  _token          The address of the ERC20 token
     * @param  _from           The address to transfer from
     * @param  _to             The address to transfer to
     * @param  _quantity       The number of tokens to transfer
     */
    function transferFrom(
        address _token,
        address _from,
        address _to,
        uint256 _quantity
    )
        external
    {
        IERC20(_token).transferFrom(_from, _to, _quantity);

        // Check that transferFrom returns true or null
        require(
            checkSuccess(),
            "ERC20Wrapper.transferFrom: Bad return value"
        );
    }

    /**
     * Grants spender ability to spend on owner's behalf.
     * Handle's tokens that return true or null. If other value returned, reverts.
     *
     * @param  _token          The address of the ERC20 token
     * @param  _spender        The address to approve for transfer
     * @param  _quantity       The amount of tokens to approve spender for
     */
    function approve(
        address _token,
        address _spender,
        uint256 _quantity
    )
        internal
    {
        IERC20(_token).approve(_spender, _quantity);

        // Check that approve returns true or null
        require(
            checkSuccess(),
            "ERC20Wrapper.approve: Bad return value"
        );
    }

    /**
     * Ensure's the owner has granted enough allowance for system to
     * transfer tokens.
     *
     * @param  _token          The address of the ERC20 token
     * @param  _owner          The address of the token owner
     * @param  _spender        The address to grant/check allowance for
     * @param  _quantity       The amount to see if allowed for
     */
    function ensureAllowance(
        address _token,
        address _owner,
        address _spender,
        uint256 _quantity
    )
        internal
    {
        uint256 currentAllowance = allowance(_token, _owner, _spender);
        if (currentAllowance < _quantity) {
            approve(
                _token,
                _spender,
                CommonMath.maxUInt256()
            );
        }
    }

    // ============ Private Functions ============

    /**
     * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
     * function returned 0 bytes or 1.
     */
    function checkSuccess(
    )
        private
        pure
        returns (bool)
    {
        // default to failure
        uint256 returnValue = 0;

        assembly {
            // check number of bytes returned from last function call
            switch returndatasize

            // no bytes returned: assume success
            case 0x0 {
                returnValue := 1
            }

            // 32 bytes returned
            case 0x20 {
                // copy 32 bytes into scratch space
                returndatacopy(0x0, 0x0, 0x20)

                // load those bytes into returnValue
                returnValue := mload(0x0)
            }

            // not sure what was returned: dont mark as success
            default { }
        }

        // check if returned value is one or nothing
        return returnValue == 1;
    }
}

// File: set-protocol-contracts/contracts/core/interfaces/IExchangeIssuanceModule.sol

/*
    Copyright 2018 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;


/**
 * @title IExchangeIssuanceModule
 * @author Set Protocol
 *
 * Interface for executing orders and issuing and redeeming a Set
 */
interface IExchangeIssuanceModule {

    function exchangeIssue(
        ExchangeIssuanceLibrary.ExchangeIssuanceParams calldata _exchangeIssuanceParams,
        bytes calldata _orderData
    )
        external;


    function exchangeRedeem(
        ExchangeIssuanceLibrary.ExchangeIssuanceParams calldata _exchangeIssuanceParams,
        bytes calldata _orderData
    )
        external;
}

// File: set-protocol-contracts/contracts/core/lib/RebalancingLibrary.sol

/*
    Copyright 2018 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;


/**
 * @title RebalancingLibrary
 * @author Set Protocol
 *
 * The RebalancingLibrary contains functions for facilitating the rebalancing process for
 * Rebalancing Set Tokens. Removes the old calculation functions
 *
 */
library RebalancingLibrary {

    /* ============ Enums ============ */

    enum State { Default, Proposal, Rebalance, Drawdown }

    /* ============ Structs ============ */

    struct AuctionPriceParameters {
        uint256 auctionStartTime;
        uint256 auctionTimeToPivot;
        uint256 auctionStartPrice;
        uint256 auctionPivotPrice;
    }

    struct BiddingParameters {
        uint256 minimumBid;
        uint256 remainingCurrentSets;
        uint256[] combinedCurrentUnits;
        uint256[] combinedNextSetUnits;
        address[] combinedTokenArray;
    }
}

// File: set-protocol-contracts/contracts/core/interfaces/IRebalancingSetToken.sol

/*
    Copyright 2018 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;


/**
 * @title IRebalancingSetToken
 * @author Set Protocol
 *
 * The IRebalancingSetToken interface provides a light-weight, structured way to interact with the
 * RebalancingSetToken contract from another contract.
 */

interface IRebalancingSetToken {

    /*
     * Get the auction library contract used for the current rebalance
     *
     * @return address    Address of auction library used in the upcoming auction
     */
    function auctionLibrary()
        external
        view
        returns (address);

    /*
     * Get totalSupply of Rebalancing Set
     *
     * @return  totalSupply
     */
    function totalSupply()
        external
        view
        returns (uint256);

    /*
     * Get proposalTimeStamp of Rebalancing Set
     *
     * @return  proposalTimeStamp
     */
    function proposalStartTime()
        external
        view
        returns (uint256);

    /*
     * Get lastRebalanceTimestamp of Rebalancing Set
     *
     * @return  lastRebalanceTimestamp
     */
    function lastRebalanceTimestamp()
        external
        view
        returns (uint256);

    /*
     * Get rebalanceInterval of Rebalancing Set
     *
     * @return  rebalanceInterval
     */
    function rebalanceInterval()
        external
        view
        returns (uint256);

    /*
     * Get rebalanceState of Rebalancing Set
     *
     * @return RebalancingLibrary.State    Current rebalance state of the RebalancingSetToken
     */
    function rebalanceState()
        external
        view
        returns (RebalancingLibrary.State);

    /*
     * Get the starting amount of current SetToken for the current auction
     *
     * @return  rebalanceState
     */
    function startingCurrentSetAmount()
        external
        view
        returns (uint256);

    /**
     * Gets the balance of the specified address.
     *
     * @param owner      The address to query the balance of.
     * @return           A uint256 representing the amount owned by the passed address.
     */
    function balanceOf(
        address owner
    )
        external
        view
        returns (uint256);

    /**
     * Function used to set the terms of the next rebalance and start the proposal period
     *
     * @param _nextSet                      The Set to rebalance into
     * @param _auctionLibrary               The library used to calculate the Dutch Auction price
     * @param _auctionTimeToPivot           The amount of time for the auction to go ffrom start to pivot price
     * @param _auctionStartPrice            The price to start the auction at
     * @param _auctionPivotPrice            The price at which the price curve switches from linear to exponential
     */
    function propose(
        address _nextSet,
        address _auctionLibrary,
        uint256 _auctionTimeToPivot,
        uint256 _auctionStartPrice,
        uint256 _auctionPivotPrice
    )
        external;

    /*
     * Get natural unit of Set
     *
     * @return  uint256       Natural unit of Set
     */
    function naturalUnit()
        external
        view
        returns (uint256);

    /**
     * Returns the address of the current base SetToken with the current allocation
     *
     * @return           A address representing the base SetToken
     */
    function currentSet()
        external
        view
        returns (address);

    /**
     * Returns the address of the next base SetToken with the post auction allocation
     *
     * @return  address    Address representing the base SetToken
     */
    function nextSet()
        external
        view
        returns (address);

    /*
     * Get the unit shares of the rebalancing Set
     *
     * @return  unitShares       Unit Shares of the base Set
     */
    function unitShares()
        external
        view
        returns (uint256);

    /*
     * Burn set token for given address.
     * Can only be called by authorized contracts.
     *
     * @param  _from        The address of the redeeming account
     * @param  _quantity    The number of sets to burn from redeemer
     */
    function burn(
        address _from,
        uint256 _quantity
    )
        external;

    /*
     * Place bid during rebalance auction. Can only be called by Core.
     *
     * @param _quantity                 The amount of currentSet to be rebalanced
     * @return combinedTokenArray       Array of token addresses invovled in rebalancing
     * @return inflowUnitArray          Array of amount of tokens inserted into system in bid
     * @return outflowUnitArray         Array of amount of tokens taken out of system in bid
     */
    function placeBid(
        uint256 _quantity
    )
        external
        returns (address[] memory, uint256[] memory, uint256[] memory);

    /*
     * Get combinedTokenArray of Rebalancing Set
     *
     * @return  combinedTokenArray
     */
    function getCombinedTokenArrayLength()
        external
        view
        returns (uint256);

    /*
     * Get combinedTokenArray of Rebalancing Set
     *
     * @return  combinedTokenArray
     */
    function getCombinedTokenArray()
        external
        view
        returns (address[] memory);

    /*
     * Get failedAuctionWithdrawComponents of Rebalancing Set
     *
     * @return  failedAuctionWithdrawComponents
     */
    function getFailedAuctionWithdrawComponents()
        external
        view
        returns (address[] memory);

    /*
     * Get auctionPriceParameters for current auction
     *
     * @return uint256[4]    AuctionPriceParameters for current rebalance auction
     */
    function getAuctionPriceParameters()
        external
        view
        returns (uint256[] memory);

    /*
     * Get biddingParameters for current auction
     *
     * @return uint256[2]    BiddingParameters for current rebalance auction
     */
    function getBiddingParameters()
        external
        view
        returns (uint256[] memory);

    /*
     * Get token inflows and outflows required for bid. Also the amount of Rebalancing
     * Sets that would be generated.
     *
     * @param _quantity               The amount of currentSet to be rebalanced
     * @return inflowUnitArray        Array of amount of tokens inserted into system in bid
     * @return outflowUnitArray       Array of amount of tokens taken out of system in bid
     */
    function getBidPrice(
        uint256 _quantity
    )
        external
        view
        returns (uint256[] memory, uint256[] memory);

}

// File: set-protocol-contracts/contracts/core/interfaces/ITransferProxy.sol

/*
    Copyright 2018 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;

/**
 * @title ITransferProxy
 * @author Set Protocol
 *
 * The ITransferProxy interface provides a light-weight, structured way to interact with the
 * TransferProxy contract from another contract.
 */
interface ITransferProxy {

    /* ============ External Functions ============ */

    /**
     * Transfers tokens from an address (that has set allowance on the proxy).
     * Can only be called by authorized core contracts.
     *
     * @param  _token          The address of the ERC20 token
     * @param  _quantity       The number of tokens to transfer
     * @param  _from           The address to transfer from
     * @param  _to             The address to transfer to
     */
    function transfer(
        address _token,
        uint256 _quantity,
        address _from,
        address _to
    )
        external;

    /**
     * Transfers tokens from an address (that has set allowance on the proxy).
     * Can only be called by authorized core contracts.
     *
     * @param  _tokens         The addresses of the ERC20 token
     * @param  _quantities     The numbers of tokens to transfer
     * @param  _from           The address to transfer from
     * @param  _to             The address to transfer to
     */
    function batchTransfer(
        address[] calldata _tokens,
        uint256[] calldata _quantities,
        address _from,
        address _to
    )
        external;
}

// File: set-protocol-contracts/contracts/lib/IWETH.sol

/*
    Copyright 2018 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;


/**
 * @title IWETH
 * @author Set Protocol
 *
 * Interface for Wrapped Ether. This interface allows for interaction for wrapped ether's deposit and withdrawal
 * functionality.
 */
interface IWETH {
    function deposit()
        external
        payable;

    function withdraw(
        uint256 wad
    )
        external;
}

// File: set-protocol-contracts/contracts/core/modules/lib/ModuleCoreStateV2.sol

/*
    Copyright 2018 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;





/**
 * @title ModuleCoreStateV2
 * @author Set Protocol
 *
 * The ModuleCoreStateV2 library maintains Core-related state for modules.
 *
 * CHANGELOG
 * - Adds transferProxy to the tracked state
 * - Removes address variables
 *
 */
contract ModuleCoreStateV2 {

    /* ============ State Variables ============ */

    // Address of core contract
    ICore public coreInstance;

    // Address of vault contract
    IVault public vaultInstance;

    // Address of transferProxy contract
    ITransferProxy public transferProxyInstance;

    /* ============ Public Getters ============ */

    /**
     * Constructor function for ModuleCoreStateV2
     *
     * @param _core                The address of Core
     * @param _vault               The address of Vault
     * @param _transferProxy       The address of TransferProxy
     */
    constructor(
        ICore _core,
        IVault _vault,
        ITransferProxy _transferProxy
    )
        public
    {
        // Commit passed address to core state variable
        coreInstance = _core;

        // Commit passed address to vault state variable
        vaultInstance = _vault;

        // Commit passed address to vault state variable
        transferProxyInstance = _transferProxy;
    }
}

// File: set-protocol-contracts/contracts/core/modules/lib/TokenFlush.sol

/*
    Copyright 2019 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;







/**
 * @title TokenFlush
 * @author Set Protocol
 *
 * The TokenFlush contains utility functions to send tokens and base SetTokens from the
 * Vault or Contract to a specified user address
 */
contract TokenFlush is 
    ModuleCoreStateV2
{
    using SafeMath for uint256;
    using AddressArrayUtils for address[];

    // ============ Internal ============

    /**
     * Checks the base SetToken balances on the contract and sends
     * any positive quantity to the user directly or into the Vault
     * depending on the keepChangeInVault flag.
     *
     * @param _baseSetAddress             The address of the base SetToken
     * @param _returnAddress              The address to send excess tokens to
     * @param  _keepChangeInVault         Boolean signifying whether excess base SetToken is transfered to the user 
     *                                     or left in the vault
     */
    function returnExcessBaseSetFromContract(
        address _baseSetAddress,
        address _returnAddress,
        bool _keepChangeInVault
    )
        internal
    {
        uint256 baseSetQuantity = ERC20Wrapper.balanceOf(_baseSetAddress, address(this));
        
        if (baseSetQuantity > 0) { 
            if (_keepChangeInVault) {
                // Ensure base SetToken allowance
                ERC20Wrapper.ensureAllowance(
                    _baseSetAddress,
                    address(this),
                    address(transferProxyInstance),
                    baseSetQuantity
                );

                // Deposit base SetToken to the user
                coreInstance.depositModule(
                    address(this),
                    _returnAddress,
                    _baseSetAddress,
                    baseSetQuantity
                );
            } else {
                // Transfer directly to the user
                ERC20Wrapper.transfer(
                    _baseSetAddress,
                    _returnAddress,
                    baseSetQuantity
                );
            }
        }
    }

    /**
     * Checks the base SetToken balances in the Vault and sends
     * any positive quantity to the user directly or into the Vault
     * depending on the keepChangeInVault flag.
     *
     * @param _baseSetAddress             The address of the base SetToken
     * @param _returnAddress              The address to send excess tokens to
     * @param  _keepChangeInVault         Boolean signifying whether excess base SetToken is transfered to the user 
     *                                     or left in the vault
     */
    function returnExcessBaseSetInVault(
        address _baseSetAddress,
        address _returnAddress,
        bool _keepChangeInVault
    )
        internal
    {
        // Return base SetToken if any that are in the Vault
        uint256 baseSetQuantityInVault = vaultInstance.getOwnerBalance(
            _baseSetAddress,
            address(this)
        );
        
        if (baseSetQuantityInVault > 0) { 
            if (_keepChangeInVault) {
                // Transfer ownership within the vault to the user
                coreInstance.internalTransfer(
                    _baseSetAddress,
                    _returnAddress,
                    baseSetQuantityInVault
                );
            } else {
                // Transfer ownership directly to the user
                coreInstance.withdrawModule(
                    address(this),
                    _returnAddress,
                    _baseSetAddress,
                    baseSetQuantityInVault
                );
            }
        }
    } 

    /**
     * Withdraw any base Set components to the user from the contract.
     *
     * @param _baseSetToken               Instance of the Base SetToken
     * @param _returnAddress              The address to send excess tokens to
     */
    function returnExcessComponentsFromContract(
        ISetToken _baseSetToken,
        address _returnAddress
    )
        internal
    {
        // Return base Set components
        address[] memory baseSetComponents = _baseSetToken.getComponents();
        for (uint256 i = 0; i < baseSetComponents.length; i++) {
            uint256 withdrawQuantity = ERC20Wrapper.balanceOf(baseSetComponents[i], address(this));
            if (withdrawQuantity > 0) {
                ERC20Wrapper.transfer(
                    baseSetComponents[i],
                    _returnAddress,
                    withdrawQuantity
                );
            }
        }         
    }

    /**
     * Any base Set components in the Vault are returned to the caller.
     *
     * @param _baseSetToken               Instance of the Base SetToken
     * @param _returnAddress              The address to send excess tokens to
     */
    function returnExcessComponentsFromVault(
        ISetToken _baseSetToken,
        address _returnAddress
    )
        internal
    {
        // Return base Set components not used in issuance of base set
        address[] memory baseSetComponents = _baseSetToken.getComponents();
        for (uint256 i = 0; i < baseSetComponents.length; i++) {
            uint256 vaultQuantity = vaultInstance.getOwnerBalance(baseSetComponents[i], address(this));
            if (vaultQuantity > 0) {
                coreInstance.withdrawModule(
                    address(this),
                    _returnAddress,
                    baseSetComponents[i],
                    vaultQuantity
                );
            }
        }
    }   
}

// File: set-protocol-contracts/contracts/core/modules/RebalancingSetExchangeIssuanceModule.sol

/*
    Copyright 2019 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;
pragma experimental "ABIEncoderV2";
















/**
 * @title RebalancingSetExchangeIssuanceModule
 * @author Set Protocol
 *
 * The RebalancingSetExchangeIssuanceModule supplementary smart contract allows a user to issue and redeem a Rebalancing Set
 * using a payment token or receiving a receive token atomically in a single transaction using liquidity from
 * decentralized exchanges.
 */
contract RebalancingSetExchangeIssuanceModule is
    ModuleCoreStateV2,
    TokenFlush,
    ReentrancyGuard
{
    using SafeMath for uint256;

    /* ============ State Variables ============ */

    // Address and instance of ExchangeIssuance Module contract
    IExchangeIssuanceModule public exchangeIssuanceModuleInstance;

    // Address and instance of Wrapped Ether contract
    IWETH public wethInstance;

    /* ============ Events ============ */

    event LogPayableExchangeIssue(
        address indexed rebalancingSetAddress,
        address indexed callerAddress,
        address paymentTokenAddress,
        uint256 rebalancingSetQuantity,
        uint256 paymentTokenReturned
    );

    event LogPayableExchangeRedeem(
        address indexed rebalancingSetAddress,
        address indexed callerAddress,
        address outputTokenAddress,
        uint256 rebalancingSetQuantity,
        uint256 outputTokenQuantity
    );

    /* ============ Constructor ============ */

    /**
     * Constructor function for RebalancingSetExchangeIssuanceModule
     *
     * @param _core                     The address of Core
     * @param _transferProxy            The address of the TransferProxy
     * @param _exchangeIssuanceModule   The address of ExchangeIssuanceModule
     * @param _wrappedEther             The address of wrapped ether
     * @param _vault                    The address of Vault
     */
    constructor(
        ICore _core,
        ITransferProxy _transferProxy,
        IExchangeIssuanceModule _exchangeIssuanceModule,
        IWETH _wrappedEther,
        IVault _vault
    )
        public
        ModuleCoreStateV2(
            _core,
            _vault,
            _transferProxy
        )
    {
        // Commit the instance of ExchangeIssuanceModule to state variables
        exchangeIssuanceModuleInstance = _exchangeIssuanceModule;

        // Commit the address and instance of Wrapped Ether to state variables
        wethInstance = _wrappedEther;

        // Add approvals of Wrapped Ether to the Transfer Proxy
        ERC20Wrapper.approve(
            address(_wrappedEther),
            address(_transferProxy),
            CommonMath.maxUInt256()
        );
    }

    /**
     * Fallback function. Disallows ether to be sent to this contract without data except when
     * unwrapping WETH.
     */
    function ()
        external
        payable
    {
        require(
            msg.sender == address(wethInstance),
            "RebalancingSetExchangeIssuanceModule.fallback: Cannot receive ETH directly unless unwrapping WETH"
        );
    }

    /* ============ Public Functions ============ */

    /**
     * Issue a Rebalancing Set using Wrapped Ether to acquire the base components of the Base Set.
     * The Base Set is then issued using ExchangeIssue and reissued into the Rebalancing Set.
     * All remaining tokens / change are flushed and returned to the user.
     *
     * @param  _rebalancingSetAddress    Address of the rebalancing Set to issue
     * @param  _rebalancingSetQuantity   Quantity of the rebalancing Set
     * @param  _exchangeIssuanceParams   Struct containing data around the base Set issuance
     * @param  _orderData                Bytecode encoding exchange data for acquiring base set components
     * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transferred to the user
     *                                     or left in the vault
     */
    function issueRebalancingSetWithEther(
        address _rebalancingSetAddress,
        uint256 _rebalancingSetQuantity,
        ExchangeIssuanceLibrary.ExchangeIssuanceParams memory _exchangeIssuanceParams,
        bytes memory _orderData,
        bool _keepChangeInVault
    )
        public
        payable
        nonReentrant
    {
        // Wrap all Ether; Wrapped Ether could be a component of the Set being issued.
        wethInstance.deposit.value(msg.value)();

        // Perform exchange transactions, mint the base SetToken, and issue the Rebalancing Set to the sender
        issueRebalancingSetInternal(
            _rebalancingSetAddress,
            _rebalancingSetQuantity,
            address(wethInstance),
            msg.value,
            _exchangeIssuanceParams,
            _orderData,
            _keepChangeInVault
        );

        // unwrap any leftover WETH and transfer to sender
        uint256 leftoverWeth = ERC20Wrapper.balanceOf(address(wethInstance), address(this));
        if (leftoverWeth > 0) {
            // Withdraw wrapped Ether
            wethInstance.withdraw(leftoverWeth);

            // Transfer ether to user
            msg.sender.transfer(leftoverWeth);
        }

        emit LogPayableExchangeIssue(
            _rebalancingSetAddress,
            msg.sender,
            address(wethInstance),
            _rebalancingSetQuantity,
            leftoverWeth
        );
    }

    /**
     * Issue a Rebalancing Set using a specified ERC20 payment token. The payment token is used in ExchangeIssue
     * to acquire the base SetToken components and issue the base SetToken. The base SetToken is then used to
     * issue the Rebalancing SetToken. The payment token can be utilized as a component of the base SetToken.
     * All remaining tokens / change are flushed and returned to the user.
     * Ahead of calling this function, the user must approve their paymentToken to the transferProxy.
     *
     * @param  _rebalancingSetAddress    Address of the rebalancing Set to issue
     * @param  _rebalancingSetQuantity   Quantity of the rebalancing Set
     * @param  _paymentTokenAddress      Address of the ERC20 token to pay with
     * @param  _paymentTokenQuantity     Quantity of the payment token
     * @param  _exchangeIssuanceParams   Struct containing data around the base Set issuance
     * @param  _orderData                Bytecode formatted data with exchange data for acquiring base set components
     * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transfered to the user
     *                                     or left in the vault
     */
    function issueRebalancingSetWithERC20(
        address _rebalancingSetAddress,
        uint256 _rebalancingSetQuantity,
        address _paymentTokenAddress,
        uint256 _paymentTokenQuantity,
        ExchangeIssuanceLibrary.ExchangeIssuanceParams memory _exchangeIssuanceParams,
        bytes memory _orderData,
        bool _keepChangeInVault
    )
        public
        nonReentrant
    {
        // Deposit the erc20 to this contract. The token must be approved the caller to the transferProxy
        coreInstance.transferModule(
            _paymentTokenAddress,
            _paymentTokenQuantity,
            msg.sender,
            address(this)
        );

        // Perform exchange transactions, mint the base SetToken, and issue the Rebalancing Set to the sender
        issueRebalancingSetInternal(
            _rebalancingSetAddress,
            _rebalancingSetQuantity,
            _paymentTokenAddress,
            _paymentTokenQuantity,
            _exchangeIssuanceParams,
            _orderData,
            _keepChangeInVault
        );

        // Send back any unused payment token
        uint256 leftoverPaymentTokenQuantity = ERC20Wrapper.balanceOf(_paymentTokenAddress, address(this));
        if (leftoverPaymentTokenQuantity > 0) {
            ERC20Wrapper.transfer(
                _paymentTokenAddress,
                msg.sender,
                leftoverPaymentTokenQuantity
            );
        }

        emit LogPayableExchangeIssue(
            _rebalancingSetAddress,
            msg.sender,
            _paymentTokenAddress,
            _rebalancingSetQuantity,
            leftoverPaymentTokenQuantity
        );
    }

    /**
     * Redeems a Rebalancing Set into ether. The Rebalancing Set is redeemed into the Base Set, and
     * Base Set components are traded for WETH. The WETH is then withdrawn into ETH and the ETH sent to the caller.
     *
     * @param  _rebalancingSetAddress    Address of the rebalancing Set
     * @param  _rebalancingSetQuantity   Quantity of rebalancing Set to redeem
     * @param  _exchangeIssuanceParams   Struct containing data around the base Set issuance
     * @param  _orderData                Bytecode encoding exchange data for disposing base set components
     * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transfered to the user
     *                                     or left in the vault
     */
    function redeemRebalancingSetIntoEther(
        address _rebalancingSetAddress,
        uint256 _rebalancingSetQuantity,
        ExchangeIssuanceLibrary.ExchangeIssuanceParams memory _exchangeIssuanceParams,
        bytes memory _orderData,
        bool _keepChangeInVault
    )
        public
        nonReentrant
    {
        // Redeems the rebalancing Set into the base SetToken, redeems the base SetToken into its components,
        // and exchanges the components into wrapped ether to this contract.
        redeemRebalancingSetIntoComponentsInternal(
            _rebalancingSetAddress,
            _rebalancingSetQuantity,
            address(wethInstance),
            _exchangeIssuanceParams,
            _orderData
        );

        // In the event that exchangeIssue returns more receiveTokens or wrappedEth than
        // specified in receiveToken quantity, those tokens are also retrieved into this contract.
        // We also call this ahead of returnRedemptionChange to allow the unwrapping of the wrappedEther
        uint256 wethQuantityInVault = vaultInstance.getOwnerBalance(address(wethInstance), address(this));
        if (wethQuantityInVault > 0) {
            coreInstance.withdrawModule(
                address(this),
                address(this),
                address(wethInstance),
                wethQuantityInVault
            );
        }

        // Unwrap wrapped Ether and transfer Eth to user
        uint256 wethBalance = ERC20Wrapper.balanceOf(address(wethInstance), address(this));
        if (wethBalance > 0) {
            wethInstance.withdraw(wethBalance);
            msg.sender.transfer(wethBalance);
        }

        address baseSetAddress = _exchangeIssuanceParams.setAddress;

        // Send excess base Set to the user
        returnExcessBaseSetFromContract(
            baseSetAddress,
            msg.sender,
            _keepChangeInVault
        );

        // Return non-exchanged components to the user
        returnExcessComponentsFromContract(ISetToken(baseSetAddress), msg.sender);

        emit LogPayableExchangeRedeem(
            _rebalancingSetAddress,
            msg.sender,
            address(wethInstance),
            _rebalancingSetQuantity,
            wethBalance
        );
    }

    /**
     * Redeems a Rebalancing Set into a specified ERC20 token. The Rebalancing Set is redeemed into the Base Set, and
     * Base Set components are traded for the ERC20 and sent to the caller.
     *
     * @param  _rebalancingSetAddress    Address of the rebalancing Set
     * @param  _rebalancingSetQuantity   Quantity of rebalancing Set to redeem
     * @param  _outputTokenAddress       Address of the resulting ERC20 token sent to the user
     * @param  _exchangeIssuanceParams   Struct containing data around the base Set issuance
     * @param  _orderData                Bytecode formatted data with exchange data for disposing base set components
     * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transfered to the user
     *                                     or left in the vault
     */
    function redeemRebalancingSetIntoERC20(
        address _rebalancingSetAddress,
        uint256 _rebalancingSetQuantity,
        address _outputTokenAddress,
        ExchangeIssuanceLibrary.ExchangeIssuanceParams memory _exchangeIssuanceParams,
        bytes memory _orderData,
        bool _keepChangeInVault
    )
        public
        nonReentrant
    {
        // Redeems the rebalancing Set into the base SetToken, redeems the base SetToken into its components,
        // and exchanges the components into the receiveToken to this contract.
        redeemRebalancingSetIntoComponentsInternal(
            _rebalancingSetAddress,
            _rebalancingSetQuantity,
            _outputTokenAddress,
            _exchangeIssuanceParams,
            _orderData
        );

        // In the event that exchangeIssue returns more outputTokens than
        // specified in receiveToken quantity, those tokens are also retrieved into this contract.
        uint256 outputTokenInVault = vaultInstance.getOwnerBalance(_outputTokenAddress, address(this));
        if (outputTokenInVault > 0) {
            coreInstance.withdrawModule(
                address(this),
                address(this),
                _outputTokenAddress,
                outputTokenInVault
            );
        }

        // Transfer outputToken to the caller
        uint256 outputTokenBalance = ERC20Wrapper.balanceOf(_outputTokenAddress, address(this));
        ERC20Wrapper.transfer(
            _outputTokenAddress,
            msg.sender,
            outputTokenBalance
        );

        address baseSetAddress = _exchangeIssuanceParams.setAddress;

        // Send excess base SetToken to the user
        returnExcessBaseSetFromContract(
            baseSetAddress,
            msg.sender,
            _keepChangeInVault
        );

        // Non-exchanged base SetToken components are returned to the user
        returnExcessComponentsFromContract(ISetToken(baseSetAddress), msg.sender);

        emit LogPayableExchangeRedeem(
            _rebalancingSetAddress,
            msg.sender,
            _outputTokenAddress,
            _rebalancingSetQuantity,
            outputTokenBalance
        );
    }


    /* ============ Private Functions ============ */

    /**
     * Validate that the issuance parameters and inputs are congruent.
     *
     * @param  _transactTokenAddress     Address of the sendToken (issue) or receiveToken (redeem)
     * @param  _rebalancingSetAddress    Address of the rebalancing SetToken
     * @param  _rebalancingSetQuantity   Quantity of rebalancing SetToken to issue or redeem
     * @param  _baseSetAddress           Address of base SetToken in ExchangeIssueanceParams
     * @param  _transactTokenArray       List of addresses of send tokens (during issuance) and
     *                                     receive tokens (during redemption)
     */
    function validateExchangeIssuanceInputs(
        address _transactTokenAddress,
        IRebalancingSetToken _rebalancingSetAddress,
        uint256 _rebalancingSetQuantity,
        address _baseSetAddress,
        address[] memory _transactTokenArray
    )
        private
        view
    {
        // Expect rebalancing SetToken to be valid and enabled SetToken
        require(
            coreInstance.validSets(address(_rebalancingSetAddress)),
            "RebalancingSetExchangeIssuance.validateExchangeIssuanceInputs: Invalid or disabled SetToken address"
        );

        require(
            _rebalancingSetQuantity > 0,
            "RebalancingSetExchangeIssuance.validateExchangeIssuanceInputs: Quantity must be > 0"
        );

        // Make sure Issuance quantity is multiple of the rebalancing SetToken natural unit
        require(
            _rebalancingSetQuantity.mod(_rebalancingSetAddress.naturalUnit()) == 0,
            "RebalancingSetExchangeIssuance.validateExchangeIssuanceInputs: Quantity must be multiple of natural unit"
        );

        // Multiple items are allowed on the transactTokenArray. Specifically, this allows there to be
        // multiple sendToken items that are directed to the various exchangeWrappers.
        // The receiveTokenArray is implicitly limited to a single item, as the exchangeIssuanceModuleInstance
        // checks that the receive tokens do not have duplicates
        for (uint256 i = 0; i < _transactTokenArray.length; i++) {
            // The transact token array tokens must match the transact token.
            require(
                _transactTokenAddress == _transactTokenArray[i],
                "RebalancingSetExchangeIssuance.validateExchangeIssuanceInputs: Send/Receive token must match transact token"
            );
        }

        // Validate that the base Set address matches the issuanceParams Set Address
        address baseSet = _rebalancingSetAddress.currentSet();
        require(
            baseSet == _baseSetAddress,
            "RebalancingSetExchangeIssuance.validateExchangeIssuanceInputs: Base Set addresses must match"
        );
    }

    /**
     * Issue a Rebalancing Set using a specified ERC20 payment token. The payment token is used in ExchangeIssue
     * to acquire the base SetToken components and issue the base SetToken. The base SetToken is then used to
     * issue the Rebalancing SetToken. The payment token can be utilized as a component of the base SetToken.
     * All remaining tokens / change are flushed and returned to the user.
     *
     * Note: We do not validate the rebalancing SetToken quantity and the exchangeIssuanceParams base SetToken
     * quantity. Thus there could be extra base SetToken (or change) generated.
     *
     * @param  _rebalancingSetAddress    Address of the rebalancing Set to issue
     * @param  _rebalancingSetQuantity   Quantity of the rebalancing Set
     * @param  _paymentTokenAddress      Address of the ERC20 token to pay with
     * @param  _paymentTokenQuantity     Quantity of the payment token
     * @param  _exchangeIssuanceParams   Struct containing data around the base Set issuance
     * @param  _orderData                Bytecode formatted data with exchange data for acquiring base set components
     * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transfered to the user
     *                                     or left in the vault
     */
    function issueRebalancingSetInternal(
        address _rebalancingSetAddress,
        uint256 _rebalancingSetQuantity,
        address _paymentTokenAddress,
        uint256 _paymentTokenQuantity,
        ExchangeIssuanceLibrary.ExchangeIssuanceParams memory _exchangeIssuanceParams,
        bytes memory _orderData,
        bool _keepChangeInVault
    )
        private
    {
        address baseSetAddress = _exchangeIssuanceParams.setAddress;
        uint256 baseSetIssueQuantity = _exchangeIssuanceParams.quantity;

        // Validate parameters
        validateExchangeIssuanceInputs(
            _paymentTokenAddress,
            IRebalancingSetToken(_rebalancingSetAddress),
            _rebalancingSetQuantity,
            baseSetAddress,
            _exchangeIssuanceParams.sendTokens
        );

        // Ensure payment token allowance to the TransferProxy
        // Note that the paymentToken may also be used as a component to issue the Set
        // So the paymentTokenQuantity must be used vs. the exchangeIssuanceParams sendToken quantity
        ERC20Wrapper.ensureAllowance(
            _paymentTokenAddress,
            address(this),
            address(transferProxyInstance),
            _paymentTokenQuantity
        );

        // Atomically trade paymentToken for base SetToken components and mint the base SetToken
        exchangeIssuanceModuleInstance.exchangeIssue(
            _exchangeIssuanceParams,
            _orderData
        );

        // Approve base SetToken to transferProxy for minting rebalancing SetToken
        ERC20Wrapper.ensureAllowance(
            baseSetAddress,
            address(this),
            address(transferProxyInstance),
            baseSetIssueQuantity
        );

        // Issue rebalancing SetToken to the caller
        coreInstance.issueTo(
            msg.sender,
            _rebalancingSetAddress,
            _rebalancingSetQuantity
        );

        // Send excess base Set held in this contract to the user
        // If keepChangeInVault is true, the baseSetToken is held in the Vault
        // which is a UX improvement
        returnExcessBaseSetFromContract(
            baseSetAddress,
            msg.sender,
            _keepChangeInVault
        );

        // Return any extra components acquired during exchangeIssue to the user
        returnExcessComponentsFromVault(ISetToken(baseSetAddress), msg.sender);
    }

    /**
     * Redeems a Rebalancing Set into the receiveToken. The Rebalancing Set is redeemed into the Base Set, and
     * Base Set components are traded for the receiveToken located in this contract.
     *
     * Note: We do not validate the rebalancing SetToken quantity and the exchangeIssuanceParams base SetToken
     * quantity. Thus there could be extra base SetToken (or change) generated.
     *
     * @param  _rebalancingSetAddress    Address of the rebalancing Set
     * @param  _rebalancingSetQuantity   Quantity of rebalancing Set to redeem
     * @param  _receiveTokenAddress      Address of the receiveToken
     * @param  _exchangeIssuanceParams   Struct containing data around the base Set issuance
     * @param  _orderData                Bytecode formatted data with exchange data for disposing base set components
     */
    function redeemRebalancingSetIntoComponentsInternal(
        address _rebalancingSetAddress,
        uint256 _rebalancingSetQuantity,
        address _receiveTokenAddress,
        ExchangeIssuanceLibrary.ExchangeIssuanceParams memory _exchangeIssuanceParams,
        bytes memory _orderData
    )
        private
    {
        // Validate Params
        validateExchangeIssuanceInputs(
            _receiveTokenAddress,
            IRebalancingSetToken(_rebalancingSetAddress),
            _rebalancingSetQuantity,
            _exchangeIssuanceParams.setAddress,
            _exchangeIssuanceParams.receiveTokens
        );

        // Redeem rebalancing Set into the base SetToken from the user to this contract in the Vault
        coreInstance.redeemModule(
            msg.sender,
            address(this),
            _rebalancingSetAddress,
            _rebalancingSetQuantity
        );

        address baseSetAddress = _exchangeIssuanceParams.setAddress;
        uint256 baseSetVaultQuantity = vaultInstance.getOwnerBalance(baseSetAddress, address(this));

        // Withdraw base SetToken from Vault to this contract
        coreInstance.withdrawModule(
            address(this),
            address(this),
            baseSetAddress,
            baseSetVaultQuantity
        );

        // Redeem base SetToken into components and perform trades / exchanges
        // into the receiveToken. The receiveTokens are transferred to this contract
        // as well as the remaining non-exchanged components
        exchangeIssuanceModuleInstance.exchangeRedeem(
            _exchangeIssuanceParams,
            _orderData
        );
    }
}

// File: set-protocol-contracts/contracts/core/modules/lib/ModuleCoreState.sol

/*
    Copyright 2018 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;





/**
 * @title ModuleCoreState
 * @author Set Protocol
 *
 * The ModuleCoreState library maintains Core-related state for modules
 */
contract ModuleCoreState {

    /* ============ State Variables ============ */

    // Address of core contract
    address public core;

    // Address of vault contract
    address public vault;

    // Instance of core contract
    ICore public coreInstance;

    // Instance of vault contract
    IVault public vaultInstance;

    /* ============ Public Getters ============ */

    /**
     * Constructor function for ModuleCoreState
     *
     * @param _core                The address of Core
     * @param _vault               The address of Vault
     */
    constructor(
        address _core,
        address _vault
    )
        public
    {
        // Commit passed address to core state variable
        core = _core;

        // Commit passed address to coreInstance state variable
        coreInstance = ICore(_core);

        // Commit passed address to vault state variable
        vault = _vault;

        // Commit passed address to vaultInstance state variable
        vaultInstance = IVault(_vault);
    }
}

// File: set-protocol-contracts/contracts/core/modules/lib/RebalancingSetIssuance.sol

/*
    Copyright 2019 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;








/**
 * @title RebalancingSetIssuance
 * @author Set Protocol
 *
 * The RebalancingSetIssuance contains utility functions used in rebalancing SetToken 
 * issuance
 */
contract RebalancingSetIssuance is 
    ModuleCoreState
{
    using SafeMath for uint256;
    using AddressArrayUtils for address[];

    // ============ Internal ============

    /**
     * Validates that wrapped Ether is a component of the SetToken
     *
     * @param  _setAddress            Address of the SetToken
     * @param  _wrappedEtherAddress   Address of wrapped Ether
     */
    function validateWETHIsAComponentOfSet(
        address _setAddress,
        address _wrappedEtherAddress
    )
        internal
        view
    {
        require(
            ISetToken(_setAddress).tokenIsComponent(_wrappedEtherAddress),
            "RebalancingSetIssuance.validateWETHIsAComponentOfSet: Components must contain weth"
        );
    }

    /**
     * Validates that the passed in address is tracked by Core and that the quantity
     * is a multiple of the natural unit
     *
     * @param  _rebalancingSetAddress    Address of the rebalancing SetToken to issue/redeem
     * @param  _rebalancingSetQuantity   The issuance quantity of rebalancing SetToken
     */   
    function validateRebalancingSetIssuance(
        address _rebalancingSetAddress,
        uint256 _rebalancingSetQuantity
    ) 
        internal
        view
    {
        // Expect rebalancing SetToken to be valid and enabled SetToken
        require(
            coreInstance.validSets(_rebalancingSetAddress),
            "RebalancingSetIssuance.validateRebalancingIssuance: Invalid or disabled SetToken address"
        );
        
        // Make sure Issuance quantity is multiple of the rebalancing SetToken natural unit
        require(
            _rebalancingSetQuantity.mod(ISetToken(_rebalancingSetAddress).naturalUnit()) == 0,
            "RebalancingSetIssuance.validateRebalancingIssuance: Quantity must be multiple of natural unit"
        );
    }

    /**
     * Given a rebalancing SetToken and a desired issue quantity, calculates the 
     * minimum issuable quantity of the base SetToken. If the calculated quantity is initially
     * not a multiple of the base SetToken's natural unit, the quantity is rounded up
     * to the next base set natural unit.
     *
     * @param  _rebalancingSetAddress    Address of the rebalancing SetToken to issue
     * @param  _rebalancingSetQuantity   The issuance quantity of rebalancing SetToken
     * @return requiredBaseSetQuantity   The quantity of base SetToken to issue
     */    
    function getBaseSetIssuanceRequiredQuantity(
        address _rebalancingSetAddress,
        uint256 _rebalancingSetQuantity
    )
        internal
        view
        returns (uint256)
    {
        IRebalancingSetToken rebalancingSet = IRebalancingSetToken(_rebalancingSetAddress);

        uint256 unitShares = rebalancingSet.unitShares();
        uint256 naturalUnit = rebalancingSet.naturalUnit();

        uint256 requiredBaseSetQuantity = _rebalancingSetQuantity.div(naturalUnit).mul(unitShares);

        address baseSet = rebalancingSet.currentSet();
        uint256 baseSetNaturalUnit = ISetToken(baseSet).naturalUnit();

        // If there is a mismatch between the required quantity and the base SetToken natural unit,
        // round up to the next base SetToken natural unit if required.
        uint256 roundDownQuantity = requiredBaseSetQuantity.mod(baseSetNaturalUnit);
        if (roundDownQuantity > 0) {
            requiredBaseSetQuantity = requiredBaseSetQuantity.sub(roundDownQuantity).add(baseSetNaturalUnit);
        }

        return requiredBaseSetQuantity;
    }


    /**
     * Given a rebalancing SetToken address, retrieve the base SetToken quantity redeem quantity based on the quantity
     * held in the Vault. Rounds down to the nearest base SetToken natural unit
     *
     * @param _baseSetAddress             The address of the base SetToken
     * @return baseSetRedeemQuantity      The quantity of base SetToken to redeem
     */
    function getBaseSetRedeemQuantity(
        address _baseSetAddress
    )
        internal
        view
        returns (uint256)
    {
        // Get base SetToken Details from the rebalancing SetToken
        uint256 baseSetNaturalUnit = ISetToken(_baseSetAddress).naturalUnit();
        uint256 baseSetBalance = vaultInstance.getOwnerBalance(
            _baseSetAddress,
            address(this)
        );

        // Round the balance down to the base SetToken natural unit and return
        return baseSetBalance.sub(baseSetBalance.mod(baseSetNaturalUnit));
    }

    /**
     * Checks the base SetToken balances in the Vault and on the contract. 
     * Sends any positive quantity to the user directly or into the Vault
     * depending on the keepChangeInVault flag.
     *
     * @param _baseSetAddress             The address of the base SetToken
     * @param _transferProxyAddress       The address of the TransferProxy
     * @param  _keepChangeInVault         Boolean signifying whether excess base SetToken is transferred to the user 
     *                                     or left in the vault
     */
    function returnExcessBaseSet(
        address _baseSetAddress,
        address _transferProxyAddress,
        bool _keepChangeInVault
    )
        internal
    {
        returnExcessBaseSetFromContract(_baseSetAddress, _transferProxyAddress, _keepChangeInVault);

        returnExcessBaseSetInVault(_baseSetAddress, _keepChangeInVault);
    }   

    /**
     * Checks the base SetToken balances on the contract and sends
     * any positive quantity to the user directly or into the Vault
     * depending on the keepChangeInVault flag.
     *
     * @param _baseSetAddress             The address of the base SetToken
     * @param _transferProxyAddress       The address of the TransferProxy
     * @param  _keepChangeInVault         Boolean signifying whether excess base SetToken is transfered to the user 
     *                                     or left in the vault
     */
    function returnExcessBaseSetFromContract(
        address _baseSetAddress,
        address _transferProxyAddress,
        bool _keepChangeInVault
    )
        internal
    {
        uint256 baseSetQuantity = ERC20Wrapper.balanceOf(_baseSetAddress, address(this));
        
        if (baseSetQuantity == 0) { 
            return; 
        } else if (_keepChangeInVault) {
            // Ensure base SetToken allowance
            ERC20Wrapper.ensureAllowance(
                _baseSetAddress,
                address(this),
                _transferProxyAddress,
                baseSetQuantity
            );

            // Deposit base SetToken to the user
            coreInstance.depositModule(
                address(this),
                msg.sender,
                _baseSetAddress,
                baseSetQuantity
            );
        } else {
            // Transfer directly to the user
            ERC20Wrapper.transfer(
                _baseSetAddress,
                msg.sender,
                baseSetQuantity
            );
        }
    }

    /**
     * Checks the base SetToken balances in the Vault and sends
     * any positive quantity to the user directly or into the Vault
     * depending on the keepChangeInVault flag.
     *
     * @param _baseSetAddress             The address of the base SetToken
     * @param  _keepChangeInVault         Boolean signifying whether excess base SetToken is transfered to the user 
     *                                     or left in the vault
     */
    function returnExcessBaseSetInVault(
        address _baseSetAddress,
        bool _keepChangeInVault
    )
        internal
    {
        // Return base SetToken if any that are in the Vault
        uint256 baseSetQuantityInVault = vaultInstance.getOwnerBalance(
            _baseSetAddress,
            address(this)
        );
        
        if (baseSetQuantityInVault == 0) { 
            return; 
        } else if (_keepChangeInVault) {
            // Transfer ownership within the vault to the user
            coreInstance.internalTransfer(
                _baseSetAddress,
                msg.sender,
                baseSetQuantityInVault
            );
        } else {
            // Transfer ownership directly to the user
            coreInstance.withdrawModule(
                address(this),
                msg.sender,
                _baseSetAddress,
                baseSetQuantityInVault
            );
        }
    }   
}

// File: set-protocol-contracts/contracts/core/modules/RebalancingSetIssuanceModule.sol

/*
    Copyright 2019 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;










/**
 * @title RebalancingSetIssuanceModule
 * @author Set Protocol
 *
 * A module that includes functions for issuing / redeeming rebalancing SetToken to/from its base components and ether.
 */
contract RebalancingSetIssuanceModule is
    ModuleCoreState,
    RebalancingSetIssuance,
    ReentrancyGuard
{
    using SafeMath for uint256;

    // Address and instance of TransferProxy contract
    address public transferProxy;

    // Address and instance of Wrapped Ether contract
    IWETH public weth;

    /* ============ Events ============ */

    event LogRebalancingSetIssue(
        address indexed rebalancingSetAddress,
        address indexed callerAddress,
        uint256 rebalancingSetQuantity
    );

    event LogRebalancingSetRedeem(
        address indexed rebalancingSetAddress,
        address indexed callerAddress,
        uint256 rebalancingSetQuantity
    );

    /* ============ Constructor ============ */

    /**
     * Constructor function for RebalancingSetIssuanceModule
     *
     * @param _core                The address of Core
     * @param _vault               The address of Vault
     * @param _transferProxy       The address of TransferProxy
     * @param _weth                The address of Wrapped Ether
     */
    constructor(
        address _core,
        address _vault,
        address _transferProxy,
        IWETH _weth
    )
        public
        ModuleCoreState(
            _core,
            _vault
        )
    {
        // Commit the WETH instance
        weth = _weth;

        // Commit the transferProxy instance
        transferProxy = _transferProxy;
    }

    /**
     * Fallback function. Disallows ether to be sent to this contract without data except when
     * unwrapping WETH.
     */
    function ()
        external
        payable
    {
        require(
            msg.sender == address(weth),
            "RebalancingSetIssuanceModule.fallback: Cannot receive ETH directly unless unwrapping WETH"
        );
    }

    /* ============ External Functions ============ */

    /**
     * Issue a rebalancing SetToken using the base components of the base SetToken.
     * The base SetToken is then issued into the rebalancing SetToken. The base SetToken quantity issued is calculated
     * by taking the rebalancing SetToken's quantity, unit shares, and natural unit. If the calculated quantity is not
     * a multiple of the natural unit of the base SetToken, the quantity is rounded up to the base SetToken natural unit.
     * NOTE: Potential to receive more baseSet than expected if someone transfers some to this module.
     * Be careful with balance checks.
     *
     * @param  _rebalancingSetAddress    Address of the rebalancing SetToken to issue
     * @param  _rebalancingSetQuantity   The issuance quantity of rebalancing SetToken
     * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transfered to the user 
     *                                     or left in the vault
     */
    function issueRebalancingSet(
        address _rebalancingSetAddress,
        uint256 _rebalancingSetQuantity,
        bool _keepChangeInVault
    )
        external
        nonReentrant
    {
        // Get baseSet address and quantity required for issuance of Rebalancing Set
        (
            address baseSetAddress,
            uint256 requiredBaseSetQuantity
        ) = getBaseSetAddressAndQuantity(_rebalancingSetAddress, _rebalancingSetQuantity);

        // Issue base SetToken to this contract, held in this contract
        coreInstance.issueModule(
            msg.sender,
            address(this),
            baseSetAddress,
            requiredBaseSetQuantity
        );

        // Ensure base SetToken allowance to the transferProxy
        ERC20Wrapper.ensureAllowance(
            baseSetAddress,
            address(this),
            transferProxy,
            requiredBaseSetQuantity
        );

        // Issue rebalancing SetToken to the sender and return any excess base to sender
        issueRebalancingSetAndReturnExcessBase(
            _rebalancingSetAddress,
            baseSetAddress,
            _rebalancingSetQuantity,
            _keepChangeInVault
        );
    }

    /**
     * Issue a rebalancing SetToken using the base components and ether of the base SetToken. The ether is wrapped 
     * into wrapped Ether and utilized in issuance.
     * The base SetToken is then issued and reissued into the rebalancing SetToken. Read more about base SetToken quantity
     * in the issueRebalancingSet function.
     * NOTE: Potential to receive more baseSet and ether dust than expected if someone transfers some to this module.
     * Be careful with balance checks.
     *
     * @param  _rebalancingSetAddress    Address of the rebalancing SetToken to issue
     * @param  _rebalancingSetQuantity   The issuance quantity of rebalancing SetToken
     * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transfered to the user 
     *                                     or left in the vault
     */
    function issueRebalancingSetWrappingEther(
        address _rebalancingSetAddress,
        uint256 _rebalancingSetQuantity,
        bool _keepChangeInVault
    )
        external
        payable
        nonReentrant
    {
        // Get baseSet address and quantity required for issuance of Rebalancing Set
        (
            address baseSetAddress,
            uint256 requiredBaseSetQuantity
        ) = getBaseSetAddressAndQuantity(_rebalancingSetAddress, _rebalancingSetQuantity);

        // Validate that WETH is a component of baseSet
        validateWETHIsAComponentOfSet(baseSetAddress, address(weth));

        // Deposit all the required non-weth components to the vault under the name of this contract
        // The required ether is wrapped and approved to the transferProxy
        depositComponentsAndHandleEth(
            baseSetAddress,
            requiredBaseSetQuantity
        );

        // Issue base SetToken to this contract, with the base SetToken held in the Vault
        coreInstance.issueInVault(
            baseSetAddress,
            requiredBaseSetQuantity
        );

        // Note: Don't need to set allowance of the base SetToken as the base SetToken is already in the vault

        // Issue rebalancing SetToken to the sender and return any excess base to sender
        issueRebalancingSetAndReturnExcessBase(
            _rebalancingSetAddress,
            baseSetAddress,
            _rebalancingSetQuantity,
            _keepChangeInVault
        );

        // Any eth that is not wrapped is sent back to the user
        // Only the amount required for the base SetToken issuance is wrapped.
        uint256 leftoverEth = address(this).balance;
        if (leftoverEth > 0) {
            msg.sender.transfer(leftoverEth);
        }
    }

    /**
     * Redeems a rebalancing SetToken into the base components of the base SetToken.
     * NOTE: Potential to receive more baseSet than expected if someone transfers some to this module.
     * Be careful with balance checks.
     *
     * @param  _rebalancingSetAddress    Address of the rebalancing SetToken to redeem
     * @param  _rebalancingSetQuantity   The Quantity of the rebalancing SetToken to redeem
     * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transfered to the user 
     *                                     or left in the vault
     */
    function redeemRebalancingSet(
        address _rebalancingSetAddress,
        uint256 _rebalancingSetQuantity,
        bool _keepChangeInVault
    )
        external
        nonReentrant
    {
        // Validate the rebalancing SetToken is valid and the quantity is a multiple of the natural unit
        validateRebalancingSetIssuance(_rebalancingSetAddress, _rebalancingSetQuantity);

        // Redeem RB Set to the vault attributed to this contract
        coreInstance.redeemModule(
            msg.sender,
            address(this),
            _rebalancingSetAddress,
            _rebalancingSetQuantity
        );

        // Calculate the base SetToken Redeem quantity
        address baseSetAddress = IRebalancingSetToken(_rebalancingSetAddress).currentSet();
        uint256 baseSetRedeemQuantity = getBaseSetRedeemQuantity(baseSetAddress);

        // Withdraw base SetToken to this contract
        coreInstance.withdraw(
            baseSetAddress,
            baseSetRedeemQuantity
        );

        // Redeem base SetToken and send components to the the user
        // Set exclude to 0, as tokens in rebalancing SetToken are already whitelisted
        coreInstance.redeemAndWithdrawTo(
            baseSetAddress,
            msg.sender,
            baseSetRedeemQuantity,
            0
        );

        // Transfer any change of the base SetToken to the end user
        returnExcessBaseSet(baseSetAddress, transferProxy, _keepChangeInVault);

        // Log RebalancingSetRedeem
        emit LogRebalancingSetRedeem(
            _rebalancingSetAddress,
            msg.sender,
            _rebalancingSetQuantity
        );
    }

    /**
     * Redeems a rebalancing SetToken into the base components of the base SetToken. Unwraps
     * wrapped ether and sends eth to the user. If no wrapped ether in Set then will REVERT.
     * NOTE: Potential to receive more baseSet and ether dust than expected if someone transfers some to this module.
     * Be careful with balance checks.
     *
     * @param  _rebalancingSetAddress    Address of the rebalancing SetToken to redeem
     * @param  _rebalancingSetQuantity   The Quantity of the rebalancing SetToken to redeem
     * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transferred to the user 
     *                                   or left in the vault
     */
    function redeemRebalancingSetUnwrappingEther(
        address _rebalancingSetAddress,
        uint256 _rebalancingSetQuantity,
        bool _keepChangeInVault
    )
        external
        nonReentrant
    {
        // Validate the rebalancing SetToken is valid and the quantity is a multiple of the natural unit
        validateRebalancingSetIssuance(_rebalancingSetAddress, _rebalancingSetQuantity);

        address baseSetAddress = IRebalancingSetToken(_rebalancingSetAddress).currentSet();

        validateWETHIsAComponentOfSet(baseSetAddress, address(weth));

        // Redeem rebalancing SetToken to the vault attributed to this contract
        coreInstance.redeemModule(
            msg.sender,
            address(this),
            _rebalancingSetAddress,
            _rebalancingSetQuantity
        );

        // Calculate the base SetToken Redeem quantity
        uint256 baseSetRedeemQuantity = getBaseSetRedeemQuantity(baseSetAddress);

        // Withdraw base SetToken to this contract
        coreInstance.withdraw(
            baseSetAddress,
            baseSetRedeemQuantity
        );

        // Redeem the base SetToken. The components stay in the vault
        coreInstance.redeem(
            baseSetAddress,
            baseSetRedeemQuantity
        );

        // Loop through the base SetToken components and transfer to sender.
        withdrawComponentsToSenderWithEther(baseSetAddress);

        // Transfer any change of the base SetToken to the end user
        returnExcessBaseSet(baseSetAddress, transferProxy, _keepChangeInVault);

        // Log RebalancingSetRedeem
        emit LogRebalancingSetRedeem(
            _rebalancingSetAddress,
            msg.sender,
            _rebalancingSetQuantity
        );
    }

    /* ============ Private Functions ============ */

    /**
     * Gets base set address from rebalancing set token and calculates amount of base set needed
     * for issuance.
     *
     * @param  _rebalancingSetAddress    Address of the RebalancingSetToken to issue
     * @param  _rebalancingSetQuantity   The Quantity of the rebalancing SetToken to issue
     * @return baseSetAddress            The address of RebalancingSet's base SetToken
     * @return requiredBaseSetQuantity   The quantity of base SetToken to issue
     */
    function getBaseSetAddressAndQuantity(
        address _rebalancingSetAddress,
        uint256 _rebalancingSetQuantity
    )
        internal
        view
        returns (address, uint256)
    {
        // Validate the rebalancing SetToken is valid and the quantity is a multiple of the natural unit
        validateRebalancingSetIssuance(_rebalancingSetAddress, _rebalancingSetQuantity);

        address baseSetAddress = IRebalancingSetToken(_rebalancingSetAddress).currentSet();

        // Calculate required base SetToken quantity
        uint256 requiredBaseSetQuantity = getBaseSetIssuanceRequiredQuantity(
            _rebalancingSetAddress,
            _rebalancingSetQuantity
        );

        return (baseSetAddress, requiredBaseSetQuantity);        
    }

    /**
     * Issues the rebalancing set token to sender and returns any excess baseSet.
     *
     * @param  _rebalancingSetAddress    Address of the rebalancing SetToken to issue
     * @param  _baseSetAddress           Address of the rebalancing SetToken's base set
     * @param  _rebalancingSetQuantity   The Quantity of the rebalancing SetToken to redeem
     * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transferred to the user 
     *                                   or left in the vault
     */
    function issueRebalancingSetAndReturnExcessBase(
        address _rebalancingSetAddress,
        address _baseSetAddress,
        uint256 _rebalancingSetQuantity,
        bool _keepChangeInVault
    )
        internal
    {
        // Issue rebalancing SetToken to the sender
        coreInstance.issueTo(
            msg.sender,
            _rebalancingSetAddress,
            _rebalancingSetQuantity
        );

        // Return any excess base SetToken token to the sender
        returnExcessBaseSet(_baseSetAddress, transferProxy, _keepChangeInVault);

        // Log RebalancingSetIssue
        emit LogRebalancingSetIssue(
            _rebalancingSetAddress,
            msg.sender,
            _rebalancingSetQuantity
        );       
    }

    /**
     * During issuance, deposit the required quantity of base SetToken, wrap Ether, and deposit components
     * (excluding Ether, which is deposited during issuance) to the Vault in the name of the module.
     *
     * @param  _baseSetAddress           Address of the base SetToken token
     * @param  _baseSetQuantity          The Quantity of the base SetToken token to issue
     */
    function depositComponentsAndHandleEth(
        address _baseSetAddress,
        uint256 _baseSetQuantity
    )
        private
    {
        ISetToken baseSet = ISetToken(_baseSetAddress);

        address[] memory baseSetComponents = baseSet.getComponents();
        uint256[] memory baseSetUnits = baseSet.getUnits();
        uint256 baseSetNaturalUnit = baseSet.naturalUnit();

       // Loop through the base SetToken components and deposit components 
        for (uint256 i = 0; i < baseSetComponents.length; i++) {
            address currentComponent = baseSetComponents[i];
            uint256 currentUnit = baseSetUnits[i];

            // Calculate required component quantity
            uint256 currentComponentQuantity = _baseSetQuantity.div(baseSetNaturalUnit).mul(currentUnit);

            // If address is weth, deposit weth and transfer eth
            if (currentComponent == address(weth)) {
                // Expect the ether included exceeds the required Weth quantity
                require(
                    msg.value >= currentComponentQuantity,
                    "RebalancingSetIssuanceModule.depositComponentsAndHandleEth: Not enough ether included for base SetToken"
                );

                // wrap the required ether quantity
                weth.deposit.value(currentComponentQuantity)();

                // Ensure weth allowance
                ERC20Wrapper.ensureAllowance(
                    address(weth),
                    address(this),
                    transferProxy,
                    currentComponentQuantity
                );
            } else {
                // Deposit components to the vault in the name of the contract
                coreInstance.depositModule(
                    msg.sender,
                    address(this),
                    currentComponent,
                    currentComponentQuantity
                );                
            }
        }
    }

    /**
     * During redemption, withdraw the required quantity of base SetToken, unwrapping Ether, and withdraw
     * components to the sender
     *
     * @param  _baseSetAddress           Address of the base SetToken
     */
    function withdrawComponentsToSenderWithEther(
        address _baseSetAddress
    )
        private
    {
        address[] memory baseSetComponents = ISetToken(_baseSetAddress).getComponents();

        // Loop through the base SetToken components.
        for (uint256 i = 0; i < baseSetComponents.length; i++) {
            address currentComponent = baseSetComponents[i];
            uint256 currentComponentQuantity = vaultInstance.getOwnerBalance(
                currentComponent,
                address(this)
            );

            // If address is weth, withdraw weth and transfer eth to sender
            if (currentComponent == address(weth)) {
                // Transfer the wrapped ether to this address from the Vault
                coreInstance.withdrawModule(
                    address(this),
                    address(this),
                    address(weth),
                    currentComponentQuantity
                );

                // Unwrap wrapped ether
                weth.withdraw(currentComponentQuantity);

                // Transfer to recipient
                msg.sender.transfer(currentComponentQuantity);
            } else {
                // Withdraw component from the Vault and send to the user
                coreInstance.withdrawModule(
                    address(this),
                    msg.sender,
                    currentComponent,
                    currentComponentQuantity
                );
            }
        }
    }
}

// File: set-protocol-contracts/contracts/core/interfaces/IAddressToAddressWhiteList.sol

/*
    Copyright 2020 Set Labs Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity 0.5.7;

/**
 * @title IAddressToAddressWhiteList
 * @author Set Protocol
 *
 * The IAddressToAddressWhiteList interface exposes the whitelist mapping to check components
 */
interface IAddressToAddressWhiteList {

    /* ============ External Functions ============ */

    /**
     * Returns value of key type address passed in (not in array form)
     *
     * @param  _key     Address to check
     * @return bool                Whether passed in address is whitelisted
     */
    function whitelist(
        address _key
    )
        external
        view
        returns (address);

    /**
     * Verifies an array of addresses against the whitelist
     *
     * @param  _keys                Array of key type addresses to check if value exists
     * @return bool                 Whether all addresses in the list are whitelisted
     */
    function areValidAddresses(
        address[] calldata _keys
    )
        external
        view
        returns (bool);

    /**
     * Return array of value type addresses based on passed in key type addresses 
     *
     * @param  _key                Array of key type addresses to get value type addresses for
     * @return address[]           Array of value type addresses
     */
    function getValues(
        address[] calldata _key
    )
        external
        view
        returns (address[] memory);

    /**
     * Return value type address associated with a passed key type address 
     *
     * @param  _key               Address of key type
     * @return address            Address associated with _key 
     */
    function getValue(
        address _key
    )
        external
        view
        returns (address);

    /**
     * Return array of all whitelisted addresses
     *
     * @return address[]      Array of key type addresses
     */
    function validAddresses()
        external
        view
        returns (address[] memory);
}

// File: contracts/SmartWalletProd.sol

// contracts/SmartWalletProd.sol
pragma solidity ^0.5.0;












contract SmartWalletProd is Initializable, ReentrancyGuardEmber, WhitelistedRoleEmber {
    using SafeMath for uint256;

    address constant public transfersProxy = 0x882d80D3a191859d64477eb78Cca46599307ec1C;
    address payable constant public rebalancingSetExchangeIssuanceModule = 0xd4240987D6F92B06c8B5068B1E4006A97c47392b;
    address payable constant public rebalancingSetIssuanceModule = 0xDA6786379FF88729264d31d472FA917f5E561443;
    address payable constant public cTokenaddressToAddressWhiteList = 0x5BA020a8835ed40936941562bdF42D66F65fc00f;

    // Nonces to prevent replay attacks
    mapping(uint256 => bool) issueRebalancingSetUsedNonces;
    mapping(uint256 => bool) redeemRebalancingSetUsedNonces;

    event IssueRebalancingSetFromERC20Token(uint256 quantity);
    event IssueRebalancingSetFromComponents(uint256 quantity);
    event IssueBaseSetFromComponents(uint256 quantity, uint256 roundedQuantity);
    event RedeemedRebalancingSetIntoERC20(address erc20, uint256 quantity);
    event MissingComponentForIssueRebalancingSetFromAllComponents(address componentMissing);

    function initialize(address _owner) public initializer {
      WhitelistedRoleEmber.initialize(_owner);
      ReentrancyGuardEmber.initialize();
    }

    function() external payable { }

    function withdrawAllAdmin(address [] calldata _tokenAddresses)
      external
      nonReentrant
      onlyWhitelistAdmin
    {
      for (uint i=0; i<_tokenAddresses.length; i++) {
          uint256 tokenBalance = ERC20Wrapper.balanceOf(_tokenAddresses[i], address(this));
          ERC20Wrapper.transfer(
              _tokenAddresses[i],
              msg.sender,
              tokenBalance
          );
      }
    }

    function getIssueRebalancingSetSigner(address _rebalancingSetAddress, address _paymentTokenAddress, uint256 _nonce, bytes memory _signature) private view returns (address) {
      bytes32 msgHash = OpenZeppelinUpgradesECDSA.toEthSignedMessageHash(
      keccak256(
          abi.encodePacked(
            _rebalancingSetAddress,
            _paymentTokenAddress,
            _nonce,
            address(this)
          )
        )
      );
      return OpenZeppelinUpgradesECDSA.recover(msgHash, _signature);
    }

    /**
    * https://github.com/SetProtocol/set-protocol-contracts/blob/bb4f12cd07c7ba3adb8682e6b0f0f8b37953700c/contracts/core/modules/RebalancingSetExchangeIssuanceModule.sol
    */
    function issueRebalancingSetFromERC20(
       address _rebalancingSetAddress,
       uint256 _rebalancingSetQuantity,
       address _paymentTokenAddress,
       uint256 _paymentTokenQuantity,
       ExchangeIssuanceLibrary.ExchangeIssuanceParams memory _exchangeIssuanceParams,
       bytes memory _orderData,
       uint256 _nonce,
       bytes memory _signature
    )
      public
      nonReentrant
    {
      require(!issueRebalancingSetUsedNonces[_nonce], "Replay attack detected.");
      issueRebalancingSetUsedNonces[_nonce] = true;
      address signer = getIssueRebalancingSetSigner(_rebalancingSetAddress, _paymentTokenAddress, _nonce, _signature);
      require(signer != address(0), "Invalid signature");
      require(isWhitelistAdmin(signer), "signer is not an admin");

      uint256 paymentTokenBalance = ERC20Wrapper.balanceOf(_paymentTokenAddress, address(this));
      require(paymentTokenBalance > 0, "Zero payment token balance");

      // Need to approve transferProxy to move our payment erc20 token
      ERC20Wrapper.approve(_paymentTokenAddress, transfersProxy, uint256(-1));

      // Check if we already have all components
      ISetToken baseSet = ISetToken(IRebalancingSetToken(_rebalancingSetAddress).currentSet());
      if (baseSet.getComponents().length == 1 &&
          (_paymentTokenAddress == baseSet.getComponents()[0]
          || _paymentTokenAddress == IAddressToAddressWhiteList(cTokenaddressToAddressWhiteList).whitelist(baseSet.getComponents()[0])
      )) {
            // we have all base set components
            RebalancingSetIssuanceModule(rebalancingSetIssuanceModule).issueRebalancingSet(
              _rebalancingSetAddress, _rebalancingSetQuantity, true);
      } else {
        RebalancingSetExchangeIssuanceModule(rebalancingSetExchangeIssuanceModule).issueRebalancingSetWithERC20(
          _rebalancingSetAddress,
          _rebalancingSetQuantity,
          _paymentTokenAddress,
          _paymentTokenQuantity,
          _exchangeIssuanceParams,
          _orderData,
          true
        );
      }

      uint256 rebalancingTokenSetBalance = ERC20Wrapper.balanceOf(_rebalancingSetAddress, address(this));

      emit IssueRebalancingSetFromERC20Token(rebalancingTokenSetBalance);

      issueRebalancingSetFromRemainingComponents(_rebalancingSetAddress);
    }

    function issueRebalancingSetFromRemainingComponents(address _rebalancingSetAddress) private {
      IRebalancingSetToken rebalancingSet = IRebalancingSetToken(_rebalancingSetAddress);
      address baseSetAddress = rebalancingSet.currentSet();
      ISetToken baseSet = ISetToken(baseSetAddress);

      // We need to check we have all components
      uint256 minPossibleBaseSetQuantity = 2**256 - 1;
      bool missingComponents = false;
      for (uint256 i = 0; i < baseSet.getComponents().length; i++) {
        uint256 componentBalance = ERC20Wrapper.balanceOf(baseSet.getComponents()[i], address(this));
        if (componentBalance == 0) {
          // Nothing to do
          emit MissingComponentForIssueRebalancingSetFromAllComponents(baseSet.getComponents()[i]);
          missingComponents = true;
          break;
        }

        ERC20Wrapper.approve(baseSet.getComponents()[i], transfersProxy, uint256(-1));

        uint256 possibleBaseSetQuantity = baseSet.naturalUnit().div(baseSet.getUnits()[i]).mul(componentBalance);
        if(possibleBaseSetQuantity < minPossibleBaseSetQuantity) {
          minPossibleBaseSetQuantity = possibleBaseSetQuantity;
        }
      }

      if (!missingComponents) {
        // Need to round
        uint256 rationalBaseSetQuantity = minPossibleBaseSetQuantity.div(baseSet.naturalUnit());
        uint256 roundedBaseSetQuantity = rationalBaseSetQuantity.mul(baseSet.naturalUnit());

        emit IssueBaseSetFromComponents(minPossibleBaseSetQuantity, roundedBaseSetQuantity);
        uint256 rebalancingSetUnitShares = rebalancingSet.unitShares();
        uint256 rebalancingSetNaturalUnits = rebalancingSet.naturalUnit();
        uint256 impliedRebalancingSetQuantityFromBaseSet = roundedBaseSetQuantity
          .mul(rebalancingSetNaturalUnits)
          .div(rebalancingSetUnitShares);

        uint256 rationalRebalancingSetQuantity = impliedRebalancingSetQuantityFromBaseSet.div(rebalancingSet.naturalUnit());
        uint256 roundedRebalancingSetQuantity = rationalRebalancingSetQuantity.mul(rebalancingSet.naturalUnit());

        RebalancingSetIssuanceModule(rebalancingSetIssuanceModule).issueRebalancingSet(
          _rebalancingSetAddress, roundedRebalancingSetQuantity, true);

        // Transfer outputToken to the caller
        uint256 rebalancingTokenSetBalance = ERC20Wrapper.balanceOf(_rebalancingSetAddress, address(this));

        emit IssueRebalancingSetFromComponents(rebalancingTokenSetBalance);

      }
    }

    function getRedeemRebalancingSetSigner(address _rebalancingSetAddress, address _outputTokenAddress, address _to, uint256 _nonce, bytes memory _signature) private view returns (address) {
      bytes32 msgHash = OpenZeppelinUpgradesECDSA.toEthSignedMessageHash(
      keccak256(
          abi.encodePacked(
            _rebalancingSetAddress,
            _outputTokenAddress,
            _to,
            _nonce,
            address(this)
          )
        )
      );
      return OpenZeppelinUpgradesECDSA.recover(msgHash, _signature);
    }

    function redeemRebalancingSetIntoERC20(
      address _rebalancingSetAddress,
      uint256 _rebalancingSetQuantity,
      address _outputTokenAddress,
      ExchangeIssuanceLibrary.ExchangeIssuanceParams memory _exchangeIssuanceParams,
      bytes memory _orderData,
      address _to,
      uint256 _nonce,
      bytes memory _signature
    )
        public
        nonReentrant
    {

      require(!redeemRebalancingSetUsedNonces[_nonce], "Replay attack detected.");
      redeemRebalancingSetUsedNonces[_nonce] = true;
      address signer = getRedeemRebalancingSetSigner(_rebalancingSetAddress, _outputTokenAddress, _to, _nonce, _signature);
      require(signer != address(0), "Invalid signature");
      require(isWhitelistAdmin(signer), "signer is not an admin");

      // Check if we already have the output token as a component of the set
      ISetToken baseSet = ISetToken(IRebalancingSetToken(_rebalancingSetAddress).currentSet());
      if (baseSet.getComponents().length == 1 &&
          (_outputTokenAddress == baseSet.getComponents()[0]
          ||
          _outputTokenAddress == IAddressToAddressWhiteList(cTokenaddressToAddressWhiteList).whitelist(baseSet.getComponents()[0])
      )) {
        // we already have the output token as a base set component. no need to use exchanges.
        RebalancingSetIssuanceModule(rebalancingSetIssuanceModule).redeemRebalancingSet(
          _rebalancingSetAddress, _rebalancingSetQuantity, false);
      } else {
        RebalancingSetExchangeIssuanceModule(rebalancingSetExchangeIssuanceModule).redeemRebalancingSetIntoERC20(
          _rebalancingSetAddress,
          _rebalancingSetQuantity,
          _outputTokenAddress,
          _exchangeIssuanceParams,
          _orderData,
          false
        );
      }

      // Transfer outputToken out of the smart wallet back to the owner
      uint256 outputTokenBalance = ERC20Wrapper.balanceOf(_outputTokenAddress, address(this));

      ERC20Wrapper.transfer(
          _outputTokenAddress,
          _to,
          outputTokenBalance
      );

      emit RedeemedRebalancingSetIntoERC20(_outputTokenAddress, outputTokenBalance);
    }

}