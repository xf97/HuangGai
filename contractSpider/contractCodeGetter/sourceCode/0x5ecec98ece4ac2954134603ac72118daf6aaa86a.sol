/**
 *Submitted for verification at Etherscan.io on 2020-05-12
*/

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol

pragma solidity ^0.5.0;



/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        require(token.transfer(to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        require(token.transferFrom(from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require((value == 0) || (token.allowance(address(this), spender) == 0));
        require(token.approve(spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        require(token.approve(spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        require(token.approve(spender, newAllowance));
    }
}

// File: contracts/loopring/iface/IBrokerRegistry.sol

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

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
pragma solidity ^0.5.7;


/// @title IBrokerRegistry
/// @dev A broker is an account that can submit orders on behalf of other
///      accounts. When registering a broker, the owner can also specify a
///      pre-deployed BrokerInterceptor to hook into the exchange smart contracts.
/// @author Daniel Wang - <daniel@loopring.org>.
contract IBrokerRegistry {
    event BrokerRegistered(
        address owner,
        address broker,
        address interceptor
    );

    event BrokerUnregistered(
        address owner,
        address broker,
        address interceptor
    );

    event AllBrokersUnregistered(
        address owner
    );

    /// @dev   Validates if the broker was registered for the order owner and
    ///        returns the possible BrokerInterceptor to be used.
    /// @param owner The owner of the order
    /// @param broker The broker of the order
    /// @return True if the broker was registered for the owner
    ///         and the BrokerInterceptor to use.
    function getBroker(
        address owner,
        address broker
        )
        external
        view
        returns(
            bool registered,
            address interceptor
        );

    /// @dev   Gets all registered brokers for an owner.
    /// @param owner The owner
    /// @param start The start index of the list of brokers
    /// @param count The number of brokers to return
    /// @return The list of requested brokers and corresponding BrokerInterceptors
    function getBrokers(
        address owner,
        uint    start,
        uint    count
        )
        external
        view
        returns (
            address[] memory brokers,
            address[] memory interceptors
        );

    /// @dev   Registers a broker for msg.sender and an optional
    ///        corresponding BrokerInterceptor.
    /// @param broker The broker to register
    /// @param interceptor The optional BrokerInterceptor to use (0x0 allowed)
    function registerBroker(
        address broker,
        address interceptor
        )
        external;

    /// @dev   Unregisters a broker for msg.sender
    /// @param broker The broker to unregister
    function unregisterBroker(
        address broker
        )
        external;

    /// @dev   Unregisters all brokers for msg.sender
    function unregisterAllBrokers(
        )
        external;
}

// File: contracts/loopring/iface/IBurnRateTable.sol

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

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
pragma solidity ^0.5.7;


/// @author Brecht Devos - <brecht@loopring.org>
/// @title IBurnRateTable - A contract for managing burn rates for tokens
contract IBurnRateTable {

    struct TokenData {
        uint    tier;
        uint    validUntil;
    }

    mapping(address => TokenData) public tokens;

    uint public constant YEAR_TO_SECONDS = 31556952;

    // Tiers
    uint8 public constant TIER_4 = 0;
    uint8 public constant TIER_3 = 1;
    uint8 public constant TIER_2 = 2;
    uint8 public constant TIER_1 = 3;

    uint16 public constant BURN_BASE_PERCENTAGE           =                 100 * 10; // 100%

    // Cost of upgrading the tier level of a token in a percentage of the total LRC supply
    uint16 public constant TIER_UPGRADE_COST_PERCENTAGE   =                        1; // 0.1%

    // Burn rates
    // Matching
    uint16 public constant BURN_MATCHING_TIER1            =                       25; // 2.5%
    uint16 public constant BURN_MATCHING_TIER2            =                  15 * 10; //  15%
    uint16 public constant BURN_MATCHING_TIER3            =                  30 * 10; //  30%
    uint16 public constant BURN_MATCHING_TIER4            =                  50 * 10; //  50%
    // P2P
    uint16 public constant BURN_P2P_TIER1                 =                       25; // 2.5%
    uint16 public constant BURN_P2P_TIER2                 =                  15 * 10; //  15%
    uint16 public constant BURN_P2P_TIER3                 =                  30 * 10; //  30%
    uint16 public constant BURN_P2P_TIER4                 =                  50 * 10; //  50%

    event TokenTierUpgraded(
        address indexed addr,
        uint            tier
    );

    /// @dev   Returns the P2P and matching burn rate for the token.
    /// @param token The token to get the burn rate for.
    /// @return The burn rate. The P2P burn rate and matching burn rate
    ///         are packed together in the lowest 4 bytes.
    ///         (2 bytes P2P, 2 bytes matching)
    function getBurnRate(
        address token
        )
        external
        view
        returns (uint32 burnRate);

    /// @dev   Returns the tier of a token.
    /// @param token The token to get the token tier for.
    /// @return The tier of the token
    function getTokenTier(
        address token
        )
        public
        view
        returns (uint);

    /// @dev   Upgrades the tier of a token. Before calling this function,
    ///        msg.sender needs to approve this contract for the neccessary funds.
    /// @param token The token to upgrade the tier for.
    /// @return True if successful, false otherwise.
    function upgradeTokenTier(
        address token
        )
        external
        returns (bool);

}

// File: contracts/loopring/iface/IFeeHolder.sol

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

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
pragma solidity ^0.5.7;


/// @author Kongliang Zhong - <kongliang@loopring.org>
/// @title IFeeHolder - A contract holding fees.
contract IFeeHolder {

    event TokenWithdrawn(
        address owner,
        address token,
        uint value
    );

    // A map of all fee balances
    mapping(address => mapping(address => uint)) public feeBalances;

    // A map of all the nonces for a withdrawTokenFor request
    mapping(address => uint) public nonces;

    /// @dev   Allows withdrawing the tokens to be burned by
    ///        authorized contracts.
    /// @param token The token to be used to burn buy and burn LRC
    /// @param value The amount of tokens to withdraw
    function withdrawBurned(
        address token,
        uint value
        )
        external
        returns (bool success);

    /// @dev   Allows withdrawing the fee payments funds
    ///        msg.sender is the recipient of the fee and the address
    ///        to which the tokens will be sent.
    /// @param token The token to withdraw
    /// @param value The amount of tokens to withdraw
    function withdrawToken(
        address token,
        uint value
        )
        external
        returns (bool success);

    /// @dev   Allows withdrawing the fee payments funds by providing a
    ///        a signature
    function withdrawTokenFor(
      address owner,
      address token,
      uint value,
      address recipient,
      uint feeValue,
      address feeRecipient,
      uint nonce,
      bytes calldata signature
      )
      external
      returns (bool success);

    function batchAddFeeBalances(
        bytes32[] calldata batch
        )
        external;
}

// File: contracts/loopring/iface/IOrderBook.sol

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

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
pragma solidity ^0.5.7;


/// @title IOrderBook
/// @author Daniel Wang - <daniel@loopring.org>.
/// @author Kongliang Zhong - <kongliang@loopring.org>.
contract IOrderBook {
    // The map of registered order hashes
    mapping(bytes32 => bool) public orderSubmitted;

    /// @dev  Event emitted when an order was successfully submitted
    ///        orderHash      The hash of the order
    ///        orderData      The data of the order as passed to submitOrder()
    event OrderSubmitted(
        bytes32 orderHash,
        bytes   orderData
    );

    /// @dev   Submits an order to the on-chain order book.
    ///        No signature is needed. The order can only be sumbitted by its
    ///        owner or its broker (the owner can be the address of a contract).
    /// @param orderData The data of the order. Contains all fields that are used
    ///        for the order hash calculation.
    ///        See OrderHelper.updateHash() for detailed information.
    function submitOrder(
        bytes calldata orderData
        )
        external
        returns (bytes32);
}

// File: contracts/loopring/iface/IOrderRegistry.sol

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

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
pragma solidity ^0.5.7;


/// @title IOrderRegistry
/// @author Daniel Wang - <daniel@loopring.org>.
contract IOrderRegistry {

    /// @dev   Returns wether the order hash was registered in the registry.
    /// @param broker The broker of the order
    /// @param orderHash The hash of the order
    /// @return True if the order hash was registered, else false.
    function isOrderHashRegistered(
        address broker,
        bytes32 orderHash
        )
        external
        view
        returns (bool);

    /// @dev   Registers an order in the registry.
    ///        msg.sender needs to be the broker of the order.
    /// @param orderHash The hash of the order
    function registerOrderHash(
        bytes32 orderHash
        )
        external;
}

// File: contracts/loopring/impl/BrokerData.sol

pragma solidity ^0.5.7;

library BrokerData {

  struct BrokerOrder {
    address owner;
    bytes32 orderHash;
    uint fillAmountB;
    uint requestedAmountS;
    uint requestedFeeAmount;
    address tokenRecipient;
    bytes extraData;
  }

  /**
   * The request wraps all broker orders that share the following overall fields. The perspective on these fields is
   * the orders that are passed in. Meaning, `tokenB` is the token being RECEIVED by each owner and `tokenS` is the
   * token being SPENT by each owner. Lastly, `totalRequestedFeeAmount` is the total `feeAmountS` for all brokered
   * orders. If the fees are in `tokenB`, then this amount is always 0.
   */
  struct BrokerApprovalRequest {
    BrokerOrder[] orders;
    address tokenS;
    address tokenB;
    address feeToken;
    uint totalFillAmountB;
    uint totalRequestedAmountS;
    uint totalRequestedFeeAmount;
  }

  struct BrokerInterceptorReport {
    address owner;
    address broker;
    bytes32 orderHash;
    address tokenB;
    address tokenS;
    address feeToken;
    uint fillAmountB;
    uint spentAmountS;
    uint spentFeeAmount;
    address tokenRecipient;
    bytes extraData;
  }

}

// File: contracts/loopring/iface/ILoopringTradeDelegate.sol

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

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
pragma solidity ^0.5.7;
pragma experimental ABIEncoderV2;


/// @title ILoopringTradeDelegate
/// @dev Acts as a middle man to transfer ERC20 tokens on behalf of different
/// versions of Loopring protocol to avoid ERC20 re-authorization.
/// @author Daniel Wang - <daniel@loopring.org>.
contract ILoopringTradeDelegate {

    function isTrustedSubmitter(address submitter) public view returns (bool);

    function addTrustedSubmitter(address submitter) public;

    function removeTrustedSubmitter(address submitter) public;

    function batchTransfer(
        bytes32[] calldata batch
    ) external;

    function brokerTransfer(
        address token,
        address broker,
        address recipient,
        uint amount
    ) external;

    function proxyBrokerRequestAllowance(
        BrokerData.BrokerApprovalRequest memory request,
        address broker
    ) public returns (bool);


    /// @dev Add a Loopring protocol address.
    /// @param addr A loopring protocol address.
    function authorizeAddress(
        address addr
        )
        external;

    /// @dev Remove a Loopring protocol address.
    /// @param addr A loopring protocol address.
    function deauthorizeAddress(
        address addr
        )
        external;

    function isAddressAuthorized(
        address addr
        )
        public
        view
        returns (bool);


    function suspend()
        external;

    function resume()
        external;

    function kill()
        external;
}

// File: contracts/loopring/iface/ITradeHistory.sol

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

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
pragma solidity ^0.5.7;


/// @title ITradeHistory
/// @dev Stores the trade history and cancelled data of orders
/// @author Brecht Devos - <brecht@loopring.org>.
contract ITradeHistory {

    // The following map is used to keep trace of order fill and cancellation
    // history.
    mapping (bytes32 => uint) public filled;

    // This map is used to keep trace of order's cancellation history.
    mapping (address => mapping (bytes32 => bool)) public cancelled;

    // A map from a broker to its cutoff timestamp.
    mapping (address => uint) public cutoffs;

    // A map from a broker to its trading-pair cutoff timestamp.
    mapping (address => mapping (bytes20 => uint)) public tradingPairCutoffs;

    // A map from a broker to an order owner to its cutoff timestamp.
    mapping (address => mapping (address => uint)) public cutoffsOwner;

    // A map from a broker to an order owner to its trading-pair cutoff timestamp.
    mapping (address => mapping (address => mapping (bytes20 => uint))) public tradingPairCutoffsOwner;


    function batchUpdateFilled(
        bytes32[] calldata filledInfo
        )
        external;

    function setCancelled(
        address broker,
        bytes32 orderHash
        )
        external;

    function setCutoffs(
        address broker,
        uint cutoff
        )
        external;

    function setTradingPairCutoffs(
        address broker,
        bytes20 tokenPair,
        uint cutoff
        )
        external;

    function setCutoffsOfOwner(
        address broker,
        address owner,
        uint cutoff
        )
        external;

    function setTradingPairCutoffsOfOwner(
        address broker,
        address owner,
        bytes20 tokenPair,
        uint cutoff
        )
        external;

    function batchGetFilledAndCheckCancelled(
        bytes32[] calldata orderInfo
        )
        external
        view
        returns (uint[] memory fills);


    /// @dev Add a Loopring protocol address.
    /// @param addr A loopring protocol address.
    function authorizeAddress(
        address addr
        )
        external;

    /// @dev Remove a Loopring protocol address.
    /// @param addr A loopring protocol address.
    function deauthorizeAddress(
        address addr
        )
        external;

    function isAddressAuthorized(
        address addr
        )
        public
        view
        returns (bool);


    function suspend()
        external;

    function resume()
        external;

    function kill()
        external;
}

// File: contracts/loopring/impl/Data.sol

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

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
pragma solidity ^0.5.7;









library Data {

    enum TokenType { ERC20 }

    struct Header {
        uint version;
        uint numOrders;
        uint numRings;
        uint numSpendables;
    }

    struct BrokerAction {
        bytes32 hash;
        address broker;
        uint[] orderIndices;
        uint numOrders;
        uint[] transferIndices;
        uint numTransfers;
        address tokenS;
        address tokenB;
        address feeToken;
        address delegate;
    }

    struct BrokerTransfer {
        bytes32 hash;
        address token;
        uint amount;
        address recipient;
    }

    struct Context {
        address lrcTokenAddress;
        ILoopringTradeDelegate delegate;
        ITradeHistory   tradeHistory;
        IBrokerRegistry orderBrokerRegistry;
        IOrderRegistry  orderRegistry;
        IFeeHolder feeHolder;
        IOrderBook orderBook;
        IBurnRateTable burnRateTable;
        uint64 ringIndex;
        uint feePercentageBase;
        bytes32[] tokenBurnRates;
        uint feeData;
        uint feePtr;
        uint transferData;
        uint transferPtr;
        BrokerData.BrokerOrder[] brokerOrders;
        BrokerAction[] brokerActions;
        BrokerTransfer[] brokerTransfers;
        uint numBrokerOrders;
        uint numBrokerActions;
        uint numBrokerTransfers;
    }

    struct Mining {
        // required fields
        address feeRecipient;

        // optional fields
        address miner;
        bytes   sig;

        // computed fields
        bytes32 hash;
        address interceptor;
    }

    struct Spendable {
        bool initialized;
        uint amount;
        uint reserved;
    }

    struct Order {
        uint      version;

        // required fields
        address   owner;
        address   tokenS;
        address   tokenB;
        uint      amountS;
        uint      amountB;
        uint      validSince;
        Spendable tokenSpendableS;
        Spendable tokenSpendableFee;

        // optional fields
        address   dualAuthAddr;
        address   broker;
        Spendable brokerSpendableS;
        Spendable brokerSpendableFee;
        address   orderInterceptor;
        address   wallet;
        uint      validUntil;
        bytes     sig;
        bytes     dualAuthSig;
        bool      allOrNone;
        address   feeToken;
        uint      feeAmount;
        int16     waiveFeePercentage;
        uint16    tokenSFeePercentage;    // Pre-trading
        uint16    tokenBFeePercentage;   // Post-trading
        address   tokenRecipient;
        uint16    walletSplitPercentage;

        // computed fields
        bool    P2P;
        bytes32 hash;
        address brokerInterceptor;
        uint    filledAmountS;
        uint    initialFilledAmountS;
        bool    valid;

        TokenType tokenTypeS;
        TokenType tokenTypeB;
        TokenType tokenTypeFee;
        bytes32 trancheS;
        bytes32 trancheB;
        uint    maxPrimaryFillAmount;
        bool    transferFirstAsMaker;
        bytes   transferDataS;
    }

    struct Participation {
        // required fields
        Order order;

        // computed fields
        uint splitS;
        uint feeAmount;
        uint feeAmountS;
        uint feeAmountB;
        uint rebateFee;
        uint rebateS;
        uint rebateB;
        uint fillAmountS;
        uint fillAmountB;
    }

    struct Ring {
        uint size;
        Participation[] participations;
        bytes32 hash;
        uint minerFeesToOrdersPercentage;
        bool valid;
    }

    struct RingIndices {
        uint index0;
        uint index1;
    }

    struct FeeContext {
        Data.Ring ring;
        Data.Context ctx;
        address feeRecipient;
        uint walletPercentage;
        int16 waiveFeePercentage;
        address owner;
        address wallet;
        bool P2P;
    }

//    struct SubmitRingsRequest {
//        Data.Mining  mining;
//        Data.Order[] orders;
//        Data.RingIndices[]  ringIndices;
//    }

}

// File: @dydxprotocol/solo/contracts/protocol/lib/Monetary.sol

/*

    Copyright 2019 dYdX Trading Inc.

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

pragma solidity ^0.5.7;


/**
 * @title Monetary
 * @author dYdX
 *
 * Library for types involving money
 */
library Monetary {

    /*
     * The price of a base-unit of an asset.
     */
    struct Price {
        uint256 value;
    }

    /*
     * Total value of an some amount of an asset. Equal to (price * amount).
     */
    struct Value {
        uint256 value;
    }
}

// File: @dydxprotocol/solo/contracts/protocol/lib/Require.sol

/*

    Copyright 2019 dYdX Trading Inc.

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

pragma solidity ^0.5.7;


/**
 * @title Require
 * @author dYdX
 *
 * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
 */
library Require {

    // ============ Constants ============

    uint256 constant ASCII_ZERO = 48; // '0'
    uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
    uint256 constant ASCII_LOWER_EX = 120; // 'x'
    bytes2 constant COLON = 0x3a20; // ': '
    bytes2 constant COMMA = 0x2c20; // ', '
    bytes2 constant LPAREN = 0x203c; // ' <'
    byte constant RPAREN = 0x3e; // '>'
    uint256 constant FOUR_BIT_MASK = 0xf;

    // ============ Library Functions ============

    function that(
        bool must,
        bytes32 file,
        bytes32 reason
    )
        internal
        pure
    {
        if (!must) {
            revert(
                string(
                    abi.encodePacked(
                        stringifyTruncated(file),
                        COLON,
                        stringifyTruncated(reason)
                    )
                )
            );
        }
    }

    function that(
        bool must,
        bytes32 file,
        bytes32 reason,
        uint256 payloadA
    )
        internal
        pure
    {
        if (!must) {
            revert(
                string(
                    abi.encodePacked(
                        stringifyTruncated(file),
                        COLON,
                        stringifyTruncated(reason),
                        LPAREN,
                        stringify(payloadA),
                        RPAREN
                    )
                )
            );
        }
    }

    function that(
        bool must,
        bytes32 file,
        bytes32 reason,
        uint256 payloadA,
        uint256 payloadB
    )
        internal
        pure
    {
        if (!must) {
            revert(
                string(
                    abi.encodePacked(
                        stringifyTruncated(file),
                        COLON,
                        stringifyTruncated(reason),
                        LPAREN,
                        stringify(payloadA),
                        COMMA,
                        stringify(payloadB),
                        RPAREN
                    )
                )
            );
        }
    }

    function that(
        bool must,
        bytes32 file,
        bytes32 reason,
        address payloadA
    )
        internal
        pure
    {
        if (!must) {
            revert(
                string(
                    abi.encodePacked(
                        stringifyTruncated(file),
                        COLON,
                        stringifyTruncated(reason),
                        LPAREN,
                        stringify(payloadA),
                        RPAREN
                    )
                )
            );
        }
    }

    function that(
        bool must,
        bytes32 file,
        bytes32 reason,
        address payloadA,
        uint256 payloadB
    )
        internal
        pure
    {
        if (!must) {
            revert(
                string(
                    abi.encodePacked(
                        stringifyTruncated(file),
                        COLON,
                        stringifyTruncated(reason),
                        LPAREN,
                        stringify(payloadA),
                        COMMA,
                        stringify(payloadB),
                        RPAREN
                    )
                )
            );
        }
    }

    function that(
        bool must,
        bytes32 file,
        bytes32 reason,
        address payloadA,
        uint256 payloadB,
        uint256 payloadC
    )
        internal
        pure
    {
        if (!must) {
            revert(
                string(
                    abi.encodePacked(
                        stringifyTruncated(file),
                        COLON,
                        stringifyTruncated(reason),
                        LPAREN,
                        stringify(payloadA),
                        COMMA,
                        stringify(payloadB),
                        COMMA,
                        stringify(payloadC),
                        RPAREN
                    )
                )
            );
        }
    }

    function that(
        bool must,
        bytes32 file,
        bytes32 reason,
        bytes32 payloadA
    )
        internal
        pure
    {
        if (!must) {
            revert(
                string(
                    abi.encodePacked(
                        stringifyTruncated(file),
                        COLON,
                        stringifyTruncated(reason),
                        LPAREN,
                        stringify(payloadA),
                        RPAREN
                    )
                )
            );
        }
    }

    function that(
        bool must,
        bytes32 file,
        bytes32 reason,
        bytes32 payloadA,
        uint256 payloadB,
        uint256 payloadC
    )
        internal
        pure
    {
        if (!must) {
            revert(
                string(
                    abi.encodePacked(
                        stringifyTruncated(file),
                        COLON,
                        stringifyTruncated(reason),
                        LPAREN,
                        stringify(payloadA),
                        COMMA,
                        stringify(payloadB),
                        COMMA,
                        stringify(payloadC),
                        RPAREN
                    )
                )
            );
        }
    }

    // ============ Private Functions ============

    function stringifyTruncated(
        bytes32 input
    )
        private
        pure
        returns (bytes memory)
    {
        // put the input bytes into the result
        bytes memory result = abi.encodePacked(input);

        // determine the length of the input by finding the location of the last non-zero byte
        for (uint256 i = 32; i > 0; ) {
            // reverse-for-loops with unsigned integer
            /* solium-disable-next-line security/no-modify-for-iter-var */
            i--;

            // find the last non-zero byte in order to determine the length
            if (result[i] != 0) {
                uint256 length = i + 1;

                /* solium-disable-next-line security/no-inline-assembly */
                assembly {
                    mstore(result, length) // r.length = length;
                }

                return result;
            }
        }

        // all bytes are zero
        return new bytes(0);
    }

    function stringify(
        uint256 input
    )
        private
        pure
        returns (bytes memory)
    {
        if (input == 0) {
            return "0";
        }

        // get the final string length
        uint256 j = input;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }

        // allocate the string
        bytes memory bstr = new bytes(length);

        // populate the string starting with the least-significant character
        j = input;
        for (uint256 i = length; i > 0; ) {
            // reverse-for-loops with unsigned integer
            /* solium-disable-next-line security/no-modify-for-iter-var */
            i--;

            // take last decimal digit
            bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));

            // remove the last decimal digit
            j /= 10;
        }

        return bstr;
    }

    function stringify(
        address input
    )
        private
        pure
        returns (bytes memory)
    {
        uint256 z = uint256(input);

        // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
        bytes memory result = new bytes(42);

        // populate the result with "0x"
        result[0] = byte(uint8(ASCII_ZERO));
        result[1] = byte(uint8(ASCII_LOWER_EX));

        // for each byte (starting from the lowest byte), populate the result with two characters
        for (uint256 i = 0; i < 20; i++) {
            // each byte takes two characters
            uint256 shift = i * 2;

            // populate the least-significant character
            result[41 - shift] = char(z & FOUR_BIT_MASK);
            z = z >> 4;

            // populate the most-significant character
            result[40 - shift] = char(z & FOUR_BIT_MASK);
            z = z >> 4;
        }

        return result;
    }

    function stringify(
        bytes32 input
    )
        private
        pure
        returns (bytes memory)
    {
        uint256 z = uint256(input);

        // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
        bytes memory result = new bytes(66);

        // populate the result with "0x"
        result[0] = byte(uint8(ASCII_ZERO));
        result[1] = byte(uint8(ASCII_LOWER_EX));

        // for each byte (starting from the lowest byte), populate the result with two characters
        for (uint256 i = 0; i < 32; i++) {
            // each byte takes two characters
            uint256 shift = i * 2;

            // populate the least-significant character
            result[65 - shift] = char(z & FOUR_BIT_MASK);
            z = z >> 4;

            // populate the most-significant character
            result[64 - shift] = char(z & FOUR_BIT_MASK);
            z = z >> 4;
        }

        return result;
    }

    function char(
        uint256 input
    )
        private
        pure
        returns (byte)
    {
        // return ASCII digit (0-9)
        if (input < 10) {
            return byte(uint8(input + ASCII_ZERO));
        }

        // return ASCII letter (a-f)
        return byte(uint8(input + ASCII_RELATIVE_ZERO));
    }
}

// File: @dydxprotocol/solo/contracts/protocol/lib/Math.sol

/*

    Copyright 2019 dYdX Trading Inc.

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

pragma solidity ^0.5.7;




/**
 * @title Math
 * @author dYdX
 *
 * Library for non-standard Math functions
 */
library Math {
    using SafeMath for uint256;

    // ============ Constants ============

    bytes32 constant FILE = "Math";

    // ============ Library Functions ============

    /*
     * Return target * (numerator / denominator).
     */
    function getPartial(
        uint256 target,
        uint256 numerator,
        uint256 denominator
    )
        internal
        pure
        returns (uint256)
    {
        return target.mul(numerator).div(denominator);
    }

    /*
     * Return target * (numerator / denominator), but rounded up.
     */
    function getPartialRoundUp(
        uint256 target,
        uint256 numerator,
        uint256 denominator
    )
        internal
        pure
        returns (uint256)
    {
        if (target == 0 || numerator == 0) {
            // SafeMath will check for zero denominator
            return SafeMath.div(0, denominator);
        }
        return target.mul(numerator).sub(1).div(denominator).add(1);
    }

    function to128(
        uint256 number
    )
        internal
        pure
        returns (uint128)
    {
        uint128 result = uint128(number);
        Require.that(
            result == number,
            FILE,
            "Unsafe cast to uint128"
        );
        return result;
    }

    function to96(
        uint256 number
    )
        internal
        pure
        returns (uint96)
    {
        uint96 result = uint96(number);
        Require.that(
            result == number,
            FILE,
            "Unsafe cast to uint96"
        );
        return result;
    }

    function to32(
        uint256 number
    )
        internal
        pure
        returns (uint32)
    {
        uint32 result = uint32(number);
        Require.that(
            result == number,
            FILE,
            "Unsafe cast to uint32"
        );
        return result;
    }

    function min(
        uint256 a,
        uint256 b
    )
        internal
        pure
        returns (uint256)
    {
        return a < b ? a : b;
    }

    function max(
        uint256 a,
        uint256 b
    )
        internal
        pure
        returns (uint256)
    {
        return a > b ? a : b;
    }
}

// File: @dydxprotocol/solo/contracts/protocol/lib/Types.sol

/*

    Copyright 2019 dYdX Trading Inc.

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

pragma solidity ^0.5.7;




/**
 * @title Types
 * @author dYdX
 *
 * Library for interacting with the basic structs used in Solo
 */
library Types {
    using Math for uint256;

    // ============ AssetAmount ============

    enum AssetDenomination {
        Wei, // the amount is denominated in wei
        Par  // the amount is denominated in par
    }

    enum AssetReference {
        Delta, // the amount is given as a delta from the current value
        Target // the amount is given as an exact number to end up at
    }

    struct AssetAmount {
        bool sign; // true if positive
        AssetDenomination denomination;
        AssetReference ref;
        uint256 value;
    }

    // ============ Par (Principal Amount) ============

    // Total borrow and supply values for a market
    struct TotalPar {
        uint128 borrow;
        uint128 supply;
    }

    // Individual principal amount for an account
    struct Par {
        bool sign; // true if positive
        uint128 value;
    }

    function zeroPar()
        internal
        pure
        returns (Par memory)
    {
        return Par({
            sign: false,
            value: 0
        });
    }

    function sub(
        Par memory a,
        Par memory b
    )
        internal
        pure
        returns (Par memory)
    {
        return add(a, negative(b));
    }

    function add(
        Par memory a,
        Par memory b
    )
        internal
        pure
        returns (Par memory)
    {
        Par memory result;
        if (a.sign == b.sign) {
            result.sign = a.sign;
            result.value = SafeMath.add(a.value, b.value).to128();
        } else {
            if (a.value >= b.value) {
                result.sign = a.sign;
                result.value = SafeMath.sub(a.value, b.value).to128();
            } else {
                result.sign = b.sign;
                result.value = SafeMath.sub(b.value, a.value).to128();
            }
        }
        return result;
    }

    function equals(
        Par memory a,
        Par memory b
    )
        internal
        pure
        returns (bool)
    {
        if (a.value == b.value) {
            if (a.value == 0) {
                return true;
            }
            return a.sign == b.sign;
        }
        return false;
    }

    function negative(
        Par memory a
    )
        internal
        pure
        returns (Par memory)
    {
        return Par({
            sign: !a.sign,
            value: a.value
        });
    }

    function isNegative(
        Par memory a
    )
        internal
        pure
        returns (bool)
    {
        return !a.sign && a.value > 0;
    }

    function isPositive(
        Par memory a
    )
        internal
        pure
        returns (bool)
    {
        return a.sign && a.value > 0;
    }

    function isZero(
        Par memory a
    )
        internal
        pure
        returns (bool)
    {
        return a.value == 0;
    }

    // ============ Wei (Token Amount) ============

    // Individual token amount for an account
    struct Wei {
        bool sign; // true if positive
        uint256 value;
    }

    function zeroWei()
        internal
        pure
        returns (Wei memory)
    {
        return Wei({
            sign: false,
            value: 0
        });
    }

    function sub(
        Wei memory a,
        Wei memory b
    )
        internal
        pure
        returns (Wei memory)
    {
        return add(a, negative(b));
    }

    function add(
        Wei memory a,
        Wei memory b
    )
        internal
        pure
        returns (Wei memory)
    {
        Wei memory result;
        if (a.sign == b.sign) {
            result.sign = a.sign;
            result.value = SafeMath.add(a.value, b.value);
        } else {
            if (a.value >= b.value) {
                result.sign = a.sign;
                result.value = SafeMath.sub(a.value, b.value);
            } else {
                result.sign = b.sign;
                result.value = SafeMath.sub(b.value, a.value);
            }
        }
        return result;
    }

    function equals(
        Wei memory a,
        Wei memory b
    )
        internal
        pure
        returns (bool)
    {
        if (a.value == b.value) {
            if (a.value == 0) {
                return true;
            }
            return a.sign == b.sign;
        }
        return false;
    }

    function negative(
        Wei memory a
    )
        internal
        pure
        returns (Wei memory)
    {
        return Wei({
            sign: !a.sign,
            value: a.value
        });
    }

    function isNegative(
        Wei memory a
    )
        internal
        pure
        returns (bool)
    {
        return !a.sign && a.value > 0;
    }

    function isPositive(
        Wei memory a
    )
        internal
        pure
        returns (bool)
    {
        return a.sign && a.value > 0;
    }

    function isZero(
        Wei memory a
    )
        internal
        pure
        returns (bool)
    {
        return a.value == 0;
    }
}

// File: contracts/dolomite-margin-protocol/external/ExternalDefinitions.sol

/*
 * Copyright 2020 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.7;




// ---------------------------------
// Dolomite Direct Includes

interface IDepositContractRegistry {
    function depositAddressOf(address owner) external view returns (address payable);

    function operatorOf(address owner, address operator) external returns (bool);

    function versionOf(address owner) external view returns (address);
}

interface IDolomiteDirect {
    function brokerMarginRequestApproval(address owner, address token, uint amount) external;
}

// ---------------------------------
// Dydx Includes

library DydxTypes {
    enum AssetDenomination {Wei, Par}
    enum AssetReference {Delta, Target}

    struct AssetAmount {
        bool sign;
        AssetDenomination denomination;
        AssetReference ref;
        uint256 value;
    }
}

library DydxPosition {
    struct Info {
        address owner;
        uint256 number;
    }
}

library DydxActions {
    enum ActionType {Deposit, Withdraw, Transfer, Buy, Sell, Trade, Liquidate, Vaporize, Call}

    struct ActionArgs {
        ActionType actionType;
        uint256 accountId;
        DydxTypes.AssetAmount amount;
        uint256 primaryMarketId;
        uint256 secondaryMarketId;
        address otherAddress;
        uint256 otherAccountId;
        bytes data;
    }
}

interface IDyDxExchangeWrapper {
    function exchange(
        address tradeOriginator,
        address receiver,
        address makerToken,
        address takerToken,
        uint256 requestedFillAmount,
        bytes calldata orderData
    ) external returns (uint256);

    // Unused by our contract, does not need to be implemented
    // function getExchangeCost(
    //   address makerToken,
    //   address takerToken,
    //   uint256 desiredMakerToken,
    //   bytes calldata orderData
    // ) external view returns (uint256);
}

interface IDyDxCallee {
    function callFunction(address sender, DydxPosition.Info calldata accountInfo, bytes calldata data) external;
}

contract IDyDxProtocol {
    struct OperatorArg {
        address operator;
        bool trusted;
    }

    function operate(
        DydxPosition.Info[] calldata accounts,
        DydxActions.ActionArgs[] calldata actions
    ) external;

    function getNumMarkets() public view returns (uint256);

    function getMarketTokenAddress(uint256 marketId) external view returns (address);

    function getMarketPrice(uint256 marketId) external view returns (Monetary.Price memory);

    function getAccountWei(DydxPosition.Info calldata account, uint256 marketId) external view returns (Types.Wei memory);
}

// ---------------------------------
// Loopring Includes

library LoopringTypes {
    struct BrokerApprovalRequest {
        BrokerOrder[] orders;
        address tokenS;
        address tokenB;
        address feeToken;
        uint totalFillAmountB;
        uint totalRequestedAmountS;
        uint totalRequestedFeeAmount;
    }

    struct BrokerOrder {
        address owner;
        bytes32 orderHash;
        uint fillAmountB;
        uint requestedAmountS;
        uint requestedFeeAmount;
        address tokenRecipient;
        bytes extraData;
    }

    struct BrokerInterceptorReport {
        address owner;
        address broker;
        bytes32 orderHash;
        address tokenB;
        address tokenS;
        address feeToken;
        uint fillAmountB;
        uint spentAmountS;
        uint spentFeeAmount;
        address tokenRecipient;
        bytes extraData;
    }
}

// File: contracts/libs/LoopringTradeDelegateHelper.sol

/*
 * Copyright 2019 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.13;



library LoopringTradeDelegateHelper {

    function transferTokenFrom(
        ILoopringTradeDelegate self,
        address token,
        address from,
        address to,
        uint256 amount
    ) internal {
        bytes32[] memory transferData = new bytes32[](4);
        transferData[0] = addressToBytes32(token);
        transferData[1] = addressToBytes32(from);
        transferData[2] = addressToBytes32(to);
        transferData[3] = bytes32(amount);

        self.batchTransfer(transferData);
    }

    function addressToBytes32(address addr) private pure returns (bytes32) {
        return bytes32(uint256(addr));
    }
}

// File: contracts/dolomite-margin-protocol/external/ExternalHelpers.sol

/*
 * Copyright 2020 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.7;



library Logger {
    function revertAddress(address addr) internal pure {
        revert(_addressToString(addr));
    }

    function revertUint(uint num) internal pure {
        revert(_uintToString(num));
    }

    // -----------------------------

    function _addressToString(address _addr) private pure returns (string memory) {
        bytes32 value = bytes32(uint256(_addr));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(51);
        str[0] = '0';
        str[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            str[2 + i * 2] = alphabet[uint(uint8(value[i + 12] >> 4))];
            str[3 + i * 2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
        }
        return string(str);
    }

    function _uintToString(uint num) internal pure returns (string memory) {
        if (num == 0) {
            return "0";
        }
        uint j = num;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (num != 0) {
            bstr[k--] = byte(uint8(48 + num % 10));
            num /= 10;
        }
        return string(bstr);
    }

}

library DydxActionBuilder {

    function Deposit(uint positionIndex, uint marketId, uint amount, address from)
    internal
    pure
    returns (DydxActions.ActionArgs memory depositAction)
    {
        depositAction.actionType = DydxActions.ActionType.Deposit;
        depositAction.accountId = positionIndex;
        depositAction.primaryMarketId = marketId;
        depositAction.otherAddress = from;
        depositAction.amount = DydxTypes.AssetAmount({
            sign : true,
            denomination : DydxTypes.AssetDenomination.Wei,
            ref : DydxTypes.AssetReference.Delta,
            value : amount
            });
    }

    // The only way to deposit a variable amount into dYdX during the execution of an "operate" call is
    // to perform a "sell" action sending 0 wei and then the implementor of IExchangeWrapper returns the amount that
    // will be deposited. The 1 wei is an unfortunate side effect, however it is a very negligible amount. If, in a
    // future version of dYdX a DepositAll action is added, this would remove the need for this weird mechanic.
    function DepositAll(uint positionIndex, uint marketId, uint burnMarketId, address controller, bytes32 orderHash)
    internal
    pure
    returns (DydxActions.ActionArgs memory action)
    {
        action.actionType = DydxActions.ActionType.Sell;
        action.accountId = positionIndex;
        action.otherAddress = controller;
        action.data = abi.encode(orderHash);
        action.primaryMarketId = burnMarketId;
        action.secondaryMarketId = marketId;
        action.amount = DydxTypes.AssetAmount({
            sign : false,
            denomination : DydxTypes.AssetDenomination.Wei,
            ref : DydxTypes.AssetReference.Delta,
            value : 0
            });
    }

    // ---------------------------------

    function Withdraw(uint positionIndex, uint marketId, uint amount, address to)
    internal
    pure
    returns (DydxActions.ActionArgs memory withdrawAction)
    {
        withdrawAction.actionType = DydxActions.ActionType.Withdraw;
        withdrawAction.accountId = positionIndex;
        withdrawAction.primaryMarketId = marketId;
        withdrawAction.otherAddress = to;
        withdrawAction.amount = DydxTypes.AssetAmount({
            sign : false,
            denomination : DydxTypes.AssetDenomination.Wei,
            ref : DydxTypes.AssetReference.Delta,
            value : amount
            });
    }

    function WithdrawAll(uint positionIndex, uint marketId, address to)
    internal
    pure
    returns (DydxActions.ActionArgs memory withdrawAction)
    {
        withdrawAction.actionType = DydxActions.ActionType.Withdraw;
        withdrawAction.accountId = positionIndex;
        withdrawAction.primaryMarketId = marketId;
        withdrawAction.otherAddress = to;
        withdrawAction.amount = DydxTypes.AssetAmount({
            sign : true,
            denomination : DydxTypes.AssetDenomination.Wei,
            ref : DydxTypes.AssetReference.Target,
            value : 0
            });
    }

    // ---------------------------------

    // function Liquidation() {

    // }

    // ---------------------------------

    function SetExpiry(uint positionIndex, address expiry, uint marketId, uint expiryTime)
    internal
    pure
    returns (DydxActions.ActionArgs memory)
    {
        return ExternalCall({
            positionIndex : positionIndex,
            callee : expiry,
            data : abi.encode(marketId, expiryTime)
            });
    }

    function LoopringSettlement(
        bytes memory settlementData,
        address settlementCaller,
        uint positionIndex
    )
    internal
    pure
    returns (DydxActions.ActionArgs memory)
    {
        return ExternalCall({
            positionIndex : positionIndex,
            callee : settlementCaller,
            data : settlementData
            });
    }

    function ExternalCall(uint positionIndex, address callee, bytes memory data)
    internal
    pure
    returns (DydxActions.ActionArgs memory callAction)
    {
        callAction.actionType = DydxActions.ActionType.Call;
        callAction.accountId = positionIndex;
        callAction.otherAddress = callee;
        callAction.data = data;
    }
}

library LoopringOrderDecoder {

    function decodeLoopringOrders(bytes memory ringData, uint[] memory indices) internal pure returns (Data.Order[] memory orders) {
        uint numOrders = bytesToUint16(ringData, 2);
        uint numRings = bytesToUint16(ringData, 4);
        uint numSpendables = bytesToUint16(ringData, 6);

        uint dataPtr;
        assembly {dataPtr := ringData}
        uint orderDataPtr = (dataPtr + 8) + 3 * 2;
        uint ringDataPtr = orderDataPtr + (32 * numOrders) * 2;
        uint dataBlobPtr = ringDataPtr + (numRings * 9) + 32;

        // orders = new LoopringOrder[](indices.length);
        orders = new Data.Order[](indices.length);

        for (uint i = 0; i < indices.length; i++) {
            orders[i] = _decodeLoopringOrderAtIndex(dataBlobPtr, orderDataPtr + 2, numSpendables, indices[i]);
        }
    }

    // ----------------------------

    function _decodeLoopringOrderAtIndex(uint data, uint tablesPtr, uint numSpendables, uint orderIndex) private pure returns (Data.Order memory order) {
        tablesPtr += 64 * orderIndex;

        uint offset;
        bytes memory emptyBytes = new bytes(0);
        address lrcTokenAddress = address(0);
        Data.Spendable[] memory spendableList = new Data.Spendable[](numSpendables);
        uint orderStructSize = 40 * 32;

        assembly {
            order := mload(0x40)
            mstore(0x40, add(order, orderStructSize)) // Reserve memory for the order struct

        // order.version
            offset := and(mload(add(tablesPtr, 0)), 0xFFFF)
            mstore(
            add(order, 0),
            offset
            )

        // order.owner
            offset := mul(and(mload(add(tablesPtr, 2)), 0xFFFF), 4)
            mstore(
            add(order, 32),
            and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            )

        // order.tokenS
            offset := mul(and(mload(add(tablesPtr, 4)), 0xFFFF), 4)
            mstore(
            add(order, 64),
            and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            )

        // order.tokenB
            offset := mul(and(mload(add(tablesPtr, 6)), 0xFFFF), 4)
            mstore(
            add(order, 96),
            and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            )

        // order.amountS
            offset := mul(and(mload(add(tablesPtr, 8)), 0xFFFF), 4)
            mstore(
            add(order, 128),
            mload(add(add(data, 32), offset))
            )

        // order.amountB
            offset := mul(and(mload(add(tablesPtr, 10)), 0xFFFF), 4)
            mstore(
            add(order, 160),
            mload(add(add(data, 32), offset))
            )

        // order.validSince
            offset := mul(and(mload(add(tablesPtr, 12)), 0xFFFF), 4)
            mstore(
            add(order, 192),
            and(mload(add(add(data, 4), offset)), 0xFFFFFFFF)
            )

        // order.tokenSpendableS
            offset := and(mload(add(tablesPtr, 14)), 0xFFFF)
        // Force the spendable index to 0 if it's invalid
            offset := mul(offset, lt(offset, numSpendables))
            mstore(
            add(order, 224),
            mload(add(spendableList, mul(add(offset, 1), 32)))
            )

        // order.tokenSpendableFee
            offset := and(mload(add(tablesPtr, 16)), 0xFFFF)
        // Force the spendable index to 0 if it's invalid
            offset := mul(offset, lt(offset, numSpendables))
            mstore(
            add(order, 256),
            mload(add(spendableList, mul(add(offset, 1), 32)))
            )

        // order.dualAuthAddr
            offset := mul(and(mload(add(tablesPtr, 18)), 0xFFFF), 4)
            mstore(
            add(order, 288),
            and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            )

        // order.broker
            offset := mul(and(mload(add(tablesPtr, 20)), 0xFFFF), 4)
            mstore(
            add(order, 320),
            and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            )

        // order.orderInterceptor
            offset := mul(and(mload(add(tablesPtr, 22)), 0xFFFF), 4)
            mstore(
            add(order, 416),
            and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            )

        // order.wallet
            offset := mul(and(mload(add(tablesPtr, 24)), 0xFFFF), 4)
            mstore(
            add(order, 448),
            and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            )

        // order.validUntil
            offset := mul(and(mload(add(tablesPtr, 26)), 0xFFFF), 4)
            mstore(
            add(order, 480),
            and(mload(add(add(data, 4), offset)), 0xFFFFFFFF)
            )

        // Default to empty bytes array for value sig and dualAuthSig
            mstore(add(data, 32), emptyBytes)

        // order.sig
            offset := mul(and(mload(add(tablesPtr, 28)), 0xFFFF), 4)
            mstore(
            add(order, 512),
            add(data, add(offset, 32))
            )

        // order.dualAuthSig
            offset := mul(and(mload(add(tablesPtr, 30)), 0xFFFF), 4)
            mstore(
            add(order, 544),
            add(data, add(offset, 32))
            )

        // Restore default to 0
            mstore(add(data, 32), 0)

        // order.allOrNone
            offset := and(mload(add(tablesPtr, 32)), 0xFFFF)
            mstore(
            add(order, 576),
            gt(offset, 0)
            )

        // lrcTokenAddress is the default value for feeToken
            mstore(add(data, 20), lrcTokenAddress)

        // order.feeToken
            offset := mul(and(mload(add(tablesPtr, 34)), 0xFFFF), 4)
            mstore(
            add(order, 608),
            and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            )

        // Restore default to 0
            mstore(add(data, 20), 0)

        // order.feeAmount
            offset := mul(and(mload(add(tablesPtr, 36)), 0xFFFF), 4)
            mstore(
            add(order, 640),
            mload(add(add(data, 32), offset))
            )

        // order.waiveFeePercentage
            offset := and(mload(add(tablesPtr, 38)), 0xFFFF)
            mstore(
            add(order, 672),
            offset
            )

        // order.tokenSFeePercentage
            offset := and(mload(add(tablesPtr, 40)), 0xFFFF)
            mstore(
            add(order, 704),
            offset
            )

        // order.tokenBFeePercentage
            offset := and(mload(add(tablesPtr, 42)), 0xFFFF)
            mstore(
            add(order, 736),
            offset
            )

        // The owner is the default value of tokenRecipient
        // order.owner
            mstore(add(data, 20), mload(add(order, 32)))

        // order.tokenRecipient
            offset := mul(and(mload(add(tablesPtr, 44)), 0xFFFF), 4)
            mstore(
            add(order, 768),
            and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            )

        // Restore default to 0
            mstore(add(data, 20), 0)

        // order.walletSplitPercentage
            offset := and(mload(add(tablesPtr, 46)), 0xFFFF)
            mstore(
            add(order, 800),
            offset
            )

        // order.tokenTypeS
            offset := and(mload(add(tablesPtr, 48)), 0xFFFF)
            mstore(
            add(order, 1024),
            offset
            )

        // order.tokenTypeB
            offset := and(mload(add(tablesPtr, 50)), 0xFFFF)
            mstore(
            add(order, 1056),
            offset
            )

        // order.tokenTypeFee
            offset := and(mload(add(tablesPtr, 52)), 0xFFFF)
            mstore(
            add(order, 1088),
            offset
            )

        // order.trancheS
            offset := mul(and(mload(add(tablesPtr, 54)), 0xFFFF), 4)
            mstore(
            add(order, 1120),
            mload(add(add(data, 32), offset))
            )

        // order.trancheB
            offset := mul(and(mload(add(tablesPtr, 56)), 0xFFFF), 4)
            mstore(
            add(order, 1152),
            mload(add(add(data, 32), offset))
            )

        // Restore default to 0
            mstore(add(data, 20), 0)

        // order.maxPrimaryFillAmount
            offset := mul(and(mload(add(tablesPtr, 58)), 0xFFFF), 4)
            mstore(
            add(order, 1184),
            mload(add(add(data, 32), offset))
            )

        // order.allOrNone
            offset := and(mload(add(tablesPtr, 60)), 0xFFFF)
            mstore(
            add(order, 1216),
            gt(offset, 0)
            )

        // Default to empty bytes array for transferDataS
            mstore(add(data, 32), emptyBytes)

        // order.transferDataS
            offset := mul(and(mload(add(tablesPtr, 62)), 0xFFFF), 4)
            mstore(
            add(order, 1248),
            add(data, add(offset, 32))
            )

        // Restore default to 0
            mstore(add(data, 32), 0)

        // Set default  values
            mstore(add(order, 832), 0)         // order.P2P
            mstore(add(order, 864), 0)         // order.hash
            mstore(add(order, 896), 0)         // order.brokerInterceptor
            mstore(add(order, 928), 0)         // order.filledAmountS
            mstore(add(order, 960), 0)         // order.initialFilledAmountS
            mstore(add(order, 992), 1)         // order.valid

        }
    }

    function bytesToUintX(bytes memory b, uint offset, uint numBytes) private pure returns (uint data) {
        require(b.length >= offset + numBytes, "INVALID_SIZE");
        assembly {data := mload(add(add(b, numBytes), offset))}
    }

    function bytesToUint16(bytes memory b, uint offset) private pure returns (uint16) {
        return uint16(bytesToUintX(b, offset, 2) & 0xFFFF);
    }
}

// File: contracts/dolomite-margin-protocol/helpers/DolomiteMarginReentrancyGuard.sol

/*
 * Copyright 2020 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.0;

contract DolomiteMarginReentrancyGuard {

    uint256 private _guardCounter;

    // Functions with this modifier can not be re-entered
    // (sets counter to odd number when executing, even when finished)
    modifier singleEntry {
        _guardCounter += 1;
        uint current = _guardCounter;
        _;
        require(current == _guardCounter, "NO_ENTRY: Cannot re-enter contract");
        _guardCounter += 1;
    }

    // Functions with this modifier can only be called after entering a singleEntry function
    modifier noEntry {
        require(_guardCounter % 2 == 1, "NO_ENTRY: Cannot enter a noEntry function");
        // counter must be odd number
        _;
    }

}

// File: contracts/loopring/lib/ERC20.sol

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

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
pragma solidity ^0.5.7;


/// @title ERC20 Token Interface
/// @dev see https://github.com/ethereum/EIPs/issues/20
/// @author Daniel Wang - <daniel@loopring.org>
contract ERC20 {
    function totalSupply()
        public
        view
        returns (uint256);

    function balanceOf(
        address who
        )
        public
        view
        returns (uint256);

    function allowance(
        address owner,
        address spender
        )
        public
        view
        returns (uint256);

    function transfer(
        address to,
        uint256 value
        )
        public
        returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
        )
        public
        returns (bool);

    function approve(
        address spender,
        uint256 value
        )
        public
        returns (bool);
}

// File: contracts/loopring/lib/MathUint.sol

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

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
pragma solidity ^0.5.7;


/// @title Utility Functions for uint
/// @author Daniel Wang - <daniel@loopring.org>
library MathUint {

    function mul(
        uint a,
        uint b
        )
        internal
        pure
        returns (uint c)
    {
        c = a * b;
        require(a == 0 || c / a == b, "INVALID_VALUE_MULTIPLY");
    }

    function sub(
        uint a,
        uint b
        )
        internal
        pure
        returns (uint)
    {
        require(b <= a, "INVALID_VALUE_SUB");
        return a - b;
    }

    function add(
        uint a,
        uint b
        )
        internal
        pure
        returns (uint c)
    {
        c = a + b;
        require(c >= a, "INVALID_VALUE_ADD");
    }

    function hasRoundingError(
        uint value,
        uint numerator,
        uint denominator
        )
        internal
        pure
        returns (bool)
    {
        uint multiplied = mul(value, numerator);
        uint remainder = multiplied % denominator;
        // Return true if the rounding error is larger than 1%
        return mul(remainder, 100) > multiplied;
    }
}

// File: contracts/loopring/lib/BytesUtil.sol

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

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
pragma solidity ^0.5.7;


/// @title Utility Functions for bytes
/// @author Daniel Wang - <daniel@loopring.org>
library BytesUtil {
    function bytesToBytes32(
        bytes memory b,
        uint offset
        )
        internal
        pure
        returns (bytes32)
    {
        return bytes32(bytesToUintX(b, offset, 32));
    }

    function bytesToUint(
        bytes memory b,
        uint offset
        )
        internal
        pure
        returns (uint)
    {
        return bytesToUintX(b, offset, 32);
    }

    function bytesToAddress(
        bytes memory b,
        uint offset
        )
        internal
        pure
        returns (address)
    {
        return address(bytesToUintX(b, offset, 20) & 0x00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    }

    function bytesToUint16(
        bytes memory b,
        uint offset
        )
        internal
        pure
        returns (uint16)
    {
        return uint16(bytesToUintX(b, offset, 2) & 0xFFFF);
    }

    function bytesToUintX(
        bytes memory b,
        uint offset,
        uint numBytes
        )
        private
        pure
        returns (uint data)
    {
        require(b.length >= offset + numBytes, "INVALID_SIZE");
        assembly {
            data := mload(add(add(b, numBytes), offset))
        }
    }

    function subBytes(
        bytes memory b,
        uint offset
        )
        internal
        pure
        returns (bytes memory data)
    {
        require(b.length >= offset + 32, "INVALID_SIZE");
        assembly {
            data := add(add(b, 32), offset)
        }
    }
}

// File: contracts/loopring/lib/MultihashUtil.sol

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

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
pragma solidity ^0.5.7;



/// @title Utility Functions for Multihash signature verificaiton
/// @author Daniel Wang - <daniel@loopring.org>
/// For more information:
///   - https://github.com/saurfang/ipfs-multihash-on-solidity
///   - https://github.com/multiformats/multihash
///   - https://github.com/multiformats/js-multihash
library MultihashUtil {

    enum HashAlgorithm { Ethereum, EIP712 }

    string public constant SIG_PREFIX = "\x19Ethereum Signed Message:\n32";

    function verifySignature(
        address signer,
        bytes32 plaintext,
        bytes memory multihash
        )
        internal
        pure
        returns (bool)
    {
        uint length = multihash.length;
        require(length >= 2, "invalid multihash format");
        uint8 algorithm;
        uint8 size;
        assembly {
            algorithm := mload(add(multihash, 1))
            size := mload(add(multihash, 2))
        }
        require(length == (2 + size), "bad multihash size");

        if (algorithm == uint8(HashAlgorithm.Ethereum)) {
            require(signer != address(0x0), "invalid signer address");
            require(size == 65, "bad Ethereum multihash size");
            bytes32 hash;
            uint8 v;
            bytes32 r;
            bytes32 s;
            assembly {
                let data := mload(0x40)
                mstore(data, 0x19457468657265756d205369676e6564204d6573736167653a0a333200000000) // SIG_PREFIX
                mstore(add(data, 28), plaintext)                                                 // plaintext
                hash := keccak256(data, 60)                                                      // 28 + 32
                // Extract v, r and s from the multihash data
                v := mload(add(multihash, 3))
                r := mload(add(multihash, 35))
                s := mload(add(multihash, 67))
            }
            return signer == ecrecover(
                hash,
                v,
                r,
                s
            );
        } else if (algorithm == uint8(HashAlgorithm.EIP712)) {
            require(signer != address(0x0), "invalid signer address");
            require(size == 65, "bad EIP712 multihash size");
            uint8 v;
            bytes32 r;
            bytes32 s;
            assembly {
                // Extract v, r and s from the multihash data
                v := mload(add(multihash, 3))
                r := mload(add(multihash, 35))
                s := mload(add(multihash, 67))
            }
            return signer == ecrecover(
                plaintext,
                v,
                r,
                s
            );
        } else {
            return false;
        }
    }
}

// File: contracts/loopring/iface/IBrokerDelegate.sol

/*
 * Copyright 2019 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.7;


interface IBrokerDelegate {

  /*
   * Loopring requests an allowance be set on a given token for a specified amount. Order details
   * are provided (tokenS, totalAmountS, tokenB, totalAmountB, orderTokenRecipient, extraOrderData)
   * to aid in any calculations or on-chain exchange of assets that may be required. The last 4
   * parameters concern the actual token approval being requested of the broker.
   *
   * @returns Whether or not onOrderFillReport should be called for orders using this broker
   */
  function brokerRequestAllowance(BrokerData.BrokerApprovalRequest calldata request) external returns (bool);

  /*
   * After Loopring performs all of the transfers necessary to complete all the submitted
   * rings it will call this function for every order's brokerInterceptor (if set) passing
   * along the final fill counts for tokenB, tokenS and feeToken. This allows actions to be
   * performed on a per-order basis after all tokenS/feeToken funds have left the order owner's
   * possession and the tokenB funds have been transferred to the order owner's intended recipient
   */
  function onOrderFillReport(BrokerData.BrokerInterceptorReport calldata fillReport) external;

  /*
   * Get the available token balance controlled by the broker on behalf of an address (owner)
   */
  function brokerBalanceOf(address owner, address token) external view returns (uint);
}

// File: contracts/loopring/helper/OrderHelper.sol

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

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
pragma solidity ^0.5.7;






/// @title OrderHelper
/// @author Daniel Wang - <daniel@loopring.org>.
library OrderHelper {
    using MathUint      for uint;

    string constant internal EIP191_HEADER = "\x19\x01";
    string constant internal EIP712_DOMAIN_NAME = "Loopring Protocol";
    string constant internal EIP712_DOMAIN_VERSION = "2";
    bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(
        abi.encodePacked(
            "EIP712Domain(",
            "string name,",
            "string version",
            ")"
        )
    );
    bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(
        abi.encodePacked(
            "Order(",
            "uint amountS,",
            "uint amountB,",
            "uint feeAmount,",
            "uint validSince,",
            "uint validUntil,",
            "address owner,",
            "address tokenS,",
            "address tokenB,",
            "address dualAuthAddr,",
            "address broker,",
            "address orderInterceptor,",
            "address wallet,",
            "address tokenRecipient,",
            "address feeToken,",
            "uint16 walletSplitPercentage,",
            "uint16 tokenSFeePercentage,",
            "uint16 tokenBFeePercentage,",
            "bool allOrNone,",
            "uint8 tokenTypeS,",
            "uint8 tokenTypeB,",
            "uint8 tokenTypeFee,",
            "bytes32 trancheS,",
            "bytes32 trancheB,",
            "bytes transferDataS",
            ")"
        )
    );
    bytes32 constant internal EIP712_DOMAIN_HASH = keccak256(
        abi.encodePacked(
            EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
            keccak256(bytes(EIP712_DOMAIN_NAME)),
            keccak256(bytes(EIP712_DOMAIN_VERSION))
        )
    );

    function updateHash(Data.Order memory order)
        internal
        pure
    {
        // Pre-calculated EIP712_ORDER_SCHEMA_HASH amd EIP712_DOMAIN_HASH because
        // the solidity compiler doesn't correctly pre-calculate them for us.
        bytes32 _EIP712_ORDER_SCHEMA_HASH = 0x40b942178d2a51f1f61934268590778feb8114db632db7d88537c98d2b05c5f2;
        bytes32 _EIP712_DOMAIN_HASH = 0xaea25658c273c666156bd427f83a666135fcde6887a6c25fc1cd1562bc4f3f34;

//         bytes32 message = keccak256(
//             abi.encode(
//                 EIP712_ORDER_SCHEMA_HASH,
//                 order.amountS,
//                 order.amountB,
//                 order.feeAmount,
//                 order.validSince,
//                 order.validUntil,
//                 order.owner,
//                 order.tokenS,
//                 order.tokenB,
//                 order.dualAuthAddr,
//                 order.broker,
//                 order.orderInterceptor,
//                 order.wallet,
//                 order.tokenRecipient,
//                 order.feeToken,
//                 order.walletSplitPercentage,
//                 order.tokenSFeePercentage,
//                 order.tokenBFeePercentage,
//                 order.allOrNone,
//                 order.tokenTypeS,
//                 order.tokenTypeB,
//                 order.tokenTypeFee,
//                 order.trancheS,
//                 order.trancheB,
//                 order.transferDataS
//             )
//         );
//         order.hash = keccak256(
//            abi.encodePacked(
//                EIP191_HEADER,
//                EIP712_DOMAIN_HASH,
//                message
//            )
//        );

        bytes32 hash;
        assembly {
            // Calculate the hash for transferDataS separately
            let transferDataS := mload(add(order, 1248))         // order.transferDataS
            let transferDataSHash := keccak256(add(transferDataS, 32), mload(transferDataS))

            let ptr := mload(64)
            mstore(add(ptr,   0), _EIP712_ORDER_SCHEMA_HASH)     // EIP712_ORDER_SCHEMA_HASH
            mstore(add(ptr,  32), mload(add(order, 128)))        // order.amountS
            mstore(add(ptr,  64), mload(add(order, 160)))        // order.amountB
            mstore(add(ptr,  96), mload(add(order, 640)))        // order.feeAmount
            mstore(add(ptr, 128), mload(add(order, 192)))        // order.validSince
            mstore(add(ptr, 160), mload(add(order, 480)))        // order.validUntil
            mstore(add(ptr, 192), mload(add(order,  32)))        // order.owner
            mstore(add(ptr, 224), mload(add(order,  64)))        // order.tokenS
            mstore(add(ptr, 256), mload(add(order,  96)))        // order.tokenB
            mstore(add(ptr, 288), mload(add(order, 288)))        // order.dualAuthAddr
            mstore(add(ptr, 320), mload(add(order, 320)))        // order.broker
            mstore(add(ptr, 352), mload(add(order, 416)))        // order.orderInterceptor
            mstore(add(ptr, 384), mload(add(order, 448)))        // order.wallet
            mstore(add(ptr, 416), mload(add(order, 768)))        // order.tokenRecipient
            mstore(add(ptr, 448), mload(add(order, 608)))        // order.feeToken
            mstore(add(ptr, 480), mload(add(order, 800)))        // order.walletSplitPercentage
            mstore(add(ptr, 512), mload(add(order, 704)))        // order.tokenSFeePercentage
            mstore(add(ptr, 544), mload(add(order, 736)))        // order.tokenBFeePercentage
            mstore(add(ptr, 576), mload(add(order, 576)))        // order.allOrNone
            mstore(add(ptr, 608), mload(add(order, 1024)))       // order.tokenTypeS
            mstore(add(ptr, 640), mload(add(order, 1056)))       // order.tokenTypeB
            mstore(add(ptr, 672), mload(add(order, 1088)))       // order.tokenTypeFee
            mstore(add(ptr, 704), mload(add(order, 1120)))       // order.trancheS
            mstore(add(ptr, 736), mload(add(order, 1152)))       // order.trancheB
            mstore(add(ptr, 768), transferDataSHash)             // keccak256(order.transferDataS)
            let message := keccak256(ptr, 800)                   // 25 * 32

            mstore(add(ptr,  0), 0x1901)                         // EIP191_HEADER
            mstore(add(ptr, 32), _EIP712_DOMAIN_HASH)            // EIP712_DOMAIN_HASH
            mstore(add(ptr, 64), message)                        // message
            hash := keccak256(add(ptr, 30), 66)                  // 2 + 32 + 32
        }

        order.hash = hash;
    }

    function check(
        Data.Order memory order,
        Data.Context memory ctx
        )
        internal
        view
    {
        // If the order was already partially filled
        // we don't have to check all of the infos and the signature again
        if(order.filledAmountS == 0) {
            validateAllInfo(order, ctx);
            checkOwnerSignature(order, ctx);
        } else {
            validateUnstableInfo(order, ctx);
        }

        order.P2P = (order.tokenSFeePercentage > 0 || order.tokenBFeePercentage > 0);
    }

    function validateAllInfo(
        Data.Order memory order,
        Data.Context memory ctx
        )
        internal
        view
    {
        bool valid = true;
        valid = valid && (order.version == 0); // unsupported order version
        valid = valid && (order.owner != address(0x0)); // invalid order owner
        valid = valid && (order.tokenS != address(0x0)); // invalid order tokenS
        valid = valid && (order.tokenB != address(0x0)); // invalid order tokenB
        valid = valid && (order.amountS != 0); // invalid order amountS
        valid = valid && (order.amountB != 0); // invalid order amountB
        valid = valid && (order.feeToken != address(0x0)); // invalid fee token

        valid = valid && (order.tokenSFeePercentage < ctx.feePercentageBase); // invalid tokenS percentage
        valid = valid && (order.tokenBFeePercentage < ctx.feePercentageBase); // invalid tokenB percentage
        valid = valid && (order.walletSplitPercentage <= 100); // invalid wallet split percentage

        // We only support ERC20 for now
        valid = valid && (order.tokenTypeS == Data.TokenType.ERC20 && order.trancheS == 0x0);
        valid = valid && (order.tokenTypeFee == Data.TokenType.ERC20);

        // NOTICE: replaced to allow orders to specify market's primary token (to denote order side)
        // valid = valid && (order.tokenTypeB == Data.TokenType.ERC20 && order.trancheB == 0x0);
        valid = valid && (order.tokenTypeB == Data.TokenType.ERC20) && (
            bytes32ToAddress(order.trancheB) == order.tokenB ||
            bytes32ToAddress(order.trancheB) == order.tokenS
        );

        // NOTICE: commented to allow order.transferDataS to be used for dApps building on Loopring
        // valid = valid && (order.transferDataS.length == 0);

        valid = valid && (order.validSince <= (now + 300)); // order is too early to match

        valid = valid && (!order.allOrNone); // We don't support allOrNone

        require(valid, "INVALID_STABLE_DATA");

        order.valid = order.valid && valid;

        validateUnstableInfo(order, ctx);
    }


    function validateUnstableInfo(
        Data.Order memory order,
        Data.Context memory ctx
        )
        internal
        view
    {
        bool valid = true;
        valid = valid && (order.validUntil == 0 || order.validUntil > now - 300);  // order is expired
        valid = valid && (order.waiveFeePercentage <= int16(ctx.feePercentageBase)); // invalid waive percentage
        valid = valid && (order.waiveFeePercentage >= -int16(ctx.feePercentageBase)); // invalid waive percentage
        if (order.dualAuthAddr != address(0x0)) {
            // if dualAuthAddr exists, dualAuthSig must be exist.
            require(order.dualAuthSig.length > 0, "MISSING_DUAL_AUTH_SIGNATURE");
        }
        require(valid, "INVALID_UNSTABLE_DATA");
        order.valid = order.valid && valid;
    }


    function isBuy(Data.Order memory order) internal pure returns (bool) {
        return bytes32ToAddress(order.trancheB) == order.tokenB;
    }

    function checkOwnerSignature(
        Data.Order memory order,
        Data.Context memory ctx
        )
        internal
        view
    {
        if (order.sig.length == 0) {
            bool registered = ctx.orderRegistry.isOrderHashRegistered(
                order.owner,
                order.hash
            );

            if (!registered) {
                order.valid = order.valid && ctx.orderBook.orderSubmitted(order.hash);
            }
        } else {
            require(order.valid, "INVALID_ORDER_DATA");
            order.valid = order.valid && MultihashUtil.verifySignature(
                order.owner,
                order.hash,
                order.sig
            );
            require(order.valid, "INVALID_SIGNATURE");
        }
    }

    function checkDualAuthSignature(
        Data.Order memory order,
        bytes32 miningHash
        )
        internal
        pure
    {
        if (order.dualAuthSig.length != 0) {
            order.valid = order.valid && MultihashUtil.verifySignature(
                order.dualAuthAddr,
                miningHash,
                order.dualAuthSig
            );
            require(order.valid, 'INVALID_DUAL_AUTH_SIGNATURE');
        }
    }

    function getBrokerHash(Data.Order memory order) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(order.broker, order.tokenS, order.tokenB, order.feeToken));
    }

    function getSpendableS(
        Data.Order memory order,
        Data.Context memory ctx
        )
        internal
        view
        returns (uint)
    {
        return getSpendable(
            order,
            ctx.delegate,
            order.tokenS,
            order.owner,
            order.tokenSpendableS
        );
    }

    function getSpendableFee(
        Data.Order memory order,
        Data.Context memory ctx
        )
        internal
        view
        returns (uint)
    {
        return getSpendable(
            order,
            ctx.delegate,
            order.feeToken,
            order.owner,
            order.tokenSpendableFee
        );
    }

    function reserveAmountS(
        Data.Order memory order,
        uint amount
        )
        internal
        pure
    {
        order.tokenSpendableS.reserved += amount;
    }

    function reserveAmountFee(
        Data.Order memory order,
        uint amount
        )
        internal
        pure
    {
        order.tokenSpendableFee.reserved += amount;
    }

    function resetReservations(
        Data.Order memory order
        )
        internal
        pure
    {
        order.tokenSpendableS.reserved = 0;
        order.tokenSpendableFee.reserved = 0;
    }

    /// @return Amount of ERC20 token that can be spent by this contract.
    function getERC20Spendable(
        Data.Order memory order,
        ILoopringTradeDelegate delegate,
        address tokenAddress,
        address owner
        )
        private
        view
        returns (uint spendable)
    {
        if (order.broker == address(0x0)) {
            ERC20 token = ERC20(tokenAddress);
            spendable = token.allowance(
                owner,
                address(delegate)
            );
            if (spendable != 0) {
                uint balance = token.balanceOf(owner);
                spendable = (balance < spendable) ? balance : spendable;
            }
        } else {
            IBrokerDelegate broker = IBrokerDelegate(order.broker);
            spendable = broker.brokerBalanceOf(owner, tokenAddress);
        }
    }

    function getSpendable(
        Data.Order memory order,
        ILoopringTradeDelegate delegate,
        address tokenAddress,
        address owner,
        Data.Spendable memory tokenSpendable
        )
        private
        view
        returns (uint spendable)
    {
        if (!tokenSpendable.initialized) {
            tokenSpendable.amount = getERC20Spendable(
                order,
                delegate,
                tokenAddress,
                owner
            );
            tokenSpendable.initialized = true;
        }
        spendable = tokenSpendable.amount.sub(tokenSpendable.reserved);
    }

    function bytes32ToAddress(bytes32 data) private pure returns (address) {
        return address(uint160(uint256(data)));
    }
}

