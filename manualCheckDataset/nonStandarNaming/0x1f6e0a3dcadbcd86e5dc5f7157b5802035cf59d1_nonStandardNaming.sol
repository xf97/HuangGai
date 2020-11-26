pragma solidity ^0.5.2;

// File: @daostack/infra/contracts/votingMachines/IntVoteInterface.sol

interface intvoteinterface31 {	//inject NONSTANDARD NAMING
    //When implementing this interface please do not only override function and modifier,
    //but also to keep the modifiers on the overridden functions.
    modifier ONLYPROPOSALOWNER70(bytes32 _proposalId) {revert(); _;}	//inject NONSTANDARD NAMING
    modifier VOTABLE14(bytes32 _proposalId) {revert(); _;}	//inject NONSTANDARD NAMING

    event NEWPROPOSAL82(	//inject NONSTANDARD NAMING
        bytes32 indexed _proposalId,
        address indexed _organization,
        uint256 _numOfChoices,
        address _proposer,
        bytes32 _paramsHash
    );

    event EXECUTEPROPOSAL67(bytes32 indexed _proposalId,	//inject NONSTANDARD NAMING
        address indexed _organization,
        uint256 _decision,
        uint256 _totalReputation
    );

    event VOTEPROPOSAL81(	//inject NONSTANDARD NAMING
        bytes32 indexed _proposalId,
        address indexed _organization,
        address indexed _voter,
        uint256 _vote,
        uint256 _reputation
    );

    event CANCELPROPOSAL59(bytes32 indexed _proposalId, address indexed _organization );	//inject NONSTANDARD NAMING
    event CANCELVOTING5(bytes32 indexed _proposalId, address indexed _organization, address indexed _voter);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function PROPOSE48(	//inject NONSTANDARD NAMING
        uint256 _numOfChoices,
        bytes32 _proposalParameters,
        address _proposer,
        address _organization
        ) external returns(bytes32);

    function VOTE79(	//inject NONSTANDARD NAMING
        bytes32 _proposalId,
        uint256 _vote,
        uint256 _rep,
        address _voter
    )
    external
    returns(bool);

    function CANCELVOTE62(bytes32 _proposalId) external;	//inject NONSTANDARD NAMING

    function GETNUMBEROFCHOICES23(bytes32 _proposalId) external view returns(uint256);	//inject NONSTANDARD NAMING

