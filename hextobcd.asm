;RollNo.19
;Batch S2

;****************************************************
;x64 bit ALP for Hex to BCD and BCD to Hex Conversion
;****************************************************


section .data
	menumsg db 10,10,'###### Menu for Code Conversion ######'
		db 10,'1: Hex to BCD'
		db 10,'2: BCD to Hex'
		db 10,'3: Exit'
		db 10,10,'Please Enter Choice::'
	menumsg_len equ $-menumsg
	wrchmsg db 10,10,'Wrong Choice Entered....Please try again!!!',10,10
	wrchmsg_len equ $-wrchmsg

	hexinmsg db 10,10,'Please enter 4 digit hex number::'
	hexinmsg_len equ $-hexinmsg

	bcdopmsg db 10,10,'BCD Equivalent::'
	bcdopmsg_len equ $-bcdopmsg

	bcdinmsg db 10,10,'Please enter 5 digit BCD number::'
	bcdinmsg_len equ $-bcdinmsg

	hexopmsg db 10,10,'Hex Equivalent::'
	hexopmsg_len equ $-hexopmsg

	thankmsg db 10,10,'Thank you for using Program',10
	thankmsg_len equ $-thankmsg


section .bss
	numascii resb 06		;common buffer for choice, hex and bcd input
	opbuff resb 05
	dnumbuff resb 08



%macro dispmsg 2
	mov rax,01
	mov rdi,01
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro accept 2
	mov rax,00
	mov rdi,00
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .text
	global _start
_start:

	dispmsg menumsg,menumsg_len
	accept numascii,2

	cmp byte [numascii],'1'
	jne case2
	call hex2bcd_proc

	jmp _start

case2:	cmp byte [numascii],'2'
	jne case3
	call bcd2hex_proc
	jmp _start

case3:	cmp byte [numascii],'3'
	je exit
	dispmsg wrchmsg,wrchmsg_len
	jmp _start

exit:
	dispmsg thankmsg,thankmsg_len

	mov rax,60
	mov rbx,0
	syscall

hex2bcd_proc:
	dispmsg hexinmsg,hexinmsg_len
	accept numascii,5
	call packnum
	mov rcx,0
	mov ax,bx
	mov bx,10		;Base of Decimal No. system
h2bup1:	mov dx,0
	div bx
	push rdx
	inc rcx
	cmp ax,0
	jne h2bup1
	mov rdi,opbuff

h2bup2:	pop rdx
	add dl,30h
	mov [rdi],dl
	inc rdi
	loop h2bup2
	
	dispmsg bcdopmsg,bcdopmsg_len
	dispmsg opbuff,5
	ret

bcd2hex_proc:
	dispmsg bcdinmsg,bcdinmsg_len
	accept numascii,6

	dispmsg hexopmsg,hexopmsg_len

	mov rsi,numascii
	mov rcx,05
	mov rax,0
	mov ebx,0ah

b2hup1:	mov rdx,0
	mul ebx
	mov dl,[rsi]
	sub dl,30h
	add rax,rdx
	inc rsi
	loop b2hup1
	mov ebx,eax
	call disp32_num
	ret

packnum:
	mov bx,0
	mov ecx,04
	mov esi,numascii
up1:
	rol bx,04
	mov al,[esi]
	cmp al,39h
	jbe skip1
	sub al,07h
skip1:	sub al,30h
	add bl,al
	inc esi
	loop up1
	ret


disp32_num:
	mov rdi,dnumbuff	;point esi to buffer
	mov rcx,08		;load number of digits to display 

dispup1:
	rol ebx,4		;rotate number left by four bits
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

	dispmsg dnumbuff+3,5	;Dispays only lower 5 digits as upper three are '0'
	
	ret


; ---------------------------------------------------------------
;Output-:

;###### Menu for Code Conversion ######
;1: Hex to BCD
;2: BCD to Hex
;3: Exit

;Please Enter Choice::1


;Please enter 4 digit hex number::000B


;BCD Equivalent::11

;###### Menu for Code Conversion ######
;1: Hex to BCD
;2: BCD to Hex
;3: Exit

;Please Enter Choice::2


;Please enter 5 digit BCD number::00012     


;Hex Equivalent::0000C

;###### Menu for Code Conversion ######
;1: Hex to BCD
;2: BCD to Hex
;3: Exit

;Please Enter Choice::3 


;Thank you for using Program
