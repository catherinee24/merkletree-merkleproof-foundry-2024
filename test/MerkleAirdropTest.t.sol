//SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MerkleAdropTest is Test {
    MerkleAidrop merkleAirdrop;

    bytes32 merkleRoot;
    IERC20 airdropToken;
    function setUp() public {
        merkleAirdrop = new MerkleAirdrop(merkleRoot, IERC20(airdropToken));
    }
}