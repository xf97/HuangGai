/**
 *Submitted for verification at Etherscan.io on 2020-07-22
*/

pragma solidity ^0.5.0;

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/*
 * This code has not been reviewed.
 * Do not use or deploy this code before reviewing it personally first.
 */



contract ERC1820Implementer {
  bytes32 constant ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));

  mapping(bytes32 => bool) internal _interfaceHashes;

  function canImplementInterfaceForAddress(bytes32 interfaceHash, address /*addr*/) // Comments to avoid compilation warnings for unused variables.
    external
    view
    returns(bytes32)
  {
    if(_interfaceHashes[interfaceHash]) {
      return ERC1820_ACCEPT_MAGIC;
    } else {
      return "";
    }
  }

  function _setInterface(string memory interfaceLabel) internal {
    _interfaceHashes[keccak256(abi.encodePacked(interfaceLabel))] = true;
  }

}

/*
 * This code has not been reviewed.
 * Do not use or deploy this code before reviewing it personally first.
 */


/**
 * @title IERC1400 security token standard
 * @dev See https://github.com/SecurityTokenStandard/EIP-Spec/blob/master/eip/eip-1400.md
 */
interface IERC1400 /*is IERC20*/ { // Interfaces can currently not inherit interfaces, but IERC1400 shall include IERC20

  // ****************** Document Management *******************
  function getDocument(bytes32 name) external view returns (string memory, bytes32);
  function setDocument(bytes32 name, string calldata uri, bytes32 documentHash) external;

  // ******************* Token Information ********************
  function balanceOfByPartition(bytes32 partition, address tokenHolder) external view returns (uint256);
  function partitionsOf(address tokenHolder) external view returns (bytes32[] memory);

  // *********************** Transfers ************************
  function transferWithData(address to, uint256 value, bytes calldata data) external;
  function transferFromWithData(address from, address to, uint256 value, bytes calldata data) external;

  // *************** Partition Token Transfers ****************
  function transferByPartition(bytes32 partition, address to, uint256 value, bytes calldata data) external returns (bytes32);
  function operatorTransferByPartition(bytes32 partition, address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData) external returns (bytes32);

  // ****************** Controller Operation ******************
  function isControllable() external view returns (bool);
  // function controllerTransfer(address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData) external; // removed because same action can be achieved with "operatorTransferByPartition"
  // function controllerRedeem(address tokenHolder, uint256 value, bytes calldata data, bytes calldata operatorData) external; // removed because same action can be achieved with "operatorRedeemByPartition"

  // ****************** Operator Management *******************
  function authorizeOperator(address operator) external;
  function revokeOperator(address operator) external;
  function authorizeOperatorByPartition(bytes32 partition, address operator) external;
  function revokeOperatorByPartition(bytes32 partition, address operator) external;

  // ****************** Operator Information ******************
  function isOperator(address operator, address tokenHolder) external view returns (bool);
  function isOperatorForPartition(bytes32 partition, address operator, address tokenHolder) external view returns (bool);

  // ********************* Token Issuance *********************
  function isIssuable() external view returns (bool);
  function issue(address tokenHolder, uint256 value, bytes calldata data) external;
  function issueByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata data) external;

  // ******************** Token Redemption ********************
  function redeem(uint256 value, bytes calldata data) external;
  function redeemFrom(address tokenHolder, uint256 value, bytes calldata data) external;
  function redeemByPartition(bytes32 partition, uint256 value, bytes calldata data) external;
  function operatorRedeemByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata operatorData) external;

  // ******************* Transfer Validity ********************
  // We use different transfer validity functions because those described in the interface don't allow to verify the certificate's validity.
  // Indeed, verifying the ecrtificate's validity requires to keeps the function's arguments in the exact same order as the transfer function.
  //
  // function canTransfer(address to, uint256 value, bytes calldata data) external view returns (byte, bytes32);
  // function canTransferFrom(address from, address to, uint256 value, bytes calldata data) external view returns (byte, bytes32);
  // function canTransferByPartition(address from, address to, bytes32 partition, uint256 value, bytes calldata data) external view returns (byte, bytes32, bytes32);    

  // ******************* Controller Events ********************
  // We don't use this event as we don't use "controllerTransfer"
  //   event ControllerTransfer(
  //       address controller,
  //       address indexed from,
  //       address indexed to,
  //       uint256 value,
  //       bytes data,
  //       bytes operatorData
  //   );
  //
  // We don't use this event as we don't use "controllerRedeem"
  //   event ControllerRedemption(
  //       address controller,
  //       address indexed tokenHolder,
  //       uint256 value,
  //       bytes data,
  //       bytes operatorData
  //   );

  // ******************** Document Events *********************
  event Document(bytes32 indexed name, string uri, bytes32 documentHash);

  // ******************** Transfer Events *********************
  event TransferByPartition(
      bytes32 indexed fromPartition,
      address operator,
      address indexed from,
      address indexed to,
      uint256 value,
      bytes data,
      bytes operatorData
  );

  event ChangedPartition(
      bytes32 indexed fromPartition,
      bytes32 indexed toPartition,
      uint256 value
  );

  // ******************** Operator Events *********************
  event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
  event RevokedOperator(address indexed operator, address indexed tokenHolder);
  event AuthorizedOperatorByPartition(bytes32 indexed partition, address indexed operator, address indexed tokenHolder);
  event RevokedOperatorByPartition(bytes32 indexed partition, address indexed operator, address indexed tokenHolder);

  // ************** Issuance / Redemption Events **************
  event Issued(address indexed operator, address indexed to, uint256 value, bytes data);
  event Redeemed(address indexed operator, address indexed from, uint256 value, bytes data);
  event IssuedByPartition(bytes32 indexed partition, address indexed operator, address indexed to, uint256 value, bytes data, bytes operatorData);
  event RedeemedByPartition(bytes32 indexed partition, address indexed operator, address indexed from, uint256 value, bytes operatorData);

}

