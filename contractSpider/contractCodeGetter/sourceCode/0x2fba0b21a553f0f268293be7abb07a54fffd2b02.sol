/**
 *Submitted for verification at Etherscan.io on 2020-05-01
*/

// File: @openzeppelin/upgrades/contracts/Initializable.sol

pragma solidity >=0.4.24 <0.6.0;


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
    uint256 cs;
    assembly { cs := extcodesize(address) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol

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

// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol

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

// File: @openzeppelin/contracts-ethereum-package/contracts/utils/ReentrancyGuard.sol

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
contract ReentrancyGuard is Initializable {
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

// File: contracts/UpdatedZaps/WIP/UniSwapRemoveLiquidityGeneral_v1.sol

// Copyright (C) 2019, 2020 dipeshsukhani, nodarjonashi, toshsharma, suhailg

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// Visit <https://www.gnu.org/licenses/>for a copy of the GNU Affero General Public License

/**
 * WARNING: This is an upgradable contract. Be careful not to disrupt
 * the existing storage layout when making upgrades to the contract. In particular,
 * existing fields should not be removed and should not have their types changed.
 * The order of field declarations must not be changed, and new fields must be added
 * below all existing declarations.
 *
 * The base contracts and the order in which they are declared must not be changed.
 * New fields must not be added to base contracts (unless the base contract has
 * reserved placeholder fields for this purpose).
 *
 * See https://docs.zeppelinos.org/docs/writing_contracts.html for more info.
*/

pragma solidity ^0.5.0;





///@author DeFiZap
///@notice this contract implements one click conversion from Unipool liquidity tokens to ETH

interface IuniswapFactory_UniSwapRemoveLiquityGeneral_v1 {
    function getExchange(address token)
        external
        view
        returns (address exchange);
}

interface IuniswapExchange_UniSwapRemoveLiquityGeneral_v1 {
    // for removing liquidity (returns ETH removed, ERC20 Removed)
    function removeLiquidity(
        uint256 amount,
        uint256 min_eth,
        uint256 min_tokens,
        uint256 deadline
    ) external returns (uint256, uint256);

    // to convert ERC20 to ETH and transfer
    function getTokenToEthInputPrice(uint256 tokens_sold)
        external
        view
        returns (uint256 eth_bought);
    function tokenToEthTransferInput(
        uint256 tokens_sold,
        uint256 min_eth,
        uint256 deadline,
        address recipient
    ) external returns (uint256 eth_bought);
    /// -- optional
    function tokenToEthSwapInput(
        uint256 tokens_sold,
        uint256 min_eth,
        uint256 deadline
    ) external returns (uint256 eth_bought);

    // to convert ETH to ERC20 and transfer
    function getEthToTokenInputPrice(uint256 eth_sold)
        external
        view
        returns (uint256 tokens_bought);
    function ethToTokenTransferInput(
        uint256 min_tokens,
        uint256 deadline,
        address recipient
    ) external payable returns (uint256 tokens_bought);
    /// -- optional
    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline)
        external
        payable
        returns (uint256 tokens_bought);

    // converting ERC20 to ERC20 and transfer
    function tokenToTokenTransferInput(
        uint256 tokens_sold,
        uint256 min_tokens_bought,
        uint256 min_eth_bought,
        uint256 deadline,
        address recipient,
        address token_addr
    ) external returns (uint256 tokens_bought);

    // misc
    function allowance(address _owner, address _spender)
        external
        view
        returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address from, address to, uint256 tokens)
        external
        returns (bool success);

}

