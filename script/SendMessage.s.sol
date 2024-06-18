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
        uint256 senderChainId = 701;
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

        string[] memory headers = new string[](1);
        headers[0] = "Content-Type: application/json";
        string memory ormp = "ormp";
        string memory ormpJson = ormp.serialize("refundAddress", vm.toString(refundAddr));

        string memory body = "body";
        body.serialize("fromChainId", vm.toString(senderChainId));
        body.serialize("fromAddress", vm.toString(TEST_SENDER));
        body.serialize("toChainId", vm.toString(receiverChainId));
        body.serialize("toAddress", vm.toString(TEST_RECEIVER));
        body.serialize("message", vm.toString(message));
        string memory finalbody = body.serialize("ormp", ormpJson);

        (uint256 status, bytes memory resp) = "https://api.msgport.xyz/v2/fee_with_options".post(headers, finalbody);
        uint256 fee = vm.parseJsonUint(string(resp), ".data.fee");
        bytes memory params = vm.parseJsonBytes(string(resp), ".data.params");

        TestSender sender = TestSender(TEST_SENDER);
        sender.send{value: fee}(receiverChainId, TEST_RECEIVER, message, params);

        vm.stopBroadcast();
    }
}

contract Test is Script {
    using stdJson for string;

    function run() public {
        string memory t = "";
        t.serialize("a", uint256(123));
        string memory semiFinal = t.serialize("b", string("test"));
        string memory finalJson = t.serialize("c", semiFinal);
        console.log("json: %s", finalJson);
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
