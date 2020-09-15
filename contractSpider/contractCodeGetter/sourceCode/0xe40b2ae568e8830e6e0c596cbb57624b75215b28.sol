/**
 *Submitted for verification at Etherscan.io on 2020-06-15
*/

// File: contracts/dydx/DyDx.sol

pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

interface Structs {
    struct Val {
        uint256 value;
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
        Wei // the amount is denominated in wei
    }

    enum AssetReference {
        Delta // the amount is given as a delta from the current value
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

    struct Info {
        address owner;  // The address that owns the account
        uint256 number; // A nonce that allows a single address to control many accounts
    }

    struct Wei {
        bool sign; // true if positive
        uint256 value;
    }
}

contract DyDxPool is Structs {
    function getAccountWei(Info memory account, uint256 marketId) public view returns (Wei memory);
    function operate(Info[] memory, ActionArgs[] memory) public;
}

// File: contracts/IERC20.sol

pragma solidity ^0.5.0;


/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
 */
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);
}

// File: contracts/dydx/DyDxFlashLoan.sol

pragma solidity ^0.5.0;




contract DyDxFlashLoan is Structs {
    DyDxPool pool = DyDxPool(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);

    address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public SAI = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
    address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    mapping(address => uint256) public currencies;

    constructor() public {
        currencies[WETH] = 1;
        currencies[SAI] = 2;
        currencies[USDC] = 3;
        currencies[DAI] = 4;
    }

    modifier onlyPool() {
        require(
            msg.sender == address(pool),
            "FlashLoan: could be called by DyDx pool only"
        );
        _;
    }

    function tokenToMarketId(address token) public view returns (uint256) {
        uint256 marketId = currencies[token];
        require(marketId != 0, "FlashLoan: Unsupported token");
        return marketId - 1;
    }

    // the DyDx will call `callFunction(address sender, Info memory accountInfo, bytes memory data) public` after during `operate` call
    function flashloan(address token, uint256 amount, bytes memory data)
        internal
    {
        IERC20(token).approve(address(pool), amount + 1);
        Info[] memory infos = new Info[](1);
        ActionArgs[] memory args = new ActionArgs[](3);

        infos[0] = Info(address(this), 0);

        AssetAmount memory wamt = AssetAmount(
            false,
            AssetDenomination.Wei,
            AssetReference.Delta,
            amount
        );
        ActionArgs memory withdraw;
        withdraw.actionType = ActionType.Withdraw;
        withdraw.accountId = 0;
        withdraw.amount = wamt;
        withdraw.primaryMarketId = tokenToMarketId(token);
        withdraw.otherAddress = address(this);

        args[0] = withdraw;

        ActionArgs memory call;
        call.actionType = ActionType.Call;
        call.accountId = 0;
        call.otherAddress = address(this);
        call.data = data;

        args[1] = call;

        ActionArgs memory deposit;
        AssetAmount memory damt = AssetAmount(
            true,
            AssetDenomination.Wei,
            AssetReference.Delta,
            amount + 1
        );
        deposit.actionType = ActionType.Deposit;
        deposit.accountId = 0;
        deposit.amount = damt;
        deposit.primaryMarketId = tokenToMarketId(token);
        deposit.otherAddress = address(this);

        args[2] = deposit;

        pool.operate(infos, args);
    }
}

// File: contracts/FlashloanTaker.sol

pragma solidity ^0.5.0;

interface ERC20 {
    function totalSupply() external view returns (uint supply);
    function balanceOf(address _owner) external view returns (uint balance);
    function transfer(address _to, uint _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint _value) external returns (bool success);
    function approve(address _spender, uint _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    function decimals() external view returns(uint digits);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}


interface OrFeedInterface {
  function getExchangeRate ( string calldata fromSymbol, string calldata  toSymbol, string calldata venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string calldata  symbol ) external view returns ( address );
  function getSynthBytes32 ( string calldata  symbol ) external view returns ( bytes32 );
  function getForexAddress ( string calldata symbol ) external view returns ( address );
  function arb(address  fundsReturnToAddress,  address liquidityProviderContractAddress, string[] calldata   tokens,  uint256 amount, string[] calldata  exchanges) external payable returns (bool);
}

interface IKyberNetworkProxy {
    function maxGasPrice() external view returns(uint);
    function getUserCapInWei(address user) external view returns(uint);
    function getUserCapInTokenWei(address user, ERC20 token) external view returns(uint);
    function enabled() external view returns(bool);
    function info(bytes32 id) external view returns(uint);
    function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) external view returns (uint expectedRate, uint slippageRate);
    function tradeWithHint(ERC20 src, uint srcAmount, ERC20 dest, address destAddress, uint maxDestAmount, uint minConversionRate, address walletId, bytes calldata  hint) external payable returns(uint);
    function swapEtherToToken(ERC20 token, uint minRate) external payable returns (uint);
    function swapTokenToEther(ERC20 token, uint tokenQty, uint minRate) external returns (uint);
}