// File: contracts/dolomite-margin-protocol/lib/Order.sol

/*
 * Copyright 2019 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.7;

//import "./Runtime.sol";

library Order {

    using OrderHelper for Data.Order;

    struct Info {
        address signer;
        address tokenS;
        address tokenB;
        bytes32 orderHash;
        bytes extraData;
    }

    struct TradeInfo {
        bool isUsingDepositContract;
        uint positionId;
        uint expirationDays;
        uint depositMarketId;
        uint depositAmount;
        ////////
        address trader;
        address signer;
    }

    function tradeInfo(Order.Info memory order, RunTime.Context memory ctx) internal view returns (Order.TradeInfo memory info) {
    (
        info.isUsingDepositContract,
        info.positionId,
        info.expirationDays,
        info.depositMarketId,
        info.depositAmount
    ) = abi.decode(order.extraData, (bool, uint, uint, uint, uint));

        info.trader = info.isUsingDepositContract
        ? ctx.depositContractRegistry.depositAddressOf(order.signer)
        : order.signer;

        info.signer = order.signer;

        return info;
    }

    function decodeRawOrders(bytes memory ringData, uint[] memory relevantOrderIndices)
    internal
    pure
    returns (Order.Info[] memory orders)
    {
        orders = new Order.Info[](relevantOrderIndices.length);
        Data.Order[] memory rawOrders = LoopringOrderDecoder.decodeLoopringOrders(ringData, relevantOrderIndices);

        bytes memory emptyBytes = new bytes(0);
        for (uint i = 0; i < orders.length; i++) {
            rawOrders[i].updateHash();
            orders[i] = Order.Info({
                signer : rawOrders[i].owner,
                tokenS : rawOrders[i].tokenS,
                tokenB : rawOrders[i].tokenB,
                orderHash : rawOrders[i].hash,
                extraData : rawOrders[i].transferDataS
                });
        }
    }
}

// File: contracts/loopring/impl/ExchangeDeserializer.sol

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

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
pragma solidity ^0.5.7;




/// @title Deserializes the data passed to submitRings
/// @author Daniel Wang - <daniel@loopring.org>,
library ExchangeDeserializer {
    using BytesUtil     for bytes;

    function deserializeRingIndices(
        Data.Order[] memory orders,
        Data.RingIndices[] memory ringIndices
    ) internal
        view returns (
            Data.Ring[] memory rings
        ) {
        rings = new Data.Ring[](ringIndices.length);
        for (uint i = 0; i < ringIndices.length; i++) {
            rings[i].size = 2;
            rings[i].participations = new Data.Participation[](2);

            rings[i].participations[0] = Data.Participation({
                order: orders[ringIndices[i].index0],
                splitS: uint(0),
                feeAmount: uint(0),
                feeAmountS: uint(0),
                feeAmountB: uint(0),
                rebateFee: uint(0),
                rebateS: uint(0),
                rebateB: uint(0),
                fillAmountS: uint(0),
                fillAmountB: uint(0)
            });

            rings[i].participations[1] = Data.Participation({
                order: orders[ringIndices[i].index1],
                splitS: uint(0),
                feeAmount: uint(0),
                feeAmountS: uint(0),
                feeAmountB: uint(0),
                rebateFee: uint(0),
                rebateS: uint(0),
                rebateB: uint(0),
                fillAmountS: uint(0),
                fillAmountB: uint(0)
            });

            rings[i].hash = bytes32(0);
            rings[i].minerFeesToOrdersPercentage = uint(0);
            rings[i].valid = true;
        }
    }

    function deserialize(
        address lrcTokenAddress,
        bytes memory data
        )
        internal
        view
        returns (
            Data.Mining memory mining,
            Data.Order[] memory orders,
            Data.Ring[] memory rings
        )
    {
        // Read the header
        Data.Header memory header;
        header.version = data.bytesToUint16(0);
        header.numOrders = data.bytesToUint16(2);
        header.numRings = data.bytesToUint16(4);
        header.numSpendables = data.bytesToUint16(6);

        // Validation
        require(header.version == 0, "Unsupported serialization format");
        require(header.numOrders > 0, "Invalid number of orders");
        require(header.numRings > 0, "Invalid number of rings");
        require(header.numSpendables > 0, "Invalid number of spendables");

        // Calculate data pointers
        uint dataPtr;
        assembly {
            dataPtr := data
        }
        uint miningDataPtr = dataPtr + 8;
        uint orderDataPtr = miningDataPtr + 3 * 2;
        uint ringDataPtr = orderDataPtr + (32 * header.numOrders) * 2;
        uint dataBlobPtr = ringDataPtr + (header.numRings * 9) + 32;

        // The data stream needs to be at least large enough for the
        // header/mining/orders/rings data + 64 bytes of zeros in the data blob.
        require(data.length >= (dataBlobPtr - dataPtr) + 32, "Invalid input data");

        // Setup the rings
        mining = setupMiningData(dataBlobPtr, miningDataPtr + 2);
        orders = setupOrders(dataBlobPtr, orderDataPtr + 2, header.numOrders, header.numSpendables, lrcTokenAddress);
        rings = assembleRings(ringDataPtr + 1, header.numRings, orders);
    }

    function setupMiningData(
        uint data,
        uint tablesPtr
        )
        internal
        view
        returns (Data.Mining memory mining)
    {
        bytes memory emptyBytes = new bytes(0);
        uint offset;

        assembly {
            // Default to transaction origin for feeRecipient
            mstore(add(data, 20), origin)

            // mining.feeRecipient
            offset := mul(and(mload(add(tablesPtr,  0)), 0xFFFF), 4)
            mstore(
                add(mining,   0),
                mload(add(add(data, 20), offset))
            )

            // Restore default to 0
            mstore(add(data, 20), 0)

            // mining.miner
            offset := mul(and(mload(add(tablesPtr,  2)), 0xFFFF), 4)
            mstore(
                add(mining,  32),
                mload(add(add(data, 20), offset))
            )

            // Default to empty bytes array
            mstore(add(data, 32), emptyBytes)

            // mining.sig
            offset := mul(and(mload(add(tablesPtr,  4)), 0xFFFF), 4)
            mstore(
                add(mining, 64),
                add(data, add(offset, 32))
            )

            // Restore default to 0
            mstore(add(data, 32), 0)
        }
    }

    function setupOrders(
        uint data,
        uint tablesPtr,
        uint numOrders,
        uint numSpendables,
        address lrcTokenAddress
        )
        internal
        pure
        returns (Data.Order[] memory orders)
    {
        bytes memory emptyBytes = new bytes(0);
        uint orderStructSize = 40 * 32;
        // Memory for orders length + numOrders order pointers
        uint arrayDataSize = (1 + numOrders) * 32;
        Data.Spendable[] memory spendableList = new Data.Spendable[](numSpendables);
        uint offset;

        assembly {
            // Allocate memory for all orders
            orders := mload(0x40)
            mstore(add(orders, 0), numOrders)                       // orders.length
            // Reserve the memory for the orders array
            mstore(0x40, add(orders, add(arrayDataSize, mul(orderStructSize, numOrders))))

            for { let i := 0 } lt(i, numOrders) { i := add(i, 1) } {
                let order := add(orders, add(arrayDataSize, mul(orderStructSize, i)))

                // Store the memory location of this order in the orders array
                mstore(add(orders, mul(add(1, i), 32)), order)

                // order.version
                offset := and(mload(add(tablesPtr,  0)), 0xFFFF)
                mstore(
                    add(order,   0),
                    offset
                )

                // order.owner
                offset := mul(and(mload(add(tablesPtr,  2)), 0xFFFF), 4)
                mstore(
                    add(order,  32),
                    and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
                )

                // order.tokenS
                offset := mul(and(mload(add(tablesPtr,  4)), 0xFFFF), 4)
                mstore(
                    add(order,  64),
                    and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
                )

                // order.tokenB
                offset := mul(and(mload(add(tablesPtr,  6)), 0xFFFF), 4)
                mstore(
                    add(order,  96),
                    and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
                )

                // order.amountS
                offset := mul(and(mload(add(tablesPtr,  8)), 0xFFFF), 4)
                mstore(
                    add(order, 128),
                    mload(add(add(data, 32), offset))
                )

                // order.amountB
                offset := mul(and(mload(add(tablesPtr, 10)), 0xFFFF), 4)
                mstore(
                    add(order, 160),
                    mload(add(add(data, 32), offset))
                )

                // order.validSince
                offset := mul(and(mload(add(tablesPtr, 12)), 0xFFFF), 4)
                mstore(
                    add(order, 192),
                    and(mload(add(add(data, 4), offset)), 0xFFFFFFFF)
                )

                // order.tokenSpendableS
                offset := and(mload(add(tablesPtr, 14)), 0xFFFF)
                // Force the spendable index to 0 if it's invalid
                offset := mul(offset, lt(offset, numSpendables))
                mstore(
                    add(order, 224),
                    mload(add(spendableList, mul(add(offset, 1), 32)))
                )

                // order.tokenSpendableFee
                offset := and(mload(add(tablesPtr, 16)), 0xFFFF)
                // Force the spendable index to 0 if it's invalid
                offset := mul(offset, lt(offset, numSpendables))
                mstore(
                    add(order, 256),
                    mload(add(spendableList, mul(add(offset, 1), 32)))
                )

                // order.dualAuthAddr
                offset := mul(and(mload(add(tablesPtr, 18)), 0xFFFF), 4)
                mstore(
                    add(order, 288),
                    and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
                )

                // order.broker
                offset := mul(and(mload(add(tablesPtr, 20)), 0xFFFF), 4)
                mstore(
                    add(order, 320),
                    and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
                )

                // order.orderInterceptor
                offset := mul(and(mload(add(tablesPtr, 22)), 0xFFFF), 4)
                mstore(
                    add(order, 416),
                    and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
                )

                // order.wallet
                offset := mul(and(mload(add(tablesPtr, 24)), 0xFFFF), 4)
                mstore(
                    add(order, 448),
                    and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
                )

                // order.validUntil
                offset := mul(and(mload(add(tablesPtr, 26)), 0xFFFF), 4)
                mstore(
                    add(order, 480),
                    and(mload(add(add(data,  4), offset)), 0xFFFFFFFF)
                )

                // Default to empty bytes array for value sig and dualAuthSig
                mstore(add(data, 32), emptyBytes)

                // order.sig
                offset := mul(and(mload(add(tablesPtr, 28)), 0xFFFF), 4)
                mstore(
                    add(order, 512),
                    add(data, add(offset, 32))
                )

                // order.dualAuthSig
                offset := mul(and(mload(add(tablesPtr, 30)), 0xFFFF), 4)
                mstore(
                    add(order, 544),
                    add(data, add(offset, 32))
                )

                // Restore default to 0
                mstore(add(data, 32), 0)

                // order.allOrNone
                offset := and(mload(add(tablesPtr, 32)), 0xFFFF)
                mstore(
                    add(order, 576),
                    gt(offset, 0)
                )

                // lrcTokenAddress is the default value for feeToken
                mstore(add(data, 20), lrcTokenAddress)

                // order.feeToken
                offset := mul(and(mload(add(tablesPtr, 34)), 0xFFFF), 4)
                mstore(
                    add(order, 608),
                    and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
                )

                // Restore default to 0
                mstore(add(data, 20), 0)

                // order.feeAmount
                offset := mul(and(mload(add(tablesPtr, 36)), 0xFFFF), 4)
                mstore(
                    add(order, 640),
                    mload(add(add(data, 32), offset))
                )

                // order.waiveFeePercentage
                offset := and(mload(add(tablesPtr, 38)), 0xFFFF)
                mstore(
                    add(order, 672),
                    offset
                )

                // order.tokenSFeePercentage
                offset := and(mload(add(tablesPtr, 40)), 0xFFFF)
                mstore(
                    add(order, 704),
                    offset
                )

                // order.tokenBFeePercentage
                offset := and(mload(add(tablesPtr, 42)), 0xFFFF)
                mstore(
                    add(order, 736),
                    offset
                )

                // The owner is the default value of tokenRecipient
                mstore(add(data, 20), mload(add(order, 32)))                // order.owner

                // order.tokenRecipient
                offset := mul(and(mload(add(tablesPtr, 44)), 0xFFFF), 4)
                mstore(
                    add(order, 768),
                    and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
                )

                // Restore default to 0
                mstore(add(data, 20), 0)

                // order.walletSplitPercentage
                offset := and(mload(add(tablesPtr, 46)), 0xFFFF)
                mstore(
                    add(order, 800),
                    offset
                )

                // order.tokenTypeS
                offset := and(mload(add(tablesPtr, 48)), 0xFFFF)
                mstore(
                    add(order, 1024),
                    offset
                )

                // order.tokenTypeB
                offset := and(mload(add(tablesPtr, 50)), 0xFFFF)
                mstore(
                    add(order, 1056),
                    offset
                )

                // order.tokenTypeFee
                offset := and(mload(add(tablesPtr, 52)), 0xFFFF)
                mstore(
                    add(order, 1088),
                    offset
                )

                // order.trancheS
                offset := mul(and(mload(add(tablesPtr, 54)), 0xFFFF), 4)
                mstore(
                    add(order, 1120),
                    mload(add(add(data, 32), offset))
                )

                // order.trancheB
                offset := mul(and(mload(add(tablesPtr, 56)), 0xFFFF), 4)
                mstore(
                    add(order, 1152),
                    mload(add(add(data, 32), offset))
                )

                // Restore default to 0
                mstore(add(data, 20), 0)

                // order.maxPrimaryFillAmount
                offset := mul(and(mload(add(tablesPtr, 58)), 0xFFFF), 4)
                mstore(
                    add(order, 1184),
                    mload(add(add(data, 32), offset))
                )

                // order.allOrNone
                offset := and(mload(add(tablesPtr, 60)), 0xFFFF)
                mstore(
                    add(order, 1216),
                    gt(offset, 0)
                )

                // Default to empty bytes array for transferDataS
                mstore(add(data, 32), emptyBytes)

                // order.transferDataS
                offset := mul(and(mload(add(tablesPtr, 62)), 0xFFFF), 4)
                mstore(
                    add(order, 1248),
                    add(data, add(offset, 32))
                )

                // Restore default to 0
                mstore(add(data, 32), 0)

                // Set default  values
                mstore(add(order, 832), 0)         // order.P2P
                mstore(add(order, 864), 0)         // order.hash
                mstore(add(order, 896), 0)         // order.brokerInterceptor
                mstore(add(order, 928), 0)         // order.filledAmountS
                mstore(add(order, 960), 0)         // order.initialFilledAmountS
                mstore(add(order, 992), 1)         // order.valid

                // Advance to the next order
                tablesPtr := add(tablesPtr, 64)
            }
        }
    }

    function assembleRings(
        uint data,
        uint numRings,
        Data.Order[] memory orders
        )
        internal
        pure
        returns (Data.Ring[] memory rings)
    {
        uint ringsArrayDataSize = (1 + numRings) * 32;
        uint ringStructSize = 5 * 32;
        uint participationStructSize = 10 * 32;

        assembly {
            // Allocate memory for all rings
            rings := mload(0x40)
            mstore(add(rings, 0), numRings)                      // rings.length
            // Reserve the memory for the rings array
            mstore(0x40, add(rings, add(ringsArrayDataSize, mul(ringStructSize, numRings))))

            for { let r := 0 } lt(r, numRings) { r := add(r, 1) } {
                let ring := add(rings, add(ringsArrayDataSize, mul(ringStructSize, r)))

                // Store the memory location of this ring in the rings array
                mstore(add(rings, mul(add(r, 1), 32)), ring)

                // Get the ring size
                let ringSize := and(mload(data), 0xFF)
                data := add(data, 1)

                // require(ringsSize <= 8)
                if gt(ringSize, 8) {
                    revert(0, 0)
                }

                // Allocate memory for all participations
                let participations := mload(0x40)
                mstore(add(participations, 0), ringSize)         // participations.length
                // Memory for participations length + ringSize participation pointers
                let participationsData := add(participations, mul(add(1, ringSize), 32))
                // Reserve the memory for the participations
                mstore(0x40, add(participationsData, mul(participationStructSize, ringSize)))

                // Initialize ring properties
                mstore(add(ring,   0), ringSize)                 // ring.size
                mstore(add(ring,  32), participations)           // ring.participations
                mstore(add(ring,  64), 0)                        // ring.hash
                mstore(add(ring,  96), 0)                        // ring.minerFeesToOrdersPercentage
                mstore(add(ring, 128), 1)                        // ring.valid

                for { let i := 0 } lt(i, ringSize) { i := add(i, 1) } {
                    let participation := add(participationsData, mul(participationStructSize, i))

                    // Store the memory location of this participation in the participations array
                    mstore(add(participations, mul(add(i, 1), 32)), participation)

                    // Get the order index
                    let orderIndex := and(mload(data), 0xFF)
                    // require(orderIndex < orders.length)
                    if iszero(lt(orderIndex, mload(orders))) {
                        revert(0, 0)
                    }
                    data := add(data, 1)

                    // participation.order
                    mstore(
                        add(participation,   0),
                        mload(add(orders, mul(add(orderIndex, 1), 32)))
                    )

                    // Set default values
                    mstore(add(participation,  32), 0)          // participation.splitS
                    mstore(add(participation,  64), 0)          // participation.feeAmount
                    mstore(add(participation,  96), 0)          // participation.feeAmountS
                    mstore(add(participation, 128), 0)          // participation.feeAmountB
                    mstore(add(participation, 160), 0)          // participation.rebateFee
                    mstore(add(participation, 192), 0)          // participation.rebateS
                    mstore(add(participation, 224), 0)          // participation.rebateB
                    mstore(add(participation, 256), 0)          // participation.fillAmountS
                    mstore(add(participation, 288), 0)          // participation.fillAmountB
                }

                // Advance to the next ring
                data := add(data, sub(8, ringSize))
            }
        }
    }
}

// File: contracts/dolomite-margin-protocol/lib/Runtime.sol

/*
 * Copyright 2019 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.7;







library RunTime {
    struct OutgoingAllowanceTrigger {
        address signer;
        uint marketId;
        uint amount;
    }

    struct TokenTransfer {
        address from;
        address to;
        address token;
        uint amount;
        bool isUsingDepositContract;
    }

    struct Context {
        address self;
        IDepositContractRegistry depositContractRegistry;
        address dydxExpiryContractAddress;
        Order.Info[] orders;
        address[] marketTokenAddress;
        ////////
        bytes32[] depositFlagTriggers;
        TokenTransfer[] tokenTransfers;
        OutgoingAllowanceTrigger[] setOutgoingAllowanceTriggers;
        DydxPosition.Info[] dydxPositions;
        DydxActions.ActionArgs[] dydxBeforeActions;
        DydxActions.ActionArgs[] dydxAfterActions;
        uint numDepositFlagTriggers;
        uint numTokenTransfers;
        uint numSetOutgoingAllowanceTriggers;
        uint numDydxPositions;
        uint numDydxBeforeActions;
        uint numDydxAfterActions;
    }

    // ---------------------------------

    function setDepositFlag(Context memory ctx, bytes32 orderHash) internal pure {
        ctx.depositFlagTriggers[ctx.numDepositFlagTriggers] = orderHash;
        ctx.numDepositFlagTriggers += 1;
    }

    function requireTokenTransfer(
        Context memory ctx,
        address from,
        address to,
        address token,
        uint amount,
        bool isUsingDepositContract
    ) internal pure {
        for (uint i = 0; i < ctx.numTokenTransfers; i++) {
            TokenTransfer memory transfer = ctx.tokenTransfers[i];
            if (transfer.from == from && transfer.to == to && transfer.token == token) {
                transfer.amount += amount;
                return;
            }
        }

        ctx.tokenTransfers[ctx.numTokenTransfers] = TokenTransfer(from, to, token, amount, isUsingDepositContract);
        ctx.numTokenTransfers += 1;
    }

    function registerPosition(
        Context memory ctx,
        address trader,
        uint positionId
    ) internal pure returns (uint) {
        for (uint i = 0; i < ctx.numDydxPositions; i++) {
            if (ctx.dydxPositions[i].owner == trader && ctx.dydxPositions[i].number == positionId) {
                return i;
            }
        }

        ctx.dydxPositions[ctx.numDydxPositions] = DydxPosition.Info(trader, positionId);
        ctx.numDydxPositions += 1;
        return ctx.numDydxPositions - 1;
    }

    function addBeforeAction(Context memory ctx, DydxActions.ActionArgs memory action) internal pure {
        ctx.dydxBeforeActions[ctx.numDydxBeforeActions] = action;
        ctx.numDydxBeforeActions += 1;
    }

    function addAfterAction(Context memory ctx, DydxActions.ActionArgs memory action) internal pure {
        ctx.dydxAfterActions[ctx.numDydxAfterActions] = action;
        ctx.numDydxAfterActions += 1;
    }
}

// File: contracts/dolomite-margin-protocol/lib/Activity.sol

/*
 * Copyright 2019 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.7;




library Activity {
    using RunTime for RunTime.Context;
    using Order for Order.Info;
    using Activity for *;

    struct ActivityArg {
        Activity.Type activityType;
        bytes encodedFields;
    }

    enum Type {Trade, Loan, Liquidation}
    enum TradeMovementType {None, DepositAll, WithdrawAll}

    struct Trade {
        uint orderIndex;
        uint marketIdS;
        uint marketIdB;
        uint fillAmountS;
        TradeMovementType movementType;
    }

    struct Loan {
        // TODO
        uint orderIndex;
    }

    struct Liquidation {
        uint orderIndex;
        uint marketIdS;
        uint marketIdB;
        uint fillAmountB;
        address profitReceiver;
        address liquidOwner;
        uint liquidPositionId;
    }

    function depositBalanceHash() internal pure returns (bytes32) {
        return bytes32(0x1234567812345678123456781234567812345678123456781234567812345678);
    }

    function registerActivity(RunTime.Context memory ctx, Activity.Type activityType, bytes memory encodedFields) internal view {
        if (activityType == Type.Trade) encodedFields._decodeTradeActivity()._generateTradeActions(ctx);
        else if (activityType == Type.Loan) encodedFields._decodeLoanActivity()._generateLoanActions(ctx);
        else if (activityType == Type.Liquidation) encodedFields._decodeLiquidationActivity()._generateLiquidationActions(ctx);
    }

    // ---------------------------------

    function _decodeTradeActivity(bytes memory encoded) internal pure returns (Activity.Trade memory trade) {
        return abi.decode(encoded, (Activity.Trade));
    }

    function _decodeLoanActivity(bytes memory encoded) internal pure returns (Activity.Loan memory loan) {
        revert("NOT_IMPLEMENTED: Activity.Type.Loan is not yet supported");
    }

    function _decodeLiquidationActivity(bytes memory encoded) internal pure returns (Activity.Liquidation memory liquidation) {
        return abi.decode(encoded, (Activity.Liquidation));
    }

    // ---------------------------------

    function _generateTradeActions(Activity.Trade memory trade, RunTime.Context memory ctx) internal view {
        Order.Info memory order = ctx.orders[trade.orderIndex];
        Order.TradeInfo memory tradeInfo = order.tradeInfo(ctx);

        uint positionIndex = ctx.registerPosition(tradeInfo.trader, tradeInfo.positionId);

        // Requirements for deposit of trader's collateral
        if (trade.movementType == Activity.TradeMovementType.DepositAll) {
            address depositToken = ctx.marketTokenAddress[tradeInfo.depositMarketId];
            ctx.requireTokenTransfer(tradeInfo.signer, ctx.self, depositToken, tradeInfo.depositAmount, tradeInfo.isUsingDepositContract);
            ctx.addBeforeAction(DydxActionBuilder.Deposit(positionIndex, tradeInfo.depositMarketId, tradeInfo.depositAmount, ctx.self));
            ctx.setDepositFlag(order.orderHash);
        }

        // Actions for borrowing tokens to exchange and depositing what was received
        ctx.addBeforeAction(DydxActionBuilder.Withdraw(positionIndex, trade.marketIdS, trade.fillAmountS, ctx.self));
        ctx.addAfterAction(DydxActionBuilder.DepositAll({
            positionIndex : positionIndex,
            marketId : trade.marketIdB,
            burnMarketId : trade.marketIdS,
            controller : ctx.self,
            orderHash : order.orderHash
            }));

        // Actions to withdraw the position's balances to the trader
        if (trade.movementType == Activity.TradeMovementType.WithdrawAll) {
            ctx.addAfterAction(DydxActionBuilder.WithdrawAll(positionIndex, trade.marketIdS, tradeInfo.trader));
            ctx.addAfterAction(DydxActionBuilder.WithdrawAll(positionIndex, trade.marketIdB, tradeInfo.trader));
        }

        // Action for setting the expiration timestamp of the position
        if (trade.movementType == Activity.TradeMovementType.DepositAll && tradeInfo.expirationDays > 0) {
            uint expirationTime = block.timestamp + (tradeInfo.expirationDays * 60 * 60 * 24);
            ctx.addAfterAction(DydxActionBuilder.SetExpiry(positionIndex, ctx.dydxExpiryContractAddress, trade.marketIdS, expirationTime));
        }
    }

    function _generateLoanActions(Activity.Loan memory trade, RunTime.Context memory ctx) internal pure {/* TODO */}

    function _generateLiquidationActions(Activity.Liquidation memory liquidation, RunTime.Context memory ctx) internal view {
        // For liquidations, `primaryMarketId` is the owed market. `secondaryMarketId` is the market whose positive
        // balance will be earned (plus the 5% spread). We buy into `marketIdB` using the collateral earned from
        // `marketIdS`. In doing so, we will take on the debt owed by the liquid account and then sell off any positive
        // balance (which is in secondaryMarketId) into the owed market (primaryMarketId), to clear out any debt.
        // Whatever is left from this process is profit for the liquidator.
        Order.Info memory order = ctx.orders[liquidation.orderIndex];

        uint solidPositionTradeIndex = ctx.registerPosition(order.signer, 0);
        uint solidPositionProfitIndex = ctx.registerPosition(liquidation.profitReceiver, 0);
        uint liquidPositionIndex = ctx.registerPosition(liquidation.liquidOwner, liquidation.liquidPositionId);

        DydxActions.ActionArgs memory liquidateAction;
        liquidateAction.actionType = DydxActions.ActionType.Liquidate;
        liquidateAction.accountId = solidPositionTradeIndex;
        liquidateAction.otherAccountId = liquidPositionIndex;
        liquidateAction.primaryMarketId = liquidation.marketIdB;
        liquidateAction.secondaryMarketId = liquidation.marketIdS;
        if (liquidation.fillAmountB == uint(- 1)) {
            liquidateAction.amount = DydxTypes.AssetAmount({
                sign : true,
                denomination : DydxTypes.AssetDenomination.Wei,
                ref : DydxTypes.AssetReference.Target,
                value : 0
                });
        } else {
            liquidateAction.amount = DydxTypes.AssetAmount({
                sign : true,
                denomination : DydxTypes.AssetDenomination.Wei,
                ref : DydxTypes.AssetReference.Delta,
                value : liquidation.fillAmountB
                });
        }
        ctx.addBeforeAction(liquidateAction);

        // Sell off the full positive balance (`marketIdS`) that was received from the liquidation.
        ctx.addBeforeAction(DydxActionBuilder.WithdrawAll(solidPositionTradeIndex, liquidation.marketIdS, ctx.self));

        // Deposit all received tokens from the sell (of marketIdS into marketIdB) into the account. This should
        // make our negative balance positive. The new positive balance is now profit for the solid account.
        ctx.addAfterAction(DydxActionBuilder.DepositAll({
            positionIndex : solidPositionTradeIndex,
            marketId : liquidation.marketIdB,
            burnMarketId : liquidation.marketIdS,
            controller : ctx.self,
            orderHash : order.orderHash
            }));

        // Move the funds from trade index to the profit-taking one. This way, we only move positive balances into this
        // account.
        DydxActions.ActionArgs memory transferAction;
        transferAction.actionType = DydxActions.ActionType.Transfer;
        transferAction.accountId = solidPositionTradeIndex;
        transferAction.otherAccountId = solidPositionProfitIndex;
        transferAction.primaryMarketId = liquidation.marketIdB;
        transferAction.amount = DydxTypes.AssetAmount({
            sign : true,
            denomination : DydxTypes.AssetDenomination.Wei,
            ref : DydxTypes.AssetReference.Target,
            value : 0
            });
        ctx.addAfterAction(transferAction);
    }
}

