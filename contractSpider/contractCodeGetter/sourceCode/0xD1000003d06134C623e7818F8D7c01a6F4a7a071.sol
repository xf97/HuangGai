/**
 *Submitted for verification at Etherscan.io on 2020-06-28
*/

// SPDX-License-Identifier: MIT
//      _ __  __ __  __ __  __     _
//     | |  \/  |  \/  |  \/  |   (_)
//   __| | \  / | \  / | \  / |    _  ___
//  / _` | |\/| | |\/| | |\/| |   | |/ _ \
// | (_| | |  | | |  | | |  | |  _| | (_) |
//  \__,_|_|  |_|_|  |_|_|  |_| (_)_|\___/

// dMMM dApp: https://dMMM.io
// Official Website: http://d-mmm.github.io/
// Telegram Channel:  https://t.me/dMMM2020
// Github: https://github.com/d-mmm
// WhitePaper: https://dMMM.io/whitepaper

pragma solidity >=0.6.0;

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
     *
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
     *
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
     *
     * - Subtraction cannot overflow.
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
     *
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }

    function per(uint256 a, uint256 base, uint256 percent) internal pure returns (uint256) {
        return div(mul(a,percent),base);
    }
}
// SPDX-License-Identifier: MIT



/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
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
// SPDX-License-Identifier: MIT



interface IMaster {
    function isOwner(address _addr) external view returns (bool);

    function payableOwner() external view returns (address payable);

    function isInternal(address _addr) external view returns (bool);

    function getLatestAddress(bytes2 _contractName)
        external
        view
        returns (address contractAddress);
}
// SPDX-License-Identifier: MIT



interface ILast100Logic {
    function checkUserAvailable(address payable from)
        external
        returns (uint256);

    function internalExchange() external;
}
// SPDX-License-Identifier: MIT



interface ILast100 {
    function sendToken(address to, uint256 amt) external;

    function sendETH(address payable to, uint256 amt) external;
}
// SPDX-License-Identifier: MIT



interface IDeFiStorage {
    enum ConfigType {
        InvestAmt,
        StaticIncomeAmt,
        DynamicIncomePercent,
        ClaimFeePercent,
        UpgradeRequiredInviteValidPlayerCount,
        UpgradeRequiredMarketPerformance,
        UpgradeRequiredSelfInvestCount
    }
    enum InvestType {Newbie, Open, PreOrder}
    enum GlobalStatus {Pending, Started, Bankruptcy, Ended}
    event GlobalBlocks(uint256 indexed eventID, uint256[3] blocks);

    // public
    function getCurrentRoundID(bool enableCurrentBlock)
        external
        view
        returns (uint256);

    function getAvailableRoundID(bool isNewUser, bool enableCurrentBlock)
        external
        view
        returns (uint256 id, InvestType investType);

    function getInvestGear(uint256 usdAmt) external view returns (uint256);

    function U2T(uint256 usdAmt) external view returns (uint256);

    function U2E(uint256 usdAmt) external view returns (uint256);

    function T2U(uint256 tokenAmt) external view returns (uint256);

    function E2U(uint256 etherAmt) external view returns (uint256);

    function T2E(uint256 tokenAmt) external view returns (uint256);

    function E2T(uint256 etherAmt) external view returns (uint256);

    function getGlobalStatus() external view returns (GlobalStatus);

    function last100() external view returns (uint256[100] memory);

    function getGlobalBlocks() external view returns (uint256[3] memory);

    function getDeFiAccounts() external view returns (uint256[5] memory);

    function getPoolSplitStats() external view returns (uint256[3] memory);

    function getPoolSplitPercent(uint256 roundID) external view returns (uint256[6] memory splitPrcent, uint256[2] memory nodeCount);

    // internal
    function isLast100AndLabel(uint256 userID) external returns (bool);

    function increaseRoundData(
        uint256 roundID,
        uint256 dataID,
        uint256 num
    ) external;

    function getNodePerformance(
        uint256 roundID,
        uint256 nodeID,
        bool isSuperNode
    ) external view returns (uint256);

