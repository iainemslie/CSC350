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
    addi $sp, $sp, -40 	# Increase the size of the stack and push values
    sw $ra, 36($sp)
    sw $s0, 32($sp)
    sw $a0, 28($sp)
    sw $a1, 24($sp)
    sw $a2, 20($sp)
    sw $t0, 16($sp)
    sw $t1, 12($sp)
    sw $t2, 8($sp)
    sw $t3, 4($sp)
    sw $t4, 0($sp)
         
    # pivot := A[(lo + hi) / 2]
    add $t0, $a1, $a2		# $t0 = lo + hi
    addi $t1, $zero, 2		# Let $t1 be 2
    div $t0, $t0, $t1		# (lo + hi) / 2
    mul $t0, $t0, MAX_WORD_LEN 	# A[(lo + hi) / 2]
    add $t0, $t0, $a0		# pivot : = A[(lo + hi) / 2]  #$t0 contains address of pivot
 
    add $s0, $zero, $a0		# save the base address of the array into $s0   
        
    # Don't want the address of pivot want the value of pivot, the reason is that the pivot can change places and the reference
    # Will be to the new value not the value of pivot

    # Allocate Heap Memory to save the value of pivot
    li $v0, 9
    li $a0, MAX_WORD_LEN
    syscall
    
    add $s7, $zero, $v0		# Save the allocated memory address
    add $t5, $zero, $s7		# Use this for incrementing dynamic pivot copy
    add $t6, $zero, $t0		# Use this for incrementing pivot address in static memory
    
    # Copy the value of pivot into the dynamic memory
    
    #Copy the contents of the second string into the memory of the first string
    copy_loop:
    lbu $t7, 0($t6)		#Load the "i'th" byte of second word char in $t2
    sb $t7, 0($t5)		#Store the i'th byte of second word in i'th byte of first word
    addi $t5, $t5, 1		#Increment the byte position in first word
    addi $t6, $t6, 1		#Increment the byte position in the second word
    bne $t7, $zero, copy_loop	#Keep looping until the NULL char is reached
    
    add $a0, $zero, $a0		# Restore the base address of the array into $a0
    
    addi $t1, $a1, -1		# i = lo - 1
    addi $t2, $a2, 1		# j = hi + 1

forever_loop:

    while_loop1:
    	addi $t1, $t1, 1		# i = i + 1
    	mul $t3, $t1, MAX_WORD_LEN	# $t3 contains offset address of A[i]
        add $a0, $t3, $s0		# Pass the offset address of A[i] as argument
        add $a1, $s7, $zero		# Pass the offset address of A[pivot] as argument
    	jal FUNCTION_STRCMP
    	blt $v0, $zero, while_loop1	# A[i] < pivot 
    	
    while_loop2:
    	addi $t2, $t2, -1		# j = j - 1
    	mul $t4, $t2, MAX_WORD_LEN	# $t3 contains offset address of A[j]
    	add $a0, $t4, $s0		# Pass the offset address of A[j] as argument
    	add $a1, $s7, $zero		# Pass the offset address of A[pivot] as argument
        jal FUNCTION_STRCMP
        bgt $v0, $zero, while_loop2	# A[j] > pivot
        
    bge $t1, $t2, exit	# if i >= j

    mul $t3, $t1, MAX_WORD_LEN	# $t3 contains offset address of A[i]
    add $a0, $t3, $s0		# Pass the offset address of A[i] as argument
    mul $t4, $t2, MAX_WORD_LEN	# $t3 contains offset address of A[j]
    add $a1, $t4, $s0		# Pass the offset address of A[j] as argument
    addi $a2, $zero, MAX_WORD_LEN
    jal FUNCTION_SWAP	# swap A[i] with A[j]
    
    j forever_loop
        
 exit:   
    add $v0, $zero, $t2
    lw $t4, 0($sp)
    lw $t3, 4($sp)
    lw $t2, 8($sp)
    lw $t1, 12($sp)
    lw $t0, 16($sp)
    lw $a2, 20($sp)
    lw $a1, 24($sp)
    lw $a0, 28($sp)
    lw $s0, 32($sp)
    lw $ra, 36($sp)
    addi $sp, $sp, 40	# Decrease the stack and pop values
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
    addi $sp, $sp, -32	# Push values to the stack
    sw $ra, 28($sp)
    sw $a0, 24($sp)
    sw $a1, 20($sp)
    sw $a2, 16($sp)
    sw $t0, 12($sp)
    sw $t1, 8($sp)
    sw $t2, 4($sp)
    sw $v0, 0($sp)
    
    
    add $t0, $zero, $a1		# $t0 gets lo
    add $t1, $zero, $a2		# $t1 gets hi
    
    bge $t0, $t1, done_quicksort
    
    jal FUNCTION_PARTITION	
    add $t2, $zero, $v0		# t2 is p
    
    add $a1, $zero, $t0		# Pass argument lo
    add $a2, $zero, $t2    	# Pass argument p
    jal FUNCTION_HOARE_QUICKSORT
    
    addi $a1, $t2, 1		# Pass argument p + 1
    add $a2, $zero, $t1		# Pass argument hi
    jal FUNCTION_HOARE_QUICKSORT


