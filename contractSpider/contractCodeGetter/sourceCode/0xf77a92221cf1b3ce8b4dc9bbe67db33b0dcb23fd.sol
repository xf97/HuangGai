/**
 *Submitted for verification at Etherscan.io on 2020-08-11
*/

// File: contracts\Owned.sol

pragma solidity ^0.5.0;

contract Owned {
	
	address payable public owner;
	
    constructor() public
	{
		owner = msg.sender;
	}
	
    // This contract only defines a modifier but it will be used in derived contracts.
    modifier onlyOwner() {
        require(msg.sender == owner, "Owner required");
        _;
    }
}

// File: contracts\Mortal.sol

pragma solidity ^0.5.0;


contract Mortal is Owned
{
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
}

// File: contracts\IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev ERC20 contract interface.
 */
contract IERC20
{
	function totalSupply() public view returns (uint);
	
	function transfer(address _to, uint _value) public returns (bool success);
	
	function transferFrom(address _from, address _to, uint _value) public returns (bool success);
	
	function balanceOf(address _owner) public view returns (uint balance);
	
	function approve(address _spender, uint _value) public returns (bool success);
	
	function allowance(address _owner, address _spender) public view returns (uint remaining);
	
	event Transfer(address indexed from, address indexed to, uint tokens);
	event Approval(address indexed owner, address indexed spender, uint tokens);
}

// File: contracts\SafeMathLib.sol

pragma solidity ^0.5.0;

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------

library SafeMathLib {
	
	using SafeMathLib for uint;
	
	/**
	 * @dev Sum two uint numbers.
	 * @param a Number 1
	 * @param b Number 2
	 * @return uint
	 */
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a, "SafeMathLib.add: required c >= a");
    }
	
	/**
	 * @dev Substraction of uint numbers.
	 * @param a Number 1
	 * @param b Number 2
	 * @return uint
	 */
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a, "SafeMathLib.sub: required b <= a");
        c = a - b;
    }
	
	/**
	 * @dev Product of two uint numbers.
	 * @param a Number 1
	 * @param b Number 2
	 * @return uint
	 */
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require((a == 0 || c / a == b), "SafeMathLib.mul: required (a == 0 || c / a == b)");
    }
	
	/**
	 * @dev Division of two uint numbers.
	 * @param a Number 1
	 * @param b Number 2
	 * @return uint
	 */
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0, "SafeMathLib.div: required b > 0");
        c = a / b;
    }
}

// File: contracts\OrFeedInterface.sol

pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

interface OrFeedInterface {
  function getExchangeRate ( string calldata fromSymbol, string calldata  toSymbol, string calldata venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string calldata  symbol ) external view returns ( address );
  function getSynthBytes32 ( string calldata  symbol ) external view returns ( bytes32 );
  function getForexAddress ( string calldata symbol ) external view returns ( address );
  //function arb(address  fundsReturnToAddress,  address liquidityProviderContractAddress, string[] calldata   tokens,  uint256 amount, string[] calldata  exchanges) external payable returns (bool);
}

// File: contracts\OrFeedLIVETest.sol

pragma solidity ^0.5.0;






// ----------------------------------------------------------------------------
// Oracle Feed LIVE Test contract
//
// ----------------------------------------------------------------------------

contract OrFeedLIVETest is Owned, Mortal, OrFeedInterface
{
	using SafeMathLib for uint;
	
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
	
	
	
	function getExchangeRate( string calldata fromSymbol,
							string calldata toSymbol,
							string calldata venue,
							uint256 amount )
						external view returns ( uint256 )
	{
		return (orFeed.getExchangeRate(fromSymbol, toSymbol, venue, amount));
	}
	
	function getExchangeRate2( string calldata fromSymbol,
							string calldata toSymbol,
							string calldata venue,
							uint256 amount )
						external view returns ( uint256 )
	{
		return (OrFeedInterface(orFeedContractAddress).getExchangeRate(fromSymbol, toSymbol, venue, amount));
	}
	
	
	
	function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 ) {
		return orFeed.getTokenDecimalCount(tokenAddress);
	}
	
	function getTokenAddress ( string calldata  symbol ) external view returns ( address ) {
		return orFeed.getTokenAddress(symbol);
	}
	
	function getSynthBytes32 ( string calldata  symbol ) external view returns ( bytes32 ) {
		return orFeed.getSynthBytes32(symbol);
	}
	
	function getForexAddress ( string calldata symbol ) external view returns ( address ) {
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
    }
	
	
	
	/**
	 * @dev Send all eth balance in the contract to another address
	 * @param _to Address to send contract ether balance to
	 * @return bool
	 */
    function reclaimEther(address payable _to) external onlyOwner returns (bool) {
        _to.transfer(address(this).balance);
		return true;
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