    function increaseUserData(
        uint256 userID,
        uint256 dataID,
        uint256 num,
        bool isSub,
        bool isSet
    ) external;

    function checkRoundAvailableAndUpdate(
        bool isNewUser,
        uint256 roundID,
        uint256 usdAmt,
        uint256 tokenAmt
    ) external returns (bool success);

    function increaseDeFiAccount(
        uint256 accountID,
        uint256 num,
        bool isSub
    ) external returns (bool);

    function getUser(uint256 userID)
        external
        view
        returns (
            bool[2] memory userBoolArray,
            uint256[21] memory userUint256Array
        );

    function getUserUint256Data(uint256 userID, uint256 dataID)
        external
        view
        returns (uint256);

    function setDeFiAccounts(uint256[5] calldata data) external;

    function splitDone() external;

    function getSelfInvestCount(uint256 userID)
        external
        view
        returns (uint256[5] memory selfInvestCount);

    function setSelfInvestCount(
        uint256 userID,
        uint256[5] calldata selfInvestCount
    ) external;

    function pushToInvestQueue(uint256 userID) external;

    function effectReferrals(
        uint256 userID,
        uint256 roundID,
        uint256 usdAmt,
        bool isNewUser
    ) external;

    function getLevelConfig(uint256 level, ConfigType configType)
        external
        view
        returns (uint256);

    function getUserFatherIDs(uint256 userID)
        external
        view
        returns (uint256[7] memory fathers);

    function getUserFatherActiveInfo(uint256 userID)
        external
        view
        returns (
            uint256[7] memory fathers,
            uint256[7] memory roundID,
            uint256[7] memory lastActive,
            address[7] memory addrs
        );

    function getUserFatherAddrs(uint256 userID)
        external
        view
        returns (address[7] memory fathers);

    function setGlobalBlocks(uint256[3] calldata blocks) external;

    function getGlobalNodeCount(uint256 roundID)
        external
        view
        returns (uint256[2] memory nodeCount);

    function getToken() external view returns (address);

    function setToken(address token) external;

    function getPlatformAddress() external view returns (address payable);

    function setPlatformAddress(address payable platformAddress) external;

    function getIDByAddr(address addr) external view returns (uint256);

    function getAddrByID(uint256 id) external view returns (address);

    function setUserAddr(uint256 id, address addr) external;

    function getIDByInviteCode(bytes32 inviteCode)
        external
        view
        returns (uint256);

    function getInviteCodeByID(uint256 id) external view returns (bytes32);

    function setUserInviteCode(uint256 id, bytes32 inviteCode) external;

    function issueUserID(address addr) external returns (uint256);

    function issueEventIndex() external returns (uint256);

    function setUser(
        uint256 userID,
        bool[2] calldata userBoolArry,
        uint256[21] calldata userUint256Array
    ) external;

    function deactivateUser(uint256 id) external;

    function getRound(uint256 roundID)
        external
        view
        returns (uint256[4] memory roundUint256Vars);

    function setRound(uint256 roundID, uint256[4] calldata roundUint256Vars)
        external;

    function setE2U(uint256 e2u) external;

    function setT2U(uint256 t2u) external;

    function setRoundLimit(uint256[] calldata roundID, uint256[] calldata limit)
        external;
}
// SPDX-License-Identifier: MIT
//      _ __  __ __  __ __  __     _
//     | |  \/  |  \/  |  \/  |   (_)
//   __| | \  / | \  / | \  / |    _  ___
//  / _` | |\/| | |\/| | |\/| |   | |/ _ \
// | (_| | |  | | |  | | |  | |  _| | (_) |
//  \__,_|_|  |_|_|  |_|_|  |_| (_)_|\___/

// dMMM dApp: https://dMMM.io
// Official Website: http://d-mmm.github.io/
// Telegram Channel:  https://t.me/dMMM2020
// Github: https://github.com/d-mmm
// WhitePaper: https://dMMM.io/whitepaper




// SPDX-License-Identifier: MIT




