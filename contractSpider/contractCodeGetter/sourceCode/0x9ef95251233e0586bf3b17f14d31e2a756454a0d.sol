/**
 *Submitted for verification at Etherscan.io on 2020-06-26
*/

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

// https://github.com/makerdao/dss/blob/master/src/cat.sol
contract CatAbstract {
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function ilks(bytes32) public view returns (address, uint256, uint256);
    function live() public view returns (uint256);
    function vat() public view returns (address);
    function vow() public view returns (address);
    function file(bytes32, address) external;
    function file(bytes32, bytes32, uint256) external;
    function file(bytes32, bytes32, address) external;
    function bite(bytes32, address) external returns (uint256);
    function cage() external;
}

// https://github.com/makerdao/dss/blob/master/src/jug.sol
contract JugAbstract {
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function ilks(bytes32) public view returns (uint256, uint256);
    function vat() public view returns (address);
    function vow() public view returns (address);
    function base() public view returns (address);
    function init(bytes32) external;
    function file(bytes32, bytes32, uint256) external;
    function file(bytes32, uint256) external;
    function file(bytes32, address) external;
    function drip(bytes32) external returns (uint256);
}

// https://github.com/makerdao/dss/blob/master/src/pot.sol
contract PotAbstract {
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function pie(address) public view returns (uint256);
    function Pie() public view returns (uint256);
    function dsr() public view returns (uint256);
    function chi() public view returns (uint256);
    function vat() public view returns (address);
    function vow() public view returns (address);
    function rho() public view returns (uint256);
    function live() public view returns (uint256);
    function file(bytes32, uint256) external;
    function file(bytes32, address) external;
    function cage() external;
    function drip() external returns (uint256);
    function join(uint256) external;
    function exit(uint256) external;
}

// https://github.com/makerdao/dss/blob/master/src/join.sol
contract GemJoinAbstract {
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function vat() public view returns (address);
    function ilk() public view returns (bytes32);
    function gem() public view returns (address);
    function dec() public view returns (uint256);
    function live() public view returns (uint256);
    function cage() external;
    function join(address, uint256) external;
    function exit(address, uint256) external;
}

// https://github.com/makerdao/dss/blob/master/src/flip.sol
contract FlipAbstract {
    function wards(address) public view returns (uint256);
    function rely(address usr) external;
    function deny(address usr) external;
    function bids(uint256) public view returns (uint256, uint256, address, uint48, uint48, address, address, uint256);
    function vat() public view returns (address);
    function ilk() public view returns (bytes32);
    function beg() public view returns (uint256);
    function ttl() public view returns (uint48);
    function tau() public view returns (uint48);
    function kicks() public view returns (uint256);
    function file(bytes32, uint256) external;
    function kick(address, address, uint256, uint256, uint256) public returns (uint256);
    function tick(uint256) external;
    function tend(uint256, uint256, uint256) external;
    function dent(uint256, uint256, uint256) external;
    function deal(uint256) external;
    function yank(uint256) external;
}

// https://github.com/makerdao/dss/blob/master/src/spot.sol
contract SpotAbstract {
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function ilks(bytes32) public view returns (address, uint256);
    function vat() public view returns (address);
    function par() public view returns (uint256);
    function live() public view returns (uint256);
    function file(bytes32, bytes32, address) external;
    function file(bytes32, uint256) external;
    function file(bytes32, bytes32, uint256) external;
    function poke(bytes32) external;
    function cage() external;
}

// https://github.com/makerdao/osm
contract OsmAbstract {
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function stopped() public view returns (uint256);
    function src() public view returns (address);
    function hop() public view returns (uint16);
    function zzz() public view returns (uint64);
    function cur() public view returns (uint128, uint128);
    function nxt() public view returns (uint128, uint128);
    function bud(address) public view returns (uint256);
    function stop() external;
    function start() external;
    function change(address) external;
    function step(uint16) external;
    function void() external;
    function pass() public view returns (bool);
    function poke() external;
    function peek() external view returns (bytes32, bool);
    function peep() external view returns (bytes32, bool);
    function read() external view returns (bytes32);
    function kiss(address) external;
    function diss(address) external;
    function kiss(address[] calldata) external;
    function diss(address[] calldata) external;
}

