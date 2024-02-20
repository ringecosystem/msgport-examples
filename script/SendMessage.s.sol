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

import {stdJson} from "forge-std/StdJson.sol";
import {Script} from "forge-std/Script.sol";
import {console2 as console} from "forge-std/console2.sol";
import {Surl} from "lib/surl/src/Surl.sol";

import "./ScriptTools.sol";
import "../src/TestReceiver.sol";
import "../src/TestSender.sol";

contract SendMessage is Script {
    using Surl for *;
    using stdJson for string;
    using ScriptTools for string;

    function run() public {
        uint256 senderChainId = 43;
        uint256 receiverChainId = 11155111;
        address refundAddr = address(0);

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(senderChainId));
        string memory deploySender = ScriptTools.readOutput("deploy");
        address TEST_SENDER = deploySender.readAddress(".TEST_SENDER");

        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(receiverChainId));
        string memory deployReceiver = ScriptTools.readOutput("deploy");
        address TEST_RECEIVER = deployReceiver.readAddress(".TEST_RECEIVER");

        bytes memory message = abi.encodeCall(TestReceiver.addReceiveNum, 10);

        string memory queryUrl = string.concat(
            "https://msgport-api.darwinia.network/ormp/fee?from_chain_id=",
            vm.toString(senderChainId),
            "&to_chain_id=",
            vm.toString(receiverChainId),
            "&payload=",
            vm.toString(message),
            "&from_address=",
            vm.toString(TEST_SENDER),
            "&to_address=",
            vm.toString(TEST_RECEIVER),
            "&refund_address=",
            vm.toString(refundAddr)
        );
        (, bytes memory resp) = queryUrl.get();
        uint256 fee = vm.parseJsonUint(string(resp), ".data.fee");
        bytes memory params = vm.parseJsonBytes(string(resp), ".data.params");

        TestSender sender = TestSender(TEST_SENDER);
        sender.send{value: fee}(receiverChainId, TEST_RECEIVER, message, params);

        vm.stopBroadcast();
    }
}

contract CheckSum is Script {
    using stdJson for string;
    using ScriptTools for string;

    function run() public {
        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(block.chainid));
        string memory deployReceiver = ScriptTools.readOutput("deploy");
        address TEST_RECEIVER = deployReceiver.readAddress(".TEST_RECEIVER");

        TestReceiver receiver = TestReceiver(TEST_RECEIVER);
        uint256 sum = receiver.sum();
        console.log("Sum: %s", sum);
    }
}