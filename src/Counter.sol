// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }

    bytes public _result;

    uint256 public modexpResult;
    uint256[2] public ecAddResult;

    // Helper to call the `modexp` precompile with uint256 values and store the result as uint256
    function modExpHelper(uint256 base, uint256 exp, uint256 modulus) public {
        // Call the modexp precompile and convert result to uint256
        modexpResult = expmod(base, exp, modulus);
    }

    // works.
    function expmod(uint base, uint e, uint m) public view returns (uint o) {
        assembly {
            // define pointer
            let p := mload(0x40)
            // store data assembly-favouring ways
            mstore(p, 0x20) // Length of Base
            mstore(add(p, 0x20), 0x20) // Length of Exponent
            mstore(add(p, 0x40), 0x20) // Length of Modulus
            mstore(add(p, 0x60), base) // Base
            mstore(add(p, 0x80), e) // Exponent
            mstore(add(p, 0xa0), m) // Modulus
            if iszero(staticcall(sub(gas(), 2000), 0x05, p, 0xc0, p, 0x20)) {
                revert(0, 0)
            }
            // data
            o := mload(p)
        }
    }

    // Helper to call the `ecadd` precompile with uint256 points (P, Q)
    function ecAddHelper(
        uint256[2] memory point1,
        uint256[2] memory point2
    ) public view returns (uint256[2] memory result) {
        // Convert uint256 values to bytes32 for ECADD precompile
        bytes32[2] memory p1 = [bytes32(point1[0]), bytes32(point1[1])];
        bytes32[2] memory p2 = [bytes32(point2[0]), bytes32(point2[1])];

        // Call the ecadd precompile
        bytes32[2] memory sum = ecAdd(p1, p2);

        // Convert bytes32 output back to uint256
        result[0] = uint256(sum[0]);
        result[1] = uint256(sum[1]);
    }

    // Internal function to call the `modexp` precompile
    function modExp(
        bytes memory base,
        bytes memory exp,
        bytes memory modulus
    ) internal view returns (bytes memory) {
        uint baseLength = base.length;
        uint expLength = exp.length;
        uint modulusLength = modulus.length;

        // Prepare the input for the modexp precompile
        bytes memory input = abi.encodePacked(
            uint32(baseLength),
            uint32(expLength),
            uint32(modulusLength),
            base,
            exp,
            modulus
        );

        // Output buffer for result (size of modulus)
        bytes memory output = new bytes(modulusLength);

        bool success;
        assembly {
            // Call the modexp precompile at address 0x05
            success := staticcall(
                gas(), // Use all available gas
                0x05, // Address of modexp precompile
                add(input, 0x20), // Pointer to input data
                mload(input), // Input size
                add(output, 0x20), // Pointer to output buffer
                modulusLength // Output size
            )
        }

        require(success, "modexp precompile call failed");
        return output;
    }

    // Internal function to call the `ecadd` precompile
    function ecAdd(
        bytes32[2] memory point1,
        bytes32[2] memory point2
    ) internal view returns (bytes32[2] memory result) {
        bytes memory input = abi.encodePacked(
            point1[0],
            point1[1],
            point2[0],
            point2[1]
        );
        bytes memory output = new bytes(64); // 64 bytes for the result (32 bytes for x, 32 bytes for y)

        bool success;
        bytes32 result0;
        bytes32 result1;
        assembly {
            // Call the ecadd precompile at address 0x06
            success := staticcall(
                gas(), // Use all available gas
                0x06, // Address of ecadd precompile
                add(input, 0x20), // Pointer to input data
                mload(input), // Input size (128 bytes)
                add(output, 0x20), // Pointer to output buffer
                64 // Output size (64 bytes)
            )
            result0 := mload(add(output, 0x20)) // x coordinate
            result1 := mload(add(output, 0x40)) // y
        }

        require(success, "ecadd precompile call failed");
        result[0] = result0;
        result[1] = result1;
    }

    uint256 public tmpfoo;
    function juststore(uint foo) public {
        tmpfoo = foo;
    }

    function ecadd(
        uint ax,
        uint ay,
        uint bx,
        uint by
    ) public view returns (uint[2] memory p) {
        uint[4] memory input;
        input[0] = ax;
        input[1] = ay;
        input[2] = bx;
        input[3] = by;

        assembly {
            if iszero(
                staticcall(sub(gas(), 2000), 0x06, input, 0x80, p, 0x40)
            ) {
                revert(input, 2)
            }
        }
        return p;
    }

    function ecmul(
        uint256 ax,
        uint256 ay,
        uint256 k
    ) public view returns (uint256[2] memory p) {
        uint256[3] memory input;
        input[0] = ax;
        input[1] = ay;
        input[2] = k;

        assembly {
            if iszero(
                staticcall(sub(gas(), 2000), 0x07, input, 0x60, p, 0x40)
            ) {
                revert(input, 2)
            }
        }
        return p;
    }

    function ecpairing(
        uint256 g1_x,
        uint256 g1_y,
        uint256 g2_x1,
        uint256 g2_x2,
        uint256 g2_y1,
        uint256 g2_y2
    ) public view returns (bool result) {
        uint256[6] memory input;
        input[0] = g1_x;
        input[1] = g1_y;
        input[2] = g2_x1;
        input[3] = g2_x2;
        input[4] = g2_y1;
        input[5] = g2_y2;

        // Call the precompile at address 0x08 (for pairing)
        assembly {
            // Perform the static call to the pairing precompile
            let success := staticcall(
                gas(), // Forward all available gas
                0x08, // Precompile address (ecpairing)
                input, // Input location (G1 and G2 points)
                0xc0, // Input size (192 bytes = 6*32 bytes)
                input, // Output location (reuse input memory for result)
                0x20 // Output size (32 bytes)
            )

            // Set the result to 1 (true) if successful and pairing is valid, otherwise 0 (false)
            result := and(success, mload(input))
        }
    }

    // Convert bytes to uint256
    function bytesToUint(bytes memory b) internal pure returns (uint256) {
        uint256 n;
        assembly {
            n := mload(add(b, 0x20))
        }
        return n;
    }
}
