## Transaction Type 113 (0x71)
These transactions, based on *EIP712*, create a standard way to handle data hashing and signing, which makes advanced features like account abstraction (more flexible account management) and **paymasters (smart contracts that can pay transaction fees)** possible.

>👀❗IMPORTANT <br> On ZK Sync, smart contracts must be deployed using type 113 transactions.

#### Key details for type 113 transactions include:

+ *Gas per Pub Data*: The highest amount of gas the sender is willing to pay for each byte of pub data, which is the Layer 2 (L2) data sent to Layer 1 (L1).
* *Custom Signature*: This is used when the signer’s account isn’t a regular externally owned account (EOA).
* *Paymaster Params*: Settings for a custom paymaster, which is a smart contract that can cover the transaction fees.
* *Factory Depths*: This includes the **bytecode (the instructions)** of the smart contract being deployed.

## Type 5 (0xFF) Transactions
These are called priority transactions and let users send transactions directly from Layer 1 (L1) to Layer 2 (L2) on ZK Sync.