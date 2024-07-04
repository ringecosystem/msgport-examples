pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console2 as console} from "forge-std/console2.sol";

import "../../../script/ScriptTools.sol";
import "../src/PingPong.sol";

contract DPingPongSource is Script {
    using stdJson for string;
    using ScriptTools for string;

    function run() public {
        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(block.chainid));
        vm.setEnv("FOUNDRY_EXPORTS_OVERWRITE_LATEST", vm.toString(true));

        string memory input = ScriptTools.readInput("constructor");
        address port_address = input.readAddress(".ORMP_PORT");
        uint256 fee = input.readUint(".FEE");

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        PingPong pingpong = new PingPong(port_address, fee);
        vm.stopBroadcast();

        console.log("PingPong has been deployed at chain: %s, contract: %s", block.chainid, address(pingpong));
        ScriptTools.exportContract("pingpong", "PingPong", address(pingpong));
    }
}

contract DPingPongTarget is Script {
    using stdJson for string;
    using ScriptTools for string;

    function run() public {
        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(block.chainid));
        vm.setEnv("FOUNDRY_EXPORTS_OVERWRITE_LATEST", vm.toString(true));

        string memory input = ScriptTools.readInput("constructor");
        address port_address = input.readAddress(".ORMP_PORT");
        uint256 fee = input.readUint(".FEE");

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        PingPong pingpong = new PingPong(port_address, fee);
        // transfer fee to the PingPong contract ahead.
        payable(pingpong).transfer(fee);
        vm.stopBroadcast();

        console.log("PingPong has been deployed at chain: %s, contract: %s", block.chainid, address(pingpong));
        ScriptTools.exportContract("pingpong", "PingPong", address(pingpong));
    }
}
