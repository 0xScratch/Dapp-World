# Decimal to Binary - Hard

Two's Complement is a mathematical operation on binary numbers, as well as a binary signed number representation based on this operation. Its wide use in computing makes it the most important example of a radix complement.

In an 8-bit Two's Complement system, the positive numbers from 0 to 127 are represented as usual in binary form (00000000 to 01111111). The negative numbers from -1 to -128 are represented as the two's complement of their absolute values.

The Two's Complement of a binary number is calculated by inverting all the bits and then adding 1 (binary addition) to the result. For example, to get the Two's Complement of -5 , we first write 5 in binary (00000101), then we invert the bits (11111010), and finally we add 1 (11111011). So, -5 is represented as 11111011 in an 8-bit two's complement system.

You are required to modify your previous code to find the 8-bit Two's Complement representation of a number if the given number is negative. The input number will be a signed integer ranging from -128 to 127.

Your contract must implement the following public functions:

## Input

***toBinary(int n) returns (string)*** : This function takes integer as input and converts the input number to its 8-bit binary representation, and return the binary representation as a string.

### Examples

|    Example   |    Function    |           Parameter          |  Returns  |
| ----------   |  ------------  |          -----------         | --------- |
|      1       |   toBinary()   |              -1              |   "11111111"  |
|      2       |   toBinary()   |              -127              |   "10000001"  |

## Solve it here

Try your solutions directly on the [platform!](https://dapp-world.com/problem/decimal-to-binary-2/problem)
