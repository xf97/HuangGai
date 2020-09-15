/**
 *Submitted for verification at Etherscan.io on 2020-06-03
*/

/* Discussion:
 * https://dfohub.com/strategy
 */
/* Description:
 * A sustainable economic model for
 * DFO-based Startups to maintain value
 * and funds operations
 * 
 * Abstract:
 * 
 * Voting Tokens of Decentralized Flexible Organizations are real programmable equities of a
 * protocol because the funds locked into a DFO wallet are actually funds in the hand of token
 * holders. DFO funds can be transferred or used only by voting, this opens new and very
 * interesting correlations between Private Equity and Tokens.
 * The core experiment of this paper is to explore how adding new on-chain valuable assets into a
 * DFO wallet can sustain the price of its voting tokens.
 * In a traditional company, if new assets are added to the Company funds (without any increase
 * of debts) the evaluation of its equities is backed by the value of these assets. This is because
 * equities holders have the power to manage these assets.
 * This basic rule can be applied to Decentralized Flexible Organizations because if funds are
 * added to a DFO wallet, Token Holders are the only ruler of these funds.
 * This is a basic design decision of The DFO core protocol, because thanks to its Smart contracts,
 * nobody can make actions outside of a public proposal voted by token holders.
 * 
 * The experiment:
 * 
 * Thanks to the Uniswap math design:
 * 
 * x * y = k. **
 * 
 * **Explained by Decrypt.co
 * In the equation, x and y represent the quantity of ETH and ERC20 tokens available in a liquidity pool and k is a
 * constant value. This equation uses the balance between the ETH and ERC20 tokens–and supply and demand–to
 * determine the price of a particular token. Whenever someone buys Poop Token with ETH, the supply of Poop Token
 * decreases while the supply of ETH increases–the price of Poop Token goes up. As a result, the price of tokens on
 * Uniswap can only change if trades occur. Essentially what Uniswap is doing it balancing out the value of tokens, and
 * the swapping of them based on how much people want to buy and sell them.
 * 
 * A Flexible Organization can sustain its operation by a fixed Circulated Supply inflation using the
 * uniswap protocol, by adding new values into the DFO Wallet:
 * 
 * Example:
 * 
 * A DFO named “Flexible” with a Voting Token named “FLX”
 * ● FLX Total Supply = 1.000.000 FLX
 * ● Flexible DFO Wallet = 800.000 FLX (80%)
 * ● FLX Circulating Supply = 200.000 FLX (20%)
 * With a Smart Contract based proposal, Flexible Token holders decide to step by step inflate the
 * circulating supply for a total of 5% during a period of a year and a half by selling a fixed number
 * of FLX once a week (~ 50.400 Ethereum Blocks @ 12 sec for a block for 80 times)
 * In this case, the Flexible DFO will sell in total 50.000 FLX on the Uniswap protocol at the ratio of
 * 625 FLX every 50.400 Blocks, increasing the circulating supply by the 0,0625%
 * (In this experiment technically the FLX backed value is already settled by the 800.000 FLX into the Flexible DFO
 * Wallet, but because the FLX is at the same time the Voting Token, we don’t count its value in this equation.)
 * Every FLX Inflation event will add new ETH to the Flexible DFO wallet, adding new backed
 * assets.
 * For example, after the first selling event the new status of the Flexible DFO Wallet will be:
 * 
 * 799375 FLX + Z ETH ***
 * 
 * ***(Z is equal to an amount of ETH depending on the ratio of ETH/FLX into the Uniswap Pool)
 * 
 * Now Z ETH is the minimum backed value of the Flexible DFO Wallet and consequently the FLX
 * Market cap because FLX Token Holders are the only people who can manage these funds, like
 * Equity Holders in a Company.
 * Every Selling Event the Uniswap Pool reaches very little inflation but at the same time this
 * selling benefits every FLX Holders.
 * If the DFO Voting Token Holders will use every week an amount < of the 100% of the Z ETH
 * funds reached, the project can pay operations and at the same time accumulate backed value
 * to benefit every token holder.
 * 
 * The DFOhub Experiment:
 * 
 * We want to do this experiment for three fundamental reasons:
 * 
 * 1) Empiric data about the correlation from Programmable Equities (DFO based Voting
 * Tokens) to Regular Equities that can open an infinite number of questions and business
 * opportunities for the dapps of tomorrow (DFO based)
 * 2) R&D and introduce these standardized Smart Contracts as optional basic functions for
 * every DFO via voting
 * 3) Sustain our operations and at the same time to build a minimum backed valorization for
 * BUIDL holders.
 * The Economics behind BUIDL is based on the Business Model of the General Purpose Protocol
 * DFO. Every time someone creates a new Decentralized Flexible Organization, a % of the new
 * DFO’s new Voting Tokens is added to the DFOhub Wallet. The DFOhub Wallet is managed only
 * by voting from the BUIDL holders, making assets into the DFOhub wallet the backed value of
 * BUIDL.
 * 
 * DFOhub Experiment in numbers:
 * ● BUIDL Total Supply = 42.000.000 BUIDL
 * ● DFOhub DFO Wallet = 11.500.000 BUIDL (27.3%)
 * ● DFOhub Team Operations Wallet = 11.500.000 BUIDL (27.3%)
 * ● BUIDL Circulating Supply = 2.200.000 BUIDL (5.2%)
 * 
 * With a Smart Contract based proposal, DFOhub will step by step inflate the circulating supply of
 * BUIDL for a total of 0.8% during a period of a year and a half by selling a fixed number of BUIDL
 * once every two weeks (~ 100.800 Ethereum Blocks @ 12 sec for a block for 40 times)
 * At the same time, the DFOhub Team Operations Wallet will step by step inflate the circulating
 * supply of BUIDL for a total of 0.8% during a period of a year and a half by selling a fixed number
 * of BUIDL once every two weeks (~ 100.800 Ethereum Blocks @ 12 sec for a block for 40 times)
 * These two Smart Contracts will inflate the circulation supply of a total of 1.6% (672.000 BUIDL)
 * in a year and a half. The funds will be inflated into 3 different Uniswap Pools:
 * 25% Uniswap V1 ETH/BUIDL | 0.4% (168.000 BUIDL)
 * 25% Uniswap V2 ETH/BUIDL | 0.4% (168.000 BUIDL)
 * 50% Uniswap V2 USDC/BUIDL | 0.8% Inflation (336.000 BUIDL)
 * During every Selling Event, the Circulating supply of BUIDL will increase by 0.02% (8.400
 * BUIDL) and will be split into:
 * 25% Uniswap V1 ETH/BUIDL | 0.005% (2.100 BUIDL)
 * 25% Uniswap V2 ETH/BUIDL | 0.005% (2.100 BUIDL)
 * 50% Uniswap V2 USDC/BUIDL | 0.01% Inflation (4.200 BUIDL)
 * Conclusion:
 * 
 * Every Two weeks these funds will create values for BUIDL holders in two different ways:
 * 1. From the DFOhub Wallet: Z ETH and Z USDC will be automatically added to the
 * DFOhub wallet as a backed value for BUIDL holders.
 * 2. From the DFOhub Team Operations Wallet, these funds will be used to accelerate the
 * R&D into new DFOhub Functionalities, Marketing, and Community Rewards. These
 * Operations will benefit all of the BUIDL holders accelerating the advancement of the
 * protocol and its usage, so more DFO's Voting Tokens into the DFOhub Wallet as a
 * backed value for BUIDL holders.
 * 
 * All of the functionalities related to this R&D will become available for every DFO as Optional
 * Basic Functionalities, to accelerate the exploration of Programmable Equities R&D.
 */
