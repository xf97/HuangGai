pragma solidity ^0.6.0;

import "./IMVDWallet.sol";
import "./IMVDProxy.sol";
import "./IERC20.sol";
import "./IERC721.sol";
import "./IERC721Receiver.sol";

contract MVDWallet is IMVDWallet, IERC721Receiver {

    address private _proxy;
    address payable private _newWallet;

    function setNewWallet(address payable newWallet, address tokenAddress) public override {
        require(msg.sender == _proxy, "Unauthorized Access!");
        _newWallet = newWallet;
        _newWallet.transfer(address(this).balance);
        IERC20 token = IERC20(tokenAddress);
        token.transfer(_newWallet, token.balanceOf(address(this)));
    }

    function flushToNewWallet(address tokenAddress) public override {
        require(_newWallet != address(0), "Unauthorized Access!");
        if(tokenAddress == address(0)) {
            payable(_newWallet).transfer(address(this).balance);
            return;
        }
        IERC20 token = IERC20(tokenAddress);
        token.transfer(_newWallet, token.balanceOf(address(this)));
    }

    function flush721ToNewWallet(uint256 tokenId, bytes memory data, bool safe, address tokenAddress) public override {
        require(_newWallet != address(0), "Unauthorized Access!");
        _transfer(_newWallet, tokenId, data, safe, tokenAddress);
    }

    function transfer(address receiver, uint256 value, address token) public override {
        require(msg.sender == _proxy, "Unauthorized Access!");
        if(value == 0) {
            return;
        }
        if(token == address(0)) {
            payable(receiver).transfer(value);
            return;
        }
        IERC20(token).transfer(receiver, value);
    }

    function transfer(address receiver, uint256 tokenId, bytes memory data, bool safe, address token) public override {
        require(msg.sender == _proxy, "Unauthorized Access!");
        _transfer(receiver, tokenId, data, safe, token);
    }

    function _transfer(address receiver, uint256 tokenId, bytes memory data, bool safe, address token) private {
        if(safe) {
            IERC721(token).safeTransferFrom(address(this), receiver, tokenId, data);
        } else {
            IERC721(token).transferFrom(address(this), receiver, tokenId);
        }
    }

    receive() external payable {
        if(_newWallet != address(0)) {
            _newWallet.transfer(address(this).balance);
        }
    }

    function getProxy() public override view returns(address) {
        return _proxy;
    }

    function setProxy() public override {
        require(_proxy == address(0) || _proxy == msg.sender, _proxy != address(0) ? "Proxy already set!" : "Only Proxy can toggle itself!");
        _proxy = _proxy == address(0) ?  msg.sender : address(0);
    }

    function onERC721Received(address, address, uint256 tokenId, bytes memory data) public override returns (bytes4) {
        if(_newWallet != address(0)) {
            _transfer(_newWallet, tokenId, data, true, msg.sender);
        }
        return 0x150b7a02;
    }
}