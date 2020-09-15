pragma solidity >=0.5.0;

import "./Ownable.sol";
import "./SafeMath.sol";


/**
 * @title DualityConsole
 * Duality is a simple smart contract that allows two parties to open up a Duality contract
 * together where each party has their own currency, but this currency can only be
 * redeemed back to the party that minted them. This allows one party to mint
 * tokens as a gift to the other party, and the other party may then come back in the
 * future to redeem this currency for goods or services.
 */
contract DualityConsole is Ownable {
    using SafeMath for uint256;

    uint256 DUALITY_COST_WEI = 10**16; // 0.01 ETH

    /// @notice Event to fire when a new duality conract is created
    event DualityCreated(uint256 indexed dualityId, string name);
    /// @notice Event to fire when one party mints tokens
    event Minted(
        uint256 indexed dualityId,
        address indexed by,
        uint256 indexed amount
    );
    /// @notice Event to fire when one party burns tokens
    event Burned(
        uint256 indexed dualityId,
        address indexed by,
        uint256 indexed amount
    );

    struct Duality {
        string name; // Name of Duality
        address aOne; // Address of party one
        string nOne; // Name of party one
        uint256 bOne; // Balance of party one
        address aTwo; // Address of party two
        string nTwo; // Name of party two
        uint256 bTwo; // Balance of part two
    }

    Duality[] public dualities;

    /// @notice Modifier used to ensure the correct payment has been made
    /// @param _weiCost -The amount in wei that the payment needs to be
    /// @dev Required that msg.value is greater than or equal to _weiCost. Also,
    ///  _splitPayment is NOT used when a crest is purchased. The majority
    ///  of that payment goes to the previous owner obviously.
    modifier sufficientPayment(uint256 _weiCost) {
        require(
            (msg.value >= _weiCost) || isOwner(),
            "There is not a sufficient payment to perform this action."
        );
        _;
        if (msg.value > _weiCost) msg.sender.transfer(msg.value - _weiCost);
    }

    function getDualityCount() public returns (uint256) {
        return dualities.length;
    }

    /// @param dualityName Name given to the created crest
    /// @param partyOneName Address that receives the fees for this crest.
    function createDuality(
        string calldata dualityName,
        string calldata partyOneName,
        string calldata partyTwoName,
        address partyTwoAddress
    ) external payable sufficientPayment(DUALITY_COST_WEI) returns (uint256) {
        // TEST
        require(
            msg.sender != partyTwoAddress && partyTwoAddress != address(0),
            "Party two address cannot be the same as senders or be address zero."
        );

        uint256 tokenId = dualities.push(
            Duality(
                dualityName,
                msg.sender, // One Address
                partyOneName, // One Name
                0, // One Balance
                partyTwoAddress, // Two Address
                partyTwoName, // Two Name
                0 // Two Balance
            )
        ) - 1; // push() returns the new length of the array

        emit DualityCreated(tokenId, dualityName);
        return tokenId;
    }

    function withdrawalFunds() external payable onlyOwner() {
        msg.sender.transfer(address(this).balance);
    }

    function setPartyName(uint256 dualityId, string calldata name) external {
        require(dualityId < dualities.length, "This is an invalid dualityId");
        Duality storage duality = dualities[dualityId];
        if (duality.aOne == msg.sender) {
            duality.nOne = name;
            return;
        }
        require(
            duality.aTwo == msg.sender,
            "Sender address is not included in this duality."
        );
        duality.nTwo = name;
    }

    function mintDualityDollars(uint256 dualityId, uint256 amount) external {
        require(dualityId < dualities.length, "This is an invalid dualityId");
        Duality storage duality = dualities[dualityId];
        if (duality.aOne == msg.sender) {
            // Here we are minting tokens for the other party
            duality.bTwo = duality.bTwo.add(amount);
            return;
        }
        require(
            duality.aTwo == msg.sender,
            "Sender address is not included in this duality."
        );
        // Here we are minting tokens for the other party
        duality.bOne = duality.bOne.add(amount);
    }

    function burnDualityDollars(uint256 dualityId, uint256 amount) external {
        require(dualityId < dualities.length, "This is an invalid dualityId");
        Duality storage duality = dualities[dualityId];
        if (duality.aOne == msg.sender) {
            require(
                duality.bOne >= amount,
                "Sender does not have anout duality dollars to perform this action."
            );
            // Here we are burning tokens from the senders own balance
            duality.bOne -= amount;
            return;
        }
        require(
            duality.aTwo == msg.sender,
            "Sender address is not included in this duality."
        );
        require(
            duality.bTwo >= amount,
            "Sender does not have anout duality dollars to perform this action."
        );
        // Here we are burning tokens from the senders own balance
        duality.bTwo -= amount;
    }
}
