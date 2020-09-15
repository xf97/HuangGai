/**
 *Submitted for verification at Etherscan.io on 2020-05-31
*/

/**
** ██████╗ ██████╗ ███████╗███╗   ██╗        
* ██╔═══██╗██╔══██╗██╔════╝████╗  ██║        
* ██║   ██║██████╔╝█████╗  ██╔██╗ ██║        
* ██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║        
* ╚██████╔╝██║     ███████╗██║ ╚████║        
*  ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝        
*                                           
** ██████╗ ██████╗ ██╗   ██╗██████╗ ████████╗
* ██╔════╝██╔═══██╗██║   ██║██╔══██╗╚══██╔══╝
* ██║     ██║   ██║██║   ██║██████╔╝   ██║   
* ██║     ██║   ██║██║   ██║██╔══██╗   ██║   
* ╚██████╗╚██████╔╝╚██████╔╝██║  ██║   ██║   
**/

pragma solidity 0.5.17;
/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

interface IToken { // brief ERC-20 interface
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

/*****************
OpenCourt Protocol
*****************/
contract OpenCourt is Context { 
    // internal references
    address public judge;
    address public judgment;
    address payable public openCourt;
    uint256 public judgeBalance;
    uint256 public judgmentReward;
    string public procedures;

    // dispute tracking 
    uint256 public dispute; 
    mapping (uint256 => Dispute) public disp;
    
    struct Dispute {  
        address complainant; 
        address respondent;
        address token;
        uint256 disputed;
        uint256 number;
        string complaint;
        string response;
        string verdict;
        bool resolved;
        bool responded;
    }
    
    event Complaint(address indexed complainant, address indexed respondent, uint256 indexed number, string complaint);
    event ComplaintUpdated(uint256 indexed number, string complaint);
    event Response(uint256 indexed number, string response);
    event Verdict(uint256 indexed number, string verdict);
    event OpenCourtPaid(address indexed sender, uint256 indexed payment, string indexed details);
    
    constructor (
        address _judge, 
        address _judgment, 
        address payable _openCourt, 
        uint256 _judgeBalance, 
        uint256 _judgmentReward,
        string memory _procedures) public { 
        judge = _judge;
        judgment = _judgment;
        openCourt = _openCourt;
        judgeBalance = _judgeBalance;
        judgmentReward = _judgmentReward;
        procedures = _procedures;
    } 
    
    /**************
    COURT FUNCTIONS
    **************/
    /**Complaint**/
    function submitComplaint(address respondent, address token, uint256 disputed, string memory complaint) public {
	    uint256 number = dispute + 1; 
	    dispute = dispute + 1;
	    
        disp[number] = Dispute( 
            _msgSender(),
            respondent,
            token,
            disputed,
            number,
            complaint,
            "PENDING",
            "PENDING",
            false,
            false);
                
        emit Complaint(_msgSender(), respondent, number, complaint);
    }
    
    function updateComplaint(uint256 number, string memory updatedComplaint) public {
        Dispute storage dis = disp[number];
        require(_msgSender() == dis.complainant, "caller not complainant");
        dis.complaint = updatedComplaint;
        emit ComplaintUpdated(number, updatedComplaint);
    }
    
    /**Response**/
    function submitResponse(uint256 number, string memory response) public {
	    Dispute storage dis = disp[number];
        require(_msgSender() == dis.respondent, "caller not respondent");
        dis.response = response;
        dis.responded = true;
        emit Response(number, response);
    }

    /**Verdict**/
    function issueVerdict(uint256 number, uint256 complainantAward, uint256 respondentAward, string memory verdict) public {
        Dispute storage dis = disp[number];
        require(_msgSender() != dis.complainant, "resolver cannot be dispute party");
        require(_msgSender() != dis.respondent, "resolver cannot be dispute party");
        require(complainantAward + respondentAward == dis.disputed, "resolution award must equal deposit amount");
        require(IToken(judge).balanceOf(_msgSender()) >= judgeBalance, "judge token balance insufficient to resolve");
        IToken(dis.token).transferFrom(dis.complainant, dis.respondent, respondentAward);
        IToken(dis.token).transferFrom(dis.respondent, dis.complainant, complainantAward);
        dis.verdict = verdict;
        dis.resolved = true;
        IToken(judgment).transfer(_msgSender(), judgmentReward);
        emit Verdict(number, verdict);
    }
    
    /*************
    MGMT FUNCTIONS
    *************/
    modifier onlyOpenCourt () {
        require(_msgSender() == openCourt, "caller not openCourt");
        _;
    }
    
    function payOpenCourt(string memory details) payable public { // public attaches ether (Ξ) with details to openCourt
        openCourt.transfer(msg.value);
        emit OpenCourtPaid(_msgSender(), msg.value, details);
    }

    function updateJudge(address _judge) public onlyOpenCourt { // token address
        judge = _judge;
    }
    
    function updateJudgeBalance(uint256 _judgeBalance) public onlyOpenCourt {
        judgeBalance = _judgeBalance;
    }
    
    function updateJudgment(address _judgment) public onlyOpenCourt { // token address
        judgment = _judgment;
    }
    
    function updateJudgmentReward(uint256 _judgmentReward) public onlyOpenCourt {
        judgmentReward = _judgmentReward;
    }

    function updateOpenCourt(address payable _openCourt) public onlyOpenCourt {
        openCourt = _openCourt;
    }
    
    function updateProcedures(string memory _procedures) public onlyOpenCourt {
        procedures = _procedures;
    }
}