// SPDX-License-Identifier: MIT



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
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}


abstract contract IUpgradable {
    IMaster public master;

    modifier onlyInternal {
        assert(master.isInternal(msg.sender));
        _;
    }

    modifier onlyOwner {
        assert(master.isOwner(msg.sender));
        _;
    }

    modifier onlyMaster {
        assert(address(master) == msg.sender);
        _;
    }

    /**
     * @dev IUpgradable Interface to update dependent contract address
     */
    function changeDependentContractAddress() public virtual;

    /**
     * @dev change master address
     * @param addr is the new address
     */
    function changeMasterAddress(address addr) public {
        assert(Address.isContract(addr));
        assert(address(master) == address(0) || address(master) == msg.sender);
        master = IMaster(addr);
    }
}




// SPDX-License-Identifier: MIT



/**
 * @dev Interface of the global ERC1820 Registry, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
 * implementers for interfaces in this registry, as well as query support.
 *
 * Implementers may be shared by multiple accounts, and can also implement more
 * than a single interface for each account. Contracts can implement interfaces
 * for themselves, but externally-owned accounts (EOA) must delegate this to a
 * contract.
 *
 * {IERC165} interfaces can also be queried via the registry.
 *
 * For an in-depth explanation and source code analysis, see the EIP text.
 */
interface IERC1820Registry {
    /**
     * @dev Sets `newManager` as the manager for `account`. A manager of an
     * account is able to set interface implementers for it.
     *
     * By default, each account is its own manager. Passing a value of `0x0` in
     * `newManager` will reset the manager to this initial state.
     *
     * Emits a {ManagerChanged} event.
     *
     * Requirements:
     *
     * - the caller must be the current manager for `account`.
     */
    function setManager(address account, address newManager) external;

    /**
     * @dev Returns the manager for `account`.
     *
     * See {setManager}.
     */
    function getManager(address account) external view returns (address);

    /**
     * @dev Sets the `implementer` contract as ``account``'s implementer for
     * `interfaceHash`.
     *
     * `account` being the zero address is an alias for the caller's address.
     * The zero address can also be used in `implementer` to remove an old one.
     *
     * See {interfaceHash} to learn how these are created.
     *
     * Emits an {InterfaceImplementerSet} event.
     *
     * Requirements:
     *
     * - the caller must be the current manager for `account`.
     * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
     * end in 28 zeroes).
     * - `implementer` must implement {IERC1820Implementer} and return true when
     * queried for support, unless `implementer` is the caller. See
     * {IERC1820Implementer-canImplementInterfaceForAddress}.
     */
    function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;

    /**
     * @dev Returns the implementer of `interfaceHash` for `account`. If no such
     * implementer is registered, returns the zero address.
     *
     * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
     * zeroes), `account` will be queried for support of it.
     *
     * `account` being the zero address is an alias for the caller's address.
     */
    function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);

    /**
     * @dev Returns the interface hash for an `interfaceName`, as defined in the
     * corresponding
     * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
     */
    function interfaceHash(string calldata interfaceName) external pure returns (bytes32);

    /**
     *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
     *  @param account Address of the contract for which to update the cache.
     *  @param interfaceId ERC165 interface for which to update the cache.
     */
    function updateERC165Cache(address account, bytes4 interfaceId) external;

    /**
     *  @notice Checks whether a contract implements an ERC165 interface or not.
     *  If the result is not cached a direct lookup on the contract address is performed.
     *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
     *  {updateERC165Cache} with the contract address.
     *  @param account Address of the contract to check.
     *  @param interfaceId ERC165 interface to check.
     *  @return True if `account` implements `interfaceId`, false otherwise.
     */
    function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);

    /**
     *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
     *  @param account Address of the contract to check.
     *  @param interfaceId ERC165 interface to check.
     *  @return True if `account` implements `interfaceId`, false otherwise.
     */
    function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);

    event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);

    event ManagerChanged(address indexed account, address indexed newManager);
}

// SPDX-License-Identifier: MIT