done_quicksort:
    lw $v0, 0($sp)	# Pop values from the stack
    lw $t2, 4($sp)	
    lw $t1, 8($sp) 
    lw $t0, 12($sp)
    lw $a2, 16($sp)
    lw $a1, 20($sp)
    lw $a0, 24($sp)
    lw $ra, 28($sp)
    addi $sp, $sp, 32
    jr $ra

# Copy the value of the pivot into space on the stack

FUNCTION_COPY_PIVOT:    

#
# Solution for FUNCTION_STRCMP must appear below.
#
# $a0 contains the address of the first string
# $a1 contains the address of the second string
# $v0 will contain the result of the function.
#

FUNCTION_STRCMP:
	addi $sp, $sp, -24 	# Increase the stack size
	sw $ra, 20($sp)		# push return address
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
	lw $t1, 12($sp)		# pop $t1
	lw $t0, 16($sp)		# pop $t0
	lw $ra, 20($sp)		# pop $ra
	addi $sp, $sp, 24	# Restore the stack
	addi $v0, $zero, -1	# Function return value
	jr $ra
set_positive_one:
	lw $t4, 0($sp)		# pop $t4
	lw $t3, 4($sp)		# pop $t3
	lw $t2, 8($sp)		# pop $t2
	lw $t1, 12($sp)		# pop $t1
	lw $t0, 16($sp)		# pop $t0
	lw $ra, 20($sp)		# pop $ra
	addi $sp, $sp, 24	# Restore the stack
	addi $v0, $zero, 1	# Function return value
	jr $ra
set_zero:
	lw $t4, 0($sp)		# pop $t4
	lw $t3, 4($sp)		# pop $t3
	lw $t2, 8($sp)		# pop $t2
	lw $t1, 12($sp)		# pop $t1
	lw $t0, 16($sp)		# pop $t0
	lw $ra, 20($sp)		# pop $ra
	addi $sp, $sp, 24	# Restore the stack
	addi $v0, $zero, 0	# Function return value				
   	jr $ra	

  	   	
#
# Solution for FUNCTION_SWAP
#
# $a0 contains the address of the first string array
# $a1 contains the address of the second string array
# $a2 contains the maximum length of the arrays
# 
	
FUNCTION_SWAP:
    addi $sp, $sp, -20		# Grow the stack
    sw $ra, 16($sp)		# Store the return address
    sw $t0, 12($sp)		# push $t0
    sw $t1, 8($sp)		# push $t1
    sw $t2, 4($sp)		# push $t2
    sw $t3, 0($sp)		# push $t3
    sub $sp, $sp, $a2		# Enlarge the size of the stack by the max word length
    
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

    add $sp, $zero, $t3		#Restore the starting position of the stack (byte offset)

    add $sp, $sp, $a2		# Restore the size of the stack by the max word length
    lw $t3, 0($sp)		# pop $t3
    lw $t2, 4($sp)		# pop $t2
    lw $t1, 8($sp)		# pop $t1
    lw $t0, 12($sp)		# pop $t0
    lw $ra, 16($sp)		# pop $ra
    addi $sp, $sp, 20		# Restore stack
    jr $ra
