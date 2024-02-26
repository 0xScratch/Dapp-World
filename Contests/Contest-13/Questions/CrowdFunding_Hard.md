# CrowdFunding - Hard

The use of blockchains really stands out when it comes to clear-cut crowdfunding. People can easily gather funds for their causes, and donors have the freedom to contribute using ERC-20 token.

Your task in this problem is to create a smart contract that facilitates setting up crowdfunding campaigns and allows donations in form of an already deployed ERC-20 contract. You can check the smart contract implementation of the ERC-20 contract [here](https://dapp-world.com/smartbook/crowdfunding-problems---erc20-contract-sxVy).

NOTE: Relation between tokens and USD is defined in the ERC-20 contract.

Specifications:

- Anyone can create a new campaign by specifying the goal amount (in USD), and the duration.
- Any user, except for the creator of the campaign, can donate to any campaign using the token.
- Users can cancel their donations anytime for a particular campaign before the deadline has passed.
- If after the deadline has passed, the goal has not been reached, the campaign is said to be unsuccessful and donors can get their contributions back.

Your smart contract must contain the following public functions / constructor:

## Input

- ***constructor(address token)*** : The parameters token is the ERC-20 token a donor can donate with.

- ***createCampaign(uint256 goal, uint256 duration)*** : This function allows anyone to create a campaign of goal amount (in USD) with the time duration of duration (in seconds). As soon as the campaign is created, it is considered to be active. Each campaign must be associated with an id , starting from 1 and increasing one at a time.

- ***contribute(uint256 id, uint256 amount)*** : This function allows anyone to create a contribution of amount tokens to a campaign specified by the id . This function must revert if the campaign with id does not exist.

- ***cancelContribution(uint256 id)*** : This function allows any donor to cancel their contribution. It should revert if no donations have been made by the caller for the particular campaign.

- ***withdrawFunds(uint256 id)*** : This function allows the creator of the campaign id to collect all the contributions. This function must revert if the duration of the campaign has not passed, or / and the goal has not been met.

- ***refund(uint256 id)*** : This allows the donors to get their funds back if the campaign has failed. It should revert if no donations were made to this campaign by the caller.

## Output

- ***getContribution(uint id, address contributor) returns (uint256)*** : This function allows anyone to view the contributions made by contributor for the id campaign (in USD).

- ***getCampaign(uint256 id) returns (uint256, uint256, uint256)***: This function returns the remaining time, the goal, and the total funds collected (in USD).

## Solve it Here
