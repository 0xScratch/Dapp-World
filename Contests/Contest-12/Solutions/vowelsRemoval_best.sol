// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
  @bepossible (https://dapp-world.com/soul/bepossible)
  Deploy Gas: 261292
*/

contract RemoveVowels {

    /**
     * remove A, E, I, O, U from _input
     * A - 65(97), E - 69, I - 73, O - 79, U - 85(117) Z - 90
     */
    function removeVowels(string memory _input) public pure returns (string memory){
        uint256 bytelength = bytes(_input).length + 1;         
        string memory output;
        assembly {
            output := mload(0x20)
            mstore(output, 0x20)

            let a := 0
            for{let i := 1} lt(i, bytelength) { i := add(i, 1) } {
                let c := byte(31, mload(add(_input, i)))
                let b := and(c, 223)
                if gt(xor(b, 65), 0) {
                    if gt(xor(b, 69), 0) {
                        if gt(xor(b, 73), 0) {
                            if gt(xor(b, 79), 0) {
                                if gt(xor(b, 85), 0) {
                                    mstore8(add(output, add(0x20, a)), c)
                                    a := add(a, 1)
                                }                
                            }
                        }    
                    }
                }
            }
            mstore(output, a)
        }
        return output;        
    }
}
