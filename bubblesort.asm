;RollNo.19
;BatchS2

;*********************************************************************
;to sort the list of integers in ascending/descending order. Read the input
;from the text file and write the sorted data back to the same text file using bubble sort
;************************************************************************************


section .data
file_name db 'myfile1.txt',0
fnotmsg db 'FILE NOT FOUND...',10
fnmsg_len equ $-fnotmsg
openmsg db 'FILE OPENED SUCCESSFULLY',10
omsg_len equ $-openmsg
filemsg db 'FILE CONTENTS ARE: ',10
fmsg_len equ $-filemsg
msg1 db 'Ascending order:',10
len1 equ $-msg1
tot_len dd 0
tot_num dd 10
temp dd 0
newline db 10

section .bss
final resb 8
result resb 4
counter resb 4
counter1 resb 4
fd_in resd 1
fbuff resb 20
fb_len equ $-fbuff
act_len resd 1
act_num resb 100
numbuff resb 100
                ;macro to write
%macro print 2
        mov eax,4
        mov ebx,1
        mov ecx,%1
        mov edx,%2
        int 0x80
%endmacro

%macro read 2
        mov eax,3
        mov ebx,0
        mov ecx,%1
        mov edx,%2
        int 0x80
%endmacro

section .text
global _start
_start:
                ;open the file for reading
        mov eax,5
        mov ebx,file_name
        mov ecx,0
        mov edx,0777
        int 80h
        mov [fd_in],eax
        bt eax,31
        jnc conti1
        print fnotmsg,fnmsg_len
        jmp exit

conti1:
        print openmsg,omsg_len
        print filemsg,fmsg_len
        mov edi,numbuff

readfile:
        mov eax,3
        mov ebx,[fd_in]
        mov ecx,fbuff
        mov edx,fb_len
        int 80h
        mov [act_len],eax
        add [tot_len],eax
        mov dword[counter],eax
        cmp eax,0
        je nxt1
        mov esi,0
back2:
        mov al,byte[fbuff+esi]  ;copy file contents to numbuff
        mov byte[edi],al
next2:
        inc esi
        inc edi
        dec byte[counter]
        jnz back2
        
        print fbuff,[act_len]
        jmp readfile

nxt1:
        mov eax,6               ;close file
        mov ebx,[fd_in]
        int 80h
        mov edi,numbuff
        mov eax,dword[tot_len]
        mov dword[counter],eax
        mov dword[counter1],0
        mov ebp,0

rdnumbuff:                     ;store numbers in 4 bytes each format
        cmp byte[edi],''
        je next3

        cmp byte[edi],10
        je next3
        mov al,byte[edi]
        mov byte[temp+ebp],al
        inc ebp
        inc dword[counter1]
next3:
        cmp byte[edi],''
        jne next4

        mov esi,temp
        call packnum
        mov ecx,dword[tot_num]
        mov dword[act_num+ecx],ebx
        add ecx,4
        mov dword[tot_num],ecx

        mov dword[temp],0
        mov ebp,0
        jmp next5
     
next4:
        cmp byte[edi],10
        jne next5
        mov esi,temp
        call packnum                    ;convert ascii to hex
        mov ecx,dword[tot_num]
        mov dword[act_num+ecx],ebx
        add ecx,4
        mov dword[tot_num],ecx
        mov dword[temp],0
        mov ebp,0

next5:
        inc edi
        dec dword[counter]
        jnz rdnumbuff
        print newline,1
        xor edx,edx
        mov eax,dword[tot_num]
        mov ebx,4h
        div ebx
        mov dword[tot_num],eax
        mov dword[counter],eax          ;bubblesort
        dec dword[counter]

loop1:
        mov eax,dword[counter]	;set inner loop counter for bubble sort
        mov dword[counter1],eax
        mov esi,act_num
        mov edi,act_num
        add edi,4
        
loop2:
        mov eax,dword[edi]
        cmp dword[esi],eax
        jb next6
        mov ebx,dword[esi] 
        mov dword[esi],eax
        mov dword[edi],ebx
next6:
        add esi,4
        add edi,4
        dec dword[counter1]
        jnz loop2
        dec dword[counter]
        jnz loop1
        mov eax,5		;open file for writing
        mov ebx,file_name
        mov ecx,2
        int 80h
        mov [fd_in],eax	;store the file descriptor

        mov eax,4		;system call number(sys_write)
        mov ebx, [fd_in]	;file descriptor
        mov ecx, msg1	;message to write
        mov edx,len1	;number of bytes
        int 0x80		;call kernel

        print msg1,len1
        mov eax,dword[tot_num]	;write ascending order to the file
        mov dword[counter1],eax
        mov edi,act_num

loop3:
        mov eax,dword[edi]
        mov dword[result],eax
        call ascii

        mov eax,4		;system call number(sys_write)
        mov ebx, [fd_in]	;file descriptor
        mov ecx,final	;message to write
        mov edx,8		;number of bytes
        int 0x80		;call kernel
        mov eax,4		;system call number(sys_write)
        mov ebx, [fd_in]	;file descriptor
        mov ecx, newline	;message to write
        mov edx,1   	;number of bytes
        int 0x80		;call kernel
        print final,8
        print newline,1
        add edi,4
        dec dword[counter1]
        jnz loop3

        mov eax,6		;close file
        mov ebx,[fd_in]
        int 80h

exit:			;exit system call
        mov eax,1
        mov ebx,0
        int 0x80

ascii:		;function to convert hex to ascii
        mov esi,final
        mov dword[counter],4
        mov eax,dword[result]

bck2:
        mov ebx,eax
        rol ebx,04
        mov eax,ebx
        and bl,0Fh
        cmp bl,9h
        jbe next1
        add bl,7h

next1:
        add bl,30h
        mov [esi],ebx
        inc esi
        dec dword[counter]
        jnz bck2
        ret

packnum:			;function to convert ascii to hex
        mov eax,0
        mov ebx,0
back:
        mov al,[esi]
        rol ebx,4
        cmp al,39h
        jbe next
        sub al,7h

next:
        sub al,30h
        or bl,al
        inc esi
        dec dword[counter1]
        jnz back 
        ret

;******************OUTPUT*********************

;FILE OPENED SUCCESSFULLY
;FILE CONTENTS ARE: 
;0001
;0004
;0003
;0010
;0005
;0002

;Ascending order:
;0000
;0000
;0001
;0002
;0003
;0004
;0005
;0010

