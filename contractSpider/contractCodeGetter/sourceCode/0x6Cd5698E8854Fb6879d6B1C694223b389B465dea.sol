/**
 *Submitted for verification at Etherscan.io on 2020-07-28
*/

pragma solidity 0.6.0;

/**
 * @title Voting factory + mapping
 * @dev Vote creating method
 */
contract Nest_3_VoteFactory {
    using SafeMath for uint256;
    
    uint256 _limitTime = 7 days;                                    //  Vote duration
    uint256 _NNLimitTime = 1 days;                                  //  NestNode raising time
    uint256 _circulationProportion = 51;                            //  Proportion of votes to pass
    uint256 _NNUsedCreate = 10;                                     //  The minimum number of NNs to create a voting contract
    uint256 _NNCreateLimit = 100;                                   //  The minimum number of NNs needed to start voting
    uint256 _emergencyTime = 0;                                     //  The emergency state start time
    uint256 _emergencyTimeLimit = 3 days;                           //  The emergency state duration
    uint256 _emergencyNNAmount = 1000;                              //  The number of NNs required to switch the emergency state
    ERC20 _NNToken;                                                 //  NestNode Token
    ERC20 _nestToken;                                               //  NestToken
    mapping(string => address) _contractAddress;                    //  Voting contract mapping
    mapping(address => bool) _modifyAuthority;                      //  Modify permissions
    mapping(address => address) _myVote;                            //  Personal voting address
    mapping(address => uint256) _emergencyPerson;                   //  Emergency state personal voting number
    mapping(address => bool) _contractData;                         //  Voting contract data
    bool _stateOfEmergency = false;                                 //  Emergency state
    address _destructionAddress;                                    //  Destroy contract address

    event ContractAddress(address contractAddress);
    
    /**
    * @dev Initialization method
    */
    constructor () public {
        _modifyAuthority[address(msg.sender)] = true;
    }
    
    /**
    * @dev Reset contract
    */
    function changeMapping() public onlyOwner {
        _NNToken = ERC20(checkAddress("nestNode"));
        _destructionAddress = address(checkAddress("nest.v3.destruction"));
        _nestToken = ERC20(address(checkAddress("nest")));
    }
    
    /**
    * @dev Create voting contract
    * @param implementContract The executable contract address for voting
    * @param nestNodeAmount Number of NNs to pledge
    */
    function createVote(address implementContract, uint256 nestNodeAmount) public {
        require(address(tx.origin) == address(msg.sender), "It can't be a contract");
        require(nestNodeAmount >= _NNUsedCreate);
        Nest_3_VoteContract newContract = new Nest_3_VoteContract(implementContract, _stateOfEmergency, nestNodeAmount);
        require(_NNToken.transferFrom(address(tx.origin), address(newContract), nestNodeAmount), "Authorization transfer failed");
        _contractData[address(newContract)] = true;
        emit ContractAddress(address(newContract));
    }
    
    /**
    * @dev Use NEST to vote
    * @param contractAddress Vote contract address
    */
    function nestVote(address contractAddress) public {
        require(address(msg.sender) == address(tx.origin), "It can't be a contract");
        require(_contractData[contractAddress], "It's not a voting contract");
        require(!checkVoteNow(address(msg.sender)));
        Nest_3_VoteContract newContract = Nest_3_VoteContract(contractAddress);
        newContract.nestVote();
        _myVote[address(tx.origin)] = contractAddress;
    }
    
    /**
    * @dev Vote using NestNode Token
    * @param contractAddress Vote contract address
    * @param NNAmount Amount of NNs to pledge
    */
    function nestNodeVote(address contractAddress, uint256 NNAmount) public {
        require(address(msg.sender) == address(tx.origin), "It can't be a contract");
        require(_contractData[contractAddress], "It's not a voting contract");
        Nest_3_VoteContract newContract = Nest_3_VoteContract(contractAddress);
        require(_NNToken.transferFrom(address(tx.origin), address(newContract), NNAmount), "Authorization transfer failed");
        newContract.nestNodeVote(NNAmount);
    }
    
    /**
    * @dev Excecute contract
    * @param contractAddress Vote contract address
    */
    function startChange(address contractAddress) public {
        require(address(msg.sender) == address(tx.origin), "It can't be a contract");
        require(_contractData[contractAddress], "It's not a voting contract");
        Nest_3_VoteContract newContract = Nest_3_VoteContract(contractAddress);
        require(_stateOfEmergency == newContract.checkStateOfEmergency());
        addSuperManPrivate(address(newContract));
        newContract.startChange();
        deleteSuperManPrivate(address(newContract));
    }
    
    /**
    * @dev Switch emergency state-transfer in NestNode Token
    * @param amount Amount of NNs to transfer
    */
    function sendNestNodeForStateOfEmergency(uint256 amount) public {
        require(_NNToken.transferFrom(address(tx.origin), address(this), amount));
        _emergencyPerson[address(tx.origin)] = _emergencyPerson[address(tx.origin)].add(amount);
    }
    
    /**
    * @dev Switch emergency state-transfer out NestNode Token
    */
    function turnOutNestNodeForStateOfEmergency() public {
        require(_emergencyPerson[address(tx.origin)] > 0);
        require(_NNToken.transfer(address(tx.origin), _emergencyPerson[address(tx.origin)]));
        _emergencyPerson[address(tx.origin)] = 0;
        uint256 nestAmount = _nestToken.balanceOf(address(this));
        require(_nestToken.transfer(address(_destructionAddress), nestAmount));
    }
    
    /**
    * @dev Modify emergency state
    */
    function changeStateOfEmergency() public {
        if (_stateOfEmergency) {
            require(now > _emergencyTime.add(_emergencyTimeLimit));
            _stateOfEmergency = false;
            _emergencyTime = 0;
        } else {
            require(_emergencyPerson[address(msg.sender)] > 0);
            require(_NNToken.balanceOf(address(this)) >= _emergencyNNAmount);
            _stateOfEmergency = true;
            _emergencyTime = now;
        }
    }
    
    /**
    * @dev Check whether participating in the voting
    * @param user Address to check
    * @return bool Whether voting
    */
    function checkVoteNow(address user) public view returns (bool) {
        if (_myVote[user] == address(0x0)) {
            return false;
        } else {
            Nest_3_VoteContract vote = Nest_3_VoteContract(_myVote[user]);
            if (vote.checkContractEffective() || vote.checkPersonalAmount(user) == 0) {
                return false;
            }
            return true;
        }
    }
    
    /**
    * @dev Check my voting
    * @param user Address to check
    * @return address Address recently participated in the voting contract address
    */
    function checkMyVote(address user) public view returns (address) {
        return _myVote[user];
    }
    
    //  Check the voting time
    function checkLimitTime() public view returns (uint256) {
        return _limitTime;
    }
    
    //  Check the NestNode raising time
    function checkNNLimitTime() public view returns (uint256) {
        return _NNLimitTime;
    }
    
    //  Check the voting proportion to pass
    function checkCirculationProportion() public view returns (uint256) {
        return _circulationProportion;
    }
    
    //  Check the minimum number of NNs to create a voting contract
    function checkNNUsedCreate() public view returns (uint256) {
        return _NNUsedCreate;
    }
    
    //  Check the minimum number of NNs raised to start a vote
    function checkNNCreateLimit() public view returns (uint256) {
        return _NNCreateLimit;
    }
    
    //  Check whether in emergency state
    function checkStateOfEmergency() public view returns (bool) {
        return _stateOfEmergency;
    }
    
    //  Check the start time of the emergency state
    function checkEmergencyTime() public view returns (uint256) {
        return _emergencyTime;
    }
    
    //  Check the duration of the emergency state
    function checkEmergencyTimeLimit() public view returns (uint256) {
        return _emergencyTimeLimit;
    }
    
    //  Check the amount of personal pledged NNs
    function checkEmergencyPerson(address user) public view returns (uint256) {
        return _emergencyPerson[user];
    }
    
    //  Check the number of NNs required for the emergency
    function checkEmergencyNNAmount() public view returns (uint256) {
        return _emergencyNNAmount;
    }
    
    //  Verify voting contract data
    function checkContractData(address contractAddress) public view returns (bool) {
        return _contractData[contractAddress];
    }
    
    //  Modify voting time
    function changeLimitTime(uint256 num) public onlyOwner {
        require(num > 0, "Parameter needs to be greater than 0");
        _limitTime = num;
    }
    
    //  Modify the NestNode raising time
    function changeNNLimitTime(uint256 num) public onlyOwner {
        require(num > 0, "Parameter needs to be greater than 0");
        _NNLimitTime = num;
    }
    
    //  Modify the voting proportion
    function changeCirculationProportion(uint256 num) public onlyOwner {
        require(num > 0, "Parameter needs to be greater than 0");
        _circulationProportion = num;
    }
    
    //  Modify the minimum number of NNs to create a voting contract
    function changeNNUsedCreate(uint256 num) public onlyOwner {
        _NNUsedCreate = num;
    }
    
    //  Modify the minimum number of NNs to raised to start a voting
    function checkNNCreateLimit(uint256 num) public onlyOwner {
        _NNCreateLimit = num;
    }
    
    //  Modify the emergency state duration
    function changeEmergencyTimeLimit(uint256 num) public onlyOwner {
        require(num > 0);
        _emergencyTimeLimit = num.mul(1 days);
    }
    
    //  Modify the number of NNs required for emergency state
    function changeEmergencyNNAmount(uint256 num) public onlyOwner {
        require(num > 0);
        _emergencyNNAmount = num;
    }
    
    //  Check address
    function checkAddress(string memory name) public view returns (address contractAddress) {
        return _contractAddress[name];
    }
    
    //  Add contract mapping address
    function addContractAddress(string memory name, address contractAddress) public onlyOwner {
        _contractAddress[name] = contractAddress;
    }
    
    //  Add administrator address 
    function addSuperMan(address superMan) public onlyOwner {
        _modifyAuthority[superMan] = true;
    }
    function addSuperManPrivate(address superMan) private {
        _modifyAuthority[superMan] = true;
    }
    
    //  Delete administrator address
    function deleteSuperMan(address superMan) public onlyOwner {
        _modifyAuthority[superMan] = false;
    }
    function deleteSuperManPrivate(address superMan) private {
        _modifyAuthority[superMan] = false;
    }
    
    //  Delete voting contract data
    function deleteContractData(address contractAddress) public onlyOwner {
        _contractData[contractAddress] = false;
    }
    
    //  Check whether the administrator
    function checkOwners(address man) public view returns (bool) {
        return _modifyAuthority[man];
    }
    
    //  Administrator only
    modifier onlyOwner() {
        require(checkOwners(msg.sender), "No authority");
        _;
    }
}

