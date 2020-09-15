/**
 *Submitted for verification at Etherscan.io on 2020-07-24
*/

pragma solidity ^0.5.0;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address private _owner;

  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    _owner = msg.sender;
  }

  /**
   * @return the address of the owner.
   */
  function owner() public view returns(address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  /**
   * @return true if `msg.sender` is the owner of the contract.
   */
  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(_owner);
    _owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

contract ERC20I {
    function balanceOf(address who) public view returns (uint);
    function decimals() public view returns (uint);
    function transfer(address to, uint value) public returns (bool);
    function transferFrom(address from, address to, uint value) public returns (bool);
}

contract DOSAddressBridgeInterface {
    function getProxyAddress() public view returns (address);
}

contract DOSPayment is Ownable {
    enum ServiceType {
        SystemRandom,
        UserRandom,
        UserQuery
    }

    struct FeeList {
        // ServiceType => serviceFee
        mapping(uint => uint) serviceFee;
        uint submitterCut;
        uint guardianFee;
    }

    struct Payment {
        address payer;
        address tokenAddr;
        uint serviceType;
        uint amount;
    }

    // payer addr => payment token addr
    mapping(address => address) public paymentMethods;
    // tokenAddr => feeList
    mapping(address => FeeList) public feeLists;
    // requestID => Payment
    mapping(uint => Payment) public payments;
    // node address => {tokenAddr => amount}
    mapping(address => mapping(address => uint)) private _balances;

    uint constant public defaultSubmitterCut = 4;
    uint constant public defaultSystemRandomFee = 10 * 1e18;  // 10 tokens
    uint constant public defaultUserRandomFee = 10 * 1e18;    // 10 tokens
    uint constant public defaultUserQueryFee = 10 * 1e18;     // 10 tokens
    uint constant public defaultGuardianFee = 10 * 1e18;      // 10 tokens

    address public guardianFundsAddr;
    address public guardianFundsTokenAddr;
    address public bridgeAddr;
    address public defaultTokenAddr;

    event LogChargeServiceFee(address payer, address tokenAddr, uint requestID, uint serviceType, uint fee);
    event LogRefundServiceFee(address payer, address tokenAddr, uint requestID, uint serviceType, uint fee);
    event LogRecordServiceFee(address nodeAddr, address tokenAddr, uint requestID, uint serviceType, uint fee, bool isSubmitter);
    event LogClaimGuardianFee(address nodeAddr, address tokenAddr, uint feeForSubmitter, address sender);

    modifier onlyFromProxy {
        require(msg.sender == DOSAddressBridgeInterface(bridgeAddr).getProxyAddress(), "not-from-dos-proxy");
        _;
    }

    modifier onlySupportedToken(address tokenAddr) {
        require(isSupportedToken(tokenAddr), "not-supported-token-addr");
        _;
    }

    modifier hasPayment(uint requestID) {
        require(payments[requestID].amount != 0, "no-fee-amount");
        require(payments[requestID].payer != address(0x0), "no-payer-info");
        require(payments[requestID].tokenAddr != address(0x0), "no-fee-token-info");
        _;
    }

    constructor(address _bridgeAddr, address _guardianFundsAddr, address _tokenAddr) public {
        initialize(_bridgeAddr, _guardianFundsAddr, _tokenAddr);
    }

    function initialize(address _bridgeAddr, address _guardianFundsAddr, address _tokenAddr) public {
        require(bridgeAddr == address(0x0) && defaultTokenAddr == address(0x0), "already-initialized");

        bridgeAddr = _bridgeAddr;
        guardianFundsAddr = _guardianFundsAddr;
        guardianFundsTokenAddr = _tokenAddr;
        defaultTokenAddr = _tokenAddr;

        FeeList storage feeList = feeLists[_tokenAddr];
        feeList.serviceFee[uint(ServiceType.SystemRandom)] = defaultSystemRandomFee;
        feeList.serviceFee[uint(ServiceType.UserRandom)] = defaultUserRandomFee;
        feeList.serviceFee[uint(ServiceType.UserQuery)] = defaultUserQueryFee;
        feeList.submitterCut = defaultSubmitterCut;
        feeList.guardianFee = defaultGuardianFee;
    }

    function isSupportedToken(address tokenAddr) public view returns(bool) {
       if (tokenAddr == address(0x0)) return false;
       if (feeLists[tokenAddr].serviceFee[uint(ServiceType.SystemRandom)] == 0) return false;
       if (feeLists[tokenAddr].serviceFee[uint(ServiceType.UserRandom)] == 0) return false;
       if (feeLists[tokenAddr].serviceFee[uint(ServiceType.UserQuery)] == 0) return false;
       return true;
    }

    function setPaymentMethod(address payer, address tokenAddr) public onlySupportedToken(tokenAddr) {
        paymentMethods[payer] = tokenAddr;
    }

    function setServiceFee(address tokenAddr, uint serviceType, uint fee) public onlyOwner {
        require(tokenAddr != address(0x0), "not-valid-token-addr");
        feeLists[tokenAddr].serviceFee[serviceType] = fee;
    }

    function setGuardianFee(address tokenAddr, uint fee) public onlyOwner {
        require(tokenAddr != address(0x0), "not-valid-token-addr");
        feeLists[tokenAddr].guardianFee = fee;
    }

    function setFeeDividend(address tokenAddr, uint submitterCut) public onlyOwner {
        require(tokenAddr != address(0x0), "not-valid-token-addr");
        feeLists[tokenAddr].submitterCut = submitterCut;
    }

    function setGuardianFunds(address fundsAddr, address tokenAddr) public onlyOwner onlySupportedToken(tokenAddr) {
        guardianFundsAddr = fundsAddr;
        guardianFundsTokenAddr = tokenAddr;
    }

    function hasServiceFee(address payer, uint serviceType) public view returns (bool) {
        if (payer == DOSAddressBridgeInterface(bridgeAddr).getProxyAddress()) return true;
        address tokenAddr = paymentMethods[payer];
        // Get fee by tokenAddr and serviceType
        uint fee = feeLists[tokenAddr].serviceFee[serviceType];
        return ERC20I(tokenAddr).balanceOf(payer) >= fee;
    }

    function chargeServiceFee(address payer, uint requestID, uint serviceType) public onlyFromProxy {
        address tokenAddr = paymentMethods[payer];
        // Get fee by tokenAddr and serviceType
        uint fee = feeLists[tokenAddr].serviceFee[serviceType];
        payments[requestID] = Payment(payer, tokenAddr, serviceType, fee);
        emit LogChargeServiceFee(payer, tokenAddr, requestID, serviceType, fee);
        ERC20I(tokenAddr).transferFrom(payer, address(this), fee);
    }

    function refundServiceFee(uint requestID) public onlyOwner hasPayment(requestID) {
        uint fee = payments[requestID].amount;
        uint serviceType = payments[requestID].serviceType;
        address tokenAddr = payments[requestID].tokenAddr;
        address payer = payments[requestID].payer;
        delete payments[requestID];
        emit LogRefundServiceFee(payer, tokenAddr, requestID, serviceType, fee);
        ERC20I(tokenAddr).transfer(payer, fee);
    }

    function recordServiceFee(uint requestID, address submitter, address[] memory workers) public onlyFromProxy hasPayment(requestID) {
        address tokenAddr = payments[requestID].tokenAddr;
        uint feeUnit = payments[requestID].amount / 10;
        uint serviceType = payments[requestID].serviceType;
        delete payments[requestID];

        FeeList storage feeList = feeLists[tokenAddr];
        uint feeForSubmitter = feeUnit * feeList.submitterCut;
        _balances[submitter][tokenAddr] += feeForSubmitter;
        emit LogRecordServiceFee(submitter, tokenAddr, requestID, serviceType, feeForSubmitter, true);
        uint feeForWorker = feeUnit * (10 - feeList.submitterCut) / (workers.length - 1);
        for (uint i = 0; i < workers.length; i++) {
            if (workers[i] != submitter) {
                _balances[workers[i]][tokenAddr] += feeForWorker;
                emit LogRecordServiceFee(workers[i], tokenAddr, requestID, serviceType, feeForWorker, false);
            }
        }
    }

    function claimGuardianReward(address guardianAddr) public onlyFromProxy {
        require(guardianFundsAddr != address(0x0), "not-valid-guardian-fund-addr");
        require(guardianFundsTokenAddr != address(0x0), "not-valid-guardian-token-addr");
        uint fee = feeLists[guardianFundsTokenAddr].guardianFee;
        emit LogClaimGuardianFee(guardianAddr, guardianFundsTokenAddr, fee, msg.sender);
        ERC20I(guardianFundsTokenAddr).transferFrom(guardianFundsAddr, guardianAddr,fee);
    }

    // @dev: node runners call to withdraw recorded service fees.
    function nodeClaim() public returns(uint) {
        return nodeClaim(msg.sender, defaultTokenAddr, msg.sender);
    }

    // @dev: node runners call to withdraw recorded service fees to specified address.
    function nodeClaim(address to) public returns(uint) {
        return nodeClaim(msg.sender, defaultTokenAddr, to);
    }

    function nodeClaim(address nodeAddr, address tokenAddr, address to) internal returns(uint) {
        uint amount = _balances[nodeAddr][tokenAddr];
        if (amount != 0) {
            delete _balances[nodeAddr][tokenAddr];
            ERC20I(tokenAddr).transfer(to, amount);
        }
        return amount;
    }

    function nodeFeeBalance(address nodeAddr) public view returns (uint) {
        return nodeFeeBalance(nodeAddr, defaultTokenAddr);
    }

    function nodeFeeBalance(address nodeAddr, address tokenAddr) public view returns (uint) {
        return _balances[nodeAddr][tokenAddr];
    }

    function paymentInfo(uint requestID) public view returns (address, uint) {
        Payment storage payment = payments[requestID];
        return (payment.tokenAddr, payment.amount);
    }
}