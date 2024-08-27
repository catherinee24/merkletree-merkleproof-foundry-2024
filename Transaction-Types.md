
# Introduction
In this lesson, we’ll go over the four main types of transactions that are used in both Ethereum and ZK Sync. After that, we’ll look at the types of transactions that are unique to the ZK Sync chain.

#### Type 0 (Legacy Transactions)
This is the oldest type of transaction, and you use it when you include the ``--legacy`` flag. It was the original standard for Ethereum transactions before newer types were introduced.

#### Type 1 (0x01)
This transaction type was introduced to fix issues that could break contracts due to changes made by ``EIP2929`` and ``EIP2930``, which changed how gas costs work and added access lists.
* *Access List*: This type includes an access list field, which is an array of addresses and storage keys. By listing these in advance, you can save gas when calling other contracts.

#### Type 2 (0x02)
This type was introduced by *EIP1559* during Ethereum's London upgrade to help lower the network's high fees.

* *Base Fee*: Instead of using a fixed gas price, this type uses a base fee that changes with each block.

* *Max Priority Fee per Gas*: This is the maximum extra fee you're willing to pay to get your transaction processed faster.

* *Max Fee per Gas*: This is the total maximum fee you're willing to pay for your transaction.

> 🗒️ NOTE <br> ZK Sync supports Type 2 transactions, but it doesn't use the max fee settings because gas works differently on ZK Sync.

#### Transaction Type 3 (0x03)

This transaction type is new and was introduced by Ethereum Improvement Proposal (*EIP4844*). It provides an initial scaling solution for rollups.

* *Maximum Blob Fee per Gas*: This parameter sets the maximum fee the sender is willing to pay per gas unit specifically for blob gas.

- **What is a blob**?

A blob is a type of large data that is used in Ethereum to handle additional information, such as rollup data. Blob gas is distinct from regular gas and has its own market.

* *Versioned Blob Hashes*: This is a list of hashes (unique codes) that are used to verify the integrity of the blobs and ensure they are correctly linked to the transaction.

- **What happens to the blob fee?**

The blob fee is deducted and burned from the sender's account before the transaction executes. This means that if the transaction fails, the blob fee is not refunded.

> ✨ In summary <br> This transaction type is new and helps to scale the Ethereum network. It uses a special type of gas called "blob gas" to handle large amounts of data, and the blob fee is deducted and burned from the sender's account before the transaction executes.