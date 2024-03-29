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
	l_5 db 'USUARIO REGISTRADO CON EXITO', 10, 13, '$'
	
;---------------------------------------------------------------
;--------------------------ENCABEZADOS--------------------------
;---------------------------------------------------------------
	e_1 db 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA ', 10, 13, '$'
	e_2 db 'FACULTAD DE INGENIERIA ', 10, 13, '$'
	e_3 db 'CIENCIAS Y SISTEMAS ', 10, 13, '$'
	e_4 db 'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 ', 10, 13, '$'
	e_5 db 'NOMBRE: CHRISTOFER WILLIAM BORRAYO LOPEZ ', 10, 13, '$'
	e_6 db 'CARNET: 201602719 ', 10, 13, '$'
	e_7 db 'SECCION: A ', 10, 13, '$'
	
;---------------------------------------------------------------
;-----------------------------ADMIN-----------------------------
;---------------------------------------------------------------
	a_1 db '   1 - Top 10 puntos', 10, 13, '$'
	a_2 db '   2 - Top 10 tiempo', 10, 13, '$'
	a_3 db '   3 - Salir', 10, 13, '$'	
	
;---------------------------------------------------------------
;--------------------------DATA TOP 10--------------------------
;---------------------------------------------------------------
	t_p   db '------------- TOP 10 PUNTOS -------------', 10, 13, '$'
	t_p2  db 'TOP 10 POR PUNTUACION', 10, 13, '$'
	t_t   db '------------- TOP 10 TIEMPO -------------', 10, 13, '$'
	t_ep  db 'No.     USUARIO       NIVEL        PUNTOS', 10, 13, '$'
	t_et  db 'No.     USUARIO       NIVEL        TIEMPO', 10, 13, '$'
	t_or  db 'ORD:', 10, 13, '$'
	t_orB db 'BUBBLESORT', 10, 13, '$'
	t_orQ db 'QUICKSORT', 10, 13, '$'
	t_tmp db 'TIEMPO:', 10, 13, '$'
	t_vel db 'VEL:', 10, 13, '$'
	
	t_txt db 42 dup('$'), '$'
    ;t_txt db '1       1234567         0           0000 ', 10, 13, '$'
	;          1234567890123456789012345678901234567890
	;		   0        1         2         3		  4
	tcant dw 0, '$'
	
	;usuario n 0000 tmps
	;1234567 8 9012 3456
	ar_desor db 120 dup('$'), '$'
	ar_liaux db 12 dup('$'), '$'
	ar_linea db 12 dup('$'), '$'
	ar_auxil db 4 dup('$'), '$'
	;0123 -- NUMEROS
	
;---------------------------------------------------------------
;-----------------------------USERS-----------------------------
;---------------------------------------------------------------
	u_1 db '   1 - Iniciar juego', 10, 13, '$'
	u_2 db '   2 - Cargar juego', 10, 13, '$'
	u_3 db '   3 - Salir', 10, 13, '$'	
	
;---------------------------------------------------------------
;-----------------------------JUEGO-----------------------------
;---------------------------------------------------------------
	j_1 db 'INGRESE EL NOMBRE DEL ARCHIVO.pla ', 10, 13, '$'
	
;---------------------------------------------------------------
;-----------------------------pruebas-----------------------------
;---------------------------------------------------------------
	p_1 db ' LEYENDO .PLAY', 10, 13, '$'
	p_2 db '  NOMBRE:', 10, 13, '$'
	p_3 db ' AQUI LLEGA', 10, 13, '$'
	
;---------------------------------------------------------------
;----------------------------Errores----------------------------
;---------------------------------------------------------------
	er_Main db 'ERROR, seleccione un dato del 1 al 3', 10, 13, '$'
	er_Ord db 'ERROR, seleccione una opcion del 1 al 2', 10, 13, '$'
	er_Vel db 'ERROR, seleccione un valor del 1 al 9', 10, 13, '$'
	er_Psw db 'ERROR, contrasenha solo debe de ser numerica', 10, 13, '$'
	er_Usr db 'ERROR, usuario ya existe', 10, 13, '$'
	er_IngU db 'ERROR, usuario incorrecto', 10, 13, '$'
	er_IngP db 'ERROR, contrasenha incorrecto', 10, 13, '$'
	er_Jue db 'ERROR, debe cargar un juego .play', 10, 13, '$'
	er_Adm db 'ERROR, no existen datos a mostrar', 10, 13, '$'
	
