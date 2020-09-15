/**
 *Submitted for verification at Etherscan.io on 2020-07-09
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

// File: contracts/marketplace/interfaces/IPositionDispatcher.sol

pragma solidity 0.5.10;

interface IPositionDispatcher {
    event PositionDispatcherCreated(
        address indexed positionDispatcher,
        uint256 timestamp,
        address mpAddress,
        uint256 mpFee
    );
    event UpdateMPFee(address indexed positionDispatcher, uint256 newFee);
    event PositionOpened(
        address indexed positionDispatcher,
        address indexed newPosition,
        uint256 timestamp,
        address seller,
        address tokenAddress,
        uint256 tokenId,
        address marketPlaceAddress,
        uint256 price
    );
    event UpdateMPAddress(address indexed positionDispatcher, address mkpAddress);
    event UpdatedPositionContract(address indexed positionDispatcher, address positionContract);

    function updateMarketPlaceAddress(address payable newMarketPlaceAddress) external;

    function updateMPFee(uint256 newFee) external;

    function setPositionTemplate(address newPositionTemplate) external;

    function createPosition(
        uint256 price,
        address tokenAddress,
        uint256 tokenId
    ) external returns (address);

    function isAddressAPosition(address positionAddress) external view returns (bool);

    function isCloned(address target, address query) external view returns (bool result);
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

// File: contracts/marketplace/CloneFactory.sol

pragma solidity 0.5.10;

/*
The MIT License (MIT)
Copyright (c) 2018 Murray Software, LLC.
Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
//solhint-disable max-line-length
//solhint-disable no-inline-assembly

contract CloneFactory {
    function createClone(address target) internal returns (address result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )
            result := create(0, clone, 0x37)
        }
    }

    function isClone(address target, address query) internal view returns (bool result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)
            mstore(add(clone, 0xa), targetBytes)
            mstore(
                add(clone, 0x1e),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )

            let other := add(clone, 0x40)
            extcodecopy(query, other, 0, 0x2d)
            result := and(
                eq(mload(clone), mload(other)),
                eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))
            )
        }
    }
}

// File: contracts/marketplace/PositionDispatcher.sol

pragma solidity 0.5.10;






contract PositionDispatcher is IPositionDispatcher, CloneFactory, Ownable {
    uint256 public contractCreated;
    uint256 public MPFee;

    address payable public marketPlaceAddress;
    address public positionTemplate;

    mapping(address => bool) public isPosition;

    event PositionDispatcherCreated(
        address indexed positionDispatcher,
        uint256 timestamp,
        address mpAddress,
        uint256 mpFee
    );
    event UpdateMPFee(address indexed positionDispatcher, uint256 newFee);
    event PositionOpened(
        address indexed positionDispatcher,
        address indexed newPosition,
        uint256 timestamp,
        address seller,
        address tokenAddress,
        uint256 tokenId,
        address marketPlaceAddress,
        uint256 price
    );
    event UpdateMPAddress(address indexed positionDispatcher, address mkpAddress);
    event UpdatedPositionContract(address indexed positionDispatcher, address positionContract);

    constructor() public {
        contractCreated = block.timestamp;
        marketPlaceAddress = 0x4f86A75764710683DAC3833dF49c72de3ec65465;
        MPFee = 1e18;
        emit PositionDispatcherCreated(address(this), block.timestamp, marketPlaceAddress, MPFee);
    }

    function updateMarketPlaceAddress(address payable newMarketPlaceAddress) external onlyOwner {
        marketPlaceAddress = newMarketPlaceAddress;
        emit UpdateMPAddress(address(this), marketPlaceAddress);
    }

    function updateMPFee(uint256 newFee) external onlyOwner {
        MPFee = newFee;
        emit UpdateMPFee(address(this), newFee);
    }

    function setPositionTemplate(address newPositionTemplate) external onlyOwner {
        positionTemplate = newPositionTemplate;
        emit UpdatedPositionContract(address(this), positionTemplate);
    }

    function createPosition(
        uint256 price,
        address tokenAddress,
        uint256 tokenId
    ) external returns (address) {
        require(
            sellerIsTokenOwner(msg.sender, tokenAddress, tokenId),
            "Seller is not the token owner"
        );

        require(positionTemplate != address(0), "position contract needs to be set");

        address positionContract = createClone((positionTemplate));

        require(
            IPosition(positionContract).init(
                msg.sender,
                MPFee,
                price,
                tokenAddress,
                tokenId,
                marketPlaceAddress
            ),
            "Failed to init position"
        );

        isPosition[positionContract] = true;

        emit PositionOpened(
            address(this),
            positionContract,
            block.timestamp,
            msg.sender,
            tokenAddress,
            tokenId,
            marketPlaceAddress,
            price
        );

        return positionContract;
    }

    function isAddressAPosition(address positionAddress) external view returns (bool) {
        return isPosition[positionAddress];
    }

    function sellerIsTokenOwner(
        address seller,
        address tokenAddress,
        uint256 tokenId
    ) internal view returns (bool) {
        address tokenOwner = Wrapper721.ownerOf(tokenAddress, tokenId);
        return tokenOwner == seller;
    }

    function isCloned(address target, address query) external view returns (bool result) {
        return isClone(target, query);
    }
}