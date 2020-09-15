/**
 *Submitted for verification at Etherscan.io on 2020-07-08
*/

pragma solidity ^0.6.0;

contract VasaPowerSwitch {

    uint256 private _totalMintable;
    uint256[] private _timeWindows;
    uint256[][] private _multipliers;

    address private _proxy;

    address private _oldTokenAddress;

    uint256 private _startBlock;

    constructor(address proxyAddress, address oldTokenAddress, uint256 startBlock, uint256 totalMintable, uint256[] memory timeWindows, uint256[] memory multipliers, uint256[] memory dividers) public {
        _startBlock = startBlock;
        _proxy = proxyAddress;
        _oldTokenAddress = oldTokenAddress;
        _totalMintable = totalMintable;
        _timeWindows = timeWindows;
        assert(timeWindows.length == multipliers.length && multipliers.length == dividers.length);
        for(uint256 i = 0; i < multipliers.length; i++) {
            _multipliers.push([multipliers[i], dividers[i]]);
        }
    }

    function totalMintable() public view returns(uint256) {
        return block.number > _timeWindows[_timeWindows.length - 1] ? 0 :_totalMintable;
    }

    function startBlock() public view returns(uint256) {
        return _startBlock;
    }

    function proxy() public view returns(address) {
        return _proxy;
    }

    function setProxy(address newProxy) public {
        require(IMVDFunctionalitiesManager(IMVDProxy(_proxy).getMVDFunctionalitiesManagerAddress()).isAuthorizedFunctionality(msg.sender), "Unauthorized Action!");
        _proxy = newProxy;
    }

    function calculateMintable(uint256 amount) public view returns(uint256) {
        if(amount == 0 || block.number > _timeWindows[_timeWindows.length - 1]) {
            return 0;
        }
        uint256 i = 0;
        for(i; i < _timeWindows.length; i++) {
            if(block.number <= _timeWindows[i]) {
                break;
            }
        }
        uint256 mintable = i >= _timeWindows.length ? 0 : ((amount * _multipliers[i][0]) / _multipliers[i][1]);
        return mintable > _totalMintable ? _totalMintable : mintable;
    }

    function length() public view returns(uint256) {
        return _timeWindows.length;
    }

    function timeWindow(uint256 i) public view returns(uint256, uint256, uint256) {
        return (_timeWindows[i], _multipliers[i][0], _multipliers[i][1]);
    }

    function getContextInfo(uint256 amount) public view returns (uint256 timeWindow, uint256 multiplier, uint256 divider, uint256 mintable) {
        if(amount == 0 || block.number > _timeWindows[_timeWindows.length - 1]) {
            return (0, 0, 0, 0);
        }
        uint256 i = 0;
        for(i; i < _timeWindows.length; i++) {
            if(block.number <= _timeWindows[i]) {
                break;
            }
        }
        if(i < _timeWindows.length) {
            timeWindow = _timeWindows[i];
            multiplier = _multipliers[i][0];
            divider = _multipliers[i][1];
        }
        mintable = i >= _timeWindows.length ? 0 : ((amount * multiplier) / divider);
        mintable = mintable > _totalMintable ? _totalMintable : mintable;
    }

    function vasaPowerSwitch(uint256 senderBalanceOf) public {
        require(block.number >= _startBlock, "Switch still not started!");

        IERC20 oldToken = IERC20(_oldTokenAddress);

        uint256 mintableAmount = calculateMintable(senderBalanceOf);
        require(mintableAmount > 0, "Zero tokens to mint!");

        oldToken.transferFrom(msg.sender, address(this), senderBalanceOf);
        oldToken.burn(senderBalanceOf);
        _totalMintable -= senderBalanceOf;
        IMVDProxy(_proxy).submit("mintAndTransfer", abi.encode(address(0), 0, mintableAmount, msg.sender));
    }
}

interface IMVDProxy {
    function getMVDFunctionalitiesManagerAddress() external view returns(address);
    function submit(string calldata codeName, bytes calldata data) external payable returns(bytes memory returnData);
}

interface IMVDFunctionalitiesManager {
    function isAuthorizedFunctionality(address functionality) external view returns(bool);
}

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function burn(uint256 amount) external;
}