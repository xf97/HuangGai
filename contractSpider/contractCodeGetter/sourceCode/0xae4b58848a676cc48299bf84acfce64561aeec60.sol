/**
 *Submitted for verification at Etherscan.io on 2020-07-30
*/

// Copyright (C) 2018 Rain <rainbreak@riseup.net>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity 0.5.12;

contract LibNote {
    event LogNote(
        bytes4   indexed  sig,
        address  indexed  usr,
        bytes32  indexed  arg1,
        bytes32  indexed  arg2,
        bytes             data
    ) anonymous;

    modifier note {
        _;
        assembly {
            // log an 'anonymous' event with a constant 6 words of calldata
            // and four indexed topics: selector, caller, arg1 and arg2
            let mark := msize                         // end of memory ensures zero
            mstore(0x40, add(mark, 288))              // update free memory pointer
            mstore(mark, 0x20)                        // bytes type data offset
            mstore(add(mark, 0x20), 224)              // bytes size (padded)
            calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
            log4(mark, 288,                           // calldata
                 shl(224, shr(224, calldataload(0))), // msg.sig
                 caller,                              // msg.sender
                 calldataload(4),                     // arg1
                 calldataload(36)                     // arg2
                )
        }
    }
}

contract PitchLike {
    function transfer(address,uint) external returns (bool);
    function transferFrom(address,address,uint) external returns (bool);
}


contract Pitch2Like {
    function mint(address,uint) external;
    function burn(address,uint) external;
}


/*
    Here we provide *adapter* to swap Pitch tokens to the Pitch - v2 tokens. The
    adapters here are provided as working examples:
      - `PitchLike`: For well behaved ERC20 tokens, with simple transfer
                   semantics.
      - `Pitch2Like`: For DAI-like tokens, with ability to mint and burn tokens.

    Adapter has two basic methods:
      - `join`: enter collateral into the system
      - `exit`: remove collateral from the system
*/

contract PitchSwap is LibNote {
    // --- Auth ---
    mapping (address => uint) public wards;
    function rely(address usr) external note auth { wards[usr] = 1; }
    function deny(address usr) external note auth { wards[usr] = 0; }
    modifier auth {
        require(wards[msg.sender] == 1, "PitchSwap/not-authorized");
        _;
    }

    Pitch2Like public pitch2;
    PitchLike public pitch;
    uint    public live;  // Access Flag

    constructor(address pitch2_, address pitch_) public {
        wards[msg.sender] = 1;
        live = 1;
        pitch2 = Pitch2Like(pitch2_);
        pitch = PitchLike(pitch_);
    }

    function cage() external note auth {
        live = 0;
    }

	// In wad input we have 1E9 and will convert to 1E18
	// we need to mul input wad to 1E9 (10**9)
	uint constant ONE = 10 ** 9; //10 ** 18;
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    function join(address usr, uint wad) external note {
        require(live == 1, "PitchSwap/not-live");
        require(int(wad) >= 0, "PitchSwap/overflow");
		// mul to get 18 decimals
        pitch2.mint(usr, mul(ONE, wad));
        require(pitch.transferFrom(msg.sender, address(this), wad), "PitchSwap/failed-transfer");
    }

    function exit(address usr, uint wad) external note {
        require(wad <= 2 ** 255, "PitchSwap/overflow");
		// mul to get 18 decimals
        pitch2.burn(usr, mul(ONE, wad));
        require(pitch.transfer(usr, wad), "PitchSwap/failed-transfer");
    }
}