// File: contracts/loopring/iface/IRingSubmitter.sol

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

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
pragma solidity ^0.5.7;


/// @title IRingSubmitter
/// @author Daniel Wang - <daniel@loopring.org>
/// @author Kongliang Zhong - <kongliang@loopring.org>
contract IRingSubmitter {
    uint16  public constant FEE_PERCENTAGE_BASE = 1000;

    /// @dev  Event emitted when a ring was successfully mined
    ///        _ringIndex     The index of the ring
    ///        _ringHash      The hash of the ring
    ///        _feeRecipient  The recipient of the matching fee
    ///        _fills         The info of the orders in the ring stored like:
    ///                       [orderHash, owner, tokenS, amountS, split, feeAmount, feeAmountS, feeAmountB]
    event RingMined(
        uint            _ringIndex,
        bytes32 indexed _ringHash,
        address indexed _feeRecipient,
        bytes           _fills
    );

    /// @dev   Event emitted when a ring was not successfully mined
    ///         _ringHash  The hash of the ring
    event InvalidRing(
        bytes32 _ringHash
    );

    /// @dev   Event emitted when fee rebates are distributed (waiveFeePercentage < 0)
    ///         _ringHash   The hash of the ring whose order(s) will receive the rebate
    ///         _orderHash  The hash of the order that will receive the rebate
    ///         _feeToken   The address of the token that will be paid to the _orderHash's owner
    ///         _feeAmount  The amount to be paid to the owner
    event DistributeFeeRebate(
        bytes32 indexed _ringHash,
        bytes32 indexed _orderHash,
        address         _feeToken,
        uint            _feeAmount
    );

//    /// @dev   Submit order-rings for validation and settlement.
//    /// @param data ABI encoded struct containing ring data.
//    function submitRings(
//        Data.SubmitRingsRequest calldata data
//    ) external;

    /// @dev   Submit order-rings for validation and settlement.
    /// @param data Packed data of all rings.
    function submitRings(
        bytes calldata data
    ) external;

    function delegateAddress() external returns (address);
}

