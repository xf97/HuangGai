                                                                 

// SPDX-License-Identifier: Apache-2.0
// Copyright 2017 Loopring Technology Limited.
pragma solidity ^0.7.0;


                  
                                                
                                                                      
                                                                               
                            
contract Ownable
{
    address public owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

                                                                              
                           
    constructor()
    {
        owner = msg.sender;
    }

                                                                  
    modifier onlyOwner()
    {
        require(msg.sender == owner, "UNAUTHORIZED");
        _;
    }

                                                                              
                       
                                                             
    function transferOwnership(
        address newOwner
        )
        public
        virtual
        onlyOwner
    {
        require(newOwner != address(0), "ZERO_ADDRESS");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function renounceOwnership()
        public
        onlyOwner
    {
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }
}

// Copyright 2017 Loopring Technology Limited.





                    
                                                
                                                                      
                                                                         
contract Claimable is Ownable
{
    address public pendingOwner;

                                                                                  
    modifier onlyPendingOwner() {
        require(msg.sender == pendingOwner, "UNAUTHORIZED");
        _;
    }

                                                                      
                                                             
    function transferOwnership(
        address newOwner
        )
        public
        override
        onlyOwner
    {
        require(newOwner != address(0) && newOwner != owner, "INVALID_ADDRESS");
        pendingOwner = newOwner;
    }

                                                                      
    function claimOwnership()
        public
        onlyPendingOwner
    {
        emit OwnershipTransferred(owner, pendingOwner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }
}

// Copyright 2017 Loopring Technology Limited.



                                     
                                               
library MathUint
{
    using MathUint for uint;

    function mul(
        uint a,
        uint b
        )
        internal
        pure
        returns (uint c)
    {
        c = a * b;
        require(a == 0 || c / a == b, "MUL_OVERFLOW");
    }

    function sub(
        uint a,
        uint b
        )
        internal
        pure
        returns (uint)
    {
        require(b <= a, "SUB_UNDERFLOW");
        return a - b;
    }

    function add(
        uint a,
        uint b
        )
        internal
        pure
        returns (uint c)
    {
        c = a + b;
        require(c >= a, "ADD_OVERFLOW");
    }

    function add64(
        uint64 a,
        uint64 b
        )
        internal
        pure
        returns (uint64 c)
    {
        c = a + b;
        require(c >= a, "ADD_OVERFLOW");
    }
}

// Copyright 2017 Loopring Technology Limited.



// Copyright 2017 Loopring Technology Limited.



                                          
                                               
                                                
library AddressUtil
{
    using AddressUtil for *;

    function isContract(
        address addr
        )
        internal
        view
        returns (bool)
    {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(addr) }
        return (codehash != 0x0 &&
                codehash != 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
    }

    function toPayable(
        address addr
        )
        internal
        pure
        returns (address payable)
    {
        return payable(addr);
    }

    // Works like address.send but with a customizable gas limit
    // Make sure your code is safe for reentrancy when using this function!
    function sendETH(
        address to,
        uint    amount,
        uint    gasLimit
        )
        internal
        returns (bool success)
    {
        if (amount == 0) {
            return true;
        }
        address payable recipient = to.toPayable();
                                      
        (success, ) = recipient.call{value: amount, gas: gasLimit}("");
    }

    // Works like address.transfer but with a customizable gas limit
    // Make sure your code is safe for reentrancy when using this function!
    function sendETHAndVerify(
        address to,
        uint    amount,
        uint    gasLimit
        )
        internal
        returns (bool success)
    {
        success = to.sendETH(amount, gasLimit);
        require(success, "TRANSFER_FAILURE");
    }

    // Works like call but is slightly more efficient when data
    // needs to be copied from memory to do the call.
    function fastCall(
        address to,
        uint    gasLimit,
        uint    value,
        bytes   memory data
        )
        internal
        returns (bool success, bytes memory returnData)
    {
        if (to != address(0)) {
            assembly {
                // Do the call
                success := call(gasLimit, to, value, add(data, 32), mload(data), 0, 0)
                // Copy the return data
                let size := returndatasize()
                returnData := mload(0x40)
                mstore(returnData, size)
                returndatacopy(add(returnData, 32), 0, size)
                // Update free memory pointer
                mstore(0x40, add(returnData, add(32, size)))
            }
        }
    }

    // Like fastCall, but throws when the call is unsuccessful.
    function fastCallAndVerify(
        address to,
        uint    gasLimit,
        uint    value,
        bytes   memory data
        )
        internal
        returns (bytes memory returnData)
    {
        bool success;
        (success, returnData) = fastCall(to, gasLimit, value, data);
        if (!success) {
            assembly {
                revert(add(returnData, 32), mload(returnData))
            }
        }
    }
}


// Copyright 2017 Loopring Technology Limited.



                              
                                                   
                                                
library ERC20SafeTransfer
{
    function safeTransferAndVerify(
        address token,
        address to,
        uint    value
        )
        internal
    {
        safeTransferWithGasLimitAndVerify(
            token,
            to,
            value,
            gasleft()
        );
    }

    function safeTransfer(
        address token,
        address to,
        uint    value
        )
        internal
        returns (bool)
    {
        return safeTransferWithGasLimit(
            token,
            to,
            value,
            gasleft()
        );
    }

    function safeTransferWithGasLimitAndVerify(
        address token,
        address to,
        uint    value,
        uint    gasLimit
        )
        internal
    {
        require(
            safeTransferWithGasLimit(token, to, value, gasLimit),
            "TRANSFER_FAILURE"
        );
    }

    function safeTransferWithGasLimit(
        address token,
        address to,
        uint    value,
        uint    gasLimit
        )
        internal
        returns (bool)
    {
        // A transfer is successful when 'call' is successful and depending on the token:
        // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
        // - A single boolean is returned: this boolean needs to be true (non-zero)

        // bytes4(keccak256("transfer(address,uint256)")) = 0xa9059cbb
        bytes memory callData = abi.encodeWithSelector(
            bytes4(0xa9059cbb),
            to,
            value
        );
        (bool success, ) = token.call{gas: gasLimit}(callData);
        return checkReturnValue(success);
    }

    function safeTransferFromAndVerify(
        address token,
        address from,
        address to,
        uint    value
        )
        internal
    {
        safeTransferFromWithGasLimitAndVerify(
            token,
            from,
            to,
            value,
            gasleft()
        );
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint    value
        )
        internal
        returns (bool)
    {
        return safeTransferFromWithGasLimit(
            token,
            from,
            to,
            value,
            gasleft()
        );
    }

    function safeTransferFromWithGasLimitAndVerify(
        address token,
        address from,
        address to,
        uint    value,
        uint    gasLimit
        )
        internal
    {
        bool result = safeTransferFromWithGasLimit(
            token,
            from,
            to,
            value,
            gasLimit
        );
        require(result, "TRANSFER_FAILURE");
    }

    function safeTransferFromWithGasLimit(
        address token,
        address from,
        address to,
        uint    value,
        uint    gasLimit
        )
        internal
        returns (bool)
    {
        // A transferFrom is successful when 'call' is successful and depending on the token:
        // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
        // - A single boolean is returned: this boolean needs to be true (non-zero)

        // bytes4(keccak256("transferFrom(address,address,uint256)")) = 0x23b872dd
        bytes memory callData = abi.encodeWithSelector(
            bytes4(0x23b872dd),
            from,
            to,
            value
        );
        (bool success, ) = token.call{gas: gasLimit}(callData);
        return checkReturnValue(success);
    }

    function checkReturnValue(
        bool success
        )
        internal
        pure
        returns (bool)
    {
        // A transfer/transferFrom is successful when 'call' is successful and depending on the token:
        // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
        // - A single boolean is returned: this boolean needs to be true (non-zero)
        if (success) {
            assembly {
                switch returndatasize()
                // Non-standard ERC20: nothing is returned so if 'call' was successful we assume the transfer succeeded
                case 0 {
                    success := 1
                }
                // Standard ERC20: a single boolean value is returned which needs to be true
                case 32 {
                    returndatacopy(0, 0, 32)
                    success := mload(0)
                }
                // None of the above: not successful
                default {
                    success := 0
                }
            }
        }
        return success;
    }
}


// Copyright 2017 Loopring Technology Limited.



                          
                                                
                                                                     
                                                                                     
                                                                          
                                                 
contract ReentrancyGuard
{
    //The default value must be 0 in order to work behind a proxy.
    uint private _guardValue;

    // Use this modifier on a function to prevent reentrancy
    modifier nonReentrant()
    {
        // Check if the guard value has its original value
        require(_guardValue == 0, "REENTRANCY");

        // Set the value to something else
        _guardValue = 1;

        // Function body
        _;

        // Set the value back
        _guardValue = 0;
    }
}


// Copyright 2017 Loopring Technology Limited.

pragma experimental ABIEncoderV2;



// Copyright 2017 Loopring Technology Limited.




// Copyright 2017 Loopring Technology Limited.


interface IAgent{}

interface IAgentRegistry
{
                                                                             
                                       
                                      
                                                                                       
    function isAgent(
        address owner,
        address agent
        )
        external
        view
        returns (bool);

                                                                               
                                         
                                      
                                                                                       
    function isAgent(
        address[] calldata owners,
        address            agent
        )
        external
        view
        returns (bool);
}


// Copyright 2017 Loopring Technology Limited.






                         
                                                
abstract contract IBlockVerifier is Claimable
{
    // -- Events --

    event CircuitRegistered(
        uint8  indexed blockType,
        uint16         blockSize,
        uint8          blockVersion
    );

    event CircuitDisabled(
        uint8  indexed blockType,
        uint16         blockSize,
        uint8          blockVersion
    );

    // -- Public functions --

                                                              
                                                                                  
                                                                              
                                
                                              
                                                                    
                                                                                           
                                      
    function registerCircuit(
        uint8    blockType,
        uint16   blockSize,
        uint8    blockVersion,
        uint[18] calldata vk
        )
        external
        virtual;

                                                       
                                                                                                       
                                   
                                              
                                                                    
                                                                                           
    function disableCircuit(
        uint8  blockType,
        uint16 blockSize,
        uint8  blockVersion
        )
        external
        virtual;

                                                                   
                                                                           
                                                   
                                          
                                                                    
                                                                                           
                                                                         
                                                                       
                                                           
    function verifyProofs(
        uint8  blockType,
        uint16 blockSize,
        uint8  blockVersion,
        uint[] calldata publicInputs,
        uint[] calldata proofs
        )
        external
        virtual
        view
        returns (bool);

                                                                             
                                              
                                                                    
                                                                                           
                                                                  
    function isCircuitRegistered(
        uint8  blockType,
        uint16 blockSize,
        uint8  blockVersion
        )
        external
        virtual
        view
        returns (bool);

                                                                        
                                              
                                                                    
                                                                                           
                                                               
    function isCircuitEnabled(
        uint8  blockType,
        uint16 blockSize,
        uint8  blockVersion
        )
        external
        virtual
        view
        returns (bool);
}


// Copyright 2017 Loopring Technology Limited.



                            
                                                                   
///
                                                                                           
                                                                                     
                                                                                      
                                                           
                                                
interface IDepositContract
{
                                                               
    function isTokenSupported(address token)
        external
        view
        returns (bool);

                                                                             
                                                                  
                                                                              
                                                                                         
                                                                                       
                                                                   
    ///
                                                                 
    ///
                                                              
    ///
                                                                     
                                                                          
                                                       
                                                                                           
                                                                                             
    function deposit(
        address from,
        address token,
        uint96  amount,
        bytes   calldata extraData
        )
        external
        payable
        returns (uint96 amountReceived);

                                                                             
                                                                            
                                                                                  
                                                                                         
                                                                           
                                                                            
                                                                                      
                                            
    ///
                                                                 
    ///
                                                              
    ///
                                                                           
                                                                       
                                                                          
                                                       
                                                                                              
    function withdraw(
        address from,
        address to,
        address token,
        uint    amount,
        bytes   calldata extraData
        )
        external
        payable;

                                                                                    
                                                                                           
                                                     
                                                                                    
                                                                                                 
                                                                                           
                                               
    ///
                                                                 
    ///
                                                              
    ///
                                                                     
                                                                       
                                                                                            
                                                       
    function transfer(
        address from,
        address to,
        address token,
        uint    amount
        )
        external
        payable;

                                                                           
                                                                                             
    ///
                                                                                               
                                                                                                 
                                                                                   
    ///
                                        
                                                                           
    function isETH(address addr)
        external
        view
        returns (bool);
}



                       
                                                                          
                                              
                                                
                                                
library ExchangeData
{
    // -- Enums --
    enum TransactionType
    {
        NOOP,
        DEPOSIT,
        WITHDRAWAL,
        TRANSFER,
        SPOT_TRADE,
        ACCOUNT_UPDATE,
        AMM_UPDATE
    }

    // -- Structs --
    struct Token
    {
        address token;
    }

    struct ProtocolFeeData
    {
        uint32 syncedAt; // only valid before 2105 (85 years to go)
        uint8  takerFeeBips;
        uint8  makerFeeBips;
        uint8  previousTakerFeeBips;
        uint8  previousMakerFeeBips;
    }

    // General auxiliary data for each conditional transaction
    struct AuxiliaryData
    {
        uint  txIndex;
        bytes data;
    }

    // This is the (virtual) block the owner  needs to submit onchain to maintain the
    // per-exchange (virtual) blockchain.
    struct Block
    {
        uint8      blockType;
        uint16     blockSize;
        uint8      blockVersion;
        bytes      data;
        uint256[8] proof;

        // Whether we should store the @BlockInfo for this block on-chain.
        bool storeBlockInfoOnchain;

        // Block specific data that is only used to help process the block on-chain.
        // It is not used as input for the circuits and it is not necessary for data-availability.
        AuxiliaryData[] auxiliaryData;

        // Arbitrary data, mainly for off-chain data-availability, i.e.,
        // the multihash of the IPFS file that contains the block data.
        bytes offchainData;
    }

    struct BlockInfo
    {
        // The time the block was submitted on-chain.
        uint32  timestamp;
        // The public data hash of the block (the 28 most significant bytes).
        bytes28 blockDataHash;
    }

    // Represents an onchain deposit request.
    struct Deposit
    {
        uint96 amount;
        uint64 timestamp;
    }

    // A forced withdrawal request.
    // If the actual owner of the account initiated the request (we don't know who the owner is
    // at the time the request is being made) the full balance will be withdrawn.
    struct ForcedWithdrawal
    {
        address owner;
        uint64  timestamp;
    }

    struct Constants
    {
        uint SNARK_SCALAR_FIELD;
        uint MAX_OPEN_FORCED_REQUESTS;
        uint MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE;
        uint TIMESTAMP_HALF_WINDOW_SIZE_IN_SECONDS;
        uint MAX_NUM_ACCOUNTS;
        uint MAX_NUM_TOKENS;
        uint MIN_AGE_PROTOCOL_FEES_UNTIL_UPDATED;
        uint MIN_TIME_IN_SHUTDOWN;
        uint TX_DATA_AVAILABILITY_SIZE;
        uint MAX_AGE_DEPOSIT_UNTIL_WITHDRAWABLE_UPPERBOUND;
    }

    function SNARK_SCALAR_FIELD() internal pure returns (uint) {
        // This is the prime number that is used for the alt_bn128 elliptic curve, see EIP-196.
        return 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    }
    function MAX_OPEN_FORCED_REQUESTS() internal pure returns (uint16) { return 4096; }
    function MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE() internal pure returns (uint32) { return 15 days; }
    function TIMESTAMP_HALF_WINDOW_SIZE_IN_SECONDS() internal pure returns (uint32) { return 7 days; }
    function MAX_NUM_ACCOUNTS() internal pure returns (uint) { return 2 ** 32; }
    function MAX_NUM_TOKENS() internal pure returns (uint) { return 2 ** 16; }
    function MIN_AGE_PROTOCOL_FEES_UNTIL_UPDATED() internal pure returns (uint32) { return 7 days; }
    function MIN_TIME_IN_SHUTDOWN() internal pure returns (uint32) { return 30 days; }
    // The amount of bytes each rollup transaction uses in the block data for data-availability.
    // This is the maximum amount of bytes of all different transaction types.
    function TX_DATA_AVAILABILITY_SIZE() internal pure returns (uint32) { return 68; }
    function MAX_AGE_DEPOSIT_UNTIL_WITHDRAWABLE_UPPERBOUND() internal pure returns (uint32) { return 15 days; }
    function ACCOUNTID_PROTOCOLFEE() internal pure returns (uint32) { return 0; }

    function TX_DATA_AVAILABILITY_SIZE_PART_1() internal pure returns (uint32) { return 29; }
    function TX_DATA_AVAILABILITY_SIZE_PART_2() internal pure returns (uint32) { return 39; }

    struct AccountLeaf
    {
        uint32   accountID;
        address  owner;
        uint     pubKeyX;
        uint     pubKeyY;
        uint32   nonce;
        uint     feeBipsAMM;
    }

    struct BalanceLeaf
    {
        uint16   tokenID;
        uint96   balance;
        uint96   weightAMM;
        uint     storageRoot;
    }

    struct MerkleProof
    {
        ExchangeData.AccountLeaf accountLeaf;
        ExchangeData.BalanceLeaf balanceLeaf;
        uint[48]                 accountMerkleProof;
        uint[24]                 balanceMerkleProof;
    }

    struct BlockContext
    {
        bytes32 DOMAIN_SEPARATOR;
        uint32  timestamp;
    }

    // Represents the entire exchange state except the owner of the exchange.
    struct State
    {
        uint32  maxAgeDepositUntilWithdrawable;
        bytes32 DOMAIN_SEPARATOR;

        ILoopringV3      loopring;
        IBlockVerifier   blockVerifier;
        IAgentRegistry   agentRegistry;
        IDepositContract depositContract;


        // The merkle root of the offchain data stored in a Merkle tree. The Merkle tree
        // stores balances for users using an account model.
        bytes32 merkleRoot;

        // List of all blocks
        mapping(uint => BlockInfo) blocks;
        uint  numBlocks;

        // List of all tokens
        Token[] tokens;

        // A map from a token to its tokenID + 1
        mapping (address => uint16) tokenToTokenId;

        // A map from an accountID to a tokenID to if the balance is withdrawn
        mapping (uint32 => mapping (uint16 => bool)) withdrawnInWithdrawMode;

        // A map from an account to a token to the amount withdrawable for that account.
        // This is only used when the automatic distribution of the withdrawal failed.
        mapping (address => mapping (uint16 => uint)) amountWithdrawable;

        // A map from an account to a token to the forced withdrawal (always full balance)
        mapping (uint32 => mapping (uint16 => ForcedWithdrawal)) pendingForcedWithdrawals;

        // A map from an address to a token to a deposit
        mapping (address => mapping (uint16 => Deposit)) pendingDeposits;

        // A map from an account owner to an approved transaction hash to if the transaction is approved or not
        mapping (address => mapping (bytes32 => bool)) approvedTx;

        // A map from an account owner to a destination address to a tokenID to an amount to a storageID to a new recipient address
        mapping (address => mapping (address => mapping (uint16 => mapping (uint => mapping (uint32 => address))))) withdrawalRecipient;


        // Counter to keep track of how many of forced requests are open so we can limit the work that needs to be done by the owner
        uint32 numPendingForcedTransactions;

        // Cached data for the protocol fee
        ProtocolFeeData protocolFeeData;

        // Time when the exchange was shutdown
        uint shutdownModeStartTime;

        // Time when the exchange has entered withdrawal mode
        uint withdrawalModeStartTime;

        // Last time the protocol fee was withdrawn for a specific token
        mapping (address => uint) protocolFeeLastWithdrawnTime;
    }
}



                      
                                                                     
                                                                       
                                                       
///
                                                                   
                         
///
                                                
                                                
abstract contract IExchangeV3 is Claimable
{
    // -- Events --

    event ExchangeCloned(
        address exchangeAddress,
        address owner,
        bytes32 genesisMerkleRoot
    );

    event TokenRegistered(
        address token,
        uint16  tokenId
    );

    event Shutdown(
        uint timestamp
    );

    event WithdrawalModeActivated(
        uint timestamp
    );

    event BlockSubmitted(
        uint    indexed blockIdx,
        bytes32         merkleRoot,
        bytes32         publicDataHash
    );

    event DepositRequested(
        address from,
        address to,
        address token,
        uint16  tokenId,
        uint96  amount
    );

    event ForcedWithdrawalRequested(
        address owner,
        address token,
        uint32  accountID
    );

    event WithdrawalCompleted(
        uint8   category,
        address from,
        address to,
        address token,
        uint    amount
    );

    event WithdrawalFailed(
        uint8   category,
        address from,
        address to,
        address token,
        uint    amount
    );

    event ProtocolFeesUpdated(
        uint8 takerFeeBips,
        uint8 makerFeeBips,
        uint8 previousTakerFeeBips,
        uint8 previousMakerFeeBips
    );

    event TransactionApproved(
        address owner,
        bytes32 transactionHash
    );

    // events from libraries
                                                                                                                                     

                                                                                                                           

                                                                                                                                          

                                                                                   


    // -- Initialization --
                                                                            
                                                         
                                                 
                                                                
    function initialize(
        address loopring,
        address owner,
        bytes32 genesisMerkleRoot
        )
        virtual
        external;

                                                                          
                                                           
                                                                   
    function setAgentRegistry(address agentRegistry)
        external
        virtual;

                                                                   
                                           
    function getAgentRegistry()
        external
        virtual
        view
        returns (IAgentRegistry);

                                                           
                                                              
    function setDepositContract(address depositContract)
        external
        virtual;

                                                            
                                    
    function getDepositContract()
        external
        virtual
        view
        returns (IDepositContract);

    // @dev Exchange owner withdraws fees from the exchange.
    // @param token Fee token address
    // @param feeRecipient Fee recipient address
    function withdrawExchangeFees(
        address token,
        address feeRecipient
        )
        external
        virtual;

    // -- Constants --
                                                              
                                                
    function getConstants()
        external
        virtual
        pure
        returns(ExchangeData.Constants memory);

    // -- Mode --
                                                               
                                                                               
    function isInWithdrawalMode()
        external
        virtual
        view
        returns (bool);

                                                      
                                                                     
    function isShutdown()
        external
        virtual
        view
        returns (bool);

    // -- Tokens --
                                                                                            
                                                    
    ///
                                                                                                   
                                                        
    ///
                                                                  
    ///
                                                
                                                         
    function registerToken(
        address tokenAddress
        )
        external
        virtual
        returns (uint16 tokenID);

                                                  
                                                
                                                         
    function getTokenID(
        address tokenAddress
        )
        external
        virtual
        view
        returns (uint16 tokenID);

                                                       
                                                         
                                                
    function getTokenAddress(
        uint16 tokenID
        )
        external
        virtual
        view
        returns (address tokenAddress);

    // -- Stakes --
                                                                                   
                                                                                  
                                                                                              
                                                                               
    ///
                                        
    function getExchangeStake()
        external
        virtual
        view
        returns (uint);

                                                           
                                                                               
                                                           
                                                 
                                                                                          
    ///
                                                      
    ///
                                                     
    function withdrawExchangeStake(
        address recipient
        )
        external
        virtual
        returns (uint amountLRC);

                                                                                   
                                      
    ///
                                                                       
                                                
    function burnExchangeStake()
        external
        virtual;

    // -- Blocks --

                                                                                
                                        
    function getMerkleRoot()
        external
        virtual
        view
        returns (bytes32);

                                                                                          
                               
                                                                                   
    function getBlockHeight()
        external
        virtual
        view
        returns (uint);

                                                                                        
                                                                                    
                                                       
                                        
    function getBlockInfo(uint blockIdx)
        external
        virtual
        view
        returns (ExchangeData.BlockInfo memory);

                                                         
    ///
                                                                       
    ///
                                                
                                                   
                                                                                
                                                     
                                                                               
                                                                                                  
                                            
                                                                                          
                                                                           
    function submitBlocks(ExchangeData.Block[] calldata blocks)
        external
        virtual;

                                                               
                                              
    function getNumAvailableForcedSlots()
        external
        virtual
        view
        returns (uint);

    // -- Deposits --

                                                                     
    ///
                                                                  
    ///
                                                                      
                                                                               
                            
    ///
                                                                       
                                                                 
                                                                          
                                                     
                                                                             
    function deposit(
        address from,
        address to,
        address tokenAddress,
        uint96  amount,
        bytes   calldata auxiliaryData
        )
        external
        virtual
        payable;

                                                                                
                                                                      
                                                                          
                                             
    function getPendingDepositAmount(
        address owner,
        address tokenAddress
        )
        external
        virtual
        view
        returns (uint96);

    // -- Withdrawals --
                                                                                
                                                            
    ///
                                                                       
    ///
                                                                                
                                                                                 
    ///
                                                                           
                                                                                                  
                                                            
    ///
                                                      
                                                                          
                                                                    
    function forceWithdraw(
        address owner,
        address tokenAddress,
        uint32  accountID
        )
        external
        virtual
        payable;

                                                                             
                                                                
                                       
                                                             
    function isForcedWithdrawalPending(
        uint32  accountID,
        address token
        )
        external
        virtual
        view
        returns (bool);

                                                                                  
                                                                             
    ///
                                                                  
    ///
                                                                           
                                                                                                  
                                                            
    ///
                                                                          
    function withdrawProtocolFees(
        address tokenAddress
        )
        external
        virtual
        payable;

                                                                           
                                                                          
                                                             
    function getProtocolFeeLastWithdrawnTime(
        address tokenAddress
        )
        external
        virtual
        view
        returns (uint);

                                                                                           
                                                                                   
    ///
                                                                                 
                                                                          
    ///
                                                                                 
                                                                                    
                                                                        
    ///
                                                      
    function withdrawFromMerkleTree(
        ExchangeData.MerkleProof calldata merkleProof
        )
        external
        virtual;

                                                                                               
                                                                
                                       
                                                                 
    function isWithdrawnInWithdrawalMode(
        uint32  accountID,
        address token
        )
        external
        virtual
        view
        returns (bool);

                                                                                         
                                                                                 
    ///
                                                                               
                                                             
    ///
                                                                             
                                       
    function withdrawFromDepositRequest(
        address owner,
        address token
        )
        external
        virtual;

                                                                                
                                                                   
    ///
                                                                          
                                                              
    ///
                                                                                 
                                                                             
                                                                  
                                                                                     
    ///
                                                       
    ///
                                                                                
                                          
    function withdrawFromApprovedWithdrawals(
        address[] calldata owners,
        address[] calldata tokens
        )
        external
        virtual;

                                                                                                      
                                                                             
                                       
                                       
    function getAmountWithdrawable(
        address owner,
        address token
        )
        external
        virtual
        view
        returns (uint);

                                                                                   
                                                                                 
    ///
                                     
    ///
                                                                       
                                                                 
    function notifyForcedRequestTooOld(
        uint32  accountID,
        address token
        )
        external
        virtual;

                                                                             
                                                                                   
                                                           
    ///
                                                          
    ///
                                                                        
                                                                                  
                                                                                
                                                                          
                                                                 
                                                                        
    function setWithdrawalRecipient(
        address from,
        address to,
        address token,
        uint96  amount,
        uint32  storageID,
        address newRecipient
        )
        external
        virtual;

                                           
    ///
                                                                        
                                                                                  
                                                                                
                                                                          
                                                                 
    function getWithdrawalRecipient(
        address from,
        address to,
        address token,
        uint96  amount,
        uint32  storageID
        )
        external
        virtual
        view
        returns (address);

                                                                                     
                                                                                                                  
                                                                                               
    ///
                                                          
    ///
                                                                     
                                                                       
                                                                                            
                                                       
    function onchainTransferFrom(
        address from,
        address to,
        address token,
        uint    amount
        )
        external
        virtual;

                                                    
    ///
                                                          
    ///
                                             
                                                 
    function approveTransaction(
        address owner,
        bytes32 txHash
        )
        external
        virtual;

                                                            
    ///
                                                          
    ///
                                        
                                                      
    function approveTransactions(
        address[] calldata owners,
        bytes32[] calldata txHashes
        )
        external
        virtual;

                                                                   
    ///
                                                                            
                                                 
                                                      
    function isTransactionApproved(
        address owner,
        bytes32 txHash
        )
        external
        virtual
        view
        returns (bool);

    // -- Admins --
                                                                                  
                                      
                               
    function setMaxAgeDepositUntilWithdrawable(
        uint32 newValue
        )
        external
        virtual
        returns (uint32);

                                                                                     
                          
    function getMaxAgeDepositUntilWithdrawable()
        external
        virtual
        view
        returns (uint32);

                                     
                                                                                         
                                                                                
                                                   
    ///
                                                                                           
                                                                                              
                                                                                                 
                                                       
    ///
                                                      
    ///
                                                                    
    function shutdown()
        external
        virtual
        returns (bool success);

                                                      
                                                                          
                                                   
                                                   
                                                                    
                                                                    
    function getProtocolFeeValues()
        external
        virtual
        view
        returns (
            uint32 syncedAt,
            uint8 takerFeeBips,
            uint8 makerFeeBips,
            uint8 previousTakerFeeBips,
            uint8 previousMakerFeeBips
        );

                                                             
    function getDomainSeparator()
        external
        virtual
        view
        returns (bytes32);
}


// Copyright 2017 Loopring Technology Limited.





                      
                                                
                                                
abstract contract ILoopringV3 is Claimable
{
    // == Events ==
    event ExchangeStakeDeposited(address exchangeAddr, uint amount);
    event ExchangeStakeWithdrawn(address exchangeAddr, uint amount);
    event ExchangeStakeBurned(address exchangeAddr, uint amount);
    event SettingsUpdated(uint time);

    // == Public Variables ==
    mapping (address => uint) internal exchangeStake;

    address public lrcAddress;
    uint    public totalStake;
    address public blockVerifierAddress;
    uint    public forcedWithdrawalFee;
    uint    public tokenRegistrationFeeLRCBase;
    uint    public tokenRegistrationFeeLRCDelta;
    uint8   public protocolTakerFeeBips;
    uint8   public protocolMakerFeeBips;

    address payable public protocolFeeVault;

    // == Public Functions ==
                                                  
                                                                            
    ///
                                                                   
                                    
    function updateSettings(
        address payable _protocolFeeVault,   // address(0) not allowed
        address _blockVerifierAddress,       // address(0) not allowed
        uint    _forcedWithdrawalFee
        )
        external
        virtual;

                                                      
                                                                            
    ///
                                                                   
                                    
    function updateProtocolFeeSettings(
        uint8 _protocolTakerFeeBips,
        uint8 _protocolMakerFeeBips
        )
        external
        virtual;

                                                           
                                                       
                                           
    function getExchangeStake(
        address exchangeAddr
        )
        public
        virtual
        view
        returns (uint stakedLRC);

                                                                          
                                                                              
                                                                                 
                                                                 
    function burnExchangeStake(
        uint amount
        )
        external
        virtual
        returns (uint burnedLRC);

                                             
                                                        
                                                    
                                                                         
    function depositExchangeStake(
        address exchangeAddr,
        uint    amountLRC
        )
        external
        virtual
        returns (uint stakedLRC);

                                                                                           
                                                                                     
                                                    
                                                             
                                                     
    function withdrawExchangeStake(
        address recipient,
        uint    requestedAmount
        )
        external
        virtual
        returns (uint amountLRC);

                                                          
                                                   
                                                   
    function getProtocolFeeValues(
        )
        public
        virtual
        view
        returns (
            uint8 takerFeeBips,
            uint8 makerFeeBips
        );
}



                     
                                              
                                                
                                                
contract LoopringV3 is ILoopringV3, ReentrancyGuard
{
    using AddressUtil       for address payable;
    using MathUint          for uint;
    using ERC20SafeTransfer for address;

    // -- Constructor --
    constructor(
        address _lrcAddress,
        address payable _protocolFeeVault,
        address _blockVerifierAddress
        )
        Claimable()
    {
        require(address(0) != _lrcAddress, "ZERO_ADDRESS");

        lrcAddress = _lrcAddress;

        updateSettingsInternal(_protocolFeeVault, _blockVerifierAddress, 0);
    }

    // == Public Functions ==
    function updateSettings(
        address payable _protocolFeeVault,
        address _blockVerifierAddress,
        uint    _forcedWithdrawalFee
        )
        external
        override
        nonReentrant
        onlyOwner
    {
        updateSettingsInternal(
            _protocolFeeVault,
            _blockVerifierAddress,
            _forcedWithdrawalFee
        );
    }

    function updateProtocolFeeSettings(
        uint8 _protocolTakerFeeBips,
        uint8 _protocolMakerFeeBips
        )
        external
        override
        nonReentrant
        onlyOwner
    {
        protocolTakerFeeBips = _protocolTakerFeeBips;
        protocolMakerFeeBips = _protocolMakerFeeBips;

        emit SettingsUpdated(block.timestamp);
    }

    function getExchangeStake(
        address exchangeAddr
        )
        public
        override
        view
        returns (uint)
    {
        return exchangeStake[exchangeAddr];
    }

    function burnExchangeStake(
        uint amount
        )
        external
        override
        nonReentrant
        returns (uint burnedLRC)
    {
        burnedLRC = exchangeStake[msg.sender];

        if (amount < burnedLRC) {
            burnedLRC = amount;
        }
        if (burnedLRC > 0) {
            lrcAddress.safeTransferAndVerify(protocolFeeVault, burnedLRC);
            exchangeStake[msg.sender] = exchangeStake[msg.sender].sub(burnedLRC);
            totalStake = totalStake.sub(burnedLRC);
        }
        emit ExchangeStakeBurned(msg.sender, burnedLRC);
    }

    function depositExchangeStake(
        address exchangeAddr,
        uint    amountLRC
        )
        external
        override
        nonReentrant
        returns (uint stakedLRC)
    {
        require(amountLRC > 0, "ZERO_VALUE");

        lrcAddress.safeTransferFromAndVerify(msg.sender, address(this), amountLRC);

        stakedLRC = exchangeStake[exchangeAddr].add(amountLRC);
        exchangeStake[exchangeAddr] = stakedLRC;
        totalStake = totalStake.add(amountLRC);

        emit ExchangeStakeDeposited(exchangeAddr, amountLRC);
    }

    function withdrawExchangeStake(
        address recipient,
        uint    requestedAmount
        )
        external
        override
        nonReentrant
        returns (uint amountLRC)
    {
        uint stake = exchangeStake[msg.sender];
        amountLRC = (stake > requestedAmount) ? requestedAmount : stake;

        if (amountLRC > 0) {
            lrcAddress.safeTransferAndVerify(recipient, amountLRC);
            exchangeStake[msg.sender] = exchangeStake[msg.sender].sub(amountLRC);
            totalStake = totalStake.sub(amountLRC);
        }

        emit ExchangeStakeWithdrawn(msg.sender, amountLRC);
    }

    function getProtocolFeeValues()
        public
        override
        view
        returns (
            uint8 takerFeeBips,
            uint8 makerFeeBips
        )
    {
        return (protocolTakerFeeBips, protocolMakerFeeBips);
    }

    // == Internal Functions ==
    function updateSettingsInternal(
        address payable  _protocolFeeVault,
        address _blockVerifierAddress,
        uint    _forcedWithdrawalFee
        )
        private
    {
        require(address(0) != _protocolFeeVault, "ZERO_ADDRESS");
        require(address(0) != _blockVerifierAddress, "ZERO_ADDRESS");

        protocolFeeVault = _protocolFeeVault;
        blockVerifierAddress = _blockVerifierAddress;
        forcedWithdrawalFee = _forcedWithdrawalFee;

        emit SettingsUpdated(block.timestamp);
    }
}