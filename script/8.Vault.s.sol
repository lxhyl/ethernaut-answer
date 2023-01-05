// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Script.sol";

import {Vault} from "../src/8.Vault.sol";
contract VaultScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Vault vault = new Vault(bytes32("123456"));
        vm.stopBroadcast();
    }
}