contract IUniswapExchange {
    // Address of ERC20 token sold on this exchange
    function tokenAddress() external view returns (address token);
    // Address of Uniswap Factory
    function factoryAddress() external view returns (address factory);
    // Provide Liquidity
    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
    // Get Prices
    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
    function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
    function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
    // Trade ETH to ERC20
    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
    function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
    function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
    // Trade ERC20 to ETH
    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
    function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
    function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
    // Trade ERC20 to ERC20
    function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
    function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
    // Trade ERC20 to Custom Pool
    function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
    function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
    // ERC20 comaptibility for liquidity tokens
    bytes32 public name;
    bytes32 public symbol;
    uint256 public decimals;
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);
    function allowance(address _owner, address _spender) external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    // Never use
    function setup(address token_addr) external;
}
interface IWETH {
  function deposit() external payable;
  function withdraw(uint wad) external;
  function totalSupply() external view returns (uint);
  function approve(address guy, uint wad) external returns (bool);
  function transfer(address dst, uint wad) external returns (bool);
  function transferFrom(address src, address dst, uint wad) external returns (bool);
  function () external payable;
}

interface IUniswapFactory {
    function createExchange(address token) external returns (address exchange);
    function getExchange(address token) external view returns (address exchange);
    function getToken(address exchange) external view returns (address token);
    function getTokenWithId(uint256 tokenId) external view returns (address token);
    function initializeFactory(address template) external;
}



contract FlashloanTaker is DyDxFlashLoan {

    address owner;
    address daiAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    uint256 public loan;

    OrFeedInterface orfeed= OrFeedInterface(0x8316B082621CFedAB95bf4a44a1d4B64a6ffc336);

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }

    constructor() public payable {
        owner = msg.sender;
        (bool success, ) = WETH.call.value(msg.value)("");
        require(success, "fail to get weth");
    }

    function withdrawETHAndTokens() external onlyOwner{

        msg.sender.transfer(address(this).balance);
        ERC20 daiToken = ERC20(daiAddress);
        uint256 currentTokenBalance = daiToken.balanceOf(address(this));
        daiToken.transfer(msg.sender, currentTokenBalance);

    }

    


    function getFlashloan(address flashToken, uint256 flashAmount) external {
        uint256 balanceBefore = IERC20(flashToken).balanceOf(address(this));
        bytes memory data = abi.encode(flashToken, flashAmount, balanceBefore);
        flashloan(flashToken, flashAmount, data); // execution goes to `callFunction`

        // and this point we have succefully paid the dept
    }
    
    

    function callFunction(
        address, /* sender */
        Info calldata, /* accountInfo */
        bytes calldata data
    ) external onlyPool {
        (address flashToken, uint256 flashAmount, uint256 balanceBefore) = abi
            .decode(data, (address, uint256, uint256));
        uint256 balanceAfter = IERC20(flashToken).balanceOf(address(this));
        require(
            balanceAfter - balanceBefore == flashAmount,
            "contract did not get the loan"
        );

        
        loan = balanceAfter;
        ERC20 theToken = ERC20(flashToken);

        //place the arb you would like to perform below
        
        //approve the token you are starting  (tokenOrder element 0 below)with (so that the orfeed contract perform its operations below )
        theToken.approve(0x8316B082621CFedAB95bf4a44a1d4B64a6ffc336, 10000000000000000000000000000);
        
         string[] memory tokenOrder = new string[](3);
         string[] memory exchangeOrder = new string[](3);
         
         tokenOrder[0]= "DAI";
         tokenOrder[1]= "USDC";
         tokenOrder[2]= "DAI";
         
         exchangeOrder[0]= "KYBER";
         exchangeOrder[1]= "UNISWAP";
         exchangeOrder[2]= "KYBER";
         
         
        orfeed.arb(address(this), address(this), tokenOrder, flashAmount, exchangeOrder);

        // do whatever you want with the money
        // the dept will be automatically withdrawn from this contract at the end of execution
    }
}