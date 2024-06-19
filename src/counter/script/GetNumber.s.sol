pragma solidity ^0.8.17;

import {stdJson} from "forge-std/StdJson.sol";
import {Script} from "forge-std/Script.sol";
import {console2 as console} from "forge-std/console2.sol";

import "../../../script/ScriptTools.sol";
import "../src/Counter.sol";
import "../src/CounterSender.sol";


contract GetNumber is Script {
    using stdJson for string;
    using ScriptTools for string;

    function run() public {
        vm.setEnv("FOUNDRY_ROOT_CHAINID", vm.toString(block.chainid));
        string memory output = ScriptTools.readOutput("counter");
        address counter_address = output.readAddress(".Counter");

        Counter counter = Counter(counter_address);
        uint256 number = counter.number();
        console.log("The current number stored in the Counter is: %s", number);
    }
}