/**
 * Reason codes - ERC-1066
 *
 * To improve the token holder experience, canTransfer MUST return a reason byte code
 * on success or failure based on the ERC-1066 application-specific status codes specified below.
 * An implementation can also return arbitrary data as a bytes32 to provide additional
 * information not captured by the reason code.
 * 
 * Code	Reason
 * 0x50	transfer failure
 * 0x51	transfer success
 * 0x52	insufficient balance
 * 0x53	insufficient allowance
 * 0x54	transfers halted (contract paused)
 * 0x55	funds locked (lockup period)
 * 0x56	invalid sender
 * 0x57	invalid receiver
 * 0x58	invalid operator (transfer agent)
 * 0x59	
 * 0x5a	
 * 0x5b	
 * 0x5a	
 * 0x5b	
 * 0x5c	
 * 0x5d	
 * 0x5e	
 * 0x5f	token meta or info
 *
 * These codes are being discussed at: https://ethereum-magicians.org/t/erc-1066-ethereum-status-codes-esc/283/24
 */

/*
 * This code has not been reviewed.
 * Do not use or deploy this code before reviewing it personally first.
 */








interface IERC1400Extended {
    // Not a real interface but added here since 'totalSupplyByPartition' doesn't belong to IERC1400

    function totalSupplyByPartition(bytes32 partition)
        external
        view
        returns (uint256);
}

/**
 * @title BatchBalanceReader
 * @dev Proxy contract to read multiple ERC1400/ERC20 token balances in a single contract call.
 */
contract BatchBalanceReader is ERC1820Implementer {
    string internal constant BALANCE_READER = "BatchBalanceReader";

    constructor() public {
        ERC1820Implementer._setInterface(BALANCE_READER);
    }

    /**
     * @dev Get a batch of ERC1400 token balances.
     * @param tokenHolders Addresses for which the balance is required.
     * @param tokenAddresses Addresses of tokens where the balances need to be fetched.
     * @param partitions Name of the partitions.
     * @return Balances array.
     */
    function balancesOfByPartition(
        address[] calldata tokenHolders,
        address[] calldata tokenAddresses,
        bytes32[] calldata partitions
    ) external view returns (uint256[] memory) {
        uint256[] memory partitionBalances = new uint256[](
            tokenAddresses.length * partitions.length * tokenHolders.length
        );
        uint256 index;
        for (uint256 i = 0; i < tokenHolders.length; i++) {
            for (uint256 j = 0; j < tokenAddresses.length; j++) {
                for (uint256 k = 0; k < partitions.length; k++) {
                    index =
                        i *
                        (tokenAddresses.length * partitions.length) +
                        j *
                        partitions.length +
                        k;
                    partitionBalances[index] = IERC1400(tokenAddresses[j])
                        .balanceOfByPartition(partitions[k], tokenHolders[i]);
                }
            }
        }

        return partitionBalances;
    }

    /**
     * @dev Get a batch of ERC20 token balances.
     * @param tokenHolders Addresses for which the balance is required.
     * @param tokenAddresses Addresses of tokens where the balances need to be fetched.
     * @return Balances array.
     */
    function balancesOf(
        address[] calldata tokenHolders,
        address[] calldata tokenAddresses
    ) external view returns (uint256[] memory) {
        uint256[] memory balances = new uint256[](
            tokenHolders.length * tokenAddresses.length
        );
        uint256 index;
        for (uint256 i = 0; i < tokenHolders.length; i++) {
            for (uint256 j = 0; j < tokenAddresses.length; j++) {
                index = i * tokenAddresses.length + j;
                balances[index] = IERC20(tokenAddresses[j]).balanceOf(
                    tokenHolders[i]
                );
            }
        }
        return balances;
    }

    /**
     * @dev Get a batch of ERC1400 token total supplies by partitions.
     * @param partitions Name of the partitions.
     * @param tokenAddresses Addresses of tokens where the balances need to be fetched.
     * @return Balances array.
     */
    function totalSuppliesByPartition(
        bytes32[] calldata partitions,
        address[] calldata tokenAddresses
    ) external view returns (uint256[] memory) {
        uint256[] memory partitionSupplies = new uint256[](
            partitions.length * tokenAddresses.length
        );
        uint256 index;
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            for (uint256 j = 0; j < partitions.length; j++) {
                index = i * partitions.length + j;
                partitionSupplies[index] = IERC1400Extended(tokenAddresses[i])
                    .totalSupplyByPartition(partitions[j]);
            }
        }
        return partitionSupplies;
    }

    /**
     * @dev Get a batch of ERC20 token total supplies.
     * @param tokenAddresses Addresses of tokens where the balances need to be fetched.
     * @return Balances array.
     */
    function totalSupplies(address[] calldata tokenAddresses)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory supplies = new uint256[](tokenAddresses.length);
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            supplies[i] = IERC20(tokenAddresses[i]).totalSupply();
        }
        return supplies;
    }
}