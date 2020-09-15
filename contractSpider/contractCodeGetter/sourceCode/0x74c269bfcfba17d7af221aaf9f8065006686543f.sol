/**
 *Submitted for verification at Etherscan.io on 2020-06-19
*/

pragma solidity >=0.4.26;


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

contract IERC20Token {
    function name() public view returns (string memory) {this;}
    function symbol() public view returns (string memory) {this;}
    function decimals() public view returns (uint8) {this;}
    function totalSupply() public view returns (uint256) {this;}
    function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
    function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}

    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
}

interface OrFeedInterface {
  function getExchangeRate ( string fromSymbol, string toSymbol, string  venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string  symbol ) external view returns ( address );
  function getSynthBytes32 ( string  symbol ) external view returns ( bytes32 );
  function getForexAddress ( string  symbol ) external view returns ( address );
}


interface IContractRegistry {
    function addressOf(bytes32 _contractName) external view returns (address);
}

interface IBancorNetwork {
    function getReturnByPath(address[]  _path, uint256 _amount) external view returns (uint256, uint256);
}

interface IBancorNetworkPathFinder {
    function generatePath(address _sourceToken, address _targetToken) external view returns (address[]);
}


library SafeMath {
    function mul(uint256 a, uint256 b) internal view returns(uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal view returns(uint256) {
        assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal view returns(uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal view returns(uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}






contract BancorPrices{
OrFeedInterface orfeed = OrFeedInterface(0x8316b082621cfedab95bf4a44a1d4b64a6ffc336);
   address owner;
      modifier onlyOwner() {
            if (msg.sender != owner) {
                throw;
            }
             _;
        }

      constructor() public payable {
            owner = msg.sender;


        }

   function kill() onlyOwner{
       selfdestruct(owner);
   }


    function getPriceFromOracle(string fromParam, string toParam, string venue, uint256 amount) public constant returns (uint256){

        address tokenFirst = orfeed.getTokenAddress(fromParam);
        address tokenSecond = orfeed.getTokenAddress(toParam);

        uint256 answer = bancorPrice(tokenSecond, tokenFirst, amount);
        return answer;

    }
    function bancorPrice(address token1, address token2, uint256 amount) constant returns (uint256){
        // updated with the newest address of the BancorNetwork contract deployed under the circumstances of old versions of `getReturnByPath`
        IContractRegistry contractRegistry = IContractRegistry(0x52Ae12ABe5D8BD778BD5397F99cA900624CfADD4);

        //
  // IBancorNetwork bancorNetwork = IBancorNetwork(contractRegistry.addressOf(0x42616e636f724e6574776f726b));

    //IBancorNetwork bancorNetwork = IBancorNetwork(0x3Ab6564d5c214bc416EE8421E05219960504eeAD);
    IBancorNetwork bancorNetwork = IBancorNetwork(0x2F9EC37d6CcFFf1caB21733BdaDEdE11c823cCB0);

   //
       // IBancorNetworkPathFinder bancorNetworkPathFinder = IBancorNetworkPathFinder(contractRegistry.addressOf(0x42616e636f724e6574776f726b5061746846696e646572));
         IBancorNetworkPathFinder bancorNetworkPathFinder = IBancorNetworkPathFinder(0x6F0cD8C4f6F06eAB664C7E3031909452b4B72861);
       // address token1ToBancor = token1;
        //address token2ToBancor = token2;
        // in case of Ether (or Weth), we need to provide the address of the EtherToken to the BancorNetwork

        if (token1 == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE || token1 == 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2){
            // the EtherToken addresss for BancorNetwork
          //  token1 = 0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315;
          token1 = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
        }
        if (token2 == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE || token2 == 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2){
          //  token2 = 0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315;
          token2 = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
        }

        address[] memory addressPath;


            addressPath = bancorNetworkPathFinder.generatePath(token2, token1);
/*
        IERC20Token[] memory tokenPath = new IERC20Token[](addressPath.length);

        for(uint256 i = 0; i < addressPath.length; i++) {
            tokenPath[i] = IERC20Token(addressPath[i]);
        }
       */
       (uint256 price, ) = bancorNetwork.getReturnByPath(addressPath, amount);
       return price;
    }



    function contains (string memory what, string memory where) public view returns(bool){
    bytes memory whatBytes = bytes (what);
    bytes memory whereBytes = bytes (where);

    bool found = false;
    for (uint i = 0; i < whereBytes.length - whatBytes.length; i++) {
        bool flag = true;
        for (uint j = 0; j < whatBytes.length; j++)
            if (whereBytes [i + j] != whatBytes [j]) {
                flag = false;
                break;
            }
        if (flag) {
            found = true;
            break;
        }
    }

    return found;

}


   function compare(string memory _a, string memory _b) public returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }
    /// @dev Compares two strings and returns true iff they are equal.
    function equal(string memory _a, string memory _b) public returns (bool) {
        return compare(_a, _b) == 0;
    }
    /// @dev Finds the index of the first occurrence of _needle in _haystack
    function indexOf(string memory _haystack, string memory _needle) public returns (int)
    {
        bytes memory h = bytes(_haystack);
        bytes memory n = bytes(_needle);
        if(h.length < 1 || n.length < 1 || (n.length > h.length))
            return -1;
        else if(h.length > (2**128 -1)) // since we have to be able to return -1 (if the char isn't found or input error), this function must return an "int" type with a max length of (2^128 - 1)
            return -1;
        else
        {
            uint subindex = 0;
            for (uint i = 0; i < h.length; i ++)
            {
                if (h[i] == n[0]) // found the first char of b
                {
                    subindex = 1;
                    while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) // search until the chars don't match or until we reach the end of a or b
                    {
                        subindex++;
                    }
                    if(subindex == n.length)
                        return int(i);
                }
            }
            return -1;
        }
    }



}