pragma solidity ^0.6.0;

import "./ERC721.sol";
import "./Ownable.sol";
import "./StringUtils.sol";

contract OwnableDelegateProxy { }

contract ProxyRegistry {
    mapping(address => OwnableDelegateProxy) public proxies;
}

/**
 * @title ERC721 Non-Fungible Token Standard basic implementation
 * @dev see https://eips.ethereum.org/EIPS/eip-721
 */
contract Yeet is ERC721, Ownable {
    using StringUtils for string;
    uint256 private _currentTokenId = 0;
    address proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;

    constructor() ERC721("Your Ethereal Event Token", "YEET") public {

    }

    /**
    * @dev sets baseTokenURI
    * @param baseTokenURI new baseTokenURI
    */
    function setBaseURI(string memory baseTokenURI) public onlyOwner {
        _setBaseURI(baseTokenURI);
    }

    /**
    * @dev Mints a token to an address with a tokenURI.
    * @param _to address of the future owner of the token
    */
    function mintTo(address _to) public onlyOwner {
        uint256 newTokenId = _getNextTokenId();
        _mint(_to, newTokenId);
        _incrementTokenId();
    }

    /**
    * @dev calculates the next token ID based on value of _currentTokenId 
    * @return uint256 for the next token ID
    */
    function _getNextTokenId() private view returns (uint256) {
        return _currentTokenId.add(1);
    }

    /**
        * @dev increments the value of _currentTokenId 
        */
    function _incrementTokenId() private  {
        _currentTokenId++;
    }

    /**
   * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
   */
    function isApprovedForAll(
        address owner,
        address operator
    )
        override
        public
        view
        returns (bool)
    {
        // Whitelist OpenSea proxy contract for easy trading.
        ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
        if (address(proxyRegistry.proxies(owner)) == operator) {
            return true;
        }

        return super.isApprovedForAll(owner, operator);
    }
    
}