//SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Script } from "forge-std/Script.sol";
import { DevOpsTools } from "foundry-devops/src/DevOpsTools.sol";
import { MerkleAirdrop } from "../src/MerkleAirdrop.sol";

contract InteractClaimAirdrop is Script {
    error InteractClaimAirdropScript__InvalidSignatureLength();

    address claimerAccount = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 AmountToClaim = 25 * 1e18;
    bytes32 PROOF_ONE = 0xd1445c931158119b00449ffcac3c947d028c0c359c34a6646d95962b3b55c6ad;
    bytes32 PROOF_TWO = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] proof = [PROOF_ONE, PROOF_TWO];
    bytes private SIGNATURE = hex =
        "0x6f83c0100b0f604ec4c49efe1a3cf7b9c293b6590fcf597e9017bc167ebf55de0f1953191239781a5e2b286b053ebfcf203a75649eff978f3fd9dff449d518f51b";

    function claimAirdrop(address merkleAirdrop) public {
        vm.startBroadcast();
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(SIGNATURE);
        MerkleAirdrop(merkleAirdrop).claim(claimerAccount, AmountToClaim, proof, v, r, s);
        vm.stopBroadcast();
    }

    function splitSignature(bytes memory signature) internal returns (uint8 v, bytes32 r, bytes32 s) {
        //32 + 32 + 1 = 65
        if (signature.length != 65) {
            revert InteractClaimAirdropScript__InvalidSignatureLength();
        }
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid);
        claimAirdrop(mostRecentlyDeployed);
    }
}
