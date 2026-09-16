# Actividad 01 Matrícula de cursos libres

## Descripción

Esta actividad representa la matrícula de un estudiante en uno o varios cursos
libres de Tecsup. El programa calcula cantidades, subtotal, IGV, descuentos y el
importe final que debe pagar el estudiante.

El archivo ejecutable es `Actividad01.swift` y funciona de manera independiente
del Playground general del laboratorio.

## Requerimientos funcionales

1. RF01 Registrar el nombre y DNI del estudiante.
2. RF02 Identificar si el estudiante pertenece a Tecsup.
3. RF03 Registrar varios cursos dentro de una misma matrícula.
4. RF04 Registrar más de una unidad de un mismo curso.
5. RF05 Calcular el importe de cada curso multiplicando precio por cantidad.
6. RF06 Calcular la cantidad total de cursos matriculados.
7. RF07 Calcular el subtotal acumulado de todos los cursos.
8. RF08 Calcular el IGV del 18 % sobre el subtotal.
9. RF09 Calcular el total de la matrícula incluyendo el IGV.
10. RF10 Aplicar un descuento del 10 % cuando se compran tres o más cursos.
11. RF11 Aplicar un descuento adicional de S/ 400 cuando el estudiante es de
    Tecsup y compra tres o más cursos.
12. RF12 Mostrar un comprobante detallado con importes formateados a dos
    decimales y el total final.

## Cumplimiento de los requerimientos

- `AlumnoCursos` conserva la identificación y condición del estudiante.
- `CursoLibre` representa el nombre y precio de cada curso.
- `DetalleMatricula` relaciona un curso con su cantidad.
- `MatriculaCursos.agregar(curso:cantidad:)` incorpora varios detalles.
- `cantidadCursos()` acumula todas las unidades matriculadas.
- `subtotal()` suma los importes de los detalles.
- `mostrarComprobante()` calcula IGV, descuentos y total final.
- La simulación usa cuatro unidades y activa ambos descuentos solicitados.

## Datos utilizados

- Estudiante: Juan León.
- DNI: 78965412.
- Alumno Tecsup: sí.
- Swift Avanzado: una unidad de S/ 450.
- IA con Python: dos unidades de S/ 650.
- Diseño UX/UI: una unidad de S/ 500.

## Resultado esperado

```text
Cantidad de cursos: 4
Subtotal: S/ 2250.00
IGV (18%): S/ 405.00
Total con IGV: S/ 2655.00
Descuento por 3 o más cursos: S/ 265.50
Descuento alumno Tecsup: S/ 400.00
Total final: S/ 1989.50
```

## Abrir el código con nano

Desde Terminal:

```bash
cd "/Users/jason/Dev/MovilesAvanzado_JasonGomez/Semana04/Lab04-POO/Actividad01"
nano Actividad01.swift
```

Dentro de `nano` se puede recorrer todo el código con las flechas. Para salir
sin modificarlo se presiona `Control + X`.

## Ejecutar desde Terminal

```bash
cd "/Users/jason/Dev/MovilesAvanzado_JasonGomez/Semana04/Lab04-POO/Actividad01"
swift Actividad01.swift
```

El programa debe terminar mostrando `Total final: S/ 1989.50`.

## Estructuras y clases utilizadas

- `CursoLibre`: almacena la información de un curso.
- `DetalleMatricula`: almacena el curso y la cantidad adquirida.
- `AlumnoCursos`: almacena los datos del estudiante.
- `MatriculaCursos`: administra los cursos y realiza los cálculos.
