.global programa #75430
.data
fin:   
  .string  "C:\\micro\\test3.txt"  # direcci�n del archivo a probar
asol:
  .string "C:\\micro\\solucion.txt" # direcci�n del archivo donde se almacenar� la salida
error:
  .string  "No se ha podido abrir el archivo"  # mensaje de error si no se puede abrir el archivo
filas:
  .byte 0  # variable para almacenar el n�mero de filas del laberinto
cols:
  .byte 0  # variable para almacenar el n�mero de columnas del laberinto
posent:
  .byte 0  # posici�n de entrada en el laberinto
dirent:
  .byte 0  # direcci�n de entrada (A, B, C, D)
possal:
  .byte 0  # posici�n de salida en el laberinto
dirsal:
  .byte 0  # direcci�n de salida (A, B, C, D)
posx:
  .byte 0  # posici�n actual en el eje x
posy:
  .byte 0  # posici�n actual en el eje y
dir:
  .byte 0  # direcci�n actual del robot
matriz:
  .string "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"  # matriz que representa el laberinto, inicializada con ceros
solu:
  .string "Salida exitosa$"  # mensaje de �xito
nosolu:
  .string "Salida inaccesible$"  # mensaje de fracaso
buffer:
  .string ""  # buffer para almacenar datos temporales
.text
programa:

.macro posBuffer()
    li t1,10  # cargar el valor 10 en t1 para operaciones de divisi�n
    addi t3,t3,1 # sumar 1 a t3 para ajustar de posici�n a n�mero de celda
    div t4,t3,t1 # dividir t3 entre 10 para obtener las decenas en t4
    add t5,a1,a2 # calcular la posici�n actual en el buffer (t5 = a1 + a2)
    beq t4,t1,centenapb # si las decenas son 10, significa que estamos en la posici�n 100
    addi t4,t4,48 # convertir el n�mero de decenas en su car�cter ASCII correspondiente
    sb t4,0(t5) # almacenar el car�cter de las decenas en el buffer
    addi t5,t5,1 # mover el puntero del buffer a la siguiente posici�n
    addi a2,a2,1 # incrementar el contador de posici�n en el buffer
    addi t4,t4,-48 # convertir el car�cter de vuelta a su valor num�rico
    mul t6,t4,t1 # calcular el valor de las decenas multiplic�ndolas por 10
    sub t0,t3,t6 # restar las decenas al n�mero original para obtener las unidades
    addi t0,t0,48 # convertir las unidades en su car�cter ASCII
    sb t0,0(t5) # almacenar el car�cter de las unidades en el buffer
    addi t5,t5,1 # mover el puntero del buffer a la siguiente posici�n
    addi a2,a2,1 # incrementar el contador de posici�n en el buffer
    j salirpb # saltar al final de la macro
centenapb:
    li t1,'1' # cargar el car�cter '1' en t1
    sb t1,0(t5) # guardar el '1' en el buffer para las centenas
    li t1,'0' # cargar el car�cter '0' en t1
    addi t5,t5,1 # mover el puntero del buffer a la siguiente posici�n
    addi a2,a2,1 # incrementar el contador de posici�n en el buffer
    sb t1,0(t5) # insertar '0' en el buffer para las decenas
    addi t5,t5,1 # mover el puntero del buffer a la siguiente posici�n
    addi a2,a2,1 # incrementar el contador de posici�n en el buffer
    sb t1,0(t5) # insertar '0' en el buffer para las unidades
    addi t5,t5,1 # mover el puntero del buffer a la siguiente posici�n
    addi a2,a2,1 # incrementar el contador de posici�n en el buffer
salirpb:
.end_macro 

