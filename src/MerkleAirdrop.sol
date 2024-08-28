//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { IERC20, SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import { EIP712 } from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

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
contract MerkleAirdrop is EIP712 {
    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    ERRORS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    error MerkleAidrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();
    error MerkleAirdrop__InvalidSignature();

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

    bytes32 private constant MESSAGE_TYPEHASH = keccak256("AirdropClaim(address claimerAccount, uint256 amountToClaim)");

    mapping(address claimer => bool claimed) private s_airdropClaimed;

    struct AirdropClaim {
        address claimerAccount;
        uint256 amountToClaim;
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                    EVENTS 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    event Claimed(address indexed claimerAccount, uint256 amountToClaim);

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                CONSTRUCTOR 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    constructor(bytes32 merkleRoot, IERC20 airdropToken) EIP712("MerkleAirdrop", "1") {
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                        EXTERNAL & PUBLIC FUNCTIONS 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/

    /// @notice Claims airdrop tokens for a given account.
    /// @param claimerAccount The account that is claiming the airdrop tokens.
    /// @param amountToClaim The amount of tokens to claim.
    /// @param merkleProof The Merkle proof that verifies the claimer's eligibility.
    /// @param v The v component of the signature.
    /// @param r The r component of the signature.
    /// @param s The s component of the signature.
    /// @dev Reverts if the claimer has already claimed tokens or if the signature is invalid.
    /// @dev Reverts if the Merkle proof is invalid.
    /// @dev Transfers the claimed tokens to the claimer's account and emits a Claimed event.
    function claim(
        address claimerAccount,
        uint256 amountToClaim,
        bytes32[] calldata merkleProof,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        external
    {
        if (s_airdropClaimed[claimerAccount]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }

        if (!_isValidSignature(claimerAccount, getMessage(claimerAccount, amountToClaim), v, r, s)) {
            revert MerkleAirdrop__InvalidSignature();
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
                                        INTERNAL & PRIVATE FUNCTIONS 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/

    function _isValidSignature(
        address claimerAccount,
        bytes32 digest,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        internal
        pure
        returns (bool)
    {
        (address actualSigner,,) = ECDSA.tryRecover(digest, v, r, s);
        return actualSigner == claimerAccount;
    }

    /*/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                     PUBLIC & EXTERNAL VIEW PURE FUNCTIONS
    /////////////////////////////////////////////////////////////////////////////////////////////////////////*/
    function getMessage(address claimerAccount, uint256 amountToClaim) public view returns (bytes32) {
        return _hashTypedDataV4(
            keccak256(
                abi.encode(
                    MESSAGE_TYPEHASH, AirdropClaim({ claimerAccount: claimerAccount, amountToClaim: amountToClaim })
                )
            )
        );
    }

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
