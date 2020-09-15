/**
 *Submitted for verification at Etherscan.io on 2020-06-24
*/

pragma solidity ^0.5.0;

interface ENS {

    // Logged when the owner of a node assigns a new owner to a subnode.
    event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);

    // Logged when the owner of a node transfers ownership to a new account.
    event Transfer(bytes32 indexed node, address owner);

    // Logged when the resolver for a node changes.
    event NewResolver(bytes32 indexed node, address resolver);

    // Logged when the TTL of a node changes
    event NewTTL(bytes32 indexed node, uint64 ttl);

    // Logged when an operator is added or removed.
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function setRecord(bytes32 node, address owner, address resolver, uint64 ttl) external;
    function setSubnodeRecord(bytes32 node, bytes32 label, address owner, address resolver, uint64 ttl) external;
    function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns(bytes32);
    function setResolver(bytes32 node, address resolver) external;
    function setOwner(bytes32 node, address owner) external;
    function setTTL(bytes32 node, uint64 ttl) external;
    function setApprovalForAll(address operator, bool approved) external;
    function owner(bytes32 node) external view returns (address);
    function resolver(bytes32 node) external view returns (address);
    function ttl(bytes32 node) external view returns (uint64);
    function recordExists(bytes32 node) external view returns (bool);
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

contract Registrar {
  function approve(address to, uint256 tokenId) public;
  function transferFrom(address from, address to, uint256 tokenId) public;
  function ownerOf(uint256 tokenId) public view returns (address owner);
  function reclaim(uint256 id, address owner) external;
}

contract Resolver {
   function supportsInterface(bytes4 interfaceID) public pure returns (bool);
   function addr(bytes32 node) public view returns (address);
   function setAddr(bytes32 node, address addr) public;
}

contract IMinion {
  function moloch() public view returns (address);
}

contract IMoloch {
  function members(address) public view returns (address, uint256, uint256, bool, uint256, uint256);
}

/**
 * @dev Implements a ENS registrar that gives subdomains to Moloch members or requires a Minion to execute transactions for non-members
 * @author Peter Phillips, based off SubdomainRegistrar.sol by ENS https://github.com/ensdomains/subdomain-registrar/blob/master/contracts/SubdomainRegistrar.sol
 */

