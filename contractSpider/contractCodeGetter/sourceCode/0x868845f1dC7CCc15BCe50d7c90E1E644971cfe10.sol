pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

import "../interfaces/IAffiliateRegistry.sol";
import "../interfaces/permissions/IWhitelist.sol";


contract AffiliateRegistry is IAffiliateRegistry {
    uint256 public constant MAX_AFFILIATE_FEE = 3*(10**19);

    IWhitelist private systemParamsWhitelist;

    address private defaultAffiliate;
    mapping (address => address) private addressToAffiliate;
    mapping (address => uint256) private affiliateFeeFrac;

    event AffiliateSet(
        address member,
        address affiliate
    );

    event AffiliateFeeFracSet(
        address affiliate,
        uint256 feeFrac
    );

    constructor(IWhitelist _systemParamsWhitelist) public {
        systemParamsWhitelist = _systemParamsWhitelist;
    }

    /// @notice Throws if the caller is not a system params admin.
    modifier onlySystemParamsAdmin() {
        require(
            systemParamsWhitelist.getWhitelisted(msg.sender),
            "NOT_SYSTEM_PARAM_ADMIN"
        );
        _;
    }

    /// @notice Sets the affiliate for an address.
    /// @param member The address to attach to the affiliate.
    /// @param affiliate The affiliate address to attach.
    function setAffiliate(address member, address affiliate)
        public
        onlySystemParamsAdmin
    {
        require(
            affiliate != address(0),
            "AFFILIATE_ZERO_ADDRESS"
        );

        addressToAffiliate[member] = affiliate;
    }

    /// @notice Sets the affiliate fee fraction for an address.
    /// @param affiliate The affiliate whose fee fraction should be changed.
    /// @param feeFrac The new fee fraction for this affiliate.
    function setAffiliateFeeFrac(address affiliate, uint256 feeFrac)
        public
        onlySystemParamsAdmin
    {
        require(
            feeFrac < MAX_AFFILIATE_FEE,
            "AFFILIATE_FEE_TOO_HIGH"
        );

        affiliateFeeFrac[affiliate] = feeFrac;
    }

    /// @notice Sets the default affiliate if no affiliate is set for an address.
    /// @param affiliate The new default affiliate.
    function setDefaultAffiliate(address affiliate)
        public
        onlySystemParamsAdmin
    {
        require(
            affiliate != address(0),
            "AFFILIATE_ZERO_ADDRESS"
        );

        defaultAffiliate = affiliate;
    }

    /// @notice Gets the affiliate for an address. If no affiliate is set, it returns the
    ///         default affiliate.
    /// @param member The address to query.
    /// @return The affiliate for this address.
    function getAffiliate(address member)
        public
        view
        returns (address)
    {
        address affiliate = addressToAffiliate[member];
        if (affiliate == address(0)) {
            return defaultAffiliate;
        } else {
            return affiliate;
        }
    }

    function getAffiliateFeeFrac(address affiliate)
        public
        view
        returns (uint256)
    {
        return affiliateFeeFrac[affiliate];
    }

    function getDefaultAffiliate()
        public
        view
        returns (address)
    {
        return defaultAffiliate;
    }

}