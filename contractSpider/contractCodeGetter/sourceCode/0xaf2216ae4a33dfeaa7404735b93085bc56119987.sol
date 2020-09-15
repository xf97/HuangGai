/**
 *Submitted for verification at Etherscan.io on 2020-07-08
*/

/* Discussion:
 * https://github.com/b-u-i-d-l/fair-inflation-v2
 */
/* Description:
 * A more sustainable economic model for DFO-based Startups to maintain value and funds operations
 * AleToschi.eth | Vasapower.eth | CD
 * 
 * White Paper: https://docs.google.com/document/d/1-foU-XTlXS0WgH97IOVC1i-O_WsKeqc-FVL5x9RR7WY/edit?usp=sharing
 * 
 * Document Purpose:
 * This document is an update of “A sustainable economic model for DFO-based Startups to maintain value and funds operations” https://drive.google.com/file/d/1_QZr5CjNsQKGxoJ5WkI9iPJGs4PdKWol/ We successfully renamed this mechanism “Fair Inflation V1” (FI V1). During the experimentation of the Fair Inflation V1, the DFOhub Team Researched and Developed a better and more resilient version of the “Fair Inflation V1” called “Fair Inflation V2” (FI V2).
 * 
 * Fair Inflation V1 - White Paper
 * FI V1 - Abstract:
 * Voting Tokens of Decentralized Flexible Organizations are real programmable equities of a protocol because the funds locked into a DFO wallet are actually funds in the hand of token holders. DFO funds can be transferred or used only by voting, this opens new and very interesting correlations between Private Equity and Tokens.
 * 
 * The core experiment of this paper is to explore how adding new on-chain valuable assets into a DFO wallet can sustain the price of its voting tokens.
 * 
 * In a traditional company, if new assets are added to the Company funds (without any increase of debts) the evaluation of its equities is backed by the value of these assets. This is because equities holders have the power to manage these assets.
 * 
 * This basic rule can be applied to Decentralized Flexible Organizations because if funds are added to a DFO wallet, Token Holders are the only ruler of these funds. This is a basic design decision of The DFO core protocol, because thanks to its Smart contracts, nobody can make actions outside of a public proposal voted by token holders.
 * 
 * FI V1 - The experiment:
 * Thanks to the Uniswap math design:
 * 
 * x * y = k. **
 * 
 * **Explained by Decrypt.co In the equation, x and y represent the quantity of ETH and ERC20 tokens available in a liquidity pool and k is a constant value. This equation uses the balance between the ETH and ERC20 tokens–and supply and demand–to determine the price of a particular token. Whenever someone buys Poop Token with ETH, the supply of Poop Token decreases while the supply of ETH increases–the price of Poop Token goes up. As a result, the price of tokens on Uniswap can only change if trades occur. Essentially what Uniswap is doing it balancing out the value of tokens, and the swapping of them based on how much people want to buy and sell them.
 * 
 * A Flexible Organization can sustain its operation by a fixed Circulated Supply inflation using the uniswap protocol, by adding new values into the DFO Wallet:
 * 
 * FI V1 - Example:
 * A DFO named “Flexible” with a Voting Token named “FLX”
 * 
 * FLX Total Supply = 1.000.000 FLX Flexible DFO Wallet = 800.000 FLX (80%) FLX Circulating Supply = 200.000 FLX (20%)
 * 
 * With a Smart Contract based proposal, Flexible Token holders decide to step by step inflate the circulating supply for a total of 5% during a period of a year and a half by selling a fixed number of FLX once a week (~ 50.400 Ethereum Blocks @ 12 sec for a block for 80 times)
 * 
 * In this case, the Flexible DFO will sell in total 50.000 FLX on the Uniswap protocol at the ratio of 625 FLX every 50.400 Blocks, increasing the circulating supply by the 0,0625%
 * 
 * (In this experiment technically the FLX backed value is already settled by the 800.000 FLX into the Flexible DFO Wallet, but because the FLX is at the same time the Voting Token, we don’t count its value in this equation.)
 * 
 * Every FLX Inflation event will add new ETH to the Flexible DFO wallet, adding new backed assets.
 * 
 * For example, after the first selling event the new status of the Flexible DFO Wallet will be:
 * 
 * 799375 FLX + Z ETH ***
 * 
 * ***(Z is equal to an amount of ETH depending on the ratio of ETH/FLX into the Uniswap Pool)
 * 
 * Now Z ETH is the minimum backed value of the Flexible DFO Wallet and consequently the FLX Market cap because FLX Token Holders are the only people who can manage these funds, like Equity Holders in a Company.
 * 
 * Every Selling Event the Uniswap Pool reaches very little inflation but at the same time this selling benefits every FLX Holders.
 * 
 * If the DFO Voting Token Holders will use every week an amount < of the 100% of the Z ETH funds reached, the project can pay operations and at the same time accumulate backed value to benefit every token holder.
 * 
 * FI V1 - The DFOhub Experiment:
 * We want to do this experiment for three fundamental reasons:
 * 
 * Empiric data about the correlation from Programmable Equities (DFO based Voting Tokens) to Regular Equities that can open an infinite number of questions and business opportunities for the dapps of tomorrow (DFO based) R&D and introduce these standardized Smart Contracts as optional basic functions for every DFO via voting Sustain our operations and at the same time to build a minimum backed valorization for BUIDL holders.
 * 
 * The Economics behind BUIDL is based on the Business Model of the General Purpose Protocol DFO. Every time someone creates a new Decentralized Flexible Organization, a % of the new DFO’s new Voting Tokens is added to the DFOhub Wallet. The DFOhub Wallet is managed only by voting from the BUIDL holders, making assets into the DFOhub wallet the backed value of BUIDL.
 * 
 * FI V1 - DFOhub Experiment in numbers:
 * BUIDL Total Supply = 42.000.000 BUIDL DFOhub DFO Wallet = 11.500.000 BUIDL (27.3%) DFOhub Team Operations Wallet = 11.500.000 BUIDL (27.3%) BUIDL Circulating Supply = 2.200.000 BUIDL (5.2%)
 * 
 * With a Smart Contract based proposal, DFOhub will step by step inflate the circulating supply of BUIDL for a total of 0.8% during a period of a year and a half by selling a fixed number of BUIDL once every two weeks (~ 100.800 Ethereum Blocks @ 12 sec for a block for 40 times)
 * 
 * At the same time, the DFOhub Team Operations Wallet will step by step inflate the circulating supply of BUIDL for a total of 0.8% during a period of a year and a half by selling a fixed number of BUIDL once every two weeks (~ 100.800 Ethereum Blocks @ 12 sec for a block for 40 times)
 * 
 * These two Smart Contracts will inflate the circulation supply of a total of 1.6% (672.000 BUIDL) in a year and a half. The funds will be inflated into 3 different Uniswap Pools:
 * 
 * 25% Uniswap V1 ETH/BUIDL | 0.4% (168.000 BUIDL) 25% Uniswap V2 ETH/BUIDL | 0.4% (168.000 BUIDL) 50% Uniswap V2 USDC/BUIDL | 0.8% Inflation (336.000 BUIDL)
 * 
 * During every Selling Event, the Circulating supply of BUIDL will increase by 0.02% (8.400 BUIDL) and will be split into:
 * 
 * 25% Uniswap V1 ETH/BUIDL | 0.005% (2.100 BUIDL) 25% Uniswap V2 ETH/BUIDL | 0.005% (2.100 BUIDL) 50% Uniswap V2 USDC/BUIDL | 0.01% Inflation (4.200 BUIDL)
 * 
 * FI V1 - Conclusion:
 * Every Two weeks these funds will create values for BUIDL holders in two different ways:
 * 
 * From the DFOhub Wallet: Z ETH and Z USDC will be automatically added to the DFOhub wallet as a backed value for BUIDL holders. From the DFOhub Team Operations Wallet, these funds will be used to accelerate the R&D into new DFOhub Functionalities, Marketing, and Community Rewards. These Operations will benefit all of the BUIDL holders accelerating the advancement of the protocol and its usage, so more DFO's Voting Tokens into the DFOhub Wallet as a backed value for BUIDL holders.
 * 
 * All of the functionalities related to this R&D will become available for every DFO as Optional Basic Functionalities, to accelerate the exploration of Programmable Equities R&D.
 * 
 * Fair Inflation V2 - White Paper Update:
 * FI V2 - Abstract:
 * The “Fair Inflation V1” experiment was a success during the first month both in terms of equity between funds for operations and backed funds for BUIDL holders.
 * 
 * You can check the three FI events here:
 * 
 * https://etherscan.io/tx/0x68ef31cc8cff2929295fbd0b84187eb70b59bd1f8efb069f1bd9ed06fe817a15 (DFOhub) https://etherscan.io/tx/0xe31d9eab9527e2a0299b80efc86ee013a0915825aac103246eccfaeddb95d822 (Operation Funds) https://etherscan.io/tx/0xfdc2ab2be2ac2d46f37e520217f6b1ce10c4203ab5d56c512d743878d93f6872 (DFOhub) https://etherscan.io/tx/0xdbf65b725d1d37750f67f6a1801c3cd38121fe676a414576d8ef5c5a19079f46 (Operation Funds)
 * 
 * The “Fair Inflation V1” experiment highlighted three unaddressed points of failure:
 * 
 * Slippage: The Uniswap Slippage is selling 8.400 BUIDL at an untoward price. This can be a problem for DFO-based Startups with less liquidity than BUIDL Dump: The 8400 BUIDL selling created a short dump in the market. This system can be attacked by speculators if they sell BUIDL just before the Fair Inflation event. This kind of attack can harm both BUIDL holders and the team.
 * 
 * FI V2 - The Experiment:
 * The “Fair Inflation V2” experiment aims to solve both the Slippage and the Dump problems by transforming weekly inflation events into daily inflation events without changing the quantity of Inflated tokens during the year and a half experiment.
 * 
 * In the “Fair Inflation V1” Every Week the circulating supply of BUIDL is inflated by 8.400 BUIDL for a total of 672.000 BUIDL after 80 weekly events into 3 Uniswap Pools (25% in ETH/BUIDL V1, 25% in ETH/BUIDL V2 and 50% in USDC/BUIDL V2).
 * 
 * In the “Fair Inflation V2” the same amount of BUIDL will be inflated in the same amount of time, but splitted into more inflation events and used to reward liquidity providers to Uniswap pools.
 * 
 * FI V2 - The DFOhub (BUIDL) Experiment:
 * DFOhub (https://etherscan.io/tokenHoldings?a=0x5D40c724ba3e7Ffa6a91db223368977C522BdACD) will step by step inflate the circulating supply of BUIDL for a total of 336.000 during a period of a year and a half splitted in 560 daily Inflation Events (6.300 Ethereum Blocks)
 * 
 * This Smart Contract will inflate the circulation supply of a total of 336.000 BUIDL in a year and a half. The funds will be both inflated into 3 different Uniswap Pools and lock them to reward liquidity pool providers :
 * 
 * 30% Uniswap V2 ETH/BUIDL (100.800 BUIDL)
 * 
 * 30% Uniswap V2 USDC/BUIDL (100.800 BUIDL)
 * 
 * 10% Uniswap V2 ARTE/BUIDL (33.600 BUIDL)
 * 
 * 30% Rewards for Liquidity Providers (100.800 BUIDL)
 * 
 * During every Selling Event, the Circulating supply of BUIDL will increase by 600 BUIDL and will be split into:
 * 
 * 30% Uniswap V2 ETH/BUIDL (180 BUIDL)
 * 
 * 30% Uniswap V2 USDC/BUIDL (180 BUIDL)
 * 
 * 10% Uniswap V2 ARTE/BUIDL (60 BUIDL)
 * 
 * 30% Rewards for Liquidity Providers (180 BUIDL)
 * 
 * At the same time, the DFOhub Team Operations Wallet (https://etherscan.io/tokenHoldings?a=0x25756f9C2cCeaCd787260b001F224159aB9fB97A) will step by step inflate the circulating supply of BUIDL for a total of 336.000 BUIDL during a period of a year and a half splitted in 560 daily Inflation Events (6.300 Ethereum Blocks)
 * 
 * This Smart Contract will inflate the circulation supply of a total of 336.000 BUIDL in a year and a half. The funds will be both inflated into 3 different Uniswap Pools:
 * 
 * 50% Uniswap V2 ETH/BUIDL (168.000 BUIDL)
 * 
 * 50% Uniswap V2 USDC/BUIDL (168.000 BUIDL)
 * 
 * During every Selling Event, the Circulating supply of BUIDL will increase by 600 BUIDL and will be split into:
 * 
 * 50% Uniswap V2 ETH/BUIDL (300 BUIDL)
 * 
 * 50% Uniswap V2 USDC/BUIDL (300 BUIDL)
 * 
 * These two Smart Contracts will inflate the circulation supply of a total of 672.000 BUIDL in a year and a half.
 * 
 * The DFOhub FI and the Operation FI will occur at ~ 12 hours apart (3.150 Ethereum Blocks).
 * 
 * FI V2 - The Liquidity Staking Reward Experiment:
 * Liquidity Providers will be rewarded by the fair inflation based on the duration of locked liquidity. The total amount of BUIDL available every 24 hours is 180 and automatically are splitted to reward liquidity providers based on locked BUIDL stacked as a liquidity for BUIDL/ETH and BUIDL/USDC in Uniswap V2.
 * 
 * The Reward is based on 4 tier:
 * 
 * 1 Month: 10% daily (18 BUIDL) for a total of 540 BUIDL every month splitted from holders that lock liquidity for a month. The ratio is 1:0.01 BUIDL for every BUIDL stacked. The total amount of BUIDL stackable is 54.000.
 * 
 * 3 Months: 20% daily (36 BUIDL) for a total of 3.240 BUIDL every three months splitted from holders that lock liquidity for three months. The ratio is 1:0.05 BUIDL for every BUIDL stacked. The total amount of BUIDL stackable is 60.480.
 * 
 * 6 Months: 30% daily (54 BUIDL) for a total of 9.720 BUIDL every six months splitted from holders that lock liquidity for six months. The ratio is 1:0.2 BUIDL for every BUIDL stacked. The total amount of BUIDL stackable is 48.600.
 * 
 * 1 Year: 40% daily (72 BUIDL) for a total of 25.920 BUIDL every year splitted from holders that lock liquidity for one year. The ratio is 1:0.5 BUIDL for every BUIDL stacked. The total amount of BUIDL stackable is 51.840.
 * 
 * Examples:
 * 
 * A BUIDL holder stake 5000 BUIDL for a month by adding to the Uniswap liquidity 5000 BUIDL and the equivalent of ETH in the BUIDL/ETH pool via the DFOhub Staking GUI. At the end of the month the holders will be able to withdraw its liquidity (at the current rate) + 50 BUIDL + the Uniswap trading fees earned.
 * 
 * A BUIDL holder stake 5000 BUIDL for three months by adding to the Uniswap liquidity 5000 BUIDL and the equivalent of ETH in the BUIDL/ETH pool via the DFOhub Staking GUI. At the end of the selected period the holder will be able to withdraw its liquidity (at the current rate) + 250 BUIDL + the Uniswap trading fees earned.
 * 
 * A BUIDL holder stake 5000 BUIDL for six months by adding to the Uniswap liquidity 5000 BUIDL and the equivalent of ETH in the BUIDL/ETH pool via the DFOhub Staking GUI. At the end of the selected period the holder will be able to withdraw its liquidity (at the current rate) + 1.000 BUIDL + the Uniswap trading fees earned.
 * 
 * A BUIDL holder stake 5000 BUIDL for one year by adding to the Uniswap liquidity 5000 BUIDL and the equivalent of ETH in the BUIDL/ETH pool via the DFOhub Staking GUI. At the end of the selected period the holder will be able to withdraw its liquidity (at the current rate) + 2.500 BUIDL + the Uniswap trading fees earned.
 * 
 * During every Fair Inflation event, if the amount of FI token moved from the DFOhub wallet is more than the number of tokens used to reward stakers, the excess BUIDL will return to the DFOhub wallet.
 * 
 * FI V2 - The ethart (ARTE) Experiment:
 * Ethart Fair Inflation V1
 * (https://github.com/b-u-i-d-l/ethArt): A sustainable economic model for DFO-based startups to maintain value and fund operations | ethArt version For the $ARTE experiment, we will inflate the circulating supply by 1.21% (121,000) of the total supply (10,000,000) over one year..
 * 
 * Inflation events will occur once a week (every 50,000 ETH Blocks) across two Uniswap pairs for a total of 2,200 $ARTE each time:
 * 
 * Uniswap V2 $ETH/$ARTE (1,100 $ARTE Every Week) 0.01% Weekly Inflation
 * Uniswap V2 $BUIDL/$ARTE (1,100 $ARTE Every Week) 0.01% Weekly Inflation
 * For a total of 2,200 $ARTE every week (0.02%)
 * 
 * Ethart Fair Inflation V2:
 * From the DFOhub Team Operations Wallet (https://etherscan.io/tokenHoldings?a=0x25756f9C2cCeaCd787260b001F224159aB9fB97A)
 * 
 * Inflation events will occur once a day (every 6,300 ETH Blocks) across two Uniswap pairs for a total of 314 $ARTE each time:
 * 
 * Uniswap V2 $ETH/$ARTE (157 $ARTE Every Day)
 * 
 * Uniswap V2 $BUIDL/$ARTE (157 $ARTE Every Day)
 * 
 * For a total of 314 $ARTE every day
 * 
 * All of the functionalities related to this R&D will become available for every DFO as Optional Basic Functionalities, to accelerate the exploration of Programmable Equities R&D.
 */
