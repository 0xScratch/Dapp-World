// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/*
    @author: JrNet (https://dapp-world.com/soul/JrNet)
    Deploy gas: 273469
    Transaction gas: 125072
*/
contract SimpleOperations {

    // custom errors
    error transferFailed();
    error exceedingBitRate();

    /**
     * @notice calculateAverage calculates the average of two numbers
     * @param a the first number
     * @param b the second number
     * @return the average of the two numbers
     */
    function calculateAverage(
        uint256 a,
        uint256 b
    ) public pure returns (uint256) {
        return (a + b) >> 1;
    }

    /**
     * @notice getBit returns the bit at the given position
     * @param num the number to get the bit from
     * @param position the position of the bit to get
     * @return the bit at the given position
     */
    function getBit(uint256 num, uint256 position) public pure returns (uint8) {
        position--;
        if(num < (uint256(1) << position)) { revert exceedingBitRate(); }
        return uint8((num >> position) & 1);
    }

    /**
     * @notice sendEth sends ETH to the given address
     * @param to the address to send ETH to
     */
    function sendEth(address to) public payable {
        if(to == msg.sender) { revert transferFailed(); }
        payable(to).transfer(msg.value);
    }
}