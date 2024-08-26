### Verifying Signatures

Verifying ECDSA signatures involves using the signed message, the signature, and the public key to check if the signature is valid. This process essentially reverses the signing algorithm to ensure the provided `r` coordinate matches the calculated one.

> 👮‍♂️ **BEST PRACTICE** 
> Using `ecrecover` directly can lead to security issues such as signature malleability. This can be mitigated by restricting the value of `s` to one half of the curve. The use of **OpenZeppelin's ECDSA library** is recommended, which provides protection against signature malleability and prevents invalid signatures from returning a zero address.
