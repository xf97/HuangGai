// SPDX-License-Identifier: GPL-3.0-or-later

// Smart Contract for Trustless Escrow at https://trustlessescrow.com

pragma solidity ^0.6.0;

import "./SafeMath.sol";


contract EscrowRegistry {
    using SafeMath for uint;

    //////////////////////////////////////////////////////////
    // Modifiers
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only owner can call this."
        );
        _;
    }

    //////////////////////////////////////////////////////////
    // Custom data types
    /*
     * 0. Init
     * 1. BuyerLocked or SellerLocked
     * 2. Locked
     * 3. Inactive
     */
    enum State {
        Init,
        BuyerLocked,
        SellerLocked,
        Locked,
        Inactive
    }

    struct Escrow {
        State state;

        uint value;
        uint buyerDeposit;
        uint sellerDeposit;
        uint expireAt;
        address payable buyer;
        address payable seller;
    }

    //////////////////////////////////////////////////////////
    // Constants
    uint constant one_hour = 60 * 60;
    uint constant one_day = 24 * one_hour;
    uint constant one_year = 365 * one_day;
    uint constant min_expiration_time = 3 * one_day;
    uint constant max_expiration_time = 3 * one_year;

    //////////////////////////////////////////////////////////
    // Data
    address payable owner;
    mapping(bytes24 => Escrow) escrows;
    uint feePct;  // in 0.01% i.e fee = value * fee_pct / 10000
    uint feeStore;

    //////////////////////////////////////////////////////////
    // Events
    event EscrowCreated(bytes24 indexed escrowId, bool buyerCreated, address indexed buyer, address indexed seller);
    event BuyerAborted(bytes24 indexed escrowId);
    event SellerAborted(bytes24 indexed escrowId);
    event BuyerConfirmed(bytes24 indexed escrowId);
    event SellerConfirmed(bytes24 indexed escrowId);
    event Completed(bytes24 indexed escrowId);
    event Expired(bytes24 indexed escrowId);

    //////////////////////////////////////////////////////////
    // Functions
    function getUniqueKey() internal view returns (bytes24) {
        bytes24 uniqId = bytes24(keccak256(abi.encodePacked(msg.sender, blockhash(block.number - 1))));
        while (escrows[uniqId].value != 0) {
            uniqId = bytes24(keccak256(abi.encodePacked(uniqId)));
        }
        return uniqId;
    }

    constructor() public {
        owner = msg.sender;
        feePct = 10;
        feeStore = 0;
    }

    function changeOwner(address payable newOwner) public onlyOwner {
        owner = newOwner;
    }

    function setFee(uint newFeePct) public onlyOwner {
        feePct = newFeePct;
    }

    function emptyFeeStore() public onlyOwner {
        require(feeStore > 0, "Fee store is empty");
        owner.transfer(feeStore);
        feeStore = 0;
    }

    function buyerCreate(uint value, address payable seller, uint sellerDeposit, uint expireIn) public payable {
        require(value > 0 && value <= msg.value, "Invalid value");
        require(expireIn >= min_expiration_time && expireIn <= max_expiration_time, "Invalid expiration time");
        bytes24 escrowId = getUniqueKey();
        emit EscrowCreated(escrowId, true, msg.sender, seller);
        escrows[escrowId] = Escrow({
            expireAt: now + expireIn,
            value: value,
            buyerDeposit: msg.value - value,
            sellerDeposit: sellerDeposit,
            buyer: msg.sender,
            seller: seller,
            state: State.BuyerLocked
        });
    }

    function sellerCreate(uint value, address payable buyer, uint buyerDeposit, uint expireIn) public payable {
        require(value > 0, "Invalid value");
        require(expireIn >= min_expiration_time && expireIn <= max_expiration_time, "Invalid expiration time");
        bytes24 escrowId = getUniqueKey();
        emit EscrowCreated(escrowId, false, buyer, msg.sender);
        escrows[escrowId] = Escrow({
            expireAt: now + expireIn,
            value: value,
            buyerDeposit: buyerDeposit,
            sellerDeposit: msg.value,
            buyer: buyer,
            seller: msg.sender,
            state: State.SellerLocked
        });
    }

    function buyerConfirm(bytes24 escrowId) public payable {
        emit BuyerConfirmed(escrowId);
        Escrow storage e = escrows[escrowId];
        require(e.state == State.SellerLocked, "Invalid state");
        require(msg.sender == e.buyer, "Not allowed");
        require(msg.value == e.value + e.buyerDeposit, "Invalid amount sent");
        e.state = State.Locked;
    }

    function sellerConfirm(bytes24 escrowId) public payable {
        emit SellerConfirmed(escrowId);
        Escrow storage e = escrows[escrowId];
        require(e.state == State.BuyerLocked, "Invalid state");
        require(msg.sender == e.seller, "Not allowed");
        require(msg.value == e.sellerDeposit, "Invalid amount sent");
        e.state = State.Locked;
    }

    function buyerAbort(bytes24 escrowId) public {
        emit BuyerAborted(escrowId);
        Escrow storage e = escrows[escrowId];
        require(e.state == State.BuyerLocked, "Invalid state");
        require(msg.sender == e.buyer, "Not allowed");
        e.state = State.Inactive;
        e.buyer.transfer(e.value + e.buyerDeposit);
    }

    function sellerAbort(bytes24 escrowId) public {
        emit SellerAborted(escrowId);
        Escrow storage e = escrows[escrowId];
        require(e.state == State.SellerLocked, "Invalid state");
        require(msg.sender == e.seller, "Not allowed");
        e.state = State.Inactive;
        e.seller.transfer(e.sellerDeposit);
    }

    function complete(bytes24 escrowId) public {
        emit Completed(escrowId);
        Escrow storage e = escrows[escrowId];
        require(e.state == State.Locked, "Invalid state");
        require(msg.sender == e.buyer, "Not allowed");
        uint fee = e.value * feePct / 10000;
        e.state = State.Inactive;
        feeStore += fee;
        e.buyer.transfer(e.buyerDeposit);
        e.seller.transfer(e.value - fee + e.sellerDeposit);
    }

    function expire(bytes24 escrowId) public onlyOwner {
        emit Expired(escrowId);
        Escrow storage e = escrows[escrowId];
        require(e.state == State.Locked, "Invalid state");
        require(now > e.expireAt, "Not expired");
        e.state = State.Inactive;
        owner.transfer(e.value + e.buyerDeposit + e.sellerDeposit);
    }

    function getEscrow(bytes24 escrowId) public view returns (State state, uint value, uint buyerDeposit,
                                                              uint sellerDeposit, uint expireAt, address buyer, address seller) {
        Escrow storage e = escrows[escrowId];
        require(e.state != State.Init, "Not found");

        return (e.state, e.value, e.buyerDeposit, e.sellerDeposit, e.expireAt, e.buyer, e.seller);
    }

    function isEscrowExpired(bytes24 escrowId) public view returns (bool) {
        Escrow storage e = escrows[escrowId];
        require(e.state != State.Init, "Not found");
        return now > e.expireAt;
    }
}
