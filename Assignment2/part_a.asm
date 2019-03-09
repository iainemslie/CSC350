# Constants, strings, to be used in all part of the
# CSC 350 (Spring 2019) A#2 submissions

# These are similar to #define statements in a C program.
# However, the .eqv directions *cannot* include arithmetic.

.eqv  MAX_WORD_LEN 32
.eqv  MAX_WORD_LEN_SHIFT 5
.eqv  MAX_NUM_WORDS 100
.eqv  WORD_ARRAY_SIZE 3200  # MAX_WORD_LEN * MAX_NUM_WORDS
.eqv NEW_LINE_ASCII 10


# Global data

.data
WORD_ARRAY: 	.space WORD_ARRAY_SIZE
NUM_WORDS: 	.space 4
MESSAGE1:	.asciiz "Number of words in string array: "
MESSAGE2:	.asciiz "Contents of string arrayr:\n"
MESSAGE3:	.asciiz "Enter strings (blank string indicates end):\n"
SPACE:		.asciiz " "
NEW_LINE:	.asciiz "\n"
EMPTY_LINE:	.asciiz ""

# For strcmp testing...
MESSAGE_A:	.asciiz "Enter first word: "
MESSAGE_B:	.asciiz "Enter second word: "
BUFFER_A:	.space MAX_WORD_LEN
BUFFER_B:	.space MAX_WORD_LEN


#
# Driver code.
#

.text

START:	
	# Read in the first word...
	la $a0, MESSAGE_A
	li $v0, 4
	syscall
	la $a0, BUFFER_A
	li $a1, MAX_WORD_LEN
	li $v0, 8
	syscall
	
	# Read in the second word...
	la $a0, MESSAGE_B
	li $v0, 4
	syscall
	la $a0, BUFFER_B
	li $a1, MAX_WORD_LEN
	li $v0, 8
	syscall
	
	la $a0, BUFFER_A
	la $a1, BUFFER_B
	jal FUNCTION_STRCMP
	
	add $a0, $zero, $v0
	li $v0, 1
	syscall
	
EXIT:
	li $v0, 10
	syscall

##########################################################
#
# YOUR SOLUTION MAY NOT ADD MORE GLOBAL DATA OR CONSTANTS.
# ALL OF THE CODE FOR YOUR FUNCTION(S) MUST APPEAR AFTER
# THIS POINT. SUBMISSIONS THAT IGNORE THIS REQUIREMENT
# MAY NOT BE ACCEPTED FOR EVALUATION.
#
##########################################################

#
# Solution for FUNCTION_STRCMP must appear below.
#
# $a0 contains the address of the first string
# $a1 contains the address of the second string
# $v0 will contain the result of the function.
#

FUNCTION_STRCMP:
	addi $sp, $sp, -20 	# Increase the stack size
	sw $t0, 16($sp)		# push $t0
	sw $t1, 12($sp)		# push $t1
	sw $t2, 8($sp)		# push $t2
	sw $t3, 4($sp)		# push $t3
	sw $t4, 0($sp)		# push $t4

	add $t0, $a0, $zero	#Store the address of the first word in $t0
	add $t1, $a1, $zero	#Store the address of the second word in $t1
	
loop:
	lbu $t2, 0($t0)		#Load the "i'th" byte of first word into $t2
	lbu $t3, 0($t1)		#Load the "i'th" byte of second word into $t3
	
	addi $t0, $t0, 1	#Add 1 to the address stored in $t0
	addi $t1, $t1, 1	#Add 1 to the address stored in $t1
	
	beq $t2, $zero, null_reached	#Exit the loop if null character
	beq $t3, $zero, null_reached	#Exit the loop if null character
	beq $t2, $t3, loop	#Repeat loop if chars match

null_reached:
	sub $t4, $t2, $t3	#Store the difference of word1 - word 2 in $t4
	
	blt $t4, $zero, set_minus_one
	bgt $t4, $zero, set_positive_one
	beq $t4, $zero, set_zero
	
set_minus_one:
	lw $t4, 0($sp)		# pop $t4
	lw $t3, 4($sp)		# pop $t3
	lw $t2, 8($sp)		# pop $t2
	lw $t1, 4($sp)		# pop $t1
	lw $t0, 0($sp)		# pop $t0
	addi $sp, $sp, 20	# Restore the stack
	addi $v0, $zero, -1	# Function return value
	jr $ra
set_positive_one:
	lw $t4, 0($sp)		# pop $t4
	lw $t3, 4($sp)		# pop $t3
	lw $t2, 8($sp)		# pop $t2
	lw $t1, 4($sp)		# pop $t1
	lw $t0, 0($sp)		# pop $t0
	addi $sp, $sp, 20	# Restore the stack
	addi $v0, $zero, 1	# Function return value
	jr $ra
set_zero:
	lw $t4, 0($sp)		# pop $t4
	lw $t3, 4($sp)		# pop $t3
	lw $t2, 8($sp)		# pop $t2
	lw $t1, 4($sp)		# pop $t1
	lw $t0, 0($sp)		# pop $t0
	addi $sp, $sp, 20	# Restore the stack
	addi $v0, $zero, 0	# Function return value				
   	jr $ra	
