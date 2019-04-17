# Read 8 integers and print them multiplied by 6 and backwards
# Register x0 = 0
# Register x28 = i
# Register x27 = n
# Register x5 = a[]
# Register x17 = env call code
# Register x10 = env using it to print or read 

.data 
	
	prompt_str: .asciz "Please enter 8 integers in 8 lines: \n"
	space_str:  .asciz " "
	line_str:     .asciz "\n-------------------------------\n"
		
	.align 2 
	a: .space 32 

.text

	main:
		# Print a prompt
			addi    x17, x0, 4      	# environment call code for print_string
			la      x10, prompt_str 	# pseudo-instruction: address of string
			ecall                   	# print the string from str_n
		   
		# Read 8 integers
		addi 	x28, x0, 0		# i = 0;
		addi 	x27, x0, 8		# n = 8;
		la  	 x5, a			# store memory address of a[] in a register
	loop1: 
			addi    x17, x0, 5     		# environment call code for read_int
			ecall                   	# read a line containing an integer
			
			sw 	 x10, (x5)		# store integer from x10 in the appropriate position of the a[] array
			
			addi 	 x5,  x5, 4		# increase current memory address of array by 4 bytes to store next integer
			addi 	x28, x28, 1		# i = i + 1;
			bne 	x28, x27, loop1		# branch if (i != n)
			
			# Print a new line
			addi    x17, x0, 4      	# environment call code for print_string
			la      x10, line_str 		# pseudo-instruction: address of string
			ecall                   	# print the string from nl_str      
			
			# Print 8 integers
			addi 	x28, x0, 0		# i = 0;
			addi 	 x5,  x5, -4		# set current memory address of array at the last integer
	loop2:	
		 lw 	x12, (x5)		# load word (our integer) from memory
		 add 	x13, x12, x12		# x13 -> x + x (2x)
		 add 	x14, x13, x13		# x14 -> 2x + 2x (4x)
		 add 	x10, x14, x13		# x10 -> 4x + 2x = (6x)

		 addi    x17, x0, 1    		# environment call code for print_int		 
			 ecall                  	# print the integer in x10 (s)
			 
			 # Print a space
			 addi    x17, x0, 4      	# environment call code for print_string
			 la      x10, space_str 	# pseudo-instruction: address of string
			 ecall                   	# print the string from space_str      
			 
			 addi 	 x5,  x5, -4		# decrease current memory address of array by 4 bytes to print previous integer
		 addi 	x28, x28, 1		# i = i + 1;
		 bne 	x28, x27, loop2 	# branch if (i != n)
		 
		 # Print a new line
			 addi    x17, x0, 4      	# environment call code for print_string
			 la      x10, line_str 		# pseudo-instruction: address of string
			 ecall                   	# print the string from nl_str    
		 
		 j main