.macro hayMuro()
    add t0, x0, x0 # vaciar registros temporales t0 - t4
    add t1, x0, x0 
    add t2, x0, x0
    add t3, x0, x0
    add t4, x0, x0
    mul t6,a4,a6 # calcular t6 = posy * n�mero de columnas (a6)
    add t3,x0,t6 # t3 = offset en la matriz por la posici�n y
    add t3,t3,a3 # t3 = offset total sumando posici�n x
    posBuffer() # llamar a posBuffer para actualizar el buffer con la posici�n actual
    addi t3,t3,-1 # ajustar t3 restando 1 para la posici�n correcta
    add t6,a0,t3 # t6 = direcci�n de la posici�n exacta del robot en la matriz
    lb t6,0(t6) # cargar el valor de la celda en t6 (indica presencia de muros)
    add t1, x0, x0 # vaciar registros temporales nuevamente
    add t2, x0, x0
    add t3, x0, x0
    add t4, x0, x0
hayDh:
    addi t5,x0,8 # t5 = 8 (valor asociado a muro en direcci�n 'D')
    blt t6,t5,hayCh # si t6 < 8, ir a hayCh
    sub t6,t6,t5 # restar 8 de t6
    li t1,1 # indicar que hay muro en direcci�n 'D' asignando 1 a t1
hayCh:
    addi t5,x0,4 # t5 = 4 (valor asociado a muro en direcci�n 'C')
    blt t6,t5,hayBh # si t6 < 4, ir a hayBh
    sub t6,t6,t5 # restar 4 de t6
    li t2,1 # indicar que hay muro en direcci�n 'C' asignando 1 a t2
hayBh:
    addi t5,x0,2 # t5 = 2 (valor asociado a muro en direcci�n 'B')
    blt t6,t5,hayAh # si t6 < 2, ir a hayAh
    sub t6,t6,t5 # restar 2 de t6
    li t3,1 # indicar que hay muro en direcci�n 'B' asignando 1 a t3
hayAh:
    addi t5,x0,1 # t5 = 1 (valor asociado a muro en direcci�n 'A')
    blt t6,t5,comprobarh # si t6 < 1, ir a comprobarh
    li t4,1 # indicar que hay muro en direcci�n 'A' asignando 1 a t4
comprobarh: # comprobar en qu� direcci�n est� mirando el robot
    li t6,'A'
    beq t6,a5,esAh # si el robot mira hacia 'A', saltar a esAh
    li t6,'B'
    beq t6,a5,esBh # si el robot mira hacia 'B', saltar a esBh
    li t6,'C'
    beq t6,a5,esCh # si el robot mira hacia 'C', saltar a esCh
    li t6,'D'
    beq t6,a5,esDh # si el robot mira hacia 'D', saltar a esDh
    j errorh # si no coincide con ninguna direcci�n, saltar a errorh
esAh:
    mv t0,t4 # mover el estado del muro en direcci�n 'A' a t0
    j validh
esBh:
    mv t0,t3 # mover el estado del muro en direcci�n 'B' a t0
    j validh
esCh:
    mv t0,t2 # mover el estado del muro en direcci�n 'C' a t0
    j validh
esDh:
    mv t0,t1 # mover el estado del muro en direcci�n 'D' a t0
    j validh
errorh:
    # direcci�n del robot no v�lida
    j salirh
validh:
    add t5,a1,a2 # calcular la direcci�n actual del buffer (t5 = a1 + a2)
    addi a2,a2,1 # incrementar el contador del buffer
    sb a5,0(t5) # almacenar la direcci�n actual del robot en el buffer
    addi a2,a2,1 # incrementar el contador del buffer
    addi t5,t5,1 # mover el puntero del buffer
    li t3,32 # cargar el car�cter espacio ' ' en t3
    sb t3,0(t5) # almacenar el espacio en el buffer
salirh:
.end_macro 

.macro girarIzquierda()
    add t1, x0, x0 # vaciar registros temporales t1 - t4
    add t2, x0, x0
    add t3, x0, x0
    add t4, x0, x0
    la t1,dir # cargar la direcci�n de la variable 'dir' que almacena la direcci�n del robot
    # comprobar en qu� direcci�n est� mirando el robot y asignar la nueva direcci�n al girar a la izquierda
    li t6,'A'
    beq t6,a5,esAgi # si mira hacia 'A', saltar a esAgi
    li t6,'B'
    beq t6,a5,esBgi # si mira hacia 'B', saltar a esBgi
    li t6,'C'
    beq t6,a5,esCgi # si mira hacia 'C', saltar a esCgi
    li t6,'D'
    beq t6,a5,esDgi # si mira hacia 'D', saltar a esDgi
    j errorgi # si no coincide con ninguna direcci�n, saltar a errorgi
