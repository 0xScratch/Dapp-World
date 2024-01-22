// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
  @aryanmalik07 (https://dapp-world.com/soul/aryanmalik07)
  Deploy Gas: 408176
*/

contract RemoveVowels {
    function removeVowels(string calldata _input) external pure returns (string memory){
        unchecked {
            bytes memory _inputBytes = bytes(_input);
            bytes memory _result = new bytes(_inputBytes.length);
            uint256 _resultIndex;
            for(uint256 i; i < _inputBytes.length; ++i){
                bytes1 char = _inputBytes[i];
                if  (char >= 'A' && char <= 'Z') {
                    char = bytes1(uint8(char) + 32);
                }
                if(!(char == 'a' || char == 'e' || char == 'i' || char == 'o' || char == 'u')){
                    _result[_resultIndex] = _inputBytes[i];
                    _resultIndex++;
                }
            }
            bytes memory _finalResult = new bytes(_resultIndex);
            for(uint256 i; i < _resultIndex; ++i){
                _finalResult[i] = _result[i];
            }
            return string(_finalResult);
        }
    }
}
