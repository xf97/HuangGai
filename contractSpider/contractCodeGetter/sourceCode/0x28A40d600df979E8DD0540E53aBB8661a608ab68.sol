/**
 *Submitted for verification at Etherscan.io on 2020-08-06
*/

pragma solidity ^0.5.0;

contract SRDPoet {
    event HashNotarized(address indexed sender, string hash);

	struct Proof {
		bool valid;
		address sender;
		uint256 timestamp;
	}

  	mapping(string => Proof) private hashesToProofs;

	function notarize(string memory _hash) public {
		require(!hashesToProofs[_hash].valid, "The document already exists");

		hashesToProofs[_hash].valid = true;
		hashesToProofs[_hash].sender = msg.sender;
		hashesToProofs[_hash].timestamp = block.timestamp;

		emit HashNotarized(msg.sender, _hash);
	}
	
	function verify(string memory _hash) public view returns (bool valid, address sender, uint256 timestamp) {
        Proof memory p = hashesToProofs[_hash];
        return (p.valid, p.sender, p.timestamp);
    }
}