/**
 * @title Voting contract
 */
contract Nest_3_VoteContract {
    using SafeMath for uint256;
    
    Nest_3_Implement _implementContract;                //  Executable contract
    Nest_3_TokenSave _tokenSave;                        //  Lock-up contract
    Nest_3_VoteFactory _voteFactory;                    //  Voting factory contract
    Nest_3_TokenAbonus _tokenAbonus;                    //  Bonus logic contract
    ERC20 _nestToken;                                   //  NestToken
    ERC20 _NNToken;                                     //  NestNode Token
    address _miningSave;                                //  Mining pool contract
    address _implementAddress;                          //  Executable contract address
    address _destructionAddress;                        //  Destruction contract address
    uint256 _createTime;                                //  Creation time
    uint256 _endTime;                                   //  End time
    uint256 _totalAmount;                               //  Total votes
    uint256 _circulation;                               //  Passed votes
    uint256 _destroyedNest;                             //  Destroyed NEST
    uint256 _NNLimitTime;                               //  NestNode raising time
    uint256 _NNCreateLimit;                             //  Minimum number of NNs to create votes
    uint256 _abonusTimes;                               //  Period number of used snapshot in emergency state
    uint256 _allNNAmount;                               //  Total number of NNs
    bool _effective = false;                            //  Whether vote is effective
    bool _nestVote = false;                             //  Whether NEST vote can be performed
    bool _isChange = false;                             //  Whether NEST vote is executed
    bool _stateOfEmergency;                             //  Whether the contract is in emergency state
    mapping(address => uint256) _personalAmount;        //  Number of personal votes
    mapping(address => uint256) _personalNNAmount;      //  Number of NN personal votes
    
    /**
    * @dev Initialization method
    * @param contractAddress Executable contract address
    * @param stateOfEmergency Whether in emergency state
    * @param NNAmount Amount of NNs
    */
    constructor (address contractAddress, bool stateOfEmergency, uint256 NNAmount) public {
        Nest_3_VoteFactory voteFactory = Nest_3_VoteFactory(address(msg.sender));
        _voteFactory = voteFactory;
        _nestToken = ERC20(voteFactory.checkAddress("nest"));
        _NNToken = ERC20(voteFactory.checkAddress("nestNode"));
        _implementContract = Nest_3_Implement(address(contractAddress));
        _implementAddress = address(contractAddress);
        _destructionAddress = address(voteFactory.checkAddress("nest.v3.destruction"));
        _personalNNAmount[address(tx.origin)] = NNAmount;
        _allNNAmount = NNAmount;
        _createTime = now;                                    
        _endTime = _createTime.add(voteFactory.checkLimitTime());
        _NNLimitTime = voteFactory.checkNNLimitTime();
        _NNCreateLimit = voteFactory.checkNNCreateLimit();
        _stateOfEmergency = stateOfEmergency;
        if (stateOfEmergency) {
            //  If in emergency state, read the last two periods of bonus lock-up and total circulation data
            _tokenAbonus = Nest_3_TokenAbonus(voteFactory.checkAddress("nest.v3.tokenAbonus"));
            _abonusTimes = _tokenAbonus.checkTimes().sub(2);
            require(_abonusTimes > 0);
            _circulation = _tokenAbonus.checkTokenAllValueHistory(address(_nestToken),_abonusTimes).mul(voteFactory.checkCirculationProportion()).div(100);
        } else {
            _miningSave = address(voteFactory.checkAddress("nest.v3.miningSave"));
            _tokenSave = Nest_3_TokenSave(voteFactory.checkAddress("nest.v3.tokenSave"));
            _circulation = (uint256(10000000000 ether).sub(_nestToken.balanceOf(address(_miningSave))).sub(_nestToken.balanceOf(address(_destructionAddress)))).mul(voteFactory.checkCirculationProportion()).div(100);
        }
        if (_allNNAmount >= _NNCreateLimit) {
            _nestVote = true;
        }
    }
    
    /**
    * @dev NEST voting
    */
    function nestVote() public onlyFactory {
        require(now <= _endTime, "Voting time exceeded");
        require(!_effective, "Vote in force");
        require(_nestVote);
        require(_personalAmount[address(tx.origin)] == 0, "Have voted");
        uint256 amount;
        if (_stateOfEmergency) {
            //  If in emergency state, read the last two periods of bonus lock-up and total circulation data
            amount = _tokenAbonus.checkTokenSelfHistory(address(_nestToken),_abonusTimes, address(tx.origin));
        } else {
            amount = _tokenSave.checkAmount(address(tx.origin), address(_nestToken));
        }
        _personalAmount[address(tx.origin)] = amount;
        _totalAmount = _totalAmount.add(amount);
        ifEffective();
    }
    
    /**
    * @dev NEST voting cancellation
    */
    function nestVoteCancel() public {
        require(address(msg.sender) == address(tx.origin), "It can't be a contract");
        require(now <= _endTime, "Voting time exceeded");
        require(!_effective, "Vote in force");
        require(_personalAmount[address(tx.origin)] > 0, "No vote");                     
        _totalAmount = _totalAmount.sub(_personalAmount[address(tx.origin)]);
        _personalAmount[address(tx.origin)] = 0;
    }
    
    /**
    * @dev  NestNode voting
    * @param NNAmount Amount of NNs
    */
    function nestNodeVote(uint256 NNAmount) public onlyFactory {
        require(now <= _createTime.add(_NNLimitTime), "Voting time exceeded");
        require(!_nestVote);
        _personalNNAmount[address(tx.origin)] = _personalNNAmount[address(tx.origin)].add(NNAmount);
        _allNNAmount = _allNNAmount.add(NNAmount);
        if (_allNNAmount >= _NNCreateLimit) {
            _nestVote = true;
        }
    }
    
    /**
    * @dev Withdrawing lock-up NNs
    */
    function turnOutNestNode() public {
        if (_nestVote) {
            //  Normal NEST voting
            if (!_stateOfEmergency || !_effective) {
                //  Non-emergency state
                require(now > _endTime, "Vote unenforceable");
            }
        } else {
            //  NN voting
            require(now > _createTime.add(_NNLimitTime));
        }
        require(_personalNNAmount[address(tx.origin)] > 0);
        //  Reverting back the NNs
        require(_NNToken.transfer(address(tx.origin), _personalNNAmount[address(tx.origin)]));
        _personalNNAmount[address(tx.origin)] = 0;
        //  Destroying NEST Tokens 
        uint256 nestAmount = _nestToken.balanceOf(address(this));
        _destroyedNest = _destroyedNest.add(nestAmount);
        require(_nestToken.transfer(address(_destructionAddress), nestAmount));
    }
    
    /**
    * @dev Execute the contract
    */
    function startChange() public onlyFactory {
        require(!_isChange);
        _isChange = true;
        if (_stateOfEmergency) {
            require(_effective, "Vote unenforceable");
        } else {
            require(_effective && now > _endTime, "Vote unenforceable");
        }
        //  Add the executable contract to the administrator list
        _voteFactory.addSuperMan(address(_implementContract));
        //  Execute
        _implementContract.doit();
        //  Delete the authorization
        _voteFactory.deleteSuperMan(address(_implementContract));
    }
    
    /**
    * @dev check whether the vote is effective
    */
    function ifEffective() private {
        if (_totalAmount >= _circulation) {
            _effective = true;
        }
    }
    
    /**
    * @dev Check whether the vote is over
    */
    function checkContractEffective() public view returns (bool) {
        if (_effective || now > _endTime) {
            return true;
        } 
        return false;
    }
    
    //  Check the executable implement contract address
    function checkImplementAddress() public view returns (address) {
        return _implementAddress;
    }
    
    //  Check the voting start time
    function checkCreateTime() public view returns (uint256) {
        return _createTime;
    }
    
    //  Check the voting end time
    function checkEndTime() public view returns (uint256) {
        return _endTime;
    }
    
    //  Check the current total number of votes
    function checkTotalAmount() public view returns (uint256) {
        return _totalAmount;
    }
    
    //  Check the number of votes to pass
    function checkCirculation() public view returns (uint256) {
        return _circulation;
    }
    
    //  Check the number of personal votes
    function checkPersonalAmount(address user) public view returns (uint256) {
        return _personalAmount[user];
    }
    
    //  Check the destroyed NEST
    function checkDestroyedNest() public view returns (uint256) {
        return _destroyedNest;
    }
    
    //  Check whether the contract is effective
    function checkEffective() public view returns (bool) {
        return _effective;
    }
    
    //  Check whether in emergency state
    function checkStateOfEmergency() public view returns (bool) {
        return _stateOfEmergency;
    }
    
    //  Check NestNode raising time
    function checkNNLimitTime() public view returns (uint256) {
        return _NNLimitTime;
    }
    
    //  Check the minimum number of NNs to create a vote
    function checkNNCreateLimit() public view returns (uint256) {
        return _NNCreateLimit;
    }
    
    //  Check the period number of snapshot used in the emergency state
    function checkAbonusTimes() public view returns (uint256) {
        return _abonusTimes;
    }
    
    //  Check number of personal votes
    function checkPersonalNNAmount(address user) public view returns (uint256) {
        return _personalNNAmount[address(user)];
    }
    
    //  Check the total number of NNs
    function checkAllNNAmount() public view returns (uint256) {
        return _allNNAmount;
    }
    
    //  Check whether NEST voting is available
    function checkNestVote() public view returns (bool) {
        return _nestVote;
    }
    
    //  Check whether it has been excecuted
    function checkIsChange() public view returns (bool) {
        return _isChange;
    }
    
    //  Vote Factory contract only
    modifier onlyFactory() {
        require(address(_voteFactory) == address(msg.sender), "No authority");
        _;
    }
}

//  Executable contract
interface Nest_3_Implement {
    //  Execute
    function doit() external;
}

//  NEST lock-up contract
interface Nest_3_TokenSave {
    //  Check lock-up amount
    function checkAmount(address sender, address token) external view returns (uint256);
}

//  Bonus logic contract
interface Nest_3_TokenAbonus {
    //  Check NEST circulation snapshot
    function checkTokenAllValueHistory(address token, uint256 times) external view returns (uint256);
    //  Check NEST user balance snapshot
    function checkTokenSelfHistory(address token, uint256 times, address user) external view returns (uint256);
    //  Check bonus ledger period
    function checkTimes() external view returns (uint256);
}

//  Erc20 contract
interface ERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}