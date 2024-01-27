// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/*
    @Parthib234 (https://dapp-world.com/soul/Parthib234)
    Deploy Gas: 205692
*/
contract ToBinary{
		function toBinary(int256 n) public pure returns (string memory ans) {
        unchecked {
            for (uint8 i = 0; i < 8; i++) {
                ans = string(abi.encodePacked((n & (int256(1) << i)) == 0 ? "0" : "1", ans));
            }
        }
        return ans;
    }
}