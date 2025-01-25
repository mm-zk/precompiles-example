// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";

contract CounterScript is Script {
    Counter public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new Counter();

        uint256 result = counter.expmod(2, 3, 100);
        require(result == 8);
        console.log("expmod ok");

        uint256[2] memory result1 = counter.ecAddHelper(
            [uint256(1), uint256(2)],
            [uint256(1), uint256(2)]
        );

        console.log(result1[0]);
        console.log(result1[1]);

        require(
            result1[0] ==
                uint256(
                    1368015179489954701390400359078579693043519447331113978918064868415326638035
                )
        );
        require(
            result1[1] ==
                uint256(
                    9918110051302171585080402603319702774565515993150576347155970296011118125764
                )
        );

        console.log("ecAdd ok");

        uint256[2] memory result2 = counter.ecmul(
            uint256(1),
            uint256(2),
            uint256(100)
        );

        console.log(result2[0]);
        console.log(result2[1]);

        require(
            result2[0] ==
                uint256(
                    8464813805670834410435113564993955236359239915934467825032129101731355555480
                )
        );

        require(
            result2[1] ==
                uint256(
                    15805858227829959406383193382434604346463310251314385567227770510519895659279
                )
        );
        console.log("ecmul ok");

        bool result3 = counter.ecpairing(
            uint256(0),
            uint256(0),
            uint256(
                0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2
            ),
            uint256(
                0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed
            ),
            uint256(
                0x090689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b
            ),
            uint256(
                0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa
            )
        );

        require(result3 == true);

        console.log("ecpairing ok");

        vm.stopBroadcast();
    }
}
