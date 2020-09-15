/**
 *Submitted for verification at Etherscan.io on 2020-05-15
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


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
     * @dev Connector Details - needs to be changed before deployment
     */
    function connectorID() public pure returns(uint model, uint id) {
        (model, id) = (0, 0);
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

interface SoloMarginContract {

    struct Info {
        address owner;  // The address that owns the account
        uint256 number; // A nonce that allows a single address to control many accounts
    }

    enum ActionType {
        Deposit,   // supply tokens
        Withdraw,  // borrow tokens
        Transfer,  // transfer balance between accounts
        Buy,       // buy an amount of some token (externally)
        Sell,      // sell an amount of some token (externally)
        Trade,     // trade tokens against another account
        Liquidate, // liquidate an undercollateralized or expiring account
        Vaporize,  // use excess tokens to zero-out a completely negative account
        Call       // send arbitrary data to an address
    }

    enum AssetDenomination {
        Wei, // the amount is denominated in wei
        Par  // the amount is denominated in par
    }

    enum AssetReference {
        Delta, // the amount is given as a delta from the current value
        Target // the amount is given as an exact number to end up at
    }

    struct AssetAmount {
        bool sign; // true if positive
        AssetDenomination denomination;
        AssetReference ref;
        uint256 value;
    }

    struct ActionArgs {
        ActionType actionType;
        uint256 accountId;
        AssetAmount amount;
        uint256 primaryMarketId;
        uint256 secondaryMarketId;
        address otherAddress;
        uint256 otherAccountId;
        bytes data;
    }

    struct Wei {
        bool sign; // true if positive
        uint256 value;
    }

    function operate(Info[] calldata accounts, ActionArgs[] calldata actions) external;
    function getAccountWei(Info calldata account, uint256 marketId) external returns (Wei memory);
    function getNumMarkets() external view returns (uint256);
    function getMarketTokenAddress(uint256 marketId) external view returns (address);

}

contract DydxHelpers is DSMath, Stores {
    /**
     * @dev get WETH address
    */
    function getWETHAddr() public pure returns (address weth) {
        weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    }

    /**
     * @dev get Dydx Solo Address
    */
    function getDydxAddress() public pure returns (address addr) {
        addr = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;
    }

    /**
     * @dev Get Dydx Actions args.
    */
    function getActionsArgs(uint256 marketId, uint256 amt, bool sign) internal view returns (SoloMarginContract.ActionArgs[] memory) {
        SoloMarginContract.ActionArgs[] memory actions = new SoloMarginContract.ActionArgs[](1);
        SoloMarginContract.AssetAmount memory amount = SoloMarginContract.AssetAmount(
            sign,
            SoloMarginContract.AssetDenomination.Wei,
            SoloMarginContract.AssetReference.Delta,
            amt
        );
        bytes memory empty;
        SoloMarginContract.ActionType action = sign ? SoloMarginContract.ActionType.Deposit : SoloMarginContract.ActionType.Withdraw;
        actions[0] = SoloMarginContract.ActionArgs(
            action,
            0,
            amount,
            marketId,
            0,
            address(this),
            0,
            empty
        );
        return actions;
    }

    /**
     * @dev Get Dydx Acccount arg
    */
    function getAccountArgs() internal view returns (SoloMarginContract.Info[] memory) {
        SoloMarginContract.Info[] memory accounts = new SoloMarginContract.Info[](1);
        accounts[0] = (SoloMarginContract.Info(address(this), 0));
        return accounts;
    }

    /**
     * @dev Get Dydx Position
    */
    function getDydxPosition(SoloMarginContract solo, uint256 marketId) internal returns (uint tokenBal, bool tokenSign) {
        SoloMarginContract.Wei memory tokenWeiBal = solo.getAccountWei(getAccountArgs()[0], marketId);
        tokenBal = tokenWeiBal.value;
        tokenSign = tokenWeiBal.sign;
    }


    /**
     * @dev Get Dydx Market ID from token Address
    */
    function getMarketId(SoloMarginContract solo, address token) internal view returns (uint _marketId) {
        uint markets = solo.getNumMarkets();
        address _token = token == getEthAddr() ? getWETHAddr() : token;

        for (uint i = 0; i < markets; i++) {
            if (_token == solo.getMarketTokenAddress(i)) {
                _marketId = i;
                break;
            }
        }
    }
}

contract BasicResolver is DydxHelpers {
    event LogDeposit(address indexed token, uint marketId, uint256 tokenAmt, uint256 getId, uint256 setId);
    event LogWithdraw(address indexed token, uint marketId, uint256 tokenAmt, uint256 getId, uint256 setId);
    event LogBorrow(address indexed token, uint marketId, uint256 tokenAmt, uint256 getId, uint256 setId);
    event LogPayback(address indexed token, uint marketId, uint256 tokenAmt, uint256 getId, uint256 setId);

    /**
     * @dev Deposit ETH/ERC20
     */
    function deposit(address token, uint amt, uint getId, uint setId) external payable{
        SoloMarginContract dydxContract = SoloMarginContract(getDydxAddress());

        uint _amt = getUint(getId, amt);
        uint _marketId = getMarketId(dydxContract, token);

        (uint depositedAmt, bool sign) = getDydxPosition(dydxContract, _marketId);
        require(depositedAmt == 0 || sign, "token-borrowed"); //TODO - check.

        if (token == getEthAddr()) {
            TokenInterface tokenContract = TokenInterface(getWETHAddr());
            _amt = _amt == uint(-1) ? address(this).balance : _amt;
            tokenContract.deposit.value(_amt)();
            TokenInterface(token).approve(getDydxAddress(), _amt);
        } else {
            TokenInterface tokenContract = TokenInterface(token);
            _amt = _amt == uint(-1) ? tokenContract.balanceOf(address(this)) : _amt;
            tokenContract.approve(getDydxAddress(), _amt);
        }

        dydxContract.operate(getAccountArgs(), getActionsArgs(_marketId, _amt, true));
        setUint(setId, _amt);

        emit LogDeposit(token, _marketId, _amt, getId, setId);
        // bytes32 _eventCode = keccak256("LogDeposit(address,uint256,uint256,uint256,uint256)");
        // bytes memory _eventParam = abi.encode(token, _marketId, _amt, getId, setId);
        // (uint _type, uint _id) = connectorID();
        // EventInterface(getEventAddr()).emitEvent(_type, _id, _eventCode, _eventParam);
    }


    function withdraw(address token, uint amt, uint getId, uint setId) external payable{
        SoloMarginContract dydxContract = SoloMarginContract(getDydxAddress());

        uint _amt = getUint(getId, amt);
        uint _marketId = getMarketId(dydxContract, token);

        (uint depositedAmt, bool sign) = getDydxPosition(dydxContract, _marketId);
        require(sign, "try-payback"); //TODO - check.

        _amt = _amt == uint(-1) ? depositedAmt : _amt;
        require(_amt <= depositedAmt, "withdraw-exceeds");

        dydxContract.operate(getAccountArgs(), getActionsArgs(_marketId, _amt, false));

        if (token == getEthAddr()) {
            TokenInterface tokenContract = TokenInterface(getWETHAddr());
            tokenContract.approve(address(tokenContract), _amt);
            tokenContract.withdraw(_amt);
        }

        setUint(setId, _amt);

        emit LogWithdraw(token, _marketId, _amt, getId, setId);
        // bytes32 _eventCode = keccak256("LogWithdraw(address,uint256,uint256,uint256,uint256)");
        // bytes memory _eventParam = abi.encode(token, _marketId, _amt, getId, setId);
        // (uint _type, uint _id) = connectorID();
        // EventInterface(getEventAddr()).emitEvent(_type, _id, _eventCode, _eventParam);

    }

    /**
    * @dev Borrow ETH/ERC20
    */
    function borrow(address token, uint amt, uint getId, uint setId) external payable {
        SoloMarginContract dydxContract = SoloMarginContract(getDydxAddress());

        uint _amt = getUint(getId, amt);
        uint _marketId = getMarketId(dydxContract, token);

        (uint borrowedAmt, bool sign) = getDydxPosition(dydxContract, _marketId);
        require(borrowedAmt == 0 || !sign, "token-deposited"); //TODO - check.

        dydxContract.operate(getAccountArgs(), getActionsArgs(_marketId, _amt, false));

        if (token == getEthAddr()) {
            TokenInterface tokenContract = TokenInterface(getWETHAddr());
            tokenContract.approve(address(tokenContract), _amt);
            tokenContract.withdraw(_amt);
        }

        setUint(setId, _amt);

        emit LogBorrow(token, _marketId, _amt, getId, setId);
        // bytes32 _eventCode = keccak256("LogBorrow(address,uint256,uint256,uint256,uint256)");
        // bytes memory _eventParam = abi.encode(token, _marketId, _amt, getId, setId);
        // (uint _type, uint _id) = connectorID();
        // EventInterface(getEventAddr()).emitEvent(_type, _id, _eventCode, _eventParam);
    }

    /**
     * @dev Payback ETH/ERC20
     */
    function payback(address token, uint amt, uint getId, uint setId) external payable {
        SoloMarginContract dydxContract = SoloMarginContract(getDydxAddress());

        uint _amt = getUint(getId, amt);
        uint _marketId = getMarketId(dydxContract, token);

        (uint borrowedAmt, bool sign) = getDydxPosition(dydxContract, _marketId);
        require(!sign, "try-withdraw"); //TODO - check.

        _amt = _amt == uint(-1) ? borrowedAmt : _amt;
        require(_amt <= borrowedAmt, "payback-exceeds");

        if (token == getEthAddr()) {
            TokenInterface tokenContract = TokenInterface(getWETHAddr());
            require(address(this).balance >= _amt, "not-enough-eth");
            tokenContract.deposit.value(_amt)();
            TokenInterface(token).approve(getDydxAddress(), _amt);
        } else {
            TokenInterface tokenContract = TokenInterface(token);
            require(tokenContract.balanceOf(address(this)) >= _amt, "not-enough-token");
            tokenContract.approve(getDydxAddress(), _amt);
        }

        dydxContract.operate(getAccountArgs(), getActionsArgs(_marketId, _amt, true));
        setUint(setId, _amt);

        emit LogPayback(token, _marketId, _amt, getId, setId);
        // bytes32 _eventCode = keccak256("LogPayback(address,uint256,uint256,uint256,uint256)");
        // bytes memory _eventParam = abi.encode(token, _marketId, _amt, getId, setId);
        // (uint _type, uint _id) = connectorID();
        // EventInterface(getEventAddr()).emitEvent(_type, _id, _eventCode, _eventParam);
    }
}

contract ConnectDydx is BasicResolver {
    string public name = "Dydx-v1";
}