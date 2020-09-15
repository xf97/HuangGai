// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";

contract Collt {
    struct Buyer {
        uint availableBalance;
        uint lockedBalance;
    }

    struct Lock {
        uint lockTime;
        uint unlockTime;
        uint lockedAmount;
        address sellerAddress;
        uint lockId;
        address payable buyerAddress;
        bool isAutoWithdraw;
    }

    mapping(address => mapping(uint =>Lock)) internal locks;
    mapping(address => Buyer) internal buyers;

    event LockCreated(address indexed sellerAddress, uint lockId, address indexed buyerAddress);
    event LockDestroyed(address indexed sellerAddress, uint lockId, address indexed buyerAddress);

    function getLock(address _sellerAddress, uint _lockId) external view returns (Lock memory) {
        return locks[_sellerAddress][_lockId];
    }

    function deposit() public payable {
        require(msg.value > 0, "You are trying to deposit 0 Wei");
        Buyer storage refBuyer = buyers[msg.sender];
        refBuyer.availableBalance = SafeMath.add(refBuyer.availableBalance, msg.value);
    }

    function withdraw(uint _value) external {
        Buyer storage refBuyer = buyers[msg.sender];
        uint availableBalance = refBuyer.availableBalance;
        require(availableBalance > 0, "You are trying to withdraw from an empty (or non existent) account");
        require(_value <= availableBalance, "You are trying to withdraw more than you have");
        refBuyer.availableBalance -= _value;
        msg.sender.transfer(_value);
    }

    function lock(uint _lockAmount, uint _unlockTime, uint _lockId, address _sellerAddress, bool _isAutoWithdraw) external payable {
        require(_lockAmount > 0, "You are trying to lock 0 Ether");
        require(_unlockTime > block.timestamp, "You are trying to set unlock time before (or equal to) lock time");
        require(msg.sender != _sellerAddress, "You are trying to buy from yourself");
        Lock storage refLock = locks[_sellerAddress][_lockId];
        require(refLock.lockedAmount == 0, "A lock with the same seller and lock ID already exists");
        if (msg.value > 0) {
            deposit();
        }
        Buyer storage buyer = buyers[msg.sender];
        require(buyer.availableBalance > 0, "Your available balance is zero");
        require(buyer.availableBalance >= _lockAmount, "You are trying to lock more than you have");
        buyer.availableBalance -= _lockAmount;
        buyer.lockedBalance = SafeMath.add(buyer.lockedBalance, _lockAmount);
        locks[_sellerAddress][_lockId] = Lock({
            lockTime: block.timestamp,
            unlockTime: _unlockTime,
            lockedAmount: _lockAmount,
            sellerAddress: _sellerAddress,
            lockId: _lockId,
            buyerAddress: msg.sender,
            isAutoWithdraw: _isAutoWithdraw
        });
        emit LockCreated(_sellerAddress, _lockId, msg.sender);
    }

    function unlock(address _sellerAddress, uint _lockId) external {
        // Copy what we need (everything except lockTime, sellerAddress and lockId) and delete the lock right away to prevent reentrancy vulnerability:
        Lock storage refLock = locks[_sellerAddress][_lockId];
        uint unlockTime = refLock.unlockTime;
        uint lockedAmount = refLock.lockedAmount;
        address payable buyerAddress = refLock.buyerAddress;
        address sellerAddress = refLock.sellerAddress;
        bool isAutoWithdraw = refLock.isAutoWithdraw;
        delete locks[_sellerAddress][_lockId];
        require(lockedAmount > 0, "You are trying to unlock a non existent lock");
        if (block.timestamp > unlockTime) {
            require(buyerAddress == msg.sender || sellerAddress == msg.sender, "Only the buyer or the seller of this order can unlock this lock now and in the future");
        } else {
            require(sellerAddress == msg.sender, "Only the seller of this order can unlock this lock now (wait for a while if you are the buyer)");
        }
        Buyer storage refBuyer = buyers[buyerAddress];
        refBuyer.lockedBalance -= lockedAmount;
        if (!isAutoWithdraw) {
            refBuyer.availableBalance = SafeMath.add(refBuyer.availableBalance, lockedAmount);
        } else {
            buyerAddress.transfer(lockedAmount);
        }
        emit LockDestroyed(_sellerAddress, _lockId, buyerAddress);
    }

    // The seller can repossess the funds at any time, before or after unlockTime
    function repossess(uint _lockId, uint _releaseAmount) external {
        // Copy what we need (lockedAmount and buyerAddress) and delete the lock right away to prevent reentrancy vulnerability:
        Lock storage refLock = locks[msg.sender][_lockId];
        uint lockedAmount = refLock.lockedAmount;
        address payable buyerAddress = refLock.buyerAddress;
        delete locks[msg.sender][_lockId];
        require(lockedAmount > 0, "You can't repossess this lock either because you are not its seller or because it doesn't exist");
        require(_releaseAmount <= lockedAmount, "You are trying to repossess more than the lock has");
        Buyer storage refBuyer = buyers[buyerAddress];
        refBuyer.lockedBalance -= lockedAmount;
        if (_releaseAmount > 0) {
            refBuyer.availableBalance = SafeMath.add(refBuyer.availableBalance, lockedAmount - _releaseAmount);
            msg.sender.transfer(_releaseAmount);
        } else {
            msg.sender.transfer(lockedAmount);
        }
        emit LockDestroyed(msg.sender, _lockId, buyerAddress);
    }

    function extendUnlockTime(uint _lockId, uint _newUnlockTime) external {
        Lock storage refLock = locks[msg.sender][_lockId];
        require(msg.sender == refLock.sellerAddress, "Only the seller of this lock can extend it, you are not the seller of this lock");
        require(_newUnlockTime > block.timestamp, "You are trying to set new unlock time in the past");
        require(_newUnlockTime > refLock.unlockTime, "You are trying to shrink unlock time, not extend");
        refLock.unlockTime = _newUnlockTime;
    }

    function getBuyerBalances(address _buyerAddress) external view returns (Buyer memory) {
        return buyers[_buyerAddress];
    }

    function test_getCurrentTimestampInSeconds() external view returns (uint) {
        return block.timestamp;
    }
}
