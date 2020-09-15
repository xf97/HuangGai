pragma solidity ^0.5.8;

import "./IERC20.sol";

contract SimpleMultiSig {
    // EIP712 Precomputed hashes:
    // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)")
    bytes32 constant EIP712DOMAINTYPE_HASH = 0xd87cd6ef79d4e2b95e15ce8abf732db51ec771f1ca2edccf22a46c729ac56472;

    // keccak256("Simple MultiSig")
    bytes32 constant NAME_HASH = 0xb7a0bfa1b79f2443f4d73ebb9259cddbcd510b18be6fc4da7d1aa7b1786e73e6;

    // keccak256("1")
    bytes32 constant VERSION_HASH = 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6;

    // keccak256("MultiSigTransaction(address destination,uint256 value,bytes data,uint256 nonce,address executor,uint256 gasLimit)")
    bytes32 constant TXTYPE_HASH = 0x3ee892349ae4bbe61dce18f95115b5dc02daf49204cc602458cd4c1f540d56d7;

    bytes32 constant SALT = 0x251543af6a222378665a76fe38dbceae4871a070b7fdaf5c6c30cf758dc33cc0;

    uint256 constant THRESHOLD = 2;

    uint256 public chainId;
    address public master;

    struct Wallet {
        uint256 nonce; // mutable state
        address owner;
        uint256 value; // mutable state
        bytes32 DOMAIN_SEPARATOR;
        address erc20Addr;
    }

    mapping(bytes32 => Wallet) public wallets;

    constructor(uint256 chainId_) public {
        chainId = chainId_;
        master = msg.sender;
    }

    function setMaster(address master_) external {
        require(msg.sender == master, "Only master can set master address");
        master = master_;
    }

    // Note that owners_ must be strictly increasing, in order to prevent duplicates
    function createWallet(bytes32 id, address owner) internal {
        Wallet storage wallet = wallets[id];
        require(wallet.owner == address(0), "Wallet already exists");
        wallet.owner = owner;

        wallet.DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                EIP712DOMAINTYPE_HASH,
                NAME_HASH,
                VERSION_HASH,
                chainId,
                this,
                id
            )
        );
    }

    function getWallet(bytes32 id)
        external
        view
        returns (uint256, address, uint256, bytes32, address)
    {
        Wallet storage wallet = wallets[id];
        return (
            wallet.nonce,
            wallet.owner,
            wallet.value,
            wallet.DOMAIN_SEPARATOR,
            wallet.erc20Addr
        );
    }

    function createEthWallet(bytes32 id, address owner) external payable {
        createWallet(id, owner);
        wallets[id].value += msg.value;
    }

    function createErc20Wallet(
        bytes32 id,
        address owner,
        address erc20Addr,
        uint256 value
    ) external {
        createWallet(id, owner);
        require(
            IERC20(erc20Addr).transferFrom(msg.sender, address(this), value),
            "Transfer ERC20 token failed"
        );
        wallets[id].value += value;
        wallets[id].erc20Addr = erc20Addr;
    }

    function getTotalInputHash(
        address recipient,
        uint256 value,
        uint256 nonce,
        bytes32 DOMAIN_SEPARATOR,
        bool isErc20
    ) internal view returns (bytes32) {

        bytes memory data;

        if (isErc20) {
            // get calldata
            data = abi.encodeWithSignature(
                "transfer(address,uint256)",
                recipient,
                value
            );
        }

        // EIP712 scheme: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md
        bytes32 txInputHash = keccak256(
            abi.encode(
                TXTYPE_HASH,
                recipient,
                value,
                keccak256(data),
                nonce,
                master
            )
        );

        bytes32 totalHash = keccak256(
            abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, txInputHash)
        );

        return totalHash;
    }

    // return signature to be signed
    function getSig(bytes32 id, address recipient)
        public
        view
        returns (bytes32)
    {
        Wallet storage wallet = wallets[id];

        return
            getTotalInputHash(
                recipient,
                wallet.value,
                wallet.nonce,
                wallet.DOMAIN_SEPARATOR,
                wallet.erc20Addr != address(0x0)
            );
    }

    function verifySigs(
        bytes32 id,
        uint8[] memory sigV,
        bytes32[] memory sigR,
        bytes32[] memory sigS,
        address recipient
    ) internal view {
        require(sigR.length == THRESHOLD, "Incorrect sig length");
        require(
            sigR.length == sigS.length && sigR.length == sigV.length,
            "Sig length does not match"
        );

        Wallet storage wallet = wallets[id];

        // compute total input hash
        bytes32 totalHash = getTotalInputHash(
            recipient,
            wallet.value,
            wallet.nonce,
            wallet.DOMAIN_SEPARATOR,
            wallet.erc20Addr != address(0x0)
        );

        // master signed
        require(
            ecrecover(totalHash, sigV[0], sigR[0], sigS[0]) == master,
            "Invalid master sig"
        );

        // owner signed
        require(
            ecrecover(totalHash, sigV[1], sigR[1], sigS[1]) == wallet.owner,
            "Invalid owner sig"
        );
    }

    function transfer(
        bytes32 id,
        uint8[] memory sigV,
        bytes32[] memory sigR,
        bytes32[] memory sigS,
        address payable recipient
    ) public {
        // only master can execute
        require(master == msg.sender, "Incorrect executor");

        // verify signatures
        verifySigs(id, sigV, sigR, sigS, recipient);

        Wallet storage wallet = wallets[id];

        wallet.nonce += 1;

        if (wallet.erc20Addr != address(0x0)) {
            // send erc20 tokens
            require(
                IERC20(wallet.erc20Addr).transfer(recipient, wallet.value),
                "Transfer ERC20 token failed"
            );
        } else {
            // send eth
            recipient.transfer(wallet.value);
        }

        // safe to set wallet.value after transfer
        // re-entry attack prevented by nonce
        wallet.value = 0;
    }

    // disable payment
    function() external {}
}
