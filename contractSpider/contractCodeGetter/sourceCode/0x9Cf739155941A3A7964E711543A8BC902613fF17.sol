/**
 *Submitted for verification at Etherscan.io on 2020-07-02
*/

// File: contracts/sol6/IERC20.sol

pragma solidity 0.6.6;


interface IERC20 {
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function approve(address _spender, uint256 _value) external returns (bool success);

    function transfer(address _to, uint256 _value) external returns (bool success);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);

    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    function balanceOf(address _owner) external view returns (uint256 balance);

    function decimals() external view returns (uint8 digits);

    function totalSupply() external view returns (uint256 supply);
}


// to support backward compatible contract name -- so function signature remains same
abstract contract ERC20 is IERC20 {

}

// File: contracts/sol6/utils/PermissionGroupsNoModifiers.sol

pragma solidity 0.6.6;


contract PermissionGroupsNoModifiers {
    address public admin;
    address public pendingAdmin;
    mapping(address => bool) internal operators;
    mapping(address => bool) internal alerters;
    address[] internal operatorsGroup;
    address[] internal alertersGroup;
    uint256 internal constant MAX_GROUP_SIZE = 50;

    event AdminClaimed(address newAdmin, address previousAdmin);
    event AlerterAdded(address newAlerter, bool isAdd);
    event OperatorAdded(address newOperator, bool isAdd);
    event TransferAdminPending(address pendingAdmin);

    constructor(address _admin) public {
        require(_admin != address(0), "admin 0");
        admin = _admin;
    }

    function getOperators() external view returns (address[] memory) {
        return operatorsGroup;
    }

    function getAlerters() external view returns (address[] memory) {
        return alertersGroup;
    }

    function addAlerter(address newAlerter) public {
        onlyAdmin();
        require(!alerters[newAlerter], "alerter exists"); // prevent duplicates.
        require(alertersGroup.length < MAX_GROUP_SIZE, "max alerters");

        emit AlerterAdded(newAlerter, true);
        alerters[newAlerter] = true;
        alertersGroup.push(newAlerter);
    }

    function addOperator(address newOperator) public {
        onlyAdmin();
        require(!operators[newOperator], "operator exists"); // prevent duplicates.
        require(operatorsGroup.length < MAX_GROUP_SIZE, "max operators");

        emit OperatorAdded(newOperator, true);
        operators[newOperator] = true;
        operatorsGroup.push(newOperator);
    }

    /// @dev Allows the pendingAdmin address to finalize the change admin process.
    function claimAdmin() public {
        require(pendingAdmin == msg.sender, "not pending");
        emit AdminClaimed(pendingAdmin, admin);
        admin = pendingAdmin;
        pendingAdmin = address(0);
    }

    function removeAlerter(address alerter) public {
        onlyAdmin();
        require(alerters[alerter], "not alerter");
        delete alerters[alerter];

        for (uint256 i = 0; i < alertersGroup.length; ++i) {
            if (alertersGroup[i] == alerter) {
                alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
                alertersGroup.pop();
                emit AlerterAdded(alerter, false);
                break;
            }
        }
    }

    function removeOperator(address operator) public {
        onlyAdmin();
        require(operators[operator], "not operator");
        delete operators[operator];

        for (uint256 i = 0; i < operatorsGroup.length; ++i) {
            if (operatorsGroup[i] == operator) {
                operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
                operatorsGroup.pop();
                emit OperatorAdded(operator, false);
                break;
            }
        }
    }

    /// @dev Allows the current admin to set the pendingAdmin address
    /// @param newAdmin The address to transfer ownership to
    function transferAdmin(address newAdmin) public {
        onlyAdmin();
        require(newAdmin != address(0), "new admin 0");
        emit TransferAdminPending(newAdmin);
        pendingAdmin = newAdmin;
    }

    /// @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
    /// @param newAdmin The address to transfer ownership to.
    function transferAdminQuickly(address newAdmin) public {
        onlyAdmin();
        require(newAdmin != address(0), "admin 0");
        emit TransferAdminPending(newAdmin);
        emit AdminClaimed(newAdmin, admin);
        admin = newAdmin;
    }

    function onlyAdmin() internal view {
        require(msg.sender == admin, "only admin");
    }

    function onlyAlerter() internal view {
        require(alerters[msg.sender], "only alerter");
    }

    function onlyOperator() internal view {
        require(operators[msg.sender], "only operator");
    }
}

// File: contracts/sol6/utils/WithdrawableNoModifiers.sol

pragma solidity 0.6.6;




contract WithdrawableNoModifiers is PermissionGroupsNoModifiers {
    constructor(address _admin) public PermissionGroupsNoModifiers(_admin) {}

    event EtherWithdraw(uint256 amount, address sendTo);
    event TokenWithdraw(IERC20 token, uint256 amount, address sendTo);

    /// @dev Withdraw Ethers
    function withdrawEther(uint256 amount, address payable sendTo) external {
        onlyAdmin();
        (bool success, ) = sendTo.call{value: amount}("");
        require(success);
        emit EtherWithdraw(amount, sendTo);
    }

    /// @dev Withdraw all IERC20 compatible tokens
    /// @param token IERC20 The address of the token contract
    function withdrawToken(
        IERC20 token,
        uint256 amount,
        address sendTo
    ) external {
        onlyAdmin();
        token.transfer(sendTo, amount);
        emit TokenWithdraw(token, amount, sendTo);
    }
}

// File: contracts/sol6/IKyberReserve.sol

pragma solidity 0.6.6;



interface IKyberReserve {
    function trade(
        IERC20 srcToken,
        uint256 srcAmount,
        IERC20 destToken,
        address payable destAddress,
        uint256 conversionRate,
        bool validate
    ) external payable returns (bool);

    function getConversionRate(
        IERC20 src,
        IERC20 dest,
        uint256 srcQty,
        uint256 blockNumber
    ) external view returns (uint256);
}

// File: contracts/sol6/IKyberNetwork.sol

pragma solidity 0.6.6;



