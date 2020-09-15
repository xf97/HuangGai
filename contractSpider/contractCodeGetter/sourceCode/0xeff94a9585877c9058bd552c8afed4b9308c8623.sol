/**
 *Submitted for verification at Etherscan.io on 2020-08-19
*/

// Built by @ragonzal - 2020
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface Poap {
    function mintToken(uint256 eventId, address to) external returns (bool);
}

contract PoapAirdrop {

    string public name;

    // POAP Contract - Only Mint Token function
    Poap POAPToken;

    // Processed claims
    mapping(address => bool) public claimed;

    // Merkle tree root hash
    bytes32 public rootHash;

    /**
     * @dev Contract constructor
     * @param contractName Contract name
     * @param contractAddress Address of the POAP contract
     * @param merkleTreeRootHash Processed merkle tree root hash
     */
    constructor (string memory contractName, address contractAddress, bytes32 merkleTreeRootHash) public {
        name = contractName;
        POAPToken = Poap(contractAddress);
        rootHash = merkleTreeRootHash;
    }

    /**
     * @dev Function to verify merkle tree proofs and mint POAPs to the recipient
     * @param index Leaf position in the merkle tree
     * @param recipient Recipient address of the POAPs to be minted
     * @param events Array of event ids to be minted
     * @param proofs Array of proofs to verify the claim
     */
    function claim(uint256 index, address recipient, uint256[] calldata events, bytes32[] calldata proofs) external {
        require(claimed[recipient] == false, "Recipient already processed!");
        require(verify(index, recipient, events, proofs), "Recipient not in merkle tree!");

        claimed[recipient] = true;

        require(mintTokens(recipient, events), "Could not mint POAPs");
    }

    /**
     * @dev Function to verify merkle tree proofs
     * @param index Leaf position in the merkle tree
     * @param recipient Recipient address of the POAPs to be minted
     * @param events Array of event ids to be minted
     * @param proofs Array of proofs to verify the claim
     */
    function verify(uint256 index, address recipient, uint256[] memory events, bytes32[] memory proofs) public view returns (bool) {

        // Compute the merkle root
        bytes32 node = keccak256(abi.encodePacked(index, recipient, events));
        for (uint16 i = 0; i < proofs.length; i++) {
            bytes32 proofElement = proofs[i];
            if (proofElement < node) {
                node = keccak256(abi.encodePacked(proofElement, node));
            } else {
                node = keccak256(abi.encodePacked(node, proofElement));
            }
        }

        // Check the merkle proof
        return node == rootHash;
    }

    /**
     * @dev Function to mint POAPs
     * @param recipient Recipient address of the POAPs to be minted
     * @param events Array of event ids to be minted
     */
    function mintTokens(address recipient, uint256[] memory events) internal returns (bool) {
        for (uint256 i = 0; i < events.length; i++) {
            POAPToken.mintToken(events[i], recipient);
        }
        return true;
    }

}