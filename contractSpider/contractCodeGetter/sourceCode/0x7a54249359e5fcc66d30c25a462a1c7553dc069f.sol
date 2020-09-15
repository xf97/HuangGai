/**
 * SPDX-License-Identifier: MIT
 */

pragma solidity >=0.6;

import "./Ownable.sol";
import "./Address.sol";
import "./RLPEncode.sol";

contract MultiSig {

  mapping (address => uint8) public signers; // The addresses that can co-sign transactions and the number of signatures needed
  uint256 public sequenceNumber; // A sequence number that contains the address of this contract to make it globally unique
  uint16 signerCount;

  event SignerChange(
    address indexed signer,
    uint8 cosignaturesNeeded
  );

  event Transacted(
    address indexed toAddress,  // The address the transaction was sent to
    bytes4 selector, // selected operation
    address[] signers // Addresses of the signers used to initiate the transaction
  );

  constructor () public {
    // ensure that the sequence number is unique by starting at the unique address of this contract
    sequenceNumber = uint256(address(this)) << 64; // 64 bits should be more than enough sequence numbers
    _setSigner(msg.sender, 1); // start with the contract creator as owner
  }

  function check(address to, uint value, bytes calldata data,
    uint8[] calldata v, bytes32[] calldata r, bytes32[] calldata s) public view returns (address[] memory) {
    bytes32 transactionHash = calculateTransactionHash(nextSequenceNumber(), to, value, data);
    return verifySignatures(transactionHash, v, r, s);
  }

  function execute(address to, uint value, bytes calldata data, uint8[] calldata v, bytes32[] calldata r, bytes32[] calldata s) public returns (bytes memory) {
    sequenceNumber = nextSequenceNumber(); // ok to increment here already, will be rolled back in case of failure and saves us one local variable
    bytes32 transactionHash = calculateTransactionHash(sequenceNumber, to, value, data);
    address[] memory found = verifySignatures(transactionHash, v, r, s);
    bytes memory returndata = Address.functionCallWithValue(to, data, value);
    emit Transacted(to, extractSelector(data), found);
    return returndata;
  }

  function extractSelector(bytes calldata data) public pure returns (bytes4){
    if (data.length < 4){
      return bytes4(0);
    } else {
      return bytes4(data[0]) | (bytes4(data[1]) >> 8) | (bytes4(data[2]) >> 16) | (bytes4(data[3]) >> 24);
    }
  }

  function nextSequenceNumber() public view returns (uint256){
    return sequenceNumber + 1;
  }

  function toBytes(uint number) internal pure returns (bytes memory){
    uint len = 0;
    uint temp = 1;
    while (number >= temp){
      temp = temp << 8;
      len++;
    }
    temp = number;
    bytes memory data = new bytes(len);
    for (uint i = len; i>0; i--) {
      data[i-1] = bytes1(uint8(temp));
      temp = temp >> 8;
    }
    return data;
  }

  // Note: does not work with contract creation
  function calculateTransactionHash(uint sequence, address to, uint value, bytes calldata data) public pure returns (bytes32){
    bytes[] memory all = new bytes[](6);
    all[0] = toBytes(sequence); // sequence number instead of nonce
    all[1] = new bytes(0); // gas price
    all[2] = all[1]; // gas limit
    all[3] = abi.encodePacked(to);
    all[4] = toBytes(value);
    all[5] = data;
    for (uint i = 0; i<6; i++){
      all[i] = RLPEncode.encodeBytes(all[i]);
    }
    return keccak256(RLPEncode.encodeList(all));
  }

  function verifySignatures(bytes32 transactionHash, uint8[] calldata v, bytes32[] calldata r, bytes32[] calldata s) public view returns (address[] memory) {
    address[] memory found = new address[](r.length);
    for (uint i = 0; i < r.length; i++) {
      address signer = ecrecover(transactionHash, v[i], r[i], s[i]);
      require(isSigner(signer), "not authorized, wrong sequence number, or other");
      uint8 cosignaturesNeeded = signers[signer];
      require(cosignaturesNeeded <= r.length, "wrong number of cosigners");
      found[i] = signer;
    }
    requireNoDuplicates(found);
    return found;
  }

  function requireNoDuplicates(address[] memory found) private pure {
    for (uint i = 0; i < found.length; i++) {
      for (uint j = i+1; j < found.length; j++) {
        require(found[i] != found[j], "duplicate signature");
      }
    }
  }

  /**
   * Call this method through execute
   */
  function setSigner(address signer, uint8 cosignaturesNeeded) public {
    require(address(this) == msg.sender || signers[msg.sender] == 1, "not self");
    _setSigner(signer, cosignaturesNeeded);
  }

  function countSigners() public view returns (uint16) {
    return signerCount;
  }

  function _setSigner(address signer, uint8 cosignaturesNeeded) internal {
    require(!Address.isContract(signer));
    uint8 prevValue = signers[signer];
    signers[signer] = cosignaturesNeeded;
    if (prevValue > 0 && cosignaturesNeeded == 0){
      signerCount--;
    } else if (prevValue == 0 && cosignaturesNeeded > 0){
      signerCount++;
    }
    emit SignerChange(signer, cosignaturesNeeded);
  }

  function isSigner(address signer) public view returns (bool) {
    return signers[signer] > 0;
  }

}