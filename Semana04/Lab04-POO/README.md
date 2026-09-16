# Laboratorio 04 Programación Orientada a Objetos en Swift

## Objetivo

Aplicar estructuras, clases, herencia, sobrescritura de métodos, enums, arrays y
polimorfismo en un Playground de Swift. El laboratorio desarrolla el Caso 1.5,
el Caso 2A y las dos actividades propuestas que aparecen en la guía entregada.

## Contenido de la rama manual

El archivo principal se encuentra en
`Lab04-POO.playground/Contents.swift` y contiene los siguientes bloques:

1. Cadena de sucursales y cotización de electrodomésticos.
2. Corrección de errores de herencia e inicialización.
3. Predicciones sobre despacho dinámico de métodos.
4. Biblioteca con préstamos, devoluciones e inventario.
5. Matrícula de cursos libres con IGV y descuentos.
6. Clientes naturales y jurídicos mediante herencia.

## Caso 1.5 Cadena de sucursales

`Electrodomestico` es un `struct` porque representa los datos de un producto.
`Sucursal` es una clase base que implementa una sola vez el flujo
`cotizar(item:)`. Este método obtiene el descuento, calcula el precio reducido,
consulta el costo de envío y muestra el total.

Las clases `SucursalLima`, `SucursalProvincia`, `SucursalOutlet` y
`SucursalOnline` sobrescriben únicamente las reglas que necesitan cambiar. Las
instancias se almacenan como `[Sucursal]`, por lo que un mismo recorrido ejecuta
el método adecuado según la clase real de cada objeto.

Las reglas implementadas son:

- Lima aplica 10 % de descuento y envío gratis desde S/ 1500.
- Provincia conserva el descuento base de 5 % y cobra 8 % de envío, con un
  mínimo de S/ 50.
- Outlet aplica 25 % de descuento y no cobra envío.
- Online conserva el descuento base de 5 % y cobra S/ 15 de envío.

## Correcciones y predicciones

`SucursalMall` necesita `override` porque reemplaza un método heredado.
`SucursalExpress` debe llamar a `super.init(nombre:ciudad:)` después de
inicializar `radioKm`, porque la clase base es responsable de `nombre` y
`ciudad`.

Aunque `misteriosa` está declarada como `Sucursal`, contiene una instancia de
`SucursalLima`. Por despacho dinámico, `descuento()` devuelve `0.1`. El monto
queda en S/ 1800 y `costoEnvio(monto:)` devuelve `0.0`.

## Caso 2A Biblioteca

`Libro` es un `struct` porque representa un valor. `Biblioteca` es una clase
porque mantiene una colección compartida cuyo estado cambia cuando se presta o
devuelve un libro.

La búsqueda recorre `libros` por índice. Esto permite modificar directamente
`libros[i].estado`. El ejercicio utiliza solamente contenidos vistos hasta esta
semana y muestra los estados mediante `switch`.

## Actividad propuesta 01

`MatriculaCursos` almacena varios detalles de matrícula y calcula:

- subtotal de los cursos;
- IGV de 18 %;
- descuento de 10 % cuando se compran tres o más cursos;
- descuento adicional de S/ 400 cuando además se trata de un alumno Tecsup.

Con los datos de la guía, el resultado final es S/ 1989.50.

La implementación autónoma, sus 12 requerimientos funcionales y la forma de
ejecutarla se encuentran en [`Actividad01/README.md`](Actividad01/README.md).

## Actividad propuesta 02

`Cliente` reúne los datos comunes de una cuenta. `ClienteNatural` agrega nombre
y DNI, mientras que `ClienteJuridico` agrega razón social, RUC y representante
legal. Ambos sobrescriben `mostrarDatos()` y se recorren mediante un arreglo
`[Cliente]`.

La implementación autónoma, sus 12 requerimientos funcionales y la forma de
ejecutarla se encuentran en [`Actividad02/README.md`](Actividad02/README.md).

## Ramas de la entrega

- `manual`: contiene el Caso 1.5, el Caso 2A y las actividades propuestas.
- `ai-assisted`: contiene únicamente el Caso 2B comentado línea por línea y el
  archivo `PROMPTS.md`.

## Ejecución en Xcode

Desde Terminal:

```bash
cd "/Users/jason/Dev/MovilesAvanzado_JasonGomez"
git switch manual
open -a Xcode "Semana04/Lab04-POO/Lab04-POO.playground"
```

Dentro de Xcode se ejecuta el Playground con el botón de reproducción. La salida
aparece en la consola inferior.

También puede comprobarse desde Terminal:

```bash
swift "Semana04/Lab04-POO/Lab04-POO.playground/Contents.swift"
```

Las actividades propuestas también pueden ejecutarse por separado:

```bash
swift "Semana04/Lab04-POO/Actividad01/Actividad01.swift"
swift "Semana04/Lab04-POO/Actividad02/Actividad02.swift"
```

## Documentación disponible

- `Actividad01/README.md`: requerimientos funcionales de la matrícula de
  cursos, datos utilizados, resultado y ejecución con `nano` y `swift`.
- `Actividad02/README.md`: requerimientos funcionales de los clientes,
  estructura de clases, datos utilizados y ejecución con `nano` y `swift`.
- `PRUEBAS.md`: resultados verificados del laboratorio completo.
