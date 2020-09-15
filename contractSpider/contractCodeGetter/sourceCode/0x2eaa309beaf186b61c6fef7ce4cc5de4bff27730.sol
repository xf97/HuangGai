// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./SafeERC20.sol";
import "./Ownable.sol";
import "./IUniswapV2Router.sol";

interface Pauseable {
    function unpause() external;
}

/**
 * @title TacosCrowdsale
 * @dev Crowdsale contract for $TACO.
 *      Pre-Sale done in this manner:
 *        1st Round: Early Cooks (2 ETH contribution max during round, CAP 70 ETH)
 *        2nd Round: $KARMA holders (2 ETH contribution max during round, CAP 70 ETH)
 *        3rd Round: Public Sale (2 ETH contribution max during round, CAP 70 ETH)
 *        - Any single address can contribute at most 2 ETH -
 *      1 ETH = 20000 $TACO (during the entire sale)
 *      Hardcap = 210 ETH
 *      Once hardcap is reached:
 *        All liquidity is added to Uniswap and locked automatically, 0% risk of rug pull.
 *
 * @author soulbar@protonmail.com ($TEND)
 * @author @Onchained ($TACO)
 */
contract TacosCrowdsale is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    //===============================================//
    //          Contract Variables                   //
    //===============================================//

    // Caps
    uint256 public constant ROUND_1_CAP = 70 ether; // CAP = 70
    uint256 public constant ROUND_2_CAP = 140 ether; // CAP = 70
    uint256 public constant ROUND_3_CAP = 210 ether; // CAP = 70
    // HARDCAP = ROUND_3_CAP
    
    // During tests, we should use 12 ether instead given that by default we only have 20 addresses.
    uint256 public constant CAP_PER_ADDRESS = 2 ether;
    uint256 public constant MIN_CONTRIBUTION = 0.1 ether;

    // Start time 08/09/2020 @ 6:00am (UTC) // For Cooks
    uint256 public constant CROWDSALE_START_TIME = 1596952800;

    // Start time 08/10/2020 @ 4:00pm (UTC)
    uint256 public constant KARMASALE_START_TIME = 1597075200;

    // Start time 08/11/2020 @ 4:00pm (UTC)
    uint256 public constant PUBLICSALE_START_TIME = 1597161600;

    // End time
    uint256 public constant CROWDSALE_END_TIME = PUBLICSALE_START_TIME + 1 days;

    // Karma Membership = 200 Karma
    uint256 public constant KARMA_MEMBERSHIP_AMOUNT = 2000000;

    // Early cooks list for round 1
    // Too many cooks? https://www.youtube.com/watch?v=QrGrOK8oZG8
    mapping(address => bool) public cookslist;

    // Contributions state
    mapping(address => uint256) public contributions;

    // Total wei raised (ETH)
    uint256 public weiRaised;

    // Flag to know if liquidity has been locked
    bool public liquidityLocked = false;

    // Pointer to the TacoToken
    IERC20 public tacoToken;

    // Pointer to the KarmaToken
    IERC20 public karmaToken;

    // How many tacos do we send per ETH contributed.
    uint256 public tacosPerEth;

    // Pointer to the UniswapRouter
    IUniswapV2Router02 internal uniswapRouter;

    //===============================================//
    //                 Constructor                   //
    //===============================================//
    constructor(
        IERC20 _tacoToken,
        IERC20 _karmaToken,
        uint256 _tacosPerEth,
        address _uniswapRouter
    ) public Ownable() {
        tacoToken = _tacoToken;
        karmaToken = _karmaToken;
        tacosPerEth = _tacosPerEth;
        uniswapRouter = IUniswapV2Router02(_uniswapRouter);
    }

    //===============================================//
    //                   Events                      //
    //===============================================//
    event TokenPurchase(
        address indexed beneficiary,
        uint256 weiAmount,
        uint256 tokenAmount
    );

    //===============================================//
    //                   Methods                     //
    //===============================================//

    // Main entry point for buying into the Pre-Sale. Contract Receives $ETH
    receive() external payable {
        // Prevent owner from buying tokens, but allow them to add pre-sale ETH to the contract for Uniswap liquidity
        if (owner() != msg.sender) {
            // Validations.
            require(
                msg.sender != address(0),
                "TacosCrowdsale: beneficiary is the zero address"
            );
            require(isOpen(), "TacosCrowdsale: sale did not start yet.");
            require(!hasEnded(), "TacosCrowdsale: sale is over.");
            require(
                weiRaised < _totalCapForCurrentRound(),
                "TacosCrowdsale: The cap for the current round has been filled."
            );
            require(
                _allowedInCurrentRound(msg.sender),
                "TacosCrowdsale: Address not allowed for this round."
            );
            require(
                contributions[msg.sender] < CAP_PER_ADDRESS,
                "TacosCrowdsale: Individual cap has been filled."
            );

            // If we've passed most validations, let's get them $TACOs
            _buyTokens(msg.sender);
        }
    }

    /**
     * Function to calculate how many `weiAmount` can the sender purchase
     * based on total available cap for this round, and how many eth they've contributed.
     *
     * At the end of the function we refund the remaining ETH not used for purchase.
     */
    function _buyTokens(address beneficiary) internal {
        // How much ETH still available for the current Round CAP
        uint256 weiAllowanceForRound = _totalCapForCurrentRound().sub(weiRaised);

        // In case there is less allowance in this cap than what was sent, cap that.
        uint256 weiAmountForRound = weiAllowanceForRound < msg.value
            ? weiAllowanceForRound
            : msg.value;

        // How many wei is this sender still able to get per their address CAP.
        uint256 weiAllowanceForAddress = CAP_PER_ADDRESS.sub(
            contributions[beneficiary]
        );

        // In case the allowance of this address is less than what was sent, cap that.
        uint256 weiAmount = weiAllowanceForAddress < weiAmountForRound
            ? weiAllowanceForAddress
            : weiAmountForRound;

        // Internal call to run the final validations, and perform the purchase.
        _buyTokens(beneficiary, weiAmount, weiAllowanceForRound);

        // Refund all unused funds.
        uint256 refund = msg.value.sub(weiAmount);
        if (refund > 0) {
            payable(beneficiary).transfer(refund);
        }
    }

    /**
     * Function that validates the minimum wei amount, then perform the actual transfer of $TACOs
     */
    function _buyTokens(address beneficiary, uint256 weiAmount, uint256 weiAllowanceForRound) internal {
        require(
            weiAmount >= MIN_CONTRIBUTION || weiAllowanceForRound < MIN_CONTRIBUTION,
            "TacosCrowdsale: weiAmount is smaller than min contribution."
        );

        // Update how much wei we have raised
        weiRaised = weiRaised.add(weiAmount);
        // Update how much wei has this address contributed
        contributions[beneficiary] = contributions[beneficiary].add(weiAmount);

        // Calculate how many $TACOs can be bought with that wei amount
        uint256 tokenAmount = _getTokenAmount(weiAmount);
        // Transfer the $TACOs to the beneficiary
        tacoToken.safeTransfer(beneficiary, tokenAmount);

        // Create an event for this purchase
        emit TokenPurchase(beneficiary, weiAmount, tokenAmount);
    }

    // Calculate how many tacos do they get given the amount of wei
    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256)
    {
        return weiAmount.mul(tacosPerEth);
    }

    // CONTROL FUNCTIONS

    // Is the sale open now?
    function isOpen() public view returns (bool) {
        return now >= CROWDSALE_START_TIME;
    }

    // Has the sale ended?
    function hasEnded() public view returns (bool) {
        return now >= CROWDSALE_END_TIME || weiRaised >= ROUND_3_CAP;
    }

    // Has the *Karma* sale started?
    function karmaSaleStarted() public view returns (bool) {
        return now >= KARMASALE_START_TIME;
    }

    // Has the *Public* sale started?
    function publicSaleStarted() public view returns (bool) {
        return now >= PUBLICSALE_START_TIME;
    }

    // Is the beneficiary allowed in the current Round?
    function _allowedInCurrentRound(address beneficiary) internal view returns (bool) {
        bool isKarmaRoundAndMember = karmaSaleStarted() && _isKarmaMember(beneficiary);

        return (cookslist[beneficiary] || isKarmaRoundAndMember || publicSaleStarted());
    }

    // Checks wether the beneficiary is a Karma member.
    // Karma membership is defined as owning 200 $KARMA
    // Thank you KarmaDAO for getting us together.
    function _isKarmaMember(address beneficiary) internal view returns (bool) {
        return karmaToken.balanceOf(beneficiary) >= KARMA_MEMBERSHIP_AMOUNT;
    }

    // What's the total cap for the current round?
    function _totalCapForCurrentRound() internal view returns (uint256) {
        if (publicSaleStarted()) {
            return ROUND_3_CAP;
        } else if(karmaSaleStarted()) {
            return ROUND_2_CAP;
        } else { // Cooks sale
            return ROUND_1_CAP;
        }
    }

    // Return human-readable currentRound
    function getCurrentRound() public view returns (string memory) {
        if (publicSaleStarted()) return "Public";
        if (karmaSaleStarted()) return "Karma";
        return "Cooks";
    }

    // Set the cooks list
    function setCooksList(address[] calldata accounts) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            cookslist[accounts[i]] = true;
        }
    }

    /**
     * Function that once sale is complete add the liquidity to Uniswap
     * then locks the liquidity by burning the UNI tokens.
     */
    function addAndLockLiquidity() external {
        require(
            hasEnded(),
            "TacosCrowdsale: can only send liquidity once hardcap is reached"
        );

        // How many ETH is in this contract
        uint256 amountEthForUniswap = address(this).balance;
        // How many $TACOs are owned by this contract
        uint256 amountTokensForUniswap = tacoToken.balanceOf(address(this));

        // Unpause TacoToken forever. This will kick off the game.
        Pauseable(address(tacoToken)).unpause();

        // Send the entire balance and all tokens in the contract to Uniswap LP
        tacoToken.approve(address(uniswapRouter), amountTokensForUniswap);
        uniswapRouter.addLiquidityETH{value: amountEthForUniswap}(
            address(tacoToken),
            amountTokensForUniswap,
            amountTokensForUniswap,
            amountEthForUniswap,
            address(0), // burn address
            now
        );
        liquidityLocked = true;
    }
}
