// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "msgport/user/Application.sol";

contract Counter is Application {
    event TheNumberIncreased(uint256 fromChainId, address fromDapp, address localPort, uint256 number);

    // The port address, which can be any messaging protocols that under the Msgport protocol.
    address public immutable PORT;
    uint256 public number;

    constructor(address port) {
        PORT = port;
    }

    function increaseNumber() external {
        // Get the additional information provided by the Application provider.
        // It can be used to perform validation before updating the contract state.
        uint256 fromChainId = _fromChainId();
        address fromDapp = _xmsgSender();
        address localPort = _msgPort();
        // Ensure that the message comes from a predefined port.
        require(localPort == PORT);

        number += 1;
        emit TheNumberIncreased(fromChainId, fromDapp, localPort, number);
    }
}
