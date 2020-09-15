pragma solidity ^0.6.0;

import "./IMVDProxy.sol";
import "./IMVDFunctionalityProposalManager.sol";
import "./IMVDFunctionalityProposal.sol";
import "./IStateHolder.sol";
import "./IERC20.sol";
import "./IVotingToken.sol";
import "./IMVDFunctionalityModelsManager.sol";
import "./ICommonUtilities.sol";
import "./IMVDFunctionalitiesManager.sol";

contract MVDProxy is IMVDProxy {

    /*address private _token;
    address private _functionalityProposalManagerAddress;
    address private _stateHolderAddress;
    address private _functionalityModelsManagerAddress;
    address private _functionalitiesManagerAddress;*/

    address[] private _delegates;

    constructor(address votingTokenAddress, address stateHolderAddress, address functionalityModelsManagerAddress, address functionalityProposalManagerAddress, address functionalitiesManagerAddress) public {
        if(votingTokenAddress == address(0)) {
            return;
        }
        init(votingTokenAddress, stateHolderAddress, functionalityModelsManagerAddress, functionalityProposalManagerAddress, functionalitiesManagerAddress);
    }

    function init(address votingTokenAddress, address stateHolderAddress, address functionalityModelsManagerAddress, address functionalityProposalManagerAddress, address functionalitiesManagerAddress) public override {

        require(_delegates.length == 0, "Init already called!");

        _delegates = new address[](5);

        IVotingToken(_delegates[0] = votingTokenAddress).setProxy();

        IMVDFunctionalityProposalManager(_delegates[1] = functionalityProposalManagerAddress).setProxy();

        IStateHolder(_delegates[2] = stateHolderAddress).setProxy();

        _delegates[3] = functionalityModelsManagerAddress;

        IMVDFunctionalitiesManager(_delegates[4] = functionalitiesManagerAddress).setProxy();

        raiseFunctionalitySetEvent("getMinimumBlockNumberForSurvey");
        raiseFunctionalitySetEvent("getMinimumBlockNumberForEmergencySurvey");
        raiseFunctionalitySetEvent("getEmergencySurveyStaking");
        raiseFunctionalitySetEvent("checkSurveyResult");
        raiseFunctionalitySetEvent("onNewProposal");
    }

    function raiseFunctionalitySetEvent(string memory codeName) private {
        (address addr, uint256 position,) = IMVDFunctionalitiesManager(_delegates[4]).getFunctionalityData(codeName);
        if(addr != address(0)) {
            emit FunctionalitySet(codeName, position, address(0), "", address(0), false, "", false, false, address(0), 0);
        }
    }

    receive() external payable {
        if(msg.value > 0) {
            emit PaymentReceived(msg.sender, msg.value);
        }
    }

    function setDelegate(uint256 position, address newAddress) private returns(address oldAddress) {
        require(isAuthorizedFunctionality(msg.sender), "Unauthorized action!");
        require(newAddress != address(0), "Cannot set void address!");
        oldAddress = _delegates[position];
        _delegates[position] = newAddress;
        if(position != 3) {
            IMVDProxyDelegate(oldAddress).setProxy();
            IMVDProxyDelegate(newAddress).setProxy();
        }
    }

    function getToken() public override view returns(address) {
        return _delegates[0];
    }

    function setToken(address newAddress) public override {
        emit TokenChanged(setDelegate(0, newAddress), newAddress);
    }

    function getMVDFunctionalityProposalManagerAddress() public override view returns(address) {
        return _delegates[1];
    }

    function setMVDFunctionalityProposalManagerAddress(address newAddress) public override {
        emit MVDFunctionalityProposalManagerChanged(setDelegate(1, newAddress), newAddress);
    }

    function getStateHolderAddress() public override view returns(address) {
        return _delegates[2];
    }

    function setStateHolderAddress(address newAddress) public override {
        emit StateHolderChanged(setDelegate(2, newAddress), newAddress);
    }

    function getMVDFunctionalityModelsManagerAddress() public override view returns(address) {
        return _delegates[3];
    }

    function setMVDFunctionalityModelsManagerAddress(address newAddress) public override {
        emit MVDFunctionalityModelsManagerChanged(setDelegate(3, newAddress), newAddress);
    }

    function getMVDFunctionalitiesManagerAddress() public override view returns(address) {
        return _delegates[4];
    }

    function setMVDFunctionalitiesManagerAddress(address newAddress) public override {
        emit MVDFunctionalitiesManagerChanged(setDelegate(4, newAddress), newAddress);
    }

    function changeProxy(address payable newAddress) public override payable {
        require(isAuthorizedFunctionality(msg.sender), "Unauthorized action!");
        require(newAddress != address(0), "Cannot set void address!");
        newAddress.transfer(msg.value);
        IERC20 votingToken = IERC20(_delegates[0]);
        votingToken.transfer(newAddress, votingToken.balanceOf(address(this)));
        IMVDProxyDelegate(_delegates[0]).setProxy();
        IMVDProxyDelegate(_delegates[1]).setProxy();
        IMVDProxyDelegate(_delegates[2]).setProxy();
        IMVDProxyDelegate(_delegates[4]).setProxy();
        IMVDProxy(newAddress).init(_delegates[0], _delegates[2], _delegates[3], _delegates[1], _delegates[4]);
        _delegates = new address[](0);
        emit ProxyChanged(newAddress);
    }

    function getFunctionalitiesAmount() public override view returns(uint256) {
        return IMVDFunctionalitiesManager(_delegates[4]).getFunctionalitiesAmount();
    }

    function isValidProposal(address proposal) public override view returns (bool) {
        return IMVDFunctionalityProposalManager(_delegates[1]).isValidProposal(proposal);
    }

    function isValidFunctionality(address functionality) public override view returns(bool) {
        return IMVDFunctionalitiesManager(_delegates[4]).isValidFunctionality(functionality);
    }

    function isAuthorizedFunctionality(address functionality) public override view returns(bool) {
        return IMVDFunctionalitiesManager(_delegates[4]).isAuthorizedFunctionality(functionality);
    }

    function getFunctionalityAddress(string memory codeName) public override view returns(address location) {
        (location,,) = IMVDFunctionalitiesManager(_delegates[4]).getFunctionalityData(codeName);
    }

    function hasFunctionality(string memory codeName) public override view returns(bool) {
        return IMVDFunctionalitiesManager(_delegates[4]).hasFunctionality(codeName);
    }

    function functionalitiesToJSON() public override view returns(string memory functionsJSONArray) {
        return IMVDFunctionalitiesManager(_delegates[4]).functionalitiesToJSON();
    }

    function functionalitiesToJSON(uint256 start, uint256 l) public override view returns(string memory functionsJSONArray) {
        return IMVDFunctionalitiesManager(_delegates[4]).functionalitiesToJSON(start, l);
    }

    function getPendingProposal(string memory codeName) public override view returns(address proposalAddress, bool isReallyPending) {
        (proposalAddress, isReallyPending) = IMVDFunctionalityProposalManager(_delegates[1]).getPendingProposal(codeName);
    }

    function newProposal(string memory codeName, bool emergency, address sourceLocation, uint256 sourceLocationId, address location, bool submitable, string memory methodSignature, string memory returnAbiParametersArray, bool isInternal, bool needsSender, string memory replaces) public override returns(address proposalAddress) {
        emergencyBehavior(emergency);

        IMVDFunctionalityModelsManager(_delegates[3]).checkWellKnownFunctionalities(codeName, submitable, methodSignature, returnAbiParametersArray, isInternal, needsSender, replaces);

        IMVDFunctionalityProposal proposal = IMVDFunctionalityProposal(proposalAddress = IMVDFunctionalityProposalManager(_delegates[1]).newProposal(codeName, location, methodSignature, returnAbiParametersArray, replaces));
        proposal.setCollateralData(emergency, sourceLocation, sourceLocationId, submitable, isInternal, needsSender, msg.sender);

        IMVDFunctionalitiesManager functionalitiesManager = IMVDFunctionalitiesManager(_delegates[4]);
        (address loc, , string memory meth) = functionalitiesManager.getFunctionalityData("onNewProposal");
        if(location != address(0)) {
            functionalitiesManager.setCallingContext(location);
            (bool response,) = loc.call(abi.encodeWithSignature(meth, proposalAddress));
            functionalitiesManager.clearCallingContext();
            require(response, "New Proposal check failed!");
        }

        if(!hasFunctionality("startProposal") || !hasFunctionality("disableProposal")) {
            proposal.start();
        }

        emit Proposal(proposalAddress);
    }

    function emergencyBehavior(bool emergency) private {
        if(!emergency) {
            return;
        }
        (address loc, , string memory meth) = IMVDFunctionalitiesManager(_delegates[4]).getFunctionalityData("getEmergencySurveyStaking");
        (, bytes memory payload) = loc.staticcall(abi.encodeWithSignature(meth));
        uint256 staking = toUint256(payload);
        if(staking > 0) {
            IERC20(_delegates[0]).transferFrom(msg.sender, address(this), staking);
        }
    }

    function startProposal(address proposalAddress) public override {
        require(isAuthorizedFunctionality(msg.sender), "Unauthorized action!");
        (address location, ,) = IMVDFunctionalitiesManager(_delegates[4]).getFunctionalityData("startProposal");
        require(location == msg.sender, "Only startProposal Functionality can enable a delayed proposal");
        require(isValidProposal(proposalAddress), "Invalid Proposal Address!");
        IMVDFunctionalityProposal(proposalAddress).start();
    }

    function disableProposal(address proposalAddress) public override {
        require(isAuthorizedFunctionality(msg.sender), "Unauthorized action!");
        (address location, ,) = IMVDFunctionalitiesManager(_delegates[4]).getFunctionalityData("disableProposal");
        require(location == msg.sender, "Only disableProposal Functionality can disable a delayed proposal");
        IMVDFunctionalityProposal(proposalAddress).disable();
        IMVDFunctionalityProposalManager(_delegates[1]).disableProposal(proposalAddress);
    }

    function transfer(address receiver, uint256 value, address token) public override {
        require(isAuthorizedFunctionality(msg.sender), "Only functionalities can transfer Proxy balances!");
        if(value == 0) {
            return;
        }
        if(token == address(0)) {
            payable(receiver).transfer(value);
            return;
        }
        IERC20(token).transfer(receiver, value);
    }

    function setProposal() public override {

        IMVDFunctionalityProposalManager(_delegates[1]).checkProposal(msg.sender);

        IMVDFunctionalitiesManager functionalitiesManager = IMVDFunctionalitiesManager(_delegates[4]);

        (address addressToCall, , string memory methodSignature) = functionalitiesManager.getFunctionalityData("checkSurveyResult");

        (bool result, bytes memory response) = addressToCall.staticcall(abi.encodeWithSignature(methodSignature, msg.sender));

        result = toUint256(response) > 0;

        IMVDFunctionalityProposal proposal = IMVDFunctionalityProposal(msg.sender);
        proposal.set();

        (addressToCall, , methodSignature) = functionalitiesManager.getFunctionalityData("proposalEnd");
        if(addressToCall != address(0)) {
            functionalitiesManager.setCallingContext(addressToCall);
            addressToCall.call(abi.encodeWithSignature(methodSignature, msg.sender, result));
            functionalitiesManager.clearCallingContext();
        }

        emit ProposalSet(msg.sender, result);

        if(!result) {
            return;
        }

        if(proposal.isEmergency()) {
            (addressToCall, , methodSignature) = functionalitiesManager.getFunctionalityData("getEmergencySurveyStaking");
            (, response) = addressToCall.staticcall(abi.encodeWithSignature(methodSignature));
            uint256 staking = toUint256(response);
            if(staking > 0) {
                IERC20(_delegates[0]).transfer(proposal.getProposer(), staking);
            }
        }

        functionalitiesManager.setupFunctionality(msg.sender);
    }

    function read(string memory codeName, bytes memory data) public override view returns(bytes memory returnData) {

        (address location, bytes memory payload) = IMVDFunctionalitiesManager(_delegates[4]).preConditionCheck(codeName, data, 0, msg.sender, 0);

        bool ok;
        (ok, returnData) = location.staticcall(payload);

        require(ok, "Failed to read from functionality");
    }

    function submit(string memory codeName, bytes memory data) public override payable returns(bytes memory returnData) {
        IMVDFunctionalitiesManager manager = IMVDFunctionalitiesManager(_delegates[4]);
        (address location, bytes memory payload) = manager.preConditionCheck(codeName, data, 1, msg.sender, msg.value);

        bool changed = manager.setCallingContext(location);

        bool ok;
        (ok, returnData) = location.call(payload);

        if(changed) {
            manager.clearCallingContext();
        }
        require(ok, "Failed to submit functionality");
    }

    function callFromManager(address location, bytes memory payload) public override returns(bool, bytes memory) {
        require(msg.sender == _delegates[4], "Only Manager can call this!");
        return location.call(payload);
    }

    function emitFromManager(string memory codeName, uint256 position, address proposal, string memory replaced, address location, bool submitable, string memory methodSignature, bool isInternal, bool needsSender, address proposalAddress, uint256 replacedPosition) public override {
        require(msg.sender == _delegates[4], "Only Manager can call this!");
        emit FunctionalitySet(codeName, position, proposal, replaced, location, submitable, methodSignature, isInternal, needsSender, proposalAddress, replacedPosition);
    }

    function emitEvent(string memory eventSignature, bytes memory firstIndex, bytes memory secondIndex, bytes memory data) public override {
        require(isAuthorizedFunctionality(msg.sender), "Only authorized functionalities can emit events!");
        emit Event(eventSignature, keccak256(firstIndex), keccak256(secondIndex), data);
    }

    function compareStrings(string memory a, string memory b) private pure returns(bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }

    function toUint256(bytes memory bs) internal pure returns(uint256 x) {
        if(bs.length >= 32) {
            assembly {
                x := mload(add(bs, add(0x20, 0)))
            }
        }
    }
}

interface IMVDProxyDelegate {
    function setProxy() external;
}