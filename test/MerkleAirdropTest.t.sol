//SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Test, console } from "forge-std/Test.sol";
import { MerkleAirdrop } from "../src/MerkleAirdrop.sol";
import { Cookie } from "../src/Cookie.sol";
import { ZkSyncChainChecker } from "lib/foundry-devops/src/ZkSyncChainChecker.sol";
import { DeployMerkleAirdrop } from "script/DeployMerkleAirdrop.s.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MerkleAdropTest is ZkSyncChainChecker, Test {
    event Claimed(address indexed claimerAccount, uint256 amountToClaim);

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    SETUP
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/

    MerkleAirdrop public merkleAirdrop;
    Cookie public cookieToken;
    DeployMerkleAirdrop public deployer;

    bytes32 public MERKLE_ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 public AMOUNT_TO_CLAIM = 25 * 1e18;
    uint256 public AMOUNT_TO_MINT = AMOUNT_TO_CLAIM * 4;
    bytes32 public MERKLE_PROOFOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 public MERKLE_PROOFTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public MERKLE_PROOF = [MERKLE_PROOFOne, MERKLE_PROOFTwo];

    address public gasPayer;
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
            merkleAirdrop = new MerkleAirdrop(MERKLE_ROOT, cookieToken);

            // Minteamos Tokens al owner y se lo transferimos, para que así haya balance en el contrato que va dar el
            // airdrop al User.
            cookieToken.mint(cookieToken.owner(), AMOUNT_TO_MINT);
            cookieToken.transfer(address(merkleAirdrop), AMOUNT_TO_MINT);
        }

        //Creamos el account del usuario y la private key
        (user, userPrivateKey) = makeAddrAndKey("user");
        gasPayer = makeAddr("gasPayer");
    }
    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                MODIFIERS TEST
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/

    modifier userClaim() {
        bytes32 message = merkleAirdrop.getMessage(user, AMOUNT_TO_CLAIM);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivateKey, message);
    
        vm.startPrank(gasPayer);
        merkleAirdrop.claim(user, AMOUNT_TO_CLAIM, MERKLE_PROOF, v, r, s);
        vm.stopPrank();
        _;
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                CLAIM TEST
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    function testUsersCanClaim() public {
        //console.log("User address: ", user); 0x6CA6d1e2D5347Bfab1d91e883F1915560e09129D

        //Lo primero que vamos a hacer es chequear que el balance inicial del usuario sea 0
        uint256 balanceOfUserBeforeClaim = cookieToken.balanceOf(user);
        console.log("Balance before claim: ", balanceOfUserBeforeClaim);

        //Obtenemos el mensaje que vamos a firmar 
        bytes32 message = merkleAirdrop.getMessage(user, AMOUNT_TO_CLAIM);
        // User sign the message
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivateKey, message);

        //gasPayer call claim using the signed message to send the transaccion for them and pay the gas.
        vm.prank(gasPayer);
        merkleAirdrop.claim(user, AMOUNT_TO_CLAIM, MERKLE_PROOF, v, r, s);

        uint256 balanceOfUserAfterClaim = cookieToken.balanceOf(user);
        console.log("Balance after claim: ", balanceOfUserAfterClaim);
        assertEq(balanceOfUserAfterClaim - balanceOfUserBeforeClaim, AMOUNT_TO_CLAIM);
    }

    function testUserAlreadyClaimed() public userClaim {
        bytes32 message = merkleAirdrop.getMessage(user, AMOUNT_TO_CLAIM);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivateKey, message);
        
        vm.startPrank(gasPayer);            
        vm.expectRevert(MerkleAirdrop.MerkleAirdrop__AlreadyClaimed.selector);
        merkleAirdrop.claim(user, AMOUNT_TO_CLAIM, MERKLE_PROOF, v, r, s);
        vm.stopPrank();
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                            MERKLE PROOF VALIDATION TEST
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    function testCheckMerkleProofIsNotValid() public {
        bytes32 proofOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c08a;
        bytes32 proofTwo = 0xa5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = proofOne;
        proof[1] = proofTwo;

        bytes32 message = merkleAirdrop.getMessage(user, AMOUNT_TO_CLAIM);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivateKey, message);

        vm.startPrank(gasPayer);
        vm.expectRevert(MerkleAirdrop.MerkleAidrop__InvalidProof.selector);
        merkleAirdrop.claim(user, AMOUNT_TO_CLAIM, proof, v, r, s);
        vm.stopPrank();
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                            EMIT EVENT TEST
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    function testEmitWithCorrectArgs() public {
        vm.expectEmit(true, true, false, false, address(merkleAirdrop));
        emit Claimed(user, AMOUNT_TO_CLAIM);

        bytes32 message = merkleAirdrop.getMessage(user, AMOUNT_TO_CLAIM);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivateKey, message);
        vm.prank(gasPayer);
        merkleAirdrop.claim(user, AMOUNT_TO_CLAIM, MERKLE_PROOF, v, r, s);
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                            GETTER FUNCTION TEST
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    function testGetMerkleRoot() public view {
        bytes32 merkleRoot = merkleAirdrop.getMerkleRoot();
        assertEq(merkleRoot, MERKLE_ROOT);
    }

    function testGetIsClaimed() public userClaim {
        bool isClaimed = merkleAirdrop.getIsClaimed(user);
        assertEq(isClaimed, true);
    }
}