pragma solidity ^0.6.0;

contract FairInflationFunctionality {

    function onStart(address,address) public {
        IMVDProxy proxy = IMVDProxy(msg.sender);

        address tokenToSwapAddress = 0xD6F0Bb2A45110f819e908a915237D652Ac7c5AA8;
        address uniswapV1ExchangeAddress = 0xFE3eB37C105800842001F759d295eCFb2158A4Cb;
        address uniswapV2RouterAddress = 0xf164fC0Ec4E93095b804a4795bBe1e041497b92a;
        address uSDCTokenAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        uint256 swapBlockLimit = 100800;
        uint256 totalSwapTimes = 40;
        uint256 tokenAmountToSwapForEtherInV1 = 2100000000000000000000;
        uint256 tokenAmountToSwapForEtherInV2 = 2100000000000000000000;
        uint256 tokenAmountToSwapForUSDCInV2 = 4200000000000000000000;

        IStateHolder stateHolder = IStateHolder(proxy.getStateHolderAddress());
        stateHolder.setAddress("tokenToSwapAddress", tokenToSwapAddress);
        stateHolder.setAddress("uniswapV1ExchangeAddress", uniswapV1ExchangeAddress);
        stateHolder.setAddress("uniswapV2RouterAddress", uniswapV2RouterAddress);
        stateHolder.setAddress("uSDCTokenAddress", uSDCTokenAddress);
        stateHolder.setUint256("swapBlockLimit", swapBlockLimit);
        stateHolder.setUint256("totalSwapTimes", totalSwapTimes);
        stateHolder.setUint256("tokenAmountToSwapForEtherInV1", tokenAmountToSwapForEtherInV1);
        stateHolder.setUint256("tokenAmountToSwapForEtherInV2", tokenAmountToSwapForEtherInV2);
        stateHolder.setUint256("tokenAmountToSwapForUSDCInV2", tokenAmountToSwapForUSDCInV2);
    }

    function onStop(address) public {
        IStateHolder stateHolder = IStateHolder(IMVDProxy(msg.sender).getStateHolderAddress());
        stateHolder.clear("tokenToSwapAddress");
        stateHolder.clear("uniswapV1ExchangeAddress");
        stateHolder.clear("uniswapV2RouterAddress");
        stateHolder.clear("uSDCTokenAddress");
        stateHolder.clear("swapBlockLimit");
        stateHolder.clear("totalSwapTimes");
        stateHolder.clear("tokenAmountToSwapForEtherInV1");
        stateHolder.clear("tokenAmountToSwapForEtherInV2");
        stateHolder.clear("tokenAmountToSwapForUSDCInV2");
        stateHolder.clear("lastSwapBlock");
        stateHolder.clear("swapTimes");
    }

    function fairInflation() public {
        IMVDProxy proxy = IMVDProxy(msg.sender);
        IStateHolder stateHolder = IStateHolder(proxy.getStateHolderAddress());

        uint256 swapTimes = stateHolder.getUint256("swapTimes");
        require(swapTimes < stateHolder.getUint256("totalSwapTimes"), "Total swap times reached");
        stateHolder.setUint256("swapTimes", swapTimes + 1);

        require(block.number >= (stateHolder.getUint256("lastSwapBlock") + stateHolder.getUint256("swapBlockLimit")), "Too early to swap new Tokens!");
        stateHolder.setUint256("lastSwapBlock", block.number);

        address dfoWalletAddress = proxy.getMVDWalletAddress();
        IERC20 tokenToSwap = IERC20(stateHolder.getAddress("tokenToSwapAddress"));

        uint256 tokenAmountToSwapForEtherInV1 = stateHolder.getUint256("tokenAmountToSwapForEtherInV1");
        uint256 tokenAmountToSwapForEtherInV2 = stateHolder.getUint256("tokenAmountToSwapForEtherInV2");
        uint256 tokenAmountToSwapForUSDCInV2 = stateHolder.getUint256("tokenAmountToSwapForUSDCInV2");

        proxy.transfer(address(this), tokenAmountToSwapForEtherInV1 + tokenAmountToSwapForEtherInV2 + tokenAmountToSwapForUSDCInV2, address(tokenToSwap));

        uniswapV1(stateHolder,tokenAmountToSwapForEtherInV1, tokenToSwap, dfoWalletAddress);
        uniswapV2(stateHolder, tokenAmountToSwapForEtherInV2, tokenAmountToSwapForUSDCInV2, tokenToSwap, dfoWalletAddress);
    }

    function uniswapV1(IStateHolder stateHolder, uint256 tokenAmountToSwapForEtherInV1, IERC20 tokenToSwap, address dfoWalletAddress) private {
        if(tokenAmountToSwapForEtherInV1 <= 0) {
            return;
        }
        IUniswapV1Exchange uniswapV1Exchange = IUniswapV1Exchange(stateHolder.getAddress("uniswapV1ExchangeAddress"));
        if(tokenToSwap.allowance(address(this), address(uniswapV1Exchange)) == 0) {
            tokenToSwap.approve(address(uniswapV1Exchange), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        }
        uniswapV1Exchange.tokenToEthTransferInput(tokenAmountToSwapForEtherInV1, uniswapV1Exchange.getTokenToEthInputPrice(tokenAmountToSwapForEtherInV1), block.timestamp + 1000, dfoWalletAddress);
    }

    function uniswapV2(IStateHolder stateHolder, uint256 tokenAmountToSwapForEtherInV2, uint256 tokenAmountToSwapForUSDCInV2, IERC20 tokenToSwap, address dfoWalletAddress) private {
        if(tokenAmountToSwapForEtherInV2 <= 0 && tokenAmountToSwapForUSDCInV2 <= 0) {
            return;
        }
        IUniswapV2Router uniswapV2Router = IUniswapV2Router(stateHolder.getAddress("uniswapV2RouterAddress"));
        if(tokenToSwap.allowance(address(this), address(uniswapV2Router)) == 0) {
            tokenToSwap.approve(address(uniswapV2Router), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        }

        address[] memory path = new address[](2);
        path[0] = address(tokenToSwap);
        if(tokenAmountToSwapForEtherInV2 > 0) {
            path[1] = uniswapV2Router.WETH();
            uniswapV2Router.swapExactTokensForETH(tokenAmountToSwapForEtherInV2, uniswapV2Router.getAmountsOut(tokenAmountToSwapForEtherInV2, path)[1], path, dfoWalletAddress, block.timestamp + 1000);
        }

        if(tokenAmountToSwapForUSDCInV2 > 0) {
            path[1] = stateHolder.getAddress("uSDCTokenAddress");
            uniswapV2Router.swapExactTokensForTokens(tokenAmountToSwapForUSDCInV2, uniswapV2Router.getAmountsOut(tokenAmountToSwapForUSDCInV2, path)[1], path, dfoWalletAddress, block.timestamp + 1000);
        }
    }
}

interface IUniswapV1Exchange {
    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
}

interface IUniswapV2Router {
    function WETH() external pure returns (address);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
}

interface IMVDProxy {
    function getToken() external view returns(address);
    function getStateHolderAddress() external view returns(address);
    function getMVDWalletAddress() external view returns(address);
    function transfer(address receiver, uint256 value, address token) external;
}

interface IStateHolder {
    function setUint256(string calldata name, uint256 value) external returns(uint256);
    function getUint256(string calldata name) external view returns(uint256);
    function getAddress(string calldata name) external view returns(address);
    function setAddress(string calldata varName, address val) external returns (address);
    function clear(string calldata varName) external returns(string memory oldDataType, bytes memory oldVal);
}

interface IERC20 {
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}