// https://github.com/makerdao/osm-mom
contract OsmMomAbstract {
    function owner() public view returns (address);
    function authority() public view returns (address);
    function osms(bytes32) public view returns (address);
    function setOsm(bytes32, address) public;
    function setOwner(address) public;
    function setAuthority(address) public;
    function stop(bytes32) public;
}

contract MedianAbstract {
    function kiss(address) public;
}

contract SpellAction {
    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    string constant public description = "2020-06-26 MakerDAO Executive Spell";

    // The contracts in this list should correspond to MCD core contracts, verify
    //  against the current release list at:
    //     https://changelog.makerdao.com/releases/mainnet/1.0.5/contracts.json
    //
    // Contract addresses pertaining to the SCD ecosystem can be found at:
    //     https://github.com/makerdao/sai#dai-v1-current-deployments
    address constant public MCD_VAT        = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address constant public MCD_CAT        = 0x78F2c2AF65126834c51822F56Be0d7469D7A523E;
    address constant public MCD_JUG        = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
    address constant public MCD_SPOT       = 0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3;
    address constant public MCD_POT        = 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7;
    address constant public MCD_END        = 0xaB14d3CE3F733CACB76eC2AbE7d2fcb00c99F3d5;
    address constant public FLIPPER_MOM    = 0x9BdDB99625A711bf9bda237044924E34E8570f75;
    address constant public OSM_MOM        = 0x76416A4d5190d071bfed309861527431304aA14f;

    address constant public MCD_JOIN_SAI   = 0xad37fd42185Ba63009177058208dd1be4b136e6b;
    address constant public MCD_FLIP_SAI   = 0x5432b2f3c0DFf95AA191C45E5cbd539E2820aE72;

    address constant public KNC            = 0xdd974D5C2e2928deA5F71b9825b8b646686BD200;
    address constant public MCD_JOIN_KNC_A = 0x475F1a89C1ED844A08E8f6C50A00228b5E59E4A9;
    address constant public MCD_FLIP_KNC_A = 0xAbBCB9Ae89cDD3C27E02D279480C7fF33083249b;
    address constant public PIP_KNC        = 0xf36B79BD4C0904A5F350F1e4f776B81208c13069;

    address constant public ZRX            = 0xE41d2489571d322189246DaFA5ebDe1F4699F498;
    address constant public MCD_JOIN_ZRX_A = 0xc7e8Cd72BDEe38865b4F5615956eF47ce1a7e5D0;
    address constant public MCD_FLIP_ZRX_A = 0x08c89251FC058cC97d5bA5F06F95026C0A5CF9B0;
    address constant public PIP_ZRX        = 0x7382c066801E7Acb2299aC8562847B9883f5CD3c;

    address constant public PIP_WBTC       = 0xf185d0682d50819263941e5f4EacC763CC5C6C42;

    uint256 constant public THOUSAND = 10**3;
    uint256 constant public MILLION  = 10**6;
    uint256 constant public WAD      = 10**18;
    uint256 constant public RAY      = 10**27;
    uint256 constant public RAD      = 10**45;

    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 8%):
    //
    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'
    //
    uint256 constant public ZERO_TWENTYFIVE_PCT_RATE = 1000000000079175551708715274;
    uint256 constant public ONE_PCT_RATE  = 1000000000315522921573372069;
    uint256 constant public ONE_TWENTYFIVE_PCT_RATE = 1000000000393915525145987602;
    uint256 constant public FIFTY_TWENTYFIVE_PCT_RATE = 1000000012910019978921115695;
    uint256 constant public FOUR_TWENTYFIVE_PCT_RATE =  1000000001319814647332759691;

    function execute() external {
        // Perform drips
        PotAbstract(MCD_POT).drip();
        JugAbstract(MCD_JUG).drip("ETH-A");
        JugAbstract(MCD_JUG).drip("BAT-A");
        JugAbstract(MCD_JUG).drip("USDC-A");
        JugAbstract(MCD_JUG).drip("TUSD-A");
        JugAbstract(MCD_JUG).drip("USDC-B");
        JugAbstract(MCD_JUG).drip("WBTC-A");
        JugAbstract(MCD_JUG).drip("SAI");

        // Set base rate +0.25%
        JugAbstract(MCD_JUG).file("ETH-A", "duty", ZERO_TWENTYFIVE_PCT_RATE);
        JugAbstract(MCD_JUG).file("BAT-A", "duty", ZERO_TWENTYFIVE_PCT_RATE);
        JugAbstract(MCD_JUG).file("USDC-A", "duty", ONE_PCT_RATE);
        JugAbstract(MCD_JUG).file("USDC-B", "duty", FIFTY_TWENTYFIVE_PCT_RATE);
        JugAbstract(MCD_JUG).file("WBTC-A", "duty", ONE_TWENTYFIVE_PCT_RATE);
        JugAbstract(MCD_JUG).file("TUSD-A", "duty", ZERO_TWENTYFIVE_PCT_RATE);

        bytes32 ilk;

        /* ---- SAIC Collateral Housekeeping ---- */

        ilk = "SAI";

        // Sanity checks
        require(GemJoinAbstract(MCD_JOIN_SAI).ilk() == ilk, "join-ilk-not-match");
        require(FlipAbstract(MCD_FLIP_SAI).ilk() == ilk,    "flip-ilk-not-match");

        // Remove the SAI PIP in the Spotter
        SpotAbstract(MCD_SPOT).file(ilk, "pip", address(0));
        // Set SAI mat to 0 in the Spotter
        SpotAbstract(MCD_SPOT).file(ilk, "mat", 0);
        // Remove the SAI Flipper in the Cat
        CatAbstract(MCD_CAT).file(ilk, "flip", address(0));
        // Set the SAI debt ceiling to 0 (Already Done)
        // VatAbstract(MCD_VAT).file(ilk, "line", 0);
        // Set the SAI dust
        VatAbstract(MCD_VAT).file(ilk, "dust", 0);
        // Set the SAI spot
        VatAbstract(MCD_VAT).file(ilk, "spot", 0);
        // Set the Lot size to 0 SAI
        CatAbstract(MCD_CAT).file(ilk, "lump", 0);
        // Set the SAI liquidation penalty to 0%
        CatAbstract(MCD_CAT).file(ilk, "chop", 0);
        // Set Jug duty to 0
        JugAbstract(MCD_JUG).file(ilk, "duty", 0);
        // Cage the Sai join adapter
        GemJoinAbstract(MCD_JOIN_SAI).cage();
        // Disallow SAI to modify Vat registry
        VatAbstract(MCD_VAT).deny(MCD_JOIN_SAI);
        // Disallow Cat to kick auctions in SAI Flipper
        FlipAbstract(MCD_FLIP_SAI).deny(MCD_CAT);
        // Disallow End to yank auctions in SAI Flipper
        FlipAbstract(MCD_FLIP_SAI).deny(MCD_END);
        // Disallow FlipperMom to access to the SAI Flipper
        FlipAbstract(MCD_FLIP_SAI).deny(FLIPPER_MOM);

        /* ---- KNC Collateral Onboarding Spell ---- */
        ilk = "KNC-A";

        // Sanity checks
        require(GemJoinAbstract(MCD_JOIN_KNC_A).vat() == MCD_VAT, "join-vat-not-match");
        require(GemJoinAbstract(MCD_JOIN_KNC_A).ilk() == ilk,     "join-ilk-not-match");
        require(GemJoinAbstract(MCD_JOIN_KNC_A).gem() == KNC,     "join-gem-not-match");
        require(GemJoinAbstract(MCD_JOIN_KNC_A).dec() == 18,      "join-dec-not-match");
        require(FlipAbstract(MCD_FLIP_KNC_A).vat()    == MCD_VAT, "flip-vat-not-match");
        require(FlipAbstract(MCD_FLIP_KNC_A).ilk()    == ilk,     "flip-ilk-not-match");

        // Set the KNC PIP in the Spotter
        SpotAbstract(MCD_SPOT).file(ilk, "pip", PIP_KNC);

        // Set the KNC-A Flipper in the Cat
        CatAbstract(MCD_CAT).file(ilk, "flip", MCD_FLIP_KNC_A);

        // Init KNC-A ilk in Vat
        VatAbstract(MCD_VAT).init(ilk);
        // Init KNC-A ilk in Jug
        JugAbstract(MCD_JUG).init(ilk);

        // Allow KNC-A Join to modify Vat registry
        VatAbstract(MCD_VAT).rely(MCD_JOIN_KNC_A);
        // Allow Cat to kick auctions in KNC-A Flipper
        FlipAbstract(MCD_FLIP_KNC_A).rely(MCD_CAT);
        // Allow End to yank auctions in KNC-A Flipper
        FlipAbstract(MCD_FLIP_KNC_A).rely(MCD_END);
        // Allow FlipperMom to access to the KNC-A Flipper
        FlipAbstract(MCD_FLIP_KNC_A).rely(FLIPPER_MOM);

        // Whitelist the Osm to read the Median data
        MedianAbstract(OsmAbstract(PIP_KNC).src()).kiss(PIP_KNC);
        // Allow OsmMom to access to the KNC Osm
        OsmAbstract(PIP_KNC).rely(OSM_MOM);
        // Whitelist Spotter to read the Osm data
        OsmAbstract(PIP_KNC).kiss(MCD_SPOT);
        // Whitelist End to read the Osm data
        OsmAbstract(PIP_KNC).kiss(MCD_END);
        // Set KNC Osm in the OsmMom for new ilk
        OsmMomAbstract(OSM_MOM).setOsm(ilk, PIP_KNC);

        // Set the KNC-A debt ceiling to 5 MM
        VatAbstract(MCD_VAT).file(ilk, "line", 5 * MILLION * RAD);
        // Set the KNC-A dust
        VatAbstract(MCD_VAT).file(ilk, "dust", 20 * RAD);
        // Set the Lot size to 50,000 KNC-A
        CatAbstract(MCD_CAT).file(ilk, "lump", 50000 * WAD);
        // Set the KNC-A liquidation penalty to 13%
        CatAbstract(MCD_CAT).file(ilk, "chop", 113 * RAY / 100);
        // Set the KNC-A stability fee to 4.25%
        JugAbstract(MCD_JUG).file(ilk, "duty", FOUR_TWENTYFIVE_PCT_RATE);
        // Set the KNC-A percentage between bids to 3%
        FlipAbstract(MCD_FLIP_KNC_A).file("beg", 103 * WAD / 100);
        // Set the KNC-A time max time between bids to 6 hours
        FlipAbstract(MCD_FLIP_KNC_A).file("ttl", 6 hours);
        // Set the KNC-A max auction duration to 6 hours
        FlipAbstract(MCD_FLIP_KNC_A).file("tau", 6 hours);
        // Set the KNC-A min collateralization ratio to 175%
        SpotAbstract(MCD_SPOT).file(ilk, "mat", 175 * RAY / 100);
        // Update KNC-A spot value in Vat (will be zero as the Osm will not have any value as current yet)
        SpotAbstract(MCD_SPOT).poke(ilk);
        /* ---- End ---- */

        /* ---- ZRX Collateral Onboarding Spell ---- */
        ilk = "ZRX-A";

        // Sanity checks
        require(GemJoinAbstract(MCD_JOIN_ZRX_A).vat() == MCD_VAT, "join-vat-not-match");
        require(GemJoinAbstract(MCD_JOIN_ZRX_A).ilk() == ilk,     "join-ilk-not-match");
        require(GemJoinAbstract(MCD_JOIN_ZRX_A).gem() == ZRX,     "join-gem-not-match");
        require(GemJoinAbstract(MCD_JOIN_ZRX_A).dec() == 18,      "join-dec-not-match");
        require(FlipAbstract(MCD_FLIP_ZRX_A).vat()    == MCD_VAT, "flip-vat-not-match");
        require(FlipAbstract(MCD_FLIP_ZRX_A).ilk()    == ilk,     "flip-ilk-not-match");

        // Set the ZRX PIP in the Spotter
        SpotAbstract(MCD_SPOT).file(ilk, "pip", PIP_ZRX);

        // Set the ZRX-A Flipper in the Cat
        CatAbstract(MCD_CAT).file(ilk, "flip", MCD_FLIP_ZRX_A);

        // Init ZRX-A ilk in Vat
        VatAbstract(MCD_VAT).init(ilk);
        // Init ZRX-A ilk in Jug
        JugAbstract(MCD_JUG).init(ilk);

        // Allow ZRX-A Join to modify Vat registry
        VatAbstract(MCD_VAT).rely(MCD_JOIN_ZRX_A);
        // Allow Cat to kick auctions in ZRX-A Flipper
        FlipAbstract(MCD_FLIP_ZRX_A).rely(MCD_CAT);
        // Allow End to yank auctions in ZRX-A Flipper
        FlipAbstract(MCD_FLIP_ZRX_A).rely(MCD_END);
        // Allow FlipperMom to access to the ZRX-A Flipper
        FlipAbstract(MCD_FLIP_ZRX_A).rely(FLIPPER_MOM);

        // Whitelist the Osm to read the Median data
        MedianAbstract(OsmAbstract(PIP_ZRX).src()).kiss(PIP_ZRX);
        // Allow OsmMom to access to the ZRX Osm
        OsmAbstract(PIP_ZRX).rely(OSM_MOM);
        // Whitelist Spotter to read the Osm data
        OsmAbstract(PIP_ZRX).kiss(MCD_SPOT);
        // Whitelist End to read the Osm data
        OsmAbstract(PIP_ZRX).kiss(MCD_END);
        // Set ZRX Osm in the OsmMom for new ilk
        OsmMomAbstract(OSM_MOM).setOsm(ilk, PIP_ZRX);

        // Set the ZRX-A debt ceiling to 5 MM
        VatAbstract(MCD_VAT).file(ilk, "line", 5 * MILLION * RAD);
        // Set the ZRX-A dust
        VatAbstract(MCD_VAT).file(ilk, "dust", 20 * RAD);
        // Set the Lot size to 100,000 ZRX-A
        CatAbstract(MCD_CAT).file(ilk, "lump", 100000 * WAD);
        // Set the ZRX-A liquidation penalty to 13%
        CatAbstract(MCD_CAT).file(ilk, "chop", 113 * RAY / 100);
        // Set the ZRX-A stability fee to 4.25%
        JugAbstract(MCD_JUG).file(ilk, "duty", FOUR_TWENTYFIVE_PCT_RATE);
        // Set the ZRX-A percentage between bids to 3%
        FlipAbstract(MCD_FLIP_ZRX_A).file("beg", 103 * WAD / 100);
        // Set the ZRX-A time max time between bids to 6 hours
        FlipAbstract(MCD_FLIP_ZRX_A).file("ttl", 6 hours);
        // Set the ZRX-A max auction duration to 6 hours
        FlipAbstract(MCD_FLIP_ZRX_A).file("tau", 6 hours);
        // Set the ZRX-A min collateralization ratio to 175%
        SpotAbstract(MCD_SPOT).file(ilk, "mat", 175 * RAY / 100);
        // Update ZRX-A spot value in Vat (will be zero as the Osm will not have any value as current yet)
        SpotAbstract(MCD_SPOT).poke(ilk);
        /* ---- End ---- */

        // Set the global debt ceiling to 195 MM
        VatAbstract(MCD_VAT).file("Line", 195 * MILLION * RAD);

        // WBTC (missing permission): Add whitelist End to read the Osm data
        OsmAbstract(PIP_WBTC).kiss(MCD_END);
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