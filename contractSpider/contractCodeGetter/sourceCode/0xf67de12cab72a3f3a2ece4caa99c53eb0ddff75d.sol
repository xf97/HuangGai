/**
 *Submitted for verification at Etherscan.io on 2020-07-27
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

interface DSPauseAbstract {
    function setOwner(address) external;
    function setAuthority(address) external;
    function setDelay(uint256) external;
    function plans(bytes32) external view returns (bool);
    function proxy() external view returns (address);
    function delay() external view returns (uint256);
    function plot(address, bytes32, bytes calldata, uint256) external;
    function drop(address, bytes32, bytes calldata, uint256) external;
    function exec(address, bytes32, bytes calldata, uint256) external returns (bytes memory);
}

interface VatAbstract {
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function can(address, address) external view returns (uint256);
    function hope(address) external;
    function nope(address) external;
    function ilks(bytes32) external view returns (uint256, uint256, uint256, uint256, uint256);
    function urns(bytes32, address) external view returns (uint256, uint256);
    function gem(bytes32, address) external view returns (uint256);
    function dai(address) external view returns (uint256);
    function sin(address) external view returns (uint256);
    function debt() external view returns (uint256);
    function vice() external view returns (uint256);
    function Line() external view returns (uint256);
    function live() external view returns (uint256);
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

interface CatAbstract {
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function ilks(bytes32) external view returns (address, uint256, uint256);
    function live() external view returns (uint256);
    function vat() external view returns (address);
    function vow() external view returns (address);
    function file(bytes32, address) external;
    function file(bytes32, bytes32, uint256) external;
    function file(bytes32, bytes32, address) external;
    function bite(bytes32, address) external returns (uint256);
    function cage() external;
}

interface JugAbstract {
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function ilks(bytes32) external view returns (uint256, uint256);
    function vat() external view returns (address);
    function vow() external view returns (address);
    function base() external view returns (address);
    function init(bytes32) external;
    function file(bytes32, bytes32, uint256) external;
    function file(bytes32, uint256) external;
    function file(bytes32, address) external;
    function drip(bytes32) external returns (uint256);
}

interface FlipAbstract {
    function wards(address) external view returns (uint256);
    function rely(address usr) external;
    function deny(address usr) external;
    function bids(uint256) external view returns (uint256, uint256, address, uint48, uint48, address, address, uint256);
    function vat() external view returns (address);
    function ilk() external view returns (bytes32);
    function beg() external view returns (uint256);
    function ttl() external view returns (uint48);
    function tau() external view returns (uint48);
    function kicks() external view returns (uint256);
    function file(bytes32, uint256) external;
    function kick(address, address, uint256, uint256, uint256) external returns (uint256);
    function tick(uint256) external;
    function tend(uint256, uint256, uint256) external;
    function dent(uint256, uint256, uint256) external;
    function deal(uint256) external;
    function yank(uint256) external;
}

interface FlapAbstract {
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function bids(uint256) external view returns (uint256, uint256, address, uint48, uint48);
    function vat() external view returns (address);
    function gem() external view returns (address);
    function beg() external view returns (uint256);
    function ttl() external view returns (uint48);
    function tau() external view returns (uint48);
    function kicks() external view returns (uint256);
    function live() external view returns (uint256);
    function file(bytes32, uint256) external;
    function kick(uint256, uint256) external returns (uint256);
    function tick(uint256) external;
    function tend(uint256, uint256, uint256) external;
    function deal(uint256) external;
    function cage(uint256) external;
    function yank(uint256) external;
}


interface FlopAbstract {
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function bids(uint256) external view returns (uint256, uint256, address, uint48, uint48);
    function vat() external view returns (address);
    function gem() external view returns (address);
    function beg() external view returns (uint256);
    function pad() external view returns (uint256);
    function ttl() external view returns (uint48);
    function tau() external view returns (uint48);
    function kicks() external view returns (uint256);
    function live() external view returns (uint256);
    function vow() external view returns (address);
    function file(bytes32, uint256) external;
    function kick(address, uint256, uint256) external returns (uint256);
    function tick(uint256) external;
    function dent(uint256, uint256, uint256) external;
    function deal(uint256) external;
    function cage() external;
    function yank(uint256) external;
}

interface SpotAbstract {
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function ilks(bytes32) external view returns (address, uint256);
    function vat() external view returns (address);
    function par() external view returns (uint256);
    function live() external view returns (uint256);
    function file(bytes32, bytes32, address) external;
    function file(bytes32, uint256) external;
    function file(bytes32, bytes32, uint256) external;
    function poke(bytes32) external;
    function cage() external;
}

interface OsmAbstract {
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function stopped() external view returns (uint256);
    function src() external view returns (address);
    function hop() external view returns (uint16);
    function zzz() external view returns (uint64);
    function cur() external view returns (uint128, uint128);
    function nxt() external view returns (uint128, uint128);
    function bud(address) external view returns (uint256);
    function stop() external;
    function start() external;
    function change(address) external;
    function step(uint16) external;
    function void() external;
    function pass() external view returns (bool);
    function poke() external;
    function peek() external view returns (bytes32, bool);
    function peep() external view returns (bytes32, bool);
    function read() external view returns (bytes32);
    function kiss(address) external;
    function diss(address) external;
    function kiss(address[] calldata) external;
    function diss(address[] calldata) external;
}

interface OsmMomAbstract {
    function owner() external view returns (address);
    function authority() external view returns (address);
    function osms(bytes32) external view returns (address);
    function setOsm(bytes32, address) external;
    function setOwner(address) external;
    function setAuthority(address) external;
    function stop(bytes32) external;
}

interface MedianAbstract {
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function age() external view returns (uint32);
    function wat() external view returns (bytes32);
    function bar() external view returns (uint256);
    function orcl(address) external view returns (uint256);
    function bud(address) external view returns (uint256);
    function slot(uint8) external view returns (address);
    function read() external view returns (uint256);
    function peek() external view returns (uint256, bool);
    function lift(address[] calldata) external;
    function drop(address[] calldata) external;
    function setBar(uint256) external;
    function kiss(address) external;
    function diss(address) external;
    function kiss(address[] calldata) external;
    function diss(address[] calldata) external;
    function poke(uint256[] calldata, uint256[] calldata, uint8[] calldata, bytes32[] calldata, bytes32[] calldata) external;
}

interface GemJoinAbstract {
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function vat() external view returns (address);
    function ilk() external view returns (bytes32);
    function gem() external view returns (address);
    function dec() external view returns (uint256);
    function live() external view returns (uint256);
    function cage() external;
    function join(address, uint256) external;
    function exit(address, uint256) external;
}

interface FlipperMomAbstract {
    function owner() external returns (address);
    function setOwner(address) external;
    function authority() external returns (address);
    function setAuthority(address) external;
    function cat() external returns (address);
    function rely(address) external;
    function deny(address) external;
}


interface VowAbstract {
    function wards(address) external view returns (uint256);
    function rely(address usr) external;
    function deny(address usr) external;
    function vat() external view returns (address);
    function flapper() external view returns (address);
    function flopper() external view returns (address);
    function sin(uint256) external view returns (uint256);
    function Sin() external view returns (uint256);
    function Ash() external view returns (uint256);
    function wait() external view returns (uint256);
    function dump() external view returns (uint256);
    function sump() external view returns (uint256);
    function bump() external view returns (uint256);
    function hump() external view returns (uint256);
    function live() external view returns (uint256);
    function file(bytes32, uint256) external;
    function file(bytes32, address) external;
    function fess(uint256) external;
    function flog(uint256) external;
    function heal(uint256) external;
    function kiss(uint256) external;
    function flop() external returns (uint256);
    function flap() external returns (uint256);
    function cage() external;
}

interface MkrAuthorityAbstract {
    function root() external returns (address);
    function setRoot(address) external;
    function wards(address) external returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function canCall(address, address, bytes4) external returns (bool);
}

contract SpellAction {

    // MAINNET ADDRESSES
    //
    // The contracts in this list should correspond to MCD core contracts, verify
    // against the current release list at:
    //     https://changelog.makerdao.com/releases/mainnet/1.0.9/contracts.json

    address constant MCD_VAT             = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address constant MCD_VOW             = 0xA950524441892A31ebddF91d3cEEFa04Bf454466;
    address constant MCD_CAT             = 0x78F2c2AF65126834c51822F56Be0d7469D7A523E;
    address constant MCD_JUG             = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
    address constant GOV_GUARD           = 0x6eEB68B2C7A918f36B78E2DB80dcF279236DDFb8;

    address constant MCD_SPOT            = 0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3;
    address constant MCD_END             = 0xaB14d3CE3F733CACB76eC2AbE7d2fcb00c99F3d5;
    address constant FLIPPER_MOM         = 0x9BdDB99625A711bf9bda237044924E34E8570f75;
    address constant OSM_MOM             = 0x76416A4d5190d071bfed309861527431304aA14f;

    address constant MCD_JOIN_MANA_A     = 0xA6EA3b9C04b8a38Ff5e224E7c3D6937ca44C0ef9;
    address constant PIP_MANA            = 0x8067259EA630601f319FccE477977E55C6078C13;
    address constant MCD_FLIP_MANA_A     = 0x4bf9D2EBC4c57B9B783C12D30076507660B58b3a;
    address constant MANA                = 0x0F5D2fB29fb7d3CFeE444a200298f468908cC942;

    address constant MCD_FLAP            = 0xC4269cC7acDEdC3794b221aA4D9205F564e27f0d;
    address constant MCD_FLOP            = 0xA41B6EF151E06da0e34B009B86E828308986736D;
    address constant MCD_FLAP_OLD        = 0xdfE0fb1bE2a52CDBf8FB962D5701d7fd0902db9f;
    address constant MCD_FLOP_OLD        = 0x4D95A049d5B0b7d32058cd3F2163015747522e99;

    address constant MCD_FLIP_ETH_A      = 0x0F398a2DaAa134621e4b687FCcfeE4CE47599Cc1;
    address constant MCD_FLIP_ETH_A_OLD  = 0xd8a04F5412223F513DC55F839574430f5EC15531;

    address constant MCD_FLIP_BAT_A      = 0x5EdF770FC81E7b8C2c89f71F30f211226a4d7495;
    address constant MCD_FLIP_BAT_A_OLD  = 0xaA745404d55f88C108A28c86abE7b5A1E7817c07;

    address constant MCD_FLIP_USDC_A     = 0x545521e0105C5698f75D6b3C3050CfCC62FB0C12;
    address constant MCD_FLIP_USDC_A_OLD = 0xE6ed1d09a19Bd335f051d78D5d22dF3bfF2c28B1;

    address constant MCD_FLIP_USDC_B     = 0x6002d3B769D64A9909b0B26fC00361091786fe48;
    address constant MCD_FLIP_USDC_B_OLD = 0xec25Ca3fFa512afbb1784E17f1D414E16D01794F;

    address constant MCD_FLIP_WBTC_A     = 0xF70590Fa4AaBe12d3613f5069D02B8702e058569;
    address constant MCD_FLIP_WBTC_A_OLD = 0x3E115d85D4d7253b05fEc9C0bB5b08383C2b0603;

    address constant MCD_FLIP_ZRX_A      = 0x92645a34d07696395b6e5b8330b000D0436A9aAD;
    address constant MCD_FLIP_ZRX_A_OLD  = 0x08c89251FC058cC97d5bA5F06F95026C0A5CF9B0;

    address constant MCD_FLIP_KNC_A      = 0xAD4a0B5F3c6Deb13ADE106Ba6E80Ca6566538eE6;
    address constant MCD_FLIP_KNC_A_OLD  = 0xAbBCB9Ae89cDD3C27E02D279480C7fF33083249b;

    address constant MCD_FLIP_TUSD_A     = 0x04C42fAC3e29Fd27118609a5c36fD0b3Cb8090b3;
    address constant MCD_FLIP_TUSD_A_OLD = 0xba3f6a74BD12Cf1e48d4416c7b50963cA98AfD61;

    // Decimals & precision
    uint256 constant THOUSAND = 10 ** 3;
    uint256 constant MILLION  = 10 ** 6;
    uint256 constant WAD      = 10 ** 18;
    uint256 constant RAY      = 10 ** 27;
    uint256 constant RAD      = 10 ** 45;

    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 8%):
    //
    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'
    //
    uint256 constant TWELVE_PCT_RATE = 1000000003593629043335673582;

    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/community/cc819c75fc8f1b622cbe06acfd0d11bf64545622/governance/votes/Executive%20vote%20-%20July%2027%2C%202020%20.md -q -O - 2>/dev/null)"
    string constant public description =
        "2020-07-27 MakerDAO Executive Spell | Executive for July Governance Cycle | 0x72b73b29a8c49e38b5a23b760f622808a41ed52f584f147b4437e5ad5b5c7ce2";

    function execute() external {
        // Raise the global debt ceiling by 41 million (40 million for ETH-A, 1 million for MANA-A)
        VatAbstract(MCD_VAT).file("Line", VatAbstract(MCD_VAT).Line() + 41 * MILLION * RAD);

        // Raise the ETH-A debt ceiling by 40 million to 260 million
        bytes32 ilk = "ETH-A";
        VatAbstract(MCD_VAT).file(ilk, "line", 260 * MILLION * RAD); // 260 MM debt ceiling

        // Set ilk bytes32 variable
        ilk = "MANA-A";

        // Sanity checks
        require(GemJoinAbstract(MCD_JOIN_MANA_A).vat() == MCD_VAT,  "join-vat-not-match");
        require(GemJoinAbstract(MCD_JOIN_MANA_A).ilk() == ilk,      "join-ilk-not-match");
        require(GemJoinAbstract(MCD_JOIN_MANA_A).gem() == MANA,     "join-gem-not-match");
        require(GemJoinAbstract(MCD_JOIN_MANA_A).dec() == 18,       "join-dec-not-match");
        require(FlipAbstract(MCD_FLIP_MANA_A).vat() == MCD_VAT,     "flip-vat-not-match");
        require(FlipAbstract(MCD_FLIP_MANA_A).ilk() == ilk,         "flip-ilk-not-match");

        // Set price feed for MANA-A
        SpotAbstract(MCD_SPOT).file(ilk, "pip", PIP_MANA);

        // Set the MANA-A flipper in the cat
        CatAbstract(MCD_CAT).file(ilk, "flip", MCD_FLIP_MANA_A);

        // Init MANA-A in Vat & Jug
        VatAbstract(MCD_VAT).init(ilk);
        JugAbstract(MCD_JUG).init(ilk);

        // Allow MANA-A Join to modify Vat registry
        VatAbstract(MCD_VAT).rely(MCD_JOIN_MANA_A);

        // Allow cat to kick auctions in MANA-A Flipper
        FlipAbstract(MCD_FLIP_MANA_A).rely(MCD_CAT);

        // Allow End to yank auctions in MANA-A Flipper
        FlipAbstract(MCD_FLIP_MANA_A).rely(MCD_END);

        // Allow FlipperMom to access the MANA-A Flipper
        FlipAbstract(MCD_FLIP_MANA_A).rely(FLIPPER_MOM);

        // Update OSM
        MedianAbstract(OsmAbstract(PIP_MANA).src()).kiss(PIP_MANA);
        OsmAbstract(PIP_MANA).rely(OSM_MOM);
        OsmAbstract(PIP_MANA).kiss(MCD_SPOT);
        OsmAbstract(PIP_MANA).kiss(MCD_END);
        OsmMomAbstract(OSM_MOM).setOsm(ilk, PIP_MANA);

        VatAbstract(MCD_VAT).file(ilk, "line", 1 * MILLION * RAD);    // 1 MM debt ceiling
        VatAbstract(MCD_VAT).file(ilk, "dust", 20 * RAD);             // 20 Dai dust
        CatAbstract(MCD_CAT).file(ilk, "lump", 500 * THOUSAND * WAD); // 500,000 lot size
        CatAbstract(MCD_CAT).file(ilk, "chop", 113 * RAY / 100);      // 13% liq. penalty
        JugAbstract(MCD_JUG).file(ilk, "duty", TWELVE_PCT_RATE);      // 12% stability fee

        FlipAbstract(MCD_FLIP_MANA_A).file("beg",  103 * WAD / 100);  // 3% bid increase
        FlipAbstract(MCD_FLIP_MANA_A).file("ttl",  6 hours);          // 6 hours ttl
        FlipAbstract(MCD_FLIP_MANA_A).file("tau",  6 hours);          // 6 hours tau

        SpotAbstract(MCD_SPOT).file(ilk, "mat",  175 * RAY / 100);    // 175% coll. ratio
        SpotAbstract(MCD_SPOT).poke(ilk);

        /*** Add new Flip, Flap, Flop contracts ***/
        MkrAuthorityAbstract mkrAuthority = MkrAuthorityAbstract(GOV_GUARD);
        VatAbstract                   vat = VatAbstract(MCD_VAT);
        CatAbstract                   cat = CatAbstract(MCD_CAT);
        VowAbstract                   vow = VowAbstract(MCD_VOW);

        FlapAbstract newFlap = FlapAbstract(MCD_FLAP);
        FlopAbstract newFlop = FlopAbstract(MCD_FLOP);
        FlapAbstract oldFlap = FlapAbstract(MCD_FLAP_OLD);
        FlopAbstract oldFlop = FlopAbstract(MCD_FLOP_OLD);

        /*** Flap ***/
        vow.file("flapper", MCD_FLAP);
        newFlap.rely(MCD_VOW);
        newFlap.file("beg", oldFlap.beg());
        newFlap.file("ttl", oldFlap.ttl());
        newFlap.file("tau", oldFlap.tau());
        oldFlap.deny(MCD_VOW);
        require(newFlap.gem() == oldFlap.gem(), "non-matching-gem");
        require(newFlap.vat() == MCD_VAT, "non-matching-vat");

        /*** Flop ***/
        vow.file("flopper", MCD_FLOP);
        newFlop.rely(MCD_VOW);
        vat.rely(MCD_FLOP);
        mkrAuthority.rely(MCD_FLOP);
        newFlop.file("beg", oldFlop.beg());
        newFlop.file("pad", oldFlop.pad());
        newFlop.file("ttl", oldFlop.ttl());
        newFlop.file("tau", oldFlop.tau());
        oldFlop.deny(MCD_VOW);
        vat.deny(MCD_FLOP_OLD);
        mkrAuthority.deny(MCD_FLOP_OLD);
        require(newFlop.gem() == oldFlop.gem(), "non-matching-gem");
        require(newFlop.vat() == MCD_VAT, "non-matching-vat");

        FlipAbstract newFlip;
        FlipAbstract oldFlip;

        /*** ETH-A Flip ***/
        ilk = "ETH-A";
        newFlip = FlipAbstract(MCD_FLIP_ETH_A);
        oldFlip = FlipAbstract(MCD_FLIP_ETH_A_OLD);

        cat.file(ilk, "flip", address(newFlip));
        newFlip.rely(MCD_CAT);
        newFlip.rely(MCD_END);
        newFlip.rely(FLIPPER_MOM);
        oldFlip.deny(MCD_CAT);
        oldFlip.deny(MCD_END);
        oldFlip.deny(FLIPPER_MOM);
        newFlip.file("beg", oldFlip.beg());
        newFlip.file("ttl", oldFlip.ttl());
        newFlip.file("tau", oldFlip.tau());
        require(newFlip.ilk() == ilk, "non-matching-ilk");
        require(newFlip.vat() == MCD_VAT, "non-matching-vat");


        /*** BAT-A Flip ***/
        ilk = "BAT-A";
        newFlip = FlipAbstract(MCD_FLIP_BAT_A);
        oldFlip = FlipAbstract(MCD_FLIP_BAT_A_OLD);

        cat.file(ilk, "flip", address(newFlip));
        newFlip.rely(MCD_CAT);
        newFlip.rely(MCD_END);
        newFlip.rely(FLIPPER_MOM);
        oldFlip.deny(MCD_CAT);
        oldFlip.deny(MCD_END);
        oldFlip.deny(FLIPPER_MOM);
        newFlip.file("beg", oldFlip.beg());
        newFlip.file("ttl", oldFlip.ttl());
        newFlip.file("tau", oldFlip.tau());
        require(newFlip.ilk() == ilk, "non-matching-ilk");
        require(newFlip.vat() == MCD_VAT, "non-matching-vat");


        /*** USDC-A Flip ***/
        ilk = "USDC-A";
        newFlip = FlipAbstract(MCD_FLIP_USDC_A);
        oldFlip = FlipAbstract(MCD_FLIP_USDC_A_OLD);

        cat.file(ilk, "flip", address(newFlip));
        newFlip.rely(MCD_CAT); // This will be denied after via FlipperMom, just doing this for explicitness
        newFlip.rely(MCD_END);
        newFlip.rely(FLIPPER_MOM);
        oldFlip.deny(MCD_CAT);
        oldFlip.deny(MCD_END);
        oldFlip.deny(FLIPPER_MOM);
        newFlip.file("beg", oldFlip.beg());
        newFlip.file("ttl", oldFlip.ttl());
        newFlip.file("tau", oldFlip.tau());
        require(newFlip.ilk() == ilk, "non-matching-ilk");
        require(newFlip.vat() == MCD_VAT, "non-matching-vat");
        FlipperMomAbstract(FLIPPER_MOM).deny(MCD_FLIP_USDC_A);


        /*** USDC-B Flip ***/
        ilk = "USDC-B";
        newFlip = FlipAbstract(MCD_FLIP_USDC_B);
        oldFlip = FlipAbstract(MCD_FLIP_USDC_B_OLD);

        cat.file(ilk, "flip", address(newFlip));
        newFlip.rely(MCD_CAT); // This will be denied after via FlipperMom, just doing this for explicitness
        newFlip.rely(MCD_END);
        newFlip.rely(FLIPPER_MOM);
        oldFlip.deny(MCD_CAT);
        oldFlip.deny(MCD_END);
        oldFlip.deny(FLIPPER_MOM);
        newFlip.file("beg", oldFlip.beg());
        newFlip.file("ttl", oldFlip.ttl());
        newFlip.file("tau", oldFlip.tau());
        require(newFlip.ilk() == ilk, "non-matching-ilk");
        require(newFlip.vat() == MCD_VAT, "non-matching-vat");
        FlipperMomAbstract(FLIPPER_MOM).deny(MCD_FLIP_USDC_B);


        /*** WBTC-A Flip ***/
        ilk = "WBTC-A";
        newFlip = FlipAbstract(MCD_FLIP_WBTC_A);
        oldFlip = FlipAbstract(MCD_FLIP_WBTC_A_OLD);

        cat.file(ilk, "flip", address(newFlip));
        newFlip.rely(MCD_CAT);
        newFlip.rely(MCD_END);
        newFlip.rely(FLIPPER_MOM);
        oldFlip.deny(MCD_CAT);
        oldFlip.deny(MCD_END);
        oldFlip.deny(FLIPPER_MOM);
        newFlip.file("beg", oldFlip.beg());
        newFlip.file("ttl", oldFlip.ttl());
        newFlip.file("tau", oldFlip.tau());
        require(newFlip.ilk() == ilk, "non-matching-ilk");
        require(newFlip.vat() == MCD_VAT, "non-matching-vat");


        /*** ZRX-A Flip ***/
        ilk = "ZRX-A";
        newFlip = FlipAbstract(MCD_FLIP_ZRX_A);
        oldFlip = FlipAbstract(MCD_FLIP_ZRX_A_OLD);

        cat.file(ilk, "flip", address(newFlip));
        newFlip.rely(MCD_CAT);
        newFlip.rely(MCD_END);
        newFlip.rely(FLIPPER_MOM);
        oldFlip.deny(MCD_CAT);
        oldFlip.deny(MCD_END);
        oldFlip.deny(FLIPPER_MOM);
        newFlip.file("beg", oldFlip.beg());
        newFlip.file("ttl", oldFlip.ttl());
        newFlip.file("tau", oldFlip.tau());
        require(newFlip.ilk() == ilk, "non-matching-ilk");
        require(newFlip.vat() == MCD_VAT, "non-matching-vat");


        /*** KNC-A Flip ***/
        ilk = "KNC-A";
        newFlip = FlipAbstract(MCD_FLIP_KNC_A);
        oldFlip = FlipAbstract(MCD_FLIP_KNC_A_OLD);

        cat.file(ilk, "flip", address(newFlip));
        newFlip.rely(MCD_CAT);
        newFlip.rely(MCD_END);
        newFlip.rely(FLIPPER_MOM);
        oldFlip.deny(MCD_CAT);
        oldFlip.deny(MCD_END);
        oldFlip.deny(FLIPPER_MOM);
        newFlip.file("beg", oldFlip.beg());
        newFlip.file("ttl", oldFlip.ttl());
        newFlip.file("tau", oldFlip.tau());
        require(newFlip.ilk() == ilk, "non-matching-ilk");
        require(newFlip.vat() == MCD_VAT, "non-matching-vat");


        /*** TUSD-A Flip ***/
        ilk = "TUSD-A";
        newFlip = FlipAbstract(MCD_FLIP_TUSD_A);
        oldFlip = FlipAbstract(MCD_FLIP_TUSD_A_OLD);

        cat.file(ilk, "flip", address(newFlip));
        newFlip.rely(MCD_CAT);
        newFlip.rely(MCD_END);
        newFlip.rely(FLIPPER_MOM);
        oldFlip.deny(MCD_CAT);
        oldFlip.deny(MCD_END);
        oldFlip.deny(FLIPPER_MOM);
        newFlip.file("beg", oldFlip.beg());
        newFlip.file("ttl", oldFlip.ttl());
        newFlip.file("tau", oldFlip.tau());
        require(newFlip.ilk() == ilk, "non-matching-ilk");
        require(newFlip.vat() == MCD_VAT, "non-matching-vat");
    }
}

contract DssSpell {
    DSPauseAbstract public pause = 
        DSPauseAbstract(0xbE286431454714F511008713973d3B053A2d38f3);
    address         public action;
    bytes32         public tag;
    uint256         public eta;
    bytes           public sig;
    uint256         public expiration;
    bool            public done;

    constructor() public {
        sig = abi.encodeWithSignature("execute()");
        action = address(new SpellAction());
        bytes32 _tag;
        address _action = action;
        assembly { _tag := extcodehash(_action) }
        tag = _tag;
        expiration = now + 4 days + 2 hours; // Extra window of 2 hours to get the spell set up in the Governance Portal and communicated
    }

    modifier officeHours {
        uint day = (now / 1 days + 3) % 7;
        require(day < 5, "Can only be cast on a weekday");
        uint hour = now / 1 hours % 24;
        require(hour >= 14 && hour < 21, "Outside office hours");
        _;
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

    function cast() public officeHours {
        require(!done, "spell-already-cast");
        done = true;
        pause.exec(action, tag, sig, eta);
    }
}