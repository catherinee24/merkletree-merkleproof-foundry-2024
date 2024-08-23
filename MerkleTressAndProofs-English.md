# Merkle Trees and Merkle Proofs
These are concepts that help manage and verify large sets of data efficiently.

## Merkle Trees
A ``Merkle Tree`` is a data structure that looks like a binary tree and is used to summarize and verify large amounts of data. Each node in the tree represents a set of data and contains a summary (or "hash") of the data in that node.

- Here’s a simplified representation of a Merkle Tree:
```mermaid
graph TD;
    Root[Root] --> NodoA[Nodo A]
    Root --> NodoB[Nodo B]
    NodoA --> Dato1[Dato1]
    NodoA --> Dato2[Dato2]
    NodoB --> Dato3[Dato3]
    NodoB --> Dato4[Dato4]

    style Root fill:#ffcc00,stroke:#333,stroke-width:2px
    style NodoA fill:#66ccff,stroke:#333,stroke-width:2px
    style NodoB fill:#66ccff,stroke:#333,stroke-width:2px
    style Dato1 fill:#ff6666,stroke:#333,stroke-width:2px
    style Dato2 fill:#ff6666,stroke:#333,stroke-width:2px
    style Dato3 fill:#ff6666,stroke:#333,stroke-width:2px
    style Dato4 fill:#ff6666,stroke:#333,stroke-width:2px
```
Each node in the tree has a unique identifier and a summary (or "hash") of the data in that node. The summary is created using a hash function, which takes the data from the node as input.

## Merkle Proofs
A ``Merkle Proof`` is a way to show that a specific piece of data is part of a larger set of data summarized by a M``erkle Tree``. The proof involves a sequence of nodes from the tree that connects the root node to the node containing the specific data.

- Here’s an example of how a ``Merkle Proof`` might be constructed to show that the data ``"Dato2"`` is in the set:

```mermaid
graph TD;
    style Root fill:#ffcc00,stroke:#333,stroke-width:2px,stroke-dasharray: 5 5
    style NodoA fill:#66ccff,stroke:#333,stroke-width:2px
    style NodoB fill:#66ccff,stroke:#333,stroke-width:2px
    style Dato1 fill:#ff6666,stroke:#333,stroke-width:2px
    style Dato2 fill:#ff6666,stroke:#333,stroke-width:2px
    style Dato3 fill:#ff6666,stroke:#333,stroke-width:2px
    style Dato4 fill:#ff6666,stroke:#333,stroke-width:2px

    Root[Root]
    Root --> NodoA[Nodo A - H_A]
    Root --> NodoB[Nodo B - H_B]
    NodoA --> Dato1[Dato1]
    NodoA --> Dato2[Dato2 - H_Dato2]
    NodoB --> Dato3[Dato3]
    NodoB --> Dato4[Dato4]

    %% Highlighting the Merkle Proof nodes
    classDef proofNode fill:#ffcc00,stroke:#000,stroke-width:2px;
    class NodoA,NodoB,Dato2 proofNode;
```
The proof consists of the sequence of nodes that connect the root node to the node containing the data ``"Dato2"``. You can verify the proof by calculating the summary (hash) of each node and comparing it with the summary stored in the previous node.