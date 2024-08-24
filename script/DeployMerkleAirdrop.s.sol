//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Script } from "forge-std/Script.sol";
import { MerkleAirdrop } from "../src/MerkleAirdrop.sol";
import { Cookie } from "../src/Cookie.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployMerkleAirdrop is Script {
    bytes32 private MERKLE_ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;

    // 4 users, 25 Bagel tokens each
    uint256 private AMOUNT_TO_TRANSFER = 4 * (25 * 1e18);

    function deployMerkleAirdrop() public returns (MerkleAirdrop, Cookie) {
        vm.startBroadcast();
        Cookie cookieToken = new Cookie();
        MerkleAirdrop merkleAirdrop = new MerkleAirdrop(MERKLE_ROOT, IERC20(address(cookieToken)));
        cookieToken.mint(cookieToken.owner(), AMOUNT_TO_TRANSFER);
        cookieToken.transfer(address(merkleAirdrop), AMOUNT_TO_TRANSFER);
        vm.stopBroadcast();
        return (merkleAirdrop, cookieToken);
    }

    function run() external returns (MerkleAirdrop, Cookie) {
        return deployMerkleAirdrop();
    }
}
