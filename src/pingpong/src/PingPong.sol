// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "msgport/user/Application.sol";
import "msgport/interfaces/IMessagePort.sol";

contract PingPong is Application {
    event ReceivedToken(address indexed from, uint256 value);

    event PingSent(uint256 fromChainId, uint256 toChainId, bytes32 msgId);
    event PongSent(uint256 fromChainId, uint256 toChainId, bytes32 msgId);
    event PongReceive(uint256 fromChainId, uint256 toChainId);

    // The port address, which can be any messaging protocols that under the Msgport protocol.
    address public immutable PORT;
    uint256 public immutable Fee;
    bytes public Params =
        hex"000000000000000000000000000000000000000000000000000000000001da53000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000000";

    constructor(address port, uint256 fee) {
        PORT = port;
        Fee = fee;
    }

    function ping(uint256 toChainId, address toDapp, bytes memory message) public payable returns (bytes32 msgId) {
        msgId = IMessagePort(PORT).send{value: Fee}(toChainId, toDapp, message, Params);
        emit PingSent(block.chainid, toChainId, msgId);
        return msgId;
    }

    function pong() public returns (bytes32 msgId) {
        uint256 fromChainId = _fromChainId();
        address fromDapp = _xmsgSender();
        address localPort = _msgPort();
        require(localPort == PORT);

        // Call back to the pongReceive() function in the source chain.
        bytes memory message = abi.encodeWithSignature("pongReceive()");
        msgId = ping(fromChainId, fromDapp, message);
        emit PongSent(block.chainid, fromChainId, msgId);

        return msgId;
    }

    function pongReceive() public {
        uint256 fromChainId = _fromChainId();
        address localPort = _msgPort();
        require(localPort == PORT);

        emit PongReceive(fromChainId, block.chainid);
    }

    receive() external payable {
        emit ReceivedToken(msg.sender, msg.value);
    }
}
