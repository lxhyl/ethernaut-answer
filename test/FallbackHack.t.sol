// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Fallback} from "../src/Fallback.sol";
import {FallbackHack} from "../src/FallbackHack.sol";
contract FallbackHackTest is Test {
    Fallback fallbackContract;
    FallbackHack fallbackHack;
    function setUp() public {
        fallbackContract = new Fallback();
        fallbackHack = new FallbackHack(fallbackContract);
    }
    function testHack() public {
        fallbackHack.hack{value: 1 ether}();
        assertEq(address(fallbackContract).balance, 0);
        assertEq(fallbackContract.owner(), address(fallbackHack));
    }
}
