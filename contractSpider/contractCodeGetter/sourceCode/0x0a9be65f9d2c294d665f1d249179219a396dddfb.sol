/**
 *Submitted for verification at Etherscan.io on 2020-06-17
*/

pragma solidity 0.4.25;


/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
 */
contract IDAP {
    function transfer(address to, uint256 value) public returns (bool);

    function approve(address spender, uint256 value) public returns (bool);

    function transferFrom(address from, address to, uint256 value) public returns (bool);

    function balanceOf(address who) public view returns (uint256);

    function allowance(address owner, address spender) public view returns (uint256);

    function burn(uint _amount) public;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract Auth {

  address internal mainAdmin;
  address internal backupAdmin;
  address internal contractAdmin;

  event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);

  constructor(
    address _mainAdmin,
    address _backupAdmin,
    address _contractAdmin
  ) internal {
    mainAdmin = _mainAdmin;
    backupAdmin = _backupAdmin;
    contractAdmin = _contractAdmin;
  }

  modifier onlyMainAdmin() {
    require(isMainAdmin(), 'onlyMainAdmin');
    _;
  }

  modifier onlyBackupAdmin() {
    require(isBackupAdmin(), 'onlyBackupAdmin');
    _;
  }

  modifier onlyContractAdmin() {
    require(isContractAdmin() || isMainAdmin(), 'onlyContractAdmin');
    _;
  }

  function transferOwnership(address _newOwner) onlyBackupAdmin internal {
    require(_newOwner != address(0x0));
    mainAdmin = _newOwner;
    emit OwnershipTransferred(msg.sender, _newOwner);
  }

  function isMainAdmin() public view returns (bool) {
    return msg.sender == mainAdmin;
  }

  function isBackupAdmin() public view returns (bool) {
    return msg.sender == backupAdmin;
  }

  function isContractAdmin() public view returns (bool) {
    return msg.sender == contractAdmin;
  }
}

pragma experimental ABIEncoderV2;

contract Withdraw is Auth {

  IDAP public dapToken;
  bool lCT = false;

  event Withdrew(address indexed user, uint amount, uint timestamp);
  event WithdrewCanceled(address indexed user, string id, uint timestamp);
  event Payout(address indexed user, uint amount, string id, uint timestamp);

  constructor (
    address _mainAdmin,
    address _backupAdmin
  )
  Auth(_mainAdmin, _backupAdmin, msg.sender)
  public {}

  function updateMainAdmin(address _admin) public {
    transferOwnership(_admin);
  }

  function updateBackupAdmin(address _backupAdmin) onlyBackupAdmin public {
    require(_backupAdmin != address(0x0), 'Invalid address');
    backupAdmin = _backupAdmin;
  }

  function updateContractAdmin(address _contractAdmin) onlyMainAdmin public {
    require(_contractAdmin != address(0x0), 'Invalid address');
    contractAdmin = _contractAdmin;
  }

  function uLT(bool _l) onlyMainAdmin public {
    lCT = _l;
  }

  function setToken(address _token) onlyContractAdmin public {
    require(_token != address(0x0), 'Invalid address');
    require(!lCT, 'Can not change token');
    dapToken = IDAP(_token);
  }

  function withdraw(uint amount) public {
    emit Withdrew(msg.sender, amount, now);
  }

  function cancelWithdraw(string id) public {
    emit WithdrewCanceled(msg.sender, id, now);
  }

  function payout(address[] _addresses, uint[] _amounts, string[] _ids) onlyMainAdmin public {
    require(_addresses.length == _amounts.length && _amounts.length == _ids.length, 'Data invalid');
    for (uint i = 0; i < _addresses.length; i++) {
      dapToken.transfer(_addresses[i], _amounts[i]);
      emit Payout(_addresses[i], _amounts[i], _ids[i], now);
    }
  }
}