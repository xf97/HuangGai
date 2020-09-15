pragma solidity ^0.4.26;

import "./Owned.sol";
import "./Mortal.sol";
import "./IERC20.sol";
import "./OrFeedInterface.sol";

// ----------------------------------------------------------------------------
// Oracle Feed LIVE Test contract
//
// ----------------------------------------------------------------------------

contract OrFeedLIVETest is Owned, Mortal, OrFeedInterface
{
	// Oracle feed for ETH/USDT real time exchange rate contrat address
	address public orFeedContractAddress;
	OrFeedInterface public orFeed;
	
	uint public oneEthAsWei = 10**18;
	
	
	
	// ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor(OrFeedInterface _orFeedContract) public
	{
		orFeedContractAddress = address(_orFeedContract);
		orFeed = OrFeedInterface(orFeedContractAddress);
    }
	
	
	
	function setOrFeedAddress(OrFeedInterface _orFeedContract) public onlyOwner returns(bool) {
		require(orFeedContractAddress != address(_orFeedContract), "New orfeed address required");
		
		orFeedContractAddress = address(_orFeedContract);
		orFeed = OrFeedInterface(orFeedContractAddress);
		return true;
	}
	
	
	
	function getEthUsdPrice() public view returns(uint) {
		return orFeed.getExchangeRate("ETH", "USDT", "DEFAULT", oneEthAsWei);
	}
	
	function getEthWeiAmountPrice(uint ethWeiAmount) public view returns(uint) {
		return orFeed.getExchangeRate("ETH", "USDT", "DEFAULT", ethWeiAmount);
	}
	
	
	
	function getEthUsdPrice2() public view returns(uint) {
		return OrFeedInterface(orFeedContractAddress).getExchangeRate("ETH", "USDT", "DEFAULT", oneEthAsWei);
	}
	
	function getEthWeiAmountPrice2(uint ethWeiAmount) public view returns(uint) {
		return OrFeedInterface(orFeedContractAddress).getExchangeRate("ETH", "USDT", "DEFAULT", ethWeiAmount);
	}
	
	
	
	function getExchangeRate( string fromSymbol,
							string toSymbol,
							string venue,
							uint256 amount )
						external view returns ( uint256 )
	{
		uint256 r = orFeed.getExchangeRate(fromSymbol, toSymbol, venue, amount);
		return r;
	}
	
	function getExchangeRateX( string fromSymbol,
							string toSymbol,
							string venue,
							uint256 amount )
						external view returns ( uint256 )
	{
		return (orFeed.getExchangeRate(fromSymbol, toSymbol, venue, amount));
	}
	
	function getExchangeRate2( string fromSymbol,
							string toSymbol,
							string venue,
							uint256 amount )
						external view returns ( uint256 )
	{
		uint256 r = OrFeedInterface(orFeedContractAddress).getExchangeRate(fromSymbol, toSymbol, venue, amount);
		return r;
	}
	
	function getExchangeRate2X( string fromSymbol,
							string toSymbol,
							string venue,
							uint256 amount )
						external view returns ( uint256 )
	{
		return (OrFeedInterface(orFeedContractAddress).getExchangeRate(fromSymbol, toSymbol, venue, amount));
	}
	
	
	
	function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 ) {
		return orFeed.getTokenDecimalCount(tokenAddress);
	}
	
	function getTokenAddress ( string symbol ) external view returns ( address ) {
		return orFeed.getTokenAddress(symbol);
	}
	
	function getSynthBytes32 ( string symbol ) external view returns ( bytes32 ) {
		return orFeed.getSynthBytes32(symbol);
	}
	
	function getForexAddress ( string symbol ) external view returns ( address ) {
		return orFeed.getForexAddress(symbol);
	}
	
	/*function arb(address  fundsReturnToAddress,
				address liquidityProviderContractAddress,
				string[] calldata tokens,
				uint256 amount,
				string[] calldata exchanges)
			external payable returns (bool)
	{
		revert();
	}*/
	
	
	
	/**
	 * Accept ETH donations
	 */
    function () external payable {
		revert();
    }
	
	
	
	/**
	 * @dev Owner can transfer out (recover) any ERC20 tokens accidentally sent to this contract.
	 * @param tokenAddress Token contract address we want to recover lost tokens from.
	 * @param tokens Amount of tokens to be recovered, usually the same as the balance of this contract.
	 * @return bool
	 */
    function recoverAnyERC20Token(address tokenAddress, uint tokens) external onlyOwner returns (bool ok) {
		ok = IERC20(tokenAddress).transfer(owner, tokens);
    }
}