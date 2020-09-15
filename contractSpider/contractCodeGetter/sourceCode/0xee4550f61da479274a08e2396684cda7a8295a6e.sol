/**
 *Submitted for verification at Etherscan.io on 2020-06-03
*/

pragma solidity 0.5.17;

contract Shame { 
    bool private erichDylusShamed = true;

    function context() public pure returns(string memory) {
        return "https://twitter.com/contractslegal/status/1267594578548400129?s=20";
    }
    
    function isErichDylusShamed() public view returns(bool) {
        return erichDylusShamed;
    }
    
    function publicAbsolution() public {
        require(msg.sender == 0x1C0Aa8cCD568d90d61659F060D1bFb1e6f855A20 || 
        msg.sender == 0x297BF847Dcb01f3e870515628b36EAbad491e5E8, "caller not ross or ameen");
        require(erichDylusShamed == true, "shamed already absolved");
        erichDylusShamed = false;
    }

    function publicShaming() public view returns(string memory) {
        if(erichDylusShamed == false) {
            return "kudos";
        } else {
            return "shame";
        }
    }
}