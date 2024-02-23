# Darwinia Msgport Demo

## Preparation

### Install foundry

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
forge install
```

### Clone repo and submodules

```bash
git clone --recursive https://github.com/darwinia-network/msgport-demo.git
```

## Sending cross-chain message via Darwinia Msgport

### Deploy test contracts (Optional)

> We have deployed TestSender(on Pangolin) and TestReceiver(on Sepolia) which has a public sum value, and we will increase it remotely.

1. export PRIVATE_KEY=0x...
2. sh bin/deploy.sh

### Sending message

> This script calls `addReceiveNum`(on Sepolia) from Pangolin through msgport.

1. sh bin/send.sh
2. After sending successfully, you can check the message status in the message scan(msgscan.darwinia.network) through the transaction hash.

### Check result

> You could check the sum of TestReceiver(on Sepolia) using this script, when the message is received successfully, the value will change. Here we add 10 to sum.

1. sh bin/check.sh