/**
 * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
 *
 * Accounts can be notified of {IERC777} tokens being sent to them by having a
 * contract implement this interface (contract holders can be their own
 * implementer) and registering it on the
 * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
 *
 * See {IERC1820Registry} and {ERC1820Implementer}.
 */
interface IERC777Recipient {
    /**
     * @dev Called by an {IERC777} token contract whenever tokens are being
     * moved or created into a registered account (`to`). The type of operation
     * is conveyed by `from` being the zero address or not.
     *
     * This call occurs _after_ the token contract's state is updated, so
     * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
     *
     * This function may revert to prevent the operation from being executed.
     */
    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external;
}

// SPDX-License-Identifier: MIT



contract Common {
    // configs
    bytes32 internal EMPTY_BYTES32;
    uint256 internal constant PERCENT_BASE = 1000;
    uint256 internal constant ROOT_ID = 6666;
    uint256 internal constant MAX_LEVEL_DEEP = 7;
    uint256 internal constant BLOCK_PER_ROUND = 5760;
    uint256 internal constant DELAY_ROUND = 10;
    uint256 internal constant ROUND_ALLOW_PREORDER = 15;
    uint256 internal constant NEWBIE_BLOCKS = 160;
    uint256 internal constant ROUND_PREORDER_LIMIT_PERCENT = 700;

    // error codes
    string constant ERROR_HELPING_FUND_NOT_ENOUGH = "1"; // helpingFund not enough
    string constant ERROR_DEFI_IS_BANKRUPT = "2"; // defi is bankrupt
    string constant ERROR_ACCOUNT_IS_DISABLED = "3"; // account is disabled
    string constant ERROR_UNINVESTABLE = "4"; // The investable quota is full
    string constant ERROR_INVALID_STATUS = "5"; // invalid status
    string constant ERROR_INVALID_INVITE_CODE = "6"; // invalid inviteCode
    string constant ERROR_REFERRER_NOT_FOUND = "7"; // Referrer not found
    string constant ERROR_USER_ALREADY_REGISTED = "8"; // user already registed
    string constant ERROR_USER_IS_NOT_REGISTED = "9"; // user is not registed
    string constant ERROR_USER_HAS_NOT_INVESTED = "10"; // User has not invested
    string constant ERROR_ROUND_IS_NOT_OVER = "11"; // Round is not over
    string constant ERROR_TRY_AGAIN_IN_A_DAY = "12"; // Try again in a day
    string constant ERROR_USER_ACTIVATED = "13"; // User activated
    string constant ERROR_USER_IS_NOT_ACTIVATED = "14"; // User is not activated
    string constant ERROR_USER_INVESTED = "15"; // User invested
    string constant ERROR_INVESTMENT_GEAR_IS_INCORRECT = "16"; // Investment gear is incorrect
    string constant ERROR_USER_IS_NOT_NODE = "17"; // user is not node
    string constant ERROR_USER_IS_NOT_SUPER_NODE = "18"; // user is not super node
    string constant ERROR_NO_MORE_BONUS = "19"; // no more bonus
    string constant ERROR_ALREADY_CLAIMED = "20"; // already claimed
    string constant ERROR_NOT_IN_LAST100 = "21"; // not in last 100 users
    string constant ERROR_NO_ORIGINAL_ACCOUNT_QUOTA = "22"; // no original account quota
    string constant ERROR_ETH_NOT_ENOUGH = "23"; // ETH not enough
    string constant ERROR_TOKEN_NOT_ENOUGH = "24"; // Token not enough
    string constant ERROR_UNMATCHED_PAYMENT_ACTION = "25"; // Unmatched payment action

    enum EventAction {
        Unknown,
        PurchaseOriginalAccount,
        UserActive,
        UserInvestment,
        ReferralUserInvestment,
        ClaimROI,
        ClaimCompensation,
        ClaimNodeBonus,
        ClaimSuperNodeBonus,
        ClaimLast100Bonus
    }

    event UserRegister(
        uint256 indexed eventID,
        uint256 indexed userID,
        uint256 blockNumber,
        uint256 referralUserID,
        address userAddr
    );

    event UserActive(
        uint256 indexed eventID,
        uint256 indexed userID,
        uint256 blockNumber,
        uint256[MAX_LEVEL_DEEP + 1] referrers,
        uint256[MAX_LEVEL_DEEP + 1] tokenAmts,
        uint256[MAX_LEVEL_DEEP + 1] usdAmts,
        bytes32 inviteCode
    );

    event Billing(
        uint256 indexed eventID,
        uint256 indexed userID,
        uint256 blockNumber,
        EventAction action,
        uint256 extData,
        uint256 extData1,
        uint256 extData2,
        uint256 tokenAmt,
        uint256 usdAmt,
        uint256 feeUSD
    );

    event UserData(
        uint256 indexed eventID,
        uint256 indexed userID,
        uint256 blockNumber,
        EventAction action,
        uint256 fromUserID,
        uint256 extData,
        bool[2] userBoolArray,
        uint256[21] userUint256Array
    );

    event RoundData(
        uint256 indexed eventID,
        uint256 indexed roundID,
        uint256 blockNumber,
        uint256[4] roundUint256Vars
    );
}


