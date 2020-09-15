/**
 *Submitted for verification at Etherscan.io on 2020-07-21
*/

/**
 *  @authors: [@mtsalenc]
 *  @reviewers: []
 *  @auditors: []
 *  @bounties: []
 *  @deployments: []
 */

pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;

interface IArbitrableTokenList {
    
    enum TokenStatus {
        Absent, // The token is not in the registry.
        Registered, // The token is in the registry.
        RegistrationRequested, // The token has a request to be added to the registry.
        ClearingRequested // The token has a request to be removed from the registry.
    }
    
    enum Party {
        None,
        Requester,
        Challenger
    }
    
    function getTokenInfo(bytes32) external view returns (string memory, string memory, address, string memory, TokenStatus, uint);
    function queryTokens(bytes32 _cursor, uint _count, bool[8] calldata _filter, bool _oldestFirst, address _tokenAddr)
        external
        view
        returns (bytes32[] memory values, bool hasMore);
    function tokenCount() external view returns (uint);
    function addressToSubmissions(address _addr, uint _index) external view returns (bytes32);
    function tokensList(uint _index) external view returns (bytes32);
    function getRequestInfo(bytes32 _tokenID, uint _request)
        external
        view
        returns (
            bool disputed,
            uint disputeID,
            uint submissionTime,
            bool resolved,
            address[3] memory parties,
            uint numberOfRounds,
            Party ruling,
            address arbitrator,
            bytes memory arbitratorExtraData
        );
}


/** @title TokensView
 *  Utility view contract to fetch multiple token information at once.
 */
