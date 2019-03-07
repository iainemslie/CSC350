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

	
	# Perform the swap
	la $a0, BUFFER_A
	la $a1, BUFFER_B
	li $a2, MAX_WORD_LEN
	jal FUNCTION_SWAP
	
	# Print string in BUFFER_A, BUFFER_B
	la $a0, BUFFER_A
	li $v0, 4
	syscall
	la $a0, NEW_LINE
	li $v0, 4
	syscall
	la $a0, BUFFER_B
	li $v0, 4
	syscall
	la $a0, NEW_LINE
	li $v0, 4
	syscall
	
	# Get outta here!	
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
# $a0 contains the address of the first string array
# $a1 contains the address of the second string array
# $a2 contains the maximum length of the arrays
# 
	
FUNCTION_SWAP:
    add $sp, $sp, $a2		#Enlarge the size of the stack by the max word length
    
    add $t0, $zero, $a0		#Store the address of the first word in $t0
    add $t1, $zero, $a1		#Store the address of the second word in $t1
    
#Store the first word in temporary stack space    
loop1:
    lbu $t2, 0($t0)		#Store the "i'th" byte of first word char in $t2		
    sb $sp, 0($t0)		#Store this byte in the stack
    addi $sp, $sp, 1		#Increment the byte position in the word
    addi $t0, $t0, 1		#Increment the byte position in the stack
    addi $t3, $zero, 1		#Keep track of number of times incremented stack
    bne $t2, $zero, loop1	#Keep looping until NULL char is reached

        
add $t0, $zero, $a0		#Restore the address of the first word to $t0
   
#Copy the contents of the second string into the memory of the first string
loop2:
    lbu $t2, 0($t1)		#Store the "i'th" byte of second word char in $t2
    sb $t2, 0($t0)		#Store the i'th byte of second word in i'th byte of first word
    addi $t0, $t0, 1		#Increment the byte position in first word
    addi $t1, $t1, 1		#Increment the byte position in the second word
    bne $t2, $zero, loop2	#Keep looping until the NULL char is reached
    
    
    
    jr $ra