contract MinionSubdomainRegistrar {
    // namehash('eth')
    bytes32 constant public TLD_NODE = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;

    ENS public ens;

    address public registrar;
    address public registrarOwner;
    address public migration;
    bool public stopped = false;

    struct Domain {
        string name;
        address owner;
        address minion;
        address moloch;
    }

    mapping (bytes32 => Domain) domains;

    modifier owner_only(bytes32 label) {
        require(owner(label) == msg.sender);
        _;
    }

    modifier not_stopped() {
        require(!stopped);
        _;
    }

    modifier registrar_owner_only() {
        require(msg.sender == registrarOwner);
        _;
    }

    event TransferAddressSet(bytes32 indexed label, address addr);
    event DomainTransferred(bytes32 indexed label, string name);
    event OwnerChanged(bytes32 indexed label, address indexed oldOwner, address indexed newOwner);
    event DomainConfigured(bytes32 indexed label, string domain, address indexed minion);
    event DomainUnlisted(bytes32 indexed label);
    event NewRegistration(bytes32 indexed label, string subdomain, address indexed owner);

    constructor(ENS _ens) public {
        ens = _ens;
        registrar = ens.owner(TLD_NODE);
        registrarOwner = msg.sender;
    }

    /** Registar owner functions **/

    function transferOwnership(address newOwner) public registrar_owner_only {
        registrarOwner = newOwner;
    }

    /**
     * @dev Sets the address where domains are migrated to.
     * @param _migration Address of the new registrar.
     */
    function setMigrationAddress(address _migration) public registrar_owner_only {
        require(stopped);
        migration = _migration;
    }

    /**
     * @dev Stops the registrar, disabling configuring of new domains.
     */
    function stop() public not_stopped registrar_owner_only {
        stopped = true;
    }

    /** Domain owner functions **/

    /**
     * @dev Sets the resolver record for a name in ENS.
     * @param name The name to set the resolver for.
     * @param resolver The address of the resolver
     */
    function setResolver(string memory name, address resolver) public owner_only(keccak256(bytes(name))) {
        bytes32 label = keccak256(bytes(name));
        bytes32 node = keccak256(abi.encodePacked(TLD_NODE, label));
        ens.setResolver(node, resolver);
    }

    /**
     * @dev Transfers internal control of a name to a new account. Does not update
     *      ENS.
     * @param name The name to transfer.
     * @param newOwner The address of the new owner.
     */
    function transfer(string memory name, address newOwner) public owner_only(keccak256(bytes(name))) {
        bytes32 label = keccak256(bytes(name));
        emit OwnerChanged(label, domains[label].owner, newOwner);
        domains[label].owner = newOwner;
    }

    /**
     * @dev Unlists a domain
     * May only be called by the owner.
     * @param name The name of the domain to unlist.
     */
    function unlistDomain(string memory name) public owner_only(keccak256(bytes(name))) {
        bytes32 label = keccak256(bytes(name));
        Registrar(registrar).reclaim(uint256(label), domains[label].owner);
        Registrar(registrar).transferFrom(address(this), domains[label].owner, uint256(label));
        delete domains[label];
        emit DomainUnlisted(label);
    }

    /** Add domain to registrar **/

    /**
     * @dev Configures a domain for sale.
     * @param name The name to configure.
     * @param minion The address of the Minion that will control subdomain permissions
     */
    function configureDomain(string memory name, address minion) public {
        configureDomainFor(name, minion, msg.sender);
    }

    /**
     * @dev Configures a domain.
     * @param name The name to configure.
     * @param minion The address of the Minion who can assign subdomains
     * @param _owner The address to assign ownership of this domain to.
     */
    function configureDomainFor(string memory name, address minion, address _owner) public not_stopped owner_only(keccak256(bytes(name))) {
        bytes32 label = keccak256(bytes(name));
        Domain storage domain = domains[label];

        if (Registrar(registrar).ownerOf(uint256(label)) != address(this)) {
            Registrar(registrar).transferFrom(msg.sender, address(this), uint256(label));
            Registrar(registrar).reclaim(uint256(label), address(this));
        }

        if (domain.owner != _owner) {
            domain.owner = _owner;
        }

        if (keccak256(abi.encodePacked(domain.name)) != label) {
            // New listing
            domain.name = name;
        }

        domain.minion = minion;
        domain.moloch = IMinion(minion).moloch();

        emit DomainConfigured(label, name, minion);
    }

    /** Move domain to a new registrar **/

    /**
     * @dev Migrates the domain to a new registrar.
     * @param name The name of the domain to migrate.
     */
    function migrate(string memory name) public owner_only(keccak256(bytes(name))) {
        require(stopped);
        require(migration != address(0x0));

        bytes32 label = keccak256(bytes(name));
        Domain storage domain = domains[label];

        Registrar(registrar).approve(migration, uint256(label));

        MinionSubdomainRegistrar(migration).configureDomainFor(
            domain.name,
            domain.minion,
            domain.owner
        );

        delete domains[label];

        emit DomainTransferred(label, name);
    }

    /** Register a subdomain **/

    /**
     * @dev Registers a subdomain.
     * @param label The label hash of the domain to register a subdomain of.
     * @param subdomain The desired subdomain label.
     * @param _subdomainOwner The account that should own the newly configured subdomain.
     */
    function register(bytes32 label, string calldata subdomain, address _subdomainOwner, address resolver) external not_stopped {
        address subdomainOwner = _subdomainOwner;
        bytes32 domainNode = keccak256(abi.encodePacked(TLD_NODE, label));
        bytes32 subdomainLabel = keccak256(bytes(subdomain));

        // Subdomain must not be registered already.
        require(ens.owner(keccak256(abi.encodePacked(domainNode, subdomainLabel))) == address(0));

        Domain storage domain = domains[label];

        // Domain must be available for registration
        require(keccak256(abi.encodePacked(domain.name)) == label);

        // Use msg.sender if _subdomainOwner is not set
        if (subdomainOwner == address(0x0)) {
            subdomainOwner = msg.sender;
        }

        // Domain can only be registered by Minion or by members (and only for members)
        if (msg.sender != domain.minion) {
          // If msg.sender is not minion check that the msg.sender and new owner are members
          ( , uint256 ownerStakes, , , , ) = IMoloch(domain.moloch).members(subdomainOwner);
          ( , uint256 senderStakes, , , , ) = IMoloch(domain.moloch).members(msg.sender);
          require(senderStakes > 0 && ownerStakes > 0);
        }

        doRegistration(domainNode, subdomainLabel, subdomainOwner, Resolver(resolver));

        emit NewRegistration(label, subdomain, subdomainOwner);
    }

    function deregister(bytes32 label, string calldata subdomain, address resolver) external {
        bytes32 domainNode = keccak256(abi.encodePacked(TLD_NODE, label));
        bytes32 subdomainLabel = keccak256(bytes(subdomain));
        address subdomainOwner = ens.owner(keccak256(abi.encodePacked(domainNode, subdomainLabel)));

        // Subdomain must be registered already.
        require(subdomainOwner != address(0));

        Domain storage domain = domains[label];

        // Domain must be available for registration
        require(keccak256(abi.encodePacked(domain.name)) == label);
        // Domain can only be deregistered by domain's Minion or subdomain owner
        require(msg.sender == domain.minion || msg.sender == subdomainOwner);

        doRegistration(domainNode, subdomainLabel, address(0), Resolver(resolver));

        emit NewRegistration(label, subdomain, address(0));
    }

    function doRegistration(bytes32 node, bytes32 label, address subdomainOwner, Resolver resolver) internal {
        // Get the subdomain so we can configure it
        ens.setSubnodeOwner(node, label, address(this));

        bytes32 subnode = keccak256(abi.encodePacked(node, label));
        // Set the subdomain's resolver
        ens.setResolver(subnode, address(resolver));

        // Set the address record on the resolver
        resolver.setAddr(subnode, subdomainOwner);

        // Pass ownership of the new subdomain to the registrant
        ens.setOwner(subnode, subdomainOwner);
    }

    /** View **/

    /**
     * @dev owner returns the address of the account that controls a domain.
     *      Initially this is a null address. If the name has been
     *      transferred to this contract, then the internal mapping is consulted
     *      to determine who controls it. If the owner is not set,
     *      the owner of the domain in the Registrar is returned.
     * @param label The label hash of the deed to check.
     * @return The address owning the deed.
     */
    function owner(bytes32 label) public view returns (address) {
        if (domains[label].owner != address(0x0)) {
            return domains[label].owner;
        }

        return Registrar(registrar).ownerOf(uint256(label));
    }
}