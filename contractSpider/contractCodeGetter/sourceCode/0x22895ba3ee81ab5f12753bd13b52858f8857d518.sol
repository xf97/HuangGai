pragma solidity ^0.5.0;

import "./OrganizationFactoryInterface.sol";

/**
 * @title Application
 * @dev Application contract for the backend
 */
contract Application {

    struct OrganizationOwner {
        address organizationAddress;
        address organizationOwner;
        bool isActive;
    }

    address public lotFactory;
    address public applicationOwner;
    address[] public organizations;
    address[] public organizationOwners;
    OrganizationFactoryInterface public organizationFactory;

    mapping(address => OrganizationOwner) public organizationOwnersMap;

    event OrganizationCreated (
        address organization,
        address owner,
        address lotFactory
    );

    event OrganizationRemoved (
        address organization,
        address owner
    );

    event DefaultLotFactoryChanged (
        address oldLotFactory,
        address newLotFactory
    );
    
    event OrganizationFactoryChanged (
        address oldOrganizationFactory,
        address newOrganizationFactory
    );
    
    modifier onlyOwnerAccess() {
        require(msg.sender == applicationOwner,  "Only Owner accessible");
        _;
    }

    constructor(address _organizationFactory, address _lotFactory) public {
        applicationOwner = msg.sender;
        organizationFactory = OrganizationFactoryInterface(_organizationFactory);
        lotFactory = _lotFactory;
    }

    /**
     * @dev Updates the default lotFactory contract used when creating new orgs
     */
    function setLotFactory(address _newLotFactory)
    public
    onlyOwnerAccess
    returns (address) {
        address _oldLotFactory = lotFactory;
        lotFactory = _newLotFactory;
        emit DefaultLotFactoryChanged(_oldLotFactory, lotFactory);
    }

    /**
     * @dev Updates the organizationFactory contract
     */
    function setOrganizationFactory(address _newOrgFactory)
    public
    onlyOwnerAccess
    returns (address) {
        address _oldOrgFactory = address(organizationFactory);
        organizationFactory = OrganizationFactoryInterface(_newOrgFactory);
        emit OrganizationFactoryChanged(_oldOrgFactory, address(organizationFactory));
    }

    /**
     * @dev Creates new organization smart contract for given organization owner
     */
    function createOrganization(
        address _organizationOwner
    )
    public
    onlyOwnerAccess
    returns (address)
    {
        return createOrganization(_organizationOwner,lotFactory);
    }

     /**
     * @dev Creates new organization smart contract for given organization owner
     */
    function createOrganization(
        address _organizationOwner,
        address _lotFactory
    )
    public
    onlyOwnerAccess
    returns (address)
    {
        address newOrgAddress = organizationFactory.createOrganization( _lotFactory,_organizationOwner, true);
        organizationOwners.push(_organizationOwner);
        organizations.push(newOrgAddress);
        organizationOwnersMap[_organizationOwner] = OrganizationOwner(
            newOrgAddress,
            _organizationOwner,
            true
        );

        emit OrganizationCreated(newOrgAddress, _organizationOwner, _lotFactory);

        return newOrgAddress;
    }

    /**
     * @dev Get all the Organizations list of addresses.
     */
    function getOrganizations()
    public
    view
    returns (address[] memory) {
        return organizations;
    }

    /**
     * @dev Remove organization so that they shouldn't create any more lots.
     * @param _organization The address of organization which needs to be removed.
     */
    function removeOrganization(address _organization)
    public
    onlyOwnerAccess
    {
        organizationOwnersMap[_organization].isActive = false;

        emit OrganizationRemoved(_organization, msg.sender);
    }

    /**
     * @dev Remove organization so that they shouldn't create any more lots.
     * @param _organization The address of organization which needs to be removed.
     */
    function getOrganization(address _organization)
    public view
    returns (address, bool)
    {
        return (organizationOwnersMap[_organization].organizationOwner, organizationOwnersMap[_organization].isActive);
    }
}
