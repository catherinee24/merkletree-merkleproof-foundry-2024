Voy a ser muy crack en entender y codear for loops en solidity y para lograrlo voy a practicar todos los dias codear el contrato MakeMerkle.s.sol de  
 * @author Ciara Nightingale
 * @author Cyfrin
https://updraft.cyfrin.io/courses/advanced-foundry/merkle-airdrop/merkle-tree-script?lesson_format=video

$ forge script script/GenerateInput.s.sol:GenerateInput
& forge install cyfrin/foundry-devops --no-commit

Cuando rodamos el Test para clamear salió el siguiente error 
```bash
Reason: ERC20InsufficientBalance(0x2e234DAe75C793f67A35089C9d99245E1C58470b, 0, 25000000000000000000
```
Para solucionarlo hay que mintear tokens en el test 