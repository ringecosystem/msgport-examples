pragma solidity ^0.8.17;

import {stdJson} from "forge-std/StdJson.sol";
import {Script} from "forge-std/Script.sol";
import {console2 as console} from "forge-std/console2.sol";
import {Surl} from "surl/Surl.sol";

import "../../../script/ScriptTools.sol";
import "../src/PingPong.sol";

contract SendPing is Script {
    using Surl for *;
    using stdJson for string;
    using ScriptTools for string;

    function run() public {
        // Darwinia Koi network as source chain
        uint256 fromChainId = 701;
        // Sepolia as target chain
        uint256 toChainId = 11155111;
        address refundAddr = address(0);

        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(fromChainId));
        string memory input = ScriptTools.readInput("constructor");
        uint256 fee = input.readUint(".FEE");
        string memory souceContract = ScriptTools.readOutput("pingpong");
        address pingpongSource = souceContract.readAddress(".PingPong");
        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(toChainId));
        string memory targetContract = ScriptTools.readOutput("pingpong");
        address pingpongTarget = targetContract.readAddress(".PingPong");

        bytes memory message = abi.encodeCall(PingPong.pong, ());
        // Request the Msgport API to fetch the necesary fee and params.
        string[] memory headers = new string[](1);
        headers[0] = "Content-Type: application/json";
        string memory body = "body";
        body.serialize("fromChainId", vm.toString(fromChainId));
        body.serialize("fromAddress", vm.toString(pingpongSource));
        body.serialize("toChainId", vm.toString(toChainId));
        body.serialize("toAddress", vm.toString(pingpongTarget));
        body.serialize("message", vm.toString(message));
        string memory ormp = "ormp";
        string memory ormpJson = ormp.serialize("refundAddress", vm.toString(refundAddr));
        string memory finalBody = body.serialize("ormp", ormpJson);
        console.log("the body is: %s", finalBody);

        (uint256 _status, bytes memory resp) = "https://api.msgport.xyz/v2/fee_with_options".post(headers, finalBody);
        uint256 api_fee = vm.parseJsonUint(string(resp), ".data.fee");
        bytes memory api_params = vm.parseJsonBytes(string(resp), ".data.params");
        console.log("the api_fee is: %s", vm.toString(api_fee));
        console.log("the api_params is: %s", vm.toString(api_params));


        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        PingPong pingpong = PingPong(payable(pingpongSource));
        bytes32 msgId = pingpong.ping{value: fee}(toChainId, pingpongTarget, message);
        vm.stopBroadcast();
        console.log("The message has been sent to chain: %s, msgId: %s", toChainId, vm.toString(msgId));
    }
}
