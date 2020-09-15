/**
 *Submitted for verification at Etherscan.io on 2020-07-01
*/

pragma solidity ^0.5.0;

/**
* @title Tellor Transfer
* @dev Contais the methods related to transfers and ERC20. Tellor.sol and TellorGetters.sol
* reference this library for function's logic.
* Many of the functions have been commented out for simplicity.
*/
library TellorTransfer {
    using SafeMath for uint256;

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);//ERC20 Approval event
    event Transfer(address indexed _from, address indexed _to, uint256 _value);//ERC20 Transfer Event

    /*Functions*/

    /**
    * @dev Allows for a transfer of tokens to _to
    * @param _to The address to send tokens to
    * @param _amount The amount of tokens to send
    * @return true if transfer is successful
    */
    function transfer(TellorStorage.TellorStorageStruct storage self, address _to, uint256 _amount) public returns (bool success) {
        doTransfer(self,msg.sender, _to, _amount);
        return true;
    }


    /**
    * @notice Send _amount tokens to _to from _from on the condition it
    * is approved by _from
    * @param _from The address holding the tokens being transferred
    * @param _to The address of the recipient
    * @param _amount The amount of tokens to be transferred
    * @return True if the transfer was successful
    */
    function transferFrom(TellorStorage.TellorStorageStruct storage self, address _from, address _to, uint256 _amount) public returns (bool success) {
        require(self.allowed[_from][msg.sender] >= _amount);
        self.allowed[_from][msg.sender] -= _amount;
        doTransfer(self,_from, _to, _amount);
        return true;
    }


    /**
    * @dev This function approves a _spender an _amount of tokens to use
    * @param _spender address
    * @param _amount amount the spender is being approved for
    * @return true if spender appproved successfully
    */
    function approve(TellorStorage.TellorStorageStruct storage self, address _spender, uint _amount) public returns (bool) {
        require(_spender != address(0));
        self.allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }


    // /**
    // * @param _user address of party with the balance
    // * @param _spender address of spender of parties said balance
    // * @return Returns the remaining allowance of tokens granted to the _spender from the _user
    // */
    // function allowance(TellorStorage.TellorStorageStruct storage self,address _user, address _spender) public view returns (uint) {
    //    return self.allowed[_user][_spender];
    // }


    /**
    * @dev Completes POWO transfers by updating the balances on the current block number
    * @param _from address to transfer from
    * @param _to addres to transfer to
    * @param _amount to transfer
    */
    function doTransfer(TellorStorage.TellorStorageStruct storage self, address _from, address _to, uint _amount) public {
        require(_amount > 0);
        require(_to != address(0));
        require(allowedToTrade(self,_from,_amount)); //allowedToTrade checks the stakeAmount is removed from balance if the _user is staked
        uint previousBalance = balanceOfAt(self,_from, block.number);
        updateBalanceAtNow(self.balances[_from], previousBalance - _amount);
        previousBalance = balanceOfAt(self,_to, block.number);
        require(previousBalance + _amount >= previousBalance); // Check for overflow
        updateBalanceAtNow(self.balances[_to], previousBalance + _amount);
        emit Transfer(_from, _to, _amount);
    }


    /**
    * @dev Gets balance of owner specified
    * @param _user is the owner address used to look up the balance
    * @return Returns the balance associated with the passed in _user
    */
    function balanceOf(TellorStorage.TellorStorageStruct storage self,address _user) public view returns (uint) {
        return balanceOfAt(self,_user, block.number);
    }


    /**
    * @dev Queries the balance of _user at a specific _blockNumber
    * @param _user The address from which the balance will be retrieved
    * @param _blockNumber The block number when the balance is queried
    * @return The balance at _blockNumber specified
    */
    function balanceOfAt(TellorStorage.TellorStorageStruct storage self,address _user, uint _blockNumber) public view returns (uint) {
        if ((self.balances[_user].length == 0) || (self.balances[_user][0].fromBlock > _blockNumber)) {
                return 0;
        }
     else {
        return getBalanceAt(self.balances[_user], _blockNumber);
     }
    }


    /**
    * @dev Getter for balance for owner on the specified _block number
    * @param checkpoints gets the mapping for the balances[owner]
    * @param _block is the block number to search the balance on
    * @return the balance at the checkpoint
    */
    function getBalanceAt(TellorStorage.Checkpoint[] storage checkpoints, uint _block) view public returns (uint) {
        if (checkpoints.length == 0) return 0;
        if (_block >= checkpoints[checkpoints.length-1].fromBlock)
            return checkpoints[checkpoints.length-1].value;
        if (_block < checkpoints[0].fromBlock) return 0;
        // Binary search of the value in the array
        uint min = 0;
        uint max = checkpoints.length-1;
        while (max > min) {
            uint mid = (max + min + 1)/ 2;
            if (checkpoints[mid].fromBlock<=_block) {
                min = mid;
            } else {
                max = mid-1;
            }
        }
        return checkpoints[min].value;
    }


    /**
    * @dev This function returns whether or not a given user is allowed to trade a given amount
    * and removing the staked amount from their balance if they are staked
    * @param _user address of user
    * @param _amount to check if the user can spend
    * @return true if they are allowed to spend the amount being checked
    */
    function allowedToTrade(TellorStorage.TellorStorageStruct storage self,address _user,uint _amount) public view returns(bool) {
        if(self.stakerDetails[_user].currentStatus >0){
            //Removes the stakeAmount from balance if the _user is staked
            if(balanceOf(self,_user).sub(self.uintVars[keccak256("stakeAmount")]).sub(_amount) >= 0){
                return true;
            }
        }
        else if(balanceOf(self,_user).sub(_amount) >= 0){
                return true;
        }
        return false;
    }


    /**
    * @dev Updates balance for from and to on the current block number via doTransfer
    * @param checkpoints gets the mapping for the balances[owner]
    * @param _value is the new balance
    */
    function updateBalanceAtNow(TellorStorage.Checkpoint[] storage checkpoints, uint _value) public {
        if ((checkpoints.length == 0) || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
               TellorStorage.Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
               newCheckPoint.fromBlock =  uint128(block.number);
               newCheckPoint.value = uint128(_value);
        } else {
               TellorStorage.Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
               oldCheckPoint.value = uint128(_value);
        }
    }
}




