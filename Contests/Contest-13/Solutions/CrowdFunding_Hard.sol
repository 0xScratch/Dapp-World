// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/*
    @author: JrNet (https://dapp-world.com/soul/JrNet)
    Deploy gas: 1570922
    Transaction gas: 4831960
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

contract CrowdFund {

    uint256 nxtId = 1;

    struct Campaign {
        uint160 creator;
        uint32 duration;
        uint256 goal;
        mapping(address => uint256) collected;
    }
    
    mapping(uint256 => Campaign) campaigns;
    mapping(uint256 => mapping(address => uint256)) contributions;
    

    address[] tokens;
    
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
    * @param _tokens list of allowed token addresses
    */
    constructor(address[] memory _tokens) {
        tokens = _tokens;
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
        Campaign storage c = campaigns[nxtId];

        c.creator = uint160(msg.sender);
        c.duration = uint32(block.timestamp + _duration);
        c.goal = _goal;
        
        
        ++nxtId;
    }

    /**
     * @dev contribute allows anyone to contribute to a campaign
     * @param _id the id of the campaign
     * @param _token the address of the token to contribute
     * @param _amount the amount of tokens to contribute
     */
    function contribute(uint256 _id, address _token, uint256 _amount) external {
        if(address(campaigns[_id].creator) == address(0)) { revert CampaignNotExist(); }
        if(address(campaigns[_id].creator) == msg.sender) { revert CreatorContribution(); }
        if(_amount <= 0) { revert ContributionFailed(); }

        contributions[uint160(msg.sender)<<32 | uint32(_id)][_token] += _amount;
        campaigns[_id].collected[_token] += _amount;
        
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        // if(!success) {
        //     revert ContributionFailed();
        // }
    }

    /**
     * @dev cancelContribution allows anyone to cancel their contribution
     * @param _id the id of the campaign
     */
    function cancelContribution(uint256 _id) external {
        uint256 key = (uint160(msg.sender) << 32 | uint32(_id));
        bool set;

        uint256 limit = tokens.length;
        for(uint i; i<limit; ) {
            address token = tokens[i];
            if(contributions[key][token] != 0)  {
                set = true;
                uint256 contribAmt = contributions[key][token];
                campaigns[_id].collected[token] -= contribAmt;
                contributions[key][token] = 0;
                IERC20(token).transfer(msg.sender, contribAmt);
                // if(!success) {
                //     revert RefundFailed();
                // }
            }

            unchecked { i = i+1; }
        }

        if (!set) {
            revert NoContributionFound();
        }
    }

    /**
     * @notice withdrawFunds allows the creator of the campaign to withdraw the funds
     * @param _id the id of the campaign
     */

    function withdrawFunds(uint256 _id) external {
        if(_id < 1 || _id >= nxtId) { revert NoContributionFound(); }

        if(msg.sender != address(campaigns[_id].creator) || campaigns[_id].duration > block.timestamp) {
            revert CampaignNotSucceded();
        }

        (,,uint256 cAmt) = _getCampaign(_id);
        if(campaigns[_id].goal > cAmt) { revert CampaignNotSucceded(); }

        uint256 limit = tokens.length;
        for(uint i; i<limit; ) {
            address token = tokens[i];
            if(IERC20(token).balanceOf(address(this)) > 0) {
                IERC20(token).transfer(msg.sender, campaigns[_id].collected[token]);
            }
            unchecked { i = i+1; }
        }
    }

    /**
     * @notice refund allows the contributors to get a refund if the campaign failed
     * @param _id the id of the campaign
     */
    function refund(uint256 _id) external {
        if(campaigns[_id].duration > block.timestamp) {
            revert CampaignSucceded();
        }

        (,,uint256 cAmt) = _getCampaign(_id);
        if(campaigns[_id].goal <= cAmt) { revert CampaignNotSucceded(); }

        uint256 key = (uint160(msg.sender) << 32 | uint32(_id));
        bool set;

        uint256 limit = tokens.length;
        for(uint i; i<limit; ) {
            address token = tokens[i];
            if(contributions[key][token] != 0)  {
                set = true;
                uint256 contribAmt = contributions[key][token];
                campaigns[_id].collected[token] -= contribAmt;
                contributions[key][token] = 0;
                IERC20(token).transfer(msg.sender, contribAmt);
                // if(!success) {
                //     revert RefundFailed();
                // }
            }

            unchecked { i = i+1; }
        }

        if (!set) {
            revert NoContributionFound();
        }
    }

    /**
     * @notice getContribution returns the contribution of a contributor in USD
     * @param _id the id of the campaign
     * @param _contributor the address of the contributor
     */
    function getContribution(uint256 _id, address _contributor) public view returns (uint256) {
        if(_id < 1 || _id >= nxtId) { revert NoContributionFound(); }

        uint256 cAmt;

        uint256 limit = tokens.length;
        for(uint i; i<limit; ) {
            address token = tokens[i];
            if(contributions[(uint160(_contributor) << 32 | uint32(_id))][token] != 0)  {
                cAmt += IERC20(token).getTokenPriceInUSD() * contributions[(uint160(_contributor) << 32 | uint32(_id))][token];
            }
            unchecked { i = i+1; }
        }

        return cAmt;
    }
		
		/**
		 * @notice getCampaign returns details about a campaign
		 * @param _id the id of the campaign
		 * @return remainingTime the time (in seconds) remaining for the campaign
		 * @return goal the goal of the campaign (in USD)
		 * @return totalFunds total funds (in USD) raised by the campaign
		 */
    function _getCampaign(uint256 _id)
        internal
        view
        returns (uint256 remainingTime, uint256 goal, uint256 totalFunds) {
            if(_id == 0 || _id >= nxtId ) { revert CampaignNotExist(); }

            uint256 cAmt;

            uint256 limit = tokens.length;
            for(uint i; i<limit; ) {
                address token = tokens[i];
                cAmt += IERC20(token).getTokenPriceInUSD() * campaigns[_id].collected[token];
                unchecked { i = i+1; }
            }

            if(campaigns[_id].duration <= block.timestamp) {
                remainingTime = 0;
            } else {
                remainingTime = campaigns[_id].duration - block.timestamp;
            }
            return (remainingTime, campaigns[_id].goal, cAmt);
        }

        function getCampaign(uint256 _id)
        external
        view
        returns (uint256 remainingTime, uint256 goal, uint256 totalFunds) {
            if(_id == 0 || _id >= nxtId ) { revert CampaignNotExist(); }

            uint256 cAmt;

            uint256 limit = tokens.length;
            for(uint i; i<limit; ) {
                address token = tokens[i];
                cAmt += IERC20(token).getTokenPriceInUSD() * campaigns[_id].collected[token];
                unchecked { i = i+1; }
            }

            return (campaigns[_id].duration - block.timestamp, campaigns[_id].goal, cAmt);
        }
}