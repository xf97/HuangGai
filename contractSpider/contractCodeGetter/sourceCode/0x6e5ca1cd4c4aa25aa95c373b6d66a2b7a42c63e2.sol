/**
 *Submitted for verification at Etherscan.io on 2020-06-18
*/

pragma solidity ^0.6.0;
// SPDX-License-Identifier: UNLICENSED;

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
        require(b <= a, "SafeMath: subtraction overflow");
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
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
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
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

interface ERC20 {
    function totalSupply() external view returns (uint supply);
    function balanceOf(address _owner) external view returns (uint balance);
    function transfer(address _to, uint _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    function decimals() external view returns(uint digits);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

interface IOneSplit {

    function getExpectedReturn(
        address fromToken,
        address toToken,
        uint256 amount,
        uint256 parts,
        uint256 disableFlags // 1 - Uniswap, 2 - Kyber, 4 - Bancor, 8 - Oasis, 16 - Compound, 32 - Fulcrum, 64 - Chai, 128 - Aave, 256 - SmartToken
    )
        external
        view
        returns(
            uint256 returnAmount,
            uint256[] memory distribution // [Uniswap, Kyber, Bancor, Oasis]
        );

    function swap(
        address fromToken,
        address toToken,
        uint256 amount,
        uint256 minReturn,
        uint256[] calldata distribution, // [Uniswap, Kyber, Bancor, Oasis]
        uint256 disableFlags // 16 - Compound, 32 - Fulcrum, 64 - Chai, 128 - Aave, 256 - SmartToken
    )
        external
        payable
        returns(uint256 returnAmount);

    function goodSwap(
        address fromToken,
        address toToken,
        uint256 amount,
        uint256 minReturn,
        uint256 parts,
        uint256 disableFlags // 1 - Uniswap, 2 - Kyber, 4 - Bancor, 8 - Oasis, 16 - Compound, 32 - Fulcrum, 64 - Chai, 128 - Aave, 256 - SmartToken
    )
        external
        payable;
}

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
        require(isOwner(), "caller must be the Contract Owner");
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
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     * @notice Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
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
        require(newOwner != address(0), "New Owner must not be empty.");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


contract OneInchArb is Ownable {
    
    //Interfaces
    IOneSplit internal OneSplit;
    ERC20 internal IFromToken;
    ERC20 internal IToToken;
    
    
    address payable public ONEINCH_ADDRESS;
    
    uint constant internal MAX_QTY   = (10**28);
    
    
    constructor(
        address payable _oneinch) public {
            ONEINCH_ADDRESS = _oneinch;
        }
    
    
    function updateOneinchAddress(address payable _address) onlyOwner public {
        ONEINCH_ADDRESS = _address;
    }
    
    function arb(address _fromToken ,address _toToken ,uint256 _amount, uint256 _minreturn,  uint256[] memory _distribution1,uint256[] memory _distribution2 ) onlyOwner public payable returns(uint256) {
 
        IFromToken = ERC20(_fromToken);
        IToToken = ERC20(_toToken);
        OneSplit = IOneSplit(ONEINCH_ADDRESS);
        
        if (IFromToken.allowance(address(this), ONEINCH_ADDRESS) < _amount)
        {
            IFromToken.approve(ONEINCH_ADDRESS, MAX_QTY);
        }
        
        if (IToToken.allowance(address(this), ONEINCH_ADDRESS) < _amount){
            IToToken.approve(ONEINCH_ADDRESS, MAX_QTY);
        }
        
        uint256 iGot = OneSplit.swap(_fromToken, _toToken, _amount,_minreturn, _distribution1, 0);
        
        uint256 iSell = OneSplit.swap(_toToken,_fromToken, iGot,_amount, _distribution2,0);
        
        require (_amount >= iSell);
        
        uint256 profit  = _amount - iSell;
        
        return profit;
        
    }
    
    
    function SendToken(address _token, uint256 _amount) onlyOwner public {
        if (_token != address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) )
        {
        IFromToken = ERC20(_token);
        IFromToken.transfer(msg.sender, IFromToken.balanceOf(address(this)));
        }
        if (_token == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) )
        {
            msg.sender.transfer(_amount);
        }
    }
    
}