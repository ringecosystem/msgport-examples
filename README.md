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

## Sending message from Pangolin to Sepolia via Darwinia Msgport

This demo aims to show a workable example of how to integrate Darwinia Msgport protocols for a dapp and how to send message from the Darwinia official Pangolin testnet to the Ethereum Sepolia testnet. The demo is designed very simple and easy understand, there is a pre-deployed contract in the Sepolia network(target) named `TestReceiver`, which has a `unit256` stoarge, named `sum` and a function name `addReceiveNum(uint256 num)` to support adjust the `sum` value. What we did in this demo is construct a message and sent it to a pre-deployed contract in the Pangolin named `TestSender` to increase the `sum` value in the Sepolia network.  Following the steps listed to have a try by your self and it's really helpful to help the user to understand deeper about the Darwinia Msgport.

1. Prepare an account with an efficient balance in the Pangolin testnet, refer to the [Pangolin Faucet](https://docs.darwinia.network/pangolin-chain-1e9ac8b09e874e8abd6a7f18c096ca6a#a3324b7c87ae44d9808753f03b2085b5) for free token. Please note that your account does not require the Sepolia token.

    ```sh
    export PRIVATE_KEY=0x................................................................
    ```

2. **(Optional)** For ease of use and simplicity, it is recommended to utilize the pre-deployed contracts for this demo. Deploying your own `TestSender` and `TestReceiver` contracts is an option, but not advised for those who are just looking to try out the demo quickly. The already deployed contract addresses are:

    - `TestSender` on Pangolin: [0x94e4e242548315F4133E4Fd1eb0962e0F5b7EF26](https://pangolin.subscan.io/account/0x94e4e242548315F4133E4Fd1eb0962e0F5b7EF26)
    - `TestReceiver` on Sepolia: [0xb115B479ef7cBAEae5a69Aae93ADb0287ADaA32c](https://sepolia.etherscan.io/address/0xb115B479ef7cBAEae5a69Aae93ADb0287ADaA32c)

    Using these contracts is the most straightforward approach to explore the functionalities of the Darwinia Msgport demo.

    ```sh
    ./bin/deploy.sh
    ```
3. Query the init `sum` value.

    ```sh
    ./bin/check.sh
    ```

    the output:

    ```sh
    [⠢] Compiling...
    No files changed, compilation skipped
    Script ran successfully.

    == Logs ==
    Sum: 20
    ```
4. Send a cross-chain message using Darwinia Msgport from Pangolin to trigger the `addReceiveNum` function on the Sepolia network, thereby increasing the sum value by 10.

    ```sh
    ./bin/send.sh
    ```

    the output:
    ```sh
    [⠢] Compiling...
    No files changed, compilation skipped
    Script ran successfully.

    ## Setting up 1 EVM.

    ==========================

    Chain 43
    Estimated gas price: 210.989116979 gwei
    Estimated total gas used for script: 334569
    Estimated amount required: 0.070590417878547051 ETH

    ==========================

    ###
    Finding wallets for all the necessary addresses...
    ##
    Sending transactions [0 - 0].
    ⠁ [00:00:00] [###########################################################################################################################################################################################################################################################] 1/1 txes (0.0s)
    Transactions saved to: /home/bear/coding/rust-space/msgport-demo/broadcast/SendMessage.s.sol/43/run-latest.json
    Sensitive values saved to: /home/bear/coding/rust-space/msgport-demo/cache/SendMessage.s.sol/43/run-latest.json

    ##
    Waiting for receipts.
    ⠉ [00:00:15] [#######################################################################################################################################################################################################################################################] 1/1 receipts (0.0s)
    ##### 43
    ✅  [Success]Hash: 0x45d1d7668efb49b304cc0317e49a379e967b54ea3c36222d8128adb0d2a8fd3e
    Block: 2394830
    Paid: 0.037231252487180544 ETH (242223 gas * 153.706512128 gwei)

    Transactions saved to: /home/bear/coding/rust-space/msgport-demo/broadcast/SendMessage.s.sol/43/run-latest.json
    Sensitive values saved to: /home/bear/coding/rust-space/msgport-demo/cache/SendMessage.s.sol/43/run-latest.json

    ==========================

    ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
    Total Paid: 0.037231252487180544 ETH (242223 gas * avg 153.706512128 gwei)
    Transactions saved to: /home/bear/coding/rust-space/msgport-demo/broadcast/SendMessage.s.sol/43/run-latest.json
    Sensitive values saved to: /home/bear/coding/rust-space/msgport-demo/cache/SendMessage.s.sol/43/run-latest.json
    ```


    After sending successfully, you can check the message status in the [Msgport Scan](https://docs.darwinia.network/msgport-scan-20e10e1727de4b07baaee0c7e1e3f627) through the transaction hash `✅  [Success]Hash: 0x45d1d7668efb49b304cc0317e49a379e967b54ea3c36222d8128adb0d2a8fd3e`.

5. Query the init `sum` value again.

    ```sh
    ./bin/check.sh
    ```

    the output:

    ```sh
    [⠢] Compiling...
    No files changed, compilation skipped
    Script ran successfully.

    == Logs ==
    Sum: 30
    ```

