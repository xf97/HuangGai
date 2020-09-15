/**
 *Submitted for verification at Etherscan.io on 2020-05-11
*/

// Copyright (C) 2020, The Maker Foundation
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

// https://github.com/makerdao/sai/blob/master/src/top.sol
contract SaiTopAbstract {
    function vox() public view returns (address);
    function tub() public view returns (address);
    function tap() public view returns (address);
    function sai() public view returns (address);
    function sin() public view returns (address);
    function skr() public view returns (address);
    function gem() public view returns (address);
    function fix() public view returns (uint256);
    function fit() public view returns (uint256);
    function caged() public view returns (uint256);
    function cooldown() public view returns (uint256);
    function era() public view returns (uint256);
    function cage() public;
    function flow() public;
    function setCooldown(uint256) public;
    function authority() public view returns (address);
    function owner() public view returns (address);
    function setOwner(address) public;
    function setAuthority(address) public;
}

contract SaiSlayer {
    uint256 constant public T2020_05_12_1600UTC = 1589299200;
    SaiTopAbstract constant public SAITOP = SaiTopAbstract(0x9b0ccf7C8994E19F39b2B4CF708e0A7DF65fA8a3);

    function cage() public {
        require(now >= T2020_05_12_1600UTC);
        SAITOP.cage();
    }
}