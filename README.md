# Experimenting with precompiles

To run:
```
forge build --zksync

forge create src/Counter.sol:Counter --private-key 0x2d64990aa363e3d38ae3417950fd40801d75e3d3bd57b86d17fcc261a6c951c6 --rpc-url http://localhost:3150 --zksync
```

Then you can call the precompiles:

```

cast call -r http://localhost:3150 0x2D60d2a35Dc1dD64b2E0a8eCB06887728a869185 'modExpHelper(uint256, uint256, uint256)' 2 3 100
Error: 
server returned an error response: error code 3: execution reverted: modexp precompile call failed
```


cast call -r http://localhost:3150 0x2D60d2a35Dc1dD64b2E0a8eCB06887728a869185 "ecAddHelper(uint256[2],uint256[2])" "[1,0]" "[1,0]"
Error: 
server returned an error response: error code 3: execution reverted: ecadd precompile call failed






## on ethereum (reth)


➜  example git:(master) ✗ cast call -r http://localhost:8545 0xD56a7D570494C6a4a2CB7740E6C8e5Da6895dA0C "ecmul(uint,uint,uint)"  1 2 3 
0x0769bf9ac56bea3ff40232bcb1b6bd159315d84715b8e679f2d355961915abf02ab799bee0489429554fdb7c8d086475319e63b40b9c5b57cdf1ff3dd9fe2261

➜  example git:(master) ✗ cast call -r http://localhost:8545 0xD56a7D570494C6a4a2CB7740E6C8e5Da6895dA0C "ecadd(uint,uint,uint,uint)"  1 2 1 2
0x030644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd315ed738c0e0a7c92e7845f96b2ae9c0a68a6a449e3538fc7ff3ebf7a5a18a2c4

cast call -r http://localhost:8545 0xD56a7D570494C6a4a2CB7740E6C8e5Da6895dA0C  "expmod(uint,uint,uint)(uint)" 2 3 100



## on zksync

modexp - error

ecadd - 153714 - for simple 1-2 1-2


      "circuit_statistic": {
        "code_decommitter": 1.0903339385986328,
        "code_decommitter_sorter": 0.0005191489472053945,
        "ecrecover": 0.1428571492433548,
        "events_sorter": 0.0006392431096173823,
        "keccak256": 0.08873720467090607,
        "log_demuxer": 0.0030638298485428095,
        "main_vm": 2.4901669025421143,
        "ram_permutation": 0.2883245348930359,
        "secp256k1_verify": 0.0,
        "sha256": 0.0,
        "storage_application": 1.6666666269302368,
        "storage_sorter": 0.002877176506444812,
        "transient_storage_checker": 0.0
      },


ecmul 1 2 100 -- 150k gas 

      "circuit_statistic": {
        "code_decommitter": 1.09982430934906,
        "code_decommitter_sorter": 0.0005191489472053945,
        "ecrecover": 0.1428571492433548,
        "events_sorter": 0.0006392431096173823,
        "keccak256": 0.08873720467090607,
        "log_demuxer": 0.0030638298485428095,
        "main_vm": 2.585899829864502,
        "ram_permutation": 0.29967668652534485,
        "secp256k1_verify": 0.0,
        "sha256": 0.0,
        "storage_application": 1.6666666269302368,
        "storage_sorter": 0.002877176506444812,
        "transient_storage_checker": 0.0
      },

then gasUsed -> 217k (for larger multiplier)

      "circuit_statistic": {
        "code_decommitter": 1.09982430934906,
        "code_decommitter_sorter": 0.0005191489472053945,
        "ecrecover": 0.1428571492433548,
        "events_sorter": 0.0006392431096173823,
        "keccak256": 0.08873720467090607,
        "log_demuxer": 0.0030638298485428095,
        "main_vm": 4.443042755126953,
        "ram_permutation": 0.5193469524383545,
        "secp256k1_verify": 0.0,
        "sha256": 0.0,
        "storage_application": 1.6666666269302368,
        "storage_sorter": 0.002877176506444812,
        "transient_storage_checker": 0.0
      },



## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
