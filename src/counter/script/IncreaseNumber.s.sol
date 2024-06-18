pragma solidity ^0.8.17;

import {stdJson} from "forge-std/StdJson.sol";
import {Script} from "forge-std/Script.sol";
import {console2 as console} from "forge-std/console2.sol";
import {Surl} from "surl/Surl.sol";

import "../../../script/ScriptTools.sol";
import "../src/Counter.sol";
import "../src/Sender.sol";

contract IncreaseNumber is Script {
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
        sender.send{value: fee * 2}(receiverChainId, TEST_RECEIVER, message, params);

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