//Slightly modified SafeMath library - includes a min and max function, removes useless div function
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function add(int256 a, int256 b) internal pure returns (int256 c) {
        if (b > 0) {
            c = a + b;
            assert(c >= a);
        } else {
            c = a + b;
            assert(c <= a);
        }
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    function max(int256 a, int256 b) internal pure returns (uint256) {
        return a > b ? uint256(a) : uint256(b);
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function sub(int256 a, int256 b) internal pure returns (int256 c) {
        if (b > 0) {
            c = a - b;
            assert(c <= a);
        } else {
            c = a - b;
            assert(c >= a);
        }

    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }
}


/**
 * @title Tellor Oracle Storage Library
 * @dev Contains all the variables/structs used by Tellor
 * This test file is exactly the same as the production/mainnet file.
 */

library TellorStorage {
    //Internal struct for use in proof-of-work submission
    struct Details {
        uint value;
        address miner;
    }

    struct Dispute {
        bytes32 hash;//unique hash of dispute: keccak256(_miner,_requestId,_timestamp)
        int tally;//current tally of votes for - against measure
        bool executed;//is the dispute settled
        bool disputeVotePassed;//did the vote pass?
        bool isPropFork; //true for fork proposal NEW
        address reportedMiner; //miner who alledgedly submitted the 'bad value' will get disputeFee if dispute vote fails
        address reportingParty;//miner reporting the 'bad value'-pay disputeFee will get reportedMiner's stake if dispute vote passes
        address proposedForkAddress;//new fork address (if fork proposal)
        mapping(bytes32 => uint) disputeUintVars;
        //Each of the variables below is saved in the mapping disputeUintVars for each disputeID
        //e.g. TellorStorageStruct.DisputeById[disputeID].disputeUintVars[keccak256("requestId")]
        //These are the variables saved in this mapping:
            // uint keccak256("requestId");//apiID of disputed value
            // uint keccak256("timestamp");//timestamp of distputed value
            // uint keccak256("value"); //the value being disputed
            // uint keccak256("minExecutionDate");//7 days from when dispute initialized
            // uint keccak256("numberOfVotes");//the number of parties who have voted on the measure
            // uint keccak256("blockNumber");// the blocknumber for which votes will be calculated from
            // uint keccak256("minerSlot"); //index in dispute array
            // uint keccak256("quorum"); //quorum for dispute vote NEW
            // uint keccak256("fee"); //fee paid corresponding to dispute
        mapping (address => bool) voted; //mapping of address to whether or not they voted
    }

    struct StakeInfo {
        uint currentStatus;//0-not Staked, 1=Staked, 2=LockedForWithdraw 3= OnDispute
        uint startDate; //stake start date
    }

    //Internal struct to allow balances to be queried by blocknumber for voting purposes
    struct  Checkpoint {
        uint128 fromBlock;// fromBlock is the block number that the value was generated from
        uint128 value;// value is the amount of tokens at a specific block number
    }

    struct Request {
        string queryString;//id to string api
        string dataSymbol;//short name for api request
        bytes32 queryHash;//hash of api string and granularity e.g. keccak256(abi.encodePacked(_sapi,_granularity))
        uint[]  requestTimestamps; //array of all newValueTimestamps requested
        mapping(bytes32 => uint) apiUintVars;
        //Each of the variables below is saved in the mapping apiUintVars for each api request
        //e.g. requestDetails[_requestId].apiUintVars[keccak256("totalTip")]
        //These are the variables saved in this mapping:
            // uint keccak256("granularity"); //multiplier for miners
            // uint keccak256("requestQPosition"); //index in requestQ
            // uint keccak256("totalTip");//bonus portion of payout
        mapping(uint => uint) minedBlockNum;//[apiId][minedTimestamp]=>block.number
        mapping(uint => uint) finalValues;//This the time series of finalValues stored by the contract where uint UNIX timestamp is mapped to value
        mapping(uint => bool) inDispute;//checks if API id is in dispute or finalized.
        mapping(uint => address[5]) minersByValue;
        mapping(uint => uint[5])valuesByTimestamp;
    }

    struct TellorStorageStruct {
        bytes32 currentChallenge; //current challenge to be solved
        uint[51]  requestQ; //uint50 array of the top50 requests by payment amount
        uint[]  newValueTimestamps; //array of all timestamps requested
        Details[5]  currentMiners; //This struct is for organizing the five mined values to find the median
        mapping(bytes32 => address) addressVars;
        //Address fields in the Tellor contract are saved the addressVars mapping
        //e.g. addressVars[keccak256("tellorContract")] = address
        //These are the variables saved in this mapping:
            // address keccak256("tellorContract");//Tellor address
            // address  keccak256("_owner");//Tellor Owner address
            // address  keccak256("_deity");//Tellor Owner that can do things at will
        mapping(bytes32 => uint) uintVars;
        //uint fields in the Tellor contract are saved the uintVars mapping
        //e.g. uintVars[keccak256("decimals")] = uint
        //These are the variables saved in this mapping:
            // keccak256("decimals");    //18 decimal standard ERC20
            // keccak256("disputeFee");//cost to dispute a mined value
            // keccak256("disputeCount");//totalHistoricalDisputes
            // keccak256("total_supply"); //total_supply of the token in circulation
            // keccak256("stakeAmount");//stakeAmount for miners (we can cut gas if we just hardcode it in...or should it be variable?)
            // keccak256("stakerCount"); //number of parties currently staked
            // keccak256("timeOfLastNewValue"); // time of last challenge solved
            // keccak256("difficulty"); // Difficulty of current block
            // keccak256("currentTotalTips"); //value of highest api/timestamp PayoutPool
            // keccak256("currentRequestId"); //API being mined--updates with the ApiOnQ Id
            // keccak256("requestCount"); // total number of requests through the system
            // keccak256("slotProgress");//Number of miners who have mined this value so far
            // keccak256("miningReward");//Mining Reward in PoWo tokens given to all miners per value
            // keccak256("timeTarget"); //The time between blocks (mined Oracle values)
        mapping(bytes32 => mapping(address=>bool)) minersByChallenge;//This is a boolean that tells you if a given challenge has been completed by a given miner
        mapping(uint => uint) requestIdByTimestamp;//minedTimestamp to apiId
        mapping(uint => uint) requestIdByRequestQIndex; //link from payoutPoolIndex (position in payout pool array) to apiId
        mapping(uint => Dispute) disputesById;//disputeId=> Dispute details
        mapping (address => Checkpoint[]) balances; //balances of a party given blocks
        mapping(address => mapping (address => uint)) allowed; //allowance for a given party and approver
        mapping(address => StakeInfo)  stakerDetails;//mapping from a persons address to their staking info
        mapping(uint => Request) requestDetails;//mapping of apiID to details
        mapping(bytes32 => uint) requestIdByQueryHash;// api bytes32 gets an id = to count of requests array
        mapping(bytes32 => uint) disputeIdByDisputeHash;//maps a hash to an ID for each dispute
    }
}

//Functions for retrieving min and Max in 51 length array (requestQ)
//Taken partly from: https://github.com/modular-network/ethereum-libraries-array-utils/blob/master/contracts/Array256Lib.sol

library Utilities{

    /**
    * @dev Returns the minimum value in an array.
    */
    function getMax(uint[51] memory data) internal pure returns(uint256 max,uint256 maxIndex) {
        max = data[1];
        maxIndex;
        for(uint i=1;i < data.length;i++){
            if(data[i] > max){
                max = data[i];
                maxIndex = i;
                }
        }
    }

    /**
    * @dev Returns the minimum value in an array.
    */
    function getMin(uint[51] memory data) internal pure returns(uint256 min,uint256 minIndex) {
        minIndex = data.length - 1;
        min = data[minIndex];
        for(uint i = data.length-1;i > 0;i--) {
            if(data[i] < min) {
                min = data[i];
                minIndex = i;
            }
        }
  }
}



/**
* @title Tellor Getters Library
* @dev This is the test getter library for all variables in the Tellor Tributes system. TellorGetters references this
* libary for the getters logic.
* Many of the functions have been commented out for simplicity.
*/



library TellorGettersLibrary{
    using SafeMath for uint256;

    event NewTellorAddress(address _newTellor); //emmited when a proposed fork is voted true

    /*Functions*/

    //The next two functions are onlyOwner functions.  For Tellor to be truly decentralized, we will need to transfer the Deity to the 0 address.
    //Only needs to be in library
    /**
    * @dev This function allows us to set a new Deity (or remove it)
    * @param _newDeity address of the new Deity of the tellor system
    */
    function changeDeity(TellorStorage.TellorStorageStruct storage self, address _newDeity) internal{
        require(self.addressVars[keccak256("_deity")] == msg.sender);
        self.addressVars[keccak256("_deity")] =_newDeity;
    }


    //Only needs to be in library
    /**
    * @dev This function allows the deity to upgrade the Tellor System
    * @param _tellorContract address of new updated TellorCore contract
    */
    function changeTellorContract(TellorStorage.TellorStorageStruct storage self,address _tellorContract) internal{
        require(self.addressVars[keccak256("_deity")] == msg.sender);
        self.addressVars[keccak256("tellorContract")]= _tellorContract;
        emit NewTellorAddress(_tellorContract);
    }


    // /*Tellor Getters*/

    // /**
    // * @dev This function tells you if a given challenge has been completed by a given miner
    // * @param _challenge the challenge to search for
    // * @param _miner address that you want to know if they solved the challenge
    // * @return true if the _miner address provided solved the
    // */
    // function didMine(TellorStorage.TellorStorageStruct storage self, bytes32 _challenge,address _miner) internal view returns(bool){
    //     return self.minersByChallenge[_challenge][_miner];
    // }


    // /**
    // * @dev Checks if an address voted in a dispute
    // * @param _disputeId to look up
    // * @param _address of voting party to look up
    // * @return bool of whether or not party voted
    // */
    // function didVote(TellorStorage.TellorStorageStruct storage self,uint _disputeId, address _address) internal view returns(bool){
    //     return self.disputesById[_disputeId].voted[_address];
    // }


    // /**
    // * @dev allows Tellor to read data from the addressVars mapping
    // * @param _data is the keccak256("variable_name") of the variable that is being accessed.
    // * These are examples of how the variables are saved within other functions:
    // * addressVars[keccak256("_owner")]
    // * addressVars[keccak256("tellorContract")]
    // */
    // function getAddressVars(TellorStorage.TellorStorageStruct storage self, bytes32 _data) view internal returns(address){
    //     return self.addressVars[_data];
    // }


    // *
    // * @dev Gets all dispute variables
    // * @param _disputeId to look up
    // * @return bytes32 hash of dispute
    // * @return bool executed where true if it has been voted on
    // * @return bool disputeVotePassed
    // * @return bool isPropFork true if the dispute is a proposed fork
    // * @return address of reportedMiner
    // * @return address of reportingParty
    // * @return address of proposedForkAddress
    // * @return uint of requestId
    // * @return uint of timestamp
    // * @return uint of value
    // * @return uint of minExecutionDate
    // * @return uint of numberOfVotes
    // * @return uint of blocknumber
    // * @return uint of minerSlot
    // * @return uint of quorum
    // * @return uint of fee
    // * @return int count of the current tally

    // function getAllDisputeVars(TellorStorage.TellorStorageStruct storage self,uint _disputeId) internal view returns(bytes32, bool, bool, bool, address, address, address,uint[9] memory, int){
    //     TellorStorage.Dispute storage disp = self.disputesById[_disputeId];
    //     return(disp.hash,disp.executed, disp.disputeVotePassed, disp.isPropFork, disp.reportedMiner, disp.reportingParty,disp.proposedForkAddress,[disp.disputeUintVars[keccak256("requestId")], disp.disputeUintVars[keccak256("timestamp")], disp.disputeUintVars[keccak256("value")], disp.disputeUintVars[keccak256("minExecutionDate")], disp.disputeUintVars[keccak256("numberOfVotes")], disp.disputeUintVars[keccak256("blockNumber")], disp.disputeUintVars[keccak256("minerSlot")], disp.disputeUintVars[keccak256("quorum")],disp.disputeUintVars[keccak256("fee")]],disp.tally);
    // }


    // /**
    // * @dev Getter function for variables for the requestId being currently mined(currentRequestId)
    // * @return current challenge, curretnRequestId, level of difficulty, api/query string, and granularity(number of decimals requested), total tip for the request
    // */
    // function getCurrentVariables(TellorStorage.TellorStorageStruct storage self) internal view returns(bytes32, uint, uint,string memory,uint,uint){
    //     return (self.currentChallenge,self.uintVars[keccak256("currentRequestId")],self.uintVars[keccak256("difficulty")],self.requestDetails[self.uintVars[keccak256("currentRequestId")]].queryString,self.requestDetails[self.uintVars[keccak256("currentRequestId")]].apiUintVars[keccak256("granularity")],self.requestDetails[self.uintVars[keccak256("currentRequestId")]].apiUintVars[keccak256("totalTip")]);
    // }


    // /**
    // * @dev Checks if a given hash of miner,requestId has been disputed
    // * @param _hash is the sha256(abi.encodePacked(_miners[2],_requestId));
    // * @return uint disputeId
    // */
    // function getDisputeIdByDisputeHash(TellorStorage.TellorStorageStruct storage self,bytes32 _hash) internal view returns(uint){
    //     return  self.disputeIdByDisputeHash[_hash];
    // }


    // /*
    // * @dev Checks for uint variables in the disputeUintVars mapping based on the disuputeId
    // * @param _disputeId is the dispute id;
    // * @param _data the variable to pull from the mapping. _data = keccak256("variable_name") where variable_name is
    // * the variables/strings used to save the data in the mapping. The variables names are
    // * commented out under the disputeUintVars under the Dispute struct
    // * @return uint value for the bytes32 data submitted
    // */
    // function getDisputeUintVars(TellorStorage.TellorStorageStruct storage self,uint _disputeId,bytes32 _data) internal view returns(uint){
    //     return self.disputesById[_disputeId].disputeUintVars[_data];
    // }


    // /**
    // * @dev Gets the a value for the latest timestamp available
    // * @return value for timestamp of last proof of work submited
    // * @return true if the is a timestamp for the lastNewValue
    // */
    // function getLastNewValue(TellorStorage.TellorStorageStruct storage self) internal view returns(uint,bool){
    //     return (retrieveData(self,self.requestIdByTimestamp[self.uintVars[keccak256("timeOfLastNewValue")]], self.uintVars[keccak256("timeOfLastNewValue")]),true);
    // }


    // /**
    // * @dev Gets the a value for the latest timestamp available
    // * @param _requestId being requested
    // * @return value for timestamp of last proof of work submited and if true if it exist or 0 and false if it doesn't
    // */
    // function getLastNewValueById(TellorStorage.TellorStorageStruct storage self,uint _requestId) internal view returns(uint,bool){
    //     TellorStorage.Request storage _request = self.requestDetails[_requestId];
    //     if(_request.requestTimestamps.length > 0){
    //         return (retrieveData(self,_requestId,_request.requestTimestamps[_request.requestTimestamps.length - 1]),true);
    //     }
    //     else{
    //         return (0,false);
    //     }
    // }


    // /**
    // * @dev Gets blocknumber for mined timestamp
    // * @param _requestId to look up
    // * @param _timestamp is the timestamp to look up blocknumber
    // * @return uint of the blocknumber which the dispute was mined
    // */
    // function getMinedBlockNum(TellorStorage.TellorStorageStruct storage self,uint _requestId, uint _timestamp) internal view returns(uint){
    //     return self.requestDetails[_requestId].minedBlockNum[_timestamp];
    // }


    // /**
    // * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp
    // * @param _requestId to look up
    // * @param _timestamp is the timestamp to look up miners for
    // * @return the 5 miners' addresses
    // */
    // function getMinersByRequestIdAndTimestamp(TellorStorage.TellorStorageStruct storage self, uint _requestId, uint _timestamp) internal view returns(address[5] memory){
    //     return self.requestDetails[_requestId].minersByValue[_timestamp];
    // }


    // /**
    // * @dev Get the name of the token
    // * @return string of the token name
    // */
    // function getName(TellorStorage.TellorStorageStruct storage self) internal pure returns(string memory){
    //     return "Tellor Tributes";
    // }


    /**
    * @dev Counts the number of values that have been submited for the request
    * if called for the currentRequest being mined it can tell you how many miners have submitted a value for that
    * request so far
    * @param _requestId the requestId to look up
    * @return uint count of the number of values received for the requestId
    */
    function getNewValueCountbyRequestId(TellorStorage.TellorStorageStruct storage self, uint _requestId) internal view returns(uint){
        return self.requestDetails[_requestId].requestTimestamps.length;
    }


    // /**
    // * @dev Getter function for the specified requestQ index
    // * @param _index to look up in the requestQ array
    // * @return uint of reqeuestId
    // */
    // function getRequestIdByRequestQIndex(TellorStorage.TellorStorageStruct storage self, uint _index) internal view returns(uint){
    //     require(_index <= 50);
    //     return self.requestIdByRequestQIndex[_index];
    // }


    // /**
    // * @dev Getter function for requestId based on timestamp
    // * @param _timestamp to check requestId
    // * @return uint of reqeuestId
    // */
    // function getRequestIdByTimestamp(TellorStorage.TellorStorageStruct storage self, uint _timestamp) internal view returns(uint){
    //     return self.requestIdByTimestamp[_timestamp];
    // }


    /**
    * @dev Getter function for requestId based on the qeuaryHash
    * @param _queryHash hash(of string api and granularity) to check if a request already exists
    * @return uint requestId
    */
    function getRequestIdByQueryHash(TellorStorage.TellorStorageStruct storage self, bytes32 _queryHash) internal view returns(uint){
        return self.requestIdByQueryHash[_queryHash];
    }


    // /**
    // * @dev Getter function for the requestQ array
    // * @return the requestQ arrray
    // */
    // function getRequestQ(TellorStorage.TellorStorageStruct storage self) view internal returns(uint[51] memory){
    //     return self.requestQ;
    // }


    // *
    // * @dev Allowes access to the uint variables saved in the apiUintVars under the requestDetails struct
    // * for the requestId specified
    // * @param _requestId to look up
    // * @param _data the variable to pull from the mapping. _data = keccak256("variable_name") where variable_name is
    // * the variables/strings used to save the data in the mapping. The variables names are
    // * commented out under the apiUintVars under the requestDetails struct
    // * @return uint value of the apiUintVars specified in _data for the requestId specified

    // function getRequestUintVars(TellorStorage.TellorStorageStruct storage self,uint _requestId,bytes32 _data) internal view returns(uint){
    //     return self.requestDetails[_requestId].apiUintVars[_data];
    // }


    /**
    * @dev Gets the API struct variables that are not mappings
    * @param _requestId to look up
    * @return string of api to query
    * @return string of symbol of api to query
    * @return bytes32 hash of string
    * @return bytes32 of the granularity(decimal places) requested
    * @return uint of index in requestQ array
    * @return uint of current payout/tip for this requestId
    */
    function getRequestVars(TellorStorage.TellorStorageStruct storage self,uint _requestId) internal view returns(string memory,string memory, bytes32,uint, uint, uint) {
        TellorStorage.Request storage _request = self.requestDetails[_requestId];
        return (_request.queryString,_request.dataSymbol,_request.queryHash, _request.apiUintVars[keccak256("granularity")],_request.apiUintVars[keccak256("requestQPosition")],_request.apiUintVars[keccak256("totalTip")]);
    }


    // /**
    // * @dev This function allows users to retireve all information about a staker
    // * @param _staker address of staker inquiring about
    // * @return uint current state of staker
    // * @return uint startDate of staking
    // */
    // function getStakerInfo(TellorStorage.TellorStorageStruct storage self,address _staker) internal view returns(uint,uint){
    //     return (self.stakerDetails[_staker].currentStatus,self.stakerDetails[_staker].startDate);
    // }


    // /**
    // * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp
    // * @param _requestId to look up
    // * @param _timestamp is the timestampt to look up miners for
    // * @return address[5] array of 5 addresses ofminers that mined the requestId
    // */
    // function getSubmissionsByTimestamp(TellorStorage.TellorStorageStruct storage self, uint _requestId, uint _timestamp) internal view returns(uint[5] memory){
    //     return self.requestDetails[_requestId].valuesByTimestamp[_timestamp];
    // }

    // /**
    // * @dev Get the symbol of the token
    // * @return string of the token symbol
    // */
    // function getSymbol(TellorStorage.TellorStorageStruct storage self) internal pure returns(string memory){
    //     return "TT";
    // }


    /**
    * @dev Gets the timestamp for the value based on their index
    * @param _requestID is the requestId to look up
    * @param _index is the value index to look up
    * @return uint timestamp
    */
    function getTimestampbyRequestIDandIndex(TellorStorage.TellorStorageStruct storage self,uint _requestID, uint _index) internal view returns(uint){
        return self.requestDetails[_requestID].requestTimestamps[_index];
    }


    // /**
    // * @dev Getter for the variables saved under the TellorStorageStruct uintVars variable
    // * @param _data the variable to pull from the mapping. _data = keccak256("variable_name") where variable_name is
    // * the variables/strings used to save the data in the mapping. The variables names are
    // * commented out under the uintVars under the TellorStorageStruct struct
    // * This is an example of how data is saved into the mapping within other functions:
    // * self.uintVars[keccak256("stakerCount")]
    // * @return uint of specified variable
    // */
    // function getUintVar(TellorStorage.TellorStorageStruct storage self,bytes32 _data) view internal returns(uint){
    //     return self.uintVars[_data];
    // }



   /**
    * @dev Getter function for next requestId on queue/request with highest payout at time the function is called
    * @return onDeck/info on request with highest payout-- RequestId, Totaltips, and API query string
    */
    function getVariablesOnDeck(TellorStorage.TellorStorageStruct storage self) internal view returns(uint, uint,string memory){
        uint newRequestId = getTopRequestID(self);
        return (newRequestId,self.requestDetails[newRequestId].apiUintVars[keccak256("totalTip")],self.requestDetails[newRequestId].queryString);
    }

    /**
    * @dev Getter function for the request with highest payout. This function is used within the getVariablesOnDeck function
    * @return uint _requestId of request with highest payout at the time the function is called
    */
    function getTopRequestID(TellorStorage.TellorStorageStruct storage self) internal view returns(uint _requestId){
            uint _max;
            uint _index;
            (_max,_index) = Utilities.getMax(self.requestQ);
             _requestId = self.requestIdByRequestQIndex[_index];
    }


    /**
    * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp
    * @param _requestId to look up
    * @param _timestamp is the timestamp to look up miners for
    * @return bool true if requestId/timestamp is under dispute
    */
    function isInDispute(TellorStorage.TellorStorageStruct storage self, uint _requestId, uint _timestamp) internal view returns(bool){
        return self.requestDetails[_requestId].inDispute[_timestamp];
    }


    /**
    * @dev Retreive value from oracle based on requestId/timestamp
    * @param _requestId being requested
    * @param _timestamp to retreive data/value from
    * @return uint value for requestId/timestamp submitted
    */
    function retrieveData(TellorStorage.TellorStorageStruct storage self, uint _requestId, uint _timestamp) internal view returns (uint) {
        return self.requestDetails[_requestId].finalValues[_timestamp];
    }


//     /**
//     * @dev Getter for the total_supply of oracle tokens
//     * @return uint total supply
//     */
//     function totalSupply(TellorStorage.TellorStorageStruct storage self) internal view returns (uint) {
//        return self.uintVars[keccak256("total_supply")];
//     }

}

/**
* @title Tellor Getters
* @dev Oracle contract with all tellor getter functions. The logic for the functions on this contract
* is saved on the TellorGettersLibrary, TellorTransfer, TellorGettersLibrary, and TellorStake
*/
contract TellorGetters{
    using SafeMath for uint256;

    using TellorTransfer for TellorStorage.TellorStorageStruct;
    using TellorGettersLibrary for TellorStorage.TellorStorageStruct;
    //using TellorStake for TellorStorage.TellorStorageStruct;

    TellorStorage.TellorStorageStruct tellor;


    // *
    // * @param _user address
    // * @param _spender address
    // * @return Returns the remaining allowance of tokens granted to the _spender from the _user

    // function allowance(address _user, address _spender) external view returns (uint) {
    //    return tellor.allowance(_user,_spender);
    // }

    /**
    * @dev This function returns whether or not a given user is allowed to trade a given amount
    * @param _user address
    * @param _amount uint of amount
    * @return true if the user is alloed to trade the amount specified
    */
    function allowedToTrade(address _user,uint _amount) external view returns(bool){
        return tellor.allowedToTrade(_user,_amount);
    }

    /**
    * @dev Gets balance of owner specified
    * @param _user is the owner address used to look up the balance
    * @return Returns the balance associated with the passed in _user
    */
    function balanceOf(address _user) external view returns (uint) {
        return tellor.balanceOf(_user);
    }

    /**
    * @dev Queries the balance of _user at a specific _blockNumber
    * @param _user The address from which the balance will be retrieved
    * @param _blockNumber The block number when the balance is queried
    * @return The balance at _blockNumber
    */
    function balanceOfAt(address _user, uint _blockNumber) external view returns (uint) {
        return tellor.balanceOfAt(_user,_blockNumber);
    }

    // /**
    // * @dev This function tells you if a given challenge has been completed by a given miner
    // * @param _challenge the challenge to search for
    // * @param _miner address that you want to know if they solved the challenge
    // * @return true if the _miner address provided solved the
    // */
    // function didMine(bytes32 _challenge, address _miner) external view returns(bool){
    //     return tellor.didMine(_challenge,_miner);
    // }


    // /**
    // * @dev Checks if an address voted in a given dispute
    // * @param _disputeId to look up
    // * @param _address to look up
    // * @return bool of whether or not party voted
    // */
    // function didVote(uint _disputeId, address _address) external view returns(bool){
    //     return tellor.didVote(_disputeId,_address);
    // }


    // /**
    // * @dev allows Tellor to read data from the addressVars mapping
    // * @param _data is the keccak256("variable_name") of the variable that is being accessed.
    // * These are examples of how the variables are saved within other functions:
    // * addressVars[keccak256("_owner")]
    // * addressVars[keccak256("tellorContract")]
    // */
    // function getAddressVars(bytes32 _data) view external returns(address){
    //     return tellor.getAddressVars(_data);
    // }


    // /**
    // * @dev Gets all dispute variables
    // * @param _disputeId to look up
    // * @return bytes32 hash of dispute
    // * @return bool executed where true if it has been voted on
    // * @return bool disputeVotePassed
    // * @return bool isPropFork true if the dispute is a proposed fork
    // * @return address of reportedMiner
    // * @return address of reportingParty
    // * @return address of proposedForkAddress
    // * @return uint of requestId
    // * @return uint of timestamp
    // * @return uint of value
    // * @return uint of minExecutionDate
    // * @return uint of numberOfVotes
    // * @return uint of blocknumber
    // * @return uint of minerSlot
    // * @return uint of quorum
    // * @return uint of fee
    // * @return int count of the current tally
    // */
    // function getAllDisputeVars(uint _disputeId) public view returns(bytes32, bool, bool, bool, address, address, address,uint[9] memory, int){
    //     return tellor.getAllDisputeVars(_disputeId);
    // }


    // /**
    // * @dev Getter function for variables for the requestId being currently mined(currentRequestId)
    // * @return current challenge, curretnRequestId, level of difficulty, api/query string, and granularity(number of decimals requested), total tip for the request
    // */
    // function getCurrentVariables() external view returns(bytes32, uint, uint,string memory,uint,uint){
    //     return tellor.getCurrentVariables();
    // }

    // *
    // * @dev Checks if a given hash of miner,requestId has been disputed
    // * @param _hash is the sha256(abi.encodePacked(_miners[2],_requestId));
    // * @return uint disputeId

    // function getDisputeIdByDisputeHash(bytes32 _hash) external view returns(uint){
    //     return  tellor.getDisputeIdByDisputeHash(_hash);
    // }


    // /**
    // * @dev Checks for uint variables in the disputeUintVars mapping based on the disuputeId
    // * @param _disputeId is the dispute id;
    // * @param _data the variable to pull from the mapping. _data = keccak256("variable_name") where variable_name is
    // * the variables/strings used to save the data in the mapping. The variables names are
    // * commented out under the disputeUintVars under the Dispute struct
    // * @return uint value for the bytes32 data submitted
    // */
    // function getDisputeUintVars(uint _disputeId,bytes32 _data) external view returns(uint){
    //     return tellor.getDisputeUintVars(_disputeId,_data);
    // }


    // /**
    // * @dev Gets the a value for the latest timestamp available
    // * @return value for timestamp of last proof of work submited
    // * @return true if the is a timestamp for the lastNewValue
    // */
    // function getLastNewValue() external view returns(uint,bool){
    //     return tellor.getLastNewValue();
    // }


    // /**
    // * @dev Gets the a value for the latest timestamp available
    // * @param _requestId being requested
    // * @return value for timestamp of last proof of work submited and if true if it exist or 0 and false if it doesn't
    // */
    // function getLastNewValueById(uint _requestId) external view returns(uint,bool){
    //     return tellor.getLastNewValueById(_requestId);
    // }


    // /**
    // * @dev Gets blocknumber for mined timestamp
    // * @param _requestId to look up
    // * @param _timestamp is the timestamp to look up blocknumber
    // * @return uint of the blocknumber which the dispute was mined
    // */
    // function getMinedBlockNum(uint _requestId, uint _timestamp) external view returns(uint){
    //     return tellor.getMinedBlockNum(_requestId,_timestamp);
    // }


    // /**
    // * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp
    // * @param _requestId to look up
    // * @param _timestamp is the timestamp to look up miners for
    // * @return the 5 miners' addresses
    // */
    // function getMinersByRequestIdAndTimestamp(uint _requestId, uint _timestamp) external view returns(address[5] memory){
    //     return tellor.getMinersByRequestIdAndTimestamp(_requestId,_timestamp);
    // }


    // /**
    // * @dev Get the name of the token
    // * return string of the token name
    // */
    // function getName() external view returns(string memory){
    //     return tellor.getName();
    // }


    /**
    * @dev Counts the number of values that have been submited for the request
    * if called for the currentRequest being mined it can tell you how many miners have submitted a value for that
    * request so far
    * @param _requestId the requestId to look up
    * @return uint count of the number of values received for the requestId
    */
    function getNewValueCountbyRequestId(uint _requestId) external view returns(uint){
        return tellor.getNewValueCountbyRequestId(_requestId);
    }


    // /**
    // * @dev Getter function for the specified requestQ index
    // * @param _index to look up in the requestQ array
    // * @return uint of reqeuestId
    // */
    // function getRequestIdByRequestQIndex(uint _index) external view returns(uint){
    //     return tellor.getRequestIdByRequestQIndex(_index);
    // }


    // /**
    // * @dev Getter function for requestId based on timestamp
    // * @param _timestamp to check requestId
    // * @return uint of reqeuestId
    // */
    // function getRequestIdByTimestamp(uint _timestamp) external view returns(uint){
    //     return tellor.getRequestIdByTimestamp(_timestamp);
    // }

    /**
    * @dev Getter function for requestId based on the queryHash
    * @param _request is the hash(of string api and granularity) to check if a request already exists
    * @return uint requestId
    */
    function getRequestIdByQueryHash(bytes32 _request) external view returns(uint){
        return tellor.getRequestIdByQueryHash(_request);
    }


    // /**
    // * @dev Getter function for the requestQ array
    // * @return the requestQ arrray
    // */
    // function getRequestQ() view public returns(uint[51] memory){
    //     return tellor.getRequestQ();
    // }


    // /**
    // * @dev Allowes access to the uint variables saved in the apiUintVars under the requestDetails struct
    // * for the requestId specified
    // * @param _requestId to look up
    // * @param _data the variable to pull from the mapping. _data = keccak256("variable_name") where variable_name is
    // * the variables/strings used to save the data in the mapping. The variables names are
    // * commented out under the apiUintVars under the requestDetails struct
    // * @return uint value of the apiUintVars specified in _data for the requestId specified
    // */
    // function getRequestUintVars(uint _requestId,bytes32 _data) external view returns(uint){
    //     return tellor.getRequestUintVars(_requestId,_data);
    // }


    /**
    * @dev Gets the API struct variables that are not mappings
    * @param _requestId to look up
    * @return string of api to query
    * @return string of symbol of api to query
    * @return bytes32 hash of string
    * @return bytes32 of the granularity(decimal places) requested
    * @return uint of index in requestQ array
    * @return uint of current payout/tip for this requestId
    */
    function getRequestVars(uint _requestId) external view returns(string memory, string memory,bytes32,uint, uint, uint) {
        return tellor.getRequestVars(_requestId);
    }


    // /**
    // * @dev This function allows users to retireve all information about a staker
    // * @param _staker address of staker inquiring about
    // * @return uint current state of staker
    // * @return uint startDate of staking
    // */
    // function getStakerInfo(address _staker) external view returns(uint,uint){
    //     return tellor.getStakerInfo(_staker);
    // }

    // /**
    // * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp
    // * @param _requestId to look up
    // * @param _timestamp is the timestampt to look up miners for
    // * @return address[5] array of 5 addresses ofminers that mined the requestId
    // */
    // function getSubmissionsByTimestamp(uint _requestId, uint _timestamp) external view returns(uint[5] memory){
    //     return tellor.getSubmissionsByTimestamp(_requestId,_timestamp);
    // }

    // /**
    // * @dev Get the symbol of the token
    // * return string of the token symbol
    // */
    // function getSymbol() external view returns(string memory){
    //     return tellor.getSymbol();
    // }

    /**
    * @dev Gets the timestamp for the value based on their index
    * @param _requestID is the requestId to look up
    * @param _index is the value index to look up
    * @return uint timestamp
    */
    function getTimestampbyRequestIDandIndex(uint _requestID, uint _index) external view returns(uint){
        return tellor.getTimestampbyRequestIDandIndex(_requestID,_index);
    }


    // /**
    // * @dev Getter for the variables saved under the TellorStorageStruct uintVars variable
    // * @param _data the variable to pull from the mapping. _data = keccak256("variable_name") where variable_name is
    // * the variables/strings used to save the data in the mapping. The variables names are
    // * commented out under the uintVars under the TellorStorageStruct struct
    // * This is an example of how data is saved into the mapping within other functions:
    // * self.uintVars[keccak256("stakerCount")]
    // * @return uint of specified variable
    // */
    // function getUintVar(bytes32 _data) view public returns(uint){
    //     return tellor.getUintVar(_data);
    // }


    /**
    * @dev Getter function for next requestId on queue/request with highest payout at time the function is called
    * @return onDeck/info on request with highest payout-- RequestId, Totaltips, and API query string
    */
    function getVariablesOnDeck() external view returns(uint, uint,string memory){
        return tellor.getVariablesOnDeck();
    }


    /**
    * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp
    * @param _requestId to look up
    * @param _timestamp is the timestamp to look up miners for
    * @return bool true if requestId/timestamp is under dispute
    */
    function isInDispute(uint _requestId, uint _timestamp) external view returns(bool){
        return tellor.isInDispute(_requestId,_timestamp);
    }


    /**
    * @dev Retreive value from oracle based on timestamp
    * @param _requestId being requested
    * @param _timestamp to retreive data/value from
    * @return value for timestamp submitted
    */
    function retrieveData(uint _requestId, uint _timestamp) external view returns (uint) {
        return tellor.retrieveData(_requestId,_timestamp);
    }


    // *
    // * @dev Getter for the total_supply of oracle tokens
    // * @return uint total supply

    // function totalSupply() external view returns (uint) {
    //    return tellor.totalSupply();
    // }


}

/**** TellorMaster Test Contract***/
/*WARNING: This contract is used for the delegate calls to the Test Tellor contract
           wich excludes mining for testing purposes
           This has bee adapted for projects testing Tellor integration

**/


/**
* @title Tellor Master
* @dev This is the Master contract with all tellor getter functions and delegate call to Tellor.
* The logic for the functions on this contract is saved on the TellorGettersLibrary, TellorTransfer,
* TellorGettersLibrary, and TellorStake
*/
contract TellorMaster is TellorGetters{

    event NewTellorAddress(address _newTellor);

    /**
    * @dev The constructor sets the original `tellorStorageOwner` of the contract to the sender
    * account, the tellor contract to the Tellor master address and owner to the Tellor master owner address
    * @param _tellorContract is the address for the tellor contract
    */
    constructor (address _tellorContract)  public{
        init();
        tellor.addressVars[keccak256("_owner")] = msg.sender;
        tellor.addressVars[keccak256("_deity")] = msg.sender;
        tellor.addressVars[keccak256("tellorContract")]= _tellorContract;
        emit NewTellorAddress(_tellorContract);
    }

    /**
    * @dev This function stakes the five initial miners, sets the supply and all the constant variables.
    * This function is called by the constructor function on TellorMaster.sol
    */
    function init() internal {
        require(tellor.uintVars[keccak256("decimals")] == 0);
        //Give this contract 6000 Tellor Tributes so that it can stake the initial 6 miners
        TellorTransfer.updateBalanceAtNow(tellor.balances[address(this)], 2**256-1 - 6000e18);

        // //the initial 5 miner addresses are specfied below
        // //changed payable[5] to 6
        address payable[6] memory _initalMiners = [address(0xE037EC8EC9ec423826750853899394dE7F024fee),
        address(0xcdd8FA31AF8475574B8909F135d510579a8087d3),
        address(0xb9dD5AfD86547Df817DA2d0Fb89334A6F8eDd891),
        address(0x230570cD052f40E14C14a81038c6f3aa685d712B),
        address(0x3233afA02644CCd048587F8ba6e99b3C00A34DcC),
        address(0xe010aC6e0248790e08F42d5F697160DEDf97E024)];
        //Stake each of the 5 miners specified above
        for(uint i=0;i<6;i++){//6th miner to allow for dispute
            //Miner balance is set at 1000e18 at the block that this function is ran
            TellorTransfer.updateBalanceAtNow(tellor.balances[_initalMiners[i]],1000e18);

            //newStake(self, _initalMiners[i]);
        }

        //update the total suppply
        tellor.uintVars[keccak256("total_supply")] += 6000e18;//6th miner to allow for dispute
        //set Constants
        tellor.uintVars[keccak256("decimals")] = 18;
        tellor.uintVars[keccak256("targetMiners")] = 200;
        tellor.uintVars[keccak256("stakeAmount")] = 1000e18;
        tellor.uintVars[keccak256("disputeFee")] = 970e18;
        tellor.uintVars[keccak256("timeTarget")]= 600;
        tellor.uintVars[keccak256("timeOfLastNewValue")] = now - now  % tellor.uintVars[keccak256("timeTarget")];
        tellor.uintVars[keccak256("difficulty")] = 1;
    }

    /**
    * @dev Gets the 5 miners who mined the value for the specified requestId/_timestamp
    * @dev Only needs to be in library
    * @param _newDeity the new Deity in the contract
    */

    function changeDeity(address _newDeity) external{
        tellor.changeDeity(_newDeity);
    }


    /**
    * @dev  allows for the deity to make fast upgrades.  Deity should be 0 address if decentralized
    * @param _tellorContract the address of the new Tellor Contract
    */
    function changeTellorContract(address _tellorContract) external{
        tellor.changeTellorContract(_tellorContract);
    }


    /**
    * @dev This is the fallback function that allows contracts to call the tellor contract at the address stored
    */
    function () external payable {
        address addr = tellor.addressVars[keccak256("tellorContract")];
        bytes memory _calldata = msg.data;
        assembly {
            let result := delegatecall(not(0), addr, add(_calldata, 0x20), mload(_calldata), 0, 0)
            let size := returndatasize
            let ptr := mload(0x40)
            returndatacopy(ptr, 0, size)
            // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
            // if the call returned error data, forward it
            switch result case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }
}

/*
 * @title Price/numeric Pull Oracle mapping contract
*/

contract OracleIDDescriptions {

    /*Variables*/
    mapping(uint=>bytes32) tellorIDtoBytesID;
    mapping(bytes32 => uint) bytesIDtoTellorID;
    mapping(uint => uint) tellorCodeToStatusCode;
    mapping(uint => uint) statusCodeToTellorCode;
    mapping(uint => int) tellorIdtoAdjFactor;

    /*Events*/
    event TellorIdMappedToBytes(uint _requestID, bytes32 _id);
    event StatusMapped(uint _tellorStatus, uint _status);
    event AdjFactorMapped(uint _requestID, int _adjFactor);


    /**
    * @dev This function allows the user to map the tellor's Id to it's _adjFactor and
    * to match the standarized granularity
    * @param _tellorId uint the tellor status
    * @param _adjFactor is 1eN where N is the number of decimals to convert to ADO standard
    */
    function defineTellorIdtoAdjFactor(uint _tellorId, int _adjFactor) external{
        require(tellorIdtoAdjFactor[_tellorId] == 0, "Already Set");
        tellorIdtoAdjFactor[_tellorId] = _adjFactor;
        emit AdjFactorMapped(_tellorId, _adjFactor);
    }

    /**
    * @dev This function allows the user to map the tellor uint data status code to the standarized
    * ADO uint status code such as null, retreived etc...
    * @param _tellorStatus uint the tellor status
    * @param _status the ADO standarized uint status
    */
    function defineTellorCodeToStatusCode(uint _tellorStatus, uint _status) external{
        require(tellorCodeToStatusCode[_tellorStatus] == 0, "Already Set");
        tellorCodeToStatusCode[_tellorStatus] = _status;
        statusCodeToTellorCode[_status] = _tellorStatus;
        emit StatusMapped(_tellorStatus, _status);
    }

    /**
    * @dev Allows user to map the standarized bytes32 Id to a specific requestID from Tellor
    * The dev should ensure the _requestId exists otherwise request the data on Tellor to get a requestId
    * @param _requestID is the existing Tellor RequestID
    * @param _id is the descption of the ID in bytes
    */
    function defineTellorIdToBytesID(uint _requestID, bytes32 _id) external{
        require(tellorIDtoBytesID[_requestID] == bytes32(0), "Already Set");
        tellorIDtoBytesID[_requestID] = _id;
        bytesIDtoTellorID[_id] = _requestID;
        emit TellorIdMappedToBytes(_requestID,_id);
    }

    /**
    * @dev Getter function for the uint Tellor status code from the specified uint ADO standarized status code
    * @param _status the uint ADO standarized status
    * @return _tellorStatus uint
    */
    function getTellorStatusFromStatus(uint _status) public view returns(uint _tellorStatus){
        return statusCodeToTellorCode[_status];
    }

    /**
    * @dev Getter function of the uint ADO standarized status code from the specified Tellor uint status
    * @param _tellorStatus uint
    * @return _status the uint ADO standarized status
    */
    function getStatusFromTellorStatus (uint _tellorStatus) public view returns(uint _status) {
        return tellorCodeToStatusCode[_tellorStatus];
    }

    /**
    * @dev Getter function of the Tellor RequestID based on the specified bytes32 ADO standaraized _id
    * @param _id is the bytes32 descriptor mapped to an existing Tellor's requestId
    * @return _requestId is Tellor's requestID corresnpoding to _id
    */
    function getTellorIdFromBytes(bytes32 _id) public view  returns(uint _requestId)  {
       return bytesIDtoTellorID[_id];
    }

    /**
    * @dev Getter function of the Tellor RequestID based on the specified bytes32 ADO standaraized _id
    * @param _id is the bytes32 descriptor mapped to an existing Tellor's requestId
    * @return _requestId is Tellor's requestID corresnpoding to _id
    */
    function getGranularityAdjFactor(bytes32 _id) public view  returns(int adjFactor)  {
       uint requestID = bytesIDtoTellorID[_id];
       adjFactor = tellorIdtoAdjFactor[requestID];
       return adjFactor;
    }

    /**
    * @dev Getter function of the bytes32 ADO standaraized _id based on the specified Tellor RequestID
    * @param _requestId is Tellor's requestID
    * @return _id is the bytes32 descriptor mapped to an existing Tellor's requestId
    */
    function getBytesFromTellorID(uint _requestId) public view returns(bytes32 _id) {
        return tellorIDtoBytesID[_requestId];
    }

}
pragma solidity >=0.5.0 <0.7.0;

/**
    * @dev EIP2362 Interface for pull oracles
    * https://github.com/tellor-io/EIP-2362
*/
interface EIP2362Interface{
    /**
        * @dev Exposed function pertaining to EIP standards
        * @param _id bytes32 ID of the query
        * @return int,uint,uint returns the value, timestamp, and status code of query
    */
    function valueFor(bytes32 _id) external view returns(int256,uint256,uint256);
}


/**
* @title UserContract
* This contracts creates for easy integration to the Tellor System
* by allowing smart contracts to read data off Tellor
*/
contract UsingTellor is EIP2362Interface{
    address payable public tellorStorageAddress;
    address public oracleIDDescriptionsAddress;
    TellorMaster _tellorm;
    OracleIDDescriptions descriptions;

    event NewDescriptorSet(address _descriptorSet);

    /*Constructor*/
    /**
    * @dev the constructor sets the storage address and owner
    * @param _storage is the TellorMaster address
    */
    constructor(address payable _storage) public {
        tellorStorageAddress = _storage;
        _tellorm = TellorMaster(tellorStorageAddress);
    }

    /*Functions*/
    /*
    * @dev Allows the owner to set the address for the oracleID descriptors
    * used by the ADO members for price key value pairs standarization
    * _oracleDescriptors is the address for the OracleIDDescriptions contract
    */
    function setOracleIDDescriptors(address _oracleDescriptors) external {
        require(oracleIDDescriptionsAddress == address(0), "Already Set");
        oracleIDDescriptionsAddress = _oracleDescriptors;
        descriptions = OracleIDDescriptions(_oracleDescriptors);
        emit NewDescriptorSet(_oracleDescriptors);
    }

    /**
    * @dev Allows the user to get the latest value for the requestId specified
    * @param _requestId is the requestId to look up the value for
    * @return bool true if it is able to retreive a value, the value, and the value's timestamp
    */
    function getCurrentValue(uint256 _requestId) public view returns (bool ifRetrieve, uint256 value, uint256 _timestampRetrieved) {
        return getDataBefore(_requestId,now,1,0);
    }

    /**
    * @dev Allows the user to get the latest value for the requestId specified using the
    * ADO specification for the standard inteface for price oracles
    * @param _bytesId is the ADO standarized bytes32 price/key value pair identifier
    * @return the timestamp, outcome or value/ and the status code (for retreived, null, etc...)
    */
    function valueFor(bytes32 _bytesId) external view returns (int value, uint256 timestamp, uint status) {
        uint _id = descriptions.getTellorIdFromBytes(_bytesId);
        int n = descriptions.getGranularityAdjFactor(_bytesId);
        if (_id > 0){
            bool _didGet;
            uint256 _returnedValue;
            uint256 _timestampRetrieved;
            (_didGet,_returnedValue,_timestampRetrieved) = getDataBefore(_id,now,1,0);
            if(_didGet){
                return (int(_returnedValue)*n,_timestampRetrieved, descriptions.getStatusFromTellorStatus(1));
            }
            else{
                return (0,0,descriptions.getStatusFromTellorStatus(2));
            }
        }
        return (0, 0, descriptions.getStatusFromTellorStatus(0));
    }

    /**
    * @dev Allows the user to get the first value for the requestId before the specified timestamp
    * @param _requestId is the requestId to look up the value for
    * @param _timestamp before which to search for first verified value
    * @param _limit a limit on the number of values to look at
    * @param _offset the number of values to go back before looking for data values
    * @return bool true if it is able to retreive a value, the value, and the value's timestamp
    */
    function getDataBefore(uint256 _requestId, uint256 _timestamp, uint256 _limit, uint256 _offset)
        public
        view
        returns (bool _ifRetrieve, uint256 _value, uint256 _timestampRetrieved)
    {
        uint256 _count = _tellorm.getNewValueCountbyRequestId(_requestId) - _offset;
        if (_count > 0) {
            for (uint256 i = _count; i > _count - _limit; i--) {
                uint256 _time = _tellorm.getTimestampbyRequestIDandIndex(_requestId, i - 1);
                if (_time > 0 && _time <= _timestamp && _tellorm.isInDispute(_requestId,_time) == false) {
                    return (true, _tellorm.retrieveData(_requestId, _time), _time);
                }
            }
        }
        return (false, 0, 0);
    }
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}



contract BankStorage{
  /*Variables*/
  struct Reserve {
    uint256 collateralBalance;
    uint256 debtBalance;
    uint256 interestRate;
    uint256 originationFee;
    uint256 collateralizationRatio;
    uint256 liquidationPenalty;
    address oracleContract;
    uint256 period;
  }

  struct Token {
    address tokenAddress;
    uint256 price;
    uint256 priceGranularity;
    uint256 tellorRequestId;
    uint256 reserveBalance;
  }

  struct Vault {
    uint256 collateralAmount;
    uint256 debtAmount;
    uint256 createdAt;
  }

  mapping (address => Vault) public vaults;
  Token debt;
  Token collateral;
  Reserve reserve;


  /**
  * @dev Getter function for the current interest rate
  * @return interest rate
  */
  function getInterestRate() public view returns (uint256) {
    return reserve.interestRate;
  }

  /**
  * @dev Getter function for the origination fee
  * @return origination fee
  */
  function getOriginationFee() public view returns (uint256) {
    return reserve.originationFee;
  }

  /**
  * @dev Getter function for the current collateralization ratio
  * @return collateralization ratio
  */
  function getCollateralizationRatio() public view returns (uint256) {
    return reserve.collateralizationRatio;
  }

  /**
  * @dev Getter function for the liquidation penalty
  * @return liquidation penalty
  */
  function getLiquidationPenalty() public view returns (uint256) {
    return reserve.liquidationPenalty;
  }

  /**
  * @dev Getter function for debt token address
  * @return debt token price
  */
  function getDebtTokenAddress() public view returns (address) {
    return debt.tokenAddress;
  }

  /**
  * @dev Getter function for the debt token(reserve) price
  * @return debt token price
  */
  function getDebtTokenPrice() public view returns (uint256) {
    return debt.price;
  }

  /**
  * @dev Getter function for the debt token price granularity
  * @return debt token price granularity
  */
  function getDebtTokenPriceGranularity() public view returns (uint256) {
    return debt.priceGranularity;
  }

  /**
  * @dev Getter function for debt token address
  * @return debt token price
  */
  function getCollateralTokenAddress() public view returns (address) {
    return collateral.tokenAddress;
  }

  /**
  * @dev Getter function for the collateral token price
  * @return collateral token price
  */
  function getCollateralTokenPrice() public view returns (uint256) {
    return collateral.price;
  }

  /**
  * @dev Getter function for the collateral token price granularity
  * @return collateral token price granularity
  */
  function getCollateralTokenPriceGranularity() public view returns (uint256) {
    return collateral.priceGranularity;
  }

  /**
  * @dev Getter function for the debt token(reserve) balance
  * @return debt reserve balance
  */
  function getReserveBalance() public view returns (uint256) {
    return reserve.debtBalance;
  }

  /**
  * @dev Getter function for the debt reserve collateral balance
  * @return collateral reserve balance
  */
  function getReserveCollateralBalance() public view returns (uint256) {
    return reserve.collateralBalance;
  }

  /**
  * @dev Getter function for the user's vault collateral amount
  * @return collateral amount
  */
  function getVaultCollateralAmount() public view returns (uint256) {
    return vaults[msg.sender].collateralAmount;
  }

  /**
  * @dev Getter function for the user's vault debt amount
  * @return debt amount
  */
  function getVaultDebtAmount() public view returns (uint256) {
    return vaults[msg.sender].debtAmount;
  }

  /**
  * @dev Getter function for the user's vault debt amount
  *   uses a simple interest formula (i.e. not compound  interest)
  * @return debt amount
  */
  function getVaultRepayAmount() public view returns (uint256 principal) {
    principal = vaults[msg.sender].debtAmount;
    uint256 periodsPerYear = 365 days / reserve.period;
    uint256 periodsElapsed = (block.timestamp / reserve.period) - (vaults[msg.sender].createdAt / reserve.period);
    principal += principal * reserve.interestRate / 100 / periodsPerYear * periodsElapsed;
  }

  /**
  * @dev Getter function for the collateralization ratio
  * @return collateralization ratio
  */
  function getVaultCollateralizationRatio(address vaultOwner) public view returns (uint256) {
    if(vaults[vaultOwner].debtAmount == 0 ){
      return 0;
    } else {
      return _percent(vaults[vaultOwner].collateralAmount * collateral.price * 1000 / collateral.priceGranularity,
                      vaults[vaultOwner].debtAmount * debt.price * 1000 / debt.priceGranularity,
                      4);
    }
  }

  /**
  * @dev This function calculates the percent of the given numerator, denominator to the
  * specified precision
  * @return _quotient
  */
  function _percent(uint numerator, uint denominator, uint precision) private pure returns(uint256 _quotient) {
        _quotient =  ((numerator * 10 ** (precision+1) / denominator) + 5) / 10;
  }


}


/**
* @title Bank
* This contract allows the owner to deposit reserves(debt token), earn interest and
* origination fees from users that borrow against their collateral.
* The oracle for Bank is Tellor.
*/
contract Bank is BankStorage, Ownable, UsingTellor {
  /*Events*/
  event ReserveDeposit(uint256 amount);
  event ReserveWithdraw(address token, uint256 amount);
  event VaultDeposit(address owner, uint256 amount);
  event VaultBorrow(address borrower, uint256 amount);
  event VaultRepay(address borrower, uint256 amount);
  event VaultWithdraw(address borrower, uint256 amount);
  event PriceUpdate(address token, uint256 price);
  event Liquidation(address borrower, uint256 debtAmount);

  /*Constructor*/
  constructor(
    uint256 interestRate,
    uint256 originationFee,
    uint256 collateralizationRatio,
    uint256 liquidationPenalty,
    uint256 period,
    address collateralToken,
    uint256 collateralTokenTellorRequestId,
    uint256 collateralTokenPriceGranularity,
    uint256 collateralTokenPrice,
    address debtToken,
    uint256 debtTokenTellorRequestId,
    uint256 debtTokenPriceGranularity,
    uint256 debtTokenPrice,
    address payable oracleContract ) public UsingTellor(oracleContract) {
    reserve.interestRate = interestRate;
    reserve.originationFee = originationFee;
    reserve.collateralizationRatio = collateralizationRatio;
    reserve.liquidationPenalty = liquidationPenalty;
    reserve.period = period;
    debt.tokenAddress = debtToken;
    debt.price = debtTokenPrice;
    debt.priceGranularity = debtTokenPriceGranularity;
    debt.tellorRequestId = debtTokenTellorRequestId;
    collateral.tokenAddress = collateralToken;
    collateral.price = collateralTokenPrice;
    collateral.priceGranularity = collateralTokenPriceGranularity;
    collateral.tellorRequestId = collateralTokenTellorRequestId;
    reserve.oracleContract = oracleContract;
  }

  /*Functions*/
  /**
  * @dev This function allows the Bank owner to deposit the reserve (debt tokens)
  * @param amount is the amount to deposit
  */
  function reserveDeposit(uint256 amount) external onlyOwner {
    require(IERC20(debt.tokenAddress).transferFrom(msg.sender, address(this), amount));
    reserve.debtBalance += amount;
    emit ReserveDeposit(amount);
  }

  /**
  * @dev This function allows the Bank owner to withdraw the reserve (debt tokens)
  * @param amount is the amount to withdraw
  */
  function reserveWithdraw(uint256 amount) external onlyOwner {
    require(reserve.debtBalance >= amount, "NOT ENOUGH DEBT TOKENS IN RESERVE");
    require(IERC20(debt.tokenAddress).transfer(msg.sender, amount));
    reserve.debtBalance -= amount;
    emit ReserveWithdraw(debt.tokenAddress, amount);
  }

  /**
  * @dev This function allows the user to withdraw their collateral
  * @param amount is the amount to withdraw
  */
  function reserveWithdrawCollateral(uint256 amount) external onlyOwner {
    require(reserve.collateralBalance >= amount, "NOT ENOUGH COLLATERAL IN RESERVE");
    require(IERC20(collateral.tokenAddress).transfer(msg.sender, amount));
    reserve.collateralBalance -= amount;
    emit ReserveWithdraw(collateral.tokenAddress, amount);
  }

  /**
  * @dev Use this function to get and update the price for the collateral token
  * using the Tellor Oracle.
  */
  function updateCollateralPrice() external {
    bool ifRetrieve;
    uint256 _timestampRetrieved;
    (ifRetrieve, collateral.price, _timestampRetrieved) = getCurrentValue(collateral.tellorRequestId); //,now - 1 hours);
    emit PriceUpdate(collateral.tokenAddress, collateral.price);
  }

  /**
  * @dev Use this function to get and update the price for the debt token
  * using the Tellor Oracle.
  */
  function updateDebtPrice() external {
    bool ifRetrieve;
    uint256 _timestampRetrieved;
    (ifRetrieve, debt.price, _timestampRetrieved) = getCurrentValue(debt.tellorRequestId); //,now - 1 hours);
    emit PriceUpdate(debt.tokenAddress, debt.price);
  }

  /**
  * @dev Anyone can use this function to liquidate a vault's debt,
  * the bank owner gets the collateral liquidated
  * @param vaultOwner is the user the bank owner wants to liquidate
  */
  function liquidate(address vaultOwner) external {
    // Require undercollateralization
    require(getVaultCollateralizationRatio(vaultOwner) < reserve.collateralizationRatio * 100, "VAULT NOT UNDERCOLLATERALIZED");
    uint256 debtOwned = vaults[vaultOwner].debtAmount + (vaults[vaultOwner].debtAmount * 100 * reserve.liquidationPenalty / 100 / 100);
    uint256 collateralToLiquidate = debtOwned * debt.price / collateral.price;

    if(collateralToLiquidate <= vaults[vaultOwner].collateralAmount) {
      reserve.collateralBalance +=  collateralToLiquidate;
      vaults[vaultOwner].collateralAmount -= collateralToLiquidate;
    } else {
      reserve.collateralBalance +=  vaults[vaultOwner].collateralAmount;
      vaults[vaultOwner].collateralAmount = 0;
    }
    reserve.debtBalance += vaults[vaultOwner].debtAmount;
    vaults[vaultOwner].debtAmount = 0;
    emit Liquidation(vaultOwner, debtOwned);
  }


  /**
  * @dev Use this function to allow users to deposit collateral to the vault
  * @param amount is the collateral amount
  */
  function vaultDeposit(uint256 amount) external {
    require(IERC20(collateral.tokenAddress).transferFrom(msg.sender, address(this), amount));
    vaults[msg.sender].collateralAmount += amount;
    emit VaultDeposit(msg.sender, amount);
  }

  /**
  * @dev Use this function to allow users to borrow against their collateral
  * @param amount to borrow
  */
  function vaultBorrow(uint256 amount) external {
    if (vaults[msg.sender].debtAmount != 0) {
      vaults[msg.sender].debtAmount = getVaultRepayAmount();
    }
    uint256 maxBorrow = vaults[msg.sender].collateralAmount * collateral.price / debt.price / reserve.collateralizationRatio * 100;
    maxBorrow *= debt.priceGranularity;
    maxBorrow /= collateral.priceGranularity;
    maxBorrow -= vaults[msg.sender].debtAmount;
    require(amount < maxBorrow, "NOT ENOUGH COLLATERAL");
    require(amount <= reserve.debtBalance, "NOT ENOUGH RESERVES");
    vaults[msg.sender].debtAmount += amount + ((amount * reserve.originationFee) / 100);
    if (block.timestamp - vaults[msg.sender].createdAt > reserve.period) {
      // Only adjust if more than 1 interest rate period has past
      vaults[msg.sender].createdAt = block.timestamp;
    }
    reserve.debtBalance -= amount;
    require(IERC20(debt.tokenAddress).transfer(msg.sender, amount));
    emit VaultBorrow(msg.sender, amount);
  }

  /**
  * @dev This function allows users to pay the interest and origination fee to the
  *  vault before being able to withdraw
  * @param amount owed
  */
  function vaultRepay(uint256 amount) external {
    vaults[msg.sender].debtAmount = getVaultRepayAmount();
    require(amount <= vaults[msg.sender].debtAmount, "CANNOT REPAY MORE THAN OWED");
    require(IERC20(debt.tokenAddress).transferFrom(msg.sender, address(this), amount));
    vaults[msg.sender].debtAmount -= amount;
    reserve.debtBalance += amount;
    uint256 periodsElapsed = (block.timestamp / reserve.period) - (vaults[msg.sender].createdAt / reserve.period);
    vaults[msg.sender].createdAt += periodsElapsed * reserve.period;
    emit VaultRepay(msg.sender, amount);
  }

  /**
  * @dev Allows users to withdraw their collateral from the vault
  */
  function vaultWithdraw(uint256 amount) external {
    uint256 maxBorrowAfterWithdraw = (vaults[msg.sender].collateralAmount - amount) * collateral.price / debt.price / reserve.collateralizationRatio * 100;
    maxBorrowAfterWithdraw *= debt.priceGranularity;
    maxBorrowAfterWithdraw /= collateral.priceGranularity;
    require(vaults[msg.sender].debtAmount <= maxBorrowAfterWithdraw, "CANNOT UNDERCOLLATERALIZE VAULT");
    require(IERC20(collateral.tokenAddress).transfer(msg.sender, amount));
    vaults[msg.sender].collateralAmount -= amount;
    reserve.collateralBalance -= amount;
    emit VaultWithdraw(msg.sender, amount);
  }

  /**
  * @dev Allows the user to get the first value for the requestId after the specified timestamp
  * @param _requestId is the requestId to look up the value for
  * @param _timestamp after which to search for first verified value
  * @return bool true if it is able to retreive a value, the value, and the value's timestamp
  */
  function getDataBefore(uint256 _requestId, uint256 _timestamp)
      public
      view
      returns (bool _ifRetrieve, uint256 _value, uint256 _timestampRetrieved)
  {
      uint256 _count = _tellorm.getNewValueCountbyRequestId(_requestId);
      if (_count > 0) {
          for (uint256 i = 1; i <= _count; i++) {
              uint256 _time = _tellorm.getTimestampbyRequestIDandIndex(_requestId, i - 1);
              if (_time <= _timestamp && _tellorm.isInDispute(_requestId,_time) == false) {
                  _timestampRetrieved = _time;
              }
          }
          if (_timestampRetrieved > 0) {
              return (true, _tellorm.retrieveData(_requestId, _timestampRetrieved), _timestampRetrieved);
          }
      }
      return (false, 0, 0);
  }

}