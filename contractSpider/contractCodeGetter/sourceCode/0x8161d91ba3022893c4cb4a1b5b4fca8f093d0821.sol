pragma solidity ^0.4.26;

import "./IERC20.sol";
import "./SafeMathLib.sol";
import "./OrFeedInterface.sol";
import "./FITHTokenSaleReferrals.sol";

/**
 * @dev Fiatech ETH discount sale promotion contract.
 */
contract FITHTokenSaleRefAndPromo is FITHTokenSaleReferrals
{
	using SafeMathLib for uint;
	
	// USDT stable coin smart contrat address
	address public usdtContractAddress;
	
	// Oracle feed for ETH/USDT real time exchange rate contrat address
	address public orFeedContractAddress;
	
	uint public oneEthAsWei = 10**18;
	
	uint public ethDiscountPercent = 5000; // percent = ethDiscountPercent / 10000 = 0.2 = 20%
	
	
	// eth each token sale user used to buy tokens
	mapping(address => uint) public ethBalances;
	
	// USDT balances for users participating in eth promo
	mapping(address => uint) public usdtBalances;
	
	
	// Eth Discount Percent updated event
	event EthDiscountPercentUpdated(address indexed admin, uint newEthDiscountPercent);
	
	// USDT deposit event
	event USDTDeposit(address indexed from, uint tokens);
	
	// USDT withdrawal event
	event USDTWithdrawal(address indexed from, uint tokens);
	
	// Promo ETH bought event
	event PromoEthBought(address indexed user, uint ethWei, uint usdtCost);
	
	
	
	/**
	 * @dev Constructor
	 */
    constructor(IERC20 _tokenContract, uint256 _tokenPrice, IERC20 _usdStableCoinContract, OrFeedInterface _orFeedContract)
		FITHTokenSaleReferrals(_tokenContract, _tokenPrice)
		public
	{
		usdtContractAddress = address(_usdStableCoinContract);
		orFeedContractAddress = address(_orFeedContract);
    }
	
	
	
	function setOrFeedAddress(OrFeedInterface _orFeedContract) public onlyOwner returns(bool) {
		require(orFeedContractAddress != address(_orFeedContract), "New orfeed address required");
		
		orFeedContractAddress = address(_orFeedContract);
		return true;
	}
	
	function getEthUsdPrice() public view returns(uint) {
		return OrFeedInterface(orFeedContractAddress).getExchangeRate("ETH", "USDT", "DEFAULT", oneEthAsWei);
	}
	
	function getEthWeiAmountPrice(uint ethWeiAmount) public view returns(uint) {
		return OrFeedInterface(orFeedContractAddress).getExchangeRate("ETH", "USDT", "DEFAULT", ethWeiAmount);
	}
	
	// update eth discount percent as integer down to 0.0001 discount
	function updateEthDiscountPercent(uint newEthDiscountPercent) public onlyOwner returns(bool) {
		require(newEthDiscountPercent != ethDiscountPercent, "EthPromo/same-eth-discount-percent");
		require(newEthDiscountPercent > 0 && newEthDiscountPercent < 10000, "EthPromo/eth-discount-percent-out-of-range");
		
		ethDiscountPercent = newEthDiscountPercent;
		emit EthDiscountPercentUpdated(msg.sender, newEthDiscountPercent);
		return true;
	}
	
	
	
	// referer is address instead of string
	function fithBalanceOf(address user) public view returns(uint) {
		
		return IERC20(tokenContract).balanceOf(user);
    }
	
	//---
	// NOTE: Prior to calling this function, user has to call "approve" on the USDT contract allowing this contract to transfer on his behalf.
	// Transfer usdt stable coins on behalf of the user and register amounts for the ETH promo.
	// NOTE: This is needed for the ETH prmotion:
	// -To register each user USDT amounts for eth promo calculations and also to be able to withdraw user USDT at any time.
	//---
	function depositUSDTAfterApproval(address from, uint tokens) public returns(bool) {
		
		// this contract transfers USDT for deposit on behalf of user after approval
		require(IERC20(usdtContractAddress).transferFrom(from, address(this), tokens), "depositUSDTAfterApproval failed");
		
		// register USDT amounts for each user
		usdtBalances[from] = usdtBalances[from].add(tokens);
		
		emit USDTDeposit(from, tokens);
		
		return true;
	}
	
	//---
	// User withdraws from his USDT balance available
	// NOTE: If sender is owner, he withdraws from USDT profit balance available
	//---
	function withdrawUSDT(uint tokens) public returns(bool) {
		require(usdtBalances[msg.sender] >= tokens, "EthPromo/insufficient-USDT-balance");
		
		// this contract transfers USDT to user
		require(IERC20(usdtContractAddress).transfer(msg.sender, tokens), "EthPromo/USDT.transfer failed");
		
		// register USDT withdrawals for each user
		usdtBalances[msg.sender] = usdtBalances[msg.sender].sub(tokens);
		
		emit USDTWithdrawal(msg.sender, tokens);
		
		return true;
	}
	
	
	
	
	//---
	// Given eth wei amount return cost in USDT stable coin wei with 6 decimals.
	// This function can be used for debug and testing purposes by any user
	// and it is useful to see the discounted price in USDT for given amount of eth a user wants to purchase.
	//---
	function checkEthWeiPromoCost(uint ethWei) public view returns(uint) {
		uint ethPrice = getEthUsdPrice();
		require(ethPrice > 0, "EthPromo/ethPrice-is-zero");
		
		// calculate final discounted price
		//uint usdtCost = ethWei / (10**18) * ethPrice * (10000 - ethDiscountPercent) / 10000;
		uint usdtCost = ethWei.mul(ethPrice).mul(10000 - ethDiscountPercent).div(oneEthAsWei).div(10000);   //oneEthAsWei = 10**18 wei
		return usdtCost;
	}
	
	
	
	// returns eth cost in USDT stable coin wei with 6 decimals
	function calculateEthWeiCost(uint ethWei) public view returns(uint256) {
		return getEthWeiAmountPrice(ethWei);
	}
	
	function calculateUSDTWithDiscount(uint usdt) public view returns(uint256) {
		// we can represent discounts precision down to 0.01% = 0.0001, so we use 10000 factor
		return (usdt.mul(10000 - ethDiscountPercent).div(10000));
	}
	
	//---
	// User buys eth at discount according to eth promo rules and his USDT balance available
	//---
	function buyEthAtDiscount(uint ethWei) public returns(bool) {
		require(ethBalances[msg.sender] >= ethWei, "EthPromo/eth-promo-limit-reached");
		
		uint usdtCost = checkEthWeiPromoCost(ethWei);
		require(usdtCost > 0, "EthPromo/usdtCost-is-zero");
		
		// register USDT withdrawals for each user
		usdtBalances[msg.sender] = usdtBalances[msg.sender].sub(usdtCost);
		
		// USDT profit goes to owner that can withdraw anytime after eth sales excluding users balances
		usdtBalances[owner] = usdtBalances[owner].add(usdtCost);
		
		// register eth promo left for current user
		ethBalances[msg.sender] = ethBalances[msg.sender].sub(ethWei);
		
		// transfer to the user the ether he bought at promotion
        (msg.sender).transfer(ethWei);
		
		emit PromoEthBought(msg.sender, ethWei, usdtCost);
		
		return true;
	}
	
	
	
	///---
	/// NOTE: Having special end sale function to handle USDT stable coin profit as well is not needed,
	/// because owner can always withdraw that profit using 'withdrawUSDT' function.
	///---
	
	/**
	 * This contract has special end sale function to handle USDT stable coin profit as well.
	 */
	/*function endSale() public onlyOwner {
		// transfer remaining FITH tokens from this contract back to owner
        require(tokenContract.transfer(owner, tokenContract.balanceOf(address(this))), "Transfer token-sale token balance to owner failed");
		
		// transfer remaining USDT profit from this contract to owner
		require(IERC20(usdtContractAddress).transfer(owner, usdtBalances[owner]), "EthPromo/USDT.profit.transfer failed");
		
        // Just transfer the ether balance to the owner
        owner.transfer(address(this).balance);
    }*/
	
	
	
	/**
	 * Accept ETH for tokens
	 */
    function () external payable {
		uint tks = (msg.value).div(tokenPrice);
		
		address refererAddress = address(0);
		bytes memory msgData = msg.data;
		// 4 bytes for signature
		if (msgData.length > 4) {
			assembly {
				refererAddress := mload(add(msgData, 20))
			}
		}
		
		_buyTokens(tks, refererAddress);
		
		// store eth of each token sale user
		ethBalances[msg.sender] = ethBalances[msg.sender].add(msg.value);
    }
}