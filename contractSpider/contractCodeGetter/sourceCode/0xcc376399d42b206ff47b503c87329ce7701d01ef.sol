// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./IRipper.sol";
import {ABDKMath64x64} from "./ABDKMath64x64.sol";


contract RichBitchCoin {
    address[] public investors;
    mapping(address => uint256) public investments;
    mapping(address => uint256) public balances;
    mapping(address => address) public referrers;
    mapping(address => address[]) referrals;
    mapping(address => uint256) public lastInvestmentBlock;
    uint256 public lastTransactionBlock;
    uint256 public totalInvested = 0;
    address owner;
    address payable treasurer;

    event Investment(
        address investor,
        uint256 amount,
        address referrer,
        bool newArrival
    );

    event Withdrawal(address investor, uint256 amount, address referrer);

    event GameOver(address investor);

    constructor(address payable _treasurer) public {
        owner = msg.sender;
        treasurer = _treasurer;
    }

    function readGraph() public view returns (address[2][] memory) {
        address[2][] memory graph = new address[2][](investors.length);
        for (uint256 i = 0; i < graph.length; i++) {
            address investor = investors[i];
            if (isInvestor(investor)) {
                graph[i][0] = investor;
                graph[i][1] = referrers[investor];
            }
        }
        return graph;
    }

    function invest(address referrer) public payable {
        add(msg.value, msg.sender, referrer);
    }

    function withdraw() public onlyInvestor {
        withdrawAllBalance(msg.sender);
    }

    function add(
        uint256 amount,
        address investor,
        address referrer
    ) private {
        require(amount > 0, "Go home loser");
        bool newArrival = !isInvestor(investor) && !hasReferrer(investor);
        uint256 oldBalance = 0;
        if (isInvestor(investor)) {
            oldBalance = withdrawableBalance(investor);
        }
        if (newArrival) {
            investors.push(investor);
        }
        totalInvested += amount;
        investments[investor] += amount;
        balances[investor] = oldBalance + amount;
        processReferrer(investor, referrer);
        lastInvestmentBlock[investor] = block.number;
        lastTransactionBlock = block.number;
        emit Investment(investor, amount, referrers[investor], newArrival);
    }

    function processReferrer(address investor, address proposedReferrer)
        private
    {
        if (!hasReferrer(investor)) {
            address referrer = proposedReferrer;
            if (!isInvestor(referrer) || investor == referrer) {
                referrer = pickReferrer(investor);
            }
            setReferrer(investor, referrer);
        }
    }

    function setReferrer(address investor, address referrer) private {
        referrers[investor] = referrer;
        referrals[referrer].push(investor);
    }

    function pickReferrer(address investor) private view returns (address) {
        address candidate = address(this);
        for (uint256 i = 0; i < investors.length; i++) {
            if(investors[i] != investor){
                candidate = investors[i];
                uint256 refsNum = referrals[candidate].length;
                if (refsNum == 0) {
                    return candidate;
                }
            }
        }
        return candidate;
    }

    function withdrawAllBalance(address payable investor) private {
        uint256 amount = withdrawableBalance(investor);
        uint256 threshold = totalInvested / 10;
        bool destroy = false;
        if (amount + threshold >= address(this).balance) {
            amount = address(this).balance - threshold;
            destroy = true;
        }
        investments[investor] = 0;
        balances[investor] = 0;
        investor.transfer(amount);
        emit Withdrawal(investor, amount, referrers[investor]);
        updateReferralsOnWithdrawal(investor);
        if (destroy) {
            emit GameOver(investor);
            IRipper(owner).redeploy();
            selfdestruct(treasurer);
        } else {
            lastTransactionBlock = block.number;
        }
    }

    function sweep() public {
        require(msg.sender == treasurer, "Go home loser");
        // make sure a year of inactivity has passed
        require(blocksSinceLastTransaction() > 2250000, "Too early, don\'t be greedy man");
        emit GameOver(treasurer);
        selfdestruct(treasurer);
    }

    function updateReferralsOnWithdrawal(address investor) private {
        address referrer = referrers[investor];
        address[] memory orphanReferrals = referrals[investor];
        for (uint256 i = 0; i < orphanReferrals.length; i++) {
            setReferrer(orphanReferrals[i], referrer);
        }
        delete referrals[investor];
    }

    modifier onlyInvestor() {
        require(
            isInvestor(msg.sender),
            "Only investors with non-zero balance can do this."
        );
        _;
    }

    function isInvestor(address a) public view returns (bool) {
        return balances[a] > 0;
    }

    function hasReferrer(address a) public view returns (bool) {
        return referrers[a] != address(0);
    }

    function referralsCount(address a) public view returns (int128) {
        int128 count = 0;
        for(uint i = 0; i<referrals[a].length; i++){
            if(investments[referrals[a][i]] > investments[a]/2){
                count ++;
            }
        }
        return count;
    }

    function withdrawableBalance(address investor)
        public
        view
        returns (uint256)
    {
        if(balances[investor] == 0){
            return 0;
        }
        return
            interest(
                balances[investor],
                blocksSinceLastInvestment(investor),
                referralsCount(investor)
            );
    }

    function blocksSinceLastInvestment(address investor)
        public
        view
        returns (uint256)
    {
        return block.number - lastInvestmentBlock[investor];
    }

    function blocksSinceLastTransaction()
        public
        view
        returns (uint256)
    {
        return block.number - lastTransactionBlock;
    }

    function interest(
        uint256 balance,
        uint256 blocks,
        int128 refCount
    ) public pure returns (uint256) {
        int128 factor = interestFactor(refCount); //TODO cap multiplier
        return ABDKMath64x64.mulu(ABDKMath64x64.pow(factor, blocks), balance);
    }

    function interestFactor(int128 referralsNum) public pure returns (int128) {
        // ~= 0.00001, ~0.001% per block, ~6% per day
        int128 baseInterestRate = 184467440737096;
        int128 interestRate = baseInterestRate * (1 + referralsNum);
        return (1 << 64) + interestRate; // ~= 1.00001 with base rate;
    }
}
