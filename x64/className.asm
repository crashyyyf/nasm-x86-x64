default rel
section .data
	msg:db"Classname is --> '%s'      | 5 second Sleep",10,13,0
	hello:db"wrong title name   |  closing in 5 sec",13,0
	putA:db"write Window name",0
	setTitle:db"finding Classname >"
section .bss
	hwnd:resq 1
	char:resw 256
	readbytes:resd 1
	dda:resq 1
	ddb:resq 1
	buffer:resb 256
	cursor:resd 1
	pInput:resq 1
	pOutput:resq 1
	; GetConsoleScreenBufferInfobufferInfo (*pointer)
	lpconsoleINFO:resq 1
section .text
	global main
	extern GetStdHandle
	extern ReadConsoleA
	extern FindWindowA
	extern GetClassNameA
	extern wsprintfA
	extern WriteConsoleA
	extern ExitProcess
	extern Sleep
	extern GetConsoleScreenBufferInfo
	extern FillConsoleOutputCharacterA
	extern SetConsoleCursorPosition
	extern SetConsoleTextAttribute
	extern SetWindowTextA
	extern GetConsoleWindow
main:
	sub rsp,40
	
	call GetConsoleWindow
	mov rcx,rax
	lea rdx,[setTitle]
	call SetWindowTextA
	
	mov rcx,-10
	call GetStdHandle
	mov [pInput],rax
	
	mov rcx,-11
	call GetStdHandle
	mov [pOutput],rax
	
	mov rcx,[pOutput]
	mov word [cursor],0
	mov word [cursor+2],0
	mov edx,[cursor]
	call SetConsoleCursorPosition
	
	mov rcx,[pOutput]
	mov dx,3
	call SetConsoleTextAttribute
	
	mov rcx,[pOutput]
	lea rdx,[putA]
	mov r8,17
	lea r9,[dda]
	sub rsp,32
	mov qword [rsp+32],0
	call WriteConsoleA
	add rsp,32
	
	mov rcx,[pOutput]
	mov dx,2
	call SetConsoleTextAttribute
	
	mov rcx,[pOutput]
	mov word [cursor],18
	mov word [cursor+2],0
	mov edx,[cursor]
	call SetConsoleCursorPosition
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
	mov rcx,[pInput]
	lea rdx,[char]
	mov r8d,256
	lea r9,[readbytes]
	sub rsp,32
	mov qword [rsp+32],0
	call ReadConsoleA
	add rsp,32
	
	mov eax,[readbytes]
	cmp eax,2
	jb skip
	sub eax,2
	mov [char + eax],0
skip:
	xor rcx,rcx
	lea rdx,[char]
	call FindWindowA
	test rax,rax
	jz fail
	
	mov rcx,rax
	lea rdx,[char]
	mov r8d,256
	call GetClassNameA
	
	mov rcx,[pOutput]
	mov dx,7
	call SetConsoleTextAttribute

	lea rcx,[buffer]
	lea rdx,[msg]
	lea r8,[char]
	call wsprintfA
	mov r15,rax
	
	mov rcx,[pOutput]
	lea rdx,[buffer]
	mov r8,r15
	lea r9,[dda]
	sub rsp,32
	mov qword [rsp+32],0
	call WriteConsoleA
	add rsp,32
	
	mov rcx,5000
    call Sleep
	
	mov rcx,[pOutput]
	lea rdx,[lpconsoleINFO]
	call GetConsoleScreenBufferInfo
	test rax,rax
	jz fail
	
	movzx eax,word [lpconsoleINFO]
	movzx ecx,word [lpconsoleINFO+2]
	imul eax,ecx
	mov r8d,eax
	mov rcx,r13
	mov rdx,32
	xor r9d,r9d
	
	sub rsp,32
	lea rax,[ddb]
	mov qword [rsp+32],rax
	call FillConsoleOutputCharacterA
	add rsp,32
	
	mov rcx,[pOutput]
	mov word [cursor],0
	mov word [cursor+2],0
	mov edx,[cursor]
	call SetConsoleCursorPosition
	
	mov rcx,[pOutput]
	mov dx,2
	call SetConsoleTextAttribute
	
	mov rcx,[pOutput]
	lea rdx,[putA]
	mov r8,17
	lea r9,[dda]
	sub rsp,32
	mov qword [rsp+32],0
	call WriteConsoleA
	add rsp,32
	
	mov rcx,[pOutput]
	mov dx,7
	call SetConsoleTextAttribute
	
	mov rcx,[pOutput]
	mov word [cursor],18
	mov word [cursor+2],0
	mov edx,[cursor]
	call SetConsoleCursorPosition
	
	jmp main
fail:

	mov rcx,[pOutput]
	mov dx,4
	call SetConsoleTextAttribute
	
	mov rcx,[pOutput]
	lea rdx,[hello]
	mov r8,38
	lea r9,[dda]
	sub rsp,32
	mov qword [rsp+32],0
	call WriteConsoleA
	add rsp,32
	
	mov rcx,5000
	call Sleep
	
	add rsp,40
	xor rcx,rcx
	call ExitProcess
