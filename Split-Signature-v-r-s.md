In this lesson, we're going to break down a signature into its three parts: **v, r, and s**. We'll start by saving the signature as a variable:

```solidity
bytes private SIGNATURE = hex="0xfbd2270e6f23ff5e9248480c0f4be8a4e9bd77c3ad0b1333cc60b5debc611602a2a06c24085d8d7c038bad84edc1144dc11c";
```
In this **SIGNATURE** variable, the values for **r, s, and v** are combined in the following order:

* **r** is the first *32 bytes* of the signature.
* **s** is the next **32 bytes**.
* **v** is the final **byte**.

To separate these components, we'll create a function called **splitSignature**. This function will first check if the signature is **65 bytes long**. If it is, we'll split the signature into its components. If not, the function will return an error.

```solidity
  function splitSignature(bytes memory sig) public pure returns (uint8 v, bytes32 r, bytes32 s) {
        if (sig.length != 65) {
            revert InteractClaimAirdropScript__InvalidSignatureLength();;
        }
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }
```
>🗒️ NOTE <br> When you're using functions from libraries like OpenZeppelin or other APIs, the signature format usually follows the order v,r,s instead of r,s,v like we used in this lesson.