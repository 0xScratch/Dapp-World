# Simple Operations

In this problem you need to implement functions that performs some simple operations.

Your smart contract must include the following public functions:

## Output

- ***calculateAverage(uint256 a, uint256 b) returns (uint256 c)***: This function takes in two uint256 and returns their average.

- ***getBit(uint256 num, uint position) returns (uint8)***: This function retrieves the bit (0 or 1) at the specified position, counting from right towards left in the binary representation of num. The counting of position is expected to start from 1. If the specified position exceeds the position of the last bit with a value of 1 in the binary representation, the function reverts.

- ***sendEth(address to) payable***: This function sends the received amount of ETH to to. The function is expected to work even if the to is the solution contract address but not if to is the sender.

## Solve it Here