esAgi:
    li t6,'D' # nueva direcci�n al girar desde 'A' es 'D'
    sb t6,0(t1) # almacenar la nueva direcci�n en 'dir'
    mv a5,t6 # actualizar a5 con la nueva direcci�n
    j salirgi
esBgi:
    li t6,'A' # nueva direcci�n al girar desde 'B' es 'A'
    sb t6,0(t1)
    mv a5,t6
    j salirgi
esCgi:
    li t6,'B' # nueva direcci�n al girar desde 'C' es 'B'
    sb t6,0(t1)
    mv a5,t6
    j salirgi
esDgi:
    li t6,'C' # nueva direcci�n al girar desde 'D' es 'C'
    sb t6,0(t1)
    mv a5,t6
    j salirgi
errorgi:
    # direcci�n del robot no v�lida
    j salirgi
salirgi:
.end_macro 

.macro girarDerecha()
    add t1, x0, x0 # vaciar registros temporales t1 - t4
    add t2, x0, x0
    add t3, x0, x0
    add t4, x0, x0
    la t1,dir # cargar la direcci�n de la variable 'dir' que almacena la direcci�n del robot
    # comprobar en qu� direcci�n est� mirando el robot y asignar la nueva direcci�n al girar a la derecha
    li t6,'A'
    beq t6,a5,esAgd # si mira hacia 'A', saltar a esAgd
    li t6,'B'
    beq t6,a5,esBgd # si mira hacia 'B', saltar a esBgd
    li t6,'C'
    beq t6,a5,esCgd # si mira hacia 'C', saltar a esCgd
    li t6,'D'
    beq t6,a5,esDgd # si mira hacia 'D', saltar a esDgd
    j errorgd # si no coincide con ninguna direcci�n, saltar a errorgd
esAgd:
    li t6,'B' # nueva direcci�n al girar desde 'A' es 'B'
    sb t6,0(t1) # almacenar la nueva direcci�n en 'dir'
    mv a5,t6 # actualizar a5 con la nueva direcci�n
    j salirgd 
esBgd:
    li t6,'C' # nueva direcci�n al girar desde 'B' es 'C'
    sb t6,0(t1)
    mv a5,t6
    j salirgd
esCgd:
    li t6,'D' # nueva direcci�n al girar desde 'C' es 'D'
    sb t6,0(t1)
    mv a5,t6
    j salirgd
esDgd:
    li t6,'A' # nueva direcci�n al girar desde 'D' es 'A'
    sb t6,0(t1)
    mv a5,t6
    j salirgd
errorgd:
    # direcci�n del robot no v�lida
    j salirgd
salirgd:
.end_macro 

.macro avanzar()
    # Limpiar registros temporales
    add t0, x0, x0
    add t1, x0, x0
    add t2, x0, x0
    add t3, x0, x0
    add t4, x0, x0
    add t5, x0, x0
    add t6, x0, x0

    # Cargar posici�n de salida y comparar con la posici�n actual
    la t5, possal    # cargar la direcci�n de 'possal' en t5
    lb t1, 0(t5)     # cargar el valor de 'possal' en t1
    # Calcular la posici�n actual del robot
    mul t2, a4, a6   # t2 = posy * n�mero de columnas (a6)
    add t3, t2, a3   # t3 = posici�n total en la matriz
    addi t3, t3, 1   # ajustar a �ndice basado en 1
    beq t3, t1, ganara # si la posici�n actual coincide con la salida, ir a ganara

    # Comprobar la direcci�n actual del robot para determinar el movimiento
    li t0, 'A'
    beq t0, a5, esAa   # si la direcci�n es 'A', ir a esAa
    li t0, 'B'
    beq t0, a5, esBa   # si la direcci�n es 'B', ir a esBa
    li t0, 'C'
    beq t0, a5, esCa   # si la direcci�n es 'C', ir a esCa
    li t0, 'D'
    beq t0, a5, esDa   # si la direcci�n es 'D', ir a esDa
    j errorDa          # si no coincide con ninguna direcci�n, ir a errorDa

    # Movimiento hacia la izquierda (A)
