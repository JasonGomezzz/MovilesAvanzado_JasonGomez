# Pruebas del Laboratorio 04

## Entorno de verificación

- Fecha: 15 de septiembre de 2026.
- Lenguaje: Swift.
- Archivo ejecutado: `Lab04-POO.playground/Contents.swift`.
- Rama principal de las pruebas: `manual`.

Comando utilizado:

```bash
swiftc Lab04-POO.playground/Contents.swift -o /tmp/lab04
/tmp/lab04
```

## Resultado de compilación

El archivo compiló sin errores. La ejecución terminó normalmente y no se
produjeron cierres inesperados.

## Prueba 1 Cotizaciones oficiales

Se ejecutaron la refrigeradora de S/ 2000 y la licuadora de S/ 250 en Lima,
Provincia y Outlet.

Resultados comprobados:

- Lima y refrigeradora: S/ 1800 de precio, S/ 0 de envío y S/ 1800 total.
- Provincia y refrigeradora: S/ 1900 de precio, S/ 152 de envío y S/ 2052 total.
- Outlet y refrigeradora: S/ 1500 de precio, S/ 0 de envío y S/ 1500 total.
- Lima y licuadora: S/ 225 de precio, S/ 30 de envío y S/ 255 total.
- Provincia y licuadora: S/ 237.50 de precio, S/ 50 de envío y S/ 287.50 total.
- Outlet y licuadora: S/ 187.50 de precio, S/ 0 de envío y S/ 187.50 total.

Resultado: correcto.

## Prueba 2 Extensibilidad de las sucursales

Se agregó `SucursalOnline` al arreglo ampliado y se reutilizó el mismo recorrido
polimórfico.

Resultados comprobados:

- El arreglo ampliado contiene cuatro sucursales.
- Online conserva el descuento base de 5 %.
- Online cobra S/ 15 de envío.
- La refrigeradora obtiene un total online de S/ 1915.

Resultado: correcto.

## Prueba 3 Correcciones de herencia

Se instanciaron `SucursalMall` y `SucursalExpress` después de aplicar las dos
correcciones solicitadas.

Resultados comprobados:

- `SucursalMall.descuento()` devuelve `0.12` mediante `override`.
- `SucursalExpress` conserva nombre y ciudad mediante `super.init`.
- El radio de la sucursal Express es 8 km.

Resultado: correcto.

## Prueba 4 Predicciones

Una variable declarada como `Sucursal` almacenó una instancia de
`SucursalLima`.

Resultados comprobados:

- `misteriosa.descuento()` imprime `0.1`.
- El monto después del descuento es S/ 1800.
- `misteriosa.costoEnvio(monto:)` imprime `0.0`.

Resultado: correcto.

## Prueba 5 Biblioteca

Se agregaron tres libros y se ejecutó la secuencia completa del enunciado.

Resultados comprobados:

- Se aprobó el primer préstamo de `La ciudad y los perros`.
- Se rechazó el segundo préstamo del mismo libro.
- Se registró su devolución.
- Se prestó `El Quijote`.
- Se informó que `El Principito` no existe.
- El inventario terminó con dos libros disponibles y `El Quijote` prestado.

Resultado: correcto.

## Prueba 6 Matrícula de cursos

Se ejecutó el ejemplo de Juan León con cuatro unidades de cursos y condición de
alumno Tecsup.

Resultados comprobados:

- Subtotal: S/ 2250.00.
- IGV de 18 %: S/ 405.00.
- Total con IGV: S/ 2655.00.
- Descuento de 10 %: S/ 265.50.
- Descuento Tecsup: S/ 400.00.
- Total final: S/ 1989.50.

Resultado: correcto.

## Prueba 7 Clientes

Se almacenaron `ClienteNatural` y `ClienteJuridico` en un arreglo `[Cliente]` y
se ejecutó `mostrarDatos()` en un solo recorrido.

Resultados comprobados:

- El cliente natural muestra nombre, DNI y los datos heredados de la cuenta.
- El cliente jurídico muestra razón social, RUC, representante y los datos
  heredados de la cuenta.
- Los montos mínimos son S/ 500.00 y S/ 3000.00.

Resultado: correcto.

## Prueba 8 Comparación de las bibliotecas

Se compiló el Caso 2B de la rama `ai-assisted` y se comparó su salida con el
bloque correspondiente del Caso 2A.

Resultado: ambas salidas son idénticas.

## Resumen

Se completaron ocho grupos de pruebas. Todos finalizaron correctamente y no se
registraron pruebas fallidas.
