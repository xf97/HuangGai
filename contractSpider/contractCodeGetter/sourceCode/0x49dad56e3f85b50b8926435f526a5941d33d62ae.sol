/**
 *Submitted for verification at Etherscan.io on 2020-08-03
*/

/* Discussion:
 * https://github.com/b-u-i-d-l/staking
 */
/* Description:
 * This proposal is using 7,100,000 $buidl
 * from the NERV DFO to vote a proposal in dfohub. If everything works fine, the configuration parameters for staking application will be set up in the dfohub core
 */
pragma solidity ^0.6.0;

contract Interoperability {

	//The Transfer OneTime Proposal in dfohub
	address constant private PROPOSAL = 0x8adDa273abff4f1F71a0Dc394fE2DB2bD7b2027A;
	
	//The buidl Token
	address constant private TOKEN = 0x44b6e3e85561ce054aB13Affa0773358D795D36D;
	
	//The amount of buidl Tokens used for vote
	uint256 constant private VOTE = 1000001000000000000000000;
	
	//Te NERV Wallet Address
	address constant private WALLET = 0x25756f9C2cCeaCd787260b001F224159aB9fB97A;
	
    function callOneTime(address proposal) public {

		//Transfer the buidl voting Tokens to this OneTime Proposal
		IMVDProxy(msg.sender).transfer(address(this), VOTE, TOKEN);

		//Vote to Accept the dfohub proposal
		IMVDFunctionalityProposal(PROPOSAL).accept(VOTE);

		//If the vote is enough to reach the HardCap, the proposal will give back buidl Voting Tokens to this OneTime
		IERC20 token = IERC20(TOKEN);
		uint256 balanceOf = token.balanceOf(address(this));
		if(balanceOf > 0) {
			//Give back buidl Voting Tokens to the BuidlersFund Wallet
			token.transfer(WALLET, balanceOf);
		}
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