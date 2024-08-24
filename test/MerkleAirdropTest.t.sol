//SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Test, console } from "forge-std/Test.sol";
import { MerkleAirdrop } from "../src/MerkleAirdrop.sol";
import { Cookie } from "../src/Cookie.sol";
import { ZkSyncChainChecker } from "lib/foundry-devops/src/ZkSyncChainChecker.sol";
import { DeployMerkleAirdrop } from "script/DeployMerkleAirdrop.s.sol";

contract MerkleAdropTest is ZkSyncChainChecker, Test {
    MerkleAirdrop public merkleAirdrop;
    Cookie public cookieToken;
    DeployMerkleAirdrop public deployer;

    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 public AMOUNT_TO_CLAIM = 25 * 1e18;
    uint256 public AMOUNT_TO_MINT = AMOUNT_TO_CLAIM * 4;
    bytes32 public ProofOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 public ProofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public PROOF = [ProofOne, ProofTwo];

    address user;
    uint256 userPrivateKey;

    function setUp() public {
        if (!isZkSyncChain()) {
            //Deploya con el script
            deployer = new DeployMerkleAirdrop();
            (merkleAirdrop, cookieToken) = deployer.run();
        } else {
            //Delploya con el contrato
            cookieToken = new Cookie();
            merkleAirdrop = new MerkleAirdrop(ROOT, cookieToken);

            // Minteamos Tokens al owner y se lo transferimos, para que así haya balance en el contrato que va dar el
            // airdrop al User.
            cookieToken.mint(cookieToken.owner(), AMOUNT_TO_MINT);
            cookieToken.transfer(address(merkleAirdrop), AMOUNT_TO_MINT);
        }

        //Creamos el account del usuario y la private key
        (user, userPrivateKey) = makeAddrAndKey("user");
    }

    function testUsersCanClaim() public {
        //console.log("User address: ", user); 0x6CA6d1e2D5347Bfab1d91e883F1915560e09129D

        //Lo primero que vamos a hacer es chequear que el balance inicial del usuario sea 0
        uint256 balanceOfUserBeforeClaim = cookieToken.balanceOf(user);
        console.log("Balance before claim: ", balanceOfUserBeforeClaim);

        vm.startPrank(user);
        merkleAirdrop.claim(user, AMOUNT_TO_CLAIM, PROOF);
        vm.stopPrank();

        uint256 balanceOfUserAfterClaim = cookieToken.balanceOf(user);
        console.log("Balance after claim: ", balanceOfUserAfterClaim);
        assertEq(balanceOfUserAfterClaim - balanceOfUserBeforeClaim, AMOUNT_TO_CLAIM);
    }
}
