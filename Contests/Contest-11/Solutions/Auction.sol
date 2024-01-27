// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

/*
    @Parthib234 (https://dapp-world.com/soul/Parthib234)
    Deploy Gas: 451286
    Transaction gas: 1148188
*/

contract Auction {

	struct Bid {
		address bider;
		uint256 amount;
		uint256 duration;
	}

    address immutable private owner;
	mapping (uint256 => Bid) auction;

	constructor(){
		owner = msg.sender;
	}

	function createAuction(uint256 itemNumber,uint256 startingPrice,uint256 duration) public {
		require(msg.sender == owner);
		require(auction[itemNumber].amount == 0);
		require(startingPrice>0);
		require(duration>0);
		Bid storage b = auction[itemNumber];
		b.amount = startingPrice;
		unchecked{
		  b.duration = duration+ block.timestamp;
		}
	 }

	function bid(uint256 itemNumber, uint256 bidAmount) public payable {
		require(checkAuctionActive(itemNumber));
		require(msg.sender != owner);
		require(auction[itemNumber].amount< bidAmount);
		payable(msg.sender).transfer(bidAmount);
		Bid storage b = auction[itemNumber];
		b.bider = msg.sender;
		b.amount = bidAmount;
	 }

	function checkAuctionActive(uint256 itemNumber) public view returns (bool) {
		return block.timestamp < auction[itemNumber].duration;
	 }

	function cancelAuction(uint256 itemNumber) public {
		require(msg.sender == owner);
		require(auction[itemNumber].amount != 0);
		require(block.timestamp < auction[itemNumber].duration);
		Bid storage b = auction[itemNumber];
		b.amount = 0;
		b.bider = address(0);
	 }

	function timeLeft(uint256 itemNumber) public view returns (uint256 ans) {
		require(auction[itemNumber].duration > block.timestamp);
		unchecked{
		ans = auction[itemNumber].duration - block.timestamp;

		}
	 }

	function checkHighestBidder(uint256 itemNumber) public view  returns (address) {
		return auction[itemNumber].bider;
	 }

	function checkActiveBidPrice(uint256 itemNumber) public view  returns (uint256){
		return auction[itemNumber].amount;
	 }

}