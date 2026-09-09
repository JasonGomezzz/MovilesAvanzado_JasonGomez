# Prompts utilizados — Laboratorio 03

## Datos generales

- Desarrollado por: Jason Gomez
- Herramienta de IA utilizada: ChatGPT
- Rama de trabajo: `ai-assisted`

## Ejercicio 6 — Gestión de notas

### Prompt CTRFE

**CONTEXTO:** Soy estudiante de Programación en Móviles Avanzado y estoy desarrollando el Laboratorio 03 en Swift Playground. Durante las primeras tres semanas hemos trabajado variables, conversiones, condicionales, `switch`, ciclos, arrays, diccionarios, sets y lectura de datos con `readLine()`.

**TAREA:** Crear un sistema interactivo que solicite una cantidad válida de alumnos, registre el nombre y tres notas de cada uno dentro de un diccionario `[String: [Double]]`, calcule el promedio por alumno, lo clasifique con `switch`, muestre el promedio general, la nota individual más alta, la nota individual más baja, el porcentaje de aprobados y ordene a los alumnos desde el promedio más alto al más bajo.

**RESTRICCIONES:** Utilizar solamente contenidos estudiados hasta la semana 3. No utilizar `struct`, `class` ni programación orientada a objetos. Validar que la cantidad de alumnos sea mayor que cero, que los nombres no estén vacíos ni repetidos y que las notas se encuentren entre 0 y 20. Considerar aprobado un promedio desde 13. Comentar cada línea de código con una explicación específica y usar el encabezado `// Desarrollado por: Jason Gomez`.

**FORMATO:** Entregar código Swift ejecutable en una página del Playground. Mostrar títulos para separar el registro, los resultados por alumno, las estadísticas generales y el orden por promedio. Presentar los promedios y porcentajes con dos decimales.

**EJEMPLO:** Con Ana y notas 18, 19 y 17, mostrar promedio `18.00` y clasificación `Excelente`. Con Marta y notas 10, 12 y 11, mostrar promedio `11.00` y clasificación `Desaprobado`.

### Revisión del resultado

El sistema fue probado con tres alumnos y calculó un promedio general de `14.67`, un porcentaje de aprobados de `66.67%`, una nota máxima de `19.00` y una nota mínima de `10.00`. También se comprobaron cantidades inválidas, nombres vacíos y notas fuera del rango permitido.

### Concepto reforzado

La ordenación de un diccionario produce un array de pares clave-valor. Esto permitió presentar un ranking sin modificar el diccionario original.

## Ejercicio 7 — Inventario con menú

### Prompt CTRFE

**CONTEXTO:** Soy estudiante de Programación en Móviles Avanzado y debo resolver el ejercicio 7 del Laboratorio 03 utilizando colecciones y estructuras de control básicas de Swift en Playground.

**TAREA:** Crear un inventario interactivo que solicite una cantidad de productos y registre nombre, precio y stock. Después del registro, mostrar un menú controlado con `while` que permita ver el inventario, buscar un producto, mostrar productos con stock menor que cinco, calcular el valor total del inventario y salir.

**RESTRICCIONES:** Utilizar arrays o diccionarios junto con `if`, `switch`, `for`, `while` y `readLine()`. No utilizar `struct`, `class` ni temas posteriores a la semana 3. Validar que la cantidad de productos sea positiva, que los nombres no estén vacíos ni repetidos, que los precios sean mayores que cero y que el stock sea un entero desde cero. Comentar cada línea con una explicación específica y usar el encabezado `// Desarrollado por: Jason Gomez`.

**FORMATO:** Entregar código Swift ejecutable en una página independiente del mismo Playground. El menú debe repetirse hasta seleccionar la opción 5. Los reportes deben mostrarse con títulos, productos ordenados alfabéticamente y valores monetarios con dos decimales.

**EJEMPLO:** Para una Laptop de precio `3500` con stock `2`, un Mouse de precio `45.50` con stock `10` y un Teclado de precio `120` con stock `4`, mostrar Laptop y Teclado como productos con stock bajo y calcular un valor total de `S/. 7935.00`.

### Revisión del resultado

Se ejecutaron las cinco opciones del menú. La búsqueda encontró `Mouse` aun cuando se escribió `mouse`, informó correctamente un producto inexistente, detectó los productos con menos de cinco unidades y rechazó cantidades, nombres, precios, stocks y opciones inválidas.

### Concepto reforzado

El ciclo `while` mantiene activo el menú y el `switch` dirige cada opción. Los diccionarios de precios y stock comparten el nombre del producto como clave para relacionar ambos datos.
