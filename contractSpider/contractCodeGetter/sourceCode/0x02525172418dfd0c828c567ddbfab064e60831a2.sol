/**
 *Submitted for verification at Etherscan.io on 2020-07-07
*/

pragma solidity 0.5.17;

interface IMoloch { // brief interface for minion txs to parent moloch
    function getProposalFlags(uint256 proposalId) external view returns (bool[6] memory);

    function submitProposal(
        address applicant,
        uint256 sharesRequested,
        uint256 lootRequested,
        uint256 tributeOffered,
        address tributeToken,
        uint256 paymentRequested,
        address paymentToken,
        bytes32 details
    ) external returns (uint256);
    
    function withdrawBalance(address token, uint256 amount) external;
}

contract Minion {
    IMoloch public moloch;
    address private molochDepositToken;
    mapping(uint256 => Action) public actions; // proposalId => Action

    struct Action {
        uint256 value;
        address to;
        address proposer;
        bool executed;
        bytes data;
    }

    event ProposeAction(uint256 proposalId, address proposer);
    event ExecuteAction(uint256 proposalId, address executor);

    constructor(address _moloch, address _molochDepositToken) public {
        moloch = IMoloch(_moloch);
        molochDepositToken = _molochDepositToken;
    }

    function doWithdraw(address token, uint256 amount) public {
        moloch.withdrawBalance(token, amount); // withdraw funds from parent moloch
    }

    function proposeAction(
        address actionTo,
        uint256 actionValue,
        bytes memory actionData,
        bytes32 details
    ) public returns (uint256) {
        // No calls to zero address allows us to check that minion submitted
        // the proposal without getting the proposal struct from parent moloch
        require(actionTo != address(0), "invalid actionTo");

        uint256 proposalId = moloch.submitProposal(
            address(this),
            0,
            0,
            0,
            molochDepositToken,
            0,
            molochDepositToken,
            details
        );

        Action memory action = Action({
            value: actionValue,
            to: actionTo,
            proposer: msg.sender,
            executed: false,
            data: actionData
        });

        actions[proposalId] = action;

        emit ProposeAction(proposalId, msg.sender);
        return proposalId;
    }

    function executeAction(uint256 proposalId) public returns (bytes memory) {
        Action memory action = actions[proposalId];
        bool[6] memory flags = moloch.getProposalFlags(proposalId);

        require(action.to != address(0), "invalid proposalId");
        require(!action.executed, "action executed");
        require(address(this).balance >= action.value, "insufficient eth");
        require(flags[2], "proposal not passed");

        // execute call
        actions[proposalId].executed = true;
        (bool success, bytes memory retData) = action.to.call.value(action.value)(action.data);
        require(success, "call failure");
        emit ExecuteAction(proposalId, msg.sender);
        return retData;
    }

    function() external payable {}
}

contract MinionSummoner {
    Minion private minion;
    address public molochSummoner;
    uint8 private status;
    uint8 private NOT_SET;
    uint8 private constant SET = 1;
    
    event SummonMinion(address indexed minion);

    constructor() public {
        status = NOT_SET;
    }

    function setMolochSummoner(address _molochSummoner) public {
        require(status != SET, "already set");
        molochSummoner = _molochSummoner;
        status = SET; // lock minionSummoner to molochSummoner
    }

    function summonMinion(address _moloch, address _molochDepositToken) public {
        require(msg.sender == molochSummoner, "not molochSummoner");
        minion = new Minion(_moloch, _molochDepositToken); // summon minion for parent moloch
        
        emit SummonMinion(address(minion));
    }
}