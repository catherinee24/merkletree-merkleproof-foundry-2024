# EIP 4844 Blob Transactions
**Introduction**
In a regular Ethereum transaction, data is saved and stays on the blockchain forever. Blob transactions (type 3) are different because they allow data to be stored temporarily, for a period between 20 to 90 days, before being deleted.

### EIP-4844
This type of transaction comes from **EIP4844**, also known as *"Proto-DankSharding,"* introduced in the Dankun upgrade in March 2024. It aims to reduce Ethereum's high transaction fees.

Roll-ups are methods used to make Ethereum work faster by handling multiple transactions on separate chains, bundling them together, and then sending these bundles back to Ethereum. Before this upgrade, all the bundled transaction data had to be kept permanently on Ethereum, which was both expensive and inefficient. With **EIP4844**, this data can now be stored temporarily just for validation purposes, avoiding long-term storage.

### Blobs and Transactions
Blobs are pieces of temporary data that are attached to a transaction. This data is validated and then deleted after a while. For example, ZK Sync uses blobs to send its batch of compressed transactions to Ethereum.

You can see how blobs work by checking [this transaction](https://etherscan.io/tx/0x291351476ef62e83ed33fb385f998232b8577bd1af60eb3463ce5a9e77fc8666) on Etherscan. It includes two [Blobs](https://etherscan.io/tx/0x291351476ef62e83ed33fb385f998232b8577bd1af60eb3463ce5a9e77fc8666#blobs). Clicking on one of these blobs will show its large data, which was not stored permanently on the blockchain.

### Validation
To validate blobs, Ethereum uses a few specific processes and tools:

* **Transaction Submission**: A transaction is submitted with both the blob data and cryptographic proof.
* **Hash Generation**: The blob itself is not directly accessed by the on-chain contract. Instead, the contract uses the *BLOBHASH* opcode to create a hash of the blob.
* **Proof Verification**: The generated blob hash and the proof data are then checked using a special function called the point evaluation opcode. This process ensures the transaction batch is correct without needing to store the blob data on-chain.

>✨ Blobs are large pieces of temporary data attached to transactions, used by roll-ups like ZK Sync to bundle and send compressed transactions to Ethereum.
>✨ In essence <br> This method allows the network to validate data efficiently while keeping storage requirements minimal.

### Resources

* [What is EIP-4844?](https://www.cyfrin.io/blog/what-is-eip-4844-proto-danksharding-and-blob-transactions)
* [send\_blob](https://github.com/PatrickAlphaC/send_blob) GitHub repository
