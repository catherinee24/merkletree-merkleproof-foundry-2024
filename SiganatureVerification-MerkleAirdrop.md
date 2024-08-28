# Verifying Signatures in the Merkle Airdrop Contract
- **Step 1**: Passing Signature Components to the *claim* Function
We start by passing the *v, r, and s* components of the signature to the claim function:
```solidity
function claim(
    address claimerAccount,
    uint256 amountToClaim,
    bytes32[] calldata merkleProof,
    uint8 v,
    bytes32 r,
    bytes32 s
)
    external
{}
```
- **Step 2**: Checking if the Signature is Valid
Next, we need to verify whether the signature is valid:
```solidity
if (!signature is invalid) {
    revert MerkleAirdrop__InvalidSignature();
}
```
- **Step 3**: Implementing the *_isValidSignature* Function
To validate the signature, we'll create a *_isValidSignature* function. This function will take:
  * the account 
  * message digest 
  * and the v, r, and s signature components as arguments. 
The function will be public and pure since it doesn't modify or read any blockchain data. It will return a boolean indicating whether the signature is valid.

We'll use the *ECDSA.tryRecover* function from OpenZeppelin's library to implement this:
```solidity
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
```
- **Step 4**: Creating the Message Digest
The message that needs to be signed is a digest, which is essentially the data you get after hashing some information. It acts as a unique fingerprint for that data.

We'll create this digest using a *getMessage* function, which takes:
  * the claiming account 
  * and the amount to claim as arguments. 

We'll use a *struct -> AirdropClaim* for these arguments to keep things clear and organized:
```solidity
function getMessage(address claimerAccount, uint256 amountToClaim) public view returns (bytes32) {
    return _hashTypedDataV4(
        keccak256(
            abi.encode(
                MESSAGE_TYPEHASH,
                AirdropClaim({ claimerAccount: claimerAccount, amountToClaim: amountToClaim })
            )
        )
    );
}
```
- **Step 5:** Using the *EIP712* Library
The *_hashTypedDataV4()* function is from *OpenZeppelin's EIP712 library*, which we need to import and inherit in our contract:
```solidity
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract MerkleAirdrop is EIP712 {
    constructor(bytes32 merkleRoot, IERC20 airdropToken) EIP712("MerkleAirdrop", "1") {}
}

```
- **Step 6**: Defining the *AirdropClaim Struct* and *MESSAGE_TYPEHASH*
We'll define a struct to represent the claim details:
```solidity
struct AirdropClaim {
    address claimerAccount;
    uint256 amountToClaim;
}
```
We'll also define the *MESSAGE_TYPEHASH*, which is the hashed version of our struct using *keccak256*:
```solidity
bytes32 private constant MESSAGE_TYPEHASH = keccak256("AirdropClaim(address claimerAccount, uint256 amountToClaim)");
```

#### Wrapping Up
In the *Merkle Airdrop contract*, we check if a *signature is valid* when someone tries to claim their airdrop. First, the signature parts *(v, r, s)* are passed to the **claim** function. Then, we verify the signature with the *_isValidSignature* function, which compares the signer’s account with the account actually claiming the tokens. This is done using the *ECDSA.TryRecover* function from the *OpenZeppelin library*.

To create the message that needs to be signed, we generate a *"digest" (a unique hash of the message)* using the *getMessage* function. This function takes the claiming account and the amount to be claimed and uses the *EIP712 library from OpenZeppelin*, which we imported and included in our contract.

Finally, we define a *struct* called *AirdropClaim* to organize the claim details, and we create a constant *MESSAGE_TYPEHASH* to store the hashed type of the message, which is the *AirdropClaim struct hashed with keccak256*.