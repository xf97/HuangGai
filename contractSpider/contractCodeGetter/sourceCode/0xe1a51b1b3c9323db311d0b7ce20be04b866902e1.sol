
pragma solidity ^0.5.0;

import "./OrganizationFactoryInterface.sol";
import "./Organization.sol";

contract OrganizationFactory is OrganizationFactoryInterface {

    function createOrganization(address _lotFactory, address _organizationOwner, bool _isActive) public returns (address) {
        Organization organization = new Organization( _lotFactory, _organizationOwner, _isActive);
        return address(organization);
    }
} 
