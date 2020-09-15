// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "./Distribute.sol";
import "./erc20.sol";

contract XYSPurchasePortal{
    
    using SafeMath for uint256;
    
    Distribute dst = Distribute(0x88277055dF2EE38dA159863dA2F56ee0A6909D62);
    
    struct Asset{
        bool isAccepted;
        uint256 rate;
        string name;
        string symbol;
        uint256 decimal;
    }
    mapping(address => Asset) paymentAssets;
    
    address constant private ETH_ADDRESS = address(
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
    );
    
    address constant private DAI_ADDRESS = address(
        0x6B175474E89094C44Da98b954EedeAC495271d0F
    );
    
    address payable constant private FUNDS_RECEIVING_WALLET = 0x794Ce138d9dECf241d0b197deCcCb02f37291DD2;
    
    uint256 public rateIncrementCount = 0;
    uint256 public soldTokens = 0;
    
    event TOKENSPURCHASED(address _purchaser, uint256 _tokens);
    event PAYMENTRECEIVED(address _purchaser, uint256 _amount, address _assetAddress);
    
    constructor() public {
        paymentAssets[DAI_ADDRESS].isAccepted = true;
        paymentAssets[DAI_ADDRESS].rate = 50; // per DAI part
        paymentAssets[DAI_ADDRESS].name = "DAI Stable coin";
        paymentAssets[DAI_ADDRESS].symbol = "DAI"; // per DAI part
        paymentAssets[DAI_ADDRESS].decimal = 18; // decimals
        
        paymentAssets[ETH_ADDRESS].isAccepted = true;
        paymentAssets[ETH_ADDRESS].rate = 11905;
        paymentAssets[ETH_ADDRESS].name = "Ethers";
        paymentAssets[ETH_ADDRESS].symbol = "ETH";
        paymentAssets[ETH_ADDRESS].decimal = 18; // decimals
    }
    
    function purchase(address assetAddress, uint256 amountAsset) public payable{
        require(paymentAssets[assetAddress].isAccepted, "NOT ACCEPTED: Unaccepted payment asset provided");
        require(dst.balanceOf(address(this)) >= getTokenAmount(assetAddress, amountAsset), "XYS Balance: Insufficient liquidity");
        _purchase(assetAddress, amountAsset);
    }
    
    // receive ethers
    fallback() external payable{
        require(dst.balanceOf(address(this)) >= getTokenAmount(ETH_ADDRESS, msg.value), "XYS Balance: Insufficient liquidity");
        _purchase(ETH_ADDRESS, msg.value);
    }
    
    // receive ethers
    receive() external payable{
        require(dst.balanceOf(address(this)) >= getTokenAmount(ETH_ADDRESS, msg.value), "XYS Balance: Insufficient liquidity");
        _purchase(ETH_ADDRESS, msg.value);
    }
    
    function _purchase(address assetAddress, uint256 assetAmount) internal{
        if(assetAddress ==  ETH_ADDRESS){
            // send received ethers to the receiving wallet
            FUNDS_RECEIVING_WALLET.transfer(assetAmount);
            require(assetAmount >= 0.5 ether, "ETHERS: minimum purchase allowed is 0.5 ethers");
        }
        else{
            require(assetAmount >= 120 * 10 ** (paymentAssets[assetAddress].decimal), "DAI: minimum purchase allowed is 120 DAI");
            // send received tokens to the receiving wallet
            ERC20Interface(assetAddress).transferFrom(msg.sender, FUNDS_RECEIVING_WALLET, assetAmount);
        }
        // send tokens to the purchaser
        uint256 tokens = getTokenAmount(assetAddress, assetAmount);
        dst.transfer(msg.sender, tokens);
        
        soldTokens += tokens;
        
        // update asset rate, if needed
        if(soldTokens/1000000000000 > 0)
            rateIncrementCount = soldTokens /1000000000000 ;
        
        emit TOKENSPURCHASED(msg.sender, tokens);
        emit PAYMENTRECEIVED(msg.sender, assetAmount, assetAddress);
    }
    
    function getTokenAmount(address assetAddress, uint256 assetAmount) public view returns(uint256){
        uint256 tokens = (paymentAssets[assetAddress].rate * assetAmount / 10 ** (paymentAssets[assetAddress].decimal - dst.decimals()));
        return  tokens - onePercent(tokens) * (5 * rateIncrementCount); 
    }
    
    function onePercent(uint256 _amount) internal pure returns (uint256){
        uint roundValue = _amount.ceil(100);
        uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));
        return onePercentofTokens;
    }
}