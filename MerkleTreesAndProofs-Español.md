#  Merkle Trees y Merkle Proofs 
Son conceptos relacionados que permiten gestionar y verificar grandes conjuntos de datos de manera eficiente.

## Merkle Trees
Un ``Merkle Tree`` es una estructura de datos en forma de árbol binario que se utiliza para resumir y verificar grandes conjuntos de datos. Cada nodo del árbol representa un conjunto de datos y contiene un resumen ``(o "hash")`` de los datos que se encuentran en ese nodo.

- Aquí hay una representación simplificada de un ``Merkle Tree``:
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
Cada nodo del árbol tiene un identificador único y un resumen (hash) de los datos que se encuentran en ese nodo. El resumen se calcula mediante una función de hash que toma como entrada los datos del nodo.

# Merkle Proofs

Un ``Merkle Proof`` es una prueba que demuestra que un dato específico se encuentra en un conjunto de datos resumido por un ``Merkle Tree``. La prueba consiste en una secuencia de nodos del árbol que conectan el nodo raíz con el nodo que contiene el dato específico.

- Aquí hay un ejemplo de cómo se podría construir un ``Merkle Proof`` para demostrar que el dato ``"Dato2"`` se encuentra en el conjunto de datos:

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

La prueba consiste en la secuencia de nodos que conectan el nodo raíz con el nodo que contiene el dato ``"Dato2"``. La prueba se puede verificar calculando el resumen (hash) de cada nodo y comparándolo con el resumen almacenado en el nodo anterior.
