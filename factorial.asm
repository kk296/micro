
;RollNo.19
;Batch S2

;**********************************
;program to find factorial of a interger no.
;***********************************

section .data
  msg1 db 'Factorial of a given number is ',10,13
  len1 equ $-msg1
  msg2 db 'Given number is :',10,13
  len2 equ $-msg2
  msg0 db 'Factorial of a given number is : 1',10,13
  len0 equ $-msg0
  msg3 db 'Error',10
  len3 equ $-msg3
  newline db 10
  factorial dd 1

section .bss
  final resb 8
  result resb 8
  dnumbuff resb 16
  counter resb 8
  num resb 8
  numh resb 8
  numlen resb 8

%macro print 2
  mov rax , 01
  mov rdi , 01
  mov rsi , %1
  mov rdx , %2
  syscall
%endmacro

%macro read 2
  mov rax , 0
  mov rdi , 0
  mov rsi , %1
  mov rdx , %2
  syscall
%endmacro

section .text

global _start
_start:

      xor rax, rax
      xor rdx , rdx
      mov qword[num],rax
      mov qword[numlen] , rdx

      print msg2,len2
      pop rcx      ;pop number of arguments
      pop rcx      ; pop exec command
      pop rcx      ; pop given number
      mov rdx , 00 
      
up: cmp byte[rcx + rdx],0
    jz l1
    inc rdx
    jmp up

l1: mov rsi , rcx   ;following lines are used for printing the number from command line
    mov rax,[rsi]
    mov qword[num] , rax
    mov qword[numlen] , rdx
    print num , [numlen]
    print newline , 1
 
    mov  rsi , num
    call packnum       ; convert ascii number to hex
     
  
    ;mov rbx,04H
;break2:    add rbx , 30H

    mov qword[numh] , rbx
     
       
   cmp qword[numh] , 0
   jne next2
   print msg0,len0
   jmp exit    

next2: mov rcx , qword[numh]
       call facto


 break1: mov rdx , qword[factorial]
       mov qword[result] , rdx
       mov rbx , rdx
       push rbx
       print msg1,len1
       pop rbx
       call display
       jmp exit


packnum:
	xor rax , rax
        xor rbx , rbx
	mov rcx,04
	mov rsi,num
up1:
	rol bx,04
	mov al,[rsi]
	cmp al,39h
	jbe skip1
	sub al,07h
skip1:	sub al,30h
	add bl,al
	inc rsi
	loop up1
	ret

display:
	mov rdi,dnumbuff	;point esi to buffer
	mov rcx,16		;load number of digits to display 
                
dispup1:
	rol rbx,4		;rotate number left by four bits
	mov dl,bl		;move lower byte in dl
	and dl,0fh		;mask upper digit of byte in dl
	add dl,30h		;add 30h to calculate ASCII code
	cmp dl,39h		;compare with 39h
	jbe dispskip1		;if less than 39h akip adding 07 more 
	add dl,07h		;else add 07

dispskip1:
	mov [rdi],dl		;store ASCII code in buffer
	inc rdi			;point to next byte
	loop dispup1		;decrement the count of digits to display
				;if not zero jump to repeat

	print dnumbuff,16	;Dispays only lower 5 digits as upper three are '0'
	
	ret



facto: push rcx
       cmp rcx , 01
       jne next3
       jmp exit1
  next3: dec rcx
         call facto           ; recursive call
  exit1: pop rcx
         mov rax , rcx
         mul qword[factorial]
         mov qword[factorial] , rax
         ret             
     


exit:  mov rax , 60
       mov rdi , 0
       syscall


; nasm -f elf64 Assignment9_64bit.asm
;ld -o Assignment9_64bit Assignment9_64bit.o
;./Assignment9_64bit 0002
;Given number is :
;0002
;Factorial of a given number is 
;0000000000000002