interface IKyberNetwork {
    event KyberTrade(
        IERC20 indexed src,
        IERC20 indexed dest,
        uint256 ethWeiValue,
        uint256 networkFeeWei,
        uint256 customPlatformFeeWei,
        bytes32[] t2eIds,
        bytes32[] e2tIds,
        uint256[] t2eSrcAmounts,
        uint256[] e2tSrcAmounts,
        uint256[] t2eRates,
        uint256[] e2tRates
    );

    function tradeWithHintAndFee(
        address payable trader,
        IERC20 src,
        uint256 srcAmount,
        IERC20 dest,
        address payable destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address payable platformWallet,
        uint256 platformFeeBps,
        bytes calldata hint
    ) external payable returns (uint256 destAmount);

    function listTokenForReserve(
        address reserve,
        IERC20 token,
        bool add
    ) external;

    function enabled() external view returns (bool);

    function getExpectedRateWithHintAndFee(
        IERC20 src,
        IERC20 dest,
        uint256 srcQty,
        uint256 platformFeeBps,
        bytes calldata hint
    )
        external
        view
        returns (
            uint256 expectedRateAfterNetworkFee,
            uint256 expectedRateAfterAllFees
        );

    function getNetworkData()
        external
        view
        returns (
            uint256 negligibleDiffBps,
            uint256 networkFeeBps,
            uint256 expiryTimestamp
        );

    function maxGasPrice() external view returns (uint256);
}

// File: contracts/sol6/IKyberNetworkProxy.sol

pragma solidity 0.6.6;



interface IKyberNetworkProxy {

    event ExecuteTrade(
        address indexed trader,
        IERC20 src,
        IERC20 dest,
        address destAddress,
        uint256 actualSrcAmount,
        uint256 actualDestAmount,
        address platformWallet,
        uint256 platformFeeBps
    );

    /// @notice backward compatible
    function tradeWithHint(
        ERC20 src,
        uint256 srcAmount,
        ERC20 dest,
        address payable destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address payable walletId,
        bytes calldata hint
    ) external payable returns (uint256);

    function tradeWithHintAndFee(
        IERC20 src,
        uint256 srcAmount,
        IERC20 dest,
        address payable destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address payable platformWallet,
        uint256 platformFeeBps,
        bytes calldata hint
    ) external payable returns (uint256 destAmount);

    function trade(
        IERC20 src,
        uint256 srcAmount,
        IERC20 dest,
        address payable destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address payable platformWallet
    ) external payable returns (uint256);

    /// @notice backward compatible
    /// @notice Rate units (10 ** 18) => destQty (twei) / srcQty (twei) * 10 ** 18
    function getExpectedRate(
        ERC20 src,
        ERC20 dest,
        uint256 srcQty
    ) external view returns (uint256 expectedRate, uint256 worstRate);

    function getExpectedRateAfterFee(
        IERC20 src,
        IERC20 dest,
        uint256 srcQty,
        uint256 platformFeeBps,
        bytes calldata hint
    ) external view returns (uint256 expectedRate);
}

// File: contracts/sol6/IKyberStorage.sol

pragma solidity 0.6.6;




interface IKyberStorage {
    enum ReserveType {NONE, FPR, APR, BRIDGE, UTILITY, CUSTOM, ORDERBOOK, LAST}

    function addKyberProxy(address kyberProxy, uint256 maxApprovedProxies)
        external;

    function removeKyberProxy(address kyberProxy) external;

    function setContracts(address _kyberFeeHandler, address _kyberMatchingEngine) external;

    function setKyberDaoContract(address _kyberDao) external;

    function getReserveId(address reserve) external view returns (bytes32 reserveId);

    function getReserveIdsFromAddresses(address[] calldata reserveAddresses)
        external
        view
        returns (bytes32[] memory reserveIds);

    function getReserveAddressesFromIds(bytes32[] calldata reserveIds)
        external
        view
        returns (address[] memory reserveAddresses);

    function getReserveIdsPerTokenSrc(IERC20 token)
        external
        view
        returns (bytes32[] memory reserveIds);

    function getReserveAddressesPerTokenSrc(IERC20 token, uint256 startIndex, uint256 endIndex)
        external
        view
        returns (address[] memory reserveAddresses);

    function getReserveIdsPerTokenDest(IERC20 token)
        external
        view
        returns (bytes32[] memory reserveIds);

    function getReserveAddressesByReserveId(bytes32 reserveId)
        external
        view
        returns (address[] memory reserveAddresses);

    function getRebateWalletsFromIds(bytes32[] calldata reserveIds)
        external
        view
        returns (address[] memory rebateWallets);

    function getKyberProxies() external view returns (IKyberNetworkProxy[] memory);

    function getReserveDetailsByAddress(address reserve)
        external
        view
        returns (
            bytes32 reserveId,
            address rebateWallet,
            ReserveType resType,
            bool isFeeAccountedFlag,
            bool isEntitledRebateFlag
        );

    function getReserveDetailsById(bytes32 reserveId)
        external
        view
        returns (
            address reserveAddress,
            address rebateWallet,
            ReserveType resType,
            bool isFeeAccountedFlag,
            bool isEntitledRebateFlag
        );

    function getFeeAccountedData(bytes32[] calldata reserveIds)
        external
        view
        returns (bool[] memory feeAccountedArr);

    function getEntitledRebateData(bytes32[] calldata reserveIds)
        external
        view
        returns (bool[] memory entitledRebateArr);

    function getReservesData(bytes32[] calldata reserveIds, IERC20 src, IERC20 dest)
        external
        view
        returns (
            bool areAllReservesListed,
            bool[] memory feeAccountedArr,
            bool[] memory entitledRebateArr,
            IKyberReserve[] memory reserveAddresses);

    function isKyberProxyAdded() external view returns (bool);
}

// File: contracts/sol6/IKyberMatchingEngine.sol

pragma solidity 0.6.6;





interface IKyberMatchingEngine {
    enum ProcessWithRate {NotRequired, Required}

    function setNegligibleRateDiffBps(uint256 _negligibleRateDiffBps) external;

