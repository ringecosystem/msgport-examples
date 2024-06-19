// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "msgport/interfaces/IMessagePort.sol";

contract CounterSender {
    event MessageSent(address port, uint256 toChainId, address toDapp, bytes32 msgId);

    // The port address, which can be any messaging protocols that under the Msgport protocol.
    address public immutable PORT;

    constructor(address port) {
        PORT = port;
    }

    // The send method is quite simple, it's more like a wrapper around the internal `IMessagePort`.
    function send(uint256 toChainId, address toDapp, bytes calldata message, bytes calldata params)
        external 
        payable 
        returns (bytes32 msgId)
    {
        msgId = IMessagePort(PORT).send{value: msg.value}(toChainId, toDapp, message, params);

        emit MessageSent(PORT, toChainId, toDapp, msgId);
        return msgId;
    }
}
