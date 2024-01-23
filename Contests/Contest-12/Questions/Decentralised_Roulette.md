# Decentralised Roulette

Bob, after an exhilarating trip to Las Vegas, the capital of gambling, was left in awe by the city's vibrant atmosphere. However, he couldn't shake
off the suspicion of manipulation in several games. Inspired by his experience, he decided to create a decentralized version of the roulette game
on the Ethereum blockchain, aiming to ensure fairness and transparency.

Roulette is a casino game where players may choose to place bets on either a single number, whether the number is odd or even, or the colors red or
black. Bob's version of Roulette simplifies the betting process to three options: betting on Even (Spin result is an even number), betting on Odd
(Spin result is an odd number), and betting on the exact number (Spin result is the exact number bet on).

In this Roulette game, players use tokens to play, with 1 Ether equaling 1000 ERC20 tokens. When betting on Even or Odd, if the ball lands on the
chosen outcome, the player gets an 80% return on their bet. For example, betting 100 tokens and winning on Even or Odd gives the player 180 tokens
back (100 bet + 80 win). If betting on a specific number and it hits, the return is 1800%. So, a 100 token bet on the right number pays out 1900
tokens (100 bet + 1800 win).

The smart contract should be designed in such a way that no manipulation is possible. Bob will be testing the contract thoroughly to ensure its
integrity

## Input

- ***buyTokens() payable*** : This function allows players to buy the ERC20 tokens. This function mints the token to the callers address.Players send Ether
to the contract and receive an equivalent amount of tokens in return.

- ***placeBetEven(uint betAmount)*** : This function allows players to place bets on the roulette landing on an even number and the amount of tokens bet are burned by the contract.

- ***placeBetOdd(uint betAmount)*** : This function allows players to place bets on the roulette landing on an odd number and the amount of tokens bet are burned by the contract.

- ***placeBetOnNumber(uint betAmount, uint number)*** : This function allows players to place bets on the roulette landing on a specific number and the amount of tokens bet are burned by the contract. The number should be within the range of 0 to 36 inclusive.

- ***spinWheel()*** : This function simulates the spinning of the roulette wheel and determines the winning bet. It should generate a random number between 0 and 36 inclusive, and it sets the variable SpinWheelResultwith the generated random number.This function can be called only by the owner.

- ***sellTokens(uint tokenAmount)*** : This function allows players to sell their tokens and receive Ether in return. The tokens sold are burned by the contract.The exchange rate of tokens to Ether is the same as when buying tokens.

- ***transferWinnings()*** : This function can be called only by the owner and only after spinWheel function has been called. This function mint and transfers the winning amount of tokens according to the generated random number and the bets.

- ***setSpinWheelResult(uint key)*** : This function allows bob to manually set the result of the spin wheel for testing purposes to ensure the integrity and functionality of the contract. The function takes a single parameter, which is the desired result of the spin wheel. The function then sets the SpinWheelResult variable with the passed parameter.

## Output

- ***checkBalance() returns (uint)***: This function returns the balance of ERC20 tokens for the player who calls this function.

- ***checkWinningNumber() returns (uint)***: This function returns the winning number after the roulette wheel has been spun.

- ***checkBetsOnEven() returns (address[], uint[])***: This function returns the array of address that have bet on the Even result of spin and amount array which shows how much that address has bet in the current round of spin.

- ***checkBetsOnOdd() returns (address[], uint[])***: This function returns the list of address that have bet on the Odd result of spin and amount array which shows how much that address has bet in the current round of spin.

- ***checkBetsOnDigit() returns (address[], uint[], uint[])***: This function returns three arrays. The first array contains the addresses of the players who have placed bets on the exact result of the spin. The second array contains the specific numbers that each player has bet on. The third array contains the amount of bet placed by each player in the current round of spin. Each index in these arrays corresponds to a unique bet, meaning the address, bet number, and bet amount at the same index in their respective arrays belong to the same bet.

### Examples

|  Input/Output  |       Function        |  Sender Address  |  Parameter   |        Value(Wei)       |   Expected Output   |
| -------------- |     ------------      | ---------------- | -----------  |      --------------     |  -----------------  |
|      Input     |      buyTokens()      |     Address 1    |      ()      |   1000000000000000000   |                     |
|      Input     |      buyTokens()      |     Address 2    |      ()      |   1000000000000000000   |                     |
|      Input     |      buyTokens()      |     Address 3    |      ()      |   1000000000000000000   |                     |
|      Input     |   placeBetOnNumber()  |     Address 1    |  (1000, 11)  |                         |                     |
|      Input     |   placeBetOnNumber()  |     Address 2    |  (1000, 12)  |                         |                     |
|      Input     |   placeBetOnNumber()  |     Address 3    |  (1000, 13)  |                         |                     |
|      Output    |   checkBetsOnDigit()  |       Owner      |      ()      |                         |   ([<Address 1>,<Address 2>,Address 3>], [11,12,13],[1000,1000,1000])                  |
