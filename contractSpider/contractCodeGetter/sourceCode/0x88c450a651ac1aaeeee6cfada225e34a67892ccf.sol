/**
 *Submitted for verification at Etherscan.io on 2020-06-30
*/

pragma solidity 0.4.25;

contract ISynth {
    bytes32 public currencyKey;
    function balanceOf(address owner) external view returns (uint);
    function totalSupply() external view returns (uint);
}
contract ISynthetix {
    ISynth[] public availableSynths;
    function availableSynthCount() public view returns (uint);
    function availableCurrencyKeys()
        public
        view
        returns (bytes32[]);
}

contract IExchangeRates {
    function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
    function ratesForCurrencies(bytes32[] currencyKeys) external view returns (uint[] memory);
    function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
    public
    view
    returns (uint);
}

contract SynthSummaryUtil {
    ISynthetix public synthetix;
    IExchangeRates public exchangeRates;
    constructor(address _synthetix, address _exchangeRates) public {
        synthetix = ISynthetix(_synthetix);
        exchangeRates = IExchangeRates(_exchangeRates);
    }

    function totalSynthsInKey(address account, bytes32 currencyKey) external view returns (uint total) {
        uint numSynths = synthetix.availableSynthCount();
        for (uint i = 0; i < numSynths; i++) {
            ISynth synth = synthetix.availableSynths(i);
            total += exchangeRates.effectiveValue(synth.currencyKey(), synth.balanceOf(account), currencyKey);
        }
        return total;
    }

    function synthsBalances(address account) external view returns (bytes32[], uint[],  uint[]) {
        uint numSynths = synthetix.availableSynthCount();
        bytes32[] memory currencyKeys = new bytes32[](numSynths);
        uint[] memory balances = new uint[](numSynths);
        uint[] memory sUSDBalances = new uint[](numSynths);
        for (uint i = 0; i < numSynths; i++) {
            ISynth synth = synthetix.availableSynths(i);
            currencyKeys[i] = synth.currencyKey();
            balances[i] = synth.balanceOf(account);
            sUSDBalances[i] = exchangeRates.effectiveValue(synth.currencyKey(), synth.balanceOf(account), 'sUSD');
        }
        return (currencyKeys, balances, sUSDBalances);
    }

    function frozenSynths() external view returns (bytes32[]) {
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

    function synthsRates() external view returns (bytes32[], uint[]) {
        bytes32[] memory currencyKeys = synthetix.availableCurrencyKeys();
        return (currencyKeys, exchangeRates.ratesForCurrencies(currencyKeys));
    }

    function synthsTotalSupplies()
        external
        view
        returns (bytes32[], uint256[], uint256[])
    {
        uint256 numSynths = synthetix.availableSynthCount();
        bytes32[] memory currencyKeys = new bytes32[](numSynths);
        uint256[] memory balances = new uint256[](numSynths);
        uint256[] memory sUSDBalances = new uint256[](numSynths);
        for (uint256 i = 0; i < numSynths; i++) {
            ISynth synth = synthetix.availableSynths(i);
            currencyKeys[i] = synth.currencyKey();
            balances[i] = synth.totalSupply();
            sUSDBalances[i] = exchangeRates.effectiveValue(
                synth.currencyKey(),
                synth.totalSupply(),
                "sUSD"
            );
        }
        return (currencyKeys, balances, sUSDBalances);
    }
}