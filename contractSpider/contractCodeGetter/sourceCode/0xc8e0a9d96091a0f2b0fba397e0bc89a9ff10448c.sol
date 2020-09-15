/**
 *Submitted for verification at Etherscan.io on 2020-06-25
*/

pragma solidity >=0.6.0 <0.7.0;
pragma experimental ABIEncoderV2;

interface ERC721 {
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
}

contract ERC721Checker {
    struct Balance {
        address contractAddress;
        uint[] tokens;
    }
    
    function balance(address owner, address[] calldata contracts) public view returns (Balance[] memory output) {
        uint256 len = contracts.length;
        output = new Balance[](len);
        for(uint256 i = 0; i < len; i++){
            ERC721 token = ERC721(contracts[i]);
            uint256 tokenBalance = token.balanceOf(owner);
            uint256[] memory _tokens = new uint256[](tokenBalance);
            for(uint256 j = 0; j < tokenBalance; j++){
                _tokens[j] = token.tokenOfOwnerByIndex(owner, j);
            }
            
            Balance memory b = Balance({
                contractAddress: contracts[i],
                tokens: _tokens
            });
            
            output[i] = b;    
        }
    }
}