    function ISVOTABLE72(bytes32 _proposalId) external view returns(bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                             
    function VOTESTATUS55(bytes32 _proposalId, uint256 _choice) external view returns(uint256);	//inject NONSTANDARD NAMING

                                                                                                                            
    function ISABSTAINALLOW86() external pure returns(bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                             
    function GETALLOWEDRANGEOFCHOICES7() external pure returns(uint256 min, uint256 max);	//inject NONSTANDARD NAMING
}

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

                                                                                        
interface ierc2016 {	//inject NONSTANDARD NAMING
    function TRANSFER74(address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function APPROVE55(address spender, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM94(address from, address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function TOTALSUPPLY28() external view returns (uint256);	//inject NONSTANDARD NAMING

    function BALANCEOF62(address who) external view returns (uint256);	//inject NONSTANDARD NAMING

    function ALLOWANCE21(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

    event TRANSFER49(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

    event APPROVAL97(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// File: @daostack/infra/contracts/votingMachines/VotingMachineCallbacksInterface.sol

interface votingmachinecallbacksinterface79 {	//inject NONSTANDARD NAMING
    function MINTREPUTATION65(uint256 _amount, address _beneficiary, bytes32 _proposalId) external returns(bool);	//inject NONSTANDARD NAMING
    function BURNREPUTATION8(uint256 _amount, address _owner, bytes32 _proposalId) external returns(bool);	//inject NONSTANDARD NAMING

    function STAKINGTOKENTRANSFER23(ierc2016 _stakingToken, address _beneficiary, uint256 _amount, bytes32 _proposalId)	//inject NONSTANDARD NAMING
    external
    returns(bool);

    function GETTOTALREPUTATIONSUPPLY93(bytes32 _proposalId) external view returns(uint256);	//inject NONSTANDARD NAMING
    function REPUTATIONOF100(address _owner, bytes32 _proposalId) external view returns(uint256);	//inject NONSTANDARD NAMING
    function BALANCEOFSTAKINGTOKEN17(ierc2016 _stakingToken, bytes32 _proposalId) external view returns(uint256);	//inject NONSTANDARD NAMING
}

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

                                                                                                                                                                                             
contract ownable56 {	//inject NONSTANDARD NAMING
    address private _owner;

    event OWNERSHIPTRANSFERRED0(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                                                           
    constructor () internal {
        _owner = msg.sender;
        emit OWNERSHIPTRANSFERRED0(address(0), _owner);
    }

                                                        
    function OWNER8() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER65() {	//inject NONSTANDARD NAMING
        require(ISOWNER85());
        _;
    }

                                                                                 
    function ISOWNER85() public view returns (bool) {	//inject NONSTANDARD NAMING
        return msg.sender == _owner;
    }

                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP94() public ONLYOWNER65 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED0(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                                                    
    function TRANSFEROWNERSHIP25(address newOwner) public ONLYOWNER65 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP15(newOwner);
    }

                                                                                                                                         
    function _TRANSFEROWNERSHIP15(address newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0));
        emit OWNERSHIPTRANSFERRED0(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: @daostack/infra/contracts/Reputation.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                

contract reputation51 is ownable56 {	//inject NONSTANDARD NAMING

    uint8 public decimals = 18;             //Number of decimals of the smallest unit
    // Event indicating minting of reputation to an address.
    event MINT64(address indexed _to, uint256 _amount);	//inject NONSTANDARD NAMING
    // Event indicating burning of reputation for an address.
    event BURN4(address indexed _from, uint256 _amount);	//inject NONSTANDARD NAMING

                                                                              
                                                                                  
                
    struct Checkpoint {

    // `fromBlock` is the block number that the value was generated from
        uint128 fromBlock;

          // `value` is the amount of reputation at a specific block number
        uint128 value;
    }

      // `balances` is the map that tracks the balance of each address, in this
      //  contract when the balance changes the block number that the change
      //  occurred is also included in the map
    mapping (address => Checkpoint[]) balances;

      // Tracks the history of the `totalSupply` of the reputation
    Checkpoint[] totalSupplyHistory;

                                                  
    constructor(
    ) public
    {
    }

                                                                              
                                              
    function TOTALSUPPLY28() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return TOTALSUPPLYAT94(block.number);
    }

                  
  // Query balance and totalSupply in History
                  
                                                                                                                                                       
    function BALANCEOF62(address _owner) public view returns (uint256 balance) {	//inject NONSTANDARD NAMING
        return BALANCEOFAT72(_owner, block.number);
    }

                                                                           
                                                                            
                                                                          
                                               
    function BALANCEOFAT72(address _owner, uint256 _blockNumber)	//inject NONSTANDARD NAMING
    public view returns (uint256)
    {
        if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
            return 0;
          // This will return the expected balance during normal situations
        } else {
            return GETVALUEAT9(balances[_owner], _blockNumber);
        }
    }

                                                                          
                                                                              
                                                                  
    function TOTALSUPPLYAT94(uint256 _blockNumber) public view returns(uint256) {	//inject NONSTANDARD NAMING
        if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
            return 0;
          // This will return the expected totalSupply during normal situations
        } else {
            return GETVALUEAT9(totalSupplyHistory, _blockNumber);
        }
    }

                                                                              
                                                                           
                                                             
                                                                
    function MINT38(address _user, uint256 _amount) public ONLYOWNER65 returns (bool) {	//inject NONSTANDARD NAMING
        uint256 curTotalSupply = TOTALSUPPLY28();
        require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
        uint256 previousBalanceTo = BALANCEOF62(_user);
        require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
        UPDATEVALUEATNOW85(totalSupplyHistory, curTotalSupply + _amount);
        UPDATEVALUEATNOW85(balances[_user], previousBalanceTo + _amount);
        emit MINT64(_user, _amount);
        return true;
    }

                                                          
                                                                
                                                           
                                                             
    function BURN49(address _user, uint256 _amount) public ONLYOWNER65 returns (bool) {	//inject NONSTANDARD NAMING
        uint256 curTotalSupply = TOTALSUPPLY28();
        uint256 amountBurned = _amount;
        uint256 previousBalanceFrom = BALANCEOF62(_user);
        if (previousBalanceFrom < amountBurned) {
            amountBurned = previousBalanceFrom;
        }
        UPDATEVALUEATNOW85(totalSupplyHistory, curTotalSupply - amountBurned);
        UPDATEVALUEATNOW85(balances[_user], previousBalanceFrom - amountBurned);
        emit BURN4(_user, amountBurned);
        return true;
    }

                  
  // Internal helper functions to query and set a value in a snapshot array
                  

                                                                                      
                                                                
                                                                 
                                                        
    function GETVALUEAT9(Checkpoint[] storage checkpoints, uint256 _block) internal view returns (uint256) {	//inject NONSTANDARD NAMING
        if (checkpoints.length == 0) {
            return 0;
        }

          // Shortcut for the actual value
        if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
            return checkpoints[checkpoints.length-1].value;
        }
        if (_block < checkpoints[0].fromBlock) {
            return 0;
        }

          // Binary search of the value in the array
        uint256 min = 0;
        uint256 max = checkpoints.length-1;
        while (max > min) {
            uint256 mid = (max + min + 1) / 2;
            if (checkpoints[mid].fromBlock<=_block) {
                min = mid;
            } else {
                max = mid-1;
            }
        }
        return checkpoints[min].value;
    }

                                                                           
                               
                                                              
                                                    
    function UPDATEVALUEATNOW85(Checkpoint[] storage checkpoints, uint256 _value) internal {	//inject NONSTANDARD NAMING
        require(uint128(_value) == _value); //check value is in the 128 bits bounderies
        if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
            Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
            newCheckPoint.fromBlock = uint128(block.number);
            newCheckPoint.value = uint128(_value);
        } else {
            Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
            oldCheckPoint.value = uint128(_value);
        }
    }
}

// File: /Users/oren/daostack/daostack2/daostack/node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol


// File: /Users/oren/daostack/daostack2/daostack/node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol

                                                                                                   
library safemath4 {	//inject NONSTANDARD NAMING
                                                                                
    function MUL16(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

                                                                                                                         
    function DIV25(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                            
    function SUB37(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

                                                                          
    function ADD40(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

                                                                                                                                                 
    function MOD29(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0);
        return a % b;
    }
}

// File: /Users/oren/daostack/daostack2/daostack/node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
contract erc2045 is ierc2016 {	//inject NONSTANDARD NAMING
    using safemath4 for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

                                                             
    function TOTALSUPPLY28() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                                                                                                                                                                          
    function BALANCEOF62(address owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[owner];
    }

                                                                                                                                                                                                                                                                                                                                    
    function ALLOWANCE21(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowed[owner][spender];
    }

                                                                                                                                                             
    function TRANSFER74(address to, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER44(msg.sender, to, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function APPROVE55(address spender, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit APPROVAL97(msg.sender, spender, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function TRANSFERFROM94(address from, address to, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _allowed[from][msg.sender] = _allowed[from][msg.sender].SUB37(value);
        _TRANSFER44(from, to, value);
        emit APPROVAL97(from, msg.sender, _allowed[from][msg.sender]);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function INCREASEALLOWANCE67(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].ADD40(addedValue);
        emit APPROVAL97(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function DECREASEALLOWANCE11(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].SUB37(subtractedValue);
        emit APPROVAL97(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

                                                                                                                                                                                                               
    function _TRANSFER44(address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(to != address(0));

        _balances[from] = _balances[from].SUB37(value);
        _balances[to] = _balances[to].ADD40(value);
        emit TRANSFER49(from, to, value);
    }

                                                                                                                                                                                                                                                                                                                                                
    function _MINT14(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0));

        _totalSupply = _totalSupply.ADD40(value);
        _balances[account] = _balances[account].ADD40(value);
        emit TRANSFER49(address(0), account, value);
    }

                                                                                                                                                                                                                           
    function _BURN11(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0));

        _totalSupply = _totalSupply.SUB37(value);
        _balances[account] = _balances[account].SUB37(value);
        emit TRANSFER49(account, address(0), value);
    }

                                                                                                                                                                                                                                                                                                                                                                                              
    function _BURNFROM86(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        _allowed[account][msg.sender] = _allowed[account][msg.sender].SUB37(value);
        _BURN11(account, value);
        emit APPROVAL97(account, msg.sender, _allowed[account][msg.sender]);
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol

                                                                                           
contract erc20burnable16 is erc2045 {	//inject NONSTANDARD NAMING
                                                                                                                    
    function BURN49(uint256 value) public {	//inject NONSTANDARD NAMING
        _BURN11(msg.sender, value);
    }

                                                                                                                                                                                                                                                     
    function BURNFROM98(address from, uint256 value) public {	//inject NONSTANDARD NAMING
        _BURNFROM86(from, value);
    }
}

// File: /Users/oren/daostack/daostack2/daostack/contracts/controller/DAOToken.sol

                                                                                                                        

contract daotoken36 is erc2045, erc20burnable16, ownable56 {	//inject NONSTANDARD NAMING

    string public name;
    string public symbol;
    // solhint-disable-next-line const-name-snakecase
    uint8 public constant decimals61 = 18;	//inject NONSTANDARD NAMING
    uint256 public cap;

                                                                                                                                                              
    constructor(string memory _name, string memory _symbol, uint256 _cap)
    public {
        name = _name;
        symbol = _symbol;
        cap = _cap;
    }

                                                                                                                                                                          
    function MINT38(address _to, uint256 _amount) public ONLYOWNER65 returns (bool) {	//inject NONSTANDARD NAMING
        if (cap > 0)
            require(TOTALSUPPLY28().ADD40(_amount) <= cap);
        _MINT14(_to, _amount);
        return true;
    }
}

// File: openzeppelin-solidity/contracts/utils/Address.sol

                                                           
library address8 {	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                                                                                                                                                   
    function ISCONTRACT13(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        uint256 size;
        // XXX Currently there is no better way to check if there is a contract in an address
        // than to check the size of the code at that address.
        // See https://ethereum.stackexchange.com/a/14016/36603
        // for more details about how this works.
        // TODO Check this again before the Serenity release, because all addresses will be
        // contracts then.
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

// File: /Users/oren/daostack/daostack2/daostack/contracts/libs/SafeERC20.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
pragma solidity ^0.5.2;



library safeerc2019 {	//inject NONSTANDARD NAMING
    using address8 for address;

    bytes4 constant private transfer_selector2 = bytes4(keccak256(bytes("transfer(address,uint256)")));	//inject NONSTANDARD NAMING
    bytes4 constant private transferfrom_selector45 = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));	//inject NONSTANDARD NAMING
    bytes4 constant private approve_selector67 = bytes4(keccak256(bytes("approve(address,uint256)")));	//inject NONSTANDARD NAMING

    function SAFETRANSFER100(address _erc20Addr, address _to, uint256 _value) internal {	//inject NONSTANDARD NAMING

        // Must be a contract addr first!
        require(_erc20Addr.ISCONTRACT13());

        (bool success, bytes memory returnValue) =
        // solhint-disable-next-line avoid-low-level-calls
        _erc20Addr.call(abi.encodeWithSelector(transfer_selector2, _to, _value));
        // call return false when something wrong
        require(success);
        //check return value
        require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
    }

    function SAFETRANSFERFROM10(address _erc20Addr, address _from, address _to, uint256 _value) internal {	//inject NONSTANDARD NAMING

        // Must be a contract addr first!
        require(_erc20Addr.ISCONTRACT13());

        (bool success, bytes memory returnValue) =
        // solhint-disable-next-line avoid-low-level-calls
        _erc20Addr.call(abi.encodeWithSelector(transferfrom_selector45, _from, _to, _value));
        // call return false when something wrong
        require(success);
        //check return value
        require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
    }

    function SAFEAPPROVE78(address _erc20Addr, address _spender, uint256 _value) internal {	//inject NONSTANDARD NAMING

        // Must be a contract addr first!
        require(_erc20Addr.ISCONTRACT13());

        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero.
        require((_value == 0) || (ierc2016(_erc20Addr).ALLOWANCE21(msg.sender, _spender) == 0));

        (bool success, bytes memory returnValue) =
        // solhint-disable-next-line avoid-low-level-calls
        _erc20Addr.call(abi.encodeWithSelector(approve_selector67, _spender, _value));
        // call return false when something wrong
        require(success);
        //check return value
        require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
    }
}

// File: /Users/oren/daostack/daostack2/daostack/contracts/controller/Avatar.sol

                                                                               
contract avatar70 is ownable56 {	//inject NONSTANDARD NAMING
    using safeerc2019 for address;

    string public orgName;
    daotoken36 public nativeToken;
    reputation51 public nativeReputation;

    event GENERICCALL1(address indexed _contract, bytes _params, bool _success);	//inject NONSTANDARD NAMING
    event SENDETHER8(uint256 _amountInWei, address indexed _to);	//inject NONSTANDARD NAMING
    event EXTERNALTOKENTRANSFER37(address indexed _externalToken, address indexed _to, uint256 _value);	//inject NONSTANDARD NAMING
    event EXTERNALTOKENTRANSFERFROM36(address indexed _externalToken, address _from, address _to, uint256 _value);	//inject NONSTANDARD NAMING
    event EXTERNALTOKENAPPROVAL0(address indexed _externalToken, address _spender, uint256 _value);	//inject NONSTANDARD NAMING
    event RECEIVEETHER12(address indexed _sender, uint256 _value);	//inject NONSTANDARD NAMING

                                                                                                                                                
    constructor(string memory _orgName, daotoken36 _nativeToken, reputation51 _nativeReputation) public {
        orgName = _orgName;
        nativeToken = _nativeToken;
        nativeReputation = _nativeReputation;
    }

                                                             
    function() external payable {
        emit RECEIVEETHER12(msg.sender, msg.value);
    }

                                                                                                                                                                                                                                                                                                                          
    function GENERICCALL24(address _contract, bytes memory _data)	//inject NONSTANDARD NAMING
    public
    ONLYOWNER65
    returns(bool success, bytes memory returnValue) {
      // solhint-disable-next-line avoid-low-level-calls
        (success, returnValue) = _contract.call(_data);
        emit GENERICCALL1(_contract, _data, success);
    }

                                                                                                                                                                                                                 
    function SENDETHER91(uint256 _amountInWei, address payable _to) public ONLYOWNER65 returns(bool) {	//inject NONSTANDARD NAMING
        _to.transfer(_amountInWei);
        emit SENDETHER8(_amountInWei, _to);
        return true;
    }

                                                                                                                                                                                                                                          
    function EXTERNALTOKENTRANSFER67(ierc2016 _externalToken, address _to, uint256 _value)	//inject NONSTANDARD NAMING
    public ONLYOWNER65 returns(bool)
    {
        address(_externalToken).SAFETRANSFER100(_to, _value);
        emit EXTERNALTOKENTRANSFER37(address(_externalToken), _to, _value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                     
    function EXTERNALTOKENTRANSFERFROM68(	//inject NONSTANDARD NAMING
        ierc2016 _externalToken,
        address _from,
        address _to,
        uint256 _value
    )
    public ONLYOWNER65 returns(bool)
    {
        address(_externalToken).SAFETRANSFERFROM10(_from, _to, _value);
        emit EXTERNALTOKENTRANSFERFROM36(address(_externalToken), _from, _to, _value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                    
    function EXTERNALTOKENAPPROVAL13(ierc2016 _externalToken, address _spender, uint256 _value)	//inject NONSTANDARD NAMING
    public ONLYOWNER65 returns(bool)
    {
        address(_externalToken).SAFEAPPROVE78(_spender, _value);
        emit EXTERNALTOKENAPPROVAL0(address(_externalToken), _spender, _value);
        return true;
    }

}

// File: /Users/oren/daostack/daostack2/daostack/contracts/universalSchemes/UniversalSchemeInterface.sol

contract universalschemeinterface23 {	//inject NONSTANDARD NAMING

    function UPDATEPARAMETERS61(bytes32 _hashedParameters) public;	//inject NONSTANDARD NAMING

    function GETPARAMETERSFROMCONTROLLER72(avatar70 _avatar) internal view returns(bytes32);	//inject NONSTANDARD NAMING
}

// File: /Users/oren/daostack/daostack2/daostack/contracts/globalConstraints/GlobalConstraintInterface.sol

contract globalconstraintinterface55 {	//inject NONSTANDARD NAMING

    enum CallPhase { Pre, Post, PreAndPost }

    function PRE44( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);	//inject NONSTANDARD NAMING
    function POST41( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);	//inject NONSTANDARD NAMING
                                                                                                                                                          
    function WHEN71() public returns(CallPhase);	//inject NONSTANDARD NAMING
}

// File: /Users/oren/daostack/daostack2/daostack/contracts/controller/ControllerInterface.sol

                                                                                                                                                                                                                                                                      
interface controllerinterface59 {	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                             
    function MINTREPUTATION65(uint256 _amount, address _to, address _avatar)	//inject NONSTANDARD NAMING
    external
    returns(bool);

                                                                                                                                                                                                                                      
    function BURNREPUTATION8(uint256 _amount, address _from, address _avatar)	//inject NONSTANDARD NAMING
    external
    returns(bool);

                                                                                                                                                                                                                    
    function MINTTOKENS53(uint256 _amount, address _beneficiary, address _avatar)	//inject NONSTANDARD NAMING
    external
    returns(bool);

                                                                                                                                                                                                                                                                                                                    
    function REGISTERSCHEME80(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)	//inject NONSTANDARD NAMING
    external
    returns(bool);

                                                                                                                                                                            
    function UNREGISTERSCHEME15(address _scheme, address _avatar)	//inject NONSTANDARD NAMING
    external
    returns(bool);

                                                                                                                                       
    function UNREGISTERSELF18(address _avatar) external returns(bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                       
    function ADDGLOBALCONSTRAINT70(address _globalConstraint, bytes32 _params, address _avatar)	//inject NONSTANDARD NAMING
    external returns(bool);

                                                                                                                                                                                                                                     
    function REMOVEGLOBALCONSTRAINT6 (address _globalConstraint, address _avatar)	//inject NONSTANDARD NAMING
    external  returns(bool);

                                                                                                                                                                                                                                                            
    function UPGRADECONTROLLER96(address _newController, avatar70 _avatar)	//inject NONSTANDARD NAMING
    external returns(bool);

                                                                                                                                                                                                                                                                                                                                                                       
    function GENERICCALL24(address _contract, bytes calldata _data, avatar70 _avatar)	//inject NONSTANDARD NAMING
    external
    returns(bool, bytes memory);

                                                                                                                                                                                                                       
    function SENDETHER91(uint256 _amountInWei, address payable _to, avatar70 _avatar)	//inject NONSTANDARD NAMING
    external returns(bool);

                                                                                                                                                                                                                                                                                                                  
    function EXTERNALTOKENTRANSFER67(ierc2016 _externalToken, address _to, uint256 _value, avatar70 _avatar)	//inject NONSTANDARD NAMING
    external
    returns(bool);

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function EXTERNALTOKENTRANSFERFROM68(	//inject NONSTANDARD NAMING
    ierc2016 _externalToken,
    address _from,
    address _to,
    uint256 _value,
    avatar70 _avatar)
    external
    returns(bool);

                                                                                                                                                                                                                                                                                                                                                                                    
    function EXTERNALTOKENAPPROVAL13(ierc2016 _externalToken, address _spender, uint256 _value, avatar70 _avatar)	//inject NONSTANDARD NAMING
    external
    returns(bool);

                                                                                                                                            
    function GETNATIVEREPUTATION64(address _avatar)	//inject NONSTANDARD NAMING
    external
    view
    returns(address);

    function ISSCHEMEREGISTERED53( address _scheme, address _avatar) external view returns(bool);	//inject NONSTANDARD NAMING

    function GETSCHEMEPARAMETERS80(address _scheme, address _avatar) external view returns(bytes32);	//inject NONSTANDARD NAMING

    function GETGLOBALCONSTRAINTPARAMETERS50(address _globalConstraint, address _avatar) external view returns(bytes32);	//inject NONSTANDARD NAMING

    function GETSCHEMEPERMISSIONS72(address _scheme, address _avatar) external view returns(bytes4);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                         
    function GLOBALCONSTRAINTSCOUNT61(address _avatar) external view returns(uint, uint);	//inject NONSTANDARD NAMING

    function ISGLOBALCONSTRAINTREGISTERED65(address _globalConstraint, address _avatar) external view returns(bool);	//inject NONSTANDARD NAMING
}

// File: /Users/oren/daostack/daostack2/daostack/contracts/universalSchemes/UniversalScheme.sol

contract universalscheme48 is ownable56, universalschemeinterface23 {	//inject NONSTANDARD NAMING
    bytes32 public hashedParameters; // For other parameters.

    function UPDATEPARAMETERS61(	//inject NONSTANDARD NAMING
        bytes32 _hashedParameters
    )
        public
        ONLYOWNER65
    {
        hashedParameters = _hashedParameters;
    }

                                                                                        
    function GETPARAMETERSFROMCONTROLLER72(avatar70 _avatar) internal view returns(bytes32) {	//inject NONSTANDARD NAMING
        require(controllerinterface59(_avatar.OWNER8()).ISSCHEMEREGISTERED53(address(this), address(_avatar)),
        "scheme is not registered");
        return controllerinterface59(_avatar.OWNER8()).GETSCHEMEPARAMETERS80(address(this), address(_avatar));
    }
}

// File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol

                                                                                                                                                                                                                                                                                

library ecdsa86 {	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                                                                                 
    function RECOVER59(bytes32 hash, bytes memory signature) internal pure returns (address) {	//inject NONSTANDARD NAMING
        bytes32 r;
        bytes32 s;
        uint8 v;

        // Check the signature length
        if (signature.length != 65) {
            return (address(0));
        }

        // Divide the signature in r, s and v variables
        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solhint-disable-next-line no-inline-assembly
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 27;
        }

        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
            return (address(0));
        } else {
            return ecrecover(hash, v, r, s);
        }
    }

                                                                                                                                               
    function TOETHSIGNEDMESSAGEHASH91(bytes32 hash) internal pure returns (bytes32) {	//inject NONSTANDARD NAMING
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}


// File: /Users/oren/daostack/daostack2/daostack/node_modules/@daostack/infra/contracts/libs/RealMath.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     


library realmath32 {	//inject NONSTANDARD NAMING

                                                     
    uint256 constant private real_bits92 = 256;	//inject NONSTANDARD NAMING

                                                          
    uint256 constant private real_fbits8 = 40;	//inject NONSTANDARD NAMING

                                                          
    uint256 constant private real_one87 = uint256(1) << real_fbits8;	//inject NONSTANDARD NAMING

                                                                        
    function POW66(uint256 realBase, uint256 exponent) internal pure returns (uint256) {	//inject NONSTANDARD NAMING

        uint256 tempRealBase = realBase;
        uint256 tempExponent = exponent;

        // Start with the 0th power
        uint256 realResult = real_one87;
        while (tempExponent != 0) {
            // While there are still bits set
            if ((tempExponent & 0x1) == 0x1) {
                // If the low bit is set, multiply in the (many-times-squared) base
                realResult = MUL16(realResult, tempRealBase);
            }
            // Shift off the low bit
            tempExponent = tempExponent >> 1;
            // Do the squaring
            tempRealBase = MUL16(tempRealBase, tempRealBase);
        }

        // Return the final result.
        return uint216(realResult / real_one87);
    }

                                                              
    function FRACTION6(uint216 numerator, uint216 denominator) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV25(uint256(numerator) * real_one87, uint256(denominator) * real_one87);
    }

                                                                         
    function MUL16(uint256 realA, uint256 realB) private pure returns (uint256) {	//inject NONSTANDARD NAMING
        // When multiplying fixed point in x.y and z.w formats we get (x+z).(y+w) format.
        // So we just have to clip off the extra REAL_FBITS fractional bits.
        return uint256((uint256(realA) * uint256(realB)) >> real_fbits8);
    }

                                                                            
    function DIV25(uint256 realNumerator, uint256 realDenominator) private pure returns (uint256) {	//inject NONSTANDARD NAMING
        // We use the reverse of the multiplication trick: convert numerator from
        // x.y to (x+z).(y+w) fixed point, then divide by denom in z.w fixed point.
        return uint256((uint256(realNumerator) * real_one87) / uint256(realDenominator));
    }

}

// File: /Users/oren/daostack/daostack2/daostack/node_modules/@daostack/infra/contracts/votingMachines/VotingMachineCallbacksInterface.sol


// File: /Users/oren/daostack/daostack2/daostack/node_modules/@daostack/infra/contracts/votingMachines/ProposalExecuteInterface.sol

interface proposalexecuteinterface9 {	//inject NONSTANDARD NAMING
    function EXECUTEPROPOSAL85(bytes32 _proposalId, int _decision) external returns(bool);	//inject NONSTANDARD NAMING
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol


// File: openzeppelin-solidity/contracts/math/Math.sol

                                                       
library math46 {	//inject NONSTANDARD NAMING
                                                             
    function MAX19(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return a >= b ? a : b;
    }

                                                              
    function MIN92(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return a < b ? a : b;
    }

                                                                                                                                                                                          
    function AVERAGE32(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// File: /Users/oren/daostack/daostack2/daostack/node_modules/@daostack/infra/contracts/votingMachines/GenesisProtocolLogic.sol

                                                                                          
contract genesisprotocollogic61 is intvoteinterface31 {	//inject NONSTANDARD NAMING
    using safemath4 for uint;
    using math46 for uint;
    using realmath32 for uint216;
    using realmath32 for uint256;
    using address8 for address;

    enum ProposalState { None, ExpiredInQueue, Executed, Queued, PreBoosted, Boosted, QuietEndingPeriod}
    enum ExecutionState { None, QueueBarCrossed, QueueTimeOut, PreBoostedBarCrossed, BoostedTimeOut, BoostedBarCrossed}

    //Organization's parameters
    struct Parameters {
        uint256 queuedVoteRequiredPercentage; // the absolute vote percentages bar.
        uint256 queuedVotePeriodLimit; //the time limit for a proposal to be in an absolute voting mode.
        uint256 boostedVotePeriodLimit; //the time limit for a proposal to be in boost mode.
        uint256 preBoostedVotePeriodLimit; //the time limit for a proposal
                                          //to be in an preparation state (stable) before boosted.
        uint256 thresholdConst; //constant  for threshold calculation .
                                //threshold =thresholdConst ** (numberOfBoostedProposals)
        uint256 limitExponentValue;// an upper limit for numberOfBoostedProposals
                                   //in the threshold calculation to prevent overflow
        uint256 quietEndingPeriod; //quite ending period
        uint256 proposingRepReward;//proposer reputation reward.
        uint256 votersReputationLossRatio;//Unsuccessful pre booster
                                          //voters lose votersReputationLossRatio% of their reputation.
        uint256 minimumDaoBounty;
        uint256 daoBountyConst;//The DAO downstake for each proposal is calculate according to the formula
                               //(daoBountyConst * averageBoostDownstakes)/100 .
        uint256 activationTime;//the point in time after which proposals can be created.
        //if this address is set so only this address is allowed to vote of behalf of someone else.
        address voteOnBehalf;
    }

    struct Voter {
        uint256 vote; // YES(1) ,NO(2)
        uint256 reputation; // amount of voter's reputation
        bool preBoosted;
    }

    struct Staker {
        uint256 vote; // YES(1) ,NO(2)
        uint256 amount; // amount of staker's stake
        uint256 amount4Bounty;// amount of staker's stake used for bounty reward calculation.
    }

    struct Proposal {
        bytes32 organizationId; // the organization unique identifier the proposal is target to.
        address callbacks;    // should fulfill voting callbacks interface.
        ProposalState state;
        uint256 winningVote; //the winning vote.
        address proposer;
        //the proposal boosted period limit . it is updated for the case of quiteWindow mode.
        uint256 currentBoostedVotePeriodLimit;
        bytes32 paramsHash;
        uint256 daoBountyRemain; //use for checking sum zero bounty claims.it is set at the proposing time.
        uint256 daoBounty;
        uint256 totalStakes;// Total number of tokens staked which can be redeemable by stakers.
        uint256 confidenceThreshold;
        //The percentage from upper stakes which the caller for the expiration was given.
        uint256 expirationCallBountyPercentage;
        uint[3] times; //times[0] - submittedTime
                       //times[1] - boostedPhaseTime
                       //times[2] -preBoostedPhaseTime;
        //      vote      reputation
        mapping(uint256   =>  uint256    ) votes;
        //      vote      reputation
        mapping(uint256   =>  uint256    ) preBoostedVotes;
        //      address     voter
        mapping(address =>  Voter    ) voters;
        //      vote        stakes
        mapping(uint256   =>  uint256    ) stakes;
        //      address  staker
        mapping(address  => Staker   ) stakers;
    }

    event STAKE61(bytes32 indexed _proposalId,	//inject NONSTANDARD NAMING
        address indexed _organization,
        address indexed _staker,
        uint256 _vote,
        uint256 _amount
    );

    event REDEEM77(bytes32 indexed _proposalId,	//inject NONSTANDARD NAMING
        address indexed _organization,
        address indexed _beneficiary,
        uint256 _amount
    );

    event REDEEMDAOBOUNTY80(bytes32 indexed _proposalId,	//inject NONSTANDARD NAMING
        address indexed _organization,
        address indexed _beneficiary,
        uint256 _amount
    );

    event REDEEMREPUTATION31(bytes32 indexed _proposalId,	//inject NONSTANDARD NAMING
        address indexed _organization,
        address indexed _beneficiary,
        uint256 _amount
    );

    event STATECHANGE55(bytes32 indexed _proposalId, ProposalState _proposalState);	//inject NONSTANDARD NAMING
    event GPEXECUTEPROPOSAL49(bytes32 indexed _proposalId, ExecutionState _executionState);	//inject NONSTANDARD NAMING
    event EXPIRATIONCALLBOUNTY13(bytes32 indexed _proposalId, address indexed _beneficiary, uint256 _amount);	//inject NONSTANDARD NAMING

    mapping(bytes32=>Parameters) public parameters;  // A mapping from hashes to parameters
    mapping(bytes32=>Proposal) public proposals; // Mapping from the ID of the proposal to the proposal itself.
    mapping(bytes32=>uint) public orgBoostedProposalsCnt;
           //organizationId => organization
    mapping(bytes32        => address     ) public organizations;
          //organizationId => averageBoostDownstakes
    mapping(bytes32           => uint256              ) public averagesDownstakesOfBoosted;
    uint256 constant public num_of_choices20 = 2;	//inject NONSTANDARD NAMING
    uint256 constant public no97 = 2;	//inject NONSTANDARD NAMING
    uint256 constant public yes52 = 1;	//inject NONSTANDARD NAMING
    uint256 public proposalsCnt; // Total number of proposals
    ierc2016 public stakingToken;
    address constant private gen_token_address24 = 0x543Ff227F64Aa17eA132Bf9886cAb5DB55DCAddf;	//inject NONSTANDARD NAMING
    uint256 constant private max_boosted_proposals66 = 4096;	//inject NONSTANDARD NAMING

                                       
    constructor(ierc2016 _stakingToken) public {
      //The GEN token (staking token) address is hard coded in the contract by GEN_TOKEN_ADDRESS .
      //This will work for a network which already hosted the GEN token on this address (e.g mainnet).
      //If such contract address does not exist in the network (e.g ganache)
      //the contract will use the _stakingToken param as the
      //staking token address.
        if (address(gen_token_address24).ISCONTRACT13()) {
            stakingToken = ierc2016(gen_token_address24);
        } else {
            stakingToken = _stakingToken;
        }
    }

                                                                                                                                                                                 
    modifier VOTABLE14(bytes32 _proposalId) {	//inject NONSTANDARD NAMING
        require(_ISVOTABLE26(_proposalId));
        _;
    }

                                                                                                                                                                                                                                                                                                              
    function PROPOSE48(uint256, bytes32 _paramsHash, address _proposer, address _organization)	//inject NONSTANDARD NAMING
        external
        returns(bytes32)
    {
      // solhint-disable-next-line not-rely-on-time
        require(now > parameters[_paramsHash].activationTime, "not active yet");
        //Check parameters existence.
        require(parameters[_paramsHash].queuedVoteRequiredPercentage >= 50);
        // Generate a unique ID:
        bytes32 proposalId = keccak256(abi.encodePacked(this, proposalsCnt));
        proposalsCnt = proposalsCnt.ADD40(1);
         // Open proposal:
        Proposal memory proposal;
        proposal.callbacks = msg.sender;
        proposal.organizationId = keccak256(abi.encodePacked(msg.sender, _organization));

        proposal.state = ProposalState.Queued;
        // solhint-disable-next-line not-rely-on-time
        proposal.times[0] = now;//submitted time
        proposal.currentBoostedVotePeriodLimit = parameters[_paramsHash].boostedVotePeriodLimit;
        proposal.proposer = _proposer;
        proposal.winningVote = no97;
        proposal.paramsHash = _paramsHash;
        if (organizations[proposal.organizationId] == address(0)) {
            if (_organization == address(0)) {
                organizations[proposal.organizationId] = msg.sender;
            } else {
                organizations[proposal.organizationId] = _organization;
            }
        }
        //calc dao bounty
        uint256 daoBounty =
        parameters[_paramsHash].daoBountyConst.MUL16(averagesDownstakesOfBoosted[proposal.organizationId]).DIV25(100);
        if (daoBounty < parameters[_paramsHash].minimumDaoBounty) {
            proposal.daoBountyRemain = parameters[_paramsHash].minimumDaoBounty;
        } else {
            proposal.daoBountyRemain = daoBounty;
        }
        proposal.totalStakes = proposal.daoBountyRemain;
        proposals[proposalId] = proposal;
        proposals[proposalId].stakes[no97] = proposal.daoBountyRemain;//dao downstake on the proposal
        Staker storage staker = proposals[proposalId].stakers[organizations[proposal.organizationId]];
        staker.vote = no97;
        staker.amount = proposal.daoBountyRemain;

        emit NEWPROPOSAL82(proposalId, organizations[proposal.organizationId], num_of_choices20, _proposer, _paramsHash);
        return proposalId;
    }

                                                                                                                                                                                                                                       
    function EXECUTEBOOSTED98(bytes32 _proposalId) external returns(uint256 expirationCallBounty) {	//inject NONSTANDARD NAMING
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.state == ProposalState.Boosted);
        require(_EXECUTE0(_proposalId), "proposal need to expire");
        uint256 expirationCallBountyPercentage =
        // solhint-disable-next-line not-rely-on-time
        (uint(1).ADD40(now.SUB37(proposal.currentBoostedVotePeriodLimit.ADD40(proposal.times[1])).DIV25(15)));
        if (expirationCallBountyPercentage > 100) {
            expirationCallBountyPercentage = 100;
        }
        proposal.expirationCallBountyPercentage = expirationCallBountyPercentage;
        expirationCallBounty = expirationCallBountyPercentage.MUL16(proposal.stakes[yes52]).DIV25(100);
        require(stakingToken.TRANSFER74(msg.sender, expirationCallBounty), "transfer to msg.sender failed");
        emit EXPIRATIONCALLBOUNTY13(_proposalId, msg.sender, expirationCallBounty);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    function SETPARAMETERS19(	//inject NONSTANDARD NAMING
        uint[11] calldata _params, //use array here due to stack too deep issue.
        address _voteOnBehalf
    )
    external
    returns(bytes32)
    {
        require(_params[0] <= 100 && _params[0] >= 50, "50 <= queuedVoteRequiredPercentage <= 100");
        require(_params[4] <= 16000 && _params[4] > 1000, "1000 < thresholdConst <= 16000");
        require(_params[7] <= 100, "votersReputationLossRatio <= 100");
        require(_params[2] >= _params[5], "boostedVotePeriodLimit >= quietEndingPeriod");
        require(_params[8] > 0, "minimumDaoBounty should be > 0");
        require(_params[9] > 0, "daoBountyConst should be > 0");

        bytes32 paramsHash = GETPARAMETERSHASH35(_params, _voteOnBehalf);
        //set a limit for power for a given alpha to prevent overflow
        uint256 limitExponent = 172;//for alpha less or equal 2
        uint256 j = 2;
        for (uint256 i = 2000; i < 16000; i = i*2) {
            if ((_params[4] > i) && (_params[4] <= i*2)) {
                limitExponent = limitExponent/j;
                break;
            }
            j++;
        }

        parameters[paramsHash] = Parameters({
            queuedVoteRequiredPercentage: _params[0],
            queuedVotePeriodLimit: _params[1],
            boostedVotePeriodLimit: _params[2],
            preBoostedVotePeriodLimit: _params[3],
            thresholdConst:uint216(_params[4]).FRACTION6(uint216(1000)),
            limitExponentValue:limitExponent,
            quietEndingPeriod: _params[5],
            proposingRepReward: _params[6],
            votersReputationLossRatio:_params[7],
            minimumDaoBounty:_params[8],
            daoBountyConst:_params[9],
            activationTime:_params[10],
            voteOnBehalf:_voteOnBehalf
        });
        return paramsHash;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
     // solhint-disable-next-line function-max-lines,code-complexity
    function REDEEM91(bytes32 _proposalId, address _beneficiary) public returns (uint[3] memory rewards) {	//inject NONSTANDARD NAMING
        Proposal storage proposal = proposals[_proposalId];
        require((proposal.state == ProposalState.Executed)||(proposal.state == ProposalState.ExpiredInQueue),
        "Proposal should be Executed or ExpiredInQueue");
        Parameters memory params = parameters[proposal.paramsHash];
        uint256 lostReputation;
        if (proposal.winningVote == yes52) {
            lostReputation = proposal.preBoostedVotes[no97];
        } else {
            lostReputation = proposal.preBoostedVotes[yes52];
        }
        lostReputation = (lostReputation.MUL16(params.votersReputationLossRatio))/100;
        //as staker
        Staker storage staker = proposal.stakers[_beneficiary];
        if (staker.amount > 0) {
            if (proposal.state == ProposalState.ExpiredInQueue) {
                //Stakes of a proposal that expires in Queue are sent back to stakers
                rewards[0] = staker.amount;
            } else if (staker.vote == proposal.winningVote) {
                uint256 totalWinningStakes = proposal.stakes[proposal.winningVote];
                uint256 totalStakes = proposal.stakes[yes52].ADD40(proposal.stakes[no97]);
                if (staker.vote == yes52) {
                    uint256 _totalStakes =
                    ((totalStakes.MUL16(100 - proposal.expirationCallBountyPercentage))/100) - proposal.daoBounty;
                    rewards[0] = (staker.amount.MUL16(_totalStakes))/totalWinningStakes;
                } else {
                    rewards[0] = (staker.amount.MUL16(totalStakes))/totalWinningStakes;
                    if (organizations[proposal.organizationId] == _beneficiary) {
                          //dao redeem it reward
                        rewards[0] = rewards[0].SUB37(proposal.daoBounty);
                    }
                }
            }
            staker.amount = 0;
        }
        //as voter
        Voter storage voter = proposal.voters[_beneficiary];
        if ((voter.reputation != 0) && (voter.preBoosted)) {
            if (proposal.state == ProposalState.ExpiredInQueue) {
              //give back reputation for the voter
                rewards[1] = ((voter.reputation.MUL16(params.votersReputationLossRatio))/100);
            } else if (proposal.winningVote == voter.vote) {
                uint256 preBoostedVotes = proposal.preBoostedVotes[yes52].ADD40(proposal.preBoostedVotes[no97]);
                rewards[1] = ((voter.reputation.MUL16(params.votersReputationLossRatio))/100)
                .ADD40((voter.reputation.MUL16(lostReputation))/preBoostedVotes);
            }
            voter.reputation = 0;
        }
        //as proposer
        if ((proposal.proposer == _beneficiary)&&(proposal.winningVote == yes52)&&(proposal.proposer != address(0))) {
            rewards[2] = params.proposingRepReward;
            proposal.proposer = address(0);
        }
        if (rewards[0] != 0) {
            proposal.totalStakes = proposal.totalStakes.SUB37(rewards[0]);
            require(stakingToken.TRANSFER74(_beneficiary, rewards[0]), "transfer to beneficiary failed");
            emit REDEEM77(_proposalId, organizations[proposal.organizationId], _beneficiary, rewards[0]);
        }
        if (rewards[1].ADD40(rewards[2]) != 0) {
            votingmachinecallbacksinterface79(proposal.callbacks)
            .MINTREPUTATION65(rewards[1].ADD40(rewards[2]), _beneficiary, _proposalId);
            emit REDEEMREPUTATION31(
            _proposalId,
            organizations[proposal.organizationId],
            _beneficiary,
            rewards[1].ADD40(rewards[2])
            );
        }
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    function REDEEMDAOBOUNTY7(bytes32 _proposalId, address _beneficiary)	//inject NONSTANDARD NAMING
    public
    returns(uint256 redeemedAmount, uint256 potentialAmount) {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.state == ProposalState.Executed);
        uint256 totalWinningStakes = proposal.stakes[proposal.winningVote];
        Staker storage staker = proposal.stakers[_beneficiary];
        if (
            (staker.amount4Bounty > 0)&&
            (staker.vote == proposal.winningVote)&&
            (proposal.winningVote == yes52)&&
            (totalWinningStakes != 0)) {
            //as staker
                potentialAmount = (staker.amount4Bounty * proposal.daoBounty)/totalWinningStakes;
            }
        if ((potentialAmount != 0)&&
            (votingmachinecallbacksinterface79(proposal.callbacks)
            .BALANCEOFSTAKINGTOKEN17(stakingToken, _proposalId) >= potentialAmount)) {
            staker.amount4Bounty = 0;
            proposal.daoBountyRemain = proposal.daoBountyRemain.SUB37(potentialAmount);
            require(
            votingmachinecallbacksinterface79(proposal.callbacks)
            .STAKINGTOKENTRANSFER23(stakingToken, _beneficiary, potentialAmount, _proposalId));
            redeemedAmount = potentialAmount;
            emit REDEEMDAOBOUNTY80(_proposalId, organizations[proposal.organizationId], _beneficiary, redeemedAmount);
        }
    }

                                                                                                                                                                                   
    function SHOULDBOOST32(bytes32 _proposalId) public view returns(bool) {	//inject NONSTANDARD NAMING
        Proposal memory proposal = proposals[_proposalId];
        return (_SCORE65(_proposalId) > THRESHOLD35(proposal.paramsHash, proposal.organizationId));
    }

                                                                                                                                                                                                                                                                                                                                                                                                                    
    function THRESHOLD35(bytes32 _paramsHash, bytes32 _organizationId) public view returns(uint256) {	//inject NONSTANDARD NAMING
        uint256 power = orgBoostedProposalsCnt[_organizationId];
        Parameters storage params = parameters[_paramsHash];

        if (power > params.limitExponentValue) {
            power = params.limitExponentValue;
        }

        return params.thresholdConst.POW66(power);
    }

                                                                           
    function GETPARAMETERSHASH35(	//inject NONSTANDARD NAMING
        uint[11] memory _params,//use array here due to stack too deep issue.
        address _voteOnBehalf
    )
        public
        pure
        returns(bytes32)
        {
        //double call to keccak256 to avoid deep stack issue when call with too many params.
        return keccak256(
            abi.encodePacked(
            keccak256(
            abi.encodePacked(
                _params[0],
                _params[1],
                _params[2],
                _params[3],
                _params[4],
                _params[5],
                _params[6],
                _params[7],
                _params[8],
                _params[9],
                _params[10])
            ),
            _voteOnBehalf
        ));
    }

                                                                                                                                                                                                                                                                 
     // solhint-disable-next-line function-max-lines,code-complexity
    function _EXECUTE0(bytes32 _proposalId) internal VOTABLE14(_proposalId) returns(bool) {	//inject NONSTANDARD NAMING
        Proposal storage proposal = proposals[_proposalId];
        Parameters memory params = parameters[proposal.paramsHash];
        Proposal memory tmpProposal = proposal;
        uint256 totalReputation =
        votingmachinecallbacksinterface79(proposal.callbacks).GETTOTALREPUTATIONSUPPLY93(_proposalId);
        //first divide by 100 to prevent overflow
        uint256 executionBar = (totalReputation/100) * params.queuedVoteRequiredPercentage;
        ExecutionState executionState = ExecutionState.None;
        uint256 averageDownstakesOfBoosted;
        uint256 confidenceThreshold;

        if (proposal.votes[proposal.winningVote] > executionBar) {
         // someone crossed the absolute vote execution bar.
            if (proposal.state == ProposalState.Queued) {
                executionState = ExecutionState.QueueBarCrossed;
            } else if (proposal.state == ProposalState.PreBoosted) {
                executionState = ExecutionState.PreBoostedBarCrossed;
            } else {
                executionState = ExecutionState.BoostedBarCrossed;
            }
            proposal.state = ProposalState.Executed;
        } else {
            if (proposal.state == ProposalState.Queued) {
                // solhint-disable-next-line not-rely-on-time
                if ((now - proposal.times[0]) >= params.queuedVotePeriodLimit) {
                    proposal.state = ProposalState.ExpiredInQueue;
                    proposal.winningVote = no97;
                    executionState = ExecutionState.QueueTimeOut;
                } else {
                    confidenceThreshold = THRESHOLD35(proposal.paramsHash, proposal.organizationId);
                    if (_SCORE65(_proposalId) > confidenceThreshold) {
                        //change proposal mode to PreBoosted mode.
                        proposal.state = ProposalState.PreBoosted;
                        // solhint-disable-next-line not-rely-on-time
                        proposal.times[2] = now;
                        proposal.confidenceThreshold = confidenceThreshold;
                    }
                }
            }

            if (proposal.state == ProposalState.PreBoosted) {
                confidenceThreshold = THRESHOLD35(proposal.paramsHash, proposal.organizationId);
              // solhint-disable-next-line not-rely-on-time
                if ((now - proposal.times[2]) >= params.preBoostedVotePeriodLimit) {
                    if ((_SCORE65(_proposalId) > confidenceThreshold) &&
                        (orgBoostedProposalsCnt[proposal.organizationId] < max_boosted_proposals66)) {
                       //change proposal mode to Boosted mode.
                        proposal.state = ProposalState.Boosted;
                       // solhint-disable-next-line not-rely-on-time
                        proposal.times[1] = now;
                        orgBoostedProposalsCnt[proposal.organizationId]++;
                       //add a value to average -> average = average + ((value - average) / nbValues)
                        averageDownstakesOfBoosted = averagesDownstakesOfBoosted[proposal.organizationId];
                        // solium-disable-next-line indentation
                        averagesDownstakesOfBoosted[proposal.organizationId] =
                            uint256(int256(averageDownstakesOfBoosted) +
                            ((int256(proposal.stakes[no97])-int256(averageDownstakesOfBoosted))/
                            int256(orgBoostedProposalsCnt[proposal.organizationId])));
                    }
                } else { //check the Confidence level is stable
                    uint256 proposalScore = _SCORE65(_proposalId);
                    if (proposalScore <= proposal.confidenceThreshold.MIN92(confidenceThreshold)) {
                        proposal.state = ProposalState.Queued;
                    } else if (proposal.confidenceThreshold > proposalScore) {
                        proposal.confidenceThreshold = confidenceThreshold;
                    }
                }
            }
        }

        if ((proposal.state == ProposalState.Boosted) ||
            (proposal.state == ProposalState.QuietEndingPeriod)) {
            // solhint-disable-next-line not-rely-on-time
            if ((now - proposal.times[1]) >= proposal.currentBoostedVotePeriodLimit) {
                proposal.state = ProposalState.Executed;
                executionState = ExecutionState.BoostedTimeOut;
            }
        }

        if (executionState != ExecutionState.None) {
            if ((executionState == ExecutionState.BoostedTimeOut) ||
                (executionState == ExecutionState.BoostedBarCrossed)) {
                orgBoostedProposalsCnt[tmpProposal.organizationId] =
                orgBoostedProposalsCnt[tmpProposal.organizationId].SUB37(1);
                //remove a value from average = ((average * nbValues) - value) / (nbValues - 1);
                uint256 boostedProposals = orgBoostedProposalsCnt[tmpProposal.organizationId];
                if (boostedProposals == 0) {
                    averagesDownstakesOfBoosted[proposal.organizationId] = 0;
                } else {
                    averageDownstakesOfBoosted = averagesDownstakesOfBoosted[proposal.organizationId];
                    averagesDownstakesOfBoosted[proposal.organizationId] =
                    (averageDownstakesOfBoosted.MUL16(boostedProposals+1).SUB37(proposal.stakes[no97]))/boostedProposals;
                }
            }
            emit EXECUTEPROPOSAL67(
            _proposalId,
            organizations[proposal.organizationId],
            proposal.winningVote,
            totalReputation
            );
            emit GPEXECUTEPROPOSAL49(_proposalId, executionState);
            proposalexecuteinterface9(proposal.callbacks).EXECUTEPROPOSAL85(_proposalId, int(proposal.winningVote));
            proposal.daoBounty = proposal.daoBountyRemain;
        }
        if (tmpProposal.state != proposal.state) {
            emit STATECHANGE55(_proposalId, proposal.state);
        }
        return (executionState != ExecutionState.None);
    }

                                                                                                                                                                                                                                                                         
    function _STAKE17(bytes32 _proposalId, uint256 _vote, uint256 _amount, address _staker) internal returns(bool) {	//inject NONSTANDARD NAMING
        // 0 is not a valid vote.
        require(_vote <= num_of_choices20 && _vote > 0, "wrong vote value");
        require(_amount > 0, "staking amount should be >0");

        if (_EXECUTE0(_proposalId)) {
            return true;
        }
        Proposal storage proposal = proposals[_proposalId];

        if ((proposal.state != ProposalState.PreBoosted) &&
            (proposal.state != ProposalState.Queued)) {
            return false;
        }

        // enable to increase stake only on the previous stake vote
        Staker storage staker = proposal.stakers[_staker];
        if ((staker.amount > 0) && (staker.vote != _vote)) {
            return false;
        }

        uint256 amount = _amount;
        require(stakingToken.TRANSFERFROM94(_staker, address(this), amount), "fail transfer from staker");
        proposal.totalStakes = proposal.totalStakes.ADD40(amount); //update totalRedeemableStakes
        staker.amount = staker.amount.ADD40(amount);
        //This is to prevent average downstakes calculation overflow
        //Note that any how GEN cap is 100000000 ether.
        require(staker.amount <= 0x100000000000000000000000000000000, "staking amount is too high");
        require(proposal.totalStakes <= 0x100000000000000000000000000000000, "total stakes is too high");

        if (_vote == yes52) {
            staker.amount4Bounty = staker.amount4Bounty.ADD40(amount);
        }
        staker.vote = _vote;

        proposal.stakes[_vote] = amount.ADD40(proposal.stakes[_vote]);
        emit STAKE61(_proposalId, organizations[proposal.organizationId], _staker, _vote, _amount);
        return _EXECUTE0(_proposalId);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
     // solhint-disable-next-line function-max-lines,code-complexity
    function INTERNALVOTE44(bytes32 _proposalId, address _voter, uint256 _vote, uint256 _rep) internal returns(bool) {	//inject NONSTANDARD NAMING
        require(_vote <= num_of_choices20 && _vote > 0, "0 < _vote <= 2");
        if (_EXECUTE0(_proposalId)) {
            return true;
        }

        Parameters memory params = parameters[proposals[_proposalId].paramsHash];
        Proposal storage proposal = proposals[_proposalId];

        // Check voter has enough reputation:
        uint256 reputation = votingmachinecallbacksinterface79(proposal.callbacks).REPUTATIONOF100(_voter, _proposalId);
        require(reputation > 0, "_voter must have reputation");
        require(reputation >= _rep, "reputation >= _rep");
        uint256 rep = _rep;
        if (rep == 0) {
            rep = reputation;
        }
        // If this voter has already voted, return false.
        if (proposal.voters[_voter].reputation != 0) {
            return false;
        }
        // The voting itself:
        proposal.votes[_vote] = rep.ADD40(proposal.votes[_vote]);
        //check if the current winningVote changed or there is a tie.
        //for the case there is a tie the current winningVote set to NO.
        if ((proposal.votes[_vote] > proposal.votes[proposal.winningVote]) ||
            ((proposal.votes[no97] == proposal.votes[proposal.winningVote]) &&
            proposal.winningVote == yes52)) {
            if (proposal.state == ProposalState.Boosted &&
            // solhint-disable-next-line not-rely-on-time
                ((now - proposal.times[1]) >= (params.boostedVotePeriodLimit - params.quietEndingPeriod))||
                proposal.state == ProposalState.QuietEndingPeriod) {
                //quietEndingPeriod
                if (proposal.state != ProposalState.QuietEndingPeriod) {
                    proposal.currentBoostedVotePeriodLimit = params.quietEndingPeriod;
                    proposal.state = ProposalState.QuietEndingPeriod;
                }
                // solhint-disable-next-line not-rely-on-time
                proposal.times[1] = now;
            }
            proposal.winningVote = _vote;
        }
        proposal.voters[_voter] = Voter({
            reputation: rep,
            vote: _vote,
            preBoosted:((proposal.state == ProposalState.PreBoosted) || (proposal.state == ProposalState.Queued))
        });
        if ((proposal.state == ProposalState.PreBoosted) || (proposal.state == ProposalState.Queued)) {
            proposal.preBoostedVotes[_vote] = rep.ADD40(proposal.preBoostedVotes[_vote]);
            uint256 reputationDeposit = (params.votersReputationLossRatio.MUL16(rep))/100;
            votingmachinecallbacksinterface79(proposal.callbacks).BURNREPUTATION8(reputationDeposit, _voter, _proposalId);
        }
        emit VOTEPROPOSAL81(_proposalId, organizations[proposal.organizationId], _voter, _vote, rep);
        return _EXECUTE0(_proposalId);
    }

                                                                                                                                                                                                                     
    function _SCORE65(bytes32 _proposalId) internal view returns(uint256) {	//inject NONSTANDARD NAMING
        Proposal storage proposal = proposals[_proposalId];
        //proposal.stakes[NO] cannot be zero as the dao downstake > 0 for each proposal.
        return proposal.stakes[yes52]/proposal.stakes[no97];
    }

                                                                                                                                                            
    function _ISVOTABLE26(bytes32 _proposalId) internal view returns(bool) {	//inject NONSTANDARD NAMING
        ProposalState pState = proposals[_proposalId].state;
        return ((pState == ProposalState.PreBoosted)||
                (pState == ProposalState.Boosted)||
                (pState == ProposalState.QuietEndingPeriod)||
                (pState == ProposalState.Queued)
        );
    }
}

// File: @daostack/infra/contracts/votingMachines/GenesisProtocol.sol

                                                                                          
contract genesisprotocol36 is intvoteinterface31, genesisprotocollogic61 {	//inject NONSTANDARD NAMING
    using ecdsa86 for bytes32;

    // Digest describing the data the user signs according EIP 712.
    // Needs to match what is passed to Metamask.
    bytes32 public constant delegation_hash_eip71264 =	//inject NONSTANDARD NAMING
    keccak256(abi.encodePacked(
    "address GenesisProtocolAddress",
    "bytes32 ProposalId",
    "uint256 Vote",
    "uint256 AmountToStake",
    "uint256 Nonce"
    ));

    mapping(address=>uint256) public stakesNonce; //stakes Nonce

                                       
    constructor(ierc2016 _stakingToken)
    public
    // solhint-disable-next-line no-empty-blocks
    genesisprotocollogic61(_stakingToken) {
    }

                                                                                                                                                                                                                                                                         
    function STAKE3(bytes32 _proposalId, uint256 _vote, uint256 _amount) external returns(bool) {	//inject NONSTANDARD NAMING
        return _STAKE17(_proposalId, _vote, _amount, msg.sender);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function STAKEWITHSIGNATURE10(	//inject NONSTANDARD NAMING
        bytes32 _proposalId,
        uint256 _vote,
        uint256 _amount,
        uint256 _nonce,
        uint256 _signatureType,
        bytes calldata _signature
        )
        external
        returns(bool)
        {
        // Recreate the digest the user signed
        bytes32 delegationDigest;
        if (_signatureType == 2) {
            delegationDigest = keccak256(
                abi.encodePacked(
                    delegation_hash_eip71264, keccak256(
                        abi.encodePacked(
                        address(this),
                        _proposalId,
                        _vote,
                        _amount,
                        _nonce)
                    )
                )
            );
        } else {
            delegationDigest = keccak256(
                        abi.encodePacked(
                        address(this),
                        _proposalId,
                        _vote,
                        _amount,
                        _nonce)
                    ).TOETHSIGNEDMESSAGEHASH91();
        }
        address staker = delegationDigest.RECOVER59(_signature);
        //a garbage staker address due to wrong signature will revert due to lack of approval and funds.
        require(staker != address(0), "staker address cannot be 0");
        require(stakesNonce[staker] == _nonce);
        stakesNonce[staker] = stakesNonce[staker].ADD40(1);
        return _STAKE17(_proposalId, _vote, _amount, staker);
    }

                                                                                                                                                                                                                                                                                                                                                                              
    function VOTE79(bytes32 _proposalId, uint256 _vote, uint256 _amount, address _voter)	//inject NONSTANDARD NAMING
    external
    VOTABLE14(_proposalId)
    returns(bool) {
        Proposal storage proposal = proposals[_proposalId];
        Parameters memory params = parameters[proposal.paramsHash];
        address voter;
        if (params.voteOnBehalf != address(0)) {
            require(msg.sender == params.voteOnBehalf);
            voter = _voter;
        } else {
            voter = msg.sender;
        }
        return INTERNALVOTE44(_proposalId, voter, _vote, _amount);
    }

                                                                                                                                                                                                                 
    function CANCELVOTE62(bytes32 _proposalId) external VOTABLE14(_proposalId) {	//inject NONSTANDARD NAMING
       //this is not allowed
        return;
    }

                                                                                                                                                                                                                                                                 
    function EXECUTE34(bytes32 _proposalId) external VOTABLE14(_proposalId) returns(bool) {	//inject NONSTANDARD NAMING
        return _EXECUTE0(_proposalId);
    }

                                                                                                                                                        
    function GETNUMBEROFCHOICES23(bytes32) external view returns(uint256) {	//inject NONSTANDARD NAMING
        return num_of_choices20;
    }

                                                                                                                                                                     
    function GETPROPOSALTIMES43(bytes32 _proposalId) external view returns(uint[3] memory times) {	//inject NONSTANDARD NAMING
        return proposals[_proposalId].times;
    }

                                                                                                                                                                                                                                                                                                                                                                 
    function VOTEINFO83(bytes32 _proposalId, address _voter) external view returns(uint, uint) {	//inject NONSTANDARD NAMING
        Voter memory voter = proposals[_proposalId].voters[_voter];
        return (voter.vote, voter.reputation);
    }

                                                                                                                                                                                                                                                        
    function VOTESTATUS55(bytes32 _proposalId, uint256 _choice) external view returns(uint256) {	//inject NONSTANDARD NAMING
        return proposals[_proposalId].votes[_choice];
    }

                                                                                                                                                     
    function ISVOTABLE72(bytes32 _proposalId) external view returns(bool) {	//inject NONSTANDARD NAMING
        return _ISVOTABLE26(_proposalId);
    }

                                                                                                                                                                                                                                                                                                               
    function PROPOSALSTATUS51(bytes32 _proposalId) external view returns(uint256, uint256, uint256, uint256) {	//inject NONSTANDARD NAMING
        return (
                proposals[_proposalId].preBoostedVotes[yes52],
                proposals[_proposalId].preBoostedVotes[no97],
                proposals[_proposalId].stakes[yes52],
                proposals[_proposalId].stakes[no97]
        );
    }

                                                                                                                                                                                            
    function GETPROPOSALORGANIZATION83(bytes32 _proposalId) external view returns(bytes32) {	//inject NONSTANDARD NAMING
        return (proposals[_proposalId].organizationId);
    }

                                                                                                                                                                                                                                                          
    function GETSTAKER73(bytes32 _proposalId, address _staker) external view returns(uint256, uint256) {	//inject NONSTANDARD NAMING
        return (proposals[_proposalId].stakers[_staker].vote, proposals[_proposalId].stakers[_staker].amount);
    }

                                                                                                                                                                                                                    
    function VOTESTAKE72(bytes32 _proposalId, uint256 _vote) external view returns(uint256) {	//inject NONSTANDARD NAMING
        return proposals[_proposalId].stakes[_vote];
    }

                                                                                                                                                               
    function WINNINGVOTE73(bytes32 _proposalId) external view returns(uint256) {	//inject NONSTANDARD NAMING
        return proposals[_proposalId].winningVote;
    }

                                                                                                                                                                          
    function STATE40(bytes32 _proposalId) external view returns(ProposalState) {	//inject NONSTANDARD NAMING
        return proposals[_proposalId].state;
    }

                                                                                                                        
    function ISABSTAINALLOW86() external pure returns(bool) {	//inject NONSTANDARD NAMING
        return false;
    }

                                                                                                                                                                                                             
    function GETALLOWEDRANGEOFCHOICES7() external pure returns(uint256 min, uint256 max) {	//inject NONSTANDARD NAMING
        return (yes52, no97);
    }

                                                                                                                                                   
    function SCORE19(bytes32 _proposalId) public view returns(uint256) {	//inject NONSTANDARD NAMING
        return  _SCORE65(_proposalId);
    }
}

// File: /Users/oren/daostack/daostack2/daostack/contracts/votingMachines/VotingMachineCallbacks.sol

contract votingmachinecallbacks93 is votingmachinecallbacksinterface79 {	//inject NONSTANDARD NAMING

    struct ProposalInfo {
        uint256 blockNumber; // the proposal's block number
        avatar70 avatar; // the proposal's avatar
        address votingMachine;
    }

    modifier ONLYVOTINGMACHINE57(bytes32 _proposalId) {	//inject NONSTANDARD NAMING
        require(msg.sender == proposalsInfo[_proposalId].votingMachine, "only VotingMachine");
        _;
    }

            //proposalId ->     ProposalInfo
    mapping(bytes32      =>     ProposalInfo    ) public proposalsInfo;

    function MINTREPUTATION65(uint256 _amount, address _beneficiary, bytes32 _proposalId)	//inject NONSTANDARD NAMING
    external
    ONLYVOTINGMACHINE57(_proposalId)
    returns(bool)
    {
        avatar70 avatar = proposalsInfo[_proposalId].avatar;
        if (avatar == avatar70(0)) {
            return false;
        }
        return controllerinterface59(avatar.OWNER8()).MINTREPUTATION65(_amount, _beneficiary, address(avatar));
    }

    function BURNREPUTATION8(uint256 _amount, address _beneficiary, bytes32 _proposalId)	//inject NONSTANDARD NAMING
    external
    ONLYVOTINGMACHINE57(_proposalId)
    returns(bool)
    {
        avatar70 avatar = proposalsInfo[_proposalId].avatar;
        if (avatar == avatar70(0)) {
            return false;
        }
        return controllerinterface59(avatar.OWNER8()).BURNREPUTATION8(_amount, _beneficiary, address(avatar));
    }

    function STAKINGTOKENTRANSFER23(	//inject NONSTANDARD NAMING
        ierc2016 _stakingToken,
        address _beneficiary,
        uint256 _amount,
        bytes32 _proposalId)
    external
    ONLYVOTINGMACHINE57(_proposalId)
    returns(bool)
    {
        avatar70 avatar = proposalsInfo[_proposalId].avatar;
        if (avatar == avatar70(0)) {
            return false;
        }
        return controllerinterface59(avatar.OWNER8()).EXTERNALTOKENTRANSFER67(_stakingToken, _beneficiary, _amount, avatar);
    }

    function BALANCEOFSTAKINGTOKEN17(ierc2016 _stakingToken, bytes32 _proposalId) external view returns(uint256) {	//inject NONSTANDARD NAMING
        avatar70 avatar = proposalsInfo[_proposalId].avatar;
        if (proposalsInfo[_proposalId].avatar == avatar70(0)) {
            return 0;
        }
        return _stakingToken.BALANCEOF62(address(avatar));
    }

    function GETTOTALREPUTATIONSUPPLY93(bytes32 _proposalId) external view returns(uint256) {	//inject NONSTANDARD NAMING
        ProposalInfo memory proposal = proposalsInfo[_proposalId];
        if (proposal.avatar == avatar70(0)) {
            return 0;
        }
        return proposal.avatar.nativeReputation().TOTALSUPPLYAT94(proposal.blockNumber);
    }

    function REPUTATIONOF100(address _owner, bytes32 _proposalId) external view returns(uint256) {	//inject NONSTANDARD NAMING
        ProposalInfo memory proposal = proposalsInfo[_proposalId];
        if (proposal.avatar == avatar70(0)) {
            return 0;
        }
        return proposal.avatar.nativeReputation().BALANCEOFAT72(_owner, proposal.blockNumber);
    }
}

// File: contracts/universalSchemes/GenericScheme.sol

                                                                                                                                                                             
contract genericscheme3 is universalscheme48, votingmachinecallbacks93, proposalexecuteinterface9 {	//inject NONSTANDARD NAMING
    event NEWCALLPROPOSAL18(	//inject NONSTANDARD NAMING
        address indexed _avatar,
        bytes32 indexed _proposalId,
        bytes   _callData,
        string  _descriptionHash
    );

    event PROPOSALEXECUTED2(	//inject NONSTANDARD NAMING
        address indexed _avatar,
        bytes32 indexed _proposalId,
        bytes _genericCallReturnValue
    );

    event PROPOSALEXECUTEDBYVOTINGMACHINE53(	//inject NONSTANDARD NAMING
        address indexed _avatar,
        bytes32 indexed _proposalId,
        int256 _param
    );

    event PROPOSALDELETED34(address indexed _avatar, bytes32 indexed _proposalId);	//inject NONSTANDARD NAMING

    // Details of a voting proposal:
    struct CallProposal {
        bytes callData;
        bool exist;
        bool passed;
    }

    // A mapping from the organization (Avatar) address to the saved data of the organization:
    mapping(address=>mapping(bytes32=>CallProposal)) public organizationsProposals;

    struct Parameters {
        intvoteinterface31 intVote;
        bytes32 voteParams;
        address contractToCall;
    }

    // A mapping from hashes to parameters (use to store a particular configuration on the controller)
    mapping(bytes32=>Parameters) public parameters;

                                                                                                                                                                                                                                                                                                
    function EXECUTEPROPOSAL85(bytes32 _proposalId, int256 _decision)	//inject NONSTANDARD NAMING
    external
    ONLYVOTINGMACHINE57(_proposalId)
    returns(bool) {
        avatar70 avatar = proposalsInfo[_proposalId].avatar;
        CallProposal storage proposal = organizationsProposals[address(avatar)][_proposalId];
        require(proposal.exist, "must be a live proposal");
        require(proposal.passed == false, "cannot execute twice");

        if (_decision == 1) {
            proposal.passed = true;
            EXECUTE34(_proposalId);
        } else {
            delete organizationsProposals[address(avatar)][_proposalId];
            emit PROPOSALDELETED34(address(avatar), _proposalId);
        }

        emit PROPOSALEXECUTEDBYVOTINGMACHINE53(address(avatar), _proposalId, _decision);
        return true;
    }

                                                                                                                                                                    
    function EXECUTE34(bytes32 _proposalId) public {	//inject NONSTANDARD NAMING
        avatar70 avatar = proposalsInfo[_proposalId].avatar;
        Parameters memory params = parameters[GETPARAMETERSFROMCONTROLLER72(avatar)];
        CallProposal storage proposal = organizationsProposals[address(avatar)][_proposalId];
        require(proposal.exist, "must be a live proposal");
        require(proposal.passed, "proposal must passed by voting machine");
        proposal.exist = false;
        bytes memory genericCallReturnValue;
        bool success;
        controllerinterface59 controller = controllerinterface59(avatar70(avatar).OWNER8());
        (success, genericCallReturnValue) = controller.GENERICCALL24(params.contractToCall, proposal.callData, avatar);
        if (success) {
            delete organizationsProposals[address(avatar)][_proposalId];
            emit PROPOSALDELETED34(address(avatar), _proposalId);
            emit PROPOSALEXECUTED2(address(avatar), _proposalId, genericCallReturnValue);
        } else {
            proposal.exist = true;
        }
    }

                                                                                                                                                                                                                                           
    function SETPARAMETERS19(	//inject NONSTANDARD NAMING
        bytes32 _voteParams,
        intvoteinterface31 _intVote,
        address _contractToCall
    ) public returns(bytes32)
    {
        bytes32 paramsHash = GETPARAMETERSHASH35(_voteParams, _intVote, _contractToCall);
        parameters[paramsHash].voteParams = _voteParams;
        parameters[paramsHash].intVote = _intVote;
        parameters[paramsHash].contractToCall = _contractToCall;
        return paramsHash;
    }

                                                                                                                                                                                                                   
    function GETPARAMETERSHASH35(	//inject NONSTANDARD NAMING
        bytes32 _voteParams,
        intvoteinterface31 _intVote,
        address _contractToCall
    ) public pure returns(bytes32)
    {
        return keccak256(abi.encodePacked(_voteParams, _intVote, _contractToCall));
    }

                                                                                                                                                                                                                                                                                                                                            
    function PROPOSECALL64(avatar70 _avatar, bytes memory _callData, string memory _descriptionHash)	//inject NONSTANDARD NAMING
    public
    returns(bytes32)
    {
        Parameters memory params = parameters[GETPARAMETERSFROMCONTROLLER72(_avatar)];
        intvoteinterface31 intVote = params.intVote;

        bytes32 proposalId = intVote.PROPOSE48(2, params.voteParams, msg.sender, address(_avatar));

        organizationsProposals[address(_avatar)][proposalId] = CallProposal({
            callData: _callData,
            exist: true,
            passed: false
        });
        proposalsInfo[proposalId] = ProposalInfo({
            blockNumber:block.number,
            avatar:_avatar,
            votingMachine:address(params.intVote)
        });
        emit NEWCALLPROPOSAL18(address(_avatar), proposalId, _callData, _descriptionHash);
        return proposalId;
    }

                                                                                                                                                                                                                                                          
    function GETCONTRACTTOCALL27(avatar70 _avatar) public view returns(address) {	//inject NONSTANDARD NAMING
        return parameters[GETPARAMETERSFROMCONTROLLER72(_avatar)].contractToCall;
    }

}