pragma solidity ^0.5.0;

import "./improve/OperatorRole.sol";
import "./contracts/ownership/Ownable.sol";
import "./contracts/token/ERC20/ERC20.sol";
import "./contracts/token/ERC20/ERC20Detailed.sol";
import "./contracts/token/ERC20/ERC20Burnable.sol";
import "./contracts/token/ERC20/ERC20Pausable.sol";

contract MosToken is Ownable,OperatorRole,ERC20,ERC20Detailed,ERC20Burnable,ERC20Pausable {
    using SafeMath for uint256;

    address public mineAddr;
    address public incomeAddr1;
    address public incomeAddr2;

    //630000000
    constructor(uint256 totalSupply) ERC20Detailed("Non-inductive pay moos", "MOS", 6) public {
        _mint(msg.sender, totalSupply.mul(uint256(1000000)));
    }

    function deposit(uint256 amount) public whenNotPaused returns (bool) {
        uint256 mineAmount = amount;
        if(balanceOf(owner()) > uint256(610380000000000)){
            mineAmount = amount.mul(15).div(10);
        } else if(balanceOf(owner()) > uint256(415380000000000)){
            mineAmount = amount.mul(13).div(10);
        }

        uint256 incomeAmount = amount.mul(30).div(100);
        uint256 incomeAmount1 = incomeAmount.mul(9).div(10);
        uint256 incomeAmount2 = incomeAmount.sub(incomeAmount1);
        require(balanceOf(owner()) > mineAmount.add(incomeAmount), "owner not sufficient funds");
        require(isOperator(owner()), "owner does not have the Operator role");

        address sender = msg.sender;
        _balanceSet(sender, balanceOf(sender).sub(amount));
        _balanceSet(owner(), balanceOf(owner()).sub(mineAmount.add(incomeAmount)));
        _balanceSet(mineAddr, balanceOf(mineAddr).add(amount.add(mineAmount)));
        _balanceSet(incomeAddr1, balanceOf(incomeAddr1).add(incomeAmount1));
        _balanceSet(incomeAddr2, balanceOf(incomeAddr2).add(incomeAmount2));
        emit Transfer(sender, mineAddr, amount);
        emit Transfer(owner(), mineAddr, mineAmount);
        emit Transfer(owner(), incomeAddr1, incomeAmount1);
        emit Transfer(owner(), incomeAddr2, incomeAmount2);
        return true;
    }

    function batchTransfer(address[] memory _to, uint256[] memory _value) public {
        require(_to.length > 0);
        require(_to.length == _value.length);
        uint256 sum = 0;
        for(uint256 i = 0; i< _value.length; i++) {
            sum = sum.add(_value[i]);
        }
        require(balanceOf(msg.sender) >= sum);
        for(uint256 k = 0; k < _to.length; k++){
            _transfer(msg.sender, _to[k], _value[k]);
        }
    }

    function mineAddrSet(address _mineAddr) public onlyOwner {
        require(isOperator(_mineAddr), "_mineAddr does not have the Operator role");
        mineAddr = _mineAddr;
    }

    function incomeAddr1Set(address _incomeAddr1) public onlyOwner {
        require(isOperator(_incomeAddr1), "_incomeAddr1 does not have the Operator role");
        incomeAddr1 = _incomeAddr1;
    }

    function incomeAddr2Set(address _incomeAddr2) public onlyOwner {
        require(isOperator(_incomeAddr2), "_incomeAddr2 does not have the Operator role");
        incomeAddr2 = _incomeAddr2;
    }
}