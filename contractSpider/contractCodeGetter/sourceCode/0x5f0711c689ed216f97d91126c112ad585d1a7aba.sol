/**
 *Submitted for verification at Etherscan.io on 2020-07-13
*/

pragma solidity ^0.5.0;

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }
}

contract Ownable is Context {
    address private _owner;
    constructor () internal {
        _owner = _msgSender();
    }
    function owner() public view returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }
}

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint a, uint b) internal pure returns (uint) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint a, uint b) internal pure returns (uint) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
}

interface Oracle {
    function latestAnswer() external view returns(uint256);
}

contract ChainLinkFeedsRegistry is Ownable {
    using SafeMath for uint;
  
    mapping(address => address) public assetsUSD;
    mapping(address => address) public assetsETH;
    address constant public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    
    constructor () public {
        assetsUSD[weth] = 0xF79D6aFBb6dA890132F9D7c355e3015f15F3406F; //weth
        assetsUSD[0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599] = 0xF5fff180082d6017036B771bA883025c654BC935; //wBTC
        assetsUSD[0xEB4C2781e4ebA804CE9a9803C67d0893436bB27D] = 0xF5fff180082d6017036B771bA883025c654BC935; //renBTC
        assetsUSD[0x6B175474E89094C44Da98b954EedeAC495271d0F] = 0xa7D38FBD325a6467894A13EeFD977aFE558bC1f0; //DAI
        assetsUSD[0xF48e200EAF9906362BB1442fca31e0835773b8B4] = 0x05Cf62c4bA0ccEA3Da680f9A8744Ac51116D6231; //sAUD
        assetsUSD[0xD71eCFF9342A5Ced620049e616c5035F1dB98620] = 0x25Fa978ea1a7dc9bDc33a2959B9053EaE57169B5; //sEUR
        assetsUSD[0x0F83287FF768D1c1e17a42F44d644D7F22e8ee1d] = 0x02D5c618DBC591544b19d0bf13543c0728A3c4Ec; //sCHF
        assetsUSD[0x97fe22E7341a0Cd8Db6F6C021A24Dc8f4DAD855F] = 0x151445852B0cfDf6A4CC81440F2AF99176e8AD08; //sGBP
        assetsUSD[0xF6b1C627e95BFc3c1b4c9B825a032Ff0fBf3e07d] = 0xe1407BfAa6B5965BAd1C9f38316A3b655A09d8A6; //sJPY
        assetsUSD[0x6A22e5e94388464181578Aa7A6B869e00fE27846] = 0x8946A183BFaFA95BEcf57c5e08fE5B7654d2807B; //sXAG
        assetsUSD[0x261EfCdD24CeA98652B9700800a13DfBca4103fF] = 0xafcE0c7b7fE3425aDb3871eAe5c0EC6d93E01935; //sXAU
        assetsUSD[0x514910771AF9Ca656af840dff83E8264EcF986CA] = 0x32dbd3214aC75223e27e575C53944307914F7a90; //LINK
        assetsUSD[0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C] = 0x560B06e8897A0E52DbD5723271886BbCC5C1f52a; //BNT
        
        assetsETH[0xBBbbCA6A901c926F240b89EacB641d8Aec7AEafD] = 0x8770Afe90c52Fd117f29192866DE705F63e59407; //LRC
        assetsETH[0x80fB784B7eD66730e8b1DBd9820aFD29931aab03] = 0x1EeaF25f2ECbcAf204ECADc8Db7B0db9DA845327; //LEND
        assetsETH[0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599] = 0x0133Aa47B6197D0BA090Bf2CD96626Eb71fFd13c; //wBTC
        assetsETH[0xEB4C2781e4ebA804CE9a9803C67d0893436bB27D] = 0x0133Aa47B6197D0BA090Bf2CD96626Eb71fFd13c; //renBTC
        assetsETH[0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2] = 0xDa3d675d50fF6C555973C4f0424964e1F6A4e7D3; //MKR
        assetsETH[0x0F5D2fB29fb7d3CFeE444a200298f468908cC942] = 0xc89c4ed8f52Bb17314022f6c0dCB26210C905C97; //MANA
        assetsETH[0xdd974D5C2e2928deA5F71b9825b8b646686BD200] = 0xd0e785973390fF8E77a83961efDb4F271E6B8152; //KNC
        assetsETH[0x514910771AF9Ca656af840dff83E8264EcF986CA] = 0xeCfA53A8bdA4F0c4dd39c55CC8deF3757aCFDD07; //LINK
        assetsETH[0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48] = 0xdE54467873c3BCAA76421061036053e371721708; //USDC
        assetsETH[0x1985365e9f78359a9B6AD760e32412f4a445E862] = 0xb8b513d9cf440C1b6f5C7142120d611C94fC220c; //REP
        assetsETH[0xE41d2489571d322189246DaFA5ebDe1F4699F498] = 0xA0F9D94f060836756FFC84Db4C78d097cA8C23E8; //ZRX
        assetsETH[0x0D8775F648430679A709E98d2b0Cb6250d2887EF] = 0x9b4e2579895efa2b4765063310Dc4109a7641129; //BAT
        assetsETH[0x6B175474E89094C44Da98b954EedeAC495271d0F] = 0x037E8F2125bF532F3e228991e051c8A7253B642c; //DAI
        assetsETH[0x0000000000085d4780B73119b644AE5ecd22b376] = 0x73ead35fd6A572EF763B13Be65a9db96f7643577; //TUSD
        assetsETH[0xdAC17F958D2ee523a2206206994597C13D831ec7] = 0xa874fe207DF445ff19E7482C746C4D3fD0CB9AcE; //USDT
        assetsETH[0x4Fabb145d64652a948d72533023f6E7A623C7C53] = 0x5d4BB541EED49D0290730b4aB332aA46bd27d888; //BUSD
        assetsETH[0x57Ab1ec28D129707052df4dF418D58a2D46d5f51] = 0x6d626Ff97f0E89F6f983dE425dc5B24A18DE26Ea; //SUSD
        assetsETH[0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F] = 0xE23d1142dE4E83C08bb048bcab54d50907390828; //SNX
        assetsETH[0x408e41876cCCDC0F92210600ef50372656052a38] = 0xB7B1C8F4095D819BDAE25e7a63393CDF21fd02Ea; //REN
    }
    
    // Returns 1e8
    function getPriceUSD(address _asset) external view returns(uint256) {
        uint256 _price = 0;
        if (assetsUSD[_asset] != address(0)) {
            _price = Oracle(assetsUSD[_asset]).latestAnswer();
        } else if (assetsETH[_asset] != address(0)) {
            _price = Oracle(assetsETH[_asset]).latestAnswer();
            _price = _price.mul(Oracle(assetsUSD[weth]).latestAnswer()).div(1e18);
        }
        return _price;
    }
    
    // Returns 1e18
    function getPriceETH(address _asset) external view returns(uint256) {
        uint256 _price = 0;
        if (assetsETH[_asset] != address(0)) {
            _price = Oracle(assetsETH[_asset]).latestAnswer();
        }
        return _price;
    }
    
    function addFeedETH(address _asset, address _feed) external onlyOwner {
        assetsETH[_asset] = _feed;
    }
    
    function addFeedUSD(address _asset, address _feed) external onlyOwner {
        assetsUSD[_asset] = _feed;
    }
    
    function removeFeedETH(address _asset) external onlyOwner {
        assetsETH[_asset] = address(0);
    }
    
    function removeFeedUSD(address _asset) external onlyOwner {
        assetsUSD[_asset] = address(0);
    }

}