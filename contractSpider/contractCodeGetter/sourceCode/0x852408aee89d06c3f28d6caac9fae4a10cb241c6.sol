/**
 *Submitted for verification at Etherscan.io on 2020-08-09
*/

// File: contracts/sol6/IERC20.sol

pragma solidity 0.6.6;


interface IERC20 {
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function approve(address _spender, uint256 _value) external returns (bool success);

    function transfer(address _to, uint256 _value) external returns (bool success);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);

    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    function balanceOf(address _owner) external view returns (uint256 balance);

    function decimals() external view returns (uint8 digits);

    function totalSupply() external view returns (uint256 supply);
}


// to support backward compatible contract name -- so function signature remains same
abstract contract ERC20 is IERC20 {

}

// File: contracts/sol6/IKyberFeeHandler.sol

pragma solidity 0.6.6;



interface IKyberFeeHandler {
    event RewardPaid(address indexed staker, uint256 indexed epoch, IERC20 indexed token, uint256 amount);
    event RebatePaid(address indexed rebateWallet, IERC20 indexed token, uint256 amount);
    event PlatformFeePaid(address indexed platformWallet, IERC20 indexed token, uint256 amount);
    event KncBurned(uint256 kncTWei, IERC20 indexed token, uint256 amount);

    function handleFees(
        IERC20 token,
        address[] calldata eligibleWallets,
        uint256[] calldata rebatePercentages,
        address platformWallet,
        uint256 platformFee,
        uint256 networkFee
    ) external payable;

    function claimReserveRebate(address rebateWallet) external returns (uint256);

    function claimPlatformFee(address platformWallet) external returns (uint256);

    function claimStakerReward(
        address staker,
        uint256 epoch
    ) external returns(uint amount);
}

// File: contracts/sol6/RewardsClaimer.sol

pragma solidity 0.6.6;



contract RewardsClaimer {
    function claimRewardStakersEpochs(
        IKyberFeeHandler[] calldata feeHandlers,
        uint256[] calldata epochs,
        address[] calldata stakers
    ) external {
        for (uint i = 0; i < feeHandlers.length; i++) {
            for (uint j = 0; j < epochs.length; j++) {
                for (uint k = 0; k < stakers.length; k++) {
                    feeHandlers[i].claimStakerReward(stakers[k], epochs[j]);
                }
            }
        }
    }

    function claimRewardStakerEpochs(
        IKyberFeeHandler[] calldata feeHandlers,
        uint256[] calldata epochs,
        address staker
    ) external {
        for (uint i = 0; i < feeHandlers.length; i++) {
            for (uint j = 0; j < epochs.length; j++) {
                feeHandlers[i].claimStakerReward(staker, epochs[j]);
            }
        }
    }

    function claimRewardStakersEpoch(
        IKyberFeeHandler[] calldata feeHandlers,
        uint256 epoch,
        address[] calldata stakers
    ) external {
        for (uint i = 0; i < feeHandlers.length; i++) {
            for (uint j = 0; j < stakers.length; j++) {
                feeHandlers[i].claimStakerReward(stakers[j], epoch);
            }
        }
    }
}