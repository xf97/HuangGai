/**
 *Submitted for verification at Etherscan.io on 2020-03-24
*/

pragma solidity ^0.6.1;

// HiveNet Token (HNT) contract
//
// For any information please refer to our white paper and official communication:
// www.HiveNet.cloud
//
// Total Supply: 700,000,000 HNT
//
// Before the  HiveNet main net launches, HNT will be transferrable into HiveCoins.
// Please note that no HNT are reserved for HiveNet's team, who will only receive HiveCoins once the main net launches.
// For HiveNet's main net launch a total supply of 1,000,000,000 HiveCoins is defined.
// The amount of HNT is lower than that, because the missing 300,000,000 HiveCoins are allocated to:
// 150,000,000 HiveCoins for the HiveNet GmbH
// 100,000,000 HiveCoins for HiveNet's team
// 50,000,000 provider reward deposit
// These allocations will only be generated at HiveNet's main net launch to protect the interests of HiveNet Token buyers.
// For further details please refer to our white paper at www.HiveNet.cloud


// SafeMath

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


// Context

contract Context {

    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


// ERC20Interface

interface ERC20Interface {
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
    function transfer(address _recipient, uint256 _amount) external returns (bool);
    function allowance(address _owner, address _spender) external view returns (uint256);
    function approve(address _spender, uint256 _amount) external returns (bool);
    function transferFrom(address _sender, address _recipient, uint256 _amount) external returns (bool);
    event Transfer(address indexed _sender, address indexed _recipient, uint256);
    event Approval(address indexed _owner, address indexed _spender, uint256);
}


// contract StandardToken

contract StandardToken is Context, ERC20Interface {
    using SafeMath for uint256;

    mapping (address => uint256) public _balances;
    mapping (address => mapping (address => uint256)) public _allowances;
    uint256 public _totalSupply;

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view override returns (uint256) {
        return _balances[_owner];
    }

    function transfer(address _recipient, uint256 _amount) public virtual override returns (bool) {
        _transfer(_msgSender(), _recipient, _amount);
        return true;
    }

    function allowance(address _owner, address _spender) public view virtual override returns (uint256) {
        return _allowances[_owner][_spender];
    }

    function approve(address _spender, uint256 _amount) public virtual override returns (bool) {
        _approve(_msgSender(), _spender, _amount);
        return true;
    }

    function transferFrom(address _sender, address _recipient, uint256 _amount) public virtual override returns (bool) {
        _transfer(_sender, _recipient, _amount);
        _approve(_sender, _msgSender(), _allowances[_sender][_msgSender()].sub(_amount, "HNT: transfer amount exceeds allowance"));
        return true;
    }

    // check https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 for details
    function increaseAllowance(address _spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), _spender, _allowances[_msgSender()][_spender].add(addedValue));
        return true;
    }

    // check https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 for details
    function decreaseAllowance(address _spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), _spender, _allowances[_msgSender()][_spender].sub(subtractedValue, "HNT: decreased allowance below zero"));
        return true;
    }

    function _transfer(address _sender, address _recipient, uint256 _amount) internal virtual {
        require(_sender != address(0), "HNT: transfer from the zero address");
        require(_recipient != address(0), "HNT: transfer to the zero address");

        _beforeTokenTransfer(_sender, _recipient, _amount);

        _balances[_sender] = _balances[_sender].sub(_amount, "HNT: transfer amount exceeds balance");
        _balances[_recipient] = _balances[_recipient].add(_amount);
        emit Transfer(_sender, _recipient, _amount);
    }

  function _approve(address _owner, address _spender, uint256 _amount) internal virtual {
        require(_owner != address(0), "HNT: approve from the zero address");
        require(_spender != address(0), "HNT: approve to the zero address");

        _allowances[_owner][_spender] = _amount;
        emit Approval(_owner, _spender, _amount);
    }

    function _beforeTokenTransfer(address _sender, address _recipient, uint256 _amount) internal virtual { }
}


// contract HiveNetToken

contract HiveNetToken is ERC20Interface, StandardToken {
    using SafeMath for uint256;

    string public _name = "HiveNet Token";
    string public _symbol = "HNT";
    uint8 public _decimals = 18;

    constructor () public {
        _totalSupply = 700000000000000000000000000;
        _balances[0x8bdE0C97fA65823A7d098fa6355498da24230248] = _totalSupply;
        emit Transfer(address(0), 0x8bdE0C97fA65823A7d098fa6355498da24230248, _totalSupply);
      }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }
}