    function setKyberStorage(IKyberStorage _kyberStorage) external;

    function getNegligibleRateDiffBps() external view returns (uint256);

    function getTradingReserves(
        IERC20 src,
        IERC20 dest,
        bool isTokenToToken,
        bytes calldata hint
    )
        external
        view
        returns (
            bytes32[] memory reserveIds,
            uint256[] memory splitValuesBps,
            ProcessWithRate processWithRate
        );

    function doMatch(
        IERC20 src,
        IERC20 dest,
        uint256[] calldata srcAmounts,
        uint256[] calldata feesAccountedDestBps,
        uint256[] calldata rates
    ) external view returns (uint256[] memory reserveIndexes);
}

// File: contracts/sol6/utils/Utils5.sol

pragma solidity 0.6.6;



/**
 * @title Kyber utility file
 * mostly shared constants and rate calculation helpers
 * inherited by most of kyber contracts.
 * previous utils implementations are for previous solidity versions.
 */
contract Utils5 {
    IERC20 internal constant ETH_TOKEN_ADDRESS = IERC20(
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
    );
    uint256 internal constant PRECISION = (10**18);
    uint256 internal constant MAX_QTY = (10**28); // 10B tokens
    uint256 internal constant MAX_RATE = (PRECISION * 10**7); // up to 10M tokens per eth
    uint256 internal constant MAX_DECIMALS = 18;
    uint256 internal constant ETH_DECIMALS = 18;
    uint256 constant BPS = 10000; // Basic Price Steps. 1 step = 0.01%
    uint256 internal constant MAX_ALLOWANCE = uint256(-1); // token.approve inifinite

    mapping(IERC20 => uint256) internal decimals;

    function getUpdateDecimals(IERC20 token) internal returns (uint256) {
        if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
        uint256 tokenDecimals = decimals[token];
        // moreover, very possible that old tokens have decimals 0
        // these tokens will just have higher gas fees.
        if (tokenDecimals == 0) {
            tokenDecimals = token.decimals();
            decimals[token] = tokenDecimals;
        }

        return tokenDecimals;
    }

    function setDecimals(IERC20 token) internal {
        if (decimals[token] != 0) return; //already set

        if (token == ETH_TOKEN_ADDRESS) {
            decimals[token] = ETH_DECIMALS;
        } else {
            decimals[token] = token.decimals();
        }
    }

    /// @dev get the balance of a user.
    /// @param token The token type
    /// @return The balance
    function getBalance(IERC20 token, address user) internal view returns (uint256) {
        if (token == ETH_TOKEN_ADDRESS) {
            return user.balance;
        } else {
            return token.balanceOf(user);
        }
    }

    function getDecimals(IERC20 token) internal view returns (uint256) {
        if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
        uint256 tokenDecimals = decimals[token];
        // moreover, very possible that old tokens have decimals 0
        // these tokens will just have higher gas fees.
        if (tokenDecimals == 0) return token.decimals();

        return tokenDecimals;
    }

    function calcDestAmount(
        IERC20 src,
        IERC20 dest,
        uint256 srcAmount,
        uint256 rate
    ) internal view returns (uint256) {
        return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
    }

    function calcSrcAmount(
        IERC20 src,
        IERC20 dest,
        uint256 destAmount,
        uint256 rate
    ) internal view returns (uint256) {
        return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
    }

    function calcDstQty(
        uint256 srcQty,
        uint256 srcDecimals,
        uint256 dstDecimals,
        uint256 rate
    ) internal pure returns (uint256) {
        require(srcQty <= MAX_QTY, "srcQty > MAX_QTY");
        require(rate <= MAX_RATE, "rate > MAX_RATE");

        if (dstDecimals >= srcDecimals) {
            require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
            return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
        } else {
            require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
            return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
        }
    }

    function calcSrcQty(
        uint256 dstQty,
        uint256 srcDecimals,
        uint256 dstDecimals,
        uint256 rate
    ) internal pure returns (uint256) {
        require(dstQty <= MAX_QTY, "dstQty > MAX_QTY");
        require(rate <= MAX_RATE, "rate > MAX_RATE");

        //source quantity is rounded up. to avoid dest quantity being too low.
        uint256 numerator;
        uint256 denominator;
        if (srcDecimals >= dstDecimals) {
            require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
            numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
            denominator = rate;
        } else {
            require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
            numerator = (PRECISION * dstQty);
            denominator = (rate * (10**(dstDecimals - srcDecimals)));
        }
        return (numerator + denominator - 1) / denominator; //avoid rounding down errors
    }

    function calcRateFromQty(
        uint256 srcAmount,
        uint256 destAmount,
        uint256 srcDecimals,
        uint256 dstDecimals
    ) internal pure returns (uint256) {
        require(srcAmount <= MAX_QTY, "srcAmount > MAX_QTY");
        require(destAmount <= MAX_QTY, "destAmount > MAX_QTY");

        if (dstDecimals >= srcDecimals) {
            require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
            return ((destAmount * PRECISION) / ((10**(dstDecimals - srcDecimals)) * srcAmount));
        } else {
            require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
            return ((destAmount * PRECISION * (10**(srcDecimals - dstDecimals))) / srcAmount);
        }
    }

    function minOf(uint256 x, uint256 y) internal pure returns (uint256) {
        return x > y ? y : x;
    }
}

// File: contracts/sol6/IKyberHint.sol

pragma solidity 0.6.6;



interface IKyberHint {
    enum TradeType {BestOfAll, MaskIn, MaskOut, Split}
    enum HintErrors {
        NoError, // Hint is valid
        NonEmptyDataError, // reserveIDs and splits must be empty for BestOfAll hint
        ReserveIdDupError, // duplicate reserveID found
        ReserveIdEmptyError, // reserveIDs array is empty for MaskIn and Split trade type
        ReserveIdSplitsError, // reserveIDs and splitBpsValues arrays do not have the same length
        ReserveIdSequenceError, // reserveID sequence in array is not in increasing order
        ReserveIdNotFound, // reserveID isn't registered or doesn't exist
        SplitsNotEmptyError, // splitBpsValues is not empty for MaskIn or MaskOut trade type
        TokenListedError, // reserveID not listed for the token
        TotalBPSError // total BPS for Split trade type is not 10000 (100%)
    }

