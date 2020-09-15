pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

import "../../interfaces/permissions/ISuperAdminRole.sol";
import "openzeppelin-solidity/contracts/access/Roles.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";


/// @title SuperAdminRole
/// @author Julian Wilson <julian@nextgenbt.com>
/// @notice This is copied from the openzeppelin-solidity@2.0.0 library CapperRole and just
///         renamed to SuperAdminRole. Super admins are parents to all other admins in the system.
///         Super admins can also promote others to super admins but not remove them.
contract SuperAdminRole is ISuperAdminRole {
    using Roles for Roles.Role;
    using SafeMath for uint256;

    event SuperAdminAdded(address indexed account);
    event SuperAdminRemoved(address indexed account);

    Roles.Role private superAdmins;

    uint256 private superAdminCount;

    constructor() public {
        _addSuperAdmin(msg.sender);
    }

    /// @notice Throws if the caller is not a super admin./
    modifier onlySuperAdmin() {
        require(isSuperAdmin(msg.sender), "NOT_SUPER_ADMIN");
        _;
    }

    /// @notice Adds a super admin to the list.
    /// @param account The account to add.
    function addSuperAdmin(address account) public onlySuperAdmin {
        _addSuperAdmin(account);
    }

    /// @notice Throws if the caller is last super admin left
    modifier atLeastOneSuperAdmin() {
        require(
            superAdminCount > 1,
            "LAST_SUPER_ADMIN"
        );
        _;
    }

    /// @notice Removes a super admin from the list.
    /// @param account The account to add.
    function removeSuperAdmin(address account)
        public
        onlySuperAdmin
        atLeastOneSuperAdmin
    {
        _removeSuperAdmin(account);
    }

    /// @notice Internal function to add an account to the super admin list.
    /// @param account The account to add.
    function _addSuperAdmin(address account) internal {
        superAdmins.add(account);
        superAdminCount = superAdminCount.add(1);
        emit SuperAdminAdded(account);
    }

    /// @notice Internal function to remove an account from the super admin list.
    /// @param account The account to remove.
    function _removeSuperAdmin(address account) internal {
        superAdmins.remove(account);
        superAdminCount = superAdminCount.sub(1);
        emit SuperAdminRemoved(account);
    }

        /// @notice Gets the total number of super admins.
    /// @return The total number of super admins.
    function getSuperAdminCount() public view returns (uint256) {
        return superAdminCount;
    }

    /// @notice Checks if an account is a super admin.
    /// @param account The account to add.
    /// @return true if the account is a super admin, false otherwise.
    function isSuperAdmin(address account) public view returns (bool) {
        return superAdmins.has(account);
    }
}