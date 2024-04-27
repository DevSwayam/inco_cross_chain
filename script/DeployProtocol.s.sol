// SPDX-License-Identifier: MIT

import {Script} from "../lib/forge-std/src/Script.sol";
import {SlotMachine} from "../src/SlotMachine.sol";
import {RandomNumberGenerator} from "../src/RandomNumberGenerator.sol";

pragma solidity >=0.8.13 <0.9.0;

contract DeployProtocol is Script{

    SlotMachine slotMachine;
    RandomNumberGenerator randomNumberGenerator;

    function run() external returns(SlotMachine){
        vm.startBroadcast();
        slotMachine = new SlotMachine();
        vm.stopBroadcast();
        return(slotMachine);
    }
}