// SPDX-License-Identifier: MIT







/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// SPDX-License-Identifier: MIT



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
 */
contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () internal {
        _status = _NOT_ENTERED;
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
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}


contract Last100 is
    IUpgradable,
    Common,
    IERC777Recipient,
    ILast100,
    ReentrancyGuard
{
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    bytes32 internal constant TOKENS_RECIPIENT_INTERFACE_HASH = keccak256(
        "ERC777TokensRecipient"
    );
    IERC1820Registry internal ERC1820 = IERC1820Registry(
        0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24
    );

    IDeFiStorage private _fs;
    ILast100Logic private _ll;
    uint256 totalBonus;

    constructor() public {
        ERC1820.setInterfaceImplementer(
            address(this),
            TOKENS_RECIPIENT_INTERFACE_HASH,
            address(this)
        );
    }

    modifier ensureStatus(IDeFiStorage.GlobalStatus requireStatus) {
        IDeFiStorage.GlobalStatus status = _fs.getGlobalStatus();
        require(
            status == requireStatus ||
                (requireStatus == IDeFiStorage.GlobalStatus.Pending &&
                    (status == IDeFiStorage.GlobalStatus.Pending ||
                        status == IDeFiStorage.GlobalStatus.Started)),
            ERROR_INVALID_STATUS
        );
        _;
    }

    receive() external payable {
        return;
    }

    function tokensReceived(
        address,
        address,
        address,
        uint256,
        bytes memory,
        bytes memory
    ) public override {
        // check token
        assert(msg.sender == _fs.getToken());
    }

    /// public functions
    function claimLast100Bonus()
        public
        ensureStatus(IDeFiStorage.GlobalStatus.Bankruptcy)
    {
        uint256 userID = _ll.checkUserAvailable(msg.sender);
        if (totalBonus == 0) totalBonus = address(this).balance;
        _sendETH(msg.sender, totalBonus.div(100));
        emit Billing(
            _fs.issueEventIndex(),
            userID,
            block.number,
            EventAction.ClaimLast100Bonus,
            0,
            0,
            0,
            totalBonus.div(100),
            0,
            0
        );
    }

    /// internal functions
    function sendToken(address to, uint256 amt) public override onlyInternal {
        _sendToken(to, amt);
    }

    function sendETH(address payable to, uint256 amt)
        public
        override
        onlyInternal
    {
        _sendETH(to, amt);
    }

    /// private functions
    function _sendETH(address payable to, uint256 amt) private nonReentrant {
        to.transfer(amt);
    }

    function _sendToken(address to, uint256 amt) private nonReentrant {
        IERC20(_fs.getToken()).safeTransfer(to, amt);
    }

    /// implements functions
    function changeDependentContractAddress() public override {
        _fs = IDeFiStorage(master.getLatestAddress("FS"));
        _ll = ILast100Logic(master.getLatestAddress("LL"));
    }
}