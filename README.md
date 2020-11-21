# Tower of Hanoi
This is a script is made in assembler for ARMv7 32-bit architectures in order to solve the mathematical puzzle "Tower of Hanoi" depending on the input r0 (register 0) which represent how many disks are in the first origin tower and then moved step by step to the destination tower, saving each movement in the memory of the computer

# Input R0
The maximum input is limited to 8 disks, as it's simulated in a 32-bit ARM CPU, so the user can change the third line  of the original code as follows
```
mov r0, #8
```

The code can be tested in an ARM CPU simulator like [cpulator](https://cpulator.01xz.net/?sys=arm)

## Authors
Sebastián Valdivia

Diego Herrera

Víctor Díaz
