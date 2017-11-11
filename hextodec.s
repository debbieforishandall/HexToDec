# A MIPS Program that prints the corresponding decimal number 
# of an hexadecimal number specified by user input
.data
str: .space 32
error: .asciiz "Invalid hexadecimal number."

.text
main:
addi $s0, $zero, 0    # Initialize $s0

li $v0, 8 						# Read in hexadecimal number
la $a0, str
li $a1, 32						# of size 32 bits
syscall

li $v0, 4							# Print string in $a0
la $a0, str
syscall

li $v0, 1							# Print integer value
add $a0, $s0, $zero		# in $s0
syscall

li $v0, 10 		# Exit Program
syscall