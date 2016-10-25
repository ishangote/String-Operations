;String Operations: Length, Reverse, Palindrome

Section .data

msg1: db "Enter a string: "
len1: equ $-msg1

msg2:	db "1. Length",0x0A
	db "2. Reverse",0x0A
	db "3. Palindrome",0x0A
	db "4. Exit",0x0A
	db "Enter choice: " 
len2: equ $-msg2

msg3: db "Length is: "
len3: equ $-msg3

msg4: db "Reverse is: "
len4: equ $-msg4

msg5: db "String is a palindrome."
len5: equ $-msg5

msg6: db "String is not a palindrome."
len6: equ $-msg6

msg: db 0x0A
len: equ $-msg

;******************************************************

Section .bss

data: resb 0x28
chc: resb 0x01
result: resq 0x01
res: resb 0x01
mylen: resb 0x01
cntd: resb 0x01
data2: resb 0x28

;******************************************************

%macro print 2
	mov rax,0x01
	mov rdi,0x01
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

;******************************************************

%macro read 2
	mov rax,0x00
	mov rdi,0x00
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

;******************************************************

Section .text
Global _start:
_start:

	print msg1,len1
	read data,0x28

;******************************************************

menu:
	print msg2,len2
	read chc,0x02
	print msg,len

	cmp byte[chc],0x31
	je disp_length

	cmp byte[chc],0x32
	je disp_rev

	cmp byte[chc],0x33
	je disp_pali

	cmp byte[chc],0x34
	je exit

disp_length:				;Front End to diplay length
	print msg3,len3
	call get_length			;Back End to calculate length
	xor al,al
	
	mov al,byte[mylen]
	mov byte[result+7],al
	mov byte[cntd],0x02
	call disp
	print msg,len
	jmp menu

disp_rev:
	mov rsi,data
	mov rdi,data2
	call rev_fun
	print msg4,len4

	xor rax,rax			;print sys call
	xor rdx,rdx	
	mov rax,0x01
	mov rdi,0x01
	mov rsi,data2
	mov dl,byte[mylen]
	syscall
	print msg,len
	jmp menu
	
disp_pali:
	mov rsi,data
	mov rdi,data2
	call rev_fun			;Reverse stored in data2

	call get_length
	xor rcx,rcx
	mov cl,byte[mylen]

	mov rsi,data
	mov rdi,data2
	
	cld
	rep cmpsb
	
	or cl,cl
	jnz no_pali
	print msg5,len5
	print msg,len
	jmp pali_done
no_pali:
	print msg6,len6
	print msg,len

pali_done:	
	jmp menu

exit:
	mov rax,0x3C
	mov rdi,0x00
	syscall

;******************************************************

get_length:				;Stores length of data in mylen
	xor rax,rax
	mov rsi,data
	
loop:	
	cmp byte[rsi],0x0A
	je loop1
	inc rsi 
	inc al
	jmp loop
loop1:	
	mov byte[mylen],al
	ret

rev_fun:				;To store reverse of string in data2
	push rsi
	call get_length
	pop rsi
	call get_last
	xor rcx,rcx
	mov cl,byte[mylen]

back_rev:
	mov al,byte[rsi]
	mov byte[rdi],al
	inc rdi
	dec rsi
	dec cl
	jnz back_rev
	ret

get_last:				;Puts position of rsi to the last letter
	mov rsi,data		

back_last:
	cmp byte[rsi],0x0A
	je done_last
	inc rsi
	jmp back_last

done_last:
	dec rsi
	ret 
	

;******************************************************

disp:					;Display routine
back:
	rol qword[result],4
	mov bl,byte[result]
	and bl,0FH
	cmp bl,09H
	jbe next
	add bl,07H
next:
	add bl,30H
	
	mov byte[res],bl
	print res,0x01
	dec byte[cntd]
	jnz back
	ret




