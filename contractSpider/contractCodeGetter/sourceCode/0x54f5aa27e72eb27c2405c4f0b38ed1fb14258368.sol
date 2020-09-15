/*! oris.share.sol | (c) 2020 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | SPDX-License-Identifier: MIT License */

pragma solidity 0.6.8;

import "Ownable.sol";
import "IERC20.sol";
import "ERC20DecimalsMock.sol";
import "ERC20Capped.sol";

contract Token is ERC20Capped(21e8), ERC20DecimalsMock("ORIS SHARE", "ORIS", 4), Ownable {
    struct Payment {
        uint40 time;
        uint256 amount;
    }

    IERC20 public orgon_token = IERC20(0xc58603dCD0cfa4B257409DFFF6402aB638DE99b9);

    Payment[] public repayments;
    mapping(address => Payment[]) public rewards;

    event Repayment(address indexed from, uint256 amount);
    event Reward(address indexed to, uint256 amount);
    
    function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal override(ERC20Capped, ERC20) {
        if(_from != address(0)) _reward(_from);
        _reward(_to);

        ERC20Capped._beforeTokenTransfer(_from, _to, _amount);
    }

    function _reward(address _to) private returns(bool) {
        uint256 balance = balanceOf(_to);

        if(rewards[_to].length < repayments.length && balance > 0) {
            uint256 sum = 0;

            for(uint256 i = rewards[_to].length; i < repayments.length; i++) {
                uint256 amount = repayments[i].amount * balance / totalSupply();

                rewards[_to].push(Payment({
                    time : uint40(block.timestamp),
                    amount : amount
                }));

                sum += amount;
            }

            if(sum > 0) {
                orgon_token.transfer(_to, sum);

                emit Reward(_to, sum);
            }

            return true;
        }

        return false;
    }

    function buy(uint256 _amount) external {
        require(orgon_token.transferFrom(msg.sender, owner(), _amount));
        
        _mint(msg.sender, _amount / 5e16);
    }

    function reward() external returns(bool) {
        return _reward(msg.sender);
    }

    function repayment(uint256 _amount) external onlyOwner {
        require(orgon_token.transferFrom(msg.sender, address(this), _amount));

        repayments.push(Payment({
            time : uint40(block.timestamp),
            amount : _amount
        }));

        emit Repayment(msg.sender, _amount);
    }

    function withdrawOrgon(uint256 _amount) external onlyOwner {
        orgon_token.transfer(msg.sender, _amount);
    }

    function availableRewards(address _to) external view returns(uint256 sum) {
        uint256 balance = balanceOf(_to);

        if(balance > 0) {
            for(uint256 i = rewards[_to].length; i < repayments.length; i++) {
                sum += repayments[i].amount * balance / totalSupply();
            }
        }
    }
}