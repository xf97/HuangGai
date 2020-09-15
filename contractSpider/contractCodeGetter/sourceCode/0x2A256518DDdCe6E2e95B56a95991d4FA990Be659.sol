pragma solidity 0.5.15;

contract IOwnable {
    function getOwner() public view returns (address);
    function transferOwnership(address _newOwner) public returns (bool);
}

contract Ownable is IOwnable {
    address internal owner;

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param _newOwner The address to transfer ownership to.
     */
    function transferOwnership(address _newOwner) public onlyOwner returns (bool) {
        require(_newOwner != address(0));
        onTransferOwnership(owner, _newOwner);
        owner = _newOwner;
        return true;
    }

    // Subclasses of this token may want to send additional logs through the centralized Augur log emitter contract
    function onTransferOwnership(address, address) internal;
}

contract IAffiliateValidator {
    function validateReference(address _account, address _referrer) external view returns (bool);
}

contract AffiliateValidator is Ownable, IAffiliateValidator {
    // Mapping of affiliate address to their key
    mapping (address => bytes32) public keys;

    mapping (address => bool) public operators;

    mapping (uint256 => bool) public usedSalts;

    /**
     * @notice Add an operator who can sign keys to admit accounts into this affiliate validator
     * @param _operator The address of the new operator
     */
    function addOperator(address _operator) external onlyOwner {
        operators[_operator] = true;
    }

    /**
     * @notice Remove an existing operator
     * @param _operator The operator to remove from the authorized operators
     */
    function removeOperator(address _operator) external onlyOwner {
        operators[_operator] = false;
    }

    /**
     * @notice Apply a key provided by an operator in order to be added to this validator
     * @param _key The key to store. This is used to check if an account is attempting to self trade
     * @param _salt A salt to secure the key hash
     * @param _r r portion of the signature
     * @param _s s portion of the signature
     * @param _v v portion of the signature
     * @return bytes32
     */
    function addKey(bytes32 _key, uint256 _salt, bytes32 _r, bytes32 _s, uint8 _v) external {
        require(!usedSalts[_salt], "Salt already used");
        bytes32 _hash = getKeyHash(_key, msg.sender, _salt);
        require(isValidSignature(_hash, _r, _s, _v), "Signature invalid");
        usedSalts[_salt] = true;
        keys[msg.sender] = _key;
    }

    /**
     * @notice Get the key hash for a given key
     * @param _key The key to get a hash for
     * @param _account The account to get a hash for
     * @param _salt A salt to secure the key hash
     * @return bytes32
     */
    function getKeyHash(bytes32 _key, address _account, uint256 _salt) public view returns (bytes32) {
        return keccak256(abi.encodePacked(_key, _account, address(this), _salt));
    }

    function isValidSignature(bytes32 _hash, bytes32 _r, bytes32 _s, uint8 _v) public view returns (bool) {
        address recovered = ecrecover(
            keccak256(abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                _hash
            )),
            _v,
            _r,
            _s
        );
        return operators[recovered];
    }

    function validateReference(address _account, address _referrer) external view returns (bool) {
        bytes32 _accountKey = keys[_account];
        bytes32 _referralKey = keys[_referrer];
        if (_accountKey == bytes32(0) || _referralKey == bytes32(0)) {
            return false;
        }
        return _accountKey != _referralKey;
    }

    function onTransferOwnership(address, address) internal {}
}