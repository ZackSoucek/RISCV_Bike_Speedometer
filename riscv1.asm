main: li a3 0x110C0000 # SSEG
li a2 966853 # for mpg calculation
li s1 999999 # max before time reset
li s5 0
la t1 ISR
csrw t1 mtvec
li s2 1
csrw s2 mie
li a1 0
#sw a1 0(a3)

loop: addi a1 a1 1
sw a1 0(a3)
bge a1 s1 wipe
j loop
wipe: li a1 0
j loop

ISR: csrw zero mie
beqz s5 ISR_MAIN
li s5 0
li a1 0
li s2 1
csrw s2 mie
j loop

ISR_MAIN: 
jal div
sw a0 0(a3)
li s5 1
li s2 1
csrw s2 mie
ISR_LOOP: nop
j ISR_LOOP

# a0 = a2 / a1
div:
li a0 0
mv s3 a2
beqz a1 endDiv
divLoop: blt s3 a1 endDiv
sub s3 s3 a1
addi a0 a0 1
j divLoop
endDiv: jalr ra

