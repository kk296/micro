;*************************************************************
;Assignmnet no. 19
;Write a TSR to generate the pattern of the frequency tones by ;reading the Real Time Clock (RTC). The duration of the each tone ;is solely decided by the programmer. 
;*************************************************************

code segment
assume cs:code
org 100h                ;prog seg prefix addrss
jmp initze              ;hex no of 256
savint dd ?             ;for saving address of es:bx
count dw 0000h          ;count of tics

hours db ?
mins db ?
sec db ?

testnum:
        push ax    ;store all the contents of register
        push bx    ;(not to change original values of register)
        push cx
        push dx
        push cs
        push es
        push si
        push di

        mov ax,0b800h   ;starting address of display
        mov es,ax
        mov cx,count
        inc cx
        mov count,cx
        cmp cx,011h
        
	  jne exit

        mov cx,0000h
        mov count,cx
        call time
exit:
        pop di
        pop si
        pop es
        pop ds
        pop dx
        pop cx
        pop bx
        pop ax
        jmp cs:savint   ;jump to normal isr

;------------------convert procedure--------------------
convert proc
        and al,0f0h
        ror al,4
        add al,30h
        call disp
        mov al,dh
        and al,0fh
        add al,30h
        call disp
        ret
endp

;------------------------time procedure----------------
time proc
        mov ah,02h      ;getting current time system clk
        int 1ah
        mov hours,ch    ;HH->ch, MM->cl, SS->dh
        mov mins,cl
        mov sec,dh

       ; mov bx,0E00h    ;location for displaying clk
	
	   mov bx,3984
        mov al,hours	   ;Display Hours
        mov dh,hours
        call convert
        mov al,':'
        call disp

        mov al,mins	   ;Display Mins
        mov dh,mins
        call convert
        mov al,':'
        call disp


        mov al,sec	   ;Display Seconds
        mov dh,sec
        call convert
      
	   call tone
  
	   ret
         endp


;-----------------------display procedue----------------
disp proc
        mov ah,9Ch      ;for setting attribute
				 ;ATTRIBUTE BYTE  BL  R  G  B  I  R  G  B    
                                         ;BACKGROUND FOREGROUND
	   mov es:bx,ax    ;write into vedio buffer
        inc bx
        inc bx
        ret
endp

;--------------- frequency tone procedure-------------------

tone proc

	   mov     al, 182         ; Prepare the speaker for the
        out     43h, al         ;  note.
        mov     ax, 4560        ; Frequency number (in decimal)                                
        out     42h, al         ; Output low byte.
        mov     al, ah          ; Output high byte.
        out     42h, al 
        in      al, 61h         ; Turn on note (get value from
                                ;  port 61h).
        or      al, 00000011b   ; Set bits 1 and 0.
        out     61h, al         ; Send new value.
        mov     bx, 25          ; Pause for duration of note.
.pause1:
        mov     cx, 65535
.pause2:
        dec     cx
        jne     .pause2
        dec     bx
        jne     .pause1
        in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
        and     al, 11111100b   ; Reset bits 1 and 0.
        out     61h, al         ; Send new value.	
	   ret
endp
;------------------initialization------------------------
initze:
        push cs
        pop ds
        cli             ;clear int flag

        mov ah,35h      ;35 for get orignal add
        mov al,08h      ;intrrupt no
        int 21h
        mov word ptr savint,bx
        mov word ptr savint+2,es

        mov ah,25h              ;25 for set int add
        mov al,08h
        mov dx,offset testnum   ;new add for intrrupt
        int 21h

        mov ah,31h              ;make prog resident(request tsr)
        mov dx,offset initze    ;size of program

        sti	                ;set intrrupt flag
        int 21h                 
code ends
end