contract TokensViewV3 {
    
    struct Token {
        bytes32 ID;
        string name;
        string ticker;
        address addr;
        string symbolMultihash;
        IArbitrableTokenList.TokenStatus status;
        uint decimals;
    }
    
    /** @dev Fetch token IDs of the first tokens present on the tcr for the addresses.
     *  @param _t2crAddress The address of the t2cr contract from where to fetch token information.
     *  @param _tokenAddresses The address of each token.
     */
    function getTokensIDsForAddresses(
        address _t2crAddress, 
        address[] calldata _tokenAddresses
    ) external view returns (bytes32[] memory result) {
        IArbitrableTokenList t2cr = IArbitrableTokenList(_t2crAddress);
        result = new bytes32[](_tokenAddresses.length);
        for (uint i = 0; i < _tokenAddresses.length;  i++){
            // Count how many submissions were made for an address.
            address tokenAddr = _tokenAddresses[i];
            bool counting = true;
            bytes4 sig = bytes4(keccak256("addressToSubmissions(address,uint256)"));
            uint submissions = 0;
            while(counting) {
                assembly {
                    let x := mload(0x40)   // Find empty storage location using "free memory pointer"
                    mstore(x, sig)         // Set the signature to the first call parameter. 
                    mstore(add(x, 0x04), tokenAddr)
                    mstore(add(x, 0x24), submissions)
                    counting := staticcall( // `counting` will be set to false if the call reverts (which will happen if we reached the end of the array.)
                        30000,              // 30k gas
                        _t2crAddress,       // The call target.
                        x,                  // Inputs are stored at location x
                        0x44,               // Input is 44 bytes long (signature (4B) + address (20B) + index(20B))
                        x,                  // Overwrite x with output
                        0x20                // The output length
                    )
                }
                
                if (counting) {
                    submissions++;
                }
            }
            
            // Search for the oldest submission currently in the registry.
            for(uint j = 0; j < submissions; j++) {
                bytes32 tokenID = t2cr.addressToSubmissions(tokenAddr, j);
                (,,,,IArbitrableTokenList.TokenStatus status,) = t2cr.getTokenInfo(tokenID);
                if (status == IArbitrableTokenList.TokenStatus.Registered || status == IArbitrableTokenList.TokenStatus.ClearingRequested) 
                {
                    result[i] = tokenID;
                    break;
                }
            }
        }
    }
    
    /** @dev Fetch up token information with token IDs. If a token contract does not implement the decimals() function, its decimals field will be 0.
     *  @param _t2crAddress The address of the t2cr contract from where to fetch token information.
     *  @param _tokenIDs The IDs of the tokens we want to query.
     *  @return tokens The tokens information.
     */
    function getTokens(address _t2crAddress, bytes32[] calldata _tokenIDs) 
        external 
        view 
        returns (Token[] memory tokens)
    {
        IArbitrableTokenList t2cr = IArbitrableTokenList(_t2crAddress);
        tokens = new Token[](_tokenIDs.length);
        for (uint i = 0; i < _tokenIDs.length ; i++){
            string[] memory strings = new string[](3); // name, ticker and symbolMultihash respectively.
            address tokenAddress;
            IArbitrableTokenList.TokenStatus status;
            (
                strings[0], 
                strings[1], 
                tokenAddress, 
                strings[2], 
                status, 
            ) = t2cr.getTokenInfo(_tokenIDs[i]);
            
            tokens[i] = Token(
                _tokenIDs[i],
                strings[0],
                strings[1],
                tokenAddress,
                strings[2],
                status,
                0
            );
            
            // Call the contract's decimals() function without reverting when
            // the contract does not implement it.
            // 
            // Two things should be noted: if the contract does not implement the function
            // and does not implement the contract fallback function, `success` will be set to
            // false and decimals won't be set. However, in some cases (such as old contracts) 
            // the fallback function is implemented, and so staticcall will return true
            // even though the value returned will not be correct (the number below):
            // 
            // 22270923699561257074107342068491755213283769984150504402684791726686939079929
            //
            // We handle that edge case by also checking against this value.
            uint decimals;
            bool success;
            bytes4 sig = bytes4(keccak256("decimals()"));
            assembly {
                let x := mload(0x40)   // Find empty storage location using "free memory pointer"
                mstore(x, sig)          // Set the signature to the first call parameter. 0x313ce567 === bytes4(keccak256("decimals()")
                success := staticcall(
                    30000,              // 30k gas
                    tokenAddress,       // The call target.
                    x,                  // Inputs are stored at location x
                    0x04,               // Input is 4 bytes long
                    x,                  // Overwrite x with output
                    0x20                // The output length
                )
                
                decimals := mload(x)   
            }
            if (success && decimals != 22270923699561257074107342068491755213283769984150504402684791726686939079929) {
                tokens[i].decimals = decimals;
            }
        }
    }
    
    /** @dev Fetch token information in batches
     *  @param _t2crAddress The address of the t2cr contract from where to fetch token information.
     *  @param _cursor The index from where to start iterating.
     *  @param _count The number of items to iterate.
     *  @param _filter The filter to use. Each element of the array in sequence means:
     *  - Include absent addresses in result.
     *  - Include registered addresses in result.
     *  - Include addresses with registration requests that are not disputed in result.
     *  - Include addresses with clearing requests that are not disputed in result.
     *  - Include disputed addresses with registration requests in result.
     *  - Include disputed addresses with clearing requests in result.
     *  @return tokens The tokens information.
     */
    function getTokensCursor(address _t2crAddress, uint _cursor, uint _count, bool[6] calldata _filter) 
        external 
        view 
        returns (Token[] memory tokens, bool hasMore)
    {
        IArbitrableTokenList t2cr = IArbitrableTokenList(_t2crAddress);
        if (_count == 0) _count = t2cr.tokenCount();
        
        tokens = new Token[](_count);
        
        
        for (uint i = _cursor; i < t2cr.tokenCount() && i < _cursor + _count ; i++){
            bytes32 tokenID = t2cr.tokensList(i);
            string[] memory strings = new string[](3); // name, ticker and symbolMultihash respectively.
            address tokenAddress;
            IArbitrableTokenList.TokenStatus status;
            uint numberOfRequests;
            (
                strings[0], 
                strings[1], 
                tokenAddress, 
                strings[2], 
                status, 
                numberOfRequests
            ) = t2cr.getTokenInfo(tokenID);
            
            tokens[i] = Token(
                tokenID,
                strings[0],
                strings[1],
                tokenAddress,
                strings[2],
                status,
                0
            );
            
            (bool disputed,,,,,,,,) = t2cr.getRequestInfo(tokenID, numberOfRequests - 1);
            
            if (
                /* solium-disable operator-whitespace */
                (_filter[0] && status == IArbitrableTokenList.TokenStatus.Absent) ||
                (_filter[1] && status == IArbitrableTokenList.TokenStatus.Registered) ||
                (_filter[2] && status == IArbitrableTokenList.TokenStatus.RegistrationRequested && !disputed) ||
                (_filter[3] && status == IArbitrableTokenList.TokenStatus.ClearingRequested && !disputed) ||
                (_filter[4] && status == IArbitrableTokenList.TokenStatus.RegistrationRequested && disputed) ||
                (_filter[5] && status == IArbitrableTokenList.TokenStatus.ClearingRequested && disputed)
                /* solium-enable operator-whitespace */
            ) {
                if (i < _count) {
                    // Call the contract's decimals() function without reverting when
                    // the contract does not implement it.
                    // 
                    // Two things should be noted: if the contract does not implement the function
                    // and does not implement the contract fallback function, `success` will be set to
                    // false and decimals won't be set. However, in some cases (such as old contracts) 
                    // the fallback function is implemented, and so staticcall will return true
                    // even though the value returned will not be correct (the number below):
                    // 
                    // 22270923699561257074107342068491755213283769984150504402684791726686939079929
                    //
                    // We handle that edge case by also checking against this value.
                    uint decimals;
                    bool success;
                    bytes4 sig = bytes4(keccak256("decimals()"));
                    assembly {
                        let x := mload(0x40)   // Find empty storage location using "free memory pointer"
                        mstore(x, sig)          // Set the signature to the first call parameter. 0x313ce567 === bytes4(keccak256("decimals()")
                        success := staticcall(
                            30000,              // 30k gas
                            tokenAddress,       // The call target.
                            x,                  // Inputs are stored at location x
                            0x04,               // Input is 4 bytes long
                            x,                  // Overwrite x with output
                            0x20                // The output length
                        )
                        
                        decimals := mload(x)   
                    }
                    if (success && decimals != 22270923699561257074107342068491755213283769984150504402684791726686939079929) {
                        tokens[i].decimals = decimals;
                    }
                } else {
                    hasMore = true;
                    break;
                }
            }
            
            
        }
    }
}