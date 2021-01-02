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
	mov dl, ' '
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
		jmp %%ciclo
		
	%%fin_cicloEnter:
		cmp si, 4
		jae %%fin_ciclo
		mov psw[si], dl
		inc si
		jmp %%fin_cicloEnter
		
	%%fin_ciclo:
		salto
%endmacro

%macro getDatoPth 0
	xor si, si
	%%ciclo:
		getChar
		cmp al, 0dh
			je %%fin_ciclo
		mov pth[si], al
		inc si
		jmp %%ciclo
		
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

%macro resetTexto 0
	xor si, si
	mov al, '$'
	%%ciclo:
		cmp si, 255
			jae %%fin_ciclo
		mov texto[si], al
		inc si
		call %%ciclo
	%%fin_ciclo:
%endmacro

%macro resetPth 0
	xor si, si
	mov al, 0
	%%ciclo:
		cmp si, 255
			jae %%fin_ciclo
		mov pth[si], al
		inc si
		call %%ciclo
	%%fin_ciclo:
%endmacro

%macro setDatoPts1 0
	mov ah, 'p'
	mov f_pts[0], ah
	mov ah, 't'
	mov f_pts[1], ah
	mov ah, 's'
	mov f_pts[2], ah
	mov ah, '/'
	mov f_pts[3], ah
	mov ah, '.'
	mov f_pts[11], ah
	mov ah, 'p'
	mov f_pts[12], ah
	mov ah, 't'
	mov f_pts[13], ah
	mov ah, 's'
	mov f_pts[14], ah
%endmacro
%macro setDatoPts 0
	mov si, 4
	mov di, 0
	mov ah, '.'
	%%ciclo:
		cmp f_pts[si], ah
			je %%fin_ciclo
		mov al, usr[di]
		mov f_pts[si], al
		inc si
		inc di
		call %%ciclo
	%%fin_ciclo:
%endmacro