;---------------------------------------------------------------
;-----------------------------DATAS-----------------------------
;---------------------------------------------------------------
	usr db 8 dup('$'), '$'
	psw db 5 dup('$'), '$'
	
	
;---------------------------------------------------------------
;-----------------------------JUEGO-----------------------------
;---------------------------------------------------------------
	pth db 255 dup(0), '$'	;RUTA CARGA JUEGO
	
	nv_ db 'Nv:', '$'			;PALABRA NV:
	nv0 db 0, '$'				;NUMERO DE NIVEL ACTUAL
	nvM db 0,"$"				;NIVEL MAXIMO
	
	ptn db 0, '$'				;PUNTOS
	
	t_mi db 2 dup ('$'), '$'	;TIEMPO MICROSEGUNDOS 0 - 9
	t_s db 2 dup ('$'), '$'		;TIEMPO SEGUNDOS
	t_m db 2 dup ('$'), '$'		;TIEMPO MINUTOS
	
	segs db 0, '$'		;TIEMPO SEGUNDOS ACTUALES
	segAct db 0, '$'		;TIEMPO SEGUNDOS ACTUALES
	segMax db 0, '$'		;TIEMPO SEGUNDOS MAXIMOS

	uni 			db 0,"$"	;UNIDAD
	dece 			db 0,"$"	;DECENA
	dosP 			db 0,"$"	;DOS PUNTOS
	
	vel dw 20					;VELOCIDAD
	perdido db 1				;VARIABLE QUE INDICA QUE NO HAS PERDIDO
	
;---------------------------------------------------------------
;----------------------------SPRITES----------------------------
;---------------------------------------------------------------
;----------------------------CARROS-----------------------------
	CoordX_car 			dw 155
	CoordY_car 			dw 165
	car_f1  DB  27,27,27,12,12,12,27,27,27
	car_f2  DB  27,27,12,15,15,15,12,27,27
	car_f3  DB  17,12,12,15,15,15,12,12,17
	car_f4  DB  19, 4,12,15,15,15,12, 4,19
    car_f5  DB  17,12, 8,17, 8, 8, 8,12,17
    car_f6  DB  27, 4,19,19,18, 8, 8, 4,27
    car_f7  DB  27, 4, 8,17,17,18, 8, 4,27
    car_f8  DB  27, 4,12,15,15,15,12, 4,27
    car_f9  DB  27, 4,12,30,31,31,12, 4,27
	car_f10 DB  27, 4,12,30,30,15,12, 4,27 
	car_f11 DB  17, 4,12,15,15,15,12, 4,17
	car_f12 DB  19,12,31,31,15,15,15,12,19
	car_f13 DB  17,12,31,30,30,30,30,12,17 
	car_f14 DB  27, 4,14,12,12,12,14, 4,27 

;------------------------ESTRELLA BUENA-------------------------
	pre_pts  	dw 0					;PUNTOS QUE DA
	pre_tmp  	dw 0					;TIEMPO PARA QUE APAREZCA 
	pre_tmpAnt  dw 0					;TIEMPO QUE HA PASADO
	
	pre_CoordY1	dw 0
	pre_CoordY2	dw 0
	pre_CoordY3	dw 0
	pre_CoordY4	dw 0
	pre_CoordY5	dw 0
	
	pre_CoordX1	dw 50
	pre_CoordX2	dw 250
	pre_CoordX3	dw 100
	pre_CoordX4	dw 200
	pre_CoordX5	dw 150
	
	stb_1  DB  44,27,27,27,43,27,27,27,44
	stb_2  DB  27,14,27,27,42,27,27,14,27
	stb_3  DB  27,27,14,27,27,27,14,27,27
	stb_4  DB  27,27,27,27,44,27,27,27,27
	stb_5  DB  43,42,27,44,27,44,27,42,43
	stb_6  DB  27,27,27,27,44,27,27,27,27
	stb_7  DB  27,27,14,27,27,27,14,27,27
	stb_8  DB  27,14,27,27,42,27,27,14,27
	stb_9  DB  44,27,27,27,43,27,27,27,44