esAa:
    beqz a3, bordea     # si posx es 0, est� en el borde izquierdo
    addi a3, a3, -1     # mover hacia la izquierda disminuyendo posx
    j valida

    # Movimiento hacia arriba (B)
esBa:
    addi a4, a4, 1      # mover hacia arriba incrementando posy
    bge a4, a7, bordeay # si posy >= filas, est� en el borde superior
    j valida

    # Movimiento hacia la derecha (C)
esCa:
    addi a3, a3, 1      # mover hacia la derecha incrementando posx
    bge a3, a6, bordeax # si posx >= columnas, est� en el borde derecho
    j valida

    # Movimiento hacia abajo (D)
esDa:
    addi a4, a4, 1       # mover hacia abajo incrementando posy
    bge a4, a7, bordea   # si posy >= filas, est� fuera del borde
    j valida

errorDa:
    # Direcci�n del robot no v�lida
    j salira

bordeay:                 # Manejo de borde superior
    addi a4, a4, -1      # revertir el incremento en posy
    j bordea

bordeax:                 # Manejo de borde derecho
    addi a3, a3, -1      # revertir el incremento en posx
    j bordea

bordea:
    # Calcular el �ndice de la posici�n actual del robot en la matriz
    mul t2, a4, a6       # t2 = posy * n�mero de columnas
    add t5, t2, a3       # t5 = �ndice en la matriz
    addi t5, t5, 1       # ajustar a �ndice basado en 1

    # Obtener y cargar la posici�n de salida para comparar
    la t4, possal        # cargar la direcci�n de 'possal' en t4
    lb t3, 0(t4)         # cargar el valor de 'possal' en t3

    # Comparar la posici�n actual con la posici�n de salida
    beq t3, t5, ganara   # si coinciden, ir a ganara

    # Verificar si el robot ha vuelto a la entrada
    la t4, posent        # cargar la direcci�n de 'posent' en t4
    lb t3, 0(t4)         # cargar el valor de 'posent' en t3
    beq t3, t5, perdera  # si coincide, ir a perdera

    # Si no se ha alcanzado ni la salida ni la entrada, continuar
    j errorSa            # salir con error si se sale del mapa sin soluci�n

ganara:
    # Detener el robot en la celda de salida y marcar como �xito
    la t1, solu          # cargar el mensaje de "Salida exitosa"
    j imprimira          # ir a imprimir el mensaje y terminar

perdera:
    # Imprimir mensaje de salida inaccesible si se regresa a la entrada
    la t1, nosolu        # cargar el mensaje de "Salida inaccesible"
    j imprimira          # ir a imprimir el mensaje y terminar

errorSa:
    # Error si se detecta una salida sin encontrar la celda de salida
    j salira

imprimira:
    add t2,a1,a2 # calcular la direcci�n actual del buffer
    li t4,'$'    # car�cter que indica el fin del mensaje
printSolua:
    lb t3,0(t1) # cargar el car�cter actual del mensaje
    beq t4,t3,salirpa # si es '$', fin del mensaje
    sb t3,0(t2) # almacenar el car�cter en el buffer
    addi t1,t1,1 # avanzar al siguiente car�cter del mensaje
    addi t2,t2,1 # avanzar en el buffer
    addi a2,a2,1 # incrementar el contador del buffer
    j printSolua # repetir hasta terminar el mensaje
