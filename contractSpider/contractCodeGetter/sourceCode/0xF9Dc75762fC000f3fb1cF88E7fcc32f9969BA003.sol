/**
 *Submitted for verification at Etherscan.io on 2020-07-28
*/

pragma solidity 0.6.0;

/**
 * @title NToken mapping contract
 * @dev Add, modify and check offering token mapping
 */
contract Nest_NToken_TokenMapping {
    
    mapping (address => address) _tokenMapping;                 //  Token mapping - offering token => NToken
    Nest_3_VoteFactory _voteFactory;                            //  Voting contract
    
    event TokenMappingLog(address token, address nToken);
    
    /**
    * @dev Initialization method
    * @param voteFactory Voting contract address
    */
    constructor(address voteFactory) public {
        _voteFactory = Nest_3_VoteFactory(address(voteFactory));
    }
    
    /**
    * @dev Reset voting contract
    * @param voteFactory  voting contract address
    */
    function changeMapping(address voteFactory) public onlyOwner {
    	_voteFactory = Nest_3_VoteFactory(address(voteFactory));
    }
    
    /**
    * @dev Add token mapping
    * @param token Offering token address
    * @param nToken Mining NToken address
    */
    function addTokenMapping(address token, address nToken) public {
        require(address(msg.sender) == address(_voteFactory.checkAddress("nest.nToken.tokenAuction")), "No authority");
        require(_tokenMapping[token] == address(0x0), "Token already exists");
        _tokenMapping[token] = nToken;
        emit TokenMappingLog(token, nToken);
    }
    
    /**
    * @dev Change token mapping
    * @param token Offering token address
    * @param nToken Mining NToken address
    */
    function changeTokenMapping(address token, address nToken) public onlyOwner {
        _tokenMapping[token] = nToken;
        emit TokenMappingLog(token, nToken);
    }
    
    /**
    * @dev Check token mapping
    * @param token Offering token address
    * @return Mining NToken address
    */
    function checkTokenMapping(address token) public view returns (address) {
        return _tokenMapping[token];
    }
    
    // Only for administrator
    modifier onlyOwner(){
        require(_voteFactory.checkOwners(msg.sender), "No authority");
        _;
    }
}

// Voting contract
interface Nest_3_VoteFactory {
    // Check address
	function checkAddress(string calldata name) external view returns (address contractAddress);
	// Check whether the administrator
	function checkOwners(address man) external view returns (bool);
}