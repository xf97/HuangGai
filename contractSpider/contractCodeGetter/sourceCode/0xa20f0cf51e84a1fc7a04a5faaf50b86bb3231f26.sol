/**
 *Submitted for verification at Etherscan.io on 2020-07-09
*/

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
 */
contract ReentrancyGuard {
    // counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
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
}

// File: contracts/marketplace/interfaces/IPosition.sol

pragma solidity 0.5.10;

interface IPosition {
    event PositionCreated(
        address indexed position,
        address indexed seller,
        uint256 indexed tokenId,
        uint256 price,
        address tokenAddress,
        address marketPlaceAddress,
        uint256 timestamp
    );

    event PositionBought(
        address indexed position,
        address indexed seller,
        uint256 indexed tokenId,
        uint256 tokenAddress,
        uint256 price,
        address buyer,
        uint256 mktFee,
        uint256 sellerProfit,
        uint256 timestamp
    );

    function init(
        address payable _seller,
        uint256 _MPFee,
        uint256 _price,
        address _tokenAddress,
        uint256 _tokenId,
        address payable _marketPlaceAddress
    ) external returns (bool);

    function isTemplateContract() external view returns (bool);

    function buyPosition() external payable;
}

// File: contracts/marketplace/library/Wrapper721.sol

pragma solidity 0.5.10;

interface I721Kitty {
    function ownerOf(uint256 _tokenId) external view returns (address owner);
    function transfer(address _to, uint256 _tokenId) external;
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    function kittyIndexToApproved(uint256 tokenId) external view returns (address owner);
    // mapping(uint256 => address) public kittyIndexToApproved;
}

interface I721 {
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
}

interface I721Meta {
    function symbol() external view returns (string memory);
}
library Wrapper721 {
    function safeTransferFrom(address _token, address _from, address _to, uint256 _tokenId)
        external
    {
        if (isIssuedToken(_token)) {
            I721Kitty(_token).transferFrom(_from, _to, _tokenId);
        } else {
            I721(_token).safeTransferFrom(_from, _to, _tokenId);
        }

    }
    function getApproved(address _token, uint256 _tokenId) external view returns (address) {
        if (isIssuedToken(_token)) {
            return I721Kitty(_token).kittyIndexToApproved(_tokenId);
        } else {
            return I721(_token).getApproved(_tokenId);
        }
    }
    function ownerOf(address _token, uint256 _tokenId) public view returns (address owner) {
        if (isIssuedToken(_token)) {
            return I721Kitty(_token).ownerOf(_tokenId);
        } else {
            return I721(_token).ownerOf(_tokenId);
        }
    }
    function isIssuedToken(address _token) private view returns (bool) {
        return (keccak256(abi.encodePacked((I721Meta(_token).symbol()))) ==
            keccak256(abi.encodePacked(("CK"))));
    }

}

// File: contracts/marketplace/Position.sol

pragma solidity 0.5.10;





contract Position is IPosition, ReentrancyGuard {
    using SafeMath for uint256;

    address public token721;
    bool private isTemplate;

    uint256 public positionCreated;
    uint256 public price;
    uint256 public MPFee;
    uint256 public positionFee;

    address payable public seller;
    address payable public marketPlaceAddress;
    address public tokenAddress;
    uint256 public tokenId;

    uint256 constant ONE_HUNDRED = 100e18;

    event PositionCreated(
        address indexed position,
        address indexed seller,
        uint256 indexed tokenId,
        uint256 price,
        address tokenAddress,
        address marketPlaceAddress,
        uint256 timestamp
    );

    event PositionBought(
        address indexed position,
        address indexed seller,
        uint256 indexed tokenId,
        address tokenAddress,
        uint256 price,
        address buyer,
        uint256 mktFee,
        uint256 sellerProfit,
        uint256 timestamp
    );

    modifier notTemplate() {
        require(isTemplate == false, "you cant call template contract");
        _;
    }

    constructor() public {
        isTemplate = true;
    }

    function init(
        address payable _seller,
        uint256 _MPFee,
        uint256 _price,
        address _tokenAddress,
        uint256 _tokenId,
        address payable _marketPlaceAddress
    ) external notTemplate returns (bool) {
        positionCreated = block.timestamp;

        seller = _seller;
        MPFee = _MPFee;
        price = _price;
        tokenAddress = _tokenAddress;
        tokenId = _tokenId;

        marketPlaceAddress = _marketPlaceAddress;

        token721 = tokenAddress;

        emit PositionCreated(
            address(this),
            seller,
            tokenId,
            price,
            tokenAddress,
            marketPlaceAddress,
            block.timestamp
        );

        return true;
    }

    function isTemplateContract() external view returns (bool) {
        return isTemplate;
    }

    function buyPosition() external payable nonReentrant notTemplate {
        address approved = Wrapper721.getApproved(token721, tokenId);
        require(approved == address(this), "This contract is not approved to use this token");
        require(address(msg.sender).balance >= price, "Buyer does not have enought money");
        require(msg.value >= price, "The value sent is smaller than price");
        uint256 mktFee = price.mul(MPFee).div(ONE_HUNDRED);
        uint256 sellerProfit = price.sub(mktFee);

        seller.transfer(sellerProfit);

        marketPlaceAddress.transfer(mktFee);

        Wrapper721.safeTransferFrom(token721, seller, msg.sender, tokenId);

        emit PositionBought(
            address(this),
            seller,
            tokenId,
            tokenAddress,
            price,
            msg.sender,
            mktFee,
            sellerProfit,
            block.timestamp
        );
    }
}