valida:
    la t5,posx   # cargar la direcci�n de 'posx'
    sb a3,0(t5)  # actualizar 'posx' con la nueva posici�n
    la t5,posy   # cargar la direcci�n de 'posy'
    sb a4,0(t5)  # actualizar 'posy' con la nueva posici�n
    mul t2,a4,a6 # t2 = posy * n�mero de columnas
    add t3,x0,t2 # t3 = t2
    add t3,t3,a3 # t3 += posx
    posBuffer()  # actualizar el buffer con la nueva posici�n
    add t4,a1,a2 # calcular la direcci�n actual del buffer
    sb a5,0(t4)  # almacenar la direcci�n actual del robot en el buffer	
    addi a2,a2,1 # incrementar el contador del buffer
    addi t4,t4,1 # avanzar en el buffer
    li t3,32     # cargar el car�cter espacio ' '
    sb t3,0(t4)  # almacenar el espacio en el buffer
    addi a2,a2,1 # incrementar el contador del buffer
    add t0, x0, x0 # vaciar t0
    j salira
salirpa:
    li t0,1      # indicar que se ha completado el avance
salira:
.end_macro 

.macro reconFilCol() # Obtener el valor num�rico a partir de 2 d�gitos en caracteres
    obtenerChar(t0) # obtener el car�cter en la posici�n actual del buffer
    mv a4,t4        # guardar el car�cter en a4
    addi t0, t0, 1  # avanzar la posici�n del buffer
    obtenerChar(t0) # obtener el siguiente car�cter
    mv a5,t4        # guardar el car�cter en a5
    addi a4,a4,-48  # convertir el car�cter a su valor num�rico
    addi a5,a5,-48  # convertir el car�cter a su valor num�rico
    beqz a4, unidadesrf # si las decenas son 0, asignar solo las unidades
    li t6,1
    bne a4,t6 errorrf # si las decenas no son 1, error (valor mayor a 10)
    bnez a5, errorrf # si las unidades no son 0, error (valor mayor a 10)
    addi a6,x0,10	# asignar 10 al resultado
    j salirrf
errorrf:
    # El n�mero de fila o columna es mayor a 10
    j salirrf
unidadesrf:
    add a6,x0,a5 # asignar las unidades al resultado
salirrf:
.end_macro

.macro reconNumber() # Obtener el valor num�rico a partir de una posici�n en el buffer
    obtenerChar(t0) # obtener el car�cter en la posici�n actual del buffer
    mv a2,t4        # guardar el car�cter en a2
    addi t0, t0, 1  # avanzar la posici�n del buffer
    obtenerChar(t0) # obtener el siguiente car�cter
    mv a3,t4        # guardar el car�cter en a3
    addi a2,a2,-48  # convertir el car�cter a su valor num�rico
    addi a3,a3,-48  # convertir el car�cter a su valor num�rico
    li a5,1         # a5 = 1
    bne a2,a5,decenasrn # si el primer d�gito no es 1, ir a decenasrn
    bnez a3,decenasrn   # si el segundo d�gito no es 0, ir a decenasrn
    addi t0, t0, 1  # avanzar la posici�n del buffer
    obtenerChar(t0) # obtener el siguiente car�cter
    mv a5,t4        # guardar el car�cter en a5
    addi a5,a5,-48  # convertir el car�cter a su valor num�rico
    bnez a5,nocentrn # si el tercer d�gito no es 0, ir a nocentrn
    addi a6,x0,100  # asignar 100 al resultado
    j salirrn
nocentrn:
    addi t0,t0,-1   # revertir el avance del puntero
decenasrn:
    li a5,10
    mul a4,a5,a2    # calcular las decenas
    add a6,x0,a4    # asignar las decenas al resultado
    add a6,a6,a3    # sumar las unidades al resultado
salirrn:
.end_macro
    	
.macro obtenerChar(%pos) # obtener el car�cter en la posici�n del buffer
    add t2, a0, %pos # calcular la direcci�n en el buffer
    lb t4,0(t2)      # cargar el car�cter en t4
.end_macro 

# Inicio del programa principal
la   s0, buffer   # cargar la direcci�n del buffer en s0
li   s1, 1        # s1 = 1 (cantidad de caracteres a leer)

la   a0, fin      # cargar la direcci�n del archivo de entrada en a0
li   a1, 0        # a1 = 0 para abrir en modo lectura
li   a7, 1024     # syscall para abrir archivo
ecall             # llamada al sistema