// File: contracts/dolomite-margin-protocol/DolomiteMarginProtocol.sol

/*
 * Copyright 2020 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.13;













/*
 * @title DolomiteMarginV2
 *
 * Allows Loopring v2.3 orders to trade on margin, loan funds with 0 collateral to perform 
 * arbitrage and liquidate under-collateralized positions through the dYdX protocol.
 *
 * Users sign orders with the broker set to this contract, so orders must be submitted
 * through this contract, ensuring that margin orders can only be settled as margin orders.
 * Users also sign other information in the extraData (transferDataS) field of the order 
 * which is used by this contract. The information provided by the relay is checked
 * against this information signed by the user, and is also verified by Loopring v2.3 and dYdX.
 */
contract DolomiteMarginProtocol is IDyDxCallee, IBrokerDelegate, IDyDxExchangeWrapper, DolomiteMarginReentrancyGuard, Ownable {
    using Order for *;
    using Activity for *;
    using LoopringTradeDelegateHelper for ILoopringTradeDelegate;
    using SafeERC20 for IERC20;
    using SafeMath for *;

    //        bytes32 public constant DEPOSIT_COLLATERAL_TYPE_HASH = keccak256("DepositCollateral(address signer,uint256 positionId,uint256 tokenId,uint256 amount,uint256 feeAmount,address feeRecipient,uint256 expiry,uint256 nonce)");
    bytes32 public constant DEPOSIT_COLLATERAL_TYPE_HASH = 0x3e5ecf67633bf55e5afafd4ed3ca3ce81df8fe6e1767e986edc5e247c0019d27;

    //        bytes32 public constant WITHDRAW_COLLATERAL_TYPE_HASH = keccak256("WithdrawCollateral(address signer,uint256 positionId,uint256 tokenId,uint256 amount,uint256 feeAmount,address feeRecipient,uint256 expiry,uint256 nonce)");
    bytes32 public constant WITHDRAW_COLLATERAL_TYPE_HASH = 0xf4f01e4a789a88db3d7581d902fca290c3d0ef9a0974ee9c5f6ac11c86056e7e;

    bytes32 public domainSeparator;

    struct RelayParams {
        uint[] relevantOrderIndices;
        uint[] relevantMarketIds;
        Activity.ActivityArg[] activityArgs;
        address dustCollector;
    }

    address public DYDX_EXPIRY_ADDRESS;
    IDyDxProtocol public DYDX_PROTOCOL;
    IRingSubmitter public LOOPRING_PROTOCOL;
    IDepositContractRegistry public DEPOSIT_CONTRACT_REGISTRY;
    ILoopringTradeDelegate public TRADE_DELEGATE;

    constructor(
        address dydxProtocol,
        address payable loopringProtocol,
        address dydxExpiry,
        address depositContractRegistry
    ) public {
        DYDX_PROTOCOL = IDyDxProtocol(dydxProtocol);
        LOOPRING_PROTOCOL = IRingSubmitter(loopringProtocol);
        TRADE_DELEGATE = ILoopringTradeDelegate(LOOPRING_PROTOCOL.delegateAddress());
        DEPOSIT_CONTRACT_REGISTRY = IDepositContractRegistry(depositContractRegistry);
        DYDX_EXPIRY_ADDRESS = dydxExpiry;

        uint256 chainId;
        assembly {chainId := chainid()}

        domainSeparator = keccak256(abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256(bytes("Dolomite Margin")),
                keccak256(bytes(/* version */ "1")),
                chainId,
                address(this)
            ));
    }

    // =================================

    mapping(bytes32 => bool) private _orderHasDeposited;
    mapping(bytes32 => mapping(address => uint)) private _runtimeIncomingAmount;
    mapping(address => uint) private _nonces;

    function nonceOf(address user) public view returns (uint) {
        return _nonces[user];
    }

    function withdrawDust(address token) public onlyOwner {
        IERC20(token).safeTransfer(owner(), IERC20(token).balanceOf(address(this)));
    }

    function depositCollateral(uint positionId, uint tokenId, uint amount) public singleEntry {
        TRADE_DELEGATE.transferTokenFrom(
            DYDX_PROTOCOL.getMarketTokenAddress(tokenId),
            msg.sender,
            address(this),
            amount
        );

        DydxPosition.Info[] memory infos = new DydxPosition.Info[](1);
        infos[0] = DydxPosition.Info(msg.sender, positionId);

        DydxActions.ActionArgs[] memory args = new DydxActions.ActionArgs[](1);
        args[0] = DydxActionBuilder.Deposit(0, tokenId, amount, /* from */ address(this));

        DYDX_PROTOCOL.operate(infos, args);
    }

    function withdrawCollateral(uint positionId, uint tokenId, uint amount) public singleEntry {
        DydxPosition.Info[] memory infos = new DydxPosition.Info[](1);
        infos[0] = DydxPosition.Info(msg.sender, positionId);

        DydxActions.ActionArgs[] memory args = new DydxActions.ActionArgs[](1);
        if (amount == uint(- 1)) {
            args[0] = DydxActionBuilder.WithdrawAll(0, tokenId, msg.sender);
        } else {
            args[0] = DydxActionBuilder.Withdraw(0, tokenId, amount, msg.sender);
        }

        DYDX_PROTOCOL.operate(infos, args);
    }

    function depositCollateralViaGaslessRequest(
        address signer,
        uint positionId,
        uint tokenId,
        uint amount,
        uint feeAmount,
        address feeRecipient,
        uint expiry,
        uint nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public singleEntry {
        require(amount >= feeAmount, "FEE_TOO_LARGE");
        validateGaslessRequest(
            DEPOSIT_COLLATERAL_TYPE_HASH,
            signer,
            positionId,
            tokenId,
            amount,
            feeAmount,
            feeRecipient,
            expiry,
            nonce,
            v,
            r,
            s
        );

        // These functions were created to help avoid the infamous "stack too deep" error.
        performDolomiteDirectDepositTransferIn(signer, tokenId, amount);
        payFeesForDolomiteDirectDepositIfNecessary(feeAmount, feeRecipient, tokenId);
        performDolomiteDirectDeposit(signer, positionId, tokenId, amount.sub(feeAmount));
    }

    function withdrawCollateralViaGaslessRequest(
        address signer,
        uint positionId,
        uint tokenId,
        uint amount,
        uint feeAmount,
        address feeRecipient,
        uint expiry,
        uint nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public singleEntry {
        require(amount >= feeAmount, "FEE_TOO_LARGE");
        validateGaslessRequest(
            WITHDRAW_COLLATERAL_TYPE_HASH,
            signer,
            positionId,
            tokenId,
            amount,
            feeAmount,
            feeRecipient,
            expiry,
            nonce,
            v,
            r,
            s
        );

        // This is function was created to help avoid the infamous "stack too deep" error.
        performDolomiteDirectWithdraw(signer, positionId, tokenId, amount);
        payFeesForDolomiteDirectWithdrawalIfNecessary(signer, feeAmount, feeRecipient, tokenId);
    }

    /*
     * If orders in a Loopring settlement require interaction(s) with dYdX in order to
     * trade on margin, loan money to perform arbitrage or perform liquidations, they can
     * be submitted here. The orders that need dYdX are registered along with other relevant
     * information in the RelayParams parameter by the relay.
     */
    function submitRingsThroughDyDx(
        bytes memory ringData,
        RelayParams memory params
    ) public singleEntry {
        Order.Info[] memory orders = ringData.decodeRawOrders(params.relevantOrderIndices);
        submitRingsThroughDyDx(ringData, params, orders, /* isTypeSafe */ false);
    }

    /*
     * If orders in a Loopring settlement require interaction(s) with dYdX in order to
     * trade on margin, loan money to perform arbitrage or perform liquidations, they can
     * be submitted here. The orders that need dYdX are registered along with other relevant
     * information in the RelayParams parameter by the relay.
     */
    function submitRingsThroughDyDx(
        bytes memory ringData,
        RelayParams memory params,
        Order.Info[] memory orders,
        bool isTypeSafe
    ) internal {
        RunTime.Context memory ctx = _createRuntimeContext(orders, params);
        _registerActivities(ctx, params.activityArgs);
        _resolveDepositFlagTriggers(ctx);
        _performTokenTransfers(ctx);

        (
        DydxPosition.Info[] memory positions,
        DydxActions.ActionArgs[] memory actions
        ) = _generateDydxPerformParams(ctx, ringData, isTypeSafe);

        DYDX_PROTOCOL.operate(positions, actions);

        _clearRuntime(ctx);
    }

    function _createRuntimeContext(Order.Info[] memory orders, RelayParams memory params)
    internal
    view
    returns (RunTime.Context memory ctx)
    {
        uint numActivities = params.activityArgs.length;

        uint totalNumMarkets = DYDX_PROTOCOL.getNumMarkets();
        ctx.marketTokenAddress = new address[](totalNumMarkets);
        for (uint i = 0; i < params.relevantMarketIds.length; i++) {
            ctx.marketTokenAddress[params.relevantMarketIds[i]] = DYDX_PROTOCOL.getMarketTokenAddress(params.relevantMarketIds[i]);
        }

        ctx.self = address(this);
        ctx.orders = orders;
        ctx.depositContractRegistry = DEPOSIT_CONTRACT_REGISTRY;
        ctx.dydxExpiryContractAddress = DYDX_EXPIRY_ADDRESS;
        ctx.depositFlagTriggers = new bytes32[](numActivities);
        ctx.tokenTransfers = new RunTime.TokenTransfer[](numActivities);
        ctx.dydxPositions = new DydxPosition.Info[](numActivities * 3);
        ctx.dydxBeforeActions = new DydxActions.ActionArgs[](numActivities * 3);
        ctx.dydxAfterActions = new DydxActions.ActionArgs[](numActivities * 3);

        return ctx;
    }

    function _registerActivities(RunTime.Context memory ctx, Activity.ActivityArg[] memory activityArgs) internal view {
        for (uint i = 0; i < activityArgs.length; i++) {
            Activity.ActivityArg memory arg = activityArgs[i];
            ctx.registerActivity(arg.activityType, arg.encodedFields);
        }
    }

    function _resolveDepositFlagTriggers(RunTime.Context memory ctx) internal {
        for (uint i = 0; i < ctx.numDepositFlagTriggers; i++) {
            bytes32 orderHash = ctx.depositFlagTriggers[i];
            require(_orderHasDeposited[orderHash] == false, "ORDER_DEPOSIT_REJECTED: deposit already performed");
            _orderHasDeposited[orderHash] = true;
        }
    }

    function _performTokenTransfers(RunTime.Context memory ctx) internal {
        for (uint i = 0; i < ctx.numTokenTransfers; i++) {
            RunTime.TokenTransfer memory transfer = ctx.tokenTransfers[i];
            if (transfer.isUsingDepositContract) {
                IDolomiteDirect dolomiteDirect = IDolomiteDirect(DEPOSIT_CONTRACT_REGISTRY.versionOf(transfer.from));
                dolomiteDirect.brokerMarginRequestApproval(
                    transfer.from,
                    transfer.token,
                    transfer.amount
                );
                TRADE_DELEGATE.transferTokenFrom(
                    transfer.token,
                    address(dolomiteDirect),
                    transfer.to,
                    transfer.amount
                );
            } else {
                TRADE_DELEGATE.transferTokenFrom(
                    transfer.token,
                    transfer.from,
                    transfer.to,
                    transfer.amount
                );
            }
        }
    }

    function _generateDydxPerformParams(RunTime.Context memory ctx, bytes memory ringData, bool isTypeSafe)
    internal
    pure
    returns (DydxPosition.Info[] memory positions, DydxActions.ActionArgs[] memory actions)
    {
        positions = new DydxPosition.Info[](ctx.numDydxPositions + 1);
        actions = new DydxActions.ActionArgs[](ctx.numDydxBeforeActions + ctx.numDydxAfterActions + 1);

        // Trim positions array & insert before actions to beginning of actions array
        for (uint i = 0; i < ctx.numDydxPositions; i++) positions[i] = ctx.dydxPositions[i];
        for (uint j = 0; j < ctx.numDydxBeforeActions; j++) actions[j] = ctx.dydxBeforeActions[j];

        // Insert Loopring settlement action after the "before" actions
        positions[ctx.numDydxPositions] = DydxPosition.Info(ctx.self, 123456789);
        actions[ctx.numDydxBeforeActions] = DydxActionBuilder.LoopringSettlement({
            settlementData : abi.encode(isTypeSafe, ringData),
            settlementCaller : ctx.self,
            positionIndex : ctx.numDydxPositions
            });

        // Insert all of the after actions after Loopring settlement is to take place
        for (uint k = 0; k < ctx.numDydxAfterActions; k++) {
            actions[k + ctx.numDydxBeforeActions + 1] = ctx.dydxAfterActions[k];
        }
    }

    function _clearRuntime(RunTime.Context memory ctx) internal {
        for (uint i = 0; i < ctx.orders.length; i++) {
            bytes32 orderHash = ctx.orders[i].orderHash;
            for (uint j = 0; j < ctx.marketTokenAddress.length; j++) {
                _runtimeIncomingAmount[orderHash][ctx.marketTokenAddress[j]] = 0;
            }
        }
    }

    // =================================
    // Loopring Settlement & dYdX Action Callbacks

    /*
     * @Implements IDyDxCallee
     *
     * dYdX is instructed to perform all of the necessary actions for
     * margin order settlement (and loan/liquidation settlement) to succeed.
     * After all of these actions, an action is performed that calls this function,
     * which performs trade settlement through Loopring v2.3
     */
    function callFunction(
        address sender,
        DydxPosition.Info memory accountInfo,
        bytes memory data
    ) public noEntry {
        require(msg.sender == address(DYDX_PROTOCOL), "INVALID_CALLER: IDyDxCallee caller must be dYdX protocol");
        (bool isTypeSafe, bytes memory ringData) = abi.decode(data, (bool, bytes));
        if (isTypeSafe) {
            revert("Submitting rings with type safety is not enabled!");
            //      LOOPRING_PROTOCOL.submitRings(abi.decode(ringData, (Data.SubmitRingsRequest)));
        } else {
            LOOPRING_PROTOCOL.submitRings(ringData);
        }
    }

    /*
     * @Implements ILoopringBrokerDelegate
     *
     * Loopring will request the available balance of the order owner if the broker. The amount of funds borrowed is
     * baked into the size of the order. Thus, returning an actual balance is redundant.
     */
    function brokerBalanceOf(address user, address token) public view returns (uint) {
        return uint(- 1);
    }

    /*
     * @Implements ILoopringBrokerDelegate
     *
     * Loopring will then request approval to transfer the borrowed amount to settle the
     * order with the borrowed funds. Loopring notifies this contract how much the order
     * has been filled and requires that the funds are sent into itself (this). The exact
     * amount of received tokens is stored for later use.
     */
    function brokerRequestAllowance(BrokerData.BrokerApprovalRequest memory request) public noEntry returns (bool) {
        require(msg.sender == address(TRADE_DELEGATE), "INVALID_CALLER: Caller of broker impl must be Loopring Delegate");

        for (uint i = 0; i < request.orders.length; i++) {
            BrokerData.BrokerOrder memory order = request.orders[i];
            require(order.tokenRecipient == address(this), "INVALID_RECIPIENT: Token recipient must be set to margin protocol");
            require(order.requestedFeeAmount == 0, "INVALID_ORDER_FEE: FeeToken must be in tokenB of Loopring order");

            _runtimeIncomingAmount[order.orderHash][request.tokenB] = order.fillAmountB;
        }

        return false;
    }

    function onOrderFillReport(BrokerData.BrokerInterceptorReport memory fillReport) public {
        // No op - do nothing
    }

    /*
     * @Implements IDyDxExchangeWrapper
     *
     * Neat "hack": if you want to orchestrate a deposit for an unknown amount
     * you can use a SellAction to do it. Have dYdX "sell" 1 wei and, in the
     * implementation of the IExchangeWrapper's exchange function, return an amount
     * and it will be deposited into the dYdX position in full! 1 wei is burned unfortunately,
     * but who really cares.
     *
     * That amount we "stored for later use" is returned so that all of the purchased tokens
     * are deposited into dYdX in full.
     */
    function exchange(
        address tradeOriginator,
        address receiver,
        address makerToken,
        address takerToken,
        uint256 requestedFillAmount,
        bytes memory orderData
    ) public noEntry returns (uint256) {
        require(msg.sender == address(DYDX_PROTOCOL), "INVALID_EXCHANGE_CALLER");
        bytes32 orderHash = abi.decode(orderData, (bytes32));
        return _runtimeIncomingAmount[orderHash][makerToken];
    }

    // =================================
    // Administrative

    function enableToken(address tokenAddress) public {
        IERC20(tokenAddress).approve(address(TRADE_DELEGATE), uint(- 1));
        IERC20(tokenAddress).approve(address(DYDX_PROTOCOL), uint(- 1));
    }

    function enableTokens(address[] calldata tokenAddresses) external {
        for (uint i = 0; i < tokenAddresses.length; i++) {
            enableToken(tokenAddresses[i]);
        }
    }

    // =================================
    // Private

    function validateGaslessRequest(
        bytes32 typeHash,
        address signer,
        uint positionId,
        uint tokenId,
        uint amount,
        uint feeAmount,
        address feeRecipient,
        uint expiry,
        uint nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) private {
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                domainSeparator,
                keccak256(abi.encode(typeHash, signer, positionId, tokenId, amount, feeAmount, feeRecipient, expiry, nonce))
            )
        );

        require(signer == ecrecover(digest, v, r, s), "INVALID_SIGNATURE");
        require(expiry == 0 || now <= expiry, "REQUEST_EXPIRED");
        require(nonce == _nonces[signer], "INVALID_NONCE");
        if (feeAmount > 0) {
            require(feeRecipient != address(0x0), "INVALID_FEE_ADDRESS");
        }

        _nonces[signer] += 1;
    }

    function payFeesForDolomiteDirectDepositIfNecessary(
        uint feeAmount,
        address feeRecipient,
        uint tokenId
    ) private {
        if (feeAmount > 0) {
            require(feeRecipient != address(0x0), "INVALID_FEE_RECIPIENT");
            address token = DYDX_PROTOCOL.getMarketTokenAddress(tokenId);
            IERC20(token).safeTransfer(feeRecipient, feeAmount);
        }
    }

    function performDolomiteDirectDepositTransferIn(
        address signer,
        uint tokenId,
        uint amount
    )
    private {
        IDolomiteDirect dolomiteDirect = IDolomiteDirect(DEPOSIT_CONTRACT_REGISTRY.versionOf(signer));
        address token = DYDX_PROTOCOL.getMarketTokenAddress(tokenId);
        dolomiteDirect.brokerMarginRequestApproval(signer, token, amount);
        TRADE_DELEGATE.transferTokenFrom(
            token,
            address(dolomiteDirect),
            address(this),
            amount
        );
    }

    function performDolomiteDirectDeposit(
        address signer,
        uint positionId,
        uint tokenId,
        uint amountLessFee
    )
    private {
        address trader = DEPOSIT_CONTRACT_REGISTRY.depositAddressOf(signer);

        DydxPosition.Info[] memory infos = new DydxPosition.Info[](1);
        infos[0] = DydxPosition.Info(trader, positionId);

        DydxActions.ActionArgs[] memory args = new DydxActions.ActionArgs[](1);
        args[0] = DydxActionBuilder.Deposit(0, tokenId, amountLessFee, /* from */ address(this));

        DYDX_PROTOCOL.operate(infos, args);
    }

    function performDolomiteDirectWithdraw(
        address signer,
        uint positionId,
        uint tokenId,
        uint amount
    )
    private {
        address trader = DEPOSIT_CONTRACT_REGISTRY.depositAddressOf(signer);

        DydxPosition.Info[] memory infos = new DydxPosition.Info[](1);
        infos[0] = DydxPosition.Info(trader, positionId);

        // We withdraw to the trader's deposit contract so we can later pull the fee, if there is one. Reason being,
        // there may be leftover funds in this contract, so we cannot trust the values/balances presented in here.
        // Therefore, it's best to just send it to the trader, and then pull what's needed afterward.
        DydxActions.ActionArgs[] memory args = new DydxActions.ActionArgs[](1);
        if (amount == uint(- 1)) {
            args[0] = DydxActionBuilder.WithdrawAll(0, tokenId, trader);
        } else {
            args[0] = DydxActionBuilder.Withdraw(0, tokenId, amount, trader);
        }

        DYDX_PROTOCOL.operate(infos, args);
    }

    function payFeesForDolomiteDirectWithdrawalIfNecessary(
        address signer,
        uint feeAmount,
        address feeRecipient,
        uint tokenId
    ) private {
        if (feeAmount > 0) {
            require(feeRecipient != address(0x0), "INVALID_FEE_RECIPIENT");

            address dolomiteDirect = DEPOSIT_CONTRACT_REGISTRY.versionOf(signer);
            address token = DYDX_PROTOCOL.getMarketTokenAddress(tokenId);

            IDolomiteDirect(dolomiteDirect).brokerMarginRequestApproval(
                signer,
                token,
                feeAmount
            );
            TRADE_DELEGATE.transferTokenFrom(
                token,
                dolomiteDirect,
                feeRecipient,
                feeAmount
            );
        }
    }

}