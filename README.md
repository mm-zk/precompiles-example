# Experimenting with precompiles

This repo has a bunch of example methods and scripts that test the different EC related precompiles.


## With the script

Running against RETH/GETH/Anvil
```
forge script script/Counter.s.sol --rpc-url http://localhost:8545 --private-key 0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6  --broadcast
```

to run against era -- just pass the '--zksync' (and correct RPC).


## Manually


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


cast call -r http://localhost:3150 0x3F015117432f4E2e970D3B6b918F3B92D17eFC88 "ecAddHelper(uint256[2],uint256[2])" "[1,2]" "[1,2]"
0x030644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd315ed738c0e0a7c92e7845f96b2ae9c0a68a6a449e3538fc7ff3ebf7a5a18a2c4

cast call -r http://localhost:3150 0x3F015117432f4E2e970D3B6b918F3B92D17eFC88 "ecmul(uint256,uint256,uint256)" 1 2 100        
0x12b6ea3252fd7f991b6c7759bc6b50f212d4d97fce265973af308a327675f69822f1cc798e3bfac4a4d7bdc55c3876b215da1ffd67d525c0cd570f963d21130f


cast call -r http://localhost:3150 0x3F015117432f4E2e970D3B6b918F3B92D17eFC88 "expmod(uint,uint,uint)" 2 3 100        
Error: 
server returned an error response: error code 3: execution reverted
// because we have no precompile for expmod

cast call -r http://localhost:3150 0x3F015117432f4E2e970D3B6b918F3B92D17eFC88  "ecadd(uint256,uint256,uint256,uint256)(uint256[2])"  0x1 0x2 1 2
[1368015179489954701390400359078579693043519447331113978918064868415326638035 [1.368e75], 9918110051302171585080402603319702774565515993150576347155970296011118125764 [9.918e75]]



REMEMBER - this is BN254 curve - not sepck256r1
(so this is y^2 == x^3 + 3)

cast call -r http://localhost:8545 0x700b6A60ce7EaaEA56F065753d8dcB9653dbAD35 "ecpairing(uint256,uint256,uint256,uint256,uint256,uint256)" \
    0x0000000000000000000000000000000000000000000000000000000000000000 \
    0x0000000000000000000000000000000000000000000000000000000000000000 \
    0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2 \
    0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed \
    0x090689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b \
    0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa


more examples in https://github.com/lambdaclass/zksync_era_precompiles/blob/main/tests/tests/ecpairing_tests.rs




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
        "main_vm": 2.4901669025421143,  [~1 main VM per call]
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
        "main_vm": 2.585899829864502, [~1 main VM per call]
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
        "main_vm": 4.443042755126953, [3 main VM per call]
        "ram_permutation": 0.5193469524383545,
        "secp256k1_verify": 0.0,
        "sha256": 0.0,
        "storage_application": 1.6666666269302368,
        "storage_sorter": 0.002877176506444812,
        "transient_storage_checker": 0.0
      },

ecpairing - gas used 174602 (so low??)

      "circuit_statistic": {
        "code_decommitter": 1.75079083442688,
        "code_decommitter_sorter": 0.0005191489472053945,
        "ecrecover": 0.1428571492433548,
        "events_sorter": 0.0006392431096173823,
        "keccak256": 0.09215017408132552,
        "log_demuxer": 0.0030808511655777693,
        "main_vm": 1.520964741706848, (very low - something is wrong..)
        "ram_permutation": 0.17389586567878723,
        "secp256k1_verify": 0.0,
        "sha256": 0.0,
        "storage_application": 1.6666666269302368,
        "storage_sorter": 0.002877176506444812,
        "transient_storage_checker": 0.0
      },

**for comparison -- calling a 'number()' method**
gas used: 121112 


      "circuit_statistic": {
        "code_decommitter": 1.0664323568344116,  [-0.03]
        "code_decommitter_sorter": 0.0005106382886879146, [same]
        "ecrecover": 0.1428571492433548, [same]
        "events_sorter": 0.0006392431096173823, [same]
        "keccak256": 0.08191126585006714, [-0.007]
        "log_demuxer": 0.0030638298485428095, [same]
        "main_vm": 1.455844163894653, []
        "ram_permutation": 0.16587181389331818, [-0.1]
        "secp256k1_verify": 0.0, [same]
        "sha256": 0.0, [same]
        "storage_application": 1.6666666269302368, [same]
        "storage_sorter": 0.002877176506444812, [same]
        "transient_storage_checker": 0.0 [same]
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