bltz a0, errorlectura # si a0 < 0, error al abrir el archivo
mv   s6, a0        # guardar el descriptor del archivo en s6

ciclolectura:
    mv   a0, s6       # cargar el descriptor del archivo en a0
    mv   a1, s0       # cargar la direcci�n del buffer en a1
    mv   a2, s1       # cargar la cantidad de caracteres a leer en a2
    li   a7, 63       # syscall para leer archivo
    ecall             # llamada al sistema

    bltz a0, cerrararchivo # si error al leer, cerrar el archivo
    mv   t0, a0       
    add  t1, s0, a0   
    sb   zero, 0(t1)  # a�adir terminador nulo al final del buffer

    # Impresi�n de lo que se ha le�do (comentado)
    # mv   a0, s0
    # li   a7, 4
    # ecall
    addi s0,s0,1      # avanzar el puntero del buffer
    beq  t0, s1, ciclolectura # si se ley� correctamente, repetir
cerrararchivo: 
    mv   a0, s6       # cargar el descriptor del archivo en a0
    li   a7, 57       # syscall para cerrar archivo
    ecall             # llamada al sistema para cerrar el archivo

# EMPIEZA EL PROYECTO
# Reconocer los primeros par�metros desde el archivo
add t0, x0, x0 # limpiar registros temporales t0 - t4 y a0 - a7
add t1, x0, x0
add t2, x0, x0
add t3, x0, x0
add t4, x0, x0
add a0, x0, x0
add a1, x0, x0
add a2, x0, x0
add a3, x0, x0
add a4, x0, x0
add a5, x0, x0
add a6, x0, x0
add a7, x0, x0
# Asignar filas
la a0, buffer    # cargar la direcci�n del buffer en a0
reconFilCol()    # llamar a reconFilCol para obtener el n�mero de filas
la a1, filas     # cargar la direcci�n de 'filas' en a1
sb a6, 0(a1)     # almacenar el valor de filas en la variable 'filas'
# Asignar columnas
addi t0, t0, 2   # avanzar el puntero t0 en 2 posiciones
reconFilCol()    # llamar a reconFilCol para obtener el n�mero de columnas
la a1, cols      # cargar la direcci�n de 'cols' en a1
sb a6, 0(a1)     # almacenar el valor de columnas en la variable 'cols'
# Asignar posici�n de entrada
addi t0, t0, 2   # avanzar el puntero t0 en 2 posiciones
reconNumber()    # llamar a reconNumber para obtener la posici�n de entrada
la a1, posent    # cargar la direcci�n de 'posent' en a1
sb a6, 0(a1)     # almacenar el valor en la variable 'posent'
la a1,filas
lb a2,0(a1)      # cargar el valor de 'filas' en a2
div a3,a6,a2     # calcular posy = posent / filas
la a1, posy
sb a3,0(a1)      # almacenar posy en la variable 'posy'
mul a4,a3,a2     # calcular el offset por posici�n y
sub a6,a6,a4     # calcular posx = posent - offset
addi a6,a6,-1    # ajustar posx para �ndice base 0
la a1, posx
sb a6, 0(a1)     # almacenar posx en la variable 'posx'
# Asignar direcci�n de entrada
addi t0, t0, 1   # avanzar el puntero t0 en 1 posici�n
obtenerChar(t0)  # obtener el car�cter de direcci�n de entrada
mv a6,t4         # mover el car�cter a a6
la a1, dirent
sb a6, 0(a1)     # almacenar la direcci�n de entrada en 'dirent'
la a2, dir
sb a6, 0(a2)     # tambi�n almacenar en 'dir' (direcci�n actual del robot)
# Asignar posici�n de salida
addi t0, t0, 2   # avanzar el puntero t0 en 2 posiciones
reconNumber()    # llamar a reconNumber para obtener la posici�n de salida
la a1, possal
sb a6, 0(a1)     # almacenar el valor en la variable 'possal'
# Asignar direcci�n de salida
addi t0, t0, 1   # avanzar el puntero t0 en 1 posici�n
obtenerChar(t0)  # obtener el car�cter de direcci�n de salida
mv a6,t4         # mover el car�cter a a6
la a1, dirsal
sb a6, 0(a1)     # almacenar la direcci�n de salida en 'dirsal'


