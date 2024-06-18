pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console2 as console} from "forge-std/console2.sol";

import "../../../script/ScriptTools.sol";
import "../src/Counter.sol";
import "../src/Sender.sol";

contract DSender is Script {
    using stdJson for string;
    using ScriptTools for string;

    function run() public {
        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(block.chainid));
        string memory portAddr = ScriptTools.readInput("port_address");
        address PORT_ADDR = portAddr.readAddress(".ORMP_PORT");

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Sender sender = new Sender(PORT_ADDR);
        console.log("TestSender deployed: %s", address(sender));
        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(block.chainid));
        vm.setEnv("FOUNDRY_EXPORTS_OVERWRITE_LATEST", vm.toString(true));
        ScriptTools.exportContract("deploy", "TEST_SENDER", address(sender));
        vm.stopBroadcast();
    }
}

contract DCounter is Script {
    using stdJson for string;
    using ScriptTools for string;

    function run() public {
        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(block.chainid));
        string memory portAddr = ScriptTools.readInput("port_address");
        address PORT_ADDR = portAddr.readAddress(".ORMP_PORT");

        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(block.chainid));
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Counter counter = new Counter(PORT_ADDR);
        console.log("TestReceiver deployed: %s", address(counter));
        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(block.chainid));
        vm.setEnv("FOUNDRY_EXPORTS_OVERWRITE_LATEST", vm.toString(true));
        ScriptTools.exportContract("deploy", "TEST_RECEIVER", address(counter));
        vm.stopBroadcast();
    }
}
