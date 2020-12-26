section .data
;---------------------------------------------------------------
;-----------------------------EXTRA-----------------------------
;---------------------------------------------------------------
	pts db '**********************************', 10, 13, '$'
	ads db 'SALIENDO DEL SISTEMA....ADIOS...', 10, 13, '$'
	slt db 0dh, 0ah, '$'
	
;---------------------------------------------------------------
;-----------------------------MAINs-----------------------------
;---------------------------------------------------------------
	m_1 db 'BIENVENIDO - SELECCIONE UNA OPCION', 10, 13, '$'
	m_2 db '   1 - Ingresar', 10, 13, '$'
	m_3 db '   2 - Registrar', 10, 13, '$'
	m_4 db '   3 - Salir', 10, 13, '$'
	
;---------------------------------------------------------------
;------------------------LOGIN/REGISTRAR------------------------
;---------------------------------------------------------------
	l_1 db '-------- INGRESO --------', 10, 13, '$'
	l_2 db '-------- REGISTRO --------', 10, 13, '$'
	l_3 db 'Nombre de usuario:', 10, 13, '$'
	l_4 db 'Contrasenha:', 10, 13, '$'
	
;---------------------------------------------------------------
;----------------------------Errores----------------------------
;---------------------------------------------------------------
	er_Main db 'ERROR, seleccione un dato del 1 al 3', 10, 13, '$'
	er_Ingr db 'ERROR, usuario o contrasenha incorrecta', 10, 13, '$'
	er_IngrPsw db 'ERROR, contrasenha solo debe de ser numerica', 10, 13, '$'
	
;---------------------------------------------------------------
;-----------------------------DATAS-----------------------------
;---------------------------------------------------------------
	usr db 8 dup('$'), '$'
	psw db 5 dup('$'), '$'