    function buildTokenToEthHint(
        IERC20 tokenSrc,
        TradeType tokenToEthType,
        bytes32[] calldata tokenToEthReserveIds,
        uint256[] calldata tokenToEthSplits
    ) external view returns (bytes memory hint);

    function buildEthToTokenHint(
        IERC20 tokenDest,
        TradeType ethToTokenType,
        bytes32[] calldata ethToTokenReserveIds,
        uint256[] calldata ethToTokenSplits
    ) external view returns (bytes memory hint);

    function buildTokenToTokenHint(
        IERC20 tokenSrc,
        TradeType tokenToEthType,
        bytes32[] calldata tokenToEthReserveIds,
        uint256[] calldata tokenToEthSplits,
        IERC20 tokenDest,
        TradeType ethToTokenType,
        bytes32[] calldata ethToTokenReserveIds,
        uint256[] calldata ethToTokenSplits
    ) external view returns (bytes memory hint);

    function parseTokenToEthHint(IERC20 tokenSrc, bytes calldata hint)
        external
        view
        returns (
            TradeType tokenToEthType,
            bytes32[] memory tokenToEthReserveIds,
            IKyberReserve[] memory tokenToEthAddresses,
            uint256[] memory tokenToEthSplits
        );

    function parseEthToTokenHint(IERC20 tokenDest, bytes calldata hint)
        external
        view
        returns (
            TradeType ethToTokenType,
            bytes32[] memory ethToTokenReserveIds,
            IKyberReserve[] memory ethToTokenAddresses,
            uint256[] memory ethToTokenSplits
        );

    function parseTokenToTokenHint(IERC20 tokenSrc, IERC20 tokenDest, bytes calldata hint)
        external
        view
        returns (
            TradeType tokenToEthType,
            bytes32[] memory tokenToEthReserveIds,
            IKyberReserve[] memory tokenToEthAddresses,
            uint256[] memory tokenToEthSplits,
            TradeType ethToTokenType,
            bytes32[] memory ethToTokenReserveIds,
            IKyberReserve[] memory ethToTokenAddresses,
            uint256[] memory ethToTokenSplits
        );
}

// File: contracts/sol6/KyberHintHandler.sol

pragma solidity 0.6.6;




/**
 *   @title kyberHintHandler contract
 *   The contract provides the following functionality:
 *       - building hints
 *       - parsing hints
 *
 *       All external functions, build*Hint() and parse*Hint:
 *           - Will revert with error message if an error is found
 *           - parse*Hint() returns both reserveIds and reserveAddresses
 *       Internal functions unpackT2THint() and parseHint():
 *           - Are part of get rate && trade flow
 *           - Don't revert if an error is found
 *           - If an error is found, return no data such that the trade flow
 *             returns 0 rate for bad hint values
 */
