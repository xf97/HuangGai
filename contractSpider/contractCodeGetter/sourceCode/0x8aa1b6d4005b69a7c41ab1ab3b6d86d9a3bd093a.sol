/**
 *Submitted for verification at Etherscan.io on 2020-06-17
*/

// SPDX-License-Identifier: MIT

/* ETHART - A DFO-based ERC721
 * A ERC-721 standard Non Fungible Tokens implementation that exploits all the power of DFO
 * DFOBased721 Smart Contract is a wrapper that lets third-party applications (e.g. OpenSea, Cryptovoxels, etc.) easily interface and interact with NFTs
 * In fact, all standard ERC721 methods called in this Contract are totally redirected to the ethArt DFO which really stores and manages real data through its Microservices.
 * Advantages
 * 1. Flexibility: The community can directly manage it to solve protocol bugs or add features.
 * 2. Extension: If, for any reason in the future, a new NFT standard will come out, this wrapper can be changed to accept new capabilities without the need to migrate any single byte of data.
 * 3. Perpetual Storage: To avoid classical ERC721 censorship problems, NFTs made with this Dapp can be also stored on-chain, to keep them always available in any circumstances.
 * 4. Triple interaction: You can use it passing through this wrapper, the DFOHub portal or the ethArt web Application. They retrieve and set data from/to the same source.
*/
pragma solidity ^0.6.0;

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

interface IDFOBased721 {
    function getProxy() external view returns (address);
    function setProxy(address proxy) external;
    function raiseTransferEvent(address from, address to, uint256 tokenId) external;
    function raiseApprovalEvent(address subject, address operator, bool forAll, bool approved, uint256 tokenId) external;
    function checkOnERC721Received(address subject, address from, address to, uint256 tokenId, bytes calldata _data) external returns (bool);
}

contract DFOBased721 is IDFOBased721, IERC165, IERC721, IERC721Metadata, IERC721Enumerable {

    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    bytes32 private constant EMPTY_STRING = keccak256("");

    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;

    address private _proxy;

    constructor(address proxy) public {
        setProxy(proxy);
    }

    modifier authorizedOnly {
        require(IMVDFunctionalitiesManager(IMVDProxy(_proxy).getMVDFunctionalitiesManagerAddress()).isAuthorizedFunctionality(msg.sender), "Unauthorized Access!");
        _;
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

    function name() public override view returns(string memory) {
        return IERC20(IMVDProxy(_proxy).getToken()).name();
    }

    function symbol() public override view returns(string memory) {
        return IERC20(IMVDProxy(_proxy).getToken()).symbol();
    }

    function tokenURI(uint256 tokenId) public override view returns (string memory) {
        IStateHolder stateHolder = IStateHolder(IMVDProxy(_proxy).getStateHolderAddress());
        return stateHolder.getString(_stringConcat(_toString(stateHolder.exists(_stringConcat(_toString(tokenId), "parent", "")) ? stateHolder.getUint256(_stringConcat(_toString(tokenId), "parent", "")) : tokenId), "", ""));
    }

    function totalSupply() public override view returns (uint256) {
        return IStateHolder(IMVDProxy(_proxy).getStateHolderAddress()).getUint256("totalSupply");
    }

    function balanceOf(address owner) public override view returns (uint256) {
        return IStateHolder(IMVDProxy(_proxy).getStateHolderAddress()).getUint256(_stringConcat(_toString(owner), "balance", ""));
    }

    function ownerOf(uint256 tokenId) public override view returns (address) {
        return IStateHolder(IMVDProxy(_proxy).getStateHolderAddress()).getAddress(_stringConcat(_toString(tokenId), "owner", ""));
    }

    function getApproved(uint256 tokenId) public override view returns (address) {
        return IStateHolder(IMVDProxy(_proxy).getStateHolderAddress()).getAddress(_stringConcat(_toString(ownerOf(tokenId)), "approved", _toString(tokenId)));
    }

    function isApprovedForAll(address owner, address operator) public override view returns (bool) {
        return IStateHolder(IMVDProxy(_proxy).getStateHolderAddress()).getBool(_stringConcat(_toString(owner), "approved", _toString(operator)));
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public override view returns (uint256) {
        return IStateHolder(IMVDProxy(_proxy).getStateHolderAddress()).getUint256(_stringConcat(_toString(owner), _toString(index), ""));
    }

    function tokenByIndex(uint256 index) public override view returns (uint256) {
        if(index + 1 >= IStateHolder(IMVDProxy(_proxy).getStateHolderAddress()).getUint256("nextId")) {
            return 0;
        }
        return index + 1;
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override {
        IMVDProxy(_proxy).submit('transfer', abi.encode(address(0), 0, msg.sender, from, to, tokenId, true, data));
    }

    function transferFrom(address from, address to, uint256 tokenId) public override {
        IMVDProxy(_proxy).submit('transfer', abi.encode(address(0), 0, msg.sender, from, to, tokenId, false, ""));
    }

    function approve(address operator, uint256 tokenId) public override {
        IMVDProxy(_proxy).submit('approve', abi.encode(address(0), 0, msg.sender, operator, false, false, tokenId));
    }

    function setApprovalForAll(address operator, bool _approved) public override {
        IMVDProxy(_proxy).submit('approve', abi.encode(address(0), 0, msg.sender, operator, true, _approved, 0));
    }

    function raiseTransferEvent(address from, address to, uint256 tokenId) public override authorizedOnly {
        emit Transfer(from, to, tokenId);
    }

    function raiseApprovalEvent(address subject, address operator, bool forAll, bool approved, uint256 tokenId) public override authorizedOnly {
        if(forAll) {
            emit ApprovalForAll(subject, operator, approved);
        } else {
            emit Approval(subject, operator, tokenId);
        }
    }

    function checkOnERC721Received(address subject, address from, address to, uint256 tokenId, bytes memory _data) public override authorizedOnly returns (bool) {
        if (!_isContract(to)) {
            return true;
        }
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
            IERC721Receiver(to).onERC721Received.selector,
            subject,
            from,
            tokenId,
            _data
        ));
        if (!success) {
            if (returndata.length > 0) {
                // solhint-disable-next-line no-inline-assembly
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
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    function _stringConcat(string memory a, string memory b, string memory c) private pure returns(string memory) {
        bool aEmpty = _isEmpty(a);
        bool bEmpty = _isEmpty(b);
        bool cEmpty = _isEmpty(c);
        return _toLowerCase(string(abi.encodePacked(
            a,
            aEmpty || bEmpty ? "" : "_",
            b,
            (aEmpty && bEmpty) || cEmpty ? "" : "_",
            c
        )));
    }

    function _isEmpty(string memory test) private pure returns(bool) {
        return keccak256(bytes(test)) == EMPTY_STRING;
    }

    function _toString(address _addr) private pure returns(string memory) {
        bytes32 value = bytes32(uint256(_addr));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
        }
        return string(str);
    }

    function _toString(uint _i) private pure returns(string memory) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

    function _toLowerCase(string memory str) private pure returns(string memory) {
        bytes memory bStr = bytes(str);
        for (uint i = 0; i < bStr.length; i++) {
            bStr[i] = bStr[i] >= 0x41 && bStr[i] <= 0x5A ? bytes1(uint8(bStr[i]) + 0x20) : bStr[i];
        }
        return string(bStr);
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