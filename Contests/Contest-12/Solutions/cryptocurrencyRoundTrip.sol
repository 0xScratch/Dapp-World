// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
  @author: @Of3lija (https://dapp-world.com/soul/Of3lija)
*/
contract CryptoTrader {
    function roundTrip(
				int[] memory walletBalances, 
				int[] memory networkFees
				) public pure returns (int res) {

		assembly {
			let wb_len := mload(walletBalances)
			res := sub(0, 1)
			
			for {let start := 0} lt(start, wb_len) { start := add(start, 1) } {
				if lt(mload(add(walletBalances, add(0x20, mul(0x20, start)))), mload(add(networkFees, add(0x20, mul(0x20, start))))) {
					continue
				}

				let b_ := sub(mload(add(walletBalances, add(0x20, mul(0x20, start)))), mload(add(networkFees, add(0x20, mul(0x20, start)))))
				let idx := mod(add(start, 1), wb_len)

				for {} iszero(eq(idx, start)) {idx := mod(add(idx, 1), wb_len)} {
					b_ := add(b_, mload(add(walletBalances, add(0x20, mul(0x20, idx)))))
					if lt(b_, mload(add(networkFees, add(0x20, mul(0x20, idx))))) {
						break
					}
					b_ := sub(b_, mload(add(networkFees, add(0x20, mul(0x20, idx)))))
				}

				if eq(idx, start) {
					res := start
					break
				}
			}
		}
    }
}
