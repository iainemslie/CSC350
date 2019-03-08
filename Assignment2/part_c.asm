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

	.text
#####
#####	
INIT:
	# Save $s0, $s1 and $s2 on stack.
	addi $t0, $sp, 12
	sub $sp, $sp, $t0
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	
	la $a0, MESSAGE3
	li $v0, 4
	syscall
	
	# Initialize NUM_WORDS to zero.
	#
	# Load start of word array into $s0; we'll directly read
	# input words into this array/buffer. 
	la $t0, NUM_WORDS
	sw $zero, 0($t0)
	la $s0, WORD_ARRAY
		
READ_WORD:
	add $a0, $s0, $zero
	li $a1, MAX_WORD_LEN
	li $v0, 8
	syscall
	
	# Empty string? If so, finish. An emtpy string
	# consists of the single newline character.
	lbu $t0, 0($s0)
	li $t1, NEW_LINE_ASCII
	beq $t0, $t1, CALL_QUICKSORT
	
	# Increment # of words; at the maximum??
	la $t0, NUM_WORDS
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)
	addi $t2, $zero, MAX_NUM_WORDS
	beq $t1, $t2, CALL_QUICKSORT
	
	# Otherwise proceed to the next work
	addi $s0, $s0, MAX_WORD_LEN
	j READ_WORD
	

	
CALL_QUICKSORT:	
	# Before call to quicksort
	jal FUNCTION_PRINT_WORDS
	
	# Assemble arguments
	la $a0, WORD_ARRAY
	li $a1, 0
	la $t0, NUM_WORDS
	lw $a2, 0($t0)
	addi $a2, $a2, -1
	jal FUNCTION_HOARE_QUICKSORT
			
	# Restore from stack the callee-save registers used in this code
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
	# After call to quicksort
	jal FUNCTION_PRINT_WORDS

EXiT:
	li $v0, 10
	syscall
	
	
	
#####
#####	
FUNCTION_PRINT_WORDS:
	la $a0, MESSAGE1
	li $v0, 4
	syscall
	
	la $t0, NUM_WORDS
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
	la $a0, NEW_LINE
	li $v0, 4
	syscall
	
	la $a0, MESSAGE2
	li $v0, 4
	syscall
	
	li $t0, 0
	la $t1, WORD_ARRAY
	la $t2, NUM_WORDS
	lw $t2, 0($t2)
	
LOOP_FPW:
	beq $t0, $t2, EXIT_FPW
	add $a0, $t1, $zero
	li $v0, 4
	syscall
	addi $t0, $t0, 1
	addi $t1, $t1, MAX_WORD_LEN
	j LOOP_FPW
	
EXIT_FPW:
	jr $ra
	
	
	
	
##########################################################
#
# YOUR SOLUTION MAY NOT ADD MORE GLOBAL DATA OR CONSTANTS.
# ALL OF THE CODE FOR YOUR FUNCTION(S) MUST APPEAR AFTER
# THIS POINT. SUBMISSIONS THAT IGNORE THIS REQUIREMENT
# MAY NOT BE ACCEPTED FOR EVALUATION.
#
##########################################################


#
# $a0 contains the starting address of the array of strings,
#    where each string occupies up to MAX_WORD_LEN chars.
# $a1 contains the starting index for the partition
# $a2 contains the ending index for the partition
# $v0 contains the index that is to be returned by the
#    partition algorithm
#

FUNCTION_PARTITION:
    jr $ra
	
	
#
# $a0 contains the starting address of the array of strings,
#    where each string occupies up to MAX_WORD_LEN chars.
# $a1 contains the starting index for the quicksort
# $a2 contains the ending index for the quicksort
#
# THIS FUNCTION MUST BE WRITTEN IN A RECURSIVE STYLE.
#

FUNCTION_HOARE_QUICKSORT:
    add $t0, $zero, $a1		#Copy the value of lo in $a1 into $t0
    add $t1, $zero, $a2		#Copy the value of hi in $a2 into $t1 
    
    add $t3, $t0, $t1	# lo + hi stored in $t0
    addi $t4, $zero, 2	# for dividing by two  
    div $t3, $t4	# divide [(lo + hi) / 2]
    
    subi $t0, $t0, 1	# i := lo - 1
    addi $t1, $t1, 1    # i := hi + 1
    
    addi $t7, $zero, 1
    
#forever_loop:
    
    
    #bne $t7, $zero, forever_loop

    jr $ra
    

    
            
#
# Solution for FUNCTION_STRCMP
#
# $a0 contains the address of the first string
# $a1 contains the address of the second string
# $v0 will contain the result of the function.
#   
FUNCTION_STRCMP:
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
	addi $v0, $zero, -1
	jr $ra
set_positive_one:
	addi $v0, $zero, 1
	jr $ra
set_zero:
	addi $v0, $zero, 0				
   	jr $ra
   	
#
# Solution for FUNCTION_SWAP
#
# $a0 contains the address of the first string array
# $a1 contains the address of the second string array
# $a2 contains the maximum length of the arrays
# 
	
FUNCTION_SWAP:
    sub $sp, $sp, $a2		#Enlarge the size of the stack by the max word length
    
    add $t0, $zero, $a0		#Store the address of the first word in $t0
    add $t1, $zero, $a1		#Store the address of the second word in $t1

    add $t3, $zero, $sp		#Save the address of the start of the stack
    
#Copy the contents of the first word to the stack
loop1:
    lbu $t2, 0($t0)		#Load the i'th byte of first word into $t2	
    sb $t2, 0($sp)		#Store the i'th byte of first word to i'th byte of stack pointer
    addi $t0, $t0, 1		#Increment the byte position in the first word
    addi $sp, $sp, 1		#Increment the byte position in the stack
    bne $t2, $zero, loop1
 
add $t0, $zero, $a0		#Restore the address of the first word in $t0         
                         
#Copy the contents of the second string into the memory of the first string
loop2:
    lbu $t2, 0($t1)		#Load the "i'th" byte of second word char in $t2
    sb $t2, 0($t0)		#Store the i'th byte of second word in i'th byte of first word
    addi $t0, $t0, 1		#Increment the byte position in first word
    addi $t1, $t1, 1		#Increment the byte position in the second word
    bne $t2, $zero, loop2	#Keep looping until the NULL char is reached
      
add $sp, $zero, $t3		#Restore the starting position of the stack  
add $t1, $zero, $a1		#Restore the address of the second word in $t1
    
#Copy the contents of the temporary stack area into the second string
loop3:
    lbu $t2, 0($sp)		#Load the i'th byte of temp area into $t2
    sb $t2, 0($t1)		#Store value of $t2 into beginning of second word in $t1
    addi $t1, $t1, 1		#Increment the byte position in second word
    addi $sp, $sp, 1		#Increment the byte position in the stack
    bne $t2, $zero, loop3

add $sp, $zero, $t3		#Restore the starting position of the stack 

    jr $ra
