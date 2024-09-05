# Cross-chain PingPong

## Preparation

### Install foundry

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
forge install
```

### Clone repo and submodules

```bash
git clone --recursive https://github.com/ringecosystem/msgport-examples.git
```

### Account with balance

Before proceeding with the tutorial, you need an account with sufficient balance. This is required to perform contract operations in both the Koi and Sepolia testnets. If you don't have an account with sufficient balance, you may encounter difficulties when interacting with these contracts. Once you have the account, copy and create a `.env` file based on the `.env.example` file in the root of the repository. This will allow you to continue with the tutorial.

## Overview

This examples is designed very simple and straightforward, aims to illustrate how to integrate the Msgport protocol for a dapp. 

In this example, we will deploy the `PingPong` contract in both the Koi and Sepolia testnets. We will then call the `ping()` function of the `PingPong` contract in the Koi testnet, which will trigger the cross-chain message delivery and invoke the `pong()` function of the `PingPong` contract in the Sepolia testnet. Once the `pong` is received in the Sepolia testnet, it will call `ping` back and trigger the `pongReceive()` function of the source chain.

### Deploy PingPong in the Koi testnet

```sh
forge script src/pingpong/script/Deploy.s.sol:DPingPongSource --broadcast --rpc-url https://koi-rpc.darwinia.network
```

The output:

```sh
== Logs ==
  PingPong has been deployed at chain: 701, contract: 0xC0FFF7abA8C095ce1c074C743c7526aa7432535E

## Setting up 1 EVM.
==========================
Chain 701

Estimated gas price: 150.706512128 gwei
Estimated total gas used for script: 703866
Estimated amount required: 0.106077189865486848 ETH

==========================

##### 701
✅  [Success]Hash: 0xfa05e4ee172254dededb2f8e7364dea987cb768c2541afb989224b97fa429cf1
Contract Address: 0xC0FFF7abA8C095ce1c074C743c7526aa7432535E
Block: 193754
Paid: 0.040809967125653248 ETH (541582 gas * 75.353256064 gwei)

```

### Deploy PingPong in the Sepolia testnet

```sh
forge script src/pingpong/script/Deploy.s.sol:DPingPongTarget --broadcast --rpc-url https://ethereum-sepolia.publicnode.com
```

The output:

```sh
== Logs ==
  PingPong has been deployed at chain: 11155111, contract: 0x0c8541f3A9B5384029BFdbA5e8f8D6E4242FC02a

## Setting up 1 EVM.
==========================
Chain 11155111

Estimated gas price: 48.991176468 gwei
Estimated total gas used for script: 736711
Estimated amount required: 0.036092338606916748 ETH
==========================

##### sepolia
✅  [Success]Hash: 0xbf8c63f6cd7fbae37a6b92a51279b41bf0deabafff82f9ae18857c60e37dccf4
Block: 6243115
Paid: 0.00055404038891591 ETH (22490 gas * 24.634966159 gwei)


##### sepolia
✅  [Success]Hash: 0xb1d86cf0d529a8eee8e91462119a13ddcf22d19f41eb7d2f8c85afd8dee297ad
Contract Address: 0x0c8541f3A9B5384029BFdbA5e8f8D6E4242FC02a
Block: 6243115
Paid: 0.013340967383541814 ETH (541546 gas * 24.634966159 gwei)
```

### Send Ping from the Koi testnet

```sh
forge script src/pingpong/script/SendPing.s.sol:SendPing --broadcast --rpc-url https://koi-rpc.darwinia.network --gas-estimate-multiplier 200
```

The output:

```sh
== Logs ==
  The message has been sent to chain: 11155111, msgId: 0x2356043973bba1b6881ecf15b326fdc243fd2e7b2498fb12c4149e652421e81d

## Setting up 1 EVM.
==========================
Chain 701

Estimated gas price: 150.706512128 gwei
Estimated total gas used for script: 285696
Estimated amount required: 0.043056247688921088 ETH

==========================

##### 701
✅  [Success]Hash: 0x77d07b664edf1813e41a9284ac895f9335625203efd6b44771e2c3326dbc7f09
Block: 193773
Paid: 0.014324503271254272 ETH (190098 gas * 75.353256064 gwei)
```

After sending the ping, you can find the msgId in the output. The msgId can be used to track the status of the ping message in the [Msgport Scan](https://scan.msgport.xyz/). For example, you can check out the status on the Msgport Scan website by entering the msgId and selecting the network. If the status changes from "inflight" to "success", it means that the "pong" function in the target chain has been called successfully. It will then call back and trigger the `PongReceive` event in the Koi testnet.

To check the `PongReceive` event in the Koi testnet, you can wait for about 5 minutes and check the events for the PingPong contract in the Koi testnet.
