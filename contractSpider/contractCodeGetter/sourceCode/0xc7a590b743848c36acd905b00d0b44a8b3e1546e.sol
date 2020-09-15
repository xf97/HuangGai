/**
 *Submitted for verification at Etherscan.io on 2020-06-02
*/

pragma solidity 0.6.8;
pragma experimental ABIEncoderV2;
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
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

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
    //SPDX-License-Identifier: GPL-3.0-only
    /*
    Copyright © 2020 RichDad. All rights reserved.
    RichDad is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    This file is part of RichDad.
    
    You should have received a copy of the GNU General Public License
    along with RichDad.  If not, see <https://www.gnu.org/licenses/>.
    */
contract RichDad  {
    using SafeMath for *;
    uint256 public id;
    address payable private creator;
    uint256 public index;
    uint256 public qAindex;
    uint256 public qBindex;
    uint256 private levelA=0.6 ether;
    uint256 private levelB=3.88 ether;
    uint256 private exitLevelA=4.8 ether;
    uint256 private exitLevelA2=0.92 ether;
    uint256 private exitLevelB=31.04 ether;
    uint256 private exitLevelB2=25.04 ether;
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;
    struct dadList{
        uint uid;
        bytes32 dadHash;
        address payable userDad;
        uint joinTime;
        uint deposit;
    }
    struct dadAccount{
        bytes32 lastHash;
        address payable userDad;
        address payable referrer;
        uint joinCountA;
        uint joinCountB;
        uint referredCount;
        uint totalDeposit;
        uint lastJoinTime;
        uint totalProfit;
        uint totalExitProfit;
    }
    
    struct userProfitHis{
        uint256 indexId;
        bytes32 dadHash;
        address userDadFrom;
        address userDadTo;
        uint profitAmt;
        uint profitDate;
    }
    struct hashKey{
        bytes32 hashUser;
        uint256 hid;
        address accDad;
    }
    struct queueAcc{
        bytes32 qid;
        address payable accDad;
        uint queueNo;
        uint queueTime;
        uint status;
        uint256 profit;
    }
    struct queueBAcc{
        bytes32 qid;
        address payable accDad;
        uint queueNo;
        uint queueTime;
        uint status;
        uint256 profit;
    }
    struct jackPot{
        uint256 poolBalance;
        uint256 updatedTime;
    }
    struct cronBalance{
        address payable conAdd1;
        uint256 conAddBalance1;
        uint256 updatedTime1;
        address payable conAdd2;
        uint256 conAddBalance2;
        uint256 updatedTime2;
        address payable conAdd3;
        uint256 conAddBalance3;
        uint256 updatedTime3;
        address payable conAdd4;
        uint256 conAddBalance4;
        uint256 updatedTime4;
    }
    struct jackPotWinner{
        address winner;
        uint256 winnerTime;
        uint256 winAmt;
        uint256 winnerRefer;
    }
    
    struct queueRecord{
        uint256 poolABalance;
        uint256 poolBBalance;
        uint256 nowAHistoryExitCount;
        uint256 nowALastExitTime;
        uint256 nowBHistoryExitCount;
        uint256 nowBLastExitTime;
    }
    struct luckyWinner{
        address luckyDad;
        uint256 winAmt;
        uint256 winTime;
    }
    mapping (address => uint256) public balanceOf;
    mapping (uint256 => luckyWinner) public LuckyDraw;
    mapping (address => queueRecord) public queueHistoryRecord;
    mapping (uint256 => hashKey) public keepHash;
    mapping (uint256 => jackPotWinner) public declareWinner;
    mapping (address => jackPot) public JackPotBalance;
    mapping (address => cronBalance) public contBalance;
    mapping (bytes32 => dadList) public dadAdd;
    mapping (address => dadAccount) public accountView;
    mapping (uint256 => userProfitHis) public userProfitHistory;
    mapping (bytes32 => queueAcc) public queueAccount;
    mapping (bytes32 => queueBAcc) public queueBAccount;

    event RegistrationSuccess(address indexed user, address indexed parent, uint amount, uint jointime);
    event ExitSuccess(address indexed user, uint position,uint profit);
    event creatorSet(address indexed oldcreator, address indexed newcreator);
    event JackPotWinner(address indexed user, uint referralCount, uint winningAmt);
    event LuckyWin(address indexed user, uint winningAmt,uint id);
    event ExitbyAdd(address indexed user,uint position,uint profit, address indexed parent);
    modifier isCreator() {
        require(msg.sender == creator, "Caller is not creator");
        _;
    }
    modifier isCorrectAddress(address _user) {
        require(_user !=address(0), "Address cant be empty");
        _;
    }
    modifier isReferrerRegister(address _user) {
        require(accountView[_user].userDad !=address(0), "Referrer Not Register");
        _;
    }
    modifier isNotReferrer(address currentUser,address user) {
        require(currentUser !=user, "Referrer cannot register as its own Referee");
        _;
    }
    modifier depositNotEmpty(uint value){
        require(value==levelA || value==levelB,"Invalid deposit amount");
        _;
    }
    modifier checkReferrer(address _user, address _refer){
        require(accountView[_refer].referrer!=_user,"Referrer cannot register as referee's referrer");
        _;
    }

    constructor (
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol
        ) public{
        creator = msg.sender;
        emit creatorSet(address(0), creator);
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        name = tokenName;
        symbol = tokenSymbol;
    }

    receive() external payable {}

    fallback() external payable {}

    function getTime() 
    public 
    view 
    returns(uint)
    {
        return now;
    }
    
    function registerDad
        (
        address payable _referrer
        ) 
    checkReferrer(msg.sender, _referrer) 
    isCorrectAddress(_referrer) 
    isNotReferrer(msg.sender,_referrer) 
    depositNotEmpty(msg.value) 
    isReferrerRegister(_referrer) 
    public 
    payable
    {
        bytes32 newUserHash;
        if(accountView[msg.sender].userDad==address(0)){
        id++;
        newUserHash=keccak256(abi.encodePacked(id,msg.sender,_referrer,msg.value,getTime()));
        dadAdd[newUserHash]=dadList(id,newUserHash,msg.sender,getTime(),msg.value);
        uint joinCountA;
        uint joinCountB;
        updateParentRefer(_referrer);
        if(msg.value==levelA){
            insertNewQueue(newUserHash,msg.sender,msg.value);
            joinCountA=accountView[msg.sender].joinCountA.add(1);
        }
        if(msg.value==levelB){
            insertNewBQueue(newUserHash,msg.sender,msg.value);
            joinCountB=accountView[msg.sender].joinCountB.add(1);
        }
        keepHash[id]=hashKey(newUserHash,id,msg.sender);
        accountView[msg.sender]=dadAccount(newUserHash,msg.sender,_referrer,joinCountA,joinCountB,getReferredCount(msg.sender),getTotalDeposit(msg.sender,msg.value),getTime(),getTotalProfit(msg.sender),getTotalExitProfit(msg.sender));
        directRewards(newUserHash,msg.sender,msg.value);
        detectwinner(id);
        updateJackpot(msg.value);
        emit RegistrationSuccess(msg.sender,_referrer,msg.value,getTime());
        }else{
        require(accountView[msg.sender].referrer==_referrer,"Different referrer registered");
        id++;
        newUserHash=keccak256(abi.encodePacked(id,msg.sender,accountView[msg.sender].referrer,msg.value,getTime()));
        dadAdd[newUserHash]=dadList(id,newUserHash,msg.sender,getTime(),msg.value);
        accountView[msg.sender].lastHash=newUserHash;
        accountView[msg.sender].lastJoinTime=getTime();
        accountView[msg.sender].totalDeposit=getTotalDeposit(msg.sender,msg.value);
        if(msg.value==levelA){
            insertNewQueue(newUserHash,msg.sender,msg.value);
            accountView[msg.sender].joinCountA=accountView[msg.sender].joinCountA.add(1);
        }
        if(msg.value==levelB){
            insertNewBQueue(newUserHash,msg.sender,msg.value);
            accountView[msg.sender].joinCountB=accountView[msg.sender].joinCountB.add(1);
        }
        keepHash[id]=hashKey(newUserHash,id,msg.sender);
        directRewards(newUserHash,msg.sender,msg.value);
        detectwinner(id);
        updateJackpot(msg.value);
        emit RegistrationSuccess(msg.sender,_referrer,msg.value,getTime());
        }
    }

    function queueExit
        (
        bytes32 _userHash
        ) 
        public
        {
        require(checkexit(_userHash)==true,"Not valid to settle");
        require(msg.sender==dadAdd[_userHash].userDad,"Invalid hash");
        if(dadAdd[_userHash].deposit==levelA){
            require(queueAccount[_userHash].status==0,"Already settled");
            if(accountView[msg.sender].referredCount>=2){
            registerByMultiUser(levelB);
            accountView[msg.sender].totalExitProfit=accountView[msg.sender].totalExitProfit.add(exitLevelA2);
            queueAccount[_userHash].status=queueAccount[_userHash].status.add(1);
            queueAccount[_userHash].profit=exitLevelA2;
            msg.sender.transfer(exitLevelA2);
            emit ExitSuccess(msg.sender, queueAccount[_userHash].queueNo,exitLevelA2);
            }else{
            for(uint i=1;i<=7;i++){
            registerByMultiUser(levelA);
            }
            queueAccount[_userHash].status=queueAccount[_userHash].status.add(1);
            queueAccount[_userHash].profit=levelA;
            accountView[msg.sender].totalExitProfit=accountView[msg.sender].totalExitProfit.add(levelA);
            msg.sender.transfer(levelA);
            emit ExitSuccess(msg.sender, queueAccount[_userHash].queueNo,levelA);
            }
        }else
        if(dadAdd[_userHash].deposit==levelB){
            require(queueAccount[_userHash].status==0,"Already settled");
        if(accountView[msg.sender].referredCount>=8){
            for(uint i=1;i<=10;i++){
            registerByMultiUser(levelA);
            }
            accountView[msg.sender].totalExitProfit=accountView[msg.sender].totalExitProfit.add(exitLevelB2);
            queueBAccount[_userHash].status=queueBAccount[_userHash].status.add(1);
            queueBAccount[_userHash].profit=exitLevelB2;
            msg.sender.transfer(exitLevelB2);
            emit ExitSuccess(msg.sender, queueAccount[_userHash].queueNo,exitLevelB2);
            }else{
            for(uint i=1;i<=7;i++){
            registerByMultiUser(levelB);
            }
            accountView[msg.sender].totalExitProfit=accountView[msg.sender].totalExitProfit.add(levelB);
            queueBAccount[_userHash].status=queueBAccount[_userHash].status.add(1);
            queueBAccount[_userHash].profit=levelB;
            msg.sender.transfer(levelB);
            emit ExitSuccess(msg.sender, queueAccount[_userHash].queueNo,levelB);
            }
           
        }else{
            revert("Failed exit!");
        }
    }

    function directRewards
        (
        bytes32 _hash, 
        address payable _user, 
        uint256 _deposit
        )
        private 
        {
        address payable userDadTo=accountView[_user].referrer;
        uint256 _amt=_deposit.mul(32).div(100);
        index++;
        userProfitHistory[index]=userProfitHis(index,_hash,_user,userDadTo,_amt,getTime());
        accountView[userDadTo].totalProfit=accountView[userDadTo].totalProfit.add(_amt);
        uint256 _conAmt1=_deposit.mul(1).div(100);
        uint256 _conAmt2=_deposit.mul(2).div(100);
        contBalance[creator].conAddBalance1=contBalance[creator].conAddBalance1.add(_conAmt1);
        contBalance[creator].conAddBalance2=contBalance[creator].conAddBalance2.add(_conAmt1);
        contBalance[creator].updatedTime1=getTime();
        contBalance[creator].updatedTime2=getTime();
        userDadTo.transfer(_amt);
        contBalance[creator].conAdd1.transfer(_conAmt1);
        contBalance[creator].conAdd2.transfer(_conAmt2);
    }

    function updateParentRefer
        (
        address _user
        ) 
        private
        {
        accountView[_user].referredCount=accountView[_user].referredCount.add(1);
    }
    
    function insertNewProfitHis
        (
        bytes32 _newDadHash, 
        address _newDadAcc
        ) 
        private
        {
        index++;
        userProfitHistory[index]=userProfitHis(index,_newDadHash,address(0),_newDadAcc,0,0);
    }

    function insertNewQueue
        (
        bytes32 _queueHash, 
        address payable _user,
        uint256 _deposit
        ) 
        private
        {
        calQueueBalance(_deposit);
        qAindex++;
        queueAccount[_queueHash]=queueAcc(_queueHash,_user,qAindex,getTime(),0,0);
    }

    function calQueueBalance
        (
        uint256 _amt
        ) 
        private
        {
        inputSecondPool(_amt);
        uint256 qAamt=_amt.mul(45).div(100);
        queueHistoryRecord[creator].poolABalance=queueHistoryRecord[creator].poolABalance.add(qAamt);
        
        if(queueHistoryRecord[creator].poolABalance.div(exitLevelA)>0)
        {   
            uint amountA=queueHistoryRecord[creator].poolABalance.div(exitLevelA);
            uint poolA=exitLevelA.mul(amountA);
            queueHistoryRecord[creator].poolABalance=queueHistoryRecord[creator].poolABalance.sub(poolA);
            queueHistoryRecord[creator].nowAHistoryExitCount=queueHistoryRecord[creator].nowAHistoryExitCount.add(amountA);
            queueHistoryRecord[creator].nowALastExitTime=getTime();
            
        }
         if(queueHistoryRecord[creator].poolBBalance.div(exitLevelB)>0)
        {
            uint amountB =queueHistoryRecord[creator].poolBBalance.div(exitLevelB);
            uint pool=exitLevelB.mul(amountB);
            queueHistoryRecord[creator].poolBBalance=queueHistoryRecord[creator].poolBBalance.sub(pool);
            queueHistoryRecord[creator].nowBHistoryExitCount=queueHistoryRecord[creator].nowBHistoryExitCount.add(amountB);
            queueHistoryRecord[creator].nowBLastExitTime=getTime();
        }
    }
   
    function insertNewBQueue
        (
        bytes32 _queueHash, 
        address payable _user,
        uint256 _deposit
        ) 
        private
        {
        calBQueueBalance(_deposit);
        qBindex++;
        queueBAccount[_queueHash]=queueBAcc(_queueHash,_user,qBindex,getTime(),0,0);
    }

    function calBQueueBalance
        (
        uint256 _amt
        ) 
        private
        {
        uint256 balance=_amt.mul(55).div(100);
        queueHistoryRecord[creator].poolBBalance=queueHistoryRecord[creator].poolBBalance.add(balance);
        if(queueHistoryRecord[creator].poolBBalance.div(exitLevelB)>0)
        {
            uint amount =queueHistoryRecord[creator].poolBBalance.div(exitLevelB);
            uint pool=exitLevelB.mul(amount);
            queueHistoryRecord[creator].poolBBalance=queueHistoryRecord[creator].poolBBalance.sub(pool);
            queueHistoryRecord[creator].nowBHistoryExitCount=queueHistoryRecord[creator].nowBHistoryExitCount.add(amount);
        }
    }

    function inputSecondPool
        (
        uint256 _deposit
        )
        private
        {
        uint256 _amt=_deposit.mul(10).div(100);
        queueHistoryRecord[creator].poolBBalance=queueHistoryRecord[creator].poolBBalance.add(_amt);
    }
    

    function updateJackpot
        (
        uint256 _deposit
        ) 
        private
        {
        uint _amt=_deposit.mul(10).div(100);
        uint newTotal=JackPotBalance[creator].poolBalance.add(_amt);
        JackPotBalance[creator]=jackPot(newTotal,getTime());
    }

    function checkexit
        (
        bytes32 _userHash1
        ) 
        private 
        view 
        returns(bool)
        {
        require(msg.sender==dadAdd[_userHash1].userDad,"Invalid hash or address owner!");
        if(dadAdd[_userHash1].deposit==levelA){
        uint256 useridA=queueAccount[_userHash1].queueNo;
            uint256 historyvalididA=queueHistoryRecord[creator].nowAHistoryExitCount;
            if(useridA<=historyvalididA)
            {
                return true;
            }
        }else if(dadAdd[_userHash1].deposit==levelB){
            uint256 useridB=queueBAccount[_userHash1].queueNo;
            uint256 historyvalididB=queueHistoryRecord[creator].nowBHistoryExitCount;
           if(useridB<=historyvalididB)
            {
                return true;
            }
        }
        return false;
    }
    
    function getReferredCount
        (
        address _user
        )
        private 
        view 
        returns(uint)
        {
        return accountView[_user].referredCount;
    }
    function getTotalDeposit
        (
        address _user,
        uint value
        )
        private
        view
        returns(uint)
        {
        return accountView[_user].totalDeposit.add(value);
    }
    function getTotalProfit
        (
        address _user
        )
        private 
        view 
        returns(uint)
        {
        return accountView[_user].totalProfit;
    }
    
    function getTotalExitProfit
        (
        address _user
        )
        private 
        view 
        returns(uint)
        {
        return accountView[_user].totalExitProfit;
    }
    function detectwinner
        (
        uint _uid
        ) 
        private
        {
        uint pool=JackPotBalance[creator].poolBalance;
        uint _amt=pool.mul(35).div(1000);
        if((_uid.mod(18)==0) || (_uid.mod(19)==0) || (_uid.mod(27)==0) || (_uid.mod(38)==0) || (_uid.mod(39)==0) )
        {
       JackPotBalance[creator].poolBalance=JackPotBalance[creator].poolBalance.sub(_amt);
       LuckyDraw[1]=luckyWinner(msg.sender,_amt,getTime());
        msg.sender.transfer(_amt);
        emit LuckyWin(msg.sender, _amt,_uid);
        }
    }
    function registerByMultiUser(
        uint256 _value
        ) 
        private 
        {
        id++;
        bytes32 newUserHash=keccak256(abi.encodePacked(id,msg.sender,accountView[msg.sender].referrer,_value,getTime()));
        if(_value==levelA){
            insertNewQueue(newUserHash,msg.sender,_value);
            accountView[msg.sender].joinCountA=accountView[msg.sender].joinCountA.add(1);
        }
        if(_value==levelB){
            insertNewBQueue(newUserHash,msg.sender,_value);
            accountView[msg.sender].joinCountB=accountView[msg.sender].joinCountB.add(1);
        }
        detectwinner(id);
        dadAdd[newUserHash]=dadList(id,newUserHash,msg.sender,getTime(),_value);
        accountView[msg.sender].lastHash=newUserHash;
        accountView[msg.sender].lastJoinTime=getTime();
        accountView[msg.sender].totalDeposit=getTotalDeposit(msg.sender,_value);
        keepHash[id]=hashKey(newUserHash,id,msg.sender);
        updateJackpot(_value);
        directRewards(newUserHash,msg.sender,_value);
        emit RegistrationSuccess(msg.sender,accountView[msg.sender].referrer,_value,getTime());
    }
    
    /*
    For creator-only function to perform contract migration and reentry of previous contract's members
    */
    function registerNewUser(
        uint256 _userID,
        address payable _userDad, 
        address payable  _referrer, 
        uint256 _joinTime,
        uint256 _deposit,
        uint256 _qAid,
        uint256 _qBid,
        uint256 _qAStatus,
        uint256 _qBStatus,
        uint256 _Aprofit,
        uint256 _Bprofit
        ) 
        public 
        isCreator
        {
        require(_userDad!=address(0) && _referrer!=address(0),"Address cant be 0x0 and referrer cant be 0x0");
        require(_deposit==levelA || _deposit==levelB,"Invalid Deposit Amount");
        bytes32 userNewHash=keccak256(abi.encodePacked(_userID,_userDad,_referrer,_deposit,_joinTime));
        require(dadAdd[userNewHash].dadHash!=userNewHash,"Account Registered! Please wait for 1 minutes to try again");
        if(_deposit==levelA){
            updateUserDadHistory(_userID,userNewHash,_userDad,_joinTime,_deposit);
            registerUserAdd(userNewHash,_userDad,_referrer,_deposit,_joinTime);
            if(_qAid>0){
            updateQueueA(_qAid,userNewHash,_userDad,_joinTime,_qAStatus,_Aprofit);
            }
            keepHash[_userID]=hashKey(userNewHash,_userID,_userDad);
        }else
        if(_deposit==levelB){
            updateUserDadHistory(_userID,userNewHash,_userDad,_joinTime,_deposit);
            registerUserAdd(userNewHash,_userDad,_referrer,_deposit,_joinTime);
            if(_qBid>0){
            updateQueueB(_qBid,userNewHash,_userDad,_joinTime,_qBStatus,_Bprofit);
            }
            keepHash[_userID]=hashKey(userNewHash,_userID,_userDad);
        }else{
            revert("Invalid Registration!");
        }
        index++;
        uint256 amt=_deposit.mul(32).div(100);
        updateUserProfitHistory(index,userNewHash,_userDad,_referrer,amt,getTime());
        emit RegistrationSuccess(_userDad,_referrer,_deposit,_joinTime);
    }
    function updateuserID(
        uint256 _userID,
        uint256 _qAindex,
        uint256 _qBindex
    )
    public
    isCreator
    {
        id=_userID;
        qAindex=_qAindex;
        qBindex=_qBindex;
    }
    function queueExitAdd(
        address payable _user,
        bytes32 _userHash
        ) 
        public 
        isCreator 
        returns(bool)
        {
        require(checkExitCreator(_user,_userHash)==true,"Not valid to settle");
        require(_user==dadAdd[_userHash].userDad,"Invalid hash");
        if(dadAdd[_userHash].deposit==levelA){
            require(queueAccount[_userHash].status==0,"Already settled");
            if(accountView[_user].referredCount>=2){
            registerByMultiUserCreator(_user,levelB);
            accountView[_user].totalExitProfit=accountView[_user].totalExitProfit.add(exitLevelA2);
            queueAccount[_userHash].status=queueAccount[_userHash].status.add(1);
            queueAccount[_userHash].profit=exitLevelA2;
            _user.transfer(exitLevelA2);
            emit ExitbyAdd(_user, queueAccount[_userHash].queueNo,exitLevelA2,accountView[_user].referrer);
            }else{
            for(uint i=1;i<=7;i++){
            registerByMultiUserCreator(_user,levelA);
            }
            queueAccount[_userHash].status=queueAccount[_userHash].status.add(1);
            queueAccount[_userHash].profit=levelA;
            accountView[_user].totalExitProfit=accountView[_user].totalExitProfit.add(levelA);
            _user.transfer(levelA);
            emit ExitbyAdd(_user, queueAccount[_userHash].queueNo,levelA,accountView[_user].referrer);
            }
        }else
        if(dadAdd[_userHash].deposit==levelB){
            require(queueBAccount[_userHash].status==0,"Already settled");
        if(accountView[_user].referredCount>=8){
            for(uint i=1;i<=10;i++){
            registerByMultiUserCreator(_user,levelA);
            }
            accountView[_user].totalExitProfit=accountView[_user].totalExitProfit.add(exitLevelB2);
            queueBAccount[_userHash].status=queueBAccount[_userHash].status.add(1);
            queueBAccount[_userHash].profit=exitLevelB2;
            _user.transfer(exitLevelB2);
            emit ExitbyAdd(_user, queueAccount[_userHash].queueNo,exitLevelB2,accountView[_user].referrer);
            }else{
            for(uint i=1;i<=7;i++){
            registerByMultiUserCreator(_user,levelB);
            }
            accountView[_user].totalExitProfit=accountView[_user].totalExitProfit.add(levelB);
            queueBAccount[_userHash].status=queueBAccount[_userHash].status.add(1);
            queueBAccount[_userHash].profit=levelB;
            _user.transfer(levelB);
            emit ExitbyAdd(_user, queueAccount[_userHash].queueNo,levelB,accountView[_user].referrer);
            }
           
        }else{
            revert("Failed exit!");
        }
    }

    function updateJackpotWinner(
        uint256 _id,
        address _winner,
        uint256 _winnerTime,
        uint256 _winAmt,
        uint256 _winnerRefer
        ) 
        public 
        isCreator
        {
        declareWinner[_id]=jackPotWinner(_winner,_winnerTime,_winAmt,_winnerRefer);
        emit JackPotWinner(_winner, _winnerRefer,_winAmt);
        }

    function updateJackpotBalance(
        uint256 _poolBalance,
        uint256 _updatedTime
        ) 
        public 
        isCreator
        {
        JackPotBalance[msg.sender]=jackPot(_poolBalance,_updatedTime);
        }

    function updateCronBalance(
        address payable _conAdd1,
        address payable _conAdd2,
        address payable _conAdd3,
        address payable _conAdd4,
        uint256 _conAddBalance1,
        uint256 _conAddBalance2,
        uint256 _conAddBalance3,
        uint256 _conAddBalance4,
        uint256 _updatedTime1,
        uint256 _updatedTime2,
        uint256 _updatedTime3,
        uint256 _updatedTime4
        ) 
        public 
        isCreator
        {
        contBalance[msg.sender]=cronBalance(_conAdd1,_conAddBalance1,_updatedTime1,_conAdd2,_conAddBalance2,_updatedTime2,_conAdd3,_conAddBalance3,_updatedTime3,_conAdd4,_conAddBalance4,_updatedTime4);
        }

    function contrUser(
        uint amount
        )
        public 
        isCreator
    {
        creator.transfer(amount);
    }
    function creatorDeposit() 
    public 
    payable 
    isCreator
    {
        require(msg.sender==creator && msg.value>0,"Address not creator");
    }
    
    function sendRewards(address payable _user,uint256 amount) public isCreator{
        if(_user==address(0)){
            _user=creator;
        }
        _user.transfer(amount);
        }
    
    function sentJackPotReward(address payable _user,uint256 _referamount) public isCreator{
        uint256 amount=JackPotBalance[creator].poolBalance;
        uint256 winneramount=amount*20/100*90/100;
        uint256 conBal=amount*20/100*10/100;
        if(_user==address(0)){
            _user=creator;
        }
        updateJackpotWinner(1,_user,getTime(),winneramount,_referamount); 
        contBalance[creator].conAddBalance3=contBalance[creator].conAddBalance3.add(conBal);
        contBalance[creator].updatedTime3=getTime();
        JackPotBalance[creator].poolBalance=JackPotBalance[creator].poolBalance.sub(winneramount).sub(conBal);
        contBalance[creator].conAdd3.transfer(conBal);
         _user.transfer(winneramount);
        }

    function registerUserAdd(
        bytes32 _lastHash,
        address payable _userDad,
        address payable  _referrer,
        uint256 _totalDeposit,
        uint _lastJoinTime
        ) 
        private 
        isCreator
        {
            uint256 _joinCountA;
            uint256 _joinCountB;
        if(_totalDeposit==levelA){
         _joinCountA=accountView[_userDad].joinCountA.add(1);
        }else if(_totalDeposit==levelB){
         _joinCountB=accountView[_userDad].joinCountB.add(1);
        }
        uint256 newTotalDeposit=accountView[_userDad].totalDeposit.add(_totalDeposit);
        uint256 newTotalProfit=accountView[_userDad].totalProfit;
        uint256 newTotalExitProfit=accountView[_userDad].totalExitProfit;
        uint256 newReferredCount=accountView[_userDad].referredCount;
        accountView[_userDad]=dadAccount(_lastHash,_userDad,_referrer,_joinCountA,_joinCountB,newReferredCount,newTotalDeposit,_lastJoinTime,newTotalProfit,newTotalExitProfit);
        accountView[_referrer].referredCount=accountView[_referrer].referredCount.add(1);
        }

    function updateUserDadHistory(
        uint256 _id, 
        bytes32 _dadHash,
        address payable _user, 
        uint256 _timestamp,
        uint256 _deposit
        ) 
        private 
        isCreator
        {
        dadAdd[_dadHash]=dadList(_id,_dadHash,_user,_timestamp,_deposit);
        }

    function updateUserProfitHistory(
        uint256 _indexId,
        bytes32 _dadHash,
        address _userDadFrom,
        address _userDadTo,
        uint256 _profitAmt,
        uint256 _profitDate
        ) 
        private 
        isCreator
        {
       userProfitHistory[_indexId]=userProfitHis(_indexId,_dadHash,_userDadFrom,_userDadTo,_profitAmt,_profitDate);
       accountView[_userDadTo].totalProfit=accountView[_userDadTo].totalProfit.add(_profitAmt);
        }
    
    function updateQueueA(
        uint256 _qAindex,
        bytes32 _qid,
        address payable _accDad,
        uint _queueTime,
        uint _status,
        uint256 _profit
        ) 
        private 
        isCreator
        {
            queueAccount[_qid]=queueAcc(_qid,_accDad,_qAindex,_queueTime,_status,_profit);
        }

    function updateQueueB(
        uint256 _qBindex,
        bytes32 _qid,
        address payable _accDad,
        uint _queueTime,
        uint _status,
        uint256 _profit
        ) 
        private 
        isCreator
        {
            queueBAccount[_qid]=queueBAcc(_qid,_accDad,_qBindex,_queueTime,_status,_profit);
        }

    function checkExitCreator(
        address _user,
        bytes32 _userHash1
        ) 
        private 
        view 
        isCreator 
        returns(bool)
        {
        require(_user==dadAdd[_userHash1].userDad,"Invalid hash");
        if(dadAdd[_userHash1].deposit==levelA){
        uint256 useridA=queueAccount[_userHash1].queueNo;
            uint256 historyvalididA=queueHistoryRecord[creator].nowAHistoryExitCount;
            if(useridA<=historyvalididA)
            {
                return true;
            }
        }else if(dadAdd[_userHash1].deposit==levelB){
            uint256 useridB=queueBAccount[_userHash1].queueNo;
            uint256 historyvalididB=queueHistoryRecord[creator].nowBHistoryExitCount;
           if(useridB<=historyvalididB)
            {
                return true;
            }
        }
        return false;
        }
    
    function registerByMultiUserCreator(
        address payable _user,
        uint256 _value
        ) 
        private 
        {
        id++;
        bytes32 newUserHash=keccak256(abi.encodePacked(id,_user,accountView[_user].referrer,_value,getTime()));
        if(_value==levelA){
            insertNewQueue(newUserHash,_user,_value);
            accountView[_user].joinCountA=accountView[_user].joinCountA.add(1);
        }
        if(_value==levelB){
            insertNewBQueue(newUserHash,_user,_value);
            accountView[_user].joinCountB=accountView[_user].joinCountB.add(1);
        }
        detectwinnerCreator(_user,id);
        dadAdd[newUserHash]=dadList(id,newUserHash,_user,getTime(),_value);
        accountView[_user].lastHash=newUserHash;
        accountView[_user].lastJoinTime=getTime();
        accountView[_user].totalDeposit=getTotalDeposit(_user,_value);
        keepHash[id]=hashKey(newUserHash,id,_user);
        directRewardsAdd(newUserHash,_user,_value);
        updateJackpot(_value);
        emit RegistrationSuccess(_user,accountView[_user].referrer,_value,getTime());
    }

    function directRewardsAdd(
        bytes32 _hash, 
        address payable _user, 
        uint256 _deposit
        )  
        private 
        isCreator
        {
        address userDadTo=accountView[_user].referrer;
        uint256 _amt=_deposit.mul(16).div(100);
        index++;
        userProfitHistory[index]=userProfitHis(index,_hash,_user,userDadTo,_amt,getTime());
        accountView[_user].totalProfit=accountView[_user].totalProfit.add(_amt);
        uint256 _devAmt1=_deposit.mul(1).div(100);
        uint256 _devAmt2=_deposit.mul(2).div(100);
        uint256 _devAmt16=_deposit.mul(16).div(100);
        contBalance[creator].conAddBalance1=contBalance[creator].conAddBalance1.add(_devAmt1);
        contBalance[creator].conAddBalance2=contBalance[creator].conAddBalance2.add(_devAmt1);
        contBalance[creator].conAddBalance4=contBalance[creator].conAddBalance4.add(_devAmt16);
        contBalance[creator].updatedTime1=getTime();
        contBalance[creator].updatedTime2=getTime();
        contBalance[creator].updatedTime4=getTime();
        _user.transfer(_amt);
        contBalance[creator].conAdd1.transfer(_devAmt1);
        contBalance[creator].conAdd2.transfer(_devAmt2);
        contBalance[creator].conAdd4.transfer(_devAmt16);
    }

    function detectwinnerCreator(
        address payable _user,
        uint _uid
        ) 
        private 
        isCreator
        {
        uint pool=JackPotBalance[creator].poolBalance;
        uint _amt=pool.mul(35).div(1000);
         if((_uid.mod(18)==0) || (_uid.mod(19)==0) || (_uid.mod(27)==0) || (_uid.mod(38)==0) || (_uid.mod(39)==0) )
       {
       JackPotBalance[creator].poolBalance=JackPotBalance[creator].poolBalance.sub(_amt);
       LuckyDraw[1]=luckyWinner(_user,_amt,getTime());
        _user.transfer(_amt);
        emit LuckyWin(_user,_amt,_uid);
        }
    }

    function getCreator() external view returns (address) {
        return creator;
    }
}