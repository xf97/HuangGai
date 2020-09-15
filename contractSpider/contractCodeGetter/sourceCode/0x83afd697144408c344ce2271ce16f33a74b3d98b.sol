pragma solidity ^0.4.24;

import "./BimodalProxy.sol";
import "./DepositProxy.sol";
import "./WithdrawalProxy.sol";
import "./ChallengeProxy.sol";
import "./RecoveryProxy.sol";
import "./SafeMathLib256.sol";

/**
 * This is the main Parent-chain Verifier contract. It inherits all of the proxy
 * contracts and provides a single address to interact with all the moderated
 * balance pools. Proxies define the exposed methods, events and enforce the
 * modifiers of library methods.
 */
contract NOCUSTCommitChain is
    BimodalProxy,
    DepositProxy,
    WithdrawalProxy,
    ChallengeProxy,
    RecoveryProxy
{
    using SafeMathLib256 for uint256;

    /**
     * This is the main constructor.
     * @param blocksPerEon - The number of blocks per eon.
     * @param operator - The IMMUTABLE address of the operator.
     */
    constructor(uint256 blocksPerEon, address operator)
        public
        BimodalProxy(blocksPerEon, operator)
    {
        // Support ETH by default
        ledger.trailToToken.push(address(this));
        ledger.tokenToTrail[address(this)] = 0;
    }

    /**
     * This allows the operator to register the existence of another ERC20 token
     * @param token - ERC20 token address
     */
    function registerERC20(ERC20 token) public onlyOperator() {
        require(ledger.tokenToTrail[token] == 0);
        ledger.tokenToTrail[token] = uint64(ledger.trailToToken.length);
        ledger.trailToToken.push(token);
    }

    /**
     * This method allows the operator to submit one checkpoint per eon that
     * synchronizes the commit-chain ledger with the parent chain.
     * @param accumulator - The accumulator of the previous eon under which this checkpoint is calculated.
     * @param merkleRoot - The checkpoint merkle root.
     */
    function submitCheckpoint(bytes32 accumulator, bytes32 merkleRoot)
        public
        onlyOperator()
        onlyWhenContractUnpunished()
    {
        uint256 eon = ledger.currentEon();
        require(
            ledger.parentChainAccumulator[eon.sub(1).mod(ledger.EONS_KEPT)] ==
                accumulator,
            "b"
        );
        require(ledger.getLiveChallenges(eon.sub(1)) == 0, "c");
        require(eon > ledger.lastSubmissionEon, "d");

        ledger.lastSubmissionEon = eon;

        BimodalLib.Checkpoint storage checkpoint = ledger.getOrCreateCheckpoint(
            eon,
            eon
        );
        checkpoint.merkleRoot = merkleRoot;

        emit CheckpointSubmission(eon, merkleRoot);
    }
}
