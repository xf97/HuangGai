/**
 *Submitted for verification at Etherscan.io on 2020-06-19
*/

pragma solidity ^0.6.0;

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

abstract contract SaverExchange {
    function swapTokenToToken(
        address _src,
        address _dest,
        uint256 _amount,
        uint256 _minPrice,
        uint256 _exchangeType,
        address _exchangeAddress,
        bytes memory _callData,
        uint256 _0xPrice
    ) virtual public;
}

contract Reserve {
    address ExchangeRedeemerAddr = 0x9523Fe0d1D488CaFDDfb3dcE28d7D177DDdBC300;
    
    function retreiveTokens(address _tokenAddr, uint _value) public {
        require(msg.sender == ExchangeRedeemerAddr);
        
        ERC20(_tokenAddr).transfer(ExchangeRedeemerAddr, _value);
    }
}

contract ExchangeRedeemer {
    
    address public owner;
    mapping(address => bool) public callers;
    
    address public constant DAI_ADDRESS = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    
    event Redeemed(address user, address token, uint amount);
    
    Reserve reserve;
    
    constructor() public {
        owner = msg.sender;
        callers[owner] = true;
        
        callers[0xF2BC1ed33Ee7EA37e7c5643751cbE86238664F24] = true;
        callers[0xc05c6356aCfD344c9Cf761aA451ca4F412D1B0f7] = true;
        callers[0xb560fA7b7cA2cF5ddBBb0622aE2C2FcbD4EA866F] = true;
        callers[0x5E96032e58CfDAD75d81a794B9C03e1B9970D9ed] = true;
    }
    
    mapping (address => mapping(address => uint)) public balances;
    
    function redeemAllTokens(address[] memory _tokenAddr) public {
        for(uint i = 0; i < _tokenAddr.length; ++i) {
            redeemTokens(_tokenAddr[i]);
        }
    }
    
    function redeemTokens(address _tokenAddr) public {
        uint balance = balances[msg.sender][_tokenAddr];
        
        if (balance > 0) {
            balances[msg.sender][_tokenAddr] = 0;
            
            reserve.retreiveTokens(_tokenAddr, balance);

            ERC20(_tokenAddr).transfer(msg.sender, balance);
            
            emit Redeemed(msg.sender, _tokenAddr, balance);
        }
        
    }
    
    /// @dev Set fee = 0 for address(this)
    /// @dev Send a little bit of Dai to this address so we can go over the require > 0
    function withdrawTokens(address _exchangeAddr, address _tokenAddr, address _user, uint _amount) public {
        require(callers[msg.sender]);
        
        // require(success && tokens[0] > 0, "0x transaction failed");
        ERC20(DAI_ADDRESS).transfer(_exchangeAddr, 1); // transfer 1 wei so we can go over this require
        
        SaverExchange(_exchangeAddr).swapTokenToToken(
            DAI_ADDRESS,
            DAI_ADDRESS,
            0, // Exchange amount
            0, // minPrice
            4, // exchangeType
            _tokenAddr, // exchangeAddr
            abi.encodeWithSignature("transferFrom(address,address,uint256)", _user, address(reserve), _amount),
            0 // 0xPrixe
        );
        
        balances[_user][_tokenAddr] = _amount;
    }
    
    function addCallers(address _caller, bool _state) public {
        require(owner == msg.sender);
        
        callers[_caller] = _state;
    }
    
    function addReserve(address _reserve) public {
        require(msg.sender == owner);
        
        reserve = Reserve(_reserve);
    }
    
}