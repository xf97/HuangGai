/**
 *Submitted for verification at Etherscan.io on 2020-06-03
*/

pragma solidity ^0.4.26;

pragma experimental ABIEncoderV2;
contract Witness {
    
    struct UploadEvent {
        string prefHash;
        string[] refHash;
        string id;
        string desc;
        string data;
    }
    
    UploadEvent[] public uploads;
    
    struct WitnessEvent {
        string hash;
        string pkHash;
        string sig;
    }
    
    WitnessEvent[] public witnesses;
    
    event onUpload(string prefHash, string[] refHash, string id, string desc, string data);
    event onWitness(string hash, string pkHash, string sig);
   
    function upload(string memory prefHash, string[] memory refHash, string memory id, string memory desc, string memory data) public {
        require(bytes(prefHash).length > 0);
        require(bytes(id).length > 0);
        require(bytes(desc).length > 0);
        require(bytes(data).length > 0);
        
        uploads.push(UploadEvent(prefHash, refHash, id, desc, data));
        
        emit onUpload(prefHash, refHash, id, desc, data);
    }
    
    function witness(string memory hash, string memory pkHash, string memory sig) public {
        require(bytes(hash).length > 0);
        require(bytes(pkHash).length > 0);
        require(bytes(sig).length > 0);
        
        witnesses.push(WitnessEvent(hash, pkHash, sig));
        
        emit onWitness(hash, pkHash, sig);
    }
}