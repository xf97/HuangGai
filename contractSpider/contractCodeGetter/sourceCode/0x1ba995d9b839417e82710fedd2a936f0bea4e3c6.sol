/**
 *Submitted for verification at Etherscan.io on 2020-08-05
*/

pragma solidity ^0.6.6;

contract ImitationGame {
    
    uint entropy;
    function getRandomNumber() internal returns (uint){
        entropy = uint(keccak256(abi.encodePacked(now, msg.sender, blockhash(block.number - 1), entropy)));
        return entropy;
    }
    
    uint public maxValue = 2**256-1;
    
    uint public schedule;
    uint public period = 28 days;
    uint public hour;
    
    struct Reg {
        bool rank;
        uint id;
        bool[] signatures;
        bool verified;
    }
    
    mapping (uint => mapping (address => Reg)) public registry;
    mapping (uint => address[]) public shuffler;
    mapping (uint => mapping (uint => bool[2])) public completed;
    mapping (uint => mapping (uint => bool)) public disputed;

    mapping (uint => uint) public population;
    mapping (uint => mapping (address => uint)) public proofOfPersonhood;
    mapping (uint => mapping (uint => address)) public personhoodIndex;
    
    mapping (uint => mapping (address => uint)) public immigrationToken;
    mapping (uint => mapping (address => mapping (address => uint))) public delegatedImmigrationToken;
    mapping (uint => mapping (address => uint)) public registrationToken;
    mapping (uint => mapping (address => mapping (address => uint))) public delegatedRegistrationToken;
    mapping (uint => mapping (address => uint)) public verificationToken;
    mapping (uint => mapping (address => mapping (address => uint))) public delegatedVerificationToken;

    function pseudonymEvent() public view returns (uint) { return schedule + period + hour * 3600; }
    modifier scheduler() {
        if(block.timestamp > pseudonymEvent()) {
            schedule += period;
            hour = getRandomNumber()%24;
        }
        _;
    }
    function getSchedule() public scheduler returns (uint) { return schedule; }    

    function register() public scheduler {
        require(registry[schedule][msg.sender].id == 0 && registrationToken[schedule][msg.sender] >= 1);
        registrationToken[schedule][msg.sender]--;
        uint id = 1;
        if(shuffler[schedule].length != 0) {
            id += getRandomNumber() % shuffler[schedule].length;
            shuffler[schedule].push(shuffler[schedule][id-1]);
            registry[schedule][shuffler[schedule][id-1]].id = shuffler[schedule].length;
        }
        else shuffler[schedule].push();

        shuffler[schedule][id-1] = msg.sender;
        registry[schedule][msg.sender] = Reg(true, id, new bool[](1), false);

        immigrationToken[schedule+period][msg.sender]++;
    }
    function immigrate() public scheduler {
        require(registry[schedule][msg.sender].id == 0 && immigrationToken[schedule][msg.sender] >= 1);
        immigrationToken[schedule][msg.sender]--;
        registry[schedule][msg.sender] = Reg(false, 1 + getRandomNumber()%maxValue, new bool[](2), false);
        immigrationToken[schedule][shuffler[schedule-period][getRandomNumber()%shuffler[schedule-period].length]]++;
    }
    function transferRegistrationKey(address _to) public scheduler {
        require(registry[schedule][msg.sender].id != 0 && registry[schedule][_to].id == 0);
        if(registry[schedule][msg.sender].rank == true) shuffler[schedule][registry[schedule][msg.sender].id-1] = _to;
        registry[schedule][_to] = registry[schedule][msg.sender];
        delete registry[schedule][msg.sender];
    }
    function pairVerified(uint _pair) public view returns (bool) {
        return (completed[schedule-period][_pair][0] == true && completed[schedule-period][_pair][1] == true);
    }
    function dispute() public scheduler {
        require(registry[schedule-period][msg.sender].rank == true);
        uint pair = (1 + registry[schedule-period][msg.sender].id)/2;
        require(!pairVerified(pair));
        disputed[schedule-period][pair] = true;
    }
    function getPair(address _account) public view returns (uint) {
        if(registry[schedule-period][_account].rank == true) return (1 + registry[schedule-period][_account].id)/2;
        return 1 + registry[schedule-period][msg.sender].id%(shuffler[schedule-period].length/2);
    }    
    function reassign() public scheduler {
        require(disputed[schedule-period][getPair(msg.sender)] == true);
        delete registry[schedule-period][msg.sender];
        registry[schedule-period][msg.sender] = Reg(false, 1 + getRandomNumber()%maxValue, new bool[](2), false);
    }
    function lockProofOfPersonhood() public scheduler {
        require(verificationToken[schedule][msg.sender] >= 1);
        require(proofOfPersonhood[schedule][msg.sender] == 0);
        verificationToken[schedule][msg.sender]--;
        population[schedule]++;
        proofOfPersonhood[schedule][msg.sender] = population[schedule];
        personhoodIndex[schedule][population[schedule]] = msg.sender;
    }
    function transferPersonhoodKey(address _to) public scheduler {
        require(proofOfPersonhood[schedule][_to] == 0 && _to != msg.sender);
        proofOfPersonhood[schedule][_to] = proofOfPersonhood[schedule][msg.sender];
        personhoodIndex[schedule][proofOfPersonhood[schedule][msg.sender]] = _to;
        delete proofOfPersonhood[schedule][msg.sender];
    }
    function collectPersonhood() public scheduler {
        require(registry[schedule-period][msg.sender].verified = false);
        require(pairVerified(getPair(msg.sender)) == true);
        if(registry[schedule-period][msg.sender].rank == false) {
            require(registry[schedule-period][msg.sender].signatures[0] == true && registry[schedule-period][msg.sender].signatures[1] == true);
        }
        registrationToken[schedule][msg.sender]++;
        verificationToken[schedule][msg.sender]++;
        registry[schedule-period][msg.sender].verified = true;
    }
    function verify(address _account, address _signer) internal {
        require(_account != _signer && registry[schedule-period][_signer].rank == true);
        uint pair = getPair(_account);
        require(disputed[schedule-period][pair] == false && pair == getPair(_signer));
        uint peer = registry[schedule-period][_signer].id%2;
        if(registry[schedule-period][_account].rank == true) {
            registry[schedule-period][_account].signatures[0] = true;
            completed[schedule-period][pair][peer] = true;
        }
        else registry[schedule-period][_account].signatures[peer] = true;
    }
    function verifyAccount(address _account) public scheduler {
	    verify(_account, msg.sender);
    }
    function uploadSignature(address _account, bytes memory _signature) public scheduler {

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(_signature,0x20))
            s := mload(add(_signature,0x40))
            v := and(mload(add(_signature, 0x41)), 0xFF)
        }
        if (v < 27) v += 27;

        bytes32 msgHash = keccak256(abi.encodePacked(_account, schedule-period));

        verify(_account, ecrecover(msgHash, v, r, s));
    }
    function transferImmigrationToken(address _to, uint _value) public scheduler { 
        require(immigrationToken[schedule][msg.sender] >= _value);
        immigrationToken[schedule][msg.sender] -= _value;
        immigrationToken[schedule][_to] += _value;        
    }
    function transferRegistrationToken(address _to, uint _value) public scheduler { 
        require(registrationToken[schedule][msg.sender] >= _value);
        registrationToken[schedule][msg.sender] -= _value;
        registrationToken[schedule][_to] += _value;        
    }
    function transferVerificationToken(address _to, uint _value) public scheduler { 
        require(verificationToken[schedule][msg.sender] >= _value);
        verificationToken[schedule][msg.sender] -= _value;
        verificationToken[schedule][_to] += _value;        
    }
    function delegateImmigrationToken(address _spender, uint _value) public scheduler {
        delegatedImmigrationToken[schedule][msg.sender][_spender] = _value;
    }
    function delegateRegistrationToken(address _spender, uint _value) public scheduler {
        delegatedRegistrationToken[schedule][msg.sender][_spender] = _value;
    }
    function delegateVerificationToken(address _spender, uint _value) public scheduler {
        delegatedVerificationToken[schedule][msg.sender][_spender] = _value;
    }
    function collectImmigrationToken(address _from, address _to, uint _value) public scheduler {
        require(delegatedImmigrationToken[schedule][_from][msg.sender] >= _value);
        require(immigrationToken[schedule][_from] >= _value);
        immigrationToken[schedule][_from] -= _value;
        immigrationToken[schedule][_to] += _value;    
        delegatedImmigrationToken[schedule][_from][msg.sender] -= _value;
    }
    function collectRegistrationToken(address _from, address _to, uint _value) public scheduler {
        require(delegatedRegistrationToken[schedule][_from][msg.sender] >= _value);
        require(registrationToken[schedule][_from] >= _value);
        registrationToken[schedule][_from] -= _value;
        registrationToken[schedule][_to] += _value;    
        delegatedRegistrationToken[schedule][_from][msg.sender] -= _value;
    }
    function collectVerificationToken(address _from, address _to, uint _value) public scheduler {
        require(delegatedVerificationToken[schedule][_from][msg.sender] >= _value);
        require(verificationToken[schedule][_from] >= _value);
        verificationToken[schedule][_from] -= _value;
        verificationToken[schedule][_to] += _value;    
        delegatedVerificationToken[schedule][_from][msg.sender] -= _value;
    }
    function initiateNetwork() public scheduler {
        require(shuffler[schedule-period].length < 2);
        schedule = 198000 + ((block.timestamp - 198000)/ 7 days) * 7 days - 21 days;
        registrationToken[schedule][msg.sender] = maxValue;
        shuffler[schedule-period] = new address[](2);
    }
}