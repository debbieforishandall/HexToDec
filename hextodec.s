# A MIPS Program that prints the corresponding decimal number 
# of an hexadecimal number specified by user input
.data
str: .space 9
error: .asciiz "Invalid hexadecimal number."
buffer: .space 11

.text
main:
addi $s0, $zero, 0    	# Initialize $s0

li $v0, 8 							# Read in hexadecimal number
la $a0, str
li $a1, 9							# of size 36 bits
syscall

la $s1, str
lbu $t2, 0($s1)					# Load character at $s1
addi $t1, $zero, 0			# initialize counter $t1 to zero

sp: addi $t7, $zero, 32			# Store 32 in $t7			
bne $t2, $t7, loop					# If not space branch to loop
addi $s1, $s1, 1
lbu $t2, 0($s1)
j sp

loop: 
add $a0, $zero,  $t2		# Initialize values for function: hex_funct for the ascii range 0 - 9
li $a1, 48
li $a2, 58
add $a3, $a1, $zero
jal hex_funct
addi $t4, $zero, 1			# Set temporary variable to 1
sub $t3, $zero, $t4			# Set temporary variable to -1
bne $v0, $t3, valid			# Check whether $v0 is not equal to -1

add $a0, $zero,  $t2		# Initialize values for function: hex_funct for the ascii range A - F
li $a1, 65
li $a2, 71
addi $t4, $zero, 10			# Set temporary variable to 10
sub $a3, $a1, $t4
jal hex_funct
addi $t4, $zero, 1			# Set temporary variable to 1
sub $t3, $zero, $t4			# Set temporary variable to -1
bne $v0, $t3, valid			# Check whether $v0 is not equal to -1

add $a0, $zero,  $t2		# Initialize values for function: hex_funct for the ascii range a - f
li $a1, 97
li $a2, 103
addi $t4, $zero, 10			# Set temporary variable to 10
sub $a3, $a1, $t4
jal hex_funct
addi $t4, $zero, 1			# Set temporary variable to 1
sub $t3, $zero, $t4			# Set temporary variable to -1
bne $v0, $t3, valid			# Check whether $v0 is not equal to -1

li $v0, 4								# Print error string, the input character is not a hex value
la $a0, error
syscall
li $v0, 10 							# Exit Program
syscall

valid: add $t0, $v0, $zero
bne $t1,$zero, else
j both
else: sll $s0, $s0, 4
both: add $s0, $s0, $t0

addi $t1, $t1, 1

addi $s1, $s1, 1
lbu $t2, 0($s1)
beq $t2, $zero, finish 				# Exit loop when next character in string is null
addi $t8, $zero, 10
beq $t2, $t8, finish					# Exit loop when next character in string is enter
j loop

finish:

#li $v0, 1								# Print integer value
#add $a0, $s0, $zero			# in $s0
#syscall

la $s3, buffer
addi $t7, $zero, 0
sb $t7, 8($s3)					# Null terminate the buffer string

addi $s3, $s3, 8

stringloop: addi $t6, $zero, 1
sub $s3, $s3, $t6
addi $t6, $zero, 10
divu $s0, $t6					# Divide the decimal in $s0 by 10
mfhi $t7							# Put the remainder in $t7
mflo $s0							# Put the quotient in $s0
addi $t7, $t7, 48 		# Convert decimal in $t7 to ascii
sb $t7, 0($s3)   			# store character at $s3

bne $s0, $zero, stringloop

finalexit: 

li $v0, 4  						# Print string
la $a0, 0($s3)
syscall

li $v0, 10 							# Exit Program
syscall

########################################hex_funct
# Function returns hex value of asci value within an ascii range
#
# Arg registers used: $a0, $a1, $a2, $a3
# Tmp registers used: $t7
#
# Pre: none
# Post: $v0 contains the return value
# Returns: the value of the hex, -1 if not valid
#
# Called by: main
# Calls: none
hex_funct:	
addi $t7, $zero, 1								
sub $v0, $zero, $t7			# Initialize $v0 to -1
l: bne $a0, $a1, ne 		# a0 is the ascii value, a1 is the lower bound of the ascii range to be checked
sub $v0, $a1, $a3				# a3 is the value to be subtracted from the ascii value to get its value in hex
jr $ra
ne: addi $a1, $a1, 1
bne $a1, $a2, nne				# a2 is the upper bound of the ascii range plus 1
jr $ra
nne: j l
