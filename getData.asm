%macro getChar 0
	mov ah, 01h
	int 21h
%endmacro

%macro getDatoUsr 0
	xor si, si
	mov dl, ' '
	%%ciclo:
		getChar
		cmp si, 7
			jae %%fin_ciclo
		cmp al, 0dh
			je %%fin_cicloEnter
		mov usr[si], al
		inc si
		jmp %%ciclo
		
	%%fin_cicloEnter:
		cmp si, 7
		jae %%fin_ciclo
		mov usr[si], dl
		inc si
		jmp %%fin_cicloEnter
		
	%%fin_ciclo:
		salto
%endmacro

%macro getDatoPsw 0
	xor si, si
	mov cl, 0
	%%ciclo:
		getChar
		cmp si, 4
			jae %%fin_ciclo
		cmp al, 0dh
			je %%fin_cicloEnter
		cmp al, 48
			jb %%noNum
		cmp al, 57
			ja %%noNum
		jmp %%continua
		%%noNum:
			mov cl, 1
		%%continua:
		mov psw[si], al
		inc si
		call %%ciclo
		
	%%fin_cicloEnter:
		cmp si, 7
		jae %%fin_ciclo
		mov usr[si], dl
		inc si
		jmp %%fin_cicloEnter
		
	%%fin_ciclo:
		salto
%endmacro


%macro resetUsr 0
	xor si, si
	xor al, al
	%%ciclo:
		cmp si, 7	
			jae %%fin_ciclo
		mov usr[si], al
		inc si
		call %%ciclo
	%%fin_ciclo:
%endmacro

%macro resetPsw 0
	xor si, si
	xor al, al
	%%ciclo:
		cmp si, 4	
			jae %%fin_ciclo
		mov psw[si], al
		inc si
		call %%ciclo
	%%fin_ciclo:
%endmacro