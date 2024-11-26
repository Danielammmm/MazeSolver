# MazeSolver
# **Juego de Laberinto en RISC-V**

## **Descripción**
Este proyecto implementa un juego en lenguaje ensamblador RISC-V donde un robot debe navegar por un laberinto siguiendo una estrategia de "seguir la pared". El objetivo es encontrar la salida del laberinto o determinar si esta es inaccesible. Se utilizan conceptos avanzados de control de memoria y manejo de registros para desarrollar la lógica del juego.

## **Características principales**
- **Entrada del Laberinto:**
  - Lectura desde un archivo `.txt` que define las dimensiones, posición inicial, salida, y configuración del laberinto.
- **Estrategia de Navegación:**
  - El robot sigue un algoritmo de "seguir la pared", garantizando que explore todas las posibilidades hasta encontrar la salida o determinar que no hay solución.
- **Salida del Laberinto:**
  - Generación de un archivo de salida `.txt` con el resultado del recorrido:
    - "Salida exitosa" si el robot alcanza la salida.
    - "Salida inaccesible" si no encuentra una solución.

## **Requisitos**
- **Entorno:** Simulador RISC-V compatible (por ejemplo, RARS).
- **Archivos:**
  - Archivo de entrada: Definición del laberinto.
  - Archivo de salida: Registro del resultado y movimientos realizados.

## **Formato del Archivo de Entrada**
El archivo debe tener el siguiente formato:
1. **Dimensiones del Laberinto:** Dos enteros que indican filas y columnas (máximo 10x10).
2. **Posición de Entrada:** Número de celda seguido de la dirección inicial (`A`, `B`, `C`, `D`).
3. **Posición de Salida:** Número de celda seguido de la dirección.
4. **Paredes:** Número de celda seguido de las paredes abiertas (`A`, `B`, `C`, `D`).
5. **Fin de la Descripción:** `$` al final del archivo.

Ejemplo:
10 10 01A 100D 02A 03B 04C 05D $


## **Instrucciones de Uso**
1. **Configuración Inicial:**
   - Modifica las rutas de archivo en las primeras líneas del código:
     ```assembly
     fin:   .string "C:\\ruta\\entrada.txt"
     asol:  .string "C:\\ruta\\salida.txt"
     ```
2. **Compilación y Ejecución:**
   - Abre el código en un simulador como RARS.
   - Compila el programa y ejecuta, asegurándote de que el archivo de entrada esté en la ruta especificada.

3. **Salida del Programa:**
   - El programa genera un archivo `.txt` con:
     - Secuencia de movimientos realizados (celdas y direcciones).
     - Resultado final: "Salida exitosa" o "Salida inaccesible".

## **Estructura del Código**
### **Secciones principales:**
1. **Inicialización:**
   - Configuración de registros y variables para la lectura del archivo.
   - Carga de dimensiones, posiciones, y paredes del laberinto.
2. **Navegación:**
   - Implementación de macros como:
     - `girarDerecha` y `girarIzquierda` para cambiar la dirección del robot.
     - `hayMuro` para detectar obstáculos.
     - `avanzar` para mover el robot en la dirección actual.
3. **Condiciones de Parada:**
   - Éxito: Si el robot alcanza la salida.
   - Fracaso: Si el robot regresa a su punto de entrada o no puede avanzar.
4. **Escritura del Resultado:**
   - El programa almacena los movimientos realizados en el archivo de salida.

## **Ejemplo de Salida**
Archivo de salida generado:
01A 01D 02D 02C 02B 01A Salida exitosa


