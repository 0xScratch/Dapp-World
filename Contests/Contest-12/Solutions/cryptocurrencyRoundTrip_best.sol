// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
  @author: @aryanmalik07 (https://dapp-world.com/soul/aryanmalik07)
*/
contract CryptoTrader {
    function roundTrip (
        int[] calldata walletBalances,
        int[] calldata networkFees
    ) public pure returns (int) {
        unchecked {
            uint balancesLength = uint(walletBalances.length);

            int sum;
            int index;
            bool flag;
            int sub_sum;
            for (uint i; i < balancesLength; ++i) {
                int total = walletBalances[i] - networkFees[i];
                sum += total;
                sub_sum += total;
                
                if (total >= 0 && flag == false) {
                    flag = true;
                    index = int(i);
                } else if (sub_sum < 0) {
                    flag = false;
                    sub_sum = 0;
                }
            }

            if (sub_sum >= 0 && sum >= 0) {
                return index;
            } else {
                return -1;
            }
        }
    }
}
