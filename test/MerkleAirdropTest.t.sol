//SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {Cookie} from "../src/Cookie.sol";
//import {MakeMerkle} from "../src/MakeMerkle.sol";

contract MerkleAdropTest is Test {
    MerkleAidrop public merkleAirdrop;
    Cookie public cookieToken;

    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    address user;
    uint256 userPrivateKey;
    function setUp() public {
        cookieToken = new Cookie();
        merkleAirdrop = new MerkleAirdrop(merkleRoot, cookieToken);

        (user, userPrivateKey)= makeAddrAndKey("user");
    }

    function testUsersCanClaim() public {
        console.log("User address: ", user);
    }
}