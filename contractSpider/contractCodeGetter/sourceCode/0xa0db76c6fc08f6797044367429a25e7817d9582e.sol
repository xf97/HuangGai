pragma solidity ^0.5.0;

import "./LotFactoryInterface.sol";
import "./LotInterface.sol";
import "./OrganizationInterface.sol";
import "./PermissionsEnum.sol";

import "./Lot.sol";

contract LotFactory is PermissionsEnum, LotFactoryInterface {
    event LotCreated (
        address organization,
        address lot,
        string name
    );

    event SubLotCreated (
        address organization,
        address lot,
        address parentLot,
        string name,
        uint32 totalSupply
    );

    function createLot(
        address _organization,
        string memory _name)
    public 
    returns (address) 
    {
        require(OrganizationInterface(_organization).hasPermissions(msg.sender, uint256(Permissions.CREATE_LOT)), "Not Allowed");

        address lot = _createLot(_organization, _name, 0, address(0), address(0));

        emit LotCreated(_organization, lot, _name);
        return lot;
    }

    function createSubLot(
        address _organization,
        address _parentLot,
        string memory _name,
        uint32 _totalSupply,
        address _nextPermitted)
    public
    returns (address)
    {
        require(OrganizationInterface(_organization).hasPermissions(msg.sender, uint256(Permissions.CREATE_SUB_LOT)), "Not Allowed");
        require(LotInterface(_parentLot).getOrganization() == _organization, "Lot does not belong to the organization");
        require(_totalSupply > 0, "Total supply must be greater than 0");

        address lot = _createLot(_organization, _name, _totalSupply, _parentLot, _nextPermitted);
        LotInterface(_parentLot).allocateSupply(lot, _totalSupply);

        emit SubLotCreated(_organization, lot, _parentLot, _name, _totalSupply);
        return lot;
    }

    function _createLot(
        address _organization,
        string memory _name,
        uint32 _totalSupply,
        address _parentLot,
        address _nextPermitted
    ) internal returns (address) {
        return address (new Lot(_organization, address(this), _name, _totalSupply, _parentLot, _nextPermitted));
    }
}
