// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

/*
    @bepossible (https://dapp-world.com/soul/bepossible)
    Deploy Gas: 425404
    Transaction Gas: 701819
*/
contract Auction {

    mapping(uint256 => uint256) auction; //64/32/160 - time/price/address
    address immutable owner = msg.sender;

    function createAuction(uint256 itemNumber,uint256 startingPrice,uint256 duration) public { 
        require(msg.sender == owner); 
        require(startingPrice > 0); 
        require(duration > 0); 
        require(((auction[itemNumber] >> 160) & 0xffffffff) == 0); 
        unchecked { auction[itemNumber] = (((block.timestamp + duration) << 32) + startingPrice) << 160; }
    }

    function bid(uint256 itemNumber, uint256 bidAmount) public payable { 
        uint256 a = auction[itemNumber];
        require((a >> 192) > block.timestamp);
        uint256 p = ((a >> 160) & 0xffffffff);
        require(p > 0); 
        require(bidAmount == msg.value);
        require(p < bidAmount);
        unchecked { auction[itemNumber] = (a & 0xffffffffffffffff000000000000000000000000000000000000000000000000) + (bidAmount << 160) + uint160(msg.sender); }
    }
    
    function checkAuctionActive(uint256 itemNumber) public view returns (bool) { 
        return (auction[itemNumber] >> 192) > block.timestamp;
    }

    function cancelAuction(uint256 itemNumber) public { 
        require((auction[itemNumber] >> 192) > block.timestamp); 
        require(msg.sender == owner); 
        auction[itemNumber] = auction[itemNumber] & 0x0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff;
    }

    function timeLeft(uint256 itemNumber) public view returns (uint256) { 
        return (auction[itemNumber] >> 192) - block.timestamp;
    }

    function checkHighestBidder(uint256 itemNumber) public view returns (address b) { 
        uint256 a = auction[itemNumber];
        if((a >> 192) > 0) b = address(uint160(a));
    }

    function checkActiveBidPrice(uint256 itemNumber) public view returns (uint256){ 
        return (auction[itemNumber] >> 160) & 0xffffffff;
    }
}