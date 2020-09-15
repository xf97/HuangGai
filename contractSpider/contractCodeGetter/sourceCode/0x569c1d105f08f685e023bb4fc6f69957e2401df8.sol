/**
 *Submitted for verification at Etherscan.io on 2020-04-30
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

// https://github.com/dapphub/ds-pause
contract DSPauseAbstract {
    function setOwner(address) public;
    function setAuthority(address) public;
    function setDelay(uint256) public;
    function plans(bytes32) public view returns (bool);
    function proxy() public view returns (address);
    function delay() public view returns (uint256);
    function plot(address, bytes32, bytes memory, uint256) public;
    function drop(address, bytes32, bytes memory, uint256) public;
    function exec(address, bytes32, bytes memory, uint256) public returns (bytes memory);
}

// https://github.com/makerdao/dss/blob/master/src/vat.sol
contract VatAbstract {
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function can(address, address) public view returns (uint256);
    function hope(address) external;
    function nope(address) external;
    function ilks(bytes32) external view returns (uint256, uint256, uint256, uint256, uint256);
    function urns(bytes32, address) public view returns (uint256, uint256);
    function gem(bytes32, address) public view returns (uint256);
    function dai(address) public view returns (uint256);
    function sin(address) public view returns (uint256);
    function debt() public view returns (uint256);
    function vice() public view returns (uint256);
    function Line() public view returns (uint256);
    function live() public view returns (uint256);
    function init(bytes32) external;
    function file(bytes32, uint256) external;
    function file(bytes32, bytes32, uint256) external;
    function cage() external;
    function slip(bytes32, address, int256) external;
    function flux(bytes32, address, address, uint256) external;
    function move(address, address, uint256) external;
    function frob(bytes32, address, address, address, int256, int256) external;
    function fork(bytes32, address, address, int256, int256) external;
    function grab(bytes32, address, address, address, int256, int256) external;
    function heal(uint256) external;
    function suck(address, address, uint256) external;
    function fold(bytes32, address, int256) external;
}

contract SpellAction {
    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    string constant public description = "2020-04-29 MakerDAO Executive Spell";

    // The contracts in this list should correspond to MCD core contracts, verify
    //  against the current release list at:
    //     https://changelog.makerdao.com/releases/mainnet/1.0.5/contracts.json
    //
    // Contract addresses pertaining to the SCD ecosystem can be found at:
    //     https://github.com/makerdao/sai#dai-v1-current-deployments
    address constant public MCD_VAT = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;

    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 8%):
    //
    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'
    //

    uint256 constant public RAD = 10**45;
    uint256 constant public MILLION = 10**6;

    function execute() external {
        // MCD Modifications

        // Set the ETH-A debt ceiling
        // ETH_LINE is the number of Dai that can be created with WETH token collateral
        //  ex. a 100 million Dai ETH ceiling will be ETH_LINE = 100,000,000
        // Existing Line: 100m
        // New Line: 120m
        uint256 ETH_LINE = 120 * MILLION;
        VatAbstract(MCD_VAT).file("ETH-A", "line", ETH_LINE * RAD);

        // set the global debt ceiling to 143,000,000
        uint256 GLOBAL_LINE = 143 * MILLION;
        VatAbstract(MCD_VAT).file("Line", GLOBAL_LINE * RAD);
    }
}

contract DssSpell {

    DSPauseAbstract  public pause =
        DSPauseAbstract(0xbE286431454714F511008713973d3B053A2d38f3);
    address          public action;
    bytes32          public tag;
    uint256          public eta;
    bytes            public sig;
    uint256          public expiration;
    bool             public done;

    constructor() public {
        sig = abi.encodeWithSignature("execute()");
        action = address(new SpellAction());
        bytes32 _tag;
        address _action = action;
        assembly { _tag := extcodehash(_action) }
        tag = _tag;
        expiration = now + 30 days;
    }

    function description() public view returns (string memory) {
        return SpellAction(action).description();
    }

    function schedule() public {
        require(now <= expiration, "This contract has expired");
        require(eta == 0, "This spell has already been scheduled");
        eta = now + DSPauseAbstract(pause).delay();
        pause.plot(action, tag, sig, eta);
    }

    function cast() public {
        require(!done, "spell-already-cast");
        done = true;
        pause.exec(action, tag, sig, eta);
    }
}