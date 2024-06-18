#!/usr/bin/env bash

forge script script/Deploy.s.sol:DeploySender --broadcast --rpc-url https://koi-rpc.darwinia.network
forge script script/Deploy.s.sol:DeployReceiver --broadcast --rpc-url https://ethereum-sepolia.publicnode.com