contract UniSwapRemoveLiquityGeneral_v1 is Initializable, ReentrancyGuard {
    using SafeMath for uint256;

    // state variables

    // - THESE MUST ALWAYS STAY IN THE SAME LAYOUT
    bool private stopped;
    address payable public owner;
    IuniswapFactory_UniSwapRemoveLiquityGeneral_v1 public UniSwapFactoryAddress;
    uint16 public goodwill;
    address public dzgoodwillAddress;
    mapping(address => uint256) private userBalance;
    IERC20 public DaiTokenAddress;

    // events
    event details(
        IuniswapExchange_UniSwapRemoveLiquityGeneral_v1 indexed ExchangeAddress,
        IERC20 TokenAdddress,
        address _user,
        uint256 LiqRed,
        uint256 ethRec,
        uint256 tokenRec,
        string indexed func
    );

    // circuit breaker modifiers
    modifier stopInEmergency {
        if (stopped) {
            revert("Temporarily Paused");
        } else {
            _;
        }
    }
    modifier onlyOwner() {
        require(isOwner(), "you are not authorised to call this function");
        _;
    }

    function initialize(
        address _UniSwapFactoryAddress,
        uint16 _goodwill,
        address _dzgoodwillAddress,
        address _DaiTokenAddress
    ) public initializer {
        ReentrancyGuard.initialize();
        stopped = false;
        owner = msg.sender;
        UniSwapFactoryAddress = IuniswapFactory_UniSwapRemoveLiquityGeneral_v1(
            _UniSwapFactoryAddress
        );
        goodwill = _goodwill;
        dzgoodwillAddress = _dzgoodwillAddress;
        DaiTokenAddress = IERC20(_DaiTokenAddress);
    }

    function set_new_UniSwapFactoryAddress(address _new_UniSwapFactoryAddress)
        public
        onlyOwner
    {
        UniSwapFactoryAddress = IuniswapFactory_UniSwapRemoveLiquityGeneral_v1(
            _new_UniSwapFactoryAddress
        );

    }

    function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
        require(
            _new_goodwill >= 0 && _new_goodwill <= 10000,
            "GoodWill Value not allowed"
        );
        goodwill = _new_goodwill;

    }

    function set_new_dzgoodwillAddress(address _new_dzgoodwillAddress)
        public
        onlyOwner
    {
        dzgoodwillAddress = _new_dzgoodwillAddress;
    }

    function LetsWithdraw_onlyETH(
        address _TokenContractAddress,
        uint256 LiquidityTokenSold
    ) public payable stopInEmergency nonReentrant returns (bool) {
        IuniswapExchange_UniSwapRemoveLiquityGeneral_v1 UniSwapExchangeContractAddress = IuniswapExchange_UniSwapRemoveLiquityGeneral_v1(
            UniSwapFactoryAddress.getExchange(_TokenContractAddress)
        );
        uint256 maxtokensPermitted = UniSwapExchangeContractAddress.allowance(
            msg.sender,
            address(this)
        );
        require(
            LiquidityTokenSold <= maxtokensPermitted,
            "Permission to DeFiZap is less than requested"
        );
        uint256 goodwillPortion = SafeMath.div(
            SafeMath.mul(LiquidityTokenSold, goodwill),
            10000
        );
        require(
            UniSwapExchangeContractAddress.transferFrom(
                msg.sender,
                address(this),
                SafeMath.sub(LiquidityTokenSold, goodwillPortion)
            ),
            "error2:defizap"
        );
        require(
            UniSwapExchangeContractAddress.transferFrom(
                msg.sender,
                dzgoodwillAddress,
                goodwillPortion
            ),
            "error3:defizap"
        );

        (uint256 ethReceived, uint256 erc20received) = UniSwapExchangeContractAddress
            .removeLiquidity(
            SafeMath.sub(LiquidityTokenSold, goodwillPortion),
            1,
            1,
            SafeMath.add(now, 1800)
        );

        uint256 eth_againstERC20 = UniSwapExchangeContractAddress
            .getTokenToEthInputPrice(erc20received);
        IERC20(_TokenContractAddress).approve(
            address(UniSwapExchangeContractAddress),
            erc20received
        );
        UniSwapExchangeContractAddress.tokenToEthTransferInput(
            erc20received,
            SafeMath.div(SafeMath.mul(eth_againstERC20, 98), 100),
            SafeMath.add(now, 1800),
            msg.sender
        );
        userBalance[msg.sender] = ethReceived;
        require(send_out_eth(msg.sender), "issue in transfer ETH");
        emit details(
            UniSwapExchangeContractAddress,
            IERC20(_TokenContractAddress),
            msg.sender,
            SafeMath.sub(LiquidityTokenSold, goodwillPortion),
            ethReceived,
            erc20received,
            "onlyETH"
        );
        return true;
    }

    function LetsWithdraw_onlyERC(
        address _TokenContractAddress,
        uint256 LiquidityTokenSold,
        bool _returnInDai
    ) public payable stopInEmergency nonReentrant returns (bool) {
        IuniswapExchange_UniSwapRemoveLiquityGeneral_v1 UniSwapExchangeContractAddress = IuniswapExchange_UniSwapRemoveLiquityGeneral_v1(
            UniSwapFactoryAddress.getExchange(_TokenContractAddress)
        );
        IuniswapExchange_UniSwapRemoveLiquityGeneral_v1 DAIUniSwapExchangeContractAddress = IuniswapExchange_UniSwapRemoveLiquityGeneral_v1(
            UniSwapFactoryAddress.getExchange(address(DaiTokenAddress))
        );
        uint256 maxtokensPermitted = UniSwapExchangeContractAddress.allowance(
            msg.sender,
            address(this)
        );
        require(
            LiquidityTokenSold <= maxtokensPermitted,
            "Permission to DeFiZap is less than requested"
        );
        uint256 goodwillPortion = SafeMath.div(
            SafeMath.mul(LiquidityTokenSold, goodwill),
            10000
        );
        require(
            UniSwapExchangeContractAddress.transferFrom(
                msg.sender,
                address(this),
                SafeMath.sub(LiquidityTokenSold, goodwillPortion)
            ),
            "error2:defizap"
        );
        require(
            UniSwapExchangeContractAddress.transferFrom(
                msg.sender,
                dzgoodwillAddress,
                goodwillPortion
            ),
            "error3:defizap"
        );
        (uint256 ethReceived, uint256 erc20received) = UniSwapExchangeContractAddress
            .removeLiquidity(
            SafeMath.sub(LiquidityTokenSold, goodwillPortion),
            1,
            1,
            SafeMath.add(now, 1800)
        );
        if (_returnInDai) {
            require(
                _TokenContractAddress != address(DaiTokenAddress),
                "error5:defizap"
            );
            DAIUniSwapExchangeContractAddress.ethToTokenTransferInput.value(
                ethReceived
            )(1, SafeMath.add(now, 1800), msg.sender);
            IERC20(_TokenContractAddress).approve(
                address(UniSwapExchangeContractAddress),
                erc20received
            );
            UniSwapExchangeContractAddress.tokenToTokenTransferInput(
                erc20received,
                1,
                1,
                SafeMath.add(now, 1800),
                msg.sender,
                address(DaiTokenAddress)
            );
            emit details(
                UniSwapExchangeContractAddress,
                IERC20(_TokenContractAddress),
                msg.sender,
                SafeMath.sub(LiquidityTokenSold, goodwillPortion),
                ethReceived,
                erc20received,
                "onlyDAI"
            );
        } else {
            UniSwapExchangeContractAddress.ethToTokenTransferInput.value(
                ethReceived
            )(1, SafeMath.add(now, 1800), msg.sender);
            IERC20(_TokenContractAddress).transfer(msg.sender, erc20received);
            emit details(
                UniSwapExchangeContractAddress,
                IERC20(_TokenContractAddress),
                msg.sender,
                SafeMath.sub(LiquidityTokenSold, goodwillPortion),
                ethReceived,
                erc20received,
                "onlyERC"
            );
        }

        return true;
    }

    function send_out_eth(address _towhomtosendtheETH) internal returns (bool) {
        require(userBalance[_towhomtosendtheETH] > 0, "error4:DefiZap");
        uint256 amount = userBalance[_towhomtosendtheETH];
        userBalance[_towhomtosendtheETH] = 0;
        (bool success, ) = _towhomtosendtheETH.call.value(amount)("");
        require(success, "error5:DefiZap");
        return true;
    }

    // - fallback function let you / anyone send ETH to this wallet without the need to call any function
    function() external payable {}

    // Should there be a need to withdraw any other ERC20 token
    function withdrawERC20Token(IERC20 _targetContractAddress)
        public
        onlyOwner
    {
        uint256 OtherTokenBalance = _targetContractAddress.balanceOf(
            address(this)
        );
        _targetContractAddress.transfer(owner, OtherTokenBalance);
    }

    // - to Pause the contract
    function toggleContractActive() public onlyOwner {
        stopped = !stopped;
    }

    // - to withdraw any ETH balance sitting in the contract
    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }

    // - to kill the contract
    function destruct() public onlyOwner {
        selfdestruct(owner);
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address payable newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address payable newOwner) internal {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        owner = newOwner;
    }

}