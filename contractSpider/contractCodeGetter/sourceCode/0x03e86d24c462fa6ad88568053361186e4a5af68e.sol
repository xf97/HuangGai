/**
 *Submitted for verification at Etherscan.io on 2020-07-10
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
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
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

// File: @openzeppelin/contracts/utils/ReentrancyGuard.sol

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


// Copyright (C) 2020 zapper, dipeshsukhani, nodarjanashia, suhailg, sebaudet, sumitrajput, apoorvlathey

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

///@author Zapper
///@notice this contract adds liquidity to Balancer liquidity pools in one transaction

pragma solidity 0.5.12;


interface IBFactory_Balancer_ZapIn_General_V1 {
    function isBPool(address b) external view returns (bool);
}


interface IBPool_Balancer_ZapIn_General_V1 {
    function joinswapExternAmountIn(
        address tokenIn,
        uint256 tokenAmountIn,
        uint256 minPoolAmountOut
    ) external payable returns (uint256 poolAmountOut);

    function isBound(address t) external view returns (bool);

    function getFinalTokens() external view returns (address[] memory tokens);

    function totalSupply() external view returns (uint256);

    function getDenormalizedWeight(address token)
        external
        view
        returns (uint256);

    function getTotalDenormalizedWeight() external view returns (uint256);

    function getSwapFee() external view returns (uint256);

    function calcPoolOutGivenSingleIn(
        uint256 tokenBalanceIn,
        uint256 tokenWeightIn,
        uint256 poolSupply,
        uint256 totalWeight,
        uint256 tokenAmountIn,
        uint256 swapFee
    ) external pure returns (uint256 poolAmountOut);

    function getBalance(address token) external view returns (uint256);
}


interface IuniswapFactory_Balancer_ZapIn_General_V1 {
    function getExchange(address token)
        external
        view
        returns (address exchange);
}


interface Iuniswap_Balancer_ZapIn_General_V1 {
    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline)
        external
        payable
        returns (uint256 tokens_bought);

    // converting ERC20 to ERC20 and transfer
    function tokenToTokenSwapInput(
        uint256 tokens_sold,
        uint256 min_tokens_bought,
        uint256 min_eth_bought,
        uint256 deadline,
        address token_addr
    ) external returns (uint256 tokens_bought);

    function getTokenToEthInputPrice(uint256 tokens_sold)
        external
        view
        returns (uint256 eth_bought);

    function getEthToTokenInputPrice(uint256 eth_sold)
        external
        view
        returns (uint256 tokens_bought);

    function balanceOf(address _owner) external view returns (uint256);

    function transfer(address _to, uint256 _value) external returns (bool);

    function transferFrom(address from, address to, uint256 tokens)
        external
        returns (bool success);
}

interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;
}



contract Balancer_ZapIn_General_V2 is ReentrancyGuard, Ownable {
    using SafeMath for uint256;
    using Address for address;
    bool private stopped = false;
    uint16 public goodwill;
    address public dzgoodwillAddress;

    IuniswapFactory_Balancer_ZapIn_General_V1 public UniSwapFactoryAddress = IuniswapFactory_Balancer_ZapIn_General_V1(
        0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95
    );
    IBFactory_Balancer_ZapIn_General_V1 BalancerFactory = IBFactory_Balancer_ZapIn_General_V1(
        0x9424B1412450D0f8Fc2255FAf6046b98213B76Bd
    );

    address wethTokenAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    event Zapin(
        address _toWhomToIssue,
        address _toBalancerPoolAddress,
        uint256 _OutgoingBPT
    );

    constructor(
        uint16 _goodwill,
        address _dzgoodwillAddress
    ) public {
        goodwill = _goodwill;
        dzgoodwillAddress = _dzgoodwillAddress;
    }

    // circuit breaker modifiers
    modifier stopInEmergency {
        if (stopped) {
            revert("Temporarily Paused");
        } else {
            _;
        }
    }

    /**
    @notice This function is used to invest in given balancer pool through ETH/ERC20 Tokens
    @param _FromTokenContractAddress The token used for investment (address(0x00) if ether)
    @param _ToBalancerPoolAddress The address of balancer pool to zapin
    @param _amount The amount of ERC to invest
    @param _minPoolTokens for slippage
    @return success or failure
     */
    function EasyZapIn(
        address _FromTokenContractAddress,
        address _ToBalancerPoolAddress,
        uint256 _amount,
        uint256 _minPoolTokens
    ) public payable nonReentrant stopInEmergency returns (uint256 tokensBought) {
        require(
            BalancerFactory.isBPool(_ToBalancerPoolAddress),
            "Invalid Balancer Pool"
        );

        if (_FromTokenContractAddress == address(0)) {
            require(msg.value > 0, "ERR: No ETH sent");

            address _ToTokenContractAddress = _getBestDeal(
                _ToBalancerPoolAddress,
                msg.value,
                _FromTokenContractAddress
            );

            tokensBought = _performZapIn(
                msg.sender,
                _FromTokenContractAddress,
                _ToBalancerPoolAddress,
                msg.value,
                _ToTokenContractAddress,
                _minPoolTokens
            );

            return tokensBought;
        }

        require(_amount > 0, "ERR: No ERC sent");
        require(msg.value == 0, "ERR: ETH sent with tokens");

        //transfer tokens to contract
        require(
            IERC20(_FromTokenContractAddress).transferFrom(
                msg.sender,
                address(this),
                _amount
            ),
            "Error in transferring ERC: 1"
        );

        address _ToTokenContractAddress = _getBestDeal(
            _ToBalancerPoolAddress,
            _amount,
            _FromTokenContractAddress
        );

        tokensBought = _performZapIn(
            msg.sender,
            _FromTokenContractAddress,
            _ToBalancerPoolAddress,
            _amount,
            _ToTokenContractAddress,
            _minPoolTokens
        );
    }

    /**
    @notice This function is used to invest in given balancer pool through ETH/ERC20 Tokens with interface
    @param _toWhomToIssue The user address who want to invest
    @param _FromTokenContractAddress The token used for investment (address(0x00) if ether)
    @param _ToBalancerPoolAddress The address of balancer pool to zapin
    @param _amount The amount of ERC to invest
    @param _IntermediateToken The token for intermediate conversion before zapin
    @param _minPoolTokens for slippage
    @return The quantity of Balancer Pool tokens returned
     */
    function ZapIn(
        address payable _toWhomToIssue,
        address _FromTokenContractAddress,
        address _ToBalancerPoolAddress,
        uint256 _amount,
        address _IntermediateToken,
        uint256 _minPoolTokens
    ) public payable nonReentrant stopInEmergency returns (uint256 tokensBought) {

        if (_FromTokenContractAddress == address(0)) {
            require(msg.value > 0, "ERR: No ETH sent");

            tokensBought = _performZapIn(
                _toWhomToIssue,
                _FromTokenContractAddress,
                _ToBalancerPoolAddress,
                msg.value,
                _IntermediateToken,
                _minPoolTokens
            );

            return tokensBought;
        }

        require(_amount > 0, "ERR: No ERC sent");
        require(msg.value == 0, "ERR: ETH sent with tokens");

        //transfer tokens to contract
        require(
            IERC20(_FromTokenContractAddress).transferFrom(
                msg.sender,
                address(this),
                _amount
            ),
            "Error in transferring ERC: 2"
        );

        tokensBought = _performZapIn(
            _toWhomToIssue,
            _FromTokenContractAddress,
            _ToBalancerPoolAddress,
            _amount,
            _IntermediateToken,
            _minPoolTokens
        );
    }

    /**
    @notice This function internally called by ZapIn() and EasyZapIn()
    @param _toWhomToIssue The user address who want to invest
    @param _FromTokenContractAddress The token used for investment (address(0x00) if ether)
    @param _ToBalancerPoolAddress The address of balancer pool to zapin
    @param _amount The amount of ETH/ERC to invest
    @param _IntermediateToken The token for intermediate conversion before zapin
    @param _minPoolTokens for slippage
    @return The quantity of Balancer Pool tokens returned
     */
    function _performZapIn(
        address _toWhomToIssue,
        address _FromTokenContractAddress,
        address _ToBalancerPoolAddress,
        uint256 _amount,
        address _IntermediateToken,
        uint256 _minPoolTokens
    ) internal returns (uint256 tokensBought) {
        // check if isBound()
        bool isBound = IBPool_Balancer_ZapIn_General_V1(_ToBalancerPoolAddress)
            .isBound(_FromTokenContractAddress);

        uint256 balancerTokens;

        if (isBound) {
            balancerTokens = _enter2Balancer(
                _ToBalancerPoolAddress,
                _FromTokenContractAddress,
                _amount,
                _minPoolTokens
            );
        } else {
            // swap tokens or eth
            uint256 tokenBought;
            if (_FromTokenContractAddress == address(0)) {
                tokenBought = _eth2Token(_IntermediateToken);
            } else {
                tokenBought = _token2Token(
                    _FromTokenContractAddress,
                    _IntermediateToken,
                    _amount
                );
            }

            //get BPT
            balancerTokens = _enter2Balancer(
                _ToBalancerPoolAddress,
                _IntermediateToken,
                tokenBought,
                _minPoolTokens
            );
        }

        //transfer goodwill
        uint256 goodwillPortion = _transferGoodwill(
            _ToBalancerPoolAddress,
            balancerTokens
        );

        emit Zapin(
            _toWhomToIssue,
            _ToBalancerPoolAddress,
            SafeMath.sub(balancerTokens, goodwillPortion)
        );

        //transfer tokens to user
        IERC20(_ToBalancerPoolAddress).transfer(
            _toWhomToIssue,
            SafeMath.sub(balancerTokens, goodwillPortion)
        );
        return SafeMath.sub(balancerTokens, goodwillPortion);
    }

    /**
    @notice This function is used to calculate and transfer goodwill
    @param _tokenContractAddress Token in which goodwill is deducted
    @param tokens2Trade The total amount of tokens to be zapped in
    @return The quantity of goodwill deducted
     */
    function _transferGoodwill(
        address _tokenContractAddress,
        uint256 tokens2Trade
    ) internal returns (uint256 goodwillPortion) {
        goodwillPortion = SafeMath.div(
            SafeMath.mul(tokens2Trade, goodwill),
            10000
        );

        if (goodwillPortion == 0) {
            return 0;
        }

        require(
            IERC20(_tokenContractAddress).transfer(
                dzgoodwillAddress,
                goodwillPortion
            ),
            "Error in transferring BPT:1"
        );
    }

    /**
    @notice This function is used to zapin to balancer pool
    @param _ToBalancerPoolAddress The address of balancer pool to zap in
    @param _FromTokenContractAddress The token used to zap in
    @param tokens2Trade The amount of tokens to invest
    @return The quantity of Balancer Pool tokens returned
     */
    function _enter2Balancer(
        address _ToBalancerPoolAddress,
        address _FromTokenContractAddress,
        uint256 tokens2Trade,
        uint256 _minPoolTokens
    ) internal returns (uint256 poolTokensOut) {
        require(
            IBPool_Balancer_ZapIn_General_V1(_ToBalancerPoolAddress).isBound(
                _FromTokenContractAddress
            ),
            "Token not bound"
        );

        uint256 allowance = IERC20(_FromTokenContractAddress).allowance(
            address(this),
            _ToBalancerPoolAddress
        );

        if (allowance < tokens2Trade) {
            IERC20(_FromTokenContractAddress).approve(
                _ToBalancerPoolAddress,
                uint256(-1)
            );
        }

        poolTokensOut = IBPool_Balancer_ZapIn_General_V1(_ToBalancerPoolAddress)
            .joinswapExternAmountIn(_FromTokenContractAddress, tokens2Trade, _minPoolTokens);

        require(poolTokensOut > 0, "Error in entering balancer pool");
    }

    /**
    @notice This function finds best token from the final tokens of balancer pool
    @param _ToBalancerPoolAddress The address of balancer pool to zap in
    @param _amount amount of eth/erc to invest
    @param _FromTokenContractAddress the token address which is used to invest
    @return The token address having max liquidity
     */
    function _getBestDeal(
        address _ToBalancerPoolAddress,
        uint256 _amount,
        address _FromTokenContractAddress
    ) internal view returns (address _token) {
        //get token list
        address[] memory tokens = IBPool_Balancer_ZapIn_General_V1(
            _ToBalancerPoolAddress
        ).getFinalTokens();

        uint256 amount = _amount;
        
        if (_FromTokenContractAddress != address(0)) {
            // check if isBound()
            bool isBound = IBPool_Balancer_ZapIn_General_V1(
                _ToBalancerPoolAddress
            ).isBound(_FromTokenContractAddress);

            if (isBound) return _FromTokenContractAddress;

            //get eth value for given token

            Iuniswap_Balancer_ZapIn_General_V1 FromUniSwapExchangeContractAddress
            = Iuniswap_Balancer_ZapIn_General_V1(
                UniSwapFactoryAddress.getExchange(_FromTokenContractAddress)
            );

            //get qty of eth expected
            amount = Iuniswap_Balancer_ZapIn_General_V1(
                FromUniSwapExchangeContractAddress
            ).getTokenToEthInputPrice(_amount);
        } else {
            bool isBound = IBPool_Balancer_ZapIn_General_V1(
                _ToBalancerPoolAddress
            ).isBound(wethTokenAddress);

            if (isBound) return wethTokenAddress;   
        }

        uint256 maxBPT;

        for (uint256 index = 0; index < tokens.length; index++) {

            Iuniswap_Balancer_ZapIn_General_V1 FromUniSwapExchangeContractAddress
            = Iuniswap_Balancer_ZapIn_General_V1(
                UniSwapFactoryAddress.getExchange(tokens[index])
            );

            if (address(FromUniSwapExchangeContractAddress) == address(0)) {
                continue;
            }

            //get qty of tokens
            uint256 expectedTokens = Iuniswap_Balancer_ZapIn_General_V1(
                FromUniSwapExchangeContractAddress
            ).getEthToTokenInputPrice(amount);

            //get bpt for given tokens
            uint256 expectedBPT = getToken2BPT(
                _ToBalancerPoolAddress,
                expectedTokens,
                tokens[index]
            );

            //get token giving max BPT
            if (maxBPT < expectedBPT) {
                maxBPT = expectedBPT;
                _token = tokens[index];
            }
        }
    }

    /**
    @notice Function gives the expected amount of pool tokens on investing
    @param _ToBalancerPoolAddress Address of balancer pool to zapin
    @param _IncomingERC The amount of ERC to invest
    @param _FromToken Address of token to zap in with
    @return Amount of BPT token
     */
    function getToken2BPT(
        address _ToBalancerPoolAddress,
        uint256 _IncomingERC,
        address _FromToken
    ) internal view returns (uint256 tokensReturned) {
        uint256 totalSupply = IBPool_Balancer_ZapIn_General_V1(
            _ToBalancerPoolAddress
        ).totalSupply();
        uint256 swapFee = IBPool_Balancer_ZapIn_General_V1(
            _ToBalancerPoolAddress
        ).getSwapFee();
        uint256 totalWeight = IBPool_Balancer_ZapIn_General_V1(
            _ToBalancerPoolAddress
        ).getTotalDenormalizedWeight();
        uint256 balance = IBPool_Balancer_ZapIn_General_V1(
            _ToBalancerPoolAddress
        ).getBalance(_FromToken);
        uint256 denorm = IBPool_Balancer_ZapIn_General_V1(
            _ToBalancerPoolAddress
        ).getDenormalizedWeight(_FromToken);

        tokensReturned = IBPool_Balancer_ZapIn_General_V1(
            _ToBalancerPoolAddress
        ).calcPoolOutGivenSingleIn(
            balance,
            denorm,
            totalSupply,
            totalWeight,
            _IncomingERC,
            swapFee
        );
    }

    /**
    @notice This function is used to buy tokens from eth
    @param _tokenContractAddress Token address which we want to buy
    @return The quantity of token bought
     */
    function _eth2Token(address _tokenContractAddress)
        internal
        returns (uint256 tokenBought)
    {
        if(_tokenContractAddress == wethTokenAddress) {
            IWETH(wethTokenAddress).deposit.value(msg.value)();
            return msg.value;
        }

        Iuniswap_Balancer_ZapIn_General_V1 FromUniSwapExchangeContractAddress
        = Iuniswap_Balancer_ZapIn_General_V1(
            UniSwapFactoryAddress.getExchange(_tokenContractAddress)
        );

        uint256 minTokenBought = FromUniSwapExchangeContractAddress
            .getEthToTokenInputPrice(msg.value);
        minTokenBought = SafeMath.div(SafeMath.mul(minTokenBought, 98), 100);

        tokenBought = FromUniSwapExchangeContractAddress
            .ethToTokenSwapInput
            .value(msg.value)(minTokenBought, SafeMath.add(now, 1800));
    }

    /**
    @notice This function is used to swap tokens
    @param _FromTokenContractAddress The token address to swap from
    @param _ToTokenContractAddress The token address to swap to
    @param tokens2Trade The amount of tokens to swap
    @return The quantity of tokens bought
     */
    function _token2Token(
        address _FromTokenContractAddress,
        address _ToTokenContractAddress,
        uint256 tokens2Trade
    ) internal returns (uint256 tokenBought) {

        Iuniswap_Balancer_ZapIn_General_V1 FromUniSwapExchangeContractAddress
        = Iuniswap_Balancer_ZapIn_General_V1(
            UniSwapFactoryAddress.getExchange(_FromTokenContractAddress)
        );


        IERC20(_FromTokenContractAddress).approve(
            address(FromUniSwapExchangeContractAddress),
            tokens2Trade
        );

        tokenBought = FromUniSwapExchangeContractAddress.tokenToTokenSwapInput(
            tokens2Trade,
            1,
            1,
            SafeMath.add(now, 1800),
            _ToTokenContractAddress
        );
        require(tokenBought > 0, "Error in swapping ERC: 1");
    }


    function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
        require(
            _new_goodwill >= 0 && _new_goodwill < 10000,
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

    function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
        uint256 qty = _TokenAddress.balanceOf(address(this));
        _TokenAddress.transfer(owner(), qty);
    }

    // - to Pause the contract
    function toggleContractActive() public onlyOwner {
        stopped = !stopped;
    }

    // - to withdraw any ETH balance sitting in the contract
    function withdraw() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        address payable _to = owner().toPayable();
        _to.transfer(contractBalance);
    }

    // - to kill the contract
    function destruct() public onlyOwner {
        address payable _to = owner().toPayable();
        selfdestruct(_to);
    }

    function() external payable {}
}