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

import "lib/darwinia-msgport/src/interfaces/IMessagePort.sol";

contract TestSender {
    event DappMessageSent(address localPort, bytes message);

    // local port address
    address public immutable PORT;

    constructor(address port) {
        PORT = port;
    }

    function send(uint256 toChainId, address toDapp, bytes calldata message, bytes calldata params) external payable {
        IMessagePort(PORT).send{value: msg.value}(toChainId, toDapp, message, params);
        emit DappMessageSent(PORT, message);
    }
}
