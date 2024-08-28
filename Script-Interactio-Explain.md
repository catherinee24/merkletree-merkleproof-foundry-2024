# Introduction
In this lesson, we will create a **script** to handle the process of **signing** and **claiming** an airdrop. The idea is to sign a message using an account that is already included in the Merkle tree. This signature will then let someone else claim the airdrop on behalf of the original account.

### Setup
To start, go to the /script folder and create a file named **Interact.s.sol**. We will use some **DevOps** tools from **Cyfrin foundry-devops**, which are already installed, to get the most recently deployed airdrop contract.

### Here’s the basic setup:

```solidity
import { Script, console } from "forge-std/Script.sol";
import { DevOpsTools } from "foundry-devops/src/DevOpsTools.sol";
import { MerkleAirdrop } from "../src/MerkleAirdrop.sol";

contract ClaimAirdrop is Script {

    function run() external {
    }
}
```
In the **run** function, we will find the most recently deployed **MerkleAirdrop** contract and pass its address to another function called **claimAirdrop**:

```solidity
function run() external {
    address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid);
    claimAirdrop(mostRecentlyDeployed);
}
```
### claimAirdrop
The **claimAirdrop** function will use the address of the deployed **MerkleAirdrop** contract.

* First, we need to start broadcasting the transaction to the blockchain using **vm.startBroadcast** and end it with **vm.stopBroadcast**.

* Then, we call the **MerkleAirdrop::claim** function, providing these required parameters:

* *CLAIMING_ADDRESS*: This is the address that will claim the airdrop. It must be in the Merkle Tree, as defined in the **input.json file**. You can regenerate this file by running the GenerateInput script.
* *AMOUNT_TO_COLLECT*: This amount is set to **25 * 1e18.**
* *proof*: An array of bytes found in the **output.json** file.
* *v, r, s*: These are the parts of the signature. You can get them by:
    *Using vm.sign(userPrivateKey, digest)*.
    *Using cast wallet sign*.

Here’s how the function looks:

```solidity
function claimAirdrop(address airdrop) public {
    vm.startBroadcast();
    // v, r, s are retrieved in the following lesson
    MerkleAirdrop(airdrop).claim(CLAIMING_ADDRESS, AMOUNT_TO_COLLECT, proof, v, r, s);
    vm.stopBroadcast();
}
```
