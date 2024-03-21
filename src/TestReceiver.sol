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

import "lib/darwinia-msgport/src/user/Application.sol";

contract TestReceiver is Application {
    event DappMessageRecv(uint256 fromChainId, address fromDapp, address localPort, uint256 num);

    // local port address
    address public immutable PORT;

    uint256 public sum;

    constructor(address port) {
        PORT = port;
    }

    /// @notice You could check the fromDapp address or messagePort address.
    function addReceiveNum(uint256 num) external {
        uint256 fromChainId = _fromChainId();
        address fromDapp = _xmsgSender();
        address localPort = _msgPort();
        require(localPort == PORT);
        sum += num;
        emit DappMessageRecv(fromChainId, fromDapp, localPort, num);
    }
}
