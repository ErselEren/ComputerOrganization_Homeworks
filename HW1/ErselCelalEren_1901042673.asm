	.data
space: .asciiz "\n"
msg1: .asciiz "Enter size of the array: "
msg2: .asciiz "Enter elements in the array: "
msg3: .asciiz "!!! Enter a element between 1 and 100 : "
msg4: .asciiz "-MAIN- "
msg5: .asciiz "RESULT : "
msg6: .asciiz "Enter k integer divisor : "
op: .asciiz "( "
cp: .asciiz ") "
plus: .asciiz " + "
eq: .asciiz " = "
line: .asciiz " #################################################### "

	#	s2 = array size
	# 	s3 = address of array
	#	s4 = 4*size
	#	s5 = current element count
	#	s7 = divisor
	#	t0 = address of array copied from s3
	#	t1 = integer from user input
	
	
	.text
get_size:

	#print msg1
	li $v0,  4
	la $a0,  msg1
	syscall          
	
	#read integer into v0
	li $v0, 5 # load syscall read_int into $v0.
	syscall
	
	# validation of array size
	move $s2, $v0 # move the number read into $v0. $s2 contains the size of the array.
	addi $s1, $zero, 101 #maximum element size is 100, $s1=101
	slt $t1, $s2, $s1 # if ($s1 <= $s2) check if the max number of element is exceeded.
	beq $t1, $zero, get_size #branch to the label size again if it is exceeded else continue s2 is the size
	sgt $t1, $s2, 2
	beq $t1, $zero, get_size
	# multiplying size by 4, shifting 2 times
	sll $s4, $s2, 2
	
	# allocate memory and store address at $s3 
	move $a0, $s4
	li $v0, 9
	syscall
	
	
	#move address of array to t0 and s3 register
	move $s3, $v0
	move $t0, $v0 
	# set s5 as 0, s5 is current element counter
	addi $s5, $zero, 0
	
	
print_elements_msg: 
	#print msg2
	li $v0,  4
	la $a0,  msg2
	syscall            
	
	
get_elements:       
	beq $s5, $s2, get_divisor  # go to main label if size and number of elements is equal
    				
    	li $v0,5
    	syscall
    
    	move $t1, $v0    
    	bge $t1, 101, print_error_msg  # check the constraints
	
	ble $t1, 0, print_error_msg
	
	j set_index
	       
print_error_msg:
	li $v0, 4
	la $a0, msg3
	syscall
	j get_elements

get_divisor:
	li $v0, 4
	la $a0, msg6
	syscall
	
	#read integer into v0
	li $v0, 5 # load syscall read_int into $v0.
	syscall
	
	# validation of array size
	move $s7, $v0 # move the number read into $v0. $s7 contains the divisor
	addi $s1, $zero, 101 #maximum element size is 100, $s1=101
	slt $t1, $s7, $s1 # if ($s1 <= $s7) check if the max number of element is exceeded.
	beq $t1, $zero, get_divisor #branch to the label size again if it is exceeded else continue s7 is the divisor
	
	sgt $t1, $s7, 0
	beq $t1, $zero, get_divisor
	j main
			
set_index:
	# t1 is user input, pass it to array
	sw $t1, 0($t0)
	
	addi $t0, $t0, 4		
	addi $s5, $s5, 1
	j get_elements
	
main:
	li $v0,  4
	la $a0,  line
	syscall 
	
	# size assigned to t1
	move $t1, $s3 	
		
	li $t2, 0   #outer counter
	li $t3, 0   #inner counter
	li $t4, 0   #count
	move $t5, $s7   #t5 = k, integer that we will divide
	li $t8, 0
	
	move $t0, $s3
	
		
outer:
	
	beq $t2, $s2, outer_end  # s2 - size , t2 = 0 at initial, t2 is increased at each loop. Go to outer_end at equality
	move $t9, $t0
	
	addi $t3, $t2, 1          # j = i+1
	
	jal inner	
	
	addi $t2, $t2, 1 # advance loop counter
	addi $t0, $t0, 4 # advance array pointer
	
	j outer # repeat the loop
	
outer_end:	
	
	addi $v0, $zero, 4  # print_string syscall
        la $a0, space       # load address of the string
        syscall
        
	li $v0,  4
	la $a0,  msg5
	syscall 
	
	li $v0 1
	move $a0, $t4
	syscall
	
	li $v0 10 
	syscall 
	
inner: 
	beq $t3, $s2, inner_end	# if innercounter is equal to size, go to inner_end label
	
	lw $t6, 0($t0) 	  	# get i'th element
	
	addi $t9, $t9, 4	# t9 = i + 1 
	lw $s6, 0($t9)		# get j'th element
	add $t1, $t6, $s6	# t6 = A[i]+ A[j]

	div $t1, $t5		# sum / k
	mfhi $t7		# t7 = remainder
	
	bne $t7, $t8, no_count_increase # if it is not equal to 0, go to no_count_increase
	
	# \n 
        li $v0, 4
	la $a0, space
	syscall	
	
	# (
	li $v0, 4
	la $a0, op
	syscall
		
	# A[i]
	li $v0, 1
	move $a0, $t6
	syscall
		
	# +
	li $v0, 4
	la $a0, plus
	syscall	
		
	# A[j]																								
	li $v0, 1
	move $a0, $s6
	syscall
	
	# )
	li $v0, 4
	la $a0, cp
	syscall	
	
        # = 
        li $v0, 4
	la $a0, eq
	syscall	
	
	# sum
	li $v0, 1
	move $a0, $t1
	syscall			
	
	# \n 
        li $v0, 4
	la $a0, space
	syscall																																																																																																																																																																																																																																																										
										
	addi $t4, $t4, 1 	# increase count
			
no_count_increase:
	addi $t3, $t3, 1    # inner l
	j inner # restart inner loop

inner_end:
        jr $ra

