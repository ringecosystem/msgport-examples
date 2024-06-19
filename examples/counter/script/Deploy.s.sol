pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console2 as console} from "forge-std/console2.sol";

import "../../../script/ScriptTools.sol";
import "../src/Counter.sol";
import "../src/CounterSender.sol";

contract DCounterSender is Script {
    using stdJson for string;
    using ScriptTools for string;

    function run() public {
        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(block.chainid));
        vm.setEnv("FOUNDRY_EXPORTS_OVERWRITE_LATEST", vm.toString(true));

        string memory portAddr = ScriptTools.readInput("port_address");
        address port_address = portAddr.readAddress(".ORMP_PORT");

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        CounterSender sender = new CounterSender(port_address);
        vm.stopBroadcast();

        console.log("Sender has been deployed at chain: %s, contract: %s", block.chainid, address(sender));
        ScriptTools.exportContract("counter-sender", "CounterSender", address(sender));
    }
}

contract DCounter is Script {
    using stdJson for string;
    using ScriptTools for string;

    function run() public {
        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(block.chainid));
        vm.setEnv("FOUNDRY_EXPORTS_OVERWRITE_LATEST", vm.toString(true));

        string memory portAddr = ScriptTools.readInput("port_address");
        address port_address = portAddr.readAddress(".ORMP_PORT");

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Counter counter = new Counter(port_address);
        vm.stopBroadcast();

        console.log("Counter has been deployed at chain: %s, contract: %s", block.chainid, address(counter));
        ScriptTools.exportContract("counter", "Counter", address(counter));
    }
}