#Llenar matriz
add a0, x0, x0
add a1, x0, x0
add a2, x0, x0
add a3, x0, x0
add a4, x0, x0
add a5, x0, x0
add a6, x0, x0
add a7, x0, x0
la a0, matriz #asignar puntero de matriz
la a3, filas #asignar puntero de filas
lb a4, 0(a3) #guardar su valor en a4
la a5, cols #asignar puntero de cols
lb a6, 0(a5) #guardar su valor en a6
add a3, x0, x0 #vaciar a3
add a5, x0, x0 #vaciar a5
loopcol:
loopfil:
mul a5,a4,a2 #guardar en a5 filas * numero de columna para el offset por columna actual
add a3,a0,a1 #a�adir al puntero de matriz el offset por la fila actual
add a3,a3,a5 #a�adir el offset por columna al puntero de matriz
sb a7,0(a3) #guardar el valor inicial 0 en la posicion de la matriz
addi a1,a1,1 #sumar en 1 la posicion de fila
bne a1,a4,loopfil #si no se ha llegado al tope de la fila repite
add a1,x0,x0 # si si, resetea la pos de fila
addi a2,a2,1 #aumenta en 1 las columnas
bne a2,a6,loopcol #si no se ha llegado al tope de columnas repite, si no se sale
#Inicializar matriz
add t4, x0, x0#limpiar registros
add a0, x0, x0
add a1, x0, x0
add a2, x0, x0
add a3, x0, x0
add a4, x0, x0
add a5, x0, x0
add a6, x0, x0
add a7, x0, x0
la a0,buffer #asignar puntero de buffer
la a1,matriz #asignar puntero de matriz
recon:
addi t0,t0,2 #avanzar puntero
li a2,'$'
add a4,a0,t0
lb a5,0(a4)
beq a5,a2,finrecon #si encuentra $ finaliza el reconocimiento de paredes
#si no ha llegado al final reconoce una pared
reconNumber() #Reconocer el numero que esta 
	li t5,1
	sub a6,a6,t5 #Restar uno al valor para convertirlo en pos. de matriz
	addi t0,t0,1 #avanzar puntero del buffer
	obtenerChar(t0) #Obtener valor de la pared
	li a2,'A'
	li a3,'B'
	li a4,'C'
	li a5,'D'
	beq t4,a2,sumar1 #si encuentra una A, suma a la casilla el valor de 1
	beq t4,a3 sumar2 #si encuentra una B, suma a la casilla el valor de 2
	beq t4,a4 sumar4 #si encuentra una C, suma a la casilla el valor de 4
	beq t4,a5 sumar8 #si encuentra una D, suma a la casilla el valor de 8
	j errorpared
sumar1:
	li t5,1 #Asigna valor 1
	j sumar
sumar2:
	li t5,2 #Asigna valor 2
	j sumar
sumar4:
	li t5,4 #Asigna valor 4
	j sumar
sumar8:
	li t5,8 #Asigna valor 8
	j sumar
errorpared:
	#El valor de la pared es erroneo, error
	j salir
sumar:
	add a2,x0,x0 #vacia a2
	add a6,a6,a1 #obtiene la direccion de la casilla exacta
	lb a2,0(a6) #se carga el valor de la casilla en a2
	add a2,a2,t5 #suma a la casilla el valor de la pared
	sb a2,0(a6) #inserta el nuevo valor a la casilla