;------------------------ESTRELLA  MALA-------------------------
	obs_pts  	dw 0					;PUNTOS QUE DA
	obs_tmp  	dw 0					;TIEMPO PARA QUE APAREZCA 
	obs_tmpAnt  dw 0					;TIEMPO QUE HA PASADO
	
	obs_CoordY1	dw 0
	obs_CoordY2	dw 0
	obs_CoordY3	dw 0
	obs_CoordY4	dw 0
	obs_CoordY5	dw 0
	
	obs_CoordX1	dw 150
	obs_CoordX2	dw 200
	obs_CoordX3	dw 50
	obs_CoordX4	dw 250
	obs_CoordX5	dw 100
	
	stm_1  DB  47,27,27,27,45,27,27,27,47
	stm_2  DB  27,02,27,27,46,27,27,02,27
	stm_3  DB  27,27,02,27,27,27,02,27,27
	stm_4  DB  27,27,27,27,47,27,27,27,27
	stm_5  DB  45,46,27,47,27,47,27,46,45
	stm_6  DB  27,27,27,27,47,27,27,27,27
	stm_7  DB  27,27,02,27,27,27,02,27,27
	stm_8  DB  27,02,27,27,46,27,27,02,27
	stm_9  DB  47,27,27,27,45,27,27,27,47
;---------------------------------------------------------------
;----------------------------GRAFICA----------------------------
;---------------------------------------------------------------
	g_1 db 'SELECCIONE UN ORDENAMIENTO: ', 10, 13, '$'
	g_2 db '1.- Ordenamiento BubbleSort', 10, 13, '$'
	g_3 db '2.- Ordenamiento QuickSort', 10, 13, '$'
	g_4 db 'SELECCIONE UNA FORMA: ', 10, 13, '$'
	g_5 db '1.- DESCENDENTE', 10, 13, '$'
	g_6 db '2.- ASCENDENTE', 10, 13, '$'
	
	v_1 db 'INGRESE UNA VELOCIDAD (0 - 9): ', 10, 13, '$'
	
	;usuario n 0000
	;1234567 8 9012
	;ar_desor db 120 dup('$'), '$'
	as_des dw 0, '$'
	color dw 0, '$'
	alt_Aux db 4 dup('$'), '$'
	alt_max dw 0, '$'				;ALTURA MAXIMA
	altura dw 0, '$'					;ALTURA MAXIMA ES DE 140 EMPEZANDO EN 175 POR EL MARGEN DE 5 EN ALTURA
								;PARA UNA PUNTACION A MAXIMA DE B LA ALTURA ES DE (140*C)/C_MAX
								;Y INICIAL = (25+140)-ALTURA
								
	ancho dw 0, '$'					;ANCHO DE LAS BARRAS, EL ANCHO MAXIMO ES 280 CON 5 DE MARGEN A CADA LADO
								;PARA X BARRAS EL ANCHO ES DE (290 - (X+1)*5)/X DONDE X ES LA CANTIDAD DE BARRAS
								;X = 1  --->  ANCHO = 280
								;X = 2  --->  ANCHO = 137
								;X = 3  --->  ANCHO = 90
								;X = 4  --->  ANCHO = 66
								;X = 5  --->  ANCHO = 52
								;X = 6  --->  ANCHO = 42
								;X = 7  --->  ANCHO = 35
								;X = 8  --->  ANCHO = 30
								;X = 9  --->  ANCHO = 26
								;X = 10 --->  ANCHO = 23
								;X INICIAL = (25 + X*5 + (X-1)*ANCHO)
;---------------------------------------------------------------
;----------------------------ARCHIVO----------------------------
;---------------------------------------------------------------
	f_user db 'files/users.usr', 0
	f_pts db 'files/puntaje.pts', 0
	f_rep db 'files/Puntos.rep', 0
	texto times 255 dw '$'