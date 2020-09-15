/**
 *Submitted for verification at Etherscan.io on 2020-05-01
*/

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

// File: contracts/Not_upgradable_done/MultiPoolZapV1_4.sol

// Copyright (C) 2019, 2020 dipeshsukhani, nodar, suhailg, apoorvlathey

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




pragma solidity ^0.5.0;

interface UniswapFactoryInterface {
    function getExchange(address token) external view returns (address exchange);
}

interface UniswapExchangeInterface {
    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
}

interface uniswapPoolZap {
    function LetsInvest(address _TokenContractAddress, address _towhomtoissue) external payable returns (uint256);
}

/**
    @title Multiple Pool Zap
    @author Zapper
    @notice Use this contract to Add liquidity to Multiple Uniswap Pools at once using ETH or ERC20
*/
contract MultiPoolZapV1_4 is Ownable {
    using SafeMath for uint;

    uniswapPoolZap public uniswapPoolZapAddress;
    UniswapFactoryInterface public UniswapFactory;
    uint16 public goodwill;
    address payable public dzgoodwillAddress;
    mapping(address => uint256) private userBalance;

    constructor(uint16 _goodwill, address payable _dzgoodwillAddress) public {
        goodwill = _goodwill;
        dzgoodwillAddress = _dzgoodwillAddress;
        uniswapPoolZapAddress = uniswapPoolZap(0x97402249515994Cc0D22092D3375033Ad0ea438A);
        UniswapFactory = UniswapFactoryInterface(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);
    }

    function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
        require(
            _new_goodwill > 0 && _new_goodwill < 10000,
            "GoodWill Value not allowed"
        );
        goodwill = _new_goodwill;
    }

    function set_new_dzgoodwillAddress(address payable _new_dzgoodwillAddress)
        public
        onlyOwner
    {
        dzgoodwillAddress = _new_dzgoodwillAddress;
    }

    function set_uniswapPoolZapAddress(address _uniswapPoolZapAddress) onlyOwner public {
        uniswapPoolZapAddress = uniswapPoolZap(_uniswapPoolZapAddress);
    }

    function set_UniswapFactory(address _UniswapFactory) onlyOwner public {
        UniswapFactory = UniswapFactoryInterface(_UniswapFactory);
    }

    /**
        @notice Add liquidity to Multiple Uniswap Pools at once using ETH or ERC20
        @param _IncomingTokenContractAddress The token address for ERC20 being deposited. Input address(0) in case of ETH deposit.
        @param _IncomingTokenQty Quantity of ERC20 being deposited. 0 in case of ETH deposit.
        @param underlyingTokenAddresses Array of Token Addresses to which's Uniswap Pool to add liquidity to.
        @param respectiveWeightedValues Array of Relative Ratios (corresponding to underlyingTokenAddresses) to proportionally distribute received ETH or ERC20 into various pools.
    */
    function multipleZapIn(address _IncomingTokenContractAddress, uint256 _IncomingTokenQty, address[] memory underlyingTokenAddresses, uint256[] memory respectiveWeightedValues) public payable {

        uint totalWeights;
        require(underlyingTokenAddresses.length == respectiveWeightedValues.length);
        for(uint i=0;i<underlyingTokenAddresses.length;i++) {
            totalWeights = (totalWeights).add(respectiveWeightedValues[i]);
        }

        uint256 eth2Trade;

        if (msg.value > 0) {
            require (_IncomingTokenContractAddress == address(0), "Incoming token address should be address(0)");
            eth2Trade = msg.value;
        } else if(_IncomingTokenContractAddress == address(0) && msg.value == 0) {
            revert("Please send ETH along with function call");
        } else if(_IncomingTokenContractAddress != address(0)) {
            require(msg.value == 0, "Cannot send Tokens and ETH at the same time");
            require(
                IERC20(_IncomingTokenContractAddress).transferFrom(
                    msg.sender,
                    address(this),
                    _IncomingTokenQty
                ),
                "Error in transferring ERC20"
            );
            eth2Trade = _token2Eth(
              _IncomingTokenContractAddress,
              _IncomingTokenQty,
              address(this)
            );
        }

        uint goodwillPortion = ((eth2Trade).mul(goodwill)).div(10000);
        uint totalInvestable = (eth2Trade).sub(goodwillPortion);
        uint totalLeftToBeInvested = totalInvestable;

        require(address(dzgoodwillAddress).send(goodwillPortion));

        uint residualETH;
        for (uint i=0;i<underlyingTokenAddresses.length;i++) {
            uint LPT = uniswapPoolZapAddress.LetsInvest.value((((totalInvestable).mul(respectiveWeightedValues[i])).div(totalWeights)+residualETH))(underlyingTokenAddresses[i], address(this));
            IERC20(UniswapFactory.getExchange(address(underlyingTokenAddresses[i]))).transfer(msg.sender, LPT);
            totalLeftToBeInvested = (totalLeftToBeInvested).sub(((totalInvestable).mul(respectiveWeightedValues[i])).div(totalWeights));
            residualETH = (address(this).balance).sub(totalLeftToBeInvested);
        }

        if(address(this).balance >= 250000000000000000){
            totalInvestable = address(this).balance;
            totalLeftToBeInvested = totalInvestable;
            residualETH = 0;
            for (uint i=0;i<underlyingTokenAddresses.length;i++) {
                uint LPT = uniswapPoolZapAddress.LetsInvest.value((((totalInvestable).mul(respectiveWeightedValues[i])).div(totalWeights)+residualETH))(underlyingTokenAddresses[i], address(this));
                IERC20(UniswapFactory.getExchange(address(underlyingTokenAddresses[i]))).transfer(msg.sender, LPT);
                totalLeftToBeInvested = (totalLeftToBeInvested).sub(((totalInvestable).mul(respectiveWeightedValues[i])).div(totalWeights));
                residualETH = (address(this).balance).sub(totalLeftToBeInvested);
            }
        }

        userBalance[msg.sender] = address(this).balance;
        require (send_out_eth(msg.sender));
    }

    /**
        @notice This function swaps ERC20 to ERC20 via Uniswap
        @param _FromTokenContractAddress Address of Token to swap
        @param tokens2Trade The quantity of tokens to swap
        @param _toWhomToIssue Address of user to send the swapped ETH to
        @return The amount of ETH Received.
    */
    function _token2Eth(
        address _FromTokenContractAddress,
        uint256 tokens2Trade,
        address _toWhomToIssue
    ) internal returns (uint256 ethBought) {

            UniswapExchangeInterface FromUniSwapExchangeContractAddress
         = UniswapExchangeInterface(
            UniswapFactory.getExchange(_FromTokenContractAddress)
        );

        IERC20(_FromTokenContractAddress).approve(
            address(FromUniSwapExchangeContractAddress),
            tokens2Trade
        );

        ethBought = FromUniSwapExchangeContractAddress.tokenToEthTransferInput(
            tokens2Trade,
            ((FromUniSwapExchangeContractAddress.getTokenToEthInputPrice(tokens2Trade)).mul(99).div(100)),
            SafeMath.add(block.timestamp, 300),
            _toWhomToIssue
        );
        require(ethBought > 0, "Error in swapping Eth: 1");
    }

    /**
        @notice This function sends the user's remaining ETH back to them.
        @param _towhomtosendtheETH The Address of the user
        @return Boolean corresponding to successful execution.
    */
    function send_out_eth(address _towhomtosendtheETH) internal returns (bool) {
        require(userBalance[_towhomtosendtheETH] > 0);
        uint256 amount = userBalance[_towhomtosendtheETH];
        userBalance[_towhomtosendtheETH] = 0;
        (bool success, ) = _towhomtosendtheETH.call.value(amount)("");
        return success;
    }

    // - fallback function let you / anyone send ETH to this wallet without the need to call any function
    function() external payable {
    }
}