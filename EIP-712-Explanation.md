# EIP 712
> 👀❗**IMPORTANT** 
> EIP 712 prevents replay attacks by uniquely identifying the transaction.
**EIP-712** is a standard that makes signing and reading structured data easier and more specific in Ethereum. 
Here’s how it works:

- *Data Format for Signing*: When you sign data using **EIP-712**, it looks like this:.
```bash 
0x19 0x01 <domainSeparator> <hashStruct(message)>
```

- Parts of the Data:

    * *0x19*: A prefix that shows this data is for signing.
    * *0x01*: A version number that tells us which version of the standard is being used.
    * *Domain Separator*: Additional information that helps specify the context or domain for the data being signed.
    * *hashStruct(message)*: The hashed version of the structured message you want to sign.

> In simple terms, EIP-712 makes it easier to handle and verify structured messages by defining a clear format for signing them..

## ### EIP 712: Domain Separator

To define the domain separator, we first declare a domain separator struct and its type hash:

```js
struct EIP712Domain {
    string name;
    string version;
    uint256 chainId;
    address verifyingContract;
};

bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
```

The domain separator is obtained by encoding and hashing the `EIP712Domain` struct:

```js
bytes32 domainSeparator = keccak256(
  abi.encode(
    EIP712DOMAIN_TYPEHASH,
    keccak256(bytes(eip712Domain.name)),
    keccak256(bytes(eip712Domain.version)),
    eip712Domain.chainId,
    eip712Domain.verifyingContract
  )
);
```

### EIP 712: Message Hash Struct

First, define the message struct and its type hash:

```js
struct Message {
    uint256 number;
};

bytes32 public constant MESSAGE_TYPEHASH = keccak256("Message(uint256 number)");
```

Then encode and hash them together:

```js
bytes32 hashedMessage = keccak256(abi.encode(MESSAGE_TYPEHASH, Message({ number: message })));
```

### EIP 712: Implementation

Steps for EIP 712 implementation:

1. Define a domain separator struct with essential data.
2. Hash the struct and its type hash to create the domain separator.
3. Create a message type hash and combine it with the message data to generate a hashed message.
4. Combine all elements with a prefix and version byte to form a final digest.
5. Use `ecrecover` with the digest and signature to retrieve the signer's address and verify authenticity.

```js
contract SignatureVerifier {

    function getSignerEIP712(uint256 message, uint8 _v, bytes32 _r, bytes32 _s) public view returns (address) {
        // Prepare data for hashing
        bytes1 prefix = bytes1(0x19);
        bytes1 eip712Version = bytes1(0x01); // EIP-712 is version 1 of EIP-191
        bytes32 hashStructOfDomainSeparator = domainSeparator;

        // Hash the message struct
        bytes32 hashedMessage = keccak256(abi.encode(MESSAGE_TYPEHASH, Message({ number: message })));

        // Combine all elements
        bytes32 digest = keccak256(abi.encodePacked(prefix, eip712Version, hashStructOfDomainSeparator, hashedMessage));
        return ecrecover(digest, _v, _r, _s);
    }
}
```

We can then verify the signer as in the first example, but using `verifySignerEIP712`:

```js
function verifySignerEIP712(
    uint256 message,
    uint8 _v,
    bytes32 _r,
    bytes32 _s,
    address signer
) public view returns (bool) {
    address actualSigner = getSignerEIP712(message, _v, _r, _s);
    require(signer == actualSigner);
    return true;
}
```
### EIP 712: OpenZeppelin

It's recommended to use OpenZeppelin libraries to simplify the process, by using `EIP712::_hashTypedDataV4` function:

* Create the message type hash and hash it with the message data:

  ```js
  bytes32 public constant MESSAGE_TYPEHASH = keccak256("Message(uint256 message)");

  function getMessageHash(uint256 _message) public view returns (bytes32) {
      return _hashTypedDataV4(
          keccak256(
              abi.encode(
                  MESSAGE_TYPEHASH,
                  Message({message: _message})
              )
          )
      );
  }
  ```

* Retrieve the signer with `ECDSA.tryRecover` and compare it to the actual signer:

```js
function getSignerOZ(uint256 digest, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (address) {
    (address signer, /* ECDSA.RecoverError recoverError */, /* bytes32 signatureLength */ ) = ECDSA.tryRecover(digest, _v, _r, _s);
    return signer;
}
```

```js
function verifySignerOZ(
    uint256 message,
    uint8 _v,
    bytes32 _r,
    bytes32 _s,
    address signer
) public pure returns (bool) {
    address actualSigner = getSignerOZ(getMessageHash(message), _v, _r, _s);
    require(actualSigner == signer);
    return true;
}
```

> 👀❗**IMPORTANT** 
> EIP 712 prevents replay attacks by uniquely identifying the transaction.

### Conclusion

**EIP 191** standardizes the format of signed data, while **EIP 712** extends data standardization to structured data and i**ntroduces domain separators to prevent cross-domain replay attacks**.


