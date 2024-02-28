// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/*
    @author: JrNet (https://dapp-world.com/soul/JrNet)
    Deploy gas: 1146069
    Transaction gas: 2768733
*/
interface IERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  
  function getTokenPriceInUSD() external view returns (uint256);
}

contract CrowdFundEasy {
  IERC20 token;
  uint256 nxtId = 1;
  
  struct Campaign {
    uint160 creator;
    uint32 duration;
    uint256 goal;
    uint256 collected;
  }
  
  mapping(uint256 => Campaign) campaigns;
  mapping(uint256 => uint256) contributions;
  
  error CampaignNotExist();
  error CreatorContribution();
  error ContributionFailed();
  error NoContributionFound();
  error CampaignNotSucceded();
  error RefundFailed();
  error WithdrawFailed();
  error CampaignCreationFailed();
  error CampaignSucceded();
  
  /**
   * @param _token list of allowed token addresses
	 */
  constructor(address _token) {
    token = IERC20(_token);
  }
  
  /**
   * @notice createCampaign allows anyone to create a campaign
     * @param _goal amount of funds to be raised in USD
     * @param _duration the duration of the campaign in seconds
     */
  function createCampaign(uint256 _goal, uint256 _duration) external {
    if(_goal < 1 || _duration < 1) {
      revert CampaignCreationFailed();
    }
    
    campaigns[nxtId] = Campaign(
      uint160(msg.sender),
      uint32(block.timestamp + _duration),
      _goal,
      0
    );
    
    ++nxtId;
  }
  
  /**
   * @dev contribute allows anyone to contribute to a campaign
     * @param _id the id of the campaign
     * @param _amount the amount of tokens to contribute
     */
  function contribute(uint256 _id, uint256 _amount) external {
    if(address(campaigns[_id].creator) == address(0)) { revert CampaignNotExist(); }
    if(address(campaigns[_id].creator) == msg.sender) { revert CreatorContribution(); }
    if(_amount <= 0) { revert ContributionFailed(); }
    
    uint256 priceInUsd = token.getTokenPriceInUSD();
    if(priceInUsd * _amount > priceInUsd * campaigns[_id].goal) { revert ContributionFailed(); }
    
    contributions[uint160(msg.sender)<<32 | uint32(_id)] += _amount;
    campaigns[_id].collected += _amount;
    
    bool success = token.transferFrom(msg.sender, address(this), _amount);
    if(!success) {
      revert ContributionFailed();
    }
  }
  
  /**
   * @dev cancelContribution allows anyone to cancel their contribution
     * @param _id the id of the campaign
     */
  function cancelContribution(uint256 _id) external {
    uint256 key = (uint160(msg.sender) << 32 | uint32(_id));
    if(contributions[key] == 0) { revert NoContributionFound(); }
    
    uint256 contrbAmt = contributions[key];
    campaigns[_id].collected -= contrbAmt;
    contributions[key] = 0;
    
    bool success = token.transfer(msg.sender, contrbAmt);
    if(!success) {
      revert RefundFailed();
    }
  }
  
  /**
   * @notice withdrawFunds allows the creator of the campaign to withdraw the funds
     * @param _id the id of the campaign
     */
  
  function withdrawFunds(uint256 _id) external {
    uint256 collected = campaigns[_id].collected;
    if(campaigns[_id].duration > block.timestamp || token.getTokenPriceInUSD() * collected < campaigns[_id].goal) {
      revert CampaignNotSucceded();
    }
    
    bool success = token.transfer(msg.sender, collected);
    if(!success) {
      revert WithdrawFailed();
    }
  }
  
  /**
   * @notice refund allows the contributors to get a refund if the campaign failed
     * @param _id the id of the campaign
     */
  function refund(uint256 _id) external {
    if(campaigns[_id].duration > block.timestamp || token.getTokenPriceInUSD() * campaigns[_id].collected >= campaigns[_id].goal) {
      revert CampaignSucceded();
    }
    
    uint256 key = (uint160(msg.sender) << 32 | uint32(_id));
    uint256 contrbAmt = contributions[key];
    if(contrbAmt == 0) { revert NoContributionFound(); }
    
    contributions[key] = 0;
    bool success = token.transfer(msg.sender, contrbAmt);
    if(!success) {
      revert RefundFailed();
    }
  }
  
  /**
   * @notice getContribution returns the contribution of a contributor in USD
     * @param _id the id of the campaign
     * @param _contributor the address of the contributor
     */
  function getContribution(uint256 _id, address _contributor) public view returns (uint256) {
    return token.getTokenPriceInUSD() * contributions[(uint160(_contributor) << 32 | uint32(_id))];
  }
  
  /**
  * @notice getCampaign returns details about a campaign
    * @param _id the id of the campaign
    * @return remainingTime the time (in seconds) when the campaign ends
    * @return goal the goal of the campaign (in USD)
    * @return totalFunds total funds (in USD) raised by the campaign
    */
  function getCampaign(uint256 _id)
  external
  view
  returns (uint256 remainingTime, uint256 goal, uint256 totalFunds)
  {
    if(_id == 0 || _id >= nxtId ) { revert CampaignNotExist(); }
    return (uint256(campaigns[_id].duration - block.timestamp), campaigns[_id].goal, token.getTokenPriceInUSD() * campaigns[_id].collected);
  }
}