salir:
j recon #regresa al ciclo
finrecon:
#Comenzar Recorrido
add t0, x0, x0#limpiar registros
add t1, x0, x0
add t2, x0, x0
add t3, x0, x0
add t4, x0, x0
add t5, x0, x0
add t6, x0, x0
add a0, x0, x0
add a1, x0, x0
add a2, x0, x0
add a3, x0, x0
add a4, x0, x0
add a5, x0, x0
add a6, x0, x0
add a7, x0, x0
la a0,matriz #carga el inicio de la matriz
la a1,buffer #carga la ubicacion del buffer para apuntar los pasos
li a2,0 #valor de la posicon donde se sobre escribe el buffer
la a7,posx #carga la ubicacion de la posicion en x del robot
lb a3,0(a7) #guarda su valor en a3 para su uso
la a7,posy #carga la ubicacion de la posicion en x del robot
lb a4,0(a7) #guarda su valor en a4 para su uso
la a7,dir #carga la ubicacion de la direccion del robot
lb a5,0(a7) #guarda su valor en a5 para su uso
la a7,cols #carga la ubicacion de la cant de columnas
lb a6,0(a7) #guarda su valor en a6 para su uso
la t0,filas #carga la ubicacion de la cant de filas
lb a7, 0(t0) #guarda su valor en a7 pasa su uso

buscar:
	girarDerecha() #gira a la derecha
	hayMuro() #verificar si hay muro
	li t1,1
	beq t1,t0,avan #si no hay muro avanza
	girarIzquierda() #si hay gira a la izquierda
	hayMuro() #verificar si hay muro
	li t1,1
	beq t1,t0,avan #si no hay muro avanza
	girarIzquierda() #si hay gira a la izquierda
	hayMuro() #verificar si hay muro
	li t1,1
	beq t1,t0,avan #si no hay muro avanza
	girarIzquierda() #si hay gira a la izquierda
	hayMuro() #verificar si hay muro
	li t1,1
	beq t1,t0,avan #si no hay muro avanza
	#si t0 es 1, no se puede avanzar
	add t0, x0, x0 #vaciar registros
	add t1, x0, x0
	add t2, x0, x0
	add t3, x0, x0
	add t4, x0, x0
	add t5, x0, x0
	add t6, x0, x0
	la t1,nosolu #prepara el puntero de la cadena de perder
	add t2,a1,a2 #cargar la direccion del buffer
	li t4,'$'
printSol:
	lb t3,0(t1) #carga el caracter de la cadena de ganar
	beq t4,t3,escribir #si en la cadena no aparece $ no ha terminado
	sb t3,0(t2) #guarda el caracter cargado en el buffer
	addi t1,t1,1 #aumenta en 1 el puntero de la cadena
	addi t2,t2,1 #aumenta en 1 el puntero del buffer
	addi a2,a2,1 #aumenta en 1 la posicion del buffer
	j printSol #repite
avan:
	avanzar()
	beqz t0,buscar #si t0 es 0 es porque no ha terminado y debe seguir
	#si t0 es 1, se termino la busqueda
escribir:
mv s1,a2
add t0, x0, x0#limpiar registros
add t1, x0, x0
add t2, x0, x0
add t3, x0, x0
add t4, x0, x0
add t5, x0, x0
add t6, x0, x0
add a0, x0, x0
add a1, x0, x0
add a2, x0, x0
add a3, x0, x0
add a4, x0, x0
add a5, x0, x0
add a6, x0, x0
add a7, x0, x0

la   s0, buffer

  la   a0, asol      # param nombre de archivo
  li   a1, 1        # param 0 leer, param 1 escribir
  li   a7, 1024     # abrir archivo
  ecall

  bltz a0, errorlectura # Salto si a0 es menor a 0, es decir si no existe
  mv   s6, a0        # sguardar info del archivo

cicloEscritura:
  mv   a0, s6       # descripcion del archivo 
  mv   a1, s0       # direccion de buffer
  mv   a2, s1       # cantidad de caracteres a leer
  li   a7, 64       # parametro para escritura archivo
  ecall          
  
  mv   a0, s6       # informacion del archivo / descriptor
  li   a7, 57       # parametro para cerrar archivo
  ecall             # Cerrar el archivo   
 
 dump_buffer:
    la a0, buffer    # Cargar la direcci�n del buffer en a0
    li a7, 4         # Syscall de impresi�n de cadena en RARS
    ecall            # Llamada para imprimir el contenido completo del buffer
    
finalizar:
  li   a7, 10
  ecall

errorlectura:
  la   a0, error
  li   a7, 4
  ecall

