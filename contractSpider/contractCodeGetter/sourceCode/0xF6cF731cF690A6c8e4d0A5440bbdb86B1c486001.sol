/**
 *Submitted for verification at Etherscan.io on 2020-07-30
*/

// SPDX-License-Identifier: AGPL-3.0-or-later

/// Drizzle.sol -- Publicly updatable ilk registry

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

pragma solidity ^0.6.7;

interface IlkRegistry {
    function list() external view returns (bytes32[] memory);
}

interface PotLike {
    function drip() external;
}

interface JugLike {
    function drip(bytes32) external;
}

contract Drizzle {

    IlkRegistry private _reg;
    PotLike     private _pot;
    JugLike     private _jug;

    constructor(address ilkRegistry, address dss_pot, address dss_jug) public {
        _reg = IlkRegistry(ilkRegistry);
        _pot = PotLike(dss_pot);
        _jug = JugLike(dss_jug);
    }

    function drizzle(bytes32[] memory ilks) public {
        _pot.drip();
        for (uint i = 0; i < ilks.length; i++) {
            _jug.drip(ilks[i]);
        }
    }

    function drizzle() external {
        bytes32[] memory ilks = _reg.list();
        drizzle(ilks);
    }

    function registry() external view returns (address) {
        return address(_reg);
    }

    function pot() external view returns (address) {
        return address(_pot);
    }

    function jug() external view returns (address) {
        return address(_jug);
    }
}