//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { IERC20, SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

/**
 * @title MerkleAirdrop
 * @author Catellatech
 * Original Work by:
 * @author Ciara Nightingale
 * @author Cyfrin
 * @notice this contract implements an ERC20 token airdrop using a Merkle tree data structure to verify the validity of
 * claims.
 * @dev The claim function is the main function of the contract and is used to claim tokens and verify the validity of
 * the claim.
 */
contract MerkleAirdrop {
    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    ERRORS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    error MerkleAidrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    TYPES
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    using SafeERC20 for IERC20;

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                STATE VARIABLES 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    address[] private s_claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;

    mapping(address claimer => bool claimed) private s_airdropClaimed;

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    EVENTS 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    event Claimed(address indexed claimerAccount, uint256 amountToClaim);

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                CONSTRUCTOR 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    constructor(bytes32 merkleRoot, IERC20 airdropToken) {
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                        EXTERNAL & PUBLIC FUNCTIONS 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/

    /// @notice Allows a user to claim a specific amount of tokens from an airdrop
    /// @notice Follows: CEI pattern
    /// @dev The function checks that the user has not claimed before and that the Merkle proof is valid
    /// @param claimerAccount The address of the user claiming the tokens
    /// @param amountToClaim The amount of tokens to claim
    /// @param merkleProof The Merkle proof that verifies the user's membership in the airdrop list
    function claim(address claimerAccount, uint256 amountToClaim, bytes32[] calldata merkleProof) external {
        if (s_airdropClaimed[claimerAccount]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }

        //leaf: Hash of (claimerAccount, amountToClaim) hashed twice to prevent preimage attack hash collision
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(claimerAccount, amountToClaim))));

        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAidrop__InvalidProof();
        }
        s_airdropClaimed[claimerAccount] = true;
        emit Claimed(claimerAccount, amountToClaim);
        i_airdropToken.safeTransfer(claimerAccount, amountToClaim);
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                     PUBLIC & EXTERNAL VIEW PURE FUNCTIONS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    function getClaimer() external view returns (address[] memory) {
        return s_claimers;
    }

    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getAirdropToken() external view returns (IERC20) {
        return i_airdropToken;
    }

    function getIsClaimed(address claimerAccount) external view returns (bool) {
        return s_airdropClaimed[claimerAccount];
    }
}
