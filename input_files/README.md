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

##### Attention
For a byte-addressible memory with 256 words, the stack pointer register should be initialized to 'b1111100000'. As expected, the stack will grow downwards in memory positions, so the stack pointer should start at the end of the memory. How can that be done? See below:

* Option 1: modify the zero riscy code to start the stack pointer to the desired position after reset. Add an if statement to the second index in the initialization loop.
```verilog
    always_ff @(posedge clk, negedge rst_n)
    begin : register_write_behavioral
        if (i == 2) begin
            rf_reg_tmp[i] <= 'b1111100000;
    (...)
```
* Option 2: prepend a assembly instruction in your compiled code, that initializes the stack pointer to the desired position
```asm
    li sp, 992
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

# main.bin
The main.bin calculates the sum 100 + 23
it was compiled from the following code 
```c
void main(){
        int a = 100;
        int b = 23;
        int c = a + b;
        return;
}
```

```asm
Disassembly of section .data:

00000000 <.data>:
   0:   130101fe                addi    x2,x2,-32
   4:   232e8100                sw      x8,28(x2)
   8:   13040102                addi    x8,x2,32
   c:   93074006                addi    x15,x0,100
  10:   2326f4fe                sw      x15,-20(x8)
  14:   93077001                addi    x15,x0,23
  18:   2324f4fe                sw      x15,-24(x8)
  1c:   0327c4fe                lw      x14,-20(x8)
  20:   832784fe                lw      x15,-24(x8)
  24:   b307f700                add     x15,x14,x15
  28:   2322f4fe                sw      x15,-28(x8)
  2c:   13000000                addi    x0,x0,0
  30:   0324c101                lw      x8,28(x2)
  34:   13010102                addi    x2,x2,32
  38:   67800000                jalr    x0,0(x1)
```

