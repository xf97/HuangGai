contract Hashlock {
    bytes32 internal hash;	//miners can get this var's value
    constructor(bytes32 h) public payable {
        hash = h;
    }
    //so miners can destruct this contract
    function reveal(bytes32 p) external {
        require(keccak256(abi.encode(p)) == hash);
        selfdestruct(msg.sender);	//injected SUICIDE CONTRACT
    }
}