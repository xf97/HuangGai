/**
 *Submitted for verification at Etherscan.io on 2020-05-04
*/

pragma solidity ^0.6.0;


interface TokenInterface {
    function approve(address, uint) external;
    function transfer(address, uint) external;
    function transferFrom(address, address, uint) external;
    function deposit() external payable;
    function withdraw(uint) external;
    function balanceOf(address) external view returns (uint);
    function decimals() external view returns (uint);
}

interface MemoryInterface {
    function getUint(uint id) external returns (uint num);
    function setUint(uint id, uint val) external;
}

interface EventInterface {
    function emitEvent(uint connectorType, uint connectorID, bytes32 eventCode, bytes calldata eventData) external;
}

contract Stores {

    /**
     * @dev Return ethereum address
     */
    function getEthAddr() internal pure returns (address) {
        return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; // ETH Address
    }

    /**
     * @dev Return memory variable address
     */
    function getMemoryAddr() internal pure returns (address) {
        return 0x8a5419CfC711B2343c17a6ABf4B2bAFaBb06957F; // InstaMemory Address
    }

    /**
     * @dev Return InstaEvent Address.
     */
    function getEventAddr() internal pure returns (address) {
        return 0x2af7ea6Cb911035f3eb1ED895Cb6692C39ecbA97; // InstaEvent Address
    }

    /**
     * @dev Get Uint value from InstaMemory Contract.
     */
    function getUint(uint getId, uint val) internal returns (uint returnVal) {
        returnVal = getId == 0 ? val : MemoryInterface(getMemoryAddr()).getUint(getId);
    }

    /**
     * @dev Set Uint value in InstaMemory Contract.
     */
    function setUint(uint setId, uint val) internal {
        if (setId != 0) MemoryInterface(getMemoryAddr()).setUint(setId, val);
    }

    /**
     * @dev emit event on event contract
     */
    function emitEvent(bytes32 eventCode, bytes memory eventData) internal {
        (uint model, uint id) = connectorID();
        EventInterface(getEventAddr()).emitEvent(model, id, eventCode, eventData);
    }

    /**
     * @dev Connector Details.
     */
    function connectorID() public pure returns(uint model, uint id) {
        (model, id) = (1, 13);
    }

}

contract DSMath {
    uint constant WAD = 10 ** 18;
    uint constant RAY = 10 ** 27;

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "math-not-safe");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "math-not-safe");
    }


    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, RAY), y / 2) / y;
    }

    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }

}

interface KyberInterface {
    function trade(
        address src,
        uint srcAmount,
        address dest,
        address destAddress,
        uint maxDestAmount,
        uint minConversionRate,
        address walletId
    ) external payable returns (uint);

    function getExpectedRate(
        address src,
        address dest,
        uint srcQty
    ) external view returns (uint, uint);
}

contract KyberHelpers is DSMath, Stores  {
    /**
     * @dev Kyber Proxy Address
     */
    function getKyberAddr() internal pure returns (address) {
        return 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
    }

    /**
     * @dev Referral Address
     */
    function getReferralAddr() internal pure returns (address) {
        return 0x7284a8451d9a0e7Dc62B3a71C0593eA2eC5c5638;
    }
}

contract KyberResolver is KyberHelpers {
    event LogSell(
        address indexed buyToken,
        address indexed sellToken,
        uint256 buyAmt,
        uint256 sellAmt,
        uint256 getId,
        uint256 setId
    );

    /**
     * @dev Sell ETH/ERC20_Token.
     * @param buyAddr buying token address.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
     * @param sellAddr selling token amount.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
     * @param sellAmt selling token amount.
     * @param unitAmt unit amount of buyAmt/sellAmt with slippage.
     * @param getId Get token amount at this ID from `InstaMemory` Contract.
     * @param setId Set token amount at this ID in `InstaMemory` Contract.
    */
    function sell(
        address buyAddr,
        address sellAddr,
        uint sellAmt,
        uint unitAmt,
        uint getId,
        uint setId
    ) external payable
    {
        uint _sellAmt = getUint(getId, sellAmt);

        uint ethAmt;
        if (sellAddr == getEthAddr()) {
            _sellAmt = _sellAmt == uint(-1) ? address(this).balance : _sellAmt;
            ethAmt = _sellAmt;
        } else {
            TokenInterface sellContract = TokenInterface(sellAddr);
            _sellAmt = _sellAmt == uint(-1) ? sellContract.balanceOf(address(this)) : _sellAmt;
            sellContract.approve(getKyberAddr(), _sellAmt);
        }

        uint _buyAmt = KyberInterface(getKyberAddr()).trade.value(ethAmt)(
            sellAddr,
            _sellAmt,
            buyAddr,
            address(this),
            uint(-1),
            unitAmt,
            getReferralAddr()
        );

        setUint(setId, _buyAmt);

        emit LogSell(buyAddr, sellAddr, _buyAmt, _sellAmt, getId, setId);
        bytes32 eventCode = keccak256("LogSell(address,address,uint256,uint256,uint256,uint256)");
        bytes memory eventData = abi.encode(buyAddr, sellAddr, _buyAmt, _sellAmt, getId, setId);
        emitEvent(eventCode, eventData);
    }
}

contract ConnectKyber is KyberResolver {
    string public name = "Kyber-v1";
}