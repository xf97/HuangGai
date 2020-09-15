/**
 *Submitted for verification at Etherscan.io on 2020-07-01
*/

pragma solidity ^0.5.16;

interface ISynth {
    function currencyKey() external view returns (bytes32);
    function balanceOf(address owner) external view returns (uint);
    function totalSupply() external view returns (uint);
}

interface ISynthetix {
    function availableSynths(uint index) external view returns (ISynth);
    function availableSynthCount() external view returns (uint);
    function availableCurrencyKeys() external view returns (bytes32[] memory);
}

interface IExchangeRates {
    function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
    function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
    function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
    external
    view
    returns (uint);
}

interface IAddressResolver {
    function getAddress(bytes32 name) external view returns (address);
    function getSynth(bytes32 key) external view returns (address);
    function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
}

contract SynthSummaryUtil {

    IAddressResolver public addressResolverProxy;

    bytes32 internal constant CONTRACT_SYNTHETIX = "Synthetix";
    bytes32 internal constant CONTRACT_EXRATES = "ExchangeRates";
    bytes32 internal constant SUSD = "sUSD";

    constructor(address resolver) public {
        addressResolverProxy = IAddressResolver(resolver);
    }

    function _synthetix() internal view returns (ISynthetix) {
        return ISynthetix(addressResolverProxy.requireAndGetAddress(CONTRACT_SYNTHETIX, "Missing Synthetix address"));
    }

    function _exchangeRates() internal view returns (IExchangeRates) {
        return IExchangeRates(addressResolverProxy.requireAndGetAddress(CONTRACT_EXRATES, "Missing ExchangeRates address"));
    }

    function totalSynthsInKey(address account, bytes32 currencyKey) external view returns (uint total) {
        ISynthetix synthetix = _synthetix();
        IExchangeRates exchangeRates = _exchangeRates();
        uint numSynths = synthetix.availableSynthCount();
        for (uint i = 0; i < numSynths; i++) {
            ISynth synth = synthetix.availableSynths(i);
            total += exchangeRates.effectiveValue(synth.currencyKey(), synth.balanceOf(account), currencyKey);
        }
        return total;
    }

    function synthsBalances(address account) external view returns (bytes32[] memory, uint[] memory,  uint[] memory) {
        ISynthetix synthetix = _synthetix();
        IExchangeRates exchangeRates = _exchangeRates();
        uint numSynths = synthetix.availableSynthCount();
        bytes32[] memory currencyKeys = new bytes32[](numSynths);
        uint[] memory balances = new uint[](numSynths);
        uint[] memory sUSDBalances = new uint[](numSynths);
        for (uint i = 0; i < numSynths; i++) {
            ISynth synth = synthetix.availableSynths(i);
            currencyKeys[i] = synth.currencyKey();
            balances[i] = synth.balanceOf(account);
            sUSDBalances[i] = exchangeRates.effectiveValue(currencyKeys[i], balances[i], SUSD);
        }
        return (currencyKeys, balances, sUSDBalances);
    }

    function frozenSynths() external view returns (bytes32[] memory) {
        ISynthetix synthetix = _synthetix();
        IExchangeRates exchangeRates = _exchangeRates();
        uint numSynths = synthetix.availableSynthCount();
        bytes32[] memory frozenSynthsKeys = new bytes32[](numSynths);
        for (uint i = 0; i < numSynths; i++) {
            ISynth synth = synthetix.availableSynths(i);
            if (exchangeRates.rateIsFrozen(synth.currencyKey())) {
                frozenSynthsKeys[i] = synth.currencyKey();
            }

        }
        return frozenSynthsKeys;
    }

    function synthsRates() external view returns (bytes32[] memory, uint[] memory) {
        bytes32[] memory currencyKeys = _synthetix().availableCurrencyKeys();
        return (currencyKeys, _exchangeRates().ratesForCurrencies(currencyKeys));
    }

    function synthsTotalSupplies()
        external
        view
        returns (bytes32[] memory, uint256[] memory, uint256[] memory)
    {
        ISynthetix synthetix = _synthetix();
        IExchangeRates exchangeRates = _exchangeRates();

        uint256 numSynths = synthetix.availableSynthCount();
        bytes32[] memory currencyKeys = new bytes32[](numSynths);
        uint256[] memory balances = new uint256[](numSynths);
        uint256[] memory sUSDBalances = new uint256[](numSynths);
        for (uint256 i = 0; i < numSynths; i++) {
            ISynth synth = synthetix.availableSynths(i);
            currencyKeys[i] = synth.currencyKey();
            balances[i] = synth.totalSupply();
            sUSDBalances[i] = exchangeRates.effectiveValue(
                currencyKeys[i],
                balances[i],
                SUSD
            );
        }
        return (currencyKeys, balances, sUSDBalances);
    }
}