# Prompts utilizados — Laboratorio 04

## Herramienta de IA utilizada

OpenAI Codex.

## Caso 2B — Biblioteca

### Prompt 1

> olvida la restriccion del o que yo hare manual hermano hazlo tu solo por hoy es que no dispongo de mucho tiempo porque tengo que ir a trabjar haermno culmina con todo lo manual con su respectivoc ommti absolutamtente todo lo del laboratorio porfavor

El enunciado, las firmas, las restricciones y la salida esperada se tomaron del documento
`GLAB-S04-JLEONS-2026-02-2.docx` que acompañó esta conversación.

### Respuesta de la IA

La IA creó el Caso 2B en un Playground independiente dentro de la rama
`ai-assisted`. Implementó `EstadoLibro`, `Libro` y `Biblioteca`, junto con las
funciones `agregar(libro:)`, `prestar(titulo:)`, `devolver(titulo:)` e
`inventario()`. También agregó la simulación solicitada y explicó cada línea.

### ¿Funcionó a la primera?

Sí en la lógica y en la salida. El programa compiló y reprodujo exactamente los
préstamos, errores, devolución e inventario esperados. Antes del commit se hizo
una revisión editorial para evitar incluso la mención de conceptos restringidos
en los comentarios.

### ¿Usó algo que no hemos visto en clase?

No. La solución final utiliza solamente `enum`, `struct`, `class`, arrays,
bucles, funciones, condicionales y `switch`. La búsqueda se realiza recorriendo
los índices del arreglo y el estado se modifica con `libros[i].estado`.

## Mi versión (Parte A) vs. la versión de la IA (Parte B)

### ¿Qué hizo distinto la IA respecto a mi solución?

Las dos versiones siguen la misma lógica porque deben respetar las mismas firmas
y restricciones. La diferencia visible es que la versión asistida explica cada
instrucción con comentarios, mientras que la versión manual se mantiene más
directa y compacta.

### ¿Hay alguna línea de la IA que no entiendo del todo? ¿Cuál?

No. La línea más importante es `libros[i].estado = .prestado`: modifica el
elemento que está guardado dentro del arreglo. Si se modificara una copia del
`struct Libro`, el cambio no quedaría registrado en la biblioteca.

### ¿Qué me pareció mejor de MI versión?

Es más breve, permite concentrarse rápidamente en las reglas de préstamo y fue
construida siguiendo el orden del ejercicio.

### ¿Qué me pareció mejor de la versión de la IA?

Las explicaciones línea por línea facilitan repasar por qué `Libro` es un tipo de
valor, por qué `Biblioteca` conserva el estado compartido y cómo funcionan las
validaciones sin emplear contenidos de semanas posteriores.

## Verificación realizada

- El Playground compila con `swiftc` sin errores.
- La salida de la Parte B es idéntica a la salida de la Parte A.
- No se usan búsquedas con closures, desempaquetado opcional, observadores de
  propiedades ni propiedades calculadas.
- El código y este registro se guardaron en commits separados.