abstract contract KyberHintHandler is IKyberHint, Utils5 {
    /// @notice Parses the hint for a token -> eth trade
    /// @param tokenSrc source token to trade
    /// @param hint The ABI encoded hint, built using the build*Hint functions
    /// @return tokenToEthType Decoded hint type
    /// @return tokenToEthReserveIds Decoded reserve IDs
    /// @return tokenToEthAddresses Reserve addresses corresponding to reserve IDs
    /// @return tokenToEthSplits Decoded splits
    function parseTokenToEthHint(IERC20 tokenSrc, bytes memory hint)
        public
        view
        override
        returns (
            TradeType tokenToEthType,
            bytes32[] memory tokenToEthReserveIds,
            IKyberReserve[] memory tokenToEthAddresses,
            uint256[] memory tokenToEthSplits
        )
    {
        HintErrors error;

        (tokenToEthType, tokenToEthReserveIds, tokenToEthSplits, error) = parseHint(hint);
        if (error != HintErrors.NoError) throwHintError(error);

        if (tokenToEthType == TradeType.MaskIn || tokenToEthType == TradeType.Split) {
            checkTokenListedForReserve(tokenSrc, tokenToEthReserveIds, true);
        }

        tokenToEthAddresses = new IKyberReserve[](tokenToEthReserveIds.length);

        for (uint256 i = 0; i < tokenToEthReserveIds.length; i++) {
            checkReserveIdsExists(tokenToEthReserveIds[i]);
            checkDuplicateReserveIds(tokenToEthReserveIds, i);

            if (i > 0 && tokenToEthType == TradeType.Split) {
                checkSplitReserveIdSeq(tokenToEthReserveIds[i], tokenToEthReserveIds[i - 1]);
            }

            tokenToEthAddresses[i] = IKyberReserve(
                getReserveAddress(tokenToEthReserveIds[i])
            );
        }
    }

    /// @notice Parses the hint for a eth -> token trade
    /// @param tokenDest destination token to trade
    /// @param hint The ABI encoded hint, built using the build*Hint functions
    /// @return ethToTokenType Decoded hint type
    /// @return ethToTokenReserveIds Decoded reserve IDs
    /// @return ethToTokenAddresses Reserve addresses corresponding to reserve IDs
    /// @return ethToTokenSplits Decoded splits
    function parseEthToTokenHint(IERC20 tokenDest, bytes memory hint)
        public
        view
        override
        returns (
            TradeType ethToTokenType,
            bytes32[] memory ethToTokenReserveIds,
            IKyberReserve[] memory ethToTokenAddresses,
            uint256[] memory ethToTokenSplits
        )
    {
        HintErrors error;

        (ethToTokenType, ethToTokenReserveIds, ethToTokenSplits, error) = parseHint(hint);
        if (error != HintErrors.NoError) throwHintError(error);

        if (ethToTokenType == TradeType.MaskIn || ethToTokenType == TradeType.Split) {
            checkTokenListedForReserve(tokenDest, ethToTokenReserveIds, false);
        }

        ethToTokenAddresses = new IKyberReserve[](ethToTokenReserveIds.length);

        for (uint256 i = 0; i < ethToTokenReserveIds.length; i++) {
            checkReserveIdsExists(ethToTokenReserveIds[i]);
            checkDuplicateReserveIds(ethToTokenReserveIds, i);

            if (i > 0 && ethToTokenType == TradeType.Split) {
                checkSplitReserveIdSeq(ethToTokenReserveIds[i], ethToTokenReserveIds[i - 1]);
            }

            ethToTokenAddresses[i] = IKyberReserve(
                getReserveAddress(ethToTokenReserveIds[i])
            );
        }
    }

    /// @notice Parses the hint for a token to token trade
    /// @param tokenSrc source token to trade
    /// @param tokenDest destination token to trade
    /// @param hint The ABI encoded hint, built using the build*Hint functions
    /// @return tokenToEthType Decoded hint type
    /// @return tokenToEthReserveIds Decoded reserve IDs
    /// @return tokenToEthAddresses Reserve addresses corresponding to reserve IDs
    /// @return tokenToEthSplits Decoded splits
    /// @return ethToTokenType Decoded hint type
    /// @return ethToTokenReserveIds Decoded reserve IDs
    /// @return ethToTokenAddresses Reserve addresses corresponding to reserve IDs
    /// @return ethToTokenSplits Decoded splits
    function parseTokenToTokenHint(IERC20 tokenSrc, IERC20 tokenDest, bytes memory hint)
        public
        view
        override
        returns (
            TradeType tokenToEthType,
            bytes32[] memory tokenToEthReserveIds,
            IKyberReserve[] memory tokenToEthAddresses,
            uint256[] memory tokenToEthSplits,
            TradeType ethToTokenType,
            bytes32[] memory ethToTokenReserveIds,
            IKyberReserve[] memory ethToTokenAddresses,
            uint256[] memory ethToTokenSplits
        )
    {
        bytes memory t2eHint;
        bytes memory e2tHint;

        (t2eHint, e2tHint) = unpackT2THint(hint);

        (
            tokenToEthType,
            tokenToEthReserveIds,
            tokenToEthAddresses,
            tokenToEthSplits
        ) = parseTokenToEthHint(tokenSrc, t2eHint);

        (
            ethToTokenType,
            ethToTokenReserveIds,
            ethToTokenAddresses,
            ethToTokenSplits
        ) = parseEthToTokenHint(tokenDest, e2tHint);
    }

    /// @notice Builds the hint for a token -> eth trade
    /// @param tokenSrc source token to trade
    /// @param tokenToEthType token -> eth trade hint type
    /// @param tokenToEthReserveIds token -> eth reserve IDs
    /// @param tokenToEthSplits token -> eth reserve splits
    /// @return hint The ABI encoded hint
    function buildTokenToEthHint(
        IERC20 tokenSrc,
        TradeType tokenToEthType,
        bytes32[] memory tokenToEthReserveIds,
        uint256[] memory tokenToEthSplits
    ) public view override returns (bytes memory hint) {
        for (uint256 i = 0; i < tokenToEthReserveIds.length; i++) {
            checkReserveIdsExists(tokenToEthReserveIds[i]);
        }

        HintErrors valid = verifyData(
            tokenToEthType,
            tokenToEthReserveIds,
            tokenToEthSplits
        );
        if (valid != HintErrors.NoError) throwHintError(valid);

        if (tokenToEthType == TradeType.MaskIn || tokenToEthType == TradeType.Split) {
            checkTokenListedForReserve(tokenSrc, tokenToEthReserveIds, true);
        }

        if (tokenToEthType == TradeType.Split) {
            bytes32[] memory seqT2EReserveIds;
            uint256[] memory seqT2ESplits;

            (seqT2EReserveIds, seqT2ESplits) = ensureSplitSeq(
                tokenToEthReserveIds,
                tokenToEthSplits
            );

            hint = abi.encode(tokenToEthType, seqT2EReserveIds, seqT2ESplits);
        } else {
            hint = abi.encode(tokenToEthType, tokenToEthReserveIds, tokenToEthSplits);
        }
    }

    /// @notice Builds the hint for a eth -> token trade
    /// @param tokenDest destination token to trade
    /// @param ethToTokenType eth -> token trade hint type
    /// @param ethToTokenReserveIds eth -> token reserve IDs
    /// @param ethToTokenSplits eth -> token reserve splits
    /// @return hint The ABI encoded hint
    function buildEthToTokenHint(
        IERC20 tokenDest,
        TradeType ethToTokenType,
        bytes32[] memory ethToTokenReserveIds,
        uint256[] memory ethToTokenSplits
    ) public view override returns (bytes memory hint) {
        for (uint256 i = 0; i < ethToTokenReserveIds.length; i++) {
            checkReserveIdsExists(ethToTokenReserveIds[i]);
        }

        HintErrors valid = verifyData(
            ethToTokenType,
            ethToTokenReserveIds,
            ethToTokenSplits
        );
        if (valid != HintErrors.NoError) throwHintError(valid);

        if (ethToTokenType == TradeType.MaskIn || ethToTokenType == TradeType.Split) {
            checkTokenListedForReserve(tokenDest, ethToTokenReserveIds, false);
        }

        if (ethToTokenType == TradeType.Split) {
            bytes32[] memory seqE2TReserveIds;
            uint256[] memory seqE2TSplits;

            (seqE2TReserveIds, seqE2TSplits) = ensureSplitSeq(
                ethToTokenReserveIds,
                ethToTokenSplits
            );

            hint = abi.encode(ethToTokenType, seqE2TReserveIds, seqE2TSplits);
        } else {
            hint = abi.encode(ethToTokenType, ethToTokenReserveIds, ethToTokenSplits);
        }
    }

    /// @notice Builds the hint for a token to token trade
    /// @param tokenSrc source token to trade
    /// @param tokenToEthType token -> eth trade hint type
    /// @param tokenToEthReserveIds token -> eth reserve IDs
    /// @param tokenToEthSplits token -> eth reserve splits
    /// @param tokenDest destination token to trade
    /// @param ethToTokenType eth -> token trade hint type
    /// @param ethToTokenReserveIds eth -> token reserve IDs
    /// @param ethToTokenSplits eth -> token reserve splits
    /// @return hint The ABI encoded hint
    function buildTokenToTokenHint(
        IERC20 tokenSrc,
        TradeType tokenToEthType,
        bytes32[] memory tokenToEthReserveIds,
        uint256[] memory tokenToEthSplits,
        IERC20 tokenDest,
        TradeType ethToTokenType,
        bytes32[] memory ethToTokenReserveIds,
        uint256[] memory ethToTokenSplits
    ) public view override returns (bytes memory hint) {
        bytes memory t2eHint = buildTokenToEthHint(
            tokenSrc,
            tokenToEthType,
            tokenToEthReserveIds,
            tokenToEthSplits
        );

        bytes memory e2tHint = buildEthToTokenHint(
            tokenDest,
            ethToTokenType,
            ethToTokenReserveIds,
            ethToTokenSplits
        );

        hint = abi.encode(t2eHint, e2tHint);
    }

    /// @notice Parses or decodes the token -> eth or eth -> token bytes hint
    /// @param hint token -> eth or eth -> token trade hint
    /// @return tradeType Decoded hint type
    /// @return reserveIds Decoded reserve IDs
    /// @return splits Reserve addresses corresponding to reserve IDs
    /// @return valid Whether the decoded is valid
    function parseHint(bytes memory hint)
        internal
        pure
        returns (
            TradeType tradeType,
            bytes32[] memory reserveIds,
            uint256[] memory splits,
            HintErrors valid
        )
    {
        (tradeType, reserveIds, splits) = abi.decode(hint, (TradeType, bytes32[], uint256[])); // solhint-disable
        valid = verifyData(tradeType, reserveIds, splits);

        if (valid != HintErrors.NoError) {
            reserveIds = new bytes32[](0);
            splits = new uint256[](0);
        }
    }

    /// @notice Unpacks the token to token hint to token -> eth and eth -> token hints
    /// @param hint token to token trade hint
    /// @return t2eHint The ABI encoded token -> eth hint
    /// @return e2tHint The ABI encoded eth -> token hint
    function unpackT2THint(bytes memory hint)
        internal
        pure
        returns (bytes memory t2eHint, bytes memory e2tHint)
    {
        (t2eHint, e2tHint) = abi.decode(hint, (bytes, bytes));
    }

    /// @notice Checks if the reserveId exists
    /// @param reserveId Reserve ID to check
    function checkReserveIdsExists(bytes32 reserveId)
        internal
        view
    {
        if (getReserveAddress(reserveId) == address(0))
            throwHintError(HintErrors.ReserveIdNotFound);
    }

    /// @notice Checks that the token is listed for the reserves
    /// @param token ERC20 token
    /// @param reserveIds Reserve IDs
    /// @param isTokenToEth Flag to indicate token -> eth or eth -> token
    function checkTokenListedForReserve(
        IERC20 token,
        bytes32[] memory reserveIds,
        bool isTokenToEth
    ) internal view {
        IERC20 src = (isTokenToEth) ? token : ETH_TOKEN_ADDRESS;
        IERC20 dest = (isTokenToEth) ? ETH_TOKEN_ADDRESS : token;

        if (!areAllReservesListed(reserveIds, src, dest))
            throwHintError(HintErrors.TokenListedError);
    }

    /// @notice Ensures that the reserveIds in the hint to be parsed has no duplicates
    /// and applies to all trade types
    /// @param reserveIds Array of reserve IDs
    /// @param i Starting index from outer loop
    function checkDuplicateReserveIds(bytes32[] memory reserveIds, uint256 i)
        internal
        pure
    {
        for (uint256 j = i + 1; j < reserveIds.length; j++) {
            if (uint256(reserveIds[i]) == uint256(reserveIds[j])) {
                throwHintError(HintErrors.ReserveIdDupError);
            }
        }
    }

    /// @notice Ensures that the reserveIds in the hint to be parsed is in
    /// sequence for and applies to only Split trade type
    /// @param reserveId Current index Reserve ID in array
    /// @param prevReserveId Previous index Reserve ID in array
    function checkSplitReserveIdSeq(bytes32 reserveId, bytes32 prevReserveId)
        internal
        pure
    {
        if (uint256(reserveId) <= uint256(prevReserveId)) {
            throwHintError(HintErrors.ReserveIdSequenceError);
        }
    }

    /// @notice Ensures that the reserveIds and splits passed when building Split hints are in increasing sequence
    /// @param reserveIds Reserve IDs
    /// @param splits Reserve splits
    /// @return Returns a bytes32[] with reserveIds in increasing sequence and respective arranged splits
    function ensureSplitSeq(
        bytes32[] memory reserveIds,
        uint256[] memory splits
    )
        internal
        pure
        returns (bytes32[] memory, uint256[] memory)
    {
        for (uint256 i = 0; i < reserveIds.length; i++) {
            for (uint256 j = i + 1; j < reserveIds.length; j++) {
                if (uint256(reserveIds[i]) > (uint256(reserveIds[j]))) {
                    bytes32 tempId = reserveIds[i];
                    uint256 tempSplit = splits[i];

                    reserveIds[i] = reserveIds[j];
                    reserveIds[j] = tempId;
                    splits[i] = splits[j];
                    splits[j] = tempSplit;
                } else if (reserveIds[i] == reserveIds[j]) {
                    throwHintError(HintErrors.ReserveIdDupError);
                }
            }
        }

        return (reserveIds, splits);
    }

    /// @notice Ensures that the data passed when building/parsing hints is valid
    /// @param tradeType Trade hint type
    /// @param reserveIds Reserve IDs
    /// @param splits Reserve splits
    /// @return Returns a HintError enum to indicate valid or invalid hint data
    function verifyData(
        TradeType tradeType,
        bytes32[] memory reserveIds,
        uint256[] memory splits
    ) internal pure returns (HintErrors) {
        if (tradeType == TradeType.BestOfAll) {
            if (reserveIds.length != 0 || splits.length != 0) return HintErrors.NonEmptyDataError;
        }

        if (
            (tradeType == TradeType.MaskIn || tradeType == TradeType.Split) &&
            reserveIds.length == 0
        ) return HintErrors.ReserveIdEmptyError;

        if (tradeType == TradeType.Split) {
            if (reserveIds.length != splits.length) return HintErrors.ReserveIdSplitsError;

            uint256 bpsSoFar;
            for (uint256 i = 0; i < splits.length; i++) {
                bpsSoFar += splits[i];
            }

            if (bpsSoFar != BPS) return HintErrors.TotalBPSError;
        } else {
            if (splits.length != 0) return HintErrors.SplitsNotEmptyError;
        }

        return HintErrors.NoError;
    }

    /// @notice Throws error message to user to indicate error on hint
    /// @param error Error type from HintErrors enum
    function throwHintError(HintErrors error) internal pure {
        if (error == HintErrors.NonEmptyDataError) revert("reserveIds and splits must be empty");
        if (error == HintErrors.ReserveIdDupError) revert("duplicate reserveId");
        if (error == HintErrors.ReserveIdEmptyError) revert("reserveIds cannot be empty");
        if (error == HintErrors.ReserveIdSplitsError) revert("reserveIds.length != splits.length");
        if (error == HintErrors.ReserveIdSequenceError) revert("reserveIds not in increasing order");
        if (error == HintErrors.ReserveIdNotFound) revert("reserveId not found");
        if (error == HintErrors.SplitsNotEmptyError) revert("splits must be empty");
        if (error == HintErrors.TokenListedError) revert("token is not listed for reserveId");
        if (error == HintErrors.TotalBPSError) revert("total BPS != 10000");
    }

    function getReserveAddress(bytes32 reserveId) internal view virtual returns (address);

    function areAllReservesListed(
        bytes32[] memory reserveIds,
        IERC20 src,
        IERC20 dest
    ) internal virtual view returns (bool);
}

