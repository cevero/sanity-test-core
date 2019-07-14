## Test programs
Each file is a binary program that contains the machine code to the riscv32i instruction set. 

##### Useful commands
* Compile a c program with no reference to standar lib or linkage to default objects. Pure bare metal
    ```shell
    riscv32-unknown-elf-gcc -ffreestanding -nostartfiles -nostdlib -nodefaultlibs main.c -march=rv32i -o main32.elf 
    ```
* The compiler generates an elf file. Use the following command to extract the riscv machine code into a binary file.
    ```shell
    riscv32-unknown-elf-objcopy input.elf -O binary output.bin
    ```
* If necessary, convert endianess with the following command 
    ```shell
    xxd -e -g4 input.bin | xxd -r > output.bin
    ```
* Generate disassembly output with
    ```shell
    riscv32-unknown-elf-objdump -D -b binary -m riscv:rv32 -M numeric,no-aliases input.bin
    ```

# fibonacci.bin 
The fibonacci.bin calculates the fibonacci sequency.
The fibonacci_xxd.bin is the exact same program but with the opposed endianess

```asm
Disassembly of section .data:

00000000 <.data>:
   0:	9305a000          	addi	x11,x0,10
   4:	130e3000          	addi	x28,x0,3
   8:	93020000          	addi	x5,x0,0
   c:	13031000          	addi	x6,x0,1
  10:	93030000          	addi	x7,x0,0
  14:	338f0500          	add	x30,x11,x0
  18:	b3035300          	add	x7,x6,x5
  1c:	b3020300          	add	x5,x6,x0
  20:	33830300          	add	x6,x7,x0
  24:	130fffff          	addi	x30,x30,-1
  28:	e3180ffe          	bne	x30,x0,0x18
  2c:	33850300          	add	x10,x7,x0
  30:	2322a000          	sw	x10,4(x0) # 0x4
  34:	13031000          	addi	x6,x0,1
  38:	23206000          	sw	x6,0(x0) # 0x0

```
