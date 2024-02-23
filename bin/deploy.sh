#!/usr/bin/env bash

forge script script/Deploy.s.sol:DeploySender --broadcast --verify --rpc-url https://pangolin-rpc.darwinia.network
forge script script/Deploy.s.sol:DeployReceiver --broadcast --verify --rpc-url https://ethereum-sepolia.publicnode.com
