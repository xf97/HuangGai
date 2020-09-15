// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./Context.sol";
import "./SafeMath.sol";
import "./EnumerableMap.sol";
import "./EnumerableSet.sol";
import "./Address.sol";
import "./Strings.sol";

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    function transferFrom(address from, address to, uint256 tokenId) external;

    function approve(address to, uint256 tokenId) external;

    function getApproved(uint256 tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(address owner, address operator) external view returns (bool);

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

interface IERC721Metadata {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function tokenURI(uint256 tokenId) external view returns (string memory);
}

interface IERC721Enumerable {

    function totalSupply() external view returns (uint256);

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    function tokenByIndex(uint256 index) external view returns (uint256);
}

interface IEthArt721 {
    function getProxy() external view returns (address);
    function setProxy(address proxy) external;

    function mint(bytes calldata payload, string calldata tokenURI, uint256 tokenId, bool finalize, bytes calldata data) external payable returns(uint256);

    function content(uint256 tokenId, uint256 position) external view returns(bytes memory);

    function metadata(uint256 tokenId) external view returns(uint256, uint256, bool);

    event Finalized(uint256 indexed tokenId, uint256 chainSize);
}

contract EthArt721 is IEthArt721, IERC165, IERC721, IERC721Metadata, IERC721Enumerable, Context {
    using SafeMath for uint256;
    using Address for address;
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableMap for EnumerableMap.UintToAddressMap;
    using Strings for uint256;

    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    bytes32 private constant EMPTY_STRING = keccak256("");

    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;

    address private _proxy;

    mapping (address => EnumerableSet.UintSet) private _holderTokens;

    EnumerableMap.UintToAddressMap private _tokenOwners;

    mapping (uint256 => address) private _tokenApprovals;

    mapping (address => mapping (address => bool)) private _operatorApprovals;

    string private _name;

    string private _symbol;

    mapping (uint256 => string) private _tokenURIs;

    string private _baseURI;

    mapping(uint256 => bytes[]) private _chain;
    mapping(uint256 => bool) private _finalized;

    constructor (string memory name, string memory symbol, address proxy) public {
        _name = name;
        _symbol = symbol;
        setProxy(proxy);
    }

    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return
        interfaceId == _INTERFACE_ID_ERC165 ||
        interfaceId == _INTERFACE_ID_ERC721 ||
        interfaceId == _INTERFACE_ID_ERC721_METADATA ||
        interfaceId == _INTERFACE_ID_ERC721_ENUMERABLE;
    }

    function setProxy(address proxy) public override {
        require(_proxy == address(0) || IMVDFunctionalitiesManager(IMVDProxy(_proxy).getMVDFunctionalitiesManagerAddress()).isAuthorizedFunctionality(msg.sender), "Unauthorized action!");
        _proxy = proxy;
    }

    function getProxy() public override view returns (address) {
        return _proxy;
    }

    function balanceOf(address owner) public view override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _holderTokens[owner].length();
    }

    function ownerOf(uint256 tokenId) public view override returns (address) {
        return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];

        if (bytes(_baseURI).length == 0) {
            return _tokenURI;
        }
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(_baseURI, _tokenURI));
        }
        return string(abi.encodePacked(_baseURI, tokenId.toString()));
    }

    function baseURI() public view returns (string memory) {
        return _baseURI;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
        return _holderTokens[owner].at(index);
    }

    function totalSupply() public view override returns (uint256) {
        return _tokenOwners.length();
    }

    function tokenByIndex(uint256 index) public view override returns (uint256) {
        (uint256 tokenId, ) = _tokenOwners.at(index);
        return tokenId;
    }

    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");
        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );
        _approve(to, tokenId);
    }

    function getApproved(uint256 tokenId) public view override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != _msgSender(), "ERC721: approve to caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _tokenOwners.contains(tokenId);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    function mint(bytes memory payload, string memory tokenURI, uint256 tokenId, bool finalize, bytes memory data) public override payable returns(uint256 newTokenId) {
        uint256 length = totalSupply();
        require(tokenId == 0 || tokenId <= length, "Unexisting Token");
        newTokenId = tokenId == 0 ? length + 1 : tokenId;

        require(newTokenId == (length + 1) || ownerOf(newTokenId) == msg.sender, "Finalize or extend an already-finalized or an already-existing chain of someone else is forbidden");

        if(newTokenId == length + 1) {
            _mint(msg.sender, newTokenId, data);
            require(keccak256(bytes(tokenURI)) != keccak256(""), "tokenURI Cannot be empty!");
            _setTokenURI(newTokenId, tokenURI);
        }

        bool empty = keccak256(payload) == keccak256("");
        if(!empty) {
            require(!_finalized[newTokenId], "Cannot concatenate already finalized tokens");
            _chain[newTokenId].push(payload);
        }

        if(finalize || empty) {
            require(!_finalized[newTokenId], "Cannot Finalize already finalized tokens");
            _finalized[newTokenId] = true;
            emit Finalized(newTokenId, _chain[newTokenId].length);
        }

        if(msg.value > 0) {
            require(_proxy != address(0), "Cannot receive donations, proxy not set!");
            address payable wallet = payable(IStateHolder(IMVDProxy(_proxy).getStateHolderAddress()).getAddress("dfoHubWallet"));
            wallet.transfer(msg.value);
        }
    }

    function content(uint256 tokenId, uint256 position) public override view returns(bytes memory) {
        return _chain[tokenId][position];
    }

    function metadata(uint256 tokenId) public override view returns(uint256, uint256, bool) {
        return (_chain[tokenId].length, _chain[tokenId][0].length, _finalized[tokenId]);
    }

    function _mint(address to, uint256 tokenId, bytes memory _data) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _holderTokens[to].add(tokenId);

        _tokenOwners.set(tokenId, to);

        emit Transfer(address(0), to, tokenId);

        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function _burn(uint256 tokenId) internal virtual {
        address owner = ownerOf(tokenId);

        _approve(address(0), tokenId);

        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }

        _holderTokens[owner].remove(tokenId);

        _tokenOwners.remove(tokenId);

        emit Transfer(owner, address(0), tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _approve(address(0), tokenId);

        _holderTokens[from].remove(tokenId);
        _holderTokens[to].add(tokenId);

        _tokenOwners.set(tokenId, to);

        emit Transfer(from, to, tokenId);
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function _setBaseURI(string memory baseURI_) internal virtual {
        _baseURI = baseURI_;
    }

    function _approve(address to, uint256 tokenId) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) public returns (bool) {
        if (!_isContract(to)) {
            return true;
        }
        (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
            IERC721Receiver(to).onERC721Received.selector,
            _msgSender(),
            from,
            tokenId,
            _data
        ));
        if (!success) {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert("ERC721: transfer to non ERC721Receiver implementer");
            }
        } else {
            bytes4 retval = abi.decode(returndata, (bytes4));
            return (retval == _ERC721_RECEIVED);
        }
    }

    function _isContract(address account) private view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }
}

interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}

interface IMVDProxy {
    function getToken() external view returns(address);
    function getMVDFunctionalitiesManagerAddress() external view returns(address);
    function getStateHolderAddress() external view returns(address);
    function submit(string calldata codeName, bytes calldata data) external payable returns(bytes memory returnData);
}

interface IMVDFunctionalitiesManager {
    function isAuthorizedFunctionality(address functionality) external view returns(bool);
}

interface IStateHolder {
    function exists(string calldata varName) external view returns(bool);
    function clear(string calldata varName) external returns(string memory oldDataType, bytes memory oldVal);
    function setBytes(string calldata varName, bytes calldata val) external returns(bytes memory);
    function getBytes(string calldata varName) external view returns(bytes memory);
    function setString(string calldata varName, string calldata val) external returns(string memory);
    function getString(string calldata varName) external view returns (string memory);
    function setBool(string calldata varName, bool val) external returns(bool);
    function getBool(string calldata varName) external view returns (bool);
    function getUint256(string calldata varName) external view returns (uint256);
    function setUint256(string calldata varName, uint256 val) external returns(uint256);
    function getAddress(string calldata varName) external view returns (address);
    function setAddress(string calldata varName, address val) external returns (address);
}

interface IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
}