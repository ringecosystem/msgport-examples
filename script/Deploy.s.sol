// This file is part of Darwinia.
// Copyright (C) 2018-2024 Darwinia Network
// SPDX-License-Identifier: GPL-3.0
//
// Darwinia is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Darwinia is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Darwinia. If not, see <https://www.gnu.org/licenses/>.

pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console2 as console} from "forge-std/console2.sol";

import "./ScriptTools.sol";
import "../src/TestSender.sol";
import "../src/TestReceiver.sol";
import "./ScriptTools.sol";

contract DeploySender is Script {
    using stdJson for string;
    using ScriptTools for string;

    function run() public {
        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(block.chainid));
        string memory portAddr = ScriptTools.readInput("port_address");
        address PORT_ADDR = portAddr.readAddress(".ORMP_PORT");

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        TestSender sender = new TestSender(PORT_ADDR);
        console.log("TestSender deployed: %s", address(sender));
        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(block.chainid));
        vm.setEnv("FOUNDRY_EXPORTS_OVERWRITE_LATEST", vm.toString(true));
        ScriptTools.exportContract("deploy", "TEST_SENDER", address(sender));
        vm.stopBroadcast();
    }
}

contract DeployReceiver is Script {
    using stdJson for string;
    using ScriptTools for string;

    function run() public {
        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(block.chainid));
        string memory portAddr = ScriptTools.readInput("port_address");
        address PORT_ADDR = portAddr.readAddress(".ORMP_PORT");

        vm.setEnv("FOUNDRY_ROOT_CHAINID", "43");
        string memory deploySender = ScriptTools.readOutput("deploy");
        address SENDER_ADDR = deploySender.readAddress(".TEST_SENDER");

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        TestReceiver receiver = new TestReceiver(PORT_ADDR, SENDER_ADDR);
        console.log("TestReceiver deployed: %s", address(receiver));
        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(block.chainid));
        vm.setEnv("FOUNDRY_EXPORTS_OVERWRITE_LATEST", vm.toString(true));
        ScriptTools.exportContract("deploy", "TEST_RECEIVER", address(receiver));
        vm.stopBroadcast();
    }
}
