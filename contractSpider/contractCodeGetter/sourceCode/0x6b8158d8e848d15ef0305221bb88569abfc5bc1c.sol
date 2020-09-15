/**
 *Submitted for verification at Etherscan.io on 2020-06-28
*/

// SPDX-License-Identifier: AGPL-3.0
// The MegaPoker
//
// Copyright (C) 2020 Maker Ecosystem Growth Holdings, INC.
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

pragma solidity >=0.5.12;

abstract contract PotLike {
    function drip() virtual external;
}

abstract contract JugLike {
    function drip(bytes32) virtual external;
}

abstract contract OsmLike {
    function poke() virtual external;
    function pass() virtual external view returns (bool);
}

abstract contract SpotLike {
    function poke(bytes32) virtual external;
}

contract MegaPoker {
    OsmLike constant public eth = OsmLike(0x81FE72B5A8d1A857d176C3E7d5Bd2679A9B85763);
    OsmLike constant public bat = OsmLike(0xB4eb54AF9Cc7882DF0121d26c5b97E802915ABe6);
    OsmLike constant public wbtc = OsmLike(0xf185d0682d50819263941e5f4EacC763CC5C6C42);
    OsmLike constant public knc = OsmLike(0xf36B79BD4C0904A5F350F1e4f776B81208c13069);
    OsmLike constant public zrx = OsmLike(0x7382c066801E7Acb2299aC8562847B9883f5CD3c);
    PotLike constant public pot = PotLike(0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7);
    JugLike constant public jug = JugLike(0x19c0976f590D67707E62397C87829d896Dc0f1F1);
    SpotLike constant public spot = SpotLike(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);

    function poke() external {
        if (eth.pass()) eth.poke();
        if (bat.pass()) bat.poke();
        if (wbtc.pass()) wbtc.poke();
        if (knc.pass()) knc.poke();
        if (zrx.pass()) zrx.poke();
        
        spot.poke("ETH-A");
        spot.poke("BAT-A");
        spot.poke("WBTC-A");
        spot.poke("KNC-A");
        spot.poke("ZRX-A");
        
        jug.drip("ETH-A");
        jug.drip("BAT-A");
        jug.drip("WBTC-A");
        jug.drip("USDC-A");
        jug.drip("USDC-B");
        jug.drip("TUSD-A");
        jug.drip("KNC-A");
        jug.drip("ZRX-A");
        
        pot.drip();
    }
}