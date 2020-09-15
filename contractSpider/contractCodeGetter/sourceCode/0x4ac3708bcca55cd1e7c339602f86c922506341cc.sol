/* Orchid - WebRTC P2P VPN Market (on Ethereum)
 * Copyright (C) 2017-2019  The Orchid Authors
*/

/* GNU Affero General Public License, Version 3 {{{ */
/*
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.

 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
**/
/* }}} */


pragma solidity 0.6.6;

import "./include.sol";

contract OrchidLocked is OrchidSeller, OrchidVerifier {
    mapping (bytes => mapping(address => bytes)) receipts_;

    uint constant required_ = 2;

    function find(address signer) internal pure returns (uint) {
        if (signer == address(0x202a386C81791b54F07172cd7F7f3F1ffC554095)) return 0;
        if (signer == address(0x0d91Af68970cE7C2f293c8d7A223Ab5e86C1BA11)) return 1;
        if (signer == address(0x773f0E58eA6aAe0960e990F9df034589CF5f52B5)) return 2;

        require(false);
    }

    function book(bytes memory shared, address target, bytes memory receipt) override public pure {
        bytes32 message = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(target, shared))));

        require(receipt.length == 65 * required_);

        uint needed = 0;

        for (uint i = 0; i != required_; ++i) {
            uint256 offset = i * 65;

            bytes32 r;
            bytes32 s;
            uint8 v;

            assembly {
                r := mload(add(receipt, add(offset, 32)))
                s := mload(add(receipt, add(offset, 64)))
                v := and(mload(add(receipt, add(offset, 65))), 255)
            }

            uint signer = find(ecrecover(message, v, r, s));
            require(signer >= needed);
            needed = signer + 1;
        }
    }

    function list(bytes calldata shared, address target, bytes calldata receipt) external {
        book(shared, target, receipt);
        receipts_[shared][target] = receipt;
    }

    function ring(bytes calldata shared, address target) override external view returns (bytes memory) {
        bytes storage receipt = receipts_[shared][target];
        require(receipt.length != 0);
        return receipt;
    }
}