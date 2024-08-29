# Introduction
In this lesson, we're going to create a signature for a default Anvil address. This signature will allow someone else to claim tokens on behalf of that address.

* First, make sure you have a local Anvil node running. You can do this by typing **anvil** in your terminal. Also, use the **foundryup command** to get the basic version of Foundry.

* Next, copy the **Makefile** content for this course. Then, run the **make deploy** command. This will deploy both the **CookieToken** and **MerkleAirdrop** contracts.

### MessageHash
To get the data we need for signing, use the **getMessage** function on the **MerkleAirdrop** contract. You’ll need to provide an account address, a uint256 amount, and the **Anvil** node **URL (http://localhost:8545)**.

```bash
cast call 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "getMessageHash(address,uint256)" 0xf39Fd6e51aad88F6f4ce6aB88272ffFb92266 25000000000000000000 --rpc-url http://localhost:8545
0x184e30c4b19f5e304a893524210d50346dad61c461e79155b910e73fd856dc72
```
* **DIGEST** (AKA message hash) = **0x184e30c4b19f5e304a893524210d50346dad61c461e79155b910e73fd856dc72**

### Signing
Now that we have the data, we can sign it using the **cast wallet sign** command. Add the **--no-hash** flag to make sure the message isn’t rehashed, since it’s already in the correct format. Also, use the **--private-key** flag with the first **Anvil private key**.

> 👮‍♂️ Best Practice <br> When working on a testnet or with a real account, it’s safer to not use the private key directly. Instead, use the --account flag and your keystore account to sign.

```bash
cast wallet sign --no-hash 0x184e30c4b19f5e304a893524210d50346dad61c461e79155b910e73fd856dc72 --private-key 0xac093f74bec39a17e36ba4a6b4d238ff944bacb478cbeb5efcae784d7bf4f2ff80
0xfbd2270e6f23ff5e9248480c0f4be8a4e9bd77c3ad0b1333cc60b5debc611602a2a06c24085d8d7c038bad84edc1144dc11c
```
* **SIGNATURE HASH** = **0xfbd2270e6f23ff5e9248480c0f4be8a4e9bd77c3ad0b1333cc60b5debc611602a2a06c24085d8d7c038bad84edc1144dc11c**

Great job! We've just created a signature, which we will break down into its parts **(v, r, and s)** in the next lesson.






