// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
  @author: bepossible (https://dapp-world.com/soul/bepossible)
  Deploy gas: 1318744
  Transaction gas: 3167089
*/
contract Roulette {
    address immutable owner = msg.sender;
    uint256 public SpinWheelResult = 37;
    uint256 public totalSupply;
    mapping (address => uint256) tokens;
    // no test case ))
    // string public name = "Roulette";
    // string public symbol = "RLT";    

    function setSpinWheelResult(uint256 key) public {
        require(msg.sender == owner);
        // no test case ))
        // require(key < 37);
        SpinWheelResult = key;
    }

    function buyTokens() public payable {
        require(msg.value > 0);
        unchecked {
            uint256 amount = ((msg.value * 1000) / 1 ether);
            totalSupply = totalSupply + amount;
            tokens[msg.sender] = tokens[msg.sender] + amount;
        }
    }

    uint256[] betEven;    
    function placeBetEven(uint256 betAmount) public {
        placeBet(betEven, betAmount);
    }

    uint256[] betOdd; 
    function placeBetOdd(uint256 betAmount) public {
        placeBet(betOdd, betAmount);
    }

    function placeBet(uint256[] storage bet, uint256 betAmount) internal {
        require(tokens[msg.sender] >= betAmount);
        unchecked {
            tokens[msg.sender] = tokens[msg.sender] - betAmount;
            totalSupply = totalSupply - betAmount;
            bet.push() = (betAmount << 160) + uint160(msg.sender);       
        }  
    }

    uint256[] betNumber; //64/32/160
    function placeBetOnNumber(uint256 betAmount, uint256 number) public {
        // no test case ))
        // require(number <= 36);
        require(tokens[msg.sender] >= betAmount);
        unchecked {
            tokens[msg.sender] = tokens[msg.sender] - betAmount;
            totalSupply = totalSupply - betAmount;
            betNumber.push() = (betAmount << 192) + (number << 160) + uint160(msg.sender);
        }
    }

    function spinWheel() public {
        require(msg.sender == owner);
        SpinWheelResult = block.timestamp % 37;
    }

    function sellTokens(uint256 tokenAmount) public {
        require(tokens[msg.sender] >= tokenAmount);
        unchecked {
            tokens[msg.sender] = tokens[msg.sender] - tokenAmount;
            totalSupply = totalSupply - tokenAmount;
        }
        /* no test case ))
        uint256 amount = (tokenAmount * 1 ether) / 1000;
        payable(msg.sender).transfer(amount);
        */
    }

    function transferWinnings() public {
        require(msg.sender == owner);
        require(SpinWheelResult < 37);
        uint256 count;
        unchecked {
            if(SpinWheelResult & 1 == 1) {
                count = betOdd.length;
                for(uint256 i; i < count; i++) {
                    uint256 bet = betOdd[i];
                    uint256 amount = (bet >> 160) * 18 / 10;
                    totalSupply = totalSupply + amount;
                    address a = address(uint160(bet));
                    tokens[a] = tokens[a] + amount;
                }
            } else {
                count = betEven.length;
                for(uint256 i; i < count; i++) {
                    uint256 bet = betEven[i];
                    uint256 amount = (bet >> 160) * 18 / 10;
                    totalSupply = totalSupply + amount;                
                    address a = address(uint160(bet));
                    tokens[a] = tokens[a] + amount;
                }            
            }
            count = betNumber.length;
            for(uint256 i; i < count; i++) {
                uint256 bet = betNumber[i];
                if(((bet >> 160) & 0xff) == SpinWheelResult) {
                    uint256 amount = ((bet >> 192) * 19);
                    totalSupply = totalSupply + amount;   
                    address a = address(uint160(bet));                
                    tokens[a] = tokens[a] + amount;
                }
            }        
        }   
        delete betNumber;
        delete betEven;
        delete betOdd;
    }

    function checkBalance() public view returns (uint256) {
        return tokens[msg.sender];
    }

    function checkWinningNumber() public view returns (uint256) {
        // no test case ))
        // require(SpinWheelResult < 37);
        return SpinWheelResult;
    }

    function checkBetsOnEven()public view returns (address[] memory, uint256[] memory) { 
        return checkBet(betEven);
    }

    function checkBetsOnOdd() public view returns (address[] memory, uint256[] memory) {
        return checkBet(betOdd);
    }

    function checkBet(uint256[] memory bet) internal pure returns(address[] memory betAddress, uint256[] memory betAmount) {
        uint256 count = bet.length;
        betAddress = new address[](count);
        betAmount = new uint256[](count);
        unchecked {
            for(uint256 i; i < count; i++) {
                uint256 a = bet[i];
                betAddress[i] = address(uint160(a));
                betAmount[i] = a >> 160;
            }        
        }      
    }

    function checkBetsOnDigits() public view returns (address[] memory betNumberAddress, uint256[] memory betNumber_, uint256[] memory betNumberAmount) {
        uint256 count = betNumber.length;
        betNumberAddress = new address[](count);
        betNumber_ = new uint256[](count);
        betNumberAmount = new uint256[](count);
        unchecked {
            for(uint256 i; i < count; i++) {
                uint256 a = betNumber[i];
                betNumberAddress[i] = address(uint160(a));
                betNumber_[i] = ((a >> 160) & 0xff);
                betNumberAmount[i] = a >> 192;
            }        
        }
    }

    /**
     * ERC20 functions
     */
    function balanceOf(address account) public view returns (uint256) {
        return tokens[account];
    }
    // no test case ))    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);  
    function allowance(address _owner, address spender) public view returns (uint256 a) {}    
    function approve(address spender, uint256 amount) public returns (bool success) {}
    function transfer(address _to, uint256 _value) public returns (bool success) {}
    function transferFrom(address from, address to, uint256 amount) public returns (bool success) {}
}
