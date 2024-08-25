# Introduction

In this lesson, we will learn about two important Ethereum signature standards: *EIP 191* and *EIP 712*. These standards help us **understand and verify digital signatures** better.

Before these standards, when you signed transactions in Metamask, the messages were hard to read, making it tricky to check what the transaction was about. **EIP 191** and **EIP 712** make these messages clearer and **protect against replay attacks**, which are when someone tries to reuse a signature or transaction in a harmful way.

#### So, we’ll cover:

* *How to sign and check signatures.*
* *How these standards make data easier to read and more secure*.

## Simple Signature Verification
We’ll start with a basic contract that checks if a signature is valid. Here’s how it works:

* **Retrieve Signer Address**: The contract uses a function called *ecrecover* to find out who signed the message.

* **Verify Signature**: It then checks if the signer matches the expected address. If it does, the signature is considered valid.

```javascript
function getSignerSimple(uint256 message, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (address) {
    bytes32 hashedMessage = bytes32(message); // If string, use keccak256(abi.encodePacked(string))
    address signer = ecrecover(hashedMessage, _v, _r, _s);
    return signer;
}
```
**📝NOTE**: > `ecrecover` is a function built into the Ethereum protocol.

```javascript
function verifySignerSimple(
    uint256 message,
    uint8 _v,
    bytes32 _r,
    bytes32 _s,
    address signer
) public pure returns (bool) {
    address actualSigner = getSignerSimple(message, _v, _r, _s);
    require(signer == actualSigner);
    return true;
}
```
> In short, this contract makes sure that a message was signed by the right person by comparing the actual signer with the one we expect.

