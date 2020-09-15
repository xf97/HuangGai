/**
 *Submitted for verification at Etherscan.io on 2020-08-14
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.5.17;

interface Harvester {
    function harvest() external;
}

contract LazyHarvest {
   function harvest() external {
       Harvester(0xA30d1D98C502378ad61Fe71BcDc3a808CF60b897).harvest();
       Harvester(0xa069E33994DcC24928D99f4BBEDa83AAeF00B5f3).harvest();
       Harvester(0xd643cf07344428770b84973e049A1c18B5d47edE).harvest();
       Harvester(0x787C771035bDE631391ced5C083db424A4A64bD8).harvest();
   }
}