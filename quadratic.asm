.data
	values_message: .asciiz "Enter the root of root A,B C\n"
	a_value:.asciiz "Enter the value for A\n"
	b_value: .asciiz "Enter the value for B\n"
	c_value: .asciiz "Enter the value for C\n"
	complex_root: .asciiz "The root is a complex root"
	first_root:.asciiz "The value root1 is\n"
	second_root: .asciiz "The value for root2 is\n"
.text
	#values message
	la $a0, values_message
	li $v0, 4
	syscall
	#input for a
	la $a0, a_value
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0
	
	#input for b
	la $a0, b_value
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0
	
	#input for c
	la $a0, c_value
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $t2, $v0
	
	
	subu $t3, $zero, $t1  #convert b from a positive number to negative number
	
	#covert $t3 i.e (-b) to a floating point register $f0
	mtc1 $t3, $f0
	cvt.d.w $f0, $f0
	
	#convert 2 to a floating point and store in register #f2
	li $t3, 2
	mtc1 $t3, $f2
	cvt.d.w $f2, $f2
	
	#convert (a) i.e $t0 to a floating point and store in $f4
	mtc1 $t0, $f4
	cvt.d.w $f4, $f4
	
	#move 4 to register $t3
	li $t3, 4
	
	mul $t6, $t1, $t1 #getting b square (b^2) $t1^2 = $t6
	
	mul $t5, $t0, $t2 #multiplication of a*c i.e $t0 * $t2 = $t5
	
	mul $t3, $t5, $t3 #multiply $t3 * $t5 and store it back in $t3
	
	subu $t7, $t6, $t3 # subtract $t3 from $t6 and store in $t7 as your D
	
	#condition if D is less than or equal to zero
	ble $t7, 0, stopProgramme
	#solving for square root of d which is $t7
	div $t8, $t7, 2 # $t8 is storing the loop times when D is greater than ten
	
	li $t3, 1 # $t3 is storing the loop counter
	
	#convert d in $t7 to a floating point $f6 which will b my n value
	mtc1 $t7, $f6
	cvt.d.w $f6, $f6
	
	#convert d in $t7 to a floating point $f6 which will b my x value
	mtc1 $t7, $f8
	cvt.d.w $f8, $f8
	
	#condition if $t7 is less than or equal to 10
	ble $t7, 10, calculate
loop:
	beq $t3, $t8, endloop
	
	div.d $f10, $f6, $f8 # $f10 = n/x
	add.d $f8, $f8, $f10 # $f8 = x + n/x
	div.d $f8, $f8, $f2 # $f8 = (x + n/x)/2.0
	addu $t3, $t3, 1 # increment $t3 by 1
	b loop #back to the loop

calculate:
loop_2:
	beq $t3, $t7, endloop
	
	div.d $f10, $f6, $f8 # $f10 = n/x
	add.d $f8, $f8, $f10 # $f8 = x + n/x
	div.d $f8, $f8, $f2 # $f8 = (x + n/x)/2.0
	addu $t3, $t3, 1 # increment $t3 by 1
	b loop #back to the loop
	b exit
	
endloop:
	mul.d $f4, $f2, $f4
	
	#the first root
	sub.d $f6, $f0, $f8
	div.d $f10, $f6, $f4
	
	#second root
	add.d $f6, $f0, $f8
	div.d $f2, $f6, $f4
	
	#print out first root
	la $a0, first_root
	li $v0, 4
	syscall
	
	mov.d $f12, $f10
	li $v0, 3
	syscall
	
	#print out second root
	la $a0, second_root
	li $v0, 4
	syscall
	
	mov.d $f12, $f2
	li $v0, 3
	syscall
	
	
	
stopProgramme:
	la $a0, complex_root
	li $v0, 4
	syscall
	
	b exit
	

exit:
	li $v0,10
	syscall