// File: contracts/sol6/KyberMatchingEngine.sol

pragma solidity 0.6.6;







/**
 *   @title kyberMatchingEngine contract
 *   During getExpectedRate flow and trade flow this contract is called for:
 *       - parsing hint and returning reserve list (function getTradingReserves)
 *       - matching best reserves to trade with (function doMatch)
 */
contract KyberMatchingEngine is KyberHintHandler, IKyberMatchingEngine, WithdrawableNoModifiers {
    struct BestReserveInfo {
        uint256 index;
        uint256 destAmount;
        uint256 numRelevantReserves;
    }
    IKyberNetwork public kyberNetwork;
    IKyberStorage public kyberStorage;

    uint256 negligibleRateDiffBps = 5; // 1 bps is 0.01%

    event KyberStorageUpdated(IKyberStorage newKyberStorage);
    event KyberNetworkUpdated(IKyberNetwork newKyberNetwork);

    constructor(address _admin) public WithdrawableNoModifiers(_admin) {
        /* empty body */
    }

    function setKyberStorage(IKyberStorage _kyberStorage) external virtual override {
        onlyAdmin();
        emit KyberStorageUpdated(_kyberStorage);
        kyberStorage = _kyberStorage;
    }

    function setNegligibleRateDiffBps(uint256 _negligibleRateDiffBps)
        external
        virtual
        override
    {
        onlyNetwork();
        require(_negligibleRateDiffBps <= BPS, "rateDiffBps exceed BPS"); // at most 100%
        negligibleRateDiffBps = _negligibleRateDiffBps;
    }

    function setNetworkContract(IKyberNetwork _kyberNetwork) external {
        onlyAdmin();
        require(_kyberNetwork != IKyberNetwork(0), "kyberNetwork 0");
        emit KyberNetworkUpdated(_kyberNetwork);
        kyberNetwork = _kyberNetwork;
    }

    /// @dev Returns trading reserves info for a trade
    /// @param src Source token
    /// @param dest Destination token
    /// @param isTokenToToken Whether the trade is token -> token
    /// @param hint Advanced instructions for running the trade
    /// @return reserveIds Array of reserve IDs for the trade, each being 32 bytes
    /// @return splitValuesBps Array of split values (in basis points) for the trade
    /// @return processWithRate Enum ProcessWithRate, whether extra processing is required or not
    function getTradingReserves(
        IERC20 src,
        IERC20 dest,
        bool isTokenToToken,
        bytes calldata hint
    )
        external
        view
        override
        returns (
            bytes32[] memory reserveIds,
            uint256[] memory splitValuesBps,
            ProcessWithRate processWithRate
        )
    {
        HintErrors error;
        if (hint.length == 0 || hint.length == 4) {
            reserveIds = (dest == ETH_TOKEN_ADDRESS)
                ? kyberStorage.getReserveIdsPerTokenSrc(src)
                : kyberStorage.getReserveIdsPerTokenDest(dest);

            splitValuesBps = populateSplitValuesBps(reserveIds.length);
            processWithRate = ProcessWithRate.Required;
            return (reserveIds, splitValuesBps, processWithRate);
        }

        TradeType tradeType;

        if (isTokenToToken) {
            bytes memory unpackedHint;
            if (src == ETH_TOKEN_ADDRESS) {
                (, unpackedHint) = unpackT2THint(hint);
                (tradeType, reserveIds, splitValuesBps, error) = parseHint(unpackedHint);
            }
            if (dest == ETH_TOKEN_ADDRESS) {
                (unpackedHint, ) = unpackT2THint(hint);
                (tradeType, reserveIds, splitValuesBps, error) = parseHint(unpackedHint);
            }
        } else {
            (tradeType, reserveIds, splitValuesBps, error) = parseHint(hint);
        }

        if (error != HintErrors.NoError)
            return (new bytes32[](0), new uint256[](0), ProcessWithRate.NotRequired);

        if (tradeType == TradeType.MaskIn) {
            splitValuesBps = populateSplitValuesBps(reserveIds.length);
        } else if (tradeType == TradeType.BestOfAll || tradeType == TradeType.MaskOut) {
            bytes32[] memory allReserves = (dest == ETH_TOKEN_ADDRESS)
                ? kyberStorage.getReserveIdsPerTokenSrc(src)
                : kyberStorage.getReserveIdsPerTokenDest(dest);

            // if bestOfAll, reserveIds = allReserves
            // if mask out, apply masking out logic
            reserveIds = (tradeType == TradeType.BestOfAll) ?
                allReserves :
                maskOutReserves(allReserves, reserveIds);
            splitValuesBps = populateSplitValuesBps(reserveIds.length);
        }

        // for split no need to search for best rate. User defines full trade details in advance.
        processWithRate = (tradeType == TradeType.Split)
            ? ProcessWithRate.NotRequired
            : ProcessWithRate.Required;
    }

    function getNegligibleRateDiffBps() external view override returns (uint256) {
        return negligibleRateDiffBps;
    }

    /// @dev Returns the indexes of the best rate from the rates array
    ///     for token -> eth or eth -> token side of trade
    /// @param src Source token (not needed in this kyberMatchingEngine version)
    /// @param dest Destination token (not needed in this kyberMatchingEngine version)
    /// @param srcAmounts Array of srcAmounts after deducting fees.
    /// @param feesAccountedDestBps Fees charged in BPS, to be deducted from calculated destAmount
    /// @param rates Rates queried from reserves
    /// @return reserveIndexes An array of the indexes most suited for the trade
    function doMatch(
        IERC20 src,
        IERC20 dest,
        uint256[] calldata srcAmounts,
        uint256[] calldata feesAccountedDestBps, // 0 for no fee, networkFeeBps when has fee
        uint256[] calldata rates
    ) external view override returns (uint256[] memory reserveIndexes) {
        src;
        dest;
        reserveIndexes = new uint256[](1);

        // use destAmounts for comparison, but return the best rate
        BestReserveInfo memory bestReserve;
        bestReserve.numRelevantReserves = 1; // assume always best reserve will be relevant

        // return empty array for unlisted tokens
        if (rates.length == 0) {
            reserveIndexes = new uint256[](0);
            return reserveIndexes;
        }

        uint256[] memory reserveCandidates = new uint256[](rates.length);
        uint256[] memory destAmounts = new uint256[](rates.length);
        uint256 destAmount;

        for (uint256 i = 0; i < rates.length; i++) {
            // if fee is accounted on dest amount of this reserve, should deduct it
            destAmount = (srcAmounts[i] * rates[i] * (BPS - feesAccountedDestBps[i])) / BPS;
            if (destAmount > bestReserve.destAmount) {
                // best rate is highest rate
                bestReserve.destAmount = destAmount;
                bestReserve.index = i;
            }

            destAmounts[i] = destAmount;
        }

        if (bestReserve.destAmount == 0) {
            reserveIndexes[0] = bestReserve.index;
            return reserveIndexes;
        }

        reserveCandidates[0] = bestReserve.index;

        // update best reserve destAmount to be its destAmount after deducting negligible diff.
        // if any reserve has better or equal dest amount it can be considred to be chosen as best
        bestReserve.destAmount = (bestReserve.destAmount * BPS) / (BPS + negligibleRateDiffBps);

        for (uint256 i = 0; i < rates.length; i++) {
            if (i == bestReserve.index) continue;
            if (destAmounts[i] > bestReserve.destAmount) {
                reserveCandidates[bestReserve.numRelevantReserves++] = i;
            }
        }

        if (bestReserve.numRelevantReserves > 1) {
            // when encountering small rate diff from bestRate. draw from relevant reserves
            bestReserve.index = reserveCandidates[uint256(blockhash(block.number - 1)) %
                bestReserve.numRelevantReserves];
        } else {
            bestReserve.index = reserveCandidates[0];
        }

        reserveIndexes[0] = bestReserve.index;
    }

    function getReserveAddress(bytes32 reserveId) internal view override returns (address reserveAddress) {
        (reserveAddress, , , ,) = kyberStorage.getReserveDetailsById(reserveId);
    }

    function areAllReservesListed(
        bytes32[] memory reserveIds,
        IERC20 src,
        IERC20 dest
    ) internal override view returns (bool allReservesListed) {
        (allReservesListed, , ,) = kyberStorage.getReservesData(reserveIds, src, dest);
    }

    /// @notice Logic for masking out reserves
    /// @param allReservesPerToken Array of reserveIds that support
    ///     the token -> eth or eth -> token side of the trade
    /// @param maskedOutReserves Array of reserveIds to be excluded from allReservesPerToken
    /// @return filteredReserves An array of reserveIds that can be used for the trade
    function maskOutReserves(
        bytes32[] memory allReservesPerToken,
        bytes32[] memory maskedOutReserves
    ) internal pure returns (bytes32[] memory filteredReserves) {
        require(
            allReservesPerToken.length >= maskedOutReserves.length,
            "mask out exceeds available reserves"
        );
        filteredReserves = new bytes32[](allReservesPerToken.length - maskedOutReserves.length);
        uint256 currentResultIndex = 0;

        for (uint256 i = 0; i < allReservesPerToken.length; i++) {
            bytes32 reserveId = allReservesPerToken[i];
            bool notMaskedOut = true;

            for (uint256 j = 0; j < maskedOutReserves.length; j++) {
                bytes32 maskedOutReserveId = maskedOutReserves[j];
                if (reserveId == maskedOutReserveId) {
                    notMaskedOut = false;
                    break;
                }
            }

            if (notMaskedOut) filteredReserves[currentResultIndex++] = reserveId;
        }
    }

    function onlyNetwork() internal view {
        require(msg.sender == address(kyberNetwork), "only kyberNetwork");
    }

    function populateSplitValuesBps(uint256 length)
        internal
        pure
        returns (uint256[] memory splitValuesBps)
    {
        splitValuesBps = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            splitValuesBps[i] = BPS;
        }
    }
}