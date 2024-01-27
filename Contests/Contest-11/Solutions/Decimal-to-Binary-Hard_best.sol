// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/*
    @bepossible (https://dapp-world.com/soul/bepossible)
    Deploy Gas: 155503
*/
contract ToBinary{

	function toBinary(int256 n) public pure returns (string memory a) {
		assembly {
			a := mload(0x10)
			mstore(a, 0x08)
			for{let i := 0} lt(i, 8) { i := add(i, 1) } {
				mstore8(add(a, add(0x20, i)), add(and(1, shr(sub(7, i), n)), 0x30)) 
			}
		}
	}

}