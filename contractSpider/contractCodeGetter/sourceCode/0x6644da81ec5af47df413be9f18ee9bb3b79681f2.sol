/**
 *Submitted for verification at Etherscan.io on 2020-06-26
*/

/* Discussion:
 * https://github.com/b-u-i-d-l/ethArt/edit/master/README.md
 */
/* Description:
 * # UPDATE
 * 
 * The DFOhub team has temporarily voted to reduce to 1 $ARTE the prize received for each co-owned NFT minted for these reasons:
 * 
 * 1. Single Point Of Failure: This experiment in less than one week highlighted that 100 ARTE for every NFT minted is the wrong incentive.
 * 
 * 2. Incentives: The V1 architecture allows people to mint NFT and earn 100 $ARTE without caring to create valuable NFTs for all $ARTE Holders.
 * 
 * # And Now?
 * 
 * We're already working for the next big update of ethart (ethart V2), based on solving the quality issue.
 * 
 * ## New Reward System for minting Co-Owned NFTs:
 * 
 * Every minted NFT will remain pending for a weekly period, and if ARTE holders vote by staking a sufficient amount of Tokens, the NFT will be added to the list, and the creator will earn the Reward. This new architecture can empower the participation of ARTE holder based on a fundamental incentive to empower the quality of minted NFTs:
 * 
 * If ARTE holders think that a co-owned NFT can generate value = they choose to Reward the creator (using the ethart locked funds | 0x7687fd356d1BD155e72B6eee6c2E2067F08489fB) by minting the co-owned NFT. If not, the NFT will not be minted
 * 
 * ## State Holder Improvements:
 * 
 * Improvements in gas fees to reduce the cost of minting Co-Owned NFTs
 * 
 * ## Rewards Flexible Halving System:
 * 
 * The reward after the proposal to mint a Co-Owned NFT will be halved by the amount of locked token in the ethart wallet.
 * 
 * You can follow this R&D by this repo. More info in the following weekly updates: https://medium.com/dfohub
 */
pragma solidity ^0.6.0;

contract Interoperability {

	//The Transfer OneTime Proposal in DFOHub
	address constant private PROPOSAL = 0x5d8617E6CcDe987d05018550DD817A24B11Bec4F;
	
	//The ARTE Token
	address constant private TOKEN = 0x44b6e3e85561ce054aB13Affa0773358D795D36D;
	
	//The amount of ARTE Tokens used for vote
	uint256 constant private VOTE = 910000000000000000000000;
	
	//Te BuidlersFund Wallet Address
	address constant private WALLET = 0x2BbBC1238b567F240A915451bE0D8c210895aa95;
	
    function callOneTime(address proposal) public {

		//Transfer the BUIDL voting Tokens to this OneTime Proposal
		IMVDProxy(msg.sender).transfer(address(this), VOTE, TOKEN);

		//Vote to Accept the DFOhub proposal
		IMVDFunctionalityProposal(PROPOSAL).accept(VOTE);
    }

	//This collateral function is needed to let everyone withraw the eventual staked voting tokens still held in the proposal and give back the to the BuidlersFund wallet
	function withdraw(bool terminateFirst) public {
		//Terminate or withraw the Proposal
		if(terminateFirst) {
			IMVDFunctionalityProposal(PROPOSAL).terminate();
		} else {
			IMVDFunctionalityProposal(PROPOSAL).withdraw();
		}
		//Give back BUIDL Voting Tokens to the BuildersFund Wallet
		IERC20 token = IERC20(TOKEN);
		token.transfer(WALLET, token.balanceOf(address(this)));
	}
}

interface IERC20 {
	function balanceOf(address account) external view returns (uint256);
	function transfer(address recipient, uint256 amount) external returns (bool);
}

interface IMVDProxy {
	function transfer(address receiver, uint256 value, address token) external;
}

interface IMVDFunctionalityProposal {
    function accept(uint256 amount) external;
	function withdraw() external;
    function terminate() external;
}