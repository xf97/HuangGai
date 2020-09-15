// "SPDX-License-Identifier: UNLICENSED "
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./Owned.sol";

contract XYSVoting is Owned{
    
    struct Case{
        uint256 id;
        string title;
        string message;
        uint256 startTime;
        uint256 Legitimate;
        uint256 Illegitimate;
    }
    
    Case[10] private cases;
    
    struct Voter{
        bool voted;
        bool legitimate;
    }
    
    uint256 _votingTimePeriod = 48 hours;
    uint256 public caseId = 0;
    uint256 public totalCases = 0;
    
    mapping(uint256 => mapping(address => Voter)) caseUserVotes;
    
    modifier caseExist(uint256 id){
        require(cases[id - 1].startTime > 0 && id >= 0);
        _;
    }
    
    /*modifier votingOpenForCase(uint256 id){
        require(now > cases[id - 1].startTime + 24 hours);
        _;
    }*/
    
    modifier caseOpen(uint256 id){
        require(cases[id - 1].startTime + _votingTimePeriod > now);
        _;
    }
    
    modifier caseNotVoted(uint256 id){
        require(!caseVoteStatus(id, msg.sender));
        _;
    }
    
    constructor(address payable _owner) public {
        owner = _owner;
    }
    
    function addCase(string calldata _title, string calldata _message) external onlyOwner{
        
        if(caseId == 10)
            caseId = 0;
            
        cases[caseId] = Case({
                                id: caseId + 1,
                                title: _title,
                                message: _message,
                                startTime: now,
                                Legitimate: 0,
                                Illegitimate: 0
                            });
        caseId++;
        totalCases++;
    }
    
    function getCases() public view returns(Case[10] memory){
        return cases;
    }
    
    function vote(uint256 _caseId, bool legitimate) external caseExist(_caseId) caseOpen(_caseId) caseNotVoted(_caseId){
        if(legitimate){
            cases[_caseId - 1].Legitimate = cases[_caseId - 1].Legitimate + 1;
            caseUserVotes[_caseId - 1][msg.sender].legitimate = true;
        }
        else{
            cases[_caseId - 1].Illegitimate = cases[_caseId - 1].Illegitimate + 1;
            caseUserVotes[_caseId - 1][msg.sender].legitimate = false;
        }   
        caseUserVotes[_caseId - 1][msg.sender].voted = true;
        
    }
    
    function caseVoteStatus(uint256 _caseId, address voter) public view returns(bool status){
        return caseUserVotes[_caseId - 1][voter].voted;
    }
    
    function getAllCaseStatus() external view returns(
        bool[] memory statuses,
        bool[] memory caseVotingOpen
    ){
        statuses = new bool[](10);
        caseVotingOpen = new bool[](10);
        
        for(uint256 i =0; i < 10; i++){
            statuses[i] = caseUserVotes[i][msg.sender].voted;
            caseVotingOpen[i] = cases[i].startTime + _votingTimePeriod > now ? true : false;
        }
        
        return (statuses, caseVotingOpen);
    }
    
    function getCoherence() external view returns(uint256 coherence){
        uint256 voted = 0;
        uint256 correct = 0;
        for(uint256 i = 0; i<100 && i<totalCases ;i++){
            if(caseVoteStatus(i + 1, msg.sender) ){
                voted++;
                
                // check its correctness with majority
                if(caseUserVotes[i][msg.sender].legitimate && cases[i].Legitimate > cases[i].Illegitimate)
                    correct++;
                else if(!caseUserVotes[i][msg.sender].legitimate && cases[i].Legitimate < cases[i].Illegitimate)
                    correct++;
            }
        }
        
        return correct*100/voted;
    }
    
}