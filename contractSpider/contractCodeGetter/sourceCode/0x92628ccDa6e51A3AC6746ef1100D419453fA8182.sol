/**
 *Submitted for verification at Etherscan.io on 2020-06-03
*/

/* Description:
 * DFO Protocol - Community-Driven Governance.
 * This is the well-known Functionality provided by the DFO protocol, which is triggered when a Proposal is finalized (whether it is successful or not).
 * In case the Proposal Survey is successful (result value set to true), its proposer will receive an amount of Voting Tokens as a reward.
 * The reward amount is initially decided during the DFO Creation and can be changed with a proposal changing the value of the surveySingleReward variable set into the DFO StateHolder.
 */
/* Discussion:
 * https://gitcoin.co/grants/154/decentralized-flexible-organization
 */
pragma solidity ^0.6.0;

contract CommunityDrivenGovernance {

    function onStart(address, address) public {
    }

    function onStop(address) public {
    }

    function proposalEnd(address proposal, bool result) public {
        if(!result) {
            return;
        }
        IMVDProxy proxy = IMVDProxy(msg.sender);
        if(IMVDFunctionalitiesManager(proxy.getMVDFunctionalitiesManagerAddress()).hasFunctionality("getSurveySingleReward")) {
            uint256 surveySingleReward = toUint256(proxy.read("getSurveySingleReward", bytes("")));
            if(surveySingleReward > 0) {
                proxy.transfer(IMVDFunctionalityProposal(proposal).getProposer(), surveySingleReward, proxy.getToken());
            }
        }
    }

    function toUint256(bytes memory bs) private pure returns(uint256 x) {
        if(bs.length >= 32) {
            assembly {
                x := mload(add(bs, add(0x20, 0)))
            }
        }
    }
}

interface IVotingToken {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface IMVDProxy {
    function getToken() external view returns(address);
    function getMVDFunctionalitiesManagerAddress() external view returns(address);
    function transfer(address receiver, uint256 value, address token) external;
    function hasFunctionality(string calldata codeName) external view returns(bool);
    function read(string calldata codeName, bytes calldata data) external view returns(bytes memory returnData);
}

interface IMVDFunctionalityProposal {
    function getProposer() external view returns(address);
}

interface IMVDFunctionalitiesManager {
    function hasFunctionality(string calldata codeName) external view returns(bool);
}