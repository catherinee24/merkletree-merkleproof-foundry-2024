# Public Key Cryptography
Signatures in blockchain help prove who you are. In Ethereum, this is done using pairs of *public and private keys*, which work together to create unique digital signatures for each user. These signatures are a way to confirm that the person sending a transaction is the real owner of the account. This system is called *public key cryptography* and uses **asymmetric encryption**.

- *Private Key*: This is used to sign messages and generate the public key.
- *Public Key*: This is used to verify that the owner really has the private key. 

> It’s nearly impossible to figure out the private key from the public key, making this method very secure.

When you create a new Ethereum account, it automatically generates a pair of cryptographic keys: one public and one private. The public key is then hashed using the keccak256 algorithm, turning it into a fixed-size string of 32 bytes (256 bits). The *Ethereum address comes from the last 20 bytes of this hashed public key*.

> In simpler terms, your private key is your secret password that proves who you are, and your public key is like your username that others can use to confirm it's really you.