pragma solidity ^0.6.0;

contract NERVFairInflationV2 {

    //Functionality Set-UP
    //This mandatory method is called by the proxy just after the proposal finalization.
    //It sets-up all the stuff to let this functionality work properly
    function onStart(address,address) public {
        //The Proxy is the main Contract of the DFO Protocol
        IMVDProxy proxy = IMVDProxy(msg.sender);

        //The buidl token address, needed for the swap operations
        address buidlTokenAddress = 0x7b123f53421b1bF8533339BFBdc7C98aA94163db;

        //The ARTE token address, needed for the swap operations
        address arteTokenAddress = 0x44b6e3e85561ce054aB13Affa0773358D795D36D;

        //The well-nown USDC Contract Token
        address uSDCTokenAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

        //The Smart Contract Address to locate the Uniswap V2 Exchanges
        address uniswapV2RouterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

        //When I can call this Function? Every day (expressed in Ethereum Blocks)
        uint256 swapBlockLimit = 6300;

        //How many buidl tokens to swap for ETH in UniswapV2 every day? 300
        uint256 buidlAmountToSwapForEtherInV2 = 300000000000000000000;

        //How many buidl tokens to swap for USDC in UniswapV2 every day? 300
        uint256 buidlAmountToSwapForUSDCInV2 = 300000000000000000000;

        //How many ARTE tokens to swap for ETH in UniswapV2 every day? 157
        uint256 arteAmountToSwapForEtherInV2 = 157000000000000000000;

        //How many ARTE tokens to swap for buidl in UniswapV2 every day? 157
        uint256 arteAmountToSwapForBuidlInV2 = 157000000000000000000;

        //StateHolder is the Database of every DFO, so let's store all the above stuff
        IStateHolder stateHolder = IStateHolder(proxy.getStateHolderAddress());
        stateHolder.setAddress("buidlTokenAddress", buidlTokenAddress);
        stateHolder.setAddress("arteTokenAddress", arteTokenAddress);
        stateHolder.setAddress("uSDCTokenAddress", uSDCTokenAddress);
        stateHolder.setAddress("uniswapV2RouterAddress", uniswapV2RouterAddress);
        stateHolder.setUint256("swapBlockLimit", swapBlockLimit);
        stateHolder.setUint256("buidlAmountToSwapForEtherInV2", buidlAmountToSwapForEtherInV2);
        stateHolder.setUint256("buidlAmountToSwapForUSDCInV2", buidlAmountToSwapForUSDCInV2);
        stateHolder.setUint256("arteAmountToSwapForEtherInV2", arteAmountToSwapForEtherInV2);
        stateHolder.setUint256("arteAmountToSwapForBuidlInV2", arteAmountToSwapForBuidlInV2);
    }

    //Function Teardown - This mandatory operation is called by the Proxy before disabling the Function (e.g. for a Proposal to update it with a new one)
    //In this case, the state holder will be cleaned by useless data to keep the storage clean
    function onStop(address) public {
        IStateHolder stateHolder = IStateHolder(IMVDProxy(msg.sender).getStateHolderAddress());
        stateHolder.clear("buidlTokenAddress");
        stateHolder.clear("arteTokenAddress");
        stateHolder.clear("uSDCTokenAddress");
        stateHolder.clear("uniswapV2RouterAddress");
        stateHolder.clear("swapBlockLimit");
        stateHolder.clear("buidlAmountToSwapForEtherInV2");
        stateHolder.clear("buidlAmountToSwapForUSDCInV2");
        stateHolder.clear("arteAmountToSwapForEtherInV2");
        stateHolder.clear("arteAmountToSwapForBuidlInV2");
        stateHolder.clear("lastSwapBlock");
    }

    //The real main inflation function.
    //This is a public one, callable from any one (Team members or random guys it's not important)
    //All the rules will decide if it can be executed or not
    function fairInflation() public {
        //Load the Proxy and the State Holder
        IMVDProxy proxy = IMVDProxy(msg.sender);
        IStateHolder stateHolder = IStateHolder(proxy.getStateHolderAddress());

        //Can you call it again? - OF COURSE, Mr Bond!

        //Are you calling it after two weeks since last time?
        require(block.number >= (stateHolder.getUint256("lastSwapBlock") + stateHolder.getUint256("swapBlockLimit")), "Too early to swap new Tokens!");

        //Save the last time you called it
        stateHolder.setUint256("lastSwapBlock", block.number);

        //Where to store ETH, USDC and buidl?
        address dfoWalletAddress = proxy.getMVDWalletAddress();

        //Get the Buidl Token
        IERC20 buidlToken = IERC20(stateHolder.getAddress("buidlTokenAddress"));

        IUniswapV2Router uniswapV2Router = IUniswapV2Router(stateHolder.getAddress("uniswapV2RouterAddress"));

        address wethTokenAddress = uniswapV2Router.WETH();

        _swapBuidl(proxy, stateHolder, buidlToken, uniswapV2Router, wethTokenAddress, dfoWalletAddress);

        _swapArte(proxy, stateHolder, buidlToken, uniswapV2Router, wethTokenAddress, dfoWalletAddress);
    }

    function _swapBuidl(IMVDProxy proxy, IStateHolder stateHolder, IERC20 buidlToken, IUniswapV2Router uniswapV2Router, address wethTokenAddress, address dfoWalletAddress) private {
        //How many buidl I have to swap for ETH in UniswapV2?
        uint256 buidlAmountToSwapForEtherInV2 = stateHolder.getUint256("buidlAmountToSwapForEtherInV2");

        //How many buidl I have to swap for USDC in UniswapV2?
        uint256 buidlAmountToSwapForUSDCInV2 = stateHolder.getUint256("buidlAmountToSwapForUSDCInV2");

        //Send the correct cumulative amount of budil tokens to swap from the DFO to this function, to let it spend them in Uniswap V2
        proxy.transfer(address(this), buidlAmountToSwapForEtherInV2 + buidlAmountToSwapForUSDCInV2, address(buidlToken));

        //Swap buidl and arte for ETH, USDC and buidl in UniswapV2
        _uniswapV2Buidl(stateHolder, buidlAmountToSwapForEtherInV2, buidlAmountToSwapForUSDCInV2, buidlToken, uniswapV2Router, wethTokenAddress, dfoWalletAddress);
    }

    //Swap buidl and arte for ETH, USDC and buidl in UniswapV2
    function _uniswapV2Buidl(IStateHolder stateHolder, uint256 buidlAmountToSwapForEtherInV2, uint256 buidlAmountToSwapForUSDCInV2, IERC20 buidlToken, IUniswapV2Router uniswapV2Router, address wethTokenAddress, address dfoWalletAddress) private {
        //Do I have something to swap in UniswapV2?
        if(buidlAmountToSwapForEtherInV2 <= 0 && buidlAmountToSwapForUSDCInV2 <= 0) {
            return;
        }

        //"Unlock" - Enable UniswapV2 to spend my buidl tokens, if necessary
        if(buidlToken.allowance(address(this), address(uniswapV2Router)) == 0) {
            buidlToken.approve(address(uniswapV2Router), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        }

        address[] memory path = new address[](2);
        path[0] = address(buidlToken);

        //Swap the desired amount of buidl and send gained ETHs to the DFO's Wallet, if any
        if(buidlAmountToSwapForEtherInV2 > 0) {
            path[1] = wethTokenAddress;
            uniswapV2Router.swapExactTokensForETH(buidlAmountToSwapForEtherInV2, uniswapV2Router.getAmountsOut(buidlAmountToSwapForEtherInV2, path)[1], path, dfoWalletAddress, block.timestamp + 1000);
        }

        //Swap the desired amount of buidl and send gained USDCs to the DFO's Wallet, if any
        if(buidlAmountToSwapForUSDCInV2 > 0) {
            path[1] = stateHolder.getAddress("uSDCTokenAddress");
            uniswapV2Router.swapExactTokensForTokens(buidlAmountToSwapForUSDCInV2, uniswapV2Router.getAmountsOut(buidlAmountToSwapForUSDCInV2, path)[1], path, dfoWalletAddress, block.timestamp + 1000);
        }
    }

    function _swapArte(IMVDProxy proxy, IStateHolder stateHolder, IERC20 buidlToken, IUniswapV2Router uniswapV2Router, address wethTokenAddress, address dfoWalletAddress) private {

        IERC20 arteToken = IERC20(stateHolder.getAddress("arteTokenAddress"));

        //How many buidl I have to swap for ETH in UniswapV2?
        uint256 arteAmountToSwapForEtherInV2 = stateHolder.getUint256("arteAmountToSwapForEtherInV2");

        //How many buidl I have to swap for USDC in UniswapV2?
        uint256 arteAmountToSwapForBuidlInV2 = stateHolder.getUint256("arteAmountToSwapForBuidlInV2");

        //Send the correct cumulative amount of budil tokens to swap from the DFO to this function, to let it spend them in Uniswap V2
        proxy.transfer(address(this), arteAmountToSwapForEtherInV2 + arteAmountToSwapForBuidlInV2, address(arteToken));

        //Swap buidl and arte for ETH, USDC and buidl in UniswapV2
        _uniswapV2Arte(stateHolder, arteAmountToSwapForEtherInV2, arteAmountToSwapForBuidlInV2, buidlToken, arteToken, uniswapV2Router, wethTokenAddress, dfoWalletAddress);
    }

    //Swap buidl and arte for ETH, USDC and buidl in UniswapV2
    function _uniswapV2Arte(IStateHolder stateHolder, uint256 arteAmountToSwapForEtherInV2, uint256 arteAmountToSwapForBuidlInV2, IERC20 buidlToken, IERC20 arteToken, IUniswapV2Router uniswapV2Router, address wethTokenAddress, address dfoWalletAddress) private {
        //Do I have something to swap in UniswapV2?
        if(arteAmountToSwapForEtherInV2 <= 0 && arteAmountToSwapForBuidlInV2 <= 0) {
            return;
        }

        //"Unlock" - Enable UniswapV2 to spend my buidl tokens, if necessary
        if(arteToken.allowance(address(this), address(uniswapV2Router)) == 0) {
            arteToken.approve(address(uniswapV2Router), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        }

        address[] memory path = new address[](2);
        path[0] = address(arteToken);

        //Swap the desired amount of ARTE and send gained ETHs to the DFO's Wallet, if any
        if(arteAmountToSwapForEtherInV2 > 0) {
            path[1] = wethTokenAddress;
            uniswapV2Router.swapExactTokensForETH(arteAmountToSwapForEtherInV2, uniswapV2Router.getAmountsOut(arteAmountToSwapForEtherInV2, path)[1], path, dfoWalletAddress, block.timestamp + 1000);
        }

        //Swap the desired amount of ARTE and send gained buidls to the DFO's Wallet, if any
        if(arteAmountToSwapForBuidlInV2 > 0) {
            path[1] = address(buidlToken);
            uniswapV2Router.swapExactTokensForTokens(arteAmountToSwapForBuidlInV2, uniswapV2Router.getAmountsOut(arteAmountToSwapForBuidlInV2, path)[1], path, dfoWalletAddress, block.timestamp + 1000);
        }
    }
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