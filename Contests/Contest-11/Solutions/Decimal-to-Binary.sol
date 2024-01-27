// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/*
    @Parthib234 (https://dapp-world.com/soul/Parthib234)
    Deploy Gas: 217448
    
*/
contract ToBinary{

	function toBinary(uint256 n) public pure returns (string memory ans) {
        if (n == 0) {
            return "0";
        }

        unchecked {
            while (n > 0) {
                ans = string(abi.encodePacked((n & 1 == 0) ? "0" : "1", ans));
                n >>= 1; // Right shift by 1 (equivalent to n = n / 2)
            }
        }

        return ans;
    }


}