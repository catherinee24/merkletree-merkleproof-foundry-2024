# EIP 191
**EIP 191** helps with *pre-signed messages* or *sponsored transactions*. 

- This means:
* **Pre-signed Messages**: For example, Bob can sign a message in advance.
* **Sponsored Transactions**: Alice can then use Bob's signed message to send a transaction and cover Bob’s gas fees..

> In short, EIP 191 allows one person to sign something 🖊️ and another person to handle the transaction and pay the costs.

#### EIP 191 Signed Data Format

- This standard defines how signed messages are formatted:

```bash
0x19 <1 byte version> <version specific data> <data to sign>
```
* **0x19 Prefix**: This shows that the data is meant for signing.
* **1-byte Version**: This tells us what kind of data is being signed.
* **0x00**: For data that has a specific validator.
* **0x01**: For structured data, often used in apps and related to *EIP 712*.
* **0x45**: For personal signed messages.
* **Version Specific Data**: For version *0x01*, this is the address of the validator.
* **Data to Sign**: This is the actual message that needs to be signed.

> In short, EIP 191 standardizes how we format signed messages, helping to identify and process them correctly.

### Setting Up EIP 191

To set up *EIP 191*, follow these steps to **encode, hash, and retrieve** the signer from a message:

* **Prepare Data**: Gather the data you need for hashing:
    - *Prefix*: **0x19** to show that the data is for a signature.
    - *Version*: *0x00* to define the data version.
    - *Validator Address*: The address of the contract or the intended validator.
    - *Message Data*: The actual message you want to sign, converted to a **bytes32** format.
    - *Create the Standardized Message*: Combine all these parts and hash them using **keccak256** to get a unique hash of the message.
    - *Recover the Signer*: Use the **ecrecover** function with the hash and the signature components **(_v, _r, _s)** to find out who signed the message.

**Here’s a simple example of how this is done in code**:
```javascript
function getSigner191(uint256 message, uint8 _v, bytes32 _r, bytes32 _s) public view returns (address) {
    // Prepare data for hashing
    bytes1 prefix = bytes1(0x19);
    bytes1 eip191Version = bytes1(0);
    address intendedValidatorAddress = address(this);
    bytes32 applicationSpecificData = bytes32(message);

    // Standardized message format
    bytes32 hashedMessage = keccak256(abi.encodePacked(prefix, eip191Version, intendedValidatorAddress, applicationSpecificData));

    address signer = ecrecover(hashedMessage, _v, _r, _s);
    return signer;
}
```
**Summary**
* Combine the *prefix, version, validator address, and message* into a standardized format.
* *Hash* this combined data.
* Use the *ecrecover* function to find out the address of the person who signed the message.
> This process helps in verifying that the message was signed by the expected person.