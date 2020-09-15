pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

import "../../libraries/LibOrder.sol";


contract EIP712FillHasher {

    // EIP191 header for EIP712 prefix
    bytes2 constant private EIP191_HEADER = 0x1901;

    // EIP712 Domain Name value
    string constant private EIP712_DOMAIN_NAME = "SportX";

    // EIP712 Domain Version value
    string constant private EIP712_DOMAIN_VERSION = "1.0";

    // EIP712 typeHash of EIP712Domain
    bytes32 constant private EIP712_DOMAIN_SCHEMA_HASH = keccak256(
        abi.encodePacked(
            "EIP712Domain(",
            "string name,",
            "string version,",
            "uint256 chainId,",
            "address verifyingContract",
            ")"
        )
    );

    // EIP712 encodeType of Details
    bytes constant private EIP712_DETAILS_STRING = abi.encodePacked(
        "Details(",
        "string action,",
        "string market,",
        "string betting,",
        "string stake,",
        "string odds,",
        "string returning,",
        "FillObject fills",
        ")"
    );

    // EIP712 encodeType of FillObject
    bytes constant private EIP712_FILL_OBJECT_STRING = abi.encodePacked(
        "FillObject(",
        "Order[] orders,",
        "bytes[] makerSigs,",
        "uint256[] takerAmounts,",
        "uint256 fillSalt",
        ")"
    );

    // EIP712 encodeType of Order
    bytes constant private EIP712_ORDER_STRING = abi.encodePacked(
        "Order(",
        "bytes32 marketHash,",
        "address baseToken,",
        "uint256 totalBetSize,",
        "uint256 percentageOdds,",
        "uint256 expiry,",
        "uint256 salt,",
        "address maker,",
        "address executor,",
        "bool isMakerBettingOutcomeOne",
        ")"
    );

    // EIP712 typeHash of Order
    bytes32 constant private EIP712_ORDER_HASH = keccak256(
        abi.encodePacked(
            EIP712_ORDER_STRING
        )
    );

    // EIP712 typeHash of FillObject
    bytes32 constant private EIP712_FILL_OBJECT_HASH = keccak256(
        abi.encodePacked(
            EIP712_FILL_OBJECT_STRING,
            EIP712_ORDER_STRING
        )
    );

    // EIP712 typeHash of FillObjectWithMetadata
    bytes32 constant private EIP712_DETAILS_HASH = keccak256(
        abi.encodePacked(
            EIP712_DETAILS_STRING,
            EIP712_FILL_OBJECT_STRING,
            EIP712_ORDER_STRING
        )
    );

    // solhint-disable var-name-mixedcase
    bytes32 public EIP712_DOMAIN_HASH;

    constructor(uint256 chainId) public {
        EIP712_DOMAIN_HASH = keccak256(
            abi.encode(
                EIP712_DOMAIN_SCHEMA_HASH,
                keccak256(bytes(EIP712_DOMAIN_NAME)),
                keccak256(bytes(EIP712_DOMAIN_VERSION)),
                chainId,
                address(this)
            )
        );
    }

    function getOrderHash(LibOrder.Order memory order)
        public
        pure
        returns (bytes32)
    {
        return keccak256(
            abi.encode(
                EIP712_ORDER_HASH,
                order.marketHash,
                order.baseToken,
                order.totalBetSize,
                order.percentageOdds,
                order.expiry,
                order.salt,
                order.maker,
                order.executor,
                order.isMakerBettingOutcomeOne
            )
        );
    }

    function getOrdersArrayHash(LibOrder.Order[] memory orders)
        public
        pure
        returns (bytes32)
    {
        bytes32[] memory ordersBytes = new bytes32[](orders.length);

        for (uint256 i = 0; i < orders.length; i++) {
            ordersBytes[i] = getOrderHash(orders[i]);
        }
        return keccak256(abi.encodePacked(ordersBytes));
    }

    function getMakerSigsArrayHash(bytes[] memory sigs)
        public
        pure
        returns (bytes32)
    {
        bytes32[] memory sigsBytes = new bytes32[](sigs.length);

        for (uint256 i = 0; i < sigs.length; i++) {
            sigsBytes[i] = keccak256(sigs[i]);
        }

        return keccak256(abi.encodePacked(sigsBytes));
    }

    function getFillObjectHash(LibOrder.FillObject memory fillObject)
        public
        pure
        returns (bytes32)
    {
        return keccak256(
            abi.encode(
                EIP712_FILL_OBJECT_HASH,
                getOrdersArrayHash(fillObject.orders),
                getMakerSigsArrayHash(fillObject.makerSigs),
                keccak256(abi.encodePacked(fillObject.takerAmounts)),
                fillObject.fillSalt
            )
        );
    }

    function getDetailsHash(LibOrder.FillDetails memory details)
        public
        view
        returns (bytes32)
    {
        bytes32 structHash = keccak256(
            abi.encode(
                EIP712_DETAILS_HASH,
                keccak256(bytes(details.action)),
                keccak256(bytes(details.market)),
                keccak256(bytes(details.betting)),
                keccak256(bytes(details.stake)),
                keccak256(bytes(details.odds)),
                keccak256(bytes(details.returning)),
                getFillObjectHash(details.fills)
            )
        );
        return keccak256(
            abi.encodePacked(
                EIP191_HEADER,
                EIP712_DOMAIN_HASH,
                structHash
            )
        );
    }

    function getDomainHash()
        public
        view
        returns (bytes32)
    {
        return EIP712_DOMAIN_HASH;
    }
}