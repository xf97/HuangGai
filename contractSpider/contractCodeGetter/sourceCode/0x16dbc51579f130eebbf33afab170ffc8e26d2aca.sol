/**
 *Submitted for verification at Etherscan.io on 2020-06-03
*/

/* Discussion:
 * https://etherscan.io/address/0x91D9499EFaB86Afd95E71735C5D7B5AdCAa16A6E
 */
/* Description:
 * Set Hard Cap of votes for Proposals. With this new Optional Rule, if a proposal reaches a fixed number of voting tokens (example the 90% of the total Token supply) for “Approve” or “Disapprove” it, the proposal automatically ends, independently from the duration rule.
 */
pragma solidity ^0.6.0;

contract GetVotesHardCapFunctionality {

    function onStop(address) public {
    }

    function onStart(address,address) public {
    }

    function getVotesHardCap() public view returns(uint256) {
        return 5900000000000000000;
    }
}